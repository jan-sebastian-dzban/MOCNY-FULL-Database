DELIMITER //
CREATE FUNCTION quantity_on_date(in_product_id INT, in_date DATE) RETURNS INT
BEGIN
  DECLARE supplied INT;
  DECLARE sold INT;

  IF in_date < DATE(now()) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter future date';
  END IF;

  SELECT SUM(quantity)
  FROM supplies_info si JOIN supplies s ON si.supply_id = s.supply_id
  WHERE si.product_id = in_product_id AND
        (supply_date BETWEEN NOW() AND in_date AND
        NOT done) OR (si.product_id = in_product_id AND NOT done)
  INTO supplied;

  SELECT SUM(quantity)
  FROM sales_info si JOIN sales s ON si.sale_id = s.sale_id
  WHERE si.product_id = in_product_id AND
        sale_date BETWEEN NOW() AND in_date AND
        NOT done
  INTO sold;

  IF sold IS NULL THEN
    SET sold = 0;
  END IF;

  IF supplied IS NULL THEN
    SET supplied = 0;
  END IF;

  RETURN (SELECT quantity + supplied - sold
  FROM products
  WHERE product_id = in_product_id);
END //
DELIMITER ;
set @X= quantity_on_date(1, '2023-11-25');
select @X;