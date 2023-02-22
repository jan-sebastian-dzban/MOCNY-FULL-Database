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
    END IF;
  END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER update_quantity_sales AFTER UPDATE ON sales FOR EACH ROW
  BEGIN
    IF NEW.done AND NOT OLD.done THEN
      CREATE TEMPORARY TABLE prods AS (
        SELECT product_id, quantity FROM sales s JOIN sales_info si ON s.sale_id = si.sale_id
        WHERE s.sale_id = NEW.sale_id
      );
      UPDATE products p JOIN prods ON  p.product_id = prods.product_id
        SET p.quantity = p.quantity - prods.quantity;
    END IF;
  END //
DELIMITER ;