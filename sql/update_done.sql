DELIMITER //
CREATE PROCEDURE update_supply(IN in_supply_id INT)
BEGIN
  UPDATE supplies SET done = 1 WHERE supply_id = in_supply_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE update_sale(IN in_sale_id INT)
BEGIN
  UPDATE sales SET done = 1 WHERE sale_id = in_sale_id;
END //
DELIMITER ;