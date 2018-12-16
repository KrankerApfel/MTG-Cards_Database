-- Vues

-- 1. Vue qui regroupe toutes les données d'une carte physique (c'est-à-dire regroupant carte_virtuelle et carte_langue).
-- Utilité : Cela permet à l’utilisateur de notre base de donné d’éviter de faire des jointures compliquées
-- entre carte_langue et carte_virtuelle à chaque fois qu’il à besoin de plusieurs informations sur une carte physique.
Create View carteTotale(carte_id, carte_nom, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_texte, carte_artiste, carte_rarete, carte_ordre_serie, ser_code, lang_id) as SELECT carte_id, carte_nom, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_texte, carte_artiste, carte_rarete, carte_ordre_serie, ser_code, lang_id from carte_virtuelle NATURAL JOIN carte_langue;

--2. Vue qui regroupe les cartes anglaises possédées
-- Utilité : Cela permet à l’utilisateur de notre base de donné de ne manipuler que les cartes de cette langue.
-- sans risquer de modifier les cartes éditées dans d'autre langues. Cette vue peut être pratique dans le cas d’un tournoi
-- qui n’autorise que les cartes d’une langue en particulier où nous pouvons vérifier rapidement si nous pouvons faire un deck
-- de cette langue. Il suffit juste de modifier l’attribut lang_id pour avoir les cartes en fonction d’une langue précise,
-- par défaut cela est placé sur anglais.
Create View cartesAnglaises(col_id, carte_id, pos_quantite) as SELECT col_id, carte_id, pos_quantite FROM possession WHERE lang_id = 1;

--3. Vue qui regroupe le nombre d'utilisateur possédant une carte.
-- Utilité : Ceci permet aux collectionneurs de cartes d’estimer la valeur d’une carte en fonction
-- du nombre de possesseurs de cette dernière.

Create View nombrePossesseur(carte_nom, nbPossesseurs) AS
Select carte_nom, count(possession.carte_id) from carteTotale LEFT OUTER JOIN possession ON carteTotale.carte_id = possession.carte_id Group by carte_nom ORDER BY carte_nom;

-- Fonctions et procédures PL/*SQL
--- 1. La procédure CREER_CARTE permet d'insérer les données d'une nouvelle carte à la fois dans CARTE_VIRTUELLE et CARTE_LANGUE.
--- Utilité : Cela permet d'accélérer et de simplifier l'insertion d'information d'une carte.
--- Notons que CARTE_ID n'est pas renseigné car il est déjà auto-incrémenté. C'est pourquoi on insère dans CARTE_LANGUE par
--- rapport au dernier CARTE_ID inséré dans CARTE_VIRTUELLE (c'est-à-dire le max).

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
--- Utilité : Cela permet d'éviter une sous-requête supplémentaire lors de cette opération courante,
--- en ajoutant un niveau d'abstraction. De plus, l'identifiant de la carte est le même peut-importe
--- la langue du nom entrée en paramètre.

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
  
  --------------------------------------------------------------------------------
 --2 bis (car on a fait deux examples pour cette question)
 -- La fonction nbcartesutilisateur compte le nombre de cartes possédée par tout les utilisateurs
 -- Utilité : L’intérêt de cette fonction est de permettre à un utilisateur de s’y retrouver dans 
 -- sa base de données et évaluer l’ampleur de sa collection.

create or replace function nbcartesutilisateur return integer is
	nbCartes INTEGER;
BEGIN
	SELECT sum(pos_quantite) INTO nbCartes from possession;
	RETURN nbCartes;
END;
--------------------------------------------------------------------------------

/* Vous pouvez tester cette fonction via cette commande : */
SELECT get_card_id('Aven Flock') AS carte_identifiant FROM dual;

-- 3. La fonction carte_non_posseder permet de retourner l'ensemble des cartes non possédées dans la collection 
--- dont l'id est passé en paramètre. Elle utilise un type objet carte comportant les même attributs que les enregistrements
--- de la vue carteTotale et un type tab_carte qui est un tableau de carte.
--- Utilité : Ceci permet à l’utilisateur de savoir quelles cartes chercher s’il veut compléter sa collection.

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
--- Utilité : permet d'alerter l'utilisateur que sa requête de mise à jour d'une ligne ne sera pas executer
--- si elle ne vérifie pas les conditions, sur la valeur du nombre de carte possédée (forcément strictement supérieur à 0).
--- En effet, plutôt que de provoquer une erreur qui stopperais la totalité des requêtes update que l'utilisateur est en train
--- d'executer, cela ne modifie pas la ligne où l'erreur subsiste, informe l'utilisateur et continue les autres requêtes d'update.
--- L'utilisateur n'a plus qu'à revenir s'occuper des lignes où seules les erreurs étaient détectées.

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

/**
* Les deux triggers suivant servent à afficher le nombre de cartes possédées avant et après une insertion sur la table POSSESSION
* Utilité : permettre à l'utilisateur d'avoir un aperçu du nombre de carte qu'il a inséré après de l'opération
* d'insertion afin de déceler d'éventuelles erreurs
*/

create trigger trig_nb_inserer_total_before
  before insert on possession
  declare
    compteur NUMERIC;
  begin
    compteur := nbcartesutilisateur();
		DBMS_OUTPUT.PUT_LINE(compteur || ' nombre de cartes avant l''insertion');
  end;

create trigger trig_nb_inserer_total_after
  after insert on possession
  declare
    compteur NUMERIC;
  begin
    compteur := nbcartesutilisateur();
		DBMS_OUTPUT.PUT_LINE(compteur || ' nombre de cartes apres l''insertion');
  end;

insert into POSSESSION values (3,34,1,1);
