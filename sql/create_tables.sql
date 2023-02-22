CREATE DATABASE liquors_warehouse;
drop database liquors_warehouse;
USE liquors_warehouse;

# creating tables

CREATE TABLE products (
  product_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name       varchar(50),
  type       enum ('beer', 'liquor', 'wine'),
  capacity   int UNSIGNED,
  abv        float UNSIGNED,
  price      decimal(5, 2) UNSIGNED,
  quantity   int UNSIGNED
);

CREATE TABLE beers (
  product_id     int NOT NULL PRIMARY KEY,
  brewery        varchar(50),
  name           varchar(50),
  type           varchar(50),
  abv            float UNSIGNED,
  capacity       int UNSIGNED,
  category		 varchar(50),
  country        varchar(50),
  FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
);

CREATE TABLE liquors (
  product_id int NOT NULL PRIMARY KEY,
  name       varchar(50),
  brand	     varchar(50),
  abv        float UNSIGNED,
  type       enum ('vodka', 'whiskey', 'Liqueur'),
  capacity   int UNSIGNED,
  category		 varchar(50),
  country        varchar(50),
  FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
);

CREATE TABLE wines (
  product_id int NOT NULL PRIMARY KEY,
  name       varchar(50),
  brand	     varchar(50),
  abv        float UNSIGNED,
  type           enum ('White', 'Red', 'Rosé ','Sparkling'),
  capacity   int UNSIGNED,
  category		 varchar(50),
  country        varchar(50),

  FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
);

CREATE TABLE users (
  user_id   int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  login    varchar(50) ,
  password varchar(255),
  seed    int,
  type     enum ('admin', 'manager', 'worker','supplier','client')
);

CREATE TABLE suppliers (
  supplier_id       int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id        int NOT NULL,
  company           varchar(50),
  name              varchar(50),
  nip               char(10),
  address		    varchar(50),
  phone_number      varchar(20),
  email             varchar(50),
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE supplies (
  supply_id   int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  supply_date date,
  supplier_id int,
  done        boolean,
  FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id)
);

CREATE TABLE supplies_info (
  id         int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  product_id int,
  supply_id  int,
  quantity   int UNSIGNED,
  FOREIGN KEY (product_id) REFERENCES products (product_id),
  FOREIGN KEY (supply_id) REFERENCES supplies (supply_id) ON DELETE CASCADE
);

CREATE TABLE clients (
  client_id         int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id        	int not null,
  name              varchar(50),
  pesel              char(10),
  address		    varchar(50),
  phone_number      varchar(20),
  email             varchar(50),
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE sales (
  sale_id   int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  sale_date date,
  client_id int,
  done      boolean,
  FOREIGN KEY (client_id) REFERENCES clients (client_id)
);

CREATE TABLE sales_info (
  id         int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  product_id int,
  sale_id    int,
  quantity   int UNSIGNED,
  FOREIGN KEY (product_id) REFERENCES products (product_id),
  FOREIGN KEY (sale_id) REFERENCES sales (sale_id) ON DELETE CASCADE
);
