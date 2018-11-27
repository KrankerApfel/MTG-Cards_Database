-- 1
---Sélection des cartes dessinées par quelqu'un dont le nom commence par Mar
---Rôle : Afficher un ensemble d'artiste ayant illustré une carte
-- ORACLE 
SELECT * FROM carte_virtuelle WHERE REGEXP_LIKE(carte_artiste, '^(Mar).*');
-- PGSQL
SELECT * FROM carte_virtuelle WHERE carte_artiste ~'^(Mar.*)';
-- MySQL
SELECT * FROM carte_virtuelle WHERE carte_artiste REGEXP'^(Mar.*)';

--2
-- ORACLE - PGSQL - MySQL
--- A : Affiche le nom de l'extension, le nom des cartes et des artistes
--- Rôle : Permet de répertorier les cartes et leurs extensions par artiste

/*V1 syntaxe avec WHERE*/
SELECT carte_nom, ser_nom, carte_artiste FROM serie,carte_langue NATURAL JOIN carte_virtuelle WHERE
carte_virtuelle.ser_code = serie.ser_code ORDER BY CARTE_ARTISTE;
/*V2 syntaxe avec INNER JOIN*/
SELECT carte_nom, ser_nom, carte_artiste FROM carte_langue NATURAL JOIN carte_virtuelle INNER JOIN serie
ON carte_virtuelle.ser_code = serie.ser_code ORDER BY CARTE_ARTISTE;
/*V3 jointure externe LEFT et RIGHT*/
/*LEFT*/
SELECT carte_nom, ser_nom, carte_artiste FROM carte_langue NATURAL JOIN carte_virtuelle LEFT OUTER JOIN serie
ON carte_virtuelle.ser_code = serie.ser_code ORDER BY CARTE_ARTISTE;
/*RIGTH*/
SELECT carte_nom, ser_nom, carte_artiste FROM carte_langue NATURAL JOIN carte_virtuelle RIGHT OUTER JOIN serie
ON carte_virtuelle.ser_code = serie.ser_code ORDER BY CARTE_ARTISTE;

--  ORACLE - PGSQL - MySQL
--- B : Affiche le détail complet(nom,description,type,cout, etc..) de toutes les cartes de la base de donnée
--- Rôle : Obtenir une vue globale de la base de donnée

/*V1 syntaxe avec WHERE*/
SELECT * FROM carte_langue, carte_virtuelle
WHERE carte_langue.carte_id = carte_virtuelle.carte_id;
/*V2 syntaxe avec INNER JOIN*/
SELECT * FROM carte_langue INNER JOIN carte_virtuelle
ON carte_langue.carte_id = carte_virtuelle.carte_id;
/*V3 jointure externe LEFT et RIGHT*/
/*LEFT*/
SELECT * FROM carte_langue LEFT OUTER JOIN carte_virtuelle
ON carte_langue.carte_id = carte_virtuelle.carte_id;
/*RIGTH*/
SELECT * FROM carte_langue RIGHT OUTER JOIN carte_virtuelle
ON carte_langue.carte_id = carte_virtuelle.carte_id;

--  ORACLE - PGSQL - MySQL
--- C : Affiche la description de la carte et la langue dans laquelle elle est publiée pour les cartes françaises uniquements
--- Rôle : Obtenir tout les descriptions françaises

/*V1 syntaxe avec WHERE*/
SELECT carte_texte, lang_nom  FROM carte_langue, langue WHERE
carte_langue.lang_id = langue.lang_id AND lang_nom = 'français';
/*V2 syntaxe avec INNER JOIN*/
SELECT carte_texte, lang_nom  FROM carte_langue NATURAL JOIN langue WHERE
lang_nom = 'français';
/*V3 jointure externe LEFT et RIGHT*/
/*NOTE : La jointure externe à gauche et à droite sont égale mais différente la jointure naturelle. En effet,
la jointure gauche associe tout les noms de cartes à la langue française peut importe sa langue réelle et inversement pour la
jointure droite
*/
/*LEFT*/
SELECT carte_texte, lang_nom FROM carte_langue LEFT JOIN langue ON
lang_nom = 'français';
/*RIGTH*/
SELECT carte_texte, lang_nom FROM carte_langue RIGHT JOIN langue ON
lang_nom = 'français';

--  ORACLE - PGSQL - MySQL
--- D : Affiche le nom des cartes par collection
--- Rôle : Savoir quelles cartes sont dans quels collection

/*V1 syntaxe avec WHERE*/
SELECT  carte_nom, col_nom FROM carte_langue,collection
WHERE carte_id IN(SELECT carte_id FROM carte_langue NATURAL JOIN possession)
AND col_id IN(SELECT col_id FROM carte_langue NATURAL JOIN possession);
/*V2 syntaxe avec INNER JOIN*/
SELECT  carte_nom, col_nom FROM carte_langue INNER JOIN collection
ON carte_id IN(SELECT carte_id FROM carte_langue NATURAL JOIN possession)
AND col_id IN(SELECT col_id FROM carte_langue NATURAL JOIN possession);
/*V3 jointure externe LEFT et RIGHT*
/*NOTE : La jointure externe à droite et la jointure interne sont égales mais différente de la jointure gauche. En effet,
la jointure gauche va également afficher les cartes se trouvant dans aucune collection. Tandis que la jointure droite
va afficher toute les collection associé à une carte, ce qui est équivalent à l'action d'afficher toutes les cartes
associé à une collection (ce que fait une jointure interne).
*/
/*LEFT*/
SELECT  carte_nom, col_nom FROM carte_langue LEFT JOIN collection
ON carte_id IN(SELECT carte_id FROM carte_langue NATURAL JOIN possession)
AND col_id IN(SELECT col_id FROM carte_langue NATURAL JOIN possession);
/*RIGTH*/
SELECT  carte_nom, col_nom FROM carte_langue RIGHT JOIN collection
ON carte_id IN(SELECT carte_id FROM carte_langue NATURAL JOIN possession)
AND col_id IN(SELECT col_id FROM carte_langue NATURAL JOIN possession);

-- 3
--- Sélections des cartes de couleurs bleues et blanches
---Rôle : Filtre les cartes avec deux type de couleurs ou plus
-- ORACLE - PGSQL - MySQL
SELECT * FROM carte_virtuelle WHERE carte_couleur = 'B'
UNION
SELECT * FROM carte_virtuelle WHERE carte_couleur = 'W';

-- 4
--- Sélections de toutes les cartes à l'exception des créatures
---Rôle : Afficher les cartes à l'exception d'un critère donnée
-- ORACLE
SELECT * FROM carte_virtuelle
MINUS
SELECT * FROM carte_virtuelle WHERE carte_type = 'créature';
-- PGSQL - MySQL
SELECT * FROM carte_virtuelle
EXCEPT
SELECT * FROM carte_virtuelle WHERE carte_type = 'créature';

-- 5
--- A ORACLE - PGSQL - MySQL
--- Sélection des cartes virtuelles appartenant à la série Odyssey
--- Rôle : Obtenir l'ensemble des cartes d'une série
SELECT * FROM carte_virtuelle WHERE ser_code =
(SELECT ser_code FROM serie WHERE ser_nom = 'Odyssey');
--- B ORACLE - PGSQL - MySQL
--- Sélection des cartes langues de couleur blanche
---Role : Filtre les cartes suivant la couleur
SELECT DISTINCT carte_nom, CARTE_COULEUR FROM carte_langue, CARTE_VIRTUELLE WHERE carte_langue.carte_id IN
(SELECT carte_id FROM carte_virtuelle WHERE carte_couleur = 'W');
--- C ORACLE - PGSQL - MySQL
---Force moyenne de l'ensemble des créatures
---Rôle : Connaitre la force moyenne de son deck
SELECT AVG(cnt.m) FROM
(SELECT COUNT(carte_force) m FROM carte_virtuelle GROUP BY carte_type) cnt;
--- D ORACLE - PGSQL - MySQL
---Sélection des cartes (langues) qui ont pour id une carte dont le code de la série Tornament
---Rôle : obtenir que le texte d'une carte d'une série donnée
SELECT * FROM carte_langue WHERE carte_id IN
(SELECT carte_id FROM carte_virtuelle WHERE ser_code =
(SELECT ser_code FROM serie WHERE ser_nom = 'Tornament'));
--- E ORACLE - PGSQL - MySQL
---Sélection des cartes (langues) qui ont Flying en début de description
---Rôle : Filtrer les cartes selon leur capacité à voler
SELECT carte_nom, carte_texte FROM carte_langue c WHERE
EXISTS(SELECT * FROM carte_langue c2 WHERE c.carte_texte=c2.carte_texte AND c2.carte_texte LIKE 'Flying%');

-- 6 ORACLE - MySQL - PGSQL
--- Affiche la quantité de carte pour une collection donnée
--- Rôle : obtenir le total de carte par collection
/*version jointure*/
SELECT sum(pos_quantite), col_nom
FROM possession NATURAL JOIN collection GROUP BY col_nom;
/*version sous-requête*/
SELECT sum(pos_quantite), col_nom
FROM possession INNER JOIN
(SELECT  col_nom , col_id FROM collection) NOM ON possession.col_id = NOM.col_id
GROUP BY col_nom;

-- 7 ORACLE - MySQL - PGSQL
---Sélection de l'endurance moyenne des créatures
---Rôle : Connaitre l'endurance moyenne de ses créatures
SELECT AVG(carte_endurance) FROM carte_virtuelle WHERE carte_type = 'créature';
--- Comptage des cartes de type éphémère
---Rôle : Connaitre le nombre de carte éphémère
SELECT count(*) FROM carte_virtuelle WHERE carte_type = 'éphémère';

-- 8 ORACLE - MySQL - PGSQL
---Sélection de la meilleure force des creatures en fonction de leurs couleurs
---Rôle : Connaitre la carte la plus forte pour chaque couleur
SELECT MAX(carte_force), carte_couleur FROM carte_virtuelle where carte_type = 'creature' GROUP BY carte_couleur;
---Comptage des cartes en fonction de leur série
---Rôle : Connaitre le nombre de carte par série
SELECT COUNT(carte_id), ser_code FROM carte_virtuelle GROUP BY ser_code;

--9 ORACLE - MySQL - PGSQL
--Sélection des artistes ayant dessiné plus de 15 cartes
---Rôle : Connaitre les artiste ayant travailler sur un certain nombre de cartes
SELECT carte_artiste FROM carte_virtuelle GROUP BY carte_artiste HAVING COUNT(carte_id) > 15;
--Sélection des couleurs ayant la force moyenne de leurs cartes supérieure à 1.3
---Rôle : Connaitre les couleurs ayant une moyenne de force supérieur à un nombre
SELECT carte_couleur from carte_langue NATURAL JOIN carte_virtuelle GROUP BY carte_couleur HAVING AVG(carte_force) > 1.3;

-- 10  ORACLE - MySQL - PGSQL
--- Affiche sur une même ligne les noms des cartes français et anglais
--- Rôle : Connaître les traductions des noms de cartes dans ces deux langues
SELECT  C1.carte_nom AS NOM_EN, C2.carte_nom AS NOM_FR
FROM carte_langue C1, carte_langue C2
WHERE C1.carte_id = C2.carte_id AND C1.lang_id = 1 AND C2.lang_id = 2 ;
