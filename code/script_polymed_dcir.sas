




%MACRO polymed_dcir(nir=, annee=, tab_atc = 0, lib_des = work) ;

%MACRO join_nir(t1, t2) ;
/* jointure par le NIR */
        &t1..ben_nir_psa = &t2..ben_nir_psa
    AND &t1..ben_rng_gem = &t2..ben_rng_gem
%MEND ;

%MACRO join_dcir9(t1, t2) ;
/* jointure par clef technique */
        &t1..flx_dis_dtd     = &t2..flx_dis_dtd
    AND &t1..flx_trt_dtd     = &t2..flx_trt_dtd
    AND &t1..flx_emt_typ     = &t2..flx_emt_typ
    AND &t1..flx_emt_num     = &t2..flx_emt_num
    AND &t1..flx_emt_ord     = &t2..flx_emt_ord
    AND &t1..org_cle_num     = &t2..org_cle_num
    AND &t1..dct_ord_num     = &t2..dct_ord_num
    AND &t1..prs_ord_num     = &t2..prs_ord_num
    AND &t1..rem_typ_aff     = &t2..rem_typ_aff
%MEND ;

PROC SQL ;
    DROP TABLE orauser.ref_pha ;
    CREATE TABLE orauser.ref_pha AS
    SELECT pha_prs_ide, cod_ucd_chr, nbr_moi, atc
    FROM v_ref_pha_tmp
    ;
QUIT ;

%LET annee_plus = %EVAL(&annee + 1) ;

/* limites des dates de flux */
%LET dtd_flx_deb = %UNQUOTE(%STR(%'01FEB&annee%')) ;
%LET dtd_flx_fin = %UNQUOTE(%STR(%'01JUL&annee_plus%')) ;

/* limites des dates d'éxécution */
%LET dtd_exe_deb = %UNQUOTE(%STR(%'01JAN&annee%')) ;
%LET dtd_exe_fin = %UNQUOTE(%STR(%'31DEC&annee%')) ;

/*
extraction des prestation pharmacie ou ucd
pour la population d'intérêt
avec une ligne par individu, classe atc par jour

et également extraction du nombre de trimestre
où il existe au moins une prestation pharmacie ou ucd
par individu

les deux requêtes sont combinées en une par l'expression GROUPING SETS
top_inc est = 1 pour la requête concernant les critères d'inclusion
*/

PROC SQL ;
    DROP TABLE orauser.ext_polymed_&annee ;

    %connectora ;
    
    EXECUTE (
        CREATE TABLE ext_polymed_&annee AS
        SELECT  ANO.ben_nir_psa, ANO.ben_rng_gem,

                GROUPING(atc) AS top_inc, /* = 1 pour requête inclusion, = 0 pour requête médicaments */
                
                REF_PHA.atc,

                ER_PRS_F.exe_soi_dtd,
                %trimestre(&annee) AS trm, /* le trimestre d'éxécution de la prestation */

                MAX(REF_PHA.nbr_moi) AS nbr_moi, /* si 2 médicaments de la même classe ATC sont délivrés le même jour,
                                                    on prend le plus grand conditionnement */

                COUNT(DISTINCT %trimestre(&annee)) AS n_trm /* combien de trimestres où il y a des prestations, utilisé pour l'inclusion */

        FROM        &nir         ANO
        INNER JOIN  er_prs_f      ER_PRS_F
            ON  %join_nir(ER_PRS_F, ANO)

        LEFT JOIN   er_pha_f      ER_PHA_F
            ON  %join_dcir9(ER_PRS_F, ER_PHA_F)

        LEFT JOIN   er_ucd_f      ER_UCD_F
            ON  %join_dcir9(ER_PRS_F, ER_UCD_F)

        LEFT JOIN   ref_pha         REF_PHA
            ON  ER_PHA_F.pha_prs_ide = REF_PHA.pha_prs_ide
            OR  ER_UCD_F.ucd_ucd_cod = REF_PHA.cod_ucd_chr /* on fait la jointure du référentiel sur le code CIP ou UCD, selon le mode de délivrance */

        WHERE   ER_PRS_F.flx_dis_dtd BETWEEN TO_DATE(&dtd_flx_deb, 'DDMMYYYY') AND TO_DATE(&dtd_flx_fin, 'DDMMYYYY')
                AND (ER_PHA_F.flx_dis_dtd IS NULL OR ER_PHA_F.flx_dis_dtd BETWEEN TO_DATE(&dtd_flx_deb, 'DDMMYYYY') AND TO_DATE(&dtd_flx_fin, 'DDMMYYYY'))
                AND (ER_UCD_F.flx_dis_dtd IS NULL OR ER_UCD_F.flx_dis_dtd BETWEEN TO_DATE(&dtd_flx_deb, 'DDMMYYYY') AND TO_DATE(&dtd_flx_fin, 'DDMMYYYY'))
                /* restriction de date de flux */

                AND ER_PRS_F.exe_soi_dtd BETWEEN TO_DATE(&dtd_exe_deb, 'DDMMYYYY') AND TO_DATE(&dtd_exe_fin, 'DDMMYYYY')
                /* restriction de date de délivrance sur l'année */

                AND ER_PRS_F.prs_nat_ref IN &prs_pha
                /* sélection uniquement des prestations pharma ou ucd */

                AND ER_PRS_F.dpn_qlf <> 71
                AND ER_PRS_F.prs_pai_mnt > 0
                /* exclusion des régularisations et des lignes pour info */

                AND (ER_UCD_F.flx_dis_dtd IS NULL OR ER_UCD_F.ucd_top_ucd = 0)
                /* exclusion des médicaments en sus du GHS */

        GROUP BY ANO.ben_nir_psa, ANO.ben_rng_gem,
              GROUPING SETS((REF_PHA.atc, ER_PRS_F.exe_soi_dtd, %trimestre(&annee)), ())
              /* cette expression : groupe de base par ben_nir_psa ben_rng_gem
                                    et en plus groupe par atc, exe_soi_dtd, &trimestre dans un cas
                                    et par rien de plus dans l'autre cas (donc juste ben_nir_psa ben_rng_gem)
                                    tout ça en une seule requête */
    ) BY ORACLE ;
QUIT ;

PROC SQL ;
    %connectora ;

    DROP TABLE orauser.pop_inc_tmp ;

    EXECUTE (
        CREATE TABLE pop_inc_tmp AS
            SELECT ben_nir_psa, ben_rng_gem, n_trm
            FROM ext_polymed_&annee
            WHERE top_inc = 1
    ) BY ORACLE ;
QUIT ;

PROC SQL ;
    %connectora ;

    DROP TABLE orauser.atc_continu_&annee ;

    EXECUTE (
    CREATE TABLE atc_continu_&annee AS
    SELECT  MED.ben_nir_psa, MED.ben_rng_gem,
            MED.atc

        FROM        ext_polymed_&annee    MED
        INNER JOIN  pop_inc_tmp           INC
            ON  %join_nir(MED, INC)

        WHERE   top_inc <> 1
                AND %atc_ok(atc)
                AND INC.n_trm = 4

        GROUP BY MED.ben_nir_psa, MED.ben_rng_gem,
                 MED.atc
        HAVING SUM(nbr_moi) >= 3
    ) BY ORACLE ;

QUIT ;

PROC SQL ;
    %connectora ;

    DROP TABLE orauser.indicateur_continu_&annee._tmp ;

    EXECUTE (
    CREATE TABLE indicateur_continu_&annee._tmp AS
    SELECT  POP.ben_nir_psa, POP.ben_rng_gem,
            %l2n((POP.n_trm = 4)) AS top_inc,
            COUNT(DISTINCT ATC.atc) AS indicateur_continu
        FROM        pop_inc_tmp         POP
        LEFT JOIN   atc_continu_&annee  ATC
            ON %join_nir(POP, ATC)

        GROUP BY POP.ben_nir_psa, POP.ben_rng_gem, %l2n((POP.n_trm = 4))
    ) BY ORACLE ;

    CREATE TABLE &lib_des..indicateur_continu_&annee AS
    SELECT * FROM CONNECTION TO ORACLE (
        SELECT ben_nir_psa, ben_rng_gem,
                CASE
                    WHEN top_inc = 1
                    THEN indicateur_continu
                    ELSE NULL
                END AS indicateur_continu
            FROM indicateur_continu_&annee._tmp
    ) ;

    DROP TABLE orauser.indicateur_continu_&annee._tmp ;
QUIT ;

PROC SQL ;
    %connectora ;

    DROP TABLE orauser.atc_cumulatif_&annee._tmp ;

    EXECUTE (
    CREATE TABLE atc_cumulatif_&annee._tmp AS
    SELECT DISTINCT
            MED.ben_nir_psa, MED.ben_rng_gem,
            MED.trm,
            MED.atc

        FROM        ext_polymed_&annee    MED
        INNER JOIN  pop_inc_tmp           INC
            ON  %join_nir(MED, INC)

        WHERE   top_inc <> 1
                AND %atc_ok(atc)
                AND INC.n_trm = 4
    ) BY ORACLE ;
QUIT ;

PROC SQL ;
    %connectora ;

    DROP TABLE orauser.indicateur_cumulatif_&annee._tmp ;

    EXECUTE (
    CREATE TABLE indicateur_cumulatif_&annee._tmp AS
    SELECT  POP.ben_nir_psa, POP.ben_rng_gem,
            %l2n((POP.n_trm = 4)) AS top_inc,
            ROUND(SUM(COALESCE(ATC.n_atc, 0)) / 4) AS indicateur_cumulatif
        FROM        pop_inc_tmp     POP
        LEFT JOIN   (
            SELECT ben_nir_psa, ben_rng_gem, trm, COUNT(*) AS n_atc
            FROM atc_cumulatif_&annee._tmp
            GROUP BY ben_nir_psa, ben_rng_gem, trm
        )   ATC
            ON %join_nir(POP, ATC)
        GROUP BY POP.ben_nir_psa, POP.ben_rng_gem, %l2n((POP.n_trm = 4)) 
    ) BY ORACLE ;

    CREATE TABLE &lib_des..indicateur_cumulatif_&annee AS
    SELECT * FROM CONNECTION TO ORACLE (
        SELECT ben_nir_psa, ben_rng_gem,
                CASE
                    WHEN top_inc = 1
                    THEN indicateur_cumulatif
                    ELSE NULL
                END AS indicateur_cumulatif
            FROM indicateur_cumulatif_&annee._tmp
    ) ;

    DROP TABLE orauser.indicateur_cumulatif_&annee._tmp ;
QUIT ;

%IF &tab_atc = 1 %THEN %DO ;
PROC SQL ;

    %connectora ;

    CREATE TABLE &lib_des..atc_cumulatif_&annee AS
    SELECT * FROM CONNECTION TO ORACLE (
        SELECT DISTINCT ben_nir_psa, ben_rng_gem, atc
        FROM atc_cumulatif_&annee._tmp
    ) ;

    CREATE TABLE &lib_des..atc_continu_&annee AS
    SELECT * 
    FROM orauser.atc_continu_&annee
    ;
    
    DROP TABLE orauser.atc_cumulatif_&annee._tmp ;
    DROP TABLE orauser.atc_cumulatif_&annee ;
    DROP TABLE orauser.atc_continu_&annee ;
    DROP TABLE orauser.ext_polymed_&annee ;
    DROP TABLE orauser.pop_inc_tmp ;
QUIT ;
%END ;

%MEND ;
