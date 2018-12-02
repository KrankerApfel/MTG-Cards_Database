INSERT INTO serie VALUES
('ODY', 'Odyssey', '2001/09/21', 350),
('TOR', 'Torment', '2002/02/20', 143),
('JUD', 'Judgment', '2002/05/21', 143),
('KLD', 'Kaladesh', '2016/09/30', 267);

INSERT INTO langue(lang_nom) VALUES
('anglais'),
('français');

INSERT INTO langue_serie VALUES
(1, 'ODY'),
(1, 'TOR'),
(1, 'JUD'),
(1, 'KLD'),
(2, 'KLD');
