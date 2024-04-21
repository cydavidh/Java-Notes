**subquery**
**subquery nested in SELECT**
registered_users
| username     | sign_up_date |
|--------------|--------------|
| timbrown     | 2012-12-04   |
| awesometomas | 2014-11-06   |
| darlingKate  | 2012-12-04   |
| frMartin     | 2014-07-03   |

users_info
| username     | name        | birth_date |
|--------------|-------------|------------|
| awesometomas | Tomas Jones | 1995-10-07 |
| timbrown     | Tim Brown   | 2000-11-04 |
| frMartin     | Martin Brown| 2002-12-04 |
| darlingKate  | Kate Brown  | 2005-03-03 |

```sql
SELECT *, 
    (SELECT 
         name 
     FROM 
         users_info 
     WHERE 
         username = registered_users.username) AS name 
FROM
    registered_users
```

subquery doesn't run first with a precedence priority. instead it runs alongside outer query row by row. It doesn't return a result set of names first.

result set
| username     | sign_up_date | name        |
|--------------|--------------|-------------|
| timbrown     | 2012-12-04   | Tim Brown   |
| awesometomas | 2014-11-06   | Tomas Jones |
| darlingKate  | 2012-12-04   | Kate Brown  |
| frMartin     | 2014-07-03   | Martin Brown|

- A correlated subquery within a `SELECT` statement runs row by row alongside the outer query, using data from the outer query’s current row (like `username`) to filter its results. 
- This ensures the subquery’s output, such as a `name`, is directly matched to the right `username` from the outer query. 
- Consequently, each row in the result set correctly aligns the `username` from `registered_users` with the corresponding `name` from `users_info`, based on the subquery's execution for that specific row.

====================================================
**subquery in WHERE clause of SELECT**
new_orders table
| id   | product | product_category | quantity | unit_price |
|------|---------|------------------|----------|------------|
| 1234 | table   | furniture        | 10       | 15         |
| 3434 | chair   | furniture        | 15       | 20         |
| 4546 | bed     | furniture        | 12       | 10         |
| 5467 | candle  | decor            | 45       | 40         |
| 3244 | sticker | decor            | 40       | 14         |
| 3456 | frame   | decor            | 34       | 12         |

select all the products with unit price less than the average price of that category
```sql
SELECT 
    id,
    product 
FROM
    new_orders AS newor 
WHERE unit_price < (
    SELECT 
        AVG(unit_price) 
    FROM 
        new_orders
    WHERE 
        product_category = newor.product_category);
```
| id   | product |
|-----------------
4546 | bed
3244 | sticker
3456 | frame
==============================================================
**Subquery in WHERE of UPDATE**
students
| name         | scholarship | exams_passed |
|--------------|-------------|--------------|
| Tom Jones    | 200         | FALSE        |
| Tamara Fetch | 400         | FALSE        |
| Anthony Pots | 300         | FALSE        |
exam_results
| name         | math_exam_mark | english_exam_mark |
|--------------|----------------|-------------------|
| Tom Jones    | 22             | 23                |
| Tamara Fetch | 18             | 15                |
| Anthony Pots | 18             | 18                |
update the exam_passed for students who have >= 18 marks to TRUE 
```sql
UPDATE
    students 
SET
    exams_passed = TRUE 
WHERE 
    name IN (
        SELECT
            name
        FROM
            exam_results 
        WHERE
            math_exam_mark >= 18
            AND english_exam_mark >= 18
        ); 
```
updated students
| name         | scholarship | exams_passed |
|--------------|-------------|--------------|
| Tom Jones    | 200         | TRUE         |
| Tamara Fetch | 400         | FALSE        |
| Anthony Pots | 300         | TRUE         |
==============================================================
**Subquery in WHERE of INSERT INTO**
employees
| name    | salary | department_id |
|---------|--------|---------------|
| Ann Reed| 4000   | 1             |
departments
| id | department |
|----|------------|
| 1  | HR         |
| 2  | IT         |
| 3  | PR         |
add to the employees table the info about Tomas Hedwig who works in the PR department and with a salary equal to Ann Reed's salary.
```sql
INSERT INTO employees 
VALUES (
    'Tomas Hedwig', 
    (SELECT salary FROM employees WHERE name = 'Ann Reed'), 
    (SELECT id FROM departments WHERE department = 'PR')
)
```
| name         | salary | department_id |
|--------------|--------|---------------|
| Ann Reed     | 4000   | 1             |
| Tomas Hedwig | 4000   | 3             |
==============================================================
**Subqueries in the WHERE of DELETE**
orders
| order_id | customer_id | product   | city   |
|----------|-------------|-----------|--------|
| 1        | 1           | shampoo   | London |
| 2        | 1           | hair mask | London |
| 3        | 2           | hair mask | London |
customers
| customer_id | name     |
|-------------|----------|
| 1           | Ann Smith|
| 2           | John Doe |
| 3           | Sam Brown|
delete from orders if customer_id belongs to a customer named 'Ann Smith'
```sql
DELETE FROM orders
WHERE customer_id = (SELECT customer_id FROM customers WHERE name = 'Ann Smith')
```
update orders table
| order_id | customer_id | product   | city   |
|----------|-------------|-----------|--------|
| 3        | 2           | hair mask | London |
==============================================================
