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

