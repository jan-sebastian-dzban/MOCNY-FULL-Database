DELIMITER //
CREATE FUNCTION email_is_valid(email varchar(50)) RETURNS BOOLEAN
BEGIN
  IF INSTR(email, '@') > 0
  THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END //
DELIMITER ;

SET @x= email_is_valid('cdcd@@');
SELECT @x;

DELIMITER //
CREATE FUNCTION nip_is_valid(nip CHAR(10)) RETURNS BOOLEAN
BEGIN
  IF CHAR_LENGTH (nip)<>10
  THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER workers_insert BEFORE INSERT ON workers FOR EACH ROW
  BEGIN
    IF NOT nip_is_valid(new.nip) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIP control sum error';
    END IF;
	IF NOT email_is_valid(new.email) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'email no @ sign';
    END IF;
  END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER clients_insert BEFORE INSERT ON clients FOR EACH ROW
  BEGIN
    IF NOT nip_is_valid(new.nip) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIP control sum error';
    END IF;
	IF NOT email_is_valid(new.email) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'email no @ sign';
    END IF;
  END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER suppliers_insert BEFORE INSERT ON suppliers FOR EACH ROW
  BEGIN
    IF NOT nip_is_valid(new.nip) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIP control sum error';
    END IF;
	IF NOT email_is_valid(new.email) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'email no @ sign';
    END IF;
  END //
DELIMITER ;
select * from suppliers;
Insert into suppliers(supplier_id, company, name, nip, address, phone_number, email) values(
'30', 'Rivera-Benjamin', 'Timothy Evans', '6040830621', '90086 Daniel Ports Robinberg, AZ 35500', '577 552 628', 'amber38@example.com');
delete from suppliers where supplier_id=30;