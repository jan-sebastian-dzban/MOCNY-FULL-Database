drop user 'guest'@'localhost';
create user 'guest'@'localhost';
set password for 'guest'@'localhost' = PASSWORD('guestpassword');

drop user 'client'@'localhost';
create user 'client'@'localhost';
set password for 'client'@'localhost' = PASSWORD('cilentpassword');

drop user 'supplier'@'localhost';
create user 'supplier'@'localhost';
set password for 'supplier'@'localhost' = PASSWORD('supplierpassword');

drop user 'worker'@'localhost';
create user 'worker'@'localhost';
set password for 'worker'@'localhost' = PASSWORD('workerpassword');

drop user 'manager'@'localhost';
create user 'manager'@'localhost';
set password for 'manager'@'localhost' = PASSWORD('managerpassword');

drop user 'admin'@'localhost';
create user 'admin'@'localhost';
set password for 'admin'@'localhost' = PASSWORD('adminpassword');

drop user 'app'@'localhost';
create user 'app'@'localhost';
set password for 'app'@'localhost' = PASSWORD('apppassword');

drop role guest;
drop role supplier;
drop role  client;
drop role  worker;
drop role  manager;
drop role  admin;

CREATE ROLE IF NOT EXISTS guest;
CREATE ROLE IF NOT EXISTS supplier;
CREATE ROLE IF NOT EXISTS client;
CREATE ROLE IF NOT EXISTS worker;
CREATE ROLE IF NOT EXISTS manager;
CREATE ROLE IF NOT EXISTS admin;

#GRANT worker TO client;
#GRANT worker TO supplier;
#GRANT worker TO manager;
#GRANT manager TO admin;

GRANT guest TO `guest`@`localhost`;
GRANT client TO `client`@`localhost`;
GRANT supplier TO `supplier`@`localhost`;
GRANT manager TO `manager`@`localhost`;
GRANT worker TO `worker`@`localhost`;
GRANT admin TO `admin`@`localhost`;

SET DEFAULT ROLE guest FOR `guest`@`localhost`;
SET DEFAULT ROLE client FOR `client`@`localhost`;
SET DEFAULT ROLE supplier FOR `supplier`@`localhost`;
SET DEFAULT ROLE worker FOR `worker`@`localhost`;
SET DEFAULT ROLE manager FOR `manager`@`localhost`;
SET DEFAULT ROLE admin FOR `admin`@`localhost`;

#guest
GRANT EXECUTE ON FUNCTION liquors_warehouse.if_user_data_valid_return_seed TO guest;
GRANT EXECUTE ON FUNCTION liquors_warehouse.if_user_data_valid_return_role TO guest;
GRANT EXECUTE ON FUNCTION liquors_warehouse.if_user_data_valid_return_role TO id;
GRANT SELECT, INSERT ON liquors_warehouse.loggings TO guest;

#client
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_sales_for_client_product TO client;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_sales_for_client TO client;

#supplier
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_suppliers_product TO supplier;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_suppliers TO supplier;

#worker (no users, workers, proc no update_sale, update_supply)
GRANT SELECT ON liquors_warehouse.sale_summary TO worker;
GRANT SELECT ON liquors_warehouse.supplier_summary TO worker;

GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_beer TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_liqour TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_product TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_wine TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_beer TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_liqour TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_wine TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_sales_for_client_product TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_sales_for_client TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_suppliers_product TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_suppliers TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_sale TO worker;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_supply TO worker;

GRANT EXECUTE ON FUNCTION liquors_warehouse.beer_already_exists TO worker;
GRANT EXECUTE ON FUNCTION liquors_warehouse.liqour_already_exists TO worker;
GRANT EXECUTE ON FUNCTION liquors_warehouse.wine_already_exists TO worker;
GRANT EXECUTE ON FUNCTION liquors_warehouse.email_is_valid TO worker;
GRANT EXECUTE ON FUNCTION liquors_warehouse.nip_is_valid TO worker;

SELECT CONCAT("GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.", table_name, " TO worker;")
FROM information_schema.TABLES
WHERE table_schema = "liquors_warehouse" AND table_name <> "users" AND table_name <> "workers";

GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.beers TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.clients TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.liquors TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.products TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.sales TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.sales_info TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.suppliers TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.supplies TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.supplies_info TO worker;
GRANT SELECT, INSERT, UPDATE ON liquors_warehouse.wines TO worker;


#manager (no users)
GRANT SELECT ON liquors_warehouse.sale_summary TO manager;
GRANT SELECT ON liquors_warehouse.supplier_summary TO manager;

GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_beer TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_liqour TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_product TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_wine TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_beer TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_liqour TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_wine TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_sales_for_client_product TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_sales_for_client TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_suppliers_product TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_suppliers TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_sale TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_supply TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_user TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_user_all TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_client TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_worker TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_supplier TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_sale TO manager;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_supply TO manager;

GRANT EXECUTE ON FUNCTION liquors_warehouse.client_already_exists TO manager;
GRANT EXECUTE ON FUNCTION liquors_warehouse.supplier_already_exists TO manager;
GRANT EXECUTE ON FUNCTION liquors_warehouse.worker_already_exists TO manager;
GRANT EXECUTE ON FUNCTION liquors_warehouse.beer_already_exists TO manager;
GRANT EXECUTE ON FUNCTION liquors_warehouse.liqour_already_exists TO manager;
GRANT EXECUTE ON FUNCTION liquors_warehouse.wine_already_exists TO manager;
GRANT EXECUTE ON FUNCTION liquors_warehouse.email_is_valid TO manager;
GRANT EXECUTE ON FUNCTION liquors_warehouse.nip_is_valid TO manager;


GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.beers TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.clients TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.liquors TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.products TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.sales TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.sales_info TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.suppliers TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.supplies TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.supplies_info TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.workers TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.wines TO manager;


#admin (all)
GRANT SELECT ON liquors_warehouse.sale_summary TO admin;
GRANT SELECT ON liquors_warehouse.supplier_summary TO admin;

GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_sale TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_supply TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_beer TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_liqour TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_product TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_wine TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_beer TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_liqour TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_wine TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_sales_for_client_product TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_sales_for_client TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_suppliers_product TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.show_suppliers TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_sale TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.update_supply TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_user TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_user_all TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_client TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_worker TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_supplier TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_user TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_worker TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_supplier TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.inner_add_client TO admin;
GRANT EXECUTE ON PROCEDURE liquors_warehouse.add_user_all TO admin;







GRANT EXECUTE ON FUNCTION liquors_warehouse.client_already_exists TO admin;
GRANT EXECUTE ON FUNCTION liquors_warehouse.supplier_already_exists TO admin;
GRANT EXECUTE ON FUNCTION liquors_warehouse.worker_already_exists TO admin;
GRANT EXECUTE ON FUNCTION liquors_warehouse.beer_already_exists TO admin;
GRANT EXECUTE ON FUNCTION liquors_warehouse.liqour_already_exists TO admin;
GRANT EXECUTE ON FUNCTION liquors_warehouse.wine_already_exists TO admin;
GRANT EXECUTE ON FUNCTION liquors_warehouse.email_is_valid TO admin;
GRANT EXECUTE ON FUNCTION liquors_warehouse.nip_is_valid TO admin;


SELECT CONCAT("GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.", table_name, " TO admin;")
FROM information_schema.TABLES
WHERE table_schema = "liquors_warehouse" ;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.beers TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.clients TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.liquors TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.products TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.sales TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.sales_info TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.suppliers TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.supplies TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.supplies_info TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.users TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.wines TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON liquors_warehouse.workers TO admin;


#those are needed for backup & restore functionallity
GRANT SELECT, LOCK TABLES ON  liquors_warehouse.* TO 'admin'@'localhost';
GRANT DROP, CREATE, ALTER ON  liquors_warehouse.* TO 'admin'@'localhost';
GRANT SUPER ON *.* TO 'admin'@'localhost';
GRANT SELECT on  liquors_warehouse.users TO 'app'@'localhost';