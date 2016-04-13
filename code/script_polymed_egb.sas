
%LET prefix = x&sysuserid ;

%MACRO join_nir(t1, t2) ;
/* jointure par le NIR */
        &t1..ben_nir_idt = &t2..ben_nir_idt
%MEND ;

%MACRO join_egb(t1, t2) ;
/* jointure par clef technique */
        &t1..cle_tec_jnt     = &t2..cle_tec_jnt
    
%MEND ;


%MACRO trimestre(annee) ;
/* retourne le trimestre */
%LET m1 = %UNQUOTE(%STR(%'&annee.01%')) ;
%LET m2 = %UNQUOTE(%STR(%'&annee.02%')) ;
%LET m3 = %UNQUOTE(%STR(%'&annee.03%')) ;
%LET m4 = %UNQUOTE(%STR(%'&annee.04%')) ;
%LET m5 = %UNQUOTE(%STR(%'&annee.05%')) ;
%LET m6 = %UNQUOTE(%STR(%'&annee.06%')) ;
%LET m7 = %UNQUOTE(%STR(%'&annee.07%')) ;
%LET m8 = %UNQUOTE(%STR(%'&annee.08%')) ;
%LET m9 = %UNQUOTE(%STR(%'&annee.09%')) ;
%LET m10 = %UNQUOTE(%STR(%'&annee.10%')) ;
%LET m11 = %UNQUOTE(%STR(%'&annee.11%')) ;
%LET m12 = %UNQUOTE(%STR(%'&annee.12%')) ;

CASE 
       WHEN ES_PRS_F.exe_soi_amd IN (&m1, &m2, &m3) THEN '1'
       WHEN ES_PRS_F.exe_soi_amd IN (&m4, &m5, &m6) THEN '2'
       WHEN ES_PRS_F.exe_soi_amd IN (&m7, &m8, &m9) THEN '3'
       WHEN ES_PRS_F.exe_soi_amd IN (&m10, &m11, &m12) THEN '4'
       ELSE ES_PRS_F.exe_soi_amd
END 
%MEND ;

/* liste des codes prestation PHA ou UCD (generee empiriquement,
 c'est les lignes de PRS qui ont des correspondances dans ces tables) */

%LET prs_pha = (3311,3312,3313,3314,3315,3316,3328,3331,3332,3341,3356,4382,9566) ;

%MACRO atc_ok(atc) ;
/* garde les codes ATC qui nous intéressent */
(&atc IS NOT NULL
AND &atc NOT LIKE 'P03B%'
AND &atc NOT LIKE 'S01J%'
AND &atc NOT LIKE 'V03AB%'
AND &atc NOT LIKE 'V03AK%'
AND &atc NOT LIKE 'V03AN%'
AND &atc NOT LIKE 'W%'
AND &atc NOT LIKE 'B05%'
AND &atc NOT LIKE 'J06%'
AND &atc NOT LIKE 'J07%'
AND &atc NOT LIKE 'N01%'
AND &atc NOT LIKE 'D08%'
AND &atc NOT LIKE 'D09%'
AND &atc NOT LIKE 'V04%'
AND &atc NOT LIKE 'V07%'
AND &atc NOT LIKE 'V08%'
AND &atc NOT LIKE 'V09%'
AND &atc NOT LIKE 'V20%')
%MEND ;

%MACRO l2n(x) ;
/* transforme logique en numerique, indispensable pour ORACLE */
CASE WHEN (&x) THEN 1 ELSE 0 END
%MEND ;



DATA work.ref_aso ;
    LENGTH
        atc_ini          $ 7
        principe_actif   $ 23
        atc_cor          $ 7 ;
atc_ini = "J05AR09" ; principe_actif = "emtricitabine" ; atc_cor = "J05AF09" ; OUTPUT ; 
atc_ini = "J05AR09" ; principe_actif = "tenofovir" ; atc_cor = "J05AF07" ; OUTPUT ; 
atc_ini = "J05AR09" ; principe_actif = "cobicistat" ; atc_cor = "V03AX03" ; OUTPUT ; 
atc_ini = "J05AR09" ; principe_actif = "elvitegravir" ; atc_cor = "J05AX11" ; OUTPUT ; 
atc_ini = "J04AM05" ; principe_actif = "rifampicine" ; atc_cor = "J04AB02" ; OUTPUT ; 
atc_ini = "J04AM05" ; principe_actif = "isoniazide" ; atc_cor = "J04AC01" ; OUTPUT ; 
atc_ini = "J04AM05" ; principe_actif = "pyrazinamide" ; atc_cor = "J04AK01" ; OUTPUT ; 
atc_ini = "J05AR04" ; principe_actif = "zidovudine" ; atc_cor = "J05AF01" ; OUTPUT ; 
atc_ini = "J05AR04" ; principe_actif = "lamivudine" ; atc_cor = "J05AF05" ; OUTPUT ; 
atc_ini = "J05AR04" ; principe_actif = "abacavir" ; atc_cor = "J05AF06" ; OUTPUT ; 
atc_ini = "J05AR06" ; principe_actif = "emtricitabine" ; atc_cor = "J05AF09" ; OUTPUT ; 
atc_ini = "J05AR06" ; principe_actif = "tenofovir" ; atc_cor = "J05AF07" ; OUTPUT ; 
atc_ini = "J05AR06" ; principe_actif = "efavirenz" ; atc_cor = "J05AG03" ; OUTPUT ; 
atc_ini = "J05AR08" ; principe_actif = "emtricitabine" ; atc_cor = "J05AF09" ; OUTPUT ; 
atc_ini = "J05AR08" ; principe_actif = "tenofovir" ; atc_cor = "J05AF07" ; OUTPUT ; 
atc_ini = "J05AR08" ; principe_actif = "rilpivirine" ; atc_cor = "J05AG05" ; OUTPUT ; 
atc_ini = "N04BA03" ; principe_actif = "levodopa" ; atc_cor = "N04BA01" ; OUTPUT ; 
atc_ini = "N04BA03" ; principe_actif = "carbidopa" ; atc_cor = "N04BA03-X" ; OUTPUT ; 
atc_ini = "N04BA03" ; principe_actif = "entacapone" ; atc_cor = "N04BX02" ; OUTPUT ; 
atc_ini = "C02LA01" ; principe_actif = "bendroflumethiazide" ; atc_cor = "C03AA01" ; OUTPUT ; 
atc_ini = "C02LA01" ; principe_actif = "reserpine" ; atc_cor = "C02AA02" ; OUTPUT ; 
atc_ini = "C07BB07" ; principe_actif = "bisoprolol" ; atc_cor = "C07AB07" ; OUTPUT ; 
atc_ini = "C07BB07" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C07BB12" ; principe_actif = "nebivolol" ; atc_cor = "C07AB12" ; OUTPUT ; 
atc_ini = "C07BB12" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09XA52" ; principe_actif = "aliskiren" ; atc_cor = "C09XA02" ; OUTPUT ; 
atc_ini = "C09XA52" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C10BX03" ; principe_actif = "atorvastatine" ; atc_cor = "C10AA05" ; OUTPUT ; 
atc_ini = "C10BX03" ; principe_actif = "amlodipine" ; atc_cor = "C08CA01" ; OUTPUT ; 
atc_ini = "G04CA52" ; principe_actif = "tamsulosine" ; atc_cor = "G04CA02" ; OUTPUT ; 
atc_ini = "G04CA52" ; principe_actif = "dutasteride" ; atc_cor = "G04CB02" ; OUTPUT ; 
atc_ini = "H03AA03" ; principe_actif = "levothyroxine" ; atc_cor = "H03AA01" ; OUTPUT ; 
atc_ini = "H03AA03" ; principe_actif = "liothyronine" ; atc_cor = "H03AA02" ; OUTPUT ; 
atc_ini = "J04AM02" ; principe_actif = "rifampicine" ; atc_cor = "J04AB02" ; OUTPUT ; 
atc_ini = "J04AM02" ; principe_actif = "isoniazide" ; atc_cor = "J04AC01" ; OUTPUT ; 
atc_ini = "J05AR01" ; principe_actif = "zidovudine" ; atc_cor = "J05AF01" ; OUTPUT ; 
atc_ini = "J05AR01" ; principe_actif = "lamivudine" ; atc_cor = "J05AF05" ; OUTPUT ; 
atc_ini = "J05AR02" ; principe_actif = "lamivudine" ; atc_cor = "J05AF05" ; OUTPUT ; 
atc_ini = "J05AR02" ; principe_actif = "abacavir" ; atc_cor = "J05AF06" ; OUTPUT ; 
atc_ini = "J05AR03" ; principe_actif = "tenofovir" ; atc_cor = "J05AF07" ; OUTPUT ; 
atc_ini = "J05AR03" ; principe_actif = "emtricitabine" ; atc_cor = "J05AF09" ; OUTPUT ; 
atc_ini = "J05AR10" ; principe_actif = "lopinavir" ; atc_cor = "J05AR10-X" ; OUTPUT ; 
atc_ini = "J05AR10" ; principe_actif = "ritonavir" ; atc_cor = "J05AE03" ; OUTPUT ; 
atc_ini = "M01AB55" ; principe_actif = "diclofenac" ; atc_cor = "M01AB05" ; OUTPUT ; 
atc_ini = "M01AB55" ; principe_actif = "misoprostol" ; atc_cor = "A02BB01" ; OUTPUT ; 
atc_ini = "N02AA59" ; principe_actif = "paracetamol" ; atc_cor = "N02BE01" ; OUTPUT ; 
atc_ini = "N02AA59" ; principe_actif = "codéine" ; atc_cor = "R05DA04" ; OUTPUT ; 
atc_ini = "N02AX52" ; principe_actif = "tramadol" ; atc_cor = "N02AX02" ; OUTPUT ; 
atc_ini = "N02AX52" ; principe_actif = "paracetamol" ; atc_cor = "N02BE01" ; OUTPUT ; 
atc_ini = "N02CA52" ; principe_actif = "ergotamine" ; atc_cor = "N02CA02" ; OUTPUT ; 
atc_ini = "N02CA52" ; principe_actif = "cafeine" ; atc_cor = "N06BC01" ; OUTPUT ; 
atc_ini = "N07BC51" ; principe_actif = "buprenorphine" ; atc_cor = "N07BC01" ; OUTPUT ; 
atc_ini = "N07BC51" ; principe_actif = "naloxone" ; atc_cor = "V03AB15" ; OUTPUT ; 
atc_ini = "P01BD51" ; principe_actif = "sulfadoxine" ; atc_cor = "P01BD51-X" ; OUTPUT ; 
atc_ini = "P01BD51" ; principe_actif = "pyrimethamine" ; atc_cor = "P01BD01" ; OUTPUT ; 
atc_ini = "P01BF01" ; principe_actif = "artemeter" ; atc_cor = "P01BE02" ; OUTPUT ; 
atc_ini = "P01BF01" ; principe_actif = "lumefantrine" ; atc_cor = "P01BF01-X" ; OUTPUT ; 
atc_ini = "A10BD07" ; principe_actif = "metformine" ; atc_cor = "A10BA02" ; OUTPUT ; 
atc_ini = "A10BD07" ; principe_actif = "sitagliptine" ; atc_cor = "A10BH01" ; OUTPUT ; 
atc_ini = "A10BD08" ; principe_actif = "metformine" ; atc_cor = "A10BA02" ; OUTPUT ; 
atc_ini = "A10BD08" ; principe_actif = "vildagliptine" ; atc_cor = "A10BH02" ; OUTPUT ; 
atc_ini = "A10BD10" ; principe_actif = "metformine" ; atc_cor = "A10BA02" ; OUTPUT ; 
atc_ini = "A10BD10" ; principe_actif = "saxagliptine" ; atc_cor = "A10BH03" ; OUTPUT ; 
atc_ini = "A12AX" ; principe_actif = "calcium carbonate" ; atc_cor = "A12AA04" ; OUTPUT ; 
atc_ini = "A12AX" ; principe_actif = "vit D3 (colécalciferol)" ; atc_cor = "A11CC05" ; OUTPUT ; 
atc_ini = "A12CD51" ; principe_actif = "fluorure de sodium" ; atc_cor = "A12CD01" ; OUTPUT ; 
atc_ini = "A12CD51" ; principe_actif = "vit D3 (colécalciferol)" ; atc_cor = "A11CC05" ; OUTPUT ; 
atc_ini = "C07CA03" ; principe_actif = "pindolol" ; atc_cor = "C07AA03" ; OUTPUT ; 
atc_ini = "C07CA03" ; principe_actif = "clopamide" ; atc_cor = "C03BA03" ; OUTPUT ; 
atc_ini = "C09DA01" ; principe_actif = "losartan" ; atc_cor = "C09CA01" ; OUTPUT ; 
atc_ini = "C09DA01" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09DA03" ; principe_actif = "valsartan" ; atc_cor = "C09CA03" ; OUTPUT ; 
atc_ini = "C09DA03" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09DA04" ; principe_actif = "irbesartan" ; atc_cor = "C09CA04" ; OUTPUT ; 
atc_ini = "C09DA04" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09DA06" ; principe_actif = "candesartan" ; atc_cor = "C09CA06" ; OUTPUT ; 
atc_ini = "C09DA06" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09DA07" ; principe_actif = "telmisartan" ; atc_cor = "C09CA07" ; OUTPUT ; 
atc_ini = "C09DA07" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09DA08" ; principe_actif = "olmesartan" ; atc_cor = "C09CA08" ; OUTPUT ; 
atc_ini = "C09DA08" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09DB01" ; principe_actif = "valsartan" ; atc_cor = "C09CA03" ; OUTPUT ; 
atc_ini = "C09DB01" ; principe_actif = "amlodipine" ; atc_cor = "C08CA01" ; OUTPUT ; 
atc_ini = "C09DB02" ; principe_actif = "olmesartan" ; atc_cor = "C09CA08" ; OUTPUT ; 
atc_ini = "C09DB02" ; principe_actif = "amlodipine" ; atc_cor = "C08CA01" ; OUTPUT ; 
atc_ini = "C09DB04" ; principe_actif = "telmisartan" ; atc_cor = "C09CA07" ; OUTPUT ; 
atc_ini = "C09DB04" ; principe_actif = "amlodipine" ; atc_cor = "C08CA01" ; OUTPUT ; 
atc_ini = "C10BA02" ; principe_actif = "simvastatine" ; atc_cor = "C10AA01" ; OUTPUT ; 
atc_ini = "C10BA02" ; principe_actif = "ezetimibe" ; atc_cor = "C10AX09" ; OUTPUT ; 
atc_ini = "M05BB03" ; principe_actif = "acide alendronique" ; atc_cor = "M05BA04" ; OUTPUT ; 
atc_ini = "M05BB03" ; principe_actif = "vit D3 (colécalciferol)" ; atc_cor = "A11CC05" ; OUTPUT ; 
atc_ini = "M05BB04" ; principe_actif = "acide risedronique" ; atc_cor = "M05BA07" ; OUTPUT ; 
atc_ini = "M05BB04" ; principe_actif = "vit D3 (colécalciferol)" ; atc_cor = "A11CC05" ; OUTPUT ; 
atc_ini = "M05BB04" ; principe_actif = "calcium carbonate" ; atc_cor = "A12AA04" ; OUTPUT ; 
atc_ini = "R03AK03" ; principe_actif = "ipratropium" ; atc_cor = "R03BB01" ; OUTPUT ; 
atc_ini = "R03AK03" ; principe_actif = "fenoterol" ; atc_cor = "R03AC04" ; OUTPUT ; 
atc_ini = "R03AK06" ; principe_actif = "fluticasone" ; atc_cor = "R03BA05" ; OUTPUT ; 
atc_ini = "R03AK06" ; principe_actif = "salmeterol" ; atc_cor = "R03AC12" ; OUTPUT ; 
atc_ini = "C07DA06" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C07DA06" ; principe_actif = "amiloride" ; atc_cor = "C03DB01" ; OUTPUT ; 
atc_ini = "C07DA06" ; principe_actif = "timolol" ; atc_cor = "C07AA06" ; OUTPUT ; 
atc_ini = "C03EA04" ; principe_actif = "spironolactone" ; atc_cor = "C03DA01" ; OUTPUT ; 
atc_ini = "C03EA04" ; principe_actif = "altizide" ; atc_cor = "C03EA04-X" ; OUTPUT ; 
atc_ini = "C03EB01" ; principe_actif = "amiloride" ; atc_cor = "C03DB01" ; OUTPUT ; 
atc_ini = "C03EB01" ; principe_actif = "furosemide" ; atc_cor = "C03CA01" ; OUTPUT ; 
atc_ini = "C07FB02" ; principe_actif = "félodipine" ; atc_cor = "C08CA02" ; OUTPUT ; 
atc_ini = "C07FB02" ; principe_actif = "metoprolol" ; atc_cor = "C07AB02" ; OUTPUT ; 
atc_ini = "C07FB03" ; principe_actif = "nifedipine" ; atc_cor = "C08CA05" ; OUTPUT ; 
atc_ini = "C07FB03" ; principe_actif = "atenolol" ; atc_cor = "C07AB03" ; OUTPUT ; 
atc_ini = "C09BA01" ; principe_actif = "captopril" ; atc_cor = "C09AA01" ; OUTPUT ; 
atc_ini = "C09BA01" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09BA02" ; principe_actif = "enalapril" ; atc_cor = "C09AA02" ; OUTPUT ; 
atc_ini = "C09BA02" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09BA03" ; principe_actif = "lisinopril" ; atc_cor = "C09AA03" ; OUTPUT ; 
atc_ini = "C09BA03" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09BA04" ; principe_actif = "perindopril" ; atc_cor = "C09AA04" ; OUTPUT ; 
atc_ini = "C09BA04" ; principe_actif = "indapamide" ; atc_cor = "C03BA11" ; OUTPUT ; 
atc_ini = "C09BA05" ; principe_actif = "ramipril" ; atc_cor = "C09AA05" ; OUTPUT ; 
atc_ini = "C09BA05" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09BA06" ; principe_actif = "quinapril" ; atc_cor = "C09AA06" ; OUTPUT ; 
atc_ini = "C09BA06" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09BA07" ; principe_actif = "benazepril" ; atc_cor = "C09AA07" ; OUTPUT ; 
atc_ini = "C09BA07" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09BA09" ; principe_actif = "fosinopril" ; atc_cor = "C09AA09" ; OUTPUT ; 
atc_ini = "C09BA09" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09BA15" ; principe_actif = "zofenopril" ; atc_cor = "C09AA15" ; OUTPUT ; 
atc_ini = "C09BA15" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C09BB02" ; principe_actif = "enalapril" ; atc_cor = "C09AA02" ; OUTPUT ; 
atc_ini = "C09BB02" ; principe_actif = "lercanidipine" ; atc_cor = "C08CA13" ; OUTPUT ; 
atc_ini = "C09BB04" ; principe_actif = "perindopril" ; atc_cor = "C09AA04" ; OUTPUT ; 
atc_ini = "C09BB04" ; principe_actif = "amlodipine" ; atc_cor = "C08CA01" ; OUTPUT ; 
atc_ini = "C09BB10" ; principe_actif = "trandolapril" ; atc_cor = "C09AA10" ; OUTPUT ; 
atc_ini = "C09BB10" ; principe_actif = "verapamil" ; atc_cor = "C08DA01" ; OUTPUT ; 
atc_ini = "R03AK07" ; principe_actif = "formoterol" ; atc_cor = "R03AC13" ; OUTPUT ; 
atc_ini = "R03AK07" ; principe_actif = "budesonide" ; atc_cor = "R03BA02" ; OUTPUT ; 
atc_ini = "B01AC30" ; principe_actif = "aspirine" ; atc_cor = "B01AC06" ; OUTPUT ; 
atc_ini = "B01AC30" ; principe_actif = "clopidogrel" ; atc_cor = "B01AC04" ; OUTPUT ; 
atc_ini = "C03EA01" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
atc_ini = "C03EA01" ; principe_actif = "amiloride" ; atc_cor = "C03DB01" ; OUTPUT ; 
atc_ini = "P01BB51" ; principe_actif = "proguanil" ; atc_cor = "P01BB01" ; OUTPUT ; 
atc_ini = "P01BB51" ; principe_actif = "atovaquone" ; atc_cor = "P01AX06" ; OUTPUT ; 
atc_ini = "P01BB51" ; principe_actif = "chloroquine" ; atc_cor = "P01BA01" ; OUTPUT ; 
atc_ini = "N02BE71" ; principe_actif = "paracetamol" ; atc_cor = "N02BE01" ; OUTPUT ; 
atc_ini = "N02BE71" ; principe_actif = "cafeine" ; atc_cor = "N06BC01" ; OUTPUT ; 
atc_ini = "N02BE71" ; principe_actif = "" ; atc_cor = "9999999" ; OUTPUT ; 
atc_ini = "N04BA02" ; principe_actif = "levodopa" ; atc_cor = "N04BA01" ; OUTPUT ; 
atc_ini = "N04BA02" ; principe_actif = "carbidopa" ; atc_cor = "N04BA03-X" ; OUTPUT ; 
atc_ini = "A12CD51" ; principe_actif = "fluorure de sodium" ; atc_cor = "A12CD01" ; OUTPUT ; 
atc_ini = "A12CD51" ; principe_actif = "vit D3 (colécalciferol)" ; atc_cor = "A11CC05" ; OUTPUT ; 
atc_ini = "C07BA02" ; principe_actif = "oxprenolol" ; atc_cor = "C07AA02" ; OUTPUT ; 
atc_ini = "C07BA02" ; principe_actif = "chlortalidone" ; atc_cor = "C03BA04" ; OUTPUT ; 
atc_ini = "C07BB02" ; principe_actif = "metoprolol" ; atc_cor = "C07AB02" ; OUTPUT ; 
atc_ini = "C07BB02" ; principe_actif = "chlortalidone" ; atc_cor = "C03BA04" ; OUTPUT ; 
atc_ini = "C07BB03" ; principe_actif = "atenolol" ; atc_cor = "C07AB03" ; OUTPUT ; 
atc_ini = "C07BB03" ; principe_actif = "chlortalidone" ; atc_cor = "C03BA04" ; OUTPUT ; 
atc_ini = "C10BA05" ; principe_actif = "simvastatine" ; atc_cor = "C10AA01" ; OUTPUT ; 
atc_ini = "C10BA05" ; principe_actif = "ezetimibe" ; atc_cor = "C10AX09" ; OUTPUT ; 
atc_ini = "J01EB20" ; principe_actif = "sulfafurazole" ; atc_cor = "J01EB05" ; OUTPUT ; 
atc_ini = "J01EB20" ; principe_actif = "erythromycine" ; atc_cor = "J01FA01" ; OUTPUT ; 
atc_ini = "N02AC54" ; principe_actif = "dextropropoxyphene" ; atc_cor = "N02AC04" ; OUTPUT ; 
atc_ini = "N02AC54" ; principe_actif = "paracetamol" ; atc_cor = "N02BA01" ; OUTPUT ; 
atc_ini = "N02BA71" ; principe_actif = "metoclopramide" ; atc_cor = "A03FA01" ; OUTPUT ; 
atc_ini = "N02BA71" ; principe_actif = "acetylsalicylic acid" ; atc_cor = "N02BA01" ; OUTPUT ; 
atc_ini = "N02CA52" ; principe_actif = "cafeine" ; atc_cor = "N06BC01" ; OUTPUT ; 
atc_ini = "N02CA52" ; principe_actif = "ergotamine" ; atc_cor = "N02CA02" ; OUTPUT ; 
atc_ini = "P01BF05" ; principe_actif = "artenimol" ; atc_cor = "P01BE05" ; OUTPUT ; 
atc_ini = "P01BF05" ; principe_actif = "piperaquine" ; atc_cor = "P01BF05-X" ; OUTPUT ; 
atc_ini = "C10BX02" ; principe_actif = "pravastatine" ; atc_cor = "C10AA03" ; OUTPUT ; 
atc_ini = "C10BX02" ; principe_actif = "aspirine" ; atc_cor = "B01AC06" ; OUTPUT ; 
atc_ini = "J01EE01" ; principe_actif = "sulfamethoxazole" ; atc_cor = "J01EC01" ; OUTPUT ; 
atc_ini = "J01EE01" ; principe_actif = "trimetoprime" ; atc_cor = "J01EA01" ; OUTPUT ; 
atc_ini = "C03EA" ; principe_actif = "methychlothiazide" ; atc_cor = "C03AA08" ; OUTPUT ; 
atc_ini = "C03EA" ; principe_actif = "triamterene" ; atc_cor = "C03DB02" ; OUTPUT ; 
atc_ini = "J01RA04" ; principe_actif = "spiramycine" ; atc_cor = "J01FA02" ; OUTPUT ; 
atc_ini = "J01RA04" ; principe_actif = "metronidazole" ; atc_cor = "J01XD01" ; OUTPUT ; 
atc_ini = "C09DA04" ; principe_actif = "irbesartan" ; atc_cor = "C09CA04" ; OUTPUT ; 
atc_ini = "C09DA04" ; principe_actif = "hydrochlorothiazide" ; atc_cor = "C03AA03" ; OUTPUT ; 
RUN ;
DATA work.ref_3mo ;
    LENGTH
        pa               $ 47
        min                8
        top_3mois          8 ;
pa = "GLIMEPIRIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ROSIGLITAZONE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "GLIBENCLAMIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "GLICAZIDE" ; min = 180 ; top_3mois = 1 ; OUTPUT ; 
pa = "METFORMINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ACARBOSE" ; min = 270 ; top_3mois = 1 ; OUTPUT ; 
pa = "GLIPIZIDE" ; min = 100 ; top_3mois = 1 ; OUTPUT ; 
pa = "REPAGLINIDE" ; min = 270 ; top_3mois = 1 ; OUTPUT ; 
pa = "ACEBUTOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "QUINAPRIL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "NIFEDIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "METHYLDOPA" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "PRAZOSINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "OLMESARTAN" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "AMLODIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "IRBESARTAN" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "CANDESARTAN" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ATENOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "PROPRANOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "NITRENDIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "BISOPROLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "BENAZEPRIL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "LACIDIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CAPTOPRIL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CELIPROLOL" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "PERINDOPRIL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "LOSARTAN" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "FELODIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "INDAPAMIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "FOSINOPRIL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "RILMENIDINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ISRADIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "MANIDIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "VERAPAMIL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "BETAXOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "LERCANIDIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "METOPROLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "NIRCADIPINE" ; min = 180 ; top_3mois = 1 ; OUTPUT ; 
pa = "TELMISARTAN" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "DILTIAZEM" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "NEBIVOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "VALSARTAN" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "TRANDOLAPRIL" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "MOXONIDINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "SPIRONOLACTONE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "LISINOPRIL" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "RAMIPRIL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CICLETANINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "EPROSARTAN" ; min = 168 ; top_3mois = 1 ; OUTPUT ; 
pa = "LABETALOL" ; min = 180 ; top_3mois = 1 ; OUTPUT ; 
pa = "OXPRENOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "PINDOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ZOFENOPRIL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "BEZAFIBRATE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ROSUVASTATINE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "PRAVASTATINE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "FENOFIBRATE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "TIADENOL" ; min = 360 ; top_3mois = 1 ; OUTPUT ; 
pa = "FLUVASTATINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "SIMVASTATINE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "ATORVASTATINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ALENDRONIQUE ACIDE" ; min = 12 ; top_3mois = 1 ; OUTPUT ; 
pa = "IBANDRONIQUE ACIDE" ; min = 3 ; top_3mois = 1 ; OUTPUT ; 
pa = "RISEDRONIQUE ACIDE" ; min = 12 ; top_3mois = 1 ; OUTPUT ; 
pa = "RALOXIFENE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "QUINAPRIL + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ALTIZIDE + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "OLMESARTAN + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "PERINDOPRIL + INDAPAMIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "BENAZEPRIL + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CAPTOPRIL + HYDROCHLOROTHIAZIDE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "IRBESARTAN + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CANDESARTAN + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ENELAPRIL + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "VALSARTAN + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "VALSARTAN + AMLODIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "LOSARTAN + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "LISINOPRIL + HYDROCHLOROTHIAZIDE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "BISOPROLOL + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "METOPROLOL + FELODIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "METOPROLOL + CHLORTALIDONE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "TELMISARTAN + HYDROCHLOROTIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "AMILORIDE + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "TRANDOLAPRIL + VERAPAMIL" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "ATENOLOL + NIFEDIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ATENOLOL + CHLORTALIDONE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CLOPAMIDE + PINDOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ZOFENOPRIL + HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "RISEDRONIQUE ACIDE + CALCIUM + COLECALCIFEROL" ; min = 12 ; top_3mois = 1 ; OUTPUT ; 
pa = "ALENDRONIQUE ACIDE + COLECALCIFEROL" ; min = 12 ; top_3mois = 1 ; OUTPUT ; 
pa = "CALCIUM + COLECALCIFEROL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ATORVASTATINE + AMLODIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "PRAVASTATINE + ACETYLSALICYLIQUE ACIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "QUINAPRIL ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ALTIZIDE ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "OLMESARTAN ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "PERINDOPRIL ET INDAPAMIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "BENAZEPRIL ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CAPTOPRIL ET HYDROCHLOROTHIAZIDE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "IRBESARTAN ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CANDESARTAN ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ENELAPRIL ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "VALSARTAN ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "VALSARTAN ET AMLODIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "LOSARTAN ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "LISINOPRIL ET HYDROCHLOROTHIAZIDE" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "BISOPROLOL ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "METOPROLOL ET FELODIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "METOPROLOL ET CHLORTALIDONE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "TELMISARTAN ET HYDROCHLOROTIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "AMILORIDE ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "TRANDOLAPRIL ET VERAPAMIL" ; min = 84 ; top_3mois = 1 ; OUTPUT ; 
pa = "ATENOLOL ET NIFEDIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ATENOLOL ET CHLORTALIDONE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "CLOPAMIDE ET PINDOLOL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ZOFENOPRIL ET HYDROCHLOROTHIAZIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "RISEDRONIQUE ACIDE ET CALCIUM ET COLECALCIFEROL" ; min = 12 ; top_3mois = 1 ; OUTPUT ; 
pa = "ALENDRONIQUE ACIDE ET COLECALCIFEROL" ; min = 12 ; top_3mois = 1 ; OUTPUT ; 
pa = "CALCIUM ET COLECALCIFEROL" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "ATORVASTATINE ET AMLODIPINE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
pa = "PRAVASTATINE ET ACETYLSALICYLIQUE ACIDE" ; min = 90 ; top_3mois = 1 ; OUTPUT ; 
RUN ;
DATA work.ref_ucd ;
    LENGTH
        code_ucd           8
        nom_court        $ 149
        cod_atc          $ 7 
        cod_ucd_chr      $ 13 ;
code_ucd = 9009994 ; nom_court = "BELUSTINE 40 mg gelule" ; cod_atc = "L01AD02" ; cod_ucd_chr = "0000009009994" ; OUTPUT ; 
code_ucd = 9010750 ; nom_court = "BICNU 100 mg lyophilisat et solution pour preparation injectable IV" ; cod_atc = "L01AD01" ; cod_ucd_chr = "0000009010750" ; OUTPUT ; 
code_ucd = 9010750 ; nom_court = "BICNU 100 mg lyophilisat et solution pour preparation injectable IV" ; cod_atc = "L01AD01" ; cod_ucd_chr = "0000009010750" ; OUTPUT ; 
code_ucd = 9019840 ; nom_court = "CISPLATYL 25 mg poudre et solvant pour solution pour perfusion" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009019840" ; OUTPUT ; 
code_ucd = 9019857 ; nom_court = "CISPLATYL 50 mg poudre et solvant pour solution pour perfusion" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009019857" ; OUTPUT ; 
code_ucd = 9024114 ; nom_court = "DEBRIDAT 50 mg/5 ml solution injectable en ampoule" ; cod_atc = "A03AA05" ; cod_ucd_chr = "0000009024114" ; OUTPUT ; 
code_ucd = 9025711 ; nom_court = "DETICENE 100 mg poudre et solvant pour solution pour perfusion" ; cod_atc = "L01AX04" ; cod_ucd_chr = "0000009025711" ; OUTPUT ; 
code_ucd = 9036689 ; nom_court = "FUNGIZONE 50 mg poudre pour solution injectable" ; cod_atc = "J02AA01" ; cod_ucd_chr = "0000009036689" ; OUTPUT ; 
code_ucd = 9043494 ; nom_court = "HEXASTAT 100 mg gelule" ; cod_atc = "L01XX03" ; cod_ucd_chr = "0000009043494" ; OUTPUT ; 
code_ucd = 9058596 ; nom_court = "METHYL GAG 100 MG Poudre pour solution injectable" ; cod_atc = "L01XX16" ; cod_ucd_chr = "0000009058596" ; OUTPUT ; 
code_ucd = 9058685 ; nom_court = "MEXILETINE AP-HP 200 MG Gelule" ; cod_atc = "M09AX" ; cod_ucd_chr = "0000009058685" ; OUTPUT ; 
code_ucd = 9063781 ; nom_court = "NOTEZINE 100 mg comprime secable" ; cod_atc = "P02CB02" ; cod_ucd_chr = "0000009063781" ; OUTPUT ; 
code_ucd = 9065107 ; nom_court = "ONCOVIN 1 MG Solution injectable" ; cod_atc = "L01CA02" ; cod_ucd_chr = "0000009065107" ; OUTPUT ; 
code_ucd = 9076080 ; nom_court = "PROGLICEM 25 mg gelule" ; cod_atc = "V03AH01" ; cod_ucd_chr = "0000009076080" ; OUTPUT ; 
code_ucd = 9085647 ; nom_court = "SOLUMEDROL 500 MG Poudre et solvant pour solution injectable" ; cod_atc = "H02AB04" ; cod_ucd_chr = "0000009085647" ; OUTPUT ; 
code_ucd = 9087959 ; nom_court = "STIMU-TSH 125 MICROGRAMMES/1 ML Solution injectable" ; cod_atc = "V04CJ02" ; cod_ucd_chr = "0000009087959" ; OUTPUT ; 
code_ucd = 9088284 ; nom_court = "STREPTOMYCINE PANPHARMA 1 g 1 Boite de 1, poudre pour preparation injectable" ; cod_atc = "J01GA01" ; cod_ucd_chr = "0000009088284" ; OUTPUT ; 
code_ucd = 9093061 ; nom_court = "TIBERAL 500 MG Comprimes" ; cod_atc = "P01AB03" ; cod_ucd_chr = "0000009093061" ; OUTPUT ; 
code_ucd = 9106763 ; nom_court = "UROMITEXAN 400 mg solution injectable IV en ampoule de 4 ml" ; cod_atc = "V03AF01" ; cod_ucd_chr = "0000009106763" ; OUTPUT ; 
code_ucd = 9106993 ; nom_court = "ANCOTIL 1 P. 100 solution pour perfusion en flacon de 250 ml" ; cod_atc = "J02AX01" ; cod_ucd_chr = "0000009106993" ; OUTPUT ; 
code_ucd = 9109000 ; nom_court = "THYMOGLOBULINE 5 mg/ml poudre+solvant" ; cod_atc = "L04AA04" ; cod_ucd_chr = "0000009109000" ; OUTPUT ; 
code_ucd = 9109827 ; nom_court = "NOVANTRONE 20 mg/10 ml solution injectable pour perfusion" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009109827" ; OUTPUT ; 
code_ucd = 9117867 ; nom_court = "CISPLATYL 10 mg poudre et solvant pour solution pour perfusion" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009117867" ; OUTPUT ; 
code_ucd = 9118996 ; nom_court = "PROGLICEM 100 mg gelule" ; cod_atc = "V03AH01" ; cod_ucd_chr = "0000009118996" ; OUTPUT ; 
code_ucd = 9119659 ; nom_court = "RETROVIR 100 mg gelule" ; cod_atc = "J05AF01" ; cod_ucd_chr = "0000009119659" ; OUTPUT ; 
code_ucd = 9120651 ; nom_court = "ELDISINE 1 mg poudre pour solution injectable" ; cod_atc = "L01CA03" ; cod_ucd_chr = "0000009120651" ; OUTPUT ; 
code_ucd = 9120668 ; nom_court = "ELDISINE 4 mg poudre pour solution injectable" ; cod_atc = "L01CA03" ; cod_ucd_chr = "0000009120668" ; OUTPUT ; 
code_ucd = 9122348 ; nom_court = "NOVANTRONE 10 mg/5 ml solution injectable pour perfusion" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009122348" ; OUTPUT ; 
code_ucd = 9123201 ; nom_court = "ZANOSAR lyophilisat pour preparation injectable" ; cod_atc = "L01AD04" ; cod_ucd_chr = "0000009123201" ; OUTPUT ; 
code_ucd = 9124442 ; nom_court = "RETROVIR 250 mg gelule" ; cod_atc = "J05AF01" ; cod_ucd_chr = "0000009124442" ; OUTPUT ; 
code_ucd = 9124494 ; nom_court = "VEPESIDE 100 mg/5 ml solution injectable pour perfusion" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009124494" ; OUTPUT ; 
code_ucd = 9125157 ; nom_court = "TARGOCID 100 mg lyophilisat et solution pour usage parenteral IV-IM" ; cod_atc = "J01XA02" ; cod_ucd_chr = "0000009125157" ; OUTPUT ; 
code_ucd = 9125163 ; nom_court = "TARGOCID 200 mg lyophilisat et solution pour usage parenteral IV-IM" ; cod_atc = "J01XA02" ; cod_ucd_chr = "0000009125163" ; OUTPUT ; 
code_ucd = 9125186 ; nom_court = "TARGOCID 400 mg lyophilisat et solution pour usage parenteral IV-IM" ; cod_atc = "J01XA02" ; cod_ucd_chr = "0000009125186" ; OUTPUT ; 
code_ucd = 9130945 ; nom_court = "CYMEVAN 500 mg lyophilisat pour usage parenteral (perfusion)" ; cod_atc = "J05AB06" ; cod_ucd_chr = "0000009130945" ; OUTPUT ; 
code_ucd = 9134110 ; nom_court = "VINCRISTINE PIERRE FABRE 1 MG/ML Solution injectable" ; cod_atc = "L01CA02" ; cod_ucd_chr = "0000009134110" ; OUTPUT ; 
code_ucd = 9136876 ; nom_court = "CISPLATYL 50 mg solution injectable en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009136876" ; OUTPUT ; 
code_ucd = 9137172 ; nom_court = "NAVELBINE 10 mg/1 ml solution injectable en flacon" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009137172" ; OUTPUT ; 
code_ucd = 9137189 ; nom_court = "NAVELBINE 50 mg/5 ml solution injectable en flacon" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009137189" ; OUTPUT ; 
code_ucd = 9137551 ; nom_court = "MINIRIN 4 mg/ml solution injectable en ampoule" ; cod_atc = "H01BA02" ; cod_ucd_chr = "0000009137551" ; OUTPUT ; 
code_ucd = 9137580 ; nom_court = "MUPHORAN poudre et solution pour usage parenteral a diluer (perfusion)" ; cod_atc = "L01AD05" ; cod_ucd_chr = "0000009137580" ; OUTPUT ; 
code_ucd = 9137580 ; nom_court = "MUPHORAN poudre et solution pour usage parenteral a diluer (perfusion)" ; cod_atc = "L01AD05" ; cod_ucd_chr = "0000009137580" ; OUTPUT ; 
code_ucd = 9143534 ; nom_court = "THEPRUBICINE 10 mg lyophilisat et solution pour usage parenteral en flacon + ampoule" ; cod_atc = "L01DB08" ; cod_ucd_chr = "0000009143534" ; OUTPUT ; 
code_ucd = 9143540 ; nom_court = "THEPRUBICINE 20 mg lyophilisat et solution pour usage parenteral en flacon + ampoule" ; cod_atc = "L01DB08" ; cod_ucd_chr = "0000009143540" ; OUTPUT ; 
code_ucd = 9143557 ; nom_court = "THEPRUBICINE 50 mg lyophilisat et solution pour usage parenteral en flacon + ampoule" ; cod_atc = "L01DB08" ; cod_ucd_chr = "0000009143557" ; OUTPUT ; 
code_ucd = 9143793 ; nom_court = "PREPULSID ENFANTS ET NOURRISSONS 1 mg/ml (cisapride) suspension buvable en flacon de 100 ml" ; cod_atc = "A03FA02" ; cod_ucd_chr = "0000009143793" ; OUTPUT ; 
code_ucd = 9144321 ; nom_court = "TRIFLUCAN 2 mg/ml solution pour perfusion en flacon de 100 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009144321" ; OUTPUT ; 
code_ucd = 9144338 ; nom_court = "TRIFLUCAN 2 mg/ml solution pour perfusion en flacon de 50 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009144338" ; OUTPUT ; 
code_ucd = 9145332 ; nom_court = "FARMORUBICINE 10 mg lyophilisat pour usage parenteral" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009145332" ; OUTPUT ; 
code_ucd = 9145349 ; nom_court = "FARMORUBICINE 10 mg/5 ml solution injectable pour perfusion en flacon verre" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009145349" ; OUTPUT ; 
code_ucd = 9145355 ; nom_court = "FARMORUBICINE 20 mg/10 ml solution injectable pour perfusion en flacon verre" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009145355" ; OUTPUT ; 
code_ucd = 9145361 ; nom_court = "FARMORUBICINE 50 mg lyophilisat pour usage parenteral" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009145361" ; OUTPUT ; 
code_ucd = 9145378 ; nom_court = "FARMORUBICINE 50 mg/25 ml solution injectable pour perfusion en flacon verre" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009145378" ; OUTPUT ; 
code_ucd = 9145444 ; nom_court = "CHLORHYDRATE DE DOXORUBICINE DAKOTA PHARM 10 MG lyophilisat pour usage parenteral en flacon" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009145444" ; OUTPUT ; 
code_ucd = 9145450 ; nom_court = "CHLORHYDRATE DE DOXORUBICINE DAKOTA PHARM 50 MG lyophilisat pour usage parenteral en flacon" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009145450" ; OUTPUT ; 
code_ucd = 9147934 ; nom_court = "EPREX 10 000 UI/ml solution injectable en flacon 1 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009147934" ; OUTPUT ; 
code_ucd = 9147940 ; nom_court = "EPREX 2 000 UI/ml solution injectable en flacon 1 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009147940" ; OUTPUT ; 
code_ucd = 9147957 ; nom_court = "EPREX 4 000 UI/ml solution injectable en flacon 1 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009147957" ; OUTPUT ; 
code_ucd = 9149063 ; nom_court = "CISPLATINE DAKOTA PHARM 10 mg lyophilisat pour usage parenteral en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009149063" ; OUTPUT ; 
code_ucd = 9149086 ; nom_court = "CISPLATINE DAKOTA PHARM 10 mg/20 ml solution injectable pour perfusion en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009149086" ; OUTPUT ; 
code_ucd = 9149092 ; nom_court = "CISPLATINE DAKOTA PHARM 25 mg lyophilisat pour usage parenteral en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009149092" ; OUTPUT ; 
code_ucd = 9149100 ; nom_court = "CISPLATINE DAKOTA PHARM 25 mg/50 ml solution injectable pour perfusion en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009149100" ; OUTPUT ; 
code_ucd = 9149117 ; nom_court = "CISPLATINE DAKOTA PHARM 50 mg lyophilisat pour usage parenteral en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009149117" ; OUTPUT ; 
code_ucd = 9149123 ; nom_court = "CISPLATINE DAKOTA PHARM 50 mg/100 ml solution injectable pour perfusion en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009149123" ; OUTPUT ; 
code_ucd = 9149347 ; nom_court = "HOLOXAN 1000 mg poudre pour solution injectable" ; cod_atc = "L01AA06" ; cod_ucd_chr = "0000009149347" ; OUTPUT ; 
code_ucd = 9149821 ; nom_court = "UN-ALFA 1 microgrammes/0,5 ml solution injectable IV en ampoule" ; cod_atc = "A11CC03" ; cod_ucd_chr = "0000009149821" ; OUTPUT ; 
code_ucd = 9149838 ; nom_court = "UN-ALFA 2 microgrammes/1 ml solution injectable IV en ampoule" ; cod_atc = "A11CC03" ; cod_ucd_chr = "0000009149838" ; OUTPUT ; 
code_ucd = 9153395 ; nom_court = "ZAVEDOS 10 mg lyophilisat pour usage parenteral IV en flacon" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009153395" ; OUTPUT ; 
code_ucd = 9153395 ; nom_court = "ZAVEDOS 10 mg lyophilisat pour usage parenteral IV en flacon" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009153395" ; OUTPUT ; 
code_ucd = 9153403 ; nom_court = "ZAVEDOS 5 mg lyophilisat pour usage parenteral IV en flacon" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009153403" ; OUTPUT ; 
code_ucd = 9153403 ; nom_court = "ZAVEDOS 5 mg lyophilisat pour usage parenteral IV en flacon" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009153403" ; OUTPUT ; 
code_ucd = 9153691 ; nom_court = "VIDEX 100 mg comprime a croquer ou dispersible" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009153691" ; OUTPUT ; 
code_ucd = 9153716 ; nom_court = "VIDEX 150 mg comprime a croquer ou dispersible" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009153716" ; OUTPUT ; 
code_ucd = 9153722 ; nom_court = "VIDEX 25 mg comprime a croquer ou dispersible" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009153722" ; OUTPUT ; 
code_ucd = 9153739 ; nom_court = "VIDEX 50 mg comprime a croquer ou dispersible" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009153739" ; OUTPUT ; 
code_ucd = 9153857 ; nom_court = "FARMORUBICINE 150 mg lyophilisat pour usage parenteral" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009153857" ; OUTPUT ; 
code_ucd = 9154182 ; nom_court = "RETROVIR 100 mg/10 ml solution buvable en flacon" ; cod_atc = "J05AF01" ; cod_ucd_chr = "0000009154182" ; OUTPUT ; 
code_ucd = 9156086 ; nom_court = "CELLTOP 100 mg/5 ml solution injectable pour perfusion" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009156086" ; OUTPUT ; 
code_ucd = 9157364 ; nom_court = "VIDEX 2 g poudre pour solution buvable en flacon" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009157364" ; OUTPUT ; 
code_ucd = 9157849 ; nom_court = "ADRIBLASTINE 10 mg lyophilisat pour usage parenteral (perfusion) en flacon" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009157849" ; OUTPUT ; 
code_ucd = 9157855 ; nom_court = "ADRIBLASTINE 50 mg lyophilisat pour usage parenteral (perfusion) en flacon" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009157855" ; OUTPUT ; 
code_ucd = 9160314 ; nom_court = "EPREX 2000 UI/ml solution injectable en flacon 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009160314" ; OUTPUT ; 
code_ucd = 9160490 ; nom_court = "METASTRON solution injectable radioactive IV de chlorure de Strontium (89 SR)" ; cod_atc = "V10BX01" ; cod_ucd_chr = "0000009160490" ; OUTPUT ; 
code_ucd = 9160509 ; nom_court = "NIPENT 10 mg Poudre pour solution pour injection, poudre pour solution pour perfusion en flacon" ; cod_atc = "L01XX08" ; cod_ucd_chr = "0000009160509" ; OUTPUT ; 
code_ucd = 9160509 ; nom_court = "NIPENT 10 mg Poudre pour solution pour injection, poudre pour solution pour perfusion en flacon" ; cod_atc = "L01XX08" ; cod_ucd_chr = "0000009160509" ; OUTPUT ; 
code_ucd = 9162336 ; nom_court = "IMUKIN 100 mg/0,5 ml solution injectable" ; cod_atc = "L03AB03" ; cod_ucd_chr = "0000009162336" ; OUTPUT ; 
code_ucd = 9163577 ; nom_court = "TAXOL 6 mg/ml solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009163577" ; OUTPUT ; 
code_ucd = 9165168 ; nom_court = "EPREX 2000 UI/ml solution injectable en seringue pre-remplie 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009165168" ; OUTPUT ; 
code_ucd = 9165174 ; nom_court = "EPREX 4000 UI/ml solution injectable en seringue pre-remplie 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009165174" ; OUTPUT ; 
code_ucd = 9165180 ; nom_court = "EPREX 10000 UI/ml solution injectable en seringue pre-remplie 0,3 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009165180" ; OUTPUT ; 
code_ucd = 9165197 ; nom_court = "EPREX 10000 UI/ml solution injectable en seringue pre-remplie 0,4 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009165197" ; OUTPUT ; 
code_ucd = 9166883 ; nom_court = "LAMPRENE 100 mg capsule molle" ; cod_atc = "J04BA01" ; cod_ucd_chr = "0000009166883" ; OUTPUT ; 
code_ucd = 9166908 ; nom_court = "LAMPRENE 50 mg capsule molle" ; cod_atc = "J04BA01" ; cod_ucd_chr = "0000009166908" ; OUTPUT ; 
code_ucd = 9166914 ; nom_court = "METOPIRONE 250 mg capsule" ; cod_atc = "V04CD01" ; cod_ucd_chr = "0000009166914" ; OUTPUT ; 
code_ucd = 9167411 ; nom_court = "THIOTEPA GENOPHARM 15 mg lyophilisat pour usage parenteral" ; cod_atc = "L01AC01" ; cod_ucd_chr = "0000009167411" ; OUTPUT ; 
code_ucd = 9167440 ; nom_court = "EPREX 10000 UI/ml solution injectable en seringue pre-remplie 1 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009167440" ; OUTPUT ; 
code_ucd = 9167977 ; nom_court = "ENDOXAN 1000 mg poudre pour solution injectable" ; cod_atc = "L01AA01" ; cod_ucd_chr = "0000009167977" ; OUTPUT ; 
code_ucd = 9168014 ; nom_court = "LEUSTATINE 10 mg/10ml solution injectable pour perfusion en flacon" ; cod_atc = "L01BB04" ; cod_ucd_chr = "0000009168014" ; OUTPUT ; 
code_ucd = 9168014 ; nom_court = "LEUSTATINE 10 mg/10ml solution injectable pour perfusion en flacon" ; cod_atc = "L01BB04" ; cod_ucd_chr = "0000009168014" ; OUTPUT ; 
code_ucd = 9169321 ; nom_court = "MONOCLATE P 1000 UI/10 ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009169321" ; OUTPUT ; 
code_ucd = 9169344 ; nom_court = "MONOCLATE P 500 UI/5 ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009169344" ; OUTPUT ; 
code_ucd = 9170169 ; nom_court = "FACTEUR VII LFB 500 UI/20 ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD05" ; cod_ucd_chr = "0000009170169" ; OUTPUT ; 
code_ucd = 9170169 ; nom_court = "FACTEUR VII LFB 500 UI/20 ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD05" ; cod_ucd_chr = "0000009170169" ; OUTPUT ; 
code_ucd = 9170175 ; nom_court = "HEMOLEVEN 1000 UI/10 ml poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009170175" ; OUTPUT ; 
code_ucd = 9170175 ; nom_court = "HEMOLEVEN 1000 UI/10 ml poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009170175" ; OUTPUT ; 
code_ucd = 9170442 ; nom_court = "KASKADIL poudre et solvant pour solution injectable (10 ml)" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009170442" ; OUTPUT ; 
code_ucd = 9170442 ; nom_court = "KASKADIL poudre et solvant pour solution injectable (10 ml)" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009170442" ; OUTPUT ; 
code_ucd = 9170459 ; nom_court = "KASKADIL poudre et solvant pour solution injectable (20 ml)" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009170459" ; OUTPUT ; 
code_ucd = 9170459 ; nom_court = "KASKADIL poudre et solvant pour solution injectable (20 ml)" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009170459" ; OUTPUT ; 
code_ucd = 9171341 ; nom_court = "FLUDARA 50 mg poudre pour solution injectable ou perfusion en ampoule" ; cod_atc = "L01BB05" ; cod_ucd_chr = "0000009171341" ; OUTPUT ; 
code_ucd = 9172607 ; nom_court = "ETHYOL 50 mg/ml poudre pour solution injectable en flacon de 500 mg" ; cod_atc = "V03AF05" ; cod_ucd_chr = "0000009172607" ; OUTPUT ; 
code_ucd = 9172607 ; nom_court = "ETHYOL 50 mg/ml poudre pour solution injectable en flacon de 500 mg" ; cod_atc = "V03AF05" ; cod_ucd_chr = "0000009172607" ; OUTPUT ; 
code_ucd = 9173104 ; nom_court = "UROMITEXAN 1 g/10 ml solution injectable pour perfusion en flacon" ; cod_atc = "V03AF01" ; cod_ucd_chr = "0000009173104" ; OUTPUT ; 
code_ucd = 9173110 ; nom_court = "UROMITEXAN 5 g/50 ml solution injectable pour perfusion en flacon" ; cod_atc = "V03AF01" ; cod_ucd_chr = "0000009173110" ; OUTPUT ; 
code_ucd = 9173311 ; nom_court = "CAMPTO 20 MG/ML Solution a diluer pour perfusion en flacon verre de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009173311" ; OUTPUT ; 
code_ucd = 9173475 ; nom_court = "NORMOSANG 25 mg/ml 1 Ampoule de 10 ml, solution a diluer pour perfusion" ; cod_atc = "B06AB01" ; cod_ucd_chr = "0000009173475" ; OUTPUT ; 
code_ucd = 9175304 ; nom_court = "HOLOXAN 2000 mg poudre pour usage parenteral" ; cod_atc = "L01AA06" ; cod_ucd_chr = "0000009175304" ; OUTPUT ; 
code_ucd = 9175511 ; nom_court = "SANDOGLOBULINE 1 g poudre pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009175511" ; OUTPUT ; 
code_ucd = 9175511 ; nom_court = "SANDOGLOBULINE 1 g poudre pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009175511" ; OUTPUT ; 
code_ucd = 9175801 ; nom_court = "ETOPOSIDE DAKOTA PHARM 100 mg/5 ml solution injectable pour perfusion" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009175801" ; OUTPUT ; 
code_ucd = 9177177 ; nom_court = "LIPIOCIS solution pour injection" ; cod_atc = "V10XA" ; cod_ucd_chr = "0000009177177" ; OUTPUT ; 
code_ucd = 9177579 ; nom_court = "ZERIT 15 mg gelule" ; cod_atc = "J05AF04" ; cod_ucd_chr = "0000009177579" ; OUTPUT ; 
code_ucd = 9177585 ; nom_court = "ZERIT 20 mg gelule" ; cod_atc = "J05AF04" ; cod_ucd_chr = "0000009177585" ; OUTPUT ; 
code_ucd = 9177591 ; nom_court = "ZERIT 30 mg gelule" ; cod_atc = "J05AF04" ; cod_ucd_chr = "0000009177591" ; OUTPUT ; 
code_ucd = 9177616 ; nom_court = "ZERIT 40 mg gelule" ; cod_atc = "J05AF04" ; cod_ucd_chr = "0000009177616" ; OUTPUT ; 
code_ucd = 9177881 ; nom_court = "FOLINATE DE CALCIUM AGUETTANT 5 MG/2 ML Solution injectable" ; cod_atc = "V03AF03" ; cod_ucd_chr = "0000009177881" ; OUTPUT ; 
code_ucd = 9178082 ; nom_court = "TAXOTERE 20 mg solution a diluer et solvant pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009178082" ; OUTPUT ; 
code_ucd = 9178082 ; nom_court = "TAXOTERE 20 mg solution a diluer et solvant pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009178082" ; OUTPUT ; 
code_ucd = 9178099 ; nom_court = "TAXOTERE 80 mg solution a diluer et solvant pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009178099" ; OUTPUT ; 
code_ucd = 9178099 ; nom_court = "TAXOTERE 80 mg solution a diluer et solvant pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009178099" ; OUTPUT ; 
code_ucd = 9178811 ; nom_court = "FOLINATE DE CALCIUM AGUETTANT 50 MG Poudre pour solution injectable" ; cod_atc = "V03AF03" ; cod_ucd_chr = "0000009178811" ; OUTPUT ; 
code_ucd = 9179029 ; nom_court = "CARDIOXANE 500 mg Poudre pour solution pour perfusion en flacon" ; cod_atc = "V03AF02" ; cod_ucd_chr = "0000009179029" ; OUTPUT ; 
code_ucd = 9179029 ; nom_court = "CARDIOXANE 500 mg Poudre pour solution pour perfusion en flacon" ; cod_atc = "V03AF02" ; cod_ucd_chr = "0000009179029" ; OUTPUT ; 
code_ucd = 9179213 ; nom_court = "CISPLATYL 10 mg/10 ml solution injectable pour perfusion (I.V.) en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009179213" ; OUTPUT ; 
code_ucd = 9179236 ; nom_court = "CISPLATYL 25 mg/25 ml solution injectable pour perfusion (I.V.) en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009179236" ; OUTPUT ; 
code_ucd = 9179242 ; nom_court = "CISPLATYL 50 mg/50 ml solution injectable pour perfusion (I.V.) en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009179242" ; OUTPUT ; 
code_ucd = 9179650 ; nom_court = "FEIBA 1 000 U/20 ML poudre et solvant pour solution injectable" ; cod_atc = "B02BD03" ; cod_ucd_chr = "0000009179650" ; OUTPUT ; 
code_ucd = 9179650 ; nom_court = "FEIBA 1 000 U/20 ML poudre et solvant pour solution injectable" ; cod_atc = "B02BD03" ; cod_ucd_chr = "0000009179650" ; OUTPUT ; 
code_ucd = 9179667 ; nom_court = "FEIBA 500 U/20 ML poudre et solvant pour solution injectable" ; cod_atc = "B02BD03" ; cod_ucd_chr = "0000009179667" ; OUTPUT ; 
code_ucd = 9179667 ; nom_court = "FEIBA 500 U/20 ML poudre et solvant pour solution injectable" ; cod_atc = "B02BD03" ; cod_ucd_chr = "0000009179667" ; OUTPUT ; 
code_ucd = 9180073 ; nom_court = "TALOXA 400 mg comprime" ; cod_atc = "N03AX10" ; cod_ucd_chr = "0000009180073" ; OUTPUT ; 
code_ucd = 9180096 ; nom_court = "TALOXA 600 mg comprime" ; cod_atc = "N03AX10" ; cod_ucd_chr = "0000009180096" ; OUTPUT ; 
code_ucd = 9180104 ; nom_court = "TALOXA 600 mg/5 ml suspension buvable en flacon verre de 230 ml" ; cod_atc = "N03AX10" ; cod_ucd_chr = "0000009180104" ; OUTPUT ; 
code_ucd = 9180802 ; nom_court = "CRIXIVAN 200 mg gelule" ; cod_atc = "J05AE02" ; cod_ucd_chr = "0000009180802" ; OUTPUT ; 
code_ucd = 9180819 ; nom_court = "CRIXIVAN 400 mg gelule" ; cod_atc = "J05AE02" ; cod_ucd_chr = "0000009180819" ; OUTPUT ; 
code_ucd = 9181664 ; nom_court = "INVIRASE 200 mg gelule" ; cod_atc = "J05AE01" ; cod_ucd_chr = "0000009181664" ; OUTPUT ; 
code_ucd = 9181670 ; nom_court = "MONONINE 1 000 UI/10 ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009181670" ; OUTPUT ; 
code_ucd = 9181670 ; nom_court = "MONONINE 1 000 UI/10 ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009181670" ; OUTPUT ; 
code_ucd = 9181687 ; nom_court = "MONONINE 500 UI/5 ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009181687" ; OUTPUT ; 
code_ucd = 9181687 ; nom_court = "MONONINE 500 UI/5 ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009181687" ; OUTPUT ; 
code_ucd = 9181753 ; nom_court = "NOVOSEVEN 120 KUI poudre et solvant pour solution injectable" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009181753" ; OUTPUT ; 
code_ucd = 9181753 ; nom_court = "NOVOSEVEN 120 KUI poudre et solvant pour solution injectable" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009181753" ; OUTPUT ; 
code_ucd = 9181776 ; nom_court = "NOVOSEVEN 240 KUI poudre et solvant pour solution injectable" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009181776" ; OUTPUT ; 
code_ucd = 9181776 ; nom_court = "NOVOSEVEN 240 KUI poudre et solvant pour solution injectable" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009181776" ; OUTPUT ; 
code_ucd = 9181782 ; nom_court = "NOVOSEVEN 60 KUI poudre et solvant pour solution injectable" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009181782" ; OUTPUT ; 
code_ucd = 9181782 ; nom_court = "NOVOSEVEN 60 KUI poudre et solvant pour solution injectable" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009181782" ; OUTPUT ; 
code_ucd = 9182066 ; nom_court = "TOMUDEX 2 mg poudre pour solution pour perfusion en flacon" ; cod_atc = "L01BA03" ; cod_ucd_chr = "0000009182066" ; OUTPUT ; 
code_ucd = 9182066 ; nom_court = "TOMUDEX 2 mg poudre pour solution pour perfusion en flacon" ; cod_atc = "L01BA03" ; cod_ucd_chr = "0000009182066" ; OUTPUT ; 
code_ucd = 9182184 ; nom_court = "VESANOID 10 MG Capsules" ; cod_atc = "L01XX14" ; cod_ucd_chr = "0000009182184" ; OUTPUT ; 
code_ucd = 9182190 ; nom_court = "GEMZAR 1000 mg lyophilisat pour usage parenteral en flacon" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009182190" ; OUTPUT ; 
code_ucd = 9182209 ; nom_court = "GEMZAR 200 mg lyophilisat pour usage parenteral en flacon" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009182209" ; OUTPUT ; 
code_ucd = 9182356 ; nom_court = "ALKERAN 50 mg/10 ml lyophilisat et solution pour usage parenteral (I.V.)" ; cod_atc = "L01AA03" ; cod_ucd_chr = "0000009182356" ; OUTPUT ; 
code_ucd = 9182480 ; nom_court = "FARMORUBICINE 200 mg/ 100ml solution injectable pour perfusion en flacon verre" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009182480" ; OUTPUT ; 
code_ucd = 9182824 ; nom_court = "TEGELINE 50 MG/ML poudre et solvant pour solution pour perfusion (10 ml)" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009182824" ; OUTPUT ; 
code_ucd = 9182824 ; nom_court = "TEGELINE 50 MG/ML poudre et solvant pour solution pour perfusion (10 ml)" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009182824" ; OUTPUT ; 
code_ucd = 9182830 ; nom_court = "TEGELINE 50 MG/ML poudre et solvant pour solution pour perfusion (200 ml)" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009182830" ; OUTPUT ; 
code_ucd = 9182830 ; nom_court = "TEGELINE 50 MG/ML poudre et solvant pour solution pour perfusion (200 ml)" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009182830" ; OUTPUT ; 
code_ucd = 9182847 ; nom_court = "TEGELINE 50 MG/ML poudre et solvant pour solution pour perfusion (50 ml)" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009182847" ; OUTPUT ; 
code_ucd = 9182847 ; nom_court = "TEGELINE 50 MG/ML poudre et solvant pour solution pour perfusion (50 ml)" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009182847" ; OUTPUT ; 
code_ucd = 9182853 ; nom_court = "TEGELINE 50 MG/ML poudre et solvant pour solution pour perfusion (100 ml)" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009182853" ; OUTPUT ; 
code_ucd = 9182853 ; nom_court = "TEGELINE 50 MG/ML poudre et solvant pour solution pour perfusion (100 ml)" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009182853" ; OUTPUT ; 
code_ucd = 9183195 ; nom_court = "EPIVIR 10 mg/ml solution buvable en flacon 240 ml" ; cod_atc = "J05AF05" ; cod_ucd_chr = "0000009183195" ; OUTPUT ; 
code_ucd = 9183203 ; nom_court = "EPIVIR 150 mg comprime pellicule" ; cod_atc = "J05AF05" ; cod_ucd_chr = "0000009183203" ; OUTPUT ; 
code_ucd = 9183947 ; nom_court = "ORGARAN 750 UI anti Xa/0,6 ml, solution injectable en ampoule" ; cod_atc = "B01AB09" ; cod_ucd_chr = "0000009183947" ; OUTPUT ; 
code_ucd = 9183976 ; nom_court = "NORVIR 80 mg/ml solution buvable" ; cod_atc = "J05AE03" ; cod_ucd_chr = "0000009183976" ; OUTPUT ; 
code_ucd = 9184438 ; nom_court = "ETOPOPHOS 100 mg lyophilisat pour usage parenteral" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009184438" ; OUTPUT ; 
code_ucd = 9184467 ; nom_court = "DAUNOXOME 2 MG/ML Liposome pour injection, flacon de 50 ml" ; cod_atc = "L01DB02" ; cod_ucd_chr = "0000009184467" ; OUTPUT ; 
code_ucd = 9184467 ; nom_court = "DAUNOXOME 2 MG/ML Liposome pour injection, flacon de 50 ml" ; cod_atc = "L01DB02" ; cod_ucd_chr = "0000009184467" ; OUTPUT ; 
code_ucd = 9184711 ; nom_court = "VEPESIDE 50 mg/2,5 ml solution injectable pour perfusion" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009184711" ; OUTPUT ; 
code_ucd = 9184881 ; nom_court = "FLOLAN 0,5 mg poudre et solvant pour solution injectable" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009184881" ; OUTPUT ; 
code_ucd = 9184881 ; nom_court = "FLOLAN 0,5 mg poudre et solvant pour solution injectable" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009184881" ; OUTPUT ; 
code_ucd = 9184906 ; nom_court = "LANVIS 40 MG comprime secable" ; cod_atc = "L01BB03" ; cod_ucd_chr = "0000009184906" ; OUTPUT ; 
code_ucd = 9185314 ; nom_court = "LEDERMYCINE 150 MG Gelule" ; cod_atc = "J01AA01" ; cod_ucd_chr = "0000009185314" ; OUTPUT ; 
code_ucd = 9185923 ; nom_court = "VIDEX 4 g poudre pour solution buvable en flacon" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009185923" ; OUTPUT ; 
code_ucd = 9185946 ; nom_court = "ZERIT 200 mg 1 mg/ml poudre pour solution buvable" ; cod_atc = "J05AF04" ; cod_ucd_chr = "0000009185946" ; OUTPUT ; 
code_ucd = 9186437 ; nom_court = "ETOPOSIDE TEVA 20 mg/ml solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009186437" ; OUTPUT ; 
code_ucd = 9186443 ; nom_court = "ETOPOSIDE TEVA 20 mg/ml solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009186443" ; OUTPUT ; 
code_ucd = 9187023 ; nom_court = "HYCAMTIN 4 mg poudre pour solution pour perfusion (flacon 5 ml)" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009187023" ; OUTPUT ; 
code_ucd = 9187023 ; nom_court = "HYCAMTIN 4 mg poudre pour solution pour perfusion (flacon 5 ml)" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009187023" ; OUTPUT ; 
code_ucd = 9187939 ; nom_court = "NAROPEINE 2 MG/ML solution injectable en poche de 100 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009187939" ; OUTPUT ; 
code_ucd = 9187945 ; nom_court = "NAROPEINE 2 MG/ML solution injectable en poche de 200 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009187945" ; OUTPUT ; 
code_ucd = 9189944 ; nom_court = "TAXOL 6 mg/ml solution a diluer pour perfusion en flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009189944" ; OUTPUT ; 
code_ucd = 9190692 ; nom_court = "THALIDOMIDE LAPHAL 50 mg gelule" ; cod_atc = "L04AX02" ; cod_ucd_chr = "0000009190692" ; OUTPUT ; 
code_ucd = 9191527 ; nom_court = "FLUOROURACILE SERB 1000 mg/20 ml solution injectable pour perfusion en flacon" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009191527" ; OUTPUT ; 
code_ucd = 9191533 ; nom_court = "FLUOROURACILE SERB 250 mg/5 ml solution injectable pour perfusion en flacon" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009191533" ; OUTPUT ; 
code_ucd = 9191556 ; nom_court = "FLUOROURACILE SERB 500 mg/10 ml solution injectable pour perfusion en flacon" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009191556" ; OUTPUT ; 
code_ucd = 9192107 ; nom_court = "FLUOROURACILE DAKOTA 50 mg/ml solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009192107" ; OUTPUT ; 
code_ucd = 9192113 ; nom_court = "FLUOROURACILE DAKOTA 50 mg/ml solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009192113" ; OUTPUT ; 
code_ucd = 9192136 ; nom_court = "FLUOROURACILE DAKOTA 50 mg/ml solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009192136" ; OUTPUT ; 
code_ucd = 9192432 ; nom_court = "RETROVIR 300 mg comprime" ; cod_atc = "J05AF01" ; cod_ucd_chr = "0000009192432" ; OUTPUT ; 
code_ucd = 9193845 ; nom_court = "DIACOMIT 250 mg gelule" ; cod_atc = "N03AX17" ; cod_ucd_chr = "0000009193845" ; OUTPUT ; 
code_ucd = 9193851 ; nom_court = "DIACOMIT 250 mg granules pour suspension buvable en sachet-dose" ; cod_atc = "N03AX17" ; cod_ucd_chr = "0000009193851" ; OUTPUT ; 
code_ucd = 9193868 ; nom_court = "DIACOMIT 500 mg gelule" ; cod_atc = "N03AX17" ; cod_ucd_chr = "0000009193868" ; OUTPUT ; 
code_ucd = 9193874 ; nom_court = "DIACOMIT 500 mg granules pour suspension buvable en sachet-dose" ; cod_atc = "N03AX17" ; cod_ucd_chr = "0000009193874" ; OUTPUT ; 
code_ucd = 9193928 ; nom_court = "NEORECORMON 10 000 UI poudre et solvant pour solution injectable en cartouche" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009193928" ; OUTPUT ; 
code_ucd = 9193940 ; nom_court = "NEORECORMON 100 000 UI poudre et solvant pour solution injectable en flacon multidose" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009193940" ; OUTPUT ; 
code_ucd = 9193992 ; nom_court = "NEORECORMON 500 UI/0,3 ml poudre et solvant pour solution injectable" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009193992" ; OUTPUT ; 
code_ucd = 9194023 ; nom_court = "NEORECORMON 50 000 UI poudre et solvant pour solution injectable en flacon multidose" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009194023" ; OUTPUT ; 
code_ucd = 9194046 ; nom_court = "PHOTOFRIN 15 mg lyophilisat pour usage parenteral IV en flacon" ; cod_atc = "L01XD01" ; cod_ucd_chr = "0000009194046" ; OUTPUT ; 
code_ucd = 9194052 ; nom_court = "PHOTOFRIN 75 mg lyophilisat pour usage parenteral IV en flacon" ; cod_atc = "L01XD01" ; cod_ucd_chr = "0000009194052" ; OUTPUT ; 
code_ucd = 9194460 ; nom_court = "CAELYX 2 mg/ml Solution a diluer pour perfusion, flacon de 10 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009194460" ; OUTPUT ; 
code_ucd = 9194460 ; nom_court = "CAELYX 2 mg/ml Solution a diluer pour perfusion, flacon de 10 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009194460" ; OUTPUT ; 
code_ucd = 9194796 ; nom_court = "UROMITEXAN 400 mg comprime pellicule secable" ; cod_atc = "V03AF01" ; cod_ucd_chr = "0000009194796" ; OUTPUT ; 
code_ucd = 9194804 ; nom_court = "UROMITEXAN 600 mg comprime" ; cod_atc = "V03AF01" ; cod_ucd_chr = "0000009194804" ; OUTPUT ; 
code_ucd = 9194856 ; nom_court = "AMIKACINE AGUETTANT 250 MG Poudre pour solution injectable" ; cod_atc = "J01GB06" ; cod_ucd_chr = "0000009194856" ; OUTPUT ; 
code_ucd = 9194862 ; nom_court = "AMIKACINE AGUETTANT 500 MG Poudre pour solution injectable" ; cod_atc = "J01GB06" ; cod_ucd_chr = "0000009194862" ; OUTPUT ; 
code_ucd = 9194939 ; nom_court = "VANCOMYCINE ABBOTT 1 g poudre pour solution pour perfusion" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009194939" ; OUTPUT ; 
code_ucd = 9194945 ; nom_court = "VANCOMYCINE ABBOTT 500 mg poudre pour solution pour perfusion" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009194945" ; OUTPUT ; 
code_ucd = 9195726 ; nom_court = "ETOPOSIDE MYLAN 20 MG/ML solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009195726" ; OUTPUT ; 
code_ucd = 9195732 ; nom_court = "VANCOMYCINE MYLAN 1 G poudre pour solution pour perfusion" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009195732" ; OUTPUT ; 
code_ucd = 9195749 ; nom_court = "VANCOMYCINE MYLAN 500 MG poudre pour solution pour perfusion (IV) en flacon" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009195749" ; OUTPUT ; 
code_ucd = 9196163 ; nom_court = "FLUOROURACILE TEVA 50 mg/ml solution pour perfusion en flacon de 20 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009196163" ; OUTPUT ; 
code_ucd = 9196186 ; nom_court = "FLUOROURACILE TEVA 50 mg/ ml solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009196186" ; OUTPUT ; 
code_ucd = 9196192 ; nom_court = "FLUOROURACILE TEVA 50 mg/ml solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009196192" ; OUTPUT ; 
code_ucd = 9196200 ; nom_court = "FLUOROURACILE TEVA 50 mg/ml solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009196200" ; OUTPUT ; 
code_ucd = 9196246 ; nom_court = "ABELCET 5 mg/ml suspension a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "J02AA01" ; cod_ucd_chr = "0000009196246" ; OUTPUT ; 
code_ucd = 9196246 ; nom_court = "ABELCET 5 mg/ml suspension a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "J02AA01" ; cod_ucd_chr = "0000009196246" ; OUTPUT ; 
code_ucd = 9196424 ; nom_court = "VIRACEPT 50 mg/g poudre orale en flacon de 144g" ; cod_atc = "J05AE04" ; cod_ucd_chr = "0000009196424" ; OUTPUT ; 
code_ucd = 9196476 ; nom_court = "VIRAMUNE 200 mg comprime" ; cod_atc = "J05AG01" ; cod_ucd_chr = "0000009196476" ; OUTPUT ; 
code_ucd = 9197441 ; nom_court = "ESKAZOLE 400 mg comprime pellicule sous plaquette thermoformee" ; cod_atc = "P02CA03" ; cod_ucd_chr = "0000009197441" ; OUTPUT ; 
code_ucd = 9197518 ; nom_court = "INTRONA 18 M UI/3 ml solution injectable en flacon" ; cod_atc = "L03AB05" ; cod_ucd_chr = "0000009197518" ; OUTPUT ; 
code_ucd = 9197702 ; nom_court = "MABTHERA 100 mg solution a diluer pour perfusion" ; cod_atc = "L01XC02" ; cod_ucd_chr = "0000009197702" ; OUTPUT ; 
code_ucd = 9197702 ; nom_court = "MABTHERA 100 mg solution a diluer pour perfusion" ; cod_atc = "L01XC02" ; cod_ucd_chr = "0000009197702" ; OUTPUT ; 
code_ucd = 9197719 ; nom_court = "MABTHERA 500 mg solution a diluer pour perfusion" ; cod_atc = "L01XC02" ; cod_ucd_chr = "0000009197719" ; OUTPUT ; 
code_ucd = 9197719 ; nom_court = "MABTHERA 500 mg solution a diluer pour perfusion" ; cod_atc = "L01XC02" ; cod_ucd_chr = "0000009197719" ; OUTPUT ; 
code_ucd = 9199055 ; nom_court = "GAMMAGARD 50 MG/ML poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009199055" ; OUTPUT ; 
code_ucd = 9199055 ; nom_court = "GAMMAGARD 50 MG/ML poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009199055" ; OUTPUT ; 
code_ucd = 9199061 ; nom_court = "GAMMAGARD 50 MG/ML poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009199061" ; OUTPUT ; 
code_ucd = 9199061 ; nom_court = "GAMMAGARD 50 MG/ML poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009199061" ; OUTPUT ; 
code_ucd = 9199078 ; nom_court = "GAMMAGARD 50 MG/ML poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009199078" ; OUTPUT ; 
code_ucd = 9199078 ; nom_court = "GAMMAGARD 50 MG/ML poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009199078" ; OUTPUT ; 
code_ucd = 9199173 ; nom_court = "NEORECORMON 20 000 UI poudre et solvant pour solution injectable en cartouche" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009199173" ; OUTPUT ; 
code_ucd = 9200031 ; nom_court = "CYSTAGON 150 mg gelule" ; cod_atc = "A16AA04" ; cod_ucd_chr = "0000009200031" ; OUTPUT ; 
code_ucd = 9200048 ; nom_court = "CYSTAGON 50 mg gelule" ; cod_atc = "A16AA04" ; cod_ucd_chr = "0000009200048" ; OUTPUT ; 
code_ucd = 9200692 ; nom_court = "COMBIVIR comprime pellicule" ; cod_atc = "J05AR01" ; cod_ucd_chr = "0000009200692" ; OUTPUT ; 
code_ucd = 9200700 ; nom_court = "TESLASCAN 0,01 MMOL/ML Solution pour perfusion" ; cod_atc = "V08CA05" ; cod_ucd_chr = "0000009200700" ; OUTPUT ; 
code_ucd = 9200953 ; nom_court = "VINCRISTINE FAULDING 1 MG/ML Solution injectable" ; cod_atc = "L01CA02" ; cod_ucd_chr = "0000009200953" ; OUTPUT ; 
code_ucd = 9200976 ; nom_court = "VINCRISTINE FAULDING 2 MG/2 ML Solution injectable" ; cod_atc = "L01CA02" ; cod_ucd_chr = "0000009200976" ; OUTPUT ; 
code_ucd = 9200982 ; nom_court = "BENEFIX 1 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009200982" ; OUTPUT ; 
code_ucd = 9200982 ; nom_court = "BENEFIX 1 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009200982" ; OUTPUT ; 
code_ucd = 9200999 ; nom_court = "BENEFIX 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009200999" ; OUTPUT ; 
code_ucd = 9200999 ; nom_court = "BENEFIX 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009200999" ; OUTPUT ; 
code_ucd = 9201007 ; nom_court = "BENEFIX 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009201007" ; OUTPUT ; 
code_ucd = 9201007 ; nom_court = "BENEFIX 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009201007" ; OUTPUT ; 
code_ucd = 9201065 ; nom_court = "SUSTIVA 200 mg gelule" ; cod_atc = "J05AG03" ; cod_ucd_chr = "0000009201065" ; OUTPUT ; 
code_ucd = 9201094 ; nom_court = "NEORECORMON 1000 UI/0,3 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009201094" ; OUTPUT ; 
code_ucd = 9201102 ; nom_court = "NEORECORMON 10 000 UI/0,6 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009201102" ; OUTPUT ; 
code_ucd = 9201119 ; nom_court = "NEORECORMON 2000 UI/0,3 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009201119" ; OUTPUT ; 
code_ucd = 9201125 ; nom_court = "NEORECORMON 20 000 UI/0,6 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009201125" ; OUTPUT ; 
code_ucd = 9201131 ; nom_court = "NEORECORMON 3000 UI/0,3 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009201131" ; OUTPUT ; 
code_ucd = 9201148 ; nom_court = "NEORECORMON 500 UI/0,3 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009201148" ; OUTPUT ; 
code_ucd = 9201154 ; nom_court = "NEORECORMON 5000 UI/0,3 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009201154" ; OUTPUT ; 
code_ucd = 9202018 ; nom_court = "QUADRAMET 1,3 GBq/ml solution injectable de 1,5 ml en flacon de 15 ml" ; cod_atc = "V10BX02" ; cod_ucd_chr = "0000009202018" ; OUTPUT ; 
code_ucd = 9202260 ; nom_court = "RIMIFON 500 MG/5 ML Solution injectable" ; cod_atc = "J04AC01" ; cod_ucd_chr = "0000009202260" ; OUTPUT ; 
code_ucd = 9202308 ; nom_court = "CISPLATINE DAKOTA PHARM 1 mg/ml solution injectable en flacon de 10 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009202308" ; OUTPUT ; 
code_ucd = 9202314 ; nom_court = "CISPLATINE DAKOTA PHARM 1 mg/ml solution injectable en flacon de 100 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009202314" ; OUTPUT ; 
code_ucd = 9202320 ; nom_court = "CISPLATINE DAKOTA PHARM 1 mg/ml solution injectable en flacon de 50 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009202320" ; OUTPUT ; 
code_ucd = 9202774 ; nom_court = "ADRIBLASTINE 10 mg/5 ml solution injectable pour perfusion en flacon polypropylene" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009202774" ; OUTPUT ; 
code_ucd = 9202780 ; nom_court = "ADRIBLASTINE 50 mg/25 ml solution injectable pour perfusion en flacon polypropylene" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009202780" ; OUTPUT ; 
code_ucd = 9202834 ; nom_court = "FARMORUBICINE 10 mg/5 ml solution injectable pour perfusion en flacon polypropylene" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009202834" ; OUTPUT ; 
code_ucd = 9202840 ; nom_court = "FARMORUBICINE 20 mg/10 ml solution injectable pour perfusion en flacon polypropylene" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009202840" ; OUTPUT ; 
code_ucd = 9202857 ; nom_court = "FARMORUBICINE 200 mg/100 ml solution injectable pour perfusion en flacon polypropylene" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009202857" ; OUTPUT ; 
code_ucd = 9202863 ; nom_court = "FARMORUBICINE 50 mg/25 ml solution injectable pour perfusion en flacon polypropylene" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009202863" ; OUTPUT ; 
code_ucd = 9202886 ; nom_court = "FLOLAN 1,5 mg poudre et solvant pour solution injectable" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009202886" ; OUTPUT ; 
code_ucd = 9202886 ; nom_court = "FLOLAN 1,5 mg poudre et solvant pour solution injectable" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009202886" ; OUTPUT ; 
code_ucd = 9203058 ; nom_court = "TEMODAL 100 mg gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009203058" ; OUTPUT ; 
code_ucd = 9203064 ; nom_court = "TEMODAL 20 mg gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009203064" ; OUTPUT ; 
code_ucd = 9203070 ; nom_court = "TEMODAL 250 mg gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009203070" ; OUTPUT ; 
code_ucd = 9203087 ; nom_court = "TEMODAL 5 mg gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009203087" ; OUTPUT ; 
code_ucd = 9203383 ; nom_court = "VIRAMUNE 50 mg/5 ml suspension buvable" ; cod_atc = "J05AG01" ; cod_ucd_chr = "0000009203383" ; OUTPUT ; 
code_ucd = 9203408 ; nom_court = "AMBISOME 50 mg poudre pour suspension de liposomes pour perfusion en flacon de 30 ml" ; cod_atc = "J02AA01" ; cod_ucd_chr = "0000009203408" ; OUTPUT ; 
code_ucd = 9203934 ; nom_court = "PIPERACILLINE MERCK 1 G Poudre injectable" ; cod_atc = "J01CA12" ; cod_ucd_chr = "0000009203934" ; OUTPUT ; 
code_ucd = 9203940 ; nom_court = "PIPERACILLINE MERCK 2 G Poudre injectable" ; cod_atc = "J01CA12" ; cod_ucd_chr = "0000009203940" ; OUTPUT ; 
code_ucd = 9203957 ; nom_court = "PIPERACILLINE MERCK 4 G Poudre injectable" ; cod_atc = "J01CA12" ; cod_ucd_chr = "0000009203957" ; OUTPUT ; 
code_ucd = 9205459 ; nom_court = "VINCRISTINE TEVA 1 MG/ML Solution injectable" ; cod_atc = "L01CA02" ; cod_ucd_chr = "0000009205459" ; OUTPUT ; 
code_ucd = 9206453 ; nom_court = "REVASC 15 MG Poudre et solvant pour solution injectable" ; cod_atc = "B01AE01" ; cod_ucd_chr = "0000009206453" ; OUTPUT ; 
code_ucd = 9206708 ; nom_court = "INTRONA 10 MUI/1 ml solution injectable ou perfusion" ; cod_atc = "L03AB05" ; cod_ucd_chr = "0000009206708" ; OUTPUT ; 
code_ucd = 9206714 ; nom_court = "INTRONA 18 MUI/1,2 ml solution injectable en stylo multidose + 12 sets d'injection" ; cod_atc = "L03AB05" ; cod_ucd_chr = "0000009206714" ; OUTPUT ; 
code_ucd = 9206737 ; nom_court = "INTRONA 30 M UI solution injectable en stylo multidose" ; cod_atc = "L03AB05" ; cod_ucd_chr = "0000009206737" ; OUTPUT ; 
code_ucd = 9206766 ; nom_court = "INTRONA 60 M UI solution injectable en stylo multidose" ; cod_atc = "L03AB05" ; cod_ucd_chr = "0000009206766" ; OUTPUT ; 
code_ucd = 9206921 ; nom_court = "THYROGEN 0,9 mg poudre pour solution injectable" ; cod_atc = "H01AB01" ; cod_ucd_chr = "0000009206921" ; OUTPUT ; 
code_ucd = 9206921 ; nom_court = "THYROGEN 0,9 mg poudre pour solution injectable" ; cod_atc = "H01AB01" ; cod_ucd_chr = "0000009206921" ; OUTPUT ; 
code_ucd = 9207719 ; nom_court = "EPREX 40 000 UI/ml solution injectable en flacon 1 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009207719" ; OUTPUT ; 
code_ucd = 9208245 ; nom_court = "CISPLATINE TEVA 1 mg/1 ml solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009208245" ; OUTPUT ; 
code_ucd = 9208251 ; nom_court = "CISPLATINE TEVA 1 mg/1 ml solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009208251" ; OUTPUT ; 
code_ucd = 9208268 ; nom_court = "CISPLATINE TEVA 1 mg/1 ml solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009208268" ; OUTPUT ; 
code_ucd = 9208280 ; nom_court = "ETOPOSIDE TEVA 20 mg/ml solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009208280" ; OUTPUT ; 
code_ucd = 9208297 ; nom_court = "ETOPOSIDE TEVA 20 mg/ml solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009208297" ; OUTPUT ; 
code_ucd = 9208570 ; nom_court = "REBETOL 200 mg gelules" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009208570" ; OUTPUT ; 
code_ucd = 9208593 ; nom_court = "AMIKACINE MERCK 50 MG/1 ML Solution injectable" ; cod_atc = "J01GB06" ; cod_ucd_chr = "0000009208593" ; OUTPUT ; 
code_ucd = 9208624 ; nom_court = "ZAVEDOS 10 mg gelule" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009208624" ; OUTPUT ; 
code_ucd = 9208630 ; nom_court = "ZAVEDOS 25 mg gelule" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009208630" ; OUTPUT ; 
code_ucd = 9208647 ; nom_court = "ZAVEDOS 5 mg gelule" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009208647" ; OUTPUT ; 
code_ucd = 9208914 ; nom_court = "VENOFER 100mg/5ml solution injectable (IV)" ; cod_atc = "B03AC02" ; cod_ucd_chr = "0000009208914" ; OUTPUT ; 
code_ucd = 9210213 ; nom_court = "CARBOPLATINE TEVA 10 mg/ml solution pour perfusion en flacon de 15 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009210213" ; OUTPUT ; 
code_ucd = 9210236 ; nom_court = "CARBOPLATINE TEVA 10 mg/ml solution pour perfusion en flacon de 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009210236" ; OUTPUT ; 
code_ucd = 9210242 ; nom_court = "CARBOPLATINE TEVA 10 mg/ml solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009210242" ; OUTPUT ; 
code_ucd = 9210845 ; nom_court = "VENTOLINE NEBULE 5 MG/1 ML Solution pour inhalation, flacon compte-gouttes de 10 ml" ; cod_atc = "R03AC02" ; cod_ucd_chr = "0000009210845" ; OUTPUT ; 
code_ucd = 9211359 ; nom_court = "ZIAGEN 300 mg comprime pellicule" ; cod_atc = "J05AF06" ; cod_ucd_chr = "0000009211359" ; OUTPUT ; 
code_ucd = 9211371 ; nom_court = "ACLOTINE 100 UI/ml 10 ml poudre et solvant pour solution injectable" ; cod_atc = "B01AB02" ; cod_ucd_chr = "0000009211371" ; OUTPUT ; 
code_ucd = 9211371 ; nom_court = "ACLOTINE 100 UI/ml 10 ml poudre et solvant pour solution injectable" ; cod_atc = "B01AB02" ; cod_ucd_chr = "0000009211371" ; OUTPUT ; 
code_ucd = 9211388 ; nom_court = "ACLOTINE 100 UI/ml 5 ml poudre et solvant pour solution injectable" ; cod_atc = "B01AB02" ; cod_ucd_chr = "0000009211388" ; OUTPUT ; 
code_ucd = 9211388 ; nom_court = "ACLOTINE 100 UI/ml 5 ml poudre et solvant pour solution injectable" ; cod_atc = "B01AB02" ; cod_ucd_chr = "0000009211388" ; OUTPUT ; 
code_ucd = 9211425 ; nom_court = "NORVIR 100 mg capsule molle" ; cod_atc = "J05AE03" ; cod_ucd_chr = "0000009211425" ; OUTPUT ; 
code_ucd = 9212011 ; nom_court = "SUSTIVA 100 mg gelule" ; cod_atc = "J05AG03" ; cod_ucd_chr = "0000009212011" ; OUTPUT ; 
code_ucd = 9212028 ; nom_court = "SUSTIVA 50 mg gelule" ; cod_atc = "J05AG03" ; cod_ucd_chr = "0000009212028" ; OUTPUT ; 
code_ucd = 9212264 ; nom_court = "GLIADEL 7,7 mg implant en sachet" ; cod_atc = "L01AD01" ; cod_ucd_chr = "0000009212264" ; OUTPUT ; 
code_ucd = 9212436 ; nom_court = "CEFOXITINE PANPHARMA 1 g poudre pour solution injectable (IV)" ; cod_atc = "J01DC01" ; cod_ucd_chr = "0000009212436" ; OUTPUT ; 
code_ucd = 9212442 ; nom_court = "CEFOXITINE PANPHARMA 2 g poudre pour solution injectable (IV)" ; cod_atc = "J01DC01" ; cod_ucd_chr = "0000009212442" ; OUTPUT ; 
code_ucd = 9212488 ; nom_court = "OCTAGAM 5 G/100 ML solution pour perfusion en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009212488" ; OUTPUT ; 
code_ucd = 9212488 ; nom_court = "OCTAGAM 5 G/100 ML solution pour perfusion en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009212488" ; OUTPUT ; 
code_ucd = 9212494 ; nom_court = "OCTAGAM 10 G/200 ML solution pour perfusion en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009212494" ; OUTPUT ; 
code_ucd = 9212494 ; nom_court = "OCTAGAM 10 G/200 ML solution pour perfusion en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009212494" ; OUTPUT ; 
code_ucd = 9212502 ; nom_court = "OCTAGAM 2,5 G/50 ML solution pour perfusion en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009212502" ; OUTPUT ; 
code_ucd = 9212502 ; nom_court = "OCTAGAM 2,5 G/50 ML solution pour perfusion en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009212502" ; OUTPUT ; 
code_ucd = 9212525 ; nom_court = "ZEFFIX 100 mg comprime pellicule" ; cod_atc = "J05AF05" ; cod_ucd_chr = "0000009212525" ; OUTPUT ; 
code_ucd = 9212531 ; nom_court = "ZEFFIX 5 mg/ml solution buvable en flacon de 240 ml" ; cod_atc = "J05AF05" ; cod_ucd_chr = "0000009212531" ; OUTPUT ; 
code_ucd = 9212548 ; nom_court = "ZIAGEN 20 mg/ml solution buvable" ; cod_atc = "J05AF06" ; cod_ucd_chr = "0000009212548" ; OUTPUT ; 
code_ucd = 9212956 ; nom_court = "MACROLIN 4,5 M UI poudre pour solution injectable" ; cod_atc = "L03AC01" ; cod_ucd_chr = "0000009212956" ; OUTPUT ; 
code_ucd = 9213737 ; nom_court = "REMICADE 100 mg poudre pour solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L04AB02" ; cod_ucd_chr = "0000009213737" ; OUTPUT ; 
code_ucd = 9213743 ; nom_court = "SYNAGIS 100 mg poudre et solvant pour solution injectable" ; cod_atc = "J06BB16" ; cod_ucd_chr = "0000009213743" ; OUTPUT ; 
code_ucd = 9213766 ; nom_court = "SYNAGIS 50 mg poudre et solvant pour solution injectable" ; cod_atc = "J06BB16" ; cod_ucd_chr = "0000009213766" ; OUTPUT ; 
code_ucd = 9216925 ; nom_court = "FLUOROURACILE DAKOTA 50 mg/ml solution a diluer pour perfusion en flacon de 100 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009216925" ; OUTPUT ; 
code_ucd = 9217362 ; nom_court = "VIDEX 125 mg gelule gastro-resistante" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009217362" ; OUTPUT ; 
code_ucd = 9217379 ; nom_court = "VIDEX 200 mg gelule gastro-resistante" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009217379" ; OUTPUT ; 
code_ucd = 9217385 ; nom_court = "VIDEX 250 mg gelules gastro-resistante" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009217385" ; OUTPUT ; 
code_ucd = 9217391 ; nom_court = "VIDEX 400 mg gelule gastro-resistante" ; cod_atc = "J05AF02" ; cod_ucd_chr = "0000009217391" ; OUTPUT ; 
code_ucd = 9217592 ; nom_court = "CISPLATINE MYLAN 10 MG/10 ML solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009217592" ; OUTPUT ; 
code_ucd = 9217600 ; nom_court = "CISPLATINE MYLAN 25 MG/25 ML solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009217600" ; OUTPUT ; 
code_ucd = 9217617 ; nom_court = "CISPLATINE MYLAN 1 MG/ML solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009217617" ; OUTPUT ; 
code_ucd = 9217741 ; nom_court = "SOLUMEDROL 1 G Poudre et solvant pour solution injectable" ; cod_atc = "H02AB04" ; cod_ucd_chr = "0000009217741" ; OUTPUT ; 
code_ucd = 9218203 ; nom_court = "CEFOTAXIME MERCK 1 G Poudre pour solution injectable" ; cod_atc = "J01DD01" ; cod_ucd_chr = "0000009218203" ; OUTPUT ; 
code_ucd = 9218226 ; nom_court = "CEFOTAXIME MERCK 2 G Poudre pour solution injectable" ; cod_atc = "J01DD01" ; cod_ucd_chr = "0000009218226" ; OUTPUT ; 
code_ucd = 9218232 ; nom_court = "CEFOTAXIME MERCK 500 MG Poudre pour solution injectable" ; cod_atc = "J01DD01" ; cod_ucd_chr = "0000009218232" ; OUTPUT ; 
code_ucd = 9218261 ; nom_court = "AMBISOME 50 mg poudre pour suspension de liposomes pour perfusion en flacon de 15 ml" ; cod_atc = "J02AA01" ; cod_ucd_chr = "0000009218261" ; OUTPUT ; 
code_ucd = 9218261 ; nom_court = "AMBISOME 50 mg poudre pour suspension de liposomes pour perfusion en flacon de 15 ml" ; cod_atc = "J02AA01" ; cod_ucd_chr = "0000009218261" ; OUTPUT ; 
code_ucd = 9218605 ; nom_court = "CARBOPLATINE MYLAN 10 MG/ML solution pour perfusion en flacon de 15 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009218605" ; OUTPUT ; 
code_ucd = 9218611 ; nom_court = "CARBOPLATINE MYLAN 10 MG/ML solution pour perfusion en flacon de 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009218611" ; OUTPUT ; 
code_ucd = 9218628 ; nom_court = "CARBOPLATINE MYLAN 10 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009218628" ; OUTPUT ; 
code_ucd = 9219390 ; nom_court = "ETHYOL 50 mg/ml poudre pour solution injectable en flacon de 375 mg" ; cod_atc = "V03AF05" ; cod_ucd_chr = "0000009219390" ; OUTPUT ; 
code_ucd = 9219390 ; nom_court = "ETHYOL 50 mg/ml poudre pour solution injectable en flacon de 375 mg" ; cod_atc = "V03AF05" ; cod_ucd_chr = "0000009219390" ; OUTPUT ; 
code_ucd = 9219467 ; nom_court = "TAXOL 6 mg/ml solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009219467" ; OUTPUT ; 
code_ucd = 9219740 ; nom_court = "CEREZYME 400 U poudre pour solution a diluer pour perfusion" ; cod_atc = "A16AB02" ; cod_ucd_chr = "0000009219740" ; OUTPUT ; 
code_ucd = 9219740 ; nom_court = "CEREZYME 400 U poudre pour solution a diluer pour perfusion" ; cod_atc = "A16AB02" ; cod_ucd_chr = "0000009219740" ; OUTPUT ; 
code_ucd = 9220097 ; nom_court = "HERCEPTIN 150 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "L01XC03" ; cod_ucd_chr = "0000009220097" ; OUTPUT ; 
code_ucd = 9220097 ; nom_court = "HERCEPTIN 150 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "L01XC03" ; cod_ucd_chr = "0000009220097" ; OUTPUT ; 
code_ucd = 9220275 ; nom_court = "CISPLATINE TEVA 1 mg/1 ml solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009220275" ; OUTPUT ; 
code_ucd = 9220306 ; nom_court = "FERRIPROX 500 mg comprime pellicule" ; cod_atc = "V03AC02" ; cod_ucd_chr = "0000009220306" ; OUTPUT ; 
code_ucd = 9220861 ; nom_court = "ROFERON-A 3 M UI/0,5 ml solution injectable en seringue preremplie de 0,5 ml" ; cod_atc = "L03AB04" ; cod_ucd_chr = "0000009220861" ; OUTPUT ; 
code_ucd = 9220878 ; nom_court = "ROFERON-A 4,5 M UI/0,5 ml solution injectable en seringue preremplie de 0,5 ml" ; cod_atc = "L03AB04" ; cod_ucd_chr = "0000009220878" ; OUTPUT ; 
code_ucd = 9220884 ; nom_court = "ROFERON-A 6 M UI/0,5 ml solution injectable en seringue preremplie de 0,5 ml" ; cod_atc = "L03AB04" ; cod_ucd_chr = "0000009220884" ; OUTPUT ; 
code_ucd = 9220890 ; nom_court = "ROFERON-A 9 M UI/0,5 ml solution injectable en seringue preremplie de 0,5 ml" ; cod_atc = "L03AB04" ; cod_ucd_chr = "0000009220890" ; OUTPUT ; 
code_ucd = 9221984 ; nom_court = "VIRAFERONPEG 100 mcg/0,5 ml poudre et solvant pour solution injectable" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009221984" ; OUTPUT ; 
code_ucd = 9221990 ; nom_court = "VIRAFERONPEG 120 mcg/0,5 ml poudre et solvant pour solution injectable" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009221990" ; OUTPUT ; 
code_ucd = 9222009 ; nom_court = "VIRAFERONPEG 150 mcg/0,5 ml poudre et solvant pour solution injectable" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009222009" ; OUTPUT ; 
code_ucd = 9222015 ; nom_court = "VIRAFERONPEG 50 mcg/0,5 ml poudre et solvant pour solution injectable" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009222015" ; OUTPUT ; 
code_ucd = 9222021 ; nom_court = "VIRAFERONPEG 80 mcg/0,5 ml poudre et solvant pour solution injectable" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009222021" ; OUTPUT ; 
code_ucd = 9222222 ; nom_court = "AMIKACINE MERCK 1 G Poudre pour solution injectable" ; cod_atc = "J01GB06" ; cod_ucd_chr = "0000009222222" ; OUTPUT ; 
code_ucd = 9222647 ; nom_court = "DOXORUBICINE CHLORHYDRATE TEVA 0,2 P. 100 (10 mg/5 ml) solution injectable en flacon" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009222647" ; OUTPUT ; 
code_ucd = 9222676 ; nom_court = "DOXORUBICINE CHLORHYDRATE TEVA 0,2 P. 100 (200 mg/100 ml) solution injectable en flacon" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009222676" ; OUTPUT ; 
code_ucd = 9222682 ; nom_court = "DOXORUBICINE CHLORHYDRATE TEVA 0,2 P. 100 (50 mg/25 ml) solution injectable en flacon" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009222682" ; OUTPUT ; 
code_ucd = 9223078 ; nom_court = "DEXAMETHASONE MERCK 20 MG/5 ML Solution injectable en ampoule" ; cod_atc = "H02AB02" ; cod_ucd_chr = "0000009223078" ; OUTPUT ; 
code_ucd = 9223084 ; nom_court = "DEXAMETHASONE MERCK 4 MG/1 ML Solution injectable en ampoule" ; cod_atc = "H02AB02" ; cod_ucd_chr = "0000009223084" ; OUTPUT ; 
code_ucd = 9223109 ; nom_court = "NALOXONE MERCK 0,4 MG/ML Solution injectable en ampoule" ; cod_atc = "V03AB15" ; cod_ucd_chr = "0000009223109" ; OUTPUT ; 
code_ucd = 9223730 ; nom_court = "VIRACEPT 250 mg comprime pellicule" ; cod_atc = "J05AE04" ; cod_ucd_chr = "0000009223730" ; OUTPUT ; 
code_ucd = 9224698 ; nom_court = "ETOPOSIDE MYLAN 20 MG/ML solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009224698" ; OUTPUT ; 
code_ucd = 9224758 ; nom_court = "KOGENATE BAYER 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224758" ; OUTPUT ; 
code_ucd = 9224758 ; nom_court = "KOGENATE BAYER 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224758" ; OUTPUT ; 
code_ucd = 9224764 ; nom_court = "KOGENATE BAYER 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224764" ; OUTPUT ; 
code_ucd = 9224764 ; nom_court = "KOGENATE BAYER 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224764" ; OUTPUT ; 
code_ucd = 9224770 ; nom_court = "KOGENATE BAYER 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224770" ; OUTPUT ; 
code_ucd = 9224770 ; nom_court = "KOGENATE BAYER 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224770" ; OUTPUT ; 
code_ucd = 9224971 ; nom_court = "HELIXATE NEXGEN 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224971" ; OUTPUT ; 
code_ucd = 9224971 ; nom_court = "HELIXATE NEXGEN 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224971" ; OUTPUT ; 
code_ucd = 9224988 ; nom_court = "HELIXATE NEXGEN 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224988" ; OUTPUT ; 
code_ucd = 9224988 ; nom_court = "HELIXATE NEXGEN 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224988" ; OUTPUT ; 
code_ucd = 9224994 ; nom_court = "HELIXATE NEXGEN 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224994" ; OUTPUT ; 
code_ucd = 9224994 ; nom_court = "HELIXATE NEXGEN 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009224994" ; OUTPUT ; 
code_ucd = 9225901 ; nom_court = "TRIZIVIR comprime pellicule" ; cod_atc = "J05AR04" ; cod_ucd_chr = "0000009225901" ; OUTPUT ; 
code_ucd = 9225918 ; nom_court = "FACTANE 100 UI/ml poudre et solvant pour solution injectable (10 ml)" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009225918" ; OUTPUT ; 
code_ucd = 9225918 ; nom_court = "FACTANE 100 UI/ml poudre et solvant pour solution injectable (10 ml)" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009225918" ; OUTPUT ; 
code_ucd = 9225924 ; nom_court = "FACTANE 100 UI/ml poudre et solvant pour solution injectable (2,5 ml)" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009225924" ; OUTPUT ; 
code_ucd = 9225924 ; nom_court = "FACTANE 100 UI/ml poudre et solvant pour solution injectable (2,5 ml)" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009225924" ; OUTPUT ; 
code_ucd = 9225930 ; nom_court = "FACTANE 100 UI/ml poudre et solvant pour solution injectable (5 ml)" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009225930" ; OUTPUT ; 
code_ucd = 9225930 ; nom_court = "FACTANE 100 UI/ml poudre et solvant pour solution injectable (5 ml)" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009225930" ; OUTPUT ; 
code_ucd = 9226303 ; nom_court = "EPREX 10 000 UI/ml solution injectable en seringue pre-remplie 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009226303" ; OUTPUT ; 
code_ucd = 9226326 ; nom_court = "EPREX 10 000 UI/ml solution injectable en seringue pre-remplie 0,6 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009226326" ; OUTPUT ; 
code_ucd = 9226332 ; nom_court = "EPREX 10 000 UI/ml solution injectable en seringue pre-remplie 0,7 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009226332" ; OUTPUT ; 
code_ucd = 9226349 ; nom_court = "EPREX 10 000 UI/ml solution injectable en seringue pre-remplie 0,8 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009226349" ; OUTPUT ; 
code_ucd = 9226355 ; nom_court = "EPREX 10 000 UI/ml solution injectable en seringue pre-remplie 0,9 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009226355" ; OUTPUT ; 
code_ucd = 9226473 ; nom_court = "CEFALOTINE MERCK 1 G Poudre pour solution injectable" ; cod_atc = "J01DB03" ; cod_ucd_chr = "0000009226473" ; OUTPUT ; 
code_ucd = 9226496 ; nom_court = "CEFAZOLINE MERCK 1 G Poudre pour solution injectable" ; cod_atc = "J01DB04" ; cod_ucd_chr = "0000009226496" ; OUTPUT ; 
code_ucd = 9226562 ; nom_court = "CISPLATINE MYLAN 10 MG/20 ML solution pour perfusion en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009226562" ; OUTPUT ; 
code_ucd = 9226585 ; nom_court = "CISPLATINE MYLAN 25 MG/50 ML solution pour perfusion en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009226585" ; OUTPUT ; 
code_ucd = 9226616 ; nom_court = "CISPLATINE MYLAN 50 MG/100 ML solution pour perfusion en flacon" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009226616" ; OUTPUT ; 
code_ucd = 9226763 ; nom_court = "METHYLPREDNISOLONE MERCK 120 MG Poudre pour solution injectable" ; cod_atc = "H02AB04" ; cod_ucd_chr = "0000009226763" ; OUTPUT ; 
code_ucd = 9226786 ; nom_court = "METHYLPREDNISOLONE MERCK 20 MG Poudre pour solution en flacon" ; cod_atc = "H02AB04" ; cod_ucd_chr = "0000009226786" ; OUTPUT ; 
code_ucd = 9226792 ; nom_court = "METHYLPREDNISOLONE MERCK 40 MG Poudre pour solution injectable" ; cod_atc = "H02AB04" ; cod_ucd_chr = "0000009226792" ; OUTPUT ; 
code_ucd = 9226852 ; nom_court = "NALBUPHINE MERCK 20 MG/2 ML Solution injectable en ampoule" ; cod_atc = "N02AF02" ; cod_ucd_chr = "0000009226852" ; OUTPUT ; 
code_ucd = 9226929 ; nom_court = "TOBRAMYCINE MERCK 25 MG/2,5 ML Solution injectable" ; cod_atc = "J01GB01" ; cod_ucd_chr = "0000009226929" ; OUTPUT ; 
code_ucd = 9226935 ; nom_court = "TOBRAMYCINE MERCK 75 MG/1,5 ML Solution injectable" ; cod_atc = "J01GB01" ; cod_ucd_chr = "0000009226935" ; OUTPUT ; 
code_ucd = 9226941 ; nom_court = "TRIFLUCAN 2 mg/ml solution pour perfusion en flacon de 200 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009226941" ; OUTPUT ; 
code_ucd = 9226970 ; nom_court = "VANCOMYCINE MYLAN 125 MG poudre pour solution pour perfusion (IV)" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009226970" ; OUTPUT ; 
code_ucd = 9226987 ; nom_court = "VANCOMYCINE MYLAN 250 MG poudre pour solution pour perfusion (IV)" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009226987" ; OUTPUT ; 
code_ucd = 9227573 ; nom_court = "INSUPLANT 400 UI/ml 1 Flacon de 10 ml, solution pour perfusion" ; cod_atc = "A10AB01" ; cod_ucd_chr = "0000009227573" ; OUTPUT ; 
code_ucd = 9227679 ; nom_court = "CEFTRIAXONE MERCK 2 G Poudre pour solution injectable IV" ; cod_atc = "J01DD04" ; cod_ucd_chr = "0000009227679" ; OUTPUT ; 
code_ucd = 9227685 ; nom_court = "FLUOROURACILE MYLAN 50 MG/ML solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009227685" ; OUTPUT ; 
code_ucd = 9227691 ; nom_court = "FLUOROURACILE MYLAN 50 MG/ML solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009227691" ; OUTPUT ; 
code_ucd = 9227716 ; nom_court = "FLUOROURACILE MYLAN 50 MG/ML solution pour perfusion en flacon de 20 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009227716" ; OUTPUT ; 
code_ucd = 9227722 ; nom_court = "FLUOROURACILE MYLAN 50 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009227722" ; OUTPUT ; 
code_ucd = 9227900 ; nom_court = "NEORECORMON 4000 UI/0,3 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009227900" ; OUTPUT ; 
code_ucd = 9227917 ; nom_court = "NEORECORMON 6000 UI/0,3 ml solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009227917" ; OUTPUT ; 
code_ucd = 9227923 ; nom_court = "NEORECORMON 60 000 UI poudre et solvant pour solution injectable en cartouche" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009227923" ; OUTPUT ; 
code_ucd = 9228555 ; nom_court = "PAXENE 6 mg/ml solution a diluer pour perfusion en flacon 25 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009228555" ; OUTPUT ; 
code_ucd = 9228561 ; nom_court = "PAXENE 6 mg/ml solution a diluer pour perfusion en flacon 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009228561" ; OUTPUT ; 
code_ucd = 9229141 ; nom_court = "KALETRA capsule molle" ; cod_atc = "J05AE06" ; cod_ucd_chr = "0000009229141" ; OUTPUT ; 
code_ucd = 9229158 ; nom_court = "KALETRA solution buvable en flacon de 60 ml" ; cod_atc = "J05AR10" ; cod_ucd_chr = "0000009229158" ; OUTPUT ; 
code_ucd = 9229483 ; nom_court = "CAELYX 2 mg/ml Solution a diluer pour perfusion, flacon de 25 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009229483" ; OUTPUT ; 
code_ucd = 9229483 ; nom_court = "CAELYX 2 mg/ml Solution a diluer pour perfusion, flacon de 25 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009229483" ; OUTPUT ; 
code_ucd = 9231592 ; nom_court = "PROPYLTHIOURACILE AP-HP 50 mg comprime" ; cod_atc = "H03BA02" ; cod_ucd_chr = "0000009231592" ; OUTPUT ; 
code_ucd = 9231669 ; nom_court = "OCTAGAM 1 G/20 ML solution pour perfusion en flacon de 20 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009231669" ; OUTPUT ; 
code_ucd = 9231669 ; nom_court = "OCTAGAM 1 G/20 ML solution pour perfusion en flacon de 20 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009231669" ; OUTPUT ; 
code_ucd = 9231735 ; nom_court = "CEFTRIAXONE AGUETTANT 2 G Poudre pour solution pour perfusion" ; cod_atc = "J01DD04" ; cod_ucd_chr = "0000009231735" ; OUTPUT ; 
code_ucd = 9231818 ; nom_court = "CEPROTIN 1000 UI/10 ML poudre et solvant pour solution injectable" ; cod_atc = "B01AD12" ; cod_ucd_chr = "0000009231818" ; OUTPUT ; 
code_ucd = 9231818 ; nom_court = "CEPROTIN 1000 UI/10 ML poudre et solvant pour solution injectable" ; cod_atc = "B01AD12" ; cod_ucd_chr = "0000009231818" ; OUTPUT ; 
code_ucd = 9231824 ; nom_court = "CEPROTIN 500 UI/5 ML poudre et solvant pour solution injectable" ; cod_atc = "B01AD12" ; cod_ucd_chr = "0000009231824" ; OUTPUT ; 
code_ucd = 9231824 ; nom_court = "CEPROTIN 500 UI/5 ML poudre et solvant pour solution injectable" ; cod_atc = "B01AD12" ; cod_ucd_chr = "0000009231824" ; OUTPUT ; 
code_ucd = 9232120 ; nom_court = "BETAFACT 50 UI/ml poudre et solvant pour solution injectable (10 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009232120" ; OUTPUT ; 
code_ucd = 9232120 ; nom_court = "BETAFACT 50 UI/ml poudre et solvant pour solution injectable (10 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009232120" ; OUTPUT ; 
code_ucd = 9232137 ; nom_court = "BETAFACT 50 UI/ml poudre et solvant pour solution injectable (20 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009232137" ; OUTPUT ; 
code_ucd = 9232137 ; nom_court = "BETAFACT 50 UI/ml poudre et solvant pour solution injectable (20 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009232137" ; OUTPUT ; 
code_ucd = 9232143 ; nom_court = "BETAFACT 50 UI/ml poudre et solvant pour solution injectable (5 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009232143" ; OUTPUT ; 
code_ucd = 9232143 ; nom_court = "BETAFACT 50 UI/ml poudre et solvant pour solution injectable (5 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009232143" ; OUTPUT ; 
code_ucd = 9232309 ; nom_court = "AMMONAPS 500 mg comprime" ; cod_atc = "A16AX03" ; cod_ucd_chr = "0000009232309" ; OUTPUT ; 
code_ucd = 9232309 ; nom_court = "AMMONAPS 500 mg comprime" ; cod_atc = "A16AX03" ; cod_ucd_chr = "0000009232309" ; OUTPUT ; 
code_ucd = 9232315 ; nom_court = "AMMONAPS 940 mg/g granule en flacon de 266 g" ; cod_atc = "A16AX03" ; cod_ucd_chr = "0000009232315" ; OUTPUT ; 
code_ucd = 9232315 ; nom_court = "AMMONAPS 940 mg/g granule en flacon de 266 g" ; cod_atc = "A16AX03" ; cod_ucd_chr = "0000009232315" ; OUTPUT ; 
code_ucd = 9233208 ; nom_court = "IVHEBEX 5000 UI/100 ml poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BB04" ; cod_ucd_chr = "0000009233208" ; OUTPUT ; 
code_ucd = 9233208 ; nom_court = "IVHEBEX 5000 UI/100 ml poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BB04" ; cod_ucd_chr = "0000009233208" ; OUTPUT ; 
code_ucd = 9233214 ; nom_court = "PROLEUKIN 18 MILLIONS UI poudre pour solution injectable" ; cod_atc = "L03AC01" ; cod_ucd_chr = "0000009233214" ; OUTPUT ; 
code_ucd = 9233214 ; nom_court = "PROLEUKIN 18 MILLIONS UI poudre pour solution injectable" ; cod_atc = "L03AC01" ; cod_ucd_chr = "0000009233214" ; OUTPUT ; 
code_ucd = 9233220 ; nom_court = "PROLEUKIN 18 M UI poudre pour solution pour perfusion" ; cod_atc = "L03AC01" ; cod_ucd_chr = "0000009233220" ; OUTPUT ; 
code_ucd = 9233237 ; nom_court = "ARANESP 10 mcg solution injectable en seringue preremplie 0,4 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233237" ; OUTPUT ; 
code_ucd = 9233243 ; nom_court = "ARANESP 100 mcg solution injectable en seringue pre-remplie 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233243" ; OUTPUT ; 
code_ucd = 9233266 ; nom_court = "ARANESP 15 mcg solution injectable en flacon 1 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233266" ; OUTPUT ; 
code_ucd = 9233272 ; nom_court = "ARANESP 15 mcg solution injectable en seringue pre-remplie 0,375 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233272" ; OUTPUT ; 
code_ucd = 9233289 ; nom_court = "ARANESP 150 mcg solution injectable en seringue pre-remplie 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233289" ; OUTPUT ; 
code_ucd = 9233295 ; nom_court = "ARANESP 20 mcg solution injectable en seringue pre-remplie 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233295" ; OUTPUT ; 
code_ucd = 9233303 ; nom_court = "ARANESP 25 mcg solution injectable en flacon 1 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233303" ; OUTPUT ; 
code_ucd = 9233326 ; nom_court = "ARANESP 30 mcg solution injectable en seringue pre-remplie 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233326" ; OUTPUT ; 
code_ucd = 9233332 ; nom_court = "ARANESP 300 mcg solution injectable en seringue pre-remplie 0,6 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233332" ; OUTPUT ; 
code_ucd = 9233349 ; nom_court = "ARANESP 40 mcg solution injectable en flacon 1 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233349" ; OUTPUT ; 
code_ucd = 9233355 ; nom_court = "ARANESP 40 mcg solution injectable en seringue pre-remplie 0,4 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233355" ; OUTPUT ; 
code_ucd = 9233361 ; nom_court = "ARANESP 50 mcg solution injectable en seringue pre-remplie 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233361" ; OUTPUT ; 
code_ucd = 9233378 ; nom_court = "ARANESP 60 mcg solution injectable en flacon 1 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233378" ; OUTPUT ; 
code_ucd = 9233384 ; nom_court = "ARANESP 60 mcg solution injectable en seringue pre-remplie 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233384" ; OUTPUT ; 
code_ucd = 9233390 ; nom_court = "ARANESP 80 mcg solution injectable en seringue pre-remplie 0,4 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009233390" ; OUTPUT ; 
code_ucd = 9233473 ; nom_court = "METHOTREXATE MERCK 2,5 MG/ML Solution injectable" ; cod_atc = "L01BA01" ; cod_ucd_chr = "0000009233473" ; OUTPUT ; 
code_ucd = 9233527 ; nom_court = "ZYVOXID 2 mg/ml solution pour perfusion en poche de 300 ml" ; cod_atc = "J01XX08" ; cod_ucd_chr = "0000009233527" ; OUTPUT ; 
code_ucd = 9233533 ; nom_court = "ZYVOXID 600 mg comprime pellicule" ; cod_atc = "J01XX08" ; cod_ucd_chr = "0000009233533" ; OUTPUT ; 
code_ucd = 9233622 ; nom_court = "METHOTREXATE MERCK 50 MG/2 ML Solution injectable" ; cod_atc = "L01BA01" ; cod_ucd_chr = "0000009233622" ; OUTPUT ; 
code_ucd = 9233680 ; nom_court = "BEROMUN 1 mg/5 ml poudre et solvant pour solution pour perfusion" ; cod_atc = "L03AX11" ; cod_ucd_chr = "0000009233680" ; OUTPUT ; 
code_ucd = 9233697 ; nom_court = "MYOCET 50 mg Poudre et pre-melanges pour solution a diluer pour dispersion liposomale pour perfusion en flacons" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009233697" ; OUTPUT ; 
code_ucd = 9233697 ; nom_court = "MYOCET 50 mg Poudre et pre-melanges pour solution a diluer pour dispersion liposomale pour perfusion en flacons" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009233697" ; OUTPUT ; 
code_ucd = 9233728 ; nom_court = "TARGRETIN 75 MG Capsule molle" ; cod_atc = "L01XX25" ; cod_ucd_chr = "0000009233728" ; OUTPUT ; 
code_ucd = 9234047 ; nom_court = "PROTEXEL 50 UI/ml poudre et solvant pour solution injectable" ; cod_atc = "B01AD12" ; cod_ucd_chr = "0000009234047" ; OUTPUT ; 
code_ucd = 9234047 ; nom_court = "PROTEXEL 50 UI/ml poudre et solvant pour solution injectable" ; cod_atc = "B01AD12" ; cod_ucd_chr = "0000009234047" ; OUTPUT ; 
code_ucd = 9234053 ; nom_court = "CARBAGLU 200 mg comprime dispersible" ; cod_atc = "A16AA05" ; cod_ucd_chr = "0000009234053" ; OUTPUT ; 
code_ucd = 9234053 ; nom_court = "CARBAGLU 200 mg comprime dispersible" ; cod_atc = "A16AA05" ; cod_ucd_chr = "0000009234053" ; OUTPUT ; 
code_ucd = 9234225 ; nom_court = "ENDOBULINE 5 g poudre et solvant pour solution injectable en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009234225" ; OUTPUT ; 
code_ucd = 9234248 ; nom_court = "ENDOBULINE 10 g poudre et solvant pour solution injectable en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009234248" ; OUTPUT ; 
code_ucd = 9234254 ; nom_court = "ENDOBULINE 2,5 g poudre et solvant pour solution injectable en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009234254" ; OUTPUT ; 
code_ucd = 9235058 ; nom_court = "FABRAZYME 35 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "A16AB04" ; cod_ucd_chr = "0000009235058" ; OUTPUT ; 
code_ucd = 9235058 ; nom_court = "FABRAZYME 35 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "A16AB04" ; cod_ucd_chr = "0000009235058" ; OUTPUT ; 
code_ucd = 9235176 ; nom_court = "THALIDOMIDE LAPHAL 100 mg gelule" ; cod_atc = "L04AX02" ; cod_ucd_chr = "0000009235176" ; OUTPUT ; 
code_ucd = 9236247 ; nom_court = "VIREAD 245 mg comprime pellicule" ; cod_atc = "J05AF07" ; cod_ucd_chr = "0000009236247" ; OUTPUT ; 
code_ucd = 9236388 ; nom_court = "MABCAMPATH 10 mg/ml solution a diluer pour perfusion en ampoule de 5 ml" ; cod_atc = "L01XC04" ; cod_ucd_chr = "0000009236388" ; OUTPUT ; 
code_ucd = 9236388 ; nom_court = "MABCAMPATH 10 mg/ml solution a diluer pour perfusion en ampoule de 5 ml" ; cod_atc = "L01XC04" ; cod_ucd_chr = "0000009236388" ; OUTPUT ; 
code_ucd = 9236891 ; nom_court = "CRIXIVAN 100 mg gelule" ; cod_atc = "J05AE02" ; cod_ucd_chr = "0000009236891" ; OUTPUT ; 
code_ucd = 9238281 ; nom_court = "CEFAZOLINE MERCK 2 G Poudre pour solution injectable" ; cod_atc = "J01DB04" ; cod_ucd_chr = "0000009238281" ; OUTPUT ; 
code_ucd = 9238861 ; nom_court = "REPLAGAL 1 mg/ml solution a diluer pour perfusion en flacon de 3,5 ml" ; cod_atc = "A16AB03" ; cod_ucd_chr = "0000009238861" ; OUTPUT ; 
code_ucd = 9238861 ; nom_court = "REPLAGAL 1 mg/ml solution a diluer pour perfusion en flacon de 3,5 ml" ; cod_atc = "A16AB03" ; cod_ucd_chr = "0000009238861" ; OUTPUT ; 
code_ucd = 9239116 ; nom_court = "FASTURTEC 1,5 mg/ml poudre et solvant pour solution a diluer pour perfusion en flacon de 1,5mg + ampoule de 1 ml" ; cod_atc = "V03AF07" ; cod_ucd_chr = "0000009239116" ; OUTPUT ; 
code_ucd = 9239116 ; nom_court = "FASTURTEC 1,5 mg/ml poudre et solvant pour solution a diluer pour perfusion en flacon de 1,5mg + ampoule de 1 ml" ; cod_atc = "V03AF07" ; cod_ucd_chr = "0000009239116" ; OUTPUT ; 
code_ucd = 9239145 ; nom_court = "CARBOPLATINE WINTHROP 10 MG/ML solution pour perfusion en flacon de 15 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009239145" ; OUTPUT ; 
code_ucd = 9239151 ; nom_court = "CARBOPLATINE WINTHROP 10 MG/ML solution pour perfusion en flacon de 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009239151" ; OUTPUT ; 
code_ucd = 9239168 ; nom_court = "CARBOPLATINE WINTHROP 10 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009239168" ; OUTPUT ; 
code_ucd = 9239228 ; nom_court = "EPIVIR 300 mg comprime pellicule" ; cod_atc = "J05AF05" ; cod_ucd_chr = "0000009239228" ; OUTPUT ; 
code_ucd = 9239381 ; nom_court = "FASTURTEC 1,5 mg/ml poudre et solvant pour solution a diluer pour perfusion en flacon de 7,5 mg + ampoule de 5 ml" ; cod_atc = "V03AF07" ; cod_ucd_chr = "0000009239381" ; OUTPUT ; 
code_ucd = 9239381 ; nom_court = "FASTURTEC 1,5 mg/ml poudre et solvant pour solution a diluer pour perfusion en flacon de 7,5 mg + ampoule de 5 ml" ; cod_atc = "V03AF07" ; cod_ucd_chr = "0000009239381" ; OUTPUT ; 
code_ucd = 9239429 ; nom_court = "SALBUTAMOL MERCK 5 MG/5 ML Solution pour perfusion" ; cod_atc = "R03AC02" ; cod_ucd_chr = "0000009239429" ; OUTPUT ; 
code_ucd = 9239501 ; nom_court = "CYSTADANE 1 G 1 Flacon de 180 g, poudre orale" ; cod_atc = "A16AA06" ; cod_ucd_chr = "0000009239501" ; OUTPUT ; 
code_ucd = 9239671 ; nom_court = "CISPLATINE DAKOTA PHARM 1 mg/ml solution injectable en flacon de 25 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009239671" ; OUTPUT ; 
code_ucd = 9239754 ; nom_court = "PANRETIN 0,1 P. 100 gel en tube de 60 g" ; cod_atc = "L01XX22" ; cod_ucd_chr = "0000009239754" ; OUTPUT ; 
code_ucd = 9240013 ; nom_court = "TRACLEER 125 mg comprime pellicule" ; cod_atc = "C02KX01" ; cod_ucd_chr = "0000009240013" ; OUTPUT ; 
code_ucd = 9240036 ; nom_court = "TRACLEER 62,5 mg comprime pellicule" ; cod_atc = "C02KX01" ; cod_ucd_chr = "0000009240036" ; OUTPUT ; 
code_ucd = 9240125 ; nom_court = "VFEND 200 mg poudre pour solution pour perfusion" ; cod_atc = "J02AC03" ; cod_ucd_chr = "0000009240125" ; OUTPUT ; 
code_ucd = 9240125 ; nom_court = "VFEND 200 mg poudre pour solution pour perfusion" ; cod_atc = "J02AC03" ; cod_ucd_chr = "0000009240125" ; OUTPUT ; 
code_ucd = 9240131 ; nom_court = "VFEND 200 mg comprime pellicule" ; cod_atc = "J02AC03" ; cod_ucd_chr = "0000009240131" ; OUTPUT ; 
code_ucd = 9240148 ; nom_court = "VFEND 50 mg comprime pellicule" ; cod_atc = "J02AC03" ; cod_ucd_chr = "0000009240148" ; OUTPUT ; 
code_ucd = 9240562 ; nom_court = "SUSTIVA 600 mg comprime pellicule" ; cod_atc = "J05AG03" ; cod_ucd_chr = "0000009240562" ; OUTPUT ; 
code_ucd = 9240740 ; nom_court = "CISPLATINE MYLAN 1 MG/ML solution a diluer pour perfusion en flacon de 100 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009240740" ; OUTPUT ; 
code_ucd = 9241047 ; nom_court = "PEGASYS 135 mcg solution injectable en seringue preremplie de 0,5 ml + 1 aiguille" ; cod_atc = "L03AB11" ; cod_ucd_chr = "0000009241047" ; OUTPUT ; 
code_ucd = 9241076 ; nom_court = "PEGASYS 180 mcg solution injectable en seringue preremplie de 0,5 ml + 1 aiguille" ; cod_atc = "L03AB11" ; cod_ucd_chr = "0000009241076" ; OUTPUT ; 
code_ucd = 9241082 ; nom_court = "SUSTIVA 30 mg/ml solution buvable" ; cod_atc = "J05AG03" ; cod_ucd_chr = "0000009241082" ; OUTPUT ; 
code_ucd = 9241159 ; nom_court = "CARBOPLATINE MYLAN 10 MG/ML solution pour perfusion en flacon de 60 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009241159" ; OUTPUT ; 
code_ucd = 9241604 ; nom_court = "XIGRIS 5mg poudre pour solution pour perfusion" ; cod_atc = "B01AD10" ; cod_ucd_chr = "0000009241604" ; OUTPUT ; 
code_ucd = 9241863 ; nom_court = "VIRAFERONPEG 100 mcg poudre et solvant pour solution injectable en stylo prerempli" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009241863" ; OUTPUT ; 
code_ucd = 9241886 ; nom_court = "VIRAFERONPEG 120 mcg poudre et solvant pour solution injectable en stylo prerempli" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009241886" ; OUTPUT ; 
code_ucd = 9241892 ; nom_court = "VIRAFERONPEG 150 mcg poudre et solvant pour solution injectable en stylo prerempli" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009241892" ; OUTPUT ; 
code_ucd = 9241900 ; nom_court = "VIRAFERONPEG 50 mcg poudre et solvant pour solution injectable en stylo prerempli" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009241900" ; OUTPUT ; 
code_ucd = 9241917 ; nom_court = "VIRAFERONPEG 80 mcg poudre et solvant pour solution injectable en stylo prerempli" ; cod_atc = "L03AB10" ; cod_ucd_chr = "0000009241917" ; OUTPUT ; 
code_ucd = 9242348 ; nom_court = "XIGRIS 20 mg poudre pour solution pour perfusion" ; cod_atc = "B01AD10" ; cod_ucd_chr = "0000009242348" ; OUTPUT ; 
code_ucd = 9242615 ; nom_court = "ENBREL 25 mg poudre et solvant pour solution injectable" ; cod_atc = "L04AB01" ; cod_ucd_chr = "0000009242615" ; OUTPUT ; 
code_ucd = 9242650 ; nom_court = "CERUBIDINE 20 mg poudre pour solution pour perfusion" ; cod_atc = "L01DB02" ; cod_ucd_chr = "0000009242650" ; OUTPUT ; 
code_ucd = 9242911 ; nom_court = "TRISENOX 1 mg/ml solution a diluer pour perfusion" ; cod_atc = "L01XX27" ; cod_ucd_chr = "0000009242911" ; OUTPUT ; 
code_ucd = 9246524 ; nom_court = "CARBOPLATINE ARROW 10 mg/ml solution pour perfusion en flacon 15 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009246524" ; OUTPUT ; 
code_ucd = 9246530 ; nom_court = "CARBOPLATINE ARROW 10 mg/ml solution pour perfusion en flacon 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009246530" ; OUTPUT ; 
code_ucd = 9246547 ; nom_court = "CARBOPLATINE ARROW 10 mg/ml solution pour perfusion en flacon 5 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009246547" ; OUTPUT ; 
code_ucd = 9246553 ; nom_court = "CARBOPLATINE ARROW 10 mg/ml solution pour perfusion en flacon 60 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009246553" ; OUTPUT ; 
code_ucd = 9246642 ; nom_court = "HEPSERA 10 mg comprime" ; cod_atc = "J05AF08" ; cod_ucd_chr = "0000009246642" ; OUTPUT ; 
code_ucd = 9246725 ; nom_court = "ZAVESCA 100 mg gelule" ; cod_atc = "A16AX06" ; cod_ucd_chr = "0000009246725" ; OUTPUT ; 
code_ucd = 9246725 ; nom_court = "ZAVESCA 100 mg gelule" ; cod_atc = "A16AX06" ; cod_ucd_chr = "0000009246725" ; OUTPUT ; 
code_ucd = 9247191 ; nom_court = "FLUOROURACILE ARROW 50 mg/ml solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009247191" ; OUTPUT ; 
code_ucd = 9247216 ; nom_court = "FLUOROURACILE ARROW 50 mg/ml solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009247216" ; OUTPUT ; 
code_ucd = 9247222 ; nom_court = "FLUOROURACILE ARROW 50 mg/ml solution pour perfusion en flacon de 20 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009247222" ; OUTPUT ; 
code_ucd = 9247239 ; nom_court = "FLUOROURACILE ARROW 50 mg/ml solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009247239" ; OUTPUT ; 
code_ucd = 9247357 ; nom_court = "FUZEON 90 mg/ml poudre et solvant pour solution injectable" ; cod_atc = "J05AX07" ; cod_ucd_chr = "0000009247357" ; OUTPUT ; 
code_ucd = 9247682 ; nom_court = "NALBUPHINE AGUETTANT 20 MG/2 ML Solution injectable en ampoule" ; cod_atc = "N02AF02" ; cod_ucd_chr = "0000009247682" ; OUTPUT ; 
code_ucd = 9248144 ; nom_court = "OCTAFIX 100 UI/ml poudre et solvant pour solution injectable en flacon de 10 ml" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009248144" ; OUTPUT ; 
code_ucd = 9248144 ; nom_court = "OCTAFIX 100 UI/ml poudre et solvant pour solution injectable en flacon de 10 ml" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009248144" ; OUTPUT ; 
code_ucd = 9248150 ; nom_court = "OCTAFIX 100 UI/ml poudre et solvant pour solution injectable en flacon de 5 ml" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009248150" ; OUTPUT ; 
code_ucd = 9248150 ; nom_court = "OCTAFIX 100 UI/ml poudre et solvant pour solution injectable en flacon de 5 ml" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009248150" ; OUTPUT ; 
code_ucd = 9249089 ; nom_court = "CANCIDAS 50 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "J02AX04" ; cod_ucd_chr = "0000009249089" ; OUTPUT ; 
code_ucd = 9249089 ; nom_court = "CANCIDAS 50 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "J02AX04" ; cod_ucd_chr = "0000009249089" ; OUTPUT ; 
code_ucd = 9249095 ; nom_court = "CANCIDAS 50 mg Poudre pour solution pour perfusion + 1 systeme de transfert" ; cod_atc = "J02AX04" ; cod_ucd_chr = "0000009249095" ; OUTPUT ; 
code_ucd = 9249103 ; nom_court = "CANCIDAS 70 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "J02AX04" ; cod_ucd_chr = "0000009249103" ; OUTPUT ; 
code_ucd = 9249103 ; nom_court = "CANCIDAS 70 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "J02AX04" ; cod_ucd_chr = "0000009249103" ; OUTPUT ; 
code_ucd = 9249907 ; nom_court = "ALDURAZYME 100 U/ml solution pour perfusion" ; cod_atc = "A16AB05" ; cod_ucd_chr = "0000009249907" ; OUTPUT ; 
code_ucd = 9250187 ; nom_court = "COPEGUS 200 mg comprime pellicule" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009250187" ; OUTPUT ; 
code_ucd = 9250572 ; nom_court = "INVANZ 1 g poudre pour solution a diluer pour perfusion" ; cod_atc = "J01DH03" ; cod_ucd_chr = "0000009250572" ; OUTPUT ; 
code_ucd = 9250767 ; nom_court = "INDUCTOS 12 mg Kit pour implant" ; cod_atc = "M05BC01" ; cod_ucd_chr = "0000009250767" ; OUTPUT ; 
code_ucd = 9250922 ; nom_court = "ARANESP 500 mcg solution injectable en seringue pre-remplie1 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009250922" ; OUTPUT ; 
code_ucd = 9250980 ; nom_court = "RECOMBINATE 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009250980" ; OUTPUT ; 
code_ucd = 9250980 ; nom_court = "RECOMBINATE 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009250980" ; OUTPUT ; 
code_ucd = 9250997 ; nom_court = "RECOMBINATE 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009250997" ; OUTPUT ; 
code_ucd = 9250997 ; nom_court = "RECOMBINATE 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009250997" ; OUTPUT ; 
code_ucd = 9251005 ; nom_court = "RECOMBINATE 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009251005" ; OUTPUT ; 
code_ucd = 9251005 ; nom_court = "RECOMBINATE 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009251005" ; OUTPUT ; 
code_ucd = 9251092 ; nom_court = "HUMIRA 40 mg solution injectable en seringue preremplie de 0,8 ml" ; cod_atc = "L04AB04" ; cod_ucd_chr = "0000009251092" ; OUTPUT ; 
code_ucd = 9251235 ; nom_court = "YTRACIS solution de chlorure d'Yttrium (90 Y) 1,850 GBq/ml precurseur radiopharmaceutique flacon verre 2 ml (B/1)" ; cod_atc = "V09XX" ; cod_ucd_chr = "0000009251235" ; OUTPUT ; 
code_ucd = 9251270 ; nom_court = "DOXORUBICINE G GAM 10 mg/5 ml solution injectable pour perfusion" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009251270" ; OUTPUT ; 
code_ucd = 9251287 ; nom_court = "DOXORUBICINE G GAM 2 MG/ML solution injectable pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009251287" ; OUTPUT ; 
code_ucd = 9251399 ; nom_court = "ZYVOXID 100 mg/5 ml granules pour suspension buvable" ; cod_atc = "J01XX08" ; cod_ucd_chr = "0000009251399" ; OUTPUT ; 
code_ucd = 9253381 ; nom_court = "BUSILVEX 6 mg/ml solution a diluer pour perfusion en ampoule de 10 ml" ; cod_atc = "L01AB01" ; cod_ucd_chr = "0000009253381" ; OUTPUT ; 
code_ucd = 9255463 ; nom_court = "WILFACTIN 1000 UI/ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD06" ; cod_ucd_chr = "0000009255463" ; OUTPUT ; 
code_ucd = 9255463 ; nom_court = "WILFACTIN 1000 UI/ml poudre et solvant pour solution injectable" ; cod_atc = "B02BD06" ; cod_ucd_chr = "0000009255463" ; OUTPUT ; 
code_ucd = 9255486 ; nom_court = "WILSTART 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD06" ; cod_ucd_chr = "0000009255486" ; OUTPUT ; 
code_ucd = 9255486 ; nom_court = "WILSTART 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD06" ; cod_ucd_chr = "0000009255486" ; OUTPUT ; 
code_ucd = 9255718 ; nom_court = "NEORECORMON 30 000 UI solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009255718" ; OUTPUT ; 
code_ucd = 9255724 ; nom_court = "COSMEGEN 0,5 mg poudre pour solution injectable" ; cod_atc = "L01DA01" ; cod_ucd_chr = "0000009255724" ; OUTPUT ; 
code_ucd = 9256221 ; nom_court = "EMTRIVA 10 mg/ml solution buvable en flacon de 170 ml" ; cod_atc = "J05AF09" ; cod_ucd_chr = "0000009256221" ; OUTPUT ; 
code_ucd = 9256238 ; nom_court = "EMTRIVA 200 mg gelule" ; cod_atc = "J05AF09" ; cod_ucd_chr = "0000009256238" ; OUTPUT ; 
code_ucd = 9256818 ; nom_court = "CARBOPLATINE SANDOZ 10 MG/ML solution pour perfusion en flacon de 15 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009256818" ; OUTPUT ; 
code_ucd = 9256824 ; nom_court = "CARBOPLATINE SANDOZ 10 MG/ML solution pour perfusion en flacon de 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009256824" ; OUTPUT ; 
code_ucd = 9256830 ; nom_court = "CARBOPLATINE SANDOZ 10 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009256830" ; OUTPUT ; 
code_ucd = 9256965 ; nom_court = "VENTAVIS 10 mcg/ml solution pour inhalation par nebuliseur en ampoule de2 ml" ; cod_atc = "B01AC11" ; cod_ucd_chr = "0000009256965" ; OUTPUT ; 
code_ucd = 9256965 ; nom_court = "VENTAVIS 10 mcg/ml solution pour inhalation par nebuliseur en ampoule de2 ml" ; cod_atc = "B01AC11" ; cod_ucd_chr = "0000009256965" ; OUTPUT ; 
code_ucd = 9257031 ; nom_court = "GLUCONATE DE CALCIUM 10 P. 100 AGUETTANT Solution injectable en ampoule" ; cod_atc = "A12AA03" ; cod_ucd_chr = "0000009257031" ; OUTPUT ; 
code_ucd = 9257315 ; nom_court = "FLUOROURACILE DAKOTA 50 mg/ml solution a diluer pour perfusion en flacon de 200 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009257315" ; OUTPUT ; 
code_ucd = 9257806 ; nom_court = "ROFERON-A 18 M UI/0,5 ml solution injectable en seringue preremplie" ; cod_atc = "L03AB04" ; cod_ucd_chr = "0000009257806" ; OUTPUT ; 
code_ucd = 9258088 ; nom_court = "ADVATE 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009258088" ; OUTPUT ; 
code_ucd = 9258088 ; nom_court = "ADVATE 1000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009258088" ; OUTPUT ; 
code_ucd = 9258094 ; nom_court = "ADVATE 1500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009258094" ; OUTPUT ; 
code_ucd = 9258094 ; nom_court = "ADVATE 1500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009258094" ; OUTPUT ; 
code_ucd = 9258102 ; nom_court = "ADVATE 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009258102" ; OUTPUT ; 
code_ucd = 9258102 ; nom_court = "ADVATE 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009258102" ; OUTPUT ; 
code_ucd = 9258119 ; nom_court = "ADVATE 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009258119" ; OUTPUT ; 
code_ucd = 9258119 ; nom_court = "ADVATE 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009258119" ; OUTPUT ; 
code_ucd = 9258504 ; nom_court = "ZEVALIN 1,6 mg/ml trousse pour preparation radiopharmaceutique pour perfusion" ; cod_atc = "V10XX02" ; cod_ucd_chr = "0000009258504" ; OUTPUT ; 
code_ucd = 9258697 ; nom_court = "REYATAZ 150 mg gelule" ; cod_atc = "J05AE08" ; cod_ucd_chr = "0000009258697" ; OUTPUT ; 
code_ucd = 9258705 ; nom_court = "REYATAZ 200 mg gelule" ; cod_atc = "J05AE08" ; cod_ucd_chr = "0000009258705" ; OUTPUT ; 
code_ucd = 9259001 ; nom_court = "PAXENE 6 mg/ml solution a diluer pour perfusion en flacon 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009259001" ; OUTPUT ; 
code_ucd = 9259018 ; nom_court = "PAXENE 6 mg/ml solution a diluer pour perfusion en flacon 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009259018" ; OUTPUT ; 
code_ucd = 9259082 ; nom_court = "FEIBA 1 000 U/20 ML Poudre et solvant pour solution injectable avec dispositif de transfert BAXJECT II Hi-flow" ; cod_atc = "B02BD03" ; cod_ucd_chr = "0000009259082" ; OUTPUT ; 
code_ucd = 9259082 ; nom_court = "FEIBA 1 000 U/20 ML Poudre et solvant pour solution injectable avec dispositif de transfert BAXJECT II Hi-flow" ; cod_atc = "B02BD03" ; cod_ucd_chr = "0000009259082" ; OUTPUT ; 
code_ucd = 9259099 ; nom_court = "FEIBA 500 U/20 ML Poudre et solvant pour solution injectable avec dispositif de transfert BAXJECT II Hi-flow" ; cod_atc = "B02BD03" ; cod_ucd_chr = "0000009259099" ; OUTPUT ; 
code_ucd = 9259099 ; nom_court = "FEIBA 500 U/20 ML Poudre et solvant pour solution injectable avec dispositif de transfert BAXJECT II Hi-flow" ; cod_atc = "B02BD03" ; cod_ucd_chr = "0000009259099" ; OUTPUT ; 
code_ucd = 9259113 ; nom_court = "AMSALYO 75 mg poudre pour solution pour perfusion en flacon" ; cod_atc = "L01XX01" ; cod_ucd_chr = "0000009259113" ; OUTPUT ; 
code_ucd = 9259509 ; nom_court = "LYSODREN 500 mg comprime" ; cod_atc = "L01XX23" ; cod_ucd_chr = "0000009259509" ; OUTPUT ; 
code_ucd = 9259691 ; nom_court = "CARBOPLATINE TEVA 10 mg/ml solution pour perfusion en flacon de 60 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009259691" ; OUTPUT ; 
code_ucd = 9260010 ; nom_court = "VELCADE 3,5 mg poudre pour solution injectable" ; cod_atc = "L01XX32" ; cod_ucd_chr = "0000009260010" ; OUTPUT ; 
code_ucd = 9260010 ; nom_court = "VELCADE 3,5 mg poudre pour solution injectable" ; cod_atc = "L01XX32" ; cod_ucd_chr = "0000009260010" ; OUTPUT ; 
code_ucd = 9260599 ; nom_court = "ERBITUX 2 mg/ml solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01XC06" ; cod_ucd_chr = "0000009260599" ; OUTPUT ; 
code_ucd = 9261050 ; nom_court = "DEPOCYTE 50 mg solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC01" ; cod_ucd_chr = "0000009261050" ; OUTPUT ; 
code_ucd = 9261073 ; nom_court = "FASLODEX 250 mg/5 ml solution injectable en seringue preremplie" ; cod_atc = "L02BA03" ; cod_ucd_chr = "0000009261073" ; OUTPUT ; 
code_ucd = 9261104 ; nom_court = "AVASTIN 25 mg/ml solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XC07" ; cod_ucd_chr = "0000009261104" ; OUTPUT ; 
code_ucd = 9261110 ; nom_court = "AVASTIN 25 mg/ml solution a diluer pour perfusion en flacon de 16 ml" ; cod_atc = "L01XC07" ; cod_ucd_chr = "0000009261110" ; OUTPUT ; 
code_ucd = 9261771 ; nom_court = "ALIMTA 500 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "L01BA04" ; cod_ucd_chr = "0000009261771" ; OUTPUT ; 
code_ucd = 9261771 ; nom_court = "ALIMTA 500 mg poudre pour solution a diluer pour perfusion" ; cod_atc = "L01BA04" ; cod_ucd_chr = "0000009261771" ; OUTPUT ; 
code_ucd = 9261788 ; nom_court = "VFEND 40 mg/ml poudre pour suspension buvable" ; cod_atc = "J02AC03" ; cod_ucd_chr = "0000009261788" ; OUTPUT ; 
code_ucd = 9261908 ; nom_court = "RETROVIR 100 mg/10 ml solution buvable en flacon de 200 ml + seringue 1 ml" ; cod_atc = "J05AF01" ; cod_ucd_chr = "0000009261908" ; OUTPUT ; 
code_ucd = 9261920 ; nom_court = "PHOTOBARR 15 mg poudre pour solution injectable" ; cod_atc = "L01XD01" ; cod_ucd_chr = "0000009261920" ; OUTPUT ; 
code_ucd = 9261937 ; nom_court = "PHOTOBARR 75 mg poudre pour solution injectable" ; cod_atc = "L01XD01" ; cod_ucd_chr = "0000009261937" ; OUTPUT ; 
code_ucd = 9261966 ; nom_court = "TELZIR 700 mg comprime" ; cod_atc = "J05AE07" ; cod_ucd_chr = "0000009261966" ; OUTPUT ; 
code_ucd = 9262919 ; nom_court = "TAXOL 6 mg/ml solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009262919" ; OUTPUT ; 
code_ucd = 9264433 ; nom_court = "VANCOMYCINE ZYDUS 1g poudre pour solution injectable (IV)" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009264433" ; OUTPUT ; 
code_ucd = 9264456 ; nom_court = "VANCOMYCINE ZYDUS 500 mg poudre pour solution injectable (IV)" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009264456" ; OUTPUT ; 
code_ucd = 9264663 ; nom_court = "KOGENATE BAYER 1 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009264663" ; OUTPUT ; 
code_ucd = 9264663 ; nom_court = "KOGENATE BAYER 1 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009264663" ; OUTPUT ; 
code_ucd = 9264686 ; nom_court = "KOGENATE BAYER 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009264686" ; OUTPUT ; 
code_ucd = 9264686 ; nom_court = "KOGENATE BAYER 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009264686" ; OUTPUT ; 
code_ucd = 9264692 ; nom_court = "KOGENATE BAYER 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009264692" ; OUTPUT ; 
code_ucd = 9264692 ; nom_court = "KOGENATE BAYER 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009264692" ; OUTPUT ; 
code_ucd = 9264930 ; nom_court = "TELZIR 50 mg/ml suspension buvable" ; cod_atc = "J05AE07" ; cod_ucd_chr = "0000009264930" ; OUTPUT ; 
code_ucd = 9266550 ; nom_court = "ELOXATINE 5 mg/ml solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009266550" ; OUTPUT ; 
code_ucd = 9266567 ; nom_court = "ELOXATINE 5 mg/ml solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009266567" ; OUTPUT ; 
code_ucd = 9267911 ; nom_court = "ADRIBLASTINE 200 MG/100 ML solution injectable pour perfusion en flacon" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009267911" ; OUTPUT ; 
code_ucd = 9267928 ; nom_court = "CARBOPLATINE WINTHROP 10 MG/ML solution pour perfusion en flacon de 60 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009267928" ; OUTPUT ; 
code_ucd = 9267934 ; nom_court = "CARBOPLATINE HOSPIRA 10 MG/ ML solution injectable pour perfusion en flacon de 60 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009267934" ; OUTPUT ; 
code_ucd = 9267957 ; nom_court = "CARBOPLATINE FAULDING 10 mg/ ml solution injectable pour perfusion A/F 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009267957" ; OUTPUT ; 
code_ucd = 9268000 ; nom_court = "DUODOPA Gel intestinal" ; cod_atc = "N04BA02" ; cod_ucd_chr = "0000009268000" ; OUTPUT ; 
code_ucd = 9268052 ; nom_court = "REYATAZ 50 mg/1,5 g poudre orale" ; cod_atc = "J05AE08" ; cod_ucd_chr = "0000009268052" ; OUTPUT ; 
code_ucd = 9268069 ; nom_court = "WILZIN 25 mg (acetate de zinc dihydrate) 1 Flacon de 250, gelules" ; cod_atc = "A16AX05" ; cod_ucd_chr = "0000009268069" ; OUTPUT ; 
code_ucd = 9268075 ; nom_court = "WILZIN 50 mg (acetate de zinc dihydrate) 1 Flacon de 250, gelules" ; cod_atc = "A16AX05" ; cod_ucd_chr = "0000009268075" ; OUTPUT ; 
code_ucd = 9268081 ; nom_court = "BERINERT 500 U/10 ML Poudre et solvant pour solution injectable/perfusion" ; cod_atc = "B02AB" ; cod_ucd_chr = "0000009268081" ; OUTPUT ; 
code_ucd = 9268081 ; nom_court = "BERINERT 500 U/10 ML Poudre et solvant pour solution injectable/perfusion" ; cod_atc = "B02AB" ; cod_ucd_chr = "0000009268081" ; OUTPUT ; 
code_ucd = 9268158 ; nom_court = "ELDISINE 5 mg poudre pour solution injectable en flacon" ; cod_atc = "L01CA03" ; cod_ucd_chr = "0000009268158" ; OUTPUT ; 
code_ucd = 9268218 ; nom_court = "ETOPOSIDE COOPER 2 P. 100 (100 mg/5 ml) solution a diluer pour perfusion en flacon verre de 5 ml" ; cod_atc = "L01CB01" ; cod_ucd_chr = "0000009268218" ; OUTPUT ; 
code_ucd = 9268276 ; nom_court = "FLUOROURACILE TEVA 250 mg/5 ml solution pour perfusion en ampoule de 5 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009268276" ; OUTPUT ; 
code_ucd = 9268282 ; nom_court = "FLUOROURACILE TEVA 500 mg/10 ml solution pour perfusion en ampoule de 10 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009268282" ; OUTPUT ; 
code_ucd = 9268388 ; nom_court = "MITOXANTRONE TEVA 10 MG/5 ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009268388" ; OUTPUT ; 
code_ucd = 9268394 ; nom_court = "MITOXANTRONE TEVA 20 MG/10 ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009268394" ; OUTPUT ; 
code_ucd = 9268402 ; nom_court = "MITOXANTRONE TEVA 25 MG/12,5 ML Solution a diluer pour perfusion en flacon de 12,5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009268402" ; OUTPUT ; 
code_ucd = 9268508 ; nom_court = "ZAVEDOS 10 MG/10 ML solution pour perfusion en flacon polypropylene de 10 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268508" ; OUTPUT ; 
code_ucd = 9268508 ; nom_court = "ZAVEDOS 10 MG/10 ML solution pour perfusion en flacon polypropylene de 10 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268508" ; OUTPUT ; 
code_ucd = 9268514 ; nom_court = "ZAVEDOS 10 MG/10 ML solution pour perfusion en flacon en verre de 10 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268514" ; OUTPUT ; 
code_ucd = 9268514 ; nom_court = "ZAVEDOS 10 MG/10 ML solution pour perfusion en flacon en verre de 10 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268514" ; OUTPUT ; 
code_ucd = 9268520 ; nom_court = "ZAVEDOS 20 MG/20 ML solution pour perfusion en flacon polypropylene de 20 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268520" ; OUTPUT ; 
code_ucd = 9268520 ; nom_court = "ZAVEDOS 20 MG/20 ML solution pour perfusion en flacon polypropylene de 20 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268520" ; OUTPUT ; 
code_ucd = 9268537 ; nom_court = "ZAVEDOS 20 MG/20 ML solution pour perfusion en flacon en verre de 20 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268537" ; OUTPUT ; 
code_ucd = 9268537 ; nom_court = "ZAVEDOS 20 MG/20 ML solution pour perfusion en flacon en verre de 20 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268537" ; OUTPUT ; 
code_ucd = 9268543 ; nom_court = "ZAVEDOS 5 MG/5 ML solution pour perfusion en flacon polypropylene de 5 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268543" ; OUTPUT ; 
code_ucd = 9268543 ; nom_court = "ZAVEDOS 5 MG/5 ML solution pour perfusion en flacon polypropylene de 5 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268543" ; OUTPUT ; 
code_ucd = 9268566 ; nom_court = "ZAVEDOS 5 MG/5 ML solution pour perfusion en flacon en verre de 5 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009268566" ; OUTPUT ; 
code_ucd = 9269034 ; nom_court = "REPLAGAL 1 mg/ml solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = "A16AB03" ; cod_ucd_chr = "0000009269034" ; OUTPUT ; 
code_ucd = 9269034 ; nom_court = "REPLAGAL 1 mg/ml solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = "A16AB03" ; cod_ucd_chr = "0000009269034" ; OUTPUT ; 
code_ucd = 9269229 ; nom_court = "SUBCUVIA 160 G/L solution injectable en flacon de 10 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009269229" ; OUTPUT ; 
code_ucd = 9269229 ; nom_court = "SUBCUVIA 160 G/L solution injectable en flacon de 10 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009269229" ; OUTPUT ; 
code_ucd = 9269235 ; nom_court = "SUBCUVIA 160 G/L solution injectable en flacon de 5 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009269235" ; OUTPUT ; 
code_ucd = 9269235 ; nom_court = "SUBCUVIA 160 G/L solution injectable en flacon de 5 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009269235" ; OUTPUT ; 
code_ucd = 9270617 ; nom_court = "VANCOMYCINE SANDOZ 125 mg poudre pour solution pour perfusion en flacon verre" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009270617" ; OUTPUT ; 
code_ucd = 9270623 ; nom_court = "VANCOMYCINE SANDOZ 250 mg poudre pour solution pour perfusion en flacon verre" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009270623" ; OUTPUT ; 
code_ucd = 9270646 ; nom_court = "VANCOMYCINE SANDOZ 500 mg poudre pour solution pour perfusion en flacon verre" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009270646" ; OUTPUT ; 
code_ucd = 9270787 ; nom_court = "ENBREL 50 mg poudre et solvant pour solution injectable + seringue preremplie" ; cod_atc = "L04AB01" ; cod_ucd_chr = "0000009270787" ; OUTPUT ; 
code_ucd = 9271456 ; nom_court = "LITAK 2 mg/ml solution injectable en flacon de 5 ml" ; cod_atc = "L01BB04" ; cod_ucd_chr = "0000009271456" ; OUTPUT ; 
code_ucd = 9271539 ; nom_court = "REMODULIN 1 mg/ml solution pour perfusion en flacon de 20 ml (voie sous-cutanee)" ; cod_atc = "B01AC21" ; cod_ucd_chr = "0000009271539" ; OUTPUT ; 
code_ucd = 9271539 ; nom_court = "REMODULIN 1 mg/ml solution pour perfusion en flacon de 20 ml (voie sous-cutanee)" ; cod_atc = "B01AC21" ; cod_ucd_chr = "0000009271539" ; OUTPUT ; 
code_ucd = 9271545 ; nom_court = "REMODULIN 10 mg/ml solution pour perfusion en flacon de 20 ml (voie sous-cutanee)" ; cod_atc = "B01AC21" ; cod_ucd_chr = "0000009271545" ; OUTPUT ; 
code_ucd = 9271545 ; nom_court = "REMODULIN 10 mg/ml solution pour perfusion en flacon de 20 ml (voie sous-cutanee)" ; cod_atc = "B01AC21" ; cod_ucd_chr = "0000009271545" ; OUTPUT ; 
code_ucd = 9271551 ; nom_court = "REMODULIN 2,5 mg/ml solution pour perfusion en flacon de 20 ml (voie sous-cutanee)" ; cod_atc = "B01AC21" ; cod_ucd_chr = "0000009271551" ; OUTPUT ; 
code_ucd = 9271551 ; nom_court = "REMODULIN 2,5 mg/ml solution pour perfusion en flacon de 20 ml (voie sous-cutanee)" ; cod_atc = "B01AC21" ; cod_ucd_chr = "0000009271551" ; OUTPUT ; 
code_ucd = 9271568 ; nom_court = "REMODULIN 5 mg/ml solution pour perfusion en flacon de 20 ml (voie sous-cutanee)" ; cod_atc = "B01AC21" ; cod_ucd_chr = "0000009271568" ; OUTPUT ; 
code_ucd = 9271568 ; nom_court = "REMODULIN 5 mg/ml solution pour perfusion en flacon de 20 ml (voie sous-cutanee)" ; cod_atc = "B01AC21" ; cod_ucd_chr = "0000009271568" ; OUTPUT ; 
code_ucd = 9271781 ; nom_court = "GAMMANORM 165 mg/ml solution injectable en ampoule de 10 ml (B/1-1,65g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009271781" ; OUTPUT ; 
code_ucd = 9271781 ; nom_court = "GAMMANORM 165 mg/ml solution injectable en ampoule de 10 ml (B/1-1,65g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009271781" ; OUTPUT ; 
code_ucd = 9271798 ; nom_court = "OCTAPLEX poudre et solvant pour solution injectable" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009271798" ; OUTPUT ; 
code_ucd = 9271798 ; nom_court = "OCTAPLEX poudre et solvant pour solution injectable" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009271798" ; OUTPUT ; 
code_ucd = 9272645 ; nom_court = "EPREX 10 000 UI/ML solution injectable en seringue pre-remplie 0,3 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009272645" ; OUTPUT ; 
code_ucd = 9272651 ; nom_court = "EPREX 10 000 UI/ML solution injectable en seringue pre-remplie 0,4 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009272651" ; OUTPUT ; 
code_ucd = 9272668 ; nom_court = "EPREX 2000 UI/ML solution injectable en flacon 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009272668" ; OUTPUT ; 
code_ucd = 9272674 ; nom_court = "EPREX 4 000 UI/ML solution injectable en seringue pre-remplie 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009272674" ; OUTPUT ; 
code_ucd = 9272680 ; nom_court = "VANCOMYCINE SANDOZ 1 g poudre pour solution pour perfusion en flacon verre de 20 ml" ; cod_atc = "J01XA01" ; cod_ucd_chr = "0000009272680" ; OUTPUT ; 
code_ucd = 9273403 ; nom_court = "EPREX 2 000 UI/ML solution injectable en seringue pre-remplie 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009273403" ; OUTPUT ; 
code_ucd = 9273426 ; nom_court = "KIVEXA comprime pellicule" ; cod_atc = "J05AR02" ; cod_ucd_chr = "0000009273426" ; OUTPUT ; 
code_ucd = 9273981 ; nom_court = "MABCAMPATH 30 mg/ml solution a diluer pour perfusion" ; cod_atc = "L01XC04" ; cod_ucd_chr = "0000009273981" ; OUTPUT ; 
code_ucd = 9273981 ; nom_court = "MABCAMPATH 30 mg/ml solution a diluer pour perfusion" ; cod_atc = "L01XC04" ; cod_ucd_chr = "0000009273981" ; OUTPUT ; 
code_ucd = 9274182 ; nom_court = "TRUVADA comprime pellicule" ; cod_atc = "J05AR03" ; cod_ucd_chr = "0000009274182" ; OUTPUT ; 
code_ucd = 9274207 ; nom_court = "VIVAGLOBIN 160 mg/ml solution injectable (voie sous-cutanee) en flacon de 10 ml (B/1 - 1,6 g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009274207" ; OUTPUT ; 
code_ucd = 9274207 ; nom_court = "VIVAGLOBIN 160 mg/ml solution injectable (voie sous-cutanee) en flacon de 10 ml (B/1 - 1,6 g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009274207" ; OUTPUT ; 
code_ucd = 9274213 ; nom_court = "ABELCET 5 mg/ml suspension a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "J02AA01" ; cod_ucd_chr = "0000009274213" ; OUTPUT ; 
code_ucd = 9274242 ; nom_court = "TALOXA 600 mg/5 ml suspension buvable en flacon polypropylene de 230 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009274242" ; OUTPUT ; 
code_ucd = 9274408 ; nom_court = "REBETOL 40 mg/ml solution buvable en flacon de 100 ml" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009274408" ; OUTPUT ; 
code_ucd = 9274489 ; nom_court = "FLUCONAZOLE SANDOZ 2 MG/ML 1 Flacon de 100 ml, solution injectable" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009274489" ; OUTPUT ; 
code_ucd = 9274495 ; nom_court = "FLUCONAZOLE SANDOZ 2 MG/ML 1 Flacon de 200 ml, solution injectable" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009274495" ; OUTPUT ; 
code_ucd = 9274503 ; nom_court = "FLUCONAZOLE SANDOZ 2 MG/ML 1 Flacon de 50 ml, solution injectable" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009274503" ; OUTPUT ; 
code_ucd = 9274590 ; nom_court = "ARANESP 10 mcg solution injectable en stylo prerempli de 0,4 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274590" ; OUTPUT ; 
code_ucd = 9274609 ; nom_court = "ARANESP 100 mcg solution injectable en stylo prerempli de 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274609" ; OUTPUT ; 
code_ucd = 9274615 ; nom_court = "ARANESP 15 mcg solution injectable en stylo prerempli de 0,375 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274615" ; OUTPUT ; 
code_ucd = 9274621 ; nom_court = "ARANESP 150 mcg solution injectable en stylo prerempli de 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274621" ; OUTPUT ; 
code_ucd = 9274638 ; nom_court = "ARANESP 20 mcg solution injectable en stylo prerempli de 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274638" ; OUTPUT ; 
code_ucd = 9274644 ; nom_court = "ARANESP 30 mcg solution injectable en stylo prerempli de 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274644" ; OUTPUT ; 
code_ucd = 9274650 ; nom_court = "ARANESP 300 mcg solution injectable en stylo prerempli de 0,6 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274650" ; OUTPUT ; 
code_ucd = 9274667 ; nom_court = "ARANESP 40 mcg solution injectable en stylo prerempli de 0,4 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274667" ; OUTPUT ; 
code_ucd = 9274673 ; nom_court = "ARANESP 50 mcg solution injectable en stylo prerempli de 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274673" ; OUTPUT ; 
code_ucd = 9274696 ; nom_court = "ARANESP 500 mcg solution injectable en stylo prerempli de 1 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274696" ; OUTPUT ; 
code_ucd = 9274704 ; nom_court = "ARANESP 60 mcg solution injectable en stylo prerempli de 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274704" ; OUTPUT ; 
code_ucd = 9274710 ; nom_court = "ARANESP 80 mcg solution injectable en stylo prerempli de 0,4 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009274710" ; OUTPUT ; 
code_ucd = 9274727 ; nom_court = "ORFADIN 10 mg gelule" ; cod_atc = "A16AX04" ; cod_ucd_chr = "0000009274727" ; OUTPUT ; 
code_ucd = 9274733 ; nom_court = "ORFADIN 2 mg gelule" ; cod_atc = "A16AX04" ; cod_ucd_chr = "0000009274733" ; OUTPUT ; 
code_ucd = 9274756 ; nom_court = "ORFADIN 5 mg gelule" ; cod_atc = "A16AX04" ; cod_ucd_chr = "0000009274756" ; OUTPUT ; 
code_ucd = 9274762 ; nom_court = "VIDAZA 25 MG/ML Poudre pour suspension injectable en flacon (verre) de 100 mg" ; cod_atc = "L01BC07" ; cod_ucd_chr = "0000009274762" ; OUTPUT ; 
code_ucd = 9274762 ; nom_court = "VIDAZA 25 MG/ML Poudre pour suspension injectable en flacon (verre) de 100 mg" ; cod_atc = "L01BC07" ; cod_ucd_chr = "0000009274762" ; OUTPUT ; 
code_ucd = 9275282 ; nom_court = "GAMMANORM 165 mg/ml solution injectable en ampoule de 10 ml (B/10-16,5g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009275282" ; OUTPUT ; 
code_ucd = 9275282 ; nom_court = "GAMMANORM 165 mg/ml solution injectable en ampoule de 10 ml (B/10-16,5g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009275282" ; OUTPUT ; 
code_ucd = 9275299 ; nom_court = "GAMMANORM 165 mg/ml solution injectable en ampoule de 10 ml (B/20-33g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009275299" ; OUTPUT ; 
code_ucd = 9275299 ; nom_court = "GAMMANORM 165 mg/ml solution injectable en ampoule de 10 ml (B/20-33g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009275299" ; OUTPUT ; 
code_ucd = 9275307 ; nom_court = "SUBCUVIA 160 mg/ml solution injectable (voie sous-cutanee) en flacon de 5 ml (B/20-16g)" ; cod_atc = " " ; cod_ucd_chr = "0000009275307" ; OUTPUT ; 
code_ucd = 9275307 ; nom_court = "SUBCUVIA 160 mg/ml solution injectable (voie sous-cutanee) en flacon de 5 ml (B/20-16g)" ; cod_atc = " " ; cod_ucd_chr = "0000009275307" ; OUTPUT ; 
code_ucd = 9275313 ; nom_court = "SUBCUVIA 160 mg/ml solution injectable (voie sous-cutanee) en flacon de 10 ml (B/20-32g)" ; cod_atc = " " ; cod_ucd_chr = "0000009275313" ; OUTPUT ; 
code_ucd = 9275313 ; nom_court = "SUBCUVIA 160 mg/ml solution injectable (voie sous-cutanee) en flacon de 10 ml (B/20-32g)" ; cod_atc = " " ; cod_ucd_chr = "0000009275313" ; OUTPUT ; 
code_ucd = 9275684 ; nom_court = "MITOXANTRONE G GAM 2 mg/ml solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009275684" ; OUTPUT ; 
code_ucd = 9275690 ; nom_court = "MITOXANTRONE G GAM 2 mg/ml solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009275690" ; OUTPUT ; 
code_ucd = 9275715 ; nom_court = "ALFALASTIN 33,33 mg/ml poudre et solvant pour solution injectable" ; cod_atc = "B02AB02" ; cod_ucd_chr = "0000009275715" ; OUTPUT ; 
code_ucd = 9275715 ; nom_court = "ALFALASTIN 33,33 mg/ml poudre et solvant pour solution injectable" ; cod_atc = "B02AB02" ; cod_ucd_chr = "0000009275715" ; OUTPUT ; 
code_ucd = 9275891 ; nom_court = "INVIRASE 500 mg comprime pellicule" ; cod_atc = "J05AE01" ; cod_ucd_chr = "0000009275891" ; OUTPUT ; 
code_ucd = 9277186 ; nom_court = "MITOXANTRONE MYLAN 2 MG/ML solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009277186" ; OUTPUT ; 
code_ucd = 9277192 ; nom_court = "MITOXANTRONE MYLAN 2 MG/ML solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009277192" ; OUTPUT ; 
code_ucd = 9278091 ; nom_court = "PACLITAXEL TEVA 6 mg/ml solution a diluer pour perfusion en flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009278091" ; OUTPUT ; 
code_ucd = 9278116 ; nom_court = "PACLITAXEL TEVA 6 mg/ml solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009278116" ; OUTPUT ; 
code_ucd = 9278122 ; nom_court = "PACLITAXEL TEVA 6 mg/ml solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009278122" ; OUTPUT ; 
code_ucd = 9278582 ; nom_court = "ESKAZOLE 400 mg comprime" ; cod_atc = "P02CA03" ; cod_ucd_chr = "0000009278582" ; OUTPUT ; 
code_ucd = 9278599 ; nom_court = "FLUOURACILE G GAM 50 mg/ml solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009278599" ; OUTPUT ; 
code_ucd = 9279038 ; nom_court = "KEPIVANCE 6,25 mg poudre pour solution injectable" ; cod_atc = "V03AF08" ; cod_ucd_chr = "0000009279038" ; OUTPUT ; 
code_ucd = 9279966 ; nom_court = "NOXAFIL 40 mg/ml suspension buvable en flacon de 105 ml" ; cod_atc = "J02AC04" ; cod_ucd_chr = "0000009279966" ; OUTPUT ; 
code_ucd = 9279972 ; nom_court = "REVATIO 20 mg comprime pellicule" ; cod_atc = "G04BE03" ; cod_ucd_chr = "0000009279972" ; OUTPUT ; 
code_ucd = 9280030 ; nom_court = "FLUOURACILE G GAM 50 mg/ml solution pour perfusion en flacon de 10 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009280030" ; OUTPUT ; 
code_ucd = 9280047 ; nom_court = "FLUOURACILE G GAM 50 mg/ml solution pour perfusion en flacon de 100 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009280047" ; OUTPUT ; 
code_ucd = 9280053 ; nom_court = "FLUOURACILE G GAM 50 mg/ml solution pour perfusion en flacon de 20 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009280053" ; OUTPUT ; 
code_ucd = 9280403 ; nom_court = "VIVAGLOBIN 160 mg/ml solution injectable (voie sous-cutanee) en flacon de 10 ml (B/10-16 g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009280403" ; OUTPUT ; 
code_ucd = 9280403 ; nom_court = "VIVAGLOBIN 160 mg/ml solution injectable (voie sous-cutanee) en flacon de 10 ml (B/10-16 g)" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009280403" ; OUTPUT ; 
code_ucd = 9280596 ; nom_court = "APTIVUS 250 mg (tipranavir) 1 Boite de 120, capsules molles" ; cod_atc = "J05AE09" ; cod_ucd_chr = "0000009280596" ; OUTPUT ; 
code_ucd = 9280797 ; nom_court = "MITOXANTRONE FAULDING 2 mg/ml solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009280797" ; OUTPUT ; 
code_ucd = 9280805 ; nom_court = "MITOXANTRONE FAULDING 2 mg/ml solution a diluer pour perfusion en flacon de 12,5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009280805" ; OUTPUT ; 
code_ucd = 9281070 ; nom_court = "OXALIPLATINE DAKOTA PHARM 5 mg/ml poudre pour solution pour perfusion en flacon de 50 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009281070" ; OUTPUT ; 
code_ucd = 9281087 ; nom_court = "OXALIPLATINE DAKOTA PHARM 5 mg/ml poudre pour solution pour perfusion en flacon de 100 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009281087" ; OUTPUT ; 
code_ucd = 9281093 ; nom_court = "OXALIPLATINE DAKOTA PHARM 5 mg/ml solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009281093" ; OUTPUT ; 
code_ucd = 9281101 ; nom_court = "OXALIPLATINE DAKOTA PHARM 5 mg/ml solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009281101" ; OUTPUT ; 
code_ucd = 9281118 ; nom_court = "OXALIPLATINE WINTHROP 5 mg/ml 1 Flacon de 50 mg, poudre pour solution pour perfusion" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009281118" ; OUTPUT ; 
code_ucd = 9281124 ; nom_court = "OXALIPLATINE WINTHROP 5 mg/ml 1 Flacon de 100 mg, poudre pour solution pour perfusion" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009281124" ; OUTPUT ; 
code_ucd = 9281130 ; nom_court = "OXALIPLATINE WINTHROP 5 mg/ml 1 Flacon de 10 ml, solution a diluer pour perfusion" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009281130" ; OUTPUT ; 
code_ucd = 9281147 ; nom_court = "OXALIPLATINE WINTHROP 5 mg/ml 1 Flacon de 20 ml, solution a diluer pour perfusion" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009281147" ; OUTPUT ; 
code_ucd = 9281176 ; nom_court = "VINORELBINE EBEWE 10 mg/ml 1 Flacon de 1 ml, solution injectable" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009281176" ; OUTPUT ; 
code_ucd = 9281182 ; nom_court = "VINORELBINE EBEWE 10 mg/ml 1 Flacon de 5 ml, solution injectable" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009281182" ; OUTPUT ; 
code_ucd = 9281199 ; nom_court = "XYREM 500 mg/ml solution buvable en flacon de 180 ml" ; cod_atc = "N07XX04" ; cod_ucd_chr = "0000009281199" ; OUTPUT ; 
code_ucd = 9281348 ; nom_court = "HAEMOCOMPLETTAN 1 g poudre pour solution injectable" ; cod_atc = "B02BB01" ; cod_ucd_chr = "0000009281348" ; OUTPUT ; 
code_ucd = 9281360 ; nom_court = "SANDOGLOBULINE 12 g poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009281360" ; OUTPUT ; 
code_ucd = 9281360 ; nom_court = "SANDOGLOBULINE 12 g poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009281360" ; OUTPUT ; 
code_ucd = 9281377 ; nom_court = "SANDOGLOBULINE 3 g poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009281377" ; OUTPUT ; 
code_ucd = 9281377 ; nom_court = "SANDOGLOBULINE 3 g poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009281377" ; OUTPUT ; 
code_ucd = 9281383 ; nom_court = "SANDOGLOBULINE 6 g poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009281383" ; OUTPUT ; 
code_ucd = 9281383 ; nom_court = "SANDOGLOBULINE 6 g poudre et solvant pour solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009281383" ; OUTPUT ; 
code_ucd = 9282709 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 10 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009282709" ; OUTPUT ; 
code_ucd = 9282709 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 10 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009282709" ; OUTPUT ; 
code_ucd = 9282715 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009282715" ; OUTPUT ; 
code_ucd = 9282715 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009282715" ; OUTPUT ; 
code_ucd = 9282721 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 25 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009282721" ; OUTPUT ; 
code_ucd = 9282721 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 25 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009282721" ; OUTPUT ; 
code_ucd = 9282738 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009282738" ; OUTPUT ; 
code_ucd = 9282738 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009282738" ; OUTPUT ; 
code_ucd = 9282744 ; nom_court = "PACLITAXEL DAKOTA PHARM 6 mg/ml solution a diluer pour perfusion en flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009282744" ; OUTPUT ; 
code_ucd = 9282750 ; nom_court = "PACLITAXEL DAKOTA PHARM 6 mg/ml solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009282750" ; OUTPUT ; 
code_ucd = 9282767 ; nom_court = "PACLITAXEL DAKOTA PHARM 6 mg/ml solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009282767" ; OUTPUT ; 
code_ucd = 9282773 ; nom_court = "PACLITAXEL DAKOTA PHARM 6 mg/ml solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009282773" ; OUTPUT ; 
code_ucd = 9283904 ; nom_court = "OSIGRAFT 3,3 MG poudre pour suspension implantable" ; cod_atc = "M05BC02" ; cod_ucd_chr = "0000009283904" ; OUTPUT ; 
code_ucd = 9284097 ; nom_court = "SANDOGLOBULINE 120 mg/ml 1 Flacon de 100 ml, solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009284097" ; OUTPUT ; 
code_ucd = 9284097 ; nom_court = "SANDOGLOBULINE 120 mg/ml 1 Flacon de 100 ml, solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009284097" ; OUTPUT ; 
code_ucd = 9284105 ; nom_court = "SANDOGLOBULINE 120 mg/ml 1 Flacon de 50 ml, solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009284105" ; OUTPUT ; 
code_ucd = 9284105 ; nom_court = "SANDOGLOBULINE 120 mg/ml 1 Flacon de 50 ml, solution pour perfusion" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009284105" ; OUTPUT ; 
code_ucd = 9284163 ; nom_court = "AMIKACINE MERCK 250 MG Poudre pour solution injectable" ; cod_atc = "J01GB06" ; cod_ucd_chr = "0000009284163" ; OUTPUT ; 
code_ucd = 9284186 ; nom_court = "AMIKACINE MERCK 500 MG Poudre pour solution injectable" ; cod_atc = "J01GB06" ; cod_ucd_chr = "0000009284186" ; OUTPUT ; 
code_ucd = 9284306 ; nom_court = "EPIRUBICINE HOSPIRA 2 MG/ML Solution pour perfusion, flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284306" ; OUTPUT ; 
code_ucd = 9284312 ; nom_court = "EPIRUBICINE HOSPIRA 2 MG/ML Solution pour perfusion, flacon de 5 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284312" ; OUTPUT ; 
code_ucd = 9284329 ; nom_court = "EPIRUBICINE HOSPIRA 2 MG/ML Solution pour perfusion, flacon de 50 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284329" ; OUTPUT ; 
code_ucd = 9284335 ; nom_court = "EPIRUBICINE HOSPIRA 2 MG/ML Solution pour perfusion, flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284335" ; OUTPUT ; 
code_ucd = 9284341 ; nom_court = "EPIRUBICINE INTSEL CHIMOS 2 mg/ml solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284341" ; OUTPUT ; 
code_ucd = 9284358 ; nom_court = "EPIRUBICINE INTSEL CHIMOS 2 mg/ml 1 Flacon de 100 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284358" ; OUTPUT ; 
code_ucd = 9284364 ; nom_court = "EPIRUBICINE INTSEL CHIMOS 2 mg/ml 1 Flacon de 25 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284364" ; OUTPUT ; 
code_ucd = 9284370 ; nom_court = "EPIRUBICINE INTSEL CHIMOS 2 mg/ml 1 Flacon de 5 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284370" ; OUTPUT ; 
code_ucd = 9284387 ; nom_court = "EPIRUBICINE INTSEL CHIMOS 2 mg/ml 1 Flacon de 50 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284387" ; OUTPUT ; 
code_ucd = 9284393 ; nom_court = "EPIRUBICINE TEVA 2 MG/ML 1 Flacon de 10 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284393" ; OUTPUT ; 
code_ucd = 9284401 ; nom_court = "EPIRUBICINE TEVA 2 MG/ML 1 Flacon de 100 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284401" ; OUTPUT ; 
code_ucd = 9284418 ; nom_court = "EPIRUBICINE TEVA 2 MG/ML 1 Flacon de 25 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284418" ; OUTPUT ; 
code_ucd = 9284424 ; nom_court = "EPIRUBICINE TEVA 2 MG/ML 1 Flacon de 5 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009284424" ; OUTPUT ; 
code_ucd = 9284476 ; nom_court = "EPREX 40 000 UI/ml solution injectable, en seringue preremplie 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009284476" ; OUTPUT ; 
code_ucd = 9284482 ; nom_court = "EPREX 40 000 UI/ml solution injectable en seringue preremplie de 1 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009284482" ; OUTPUT ; 
code_ucd = 9284499 ; nom_court = "PACLITAXEL MYLAN 6 MG/ML solution a diluer pour perfusion en flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009284499" ; OUTPUT ; 
code_ucd = 9284507 ; nom_court = "PACLITAXEL MYLAN 6 MG/ML solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009284507" ; OUTPUT ; 
code_ucd = 9284513 ; nom_court = "PACLITAXEL MYLAN 6 MG/ML solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009284513" ; OUTPUT ; 
code_ucd = 9284536 ; nom_court = "PACLITAXEL MYLAN 6 MG/ML solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009284536" ; OUTPUT ; 
code_ucd = 9284803 ; nom_court = "MITOXANTRONE MYLAN 2 MG/ML solution a diluer pour perfusion en flacon de 12,5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009284803" ; OUTPUT ; 
code_ucd = 9284890 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009284890" ; OUTPUT ; 
code_ucd = 9284890 ; nom_court = "KIOVIG 100 mg/ml solution injectable en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009284890" ; OUTPUT ; 
code_ucd = 9284915 ; nom_court = "SUTENT 12,5 mg gelule" ; cod_atc = "L01XE04" ; cod_ucd_chr = "0000009284915" ; OUTPUT ; 
code_ucd = 9284921 ; nom_court = "SUTENT 25 mg gelule" ; cod_atc = "L01XE04" ; cod_ucd_chr = "0000009284921" ; OUTPUT ; 
code_ucd = 9284938 ; nom_court = "SUTENT 50 mg gelule" ; cod_atc = "L01XE04" ; cod_ucd_chr = "0000009284938" ; OUTPUT ; 
code_ucd = 9285257 ; nom_court = "EPIRUBICINE WINTHROP 2 MG/ML solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285257" ; OUTPUT ; 
code_ucd = 9285263 ; nom_court = "EPIRUBICINE WINTHROP 2 MG/ML solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285263" ; OUTPUT ; 
code_ucd = 9285286 ; nom_court = "EPIRUBICINE WINTHROP 2 MG/ML solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285286" ; OUTPUT ; 
code_ucd = 9285292 ; nom_court = "EPIRUBICINE WINTHROP 2 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285292" ; OUTPUT ; 
code_ucd = 9285300 ; nom_court = "EPIRUBICINE WINTHROP 2 MG/ML solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285300" ; OUTPUT ; 
code_ucd = 9285317 ; nom_court = "EPIRUBICINE RATIOPHARM 2 MG/ML Solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285317" ; OUTPUT ; 
code_ucd = 9285323 ; nom_court = "EPIRUBICINE RATIOPHARM 2 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285323" ; OUTPUT ; 
code_ucd = 9285346 ; nom_court = "EPIRUBICINE RATIOPHARM 2 MG/ML Solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285346" ; OUTPUT ; 
code_ucd = 9285352 ; nom_court = "EPIRUBICINE RATIOPHARM 2 MG/ML 1 Flacon de 5 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009285352" ; OUTPUT ; 
code_ucd = 9285375 ; nom_court = "NEXAVAR 200 mg comprime pellicule" ; cod_atc = "L01XE05" ; cod_ucd_chr = "0000009285375" ; OUTPUT ; 
code_ucd = 9285381 ; nom_court = "PACLITAXEL EBEWE 6 mg/ml 1 Flacon de 16,7 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009285381" ; OUTPUT ; 
code_ucd = 9285398 ; nom_court = "PACLITAXEL EBEWE 6 mg/ml 1 Flacon de 25 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009285398" ; OUTPUT ; 
code_ucd = 9285406 ; nom_court = "PACLITAXEL EBEWE 6 mg/ml 1 Flacon de 5 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009285406" ; OUTPUT ; 
code_ucd = 9285412 ; nom_court = "PACLITAXEL EBEWE 6 mg/ml 1 Flacon de 50 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009285412" ; OUTPUT ; 
code_ucd = 9286825 ; nom_court = "FLUCONAZOLE AGUETTANT 2 mg/ml solution pour perfusion en poche de 100 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009286825" ; OUTPUT ; 
code_ucd = 9286831 ; nom_court = "FLUCONAZOLE AGUETTANT 2 mg/ml solution pour perfusion en poche de 200 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009286831" ; OUTPUT ; 
code_ucd = 9286848 ; nom_court = "FLUCONAZOLE AGUETTANT 2 mg/ml solution pour perfusion en poche de 50 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009286848" ; OUTPUT ; 
code_ucd = 9286995 ; nom_court = "KALETRA 200 mg/50 mg comprime pellicule" ; cod_atc = "J05AR10" ; cod_ucd_chr = "0000009286995" ; OUTPUT ; 
code_ucd = 9287196 ; nom_court = "NAGLAZYME 1 mg/ml solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "A16AB08" ; cod_ucd_chr = "0000009287196" ; OUTPUT ; 
code_ucd = 9288304 ; nom_court = "BARACLUDE 0,05 mg/ml (entecavir) Flacon de 210 ml avec cuillere-mesure, solution buvable" ; cod_atc = "J05AF10" ; cod_ucd_chr = "0000009288304" ; OUTPUT ; 
code_ucd = 9288310 ; nom_court = "BARACLUDE 0,5 mg (entecavir) comprime pellicule" ; cod_atc = "J05AF10" ; cod_ucd_chr = "0000009288310" ; OUTPUT ; 
code_ucd = 9288327 ; nom_court = "BARACLUDE 1 mg (entecavir) comprime pellicule" ; cod_atc = "J05AF10" ; cod_ucd_chr = "0000009288327" ; OUTPUT ; 
code_ucd = 9290301 ; nom_court = "FLUCONAZOLE DAKOTA PHARM 2 mg/ml solution pour perfusion en flacon de 100 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009290301" ; OUTPUT ; 
code_ucd = 9290318 ; nom_court = "FLUCONAZOLE DAKOTA PHARM 2 mg/ml solution pour perfusion en flacon de 200 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009290318" ; OUTPUT ; 
code_ucd = 9290324 ; nom_court = "FLUCONAZOLE DAKOTA PHARM 2 mg/ml solution pour perfusion en flacon de 50 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009290324" ; OUTPUT ; 
code_ucd = 9290413 ; nom_court = "OCTANATE 100 UI/ml poudre et solvant pour solution injectable en flacon de 10 ml" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009290413" ; OUTPUT ; 
code_ucd = 9290413 ; nom_court = "OCTANATE 100 UI/ml poudre et solvant pour solution injectable en flacon de 10 ml" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009290413" ; OUTPUT ; 
code_ucd = 9290436 ; nom_court = "OCTANATE 50 UI/ml poudre et solvant pour solution injectable en flacon de 10 ml" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009290436" ; OUTPUT ; 
code_ucd = 9290436 ; nom_court = "OCTANATE 50 UI/ml poudre et solvant pour solution injectable en flacon de 10 ml" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009290436" ; OUTPUT ; 
code_ucd = 9290442 ; nom_court = "OCTANATE 50 UI/ml poudre et solvant pour solution injectable en flacon de 5 ml" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009290442" ; OUTPUT ; 
code_ucd = 9290442 ; nom_court = "OCTANATE 50 UI/ml poudre et solvant pour solution injectable en flacon de 5 ml" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009290442" ; OUTPUT ; 
code_ucd = 9290459 ; nom_court = "PACLITAXEL RATIOPHARM 6 mg/ml solution a diluer pour perfusion en flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009290459" ; OUTPUT ; 
code_ucd = 9290465 ; nom_court = "PACLITAXEL RATIOPHARM 6 mg/ml solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009290465" ; OUTPUT ; 
code_ucd = 9290471 ; nom_court = "PACLITAXEL RATIOPHARM 6 mg/ml solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009290471" ; OUTPUT ; 
code_ucd = 9290502 ; nom_court = "ERWINASE 10000 UL/FLACON Poudre pour solution injectable" ; cod_atc = "L01XX02" ; cod_ucd_chr = "0000009290502" ; OUTPUT ; 
code_ucd = 9290519 ; nom_court = "YONDELIS 0,25 MG poudre pour solution a diluer pour perfusion en flacon" ; cod_atc = "L01CX01" ; cod_ucd_chr = "0000009290519" ; OUTPUT ; 
code_ucd = 9290525 ; nom_court = "YONDELIS 1 MG poudre pour solution a diluer pour perfusion en flacon" ; cod_atc = "L01CX01" ; cod_ucd_chr = "0000009290525" ; OUTPUT ; 
code_ucd = 9290844 ; nom_court = "CARBOPLATINE INTSEL CHIMOS 10 mg/ml solution pour perfusion en flacon de 15 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009290844" ; OUTPUT ; 
code_ucd = 9290850 ; nom_court = "CARBOPLATINE INTSEL CHIMOS 10 mg/ml solution pour perfusion en flacon de 45 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009290850" ; OUTPUT ; 
code_ucd = 9290867 ; nom_court = "CARBOPLATINE INTSEL CHIMOS 10 mg/ml solution pour perfusion en flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009290867" ; OUTPUT ; 
code_ucd = 9290873 ; nom_court = "CARBOPLATINE INTSEL CHIMOS 10 mg/ml solution pour perfusion en flacon de 60 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009290873" ; OUTPUT ; 
code_ucd = 9291602 ; nom_court = "SAVENE 20 mg/ml poudre pour solution a diluer et diluant pour solution pour perfusion" ; cod_atc = "V03AF02" ; cod_ucd_chr = "0000009291602" ; OUTPUT ; 
code_ucd = 9293216 ; nom_court = "MYOZYME 50 MG poudre pour solution a diluer pour perfusion" ; cod_atc = "A16AB07" ; cod_ucd_chr = "0000009293216" ; OUTPUT ; 
code_ucd = 9293340 ; nom_court = "TYSABRI 300 mg 1 Flacon de 15 ml, solution a diluer pour perfusion" ; cod_atc = "L04AA23" ; cod_ucd_chr = "0000009293340" ; OUTPUT ; 
code_ucd = 9293357 ; nom_court = "EPIRUBICINE EBEWE 2 mg/ml solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009293357" ; OUTPUT ; 
code_ucd = 9293363 ; nom_court = "EPIRUBICINE EBEWE 2 mg/ml solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009293363" ; OUTPUT ; 
code_ucd = 9293386 ; nom_court = "EPIRUBICINE EBEWE 2 mg/ml solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009293386" ; OUTPUT ; 
code_ucd = 9293392 ; nom_court = "EPIRUBICINE EBEWE 2 mg/ml solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009293392" ; OUTPUT ; 
code_ucd = 9293593 ; nom_court = "ELAPRASE 2 mg/ml 1 Flacon de 3 ml, solution a diluer pour perfusion" ; cod_atc = "A16AB09" ; cod_ucd_chr = "0000009293593" ; OUTPUT ; 
code_ucd = 9294641 ; nom_court = "DOXORUBICINE EBEWE 2 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009294641" ; OUTPUT ; 
code_ucd = 9294658 ; nom_court = "DOXORUBICINE EBEWE 2 MG/ML Solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009294658" ; OUTPUT ; 
code_ucd = 9294664 ; nom_court = "DOXORUBICINE EBEWE 2 MG/ML Solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009294664" ; OUTPUT ; 
code_ucd = 9294670 ; nom_court = "DOXORUBICINE EBEWE 2 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009294670" ; OUTPUT ; 
code_ucd = 9294954 ; nom_court = "EVOLTRA 1 mg/ml solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01BB06" ; cod_ucd_chr = "0000009294954" ; OUTPUT ; 
code_ucd = 9295008 ; nom_court = "PREZISTA 300 mg comprime pellicule" ; cod_atc = "J05AE10" ; cod_ucd_chr = "0000009295008" ; OUTPUT ; 
code_ucd = 9295853 ; nom_court = "ENBREL 25 mg solution injectable en seringue preremplie" ; cod_atc = "L04AB01" ; cod_ucd_chr = "0000009295853" ; OUTPUT ; 
code_ucd = 9295876 ; nom_court = "ENBREL 25 mg/ml poudre et solvant pour solution injectable pour usage pediatrique" ; cod_atc = "L04AB01" ; cod_ucd_chr = "0000009295876" ; OUTPUT ; 
code_ucd = 9295882 ; nom_court = "ENBREL 50 mg solution injectable en seringue preremplie" ; cod_atc = "L04AB01" ; cod_ucd_chr = "0000009295882" ; OUTPUT ; 
code_ucd = 9296189 ; nom_court = "FLUCONAZOLE MYLAN PHARMA 2 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009296189" ; OUTPUT ; 
code_ucd = 9296195 ; nom_court = "FLUCONAZOLE MYLAN PHARMA 2 MG/ML Solution pour perfusion en flacon de 200 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009296195" ; OUTPUT ; 
code_ucd = 9296203 ; nom_court = "FLUCONAZOLE MYLAN PHARMA 2 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009296203" ; OUTPUT ; 
code_ucd = 9296829 ; nom_court = "PACLITAXEL EG 6 MG/ML solution a diluer pour perfusion en flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009296829" ; OUTPUT ; 
code_ucd = 9296835 ; nom_court = "PACLITAXEL EG 6 MG/ML solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009296835" ; OUTPUT ; 
code_ucd = 9296841 ; nom_court = "PACLITAXEL EG 6 MG/ML solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009296841" ; OUTPUT ; 
code_ucd = 9296858 ; nom_court = "PACLITAXEL EG 6 MG/ML solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009296858" ; OUTPUT ; 
code_ucd = 9297036 ; nom_court = "VIVAGLOBIN 160 MG/ML 1 Flacon de 3 ml, solution injectable" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009297036" ; OUTPUT ; 
code_ucd = 9297036 ; nom_court = "VIVAGLOBIN 160 MG/ML 1 Flacon de 3 ml, solution injectable" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009297036" ; OUTPUT ; 
code_ucd = 9297042 ; nom_court = "VIVAGLOBIN 160 MG/ML 1 Flacon de 20 ml, solution injectable" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009297042" ; OUTPUT ; 
code_ucd = 9297042 ; nom_court = "VIVAGLOBIN 160 MG/ML 1 Flacon de 20 ml, solution injectable" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009297042" ; OUTPUT ; 
code_ucd = 9297088 ; nom_court = "VINORELBINE HOSPIRA 10 MG/ML Solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009297088" ; OUTPUT ; 
code_ucd = 9297094 ; nom_court = "VINORELBINE TEVA 10 MG/ML Solution injectable en flacon de 1 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009297094" ; OUTPUT ; 
code_ucd = 9297102 ; nom_court = "VINORELBINE TEVA 10 MG/ML Solution injectable en flacon de 5 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009297102" ; OUTPUT ; 
code_ucd = 9297183 ; nom_court = "FLUCONAZOLE PANPHARMA 2 mg/ml solution pour perfusion en flacon de 100 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009297183" ; OUTPUT ; 
code_ucd = 9297208 ; nom_court = "FLUCONAZOLE PANPHARMA 2 mg/ml solution pour perfusion en flacon de 200 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009297208" ; OUTPUT ; 
code_ucd = 9297214 ; nom_court = "FLUCONAZOLE PANPHARMA 2 mg/ml solution pour perfusion en flacon de 50 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009297214" ; OUTPUT ; 
code_ucd = 9297332 ; nom_court = "HEXVIX 85 mg Poudre et solvant pour solution pour administration intravesicale" ; cod_atc = "V04CX" ; cod_ucd_chr = "0000009297332" ; OUTPUT ; 
code_ucd = 9297349 ; nom_court = "OXALIPLATINE MYLAN 5 MG/ML poudre pour solution pour perfusion en flacon de 100 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009297349" ; OUTPUT ; 
code_ucd = 9297355 ; nom_court = "OXALIPLATINE MYLAN 5 MG/ML poudre pour solution pour perfusion en flacon de 50 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009297355" ; OUTPUT ; 
code_ucd = 9297467 ; nom_court = "VENTAVIS 10 mcg/ml 1 Ampoule verre de 1 ml, solution pour inhalation par nebuliseur" ; cod_atc = "B01AC11" ; cod_ucd_chr = "0000009297467" ; OUTPUT ; 
code_ucd = 9297467 ; nom_court = "VENTAVIS 10 mcg/ml 1 Ampoule verre de 1 ml, solution pour inhalation par nebuliseur" ; cod_atc = "B01AC11" ; cod_ucd_chr = "0000009297467" ; OUTPUT ; 
code_ucd = 9298113 ; nom_court = "REVLIMID 10 MG gelule" ; cod_atc = "L04AX04" ; cod_ucd_chr = "0000009298113" ; OUTPUT ; 
code_ucd = 9298113 ; nom_court = "REVLIMID 10 MG gelule" ; cod_atc = "L04AX04" ; cod_ucd_chr = "0000009298113" ; OUTPUT ; 
code_ucd = 9298136 ; nom_court = "REVLIMID 15 MG gelule" ; cod_atc = "L04AX04" ; cod_ucd_chr = "0000009298136" ; OUTPUT ; 
code_ucd = 9298136 ; nom_court = "REVLIMID 15 MG gelule" ; cod_atc = "L04AX04" ; cod_ucd_chr = "0000009298136" ; OUTPUT ; 
code_ucd = 9298142 ; nom_court = "REVLIMID 25 MG gelule" ; cod_atc = "L04AX04" ; cod_ucd_chr = "0000009298142" ; OUTPUT ; 
code_ucd = 9298142 ; nom_court = "REVLIMID 25 MG gelule" ; cod_atc = "L04AX04" ; cod_ucd_chr = "0000009298142" ; OUTPUT ; 
code_ucd = 9298159 ; nom_court = "REVLIMID 5 MG gelule" ; cod_atc = "L04AX04" ; cod_ucd_chr = "0000009298159" ; OUTPUT ; 
code_ucd = 9298159 ; nom_court = "REVLIMID 5 MG gelule" ; cod_atc = "L04AX04" ; cod_ucd_chr = "0000009298159" ; OUTPUT ; 
code_ucd = 9298254 ; nom_court = "OXALIPLATINE HOSPIRA 5 MG/ML Poudre pour solution pour perfusion en flacon ONCO-TAIN de 100 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009298254" ; OUTPUT ; 
code_ucd = 9298260 ; nom_court = "OXALIPLATINE HOSPIRA 5 MG/ML Poudre pour solution pour perfusion en flacon ONCO-TAIN de 50 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009298260" ; OUTPUT ; 
code_ucd = 9298277 ; nom_court = "VINORELBINE HOSPIRA 10 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009298277" ; OUTPUT ; 
code_ucd = 9298461 ; nom_court = "THELIN 100 mg (sodium sitaxentan) 1 Boite de 28, comprime enrobe, plaquette alveolaire (PVC/aclar/alu)" ; cod_atc = "C02KX03" ; cod_ucd_chr = "0000009298461" ; OUTPUT ; 
code_ucd = 9298490 ; nom_court = "VINORELBINE NORDIC PHARMA 10 MG/ML 1 Flacon de 1 ml, solution injectable" ; cod_atc = " " ; cod_ucd_chr = "0000009298490" ; OUTPUT ; 
code_ucd = 9298509 ; nom_court = "VINORELBINE NORDIC PHARMA 10 MG/ML 1 Flacon de 5 ml, solution injectable" ; cod_atc = " " ; cod_ucd_chr = "0000009298509" ; OUTPUT ; 
code_ucd = 9298610 ; nom_court = "COPEGUS 400 mg comprime pellicule" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009298610" ; OUTPUT ; 
code_ucd = 9299207 ; nom_court = "SOLIRIS 300 MG Solution a diluer pour perfusion" ; cod_atc = "L04AA25" ; cod_ucd_chr = "0000009299207" ; OUTPUT ; 
code_ucd = 9299420 ; nom_court = "TMC 125 100 MG Comprime" ; cod_atc = "J05AG04" ; cod_ucd_chr = "0000009299420" ; OUTPUT ; 
code_ucd = 9299443 ; nom_court = "PACLITAXEL SANDOZ 6 MG/ML 1 Flacon de 16,7 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009299443" ; OUTPUT ; 
code_ucd = 9299466 ; nom_court = "PACLITAXEL SANDOZ 6 MG/ML 1 Flacon de 25 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009299466" ; OUTPUT ; 
code_ucd = 9299472 ; nom_court = "PACLITAXEL SANDOZ 6 MG/ML 1 Flacon de 5 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009299472" ; OUTPUT ; 
code_ucd = 9299489 ; nom_court = "PACLITAXEL SANDOZ 6 MG/ML 1 Flacon de 50 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009299489" ; OUTPUT ; 
code_ucd = 9300175 ; nom_court = "SIRDALUD 4 MG comprime secable" ; cod_atc = "M03BX02" ; cod_ucd_chr = "0000009300175" ; OUTPUT ; 
code_ucd = 9300181 ; nom_court = "ORENCIA 250 mg 1 Flacon, poudre pour solution a diluer pour perfusion" ; cod_atc = "L04AA24" ; cod_ucd_chr = "0000009300181" ; OUTPUT ; 
code_ucd = 9300749 ; nom_court = "RIAMET 20 MG/120 MG Comprime" ; cod_atc = "P01BF01" ; cod_ucd_chr = "0000009300749" ; OUTPUT ; 
code_ucd = 9300956 ; nom_court = "SEBIVO 600 MG Comprime pellicule" ; cod_atc = "J05AF11" ; cod_ucd_chr = "0000009300956" ; OUTPUT ; 
code_ucd = 9301111 ; nom_court = "ERBITUX 5 mg/ml 1 Flacon de 100 ml, solution pour perfusion" ; cod_atc = "L01XC06" ; cod_ucd_chr = "0000009301111" ; OUTPUT ; 
code_ucd = 9301128 ; nom_court = "ERBITUX 5 mg/ml 1 Flacon de 20 ml, solution pour perfusion" ; cod_atc = "L01XC06" ; cod_ucd_chr = "0000009301128" ; OUTPUT ; 
code_ucd = 9301163 ; nom_court = "OXALIPLATINE RATIOPHARM 5 MG/ML 1 Flacon de 100 mg, poudre pour solution pour perfusion" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009301163" ; OUTPUT ; 
code_ucd = 9301186 ; nom_court = "OXALIPLATINE RATIOPHARM 5 MG/ML 1 Flacon de 50 mg, poudre pour solution pour perfusion" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009301186" ; OUTPUT ; 
code_ucd = 9301393 ; nom_court = "OXALIPLATINE EBEWE 5 MG/ML Poudre pour solution pour perfusion en flacon de 100 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009301393" ; OUTPUT ; 
code_ucd = 9301401 ; nom_court = "OXALIPLATINE EBEWE 5 MG/ML Poudre pour solution pour perfusion en flacon de 50 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009301401" ; OUTPUT ; 
code_ucd = 9302139 ; nom_court = "OXALIPLATINE MEDAC 5 MG/ML 1 Flacon de 100 mg, poudre pour solution pour perfusion" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009302139" ; OUTPUT ; 
code_ucd = 9302145 ; nom_court = "OXALIPLATINE MEDAC 5 MG/ML 1 Flacon de 50 mg, poudre pour solution pour perfusion" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009302145" ; OUTPUT ; 
code_ucd = 9302286 ; nom_court = "CARBOPLATINE HOSPIRA 10 MG/ ML solution injectable pour perfusion en flacon de 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009302286" ; OUTPUT ; 
code_ucd = 9302292 ; nom_court = "CARBOPLATINE HOSPIRA 10 MG/ ML solution injectable pour perfusion en flacon de 5 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009302292" ; OUTPUT ; 
code_ucd = 9302300 ; nom_court = "CARBOPLATINE HOSPIRA 10 MG/ ML solution injectable pour perfusion A/F 60 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009302300" ; OUTPUT ; 
code_ucd = 9302323 ; nom_court = "CARBOPLATINE HOSPIRA 10 MG/ ML solution injectable pour perfusion en flacon de 15 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009302323" ; OUTPUT ; 
code_ucd = 9303386 ; nom_court = "FLUCONAZOLE REDIBAG 2 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009303386" ; OUTPUT ; 
code_ucd = 9303392 ; nom_court = "FLUCONAZOLE REDIBAG 2 MG/ML Solution pour perfusion en flacon de 200 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009303392" ; OUTPUT ; 
code_ucd = 9303400 ; nom_court = "FLUCONAZOLE REDIBAG 2 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009303400" ; OUTPUT ; 
code_ucd = 9303682 ; nom_court = "GAMMANORM 165 mg/ml 1 Flacon de 10 ml, solution injectable" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009303682" ; OUTPUT ; 
code_ucd = 9303682 ; nom_court = "GAMMANORM 165 mg/ml 1 Flacon de 10 ml, solution injectable" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009303682" ; OUTPUT ; 
code_ucd = 9303699 ; nom_court = "GAMMANORM 165 mg/ml 1 Flacon de 20 ml, solution injectable" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009303699" ; OUTPUT ; 
code_ucd = 9303699 ; nom_court = "GAMMANORM 165 mg/ml 1 Flacon de 20 ml, solution injectable" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009303699" ; OUTPUT ; 
code_ucd = 9303877 ; nom_court = "ISENTRESS 400 MG Comprime pellicule" ; cod_atc = "J05AX08" ; cod_ucd_chr = "0000009303877" ; OUTPUT ; 
code_ucd = 9304256 ; nom_court = "BENEFIX 1 000 UI Poudre et solvant pour solution injectable + dispositif de reconstitution" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009304256" ; OUTPUT ; 
code_ucd = 9304256 ; nom_court = "BENEFIX 1 000 UI Poudre et solvant pour solution injectable + dispositif de reconstitution" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009304256" ; OUTPUT ; 
code_ucd = 9304262 ; nom_court = "BENEFIX 2 000 UI Poudre et solvant pour solution injectable + dispositif de reconstitution" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009304262" ; OUTPUT ; 
code_ucd = 9304262 ; nom_court = "BENEFIX 2 000 UI Poudre et solvant pour solution injectable + dispositif de reconstitution" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009304262" ; OUTPUT ; 
code_ucd = 9304279 ; nom_court = "BENEFIX 250 UI Poudre et solvant pour solution injectable + dispositif de reconstitution" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009304279" ; OUTPUT ; 
code_ucd = 9304279 ; nom_court = "BENEFIX 250 UI Poudre et solvant pour solution injectable + dispositif de reconstitution" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009304279" ; OUTPUT ; 
code_ucd = 9304285 ; nom_court = "BENEFIX 500 UI Poudre et solvant pour solution injectable + dispositif de reconstitution" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009304285" ; OUTPUT ; 
code_ucd = 9304285 ; nom_court = "BENEFIX 500 UI Poudre et solvant pour solution injectable + dispositif de reconstitution" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009304285" ; OUTPUT ; 
code_ucd = 9304434 ; nom_court = "ARANESP 130 microgrammes solution injectable en seringue preremplie 0,65 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009304434" ; OUTPUT ; 
code_ucd = 9304440 ; nom_court = "ARANESP 130 microgrammes solution injectable en stylo prerempli 0,65 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009304440" ; OUTPUT ; 
code_ucd = 9304457 ; nom_court = "EPIRUBICINE MYLAN 2 MG/ML 1 Flacon de 10 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009304457" ; OUTPUT ; 
code_ucd = 9304463 ; nom_court = "EPIRUBICINE MYLAN 2 MG/ML 1 Flacon de 100 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009304463" ; OUTPUT ; 
code_ucd = 9304486 ; nom_court = "EPIRUBICINE MYLAN 2 MG/ML 1 Flacon de 25 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009304486" ; OUTPUT ; 
code_ucd = 9304492 ; nom_court = "EPIRUBICINE MYLAN 2 MG/ML 1 Flacon de 5 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009304492" ; OUTPUT ; 
code_ucd = 9304718 ; nom_court = "ATRIANCE 5 MG/ML 1 Flacon de 50 ml, solution pour perfusion" ; cod_atc = "L01BB07" ; cod_ucd_chr = "0000009304718" ; OUTPUT ; 
code_ucd = 9304776 ; nom_court = "TORISEL 25 MG/ML Solution a diluer et diluant pour solution pour perfusion" ; cod_atc = "L01XE09" ; cod_ucd_chr = "0000009304776" ; OUTPUT ; 
code_ucd = 9305095 ; nom_court = "EPIRUBICINE SANDOZ 2 MG/ML 1 Flacon de 10 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009305095" ; OUTPUT ; 
code_ucd = 9305103 ; nom_court = "EPIRUBICINE SANDOZ 2 MG/ML 1 Flacon de 100 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009305103" ; OUTPUT ; 
code_ucd = 9305126 ; nom_court = "EPIRUBICINE SANDOZ 2 MG/ML 1 Flacon de 25 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009305126" ; OUTPUT ; 
code_ucd = 9305132 ; nom_court = "EPIRUBICINE SANDOZ 2 MG/ML 1 Flacon de 5 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009305132" ; OUTPUT ; 
code_ucd = 9305304 ; nom_court = "FERRISAT 50 MG/ML 1 Ampoule de 2 ml, solution injectable ou pour perfusion" ; cod_atc = "B03AC06" ; cod_ucd_chr = "0000009305304" ; OUTPUT ; 
code_ucd = 9305379 ; nom_court = "PACLITAXEL MYLAN PHARMA 6 MG/ML 1 Flacon de 16,7 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009305379" ; OUTPUT ; 
code_ucd = 9305385 ; nom_court = "PACLITAXEL MYLAN PHARMA 6 MG/ML 1 Flacon de 5 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009305385" ; OUTPUT ; 
code_ucd = 9305391 ; nom_court = "PACLITAXEL MYLAN PHARMA 6 MG/ML 1 Flacon de 50 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009305391" ; OUTPUT ; 
code_ucd = 9306605 ; nom_court = "EPIRUBICINE EG 2 MG/ML solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009306605" ; OUTPUT ; 
code_ucd = 9306611 ; nom_court = "EPIRUBICINE EG 2 MG/ML solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009306611" ; OUTPUT ; 
code_ucd = 9306628 ; nom_court = "EPIRUBICINE EG 2 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009306628" ; OUTPUT ; 
code_ucd = 9306634 ; nom_court = "EPIRUBICINE PANPHARMA 2 MG/ML 1 Flacon de 10 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009306634" ; OUTPUT ; 
code_ucd = 9306640 ; nom_court = "EPIRUBICINE PANPHARMA 2 MG/ML 1 Flacon de 100 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009306640" ; OUTPUT ; 
code_ucd = 9306657 ; nom_court = "EPIRUBICINE PANPHARMA 2 MG/ML 1 Flacon de 25 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009306657" ; OUTPUT ; 
code_ucd = 9306663 ; nom_court = "EPIRUBICINE PANPHARMA 2 MG/ML 1 Flacon de 5 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009306663" ; OUTPUT ; 
code_ucd = 9306686 ; nom_court = "EPIRUBICINE PANPHARMA 2 MG/ML 1 Flacon de 50 ml, solution pour perfusion" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009306686" ; OUTPUT ; 
code_ucd = 9306870 ; nom_court = "PRIALT 100 MICROGRAMMES/ML Solution injectable pour perfusion en flacon de 1 ml" ; cod_atc = "N02BG08" ; cod_ucd_chr = "0000009306870" ; OUTPUT ; 
code_ucd = 9306887 ; nom_court = "PRIALT 100 MICROGRAMMES/ML Solution injectable pour perfusion en flacon de 5 ml" ; cod_atc = "N02BG08" ; cod_ucd_chr = "0000009306887" ; OUTPUT ; 
code_ucd = 9307160 ; nom_court = "VECTIBIX 20 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009307160" ; OUTPUT ; 
code_ucd = 9307177 ; nom_court = "VECTIBIX 20 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01XC08" ; cod_ucd_chr = "0000009307177" ; OUTPUT ; 
code_ucd = 9307183 ; nom_court = "VECTIBIX 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XC08" ; cod_ucd_chr = "0000009307183" ; OUTPUT ; 
code_ucd = 9307562 ; nom_court = "HUMIRA 40 MG 1 Stylo prerempli de 0,8 ml, solution injectable" ; cod_atc = "L04AB04" ; cod_ucd_chr = "0000009307562" ; OUTPUT ; 
code_ucd = 9307800 ; nom_court = "FLUDARABINE TEVA 25 MG/ML 1 Flacon de 2 ml, solution a diluer injectable ou pour perfusion" ; cod_atc = "L01BB05" ; cod_ucd_chr = "0000009307800" ; OUTPUT ; 
code_ucd = 9308188 ; nom_court = "DOXORUBICINE EG 2 MG/ML solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009308188" ; OUTPUT ; 
code_ucd = 9308254 ; nom_court = "PACLITAXEL TEVA 6 MG/ML 1 Flacon de 25 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009308254" ; OUTPUT ; 
code_ucd = 9308679 ; nom_court = "ATRIPLA 600 MG/200 MG/245 MG Comprime pellicule" ; cod_atc = "J05AR06" ; cod_ucd_chr = "0000009308679" ; OUTPUT ; 
code_ucd = 9308857 ; nom_court = "OXALIPLATINE TEVA 5 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009308857" ; OUTPUT ; 
code_ucd = 9308863 ; nom_court = "OXALIPLATINE TEVA 5 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009308863" ; OUTPUT ; 
code_ucd = 9308923 ; nom_court = "PACLITAXEL HOSPIRA 6 MG/ML Solution a diluer pour perfusion, flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009308923" ; OUTPUT ; 
code_ucd = 9308946 ; nom_court = "PACLITAXEL HOSPIRA 6 MG/ML Solution a diluer pour perfusion, flacon de 25 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009308946" ; OUTPUT ; 
code_ucd = 9308952 ; nom_court = "PACLITAXEL HOSPIRA 6 MG/ML Solution a diluer pour perfusion, flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009308952" ; OUTPUT ; 
code_ucd = 9308969 ; nom_court = "PACLITAXEL HOSPIRA 6 MG/ML Solution a diluer pour perfusion, flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009308969" ; OUTPUT ; 
code_ucd = 9309012 ; nom_court = "FLUCONAZOLE PHARMAKAL 2 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009309012" ; OUTPUT ; 
code_ucd = 9309029 ; nom_court = "FLUCONAZOLE PHARMAKAL 2 MG/ML Solution pour perfusion en flacon de 200 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009309029" ; OUTPUT ; 
code_ucd = 9309035 ; nom_court = "FLUCONAZOLE PHARMAKAL 2 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009309035" ; OUTPUT ; 
code_ucd = 9309549 ; nom_court = "KOGENATE BAYER 2 000 UI Poudre et solvant pour solution injectable avec systeme Bioset + seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009309549" ; OUTPUT ; 
code_ucd = 9309549 ; nom_court = "KOGENATE BAYER 2 000 UI Poudre et solvant pour solution injectable avec systeme Bioset + seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009309549" ; OUTPUT ; 
code_ucd = 9309779 ; nom_court = "GEMCITABINE HOSPIRA 1 G Poudre pour solution pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009309779" ; OUTPUT ; 
code_ucd = 9309785 ; nom_court = "GEMCITABINE HOSPIRA 2 G Poudre pour solution pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009309785" ; OUTPUT ; 
code_ucd = 9309791 ; nom_court = "GEMCITABINE HOSPIRA 200 MG Poudre pour solution pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009309791" ; OUTPUT ; 
code_ucd = 9310512 ; nom_court = "HELIXATE NEXGEN 2 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009310512" ; OUTPUT ; 
code_ucd = 9310512 ; nom_court = "HELIXATE NEXGEN 2 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009310512" ; OUTPUT ; 
code_ucd = 9310587 ; nom_court = "MITOXANTRONE TEVA 2 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009310587" ; OUTPUT ; 
code_ucd = 9310593 ; nom_court = "MITOXANTRONE TEVA 2 MG/ML Solution a diluer pour perfusion en flacon de 12,5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009310593" ; OUTPUT ; 
code_ucd = 9310601 ; nom_court = "MITOXANTRONE TEVA 2 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009310601" ; OUTPUT ; 
code_ucd = 9311204 ; nom_court = "BINOCRIT 1 000 UI/0,5 ML Solution injectable en seringue preremplie de 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311204" ; OUTPUT ; 
code_ucd = 9311210 ; nom_court = "BINOCRIT 10 000 UI/1 ML Solution injectable en seringue preremplie de 1 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311210" ; OUTPUT ; 
code_ucd = 9311227 ; nom_court = "BINOCRIT 2 000 UI/1 ML Solution injectable en seringue preremplie de 1 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311227" ; OUTPUT ; 
code_ucd = 9311233 ; nom_court = "BINOCRIT 3 000 UI/0,3 ML Solution injectable en seringue preremplie de 0,3 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311233" ; OUTPUT ; 
code_ucd = 9311256 ; nom_court = "BINOCRIT 4 000 UI/0,4 ML Solution injectable en seringue preremplie de 0,4 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311256" ; OUTPUT ; 
code_ucd = 9311262 ; nom_court = "BINOCRIT 5 000 UI/0,5 ML Solution injectable en seringue preremplie de 0,5 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311262" ; OUTPUT ; 
code_ucd = 9311279 ; nom_court = "BINOCRIT 6 000 UI/0,6 ML Solution injectable en seringue preremplie de 0,6 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311279" ; OUTPUT ; 
code_ucd = 9311285 ; nom_court = "BINOCRIT 8 000 UI/0,8 ML Solution injectable en seringue preremplie de 0,8 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311285" ; OUTPUT ; 
code_ucd = 9311581 ; nom_court = "HYCAMTIN 0,25 MG Gelule" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009311581" ; OUTPUT ; 
code_ucd = 9311598 ; nom_court = "HYCAMTIN 1 MG Gelule" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009311598" ; OUTPUT ; 
code_ucd = 9311658 ; nom_court = "VEDROP 50 MG/ML Flacon de 20 ml, solution buvable" ; cod_atc = "A11HA08" ; cod_ucd_chr = "0000009311658" ; OUTPUT ; 
code_ucd = 9311664 ; nom_court = "VEDROP 50 MG/ML Flacon de 60 ml, solution buvable" ; cod_atc = "A11HA08" ; cod_ucd_chr = "0000009311664" ; OUTPUT ; 
code_ucd = 9311670 ; nom_court = "ALIMTA 100 MG Poudre pour solution a diluer pour perfusion" ; cod_atc = "L01BA04" ; cod_ucd_chr = "0000009311670" ; OUTPUT ; 
code_ucd = 9311670 ; nom_court = "ALIMTA 100 MG Poudre pour solution a diluer pour perfusion" ; cod_atc = "L01BA04" ; cod_ucd_chr = "0000009311670" ; OUTPUT ; 
code_ucd = 9311687 ; nom_court = "EPREX 40 000 UI/ML solution injectable en seringue preremplie 0,75 ml" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009311687" ; OUTPUT ; 
code_ucd = 9312072 ; nom_court = "KALETRA 100 MG/25 MG Comprime pellicule" ; cod_atc = "J05AR10" ; cod_ucd_chr = "0000009312072" ; OUTPUT ; 
code_ucd = 9312600 ; nom_court = "VINORELBINE MYLAN 10 MG/ML Solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009312600" ; OUTPUT ; 
code_ucd = 9312617 ; nom_court = "VINORELBINE MYLAN 10 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009312617" ; OUTPUT ; 
code_ucd = 9312646 ; nom_court = "OXALIPLATINE RATIOPHARM 5 MG/ML Poudre pour solution pour perfusion en flacon de 150 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009312646" ; OUTPUT ; 
code_ucd = 9312652 ; nom_court = "PRIVIGEN 100 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009312652" ; OUTPUT ; 
code_ucd = 9312652 ; nom_court = "PRIVIGEN 100 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009312652" ; OUTPUT ; 
code_ucd = 9312669 ; nom_court = "PRIVIGEN 100 MG/ML Solution pour perfusion en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009312669" ; OUTPUT ; 
code_ucd = 9312669 ; nom_court = "PRIVIGEN 100 MG/ML Solution pour perfusion en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009312669" ; OUTPUT ; 
code_ucd = 9312675 ; nom_court = "PRIVIGEN 100 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009312675" ; OUTPUT ; 
code_ucd = 9312675 ; nom_court = "PRIVIGEN 100 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009312675" ; OUTPUT ; 
code_ucd = 9312698 ; nom_court = "FLUDARABINE MYLAN 25 MG/ML Poudre pour solution injectable ou perfusion en flacon" ; cod_atc = "L01BB05" ; cod_ucd_chr = "0000009312698" ; OUTPUT ; 
code_ucd = 9312758 ; nom_court = "FLUDARABINE PHOSPHATE HOSPIRA 50 MG Poudre pour solution injectable ou perfusion, flacon de 50 mg" ; cod_atc = "L01BB05" ; cod_ucd_chr = "0000009312758" ; OUTPUT ; 
code_ucd = 9312793 ; nom_court = "OXALIPLATINE HOSPIRA 5 MG/ML Solution a diluer pour perfusion en" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009312793" ; OUTPUT ; 
code_ucd = 9312801 ; nom_court = "OXALIPLATINE HOSPIRA 5 MG/ML Solution a diluer pour perfusion en flacon ONCO-TAIN de 20 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009312801" ; OUTPUT ; 
code_ucd = 9312907 ; nom_court = "REYATAZ 300 MG gelule" ; cod_atc = "J05AE08" ; cod_ucd_chr = "0000009312907" ; OUTPUT ; 
code_ucd = 9312936 ; nom_court = "FERRISAT 50 MG/ML Solution injectable ou pour perfusion en ampoule de 10 ml" ; cod_atc = "B03AC06" ; cod_ucd_chr = "0000009312936" ; OUTPUT ; 
code_ucd = 9312942 ; nom_court = "FLUCONAZOLE MYLAN 2 MG/ML Solution pour perfusion en poche polyolefine suremballee de 100 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009312942" ; OUTPUT ; 
code_ucd = 9312959 ; nom_court = "FLUCONAZOLE MYLAN 2 MG/ML Solution pour perfusion en poche polyolefine suremballee de 200 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009312959" ; OUTPUT ; 
code_ucd = 9312965 ; nom_court = "FLUCONAZOLE MYLAN 2 MG/ML Solution pour perfusion en poche polyolefine suremballee de 50 ml" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009312965" ; OUTPUT ; 
code_ucd = 9313137 ; nom_court = "EPIRUBICINE MEDAC 2 MG/ML solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009313137" ; OUTPUT ; 
code_ucd = 9313143 ; nom_court = "EPIRUBICINE MEDAC 2 MG/ML Solution pour perfusion en flacon de 200 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009313143" ; OUTPUT ; 
code_ucd = 9313166 ; nom_court = "EPIRUBICINE MEDAC 2 MG/ML solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009313166" ; OUTPUT ; 
code_ucd = 9313172 ; nom_court = "EPIRUBICINE MEDAC 2 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009313172" ; OUTPUT ; 
code_ucd = 9313189 ; nom_court = "EPIRUBICINE MEDAC 2 MG/ML solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009313189" ; OUTPUT ; 
code_ucd = 9313290 ; nom_court = "FLUCONAZOLE AGUETTANT 2 MG/ML Solution pour perfusion en poche de 100 ml avec site de connexion et d'injection" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009313290" ; OUTPUT ; 
code_ucd = 9313309 ; nom_court = "FLUCONAZOLE AGUETTANT 2 MG/ML Solution pour perfusion en poche de 200 ml avec site de connexion et d'injection" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009313309" ; OUTPUT ; 
code_ucd = 9313315 ; nom_court = "FLUCONAZOLE AGUETTANT 2 MG/ML Solution pour perfusion en poche de 50 ml avec site de connexion et d'injection" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009313315" ; OUTPUT ; 
code_ucd = 9313870 ; nom_court = "MIRCERA 100 MCG/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009313870" ; OUTPUT ; 
code_ucd = 9313887 ; nom_court = "MIRCERA 150 MCG/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009313887" ; OUTPUT ; 
code_ucd = 9313893 ; nom_court = "MIRCERA 200 MCG/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009313893" ; OUTPUT ; 
code_ucd = 9313901 ; nom_court = "MIRCERA 250 MCG/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009313901" ; OUTPUT ; 
code_ucd = 9313918 ; nom_court = "MIRCERA 50 MCG/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009313918" ; OUTPUT ; 
code_ucd = 9313924 ; nom_court = "MIRCERA 75 MCG/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009313924" ; OUTPUT ; 
code_ucd = 9314415 ; nom_court = "OXALIPLATINE EBEWE 5 MG/ML Poudre pour solution pour perfusion en flacon verre de 150 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009314415" ; OUTPUT ; 
code_ucd = 9314421 ; nom_court = "MYCAMINE 100 MG Poudre pour solution pour perfusion" ; cod_atc = "J02AX05" ; cod_ucd_chr = "0000009314421" ; OUTPUT ; 
code_ucd = 9314421 ; nom_court = "MYCAMINE 100 MG Poudre pour solution pour perfusion" ; cod_atc = "J02AX05" ; cod_ucd_chr = "0000009314421" ; OUTPUT ; 
code_ucd = 9314438 ; nom_court = "MYCAMINE 50 MG Poudre pour solution pour perfusion" ; cod_atc = "J02AX05" ; cod_ucd_chr = "0000009314438" ; OUTPUT ; 
code_ucd = 9314438 ; nom_court = "MYCAMINE 50 MG Poudre pour solution pour perfusion" ; cod_atc = "J02AX05" ; cod_ucd_chr = "0000009314438" ; OUTPUT ; 
code_ucd = 9314591 ; nom_court = "GEMCITABINE MYLAN 38 MG/ML Poudre pour solution pour perfusion en flacon 1 000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009314591" ; OUTPUT ; 
code_ucd = 9314616 ; nom_court = "GEMCITABINE MYLAN 38 MG/ML Poudre pour solution pour perfusion en flacon 200 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009314616" ; OUTPUT ; 
code_ucd = 9315604 ; nom_court = "RETACRIT 1 000 UI/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315604" ; OUTPUT ; 
code_ucd = 9315610 ; nom_court = "RETACRIT 10 000 UI/1 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315610" ; OUTPUT ; 
code_ucd = 9315627 ; nom_court = "RETACRIT 2 000 UI/0,6 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315627" ; OUTPUT ; 
code_ucd = 9315633 ; nom_court = "RETACRIT 20 000 UI/0,5 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315633" ; OUTPUT ; 
code_ucd = 9315656 ; nom_court = "RETACRIT 3 000 UI/0,9 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315656" ; OUTPUT ; 
code_ucd = 9315662 ; nom_court = "RETACRIT 30 000 UI/0,75 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315662" ; OUTPUT ; 
code_ucd = 9315679 ; nom_court = "RETACRIT 4 000 UI/0,4 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315679" ; OUTPUT ; 
code_ucd = 9315685 ; nom_court = "RETACRIT 40 000 UI/1 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315685" ; OUTPUT ; 
code_ucd = 9315691 ; nom_court = "RETACRIT 5 000 UI/0,5 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315691" ; OUTPUT ; 
code_ucd = 9315716 ; nom_court = "RETACRIT 6 000 UI/0,6 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315716" ; OUTPUT ; 
code_ucd = 9315722 ; nom_court = "RETACRIT 8 000 UI/0,8 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009315722" ; OUTPUT ; 
code_ucd = 9315768 ; nom_court = "ADVATE 2 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009315768" ; OUTPUT ; 
code_ucd = 9315768 ; nom_court = "ADVATE 2 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009315768" ; OUTPUT ; 
code_ucd = 9315774 ; nom_court = "ADVATE 3 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009315774" ; OUTPUT ; 
code_ucd = 9315774 ; nom_court = "ADVATE 3 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009315774" ; OUTPUT ; 
code_ucd = 9315892 ; nom_court = "DOXORUBICINE ACTAVIS 2 MG/ML Poudre pour solution pour perfusion en flacon de 10 mg" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009315892" ; OUTPUT ; 
code_ucd = 9315900 ; nom_court = "DOXORUBICINE ACTAVIS 2 MG/ML Poudre pour solution pour perfusion en flacon de 50 mg" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009315900" ; OUTPUT ; 
code_ucd = 9316035 ; nom_court = "VOLIBRIS 10 MG Comprime pellicule" ; cod_atc = "C02KX02" ; cod_ucd_chr = "0000009316035" ; OUTPUT ; 
code_ucd = 9316041 ; nom_court = "VOLIBRIS 5 MG Comprime pellicule" ; cod_atc = "C02KX02" ; cod_ucd_chr = "0000009316041" ; OUTPUT ; 
code_ucd = 9316058 ; nom_court = "EPIRUBICINE ACTAVIS 2 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009316058" ; OUTPUT ; 
code_ucd = 9316064 ; nom_court = "EPIRUBICINE ACTAVIS 2 MG/ML Solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009316064" ; OUTPUT ; 
code_ucd = 9316070 ; nom_court = "EPIRUBICINE ACTAVIS 2 MG/ML Solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009316070" ; OUTPUT ; 
code_ucd = 9316207 ; nom_court = "CARBOPLATINE ACTAVIS 10 MG/ML Solution pour perfusion en flacon de 15 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009316207" ; OUTPUT ; 
code_ucd = 9316213 ; nom_court = "CARBOPLATINE ACTAVIS 10 MG/ML Solution pour perfusion en flacon de 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009316213" ; OUTPUT ; 
code_ucd = 9316236 ; nom_court = "CARBOPLATINE ACTAVIS 10 MG/ML Solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009316236" ; OUTPUT ; 
code_ucd = 9316242 ; nom_court = "CARBOPLATINE ACTAVIS 10 MG/ML Solution pour perfusion en flacon de 60 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009316242" ; OUTPUT ; 
code_ucd = 9316710 ; nom_court = "FLUDARABINE ACTAVIS 25 MG/ML Poudre pour solution injectable ou perfusion en flacon de 50 mg" ; cod_atc = "L01BB05" ; cod_ucd_chr = "0000009316710" ; OUTPUT ; 
code_ucd = 9316874 ; nom_court = "INTELENCE 100 MG Comprime en flacon" ; cod_atc = "J05AG04" ; cod_ucd_chr = "0000009316874" ; OUTPUT ; 
code_ucd = 9317170 ; nom_court = "CAMPTO 20 MG/ML Solution a diluer pour perfusion en flacon polypropylene de 15 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009317170" ; OUTPUT ; 
code_ucd = 9317187 ; nom_court = "CAMPTO 20 MG/ML Solution a diluer pour perfusion en flacon polypropylene de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009317187" ; OUTPUT ; 
code_ucd = 9317193 ; nom_court = "CAMPTO 20 MG/ML Solution a diluer pour perfusion en flacon polypropylene de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009317193" ; OUTPUT ; 
code_ucd = 9317276 ; nom_court = "CELSENTRI 150 MG Comprime pellicule" ; cod_atc = "J05AX09" ; cod_ucd_chr = "0000009317276" ; OUTPUT ; 
code_ucd = 9317282 ; nom_court = "CELSENTRI 300 MG Comprime pellicule" ; cod_atc = "J05AX09" ; cod_ucd_chr = "0000009317282" ; OUTPUT ; 
code_ucd = 9318465 ; nom_court = "GEMCITABINE INTAS 1 000 MG Solution a diluer pour perfusion en flacon" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009318465" ; OUTPUT ; 
code_ucd = 9318471 ; nom_court = "GEMCITABINE INTAS 200 MG Poudre pour solution pour perfusion en flacon" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009318471" ; OUTPUT ; 
code_ucd = 9318873 ; nom_court = "NOVOSEVEN 1 MG (50 KUI) Poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009318873" ; OUTPUT ; 
code_ucd = 9318873 ; nom_court = "NOVOSEVEN 1 MG (50 KUI) Poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009318873" ; OUTPUT ; 
code_ucd = 9318896 ; nom_court = "NOVOSEVEN 2 MG (100 KUI) Poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009318896" ; OUTPUT ; 
code_ucd = 9318896 ; nom_court = "NOVOSEVEN 2 MG (100 KUI) Poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009318896" ; OUTPUT ; 
code_ucd = 9318904 ; nom_court = "NOVOSEVEN 5 MG (250 KUI) Poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009318904" ; OUTPUT ; 
code_ucd = 9318904 ; nom_court = "NOVOSEVEN 5 MG (250 KUI) Poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009318904" ; OUTPUT ; 
code_ucd = 9318910 ; nom_court = "VELCADE 1 MG Poudre pour solution injectable" ; cod_atc = "L01XX32" ; cod_ucd_chr = "0000009318910" ; OUTPUT ; 
code_ucd = 9318910 ; nom_court = "VELCADE 1 MG Poudre pour solution injectable" ; cod_atc = "L01XX32" ; cod_ucd_chr = "0000009318910" ; OUTPUT ; 
code_ucd = 9319022 ; nom_court = "PACLITAXEL EBEWE 6 MG/ML Solution a diluer pour perfusion en flacon de 100 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009319022" ; OUTPUT ; 
code_ucd = 9319358 ; nom_court = "BUSILVEX 6 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01AB01" ; cod_ucd_chr = "0000009319358" ; OUTPUT ; 
code_ucd = 9319364 ; nom_court = "VIMPAT 100 MG 1 Boite de 56, comprimes pellicules" ; cod_atc = "N03AX18" ; cod_ucd_chr = "0000009319364" ; OUTPUT ; 
code_ucd = 9319370 ; nom_court = "VIMPAT 200 MG 1 Boite de 56, comprimes pellicules" ; cod_atc = "N03AX18" ; cod_ucd_chr = "0000009319370" ; OUTPUT ; 
code_ucd = 9319387 ; nom_court = "VIMPAT 50 MG 1 Boite de 56, comprimes pellicules" ; cod_atc = "N03AX18" ; cod_ucd_chr = "0000009319387" ; OUTPUT ; 
code_ucd = 9319708 ; nom_court = "EPIRUBICINE ACTAVIS 2 MG/ML Solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009319708" ; OUTPUT ; 
code_ucd = 9319714 ; nom_court = "EPIRUBICINE ACTAVIS 2 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009319714" ; OUTPUT ; 
code_ucd = 9319720 ; nom_court = "OXALIPLATINE ACTAVIS 5 MG/ML poudre pour solution pour perfusion, flacon de 100 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009319720" ; OUTPUT ; 
code_ucd = 9319737 ; nom_court = "OXALIPLATINE ACTAVIS 5 MG/ML poudre pour solution pour perfusion, flacon de 50 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009319737" ; OUTPUT ; 
code_ucd = 9320054 ; nom_court = "CARBOPLATINE INTAS 10 MG/ML Solution pour perfusion en flacon de 15 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009320054" ; OUTPUT ; 
code_ucd = 9320060 ; nom_court = "CARBOPLATINE INTAS 10 MG/ML Solution pour perfusion en flacon de 45 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009320060" ; OUTPUT ; 
code_ucd = 9320077 ; nom_court = "CARBOPLATINE INTAS 10 MG/ML Solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01XA02" ; cod_ucd_chr = "0000009320077" ; OUTPUT ; 
code_ucd = 9320166 ; nom_court = "FIRAZYR 30 MG Solution injectable en seringue preremplie de 3 ml" ; cod_atc = "C01EB" ; cod_ucd_chr = "0000009320166" ; OUTPUT ; 
code_ucd = 9320166 ; nom_court = "FIRAZYR 30 MG Solution injectable en seringue preremplie de 3 ml" ; cod_atc = "C01EB" ; cod_ucd_chr = "0000009320166" ; OUTPUT ; 
code_ucd = 9320700 ; nom_court = "ABSEAMED 1 000 UI/0,5 ML Solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009320700" ; OUTPUT ; 
code_ucd = 9320717 ; nom_court = "ABSEAMED 10 000 UI/1 ML Solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009320717" ; OUTPUT ; 
code_ucd = 9320723 ; nom_court = "ABSEAMED 2 000 UI/1 ML Solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009320723" ; OUTPUT ; 
code_ucd = 9320746 ; nom_court = "ABSEAMED 3 000 UI/0,3 ML Solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009320746" ; OUTPUT ; 
code_ucd = 9320752 ; nom_court = "ABSEAMED 4 000 UI/0,4 ML Solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009320752" ; OUTPUT ; 
code_ucd = 9320769 ; nom_court = "ABSEAMED 5 000 UI/0,5 ML Solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009320769" ; OUTPUT ; 
code_ucd = 9320775 ; nom_court = "ABSEAMED 6 000 UI/0,6 ML Solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009320775" ; OUTPUT ; 
code_ucd = 9320781 ; nom_court = "ABSEAMED 8 000 UI/0,8 ML Solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009320781" ; OUTPUT ; 
code_ucd = 9321036 ; nom_court = "IRINOTECAN ACTAVIS 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009321036" ; OUTPUT ; 
code_ucd = 9321042 ; nom_court = "IRINOTECAN ACTAVIS 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009321042" ; OUTPUT ; 
code_ucd = 9321734 ; nom_court = "PASER 4 G granules gastro-resistants en sachet" ; cod_atc = "J04AA01" ; cod_ucd_chr = "0000009321734" ; OUTPUT ; 
code_ucd = 9321740 ; nom_court = "FER MYLAN 100 MG/5 ML Solution a diluer pour perfusion" ; cod_atc = "B03AC02" ; cod_ucd_chr = "0000009321740" ; OUTPUT ; 
code_ucd = 9322231 ; nom_court = "GEMCITABINE RATIOPHARM 1 G Poudre pour solution pour perfusion en flacon de 50 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009322231" ; OUTPUT ; 
code_ucd = 9322248 ; nom_court = "GEMCITABINE RATIOPHARM 200 MG Poudre pour solution pour perfusion" ; cod_atc = " " ; cod_ucd_chr = "0000009322248" ; OUTPUT ; 
code_ucd = 9322892 ; nom_court = "FER SANDOZ 100 MG/5ML Solution a diluer pour perfusion" ; cod_atc = "B03AC02" ; cod_ucd_chr = "0000009322892" ; OUTPUT ; 
code_ucd = 9323064 ; nom_court = "ORPHACOL 250 MG gelule" ; cod_atc = "A05AA03" ; cod_ucd_chr = "0000009323064" ; OUTPUT ; 
code_ucd = 9323070 ; nom_court = "ORPHACOL 50 MG gelule" ; cod_atc = "A05AA03" ; cod_ucd_chr = "0000009323070" ; OUTPUT ; 
code_ucd = 9323495 ; nom_court = "ROMIPLOSTIM 500 MCG/ML Poudre pour solution injectable, flacon de 5 ml 6" ; cod_atc = "B02BX04" ; cod_ucd_chr = "0000009323495" ; OUTPUT ; 
code_ucd = 9323791 ; nom_court = "VINORELBINE ACTAVIS 10 MG/ML Solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009323791" ; OUTPUT ; 
code_ucd = 9323816 ; nom_court = "VINORELBINE ACTAVIS 10 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009323816" ; OUTPUT ; 
code_ucd = 9323851 ; nom_court = "OXALIPLATINE HOSPIRA 5 MG/ML Solution a diluer pour perfusion en flacon ONCO-TAIN de 40 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009323851" ; OUTPUT ; 
code_ucd = 9324046 ; nom_court = "CONFIDEX 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009324046" ; OUTPUT ; 
code_ucd = 9324046 ; nom_court = "CONFIDEX 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009324046" ; OUTPUT ; 
code_ucd = 9324052 ; nom_court = "CONFIDEX 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009324052" ; OUTPUT ; 
code_ucd = 9324052 ; nom_court = "CONFIDEX 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009324052" ; OUTPUT ; 
code_ucd = 9324230 ; nom_court = "GEMCITABINE EBEWE PHARMA FRANCE 38 MG/ML Poudre pour solution pour perfusion en flacon de 200 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009324230" ; OUTPUT ; 
code_ucd = 9324247 ; nom_court = "GEMCITABINE EBEWE PHARMA FRANCE 38 MG/ML Poudre pour solution pour perfusion en flacon de 1000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009324247" ; OUTPUT ; 
code_ucd = 9324253 ; nom_court = "IRINOTECAN TEVA 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009324253" ; OUTPUT ; 
code_ucd = 9324276 ; nom_court = "IRINOTECAN TEVA 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009324276" ; OUTPUT ; 
code_ucd = 9324299 ; nom_court = "SALVACYL LP 11,25 MG Poudre et solvant pour suspension injectable a liberation prolongee" ; cod_atc = "L02AE04" ; cod_ucd_chr = "0000009324299" ; OUTPUT ; 
code_ucd = 9324632 ; nom_court = "MIRCERA 120 MICROGRAMMES/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009324632" ; OUTPUT ; 
code_ucd = 9324649 ; nom_court = "MIRCERA 30 MICROGRAMMES/0,3 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009324649" ; OUTPUT ; 
code_ucd = 9324655 ; nom_court = "MIRCERA 360 MICROGRAMMES/0,6 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009324655" ; OUTPUT ; 
code_ucd = 9325212 ; nom_court = "GEMCITABINE SANDOZ 1 G Poudre pour solution pour perfusion en flacon" ; cod_atc = " " ; cod_ucd_chr = "0000009325212" ; OUTPUT ; 
code_ucd = 9325229 ; nom_court = "GEMCITABINE SANDOZ 200 MG Poudre pour solution pour perfusion en flacon" ; cod_atc = " " ; cod_ucd_chr = "0000009325229" ; OUTPUT ; 
code_ucd = 9325755 ; nom_court = "GEMCITABINE ACTAVIS 38 MG/ML Poudre pour solution pour perfusion en flacon de 1 000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009325755" ; OUTPUT ; 
code_ucd = 9325761 ; nom_court = "GEMCITABINE ACTAVIS 38 MG/ML Poudre pour solution pour perfusion en flacon de 200 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009325761" ; OUTPUT ; 
code_ucd = 9325956 ; nom_court = "VINORELBINE SANDOZ 10 MG/ML flacon de 1 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009325956" ; OUTPUT ; 
code_ucd = 9325962 ; nom_court = "VINORELBINE SANDOZ 10 MG/ML flacon de 5 ml" ; cod_atc = "L01CA04" ; cod_ucd_chr = "0000009325962" ; OUTPUT ; 
code_ucd = 9325979 ; nom_court = "FLUDARABINE EBEWE 25 MG/ML Solution a diluer injectable ou pour perfusion en flacon de 2 ml" ; cod_atc = "L01BB05" ; cod_ucd_chr = "0000009325979" ; OUTPUT ; 
code_ucd = 9326016 ; nom_court = "REFACTO AF 1 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009326016" ; OUTPUT ; 
code_ucd = 9326016 ; nom_court = "REFACTO AF 1 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009326016" ; OUTPUT ; 
code_ucd = 9326022 ; nom_court = "REFACTO AF 2 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009326022" ; OUTPUT ; 
code_ucd = 9326022 ; nom_court = "REFACTO AF 2 000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009326022" ; OUTPUT ; 
code_ucd = 9326039 ; nom_court = "REFACTO AF 250 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009326039" ; OUTPUT ; 
code_ucd = 9326039 ; nom_court = "REFACTO AF 250 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009326039" ; OUTPUT ; 
code_ucd = 9326045 ; nom_court = "REFACTO AF 500 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009326045" ; OUTPUT ; 
code_ucd = 9326045 ; nom_court = "REFACTO AF 500 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009326045" ; OUTPUT ; 
code_ucd = 9326246 ; nom_court = "IRINOTECAN MYLAN 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009326246" ; OUTPUT ; 
code_ucd = 9326252 ; nom_court = "IRINOTECAN MYLAN 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009326252" ; OUTPUT ; 
code_ucd = 9326393 ; nom_court = "IRINOTECAN TEVA 20 MG/ML Solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009326393" ; OUTPUT ; 
code_ucd = 9327151 ; nom_court = "DOXORUBICINE EG 2 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009327151" ; OUTPUT ; 
code_ucd = 9327725 ; nom_court = "MITOXANTRONE EBEWE 2 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009327725" ; OUTPUT ; 
code_ucd = 9327731 ; nom_court = "MITOXANTRONE EBEWE 2 MG/ML Solution a diluer pour perfusion en flacon de 12,5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009327731" ; OUTPUT ; 
code_ucd = 9327748 ; nom_court = "MITOXANTRONE EBEWE 2 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB07" ; cod_ucd_chr = "0000009327748" ; OUTPUT ; 
code_ucd = 9327783 ; nom_court = "KUVAN 100 MG (DICHLORHYDRATE DE SAPROPTERINE) Comprime pour solution buvable" ; cod_atc = "A16AX07" ; cod_ucd_chr = "0000009327783" ; OUTPUT ; 
code_ucd = 9327903 ; nom_court = "PACLITAXEL ACTAVIS 6 MG/ML Solution a diluer pour perfusion en flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009327903" ; OUTPUT ; 
code_ucd = 9327926 ; nom_court = "PACLITAXEL ACTAVIS 6 MG/ML Solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009327926" ; OUTPUT ; 
code_ucd = 9327932 ; nom_court = "PACLITAXEL ACTAVIS 6 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009327932" ; OUTPUT ; 
code_ucd = 9327949 ; nom_court = "PACLITAXEL ACTAVIS 6 MG/ML Solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009327949" ; OUTPUT ; 
code_ucd = 9328050 ; nom_court = "PREZISTA 400 MG Comprime pellicule" ; cod_atc = "J05AE10" ; cod_ucd_chr = "0000009328050" ; OUTPUT ; 
code_ucd = 9328067 ; nom_court = "PREZISTA 600 MG Comprime pellicule" ; cod_atc = "J05AE10" ; cod_ucd_chr = "0000009328067" ; OUTPUT ; 
code_ucd = 9328096 ; nom_court = "STELARA 45 MG Solution injectable en flacon de 0,5 ml" ; cod_atc = "L04AC05" ; cod_ucd_chr = "0000009328096" ; OUTPUT ; 
code_ucd = 9328481 ; nom_court = "EPIRUBICINE MYLAN 2 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009328481" ; OUTPUT ; 
code_ucd = 9328788 ; nom_court = "KANOKAD 25 UI/ML DE FACTEUR IX Poudre et solvant pour solution injectable en flacon verre de 10 ml avec une aiguille de transfert" ; cod_atc = "B02BD" ; cod_ucd_chr = "0000009328788" ; OUTPUT ; 
code_ucd = 9328788 ; nom_court = "KANOKAD 25 UI/ML DE FACTEUR IX Poudre et solvant pour solution injectable en flacon verre de 10 ml avec une aiguille de transfert" ; cod_atc = "B02BD" ; cod_ucd_chr = "0000009328788" ; OUTPUT ; 
code_ucd = 9328794 ; nom_court = "KANOKAD 25 UI/ML DE FACTEUR IX Poudre et solvant pour solution injectable en flacon verre de 20 ml avec une aiguille de transfert" ; cod_atc = "B02BD" ; cod_ucd_chr = "0000009328794" ; OUTPUT ; 
code_ucd = 9328794 ; nom_court = "KANOKAD 25 UI/ML DE FACTEUR IX Poudre et solvant pour solution injectable en flacon verre de 20 ml avec une aiguille de transfert" ; cod_atc = "B02BD" ; cod_ucd_chr = "0000009328794" ; OUTPUT ; 
code_ucd = 9329173 ; nom_court = "GEMCITABINE TEVA 38 MG/ML Poudre pour solution pour perfusion en flacon de 200 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009329173" ; OUTPUT ; 
code_ucd = 9329196 ; nom_court = "GEMCITABINE TEVA 38 MG/ML Poudre pour solution pour perfusion en flacon de 1 000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009329196" ; OUTPUT ; 
code_ucd = 9330182 ; nom_court = "IRINOTECAN EBEWE PHARMA FRANCE 20 MG/ML Solution a diluer pour perfusion (IV) en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009330182" ; OUTPUT ; 
code_ucd = 9330199 ; nom_court = "IRINOTECAN EBEWE PHARMA FRANCE 20 MG/ML Solution a diluer pour perfusion (IV) en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009330199" ; OUTPUT ; 
code_ucd = 9330207 ; nom_court = "IRINOTECAN TEVA SANTE 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009330207" ; OUTPUT ; 
code_ucd = 9330213 ; nom_court = "IRINOTECAN TEVA SANTE 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009330213" ; OUTPUT ; 
code_ucd = 9330265 ; nom_court = "TEMODAL 140 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009330265" ; OUTPUT ; 
code_ucd = 9330271 ; nom_court = "TEMODAL 180 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009330271" ; OUTPUT ; 
code_ucd = 9330288 ; nom_court = "EPIPEN 0,15 MG/0,3 ML (ADRENALINE) 1 Boite de 1, solution injectable en seringue pre-remplie" ; cod_atc = " " ; cod_ucd_chr = "0000009330288" ; OUTPUT ; 
code_ucd = 9330963 ; nom_court = "THALIDOMIDE CELGENE 50 MG Gelule" ; cod_atc = "L04AX02" ; cod_ucd_chr = "0000009330963" ; OUTPUT ; 
code_ucd = 9331170 ; nom_court = "FERRIPROX 100 MG/ML Solution buvable" ; cod_atc = "V03AC02" ; cod_ucd_chr = "0000009331170" ; OUTPUT ; 
code_ucd = 9331336 ; nom_court = "BETAFACT 100 UI/ML poudre et solvant pour solution injectable avec systeme de transfert et une aiguille-filtre (10 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009331336" ; OUTPUT ; 
code_ucd = 9331336 ; nom_court = "BETAFACT 100 UI/ML poudre et solvant pour solution injectable avec systeme de transfert et une aiguille-filtre (10 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009331336" ; OUTPUT ; 
code_ucd = 9331342 ; nom_court = "BETAFACT 100 UI/ML poudre et solvant pour solution injectable avec systeme de transfert et une aiguille-filtre (5 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009331342" ; OUTPUT ; 
code_ucd = 9331342 ; nom_court = "BETAFACT 100 UI/ML poudre et solvant pour solution injectable avec systeme de transfert et une aiguille-filtre (5 ml)" ; cod_atc = "B02BD04" ; cod_ucd_chr = "0000009331342" ; OUTPUT ; 
code_ucd = 9331879 ; nom_court = "ROACTEMRA 20 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L04AC07" ; cod_ucd_chr = "0000009331879" ; OUTPUT ; 
code_ucd = 9331885 ; nom_court = "ROACTEMRA 20 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L04AC07" ; cod_ucd_chr = "0000009331885" ; OUTPUT ; 
code_ucd = 9331891 ; nom_court = "ROACTEMRA 20 MG/ML Solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L04AC07" ; cod_ucd_chr = "0000009331891" ; OUTPUT ; 
code_ucd = 9332620 ; nom_court = "CLOTTAFACT 1,5 G/100 ML Poudre et solvant pour solution injectable" ; cod_atc = "B02BB01" ; cod_ucd_chr = "0000009332620" ; OUTPUT ; 
code_ucd = 9332620 ; nom_court = "CLOTTAFACT 1,5 G/100 ML Poudre et solvant pour solution injectable" ; cod_atc = "B02BB01" ; cod_ucd_chr = "0000009332620" ; OUTPUT ; 
code_ucd = 9332637 ; nom_court = "EPIRUBICINE KABI 2 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009332637" ; OUTPUT ; 
code_ucd = 9332643 ; nom_court = "EPIRUBICINE KABI 2 MG/ML Solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009332643" ; OUTPUT ; 
code_ucd = 9332703 ; nom_court = "GEMCIRENA 200 MG Poudre pour solution pour perfusion en flacon" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009332703" ; OUTPUT ; 
code_ucd = 9332732 ; nom_court = "GEMCIRENA 1 000 MG Poudre pour solution pour perfusion en flacon" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009332732" ; OUTPUT ; 
code_ucd = 9332778 ; nom_court = "IRINOTECAN KABI 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009332778" ; OUTPUT ; 
code_ucd = 9332784 ; nom_court = "IRINOTECAN KABI 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009332784" ; OUTPUT ; 
code_ucd = 9332809 ; nom_court = "PACLITAXEL KABI 6 MG/ML Solution a diluer pour perfusion en flacon de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009332809" ; OUTPUT ; 
code_ucd = 9332815 ; nom_court = "PACLITAXEL KABI 6 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009332815" ; OUTPUT ; 
code_ucd = 9332821 ; nom_court = "PACLITAXEL KABI 6 MG/ML Solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009332821" ; OUTPUT ; 
code_ucd = 9333329 ; nom_court = "IRINOTECAN ACTAVIS 20 MG/ML Solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009333329" ; OUTPUT ; 
code_ucd = 9333335 ; nom_court = "IRINOTECAN HOSPIRA 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009333335" ; OUTPUT ; 
code_ucd = 9333341 ; nom_court = "IRINOTECAN HOSPIRA 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009333341" ; OUTPUT ; 
code_ucd = 9333996 ; nom_court = "ROPIVACAINE MYLAN 2 MG/ML solution pour perfusion en poche polyolefine suremballee de 100 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009333996" ; OUTPUT ; 
code_ucd = 9334004 ; nom_court = "ROPIVACAINE MYLAN 2 MG/ML solution pour perfusion en poche polyolefine suremballee de 200 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009334004" ; OUTPUT ; 
code_ucd = 9334582 ; nom_court = "IRINOTECAN HOSPIRA 20 MG/ML Solution a diluer pour perfusion en flacon de 30 ml contenant 25 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009334582" ; OUTPUT ; 
code_ucd = 9334665 ; nom_court = "IRINOTECAN EBEWE PHARMA FRANCE 20 MG/ML Solution a diluer pour perfusion (IV) en flacon de 25 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009334665" ; OUTPUT ; 
code_ucd = 9334814 ; nom_court = "IRINOTECAN INTAS PHARMACEUTICALS 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009334814" ; OUTPUT ; 
code_ucd = 9334820 ; nom_court = "IRINOTECAN INTAS PHARMACEUTICALS 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009334820" ; OUTPUT ; 
code_ucd = 9334866 ; nom_court = "FLUOROURACILE INTAS 50 MG/ML Solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009334866" ; OUTPUT ; 
code_ucd = 9334872 ; nom_court = "FLUOROURACILE INTAS 50 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009334872" ; OUTPUT ; 
code_ucd = 9334889 ; nom_court = "FLUOROURACILE INTAS 50 MG/ML Solution pour perfusion en flacon de 20 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009334889" ; OUTPUT ; 
code_ucd = 9334895 ; nom_court = "FLUOROURACILE INTAS 50 MG/ML Solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009334895" ; OUTPUT ; 
code_ucd = 9334955 ; nom_court = "ARANESP 10 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,4 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009334955" ; OUTPUT ; 
code_ucd = 9334961 ; nom_court = "ARANESP 100 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009334961" ; OUTPUT ; 
code_ucd = 9334978 ; nom_court = "ARANESP 130 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,65 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009334978" ; OUTPUT ; 
code_ucd = 9334984 ; nom_court = "ARANESP 15 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,375 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009334984" ; OUTPUT ; 
code_ucd = 9334990 ; nom_court = "ARANESP 150 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009334990" ; OUTPUT ; 
code_ucd = 9335009 ; nom_court = "ARANESP 20 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009335009" ; OUTPUT ; 
code_ucd = 9335015 ; nom_court = "ARANESP 30 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009335015" ; OUTPUT ; 
code_ucd = 9335021 ; nom_court = "ARANESP 300 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,6 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009335021" ; OUTPUT ; 
code_ucd = 9335038 ; nom_court = "ARANESP 40 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,4 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009335038" ; OUTPUT ; 
code_ucd = 9335044 ; nom_court = "ARANESP 50 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,5 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009335044" ; OUTPUT ; 
code_ucd = 9335050 ; nom_court = "ARANESP 500 MICROGRAMMES Solution injectable en seringue preremplie securisee de 1 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009335050" ; OUTPUT ; 
code_ucd = 9335067 ; nom_court = "ARANESP 60 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,3 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009335067" ; OUTPUT ; 
code_ucd = 9335073 ; nom_court = "ARANESP 80 MICROGRAMMES Solution injectable en seringue preremplie securisee de 0,4 ml" ; cod_atc = "B03XA02" ; cod_ucd_chr = "0000009335073" ; OUTPUT ; 
code_ucd = 9335498 ; nom_court = "CEFOXITINE HOSPIRA 1 G poudre pour solution injectable (IV)" ; cod_atc = " " ; cod_ucd_chr = "0000009335498" ; OUTPUT ; 
code_ucd = 9335506 ; nom_court = "CEFOXITINE HOSPIRA 2 G poudre pour solution injectable (IV)" ; cod_atc = "J01DC01" ; cod_ucd_chr = "0000009335506" ; OUTPUT ; 
code_ucd = 9336842 ; nom_court = "DOXORUBICINE MEDIPHA SANTE 2 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009336842" ; OUTPUT ; 
code_ucd = 9337913 ; nom_court = "EPIRUBICINE TEVA CLASSICS 2 MG/ML Solution injectable ou pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009337913" ; OUTPUT ; 
code_ucd = 9337936 ; nom_court = "EPIRUBICINE TEVA CLASSICS 2 MG/ML Solution injectable ou pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009337936" ; OUTPUT ; 
code_ucd = 9337942 ; nom_court = "EPIRUBICINE TEVA CLASSICS 2 MG/ML Solution injectable ou pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009337942" ; OUTPUT ; 
code_ucd = 9337959 ; nom_court = "EPIRUBICINE TEVA CLASSICS 2 MG/ML Solution injectable ou pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009337959" ; OUTPUT ; 
code_ucd = 9338249 ; nom_court = "IRINOTECAN MYLAN 20 MG/ML Solution a diluer pour perfusion en flacon de 15 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009338249" ; OUTPUT ; 
code_ucd = 9338255 ; nom_court = "IRINOTECAN MYLAN 20 MG/ML Solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009338255" ; OUTPUT ; 
code_ucd = 9338427 ; nom_court = "IRINOTECAN SANDOZ 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009338427" ; OUTPUT ; 
code_ucd = 9338433 ; nom_court = "IRINOTECAN SANDOZ 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009338433" ; OUTPUT ; 
code_ucd = 9338491 ; nom_court = "GEMCITABINE MYLAN PHARMA 38 MG/ML Poudre pour solution pour perfusion en flacon de 2 000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009338491" ; OUTPUT ; 
code_ucd = 9338516 ; nom_court = "MOZOBIL 20 MG/ML Solution injectable" ; cod_atc = "L03AX16" ; cod_ucd_chr = "0000009338516" ; OUTPUT ; 
code_ucd = 9338516 ; nom_court = "MOZOBIL 20 MG/ML Solution injectable" ; cod_atc = "L03AX16" ; cod_ucd_chr = "0000009338516" ; OUTPUT ; 
code_ucd = 9339177 ; nom_court = "PREZISTA 150 MG Comprime pellicule" ; cod_atc = "J05AE10" ; cod_ucd_chr = "0000009339177" ; OUTPUT ; 
code_ucd = 9339183 ; nom_court = "PREZISTA 75 MG Comprime pellicule" ; cod_atc = "J05AE10" ; cod_ucd_chr = "0000009339183" ; OUTPUT ; 
code_ucd = 9339272 ; nom_court = "OXALIPLATINE KABI 5 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009339272" ; OUTPUT ; 
code_ucd = 9339289 ; nom_court = "OXALIPLATINE KABI 5 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009339289" ; OUTPUT ; 
code_ucd = 9339295 ; nom_court = "APTIVUS 100 MG/ML Solution buvable en flacon de 95 ml" ; cod_atc = "J05AE09" ; cod_ucd_chr = "0000009339295" ; OUTPUT ; 
code_ucd = 9339326 ; nom_court = "AFINITOR 10 MG Comprimes" ; cod_atc = "L01XE10" ; cod_ucd_chr = "0000009339326" ; OUTPUT ; 
code_ucd = 9339332 ; nom_court = "AFINITOR 5 MG Comprimes" ; cod_atc = "L01XE10" ; cod_ucd_chr = "0000009339332" ; OUTPUT ; 
code_ucd = 9340950 ; nom_court = "FLUOROURACILE EBEWE 50 MG/ML Solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009340950" ; OUTPUT ; 
code_ucd = 9340967 ; nom_court = "FLUOROURACILE EBEWE 50 MG/ML Solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009340967" ; OUTPUT ; 
code_ucd = 9340973 ; nom_court = "FLUOROURACILE EBEWE 50 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009340973" ; OUTPUT ; 
code_ucd = 9340996 ; nom_court = "FLUOROURACILE EBEWE 50 MG/ML Solution pour perfusion en flacon de 20 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009340996" ; OUTPUT ; 
code_ucd = 9341004 ; nom_court = "FLUOROURACILE EBEWE 50 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01BC02" ; cod_ucd_chr = "0000009341004" ; OUTPUT ; 
code_ucd = 9341369 ; nom_court = "FIBROGAMMIN 62,5 U/ML, 250 U Poudre et solvant pour solution injectable/perfusion" ; cod_atc = "B02BD07" ; cod_ucd_chr = "0000009341369" ; OUTPUT ; 
code_ucd = 9341369 ; nom_court = "FIBROGAMMIN 62,5 U/ML, 250 U Poudre et solvant pour solution injectable/perfusion" ; cod_atc = "B02BD07" ; cod_ucd_chr = "0000009341369" ; OUTPUT ; 
code_ucd = 9341375 ; nom_court = "FIBROGAMMIN 62,5 U/ML, 1 250 U Poudre et solvant pour solution injectable/perfusion" ; cod_atc = "B02BD07" ; cod_ucd_chr = "0000009341375" ; OUTPUT ; 
code_ucd = 9341375 ; nom_court = "FIBROGAMMIN 62,5 U/ML, 1 250 U Poudre et solvant pour solution injectable/perfusion" ; cod_atc = "B02BD07" ; cod_ucd_chr = "0000009341375" ; OUTPUT ; 
code_ucd = 9341398 ; nom_court = "PRIVIGEN 100 MG/ML Solution pour perfusion en flacon de 25 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009341398" ; OUTPUT ; 
code_ucd = 9341398 ; nom_court = "PRIVIGEN 100 MG/ML Solution pour perfusion en flacon de 25 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009341398" ; OUTPUT ; 
code_ucd = 9341725 ; nom_court = "ENBREL 50 MG Solution injectable en stylo prerempli de 1 ml et 8 tampons alcoolises" ; cod_atc = "L04AB01" ; cod_ucd_chr = "0000009341725" ; OUTPUT ; 
code_ucd = 9342601 ; nom_court = "CIMZIA 200 MG Solution injectable, 1 ml en seringue preremplie" ; cod_atc = "L04AB05" ; cod_ucd_chr = "0000009342601" ; OUTPUT ; 
code_ucd = 9342759 ; nom_court = "TRACLEER 32 MG Comprime dispersible" ; cod_atc = "C02KX01" ; cod_ucd_chr = "0000009342759" ; OUTPUT ; 
code_ucd = 9342877 ; nom_court = "TAXOTERE 20 MG/1 ML Solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009342877" ; OUTPUT ; 
code_ucd = 9342883 ; nom_court = "TAXOTERE 80 MG/4 ML Solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009342883" ; OUTPUT ; 
code_ucd = 9342908 ; nom_court = "EPORATIO 1000 UI/0,5 ML Solution injectable en seringue preremplie sans dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009342908" ; OUTPUT ; 
code_ucd = 9342914 ; nom_court = "EPORATIO 1000 UI/0,5 ML Solution injectable en seringue preremplie avec dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009342914" ; OUTPUT ; 
code_ucd = 9342920 ; nom_court = "EPORATIO 10 000 UI/1 ML Solution injectable en seringue preremplie sans dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009342920" ; OUTPUT ; 
code_ucd = 9342937 ; nom_court = "EPORATIO 10 000 UI/1 ML Solution injectable en seringue preremplie avec dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009342937" ; OUTPUT ; 
code_ucd = 9342943 ; nom_court = "EPORATIO 2000 UI/0,5 ML Solution injectable en seringue preremplie sans dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009342943" ; OUTPUT ; 
code_ucd = 9342966 ; nom_court = "EPORATIO 2000 UI/0,5 ML Solution injectable en seringue preremplie avec dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009342966" ; OUTPUT ; 
code_ucd = 9342972 ; nom_court = "EPORATIO 20 000 UI/1 ML Solution injectable en seringue preremplie sans dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009342972" ; OUTPUT ; 
code_ucd = 9342989 ; nom_court = "EPORATIO 20 000 UI/1 ML Solution injectable en seringue preremplie avec dispositif de securite" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009342989" ; OUTPUT ; 
code_ucd = 9342995 ; nom_court = "EPORATIO 3000 UI/0,5 ML Solution injectable en seringue preremplie sans dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009342995" ; OUTPUT ; 
code_ucd = 9343003 ; nom_court = "EPORATIO 3000 UI/0,5 ML Solution injectable en seringue preremplie avec dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009343003" ; OUTPUT ; 
code_ucd = 9343026 ; nom_court = "EPORATIO 30 000 UI/1 ML Solution injectable en seringue preremplie sans dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009343026" ; OUTPUT ; 
code_ucd = 9343032 ; nom_court = "EPORATIO 30 000 UI/1 ML Solution injectable en seringue preremplie avec dispositif de securite" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009343032" ; OUTPUT ; 
code_ucd = 9343049 ; nom_court = "EPORATIO 4000 UI/0,5 ML Solution injectable en seringue preremplie sans dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009343049" ; OUTPUT ; 
code_ucd = 9343055 ; nom_court = "EPORATIO 4000 UI/0,5 ML Solution injectable en seringue preremplie avec dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009343055" ; OUTPUT ; 
code_ucd = 9343061 ; nom_court = "EPORATIO 5000 UI/0,5 ML Solution injectable en seringue preremplie sans dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009343061" ; OUTPUT ; 
code_ucd = 9343078 ; nom_court = "EPORATIO 5000 UI/0,5 ML Solution injectable en seringue preremplie avec dispositif de securite" ; cod_atc = " " ; cod_ucd_chr = "0000009343078" ; OUTPUT ; 
code_ucd = 9343115 ; nom_court = "CISPLATINE INTAS 1 MG/ML Solution injectable en flacon de 10 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009343115" ; OUTPUT ; 
code_ucd = 9343121 ; nom_court = "CISPLATINE INTAS 1 MG/ML Solution injectable en flacon de 25 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009343121" ; OUTPUT ; 
code_ucd = 9343138 ; nom_court = "CISPLATINE INTAS 1 MG/ML Solution injectable en flacon de 50 ml" ; cod_atc = "L01XA01" ; cod_ucd_chr = "0000009343138" ; OUTPUT ; 
code_ucd = 9343316 ; nom_court = "GEMCITABINE ACTAVIS 38 MG/ML poudre pour solution pour perfusion en flacon de 2000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009343316" ; OUTPUT ; 
code_ucd = 9343405 ; nom_court = "GEMCITABINE EG 38 MG/ML solution a diluer pour perfusion en flacon de 26,3 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009343405" ; OUTPUT ; 
code_ucd = 9343411 ; nom_court = "GEMCITABINE EG 38 MG/ML solution a diluer pour perfusion en flacon de 5,26 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009343411" ; OUTPUT ; 
code_ucd = 9343546 ; nom_court = "GEMCITABINE EBEWE PHARMA FRANCE 38 MG/ML 1 Flacon de 2000 mg, poudre pour solution pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009343546" ; OUTPUT ; 
code_ucd = 9343612 ; nom_court = "BINOCRIT 20 000 UI/0,5 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009343612" ; OUTPUT ; 
code_ucd = 9343629 ; nom_court = "BINOCRIT 30 000 UI/0,75 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009343629" ; OUTPUT ; 
code_ucd = 9343635 ; nom_court = "BINOCRIT 40 000 UI/1 ML Solution injectable en seringue preremplie" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009343635" ; OUTPUT ; 
code_ucd = 9343724 ; nom_court = "EPIRUBICINE INTAS 2 MG/ML Solution pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009343724" ; OUTPUT ; 
code_ucd = 9343730 ; nom_court = "EPIRUBICINE INTAS 2 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009343730" ; OUTPUT ; 
code_ucd = 9343747 ; nom_court = "EPIRUBICINE INTAS 2 MG/ML Solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009343747" ; OUTPUT ; 
code_ucd = 9343753 ; nom_court = "EPIRUBICINE INTAS 2 MG/ML Solution pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB03" ; cod_ucd_chr = "0000009343753" ; OUTPUT ; 
code_ucd = 9344847 ; nom_court = "JAVLOR 25 MG/ML Solution a diluer pour perfusion en flacon de 10 ml BG" ; cod_atc = "L01CA05" ; cod_ucd_chr = "0000009344847" ; OUTPUT ; 
code_ucd = 9344847 ; nom_court = "JAVLOR 25 MG/ML Solution a diluer pour perfusion en flacon de 10 ml BG" ; cod_atc = "L01CA05" ; cod_ucd_chr = "0000009344847" ; OUTPUT ; 
code_ucd = 9344853 ; nom_court = "JAVLOR 25 MG/ML Solution a diluer pour perfusion en flacon de 2 ml BG" ; cod_atc = "L01CA05" ; cod_ucd_chr = "0000009344853" ; OUTPUT ; 
code_ucd = 9344853 ; nom_court = "JAVLOR 25 MG/ML Solution a diluer pour perfusion en flacon de 2 ml BG" ; cod_atc = "L01CA05" ; cod_ucd_chr = "0000009344853" ; OUTPUT ; 
code_ucd = 9345930 ; nom_court = "IRINOTECAN KABI 20 MG/ML Solution a diluer pour perfusion en flacon de 15 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009345930" ; OUTPUT ; 
code_ucd = 9345947 ; nom_court = "IRINOTECAN KABI 20 MG/ML Solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009345947" ; OUTPUT ; 
code_ucd = 9347567 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347567" ; OUTPUT ; 
code_ucd = 9347567 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347567" ; OUTPUT ; 
code_ucd = 9347573 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 20 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347573" ; OUTPUT ; 
code_ucd = 9347573 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 20 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347573" ; OUTPUT ; 
code_ucd = 9347596 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347596" ; OUTPUT ; 
code_ucd = 9347596 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347596" ; OUTPUT ; 
code_ucd = 9347604 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 400 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347604" ; OUTPUT ; 
code_ucd = 9347604 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 400 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347604" ; OUTPUT ; 
code_ucd = 9347610 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347610" ; OUTPUT ; 
code_ucd = 9347610 ; nom_court = "CLAIRYG 50 MG/ML Solution injectable en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347610" ; OUTPUT ; 
code_ucd = 9347716 ; nom_court = "DOXORUBICINE MEDIPHA SANTE 2 MG/ML solution pour perfusion en flacon de 25 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009347716" ; OUTPUT ; 
code_ucd = 9347863 ; nom_court = "GEMCITABINE MYLAN 38 MG/ML Poudre pour solution pour perfusion en flacon de 2 000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009347863" ; OUTPUT ; 
code_ucd = 9347952 ; nom_court = "OCTAGAM 100 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347952" ; OUTPUT ; 
code_ucd = 9347952 ; nom_court = "OCTAGAM 100 MG/ML Solution pour perfusion en flacon de 100 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347952" ; OUTPUT ; 
code_ucd = 9347969 ; nom_court = "OCTAGAM 100 MG/ML Solution pour perfusion en flacon de 20 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347969" ; OUTPUT ; 
code_ucd = 9347969 ; nom_court = "OCTAGAM 100 MG/ML Solution pour perfusion en flacon de 20 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347969" ; OUTPUT ; 
code_ucd = 9347975 ; nom_court = "OCTAGAM 100 MG/ML Solution pour perfusion en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347975" ; OUTPUT ; 
code_ucd = 9347975 ; nom_court = "OCTAGAM 100 MG/ML Solution pour perfusion en flacon de 200 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347975" ; OUTPUT ; 
code_ucd = 9347981 ; nom_court = "OCTAGAM 100 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347981" ; OUTPUT ; 
code_ucd = 9347981 ; nom_court = "OCTAGAM 100 MG/ML Solution pour perfusion en flacon de 50 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009347981" ; OUTPUT ; 
code_ucd = 9347998 ; nom_court = "GEMCITABINE INTAS 2 000 MG Poudre pour solution pour perfusion en flacon" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009347998" ; OUTPUT ; 
code_ucd = 9348006 ; nom_court = "IRINOTECAN INTAS PHARMACEUTICALS 20 MG/ML Flacon de 25 ml, solution a diluer pour perfusion" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009348006" ; OUTPUT ; 
code_ucd = 9348093 ; nom_court = "JAVLOR 25 MG/ML Solution a diluer pour perfusion en flacon de 10 ml BN" ; cod_atc = " " ; cod_ucd_chr = "0000009348093" ; OUTPUT ; 
code_ucd = 9348093 ; nom_court = "JAVLOR 25 MG/ML Solution a diluer pour perfusion en flacon de 10 ml BN" ; cod_atc = " " ; cod_ucd_chr = "0000009348093" ; OUTPUT ; 
code_ucd = 9348101 ; nom_court = "JAVLOR 25 MG/ML Solution a diluer pour perfusion en flacon de 2 ml BN" ; cod_atc = " " ; cod_ucd_chr = "0000009348101" ; OUTPUT ; 
code_ucd = 9348101 ; nom_court = "JAVLOR 25 MG/ML Solution a diluer pour perfusion en flacon de 2 ml BN" ; cod_atc = " " ; cod_ucd_chr = "0000009348101" ; OUTPUT ; 
code_ucd = 9348383 ; nom_court = "DOCETAXEL TEVA 20 MG/0,5 ML Solution a diluer et solvant pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009348383" ; OUTPUT ; 
code_ucd = 9348383 ; nom_court = "DOCETAXEL TEVA 20 MG/0,5 ML Solution a diluer et solvant pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009348383" ; OUTPUT ; 
code_ucd = 9348408 ; nom_court = "DOCETAXEL TEVA 80 MG/2 ML Solution a diluer et solvant pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009348408" ; OUTPUT ; 
code_ucd = 9348408 ; nom_court = "DOCETAXEL TEVA 80 MG/2 ML Solution a diluer et solvant pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009348408" ; OUTPUT ; 
code_ucd = 9348420 ; nom_court = "TEMOZOLOMIDE TEVA 100 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009348420" ; OUTPUT ; 
code_ucd = 9348437 ; nom_court = "TEMOZOLOMIDE TEVA 20 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009348437" ; OUTPUT ; 
code_ucd = 9348443 ; nom_court = "TEMOZOLOMIDE TEVA 250 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009348443" ; OUTPUT ; 
code_ucd = 9348466 ; nom_court = "TEMOZOLOMIDE TEVA 5 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009348466" ; OUTPUT ; 
code_ucd = 9348615 ; nom_court = "ADCIRCA 20 MG Comprime pellicule" ; cod_atc = "G04BE08" ; cod_ucd_chr = "0000009348615" ; OUTPUT ; 
code_ucd = 9350322 ; nom_court = "TEMOZOLOMIDE SANDOZ 100 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009350322" ; OUTPUT ; 
code_ucd = 9350339 ; nom_court = "TEMOZOLOMIDE SANDOZ 140 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009350339" ; OUTPUT ; 
code_ucd = 9350345 ; nom_court = "TEMOZOLOMIDE SANDOZ 180 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009350345" ; OUTPUT ; 
code_ucd = 9350351 ; nom_court = "TEMOZOLOMIDE SANDOZ 20 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009350351" ; OUTPUT ; 
code_ucd = 9350368 ; nom_court = "TEMOZOLOMIDE SANDOZ 250 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009350368" ; OUTPUT ; 
code_ucd = 9350374 ; nom_court = "TEMOZOLOMIDE SANDOZ 5 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009350374" ; OUTPUT ; 
code_ucd = 9350546 ; nom_court = "TEMOZOLOMIDE TEVA 140 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009350546" ; OUTPUT ; 
code_ucd = 9350552 ; nom_court = "TEMOZOLOMIDE TEVA 180 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009350552" ; OUTPUT ; 
code_ucd = 9350730 ; nom_court = "NEODEX 40 MG Comprime secable" ; cod_atc = "H02AB02" ; cod_ucd_chr = "0000009350730" ; OUTPUT ; 
code_ucd = 9350925 ; nom_court = "GEMCITABINE ACTAVIS 40 MG/ML solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009350925" ; OUTPUT ; 
code_ucd = 9350931 ; nom_court = "GEMCITABINE ACTAVIS 40 MG/ML solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009350931" ; OUTPUT ; 
code_ucd = 9350948 ; nom_court = "GEMCITABINE ACTAVIS 40 MG/ML solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009350948" ; OUTPUT ; 
code_ucd = 9351451 ; nom_court = "RIBAVIRINE TEVA PHARMA BV 200 MG comprime pellicule" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009351451" ; OUTPUT ; 
code_ucd = 9351505 ; nom_court = "ROPIVACAINE SANDOZ 2 MG/ML solution pour perfusion en poche polypropylene de 100 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009351505" ; OUTPUT ; 
code_ucd = 9351511 ; nom_court = "ROPIVACAINE SANDOZ 2 MG/ML solution pour perfusion en poche polypropylene de 200 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009351511" ; OUTPUT ; 
code_ucd = 9351586 ; nom_court = "TEMOZOLOMIDE HOSPIRA 100 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009351586" ; OUTPUT ; 
code_ucd = 9351592 ; nom_court = "TEMOZOLOMIDE HOSPIRA 140 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009351592" ; OUTPUT ; 
code_ucd = 9351600 ; nom_court = "TEMOZOLOMIDE HOSPIRA 180 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009351600" ; OUTPUT ; 
code_ucd = 9351617 ; nom_court = "TEMOZOLOMIDE HOSPIRA 20 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009351617" ; OUTPUT ; 
code_ucd = 9351623 ; nom_court = "TEMOZOLOMIDE HOSPIRA 250 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009351623" ; OUTPUT ; 
code_ucd = 9351646 ; nom_court = "TEMOZOLOMIDE HOSPIRA 5 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009351646" ; OUTPUT ; 
code_ucd = 9351698 ; nom_court = "GEMCITABINE MYLAN 40 MG/ML Flacon de 25 ml, solution a diluer pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009351698" ; OUTPUT ; 
code_ucd = 9351706 ; nom_court = "GEMCITABINE MYLAN 40 MG/ML Flacon de 5 ml, solution a diluer pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009351706" ; OUTPUT ; 
code_ucd = 9351712 ; nom_court = "GEMCITABINE MYLAN 40 MG/ML Flacon de 50 ml, solution a diluer pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009351712" ; OUTPUT ; 
code_ucd = 9351758 ; nom_court = "OXALIPLATINE EG 5 MG/ML poudre pour solution pour perfusion en flacon de 100 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009351758" ; OUTPUT ; 
code_ucd = 9351770 ; nom_court = "OXALIPLATINE EG 5 MG/ML poudre pour solution pour perfusion en flacon de 50 mg" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009351770" ; OUTPUT ; 
code_ucd = 9351787 ; nom_court = "STELARA 45 MG Solution injectable, 0,5 ml en seringue preremplie" ; cod_atc = "L04AC05" ; cod_ucd_chr = "0000009351787" ; OUTPUT ; 
code_ucd = 9351793 ; nom_court = "STELARA, 90 MG (USTEKINUMAB) 1 ml seringue pre-remplie, solution injectable" ; cod_atc = "L04AC05" ; cod_ucd_chr = "0000009351793" ; OUTPUT ; 
code_ucd = 9351818 ; nom_court = "DOCETAXEL HOSPIRA 10MG/ML Solution a diluer pour perfusion en flacon de 16 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009351818" ; OUTPUT ; 
code_ucd = 9351818 ; nom_court = "DOCETAXEL HOSPIRA 10MG/ML Solution a diluer pour perfusion en flacon de 16 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009351818" ; OUTPUT ; 
code_ucd = 9351824 ; nom_court = "DOCETAXEL HOSPIRA 10 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009351824" ; OUTPUT ; 
code_ucd = 9351824 ; nom_court = "DOCETAXEL HOSPIRA 10 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009351824" ; OUTPUT ; 
code_ucd = 9351830 ; nom_court = "DOCETAXEL HOSPIRA 10 MG/ML Solution a diluer pour perfusion en flacon de 8 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009351830" ; OUTPUT ; 
code_ucd = 9351830 ; nom_court = "DOCETAXEL HOSPIRA 10 MG/ML Solution a diluer pour perfusion en flacon de 8 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009351830" ; OUTPUT ; 
code_ucd = 9352410 ; nom_court = "NORVIR 100 MG Comprime pellicule" ; cod_atc = "J05AE03" ; cod_ucd_chr = "0000009352410" ; OUTPUT ; 
code_ucd = 9352516 ; nom_court = "KIOVIG 100 MG/ML Solution pour perfusion en flacon de 300 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009352516" ; OUTPUT ; 
code_ucd = 9352516 ; nom_court = "KIOVIG 100 MG/ML Solution pour perfusion en flacon de 300 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009352516" ; OUTPUT ; 
code_ucd = 9352568 ; nom_court = "TEMOMEDAC 100 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009352568" ; OUTPUT ; 
code_ucd = 9352574 ; nom_court = "TEMOMEDAC 140 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009352574" ; OUTPUT ; 
code_ucd = 9352580 ; nom_court = "TEMOMEDAC 180 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009352580" ; OUTPUT ; 
code_ucd = 9352597 ; nom_court = "TEMOMEDAC 20 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009352597" ; OUTPUT ; 
code_ucd = 9352605 ; nom_court = "TEMOMEDAC 250 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009352605" ; OUTPUT ; 
code_ucd = 9352611 ; nom_court = "TEMOMEDAC 5 MG Gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009352611" ; OUTPUT ; 
code_ucd = 9352686 ; nom_court = "GEMCITABINE TEVA 40 MG/ML 1 Flacon de 25 ml, solution a diluer pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009352686" ; OUTPUT ; 
code_ucd = 9352692 ; nom_court = "GEMCITABINE TEVA 40 MG/ML 1 Flacon de 5 ml, solution a diluer pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009352692" ; OUTPUT ; 
code_ucd = 9352700 ; nom_court = "GEMCITABINE TEVA 40 MG/ML 1 Flacon de 50 ml, solution a diluer pour perfusion" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009352700" ; OUTPUT ; 
code_ucd = 9352806 ; nom_court = "VENOFER 100 MG/5 ML Solution injectable en flacon (IV)" ; cod_atc = "B03AC02" ; cod_ucd_chr = "0000009352806" ; OUTPUT ; 
code_ucd = 9352887 ; nom_court = "DOCETAXEL EBEWE 10 MG/ML Flacon de 2 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009352887" ; OUTPUT ; 
code_ucd = 9352887 ; nom_court = "DOCETAXEL EBEWE 10 MG/ML Flacon de 2 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009352887" ; OUTPUT ; 
code_ucd = 9352893 ; nom_court = "DOCETAXEL EBEWE 10 MG/ML Flacon de 8 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009352893" ; OUTPUT ; 
code_ucd = 9352893 ; nom_court = "DOCETAXEL EBEWE 10 MG/ML Flacon de 8 ml, solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009352893" ; OUTPUT ; 
code_ucd = 9353059 ; nom_court = "FLUCONAZOLE KABI 2 MG/ML Flacon de 100 ml, solution pour perfusion" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009353059" ; OUTPUT ; 
code_ucd = 9353065 ; nom_court = "FLUCONAZOLE KABI 2 MG/ML Flacon de 200 ml, solution pour perfusion" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009353065" ; OUTPUT ; 
code_ucd = 9353071 ; nom_court = "FLUCONAZOLE KABI 2 MG/ML Flacon de 50 ml, solution pour perfusion" ; cod_atc = "J02AC01" ; cod_ucd_chr = "0000009353071" ; OUTPUT ; 
code_ucd = 9353705 ; nom_court = "DOCETAXEL INTAS PHARMACEUTICALS 20 MG/0,5 ML Solution a diluer pour perfusion en flacon" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009353705" ; OUTPUT ; 
code_ucd = 9353711 ; nom_court = "DOCETAXEL INTAS PHARMACEUTICALS 80 MG/2 ML Solution a diluer pour perfusion en flacon" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009353711" ; OUTPUT ; 
code_ucd = 9353728 ; nom_court = "DOXORUBICINE INTAS 2 MG/ML Solution injectable pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009353728" ; OUTPUT ; 
code_ucd = 9353734 ; nom_court = "DOXORUBICINE INTAS 2 MG/ML Solution injectable pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009353734" ; OUTPUT ; 
code_ucd = 9353869 ; nom_court = "CHLORHYDRATE DE PROPRANOLOL PIERRE FABRE DERMATOLOGIE 3,75 mg/ml, solution buvable" ; cod_atc = "D11A" ; cod_ucd_chr = "0000009353869" ; OUTPUT ; 
code_ucd = 9353964 ; nom_court = "TAXOTERE 160 MG/8 ML Solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009353964" ; OUTPUT ; 
code_ucd = 9353970 ; nom_court = "LEVACT 2,5 MG/ML poudre pour solution a diluer pour perfusion, 25 mg de poudre en flacon de 26 ml" ; cod_atc = "L01AA09" ; cod_ucd_chr = "0000009353970" ; OUTPUT ; 
code_ucd = 9353987 ; nom_court = "LEVACT 2,5 MG/ML poudre pour solution a diluer pour perfusion, 100 mg de poudre en flacon de 60 ml" ; cod_atc = "L01AA09" ; cod_ucd_chr = "0000009353987" ; OUTPUT ; 
code_ucd = 9354053 ; nom_court = "TEMOZOLOMIDE MYLAN 100 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009354053" ; OUTPUT ; 
code_ucd = 9354076 ; nom_court = "TEMOZOLOMIDE MYLAN 140 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009354076" ; OUTPUT ; 
code_ucd = 9354082 ; nom_court = "TEMOZOLOMIDE MYLAN 180 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009354082" ; OUTPUT ; 
code_ucd = 9354099 ; nom_court = "TEMOZOLOMIDE MYLAN 20 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009354099" ; OUTPUT ; 
code_ucd = 9354107 ; nom_court = "TEMOZOLOMIDE MYLAN 250 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009354107" ; OUTPUT ; 
code_ucd = 9354113 ; nom_court = "TEMOZOLOMIDE MYLAN 5 MG Gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009354113" ; OUTPUT ; 
code_ucd = 9354225 ; nom_court = "EPOPROSTENOL PANPHARMA 0,5 MG poudre et solvant pour solution injectable, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009354225" ; OUTPUT ; 
code_ucd = 9354225 ; nom_court = "EPOPROSTENOL PANPHARMA 0,5 MG poudre et solvant pour solution injectable, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009354225" ; OUTPUT ; 
code_ucd = 9354231 ; nom_court = "EPOPROSTENOL PANPHARMA 1,5 MG poudre et solvant pour solution injectable, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009354231" ; OUTPUT ; 
code_ucd = 9354231 ; nom_court = "EPOPROSTENOL PANPHARMA 1,5 MG poudre et solvant pour solution injectable, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009354231" ; OUTPUT ; 
code_ucd = 9354320 ; nom_court = "IFOSFAMIDE EG 40 MG/ML solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01AA06" ; cod_ucd_chr = "0000009354320" ; OUTPUT ; 
code_ucd = 9354337 ; nom_court = "IFOSFAMIDE EG 40 MG/ML solution pour perfusion en flacon de 50 ml" ; cod_atc = "L01AA06" ; cod_ucd_chr = "0000009354337" ; OUTPUT ; 
code_ucd = 9354604 ; nom_court = "GEMCITABINE KABI 38 MG/ML Poudre pour solution pour perfusion en flacon de 1 000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009354604" ; OUTPUT ; 
code_ucd = 9354610 ; nom_court = "GEMCITABINE KABI 38 MG/ML Poudre pour solution pour perfusion en flacon de 200 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009354610" ; OUTPUT ; 
code_ucd = 9354627 ; nom_court = "GEMCITABINE KABI 38 MG/ML Poudre pour solution pour perfusion en flacon de 2 000 mg" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009354627" ; OUTPUT ; 
code_ucd = 9354923 ; nom_court = "IRINOTECAN EBEWE 20 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009354923" ; OUTPUT ; 
code_ucd = 9354946 ; nom_court = "IRINOTECAN EBEWE 20 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009354946" ; OUTPUT ; 
code_ucd = 9354952 ; nom_court = "IRINOTECAN EBEWE 20 MG/ML Solution a diluer pour perfusion en flacon de 7,5 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009354952" ; OUTPUT ; 
code_ucd = 9354969 ; nom_court = "IRINOTECAN EBEWE 20 MG/ML Solution a diluer pour perfusion en flacon de 15 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009354969" ; OUTPUT ; 
code_ucd = 9354975 ; nom_court = "IRINOTECAN EBEWE 20 MG/ML Solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009354975" ; OUTPUT ; 
code_ucd = 9355012 ; nom_court = "FER ACTAVIS 100 MG/5ML Solution injectable" ; cod_atc = "B03AC02" ; cod_ucd_chr = "0000009355012" ; OUTPUT ; 
code_ucd = 9355029 ; nom_court = "TOPOTECAN HOSPIRA 4 MG/4 ML Solution a diluer pour perfusion" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009355029" ; OUTPUT ; 
code_ucd = 9355029 ; nom_court = "TOPOTECAN HOSPIRA 4 MG/4 ML Solution a diluer pour perfusion" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009355029" ; OUTPUT ; 
code_ucd = 9355035 ; nom_court = "VPRIV 400 UNITES poudre pour solution pour perfusion" ; cod_atc = "A16AB10" ; cod_ucd_chr = "0000009355035" ; OUTPUT ; 
code_ucd = 9355035 ; nom_court = "VPRIV 400 UNITES poudre pour solution pour perfusion" ; cod_atc = "A16AB10" ; cod_ucd_chr = "0000009355035" ; OUTPUT ; 
code_ucd = 9355288 ; nom_court = "OXALIPLATINE ACCORD 5 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009355288" ; OUTPUT ; 
code_ucd = 9355294 ; nom_court = "OXALIPLATINE ACCORD 5 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009355294" ; OUTPUT ; 
code_ucd = 9355816 ; nom_court = "EPOPROSTENOL SANDOZ 0,5 MG Poudre et solvant pour solution pour perfusion, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009355816" ; OUTPUT ; 
code_ucd = 9355816 ; nom_court = "EPOPROSTENOL SANDOZ 0,5 MG Poudre et solvant pour solution pour perfusion, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009355816" ; OUTPUT ; 
code_ucd = 9355822 ; nom_court = "EPOPROSTENOL SANDOZ 1,5 MG Poudre et solvant pour solution pour perfusion, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009355822" ; OUTPUT ; 
code_ucd = 9355822 ; nom_court = "EPOPROSTENOL SANDOZ 1,5 MG Poudre et solvant pour solution pour perfusion, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009355822" ; OUTPUT ; 
code_ucd = 9355905 ; nom_court = "FERRIPROX 1000 MG Comprime pellicule" ; cod_atc = "V03AC02" ; cod_ucd_chr = "0000009355905" ; OUTPUT ; 
code_ucd = 9356201 ; nom_court = "EPOPROSTENOL INTSEL CHIMOS 0,5 MG Poudre et solvant pour solution injectable" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009356201" ; OUTPUT ; 
code_ucd = 9356201 ; nom_court = "EPOPROSTENOL INTSEL CHIMOS 0,5 MG Poudre et solvant pour solution injectable" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009356201" ; OUTPUT ; 
code_ucd = 9356218 ; nom_court = "EPOPROSTENOL INTSEL CHIMOS 1,5 MG Poudre et solvant pour solution injectable" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009356218" ; OUTPUT ; 
code_ucd = 9356218 ; nom_court = "EPOPROSTENOL INTSEL CHIMOS 1,5 MG Poudre et solvant pour solution injectable" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009356218" ; OUTPUT ; 
code_ucd = 9357577 ; nom_court = "EPOPROSTENOL ARROW 0,5 MG poudre et solvant pour solution injectable, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009357577" ; OUTPUT ; 
code_ucd = 9357577 ; nom_court = "EPOPROSTENOL ARROW 0,5 MG poudre et solvant pour solution injectable, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009357577" ; OUTPUT ; 
code_ucd = 9357583 ; nom_court = "EPOPROSTENOL ARROW 1,5 MG poudre et solvant pour solution injectable, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009357583" ; OUTPUT ; 
code_ucd = 9357583 ; nom_court = "EPOPROSTENOL ARROW 1,5 MG poudre et solvant pour solution injectable, poudre en flacon + 1 flacon de 50 ml de solvant + filtre" ; cod_atc = "B01AC09" ; cod_ucd_chr = "0000009357583" ; OUTPUT ; 
code_ucd = 9359346 ; nom_court = "HELIXATE NEXGEN 3000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009359346" ; OUTPUT ; 
code_ucd = 9359346 ; nom_court = "HELIXATE NEXGEN 3000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009359346" ; OUTPUT ; 
code_ucd = 9360527 ; nom_court = "RIASTAP 1 G Poudre pour solution injectable pour perfusion" ; cod_atc = "B02BB01" ; cod_ucd_chr = "0000009360527" ; OUTPUT ; 
code_ucd = 9360527 ; nom_court = "RIASTAP 1 G Poudre pour solution injectable pour perfusion" ; cod_atc = "B02BB01" ; cod_ucd_chr = "0000009360527" ; OUTPUT ; 
code_ucd = 9360651 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 10 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360651" ; OUTPUT ; 
code_ucd = 9360651 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 10 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360651" ; OUTPUT ; 
code_ucd = 9360668 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 100 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360668" ; OUTPUT ; 
code_ucd = 9360668 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 100 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360668" ; OUTPUT ; 
code_ucd = 9360674 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 200 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360674" ; OUTPUT ; 
code_ucd = 9360674 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 200 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360674" ; OUTPUT ; 
code_ucd = 9360680 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 400 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360680" ; OUTPUT ; 
code_ucd = 9360680 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 400 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360680" ; OUTPUT ; 
code_ucd = 9360697 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 50 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360697" ; OUTPUT ; 
code_ucd = 9360697 ; nom_court = "FLEBOGAMMA DIF 50 MG/ML solution pour perfusion, 50 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009360697" ; OUTPUT ; 
code_ucd = 9360898 ; nom_court = "IDARUBICINE SANDOZ 1 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009360898" ; OUTPUT ; 
code_ucd = 9360898 ; nom_court = "IDARUBICINE SANDOZ 1 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009360898" ; OUTPUT ; 
code_ucd = 9360906 ; nom_court = "IDARUBICINE SANDOZ 1 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009360906" ; OUTPUT ; 
code_ucd = 9360906 ; nom_court = "IDARUBICINE SANDOZ 1 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009360906" ; OUTPUT ; 
code_ucd = 9360912 ; nom_court = "IDARUBICINE SANDOZ 1 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009360912" ; OUTPUT ; 
code_ucd = 9360912 ; nom_court = "IDARUBICINE SANDOZ 1 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009360912" ; OUTPUT ; 
code_ucd = 9360929 ; nom_court = "DACARBAZINE TEVA 100 MG poudre pour perfusion" ; cod_atc = " " ; cod_ucd_chr = "0000009360929" ; OUTPUT ; 
code_ucd = 9361389 ; nom_court = "ROPIVACAINE KABI 2 MG/ML solution pour perfusion en poche polyolefine suremballee de 100 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009361389" ; OUTPUT ; 
code_ucd = 9361395 ; nom_court = "ROPIVACAINE KABI 2 MG/ML solution pour perfusion en poche polyolefine suremballee de 200 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009361395" ; OUTPUT ; 
code_ucd = 9361484 ; nom_court = "DOCEFREZ 20 MG poudre et solvant pour concentre pour solution pour perfusion" ; cod_atc = " " ; cod_ucd_chr = "0000009361484" ; OUTPUT ; 
code_ucd = 9361490 ; nom_court = "DOCEFREZ 80 MG poudre et solvant pour concentre pour solution pour perfusion" ; cod_atc = " " ; cod_ucd_chr = "0000009361490" ; OUTPUT ; 
code_ucd = 9362696 ; nom_court = "RUCONEST 2100 UI poudre pour solution injectable" ; cod_atc = "B06AC04" ; cod_ucd_chr = "0000009362696" ; OUTPUT ; 
code_ucd = 9362696 ; nom_court = "RUCONEST 2100 UI poudre pour solution injectable" ; cod_atc = "B06AC04" ; cod_ucd_chr = "0000009362696" ; OUTPUT ; 
code_ucd = 9362733 ; nom_court = "KOGENATE BAYER 3000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009362733" ; OUTPUT ; 
code_ucd = 9362733 ; nom_court = "KOGENATE BAYER 3000 UI Poudre et solvant pour solution injectable" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009362733" ; OUTPUT ; 
code_ucd = 9362940 ; nom_court = "INCIVO 375 MG Comprime pellicule" ; cod_atc = "J05AE11" ; cod_ucd_chr = "0000009362940" ; OUTPUT ; 
code_ucd = 9362992 ; nom_court = "BOCEPREVIR SCHERING-PLOUGH 200 MG Gelules" ; cod_atc = "J05A" ; cod_ucd_chr = "0000009362992" ; OUTPUT ; 
code_ucd = 9363017 ; nom_court = "GEMCITABINE SANDOZ 40 MG/ML Solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009363017" ; OUTPUT ; 
code_ucd = 9363023 ; nom_court = "GEMCITABINE SANDOZ 40 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009363023" ; OUTPUT ; 
code_ucd = 9363046 ; nom_court = "GEMCITABINE SANDOZ 40 MG/ML Solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009363046" ; OUTPUT ; 
code_ucd = 9363247 ; nom_court = "DOXORUBICINE ACCORD 2 MG/ML solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009363247" ; OUTPUT ; 
code_ucd = 9363282 ; nom_court = "PACLITAXEL AHCL 6 MG/ML solution a diluer pour perfusion en flacon en verre de 16,7 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009363282" ; OUTPUT ; 
code_ucd = 9363299 ; nom_court = "PACLITAXEL AHCL 6 MG/ML solution a diluer pour perfusion en flacon en verre de 5 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009363299" ; OUTPUT ; 
code_ucd = 9363307 ; nom_court = "PACLITAXEL AHCL 6 MG/ML solution a diluer pour perfusion en flacon en verre de 50 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009363307" ; OUTPUT ; 
code_ucd = 9363431 ; nom_court = "BINOCRIT 20 000 UI/0,5 ML solution injectable en seringue preremplie avec aiguille munie d'un dispositif de securite" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009363431" ; OUTPUT ; 
code_ucd = 9363454 ; nom_court = "BINOCRIT 30 000 UI/0,75 ML solution injectable en seringue preremplie avec aiguille munie d'un dispositif de securite" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009363454" ; OUTPUT ; 
code_ucd = 9363477 ; nom_court = "BINOCRIT 40 000 UI/1 ML solution injectable en seringue preremplie avec aiguille munie d'un dispositif de securite" ; cod_atc = "B03XA01" ; cod_ucd_chr = "0000009363477" ; OUTPUT ; 
code_ucd = 9364270 ; nom_court = "IRINOTECAN ACTAVIS 20 MG/ML solution a diluer pour perfusion en flacon de 15 ml" ; cod_atc = "L01XX19" ; cod_ucd_chr = "0000009364270" ; OUTPUT ; 
code_ucd = 9364519 ; nom_court = "ROPIVACAINE ACTAVIS 2 MG/ML solution pour perfusion en poche polyolefine suremballee de 100 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009364519" ; OUTPUT ; 
code_ucd = 9364525 ; nom_court = "ROPIVACAINE ACTAVIS 2 MG/ML solution pour perfusion en poche polyolefine suremballee de 200 ml" ; cod_atc = "N01BB09" ; cod_ucd_chr = "0000009364525" ; OUTPUT ; 
code_ucd = 9365080 ; nom_court = "IDARUBICINE TEVA 1 MG/ML Solution a diluer pour perfusion, flacon de 10 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009365080" ; OUTPUT ; 
code_ucd = 9365080 ; nom_court = "IDARUBICINE TEVA 1 MG/ML Solution a diluer pour perfusion, flacon de 10 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009365080" ; OUTPUT ; 
code_ucd = 9365097 ; nom_court = "IDARUBICINE TEVA 1 MG/ML Solution a diluer pour perfusion, flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009365097" ; OUTPUT ; 
code_ucd = 9365097 ; nom_court = "IDARUBICINE TEVA 1 MG/ML Solution a diluer pour perfusion, flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009365097" ; OUTPUT ; 
code_ucd = 9365401 ; nom_court = "FER TEVA PHARMA 100 MG/5 ML Solution injectable (IV)" ; cod_atc = " " ; cod_ucd_chr = "0000009365401" ; OUTPUT ; 
code_ucd = 9365499 ; nom_court = "TOPOTECAN MYLAN 1MG/ML Solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009365499" ; OUTPUT ; 
code_ucd = 9365499 ; nom_court = "TOPOTECAN MYLAN 1MG/ML Solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009365499" ; OUTPUT ; 
code_ucd = 9365507 ; nom_court = "TOPOTECAN MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009365507" ; OUTPUT ; 
code_ucd = 9365507 ; nom_court = "TOPOTECAN MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009365507" ; OUTPUT ; 
code_ucd = 9365513 ; nom_court = "TOPOTECAN MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009365513" ; OUTPUT ; 
code_ucd = 9365513 ; nom_court = "TOPOTECAN MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009365513" ; OUTPUT ; 
code_ucd = 9365625 ; nom_court = "CYRDANAX 20 MG/ ML poudre pour solution pour perfusion en flacon de 500 mg" ; cod_atc = "V03AF02" ; cod_ucd_chr = "0000009365625" ; OUTPUT ; 
code_ucd = 9365625 ; nom_court = "CYRDANAX 20 MG/ ML poudre pour solution pour perfusion en flacon de 500 mg" ; cod_atc = "V03AF02" ; cod_ucd_chr = "0000009365625" ; OUTPUT ; 
code_ucd = 9365950 ; nom_court = "JEVTANA 60 MG 1 Boite de 2, flacon (verre), solution a diluer : 1,5 ml , solvant : 4,5 ml, boite 1 flacon + 1 flacon, solution a diluer et s" ; cod_atc = "L01CD" ; cod_ucd_chr = "0000009365950" ; OUTPUT ; 
code_ucd = 9366116 ; nom_court = "NORVIR 80 MG/ML solution buvable en flacon de 90 ml, boite de 1 flacon + 1 seringue doseuse" ; cod_atc = "J05AE03" ; cod_ucd_chr = "0000009366116" ; OUTPUT ; 
code_ucd = 9366441 ; nom_court = "PACLITAXEL KABI 6 MG/ML Solution a diluer pour perfusion en flacon de 100 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009366441" ; OUTPUT ; 
code_ucd = 9366458 ; nom_court = "PACLITAXEL KABI 6 MG/ML Solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = "L01CD01" ; cod_ucd_chr = "0000009366458" ; OUTPUT ; 
code_ucd = 9366636 ; nom_court = "DOCETAXEL ACTAVIS 20 MG/ML solution a diluer pour perfusion, flacon de 1 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009366636" ; OUTPUT ; 
code_ucd = 9366636 ; nom_court = "DOCETAXEL ACTAVIS 20 MG/ML solution a diluer pour perfusion, flacon de 1 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009366636" ; OUTPUT ; 
code_ucd = 9366642 ; nom_court = "DOCETAXEL ACTAVIS 20 MG/ML solution a diluer pour perfusion, flacon de 4 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009366642" ; OUTPUT ; 
code_ucd = 9366642 ; nom_court = "DOCETAXEL ACTAVIS 20 MG/ML solution a diluer pour perfusion, flacon de 4 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009366642" ; OUTPUT ; 
code_ucd = 9366659 ; nom_court = "DOCETAXEL ACTAVIS 20 MG/ML solution a diluer pour perfusion, flacon de 7 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009366659" ; OUTPUT ; 
code_ucd = 9366659 ; nom_court = "DOCETAXEL ACTAVIS 20 MG/ML solution a diluer pour perfusion, flacon de 7 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009366659" ; OUTPUT ; 
code_ucd = 9367535 ; nom_court = "DOCETAXEL EBEWE 10 MG/ML Solution a diluer pour perfusion en flacon de 16 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009367535" ; OUTPUT ; 
code_ucd = 9367535 ; nom_court = "DOCETAXEL EBEWE 10 MG/ML Solution a diluer pour perfusion en flacon de 16 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009367535" ; OUTPUT ; 
code_ucd = 9367587 ; nom_court = "RIBAVIRINE MYLAN 200 MG gelule" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009367587" ; OUTPUT ; 
code_ucd = 9368606 ; nom_court = "GEMCITABINE HOSPIRA 38 MG/ML solution a diluer pour perfusion en flacon de 26.3 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009368606" ; OUTPUT ; 
code_ucd = 9368612 ; nom_court = "GEMCITABINE HOSPIRA 38 MG/ML Solution a diluer pour perfusion en flacon de 5.3 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009368612" ; OUTPUT ; 
code_ucd = 9368629 ; nom_court = "GEMCITABINE HOSPIRA 38 MG/ML Solution a diluer pour perfusion en flacon de 52.6 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009368629" ; OUTPUT ; 
code_ucd = 9368664 ; nom_court = "HUMIRA 40 MG/0,8 ML solution injectable pour usage pediatrique" ; cod_atc = "L04AB04" ; cod_ucd_chr = "0000009368664" ; OUTPUT ; 
code_ucd = 9368747 ; nom_court = "RO5185426 (VEMURAFENIB) 240 MG Comprimes pellicules" ; cod_atc = "L01XE15" ; cod_ucd_chr = "0000009368747" ; OUTPUT ; 
code_ucd = 9368836 ; nom_court = "TOPOTECAN KABI 1 MG/ML Solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009368836" ; OUTPUT ; 
code_ucd = 9368836 ; nom_court = "TOPOTECAN KABI 1 MG/ML Solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009368836" ; OUTPUT ; 
code_ucd = 9368919 ; nom_court = "TOPOTECAN EBEWE 1 MG/ML solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009368919" ; OUTPUT ; 
code_ucd = 9368919 ; nom_court = "TOPOTECAN EBEWE 1 MG/ML solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009368919" ; OUTPUT ; 
code_ucd = 9368925 ; nom_court = "TOPOTECAN EBEWE 1 MG/ML solution a diluer pour perfusion en flacon de 3 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009368925" ; OUTPUT ; 
code_ucd = 9368925 ; nom_court = "TOPOTECAN EBEWE 1 MG/ML solution a diluer pour perfusion en flacon de 3 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009368925" ; OUTPUT ; 
code_ucd = 9368931 ; nom_court = "TOPOTECAN EBEWE 1 MG/ML solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009368931" ; OUTPUT ; 
code_ucd = 9368931 ; nom_court = "TOPOTECAN EBEWE 1 MG/ML solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009368931" ; OUTPUT ; 
code_ucd = 9368954 ; nom_court = "HALAVEN 0,44 MG/ML solution injectable en flacon de 2 ml" ; cod_atc = "L01XX41" ; cod_ucd_chr = "0000009368954" ; OUTPUT ; 
code_ucd = 9368983 ; nom_court = "HIZENTRA 200 MG/ML Solution injectable sous-cutanee en flacon de 10 ml" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009368983" ; OUTPUT ; 
code_ucd = 9368983 ; nom_court = "HIZENTRA 200 MG/ML Solution injectable sous-cutanee en flacon de 10 ml" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009368983" ; OUTPUT ; 
code_ucd = 9369008 ; nom_court = "HIZENTRA 200MG/ML Solution injectable sous-cutanee en flacon de 20 ml" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009369008" ; OUTPUT ; 
code_ucd = 9369008 ; nom_court = "HIZENTRA 200MG/ML Solution injectable sous-cutanee en flacon de 20 ml" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009369008" ; OUTPUT ; 
code_ucd = 9369014 ; nom_court = "HIZENTRA 200 MG/ML Solution injectable sous-cutanee en flacon de 5 ml" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009369014" ; OUTPUT ; 
code_ucd = 9369014 ; nom_court = "HIZENTRA 200 MG/ML Solution injectable sous-cutanee en flacon de 5 ml" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009369014" ; OUTPUT ; 
code_ucd = 9369126 ; nom_court = "RIBAVIRINE SANDOZ 200 MG Gelule" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009369126" ; OUTPUT ; 
code_ucd = 9371637 ; nom_court = "DOCETAXEL EG 20 MG/ML Solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009371637" ; OUTPUT ; 
code_ucd = 9371643 ; nom_court = "DOCETAXEL EG 20 MG/ML Solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009371643" ; OUTPUT ; 
code_ucd = 9371726 ; nom_court = "IDARUBICINE MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009371726" ; OUTPUT ; 
code_ucd = 9371726 ; nom_court = "IDARUBICINE MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009371726" ; OUTPUT ; 
code_ucd = 9371732 ; nom_court = "IDARUBICINE MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009371732" ; OUTPUT ; 
code_ucd = 9371732 ; nom_court = "IDARUBICINE MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01DB06" ; cod_ucd_chr = "0000009371732" ; OUTPUT ; 
code_ucd = 9371778 ; nom_court = "IDARUBICINE MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009371778" ; OUTPUT ; 
code_ucd = 9371778 ; nom_court = "IDARUBICINE MYLAN 1 MG/ML Solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009371778" ; OUTPUT ; 
code_ucd = 9372482 ; nom_court = "TOPOTECAN TEVA 4 MG/4ML Solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009372482" ; OUTPUT ; 
code_ucd = 9372482 ; nom_court = "TOPOTECAN TEVA 4 MG/4ML Solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009372482" ; OUTPUT ; 
code_ucd = 9372619 ; nom_court = "OCTAGAM 50 MG/ML solution pour perfusion, flacon en verre de 500 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009372619" ; OUTPUT ; 
code_ucd = 9372619 ; nom_court = "OCTAGAM 50 MG/ML solution pour perfusion, flacon en verre de 500 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009372619" ; OUTPUT ; 
code_ucd = 9372743 ; nom_court = "TEMOZOLOMIDE SUN 100 MG gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009372743" ; OUTPUT ; 
code_ucd = 9372766 ; nom_court = "TEMOZOLOMIDE SUN 140 MG gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009372766" ; OUTPUT ; 
code_ucd = 9372772 ; nom_court = "TEMOZOLOMIDE SUN 180 MG gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009372772" ; OUTPUT ; 
code_ucd = 9372789 ; nom_court = "TEMOZOLOMIDE SUN 20 MG gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009372789" ; OUTPUT ; 
code_ucd = 9372795 ; nom_court = "TEMOZOLOMIDE SUN 250 MG gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009372795" ; OUTPUT ; 
code_ucd = 9372803 ; nom_court = "TEMOZOLOMIDE SUN 5 MG gelule" ; cod_atc = "L01AX03" ; cod_ucd_chr = "0000009372803" ; OUTPUT ; 
code_ucd = 9373004 ; nom_court = "ZYTIGA 250 MG Comprime" ; cod_atc = "L02BX03" ; cod_ucd_chr = "0000009373004" ; OUTPUT ; 
code_ucd = 9373091 ; nom_court = "TMC207 100 MG comprime" ; cod_atc = "J04AK05" ; cod_ucd_chr = "0000009373091" ; OUTPUT ; 
code_ucd = 9373122 ; nom_court = "VICTRELIS 200 MG GELULE" ; cod_atc = "J05AE12" ; cod_ucd_chr = "0000009373122" ; OUTPUT ; 
code_ucd = 9373381 ; nom_court = "RIBAVIRINE MYLAN 200 MG comprime pellicule" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009373381" ; OUTPUT ; 
code_ucd = 9373398 ; nom_court = "RIBAVIRINE MYLAN 400 MG comprime pellicule" ; cod_atc = "J05AB04" ; cod_ucd_chr = "0000009373398" ; OUTPUT ; 
code_ucd = 9373576 ; nom_court = "GILENYA 0.5 MG gelule" ; cod_atc = "L04AA27" ; cod_ucd_chr = "0000009373576" ; OUTPUT ; 
code_ucd = 9373599 ; nom_court = "REFACTO AF 3 000 UI poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009373599" ; OUTPUT ; 
code_ucd = 9373599 ; nom_court = "REFACTO AF 3 000 UI poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009373599" ; OUTPUT ; 
code_ucd = 9373636 ; nom_court = "REFACTO AF 1 000 UI poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009373636" ; OUTPUT ; 
code_ucd = 9373636 ; nom_court = "REFACTO AF 1 000 UI poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009373636" ; OUTPUT ; 
code_ucd = 9373642 ; nom_court = "REFACTO AF 2 000 UI poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009373642" ; OUTPUT ; 
code_ucd = 9373642 ; nom_court = "REFACTO AF 2 000 UI poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009373642" ; OUTPUT ; 
code_ucd = 9373659 ; nom_court = "REFACTO AF 500 UI poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009373659" ; OUTPUT ; 
code_ucd = 9373659 ; nom_court = "REFACTO AF 500 UI poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009373659" ; OUTPUT ; 
code_ucd = 9373671 ; nom_court = "ZUTECTRA 500 UI solution injectable en seringue preremplie de 1 ml" ; cod_atc = "J06BB04" ; cod_ucd_chr = "0000009373671" ; OUTPUT ; 
code_ucd = 9373694 ; nom_court = "TAFAMIDIS MEGLUMINE 20 MG Capsule molle" ; cod_atc = "N07XX08" ; cod_ucd_chr = "0000009373694" ; OUTPUT ; 
code_ucd = 9373725 ; nom_court = "FLEBOGAMMA DIF 100 MG/ML solution pour perfusion, 100 ml en flacon" ; cod_atc = " " ; cod_ucd_chr = "0000009373725" ; OUTPUT ; 
code_ucd = 9373725 ; nom_court = "FLEBOGAMMA DIF 100 MG/ML solution pour perfusion, 100 ml en flacon" ; cod_atc = " " ; cod_ucd_chr = "0000009373725" ; OUTPUT ; 
code_ucd = 9373731 ; nom_court = "FLEBOGAMMA DIF 100 MG/ML solution pour perfusion, 200 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009373731" ; OUTPUT ; 
code_ucd = 9373731 ; nom_court = "FLEBOGAMMA DIF 100 MG/ML solution pour perfusion, 200 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009373731" ; OUTPUT ; 
code_ucd = 9373748 ; nom_court = "FLEBOGAMMA DIF 100 MG/ML solution pour perfusion, 50 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009373748" ; OUTPUT ; 
code_ucd = 9373748 ; nom_court = "FLEBOGAMMA DIF 100 MG/ML solution pour perfusion, 50 ml en flacon." ; cod_atc = " " ; cod_ucd_chr = "0000009373748" ; OUTPUT ; 
code_ucd = 9374050 ; nom_court = "YERVOY 5 MG/ML solution a diluer pour perfusion, flacon de 50 mg/10 ml" ; cod_atc = "L01XC11" ; cod_ucd_chr = "0000009374050" ; OUTPUT ; 
code_ucd = 9374067 ; nom_court = "YERVOY 5 MG/ML solution a diluer pour perfusion, flacon de 200 mg/40 ml" ; cod_atc = "L01XC11" ; cod_ucd_chr = "0000009374067" ; OUTPUT ; 
code_ucd = 9374682 ; nom_court = "PEGASYS 135 MICROGRAMMES solution injectable en stylo prerempli de 0,5 ml" ; cod_atc = "L03AB11" ; cod_ucd_chr = "0000009374682" ; OUTPUT ; 
code_ucd = 9374699 ; nom_court = "PEGASYS 180 MICROGRAMMES solution injectable en stylo prerempli de 0,5 ml" ; cod_atc = "L03AB11" ; cod_ucd_chr = "0000009374699" ; OUTPUT ; 
code_ucd = 9375440 ; nom_court = "LAMIVUDINE/ZIDOVUDINE TEVA 150 MG/300 MG comprime pellicule secable" ; cod_atc = "J05AR01" ; cod_ucd_chr = "0000009375440" ; OUTPUT ; 
code_ucd = 9375635 ; nom_court = "VIRAMUNE 100 MG comprime a liberation prolongee" ; cod_atc = "J05AG01" ; cod_ucd_chr = "0000009375635" ; OUTPUT ; 
code_ucd = 9375641 ; nom_court = "VIRAMUNE 400 MG comprime a liberation prolongee" ; cod_atc = "J05AG01" ; cod_ucd_chr = "0000009375641" ; OUTPUT ; 
code_ucd = 9377120 ; nom_court = "SIMPONI 50 MG solution injectable, boite de 1 seringue preremplie 0,5 ml" ; cod_atc = "L04AB06" ; cod_ucd_chr = "0000009377120" ; OUTPUT ; 
code_ucd = 9377137 ; nom_court = "SIMPONI 50 MG solution injectable, boite de 1 stylo prerempli 0,5 ml" ; cod_atc = "L04AB06" ; cod_ucd_chr = "0000009377137" ; OUTPUT ; 
code_ucd = 9378088 ; nom_court = "OXALIPLATINE KABI 5 MG/ML solution a diluer pour perfusion en flacon de 40 ml" ; cod_atc = "L01XA03" ; cod_ucd_chr = "0000009378088" ; OUTPUT ; 
code_ucd = 9378119 ; nom_court = "CARBOPLATINE SANDOZ 10 MG/ML solution pour perfusion en flacon de 100 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009378119" ; OUTPUT ; 
code_ucd = 9378125 ; nom_court = "CARBOPLATINE SANDOZ 10 MG/ML solution pour perfusion en flacon de 60 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009378125" ; OUTPUT ; 
code_ucd = 9378131 ; nom_court = "EVIPLERA 200 MG/25 MG/245 MG comprime pellicule" ; cod_atc = "J05AR06" ; cod_ucd_chr = "0000009378131" ; OUTPUT ; 
code_ucd = 9378154 ; nom_court = "VIMPAT 10 MG/ML sirop" ; cod_atc = " " ; cod_ucd_chr = "0000009378154" ; OUTPUT ; 
code_ucd = 9378496 ; nom_court = "POTACTASOL 1 MG poudre pour solution a diluer pour perfusion en flacon de 1 mg" ; cod_atc = " " ; cod_ucd_chr = "0000009378496" ; OUTPUT ; 
code_ucd = 9378496 ; nom_court = "POTACTASOL 1 MG poudre pour solution a diluer pour perfusion en flacon de 1 mg" ; cod_atc = " " ; cod_ucd_chr = "0000009378496" ; OUTPUT ; 
code_ucd = 9378504 ; nom_court = "POTACTASOL 4 MG poudre pour solution a diluer pour perfusion en flacon de 4 mg" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009378504" ; OUTPUT ; 
code_ucd = 9378504 ; nom_court = "POTACTASOL 4 MG poudre pour solution a diluer pour perfusion en flacon de 4 mg" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009378504" ; OUTPUT ; 
code_ucd = 9379917 ; nom_court = "TOPOTECAN MEDAC 1 MG/ML solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009379917" ; OUTPUT ; 
code_ucd = 9379917 ; nom_court = "TOPOTECAN MEDAC 1 MG/ML solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009379917" ; OUTPUT ; 
code_ucd = 9379946 ; nom_court = "TOPOTECAN MEDAC 1 MG/ML solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009379946" ; OUTPUT ; 
code_ucd = 9379946 ; nom_court = "TOPOTECAN MEDAC 1 MG/ML solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009379946" ; OUTPUT ; 
code_ucd = 9379975 ; nom_court = "GEMCITABINE INTAS 100 MG/ML solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009379975" ; OUTPUT ; 
code_ucd = 9379981 ; nom_court = "GEMCITABINE INTAS 100 MG/ML solution a diluer pour perfusion en flacon de 10 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009379981" ; OUTPUT ; 
code_ucd = 9379998 ; nom_court = "GEMCITABINE INTAS 100 MG/ML solution a diluer pour perfusion en flacon de 15 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009379998" ; OUTPUT ; 
code_ucd = 9380004 ; nom_court = "GEMCITABINE INTAS 100 MG/ML solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01BC05" ; cod_ucd_chr = "0000009380004" ; OUTPUT ; 
code_ucd = 9380470 ; nom_court = "INTELENCE 200 MG comprime" ; cod_atc = "J05AG04" ; cod_ucd_chr = "0000009380470" ; OUTPUT ; 
code_ucd = 9380607 ; nom_court = "DOXORUBICINE ACTAVIS 2 MG/ML solution pour perfusion en flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009380607" ; OUTPUT ; 
code_ucd = 9380613 ; nom_court = "DOXORUBICINE ACTAVIS 2 MG/ML solution pour perfusion en flacon de 25 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009380613" ; OUTPUT ; 
code_ucd = 9380636 ; nom_court = "DOXORUBICINE ACTAVIS 2 MG/ML solution pour perfusion en flacon de 100 ml" ; cod_atc = "L01DB01" ; cod_ucd_chr = "0000009380636" ; OUTPUT ; 
code_ucd = 9380837 ; nom_court = "VYNDAQEL 20 MG capsule molle" ; cod_atc = "N07XX08" ; cod_ucd_chr = "0000009380837" ; OUTPUT ; 
code_ucd = 9381067 ; nom_court = "CRIZOTINIB 200 MG gelule" ; cod_atc = "A07AX03" ; cod_ucd_chr = "0000009381067" ; OUTPUT ; 
code_ucd = 9381073 ; nom_court = "CRIZOTINIB 250 MG gelule" ; cod_atc = "A07AX03" ; cod_ucd_chr = "0000009381073" ; OUTPUT ; 
code_ucd = 9381222 ; nom_court = "TOPOTECANE ACCORD HEALTHCARE 4 MG Poudre pour solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = "L01XX17" ; cod_ucd_chr = "0000009381222" ; OUTPUT ; 
code_ucd = 9382003 ; nom_court = "DOCETAXEL TEVA 20 MG/ML solution a diluer pour perfusion en flacon de 1 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009382003" ; OUTPUT ; 
code_ucd = 9382026 ; nom_court = "DOCETAXEL TEVA 20 MG/ML solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009382026" ; OUTPUT ; 
code_ucd = 9382032 ; nom_court = "DOCETAXEL TEVA 20 MG/ML solution a diluer pour perfusion en flacon de 7 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009382032" ; OUTPUT ; 
code_ucd = 9382084 ; nom_court = "ALFALASTIN 33,33 MG/ML poudre et solvant pour solution injectable, poudre en flacon + 120 ml de solvant en flacon avec un systeme de transfert muni d" ; cod_atc = "B02AB02" ; cod_ucd_chr = "0000009382084" ; OUTPUT ; 
code_ucd = 9382173 ; nom_court = "POMALIDOMIDE CELGENE 4 mg, gelule" ; cod_atc = "L" ; cod_ucd_chr = "0000009382173" ; OUTPUT ; 
code_ucd = 9382196 ; nom_court = "POMALIDOMIDE CELGENE 1 mg, gelule" ; cod_atc = "L" ; cod_ucd_chr = "0000009382196" ; OUTPUT ; 
code_ucd = 9382262 ; nom_court = "RUXOLITINIB 5 MG comprimes" ; cod_atc = "L01XE18" ; cod_ucd_chr = "0000009382262" ; OUTPUT ; 
code_ucd = 9382351 ; nom_court = "CINRYZE 500 UNITES poudre et solvant pour solution injectable" ; cod_atc = "B02AB" ; cod_ucd_chr = "0000009382351" ; OUTPUT ; 
code_ucd = 9382351 ; nom_court = "CINRYZE 500 UNITES poudre et solvant pour solution injectable" ; cod_atc = "B02AB" ; cod_ucd_chr = "0000009382351" ; OUTPUT ; 
code_ucd = 9382405 ; nom_court = "POMALIDOMIDE CELGENE 2 mg, gelule" ; cod_atc = "L" ; cod_ucd_chr = "0000009382405" ; OUTPUT ; 
code_ucd = 9382730 ; nom_court = "EDURANT 25 MG comprime pellicule" ; cod_atc = "J05AG05" ; cod_ucd_chr = "0000009382730" ; OUTPUT ; 
code_ucd = 9382807 ; nom_court = "POMALIDOMIDE CELGENE 3 mg, gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009382807" ; OUTPUT ; 
code_ucd = 9383497 ; nom_court = "ADVATE 1 000 UI poudre et solvant pour solution injectable, flacon en verre de 250 UI" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009383497" ; OUTPUT ; 
code_ucd = 9383497 ; nom_court = "ADVATE 1 000 UI poudre et solvant pour solution injectable, flacon en verre de 250 UI" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009383497" ; OUTPUT ; 
code_ucd = 9383505 ; nom_court = "ADVATE 1 500 UI poudre et solvant pour solution injectable, flacon en verre de 250 UI" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009383505" ; OUTPUT ; 
code_ucd = 9383505 ; nom_court = "ADVATE 1 500 UI poudre et solvant pour solution injectable, flacon en verre de 250 UI" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009383505" ; OUTPUT ; 
code_ucd = 9383511 ; nom_court = "ADVATE 250 UI poudre et solvant pour solution injectable, flacon en verre de 250 UI" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009383511" ; OUTPUT ; 
code_ucd = 9383511 ; nom_court = "ADVATE 250 UI poudre et solvant pour solution injectable, flacon en verre de 250 UI" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009383511" ; OUTPUT ; 
code_ucd = 9383528 ; nom_court = "ADVATE 500 UI poudre et solvant pour solution injectable, flacon en verre de 250 UI" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009383528" ; OUTPUT ; 
code_ucd = 9383528 ; nom_court = "ADVATE 500 UI poudre et solvant pour solution injectable, flacon en verre de 250 UI" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009383528" ; OUTPUT ; 
code_ucd = 9384077 ; nom_court = "NOVOSEVEN 8 MG (400 KUI) poudre et solvant pour solution injectable" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009384077" ; OUTPUT ; 
code_ucd = 9384077 ; nom_court = "NOVOSEVEN 8 MG (400 KUI) poudre et solvant pour solution injectable" ; cod_atc = "B02BD08" ; cod_ucd_chr = "0000009384077" ; OUTPUT ; 
code_ucd = 9384373 ; nom_court = "DIFICLIR 200 MG comprimes pellicule" ; cod_atc = "A07AA12" ; cod_ucd_chr = "0000009384373" ; OUTPUT ; 
code_ucd = 9384373 ; nom_court = "DIFICLIR 200 MG comprimes pellicule" ; cod_atc = "A07AA12" ; cod_ucd_chr = "0000009384373" ; OUTPUT ; 
code_ucd = 9384485 ; nom_court = "DOCETAXEL ACCORD 20 MG/ML Flacon de 8 ml/160 mg, solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009384485" ; OUTPUT ; 
code_ucd = 9384491 ; nom_court = "DOCETAXEL ACCORD 20 MG/ML Flacon de 1 ml/20 mg, solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009384491" ; OUTPUT ; 
code_ucd = 9384516 ; nom_court = "DOCETAXEL ACCORD 20 MG/ML Flacon de 4 ml/80 mg, solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009384516" ; OUTPUT ; 
code_ucd = 9385013 ; nom_court = "REVATIO 10 MG/ML poudre pour suspension buvable" ; cod_atc = "G04BE03" ; cod_ucd_chr = "0000009385013" ; OUTPUT ; 
code_ucd = 9385728 ; nom_court = "RUXOLITINIB 15 MG comprimes" ; cod_atc = "L01XE18" ; cod_ucd_chr = "0000009385728" ; OUTPUT ; 
code_ucd = 9385734 ; nom_court = "RUXOLITINIB 20 MG comprimes" ; cod_atc = "L01XE18" ; cod_ucd_chr = "0000009385734" ; OUTPUT ; 
code_ucd = 9385929 ; nom_court = "KALYDECO 150 MG COMPRIME PELLICULE" ; cod_atc = "R07AX02" ; cod_ucd_chr = "0000009385929" ; OUTPUT ; 
code_ucd = 9386573 ; nom_court = "LAMIVUDINE MYLAN 150 MG comprimes pellicules secables" ; cod_atc = "J05AF05" ; cod_ucd_chr = "0000009386573" ; OUTPUT ; 
code_ucd = 9386596 ; nom_court = "LAMIVUDINE MYLAN 300 MG comprimes pellicules" ; cod_atc = "J05AF05" ; cod_ucd_chr = "0000009386596" ; OUTPUT ; 
code_ucd = 9387070 ; nom_court = "DOCETAXEL KABI 120 MG/6 ML solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009387070" ; OUTPUT ; 
code_ucd = 9387087 ; nom_court = "DOCETAXEL KABI 160 MG/8 ML solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009387087" ; OUTPUT ; 
code_ucd = 9387093 ; nom_court = "DOCETAXEL KABI 180 MG/9 ML solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009387093" ; OUTPUT ; 
code_ucd = 9387101 ; nom_court = "DOCETAXEL KABI 80 MG/4 ML solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009387101" ; OUTPUT ; 
code_ucd = 9387495 ; nom_court = "DOCETAXEL SERVIPHARM 10 MG/ML solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009387495" ; OUTPUT ; 
code_ucd = 9387503 ; nom_court = "DOCETAXEL SERVIPHARM 10 MG/ML solution a diluer pour perfusion en flacon de 8 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009387503" ; OUTPUT ; 
code_ucd = 9387609 ; nom_court = "PHEBURANE 483 MG/G granules" ; cod_atc = "A16AX03" ; cod_ucd_chr = "0000009387609" ; OUTPUT ; 
code_ucd = 9387868 ; nom_court = "LAMIVUDINE/ZIDOVUDINE MYLAN 150 MG/300 MG comprimes pellicules secables" ; cod_atc = "J05AR01" ; cod_ucd_chr = "0000009387868" ; OUTPUT ; 
code_ucd = 9388891 ; nom_court = "DOCETAXEL KABI 20 MG/1 ML solution a diluer pour perfusion" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009388891" ; OUTPUT ; 
code_ucd = 9389614 ; nom_court = "REGORAFENIB 40 mg comprimes pellicules" ; cod_atc = "L01XE21" ; cod_ucd_chr = "0000009389614" ; OUTPUT ; 
code_ucd = 9389732 ; nom_court = "NOVOSEVEN 1 MG (50 KUI) poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = " " ; cod_ucd_chr = "0000009389732" ; OUTPUT ; 
code_ucd = 9389732 ; nom_court = "NOVOSEVEN 1 MG (50 KUI) poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = " " ; cod_ucd_chr = "0000009389732" ; OUTPUT ; 
code_ucd = 9389749 ; nom_court = "NOVOSEVEN 2 MG (100 KUI) poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = " " ; cod_ucd_chr = "0000009389749" ; OUTPUT ; 
code_ucd = 9389749 ; nom_court = "NOVOSEVEN 2 MG (100 KUI) poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = " " ; cod_ucd_chr = "0000009389749" ; OUTPUT ; 
code_ucd = 9389755 ; nom_court = "NOVOSEVEN 5 MG (250 KUI) poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = " " ; cod_ucd_chr = "0000009389755" ; OUTPUT ; 
code_ucd = 9389755 ; nom_court = "NOVOSEVEN 5 MG (250 KUI) poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = " " ; cod_ucd_chr = "0000009389755" ; OUTPUT ; 
code_ucd = 9389761 ; nom_court = "NOVOSEVEN 8 MG (400 KUI) poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = " " ; cod_ucd_chr = "0000009389761" ; OUTPUT ; 
code_ucd = 9389761 ; nom_court = "NOVOSEVEN 8 MG (400 KUI) poudre et solvant pour solution injectable (flacon + solvant)" ; cod_atc = " " ; cod_ucd_chr = "0000009389761" ; OUTPUT ; 
code_ucd = 9390184 ; nom_court = "BENEFIX 3000 UI, Poudre et solvant pour solution injectable" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009390184" ; OUTPUT ; 
code_ucd = 9390184 ; nom_court = "BENEFIX 3000 UI, Poudre et solvant pour solution injectable" ; cod_atc = "B02BD09" ; cod_ucd_chr = "0000009390184" ; OUTPUT ; 
code_ucd = 9390209 ; nom_court = "REFACTO AF 250 UI, Poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009390209" ; OUTPUT ; 
code_ucd = 9390209 ; nom_court = "REFACTO AF 250 UI, Poudre et solvant pour solution injectable en seringue preremplie" ; cod_atc = "B02BD02" ; cod_ucd_chr = "0000009390209" ; OUTPUT ; 
code_ucd = 9390267 ; nom_court = "ORENCIA 125 MG solution injectable en seringue preremplie" ; cod_atc = "L04AA24" ; cod_ucd_chr = "0000009390267" ; OUTPUT ; 
code_ucd = 9390882 ; nom_court = "DOCETAXEL PFIZER 10 MG/ML solution a diluer pour perfusion en flacon de 13 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009390882" ; OUTPUT ; 
code_ucd = 9390899 ; nom_court = "DOCETAXEL PFIZER 10 MG/ML solution a diluer pour perfusion en flacon de 2 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009390899" ; OUTPUT ; 
code_ucd = 9390907 ; nom_court = "DOCETAXEL PFIZER 10 MG/ML solution a diluer pour perfusion en flacon de 20 ml" ; cod_atc = "L01CD02" ; cod_ucd_chr = "0000009390907" ; OUTPUT ; 
code_ucd = 9390913 ; nom_court = "DOCETAXEL PFIZER 10 MG/ML solution a diluer pour perfusion en flacon de 8 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009390913" ; OUTPUT ; 
code_ucd = 9391025 ; nom_court = "PREZISTA 800 MG Comprime pellicule" ; cod_atc = "J05AE10" ; cod_ucd_chr = "0000009391025" ; OUTPUT ; 
code_ucd = 9391048 ; nom_court = "ENBREL 10 MG poudre et solvant pour solution injectable pour usage pediatrique" ; cod_atc = "L04AB01" ; cod_ucd_chr = "0000009391048" ; OUTPUT ; 
code_ucd = 9391077 ; nom_court = "ISENTRESS 100 MG comprime a croquer" ; cod_atc = "J05AX08" ; cod_ucd_chr = "0000009391077" ; OUTPUT ; 
code_ucd = 9391083 ; nom_court = "ISENTRESS 25 MG comprime a croquer" ; cod_atc = "J05AX08" ; cod_ucd_chr = "0000009391083" ; OUTPUT ; 
code_ucd = 9391108 ; nom_court = "LAMIVUDINE/ZIDOVUDINE SANDOZ 150 MG/300 MG Comprime pellicule secable" ; cod_atc = "J05AR01" ; cod_ucd_chr = "0000009391108" ; OUTPUT ; 
code_ucd = 9391249 ; nom_court = "ENZALUTAMIDE ASTELLAS 40 MG capsule molle" ; cod_atc = "L02B" ; cod_ucd_chr = "0000009391249" ; OUTPUT ; 
code_ucd = 9391344 ; nom_court = "ADCETRIS 50 MG poudre pour solution pour perfusion en flacon" ; cod_atc = "L01XC12" ; cod_ucd_chr = "0000009391344" ; OUTPUT ; 
code_ucd = 9391410 ; nom_court = "NEVIRAPINE MYLAN 200 MG comprime" ; cod_atc = "J05AG01" ; cod_ucd_chr = "0000009391410" ; OUTPUT ; 
code_ucd = 9392059 ; nom_court = "GEMCITABINE KABI 40 MG/ML solution a diluer pour perfusion en flacon de 25 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009392059" ; OUTPUT ; 
code_ucd = 9392065 ; nom_court = "GEMCITABINE KABI 40 MG/ML, solution a diluer pour perfusion en flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009392065" ; OUTPUT ; 
code_ucd = 9392071 ; nom_court = "GEMCITABINE KABI 40 MG/ML, solution a diluer pour perfusion en flacon de 50 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009392071" ; OUTPUT ; 
code_ucd = 9392326 ; nom_court = "HIZENTRA 200 MG/ML, Solution injectable sous cutanee en flacon de 50 ml" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009392326" ; OUTPUT ; 
code_ucd = 9392326 ; nom_court = "HIZENTRA 200 MG/ML, Solution injectable sous cutanee en flacon de 50 ml" ; cod_atc = "J06BA01" ; cod_ucd_chr = "0000009392326" ; OUTPUT ; 
code_ucd = 9393455 ; nom_court = "STRIBILD 150 MG, 150 MG, 200 MG, 245 MG comprime pellicule" ; cod_atc = "J05AR09" ; cod_ucd_chr = "0000009393455" ; OUTPUT ; 
code_ucd = 9393461 ; nom_court = "PREZISTA 100 MG/ML suspension buvable en flacon de 200 ml" ; cod_atc = "J05AE10" ; cod_ucd_chr = "0000009393461" ; OUTPUT ; 
code_ucd = 9393509 ; nom_court = "BOSULIF 100 MG 1 Boite de 28, comprime pellicule" ; cod_atc = "L01XE14" ; cod_ucd_chr = "0000009393509" ; OUTPUT ; 
code_ucd = 9393515 ; nom_court = "BOSULIF 500 MG comprime pellicule" ; cod_atc = "L01XE14" ; cod_ucd_chr = "0000009393515" ; OUTPUT ; 
code_ucd = 9393544 ; nom_court = "VIREAD 123 MG comprime pellicule" ; cod_atc = "J05AF07" ; cod_ucd_chr = "0000009393544" ; OUTPUT ; 
code_ucd = 9393550 ; nom_court = "VIREAD 163 MG comprime pellicule" ; cod_atc = "J05AF07" ; cod_ucd_chr = "0000009393550" ; OUTPUT ; 
code_ucd = 9393567 ; nom_court = "VIREAD 204 MG comprime pellicule" ; cod_atc = "J05AF07" ; cod_ucd_chr = "0000009393567" ; OUTPUT ; 
code_ucd = 9393573 ; nom_court = "VIREAD 33 MG/G granules" ; cod_atc = "J05AF07" ; cod_ucd_chr = "0000009393573" ; OUTPUT ; 
code_ucd = 9394905 ; nom_court = "CONFIDEX 1 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009394905" ; OUTPUT ; 
code_ucd = 9394905 ; nom_court = "CONFIDEX 1 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02BD01" ; cod_ucd_chr = "0000009394905" ; OUTPUT ; 
code_ucd = 9394940 ; nom_court = "FACTANE 200 UI/ML poudre et solvant pour solution injectable en flacon de 10 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009394940" ; OUTPUT ; 
code_ucd = 9394940 ; nom_court = "FACTANE 200 UI/ML poudre et solvant pour solution injectable en flacon de 10 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009394940" ; OUTPUT ; 
code_ucd = 9394957 ; nom_court = "FACTANE 200 UI/ML poudre et solvant pour solution injectable en flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009394957" ; OUTPUT ; 
code_ucd = 9394957 ; nom_court = "FACTANE 200 UI/ML poudre et solvant pour solution injectable en flacon de 5 ml" ; cod_atc = " " ; cod_ucd_chr = "0000009394957" ; OUTPUT ; 
code_ucd = 9394992 ; nom_court = "ZALTRAP 25 MG/ML solution a diluer pour perfusion en flacon de 4 ml" ; cod_atc = "L01XX44" ; cod_ucd_chr = "0000009394992" ; OUTPUT ; 
code_ucd = 9395000 ; nom_court = "ZALTRAP 25 MG/ML solution a diluer pour perfusion en flacon de 8 ml" ; cod_atc = "L01XX44" ; cod_ucd_chr = "0000009395000" ; OUTPUT ; 
code_ucd = 9395106 ; nom_court = "PERJETA 420 MG solution a diluer pour perfusion" ; cod_atc = "L01XC13" ; cod_ucd_chr = "0000009395106" ; OUTPUT ; 
code_ucd = 9395112 ; nom_court = "PRIVIGEN 100 MG/ML solution pour perfusion en flacon de 400 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009395112" ; OUTPUT ; 
code_ucd = 9395112 ; nom_court = "PRIVIGEN 100 MG/ML solution pour perfusion en flacon de 400 ml" ; cod_atc = "J06BA02" ; cod_ucd_chr = "0000009395112" ; OUTPUT ; 
code_ucd = 9395388 ; nom_court = "PEGASYS 90 MICROGRAMMES solution injectable en seringue preremplie de 0,5 ml" ; cod_atc = "L03AB11" ; cod_ucd_chr = "0000009395388" ; OUTPUT ; 
code_ucd = 9395603 ; nom_court = "STIVARGA 40 MG comprime pellicule" ; cod_atc = "L01XE21" ; cod_ucd_chr = "0000009395603" ; OUTPUT ; 
code_ucd = 9395626 ; nom_court = "TAFINLAR 50 MG gelules" ; cod_atc = "L01XE23" ; cod_ucd_chr = "0000009395626" ; OUTPUT ; 
code_ucd = 9395632 ; nom_court = "TAFINLAR 75 MG gelules" ; cod_atc = "L01XE23" ; cod_ucd_chr = "0000009395632" ; OUTPUT ; 
code_ucd = 9395678 ; nom_court = "VONCENTO 1 000 UI/2 400 UI poudre et solvant pour solution injectable" ; cod_atc = " " ; cod_ucd_chr = "0000009395678" ; OUTPUT ; 
code_ucd = 9395684 ; nom_court = "VONCENTO 250 UI/600 UI poudre et solvant pour solution injectable" ; cod_atc = " " ; cod_ucd_chr = "0000009395684" ; OUTPUT ; 
code_ucd = 9395690 ; nom_court = "VONCENTO 500 UI/1 200 UI poudre et solvant pour solution injectable" ; cod_atc = " " ; cod_ucd_chr = "0000009395690" ; OUTPUT ; 
code_ucd = 9395750 ; nom_court = "ICLUSIG 15 MG comprime" ; cod_atc = "L01XE24" ; cod_ucd_chr = "0000009395750" ; OUTPUT ; 
code_ucd = 9395767 ; nom_court = "ICLUSIG 45 MG comprime" ; cod_atc = "V03AX" ; cod_ucd_chr = "0000009395767" ; OUTPUT ; 
code_ucd = 9395796 ; nom_court = "IMNOVID 1 MG gelule" ; cod_atc = "L04AX06" ; cod_ucd_chr = "0000009395796" ; OUTPUT ; 
code_ucd = 9395804 ; nom_court = "IMNOVID 2 MG gelule" ; cod_atc = "L04AX06" ; cod_ucd_chr = "0000009395804" ; OUTPUT ; 
code_ucd = 9395810 ; nom_court = "IMNOVID 3 MG gelule" ; cod_atc = "L04AX06" ; cod_ucd_chr = "0000009395810" ; OUTPUT ; 
code_ucd = 9395827 ; nom_court = "IMNOVID 4 MG gelule" ; cod_atc = "L04AX06" ; cod_ucd_chr = "0000009395827" ; OUTPUT ; 
code_ucd = 9396011 ; nom_court = "VIMZIM 1 MG/ML solution a diluer pour perfusion" ; cod_atc = "A16A" ; cod_ucd_chr = "0000009396011" ; OUTPUT ; 
code_ucd = 9396235 ; nom_court = "CYSTADROPS 0,55 % collyre en solution" ; cod_atc = "S01XA" ; cod_ucd_chr = "0000009396235" ; OUTPUT ; 
code_ucd = 9396442 ; nom_court = "EFAVIRENZ MYLAN 600 MG comprime pellicule" ; cod_atc = "J05AG03" ; cod_ucd_chr = "0000009396442" ; OUTPUT ; 
code_ucd = 9396465 ; nom_court = "SOFOSBUVIR 400 MG comprime pellicule" ; cod_atc = "J05AX" ; cod_ucd_chr = "0000009396465" ; OUTPUT ; 
code_ucd = 9396494 ; nom_court = "ERIVEDGE 150 MG gelules" ; cod_atc = " " ; cod_ucd_chr = "0000009396494" ; OUTPUT ; 
code_ucd = 9397080 ; nom_court = "NEVIRAPINE SANDOZ 200 MG comprime" ; cod_atc = "J05AG01" ; cod_ucd_chr = "0000009397080" ; OUTPUT ; 
code_ucd = 9397134 ; nom_court = "NOVOEIGHT 1 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397134" ; OUTPUT ; 
code_ucd = 9397134 ; nom_court = "NOVOEIGHT 1 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397134" ; OUTPUT ; 
code_ucd = 9397140 ; nom_court = "NOVOEIGHT 1 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397140" ; OUTPUT ; 
code_ucd = 9397140 ; nom_court = "NOVOEIGHT 1 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397140" ; OUTPUT ; 
code_ucd = 9397157 ; nom_court = "NOVOEIGHT 2 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397157" ; OUTPUT ; 
code_ucd = 9397157 ; nom_court = "NOVOEIGHT 2 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397157" ; OUTPUT ; 
code_ucd = 9397163 ; nom_court = "NOVOEIGHT 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397163" ; OUTPUT ; 
code_ucd = 9397163 ; nom_court = "NOVOEIGHT 250 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397163" ; OUTPUT ; 
code_ucd = 9397186 ; nom_court = "NOVOEIGHT 3 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397186" ; OUTPUT ; 
code_ucd = 9397186 ; nom_court = "NOVOEIGHT 3 000 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397186" ; OUTPUT ; 
code_ucd = 9397192 ; nom_court = "NOVOEIGHT 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397192" ; OUTPUT ; 
code_ucd = 9397192 ; nom_court = "NOVOEIGHT 500 UI poudre et solvant pour solution injectable" ; cod_atc = "B02" ; cod_ucd_chr = "0000009397192" ; OUTPUT ; 
code_ucd = 9397217 ; nom_court = "IKERVIS (CICLOSPORINE) 1 MG/ML collyre en emulsion en recipient unidose" ; cod_atc = "S01XA18" ; cod_ucd_chr = "0000009397217" ; OUTPUT ; 
code_ucd = 9397766 ; nom_court = "INTELENCE 25 MG comprime" ; cod_atc = "J05AG04" ; cod_ucd_chr = "0000009397766" ; OUTPUT ; 
code_ucd = 9397772 ; nom_court = "SIMEPREVIR 150 MG gelule" ; cod_atc = "J05AE14" ; cod_ucd_chr = "0000009397772" ; OUTPUT ; 
code_ucd = 9398211 ; nom_court = "SOVALDI 400 MG comprime pellicules, flacon de 28" ; cod_atc = "J05AX" ; cod_ucd_chr = "0000009398211" ; OUTPUT ; 
code_ucd = 9398412 ; nom_court = "CHOLBAM 250 MG gelule" ; cod_atc = "A05AA03" ; cod_ucd_chr = "0000009398412" ; OUTPUT ; 
code_ucd = 9398429 ; nom_court = "CHOLBAM 50 MG gelule" ; cod_atc = "A05AA03" ; cod_ucd_chr = "0000009398429" ; OUTPUT ; 
code_ucd = 9398748 ; nom_court = "SIMPONI 100 MG solution injectabe en seringue preremplie" ; cod_atc = "L04AB06" ; cod_ucd_chr = "0000009398748" ; OUTPUT ; 
code_ucd = 9398754 ; nom_court = "SIMPONI 100 MG solution injectable en stylo preremplie" ; cod_atc = "L04AB06" ; cod_ucd_chr = "0000009398754" ; OUTPUT ; 
code_ucd = 9398866 ; nom_court = "TIVICAY 50 MG comprimes pellicules" ; cod_atc = "J05AX12" ; cod_ucd_chr = "0000009398866" ; OUTPUT ; 
code_ucd = 9399216 ; nom_court = "RAXONE 150 MG comprime pellicule" ; cod_atc = "N06BX13" ; cod_ucd_chr = "0000009399216" ; OUTPUT ; 
code_ucd = 9399274 ; nom_court = "RIOCIGUAT 0,5 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009399274" ; OUTPUT ; 
code_ucd = 9399280 ; nom_court = "RIOCIGUAT 1 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009399280" ; OUTPUT ; 
code_ucd = 9399334 ; nom_court = "IBRUTINIB 140 MG gelules" ; cod_atc = "L01XE27" ; cod_ucd_chr = "0000009399334" ; OUTPUT ; 
code_ucd = 9399357 ; nom_court = "TECFIDERA 120 MG gelule gastroresistante" ; cod_atc = "N07XX09" ; cod_ucd_chr = "0000009399357" ; OUTPUT ; 
code_ucd = 9399363 ; nom_court = "TECFIDERA 240 MG, gelule gastroresistante" ; cod_atc = "N07XX09" ; cod_ucd_chr = "0000009399363" ; OUTPUT ; 
code_ucd = 9399647 ; nom_court = "RIOCIGUAT 1,5 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009399647" ; OUTPUT ; 
code_ucd = 9399653 ; nom_court = "RIOCIGUAT 2,5 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009399653" ; OUTPUT ; 
code_ucd = 9399676 ; nom_court = "RIOCIGUAT 2 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009399676" ; OUTPUT ; 
code_ucd = 9399742 ; nom_court = "DACLATASVIR 30 MG comprime pellicule" ; cod_atc = "J05" ; cod_ucd_chr = "0000009399742" ; OUTPUT ; 
code_ucd = 9399759 ; nom_court = "DACLATASVIR 60 MG comprime pellicule" ; cod_atc = "J05" ; cod_ucd_chr = "0000009399759" ; OUTPUT ; 
code_ucd = 9400037 ; nom_court = "HERCEPTIN 600 MG/5 ML solution injectable" ; cod_atc = "L01XC03" ; cod_ucd_chr = "0000009400037" ; OUTPUT ; 
code_ucd = 9400043 ; nom_court = "KADCYLA 100 MG poudre pour solution a diluer pour perfusion" ; cod_atc = "L01XC03" ; cod_ucd_chr = "0000009400043" ; OUTPUT ; 
code_ucd = 9400066 ; nom_court = "KADCYLA 160 MG poudre pour solution a diluer pour perfusion" ; cod_atc = "L01XC03" ; cod_ucd_chr = "0000009400066" ; OUTPUT ; 
code_ucd = 9400391 ; nom_court = "LIKOZAM 1 MG/ML suspension buvable" ; cod_atc = "N05BA09" ; cod_ucd_chr = "0000009400391" ; OUTPUT ; 
code_ucd = 9400540 ; nom_court = "ADEMPAS 0,5 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009400540" ; OUTPUT ; 
code_ucd = 9400557 ; nom_court = "ADEMPAS 1.5 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009400557" ; OUTPUT ; 
code_ucd = 9400563 ; nom_court = "ADEMPAS 1 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009400563" ; OUTPUT ; 
code_ucd = 9400586 ; nom_court = "ADEMPAS 2.5 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009400586" ; OUTPUT ; 
code_ucd = 9400592 ; nom_court = "ADEMPAS 2 MG comprimes pellicules" ; cod_atc = "C02KX05" ; cod_ucd_chr = "0000009400592" ; OUTPUT ; 
code_ucd = 9401108 ; nom_court = "OLYSIO 150 MG gelules" ; cod_atc = "J05AE14" ; cod_ucd_chr = "0000009401108" ; OUTPUT ; 
code_ucd = 9401344 ; nom_court = "OLAPARIB 50 MG gelules" ; cod_atc = "L01XX46" ; cod_ucd_chr = "0000009401344" ; OUTPUT ; 
code_ucd = 9402036 ; nom_court = "KETOCONAZOLE HRA PHARMA 200 MG comprime" ; cod_atc = "J02AB02" ; cod_ucd_chr = "0000009402036" ; OUTPUT ; 
code_ucd = 9402125 ; nom_court = "IDELALISIB 100 MG comprime pellicule" ; cod_atc = "L01X" ; cod_ucd_chr = "0000009402125" ; OUTPUT ; 
code_ucd = 9402131 ; nom_court = "IDELALISIB 150 MG comprime pellicule" ; cod_atc = "L01X" ; cod_ucd_chr = "0000009402131" ; OUTPUT ; 
code_ucd = 9402243 ; nom_court = "HEMANGIOL? 3,75 MG/ML solution buvable" ; cod_atc = "D11A" ; cod_ucd_chr = "0000009402243" ; OUTPUT ; 
code_ucd = 9402757 ; nom_court = "TRANSLARNA 1000 MG, Granules pour suspension buvable" ; cod_atc = "N07X" ; cod_ucd_chr = "0000009402757" ; OUTPUT ; 
code_ucd = 9402763 ; nom_court = "TRANSLARNA 125 MG Granules pour suspension buvable" ; cod_atc = "N07X" ; cod_ucd_chr = "0000009402763" ; OUTPUT ; 
code_ucd = 9402786 ; nom_court = "TRANSLARNA 250 MG Granules pour suspension buvable" ; cod_atc = "N07X" ; cod_ucd_chr = "0000009402786" ; OUTPUT ; 
code_ucd = 9402792 ; nom_court = "WAKIX 20 MG comprime pellicule quadrisecable" ; cod_atc = "N06BX" ; cod_ucd_chr = "0000009402792" ; OUTPUT ; 
code_ucd = 9402823 ; nom_court = "CREON 5000 U granules gastroresistants" ; cod_atc = "A09AA02" ; cod_ucd_chr = "0000009402823" ; OUTPUT ; 
code_ucd = 9402846 ; nom_court = "DAKLINZA 30 MG comprimes pellicules" ; cod_atc = "J05" ; cod_ucd_chr = "0000009402846" ; OUTPUT ; 
code_ucd = 9402852 ; nom_court = "DAKLINZA 60 MG comprimes pellicules" ; cod_atc = "J05" ; cod_ucd_chr = "0000009402852" ; OUTPUT ; 
code_ucd = 9403082 ; nom_court = "REFERO 550 MG Comprime pellicule" ; cod_atc = "A07AA11" ; cod_ucd_chr = "0000009403082" ; OUTPUT ; 
code_ucd = 9403478 ; nom_court = "ZYDELIG 100 MG comprimes pellicules" ; cod_atc = "L01X" ; cod_ucd_chr = "0000009403478" ; OUTPUT ; 
code_ucd = 9403484 ; nom_court = "ZYDELIG 150 MG comprimes pellicules" ; cod_atc = "L01X" ; cod_ucd_chr = "0000009403484" ; OUTPUT ; 
code_ucd = 9403490 ; nom_court = "IMBRUVICA 140 MG gelule" ; cod_atc = " " ; cod_ucd_chr = "0000009403490" ; OUTPUT ; 
code_ucd = 9403946 ; nom_court = "CERITINIB 150 MG gelule" ; cod_atc = "L01XE28" ; cod_ucd_chr = "0000009403946" ; OUTPUT ; 
code_ucd = 9404615 ; nom_court = "GRANUPAS 4 G granules gastro-resistants" ; cod_atc = " " ; cod_ucd_chr = "0000009404615" ; OUTPUT ; 
RUN ;


PROC SQL ;
	CREATE VIEW v_ref_pha_tmp AS
	SELECT  IR_PHA_R.pha_atc_c07,
            IR_PHA_R.pha_nom_pa,
            IR_PHA_R.pha_med_nom,
            IR_PHA_R.pha_prs_ide,
            (INPUT(IR_PHA_R.pha_unt_nbr_dses,3.0)) AS nb_unite,

            
            REF_UCD.cod_ucd_chr,
            REF_UCD.code_ucd,
            REF_UCD.nom_court,
            REF_UCD.cod_atc,

            REF_3MO.min,

            COALESCE(IR_PHA_R.pha_atc_c07, REF_UCD.cod_atc) AS atc5,
            COALESCE(IR_PHA_R.pha_med_nom, REF_UCD.nom_court) AS pha_nom,

            CASE
                WHEN (INPUT(IR_PHA_R.pha_unt_nbr_dses,3.0)) >= REF_3MO.min AND REF_3MO.min IS NOT NULL
                THEN 3 ELSE 1
            END AS nbr_moi,

            REF_ASO.principe_actif,
            REF_ASO.atc_cor,

            case
               when CALCULATEd atc5='N04BA02' and REF_ASO.ATC_cor='N04BA03' and substr(CALCULATED pha_nom,1,5)EQ'MODOP' then 'N04BA02'
               when CALCULATEd atc5='N04BA02' and REF_ASO.ATC_cor='N04BA03' and substr(CALCULATED pha_nom,1,5)EQ'LEVOD' then 'N04BA02'
               when CALCULATEd atc5='B01AC30' and REF_ASO.ATC_cor='B01AC04' and substr(CALCULATED pha_nom,1,5)EQ'ASASA' then 'B01AC07'
               when CALCULATEd atc5='C03EA01' and REF_ASO.ATC_cor='C03DB01' and substr(CALCULATED pha_nom,1,5)EQ'PREST' then 'C03DB02'
               when CALCULATEd atc5='R03AK07' and REF_ASO.ATC_cor='R03BA02' and substr(CALCULATED pha_nom,1,5)EQ'FORMO' then 'R03BA01'
               when CALCULATEd atc5='R03AK07' and REF_ASO.ATC_cor='R03BA02' and substr(CALCULATED pha_nom,1,5)EQ'INNOV' then 'R03BA01'
               when CALCULATEd atc5='N02AA59' and REF_ASO.ATC_cor='N02BE01' and substr(CALCULATED pha_nom,1,5)EQ'ANTAR' then 'M01AE01'
	       when CALCULATEd atc5='N02BE71' and REF_ASO.ATC_cor='N06BC01' and substr(CALCULATED pha_nom,1,5)EQ'IZALG' then 'N02AA02'
	       when CALCULATEd atc5='N02BE71' and REF_ASO.ATC_cor='9999999' and substr(CALCULATED pha_nom,1,5)EQ'LAMAL' then 'N02AA02'
               else REF_ASO.ATC_cor
           end as ATC_cor_2,

           COALESCE(CALCULATED atc_cor_2, CALCULATED atc5) AS atc

        FROM        spdref.ir_pha_r     IR_PHA_R
        FULL JOIN   ref_ucd     		REF_UCD
            ON  IR_PHA_R.pha_cip_ucd = REF_UCD.code_ucd

        LEFT JOIN   ref_3mo     		ref_3mo
            ON  IR_PHA_R.pha_nom_pa = REF_3MO.pa

        LEFT JOIN   ref_aso 		REF_ASO
            ON  COALESCE(IR_PHA_R.pha_atc_c07, REF_UCD.cod_atc) = REF_ASO.atc_ini

    HAVING atc IS NOT NULL
	;
    DROP TABLE spduser.&prefix.ref_pha ;
    CREATE TABLE spduser.&prefix.ref_pha AS
    SELECT pha_prs_ide, cod_ucd_chr, nbr_moi, atc
    FROM v_ref_pha_tmp
    WHERE (pha_prs_ide NOT BETWEEN 0 AND 1999999)
        AND (pha_prs_ide NOT BETWEEN 8500000 AND 8999999)
        AND pha_prs_ide NOT IN (9999940, 9999910, 9999979, 9999927, 9999999)
        AND atc_cor_2 NE '9999999' ;
QUIT ;

PROC DATASETS NODETAILS NOLIST ;
    DELETE ref_aso ref_ucd ref_3mo ;
RUN ;


%MACRO polymed_egb(nir=, annee=, tab_atc = 0, lib_des = work) ;

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

les deux requêtes sont combinées en une par l'expression GROUPING SETS
top_inc est = 1 pour la requête concernant les critères d'inclusion
*/

PROC SQL INOBS = MAX _method ;
    DROP TABLE spduser.&prefix.ext_polymed_&annee ;

    CREATE TABLE spduser.&prefix.ext_polymed_&annee AS
    SELECT  ANO.ben_nir_idt, 
            REF_PHA.atc,

            ES_PRS_F.exe_soi_dtd,

	    %trimestre(&annee) AS trm, /* le trimestre d'éxécution de la prestation */

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

           COUNT(DISTINCT %trimestre(&annee)) AS n_trm /* combien de trimestres où il y a des prestations, utilisé pour l'inclusion */

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
