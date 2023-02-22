DELIMITER //
CREATE TRIGGER delete_products AFTER DELETE ON products FOR EACH ROW
  BEGIN
    DELETE FROM beers WHERE beers.product_id = OLD.product_id;
    DELETE FROM liquors WHERE liquors.product_id = OLD.product_id;
    DELETE FROM wines WHERE wines.product_id = OLD.product_id;
  END //
DELIMITER ;


drop TRIGGER update_products;
DELIMITER //
CREATE TRIGGER update_products AFTER UPDATE ON products FOR EACH ROW
  BEGIN
	UPDATE beers SET beers.name=NEW.name , beers.abv=NEW.abv WHERE beers.product_id = OLD.product_id;
    UPDATE liquors SET liquors.name=NEW.name, liquors.abv=NEW.abv WHERE liquors.product_id = OLD.product_id;
    UPDATE wines SET wines.name=NEW.name , wines.abv=NEW.abv WHERE wines.product_id = OLD.product_id;
  END //
DELIMITER ;
UPDATE products
SET name = 'beer_update3'
WHERE product_id = 1;
select  * from beers;
select * from products;