/*--- Executer cette partie pour supprimer les tables et séquence.
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
/*-------------------------------------------------------------*/

CREATE TABLE serie (
 ser_code    NUMERIC(10) PRIMARY KEY NOT NULL,
 ser_nom     VARCHAR2(30 CHAR) NOT NULL,
 ser_date    DATE,
 ser_nbTotal NUMERIC(10) NOT NULL
);

CREATE TABLE langue (
 lang_id  NUMERIC(10) PRIMARY KEY NOT NULL,
 lang_nom VARCHAR2(30 char) NOT NULL
);

CREATE SEQUENCE langue_lang_id_seq;

CREATE OR REPLACE TRIGGER trig_langue
 BEFORE INSERT ON langue
 FOR EACH ROW
 DECLARE
   numlang NUMERIC := langue_lang_id_seq.nextval;
 BEGIN
   :new.lang_id := numlang;
 END ;

CREATE TABLE langue_serie (
  lang_id  NUMERIC(10) NOT NULL ,
  ser_code NUMERIC(10) NOT NULL ,

  CONSTRAINT langue_serie_lang_id_fk
    FOREIGN KEY (lang_id)
    REFERENCES langue (lang_id),

  CONSTRAINT langue_serie_ser_code_fk
    FOREIGN KEY (ser_code)
    REFERENCES serie (ser_code),

  CONSTRAINT langue_serie_pk PRIMARY KEY (lang_id, ser_code)
);



CREATE  TABLE carte_virtuelle
(

  carte_id            NUMERIC(10) PRIMARY KEY NOT NULL,
  carte_artiste       VARCHAR2(30 CHAR ),
  carte_cout          VARCHAR2(30 CHAR ) NOT NULL,
  carte_type          VARCHAR2(30 CHAR ) NOT NULL,
  carte_ordre_serie   NUMERIC(10) NOT NULL,
  carte_endurance     NUMERIC(10) NOT NULL,
  carte_force         NUMERIC(10) NOT NULL,
  carte_couleur       CHAR(1) NOT NULL,
  carte_rarete        NUMERIC(10) NOT NULL,
  ser_code          NUMERIC(10)  NOT NULL,




  CONSTRAINT carte_virtuelle_pk
      FOREIGN KEY (ser_code)
      REFERENCES serie(ser_code),

  CONSTRAINT check_carte_type       CHECK (carte_type IN ('terrain','créature', 'enchantement','rituel', 'éphémère','artefact')),
  CONSTRAINT check_carte_endurance  CHECK (carte_endurance >0 AND carte_type ='créature'),
  CONSTRAINT check_carte_force      CHECK (carte_force >=0 AND carte_type = 'créature'),
  CONSTRAINT check_carte_couleur    CHECK (carte_couleur IN ('w','b','n','r','v','m','i')),
  CONSTRAINT check_carte_rarete     CHECK (carte_rarete BETWEEN 0 AND 4)

);

CREATE SEQUENCE carte_id_seq;

CREATE OR REPLACE TRIGGER trig_carte_id
BEFORE INSERT ON carte_virtuelle
FOR EACH ROW
DECLARE
  idcarte INTEGER := carte_id_seq.nextval;
BEGIN
  :new.carte_id := idcarte;
END;


CREATE TABLE  carte_langue (
 carte_nom VARCHAR2(30 CHAR) NOT NULL ,
 carte_texte VARCHAR2(100 CHAR) NOT NULL ,
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


create table collection(
 col_id NUMERIC(10) PRIMARY KEY NOT NULL ,
 col_nom VARCHAR2(30 char) NOT NULL
);

create sequence collection_col_id_seq;

CREATE OR REPLACE TRIGGER col_langue
 BEFORE insert on collection
 FOR EACH row
 DECLARE
   numcol numeric := collection_col_id_seq.nextval;
 BEGIN
   :new.col_id := numcol;
 END ;


CREATE TABLE possession
(
  pos_quantite NUMERIC(10),
  carte_id     NUMERIC(10) NOT NULL,
  lang_id      NUMERIC(10) NOT NULL,
  col_id       NUMERIC(10) NOT NULL,


 CONSTRAINT possession_fk_carte
   FOREIGN KEY (carte_id)
   REFERENCES carte_langue(carte_id), /**/

 CONSTRAINT possession_fk_lang
   FOREIGN KEY (lang_id)
   REFERENCES carte_langue(carte_id), /**/

CONSTRAINT possession_fk_col
   FOREIGN KEY (col_id)
   REFERENCES collection(col_id),

CONSTRAINT possession_pk PRIMARY KEY (carte_id, lang_id, col_id) /*MARCHE PAS CAR carte_id ET lang_id SONT PAS CLE PRIMAIRE DANS CARTE LANGUE*/

);

/
