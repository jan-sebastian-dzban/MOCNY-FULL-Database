CREATE VIEW sale_summary AS
SELECT si.sale_id, s.client_id, c.name, s.done, s.sale_date,GROUP_CONCAT(p.name) products,
    SUM(si.quantity * p.price) total,GROUP_CONCAT(p.quantity) quantity
FROM sales_info si JOIN sales s ON si.sale_id = s.sale_id  JOIN clients c ON s.client_id = c.client_id JOIN products p ON si.product_id=p.product_id 
 GROUP BY si.sale_id;
select * from sale_summary;


CREATE VIEW supplier_summary AS
SELECT si.supply_id ,s.supplier_id, sr.name, s.done, s.supply_date,GROUP_CONCAT(p.name) products,
    SUM(si.quantity * p.price) total,GROUP_CONCAT(p.quantity) quantity
FROM supplies_info si JOIN supplies s ON si.supply_id = s.supply_id JOIN suppliers sr ON s.supplier_id = sr.supplier_id JOIN products p ON si.product_id=p.product_id
 GROUP BY si.supply_id;