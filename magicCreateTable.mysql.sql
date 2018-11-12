DROP TABLE IF EXISTS possession;
DROP TABLE IF EXISTS carte_langue;
DROP TABLE IF EXISTS langue_serie;
DROP TABLE IF EXISTS carte_virtuelle;
DROP TABLE IF EXISTS serie;
DROP TABLE IF EXISTS langue;
DROP TABLE IF EXISTS collection;

CREATE TABLE collection
(
	col_id int PRIMARY KEY AUTO_INCREMENT,
	col_nom varchar(30) NOT NULL
);

CREATE TABLE serie 
(
	ser_code int PRIMARY KEY AUTO_INCREMENT,
	ser_nom varchar(30) NOT NULL,
	
	ser_date date,
	ser_nbTotal int NOT NULL
);



CREATE TABLE langue 
(
	lang_id int PRIMARY KEY AUTO_INCREMENT,
	lang_nom varchar(30) NOT NULL
);

CREATE TABLE carte_virtuelle
(
	carte_id int PRIMARY KEY AUTO_INCREMENT,
	carte_cout int NOT NULL,
	
	carte_artiste varchar(30) NOT NULL,
	carte_endurance int CHECK(carte_type = 'creature' AND carte_endurance >= 0),

	carte_type varchar(20) NOT NULL CHECK(carte_type IN('terrain', 'creature', 'enchantement', 'rituel', 'ephemere', 'artefact')),
	carte_rarete int NOT NULL CHECK(carte_rarete BETWEEN 0 AND 4),
	
	carte_couleur char NOT NULL CHECK(carte_couleur IN('w', 'b', 'n', 'r', 'v', 'm', 'i')),
	carte_ordre_serie int NOT NULL,

	carte_force int CHECK(carte_type = 'creature' AND carte_force >= -1),

	ser_code int NOT NULL,
	FOREIGN KEY(ser_code) REFERENCES serie(ser_code)
);

CREATE TABLE carte_langue
(
	carte_id int,
	lang_id int,

	carte_nom varchar(30),
	carte_texte varchar(100),

	FOREIGN KEY(carte_id) REFERENCES carte_virtuelle(carte_id),
	FOREIGN KEY(lang_id) REFERENCES langue(lang_id),

	PRIMARY KEY(carte_id, lang_id)
);



CREATE TABLE langue_serie 
(
	lang_id int NOT NULL,
	ser_code int NOT NULL,

	FOREIGN KEY(lang_id) REFERENCES langue(lang_id),
	FOREIGN KEY(ser_code) REFERENCES serie(ser_code),

	PRIMARY KEY(lang_id, ser_code)
);

CREATE TABLE possession
(
	carte_id int NOT NULL,
	lang_id int NOT NULL,
	col_id int NOT NULL,

	pos_quantite int NOT NULL,

	FOREIGN KEY(carte_id, lang_id) REFERENCES carte_langue(carte_id, lang_id),
	FOREIGN KEY(col_id) REFERENCES collection(col_id),

	PRIMARY KEY(carte_id, lang_id, col_id)
);
