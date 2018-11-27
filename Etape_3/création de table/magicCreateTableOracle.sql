/*--- Executer cette partie pour supprimer les tables et séquences.
PURGE est l'équivalent de CASCADE en MySQL, i.e. supprime aussi
 les références dans les autres tables. --*/
DROP TABLE possession PURGE;
DROP TABLE carte_langue PURGE;
DROP TABLE carte_virtuelle PURGE;
DROP TABLE langue PURGE;
DROP TABLE collection PURGE;
DROP TABLE langue_serie PURGE;
DROP TABLE serie PURGE;

DROP SEQUENCE langue_lang_id_seq;
DROP SEQUENCE carte_id_seq;
DROP SEQUENCE collection_col_id_seq;

/*Création de la table SERIE*/
CREATE TABLE serie (
 ser_code    VARCHAR2(3 CHAR) PRIMARY KEY NOT NULL,
 ser_nom     VARCHAR2(30 CHAR) NOT NULL,
 ser_date    DATE,
 ser_nbTotal NUMERIC(10) NOT NULL
);

/*Création de la table LANGUE*/
CREATE TABLE langue (
 lang_id  NUMERIC(10) PRIMARY KEY NOT NULL,
 lang_nom VARCHAR2(30 char) NOT NULL
);

CREATE SEQUENCE langue_lang_id_seq START WITH 1 INCREMENT BY 1;

--Trigger pour l'incrémentation auto lang_id
CREATE OR REPLACE TRIGGER trig_langue
 BEFORE INSERT ON langue
 FOR EACH ROW
 DECLARE
   numlang NUMERIC := langue_lang_id_seq.nextval;
 BEGIN
   :new.lang_id := numlang;
 END ;

/*Création de la table LANGUE_SERIE*/
CREATE TABLE langue_serie (
  lang_id  NUMERIC(10) NOT NULL ,
  ser_code VARCHAR2(3 CHAR) NOT NULL ,

  CONSTRAINT langue_serie_lang_id_fk
    FOREIGN KEY (lang_id)
    REFERENCES langue (lang_id),

  CONSTRAINT langue_serie_ser_code_fk
    FOREIGN KEY (ser_code)
    REFERENCES serie (ser_code),

  CONSTRAINT langue_serie_pk PRIMARY KEY (lang_id, ser_code)
);


/*Création de la table CARTE_VIRTUELLE*/
create table CARTE_VIRTUELLE
(
  CARTE_ID          NUMBER(10)        not null
    primary key,
  CARTE_ARTISTE     VARCHAR2(30 char),
  CARTE_COUT        VARCHAR2(30 char),
  CARTE_TYPE        VARCHAR2(30 char) not null
    constraint CHECK_CARTE_TYPE
    check (carte_type IN
           ('terrain', 'créature', 'enchantement', 'rituel', 'éphémère', 'artefact', 'sort', 'arpenteur', 'tribal', 'permanent')),
  CARTE_ORDRE_SERIE NUMBER(10)        not null,
  CARTE_ENDURANCE   NUMBER(10),
  CARTE_FORCE       NUMBER(10),
  CARTE_COULEUR     CHAR              not null
    constraint CHECK_CARTE_COULEUR
    check (carte_couleur IN ('W', 'B', 'N', 'R', 'V', 'M', 'I','T')),
  CARTE_RARETE      NUMBER(10)        not null
    constraint CHECK_CARTE_RARETE
    check (carte_rarete BETWEEN 0 AND 4),
  SER_CODE          VARCHAR2(3 char)  not null
    constraint CARTE_VIRTUELLE_PK
    references SERIE (SER_CODE),
  constraint CHECK_CARTE_ENDURANCE
  check ((carte_type !='créature' AND CARTE_ENDURANCE is NULL) OR (CARTE_TYPE ='créature' AND carte_endurance >= -1)),
  constraint CHECK_CARTE_FORCE
  check ((carte_type !='créature' AND CARTE_FORCE is NULL) OR (CARTE_TYPE ='créature' AND CARTE_FORCE >= -1))
);


CREATE SEQUENCE carte_id_seq START WITH 1 INCREMENT BY 1;

/*Trigger pour l'incrémentation auto de carte_id*/
CREATE OR REPLACE TRIGGER trig_carte_id
BEFORE INSERT ON carte_virtuelle
FOR EACH ROW
DECLARE
  idcarte INTEGER := carte_id_seq.nextval;
BEGIN
  :new.carte_id := idcarte;
END;


/*Création de la table CARTE_LANGUE*/
CREATE TABLE  carte_langue (
 carte_nom VARCHAR2(30 CHAR) NOT NULL ,
 carte_texte VARCHAR2(500 CHAR) NOT NULL ,
 carte_id NUMERIC(10) NOT NULL ,
 lang_id NUMERIC(10) NOT NULL,

 CONSTRAINT carte_langue_fk_carte
   FOREIGN KEY (carte_id)
   REFERENCES carte_virtuelle(carte_id),

 CONSTRAINT carte_langue_fk_lang
   FOREIGN KEY (lang_id)
   REFERENCES langue(lang_id),

 CONSTRAINT carte_langue_pk PRIMARY KEY (carte_id, lang_id)

);

/*Création de la table COLLECTION*/
create table collection(
 col_id NUMERIC(10) PRIMARY KEY NOT NULL ,
 col_nom VARCHAR2(30 char) NOT NULL
);


create sequence collection_col_id_seq;

/*Trigger pour l'incrémentation auto de col_id*/
CREATE OR REPLACE TRIGGER col_langue
 BEFORE insert on collection
 FOR EACH row
 DECLARE
   numcol numeric := collection_col_id_seq.nextval;
 BEGIN
   :new.col_id := numcol;
 END ;


/*Création de la table POSSESSION*/
CREATE TABLE possession
(
  pos_quantite NUMERIC(10),
  carte_id     NUMERIC(10) NOT NULL,
  lang_id      NUMERIC(10) NOT NULL,
  col_id       NUMERIC(10) NOT NULL,


 CONSTRAINT possession_fk_carte_langue
   FOREIGN KEY (carte_id,lang_id)
   REFERENCES carte_langue(carte_id,lang_id), /* bien préciser que la clé est composite ! */

CONSTRAINT possession_fk_col
   FOREIGN KEY (col_id)
   REFERENCES collection(col_id),

CONSTRAINT possession_pk PRIMARY KEY (carte_id, lang_id, col_id)

);

/
