Drop PROCEDURE show_suppliers ;
DELIMITER //
CREATE PROCEDURE show_suppliers(IN in_supplier_id INT)
BEGIN
SELECT si.id,s.supplier_id,p.name,si.product_id,p.price,p.quantity
  FROM supplies_info si JOIN suppliers s ON si.supply_id = s.supplier_id JOIN products p ON si.product_id=p.product_id
  WHERE s.supplier_id = in_supplier_id;
END //
DELIMITER ;

CALL show_suppliers(1);



Drop PROCEDURE show_suppliers_product ;
DELIMITER //
CREATE PROCEDURE show_suppliers_product(IN in_product_id INT,IN in_supplier_id INT)
BEGIN
SELECT si.id,s.supplier_id,p.name,si.product_id,p.price,p.quantity
  FROM supplies_info si JOIN suppliers s ON si.supply_id = s.supplier_id JOIN products p ON si.product_id=p.product_id
  WHERE s.supplier_id = in_supplier_id and si.product_id = in_product_id;
END //
DELIMITER ;

CALL show_suppliers_product(34,1);

