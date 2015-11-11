
%MACRO polymed_egb(nir=, annee=, tab_atc = 0, lib_des = work) ;

%LET prefix = x&sysuserid ;

%MACRO join_nir(t1, t2) ;
/* jointure par le NIR */
        &t1..ben_nir_idt = &t2..ben_nir_idt
%MEND ;

%MACRO join_egb(t1, t2) ;
/* jointure par clef technique */
        &t1..cle_tec_jnt     = &t2..cle_tec_jnt
%MEND ;

PROC SQL ;
    DROP TABLE spduser.&prefix.ref_pha ;
    CREATE TABLE spduser.&prefix.ref_pha AS
    SELECT pha_prs_ide, cod_ucd_chr, nbr_moi, atc
    FROM v_ref_pha_tmp
    WHERE  ;
QUIT ;

%LET annee_plus = %EVAL(&annee + 1) ;

/* limites des dates de flux */
%LET dtd_flx_deb = %UNQUOTE(%STR(%'01FEB&annee%'d)) ;
%LET dtd_flx_fin = %UNQUOTE(%STR(%'01JUL&annee_plus%'d)) ;

/* limites des dates d'éxécution */
%LET dtd_exe_deb = %UNQUOTE(%STR(%'01JAN&annee%'d)) ;
%LET dtd_exe_fin = %UNQUOTE(%STR(%'31DEC&annee%'d)) ;

/*
extraction des prestation pharmacie ou ucd
pour la population d'intérêt
avec une ligne par individu, classe atc par jour

et également extraction du nombre de trimestre
où il existe au moins une prestation pharmacie ou ucd
par individu
*/

PROC SQL INOBS = MAX _method ;
    DROP TABLE spduser.&prefix.ext_polymed_&annee ;

    CREATE TABLE spduser.&prefix.ext_polymed_&annee AS
    SELECT  ANO.ben_nir_idt, 
            REF_PHA.atc,

            ES_PRS_F.exe_soi_dtd,

	    %trimestre(&annee, ES_PRS_F.exe_soi_amd) AS trm, /* le trimestre d'éxécution de la prestation */

            MAX(REF_PHA.nbr_moi) AS nbr_moi /* si 2 médicaments de la même classe ATC sont délivrés le même jour,
                                                on prend le plus grand conditionnement */
    FROM        spduser.&nir         ANO
    INNER JOIN  spdebs.ES_PRS_F      ES_PRS_F
        ON  %join_nir(ES_PRS_F, ANO)

    LEFT JOIN   spdebs.ES_PHA_F      ES_PHA_F
        ON  %join_egb(ES_PRS_F, ES_PHA_F)

    LEFT JOIN   spdebs.ES_UCD_F      ES_UCD_F
        ON  %join_egb(ES_PRS_F, ES_UCD_F)

    LEFT JOIN   spduser.&prefix.ref_pha         REF_PHA
        ON  (ES_PHA_F.pha_prs_ide = REF_PHA.pha_prs_ide AND ES_PHA_F.pha_prs_ide IS NOT NULL)
        OR  (ES_UCD_F.ucd_ucd_cod = REF_PHA.cod_ucd_chr AND ES_UCD_F.ucd_ucd_cod IS NOT NULL)
			/* on fait la jointure du référentiel sur le code CIP ou UCD, selon le mode de délivrance */

    WHERE   ES_PRS_F.exe_soi_dtd BETWEEN &dtd_exe_deb AND &dtd_exe_fin
            /* restriction de date de délivrance sur l'année */

            AND ES_PRS_F.prs_nat_ref IN &prs_pha
            /* sélection uniquement des prestations pharma ou ucd */

            AND ES_PRS_F.dpn_qlf <> 71
            AND ES_PRS_F.prs_pai_mnt > 0
            /* exclusion des régularisations et des lignes pour info */

            AND (ES_UCD_F.flx_dis_dtd IS NULL OR ES_UCD_F.ucd_top_ucd = 0)
            /* exclusion des médicaments en sus du GHS */

    GROUP BY 1, 2, 3, 4
	;
QUIT ;

PROC SQL INOBS = MAX _method ;
    DROP TABLE spduser.&prefix.pop_inc_tmp ;
    CREATE TABLE spduser.&prefix.pop_inc_tmp AS
    SELECT ANO.ben_nir_idt,

           COUNT(DISTINCT %trimestre(&annee, ES_PRS_F.exe_soi_amd)) AS n_trm /* combien de trimestres où il y a des prestations, utilisé pour l'inclusion */

    FROM        spduser.&nir         ANO
    INNER JOIN  spdebs.ES_PRS_F      ES_PRS_F
        ON  %join_nir(ES_PRS_F, ANO)

    WHERE   ES_PRS_F.exe_soi_dtd BETWEEN &dtd_exe_deb AND &dtd_exe_fin
            /* restriction de date de délivrance sur l'année */

            AND ES_PRS_F.prs_nat_ref IN &prs_pha
            /* sélection uniquement des prestations pharma ou ucd */

            AND ES_PRS_F.dpn_qlf <> 71
            AND ES_PRS_F.prs_pai_mnt > 0
            /* exclusion des régularisations et des lignes pour info */

    GROUP BY ANO.ben_nir_idt
    ;
QUIT ;




PROC SQL _method ;
	DROP TABLE spduser.&prefix.atc_continu_&annee ;
    CREATE TABLE spduser.&prefix.atc_continu_&annee AS
    SELECT  MED.ben_nir_idt,
            MED.atc

        FROM        spduser.&prefix.ext_polymed_&annee    MED
        INNER JOIN  spduser.&prefix.pop_inc_tmp           INC
            ON  %join_nir(MED, INC)

        WHERE   %atc_ok(atc)
                AND INC.n_trm = 4

        GROUP BY MED.ben_nir_idt,
                 MED.atc
        HAVING SUM(nbr_moi) >= 3 ;
QUIT ;


PROC SQL _method ;
    DROP TABLE spduser.&prefix.ind_continu_&annee._tmp ;

    CREATE TABLE spduser.&prefix.ind_continu_&annee._tmp AS
    SELECT  POP.ben_nir_idt,
            %l2n((POP.n_trm = 4)) AS top_inc,
            COUNT(DISTINCT ATC.atc) AS indicateur_continu
        FROM        spduser.&prefix.pop_inc_tmp         POP
        LEFT JOIN   spduser.&prefix.atc_continu_&annee  ATC
            ON %join_nir(POP, ATC)

        GROUP BY 1, 2
	;

    CREATE TABLE &lib_des..indicateur_continu_&annee AS
    SELECT 	ben_nir_idt,
            CASE
                WHEN top_inc = 1
                THEN indicateur_continu
                ELSE .
            END AS indicateur_continu
            FROM spduser.&prefix.ind_continu_&annee._tmp ;

    DROP TABLE spduser.&prefix.ind_continu_&annee._tmp ;
QUIT ;



PROC SQL ;
    DROP TABLE spduser.&prefix.atc_cumulatif_&annee._tmp ;

    CREATE TABLE spduser.&prefix.atc_cumulatif_&annee._tmp AS
    SELECT DISTINCT
			MED.ben_nir_idt,
            MED.trm,
            MED.atc

        FROM        spduser.&prefix.ext_polymed_&annee    MED
        INNER JOIN  spduser.&prefix.pop_inc_tmp           INC
            ON  %join_nir(MED, INC)

        WHERE   %atc_ok(atc)
                AND INC.n_trm = 4
	;
QUIT ;



PROC SQL ;
    DROP TABLE spduser.&prefix.ind_cumulatif_&annee._tmp ;

    CREATE TABLE spduser.&prefix.ind_cumulatif_&annee._tmp AS
    SELECT  POP.ben_nir_idt,
            %l2n((POP.n_trm = 4)) AS top_inc,
            ROUND(SUM(COALESCE(ATC.n_atc, 0)) / 4) AS indicateur_cumulatif
        FROM        spduser.&prefix.pop_inc_tmp     POP
        LEFT JOIN   (
            SELECT ben_nir_idt, trm, COUNT(*) AS n_atc
            FROM spduser.&prefix.atc_cumulatif_&annee._tmp
            GROUP BY ben_nir_idt, trm
        )   ATC
            ON %join_nir(POP, ATC)
        GROUP BY 1, 2
	;

    CREATE TABLE &lib_des..indicateur_cumulatif_&annee AS
    SELECT 	ben_nir_idt,
            CASE
                WHEN top_inc = 1
                THEN indicateur_cumulatif
                ELSE .
            END AS indicateur_cumulatif
            FROM spduser.&prefix.ind_cumulatif_&annee._tmp
	;

    DROP TABLE spduser.&prefix.ind_cumulatif_&annee._tmp ;
QUIT ;

%IF &tab_atc = 1 %THEN %DO ;
PROC SQL ;

    CREATE TABLE &lib_des..atc_cumulatif_&annee AS
    SELECT DISTINCT ben_nir_idt, atc
        FROM spduser.&prefix.atc_cumulatif_&annee._tmp
	;

    CREATE TABLE &lib_des..atc_continu_&annee AS
    SELECT * 
    	FROM spduser.&prefix.atc_continu_&annee
    ;
QUIT ;
%END ;
PROC SQL ;
    DROP TABLE spduser.&prefix.atc_cumulatif_&annee._tmp ;
    DROP TABLE spduser.&prefix.atc_cumulatif_&annee ;
    DROP TABLE spduser.&prefix.atc_continu_&annee ;
    DROP TABLE spduser.&prefix.ext_polymed_&annee ;
    DROP TABLE spduser.&prefix.pop_inc_tmp ;
QUIT ;
%MEND ;
