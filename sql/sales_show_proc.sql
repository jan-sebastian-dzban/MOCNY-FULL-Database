Drop PROCEDURE show_sales_for_client ;
DELIMITER //
CREATE PROCEDURE show_sales_for_client(IN in_client_id INT)
BEGIN
SELECT si.id,s.sale_id,s.sale_date,s.done,p.name,si.product_id,p.price,p.quantity
  FROM sales_info si JOIN sales s ON si.sale_id = s.sale_id JOIN products p ON si.product_id=p.product_id
  WHERE s.client_id = in_client_id order by s.sale_date;
END //
DELIMITER ;

CALL show_sales_for_client(1);

Drop PROCEDURE show_sales_for_client_product ;
DELIMITER //
CREATE PROCEDURE show_sales_for_client_product(IN in_product_id INT,IN in_client_id INT)
BEGIN
SELECT si.id,s.sale_id,s.sale_date,s.done,p.name,si.product_id,p.price,p.quantity
  FROM sales_info si JOIN sales s ON si.sale_id = s.sale_id JOIN products p ON si.product_id=p.product_id
  WHERE s.client_id = in_client_id and si.product_id = in_product_id;
END //
DELIMITER ;

CALL show_sales_for_client_product(14,38);

