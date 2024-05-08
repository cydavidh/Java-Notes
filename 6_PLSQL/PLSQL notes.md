anonymous block
named block
[] optional

```sql
[DECLARE]
declaration statements //v_Employee_ID int := '1234';
BEGIN
execution statements
[EXCEPTION]
exception handling statements
END
```
==================================



v_ local
g_ global

DBMS_OUTPUT.PUT_LINE('hello world');

|| means string concatenation

precision means decimal places
==================================
Scalar Data Types:
CHAR [(maximum_length)] VARCHAR2 (maximum_length) LONG NUMBER [(precision, scale)] BOOLEAN DATE TIMESTAMP
====================================
BEGISSSSSSN
function: a type of named block

```sql
CREATE OR REPLACE FUNCTION add(v_v1 integer, v_v2 integer
RETURN INTEGER
IS

  return (v_v1 + v_v2);
END add;
```
using the function add
```sql
SET SERVEROUTPUT ON;
BEGIN
  DBMS_OUTPUT.PUT_LINE('10+5=' || add(10,5));
END;
```
=====================================
# substitution variables 1-12
add & in front of variable
//v_Employee_ID int := &v_Employee_ID2;

remember '' for string sub variables
'&v_String1'

& asks evertime
DBMS_OUTPUT.PUT_LINE('weather:' || '&v_weather');
DBMS_OUTPUT.PUT_LINE('weather:' || '&v_weather');
&& variables will take the last & input
DBMS_OUTPUT.PUT_LINE('weather:' || '&&v_weather');
DBMS_OUTPUT.PUT_LINE('weather:' || '&&v_weather');
DBMS_OUTPUT.PUT_LINE('weather:' || '&v_weather');


can also use in part of a variable or string

v_My&Dog
'v_My&Ass'

=====================================
# ACCEPT, PROMPT, DEFAULT, HIDE
```sql
SET SERVEROUTPUT ON;
ACCEPT v_ID PROMPT 'Enter your ID: '; //default is string 
ACCEPT v_ID INT PROMPT 'Enter your ID: ';
ACCEPT v_ID INT DEFAULT 3 PROMPT 'Enter your ID: ';
ACCEPT v_password VARCHAR2(10) PROMPT 'Enter your password: ' HIDE; //input becomes ***
```
=====================================
# BOOLEAN
v_asdf BOOLEAN NOT NULL := TRUE; //default is true, otherwise false

# BOOLEAN SUBTYPE
SUBTYPE isActive IS BOOLEAN;
v_busActiveStatus isActive := TRUE;
=====================================
# CHAR,VARCHAR2
v_char1 char(100);
v_char1 char(100) := 'A';

# SUBTYPE
SUBTYPE CHAR50 IS char(50); //a custom type CHAR50 that has only 50 characters
SUBTYPE VARC50 IS varchar2(50);

# NCHAR, NVARCHAR2
same as char and varchar2, but for national characters
=====================================
#NUMBER
SUBTYPE NUM100_200 IS NUMBER(6,2)

# BINARY_INTEGER
# PLS_INTEGER //newer, faster, safer
NATURAL,NATURALN(>=0,Not Null),POSITIVE,POSITIVEN,SIGNTYPE(-1,0,1);
SUBTYPE BI100_200 IS PLS_INTEGER RANGE 100..200 NOT NULL;

//you can't set range for number, but you can for subtypes.

#DEC
DECIMAL(precision,scale)
DECIMAL(10,3) //7 in front, and 3 decimal places 1234567.123
#NUMERIC, DOUBLE PRECISION, FLOAT, INTEGER, INT, SMALLINT, REAL

=====================================
# SYSDATE
# SYSTIMESTAMP
```sql
SET SERVEROUTPUT ON;
  t01 TIMESTAMP := TRUNC(SYSTIMESTAMP,'YEAR'); //
BEGIN;
  DBMS_OUTPUT.PUT_LINE(SYSDATE); //22-5月 -14
  DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP); //22-5月 -14 03.31.10.535000000 下午 +08:00
END;
```
# TIMESTAMP(precision)
SUBTYPE subt1 IS TIMESTAMP(3) WITH TIME ZONE;

# TO_DATE( string [, format_mask] [, nls_language] )
DBMS_OUTPUT.PUT_LINE(TO_DATE('2020/03/13','YYYY/MM/DD')
DBMS_OUTPUT.PUT_LINE(TO_DATE('2020年03月13日','YYYY“年”MM“月”DD“日”')

# TO_CHAR( value [, format_mask] [, nls_language] )
with numbers
TO_CHAR(1210.73, '$9,999.00') //Result: ' $1,210.73'
TO_CHAR(21, '000099') //Result: ' 000021'
with date
TO_CHAR(sysdate, 'yyyy/mm/dd') //Result: '2003/07/09'
TO_CHAR(sysdate, 'FMMon ddth, YYYY') //Result: 'Jul 9th, 2003'

=====================================
# %TYPE
CREATE OR REPLACE PACKAGE pkg7a
IS
TYPE t1_typ IS RECORD ( 
  c1 T1.B1%TYPE, //sets the c1 data type the same as the type of B1 column in table T1.
  c2 VARCHAR(10)
);
END;
=====================================
# RECORD
```sql
TYPE name IS RECORD (surname INT [NOT NULL] {:= | DEFAULT} expression)
```
//see record.md for example
=====================================
# variable declaration
```sql
variable_name [CONSTANT] datatype [NOT NULL] [:= | DEFAULT initial_value] 
```
```sql
sales number(10, 2); 
pi CONSTANT double precision := 3.1415; 
```
upper/lower case doesn't matter.
=====================================
# Operators
assignment
:=

equality comparison
=

'' single quote for string
"" double quote for special cases like when name contains spaces, don't use it.

('Taipei', 1, 2) Collection

<<outer_block>> label

-- comment

: host or bind variable

%TYPE type of the other variable/column

%ROWTYPE copies entire row

&
&&
substitution variables for outside input

=> 
like lambda passing in funciton parameters
MultipleVariable(3, SecondV => 5, ThirdV => 8)

@ database link to access remote data
=====================================
# %TYPE
define variable that match type of column
```sql
DECLARE
  v_employee_name employees.employee_name%TYPE;
BEGIN
  -- Your code here
END;
```
=====================================
# %ROWTYPE
define record varialbe that hold all columns of a row
effectively mirrors the structure of the entire row
COPIES THE WHOLE ROW NOT JUST THE TYPE


basically fetches the whole row, and also automatically changes when original changed like delete or added
```sql
DECLARE
  v_employee_record employees%ROWTYPE;
BEGIN
  -- Your code here
END;
```
=====================================
# Bind Variable
# Host Variable
```sql
VARIABLE emp_name VARCHAR2(100)
```
```sql
BEGIN
  SELECT employee_name INTO :emp_name FROM employees WHERE employee_id = 101;
END;
```

```sql
VARIABLE MSG varchar2(100);
<<block_1_label>>
BEGIN
  :MSG := 'Hello World';
END block_1_label;

BEGIN
  dbms_output.put_line(:MSG);
END;
```

=====================================
# <<labels>>

```sql
SET SERVEROUTPUT ON;
<<outer_block>>
DECLARE
  asdf varchar2(30) := 'hello'
BEGIN
  <<inner_block>>
  DECLARE
    qwer varchar2(40) := 'world'
  BEGIN
    DBMS_OUTPUT.PUT_LINE('asdf: ' || asdf);
    DBMS_OUTPUT.PUT_LINE('qwer: ' || qwer);
  END inner_block;
END outer_block;
```
=====================================
# IF...THEN
# END IF;
=====================================
# IF...THEN
# ELSE
# END IF;
=====================================
# IF...THEN
# ELSIF...THEN
# ELSIF...THEN
# ELSE
# END IF;
=====================================
# AND, OR, NOT
AND > NOT > OR
=====================================
# order of precedence
()
** power
+-
*/
+-||
=,>,<= BETWEEN...AND..., IN(), IS NULL, LIKE
AND
NOT
OR
=====================================
# BETWEEN...AND...
# IN (100,200,300)
=====================================
# CASE
# WHEN...THEN
# ELSE
# END CASE
=====================================
example usage:
```sql
DECLARE
  num int := &userNum --asking user for input
BEGIN
  IF num > 100 AND num < 200
  OR
  num > 300 AND num < 400
  THEN
    dbms_output.put_line('hello world');
  END IF;
END;
```
=====================================
# LOOP
```sql
LOOP
...
END LOOP;
```

two ways to exit
1 use if...then exit.
```sql
LOOP
  IF num > 10 THEN ...
    EXIT;
  END IF;
END LOOP;
```

2 use exit when
```sql
LOOP
  EXIT WHEN num > 10;
END LOOP
```

using loop to find multiple of 9
```sql
DECLARE
  base int := 1;
  max int := 100;
BEGIN
  LOOP
    EXIT WHEN base > max;
    IF mod(base, 9) = 0
    THEN dbms_output.put_line(base); --print base if it's divisible by 9
    base = base + 1;
  END LOOP;
END;
```

using loop to print all employee name
```sql
DECLARE
  idV employee.id%TYPE := 1 --set type to same as the column type of employee.id
  nameV employee.name%TYPE; -- defualt value null
  maxV int; --null
BEGIN
  SELECT MAX(id) INTO maxV FROM employee; -- put max id into maxV
  LOOP
    EXIT WHEN id > maxV -- if id == maxV then exit
    SELECT name INTO nameV FROM employee WHERE id = idV; -- put name into nameV where id == idV
    dbms_output.put_line(idV || nameV); --print id and name
  END LOOP;
END;
```
=====================================
# WHILE
```sql
WHILE condition LOOP
  ...
END LOOP;
```

boolean
```sql
DECLARE
  isTrue BOOLEAN := true;
  asdf int := 0;
BEGIN
  WHILE isTrue LOOP
    ...
    IF asdf > 10 THEN
      isTrue := false;
    END IF;
  END LOOP;
END
```
=====================================
# FOR
```sql
FOR i IN 1..10 LOOP
  dbms_output.put_line('hello there x' || i );
END LOOP:
```

```sql
FOR i IN REVERSE 1..10 LOOP
  dbms_output.put_line('hello there x' || i );
END LOOP:
```
hello there x 5
hello there x 4
hello there x 3
hello there x 2
hello there x 1


cannot declare index outside, it will be treated as different
```sql
DECLARE
  i int := 10;
BEGIN
  FOR i IN 1..5 LOOP
    ... --the only i variable you can access here is the one that belong to FOR
    i := i + 1; -- you also can't modify the i, this is error.
  END LOOP;
END;
```

nested for loops
```sql
FOR i IN 1..10 LOOP
  FOR j IN 1..10 LOOP
    dbms_output.put_line(i || j);
  END LOOP;
END LOOP;
```
=====================================
# EXCEPTION

```sql
DECLARE
  declaration statements;
BEGIN
  execution statements;
EXCEPTION
  WHEN exception 1 THEN ...;
  WHEN exception 2 THEN ...;
  [WHEN OTHERS THEN ...]
END;
```

```sql
DECLARE
  dividend int := 100;
  divisor int := 0;
  quotient int;
BEGIN
  quotient := dividend / divisor;
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    dbms_output.put_line('zero division exception');
END;
```
=====================================
# Where 1=1
small trick to avoid parenthesis
```sql
where 1=1 
and A.RELEASED_DATE between date '2022-01-01' and date '2022-12-31' 
and A.PDM_MODELS like '%21B%'
```
same as
```sql
where (A.RELEASED_DATE between date '2022-01-01' and date '2022-12-31' 
and A.PDM_MODELS like '%21B%')
```

=====================================
# 