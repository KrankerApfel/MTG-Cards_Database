-- Vues

-- 1. Vue qui regroupe toutes les données d'une carte physique (c'est-à-dire regroupant carte_virtuelle et carte_langue).
-- Utilité : Cela permet à l’utilisateur de notre base de donné d’éviter de faire des jointures compliquées
-- entre carte_langue et carte_virtuelle à chaque fois qu’il à besoin de plusieurs informations sur une carte physique.
Create View carteTotale(carte_id, carte_nom, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_texte, carte_artiste, carte_rarete, carte_ordre_serie, ser_code, lang_id) as SELECT carte_id, carte_nom, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_texte, carte_artiste, carte_rarete, carte_ordre_serie, ser_code, lang_id from carte_virtuelle NATURAL JOIN carte_langue; 

--2. Vue qui regroupe les cartes anglaises possédées
-- Utilité : Cela permet à l’utilisateur de notre base de donné de ne manipuler que les cartes de cette langues.
-- sans risquer de modifier les cartes éditées dans d'autre langues. Cette vue peut être pratique dans le cas d’un tournoi
-- qui n’autorise que les cartes d’une langue en particulier, nous pouvons vérifier rapidement si nous pouvons faire un deck
-- de cette langue. Il suffit juste de modifier l’attribut lang_id pour avoir les cartes en fonction d’une langue précise,
-- par défaut cela est placé sur anglais.
Create View cartesAnglaises(col_id, carte_id, pos_quantite) as SELECT col_id, carte_id, pos_quantite FROM possession WHERE lang_id = 1;

--3. Vue qui regroupe le nombre d'utilisateur possédant une carte.
-- Utilité : Ceci permet aux collectionneurs de cartes d’estimer la valeur d’une carte en fonction
-- du nombre de possesseurs de cette dernière.

Create View nombrePossesseur(carte_nom, nbPossesseurs) AS
Select carte_nom, count(possession.carte_id) from carteTotale LEFT OUTER JOIN possession ON carteTotale.carte_id = possession.carte_id Group by carte_nom ORDER BY carte_nom;

-- Fonctions et procédures PL/pgSQL

--- 1. La procédure CREER_CARTE permet d'insérer les données d'une nouvelle carte à la fois dans CARTE_VIRTUELLE et CARTE_LANGUE.
--- Utilité : Cela permet d'accélérer et de simplifier l'insertion d'information d'une carte.
--- Notons que CARTE_ID n'est pas renseigné car il est déjà auto-incrémenté. C'est pourquoi on insère dans CARTE_LANGUE par
--- rapport au dernier CARTE_ID inséré dans CARTE_VIRTUELLE (c'est-à-dire le max).

Create or replace function creer_carte(nom varchar, texte varchar, langue integer, artiste varchar, cout varchar, type varchar, ordre integer, endurance integer, force integer, couleur char,    rarete integer,  serie varchar) Returns void AS
$$
DECLARE
	idCarte INTEGER;
BEGIN
	INSERT INTO carte_virtuelle(carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_artiste, carte_rarete, carte_ordre_serie, ser_code) VALUES
	(couleur, type, cout, force, endurance, artiste, rarete, ordre, serie);

	Select max(carte_id) INTO idCarte from carte_virtuelle;

	INSERT INTO carte_langue Values
	(nom, texte, idCarte, langue);
END;
$$ LANGUAGE plpgsql;

 --2.
 -- La fonction nbcartesutilisateur compte le nombre de cartes possédée par tout les utilisateurs
 -- Utilité : L’intérêt de cette fonction est de permettre à un utilisateur de s’y retrouver dans 
 -- sa base de données et évaluer l’ampleur de sa collection.

Create Or Replace Function nbCartesUtilisateur(idCol Integer) Returns INTEGER AS
$$
DECLARE
	nbCartes INTEGER;
BEGIN
	Select sum(pos_quantite) INTO nbCartes from possession where col_id = idCol;
	--Raise Notice 'Vous possédez % cartes', nbCartes;
	Return nbCartes;
END;
$$ LANGUAGE plpgsql;

-- 3. La fonction carte_non_posseder permet de retourner l'ensemble des cartes non possédées dans la collection
--- dont l'id est passé en paramètre. Elle utilise un type objet carte comportant les même attributs que les enregistrements
--- de la vue carteTotale et un type tab_carte qui est un tableau de carte.
--- Utilité : Ceci permet à l’utilisateur de savoir quelles cartes chercher s’il veut compléter sa collection.
Create Or Replace Function cartesNonPossedees(idCol Integer) Returns SETOF carteTotale AS
$$
DECLARE
	cnp carteTotale%RowType;
BEGIN
	FOR cnp IN SELECT * from carteTotale WHERE (carte_id, lang_id) NOT IN (Select carte_id, lang_id FROM possession where col_id = idCol) LOOP
		Return Next cnp;
	END LOOP;
	Return;
END;
$$ LANGUAGE plpgsql;

-- Triggers

/**
 * Trigger permettant de créer une collection en vérifiant que le nom de la collection n'existe pas déjà au préalable
 */

CREATE FUNCTION existe_nom() RETURNS trigger AS $$
DECLARE
	compteur int; --On déclare un compteur
BEGIN
	SELECT COUNT(*) INTO compteur FROM collection WHERE col_nom LIKE NEW.col_nom; --On regarde si le nom proposé est déjà dans la table
		IF (compteur = 0) THEN
		  RAISE NOTICE 'Changement de nom effectué';
			RETURN NEW;
		ELSE
		  RAISE NOTICE '% existe déjà parmis les noms de collection', NEW.col_nom;
			RETURN NULL;
		END IF;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION existe_nom() CASCADE ;

CREATE TRIGGER nom_collection
	BEFORE UPDATE OR INSERT ON collection
  FOR EACH ROW EXECUTE PROCEDURE existe_nom();

UPDATE collection SET col_nom ='Collection Sonny' WHERE col_id =2;
INSERT INTO collection VALUES	(4,'Collection_Tahina'),
														  (5,'Collection_Bruno'),
															(6,'Collection_Valentin'),
															(7,'Collection_Stephan');



create or replace function fun_recommandation() returns trigger as $$
  declare
		carte carteTotale%ROWTYPE;
    rep VARCHAR(3);
  begin
    SELECT * INTO carte FROM cartesNonPossedees(NEW.col_id) CN
    	WHERE ser_code = (SELECT ser_code FROM carte_virtuelle WHERE carte_virtuelle.carte_id = NEW.carte_id)
    	  		AND CN.carte_id != NEW.carte_id; -- Que les cartes différentes de la nouvelle carte insérée

    RAISE NOTICE 'Recommandation : % | % | %' ,carte.carte_nom, carte.carte_texte, carte.ser_code;
    RAISE NOTICE 'Ajouter ?';
		rep := '&saisie';
		IF rep = 'oui' THEN
			SELECT * FROM creer_carte(carte.carte_nom, carte.carte_texte, carte.lang_id, carte.carte_artiste, carte.carte_cout,carte.carte_type, carte.carte_ordre_serie, carte.carte_endurance, carte.carte_force, carte.carte_couleur, carte.carte_rarete, carte.ser_code);
			RAISE NOTICE '% ajouté à votre collection', carte.carte_nom;
		end if;
		RETURN NEW;
	end;
$$ language plpgsql;

create trigger recommandation
  after insert on possession
  for each statement execute procedure fun_recommandation();

/**
* Trigger qui permet d'afficher le nombre de cartes possédées avant et après insertion dans la base de données
*/

create function fun_after_insert_on_possession() returns trigger AS $$
  declare
    compteurAvant integer;
    compteurApres integer;
    nbChangement integer;
  begin
    raise notice 'Nombre de cartes possédées dans toutes les collections confondues';
    if(tg_when = 'BEFORE') THEN
			select * into compteurAvant from nbcartesutilisateur();
			raise notice '% avant l''insertion',compteurAvant;
		end if;
		if(tg_when = 'AFTER') THEN
			select * into compteurApres from nbcartesutilisateur();
			nbChangement := compteurApres - compteurAvant;
			raise notice '% cartes possédées après l''insertion',compteurApres;
		end if;
		RETURN NEW;
	end;
  $$ language plpgsql;

drop FUNCTION fun_after_insert_on_possession() cascade;

/**
 * Combinaison de Trigger before et after insert sur collection
 */

create trigger trig_nb_inserer_total_before
  before insert on possession
  for each statement execute procedure fun_after_insert_on_possession();

create trigger trig_nb_inserer_total_after
  after insert on possession
  for each statement execute procedure fun_after_insert_on_possession();

INSERT INTO possession VALUES (2, 300, 1, 2);
INSERT INTO possession VALUES (2, 310, 1, 2), 
			(2, 290, 1,2),
(2, 57, 1, 2);

