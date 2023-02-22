
DELIMITER //
CREATE FUNCTION supplier_already_exists(name VARCHAR(50), pesel varchar(10), address varchar(50),
  phone_number varchar(20), email varchar(50)) RETURNS BOOLEAN
  BEGIN
    RETURN !ISNULL ((
      SELECT user_id
      FROM suppliers b
      WHERE
        b.name = name AND
        b.address = address AND
        b.phone_number = phone_number AND
        b.email= email
    ));
  END //
DELIMITER ;

set @x=supplier_already_exists('name',1111111111,'address',321433,'emai@l');
select(@x);

DELIMITER //
CREATE PROCEDURE inner_add_supplier(IN id INT, IN name_in VARCHAR(50),IN pesel_in varchar(10),IN address_in varchar(50),
  IN phone_number_in varchar(20), IN email_in varchar(50))
  BEGIN
    INSERT INTO suppliers(user_id,company,name,nip,address,phone_number,email)
    VALUES (
      id,
      'company',
      name_in,
      pesel_in,
      address_in,
      phone_number_in,
      email_in
    );
  END //
DELIMITER ;
