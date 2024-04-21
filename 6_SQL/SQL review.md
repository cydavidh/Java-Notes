1. **Statements**: Text recognized by the database engine as a valid command (e.g., `SELECT`, `INSERT`, `CASE`).
2. **Clauses**: Components of statements and queries (e.g., `WHERE`, `FROM`, `ELSE`).
3. **Conditions**: Boolean expressions that evaluate to true or false to filter results (used in clauses like `WHERE`).
4. **Expressions**: Combinations of symbols and operators that the database evaluates to produce a result (e.g., `'Hello, ' || 'World!'`, `age > 21`).
5. **Predicates**: Used to limit the effects of a statement or query based on conditions (e.g., `BETWEEN`, `LIKE`).
6. **Functions**: Built-in operations for calculations, string manipulation, date handling, etc. (e.g., `COUNT()`, `NOW()`).
7. **Operators**: Symbols specifying computation types (arithmetic +,-,*,/,%; comparison =,!=,<>,>,>=,<,<=; logical AND,OR,NOT; string ||; bitwise &,|,^,~).
8. **Identifiers**: Names of database objects like tables and columns.
9. **Data types**: Definitions for types of data (e.g., `INTEGER`, `VARCHAR`).
10. **Transactions**: Sequences of operations as a single logical unit of work (`BEGIN`, `COMMIT`).
11. **Constraints**: Rules applied to table columns to enforce data integrity (e.g., `PRIMARY KEY`, `CHECK`).
12. **Subqueries**: Queries nested inside another query.
13. **Joins**: Operations combining rows from two or more tables.
14. **Views**: Virtual tables based on the result-set of a SQL statement.
15. **Indexes**: Structures to speed up retrieval of records.
16. **Comments**: Explanations or block-outs of SQL statements.
17. **Variables**: Storages for data used in SQL queries and procedures.
==========================================================================
**use ' single quotes for string literals and " double quotes for identifiers**
especially if identifiers contain spaces or are case-sensitive
'movies'
"Employee_ID"
==========================================================================
**all data types**
```sql
CREATE TABLE census (
    id INTEGER, --or INT
    name VARCHAR(20),
    birth_place_latitude REAL,
    salary FLOAT,
    year_income DECIMAL(20,2), --20 total, 2 decimal.
    is_parent BOOLEAN
);
```
**string literal**
```sql
SELECT 'Hello, World!';
```
==========================================================================
# CREATE database
```sql
CREATE DATABASE students;
```
# DROP database
```sql
DROP DATABASE students; 
```
# CREATE table
```sql
CREATE TABLE students_info ( 
    student_id INT, 
    name VARCHAR(30), 
    surname VARCHAR(30), 
    age INT
);
```
# DROP table
```sql
DROP TABLE students_info; 
```
=================================================================
# tuple = row
row = tuple = record = a row in the table
```sql
SELECT 'Alice', 170, 170*0.393701;
```
this gives you a tuple with the values 'Alice', 170, and 66.92917.
=================================================================
# AS
alias = column name OR table name
**column name**
```sql
SELECT 
  'Alice' AS name, 
  170 AS height_in_centimeters, 
  170*0.393701 AS "height in inches"
;
```
result is 
----------------------------------------------------
name  | height_in_centimeters | height_in_inches
Alice | 170                   | 66.9
----------------------------------------------------
**table name** useful when joining
```sql
SELECT e.name, d.name 
FROM employees AS e 
JOIN departments AS d 
ON e.department_id = d.id;.
```
================================================================
**projection: selecting a subset of table columns**
================================================================
**comparison operators**
= instead of ==
!< not less than
<>, != not equal
status and skills are column names 
===============================================================
# WHERE
```sql
SELECT * --all columns
FROM products --table name
WHERE price > 250
```
================================================================
# NOT(!)
```sql
SELECT *
FROM staff --table name
WHERE NOT(status="Junior");
```
# AND, OR
```sql
SELECT *
FROM staff --table name
WHERE NOT(status="Junior") AND skills="SQL" AND (status="Middle" OR status="Senior"); --status and skills are column names 
```
================================================================
# NULL
null is unknown, neither true or false
```sql
CREATE TABLE winners ( 
    year INTEGER NOT NULL,
    field VARCHAR(20) NOT NULL, 
    winner_name VARCHAR(100) NOT NULL, 
    winner_birth_year INTEGER);
```
**comparing NULL**
will evaluate to NULL
```java
NULL = 1
NULL <> 1
NULL > 1
NULL = '1'
NULL = NULL
NULL != NULL
```
# IS NULL
# IS NOT NULL
will evaluate to true or false
```sql
SELECT 0+NULL IS NULL; 
SELECT '' IS NOT NULL;
SELECT NULL IS NOT NULL;
SELECT 1-1 IS NULL;
```
================================================================
# CASE
# CASE WHEN THEN
**simple CASE**
syntax
```sql
CASE expression 
  WHEN value1 THEN result1 
  WHEN value2 THEN result2 
  ...
  ELSE resultN 
END
```
suppose 1 is DepartmentID for sales.
```sql
SELECT 
   Name, 
   CASE DepartmentID 
     WHEN 1 THEN 'Sales' 
     WHEN 2 THEN 'Marketing' 
     WHEN 3 THEN 'Finance'
     ELSE 'Other' 
   END AS Department 
FROM Employees;
```
**searched CASE**
syntax
```sql
CASE 
  WHEN condition1 THEN result1 
  WHEN condition2 THEN result2 
  ...
  ELSE resultN 
END
```
example
```sql
SELECT 
    id, name, price AS before,
    CASE
        WHEN price > 60 THEN price * 1.20
        WHEN price BETWEEN 40 AND 60 THEN price * 1.15
        WHEN price < 40 THEN price * 1.10
    END AS after
FROM Products;
```
example 2
```sql
SELECT
    StudentName,
    Score,
    CASE
        WHEN Score >= 90 THEN 'A'
        WHEN Score >= 80 THEN 'B'
        WHEN Score >= 70 THEN 'C'
        WHEN Score >= 60 THEN 'D'
        ELSE 'F'
    END AS Grade
FROM
    ExamScores;
```
================================================================
# BETWEEN
```sql
SELECT
    product 
FROM
    products 
WHERE 
    price BETWEEN 8 AND 13; --WHERE price NOT BETWEEN 8 AND 13;  --WHERE (price >= 8 AND price <= 13); 
```
result
```
product
-----------
milk
pasta
bread
```
# IN
```sql
WHERE price IN (10, 12, 16); --equal to any one in set
WHERE price NOT IN (10, 12, 16); 
```
# LIKE
string comparison
% means zero, one, or multiple characters
_ means one character
```sql
WHERE product LIKE '%s'; --cars, as, s
WHERE product LIKE 's%'; --sentinels, se, s
WHERE product LIKE '%s%'; --asdf, as, se, s
WHERE product LIKE 's_'; --si
```
# EXISTS
checks if the subquery returns any records(rows) or not
table
```
supplier | product
farmer   | pasta
gardner  | milk
farmer   | milk
gardner  | bread
```
```sql
SELECT DISTINCT --only show one supplier even if that supplier shows many
    supplier 
FROM
    suppliers AS milk_suppliers
WHERE
    product = 'milk'
    AND EXISTS
(SELECT supplier
FROM
    suppliers 
WHERE
    product = 'pasta'
    AND supplier = milk_suppliers.supplier);
```
result
```
supplier
------------
gardner
```
# ANY
```sql
SELECT Name
FROM Employees
WHERE DepartmentID = ANY (SELECT DepartmentID FROM Departments WHERE DepartmentID < 5);
```
if employee DepartmentID match ANY DepartmentID in list produced by subquery (1,2,3,4),
then that employee Name will be in result set.
```sql
SELECT ProductName, Price
FROM Products
WHERE Price < ANY (
    SELECT P.Price
    FROM Products P
    JOIN Orders O ON P.ProductID = O.ProductID
    GROUP BY P.ProductID
    HAVING COUNT(O.OrderID) > 100
);
```
1. inner/subquery: select price of products that was ordered more than 100 times.
2. outer/mainquery: select products with price lower than ANY of the products returned from subquery

The outer query then selects the name and price of products from the Products table where the product's price is less than the price of any product returned by the subquery.
# IS NULL
# IS NOT NULL
```sql
SELECT
    name 
FROM
    persons 
WHERE
    city IS NULL;
```
select the person who's city is null
# IS DISTINCT FROM
same as != not equal
except it works for null
this is basically the NOT EQUAL check for NULL
`NULL != NULL` results in UNKNOWN
`NULL IS DISTINCT FROM NULL` results in FALSE
```sql
SELECT
    * 
FROM
    persons 
WHERE
    city IS DISTINCT FROM 'New-York'; 
```
select all people who's city isn't new york. will show people with NULL cities.
================================================================
# INSERT INTO
```sql
INSERT INTO customers 
VALUES ('Bobby', 'Ray', 60601, 'Chicago');
```
```sql
INSERT INTO customers (name, surname, zip_code, city) 
VALUES ('Mary', 'West', 75201, 'Dallas'), 
       ('Steve', 'Palmer', 33107, 'Miami');
```
columns left blank will be NULL
**copy from one table to another**
customers
+---------------+-----------------------+----------+
| customer      | email                 | zip_code |
+---------------+-----------------------+----------+
| Astoria hotel | hotelastoria@hotel.com| 99501    |
| Pasta Inc     | pasta@inc.com         | 85055    |
+---------------+-----------------------+----------+
users
+----------------+----------------+----------+---------+
| user           | user_email     | zip_code | city    |
+----------------+----------------+----------+---------+
| Tadfield Cinema| tadf@cinema.com| 56567    | Tadfield|
+----------------+----------------+----------+---------+
insert all data from customers into users
```sql
INSERT INTO users (user, user_email, zip_code) 
SELECT * FROM customers; 
```
result users table
+----------------+-----------------------+----------+---------+
| user           | user_email            | zip_code | city    |
+----------------+-----------------------+----------+---------+
| Tadfield Cinema| tadf@cinema.com       | 56567    | Tadfield|
| Astoria hotel  | hotelastoria@hotel.com| 99501    | NULL    |
| Pasta Inc      | pasta@inc.com         | 85055    | NULL    |
+----------------+-----------------------+----------+---------+
**example 2**
suppliers
+-------------+--------+----------------+----------+
| supplier    | city   | supplier_email | zip_code |
+-------------+--------+----------------+----------+
| Tomato Inc  | York   | tomato@inc.uk  | 01904    |
| Potato Inc  | London | potato@inc.uk  | 53342    |
+-------------+--------+----------------+----------+

1. specifies only tomato inc with WHERE
2. changes the order of the columns
```sql
INSERT INTO users --(user, user_email, zip_code, city) 
SELECT 
    supplier, 
    supplier_email,
    zip_code,
    city 
FROM 
    suppliers
WHERE
    supplier = 'Tomato Inc'; 
```
result users table
+----------------+-----------------------+----------+---------+
| user           | user_email            | zip_code | city    |
+----------------+-----------------------+----------+---------+
| Tadfield Cinema| tadf@cinema.com       | 56567    | Tadfield|
| Astoria hotel  | hotelastoria@hotel.com| 99501    | NULL    |
| Pasta Inc      | pasta@inc.com         | 85055    | NULL    |
| Tomato Inc     | tomato@inc.uk         | 01904    | York    |
+----------------+-----------------------+----------+---------+

================================================================
# DELETE FROM
**delete all rows**
```sql
DELETE FROM books; 
```
**delete selected rows**
```sql
DELETE FROM books 
WHERE quantity = 0;
```
================================================================
# ALTER TABLE
**add new column**
```sql
ALTER TABLE employees 
ADD COLUMN employee_email VARCHAR(10);
```
**change column data type**
```sql
ALTER TABLE employees 
MODIFY COLUMN employee_email VARCHAR(45); 
```
**drop column**
```sql
ALTER TABLE employees 
DROP COLUMN native_city; 
```
**rename column**
```sql
ALTER TABLE employees
CHANGE employee_email email VARCHAR(45); 
```
=================================================================
**Constraints**
**All Constraints**
```sql
CREATE TABLE Orders (
    OrderID int NOT NULL,
    CustomerID int NOT NULL,
    OrderDate date NOT NULL,
    ShippingDate date,
    TotalAmount decimal(10, 2) CHECK (TotalAmount >= 0),
    OrderStatus varchar(15) NOT NULL DEFAULT 'Processing',
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    UNIQUE (OrderID),
    CONSTRAINT uq_id_last_name UNIQUE (personal_id, last_name) ,
    CHECK (OrderDate <= ShippingDate),
    CHECK (OrderStatus IN ('Processing', 'Shipped', 'Delivered', 'Cancelled'))
);
```
# PRIMARY KEY
two columns combine to form a primary key
```sql
CREATE TABLE employees (
    department_id INT NOT NULL,
    employee_id INT NOT NULL,
    name varchar(50) NOT NULL,
    CONSTRAINT pk_employee PRIMARY KEY (department_id, employee_id)
); 
```
```sql
ALTER TABLE students
ADD CONSTRAINT pk_student PRIMARY KEY (name,birth_date); 
```
# FOREIGN KEY
# UNIQUE
```sql
ALTER TABLE employees
ADD UNIQUE (personal_id);
```
```sql
-- named constraint
CONSTRAINT uq_id_last_name UNIQUE (personal_id, last_name) 
```
```sql
ALTER TABLE your_table_name
DROP CONSTRAINT constraint_name; --personal_id --uq_id_last_name
```
# DEFAULT
```sql
ALTER TABLE employees
ALTER first_name SET DEFAULT 'John';
```
```sql
ALTER TABLE employees 
ALTER first_name DROP DEFAULT; 
```
# NOT NULL
add NOT NULL constraint
```sql
ALTER TABLE employees
MODIFY age INT NOT NULL;
```
remove constraint
```sql
ALTER TABLE employees
MODIFY age INT;
```
# CHECK
```sql
ALTER TABLE employees 
ADD CONSTRAINT chk_employee CHECK (age > 16 AND personal_id > 0); 
```
```sql
ALTER TABLE employees
DROP CHECK age; 
```
=================================================================
# INDEX
only for MySQL
create at table creation
```sql
CREATE TABLE my_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    column2 VARCHAR(255),
    INDEX idx_column2 (column2)
);
```
create after
```sql
CREATE INDEX idx_customer_name ON customers(name);
```
drop index
```sql
alter table customers
drop index user_id
```
=================================================================
# FOREIGN KEY
departments table
--------------------------------
department_id | department_name 
1             | IT
2             | HR
--------------------------------
**named foreign key**
```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(60) NOT NULL, 
    department_id INT,
    --named
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
    --unnamed, database will generate like `FK__Orders__CustomerI__2C3393D0`
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
); 
```
**Decide what happens to employees when departments data is deleted or updated**
# ON DELETE
# ON UPDATE
**choices**
# CASCADE 
if row in parent table deleted or updated, then also in child
# SET NULL
# RESTRICT
operation to delete or update parent table will be rejected
# NO ACTION
```sql
CREATE TABLE employees (
    employee_id int PRIMARY KEY,
    name VARCHAR(60) NOT NULL, 
    department_id INT,

    CONSTRAINT fk_department FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE

); 
```
=================================================================
# ORDER BY
sort the table by the specified column
```sql
SELECT
    hotel_name, 
    price_per_night*2 + price_for_early_check_in AS total_price,
    rating, 
    stars
FROM 
    hotels
ORDER BY
    total_price ASC,
    CASE WHEN rating > 3 THEN 1 ELSE 0 END DESC; -- this will put the hotel with higher rating than 3 before the others with lower rating.
```
=================================================================
Employees
EmployeeName | DepartmentID
David        | 1
Sam          | 3
Bro          | NULL
Departments
DepartmentID | DepartmentName
1            | IT
2            | Accounting
NULL         | HR

# INNER JOIN
only if both have corresponding values in both tables
```sql
SELECT *
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;
```
EmployeeName | DepartmentID | DepartmentName
David        | 1            | IT

# NATURAL JOIN
inner join without hassle of specifying column names with ON.
```sql
SELECT *
FROM Employees
NATURAL JOIN Departments;
```
EmployeeName | DepartmentID | DepartmentName
-------------|--------------|----------------
David        | 1            | IT


# FULL OUTER JOIN
has everything
```sql
SELECT *
FROM Employees
FULL OUTER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;
```
EmployeeName | DepartmentID | DepartmentName
David        | 1            | IT
Sam          | 3            | NULL
Bro          | NULL         | NULL
NULL         | 2            | Accounting
NULL         | NULL         | HR

# LEFT JOIN
have all of the employees but not departments
```sql
SELECT *
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;
```
EmployeeName | DepartmentID | DepartmentName
David        | 1            | IT
Sam          | 3            | NULL
Bro          | NULL         | NULL

# RIGHT JOIN 
have all of the departments but not employees
```sql
SELECT *
FROM Employees
RIGHT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;
```
EmployeeName | DepartmentID | DepartmentName
David        | 1            | IT
NULL         | 2            | Accounting
NULL         | NULL         | HR

# CROSS JOIN
Cartesian product, like everything * everything, like grand swiss
```sql
SELECT *
FROM Employees
CROSS JOIN Departments;
```
EmployeeName | DepartmentID (Employees) | DepartmentID (Departments) | DepartmentName
David        | 1                        | 1                          | IT
David        | 1                        | 2                          | Accounting
David        | 1                        | NULL                       | HR
Sam          | 3                        | 1                          | IT
Sam          | 3                        | 2                          | Accounting
Sam          | 3                        | NULL                       | HR
Bro          | NULL                     | 1                          | IT
Bro          | NULL                     | 2                          | Accounting
Bro          | NULL                     | NULL                       | HR
=================================================================
**joining order is important**
```sql
SELECT val1 [AS name1], ..., valN [AS nameN]
FROM table1 
[type_of_join] JOIN table2 
    ON table1.col_name_table1 = table2.col_name_table2 --see we join table 1 and table 2 
[type_of_join] JOIN table3
    ON table2.col_name_table2 = table3.col_name_table3; -- and table 2 and table 3
```
```sql
SELECT val1 [AS name1], ..., valN [AS nameN]
FROM table1 
[type_of_join] JOIN table3
    ON table2.col_name_table2 = table3.col_name_table3; -- table 2 where??
[type_of_join] JOIN table2 
    ON table1.col_name_table1 = table2.col_name_table2
```
=================================================================
**pay attention to what you want to keep to have null**
```sql
select learners.name, courses.title
from enrollments
right join learners on learners.id = enrollments.learner_id
left join courses on courses.id = enrollments.course_id
```
we want result to have learners who have NULL courses, so we join based on learners as MAIN
```sql
select learners.name, courses.title
from learners
left join enrollment on learners.id = enrollments.learner_id
left join courses on courses.id = enrollments.course_id
```
samething, just base it on the MAIN table you want to have for sure that can have null columns from foreign tables.
=================================================================
# UPDATE ... SET
change departmentid of all the employees to 14
```sql
UPDATE employees 
SET department_id = 14;
```
change all salary +10000
```sql
UPDATE employees 
SET salary = salary + 10000;
```
do it same time
```sql
UPDATE employees 
SET department_id = 14, 
    salary = salary + 10000;
```
complex
```sql
UPDATE employees 
SET salary = floor(0.8 * upper_limit); --upper_limit is another column
--floor is a function
```
```sql
UPDATE Customers 
SET age = (current_date - birth_date) / 365 
WHERE age IS NULL OR age < 18;
```
=================================================================
**functions**
**String Functions**
# CONCAT(string1, string2, ...)
Combines two or more strings into one.
# LENGTH(string)
Returns the length of a string.
# UPPER(string)
Converts a string to upper case.
# LOWER(string)
Converts a string to lower case.
# TRIM(string)
Removes leading and trailing spaces from a string.
# SUBSTRING(string, start, length)
Extracts a substring from a string, starting at a specified position for a certain length.

**Numeric Functions**
# ABS(number)
Returns the absolute value of a number.
# CEIL(number) / CEILING(number)
Rounds a number up to the nearest integer.
# FLOOR(number)
Rounds a number down to the nearest integer.
# ROUND(number, decimals)
Rounds a number to a specified number of decimal places.

**Date and Time Functions**
# CURRENT_DATE
Returns the current date.
# CURRENT_TIME
Returns the current time.
# NOW()
Returns the current date and time.
# DATE_PART('field', date) / EXTRACT(field FROM date)
Extracts a part of the date (e.g., year, month, day).
# YEAR()
Extract year from date.

**Aggregate Functions**
# COUNT(*) / COUNT(column)
Counts the number of rows or non-NULL values in a column.
# SUM(column)
Sums up the values in a column.
# AVG(column)
Calculates the average of the values in a column.
# MIN(column) / MAX(column)
Finds the minimum or maximum value in a column.

**Logical Functions**
# CASE
Allows conditional logic in SQL queries.
# COALESCE(value1, value2, ...)
Returns the first non-NULL value in the list of arguments.
=================================================================
**aggregate funcitons**
# MIN(column name)
# MAX()
```sql
SELECT MAX(price)
FROM stocks;
```
# AVG
# COUNT
doesn't count NULL
# COUNT*
counts NULL
# SUM
```sql
SELECT 
    AVG(price) AS avg_price,
    AVG(yesterday_deals) AS avg_deals 
FROM 
    stocks 
WHERE 
    price > 40;
```
answer
avg_price | avg_deals
68.7333   | 12.5

====================================================================
# DISTINCT
```sql
SELECT COUNT(DISTINCT yesterday_deals)
FROM stocks;
```
============================================================
# GROUP BY
```sql
SELECT
    stock_name, 
    MIN(datetime) AS moment,
    MAX(price) AS maximum
FROM 
    stocks
GROUP BY
    stock_name;
```
stock_name | moment | maximum
WTI | 2019-01-18 23:02 | 89.8
FB | 1998-03-31 04:18 | 63.7
DJI | 2004-05-28 21:09 | 52.7
```sql
SELECT
    stock_name,
    datetime,
    MAX(price)
FROM
    stocks
GROUP BY
    stock_name,  
    datetime;   --this groups by unique combination of stock+time
```
stock_name | datetime            | price
-----------|---------------------|------
WTI        | 2020-05-17 11:00    | 89.8
FB         | 2020-04-11 10:23    | 26.3
WTI        | 2019-01-18 23:02    | 20.9
FB         | NULL                | 15.6
DJI        | 2004-05-28 21:09    | 52.7
FB         | 1998-03-31 04:18    | 63.7
# HAVING
```sql
SELECT
    stock_name,
    datetime,
    MAX(price) AS maximum
FROM
    stocks
GROUP BY 
    stock_name,
    datetime
HAVING
    MAX(price) > 50;
```
similar to WHERE, but for computed aggregations.
================================================================
**order of evaluation**
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY
**overview**
```sql
SELECT [columns], [aggregate_function]([column]) AS [alias]  -- 5. Define columns and aggregation
FROM [table]                -- 1. Specify the table to retrieve data from
WHERE [condition]           -- 2. Filter rows based on a condition
GROUP BY [columns]          -- 3. Group the data by specific columns
HAVING [aggregated_condition] -- 4. Filter groups based on an aggregated condition
ORDER BY [columns] [ASC|DESC]; -- 6. Order the result set
```
==============================================================
**cannot use Aggregate Fuctions in WHERE**
When you use a WHERE clause in a query, SQL evaluates the condition for each row in isolation.
On the other hand, aggregate functions such as AVG, SUM, MAX, MIN, and COUNT perform calculations across a set of rows.
 
That's why you can't use aggregate functions in where clause. 
```sql
WHERE age < AVG(age)
```
You have to create another subquery for the aggregate function. 
```sql
WHERE age < (SELECT AVG(age) FROM Players)
```
==============================================================
**Set Operators**
teachers
| name          | subject   |
|---------------|-----------|
| Ginevra Holmes| Geography |
| Carl Robinson | Math      |
| Tamara Fetch  | IT        |
| Robert Stark  | English   |
staff
| position           | name        |
|--------------------|-------------|
| headmaster         | Tomas Jones |
| deputy head        | Tamara Fetch|
| senior deputy head | Ann Brown   |
# UNION
return no duplicate
```sql
SELECT name FROM teachers 
UNION 
SELECT name FROM staff
```
| name           |
|----------------|
| Ginevra Holmes |
| Carl Robinson  |
| Tamara Fetch   |
| Robert Stark   |
| Tomas Jones    |
| Ann Brown      |
# UNION ALL
```sql
SELECT name FROM teachers 
UNION ALL
SELECT name FROM staff
```
| name           |
|----------------|
| Ginevra Holmes |
| Carl Robinson  |
| Tamara Fetch   |
| Robert Stark   |
| Tomas Jones    |
| Tamara Fetch   |
| Ann Brown      |
# INTERSECT
```sql
SELECT name FROM teachers 
INTERSECT
SELECT name FROM staff
```
| name         |
|--------------|
| Tamara Fetch |
# EXCEPT
# MINUS
first minus second
```sql
SELECT name FROM teachers
EXCEPT -- or MINUS
SELECT name FROM staff
```
| name           |
|----------------|
| Ginevra Holmes |
| Carl Robinson  |
| Robert Stark   |

staff minus teachers
```sql
SELECT name FROM staff
EXCEPT
SELECT name FROM teachers
```
| name       |
|------------|
| Tomas Jones|
| Ann Brown  |
=================================================================
**Date & Time Types:**
# DATE
Stores dates in 'YYYY-MM-DD' format. Range: '1000-01-01' to '9999-12-31'.
```sql
CREATE TABLE events (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(100),
    event_date DATE
);
```
# TIME
Stores time in 'hh:mm:ss' format. Range: '-838:59:59' to '838:59:59'.
# DATETIME
Stores date and time in 'YYYY-MM-DD hh:mm:ss' format. Range: '1000-01-01 00:00:00' to '9999-12-31 23:59:59'.
# TIMESTAMP
Stores date and time, narrower range than DATETIME. Range: '1970-01-01 00:00:01' UTC to '2038-01-19 03:14:07' UTC.
# INTERVAL
Stores the interval between two dates. Two classes: YEAR TO MONTH and DAY TO SECOND.

**Current Date & Time Functions:**
```sql
SELECT CURDATE(); -- Current date
SELECT CURTIME(); -- Current time
SELECT CURRENT_TIMESTAMP(); -- Current date and time
```
**Date & Time Difference:**
```sql
SELECT DATEDIFF('2020-05-15', '2020-05-10'); -- Days difference
SELECT TIMEDIFF('12:00:00', '10:00:00'); -- Time difference
```
**Extracting Date Parts:**
```sql
SELECT EXTRACT(MONTH FROM '2020-11-04'); -- Extracts the month
```
**Adding and Subtracting Dates:**
```sql
SELECT DATE_ADD(CURDATE(), INTERVAL 10 DAY); -- Adds 10 days
SELECT DATE_SUB('1996-11-30', INTERVAL 2 YEAR); -- Subtracts 2 years
```
**Time Zone Conversion:**
```sql
SELECT CONVERT_TZ('2008-05-15 12:00:00','UTC','US/Eastern'); -- Converts time zone
SET time_zone = 'US/Eastern'; -- Set session time zone
```
=================================================================
