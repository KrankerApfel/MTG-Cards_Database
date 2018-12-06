-- Vues

-- 1. Vue qui regroupe toutes les données d'une carte physique(carte_virtuelle + carte_langue)
Create View carteTotale(carte_id, carte_nom, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_texte, carte_artiste, carte_rarete, carte_ordre_serie, ser_code, lang_id) as SELECT carte_id, carte_nom, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_texte, carte_artiste, carte_rarete, carte_ordre_serie, ser_code, lang_id from carte_virtuelle NATURAL JOIN carte_langue;

--2. Vue qui regroupe les cartes anglaises possédées
Create View cartesAnglaises(col_id, carte_id, pos_quantite) as SELECT col_id, carte_id, pos_quantite FROM possession WHERE lang_id = 1;

--3. Vue qui regroupe le nombre d'utilisateur possédant une carte
Create View nombrePossesseur(carte_nom, nbPossesseurs) AS
Select carte_nom, count(possession.carte_id) from carteTotale LEFT OUTER JOIN possession ON carteTotale.carte_id = possession.carte_id Group by carte_nom ORDER BY carte_nom;

-- Fonctions et procédures PL/*SQL
--- 1. La procédure CREER_CARTE permet d'insérer les données d'une nouvelle carte à la fois dans CARTE_VIRTUELLE et CARTE_LANGUE.
---    Cela permet d'accélérer et de simplifier l'insertion d'information d'une carte.  Notons que CARTE_ID n'est pas renseigné car autoincrémenté !

CREATE OR REPLACE PROCEDURE creer_carte (nom IN VARCHAR2,texte IN VARCHAR2,langID IN NUMERIC,artiste IN VARCHAR2,cout IN VARCHAR2,ctype IN VARCHAR2,ordreSerie IN NUMERIC,endurance IN NUMERIC,cforce IN NUMERIC,couleur IN VARCHAR2,rarete IN NUMERIC,sercode IN VARCHAR2) IS
  carteID NUMERIC;
  BEGIN

    INSERT INTO CARTE_VIRTUELLE (CARTE_ARTISTE, CARTE_COUT, CARTE_TYPE, CARTE_ORDRE_SERIE, CARTE_ENDURANCE, CARTE_FORCE, CARTE_COULEUR, CARTE_RARETE, SER_CODE)
    VALUES (artiste,cout,ctype,ordreSerie,endurance,cforce,couleur,rarete,sercode);
    COMMIT;

    SELECT MAX(CARTE_ID) INTO carteID FROM CARTE_VIRTUELLE;

    INSERT INTO CARTE_LANGUE (CARTE_NOM, CARTE_TEXTE, CARTE_ID, LANG_ID)
    VALUES (nom,texte,carteID,langID);
    COMMIT ;
  END;

/* Vous pouvez tester cette procédure via cette commande : */
BEGIN creer_carte('Nom de teste','Texte de test.',1,'Artiste de test','3BB','créature', 100,5,5,'B',0,'KLD') ;
END;


-- 2. La fonction GET_CARTE_ID retourne l'identifiant d'une carte selon son nom.

CREATE OR REPLACE FUNCTION get_card_id(nom_de_carte IN VARCHAR2)
  RETURN NUMERIC
  IS id NUMERIC;
  BEGIN
    SELECT CARTE_ID INTO id FROM CARTE_LANGUE WHERE CARTE_NOM = nom_de_carte;
  RETURN id;

  EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR : La carte ' || nom_de_carte || 'est introuvable. Essayez une autre orthographe');
  END;

/* Vous pouvez tester cette fonction via cette commande : */
SELECT get_card_id('Aven Flock') AS carte_identifiant FROM dual;

-- 3. La fonction carte_non_posseder permet de retourner l'ensemble des cartes non possédées par l'utilisateur
CREATE TYPE carte AS OBJECT (carte_id  NUMERIC, carte_nom  VARCHAR2(30 CHAR),carte_texte  VARCHAR2(500 CHAR),lang_id  NUMERIC,carte_artiste  VARCHAR2(30 CHAR),carte_cout  VARCHAR2(30 CHAR),carte_type  VARCHAR2(30 CHAR),carte_ordre_serie  NUMERIC,carte_endurance  NUMERIC,carte_force  NUMERIC,carte_couleur  VARCHAR2(1 CHAR),carte_rarete  NUMERIC,ser_code  VARCHAR2(3 CHAR));
CREATE OR REPLACE TYPE tab_carte as TABLE OF carte;

CREATE OR REPLACE FUNCTION carte_non_posseder(idCol NUMERIC)
  RETURN  tab_carte PIPELINED
  IS c carte := carte(NULL, NULL,NULL, NULL,NULL, NULL,NULL, NULL,NULL, NULL,NULL, NULL,NULL);
  BEGIN
  FOR cc IN (SELECT * FROM carteTotale WHERE (carte_id, lang_id) NOT IN (Select carte_id, lang_id FROM possession WHERE col_id = idCol))
      LOOP

      c.carte_id := cc.carte_id;
      c.carte_nom := cc.carte_nom;
      c.carte_texte := cc.carte_texte;
      c.lang_id :=cc.lang_id;
      c.carte_artiste :=cc.carte_artiste;
      c.carte_cout :=cc.carte_cout;
      c.carte_type :=cc.carte_type;
      c.carte_ordre_serie:=cc.carte_ordre_serie;
      c.carte_endurance :=cc.carte_endurance;
      c.carte_force :=cc.carte_force;
      c.carte_couleur:=cc.carte_couleur;
      c.carte_rarete :=cc.carte_rarete;
      c.ser_code:=cc.ser_code;

  	  PIPE ROW (c);
      END LOOP;

  RETURN;
END;

/* Vous pouvez tester cette fonction via cette commande : */
SELECT * FROM TABLE(carte_non_posseder(1));


-- Triggers
-- 1. trigger executer avant la mise à jour d'une ligne de la table POSSESSION pour controller la valeur de POS_QUANTITE

CREATE OR REPLACE TRIGGER trig_update_possession
 BEFORE UPDATE ON POSSESSION
 FOR EACH ROW
 DECLARE
     zero_possession EXCEPTION;
     PRAGMA EXCEPTION_INIT( zero_possession, -20001 );

 BEGIN
      IF :NEW.POS_QUANTITE = 0 THEN  raise_application_error( -20001, 'ERROR : vous ne pouvez pas posséder zero exemplaire d''une carte => utilisez DELETE à la place ' );
      ELSIF :NEW.POS_QUANTITE < 0 THEN RAISE VALUE_ERROR;
      END IF;

   EXCEPTION
        WHEN VALUE_ERROR THEN
        :NEW.POS_QUANTITE := :OLD.POS_QUANTITE;
        DBMS_OUTPUT.PUT_LINE('ERROR : Vous ne pouvez posseder un nombre négatif ou nul de carte, l''ancienne valeur sera réaffectée' );
        WHEN zero_possession    THEN
        :NEW.POS_QUANTITE := :OLD.POS_QUANTITE;
        dbms_output.put_line( sqlerrm );
 END ;

/* Vous pouvez tester avec ces commandes : */
UPDATE POSSESSION SET POS_QUANTITE = 0  WHERE carte_id=7;
SELECT * FROM POSSESSION WHERE carte_id=7;
