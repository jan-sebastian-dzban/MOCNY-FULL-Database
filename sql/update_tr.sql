call add_beer('Bud1gfh','pp',2.2,'type',1,'dc','ds',22.34);
select* from liquors;

call add_wine('Budxcd1','pp',2.2,'Red',1,'dc','ds',22.34);
UPDATE sales SET done=1 WHERE sale_id = 58;
SET SQL_SAFE_UPDATES = 0;
call update_sale(58);
SET SQL_SAFE_UPDATES = 1;
call update_supply(10);


DELIMITER //
CREATE TRIGGER update_quantity_supplies AFTER UPDATE ON supplies FOR EACH ROW
  BEGIN
    IF NEW.done AND NOT OLD.done THEN
      CREATE TEMPORARY TABLE prods AS (
        SELECT product_id, quantity FROM supplies JOIN supplies_info si ON supplies.supply_id = si.supply_id
        WHERE supplies.supply_id = NEW.supply_id
      );
      UPDATE products p JOIN prods ON  p.product_id = prods.product_id
        SET p.quantity = p.quantity + prods.quantity;
        DROP TEMPORARY TABLE prods;
    END IF;
  END //
DELIMITER ;
DROP TRIGGER  update_quantity_supplies;
DROP TEMPORARY TABLE prods;
DELIMITER //
CREATE TRIGGER update_quantity_sales AFTER UPDATE ON sales FOR EACH ROW
  BEGIN
    IF NEW.done AND NOT OLD.done THEN
      CREATE TEMPORARY TABLE prods AS (
        SELECT product_id, quantity FROM sales s JOIN sales_info si ON s.sale_id = si.sale_id
        WHERE s.sale_id = NEW.sale_id
      );
		UPDATE products p JOIN prods ON p.product_id = prods.product_id
        SET p.quantity =  IF(p.quantity > prods.quantity ,  p.quantity - prods.quantity, 0);


        DROP TEMPORARY TABLE prods;
    END IF;
  END //
DELIMITER ;
		UPDATE products p JOIN prods ON  p.product_id = prods.product_id
        SET p.quantity = p.quantity - prods.quantity;
      CREATE TEMPORARY TABLE prods AS (
        SELECT product_id, quantity FROM sales s JOIN sales_info si ON s.sale_id = si.sale_id
        WHERE s.sale_id = 58
      );
select * from prods;
SELECT p.product_id,p.quantity,prods.product_id, prods.quantity, IF(p.quantity >prods.quantity>0 ,  p.quantity - prods.quantity, 0)  FROM
        products p JOIN prods ON p.product_id = prods.product_id;


GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_sale TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_supply TO worker;