DELIMITER //
CREATE FUNCTION beer_already_exists(name VARCHAR(50), brewery VARCHAR(50), abv FLOAT UNSIGNED, type VARCHAR(50),
  capacity INT UNSIGNED,  category varchar(50), country varchar(50)) RETURNS BOOLEAN
  BEGIN
    RETURN !ISNULL ((
      SELECT product_id
      FROM beers b
      WHERE
        b.name = name AND
        b.brewery = brewery AND
        b.abv = abv AND
        b.type = type AND
        b.capacity = capacity AND
		b.category	= category AND
		b.country=country
    ));
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE inner_add_beer(IN id INT, IN brewery_in VARCHAR(50),IN name_in VARCHAR(50),IN type_in VARCHAR(50),
  IN abv_in FLOAT UNSIGNED, IN capacity_in INT UNSIGNED, IN  category_in varchar(50), IN country_in varchar(50))
  BEGIN
    INSERT INTO beers(product_id, brewery, name, type, abv, capacity, category,country)
    VALUES (
      id,
      brewery_in,
      name_in,
      type_in,
      abv_in,
      capacity_in,
      category_in,
      country_in
    );
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_beer(IN name VARCHAR(50), IN brewery VARCHAR(50), IN abv FLOAT UNSIGNED, IN type VARCHAR(50),
  IN capacity INT UNSIGNED, IN  category varchar(50), IN country varchar(50), IN price DECIMAL(5, 2) UNSIGNED)
  BEGIN
    IF beer_already_exists(name, brewery, abv, type, capacity,category,country) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Beer already exists';
    ELSE
      SET AUTOCOMMIT = 0;
      START TRANSACTION;
      CALL add_product(name, 'beer', capacity, abv, price, 0, @id);
      CALL inner_add_beer(@id,brewery, name, type, abv, capacity, category,country);
      COMMIT;
      SET AUTOCOMMIT = 1;
    END IF;
  END //
DELIMITER ;


call add_beer('Bud1','pp',2.2,'type',1,'dc','ds',22.34);
select* from beers;
select* from products;

