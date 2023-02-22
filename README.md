Databases and Information Management – final project’s design

Szymon Kowalczyk Anna Kudela

January 2023

1  Introduction

Our main goal is to create a web-based application with created relational database (using MariaDB dialect) for the imaginary alcoholic beverage ware- house called MOCNY FULL. We strongly believe that this software will be a time-saving solution for employees working in the retail sector.

2  Requirements

Since it has to be a user-friendly app, we decided to obtain a high-quality front- end with Flask framework in Python 3.8 for the best UX. The database will be stored in MySQL Server and would be resistant to SQL injection attacks and the robustness against SQL injection will be provided. More details are described in the next sections.

3  Users

The app will provide four levels of access for users:

- admin – has the access to the whole liquors~~ warehouse database with all tables, procedures and functions, can also use LOCK, DROP, CREATE, ALTERtables, use the command-line statement to create a backup for the

table and can access all views – in the application, there will be a button

for creating a backup of the database and restoring the database using mysqldump,

- manager – is able to SELECT, INSERT, UPDATE, DELETEon liquors~~ warehouse database excluding users table, can access all procedures, functions and views,
- workers – is able to SELECT, INSERT, UPDATEon liquors~~ warehouse

database excluding users and workers tables, can access all procedures

except update~~ sales and update~~ supplies, has access to all functions ex-

cept worker~~ already~~ exists, client~~ already~~ exists supplier~~ already~~ exists

and can access all views,

- clients – can call show~~ sales~~ for~~ client and show~~ sales~~ for~~ client~~ product procedures,
- suppliers – can call show~~ sales~~ for~~ supplier and show~~ sales~~ for~~ supplier~~ product procedures.
4  Database

The data for beers, liquors and wines tables are scrapped from W[ikiliQ web- ](https://wikiliq.org/)site and categorized accordingly. The rest of the data was generated using Faker library and self-written functions in Python. The database is stored in MySQL Server.

1. Tables

Our database will consist of 12 tables which are depicted on Fig. 1. [The ](#_page3_x223.03_y630.50)database schema was designed to fulfill 2NF or 3NF depending on their type. The following tables are:

- containing users details:
- users – contains login and password credentials with the type of the account (admin, manager, worker, supplier or client ),
- suppliers – contains details about the supplier such as company, name or NIP number etc.,
- clients – contains details about the customer,
- workers – contains info about employees including admin and man- ager accounts,
- containing products info:
- products – contains details about the product name and its type (beer, wine, liquor ) with the price and quantity and abv- (alcohol by volume),
- beers – contains details about the beer,
- wines – contains details about the wine,
- liquors – contains details about the liquor,
- containing orders and deliveries info:
- sales – contains the sale’s date with the customer’s ID and tells if the order was completed or not,
- sales~~ info – contains details about the products that were ordered with their quantities,
- supplies – contains the supply’s date with the supplier’s ID and tells if the supply was done or not,
- supplies~~ info – contains details about the products supplied with their quantities.
2. Views and Prepared Statements

For privacy purposes, we are planning to create prepared statements and tar- geted views for a specific user, so they would be able to see their deliveries or orders accordingly. They would be also used for dynamic query builders, so the users wouldn’t have to type an SQL query by hand.

- sale~~ summary – groups sales info into one record by sale~~ id. It shows the summary of the sale with the customer’s name, if it’s completed or not, total value, etc.,
- supply~~ summary – groups supplies info into one record by supply~~ id. It shows the summary of the supply.
- ...(work in progress)
3. Functions

The functions that were created will be used to check any possible issues that can be faced by any user of this database which are:

- beer~~ already~~ exists , wine~~ already~~ exists , liquor~~ already~~ exists – these functions check whether a specific alcoholic beverage already exists in the database,
- worker~~ already~~ exists , client~~ already~~ exists , supplier~~ already~~ exists
  - these functions check whether a specific user already exists in the database,
- email~~ is~~ valid – checks if the typed e-mail has the @ sign,
- nip~~ is~~ valid – checks if the length of the NIP is equal to 10,
- quantity~~ on~~ date – calculates the quantity of a specific product on the chosen date to forecast the future quantity of the product after an order is made but not done yet.
- **beers wines ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.001.png) liquors![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.002.png)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.003.png)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.001.png)**
  - product\_id INT(11) product\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.003.png)product\_id INT(11)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)
    - brewery VARCHAR(50) name VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)name VARCHAR(50)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)
    - name VARCHAR(50) brand VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)brand VARCHAR(50)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)
    - type VARCHAR(50) abv FLOAT ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)abv FLOAT![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)
    - abv FLOAT type ENUM(...) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)type ENUM(...)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)
    - capacity INT(10) capacity INT(10) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)capacity INT(10)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)
    - category VARCHAR(50) category VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)category VARCHAR(50)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)
    - country VARCHAR(50) country VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)country VARCHAR(50) **Indexes Indexes Indexes**
      - **products**
        - product\_id INT(11)
          - name VARCHAR(50)
          - type ENUM(...)
          - capacity INT(10)
          - abv FLOAT
          - price DECIMAL(5,2) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.001.png)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.001.png)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.001.png)![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.001.png)

**sales sales\_info supplies\_info supplies![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)**

quantity INT(10) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.005.png)

- sale\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.005.png)id INT(11) **Indexes ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.005.png)**id INT(11) supply\_id INT(11)
  - sale\_date DATE ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.006.png)product\_id INT(11) **Triggers ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.006.png)**product\_id INT(11) supply\_date DATE![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)
    - client\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.006.png)sale\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.006.png)supply\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.006.png)supplier\_id INT(11)
  - done TINYINT(1) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)quantity INT(10) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)quantity INT(10) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)done TINYINT(1) **Indexes Indexes Indexes Indexes**
- **clients ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.001.png) workers ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.001.png) suppliers**
  - client\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.005.png)worker\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.005.png)supplier\_id INT(11)
    - user\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.007.png)user\_id INT(11) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.007.png)user\_id INT(11)
      - name VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)name VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)company VARCHAR(50)
      - pesel CHAR(10) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)pesel CHAR(10) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)name VARCHAR(50)
      - address VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)address VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)nip CHAR(10)
      - phone\_number VARCHAR(20) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)phone\_number VARCHAR(20) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)address VARCHAR(50)
      - email VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)email VARCHAR(50) ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)phone\_number VARCHAR(20) **Indexes Indexes ![](Aspose.Words.d43e8bc6-8b6c-4d58-8027-fd2e1718f241.004.png)**email VARCHAR(50)

**Indexes**

- **users**
  - user\_id INT(11)
    - login VARCHAR(50)
    - password VARCHAR(255)
    - seed INT(11)
    - type ENUM(...)

**Indexes**

Figure 1: UML diagram generated in MySQL Workspace.

4. Procedures
- add~~ product – adds a new alcoholic beverage to the database using trans- actions,
- add~~ beer , add~~ wine, add~~ liquor – adds new beer, wine or liquor to the database,
- inner~~ add~~ beer , inner~~ add~~ wine, inner~~ add~~ liquor – adds beer, wine or liquor to the right table,
- add~~ user~~ all – adds new user ( worker, client or supplier ) to the database using transactions,
- inner~~ add~~ worker , inner~~ add~~ client , inner~~ add~~ supplier – adds worker, client or supplier to the right table,
- update~~ sale – updates done field to 1 in sales table,
- update~~ supply – updates done field to 1 in supplies table,
- show~~ sales~~ for~~ client – shows the customer’s order for the given client’s ID,
- show~~ sales~~ for~~ client~~ product – shows the customer’s order for the given client’s ID with a filter on the product’s ID,
- show~~ sales~~ for~~ supplier – shows supplier’s order for given supplier’s ID,
- show~~ sales~~ for~~ client~~ product – shows the supplier’s order for the given supplier’s ID with a filter on the product’s ID.
5. Triggers
- clients~~ insert , suppliers~~ insert , workers~~ insert – creates a trigger when the e-mail or NIP is typed with a mistake,
- update~~ products , delete~~ products – updates/deletes selected product,
- update~~ quantity~~ sales , update~~ quantity~~ supplies – updates the quan- tity of a product when a new order (subtraction) or supply (addition) is made.
5
