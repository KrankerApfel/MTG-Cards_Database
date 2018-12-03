--Fonction d'insertion de carte_virtuelle et carte_langue




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

