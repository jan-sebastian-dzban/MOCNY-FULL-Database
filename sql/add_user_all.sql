drop PROCEDURE add_user_all;
DELIMITER //
CREATE PROCEDURE add_user_all(IN login_in varchar(50), IN password_in varchar(255), IN seed_in int,
  IN type_in enum ('admin', 'manager', 'worker','supplier','client'),
  IN name VARCHAR(50), IN pesel varchar(10), IN address varchar(50),
  IN phone_number varchar(20), IN email varchar(50))
  BEGIN
	IF type_in = 'worker' THEN
		IF worker_already_exists(name,pesel,address,phone_number,email) THEN
		  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Worker already exists';
		ELSE
		  SET AUTOCOMMIT = 0;
		  START TRANSACTION;
		  CALL add_user(login_in, password_in, seed_in, 'worker',  @id);
		  CALL inner_add_worker(@id,name,pesel,address,phone_number,email);
		  COMMIT;
		  SET AUTOCOMMIT = 1;
		END IF;
	ELSEIF type_in = 'manager' THEN
		IF worker_already_exists(name,pesel,address,phone_number,email) THEN
		  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Worker already exists';
		ELSE
		  SET AUTOCOMMIT = 0;
		  START TRANSACTION;
		  CALL add_user(login_in, password_in, seed_in, 'manager',  @id);
		  COMMIT;
		  SET AUTOCOMMIT = 1;
		END IF;
	 ELSEIF type_in = 'admin' THEN
		IF worker_already_exists(name,pesel,address,phone_number,email) THEN
		  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Admin already exists';
		ELSE
		  SET AUTOCOMMIT = 0;
		  START TRANSACTION;
		  CALL add_user(login_in, password_in, seed_in, 'admin',  @id);
		  COMMIT;
		  SET AUTOCOMMIT = 1;
		END IF;
	ELSEIF type_in = 'client' THEN
		IF client_already_exists(name,pesel,address,phone_number,email) THEN
		  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Client already exists';
		ELSE
		  SET AUTOCOMMIT = 0;
		  START TRANSACTION;
		  CALL add_user(login_in, password_in, seed_in, 'client',  @id);
		  CALL inner_add_client(@id,name,pesel,address,phone_number,email);
		  COMMIT;
		  SET AUTOCOMMIT = 1;
		END IF;
	ELSE
		IF supplier_already_exists(name,pesel,address,phone_number,email) THEN
		  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier already exists';
		ELSE
		  SET AUTOCOMMIT = 0;
		  START TRANSACTION;
		  CALL add_user(login_in, password_in, seed_in, 'supplier',  @id);
		  CALL inner_add_supplier(@id,name,pesel,address,phone_number,email);
		  COMMIT;
		  SET AUTOCOMMIT = 1;
		END IF;
	END IF;
  END //
DELIMITER ;

call add_user_all('ad','an',2,'worker','man12',1111111111,'fgf',34343,'adm@inadmin.com');