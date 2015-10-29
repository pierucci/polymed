# Indicateurs de polymédication

Calcule les indicateurs continus et cumulatifs de polymédication en prenant en compte les associations (et les conditionnement trimestriels pour l'indicateur continu).

## Arguments

`nir` = une table d'identifiants uniques des individus d'intérêt sur SPD (pour l'EGB) ou Oracle (pour DCIR), doit contenir la colonne `BEN_NIR_IDT` (pour l'EGB) ou les colonnes `BEN_NIR_PSA` et `BEN_RNG_GEM` (pour DCIR).

`annee` = l'année où les indicateurs sont calculés, 4 chiffres.

`tab_atc` = retouner les classes ATC contribuant aux indicateurs ? (`0` = non, `1` = oui, `0` par défaut).

`lib_des` = librairie SAS de destination, `WORK` par défaut.

## Détails

Nécessite un profil avec la date de soins précise (`EXE_SOI_DTD` visible).

Les indicateurs sont calculés pour les individus ayant des prestations affinées de pharmacie (officine ou rétrocession) pour chaque trimestre de l'année étudiée.

L'indicateur continu correspond au nombre de molécules différentes remboursées au moins 3 fois dans l'année.

L'indicateur cumulatif correspond à la moyenne annuelle du nombre de molécules différentes remboursées par trimestre.

La prise en compte des associations de molécules concerne uniquement les traitements à action systémique.

Le détail des médicaments exclus du calcul des indicateurs est disponible dans le Rapport Irdes X.


## Attention

La table des identifiants doit contenir une seule ligne par `BEN_NIR_IDT` (pour l'EGB) ou par couple `BEN_NIR_PSA`/`BEN_RNG_GEM` (pour DCIR) sinon les jointures produisent des produits cartésiens, ce qui augmente les temps de requête et produit des résultats erronés.

La macro ne vérifie pas cette que condition est respectée, c'est à l'utilisateur d'y veiller.

## Valeur

Retourne 2 tables dans `lib_des` : `indicateur_continu` et `indicateur_cumulatif` contenant la valeur des indicateurs par individus.

De plus si `tab_atc` est égal à 1 retourne dans deux table la liste des classes ATC ayant contribué aux indicateurs (une ligne par classe ATC par individu).

Les individus sans prestations de pharmacie (officine ou rétrocession) retrouvées dans DCIR sur l'année ne sont pas présents dans les tables.

Les individus non inclus (car non consommants sur au moins un des 4 trimestres) ont une valeur `NULL` de l'indicateur.

Dans les tables retournant les classes ATC, les codes ATC se terminant par `-X` correspondent à des molécules n'ayant pas de code ATC propre.

## Auteurs

Chloé Le Cossec (chloe.lecossec@gmail.com) et Antoine Filipovic-Pierucci (pierucci@gmail.com).

## Mainteneurs

Elodie Moutengou (e.moutengou@invs.sante.fr) et Francis Chin (f.chin@invs.sante.fr).

Envoyez vos critiques, remarques et pistes d'amélioration à : ind-polymed-sniiram@googlegroups.com

## Références
Rapport Irdes X. QES X.

## Exemples

```SAS
/* calcule les indicateurs de polymédication pour 2013 pour une centaine d'individus */

/* EBG */

PROC SQL ;
  DROP TABLE spduser.list_nir ;
  CREATE TABLE spduser.list_nir AS
  SELECT DISTINCT ben_nir_idt
  FROM consoegb.conso201304(OBS = 100)
  ;
QUIT ;

%polymed_egb(annee = 2013, nir = list_nir) ;

/* DCIR */

PROC SQL ;
  DROP TABLE orauser.list_nir ;
  CREATE TABLE orauser.list_nir AS
  SELECT DISTINCT ben_nir_psa, ben_rng_gem
  FROM consopat.extraction_patients2013tr(OBS = 100)
  ;
QUIT ;

%polymed_dcir(annee = 2013, nir = list_nir) ;
```
