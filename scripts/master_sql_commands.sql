SQL – COMMAND REFERENCE (CHEAT SHEET)
=====================================================

All the SQL commands in one place, with working code.
The default syntax is MySQL 8.0+.
Abbreviations: (PG) PostgreSQL, (SS) SQL Server, (ORA) Oracle.
The examples work on the sample database in section 0.

CONTENTS
 0. Sample database              18. JSON functions
 1. Database                     19. Views
 2. Tables (DDL)                 20. Indexes
 3. ALTER TABLE                  21. Transactions (TCL)
 4. Constraints                  22. Users and permissions (DCL)
 5. INSERT / UPDATE / DELETE     23. Procedures and functions
 6. SELECT (DQL)                 24. Triggers, events, cursors
 7. Operators                    25. Flow control
 8. Joins                        26. Variables and prepared statements
 9. Set operations               27. Temporary tables and sequences
10. Subqueries and CTEs          28. Administration commands
11. Aggregate functions          29. Performance
12. String functions             30. Import, export, backup
13. Numeric functions            31. Partitioning
14. Date and time functions      32. Data types
15. Conditions and NULL          33. Differences between dialects
16. Type conversion              34. Execution order and command categories
17. Window functions

Warnings before you start:
- Use MySQL 8.0.31 or later (INTERSECT and EXCEPT do not exist before that).
- Run the sections in order: some depend on objects created earlier.
- Blocks with generic names (t, a, b, fk) are templates, not runnable code.
- DELIMITER is a client command (mysql CLI and Workbench), not SQL.
- In Workbench, "Safe Updates" can block UPDATE/DELETE without a key:
  use SET SQL_SAFE_UPDATES = 0;


PART 1 – DATABASES AND TABLES
=====================================================

0. SAMPLE DATABASE
------------------
Run it only once. Finance has no employees and Vikram Das has no
department: this is intentional, to show the differences between joins.

DROP DATABASE IF EXISTS sql_cheatsheet;
CREATE DATABASE sql_cheatsheet CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sql_cheatsheet;

CREATE TABLE departments (
    dept_id   INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    location  VARCHAR(50)
);

CREATE TABLE employees (
    emp_id     INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(50)   NOT NULL,
    email      VARCHAR(100)  UNIQUE,
    salary     DECIMAL(10,2) DEFAULT 30000,
    age        INT,
    dept_id    INT,
    manager_id INT,
    hire_date  DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_age  CHECK (age >= 18),
    CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_mgr  FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

CREATE TABLE orders (
    order_id   INT PRIMARY KEY AUTO_INCREMENT,
    emp_id     INT NOT NULL,
    amount     DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO departments (dept_name, location) VALUES
  ('IT','Bengaluru'), ('HR','Delhi'), ('Sales','Mumbai'), ('Finance','Pune');

INSERT INTO employees (name, email, salary, age, dept_id, manager_id, hire_date) VALUES
  ('Asha Rao',    'asha@corp.com',   95000, 42, 1, NULL, '2015-03-01'),
  ('Ravi Kumar',  'ravi@corp.com',   72000, 35, 1, 1,    '2018-07-15'),
  ('Meera Nair',  'meera@corp.com',  68000, 29, 1, 1,    '2020-01-10'),
  ('Karan Shah',  'karan@corp.com',  55000, 31, 2, 1,    '2019-09-23'),
  ('Priya Singh', 'priya@corp.com',  60000, 27, 3, 1,    '2021-05-17'),
  ('Arjun Mehta', 'arjun@corp.com',  58000, 33, 3, 5,    '2017-11-02'),
  ('Neha Gupta',  'neha@corp.com',   52000, 26, 3, 5,    '2022-02-28'),
  ('Vikram Das',  NULL,              45000, 24, NULL, 4, '2023-06-12');

INSERT INTO orders (emp_id, amount, order_date) VALUES
  (5, 1200.50, '2024-01-15'), (5, 800.00, '2024-02-20'),
  (6, 2500.00, '2024-01-30'), (6, 300.75, '2024-03-05'),
  (7,  150.00, '2024-03-18'), (3, 999.99, '2024-02-02');


1. DATABASE
-----------
CREATE DATABASE db;                      Create the database
CREATE DATABASE IF NOT EXISTS db;        Create only if it does not exist
CREATE DATABASE db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
                                         Create with a character encoding
SHOW DATABASES;                          List databases (PG: \l)
USE db;                                  Select the database (PG: \c db)
SELECT DATABASE();                       Current database
ALTER DATABASE db CHARACTER SET utf8mb4; Modify the database
DROP DATABASE db;                        Delete the database
DROP DATABASE IF EXISTS db;              Delete if it exists
CREATE SCHEMA s; / DROP SCHEMA s;        Schemas (PG/SS/ORA; in MySQL = database)


2. TABLES (DDL)
---------------
CREATE TABLE t (id INT PRIMARY KEY, name VARCHAR(50));   Create a table
CREATE TABLE IF NOT EXISTS t (...);      Create if it does not exist
CREATE TABLE t2 AS SELECT * FROM t;      Copy structure and data
CREATE TABLE t2 AS SELECT * FROM t WHERE 1=0;   Copy structure only
CREATE TABLE t2 LIKE t;                  Copy structure with indexes (MySQL)
SELECT * INTO t2 FROM t;                 Copy a table (SS)
SHOW TABLES;                             List tables (PG: \dt)
DESCRIBE t;  /  DESC t;                  Show the columns
SHOW COLUMNS FROM t;                     Show the columns
SHOW CREATE TABLE t;                     Show the full DDL
RENAME TABLE old TO new;                 Rename (MySQL)
TRUNCATE TABLE t;                        Empty the table, reset the identity
                                         (in MySQL it cannot be undone)
DROP TABLE t;                            Delete the table
DROP TABLE IF EXISTS t;                  Delete if it exists
DROP TABLE t1, t2;                       Delete several tables

Try it:
CREATE TABLE emp_copy  AS SELECT * FROM employees;   -- structure + data
CREATE TABLE emp_shape LIKE employees;               -- structure only
DESCRIBE emp_copy;
DROP TABLE IF EXISTS emp_copy, emp_shape;            -- cleanup


3. ALTER TABLE
--------------
ALTER TABLE t ADD col INT;                     Add a column
ALTER TABLE t ADD col INT AFTER other;         Add at a position (MySQL)
ALTER TABLE t ADD col INT FIRST;               Add as the first column (MySQL)
ALTER TABLE t ADD c1 INT, ADD c2 INT;          Add several columns (MySQL)
ALTER TABLE t DROP COLUMN col;                 Delete a column
ALTER TABLE t MODIFY col BIGINT;               Change type (MySQL, ORA)
ALTER TABLE t ALTER COLUMN col TYPE BIGINT;    Change type (PG)
ALTER TABLE t ALTER COLUMN col BIGINT;         Change type (SS)
ALTER TABLE t CHANGE old new INT;              Rename + redefine (MySQL)
ALTER TABLE t RENAME COLUMN old TO new;        Rename a column
ALTER TABLE t RENAME TO new_t;                 Rename a table
ALTER TABLE t ALTER COLUMN col SET DEFAULT 0;  Set a default value
ALTER TABLE t ALTER COLUMN col DROP DEFAULT;   Remove the default value
ALTER TABLE t MODIFY col INT NOT NULL;         Add NOT NULL (MySQL)
ALTER TABLE t ALTER COLUMN col SET NOT NULL;   Add NOT NULL (PG)
ALTER TABLE t AUTO_INCREMENT = 100;            Next auto-increment value
ALTER TABLE t ENGINE = InnoDB;                 Change the engine
ALTER TABLE t CONVERT TO CHARACTER SET utf8mb4;  Change the encoding

Try it:
ALTER TABLE employees ADD bonus DECIMAL(8,2) DEFAULT 0 AFTER salary;
ALTER TABLE employees RENAME COLUMN bonus TO annual_bonus;
ALTER TABLE employees DROP COLUMN annual_bonus;


4. CONSTRAINTS
--------------
col INT NOT NULL              Required value
col INT UNIQUE                No duplicates
col INT PRIMARY KEY           Primary key
PRIMARY KEY (c1, c2)          Composite primary key
FOREIGN KEY (c) REFERENCES p(id)   Foreign key
CHECK (age >= 18)             Check (enforced by MySQL 8.0.16+)
col INT DEFAULT 0             Default value
col INT AUTO_INCREMENT        Automatic number (PG: SERIAL, SS: IDENTITY(1,1))
ON DELETE CASCADE / SET NULL / RESTRICT / NO ACTION / SET DEFAULT
ON UPDATE CASCADE / SET NULL / RESTRICT / NO ACTION
CONSTRAINT name ...           Gives the constraint a name

Templates (t, d, fk do not exist in the sample database):
ALTER TABLE t ADD PRIMARY KEY (id);
ALTER TABLE t ADD CONSTRAINT uq UNIQUE (email);
ALTER TABLE t ADD CONSTRAINT fk FOREIGN KEY (dept_id) REFERENCES d(dept_id);
ALTER TABLE t ADD CONSTRAINT ck CHECK (salary > 0);
ALTER TABLE t DROP PRIMARY KEY;          -- MySQL
ALTER TABLE t DROP FOREIGN KEY fk;       -- MySQL
ALTER TABLE t DROP INDEX uq;             -- MySQL (unique)
ALTER TABLE t DROP CHECK ck;             -- MySQL 8.0.16+
ALTER TABLE t DROP CONSTRAINT name;      -- PG / SS / ORA
SET FOREIGN_KEY_CHECKS = 0;              -- disable (MySQL)
SET FOREIGN_KEY_CHECKS = 1;              -- re-enable

Try it (it must fail: the CHECK constraint blocks the data):
INSERT INTO employees (name, age) VALUES ('Too Young', 15);


PART 2 – DATA AND QUERIES
=====================================================

5. INSERT / UPDATE / DELETE (DML)
---------------------------------
-- INSERT
INSERT INTO departments (dept_name, location) VALUES ('Legal', 'Chennai');
INSERT INTO departments (dept_name, location) VALUES ('R&D','Pune'), ('Ops','Delhi');

CREATE TABLE emp_backup LIKE employees;
INSERT INTO emp_backup SELECT * FROM employees;           -- from a query
INSERT INTO emp_backup (name, salary) SELECT name, salary FROM employees WHERE salary > 100000;

INSERT IGNORE INTO departments (dept_name) VALUES ('IT'); -- ignore duplicates (MySQL)
REPLACE INTO emp_backup (emp_id, name, salary) VALUES (1, 'Asha Rao', 99000);
                                                          -- delete + insert (MySQL)

-- UPSERT (MySQL 8.0.19+)
INSERT INTO departments (dept_id, dept_name, location) VALUES (1,'IT','Bengaluru') AS new
ON DUPLICATE KEY UPDATE location = new.location;

-- PG: INSERT ... ON CONFLICT (id) DO UPDATE SET n = EXCLUDED.n;
-- PG: INSERT ... RETURNING id;
-- PG/SS: INSERT INTO t DEFAULT VALUES;

-- UPDATE
UPDATE employees SET salary = 61000 WHERE emp_id = 5;
UPDATE employees SET salary = salary * 1.10, age = age + 1 WHERE dept_id = 1;
UPDATE employees SET salary = CASE WHEN salary < 50000 THEN salary * 1.2 ELSE salary END;
UPDATE employees e JOIN departments d ON e.dept_id = d.dept_id
SET e.salary = e.salary + 1000 WHERE d.dept_name = 'HR';     -- MySQL
-- PG / SS: UPDATE a SET x = b.x FROM b WHERE a.id = b.id;
UPDATE employees SET salary = salary + 1 ORDER BY emp_id LIMIT 2;   -- MySQL

-- DELETE
DELETE FROM departments WHERE dept_name IN ('Legal','R&D','Ops');
DELETE FROM emp_backup WHERE emp_id = 1;
DELETE e FROM emp_backup e JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'HR';                                    -- MySQL
DELETE FROM emp_backup ORDER BY emp_id LIMIT 1;              -- MySQL
DELETE FROM emp_backup;                                      -- all rows
DROP TABLE emp_backup;

WARNING: UPDATE or DELETE without WHERE changes ALL the rows.
Test the condition with a SELECT first.

-- MERGE (SS / ORA / PG 15+; does not exist in MySQL)
MERGE INTO target t USING source s ON t.id = s.id
WHEN MATCHED THEN UPDATE SET t.v = s.v
WHEN NOT MATCHED THEN INSERT (id, v) VALUES (s.id, s.v);


6. SELECT (DQL)
---------------
SELECT * FROM employees;
SELECT name, salary FROM employees;
SELECT DISTINCT dept_id FROM employees;                        -- unique values
SELECT name AS employee, salary * 12 AS annual FROM employees; -- aliases
SELECT name FROM employees WHERE salary > 60000;
SELECT dept_id, COUNT(*) AS n FROM employees GROUP BY dept_id HAVING COUNT(*) > 1;
SELECT * FROM employees ORDER BY dept_id ASC, salary DESC;     -- sorting
SELECT * FROM employees LIMIT 3;
SELECT * FROM employees LIMIT 3 OFFSET 3;
SELECT * FROM employees LIMIT 3, 3;                            -- offset, how many (MySQL)
SELECT 1 + 1;
SELECT COUNT(*) INTO @cnt FROM employees;                      -- into a variable
SELECT @cnt;

Other dialects and blocks (the first two do not work in MySQL):
-- SELECT TOP 3 * FROM employees;                      (SS)
-- SELECT * FROM employees FETCH FIRST 3 ROWS ONLY;    (ORA / PG / SS)
START TRANSACTION;
SELECT * FROM employees WHERE emp_id = 1 FOR UPDATE;   -- locks the rows
SELECT * FROM employees WHERE emp_id = 1 FOR SHARE;    -- shared lock
ROLLBACK;                                              -- releases the locks

Order in which you WRITE the clauses:
SELECT [DISTINCT] columns
FROM table
[JOIN ... ON ...]
[WHERE ...]
[GROUP BY ...]
[HAVING ...]
[ORDER BY ...]
[LIMIT ... OFFSET ...];


7. OPERATORS AND KEYWORDS
-------------------------
=  <>  !=  >  <  >=  <=       Comparison
<=>                           NULL-safe equality (MySQL)
AND, OR, NOT                  Logical
BETWEEN x AND y               Range, endpoints included
NOT BETWEEN                   Outside the range
IN (...) / NOT IN (...)       List (beware of NULLs with NOT IN)
LIKE 'A%'                     Starts with A
LIKE '%a'                     Ends with a
LIKE '%a%'                    Contains a
LIKE '_a%'                    Second letter is a
ILIKE                         Case-insensitive LIKE (PG)
REGEXP / RLIKE                Regular expression (MySQL); ~ in PG
IS NULL / IS NOT NULL         NULL test
EXISTS / NOT EXISTS           At least one row exists
ANY / SOME / ALL              Comparison with a set
+ - * / %   DIV   MOD         Arithmetic
& | ^ ~ << >>                 Bitwise
||                            Concatenation (PG, ORA)
+                             Concatenation (SS)
COLLATE                       Chooses the character comparison
ESCAPE                        LIKE '50\%' ESCAPE '\\'

Try it:
SELECT name FROM employees WHERE name LIKE 'A%';
SELECT name FROM employees WHERE name REGEXP '^[AEIOU]';
SELECT name FROM employees WHERE email IS NULL;
SELECT name, salary FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE dept_id = 2);


8. JOINS
--------
-- INNER: only the rows that match
SELECT e.name, d.dept_name FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id;
-- LEFT: all employees (Vikram: department NULL)
SELECT e.name, d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id;
-- RIGHT: all departments (Finance: employee NULL)
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;
-- CROSS: Cartesian product
SELECT d.dept_name, e.name FROM departments d CROSS JOIN employees e;
-- USING / NATURAL
SELECT * FROM employees e JOIN departments d USING (dept_id);
SELECT * FROM employees NATURAL JOIN departments;

-- Self join: employee and manager
SELECT e.name AS employee, m.name AS manager
FROM employees e LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Anti join: departments with no employees
SELECT d.dept_name FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;

-- Join on multiple tables
SELECT e.name, d.dept_name, o.amount
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN orders o ON o.emp_id = e.emp_id;

-- FULL OUTER JOIN exists in PG / SS / ORA. In MySQL you simulate it:
SELECT e.name, d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;

Summary:
INNER            Rows present in both
LEFT             All of the left + matches
RIGHT            All of the right + matches
FULL             All rows from both
CROSS            Every combination
LATERAL / CROSS APPLY   Correlated subquery per row (PG, MySQL 8.0.14+ / SS)


9. SET OPERATIONS
-----------------
SELECT dept_id FROM employees UNION     SELECT dept_id FROM departments;  -- without duplicates
SELECT dept_id FROM employees UNION ALL SELECT dept_id FROM departments;  -- with duplicates
SELECT dept_id FROM departments INTERSECT SELECT dept_id FROM employees;  -- in common (MySQL 8.0.31+)
SELECT dept_id FROM departments EXCEPT    SELECT dept_id FROM employees;  -- only on the left (ORA: MINUS)

The two queries must have the same number of columns with compatible types.


10. SUBQUERIES AND CTEs
-----------------------
-- Scalar
SELECT name, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);
-- IN
SELECT name FROM employees WHERE emp_id IN (SELECT emp_id FROM orders);
-- Derived table
SELECT * FROM (SELECT emp_id, SUM(amount) AS total FROM orders GROUP BY emp_id) x WHERE total > 1000;
-- Correlated: earns more than the average of their own department
SELECT name, salary FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id);
-- EXISTS
SELECT d.dept_name FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id);
-- In the SELECT list
SELECT name, (SELECT COUNT(*) FROM orders o WHERE o.emp_id = e.emp_id) AS n_orders FROM employees e;

-- CTE
WITH dept_avg AS (
  SELECT dept_id, AVG(salary) AS avg_salary FROM employees GROUP BY dept_id
)
SELECT e.name, e.salary, m.avg_salary
FROM employees e JOIN dept_avg m ON e.dept_id = m.dept_id;

-- Recursive CTE: numbers from 1 to 10
WITH RECURSIVE n AS (
  SELECT 1 AS x UNION ALL SELECT x + 1 FROM n WHERE x < 10
)
SELECT * FROM n;

-- Recursive CTE: hierarchy chain
WITH RECURSIVE chain AS (
  SELECT emp_id, name, manager_id, 1 AS level FROM employees WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.name, e.manager_id, c.level + 1
  FROM employees e JOIN chain c ON e.manager_id = c.emp_id
)
SELECT * FROM chain ORDER BY level, emp_id;


PART 3 – FUNCTIONS
=====================================================

11. AGGREGATE FUNCTIONS
-----------------------
COUNT(*)                       All rows
COUNT(col)                     Non-NULL values
COUNT(DISTINCT col)            Unique non-NULL values
SUM(col)  AVG(col)             Sum, average
MIN(col)  MAX(col)             Minimum, maximum
GROUP_CONCAT(col SEPARATOR ',')   Joins the values (MySQL)
STRING_AGG(col, ',')           Joins the values (PG, SS)
LISTAGG(col, ',')              Joins the values (ORA)
STDDEV()  VARIANCE()           Statistics
BIT_AND() BIT_OR() BIT_XOR()   Bitwise aggregates
JSON_ARRAYAGG() JSON_OBJECTAGG()   JSON aggregates
GROUP BY ... WITH ROLLUP       Subtotals (MySQL); PG/SS/ORA: ROLLUP(a,b)
GROUP BY CUBE(a,b)             All combinations (PG/SS/ORA)
GROUP BY GROUPING SETS (...)   Custom groupings

Try it:
SELECT COUNT(*), COUNT(email), COUNT(DISTINCT dept_id) FROM employees;   -- 8, 7, 3
SELECT dept_id, COUNT(*) AS n, ROUND(AVG(salary),2) AS average, MAX(salary) AS maximum
FROM employees GROUP BY dept_id;
SELECT dept_id, GROUP_CONCAT(name ORDER BY name SEPARATOR ', ') AS team FROM employees GROUP BY dept_id;
SELECT dept_id, SUM(salary) FROM employees GROUP BY dept_id WITH ROLLUP;

COUNT(*) counts rows; COUNT(col) skips NULLs.


12. STRING FUNCTIONS
--------------------
UPPER(s) / LOWER(s)                   Uppercase / lowercase
LENGTH(s) / CHAR_LENGTH(s)            Bytes / characters (SS: LEN)
CONCAT(a,b,...) / CONCAT_WS(sep,a,b)  Joins strings
SUBSTRING(s,pos,len) / SUBSTR         Substring (starts at 1)
LEFT(s,n) / RIGHT(s,n)                First / last n characters
TRIM(s) / LTRIM(s) / RTRIM(s)         Removes spaces
TRIM(BOTH 'x' FROM s)                 Removes specific characters
REPLACE(s,from,to)                    Replaces text
REVERSE(s)                            Reverses
INSTR(s,sub) / LOCATE(sub,s)          Finds the position
LPAD(s,n,p) / RPAD(s,n,p)             Pads up to n characters
REPEAT(s,n)                           Repeats
SPACE(n)                              n spaces
ASCII(c) / CHAR(n)                    Character / code
FORMAT(n,d)                           Formats the number (1,234.50)
STRCMP(a,b)                           Compares
FIELD(s,a,b,c)                        Index in the list
FIND_IN_SET(s,'a,b,c')                Position in a CSV list
SUBSTRING_INDEX(s,delim,n)            Splits by delimiter (MySQL)
SPLIT_PART(s,delim,n)                 Splits (PG)
INITCAP(s)                            Capitalized initials (PG/ORA)
TRANSLATE(s,from,to)                  Replaces character by character (PG/ORA)
INSERT(s,pos,len,new)                 Inserts / replaces a part (OVERLAY in PG)
SOUNDEX(s)                            Phonetic code
REGEXP_REPLACE() REGEXP_SUBSTR() REGEXP_LIKE() REGEXP_INSTR()   Regex (MySQL 8+)
QUOTE(s)                              Escapes the string
HEX(s) / UNHEX(s)                     Hexadecimal
MD5(s) / SHA2(s,256)                  Hash
TO_BASE64(s) / FROM_BASE64(s)         Base64

Try it:
SELECT UPPER(name), LENGTH(name), LEFT(name,3), SUBSTRING(name,1,4) FROM employees LIMIT 3;
SELECT CONCAT(name, ' <', IFNULL(email,'no email'), '>') AS contact FROM employees;
SELECT SUBSTRING_INDEX(email,'@',1) AS user, SUBSTRING_INDEX(email,'@',-1) AS domain
FROM employees WHERE email IS NOT NULL;
SELECT REPLACE('2024-01-15','-','/'), LPAD(7,3,'0'), REPEAT('ab',3), REVERSE('SQL');
SELECT REGEXP_REPLACE('a1b22c333','[0-9]+','#');     -- a#b#c#
SELECT SHA2('secret',256);


13. NUMERIC FUNCTIONS
---------------------
ROUND(n,d)                     Rounds
CEIL(n) / CEILING(n)           Round up
FLOOR(n)                       Round down
TRUNCATE(n,d)                  Cuts off the decimals (PG/ORA: TRUNC)
ABS(n)                         Absolute value
MOD(a,b) / a % b               Remainder
POWER(a,b) / POW               Power
SQRT(n)                        Square root
EXP(n) LN(n) LOG(n) LOG10(n) LOG2(n)   Exponential and logarithms
SIGN(n)                        -1 / 0 / 1
RAND()                         Random between 0 and 1 (PG: RANDOM())
GREATEST(a,b,...) / LEAST(a,b,...)     Maximum / minimum among values
PI()                           Pi
SIN() COS() TAN() ASIN() ACOS() ATAN() Trigonometry
DEGREES() / RADIANS()          Angle conversion
CONV(n,from,to)                Base conversion
DIV                            Integer division (MySQL)

Try it:
SELECT ROUND(3.14159,2), CEIL(4.1), FLOOR(4.9), TRUNCATE(4.987,1), ABS(-5);   -- 3.14, 5, 4, 4.9, 5
SELECT MOD(17,5), 17 % 5, 17 DIV 5, POWER(2,10), SQRT(144), SIGN(-9);         -- 2, 2, 3, 1024, 12, -1
SELECT GREATEST(3,9,2), LEAST(3,9,2), CONV('FF',16,10);                       -- 9, 2, 255
SELECT name FROM employees ORDER BY RAND() LIMIT 1;                           -- a random employee


14. DATE AND TIME FUNCTIONS
---------------------------
NOW() / CURRENT_TIMESTAMP / SYSDATE()   Current date and time (SS: GETDATE(), ORA: SYSDATE)
CURDATE() / CURRENT_DATE                Current date
CURTIME() / CURRENT_TIME                Current time
UTC_TIMESTAMP() / UTC_DATE()            UTC
DATE(x) / TIME(x)                       Extracts date / time
YEAR(x) MONTH(x) DAY(x) HOUR(x) MINUTE(x) SECOND(x)   Parts
QUARTER(x) WEEK(x) WEEKDAY(x) DAYOFWEEK(x) DAYOFMONTH(x) DAYOFYEAR(x)
DAYNAME(x) / MONTHNAME(x)               Names (in English by default)
EXTRACT(unit FROM x)                    Standard extraction
DATE_ADD(x, INTERVAL n unit)            Adds
DATE_SUB(x, INTERVAL n unit)            Subtracts
x + INTERVAL 7 DAY                      Adds an interval
DATEDIFF(d1,d2)                         Days between two dates (SS: DATEDIFF(day,d1,d2))
TIMESTAMPDIFF(unit,d1,d2)               Difference in a given unit
TIMEDIFF(t1,t2)                         Time difference
DATE_FORMAT(x,'%Y-%m-%d')               Formats (PG: TO_CHAR, SS: FORMAT)
STR_TO_DATE(s,'%d-%m-%Y')               Parses text (PG/ORA: TO_DATE)
LAST_DAY(x)                             Last day of the month
MAKEDATE(year,day_of_year) MAKETIME(h,m,s)   Builds a date / time
FROM_UNIXTIME(n) / UNIX_TIMESTAMP(x)    Conversion from/to epoch
TO_DAYS(x) / FROM_DAYS(n)               Day number
SEC_TO_TIME(n) / TIME_TO_SEC(t)         Seconds conversion
AGE(d1,d2)                              Interval (PG)
DATE_TRUNC('month', x)                  Truncates (PG)
DATEADD(day,7,x)  DATEPART(year,x)      (SS)
ADD_MONTHS(x,n)  MONTHS_BETWEEN(a,b)    (ORA)

Units: MICROSECOND, SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, YEAR

Format codes: %Y year | %y 2-digit year | %m month (01-12) | %M month name |
%b short month | %d day | %e day without zero | %H hours 24h | %h hours 12h |
%i minutes | %s seconds | %p AM/PM | %W day name | %a short day | %j day of year

Try it:
SELECT NOW(), CURDATE(), CURTIME();
SELECT name, hire_date, YEAR(hire_date) AS year, MONTHNAME(hire_date) AS month FROM employees;
SELECT name, TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service FROM employees;
SELECT DATE_ADD('2024-01-31', INTERVAL 1 MONTH), '2024-01-15' + INTERVAL 7 DAY, LAST_DAY('2024-02-10');
SELECT DATEDIFF('2024-12-25','2024-01-01');                -- 359
SELECT DATE_FORMAT('2024-03-05','%d %b %Y, %W');           -- 05 Mar 2024, Tuesday
SELECT STR_TO_DATE('15-08-2024','%d-%m-%Y');               -- 2024-08-15
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(amount)
FROM orders GROUP BY year, month ORDER BY year, month;


15. CONDITIONS AND NULL FUNCTIONS
---------------------------------
CASE WHEN c THEN a ELSE b END           If-else (standard)
CASE col WHEN 1 THEN 'a' WHEN 2 THEN 'b' END   Simple CASE
IF(cond, yes, no)                       Inline if (MySQL)
IIF(cond, yes, no)                      Inline if (SS)
IFNULL(a,b)                             b if a is NULL (MySQL)
ISNULL(a,b)                             (SS)
NVL(a,b)  NVL2(a,b,c)                   (ORA)
COALESCE(a,b,c)                         First non-NULL value (standard)
NULLIF(a,b)                             NULL if a = b
GREATEST() / LEAST()                    Maximum / minimum across columns
DECODE(col,v1,r1,v2,r2,default)         (ORA)

Try it:
SELECT name, salary,
  CASE WHEN salary >= 70000 THEN 'High'
       WHEN salary >= 55000 THEN 'Medium'
       ELSE 'Low' END AS band
FROM employees;

SELECT name, IF(dept_id IS NULL, 'No department', 'Assigned') AS status FROM employees;
SELECT name, COALESCE(email, 'no-email') FROM employees;
SELECT NULLIF(10, 10), NULLIF(10, 5);       -- NULL, 10
SELECT 100 / NULLIF(0, 0);                  -- NULL instead of a division-by-zero error


16. TYPE CONVERSION
-------------------
SELECT CAST('123' AS SIGNED), CAST(12.3456 AS DECIMAL(10,2)), CAST('2024-05-01' AS DATE);
SELECT CAST(NOW() AS DATE), CAST(65 AS CHAR), CONVERT('42', SIGNED), CONVERT('abc' USING utf8mb4);
SELECT '10' + 5;                            -- 15 (implicit conversion)

Other dialects:
x::INT                                      (PG, shorthand)
TO_CHAR(x,'fmt')  TO_NUMBER(s)  TO_DATE(s,'fmt')   (PG / ORA)
TRY_CAST(x AS INT)  TRY_CONVERT(...)        (SS: NULL if it fails)


17. WINDOW FUNCTIONS
--------------------
Form: function() OVER (PARTITION BY a ORDER BY b ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

ROW_NUMBER()                   Unique row number
RANK()                         Rank with gaps
DENSE_RANK()                   Rank without gaps
NTILE(n)                       Splits into n groups
PERCENT_RANK()                 Relative rank 0-1
CUME_DIST()                    Cumulative distribution
LAG(col,n,default)             Value from the previous row
LEAD(col,n,default)            Value from the next row
FIRST_VALUE(col) / LAST_VALUE(col) / NTH_VALUE(col,n)
SUM() AVG() COUNT() MIN() MAX() OVER (...)   Running / per-group aggregates
WINDOW w AS (PARTITION BY ...)  Named window

Frame keywords: ROWS, RANGE, UNBOUNDED PRECEDING, n PRECEDING, CURRENT ROW,
n FOLLOWING, UNBOUNDED FOLLOWING.

Try it:
-- Salary ranking within the department
SELECT name, dept_id, salary,
  ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn,
  RANK()       OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS drnk
FROM employees;

-- The highest paid in each department
SELECT * FROM (
  SELECT name, dept_id, salary,
         RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS r
  FROM employees
) t WHERE r = 1;

-- Running total, previous and next
SELECT order_id, order_date, amount,
  SUM(amount) OVER (ORDER BY order_date, order_id) AS running_total,
  LAG(amount)  OVER (ORDER BY order_date, order_id) AS previous,
  LEAD(amount) OVER (ORDER BY order_date, order_id) AS next
FROM orders;

-- 3-row moving average and share of the department total
SELECT order_id, AVG(amount) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg FROM orders;
SELECT name, dept_id, salary, ROUND(100 * salary / SUM(salary) OVER (PARTITION BY dept_id), 1) AS dept_pct FROM employees;

-- Named window + NTILE
SELECT name, salary, NTILE(4) OVER w AS quartile FROM employees WINDOW w AS (ORDER BY salary);


18. JSON FUNCTIONS
------------------
CREATE TABLE products (id INT PRIMARY KEY AUTO_INCREMENT, info JSON);
INSERT INTO products (info) VALUES
  ('{"name":"Laptop","price":55000,"tags":["tech","work"]}'),
  ('{"name":"Desk","price":12000,"tags":["furniture"]}');

SELECT JSON_EXTRACT(info,'$.name') FROM products;             -- "Laptop"
SELECT info->'$.name', info->>'$.name' FROM products;         -- with / without quotes
SELECT JSON_OBJECT('k', 1, 'x', 'y'), JSON_ARRAY(1,2,3);
UPDATE products SET info = JSON_SET(info, '$.price', 50000) WHERE id = 1;
UPDATE products SET info = JSON_REMOVE(info, '$.tags') WHERE id = 2;
SELECT * FROM products WHERE JSON_CONTAINS(info->'$.tags', '"tech"');
SELECT JSON_LENGTH(info), JSON_KEYS(info), JSON_VALID(info), JSON_TYPE(info) FROM products;
SELECT jt.* FROM products p,
  JSON_TABLE(p.info, '$' COLUMNS (name VARCHAR(50) PATH '$.name', price INT PATH '$.price')) jt;
DROP TABLE products;

Other functions: JSON_INSERT(), JSON_REPLACE(), JSON_ARRAYAGG(), JSON_OBJECTAGG().
PG: col->'name'  col->>'name'  col @> '{"a":1}'  jsonb_set(...)
SS: JSON_VALUE(col,'$.name')  OPENJSON(col)  FOR JSON PATH


PART 4 – OBJECTS AND PROGRAMMING
=====================================================

19. VIEWS
---------
CREATE VIEW v_it AS SELECT emp_id, name, salary FROM employees WHERE dept_id = 1;
CREATE OR REPLACE VIEW v_it AS SELECT emp_id, name, salary, hire_date FROM employees WHERE dept_id = 1;
CREATE VIEW v_cheap AS SELECT * FROM employees WHERE salary < 60000 WITH CHECK OPTION;
                                  -- blocks rows that would fall outside the view
SELECT * FROM v_it;
ALTER VIEW v_it AS SELECT emp_id, name FROM employees WHERE dept_id = 1;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW CREATE VIEW v_it;
DROP VIEW IF EXISTS v_it, v_cheap;

PG / ORA only:
CREATE MATERIALIZED VIEW mv AS SELECT ...;
REFRESH MATERIALIZED VIEW mv;     -- PG


20. INDEXES
-----------
CREATE INDEX idx_dept ON employees (dept_id);
CREATE INDEX idx_dept_sal ON employees (dept_id, salary);     -- composite (leftmost prefix rule)
CREATE FULLTEXT INDEX idx_ft ON departments (dept_name, location);   -- MySQL
CREATE INDEX idx_sal_desc ON employees (salary DESC);         -- MySQL 8+
CREATE INDEX idx_name5 ON employees (name(5));                -- prefix index (MySQL)

SHOW INDEX FROM employees;
ALTER TABLE employees ADD INDEX idx_age (age);
ALTER TABLE employees ALTER INDEX idx_age INVISIBLE;          -- MySQL 8+: hidden from the optimizer
DROP INDEX idx_age ON employees;                              -- MySQL / SS  (PG/ORA: DROP INDEX idx_age;)

SELECT * FROM departments WHERE MATCH(dept_name, location) AGAINST('Delhi');   -- uses the FULLTEXT

PG: partial index      CREATE INDEX idx ON t (col) WHERE active;
PG: expression index   CREATE INDEX idx ON t (LOWER(email));
SS: included columns   CREATE INDEX idx ON t (a) INCLUDE (b);

Tip: index the columns you use in filters, joins and sorting.
Too many indexes slow down writes.


21. TRANSACTIONS (TCL)
----------------------
START TRANSACTION;               -- or BEGIN
UPDATE employees SET salary = salary - 1000 WHERE emp_id = 2;
UPDATE employees SET salary = salary + 1000 WHERE emp_id = 3;
COMMIT;                          -- save

START TRANSACTION;
DELETE FROM orders WHERE emp_id = 6;
ROLLBACK;                        -- undo everything

START TRANSACTION;
UPDATE employees SET age = age + 1 WHERE emp_id = 1;
SAVEPOINT sp1;
UPDATE employees SET age = age + 1 WHERE emp_id = 2;
ROLLBACK TO SAVEPOINT sp1;       -- undo only the second update
RELEASE SAVEPOINT sp1;
COMMIT;

SET autocommit = 0;              -- manual commit
SET autocommit = 1;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;   -- applies to the next transaction
SELECT @@transaction_isolation;

Isolation levels:
READ UNCOMMITTED   dirty read: yes | non-repeatable: yes | phantom: yes
READ COMMITTED     dirty read: no  | non-repeatable: yes | phantom: yes
REPEATABLE READ    dirty read: no  | non-repeatable: no  | phantom: almost never (InnoDB)
                   (default in MySQL)
SERIALIZABLE       dirty read: no  | non-repeatable: no  | phantom: no

ACID: Atomicity, Consistency, Isolation, Durability.
DDL statements (CREATE, DROP, TRUNCATE) commit automatically in MySQL.


22. USERS AND PERMISSIONS (DCL)
-------------------------------
CREATE USER 'alice'@'localhost' IDENTIFIED BY 'Str0ng#Pass';
CREATE USER 'bob'@'%' IDENTIFIED BY 'Str0ng#Pass2';           -- from any host

GRANT SELECT ON sql_cheatsheet.* TO 'alice'@'localhost';
GRANT SELECT, INSERT, UPDATE ON sql_cheatsheet.employees TO 'alice'@'localhost';
GRANT ALL PRIVILEGES ON sql_cheatsheet.* TO 'bob'@'%' WITH GRANT OPTION;
-- GRANT EXECUTE ON PROCEDURE sql_cheatsheet.raise_salary TO 'alice'@'localhost';
--   (run it after section 23, when the procedure exists)

SHOW GRANTS FOR 'alice'@'localhost';
REVOKE INSERT ON sql_cheatsheet.employees FROM 'alice'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'bob'@'%';

ALTER USER 'alice'@'localhost' IDENTIFIED BY 'N3w#Pass';
RENAME USER 'bob'@'%' TO 'robert'@'%';
DROP USER 'alice'@'localhost', 'robert'@'%';
FLUSH PRIVILEGES;

-- Roles (MySQL 8+)
CREATE ROLE 'reader';
GRANT SELECT ON sql_cheatsheet.* TO 'reader';
DROP ROLE 'reader';


23. STORED PROCEDURES AND FUNCTIONS
-----------------------------------
DELIMITER //

CREATE PROCEDURE raise_salary(IN p_dept INT, IN p_pct DECIMAL(5,2))
BEGIN
    UPDATE employees SET salary = salary * (1 + p_pct / 100) WHERE dept_id = p_dept;
    SELECT ROW_COUNT() AS rows_changed;
END //

CREATE PROCEDURE dept_stats(IN p_dept INT, OUT p_count INT, OUT p_avg DECIMAL(10,2))
BEGIN
    SELECT COUNT(*), AVG(salary) INTO p_count, p_avg FROM employees WHERE dept_id = p_dept;
END //

CREATE FUNCTION annual_salary(p_monthly DECIMAL(10,2)) RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN p_monthly * 12;
END //

DELIMITER ;

CALL raise_salary(1, 5);
CALL dept_stats(1, @cnt, @avg);
SELECT @cnt, @avg;
SELECT name, annual_salary(salary) FROM employees LIMIT 3;

SHOW PROCEDURE STATUS WHERE Db = 'sql_cheatsheet';
SHOW FUNCTION STATUS  WHERE Db = 'sql_cheatsheet';
SHOW CREATE PROCEDURE raise_salary;
DROP PROCEDURE IF EXISTS dept_stats;
DROP FUNCTION IF EXISTS annual_salary;

Notes:
- DELIMITER is a CLIENT command, not SQL. It works in the mysql CLI and MySQL
  Workbench. In phpMyAdmin or DBeaver, set the delimiter in the program's
  option and delete the DELIMITER lines. Many online SQL editors do not support it.
- Parameter modes: IN (default), OUT, INOUT.
- If creating a function gives a binary log error, you need:
  SET GLOBAL log_bin_trust_function_creators = 1;  (requires privileges)


24. TRIGGERS, EVENTS, CURSORS
-----------------------------
-- TRIGGER
CREATE TABLE salary_log (
    log_id     INT PRIMARY KEY AUTO_INCREMENT,
    emp_id     INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_salary_audit
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_log (emp_id, old_salary, new_salary)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary);
    END IF;
END //

CREATE TRIGGER trg_email_lower
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END //
DELIMITER ;

UPDATE employees SET salary = salary + 500 WHERE emp_id = 2;
SELECT * FROM salary_log;
SHOW TRIGGERS;
DROP TRIGGER IF EXISTS trg_email_lower;

Timing: BEFORE / AFTER. Event: INSERT / UPDATE / DELETE.
OLD = row before the change, NEW = row after.

-- EVENTS (scheduler)
SET GLOBAL event_scheduler = ON;

CREATE EVENT ev_purge_log
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP
DO DELETE FROM salary_log WHERE changed_at < NOW() - INTERVAL 30 DAY;

SHOW EVENTS;
ALTER EVENT ev_purge_log DISABLE;
DROP EVENT IF EXISTS ev_purge_log;

-- CURSORS
DELIMITER //
CREATE PROCEDURE total_payroll(OUT p_total DECIMAL(14,2))
BEGIN
    DECLARE v_sal DECIMAL(10,2);
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT salary FROM employees;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET p_total = 0;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_sal;
        IF done = 1 THEN LEAVE read_loop; END IF;
        SET p_total = p_total + v_sal;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL total_payroll(@t);
SELECT @t;


25. FLOW CONTROL
----------------
DELIMITER //
CREATE PROCEDURE flow_demo(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE s INT DEFAULT 0;

    -- IF / ELSEIF / ELSE
    IF n < 0 THEN SELECT 'negative';
    ELSEIF n = 0 THEN SELECT 'zero';
    ELSE SELECT 'positive';
    END IF;

    -- CASE
    CASE WHEN n > 100 THEN SELECT 'large'; ELSE SELECT 'small'; END CASE;

    -- WHILE
    WHILE i <= n DO SET s = s + i; SET i = i + 1; END WHILE;
    SELECT s AS sum_from_1_to_n;

    -- REPEAT
    SET i = 0;
    REPEAT SET i = i + 1; UNTIL i >= 3 END REPEAT;

    -- LOOP with LEAVE (exit) / ITERATE (continue)
    SET i = 0;
    lp: LOOP
        SET i = i + 1;
        IF i = 2 THEN ITERATE lp; END IF;
        IF i > 4 THEN LEAVE lp; END IF;
    END LOOP;
END //
DELIMITER ;

CALL flow_demo(5);
DROP PROCEDURE flow_demo;

Error handling:
DELIMITER //
CREATE PROCEDURE safe_transfer(IN p_from INT, IN p_to INT, IN p_amt DECIMAL(10,2))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transfer failed, rolled back' AS msg;
    END;

    START TRANSACTION;
    UPDATE employees SET salary = salary - p_amt WHERE emp_id = p_from;
    UPDATE employees SET salary = salary + p_amt WHERE emp_id = p_to;
    IF (SELECT salary FROM employees WHERE emp_id = p_from) < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;
    COMMIT;
END //
DELIMITER ;


26. VARIABLES AND PREPARED STATEMENTS
-------------------------------------
-- User variables (valid for the whole session)
SET @name = 'Asha Rao';
SET @min_sal := 60000;
SELECT @name, @min_sal;
SELECT COUNT(*) INTO @n FROM employees WHERE salary > @min_sal;
SELECT @n;

-- System variables
SHOW VARIABLES LIKE 'max_connections';
SET SESSION sql_mode = 'STRICT_ALL_TABLES';
SET GLOBAL max_connections = 300;               -- requires privileges
SELECT @@version, @@sql_mode, @@global.time_zone;

-- Local variables (only inside routines)
-- DECLARE v INT DEFAULT 0;  SET v = 5;

-- Prepared statements (safe dynamic SQL)
PREPARE stmt FROM 'SELECT name, salary FROM employees WHERE dept_id = ? AND salary > ?';
SET @d = 1, @s = 60000;
EXECUTE stmt USING @d, @s;
DEALLOCATE PREPARE stmt;

-- Dynamic table name
SET @tbl = 'employees';
SET @sql = CONCAT('SELECT COUNT(*) AS n FROM ', @tbl);
PREPARE s2 FROM @sql; EXECUTE s2; DEALLOCATE PREPARE s2;

WARNING: use ? placeholders for values. Never paste untrusted input
into the SQL (SQL injection).


27. TEMPORARY TABLES AND SEQUENCES
----------------------------------
-- Temporary table: visible only to your session, disappears on disconnect
CREATE TEMPORARY TABLE tmp_high AS SELECT * FROM employees WHERE salary > 60000;
SELECT * FROM tmp_high;
DROP TEMPORARY TABLE tmp_high;

SELECT LAST_INSERT_ID();                  -- last auto-increment value
ALTER TABLE departments AUTO_INCREMENT = 100;

Sequences (MySQL does not have them: use AUTO_INCREMENT):
CREATE SEQUENCE seq_id START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999 CACHE 20;
SELECT NEXTVAL('seq_id');                 -- PG
SELECT seq_id.NEXTVAL FROM dual;          -- ORA
SELECT NEXT VALUE FOR seq_id;             -- SS
ALTER SEQUENCE seq_id RESTART WITH 100;
DROP SEQUENCE seq_id;

Temporary tables in other dialects:
SS: CREATE TABLE #tmp (...)     PG: CREATE TEMP TABLE tmp (...)


PART 5 – ADMINISTRATION AND REFERENCE
=====================================================

28. ADMINISTRATION AND INFORMATION COMMANDS
-------------------------------------------
SHOW DATABASES;  SHOW TABLES;            List objects
SHOW TABLES LIKE 'emp%';                 Filter by pattern
SHOW FULL COLUMNS FROM t;                Columns with comments and collation
SHOW CREATE TABLE t;                     Full DDL
SHOW INDEX FROM t;                       Indexes
SHOW TABLE STATUS LIKE 't';              Rows, size, engine
SHOW PROCESSLIST;                        Running queries
KILL 123;                                Closes a connection by ID
SHOW STATUS;                             Server counters
SHOW VARIABLES LIKE '%x%';               Configuration values
SHOW ENGINES;                            Storage engines
SHOW WARNINGS;  SHOW ERRORS;             Problems from the last statement
SHOW GRANTS;                             Your permissions
SHOW CHARACTER SET;  SHOW COLLATION;     Encodings
SELECT VERSION();                        Server version
SELECT USER(), CURRENT_USER();           Who am I
SELECT CONNECTION_ID();                  Connection ID
SELECT ROW_COUNT();                      Rows affected by the last statement
SELECT LAST_INSERT_ID();                 Last auto-increment value
HELP 'SELECT';                           Built-in help (mysql client)

-- information_schema: the catalog is queried like a table
SELECT table_name, table_rows FROM information_schema.tables
WHERE table_schema = 'sql_cheatsheet';
SELECT column_name, data_type, is_nullable FROM information_schema.columns
WHERE table_schema = 'sql_cheatsheet' AND table_name = 'employees';
SELECT constraint_name, constraint_type FROM information_schema.table_constraints
WHERE table_schema = 'sql_cheatsheet' AND table_name = 'employees';

Other dialects:
PG:  \l  \c db  \dt  \d t  \du  \q
SS:  sp_help 't';  sp_who;  SELECT * FROM sys.tables;
ORA: SELECT * FROM user_tables;  DESC t;


29. PERFORMANCE
---------------
EXPLAIN SELECT * FROM employees WHERE dept_id = 1;
EXPLAIN FORMAT=JSON SELECT * FROM employees WHERE salary > 60000;
EXPLAIN ANALYZE SELECT * FROM employees e JOIN departments d USING (dept_id);
                                         -- MySQL 8.0.18+, EXECUTES the query

ANALYZE TABLE employees;                 Updates index statistics
OPTIMIZE TABLE employees;                Defragments / rebuilds
CHECK TABLE employees;                   Checks
REPAIR TABLE employees;                  Repairs (MyISAM and a few others)

SET profiling = 1;                       Deprecated: use Performance Schema
SHOW PROFILES;
SHOW STATUS LIKE 'Slow_queries';
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;

How to read EXPLAIN:
type    from best to worst: const, eq_ref, ref, range, index, ALL (full scan)
key     index actually used (NULL = none)
rows    estimated rows to read: fewer is better
Extra   "Using filesort" and "Using temporary" are warning signs

Quick tricks:
- Index the filter and join columns.
- Select only the columns you need.
- Do not use functions on indexed columns in the WHERE:
  WHERE YEAR(d) = 2024  ->  WHERE d >= '2024-01-01' AND d < '2025-01-01'
- Avoid leading wildcards: LIKE '%x'.
- For deep pagination use the "keyset" method instead of a large OFFSET.
- With large subqueries, EXISTS is often better than IN.


30. IMPORT, EXPORT, BACKUP
--------------------------
-- Export to CSV (server side: needs the FILE privilege and the secure_file_priv folder)
SELECT * FROM employees
INTO OUTFILE '/var/lib/mysql-files/employees.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Import from CSV (the target table must exist; the output file must not already exist)
CREATE TABLE IF NOT EXISTS emp_copy LIKE employees;
LOAD DATA INFILE '/var/lib/mysql-files/employees.csv'
INTO TABLE emp_copy
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;                          -- skip the header
-- LOAD DATA LOCAL INFILE 'file.csv' ... -- file on the client computer (must be enabled)

SHOW VARIABLES LIKE 'secure_file_priv';

From the command line (in the TERMINAL, not the SQL prompt):

# Backup
mysqldump -u root -p sql_cheatsheet > backup.sql
mysqldump -u root -p --all-databases > everything.sql
mysqldump -u root -p --no-data sql_cheatsheet > schema_only.sql
mysqldump -u root -p --routines --triggers --events sql_cheatsheet > full.sql
mysqldump -u root -p sql_cheatsheet employees departments > two_tables.sql

# Restore
mysql -u root -p sql_cheatsheet < backup.sql
mysql -u root -p -e "source backup.sql"

# Run a query from the shell
mysql -u root -p -e "SELECT COUNT(*) FROM sql_cheatsheet.employees"

# PostgreSQL
pg_dump -U postgres mydb > backup.sql
psql -U postgres mydb < backup.sql


31. PARTITIONING
----------------
CREATE TABLE sales (
    sale_id   INT NOT NULL AUTO_INCREMENT,
    sale_date DATE NOT NULL,
    amount    DECIMAL(10,2),
    PRIMARY KEY (sale_id, sale_date)     -- the partition key must be in every unique key
)
PARTITION BY RANGE (YEAR(sale_date)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION pmax  VALUES LESS THAN MAXVALUE
);

INSERT INTO sales (sale_date, amount) VALUES ('2023-05-01', 100), ('2024-06-01', 200);
SELECT * FROM sales PARTITION (p2024);

ALTER TABLE sales REORGANIZE PARTITION pmax INTO (
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pmax  VALUES LESS THAN MAXVALUE
);
ALTER TABLE sales DROP PARTITION p2023;       -- immediately deletes that partition's data
ALTER TABLE sales TRUNCATE PARTITION p2024;
SELECT partition_name, table_rows FROM information_schema.partitions WHERE table_name = 'sales';
DROP TABLE sales;

Partition types:
RANGE   by value ranges (dates, ids)
LIST    by explicit lists (VALUES IN (1,2,3))
HASH    hash of an expression (even distribution)
KEY     MySQL's internal hash on one or more columns


32. DATA TYPES
--------------
Integers:         TINYINT (1 byte), SMALLINT (2), MEDIUMINT (3), INT (4), BIGINT (8);
                  add UNSIGNED for non-negative only
Exact decimals:   DECIMAL(p,s) / NUMERIC(p,s)  -> use for money
Approximate:      FLOAT, DOUBLE
Boolean:          BOOLEAN / BOOL (alias of TINYINT(1)); PG has a true BOOLEAN; SS: BIT
Fixed text:       CHAR(n)
Variable text:    VARCHAR(n), TINYTEXT, TEXT, MEDIUMTEXT, LONGTEXT
Binary:           BINARY(n), VARBINARY(n), BLOB family
Date / time:      DATE, TIME, DATETIME, TIMESTAMP, YEAR
Others:           ENUM('a','b'), SET('x','y'), JSON, BIT(n), POINT, GEOMETRY

Try it:
CREATE TABLE type_demo (
    id        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    flag      BOOLEAN DEFAULT TRUE,
    price     DECIMAL(8,2),
    ratio     DOUBLE,
    code      CHAR(3),
    title     VARCHAR(100),
    notes     TEXT,
    status    ENUM('new','active','closed') DEFAULT 'new',
    tags      SET('a','b','c'),
    born      DATE,
    seen_at   DATETIME,
    updated   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    extra     JSON
);
DROP TABLE type_demo;

Equivalents between dialects:
                MySQL            PostgreSQL                      SQL Server    Oracle
Auto ID         AUTO_INCREMENT   SERIAL / GENERATED AS IDENTITY  IDENTITY(1,1) GENERATED AS IDENTITY
Long text       TEXT             TEXT                            VARCHAR(MAX)  CLOB
Integer         INT              INTEGER                         INT           NUMBER(10)
Date and time   DATETIME         TIMESTAMP                       DATETIME2     TIMESTAMP
String          VARCHAR          VARCHAR                         NVARCHAR      VARCHAR2


33. DIFFERENCES BETWEEN DIALECTS
--------------------------------
Limit rows:           MySQL LIMIT n | PG LIMIT n | SS TOP n / OFFSET FETCH | ORA FETCH FIRST n ROWS ONLY
Concatenate:          MySQL CONCAT() | PG || | SS + or CONCAT() | ORA ||
Current time:         MySQL NOW() | PG NOW() | SS GETDATE() | ORA SYSDATE
Default for NULL:     MySQL IFNULL | PG COALESCE | SS ISNULL | ORA NVL
String length:        MySQL LENGTH | PG LENGTH | SS LEN | ORA LENGTH
Auto ID:              MySQL AUTO_INCREMENT | PG SERIAL | SS IDENTITY | ORA IDENTITY / sequence
Upsert:               MySQL ON DUPLICATE KEY UPDATE | PG ON CONFLICT DO UPDATE | SS MERGE | ORA MERGE
Full outer join:      MySQL simulated with UNION | PG, SS, ORA supported
Set difference:       MySQL EXCEPT (8.0.31+) | PG EXCEPT | SS EXCEPT | ORA MINUS
Join values:          MySQL GROUP_CONCAT | PG STRING_AGG | SS STRING_AGG | ORA LISTAGG
Quoted names:         MySQL `name` | PG "name" | SS [name] | ORA "name"
Show tables:          MySQL SHOW TABLES | PG \dt | SS sys.tables | ORA user_tables
Date format:          MySQL DATE_FORMAT | PG TO_CHAR | SS FORMAT | ORA TO_CHAR
Boolean:              MySQL TINYINT(1) | PG BOOLEAN | SS BIT | ORA NUMBER(1)
Return the row:       MySQL no | PG RETURNING | SS OUTPUT | ORA RETURNING INTO
Case-insensitive:     MySQL default collation | PG ILIKE | SS default collation | ORA UPPER()


34. EXECUTION ORDER AND COMMAND CATEGORIES
------------------------------------------
LOGICAL order in which the database runs a query:
 1. FROM / JOIN      chooses and combines the tables
 2. WHERE            filters the rows
 3. GROUP BY         creates the groups
 4. HAVING           filters the groups
 5. SELECT           computes columns and aliases
 6. DISTINCT         removes duplicates
 7. Window functions
 8. ORDER BY         sorts (can use aliases)
 9. LIMIT / OFFSET   reduces the result

This is why you can NOT use a SELECT alias in the WHERE (it does not exist yet),
but you can use it in ORDER BY. MySQL also allows it in GROUP BY and HAVING.

Command categories:
DDL  Data definition          CREATE  ALTER  DROP  TRUNCATE  RENAME
DML  Data manipulation        INSERT  UPDATE  DELETE  MERGE  REPLACE
DQL  Querying                 SELECT
DCL  Access control           GRANT  REVOKE
TCL  Transaction control      COMMIT  ROLLBACK  SAVEPOINT  START TRANSACTION

Keys:
Primary key         Unique and non-null, identifies the row (one per table)
Foreign key         Points to the primary/unique key of another table
Unique key          No duplicates (NULLs are allowed)
Composite key       Key made of 2 or more columns
Candidate key       Any set of columns that could be the primary key
Surrogate key       Artificial ID (e.g. AUTO_INCREMENT)

DELETE, TRUNCATE and DROP:
                         DELETE             TRUNCATE                  DROP
What it removes          chosen rows        all rows                  the whole table
WHERE                    yes                no                        no
Resets auto-increment    no                 yes                       not applicable
Fires triggers           yes                no                        no
Can be rolled back       yes                no in MySQL (yes in PG/SS) no in MySQL
Type                     DML                DDL                       DDL


=====================================================
The end. Happy studying SQL!
