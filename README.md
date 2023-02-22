# Introduction

Our main goal is to create a web-based application with created
relational database (using MariaDB dialect) for the imaginary alcoholic
beverage warehouse called *MOCNY FULL*. We strongly believe that this
software will be a time-saving solution for employees working in the
retail sector.

# Requirements

Since it has to be a user-friendly app, we decided to obtain a
high-quality front-end with Flask framework in Python 3.8 for the best
UX. The database will be stored in MySQL Server and would be resistant
to SQL injection attacks and the robustness against SQL injection will
be provided. More details are described in the next sections.

# Users

The app will provide four levels of access for users:

-   `admin` -- has the access to the whole `liquors_warehouse` database
    with all tables, procedures and functions, can also use `LOCK`,
    `DROP`, `CREATE`, `ALTER` tables, use the command-line statement to
    create a backup for the table and can access all views -- in the
    application, there will be a button for creating a backup of the
    database and restoring the database using *mysqldump*,

-   `manager` -- is able to `SELECT`, `INSERT`, `UPDATE`, `DELETE` on
    `liquors_warehouse` database excluding users table, can access all
    procedures, functions and views,

-   `workers` -- is able to `SELECT`, `INSERT`, `UPDATE` on
    `liquors_warehouse` database excluding users and workers tables, can
    access all procedures except `update_sales` and `update_supplies`,
    has access to all functions except `worker_already_exists`,
    `client_already_exists` `supplier_already_exists` and can access all
    views,

-   `clients` -- can call `show_sales_for_client` and
    `show_sales_for_client_product` procedures,

-   `suppliers` -- can call `show_sales_for_supplier` and
    `show_sales_for_supplier_product` procedures.

# Database

The data for `beers`, `liquors` and `wines` tables are scrapped from
[WikiliQ](https://wikiliq.org/) website and categorized accordingly. The
rest of the data was generated using *Faker* library and self-written
functions in Python. The database is stored in MySQL Server.

## Tables

Our database will consist of 12 tables which are depicted on Fig.
[1](#uml){reference-type="ref" reference="uml"}. The database schema was
designed to fulfill 2NF or 3NF depending on their type. The following
tables are:

-   containing users details:

    -   `users` -- contains login and password credentials with the type
        of the account (*admin*, *manager*, *worker*, *supplier* or
        *client*),

    -   `suppliers` -- contains details about the supplier such as
        company, name or NIP number etc.,

    -   `clients` -- contains details about the customer,

    -   `workers` -- contains info about employees including *admin* and
        *manager* accounts,

-   containing products info:

    -   `products` -- contains details about the product name and its
        type (*beer*, *wine*, *liquor*) with the price and quantity and
        abv- (alcohol by volume),

    -   `beers` -- contains details about the beer,

    -   `wines` -- contains details about the wine,

    -   `liquors` -- contains details about the liquor,

-   containing orders and deliveries info:

    -   `sales` -- contains the sale's date with the customer's ID and
        tells if the order was completed or not,

    -   `sales_info` -- contains details about the products that were
        ordered with their quantities,

    -   `supplies` -- contains the supply's date with the supplier's ID
        and tells if the supply was done or not,

    -   `supplies_info` -- contains details about the products supplied
        with their quantities.

![UML diagram generated in MySQL Workspace.](https://github.com/jan-sebastian-dzban/MOCNY-FULL-Database/blob/main/UML.pdf)

## Views and Prepared Statements

For privacy purposes, we are planning to create prepared statements and
targeted views for a specific user, so they would be able to see their
deliveries or orders accordingly. They would be also used for dynamic
query builders, so the users wouldn't have to type an SQL query by hand.

-   `sale_summary` -- groups sales info into one record by *sale_id*. It
    shows the summary of the sale with the customer's name, if it's
    completed or not, total value, etc.,

-   `supply_summary` -- groups supplies info into one record by
    *supply_id*. It shows the summary of the supply.

-   ...(work in progress)

## Functions

The functions that were created will be used to check any possible
issues that can be faced by any user of this database which are:

-   `beer_already_exists`, `wine_already_exists`,
    `liquor_already_exists` -- these functions check whether a specific
    alcoholic beverage already exists in the database,

-   `worker_already_exists`, `client_already_exists`,
    `supplier_already_exists` -- these functions check whether a
    specific user already exists in the database,

-   `email_is_valid` -- checks if the typed e-mail has the *@* sign,

-   `nip_is_valid` -- checks if the length of the NIP is equal to 10,

-   `quantity_on_date` -- calculates the quantity of a specific product
    on the chosen date to forecast the future quantity of the product
    after an order is made but not done yet.

## Procedures

-   `add_product` -- adds a new alcoholic beverage to the database using
    transactions,

-   `add_beer`, `add_wine`, `add_liquor` -- adds new *beer*, *wine* or
    *liquor* to the database,

-   `inner_add_beer`, `inner_add_wine`, `inner_add_liquor` -- adds
    *beer*, *wine* or *liquor* to the right table,

-   `add_user_all` -- adds new user (*worker*, *client* or *supplier*)
    to the database using transactions,

-   `inner_add_worker`, `inner_add_client`, `inner_add_supplier` -- adds
    *worker*, *client* or *supplier* to the right table,

-   `update_sale` -- updates [done]{.sans-serif} field to 1 in *sales*
    table,

-   `update_supply` -- updates [done]{.sans-serif} field to 1 in
    *supplies* table,

-   `show_sales_for_client` -- shows the customer's order for the given
    client's ID,

-   `show_sales_for_client_product` -- shows the customer's order for
    the given client's ID with a filter on the product's ID,

-   `show_sales_for_supplier` -- shows supplier's order for given
    supplier's ID,

-   `show_sales_for_client_product` -- shows the supplier's order for
    the given supplier's ID with a filter on the product's ID.

## Triggers

-   `clients_insert`, `suppliers_insert`, `workers_insert` -- creates a
    trigger when the e-mail or NIP is typed with a mistake,

-   `update_products`, `delete_products` -- updates/deletes selected
    product,

-   `update_quantity_sales`, `update_quantity_supplies` -- updates the
    quantity of a product when a new order (subtraction) or supply
    (addition) is made.
