
DELIMITER //
CREATE FUNCTION wine_already_exists(name VARCHAR(50), brand VARCHAR(50), abv FLOAT UNSIGNED, type VARCHAR(50),
  capacity INT UNSIGNED,  category varchar(50), country varchar(50)) RETURNS BOOLEAN
  BEGIN
    RETURN !ISNULL ((
      SELECT product_id
      FROM wines b
      WHERE
        b.name = name AND
        b.brand = brand AND
        b.abv = abv AND
        b.type = type AND
        b.capacity = capacity AND
		b.category	= category AND
		b.country=country
    ));
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE inner_add_wine(IN id INT,IN name_in VARCHAR(50), IN brand_in VARCHAR(50),IN abv_in FLOAT UNSIGNED,
IN type_in VARCHAR(50), IN capacity_in INT UNSIGNED, IN  category_in varchar(50), IN country_in varchar(50))
  BEGIN
    INSERT INTO wines(product_id,  name,brand, abv, type, capacity, category,country)
    VALUES (
      id,
      name_in,
      brand_in,
      abv_in,
      type_in,
      capacity_in,
      category_in,
      country_in
    );
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_wine(IN name VARCHAR(50), IN brand VARCHAR(50), IN abv FLOAT UNSIGNED, IN type VARCHAR(50),
  IN capacity INT UNSIGNED, IN  category varchar(50), IN country varchar(50), IN price DECIMAL(5, 2) UNSIGNED)
  BEGIN
    IF wine_already_exists(name, brand, abv, type, capacity,category,country) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Liqour already exists';
    ELSE
      SET AUTOCOMMIT = 0;
      START TRANSACTION;
      CALL add_product(name, 'wine', capacity, abv, price, 0, @id);
      CALL inner_add_wine(@id, name, brand,  abv,type, capacity, category,country);
      COMMIT;
      SET AUTOCOMMIT = 1;
    END IF;
  END //
DELIMITER ;


call add_wine('Bud1','pp',2.2,'Red',1,'dc','ds',22.34);
select* from wines;
select* from products;

