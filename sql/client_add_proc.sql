DELIMITER //
CREATE FUNCTION client_already_exists(name VARCHAR(50), pesel varchar(10), address varchar(50),
  phone_number varchar(20), email varchar(50)) RETURNS BOOLEAN
  BEGIN
    RETURN !ISNULL ((
      SELECT user_id
      FROM clients b
      WHERE
        b.name = name AND
        b.pesel = pesel AND
        b.address = address AND
        b.phone_number = phone_number AND
        b.email= email
    ));
  END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE inner_add_client(IN id INT, IN name_in VARCHAR(50),IN pesel_in varchar(10),IN address_in varchar(50),
  IN phone_number_in varchar(20), IN email_in varchar(50))
  BEGIN
    INSERT INTO clients(user_id,name,pesel,address,phone_number,email)
    VALUES (
      id,
      name_in,
      pesel_in,
      address_in,
      phone_number_in,
      email_in
    );
  END //
DELIMITER ;