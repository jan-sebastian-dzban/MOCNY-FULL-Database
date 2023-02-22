DELIMITER //
CREATE PROCEDURE add_user(IN login_in varchar(50), IN password_in varchar(255), IN seed_in int,
  IN type_in enum ('admin', 'manager', 'worker','supplier','client'), OUT id INT)
  BEGIN
    INSERT INTO users(login, password, seed, type)
    VALUES (
      login_in,
      password_in,
      seed_in,
      type_in
    );
    SET id = LAST_INSERT_ID();

  END //
DELIMITER ;

call add_user('dd','beer', 1,'client',@LID);
select* from users;
