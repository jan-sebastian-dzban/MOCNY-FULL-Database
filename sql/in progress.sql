SELECT si.sale_id,
    SUM(si.quantity * p.price) total
FROM sales_info si JOIN sales s ON si.sale_id = s.sale_id JOIN products p ON si.product_id=p.product_id
WHERE s.client_id = 1 GROUP BY si.sale_id;