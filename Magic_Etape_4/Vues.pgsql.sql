--Vue qui regroupe toutes les données d'une carte physique(carte_virtuelle + carte_langue)
Create View carteTotale(carte_id, carte_nom, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_texte, carte_artiste, carte_rarete, carte_ordre_serie, ser_code, lang_id) as SELECT carte_id, carte_nom, carte_couleur, carte_type, carte_cout, carte_force, carte_endurance, carte_texte, carte_artiste, carte_rarete, carte_ordre_serie, ser_code, lang_id from carte_virtuelle NATURAL JOIN carte_langue; 

--Vue qui regroupe les cartes anglaises possédées
Create View cartesAnglaises(col_id, carte_id, pos_quantite) as SELECT col_id, carte_id, pos_quantite FROM possession WHERE lang_id = 1;

--Vue qui regroupe le nombre d'utilisateur possédant une carte
Create View nombrePossesseur(carte_nom, nbPossesseurs) AS
Select carte_nom, count(possession.carte_id) from carteTotale LEFT OUTER JOIN possession ON carteTotale.carte_id = possession.carte_id Group by carte_nom ORDER BY carte_nom;
