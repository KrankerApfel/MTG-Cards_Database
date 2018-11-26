--1
Sélection des cartes dessiné par quelquun dont le nom commence par Mar
SELECT * FROM carte_virtuelle WHERE carte_artiste ~'^(Mar.*)'; 

--2----------------------------------------------------------------------------------

--3
Sélections des cartes de couleurs bleues et blanches
SELECT * FROM carte_virtuelle WHERE carte_couleur = 'B'
	UNION 
SELECT * FROM carte_virtuelle WHERE carte_couleur = 'W';

--4
Sélections de toutes les cartes à lexception des créatures
SELECT * FROM carte_virtuelle 
	EXCEPT
SELECT * FROM carte_virtuelle WHERE carte_type = 'creature';

--5.a
Sélection des cartes langues de couleur blanche
SELECT * FROM carte_langue WHERE carte_id IN 
	(SELECT carte_id FROM carte_virtuelle WHERE carte_couleur = 'W');

--5.b
Sélection des cartes virtuelles appartenant à la série Odyssey
SELECT * FROM carte_virtuelle WHERE ser_code = 
	(SELECT ser_code FROM serie WHERE ser_nom = 'Odyssey');

--5.c------------------------------------------------------------------------
SELECT AVG(cnt.m) FROM 
	(SELECT COUNT(carte_force) m FROM carte_virtuelle GROUP BY carte_type) cnt;

--5.d
Sélection des cartes langues qui ont pour id une carte dont le code de la série a pour nom Torment
SELECT * FROM carte_langue WHERE carte_id IN 
	(SELECT carte_id FROM carte_virtuelle WHERE ser_code =
		(SELECT ser_code FROM serie WHERE ser_nom = 'Torment'));

--7
Sélection de lendurance moyenne des créatures
SELECT AVG(carte_endurance) FROM carte_virtuelle WHERE carte_type = 'creature';

Comptage des cartes de type éphémère
SELECT count(*) FROM carte_virtuelle WHERE carte_type = 'ephemere';

--8
Sélection de la meilleure force des creatures en fonction de leurs couleurs
SELECT MAX(carte_force), carte_couleur FROM carte_virtuelle where carte_type = 'creature' GROUP BY carte_couleur;

Comptage des cartes en fonction de leur série
SELECT COUNT(carte_id), ser_code FROM carte_virtuelle GROUP BY ser_code;

--9
Sélection des artistes ayant dessiné plus de 15 cartes
SELECT carte_artiste FROM carte_virtuelle GROUP BY carte_artiste HAVING COUNT(carte_id) > 15;

Sélection des couleurs ayant la force moyenne de leurs cartes supérieure à 2.3
SELECT carte_couleur from carte_langue NATURAL JOIN carte_virtuelle GROUP BY carte_couleur HAVING AVG(carte_force) > 2.3;

--10--------------------------------------------------------------
