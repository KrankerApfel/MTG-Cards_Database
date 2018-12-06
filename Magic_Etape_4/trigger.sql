/**
 * Fonction qui retourne les noms de collections qui n'ont pas encore été utilisés
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


/*Trigger comptant le nombre de carte inséré*/

create function fun_after_insert_on_possession() returns trigger AS $$
  declare
    compteurAvant integer;
    compteurApres integer;
    nbChangement integer;
  begin
    if(tg_when = 'BEFORE') THEN
			select * into compteurAvant from nbcartesutilisateur(new.col_id);
		end if;
		if(tg_when = 'AFTER') THEN
			select * into compteurApres from nbcartesutilisateur(new.col_id);
		end if;
		nbChangement := compteurApres - compteurAvant;
		raise notice '% cartes possédées',compteurApres;
		raise notice '% cartes ajoutées',nbChangement;
	end;
  $$ language plpgsql;

/**
 * Trigger after insert sur collection
 */
create trigger trig_nb_inserer_total
  after insert on possession
  for each statement execute procedure fun_after_insert_on_possession();

