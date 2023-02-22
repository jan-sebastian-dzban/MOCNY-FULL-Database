DELIMITER //
CREATE PROCEDURE add_product(IN name_in VARCHAR(50), IN type_in ENUM('beer', 'liquor', 'wine'), IN capacity_in INT UNSIGNED,
  IN abv_in FLOAT UNSIGNED, IN price_in DECIMAL(5, 2) UNSIGNED, IN quantity_in INT UNSIGNED, OUT id INT)
  BEGIN
    INSERT INTO products(name, type, capacity, abv, price, quantity)
    VALUES (
      name_in,
      type_in,
      capacity_in,
      abv_in,
      price_in,
      quantity_in
    );
    SET id = LAST_INSERT_ID();

  END //
DELIMITER ;

call add_product('dd','beer', 1,2.2, 5.2, 10,@LID);
select* from products;