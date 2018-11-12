DROP TABLE IF EXISTS serie CASCADE;
DROP TABLE IF EXISTS langue CASCADE;
DROP TABLE IF EXISTS langue_serie CASCADE;
DROP TABLE IF EXISTS collection CASCADE;


CREATE TABLE serie (
 ser_code    AUTO_INCREMENT PRIMARY KEY,
 ser_nom     VARCHAR(30) NOT NULL,
 ser_date    DATE,
 ser_nbTotal INTEGER NOT NULL
);
CREATE TABLE langue (
 lang_id  AUTO_INCREMENT PRIMARY KEY,
 lang_nom VARCHAR(30) NOT NULL
);

CREATE TABLE langue_serie (
  lang_id  INTEGER NOT NULL ,
  ser_code INTEGER NOT NULL ,
  FOREIGN KEY (lang_id) REFERENCES langue (lang_id),
  FOREIGN KEY (ser_code) REFERENCES serie (ser_code),
  PRIMARY KEY (lang_id, ser_code)
);

CREATE TABLE collection(
 col_id AUTO_INCREMENT PRIMARY KEY,
 col_nom VARCHAR(30) NOT NULL
);
