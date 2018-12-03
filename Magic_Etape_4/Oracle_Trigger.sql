DECLARE
  X varchar2(16) := 'le monde !';
BEGIN
  DBMS_OUTPUT.PUT_LINE('Bonjour ' || X);
end;
/

CREATE OR REPLACE TRIGGER trig_recommandation_possession
AFTER INSERT ON possession
DECLARE
  x VARCHAR2(3);
  qte NUMERIC;
  TYPE prop_tab AS OBJECT(cart_nom VARCHAR2(30), ser_code VARCHAR2(3));
BEGIN
  DBMS_OUTPUT.PUT_LINE('Recommandation : ');
  SELECT * INTO prop_tab FROM carte_langue cl NATURAL JOIN carte_virtuelle cv WHERE c.carte_id != :new.carte_id;
  DBMS_OUTPUT.PUT_LINE(prop_tab || ' -- ajouter ?');
  x := '&saisie';
  IF x = 'oui' THEN
    DBMS_OUTPUT.PUT_LINE('Quantite : ');
    qte = '&saisie';
    INSERT INTO POSSESSION(carte_id, lang_id, col_id) (SELECT 
  END IF;
END;
/

SELECT * INTO prop_tab FROM carte_langue cl NATURAL JOIN carte_virtuelle cv;

SELECT * INTO proposition FROM carte_langue NATURAL JOIN serie;
INSERT INTO POSSESSION VALUES (2,12,1,2);

