DROP TABLE candidatures;
DROP TABLE formation;
DROP TABLE etablissement;
DROP TABLE departement;
DROP TABLE import;
/*\! curl "https://data.enseignementsup-recherche.gouv.fr/api/explore/v2.1/catalog/datasets/fr-esr-parcoursup/exports/csv?lang=fr&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B"*/

\echo "On importe ensuite les données dans  une table import"

CREATE TABLE import (n1 int,n2 text,n3 char(8), n4 text,n5 char(3),n6 text,n7 text,n8 text,n9 text, n10 text,n11 text, n12 text,n13 text,n14 text, n15 text,n16 text,n17 text,n18 int,n19
int,n20 int,n21 int,n22 int,n23 int,n24 int,n25 int,n26 int,n27 int,n28 int,n29 int,n30 int,n31 int,n32 int,n33 int,n34 int,n35 int,n36 int,n37 int,n38 int,
n39 int,n40 int,n41 int,n42 int,n43 int,n44 int,n45 int,n46 int,n47 int,n48 int,n49 int,n50 int,n51 float,n52 float,n53 float,n54 float,n55 int,n56 int,n57 int,n58 int,
n59 int,n60 int,n61 int,n62 int,n63 int,n64 int,n65 int,n66 float,n67 int,n68 int,n69 int,n70 int,n71 int,n72 int,n73 int,n74 float,n75 float,n76 float,n77 float,n78 float,n79 float,n80 float,n81 float,n82 float,n83 float,n84 float,
n85 float,n86 float,n87 float,n88 float,n89 float,n90 float,n91 float,n92 float,n93 float,n94 float,n95 float,n96 float,n97 float,n98 float,n99 float,n100 float,n101 float,n102 text,n103 float,n104
text,n105 float,n106 text,n107 float,n108 text,n109 text,n110 char(5),n111 text,n112 text,n113 float,n114 float,n115 float,n116 float,n117 char(5),n118 char(5));

\copy import from 'fr-esr-parcoursup.csv' with(format CSV, delimiter ';' , HEADER)

\echo "Puis on crée les tables de ventilation"

\echo "Création de la table département"

CREATE TABLE departement(
    codeDepartemental varchar(3),
    departement text,
    region text,
    academie text,
    CONSTRAINT pk_commune PRIMARY KEY (codeDepartemental)
);

\echo "Création de la table établissement"

CREATE TABLE etablissement(
    codeUAI char(8),
    nomEtablissement varchar,
    codeDepartemental varchar(3),
    statut text,
    CONSTRAINT pk_etablissement PRIMARY KEY (codeUAI),
    CONSTRAINT fk_departement FOREIGN KEY (codeDepartemental) REFERENCES departement(codeDepartemental)
);

\echo "Création de la table formation"

CREATE TABLE formation(
    cod_aff_form char(5),
    codeUAI char(8),
    filiere_formation text,
    capacite int,
    selectivite text,
    CONSTRAINT pk_formation PRIMARY KEY (cod_aff_form),
    CONSTRAINT fk_etablissement FOREIGN KEY (codeUAI) REFERENCES etablissement(codeUAI)
    ON DELETE CASCADE ON UPDATE CASCADE
);

\echo "Création de la table candidatures"

CREATE TABLE candidatures(
    cod_aff_form char(5),
    candNo SERIAL,
    effectif_Total int,
    effectif_dont_fille int,
    effectif_phase_principale int,
    eff_neo_bac_gen_principale int,
    eff_neo_bac_boursiers_gen_principale int,
    eff_neo_bac_tech_principale int,
    eff_tot_phase_secondaire int,
    eff_tot_recu_propo_admission int,
    eff_tot_accepte_propo int,
    eff_dont_candidates_admises int,
    admis_phase_principale int,
    admis_phase_secondaire int,
    admis_ouverture_proc_principale int,
    admis_avt_fin_proc_principale int,
    admis_neo_bacheliers int,
    admis_neo_bac_boursiers int,
    CONSTRAINT pk_candidatures PRIMARY KEY (candNo),
    CONSTRAINT fk_formation FOREIGN KEY (cod_aff_form) REFERENCES formation(cod_aff_form) ON DELETE CASCADE ON UPDATE CASCADE
);

\echo "Et on ajoute les données de la table import dans nos nouvelles tables"

INSERT INTO departement( codeDepartemental, departement, region,academie) SELECT DISTINCT n5, n6, n7 , n8  FROM import;
INSERT INTO etablissement SELECT DISTINCT n3,n4,n5,n2 FROM import;
INSERT INTO formation SELECT n110, n3, n10, n18 , n11 FROM import AS i, etablissement AS e WHERE i.n3 = e.codeUAI;
INSERT INTO candidatures(cod_aff_form,effectif_Total ,
	effectif_dont_fille ,
	effectif_phase_principale ,
	eff_neo_bac_gen_principale,
	eff_neo_bac_boursiers_gen_principale,
	eff_neo_bac_tech_principale,
	eff_tot_phase_secondaire,
	eff_tot_recu_propo_admission,
	eff_tot_accepte_propo,
	eff_dont_candidates_admises,
	admis_phase_principale,
	admis_phase_secondaire,
	admis_ouverture_proc_principale,
	admis_avt_fin_proc_principale,
	admis_neo_bacheliers,
	admis_neo_bac_boursiers)SELECT n110,n19,n20,n21,n23,n24,n25,n30,n46,n47,n48,n49,n50,n51,n53,n56,n55 FROM import AS i, formation AS f WHERE i.n110 = f.cod_aff_form

