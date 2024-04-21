anonymous block
named block
[] optional

```
[DECLARE]
declaration statements //v_Employee_ID int := '1234';
BEGIN
execution statements
[EXCEPTION]
exception handling statements
END
```
==================================
SET SERVEROUTPUT ON;

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

```
CREATE OR REPLACE FUNCTION add(v_v1 integer, v_v2 integer
RETURN INTEGER
IS

  return (v_v1 + v_v2);
END add;
```
using the function add
```
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
```
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
```
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
```
TYPE name IS RECORD (surname INT [NOT NULL] {:= | DEFAULT} expression)
```
//see record.md for example
=====================================
# variable declaration
variable_name [CONSTANT] datatype [NOT NULL] [:= | DEFAULT initial_value] 
sales number(10, 2); 
pi CONSTANT double precision := 3.1415; 
=====================================
