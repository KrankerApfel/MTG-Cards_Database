--1
---Sélection des cartes dessinées par quelqu'un dont le nom commence par Mar
---
/*MySQL et PGSQL*/
	SELECT * FROM carte_virtuelle WHERE carte_artiste ~'^(Mar.*)'; 
/*Oracle*/
	SELECT * FROM carte_virtuelle WHERE REGEXP_LIKE(carte_artiste, '^(Mar).*'); 

--2----------------------------------------------------------------------------------
----i-Affiche le nom de l'extension et le nom des cartes illustrées par Mark Zug
/*Version 1*/
	SELECT carte_nom, ser_nom FROM carte_langue INNER JOIN serie 
		ON carte_langue.ser_code = serie.ser_code
	WHERE REGEXP_LIKE(carte_artiste, 'Mark Zug');
/*Version 2*/
	SELECT 

---ii-Affiche le détail complet(nom,description,type,cout, etc..) de toutes les cartes de la base de donnée
	SELECT * FROM carte_langue INNER JOIN carte_virtuelle 
		ON carte_langue.carte_id = carte_virtuelle.carte_id;

--iii-

---iv-

--3
---Sélections des cartes de couleurs bleues et blanches
	SELECT * FROM carte_virtuelle WHERE carte_couleur = 'B'
		UNION 
	SELECT * FROM carte_virtuelle WHERE carte_couleur = 'W';

--4
---Sélections de toutes les cartes à lexception des créatures
	SELECT * FROM carte_virtuelle 
		EXCEPT
	SELECT * FROM carte_virtuelle WHERE carte_type = 'créature';

--5.a
---Sélection des cartes langues de couleur blanche
	SELECT * FROM carte_langue WHERE carte_id IN 
		(SELECT carte_id FROM carte_virtuelle WHERE carte_couleur = 'W');

--5.b
---Sélection des cartes virtuelles appartenant à la série Odyssey
	SELECT * FROM carte_virtuelle WHERE ser_code = 
		(SELECT ser_code FROM serie WHERE ser_nom = 'Odyssey');

--5.c
---Force moyenne de l'ensemble des créatures
SELECT AVG(cnt.m) FROM 
	(SELECT COUNT(carte_force) m FROM carte_virtuelle GROUP BY carte_type) cnt;

--5.d
---Sélection des cartes langues qui ont pour id une carte dont le code de la série a pour nom Torment
SELECT * FROM carte_langue WHERE carte_id IN 
	(SELECT carte_id FROM carte_virtuelle WHERE ser_code =
		(SELECT ser_code FROM serie WHERE ser_nom = 'Torment'));

--7
---Sélection de lendurance moyenne des créatures
SELECT AVG(carte_endurance) FROM carte_virtuelle WHERE carte_type = 'creature';

---Comptage des cartes de type éphémère
SELECT count(*) FROM carte_virtuelle WHERE carte_type = 'ephemere';

--8
---Sélection de la meilleure force des creatures en fonction de leurs couleurs
SELECT MAX(carte_force), carte_couleur FROM carte_virtuelle where carte_type = 'creature' GROUP BY carte_couleur;

---Comptage des cartes en fonction de leur série
SELECT COUNT(carte_id), ser_code FROM carte_virtuelle GROUP BY ser_code;

--9
---Sélection des artistes ayant dessiné plus de 15 cartes
SELECT carte_artiste FROM carte_virtuelle GROUP BY carte_artiste HAVING COUNT(carte_id) > 15;

--Sélection des couleurs ayant la force moyenne de leurs cartes supérieure à 2.3
SELECT carte_couleur from carte_langue NATURAL JOIN carte_virtuelle GROUP BY carte_couleur HAVING AVG(carte_force) > 2.3;

--10--------------------------------------------------------------
