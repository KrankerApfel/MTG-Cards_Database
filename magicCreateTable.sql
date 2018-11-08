DROP TABLE possession;
DROP TABLE carte_langue;
DROP TABLE carte_virtuelle;
DROP TABLE langue;
DROP TABLE collection;

DROP SEQUENCE langue_lang_id_seq;
DROP SEQUENCE carte_id_seq;
DROP SEQUENCE collection_col_id_seq;


CREATE  TABLE carte_virtuelle
(

  carte_id            numeric(10) primary key NOT NULL,
  carte_artiste       VARCHAR2(30 char ),
  carte_cout          VARCHAR2(30 char ) NOT NULL,
  carte_type          VARCHAR2(30 char ) NOT NULL,
  carte_ordre_serie   numeric(10) NOT NULL,
  carte_endurance     numeric(10) NOT NULL,
  carte_force         numeric(10) NOT NULL,
  carte_couleur       CHAR(1) NOT NULL,
  carte_rarete        numeric(10) NOT NULL,
  /*ser_code            INTEGER(100) NOT NULL*/


  /*,

CONSTRAINT carte_virtuelle_pk
    FOREIGN KEY (ser_code)
    REFERENCES serie(ser_code)*/

  CONSTRAINT check_carte_type       CHECK (carte_type IN ('terrain','créature', 'enchantement','rituel', 'éphémère','artefact')),
  CONSTRAINT check_carte_endurance  CHECK (carte_endurance >0 and carte_type ='créature'),
  CONSTRAINT check_carte_force      CHECK (carte_force >=0 and carte_type = 'créature'),
  CONSTRAINT check_carte_couleur    CHECK (carte_couleur IN ('w','b','n','r','v','m','i')),
  CONSTRAINT check_carte_rarete     CHECK (carte_rarete BETWEEN 0 and 4)

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

create table langue (
 lang_id  numeric(10) primary key NOT NULL,
 lang_nom varchar2(30 char) not null
);

create sequence langue_lang_id_seq;

CREATE OR REPLACE TRIGGER trig_langue
 BEFORE insert on langue
 FOR EACH row
 DECLARE
   numlang numeric := langue_lang_id_seq.nextval;
 BEGIN
   :new.lang_id := numlang;
 END ;

CREATE TABLE  carte_langue (
 carte_nom VARCHAR2(30 char) NOT NULL ,
 carte_texte VARCHAR2(100 char) NOT NULL ,
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
 col_id NUMERIC(10) primary key NOT NULL ,
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
   REFERENCES carte_langue(carte_id), /*cf bug1*/

 CONSTRAINT possession_fk_lang
   FOREIGN KEY (lang_id)
   REFERENCES carte_langue(carte_id), /*cf bug1*/

CONSTRAINT possession_fk_col
   FOREIGN KEY (col_id)
   REFERENCES collection(col_id),

CONSTRAINT possession_pk PRIMARY KEY (carte_id, lang_id, col_id) /* bug1 : MARCHE PAS CAR carte_id ET lang_id SONT PAS CLE PRIMAIRE DANS CARTE LANGUE*/

);

/
