DROP TABLE IF EXISTS serie CASCADE;
DROP TABLE IF EXISTS langue CASCADE;
DROP TABLE IF EXISTS langue_serie CASCADE;
DROP TABLE IF EXISTS collection CASCADE;


CREATE TABLE serie (
 ser_code    INT AUTO_INCREMENT PRIMARY KEY,
 ser_nom     VARCHAR(30) NOT NULL,
 ser_date    DATE,
 ser_nbTotal INTEGER NOT NULL
);
CREATE TABLE langue (
 lang_id  INT AUTO_INCREMENT PRIMARY KEY,
 lang_nom VARCHAR(30) NOT NULL
);

CREATE TABLE langue_serie (
  lang_id  INT NOT NULL ,
  ser_code INT NOT NULL ,
  FOREIGN KEY (lang_id) REFERENCES langue (lang_id),
  FOREIGN KEY (ser_code) REFERENCES serie (ser_code),
  PRIMARY KEY (lang_id, ser_code)
);

CREATE TABLE collection(
  col_id INT AUTO_INCREMENT PRIMARY KEY,
  col_nom VARCHAR(30) NOT NULL
);

CREATE TABLE carte_langue(
  carte_id INT NOT NULL ,
  lang_id INT NOT NULL,
  carte_texte VARCHAR(100) NOT NULL,
  carte_nom VARCHAR(30) NOT NULL,

  FOREIGN KEY(carte_id) REFERENCES carte_virtuelle(carte_id),
  FOREIGN KEY(lang_id) REFERENCES langue(lang_id)

  PRIMARY KEY(carte_id, lang_id)

);
