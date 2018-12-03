--Fonction d'insertion de carte_virtuelle et carte_langue
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



--Fonction comptant le nombre de cartes possédée par un utilisateur
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


--Fonction retournant l'ensemble des cartes non possédées par l'utilisateur
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

