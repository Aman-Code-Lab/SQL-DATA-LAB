# 📘 Complete SQL Notes

A complete, beginner-to-advanced SQL reference: every topic, explained, with commands and examples.
Examples use **MySQL** syntax by default. Differences for **PostgreSQL** and **SQL Server** are marked where important.

---

## 📑 Table of Contents

1. [Introduction](#1-introduction)
2. [Types of SQL Commands](#2-types-of-sql-commands)
3. [Data Types](#3-data-types)
4. [Database Commands](#4-database-commands)
5. [Table Commands (DDL)](#5-table-commands-ddl)
6. [Constraints](#6-constraints)
7. [DML: INSERT, UPDATE, DELETE](#7-dml-insert-update-delete)
8. [SELECT and Filtering (DQL)](#8-select-and-filtering-dql)
9. [Operators](#9-operators)
10. [Sorting, Limiting, Distinct](#10-sorting-limiting-distinct)
11. [Aliases](#11-aliases)
12. [Functions](#12-functions)
13. [GROUP BY and HAVING](#13-group-by-and-having)
14. [Joins](#14-joins)
15. [Set Operations](#15-set-operations)
16. [Subqueries](#16-subqueries)
17. [CTE (WITH clause)](#17-cte-with-clause)
18. [Window Functions](#18-window-functions)
19. [CASE and Conditional Logic](#19-case-and-conditional-logic)
20. [Views](#20-views)
21. [Indexes](#21-indexes)
22. [Keys and Relationships](#22-keys-and-relationships)
23. [Normalization](#23-normalization)
24. [Transactions (TCL) and ACID](#24-transactions-tcl-and-acid)
25. [DCL: Users and Permissions](#25-dcl-users-and-permissions)
26. [Stored Procedures, Functions, Triggers, Cursors](#26-stored-procedures-functions-triggers-cursors)
27. [Temporary Tables](#27-temporary-tables)
28. [Order of Execution](#28-order-of-execution)
29. [Performance and Optimization](#29-performance-and-optimization)
30. [Advanced Topics](#30-advanced-topics)
31. [Interview Questions](#31-interview-questions)
32. [Quick Cheat Sheet](#32-quick-cheat-sheet)
33. [Practice Sample Schema](#33-practice-sample-schema)
34. [Additional Topics (Missing Pieces)](#34-additional-topics-missing-pieces)
34. [Setup, Tools and CLI Commands](#34-setup-tools-and-cli-commands)
35. [DBMS Concepts (Theory)](#35-dbms-concepts-theory)
36. [Schemas, Sequences, Synonyms, Auto-increment](#36-schemas-sequences-synonyms-auto-increment)
37. [Extra Clauses, Operators and Functions](#37-extra-clauses-operators-and-functions)
38. [Triggers and Routines: More Detail](#38-triggers-and-routines-more-detail)
39. [Security, Backup and Recovery](#39-security-backup-and-recovery)
40. [Internals: Indexes, Execution and Join Algorithms](#40-internals-indexes-execution-and-join-algorithms)
41. [MySQL vs PostgreSQL vs SQL Server vs Oracle](#41-mysql-vs-postgresql-vs-sql-server-vs-oracle)
42. [Practice Problems with Solutions](#42-practice-problems-with-solutions)
43. [Common Errors and Fixes](#43-common-errors-and-fixes)
44. [Best Practices and Naming Conventions](#44-best-practices-and-naming-conventions)
45. [A–Z Command Index](#45-az-command-index)

---

## 1. Introduction

### What is SQL?
**SQL (Structured Query Language)** is the standard language used to store, retrieve, update, and manage data in **Relational Database Management Systems (RDBMS)**.

### What is a Database?
An organized collection of data stored electronically.

### What is a DBMS / RDBMS?
- **DBMS**: software to manage databases.
- **RDBMS**: DBMS that stores data in **tables** (rows and columns) with relationships. Examples: MySQL, PostgreSQL, Oracle, SQL Server, SQLite, MariaDB.

### Key Terms
| Term | Meaning |
|---|---|
| Table | Collection of related data (like a spreadsheet) |
| Row / Record / Tuple | One entry in a table |
| Column / Field / Attribute | One property of the data |
| Primary Key | Uniquely identifies each row |
| Foreign Key | Links to the primary key of another table |
| Schema | Structure/blueprint of the database |
| Query | A request for data |
| NULL | Missing/unknown value (not 0, not empty string) |

### SQL vs NoSQL
| SQL | NoSQL |
|---|---|
| Tables, fixed schema | Documents / key-value / graph, flexible schema |
| Vertical scaling (mostly) | Horizontal scaling |
| ACID strong | Often BASE (eventual consistency) |
| MySQL, PostgreSQL | MongoDB, Redis, Cassandra |

### SQL is case-insensitive for keywords
`SELECT` = `select`. Convention: keywords UPPERCASE, names lowercase. Every statement ends with `;`.

### Comments
```sql
-- single line comment
# single line (MySQL only)
/* multi
   line comment */
```

---

## 2. Types of SQL Commands

| Type | Full Form | Purpose | Commands |
|---|---|---|---|
| **DDL** | Data Definition Language | Define/modify structure | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME` |
| **DML** | Data Manipulation Language | Modify data | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** | Data Query Language | Fetch data | `SELECT` |
| **DCL** | Data Control Language | Permissions | `GRANT`, `REVOKE` |
| **TCL** | Transaction Control Language | Manage transactions | `COMMIT`, `ROLLBACK`, `SAVEPOINT`, `SET TRANSACTION` |

---

## 3. Data Types

### Numeric
| Type | Description |
|---|---|
| `TINYINT` | 1 byte (-128 to 127) |
| `SMALLINT` | 2 bytes |
| `MEDIUMINT` | 3 bytes (MySQL) |
| `INT` / `INTEGER` | 4 bytes |
| `BIGINT` | 8 bytes |
| `DECIMAL(p,s)` / `NUMERIC(p,s)` | Exact fixed-point. `DECIMAL(10,2)` = 10 digits, 2 after the point |
| `FLOAT`, `DOUBLE`, `REAL` | Approximate floating-point |
| `BIT` | Bit value |
| `BOOLEAN` | TRUE/FALSE (in MySQL alias for TINYINT(1)) |

### String
| Type | Description |
|---|---|
| `CHAR(n)` | Fixed length, padded with spaces |
| `VARCHAR(n)` | Variable length up to n |
| `TEXT`, `MEDIUMTEXT`, `LONGTEXT` | Large text |
| `BINARY`, `VARBINARY`, `BLOB` | Binary data |
| `ENUM('a','b')` | One value from a list (MySQL) |
| `SET('a','b')` | Zero or more values from a list (MySQL) |

### Date & Time
| Type | Format |
|---|---|
| `DATE` | `YYYY-MM-DD` |
| `TIME` | `HH:MM:SS` |
| `DATETIME` | `YYYY-MM-DD HH:MM:SS` |
| `TIMESTAMP` | Date+time, usually stored in UTC, auto-update possible |
| `YEAR` | `YYYY` |

### Others
`JSON`, `UUID` (PostgreSQL), `XML`, `ARRAY` (PostgreSQL), `GEOMETRY`/spatial types.

**Tip:** Use `DECIMAL` for money, never `FLOAT`.

---

## 4. Database Commands

```sql
-- Create
CREATE DATABASE company;
CREATE DATABASE IF NOT EXISTS company;

-- List all databases
SHOW DATABASES;                -- MySQL
\l                             -- PostgreSQL (psql)

-- Select/use
USE company;                   -- MySQL
\c company                     -- PostgreSQL

-- Show current database
SELECT DATABASE();             -- MySQL
SELECT current_database();     -- PostgreSQL

-- Drop (deletes everything!)
DROP DATABASE company;
DROP DATABASE IF EXISTS company;

-- Show tables
SHOW TABLES;                   -- MySQL
\dt                            -- PostgreSQL

-- Describe table structure
DESCRIBE employees;            -- or DESC employees;
SHOW COLUMNS FROM employees;
SHOW CREATE TABLE employees;
```

---

## 5. Table Commands (DDL)

### CREATE TABLE
```sql
CREATE TABLE employees (
    emp_id      INT PRIMARY KEY AUTO_INCREMENT,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50),
    email       VARCHAR(100) UNIQUE,
    salary      DECIMAL(10,2) DEFAULT 30000.00,
    hire_date   DATE,
    dept_id     INT,
    CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS t (...);
```

### Create table from another table
```sql
CREATE TABLE emp_backup AS SELECT * FROM employees;          -- copy structure + data
CREATE TABLE emp_copy   AS SELECT * FROM employees WHERE 1=0; -- structure only
CREATE TABLE emp_like LIKE employees;                         -- MySQL: structure incl. indexes
```

### ALTER TABLE
```sql
-- Add column
ALTER TABLE employees ADD phone VARCHAR(15);
ALTER TABLE employees ADD phone VARCHAR(15) AFTER email;  -- MySQL position

-- Add multiple columns
ALTER TABLE employees ADD (city VARCHAR(30), state VARCHAR(30));

-- Modify column datatype
ALTER TABLE employees MODIFY phone VARCHAR(20);           -- MySQL
ALTER TABLE employees ALTER COLUMN phone TYPE VARCHAR(20);-- PostgreSQL
ALTER TABLE employees ALTER COLUMN phone VARCHAR(20);     -- SQL Server

-- Rename column
ALTER TABLE employees RENAME COLUMN phone TO mobile;
ALTER TABLE employees CHANGE phone mobile VARCHAR(20);    -- MySQL (rename + redefine)

-- Drop column
ALTER TABLE employees DROP COLUMN mobile;

-- Rename table
ALTER TABLE employees RENAME TO staff;
RENAME TABLE staff TO employees;                          -- MySQL

-- Defaults
ALTER TABLE employees ALTER COLUMN salary SET DEFAULT 25000;
ALTER TABLE employees ALTER COLUMN salary DROP DEFAULT;

-- Constraints
ALTER TABLE employees ADD CONSTRAINT uq_email UNIQUE (email);
ALTER TABLE employees ADD PRIMARY KEY (emp_id);
ALTER TABLE employees ADD CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);
ALTER TABLE employees ADD CONSTRAINT chk_sal CHECK (salary > 0);
ALTER TABLE employees DROP PRIMARY KEY;                   -- MySQL
ALTER TABLE employees DROP FOREIGN KEY fk_dept;           -- MySQL
ALTER TABLE employees DROP CONSTRAINT uq_email;           -- PostgreSQL / SQL Server
ALTER TABLE employees DROP INDEX uq_email;                -- MySQL (for UNIQUE)
```

### DROP vs TRUNCATE vs DELETE
| | `DROP` | `TRUNCATE` | `DELETE` |
|---|---|---|---|
| Type | DDL | DDL | DML |
| Removes | Table structure + data | All rows | Rows (all or filtered) |
| `WHERE` allowed | No | No | Yes |
| Rollback | No (mostly) | No in MySQL (yes in PostgreSQL/SQL Server inside a transaction) | Yes |
| Resets AUTO_INCREMENT | N/A | Yes | No |
| Speed | Fast | Fast | Slower (row by row, logged) |
| Triggers fire | No | No | Yes |

```sql
DROP TABLE employees;
DROP TABLE IF EXISTS employees;
TRUNCATE TABLE employees;
DELETE FROM employees;
```

---

## 6. Constraints

Rules applied on columns to keep data valid.

| Constraint | Meaning |
|---|---|
| `NOT NULL` | Column cannot be NULL |
| `UNIQUE` | All values different (allows NULL; multiple NULLs allowed in most DBs) |
| `PRIMARY KEY` | `NOT NULL` + `UNIQUE`; one per table (can be composite) |
| `FOREIGN KEY` | Value must exist in the referenced table |
| `CHECK` | Value must satisfy a condition |
| `DEFAULT` | Default value if none supplied |
| `AUTO_INCREMENT` | Auto-generated sequence (MySQL). `SERIAL`/`IDENTITY` in PostgreSQL, `IDENTITY(1,1)` in SQL Server |

```sql
CREATE TABLE students (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(50) NOT NULL,
    email     VARCHAR(100) UNIQUE,
    age       INT CHECK (age >= 18),
    city      VARCHAR(30) DEFAULT 'Delhi',
    course_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Composite primary key
CREATE TABLE enrollments (
    student_id INT,
    course_id  INT,
    PRIMARY KEY (student_id, course_id)
);
```

### Referential actions (ON DELETE / ON UPDATE)
| Action | Behavior |
|---|---|
| `CASCADE` | Delete/update child rows automatically |
| `SET NULL` | Set the foreign key in child to NULL |
| `SET DEFAULT` | Set to default value |
| `RESTRICT` / `NO ACTION` | Block the operation if child rows exist |

---

## 7. DML: INSERT, UPDATE, DELETE

### INSERT
```sql
-- All columns (order must match)
INSERT INTO employees VALUES (1, 'Amit', 'Sharma', 'amit@x.com', 50000, '2023-01-15', 10);

-- Specific columns (recommended)
INSERT INTO employees (first_name, last_name, salary) VALUES ('Riya', 'Verma', 45000);

-- Multiple rows
INSERT INTO employees (first_name, salary) VALUES ('A', 100), ('B', 200), ('C', 300);

-- From another table
INSERT INTO emp_backup SELECT * FROM employees WHERE salary > 40000;
INSERT INTO emp_backup (first_name, salary) SELECT first_name, salary FROM employees;

-- Ignore duplicates (MySQL)
INSERT IGNORE INTO employees (...) VALUES (...);
```

### UPDATE
```sql
UPDATE employees SET salary = 60000 WHERE emp_id = 1;
UPDATE employees SET salary = salary * 1.10 WHERE dept_id = 10;
UPDATE employees SET first_name = 'X', last_name = 'Y' WHERE emp_id = 2;

-- Update with JOIN (MySQL)
UPDATE employees e
JOIN departments d ON e.dept_id = d.dept_id
SET e.salary = e.salary * 1.05
WHERE d.dept_name = 'IT';

-- PostgreSQL
UPDATE employees e SET salary = salary * 1.05
FROM departments d WHERE e.dept_id = d.dept_id AND d.dept_name = 'IT';
```
> ⚠️ Without `WHERE`, **all rows** are updated.

### DELETE
```sql
DELETE FROM employees WHERE emp_id = 5;
DELETE FROM employees WHERE salary < 20000;
DELETE FROM employees;                        -- all rows

-- Delete with JOIN (MySQL)
DELETE e FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Closed';
```

### UPSERT (insert or update)
```sql
-- MySQL
INSERT INTO employees (emp_id, first_name, salary) VALUES (1, 'Amit', 70000)
ON DUPLICATE KEY UPDATE salary = VALUES(salary);

-- PostgreSQL / SQLite
INSERT INTO employees (emp_id, first_name, salary) VALUES (1, 'Amit', 70000)
ON CONFLICT (emp_id) DO UPDATE SET salary = EXCLUDED.salary;

-- MySQL REPLACE (deletes old row, inserts new)
REPLACE INTO employees (emp_id, first_name) VALUES (1, 'Amit');

-- SQL Server / Oracle / standard
MERGE INTO target t
USING source s ON t.id = s.id
WHEN MATCHED THEN UPDATE SET t.val = s.val
WHEN NOT MATCHED THEN INSERT (id, val) VALUES (s.id, s.val);
```

---

## 8. SELECT and Filtering (DQL)

### Basic SELECT
```sql
SELECT * FROM employees;
SELECT first_name, salary FROM employees;
SELECT first_name, salary * 12 AS annual_salary FROM employees;
SELECT 2 + 3;                                  -- no table needed
SELECT DISTINCT dept_id FROM employees;
```

### WHERE
```sql
SELECT * FROM employees WHERE salary > 50000;
SELECT * FROM employees WHERE dept_id = 10 AND salary >= 40000;
SELECT * FROM employees WHERE dept_id = 10 OR dept_id = 20;
SELECT * FROM employees WHERE NOT dept_id = 10;
```

### Full SELECT syntax
```sql
SELECT   columns
FROM     table
JOIN     other ON condition
WHERE    row_condition
GROUP BY columns
HAVING   group_condition
ORDER BY columns
LIMIT    n OFFSET m;
```

---

## 9. Operators

### Comparison
`=`, `<>` or `!=`, `>`, `<`, `>=`, `<=`, `<=>` (NULL-safe equal, MySQL)

### Logical
`AND`, `OR`, `NOT`  (precedence: `NOT` > `AND` > `OR`, use parentheses)

### Special operators
```sql
-- BETWEEN (inclusive)
SELECT * FROM employees WHERE salary BETWEEN 30000 AND 50000;
SELECT * FROM employees WHERE hire_date BETWEEN '2023-01-01' AND '2023-12-31';
SELECT * FROM employees WHERE salary NOT BETWEEN 30000 AND 50000;

-- IN
SELECT * FROM employees WHERE dept_id IN (10, 20, 30);
SELECT * FROM employees WHERE dept_id NOT IN (10, 20);

-- LIKE (pattern matching)   % = any characters, _ = exactly one character
SELECT * FROM employees WHERE first_name LIKE 'A%';     -- starts with A
SELECT * FROM employees WHERE first_name LIKE '%a';     -- ends with a
SELECT * FROM employees WHERE first_name LIKE '%am%';   -- contains am
SELECT * FROM employees WHERE first_name LIKE '_m%';    -- 2nd letter m
SELECT * FROM employees WHERE first_name LIKE 'A___';   -- A + exactly 3 chars
SELECT * FROM employees WHERE first_name NOT LIKE 'A%';
SELECT * FROM t WHERE col LIKE '50\%%';                 -- escape a literal %
-- PostgreSQL: ILIKE = case-insensitive LIKE

-- REGEXP / RLIKE (MySQL), ~ (PostgreSQL)
SELECT * FROM employees WHERE first_name REGEXP '^[AEIOU]';

-- NULL handling
SELECT * FROM employees WHERE email IS NULL;
SELECT * FROM employees WHERE email IS NOT NULL;
-- NOTE: "= NULL" never works. Use IS NULL.

-- EXISTS
SELECT * FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id);

-- ANY / ALL / SOME
SELECT * FROM employees WHERE salary > ANY (SELECT salary FROM employees WHERE dept_id = 10);
SELECT * FROM employees WHERE salary > ALL (SELECT salary FROM employees WHERE dept_id = 10);
```

### Arithmetic
`+`, `-`, `*`, `/`, `%` (or `MOD()`), integer division `DIV` (MySQL)

### Bitwise
`&`, `|`, `^`, `~`, `<<`, `>>`

### Concatenation
```sql
SELECT CONCAT(first_name, ' ', last_name) FROM employees;  -- MySQL, PostgreSQL
SELECT first_name || ' ' || last_name FROM employees;      -- PostgreSQL, Oracle, SQLite
SELECT first_name + ' ' + last_name FROM employees;        -- SQL Server
```

### NULL behavior
- Any arithmetic with NULL = NULL (`5 + NULL` = NULL)
- `NULL = NULL` is not TRUE (it's unknown)
- Aggregates (`SUM`, `AVG`, ...) ignore NULL; `COUNT(*)` counts all rows, `COUNT(col)` skips NULL

---

## 10. Sorting, Limiting, Distinct

### ORDER BY
```sql
SELECT * FROM employees ORDER BY salary;                   -- ASC default
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY dept_id ASC, salary DESC; -- multiple
SELECT * FROM employees ORDER BY 3;                        -- by column position
SELECT * FROM employees ORDER BY salary DESC NULLS LAST;   -- PostgreSQL/Oracle
SELECT * FROM employees ORDER BY RAND();                   -- random (MySQL)
```

### LIMIT / OFFSET / TOP / FETCH
```sql
SELECT * FROM employees LIMIT 5;                   -- MySQL, PostgreSQL, SQLite
SELECT * FROM employees LIMIT 5 OFFSET 10;         -- skip 10, take 5 (pagination)
SELECT * FROM employees LIMIT 10, 5;               -- MySQL: offset, count
SELECT TOP 5 * FROM employees;                     -- SQL Server
SELECT * FROM employees FETCH FIRST 5 ROWS ONLY;   -- Oracle, standard SQL
SELECT * FROM employees ORDER BY id OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY; -- SQL Server/Oracle
```

**Nth highest salary**
```sql
SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 1;  -- 2nd highest

SELECT MAX(salary) FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);                          -- 2nd highest

SELECT salary FROM (
  SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) rnk FROM employees
) t WHERE rnk = 3;                                                           -- 3rd highest
```

### DISTINCT
```sql
SELECT DISTINCT city FROM employees;
SELECT DISTINCT city, dept_id FROM employees;     -- unique combinations
SELECT COUNT(DISTINCT city) FROM employees;
```

---

## 11. Aliases

```sql
SELECT first_name AS name, salary * 12 AS "Annual Salary" FROM employees;
SELECT e.first_name, d.dept_name FROM employees AS e JOIN departments AS d ON e.dept_id = d.dept_id;
```
- Column alias: rename output column. Table alias: shorten table names, needed for self joins.
- `AS` is optional. Use quotes if the alias has spaces.
- You cannot use a SELECT alias in `WHERE` (it runs before SELECT), but you can in `ORDER BY` (and in MySQL `GROUP BY`/`HAVING`).

---

## 12. Functions

### 12.1 Aggregate Functions
Work on a set of rows, return one value.

| Function | Purpose |
|---|---|
| `COUNT(*)` | Number of rows |
| `COUNT(col)` | Non-NULL values |
| `COUNT(DISTINCT col)` | Unique non-NULL values |
| `SUM(col)` | Total |
| `AVG(col)` | Average |
| `MIN(col)` / `MAX(col)` | Smallest / largest |
| `GROUP_CONCAT(col)` | Concatenate values (MySQL) |
| `STRING_AGG(col, ',')` | Concatenate values (PostgreSQL, SQL Server) |
| `STDDEV()`, `VARIANCE()` | Statistics |

```sql
SELECT COUNT(*), SUM(salary), AVG(salary), MIN(salary), MAX(salary) FROM employees;
SELECT GROUP_CONCAT(first_name ORDER BY first_name SEPARATOR ', ') FROM employees;
```

### 12.2 String Functions
| Function | Example | Result |
|---|---|---|
| `UPPER(s)` / `LOWER(s)` | `UPPER('abc')` | ABC |
| `LENGTH(s)` / `CHAR_LENGTH(s)` | `LENGTH('abc')` | 3 (`LEN()` in SQL Server) |
| `CONCAT(a,b,..)` | `CONCAT('a','b')` | ab |
| `CONCAT_WS(sep,a,b)` | `CONCAT_WS('-','a','b')` | a-b |
| `SUBSTRING(s,pos,len)` / `SUBSTR` | `SUBSTRING('abcdef',2,3)` | bcd |
| `LEFT(s,n)` / `RIGHT(s,n)` | `LEFT('abcdef',2)` | ab |
| `TRIM(s)` / `LTRIM` / `RTRIM` | `TRIM('  a  ')` | a |
| `REPLACE(s,from,to)` | `REPLACE('hello','l','x')` | hexxo |
| `REVERSE(s)` | `REVERSE('abc')` | cba |
| `INSTR(s,sub)` / `LOCATE(sub,s)` / `POSITION` | `INSTR('hello','l')` | 3 |
| `LPAD(s,n,pad)` / `RPAD` | `LPAD('5',3,'0')` | 005 |
| `REPEAT(s,n)` | `REPEAT('ab',2)` | abab |
| `ASCII(c)` / `CHAR(n)` | `ASCII('A')` | 65 |
| `FORMAT(n,d)` | `FORMAT(1234.5,2)` | 1,234.50 |
| `STRCMP(a,b)` | | 0/1/-1 |
| `INITCAP(s)` | (PostgreSQL/Oracle) | Hello World |
| `SPLIT_PART(s,delim,n)` | (PostgreSQL) | |
| `SUBSTRING_INDEX(s,delim,n)` | (MySQL) | |

### 12.3 Numeric Functions
| Function | Purpose |
|---|---|
| `ROUND(n,d)` | Round (`ROUND(3.456,2)` = 3.46) |
| `CEIL(n)` / `CEILING` | Round up |
| `FLOOR(n)` | Round down |
| `TRUNCATE(n,d)` | Cut decimals (MySQL) / `TRUNC` (PostgreSQL, Oracle) |
| `ABS(n)` | Absolute value |
| `MOD(a,b)` or `a % b` | Remainder |
| `POWER(a,b)` / `POW` | Exponent |
| `SQRT(n)` | Square root |
| `SIGN(n)` | -1, 0, 1 |
| `RAND()` / `RANDOM()` | Random number |
| `GREATEST(a,b,..)` / `LEAST(a,b,..)` | Max/min among values |
| `PI()`, `EXP()`, `LOG()`, `LN()`, `SIN()`, `COS()` | Math |

### 12.4 Date & Time Functions (MySQL)
| Function | Purpose |
|---|---|
| `NOW()` / `CURRENT_TIMESTAMP` | Current date and time |
| `CURDATE()` / `CURRENT_DATE` | Current date |
| `CURTIME()` | Current time |
| `DATE(x)`, `YEAR(x)`, `MONTH(x)`, `DAY(x)`, `HOUR(x)`, `MINUTE(x)`, `SECOND(x)` | Extract parts |
| `DAYNAME(x)`, `MONTHNAME(x)`, `DAYOFWEEK(x)`, `DAYOFYEAR(x)`, `WEEK(x)`, `QUARTER(x)` | Names/numbers |
| `EXTRACT(YEAR FROM x)` | Standard extraction |
| `DATE_ADD(d, INTERVAL 7 DAY)` / `DATE_SUB` | Add/subtract |
| `DATEDIFF(d1, d2)` | Difference in days |
| `TIMESTAMPDIFF(MONTH, d1, d2)` | Difference in given unit |
| `DATE_FORMAT(d, '%Y-%m-%d')` | Format date |
| `STR_TO_DATE('15-01-2023','%d-%m-%Y')` | String to date |
| `LAST_DAY(d)` | Last day of the month |
| `ADDDATE`, `SUBDATE`, `PERIOD_DIFF` | More |

```sql
SELECT DATE_FORMAT(NOW(), '%d %M %Y');           -- 03 November 2026
SELECT DATEDIFF('2026-12-31', '2026-11-03');
SELECT * FROM orders WHERE order_date >= CURDATE() - INTERVAL 30 DAY;
SELECT YEAR(hire_date) AS yr, COUNT(*) FROM employees GROUP BY YEAR(hire_date);
```

Common format codes: `%Y` 4-digit year, `%y` 2-digit, `%m` month 01-12, `%M` month name, `%d` day, `%H` hour 24h, `%h` hour 12h, `%i` minutes, `%s` seconds, `%W` weekday name, `%p` AM/PM.

**PostgreSQL equivalents:** `NOW()`, `CURRENT_DATE`, `AGE(d1,d2)`, `DATE_TRUNC('month', d)`, `TO_CHAR(d,'YYYY-MM-DD')`, `d + INTERVAL '7 days'`, `EXTRACT(...)`.
**SQL Server:** `GETDATE()`, `DATEADD(day,7,d)`, `DATEDIFF(day,d1,d2)`, `FORMAT(d,'yyyy-MM-dd')`, `DATEPART()`.

### 12.5 NULL-handling & Conditional Functions
| Function | Meaning |
|---|---|
| `IFNULL(a,b)` (MySQL) / `ISNULL(a,b)` (SQL Server) / `NVL(a,b)` (Oracle) | If a is NULL, use b |
| `COALESCE(a,b,c,...)` | First non-NULL value (standard) |
| `NULLIF(a,b)` | NULL if a = b, else a (avoid divide by zero) |
| `IF(cond, yes, no)` | MySQL inline condition |
| `IIF(cond, yes, no)` | SQL Server |
| `CASE WHEN ...` | Standard (see section 19) |

```sql
SELECT COALESCE(phone, email, 'N/A') FROM employees;
SELECT salary / NULLIF(bonus, 0) FROM employees;
```

### 12.6 Type Conversion
```sql
SELECT CAST('123' AS UNSIGNED);
SELECT CAST(salary AS CHAR);
SELECT CAST('2023-01-15' AS DATE);
SELECT CONVERT('123', SIGNED);          -- MySQL
SELECT '123'::INT;                      -- PostgreSQL shorthand
```

### 12.7 JSON Functions (MySQL)
```sql
SELECT JSON_EXTRACT(data, '$.name') FROM t;
SELECT data->'$.name', data->>'$.name' FROM t;   -- ->> unquotes
SELECT JSON_OBJECT('a', 1, 'b', 2);
SELECT JSON_ARRAY(1, 2, 3);
-- PostgreSQL: data->'name', data->>'name', jsonb operators @>, ?
```

### 12.8 Other utility
`DATABASE()`, `USER()`, `VERSION()`, `LAST_INSERT_ID()`, `ROW_COUNT()`, `UUID()`, `MD5()`, `SHA2()`.

---

## 13. GROUP BY and HAVING

`GROUP BY` collapses rows into groups; aggregates run per group.

```sql
SELECT dept_id, COUNT(*) AS emp_count, AVG(salary) AS avg_sal
FROM employees
GROUP BY dept_id;

-- Multiple columns
SELECT dept_id, job_title, COUNT(*) FROM employees GROUP BY dept_id, job_title;

-- HAVING filters groups (WHERE filters rows)
SELECT dept_id, AVG(salary) AS avg_sal
FROM employees
WHERE hire_date >= '2020-01-01'      -- filter rows BEFORE grouping
GROUP BY dept_id
HAVING AVG(salary) > 50000;          -- filter groups AFTER grouping

-- Find duplicates
SELECT email, COUNT(*) FROM employees GROUP BY email HAVING COUNT(*) > 1;

-- ROLLUP: subtotals and grand total
SELECT dept_id, job_title, SUM(salary) FROM employees GROUP BY dept_id, job_title WITH ROLLUP;   -- MySQL
SELECT dept_id, job_title, SUM(salary) FROM employees GROUP BY ROLLUP (dept_id, job_title);       -- PostgreSQL/SQL Server
-- Also: CUBE, GROUPING SETS (PostgreSQL / SQL Server / Oracle)
```

### WHERE vs HAVING
| WHERE | HAVING |
|---|---|
| Filters rows | Filters groups |
| Before GROUP BY | After GROUP BY |
| Cannot use aggregates | Can use aggregates |

> Every non-aggregated column in `SELECT` must appear in `GROUP BY` (strictly enforced by PostgreSQL, SQL Server, and MySQL with `ONLY_FULL_GROUP_BY`).

---

## 14. Joins

Combine rows from two or more tables based on related columns.

### Sample tables
```
employees(emp_id, name, dept_id, manager_id)
departments(dept_id, dept_name)
```

### INNER JOIN
Only matching rows from both tables.
```sql
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```

### LEFT JOIN (LEFT OUTER JOIN)
All rows from left + matching from right (NULL if no match).
```sql
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- Rows in left with NO match in right (anti join)
SELECT e.* FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id WHERE d.dept_id IS NULL;
```

### RIGHT JOIN (RIGHT OUTER JOIN)
All rows from right + matching from left.
```sql
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

### FULL OUTER JOIN
All rows from both. (PostgreSQL, SQL Server, Oracle. **MySQL doesn't support it**, so emulate:)
```sql
SELECT * FROM a LEFT JOIN b ON a.id = b.id
UNION
SELECT * FROM a RIGHT JOIN b ON a.id = b.id;
```

### CROSS JOIN
Cartesian product (every row × every row). m × n rows.
```sql
SELECT * FROM employees CROSS JOIN departments;
```

### SELF JOIN
Table joined with itself (use aliases).
```sql
-- Employee and their manager
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;
```

### NATURAL JOIN
Joins on all columns with the same name (risky, avoid in production).
```sql
SELECT * FROM employees NATURAL JOIN departments;
```

### USING
```sql
SELECT * FROM employees JOIN departments USING (dept_id);
```

### Non-equi join
```sql
SELECT e.name, g.grade FROM employees e JOIN salary_grades g ON e.salary BETWEEN g.low AND g.high;
```

### Joining multiple tables
```sql
SELECT o.order_id, c.name, p.product_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;
```

### Join summary
| Join | Returns |
|---|---|
| INNER | Matches only |
| LEFT | All left + matches |
| RIGHT | All right + matches |
| FULL | All from both |
| CROSS | All combinations |
| SELF | Table with itself |
| LEFT/RIGHT ... WHERE other IS NULL | Anti join (non-matching rows) |

### LATERAL / APPLY
Subquery that can reference earlier tables in FROM.
```sql
-- PostgreSQL / MySQL 8.0.14+
SELECT d.dept_name, t.name FROM departments d
JOIN LATERAL (SELECT name FROM employees e WHERE e.dept_id = d.dept_id ORDER BY salary DESC LIMIT 3) t ON TRUE;
-- SQL Server: CROSS APPLY / OUTER APPLY
```

---

## 15. Set Operations

Combine results of two `SELECT`s. Same number of columns, compatible types.

| Operator | Result |
|---|---|
| `UNION` | Combined, duplicates removed |
| `UNION ALL` | Combined, duplicates kept (faster) |
| `INTERSECT` | Rows in both |
| `EXCEPT` (`MINUS` in Oracle) | Rows in first but not second |

```sql
SELECT city FROM customers
UNION
SELECT city FROM suppliers;

SELECT city FROM customers UNION ALL SELECT city FROM suppliers;
SELECT id FROM a INTERSECT SELECT id FROM b;
SELECT id FROM a EXCEPT SELECT id FROM b;
```
> `INTERSECT`/`EXCEPT` are supported in MySQL 8.0.31+. Column names come from the first query.

---

## 16. Subqueries

A query inside another query.

### Types
```sql
-- Scalar subquery (returns one value)
SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);

-- Multi-row subquery (IN / ANY / ALL)
SELECT * FROM employees WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = 'Delhi');

-- Subquery in FROM (derived table, needs alias)
SELECT dept_id, avg_sal FROM (
    SELECT dept_id, AVG(salary) AS avg_sal FROM employees GROUP BY dept_id
) AS t WHERE avg_sal > 50000;

-- Subquery in SELECT
SELECT name, salary, (SELECT AVG(salary) FROM employees) AS company_avg FROM employees;

-- Correlated subquery (depends on outer query, runs per row)
SELECT * FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id);

-- EXISTS / NOT EXISTS
SELECT * FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);
```

### IN vs EXISTS
- `EXISTS` stops at first match, usually faster for large subqueries.
- `NOT IN` returns nothing if the subquery contains a NULL. Prefer `NOT EXISTS`.

---

## 17. CTE (WITH clause)

Temporary named result set, easier to read than nested subqueries. (MySQL 8.0+)

```sql
WITH dept_avg AS (
    SELECT dept_id, AVG(salary) AS avg_sal FROM employees GROUP BY dept_id
)
SELECT e.name, e.salary, d.avg_sal
FROM employees e JOIN dept_avg d ON e.dept_id = d.dept_id
WHERE e.salary > d.avg_sal;

-- Multiple CTEs
WITH a AS (SELECT ...), b AS (SELECT ... FROM a) SELECT * FROM b;
```

### Recursive CTE
For hierarchies (org charts, categories) and number series.
```sql
-- Numbers 1 to 10
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 10
)
SELECT * FROM nums;

-- Employee hierarchy
WITH RECURSIVE org AS (
    SELECT emp_id, name, manager_id, 1 AS level FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.name, e.manager_id, o.level + 1
    FROM employees e JOIN org o ON e.manager_id = o.emp_id
)
SELECT * FROM org;
```
(SQL Server uses `WITH` without the word `RECURSIVE`.)

---

## 18. Window Functions

Calculate across related rows **without collapsing** them (unlike GROUP BY). (MySQL 8.0+)

```sql
function() OVER (
    PARTITION BY col      -- split into groups (optional)
    ORDER BY col          -- order inside group (optional)
    ROWS/RANGE frame      -- window frame (optional)
)
```

### Ranking
| Function | Behavior (values 100,100,90) |
|---|---|
| `ROW_NUMBER()` | 1, 2, 3 (unique) |
| `RANK()` | 1, 1, 3 (gaps after ties) |
| `DENSE_RANK()` | 1, 1, 2 (no gaps) |
| `NTILE(n)` | Divide into n buckets |
| `PERCENT_RANK()`, `CUME_DIST()` | Relative position |

```sql
SELECT name, dept_id, salary,
  ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn,
  RANK()       OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS drnk
FROM employees;

-- Top 3 earners per department
SELECT * FROM (
  SELECT *, DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS r FROM employees
) t WHERE r <= 3;

-- Remove duplicates keeping one
WITH d AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY email ORDER BY emp_id) rn FROM employees)
SELECT * FROM d WHERE rn = 1;
```

### Value (offset) functions
| Function | Purpose |
|---|---|
| `LAG(col, n, default)` | Value from n rows before |
| `LEAD(col, n, default)` | Value from n rows after |
| `FIRST_VALUE(col)` | First in window |
| `LAST_VALUE(col)` | Last in window (mind the frame) |
| `NTH_VALUE(col, n)` | Nth in window |

```sql
SELECT order_date, amount,
       LAG(amount) OVER (ORDER BY order_date) AS prev_amount,
       amount - LAG(amount) OVER (ORDER BY order_date) AS change
FROM sales;
```

### Aggregate as window
```sql
SELECT name, salary,
  SUM(salary) OVER () AS total,
  SUM(salary) OVER (PARTITION BY dept_id) AS dept_total,
  SUM(salary) OVER (ORDER BY hire_date) AS running_total,
  AVG(salary) OVER (ORDER BY hire_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM employees;
```

### Frame clauses
`ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, `n PRECEDING`, `n FOLLOWING`, `UNBOUNDED FOLLOWING`.

### Named window
```sql
SELECT name, SUM(salary) OVER w FROM employees WINDOW w AS (PARTITION BY dept_id);
```

---

## 19. CASE and Conditional Logic

```sql
-- Searched CASE
SELECT name, salary,
  CASE
    WHEN salary >= 80000 THEN 'High'
    WHEN salary >= 40000 THEN 'Medium'
    ELSE 'Low'
  END AS salary_level
FROM employees;

-- Simple CASE
SELECT CASE dept_id WHEN 10 THEN 'HR' WHEN 20 THEN 'IT' ELSE 'Other' END FROM employees;

-- In ORDER BY
SELECT * FROM employees ORDER BY CASE WHEN dept_id = 10 THEN 0 ELSE 1 END, name;

-- Conditional aggregation (pivot style)
SELECT
  SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
  SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM employees;

-- In UPDATE
UPDATE employees SET salary = CASE WHEN dept_id = 10 THEN salary * 1.1 ELSE salary * 1.05 END;
```

---

## 20. Views

A **view** is a saved query that behaves like a virtual table (stores no data itself).

```sql
CREATE VIEW high_earners AS
SELECT emp_id, name, salary FROM employees WHERE salary > 70000;

SELECT * FROM high_earners;

CREATE OR REPLACE VIEW high_earners AS SELECT ...;
ALTER VIEW high_earners AS SELECT ...;
DROP VIEW high_earners;
DROP VIEW IF EXISTS high_earners;
SHOW FULL TABLES WHERE Table_type = 'VIEW';   -- MySQL
```

- **Benefits:** simplify complex queries, security (hide columns/rows), abstraction.
- **Updatable views:** simple views (single table, no aggregates/DISTINCT/GROUP BY) allow INSERT/UPDATE/DELETE.
- `WITH CHECK OPTION` ensures changes through the view satisfy its WHERE condition.
- **Materialized views** (PostgreSQL, Oracle): store the result physically and need refreshing.
```sql
CREATE MATERIALIZED VIEW mv AS SELECT ...;
REFRESH MATERIALIZED VIEW mv;
```

---

## 21. Indexes

Data structure (usually B-Tree) that speeds up reads at the cost of slower writes and extra storage.

```sql
CREATE INDEX idx_name ON employees (last_name);
CREATE INDEX idx_dept_sal ON employees (dept_id, salary);   -- composite index
CREATE UNIQUE INDEX idx_email ON employees (email);
CREATE FULLTEXT INDEX idx_ft ON articles (body);            -- MySQL full-text search
DROP INDEX idx_name ON employees;                           -- MySQL
DROP INDEX idx_name;                                        -- PostgreSQL
SHOW INDEXES FROM employees;                                -- MySQL
```

### Types
| Type | Description |
|---|---|
| Primary / Unique | Automatically indexed |
| Clustered | Determines physical row order (one per table; InnoDB primary key) |
| Non-clustered / Secondary | Separate structure with pointers |
| Composite | Multiple columns (leftmost prefix rule) |
| Covering | Index contains all columns the query needs |
| Full-text | Text search |
| Hash | Equality lookups only |
| Bitmap | Low-cardinality columns (Oracle) |
| Partial / Filtered | Index on a subset of rows (PostgreSQL, SQL Server) |

### When indexes help / hurt
- ✅ Columns used in `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`
- ❌ Functions on indexed column (`WHERE YEAR(date) = 2023`) prevent usage, so rewrite as a range
- ❌ Leading wildcard `LIKE '%abc'` can't use the index
- ❌ Too many indexes slow `INSERT`/`UPDATE`/`DELETE`
- ❌ Low-cardinality columns (e.g. gender) gain little

---

## 22. Keys and Relationships

### Keys
| Key | Description |
|---|---|
| Super key | Any set of columns that uniquely identifies a row |
| Candidate key | Minimal super key |
| Primary key | Chosen candidate key (NOT NULL, unique) |
| Alternate key | Candidate keys not chosen as primary |
| Unique key | Unique values, NULL allowed |
| Composite key | Primary key made of 2+ columns |
| Foreign key | References another table's key |
| Surrogate key | Artificial key (auto-increment ID / UUID) |
| Natural key | Real-world unique value (e.g. email, SSN) |

### Relationships
| Type | Example | Implementation |
|---|---|---|
| One-to-One | User ↔ Passport | FK with UNIQUE, or shared primary key |
| One-to-Many | Customer → Orders | FK on the "many" side |
| Many-to-Many | Students ↔ Courses | Junction/bridge table with two FKs |

```sql
CREATE TABLE student_course (
  student_id INT, course_id INT,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (course_id)  REFERENCES courses(id)
);
```

### ER diagram basics
Entity (table), Attribute (column), Relationship (line), Cardinality (1:1, 1:N, M:N).

---

## 23. Normalization

Organizing data to reduce redundancy and anomalies (insert, update, delete anomalies).

| Form | Rule |
|---|---|
| **1NF** | Atomic values (no lists/repeating groups in a cell); each row unique |
| **2NF** | 1NF + no partial dependency (non-key columns depend on the *whole* composite key) |
| **3NF** | 2NF + no transitive dependency (non-key columns depend only on the key) |
| **BCNF** | Every determinant is a candidate key |
| **4NF** | No multi-valued dependencies |
| **5NF** | No join dependencies |

**Example violating 1NF:** `phones = '9999, 8888'` → split into a separate `phones` table.
**Denormalization:** deliberately adding redundancy for read performance (reporting, data warehouses).

---

## 24. Transactions (TCL) and ACID

A **transaction** is a group of statements executed as one unit: all succeed or none.

```sql
START TRANSACTION;          -- or BEGIN;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;
COMMIT;                     -- save permanently
-- ROLLBACK;                -- undo everything

SAVEPOINT sp1;
ROLLBACK TO sp1;
RELEASE SAVEPOINT sp1;

SET autocommit = 0;         -- MySQL: turn off auto-commit
```

### ACID
| Property | Meaning |
|---|---|
| **A**tomicity | All or nothing |
| **C**onsistency | Moves DB from one valid state to another |
| **I**solation | Concurrent transactions don't interfere |
| **D**urability | Committed data survives crashes |

### Concurrency problems
| Problem | Description |
|---|---|
| Dirty read | Reading uncommitted data of another transaction |
| Non-repeatable read | Same row read twice gives different values |
| Phantom read | Same query returns different set of rows |
| Lost update | Two transactions overwrite each other |

### Isolation levels
| Level | Dirty | Non-repeatable | Phantom |
|---|---|---|---|
| READ UNCOMMITTED | Possible | Possible | Possible |
| READ COMMITTED | No | Possible | Possible |
| REPEATABLE READ (MySQL default) | No | No | Possible (mostly prevented in InnoDB) |
| SERIALIZABLE | No | No | No |

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;      -- row lock
SELECT * FROM accounts WHERE id = 1 LOCK IN SHARE MODE;  -- shared lock (MySQL)
```

### Locks and deadlocks
- Shared (read) lock, exclusive (write) lock, row-level, table-level.
- **Deadlock:** two transactions wait on each other; DB kills one. Avoid by accessing tables/rows in a consistent order and keeping transactions short.

---

## 25. DCL: Users and Permissions

```sql
-- Create user
CREATE USER 'ravi'@'localhost' IDENTIFIED BY 'StrongPass#1';
ALTER USER 'ravi'@'localhost' IDENTIFIED BY 'NewPass#2';
DROP USER 'ravi'@'localhost';

-- Grant
GRANT SELECT, INSERT ON company.employees TO 'ravi'@'localhost';
GRANT ALL PRIVILEGES ON company.* TO 'ravi'@'localhost';
GRANT SELECT ON *.* TO 'ravi'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;                                  -- MySQL

-- Revoke
REVOKE INSERT ON company.employees FROM 'ravi'@'localhost';

-- Show
SHOW GRANTS FOR 'ravi'@'localhost';

-- Roles (MySQL 8+, PostgreSQL)
CREATE ROLE analyst;
GRANT SELECT ON company.* TO analyst;
GRANT analyst TO 'ravi'@'localhost';
```
Common privileges: `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE`, `DROP`, `ALTER`, `INDEX`, `EXECUTE`, `ALL PRIVILEGES`.

---

## 26. Stored Procedures, Functions, Triggers, Cursors

### Stored Procedure
Saved block of SQL logic you call by name. Can have `IN`, `OUT`, `INOUT` parameters.
```sql
DELIMITER //
CREATE PROCEDURE get_emp_by_dept (IN d_id INT, OUT total INT)
BEGIN
    SELECT * FROM employees WHERE dept_id = d_id;
    SELECT COUNT(*) INTO total FROM employees WHERE dept_id = d_id;
END //
DELIMITER ;

CALL get_emp_by_dept(10, @cnt);
SELECT @cnt;
DROP PROCEDURE IF EXISTS get_emp_by_dept;
```
(SQL Server: `EXEC proc_name`.)

### User-Defined Function
Returns a value and can be used inside queries.
```sql
DELIMITER //
CREATE FUNCTION annual_salary(monthly DECIMAL(10,2)) RETURNS DECIMAL(12,2) DETERMINISTIC
BEGIN
    RETURN monthly * 12;
END //
DELIMITER ;

SELECT name, annual_salary(salary) FROM employees;
```

| Procedure | Function |
|---|---|
| Called with `CALL`/`EXEC` | Used inside SQL (`SELECT f()`) |
| Return optional (OUT params) | Must return a value |
| Can do DML/transactions freely | More restricted |

### Control flow in routines
```sql
DECLARE x INT DEFAULT 0;
SET x = 5;
IF x > 3 THEN ... ELSEIF x = 3 THEN ... ELSE ... END IF;
CASE WHEN ... THEN ... END CASE;
WHILE x < 10 DO SET x = x + 1; END WHILE;
REPEAT ... UNTIL cond END REPEAT;
loop_label: LOOP ... LEAVE loop_label; END LOOP;
```
Error handling: `DECLARE CONTINUE|EXIT HANDLER FOR SQLEXCEPTION ...`, `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '...'`.

### Triggers
Auto-run code **BEFORE/AFTER** `INSERT`, `UPDATE`, `DELETE`.
```sql
DELIMITER //
CREATE TRIGGER trg_salary_log
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_log (emp_id, old_sal, new_sal, changed_at)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary, NOW());
    END IF;
END //
DELIMITER ;

SHOW TRIGGERS;
DROP TRIGGER trg_salary_log;
```
`OLD` = row before change (UPDATE/DELETE), `NEW` = row after change (INSERT/UPDATE).
Uses: auditing, validation, auto-fill columns. Downsides: hidden logic, harder debugging, performance.

### Cursors
Process query results row by row (avoid when set-based SQL works).
```sql
DELIMITER //
CREATE PROCEDURE sum_salaries()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE s DECIMAL(10,2);
    DECLARE total DECIMAL(12,2) DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT salary FROM employees;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO s;
        IF done THEN LEAVE read_loop; END IF;
        SET total = total + s;
    END LOOP;
    CLOSE cur;
    SELECT total;
END //
DELIMITER ;
```

### Events (MySQL scheduler)
```sql
CREATE EVENT daily_cleanup ON SCHEDULE EVERY 1 DAY DO DELETE FROM logs WHERE created < NOW() - INTERVAL 30 DAY;
```

### Prepared statements
```sql
PREPARE stmt FROM 'SELECT * FROM employees WHERE dept_id = ?';
SET @d = 10;
EXECUTE stmt USING @d;
DEALLOCATE PREPARE stmt;
```
Prevent **SQL injection** by using parameterized queries/prepared statements in application code, never string concatenation.

---

## 27. Temporary Tables

Exist only for the session.
```sql
CREATE TEMPORARY TABLE temp_emp AS SELECT * FROM employees WHERE salary > 50000;
SELECT * FROM temp_emp;
DROP TEMPORARY TABLE temp_emp;
-- SQL Server: #temp_table (local), ##temp_table (global)
```

---

## 28. Order of Execution

Written order vs. logical processing order:

| Written | Executed |
|---|---|
| SELECT | 5 |
| FROM / JOIN | 1 |
| WHERE | 2 |
| GROUP BY | 3 |
| HAVING | 4 |
| Window functions | (with SELECT, 5) |
| DISTINCT | 6 |
| ORDER BY | 7 |
| LIMIT / OFFSET | 8 |

**FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT**

This is why a `SELECT` alias can't be used in `WHERE`.

---

## 29. Performance and Optimization

### EXPLAIN
```sql
EXPLAIN SELECT * FROM employees WHERE dept_id = 10;
EXPLAIN ANALYZE SELECT ...;      -- actually runs the query (MySQL 8.0.18+, PostgreSQL)
```
Look at: `type` (ALL = full scan, bad; ref/range/const = good), `key` (index used), `rows` (estimate), `Extra` (Using filesort/temporary = slow).

### Tips
- Select only the columns you need; avoid `SELECT *`.
- Index columns used in `WHERE`/`JOIN`/`ORDER BY`; check with `EXPLAIN`.
- Avoid functions on indexed columns in `WHERE` (`WHERE DATE(col) = ...` → use ranges).
- Avoid leading wildcards in `LIKE`.
- Use `EXISTS` instead of `IN` for big subqueries; use `UNION ALL` instead of `UNION` when duplicates don't matter.
- Use `LIMIT` for pagination; for deep pages use keyset pagination (`WHERE id > last_id ORDER BY id LIMIT n`).
- Use joins instead of correlated subqueries where possible.
- Batch inserts instead of one-by-one.
- Keep transactions short.
- Use appropriate data types (smallest that fits).
- Partition big tables; archive old data.
- Update statistics: `ANALYZE TABLE t;`, `OPTIMIZE TABLE t;`.

### Partitioning
```sql
CREATE TABLE sales (id INT, sale_date DATE, amount DECIMAL(10,2))
PARTITION BY RANGE (YEAR(sale_date)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION pmax  VALUES LESS THAN MAXVALUE
);
```
Types: RANGE, LIST, HASH, KEY.

### Other concepts
- **Sharding**: splitting data across servers.
- **Replication**: copying data to replicas (master-slave / primary-replica).
- **Query cache, connection pooling, caching layers**.
- **Slow query log**: `SET GLOBAL slow_query_log = 'ON';`

---

## 30. Advanced Topics

### Pivot / Unpivot
```sql
-- MySQL pivot with conditional aggregation
SELECT dept_id,
       SUM(CASE WHEN YEAR(hire_date) = 2022 THEN 1 ELSE 0 END) AS y2022,
       SUM(CASE WHEN YEAR(hire_date) = 2023 THEN 1 ELSE 0 END) AS y2023
FROM employees GROUP BY dept_id;
-- SQL Server / Oracle have PIVOT / UNPIVOT keywords
```

### Full-text search (MySQL)
```sql
SELECT * FROM articles WHERE MATCH(title, body) AGAINST ('database' IN NATURAL LANGUAGE MODE);
```

### Generated (computed) columns
```sql
CREATE TABLE t (price DECIMAL(10,2), qty INT, total DECIMAL(12,2) GENERATED ALWAYS AS (price * qty) STORED);
```

### Sequences (PostgreSQL / Oracle / SQL Server)
```sql
CREATE SEQUENCE seq_id START WITH 1 INCREMENT BY 1;
SELECT nextval('seq_id');       -- PostgreSQL
```

### Information schema (metadata)
```sql
SELECT table_name FROM information_schema.tables WHERE table_schema = 'company';
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'employees';
```

### Collation and character set
```sql
CREATE DATABASE d CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
Use `utf8mb4` in MySQL for full Unicode (emoji).

### Import / Export (MySQL)
```sql
LOAD DATA INFILE '/path/data.csv' INTO TABLE employees FIELDS TERMINATED BY ',' IGNORE 1 LINES;
SELECT * FROM employees INTO OUTFILE '/path/out.csv' FIELDS TERMINATED BY ',';
```
```bash
mysqldump -u root -p company > backup.sql         # backup
mysql -u root -p company < backup.sql             # restore
pg_dump dbname > backup.sql                       # PostgreSQL backup
```

### Locks / session info
```sql
SHOW PROCESSLIST;           -- running queries
KILL 123;                   -- stop a query
SHOW VARIABLES LIKE 'max_connections';
SHOW STATUS;
```

### Common Query Patterns
```sql
-- Duplicates
SELECT col, COUNT(*) FROM t GROUP BY col HAVING COUNT(*) > 1;

-- Delete duplicates keeping lowest id (MySQL)
DELETE t1 FROM t t1 JOIN t t2 ON t1.email = t2.email AND t1.id > t2.id;

-- Top N per group
SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) rn FROM employees) x WHERE rn <= 2;

-- Running total
SELECT order_date, SUM(amount) OVER (ORDER BY order_date) FROM orders;

-- Employees earning more than their manager
SELECT e.name FROM employees e JOIN employees m ON e.manager_id = m.emp_id WHERE e.salary > m.salary;

-- Customers with no orders
SELECT c.* FROM customers c LEFT JOIN orders o ON c.id = o.customer_id WHERE o.id IS NULL;

-- Department with highest total salary
SELECT dept_id FROM employees GROUP BY dept_id ORDER BY SUM(salary) DESC LIMIT 1;

-- Consecutive days / gaps: use LAG/LEAD or (date - ROW_NUMBER()) trick
-- Median (MySQL 8): use ROW_NUMBER() and COUNT() OVER () to pick the middle row(s)
-- Month-over-month growth: LAG(monthly_total) OVER (ORDER BY month)
```

---

## 31. Interview Questions

1. **What is the difference between `DELETE`, `TRUNCATE`, and `DROP`?** See section 5.
2. **`WHERE` vs `HAVING`?** WHERE filters rows before grouping, HAVING filters groups after.
3. **`UNION` vs `UNION ALL`?** UNION removes duplicates (slower), UNION ALL keeps them.
4. **Primary key vs Unique key?** PK: one per table, no NULL. Unique: many per table, NULL allowed.
5. **`CHAR` vs `VARCHAR`?** CHAR fixed length, VARCHAR variable length.
6. **What is a foreign key?** A column referencing the primary key of another table to enforce referential integrity.
7. **`RANK` vs `DENSE_RANK` vs `ROW_NUMBER`?** Gaps after ties / no gaps / unique numbers.
8. **Clustered vs non-clustered index?** Clustered defines physical order (one per table); non-clustered is a separate structure.
9. **What is a view? Can you update it?** Virtual table from a query; simple views are updatable.
10. **What is normalization? Explain 1NF, 2NF, 3NF.** See section 23.
11. **What are ACID properties?** Atomicity, Consistency, Isolation, Durability.
12. **What is a trigger? Procedure vs function?** See section 26.
13. **`IN` vs `EXISTS`?** EXISTS is often faster with large subqueries and handles NULL safely.
14. **What is a CTE? What is a subquery?** Named temporary result vs nested query.
15. **What is SQL injection and how to prevent it?** Malicious SQL in inputs. Use prepared statements, validate input, least privilege.
16. **How to find the Nth highest salary?** `DENSE_RANK()` or `LIMIT/OFFSET`.
17. **How to find duplicate records?** `GROUP BY ... HAVING COUNT(*) > 1`.
18. **`COUNT(*)` vs `COUNT(col)`?** COUNT(*) counts all rows, COUNT(col) skips NULLs.
19. **What is a self join / cross join?** See section 14.
20. **What is denormalization?** Adding redundancy to speed up reads.
21. **What is a composite key?** A key formed by two or more columns.
22. **What is a deadlock?** Two transactions waiting on each other's locks.
23. **What is the difference between `NULL`, 0, and empty string?** NULL = unknown/missing; 0 is a number; '' is empty text.
24. **What are `OLTP` and `OLAP`?** OLTP: many small transactions (normalized). OLAP: analytics on large data (denormalized/star schema).
25. **What is a surrogate key?** An artificial identifier with no business meaning.
26. **How do you optimize a slow query?** `EXPLAIN`, add indexes, avoid `SELECT *`, rewrite subqueries to joins, limit data.
27. **What is a `SAVEPOINT`?** A point inside a transaction you can roll back to.
28. **What is a data warehouse, star schema, fact table, dimension table?** Central analytic DB; fact table has measures, dimension tables have descriptive attributes.

---

## 32. Quick Cheat Sheet

```sql
-- DATABASE
CREATE DATABASE db;  USE db;  DROP DATABASE db;  SHOW DATABASES;

-- TABLE
CREATE TABLE t (id INT PRIMARY KEY, name VARCHAR(50) NOT NULL);
ALTER TABLE t ADD col INT;  ALTER TABLE t DROP COLUMN col;  ALTER TABLE t MODIFY col BIGINT;
DROP TABLE t;  TRUNCATE TABLE t;  DESCRIBE t;  SHOW TABLES;

-- DATA
INSERT INTO t (id, name) VALUES (1, 'A');
UPDATE t SET name = 'B' WHERE id = 1;
DELETE FROM t WHERE id = 1;

-- QUERY
SELECT DISTINCT col FROM t WHERE cond GROUP BY col HAVING cond ORDER BY col DESC LIMIT 10;

-- JOIN
SELECT * FROM a INNER JOIN b ON a.id = b.a_id;
SELECT * FROM a LEFT JOIN b ON a.id = b.a_id;

-- AGGREGATE
COUNT(*) SUM() AVG() MIN() MAX()

-- WINDOW
ROW_NUMBER() OVER (PARTITION BY x ORDER BY y)

-- TRANSACTION
START TRANSACTION; ... COMMIT; / ROLLBACK;

-- INDEX / VIEW
CREATE INDEX idx ON t (col);   CREATE VIEW v AS SELECT ...;

-- PERMISSIONS
GRANT SELECT ON db.t TO 'u'@'localhost';  REVOKE ...;
```

### Operators at a glance
`= <> > < >= <=` · `AND OR NOT` · `BETWEEN` · `IN` · `LIKE` · `IS NULL` · `EXISTS` · `ANY ALL`

### Join cheat
- **INNER**: A ∩ B
- **LEFT**: A + (A ∩ B)
- **RIGHT**: B + (A ∩ B)
- **FULL**: A ∪ B
- **CROSS**: A × B

---

## 33. Practice Sample Schema

Copy-paste to practice every query above.

```sql
CREATE DATABASE IF NOT EXISTS company;
USE company;

CREATE TABLE departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location  VARCHAR(50)
);

CREATE TABLE employees (
    emp_id     INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(50) NOT NULL,
    email      VARCHAR(100) UNIQUE,
    salary     DECIMAL(10,2) DEFAULT 30000,
    hire_date  DATE,
    dept_id    INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

INSERT INTO departments VALUES
(10, 'HR', 'Delhi'), (20, 'IT', 'Bangalore'), (30, 'Sales', 'Mumbai'), (40, 'Finance', 'Pune');

INSERT INTO employees (name, email, salary, hire_date, dept_id, manager_id) VALUES
('Amit',  'amit@x.com',  90000, '2020-03-15', 20, NULL),
('Riya',  'riya@x.com',  65000, '2021-07-01', 20, 1),
('Karan', 'karan@x.com', 50000, '2022-01-10', 10, 1),
('Neha',  'neha@x.com',  72000, '2019-11-20', 30, 1),
('Sahil', 'sahil@x.com', 48000, '2023-05-05', 30, 4),
('Pooja', 'pooja@x.com', 55000, '2022-09-12', 10, 3);
```

---

## 34. Setup, Tools and CLI Commands

### Popular RDBMS
| Database | Notes |
|---|---|
| MySQL / MariaDB | Most popular open source, web apps |
| PostgreSQL | Advanced features, strict standards, JSONB, extensions |
| SQL Server (T-SQL) | Microsoft, `TOP`, `IDENTITY`, `GETDATE()` |
| Oracle (PL/SQL) | Enterprise, `DUAL`, `ROWNUM`, `NVL` |
| SQLite | File-based, embedded, no server |

### Tools
MySQL Workbench, DBeaver, pgAdmin, SSMS, DataGrip, phpMyAdmin, VS Code SQL extensions.

### CLI
```bash
mysql -u root -p                     # login MySQL
mysql -u root -p -h host -P 3306 db  # specific host/port/db
psql -U postgres -d mydb             # PostgreSQL
sqlite3 mydb.db                      # SQLite
```
```sql
-- MySQL client
SOURCE /path/file.sql;               -- run a script file
STATUS;  EXIT;  QUIT;
SHOW VARIABLES;  SHOW STATUS;  SHOW ENGINES;  SHOW WARNINGS;  SHOW ERRORS;
SET @var = 10;  SELECT @var;         -- user variable
SET SQL_SAFE_UPDATES = 0;            -- allow UPDATE/DELETE without key (Workbench)
```
```
-- psql meta-commands
\l  list databases      \c db  connect      \dt  tables       \d t  describe table
\du  users              \dv  views          \di  indexes      \df  functions
\x  expanded output     \timing  time queries   \i file.sql  run file   \q  quit
```

### Storage engines (MySQL)
| Engine | Features |
|---|---|
| **InnoDB** (default) | ACID, transactions, row-level locking, foreign keys |
| MyISAM | Fast reads, table locking, no transactions/FKs |
| MEMORY | In-RAM tables |
| ARCHIVE, CSV | Special purpose |

---

## 35. DBMS Concepts (Theory)

### Three-schema architecture
- **Physical (internal)**: how data is stored on disk.
- **Logical (conceptual)**: tables, relations, constraints.
- **View (external)**: what each user sees.
- **Data independence**: changing one level without breaking the one above.

### Codd's rules (summary)
Information rule, guaranteed access, systematic NULL treatment, active online catalog, comprehensive data sublanguage, view updating, high-level insert/update/delete, physical and logical data independence, integrity independence, distribution independence, non-subversion rule.

### Relational algebra
| Operation | Symbol | SQL equivalent |
|---|---|---|
| Select | σ | `WHERE` |
| Project | π | `SELECT cols` |
| Union / Intersection / Difference | ∪ ∩ − | `UNION` / `INTERSECT` / `EXCEPT` |
| Cartesian product | × | `CROSS JOIN` |
| Join | ⋈ | `JOIN` |
| Rename | ρ | `AS` |
| Division | ÷ | "for all" queries (double `NOT EXISTS`) |

### Integrity
- **Entity integrity**: primary key not NULL.
- **Referential integrity**: foreign key must match a primary key (or be NULL).
- **Domain integrity**: valid data types/ranges (`CHECK`, `ENUM`).
- **User-defined integrity**: business rules (triggers).

### Functional dependency
`X → Y` means X determines Y. Basis of normalization. Also: **Armstrong's axioms**, closure of attributes, candidate key finding, lossless decomposition, dependency preservation.

### OLTP vs OLAP
| OLTP | OLAP |
|---|---|
| Day-to-day transactions | Analysis and reporting |
| Normalized | Denormalized (star/snowflake) |
| Many small reads/writes | Few large reads |
| e.g. banking app | e.g. data warehouse |

### Data warehouse terms
- **Fact table**: numeric measures (sales amount) + foreign keys.
- **Dimension table**: descriptive attributes (customer, product, date).
- **Star schema**: fact in the middle, denormalized dimensions around it.
- **Snowflake schema**: dimensions normalized further.
- **ETL**: Extract, Transform, Load. **ELT**: load first, transform in the warehouse.
- **Data mart, data lake, OLAP cube, slowly changing dimensions (SCD 1/2/3)**.

### CAP theorem and BASE
- **CAP**: a distributed system can guarantee only 2 of: **C**onsistency, **A**vailability, **P**artition tolerance.
- **BASE**: Basically Available, Soft state, Eventually consistent (NoSQL).

### Other
- **Database engine internals**: parser → optimizer → executor → storage engine.
- **MVCC** (Multi-Version Concurrency Control): readers don't block writers by keeping row versions (InnoDB, PostgreSQL).
- **WAL** (Write-Ahead Log) / redo log / undo log: durability and rollback.
- **Checkpoint**: flush dirty pages to disk.
- **Buffer pool**: memory cache of pages.

---

## 36. Schemas, Sequences, Synonyms, Auto-increment

```sql
-- Schema (namespace). In MySQL schema = database.
CREATE SCHEMA sales;                        -- PostgreSQL / SQL Server
CREATE TABLE sales.orders (...);
SET search_path TO sales, public;           -- PostgreSQL
DROP SCHEMA sales CASCADE;

-- AUTO_INCREMENT control (MySQL)
ALTER TABLE t AUTO_INCREMENT = 1000;
SELECT LAST_INSERT_ID();

-- PostgreSQL identity / serial
CREATE TABLE t (id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY);
CREATE TABLE t2 (id SERIAL PRIMARY KEY);
CREATE TABLE t3 (id UUID DEFAULT gen_random_uuid() PRIMARY KEY);

-- SQL Server
CREATE TABLE t (id INT IDENTITY(1,1) PRIMARY KEY);
SELECT SCOPE_IDENTITY();   SET IDENTITY_INSERT t ON;

-- Sequences
CREATE SEQUENCE seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999 CYCLE;
SELECT nextval('seq');  SELECT currval('seq');      -- PostgreSQL
SELECT NEXT VALUE FOR seq;                          -- SQL Server
SELECT seq.NEXTVAL FROM DUAL;                       -- Oracle
ALTER SEQUENCE seq RESTART WITH 1;
DROP SEQUENCE seq;

-- Synonym (SQL Server / Oracle): alias for an object
CREATE SYNONYM emp FOR hr.dbo.employees;
```

---

## 37. Extra Clauses, Operators and Functions

### Additional operators
```sql
-- NULL-safe comparison
SELECT * FROM t WHERE a <=> b;                     -- MySQL
SELECT * FROM t WHERE a IS NOT DISTINCT FROM b;    -- PostgreSQL / standard

-- Row constructor comparison
SELECT * FROM t WHERE (a, b) IN ((1,2), (3,4));
SELECT * FROM t WHERE (a, b) > (1, 2);

-- Wildcards in SQL Server LIKE
LIKE '[abc]%'     -- starts with a, b or c
LIKE '[a-f]%'     -- range
LIKE '[^abc]%'    -- not a, b, c

-- XOR (MySQL)
SELECT 1 XOR 0;

-- Safe division / modulo
SELECT 10 DIV 3, 10 % 3, MOD(10,3);
```

### RETURNING / OUTPUT (get affected rows back)
```sql
INSERT INTO t (name) VALUES ('A') RETURNING id;            -- PostgreSQL
UPDATE t SET x = 1 WHERE id = 5 RETURNING *;
DELETE FROM t WHERE id = 5 RETURNING *;
INSERT INTO t (name) OUTPUT INSERTED.id VALUES ('A');      -- SQL Server
```

### SELECT ... INTO
```sql
SELECT * INTO new_table FROM employees;                    -- SQL Server / PostgreSQL
SELECT salary INTO @v FROM employees WHERE emp_id = 1;     -- MySQL variable
```

### FIND_IN_SET, FIELD, ELT (MySQL)
```sql
SELECT FIND_IN_SET('b', 'a,b,c');       -- 2
SELECT * FROM t ORDER BY FIELD(status, 'new', 'open', 'closed');   -- custom sort order
```

### More string functions
```sql
SELECT REGEXP_REPLACE('a1b2', '[0-9]', '');          -- ab   (MySQL 8 / PostgreSQL)
SELECT REGEXP_SUBSTR('abc123', '[0-9]+');            -- 123
SELECT REGEXP_LIKE('abc', '^a');
SELECT TRANSLATE('abc', 'ab', 'xy');                 -- PostgreSQL/Oracle
SELECT STRING_AGG(name, ', ' ORDER BY name) FROM t;  -- PostgreSQL
SELECT STRING_AGG(name, ', ') WITHIN GROUP (ORDER BY name) FROM t;  -- SQL Server
SELECT SOUNDEX('Smith'), SOUNDEX('Smyth');           -- phonetic match
SELECT UNHEX(HEX('abc')), BIN(5), OCT(8), CONV('ff',16,10);
```

### More date examples
```sql
-- First day of the month
SELECT DATE_FORMAT(CURDATE(), '%Y-%m-01');
SELECT DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE())-1 DAY);
-- Age in years
SELECT TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM employees;
-- Rows from last 7 days
SELECT * FROM orders WHERE order_date >= NOW() - INTERVAL 7 DAY;
-- PostgreSQL
SELECT DATE_TRUNC('month', NOW());  SELECT AGE(NOW(), birth_date);
SELECT generate_series('2026-01-01'::date, '2026-01-10', '1 day');
-- Unix timestamps
SELECT UNIX_TIMESTAMP(), FROM_UNIXTIME(1700000000);
-- Time zones
SELECT CONVERT_TZ(NOW(), 'UTC', 'Asia/Kolkata');
```

### Table-valued extras
```sql
-- VALUES as a table
SELECT * FROM (VALUES ROW(1,'a'), ROW(2,'b')) AS t(id, name);   -- MySQL 8
SELECT * FROM (VALUES (1,'a'), (2,'b')) AS t(id, name);         -- PostgreSQL

-- TABLESAMPLE / random sample
SELECT * FROM t ORDER BY RAND() LIMIT 10;
SELECT * FROM t TABLESAMPLE SYSTEM (10);                        -- PostgreSQL

-- Optimizer / index hints
SELECT * FROM t USE INDEX (idx_name) WHERE ...;
SELECT * FROM t FORCE INDEX (idx_name) WHERE ...;
SELECT STRAIGHT_JOIN * FROM a JOIN b ON ...;
```

### Locking clauses
```sql
SELECT * FROM t WHERE id = 1 FOR UPDATE;
SELECT * FROM t WHERE id = 1 FOR UPDATE NOWAIT;
SELECT * FROM t WHERE status = 'new' LIMIT 1 FOR UPDATE SKIP LOCKED;   -- job-queue pattern
LOCK TABLES t WRITE;  UNLOCK TABLES;
```

### Generated sequences without tables
```sql
-- 1..10 in MySQL 8
WITH RECURSIVE n AS (SELECT 1 x UNION ALL SELECT x+1 FROM n WHERE x < 10) SELECT * FROM n;
-- PostgreSQL
SELECT generate_series(1, 10);
```

### JSON in PostgreSQL
```sql
SELECT data->'name', data->>'name', data#>>'{a,b}' FROM t;
SELECT * FROM t WHERE data @> '{"role":"admin"}';
CREATE INDEX idx_gin ON t USING GIN (data);
SELECT jsonb_agg(name), jsonb_build_object('a', 1) FROM t;
```

### Array & other PostgreSQL types
```sql
CREATE TABLE t (tags TEXT[]);
SELECT * FROM t WHERE 'sql' = ANY(tags);
SELECT UNNEST(tags) FROM t;
```
Also: `RANGE` types, `HSTORE`, `INET`, `CIDR`, `MONEY`, `INTERVAL`, `TSVECTOR` (full-text), enums via `CREATE TYPE`.

---

## 38. Triggers and Routines: More Detail

| Timing / Event | MySQL | PostgreSQL | SQL Server |
|---|---|---|---|
| BEFORE INSERT/UPDATE/DELETE | Yes | Yes | No (use INSTEAD OF) |
| AFTER INSERT/UPDATE/DELETE | Yes | Yes | Yes |
| INSTEAD OF (on views) | No | Yes | Yes |
| Statement-level | No | Yes | Yes |
| Special tables | `OLD`, `NEW` | `OLD`, `NEW` | `inserted`, `deleted` |

```sql
-- BEFORE INSERT validation (MySQL)
DELIMITER //
CREATE TRIGGER trg_check BEFORE INSERT ON employees FOR EACH ROW
BEGIN
  IF NEW.salary < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot be negative';
  END IF;
  SET NEW.email = LOWER(NEW.email);
END //
DELIMITER ;

-- PostgreSQL trigger = function + trigger
CREATE FUNCTION log_change() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit(tbl, changed_at) VALUES (TG_TABLE_NAME, NOW());
  RETURN NEW;
END; $$ LANGUAGE plpgsql;
CREATE TRIGGER trg AFTER UPDATE ON employees FOR EACH ROW EXECUTE FUNCTION log_change();
```

### Error handling
```sql
-- MySQL
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; SELECT 'Error'; END;
GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
-- SQL Server
BEGIN TRY ... END TRY BEGIN CATCH SELECT ERROR_MESSAGE(); END CATCH
-- PostgreSQL
BEGIN ... EXCEPTION WHEN unique_violation THEN ... END;
```

### Dynamic SQL
```sql
SET @sql = CONCAT('SELECT * FROM ', 'employees', ' WHERE dept_id = ?');
PREPARE s FROM @sql; SET @d = 10; EXECUTE s USING @d; DEALLOCATE PREPARE s;
-- SQL Server: EXEC sp_executesql
```

### Oracle PL/SQL structure (for reference)
```sql
DECLARE v_sal NUMBER;
BEGIN
  SELECT salary INTO v_sal FROM employees WHERE emp_id = 1;
  DBMS_OUTPUT.PUT_LINE(v_sal);
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
```
Also in Oracle: packages, `%TYPE`, `%ROWTYPE`, `ROWNUM`, `ROWID`, `DUAL`, `CONNECT BY` (hierarchy), `MINUS`, `NVL2`, `DECODE`.

---

## 39. Security, Backup and Recovery

### SQL injection
```sql
-- VULNERABLE (application code builds the string)
"SELECT * FROM users WHERE name = '" + input + "'"
-- input:  ' OR '1'='1   → returns all rows
-- input:  '; DROP TABLE users; --
```
**Prevention**
1. Prepared statements / parameterized queries (always).
2. Input validation and whitelisting.
3. Least-privilege DB accounts (no `DROP` for app user).
4. Stored procedures (with parameters, no dynamic concatenation).
5. Hide detailed error messages; use a WAF; keep software patched.

### Other security
- Hash passwords (bcrypt/argon2) in the app, **never** store plain text. Don't use plain `MD5`/`SHA1` for passwords.
- Encryption at rest (TDE) and in transit (SSL/TLS); column encryption for sensitive data.
- Row-level security (PostgreSQL `CREATE POLICY`), data masking, auditing logs.
- Use roles, revoke unused privileges, separate admin/app users, rotate credentials.

### Backup types
| Type | Description |
|---|---|
| Full | Entire database |
| Incremental | Changes since last backup (any type) |
| Differential | Changes since last full backup |
| Logical | SQL statements (`mysqldump`, `pg_dump`) |
| Physical | Raw files (Percona XtraBackup, `pg_basebackup`) |
| Hot / Warm / Cold | Database online / limited / offline |

```bash
mysqldump -u root -p --all-databases > all.sql
mysqldump -u root -p --single-transaction --routines --triggers company > company.sql
pg_dump -Fc dbname > db.dump        pg_restore -d dbname db.dump
```
- **Point-in-time recovery (PITR)**: restore full backup + replay binary logs / WAL.
- **RPO** (data loss tolerance) and **RTO** (downtime tolerance).
- **High availability**: replication, failover, clustering (Galera, Patroni), load balancers.
- Replication types: master-slave, master-master, synchronous vs asynchronous, read replicas.

---

## 40. Internals: Indexes, Execution and Join Algorithms

### B-Tree / B+Tree
Balanced tree; lookups, ranges and sorting in O(log n). In a B+Tree all data pointers sit in leaf nodes, which are linked for fast range scans. Most RDBMS indexes are B+Trees.

### Index tips
- **Leftmost prefix rule**: index `(a,b,c)` serves `a`, `a,b`, `a,b,c`, but not `b` alone.
- Put equality columns first, range column last.
- **Selectivity**: high-cardinality columns index best.
- **Covering index** avoids touching the table ("Using index" in EXPLAIN).
- Index on foreign keys speeds joins and cascades.
- Invisible/hidden indexes (MySQL 8) let you test removal safely.

### Query execution steps
Parse → Validate (syntax, permissions) → Optimize (cost-based, choose indexes and join order) → Execute → Return.

### Join algorithms
| Algorithm | When used |
|---|---|
| Nested Loop | Small tables or indexed inner table |
| Hash Join | Large unsorted tables, equality joins |
| Sort-Merge Join | Both inputs sorted / non-equality ranges |

### Scan types
Full table scan, index scan, index-only scan, range scan, bitmap scan (PostgreSQL).

### PostgreSQL EXPLAIN
```sql
EXPLAIN ANALYZE SELECT ...;
EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT ...;
VACUUM ANALYZE t;      -- clean dead rows + refresh statistics
```

### Normal vs bad patterns
| Slow | Better |
|---|---|
| `WHERE YEAR(d) = 2024` | `WHERE d >= '2024-01-01' AND d < '2025-01-01'` |
| `WHERE col + 1 = 5` | `WHERE col = 4` |
| `LIKE '%abc'` | Full-text index / trigram index |
| `SELECT *` | Named columns |
| `OFFSET 100000` | Keyset pagination |
| `NOT IN (subquery)` | `NOT EXISTS` |
| Implicit type conversion (`WHERE varchar_col = 5`) | Match types |
| `OR` across columns | `UNION ALL` of indexed queries |

---

## 41. MySQL vs PostgreSQL vs SQL Server vs Oracle

| Feature | MySQL | PostgreSQL | SQL Server | Oracle |
|---|---|---|---|---|
| Limit rows | `LIMIT n` | `LIMIT n` | `TOP n` / `FETCH` | `FETCH FIRST n` / `ROWNUM` |
| Auto ID | `AUTO_INCREMENT` | `SERIAL` / `IDENTITY` | `IDENTITY` | Sequence / `IDENTITY` |
| Current time | `NOW()` | `NOW()` | `GETDATE()` | `SYSDATE` |
| Concat | `CONCAT()` | `\|\|` | `+` / `CONCAT()` | `\|\|` |
| NULL replace | `IFNULL` | `COALESCE` | `ISNULL` | `NVL` |
| String length | `LENGTH` | `LENGTH` | `LEN` | `LENGTH` |
| FULL JOIN | No | Yes | Yes | Yes |
| Boolean | `TINYINT(1)` | `BOOLEAN` | `BIT` | `NUMBER(1)` |
| Quote identifiers | `` `name` `` | `"name"` | `[name]` / `"name"` | `"name"` |
| Upsert | `ON DUPLICATE KEY` | `ON CONFLICT` | `MERGE` | `MERGE` |
| Except | `EXCEPT` (8.0.31+) | `EXCEPT` | `EXCEPT` | `MINUS` |
| Procedural | MySQL SQL/PSM | PL/pgSQL | T-SQL | PL/SQL |
| Case-sensitive strings | No (default collation) | Yes | No (default) | Yes |
| String quotes | `'single'` | `'single'` only | `'single'` | `'single'` only |

---

## 42. Practice Problems with Solutions

Use the schema from section 33 (`employees`, `departments`).

```sql
-- 1. Employees with salary above the company average
SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);

-- 2. Department-wise employee count, including empty departments
SELECT d.dept_name, COUNT(e.emp_id) FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id GROUP BY d.dept_name;

-- 3. Second highest salary
SELECT MAX(salary) FROM employees WHERE salary < (SELECT MAX(salary) FROM employees);

-- 4. Highest-paid employee in each department
SELECT * FROM employees e WHERE salary = (SELECT MAX(salary) FROM employees WHERE dept_id = e.dept_id);

-- 5. Departments with more than 1 employee
SELECT dept_id, COUNT(*) FROM employees GROUP BY dept_id HAVING COUNT(*) > 1;

-- 6. Employees who are managers
SELECT * FROM employees WHERE emp_id IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL);

-- 7. Employees without a manager
SELECT * FROM employees WHERE manager_id IS NULL;

-- 8. Names starting and ending with a vowel
SELECT name FROM employees WHERE name REGEXP '^[AEIOUaeiou].*[AEIOUaeiou]$';

-- 9. Duplicate emails
SELECT email, COUNT(*) FROM employees GROUP BY email HAVING COUNT(*) > 1;

-- 10. Employees hired in the last 2 years
SELECT * FROM employees WHERE hire_date >= CURDATE() - INTERVAL 2 YEAR;

-- 11. Total salary per department, highest first
SELECT dept_id, SUM(salary) AS total FROM employees GROUP BY dept_id ORDER BY total DESC;

-- 12. Employees earning more than their manager
SELECT e.name FROM employees e JOIN employees m ON e.manager_id = m.emp_id WHERE e.salary > m.salary;

-- 13. Top 2 salaries per department
SELECT * FROM (SELECT *, DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) r FROM employees) t WHERE r <= 2;

-- 14. Running total of salary by hire date
SELECT name, hire_date, SUM(salary) OVER (ORDER BY hire_date) AS running FROM employees;

-- 15. Percentage of total salary per employee
SELECT name, ROUND(salary * 100 / SUM(salary) OVER (), 2) AS pct FROM employees;

-- 16. Departments with no employees
SELECT d.* FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id WHERE e.emp_id IS NULL;

-- 17. Delete duplicate rows keeping the smallest id
DELETE e1 FROM employees e1 JOIN employees e2 ON e1.email = e2.email AND e1.emp_id > e2.emp_id;

-- 18. Swap two column values (MySQL evaluates left to right, use a temp column or CASE)
UPDATE t SET gender = CASE gender WHEN 'M' THEN 'F' WHEN 'F' THEN 'M' END;

-- 19. Nth highest salary with function-free approach (N = 3)
SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 2;

-- 20. Salary difference from previous hire
SELECT name, salary, salary - LAG(salary) OVER (ORDER BY hire_date) AS diff FROM employees;

-- 21. Count employees per hire year
SELECT YEAR(hire_date) yr, COUNT(*) FROM employees GROUP BY yr ORDER BY yr;

-- 22. Median salary (MySQL 8)
SELECT AVG(salary) FROM (
  SELECT salary, ROW_NUMBER() OVER (ORDER BY salary) rn, COUNT(*) OVER () cnt FROM employees
) t WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2));

-- 23. Find consecutive numbers (3 in a row)
SELECT DISTINCT a.num FROM logs a JOIN logs b ON b.id = a.id+1 AND b.num = a.num JOIN logs c ON c.id = a.id+2 AND c.num = a.num;

-- 24. Employees whose salary is the department's lowest
SELECT * FROM employees e WHERE salary = (SELECT MIN(salary) FROM employees WHERE dept_id = e.dept_id);

-- 25. Pivot: employees per department as columns
SELECT SUM(dept_id = 10) AS hr, SUM(dept_id = 20) AS it, SUM(dept_id = 30) AS sales FROM employees;
```

---

## 43. Common Errors and Fixes

| Error | Cause | Fix |
|---|---|---|
| `Unknown column 'x' in 'where clause'` | Using an alias in WHERE, or typo | Use the real column or a subquery/CTE |
| `Column 'x' is invalid in the select list... GROUP BY` / `ONLY_FULL_GROUP_BY` | Non-aggregated column not in GROUP BY | Add it to GROUP BY or aggregate it |
| `Duplicate entry '1' for key 'PRIMARY'` | Inserting existing key | Use new key, `ON DUPLICATE KEY UPDATE`, or `INSERT IGNORE` |
| `Cannot add or update a child row: a foreign key constraint fails` | Parent row missing | Insert parent first |
| `Cannot delete or update a parent row` | Child rows exist | Delete children first or use `ON DELETE CASCADE` |
| `Subquery returns more than 1 row` | Scalar expected | Use `IN`, `LIMIT 1`, or aggregate |
| `Every derived table must have its own alias` | Subquery in FROM without alias | Add `AS t` |
| `Data too long for column` | Value larger than column | Increase size or trim data |
| `Incorrect date value` | Wrong date format | Use `YYYY-MM-DD` |
| `Lock wait timeout exceeded` / deadlock | Long transactions | Shorten transactions, consistent lock order, retry |
| `Table doesn't exist` | Wrong DB / case-sensitivity | `USE db;` check name and case |
| `Operand should contain 1 column(s)` | Subquery returns many columns | Select one column |
| `Division by zero` | Divisor 0 | `NULLIF(x, 0)` |
| `Access denied for user` | Wrong credentials/privileges | Check user, password, `GRANT` |
| `You are using safe update mode` | Update without key | Add key in WHERE or `SET SQL_SAFE_UPDATES=0` |
| `NOT IN` returns no rows | NULL in subquery | Use `NOT EXISTS` or filter NULLs |

---

## 44. Best Practices and Naming Conventions

- Use `snake_case` for names (`order_items`), singular or plural **consistently**.
- Name keys/indexes clearly: `pk_`, `fk_`, `uq_`, `idx_`, `chk_`.
- Every table gets a primary key.
- Use the right data types (`DECIMAL` for money, `DATE` for dates, not strings).
- Avoid reserved words as names (`order`, `group`, `user`, `index`, `key`, `table`); otherwise quote them.
- Always list column names in `INSERT`; avoid `SELECT *` in production.
- Write `WHERE` first when making `UPDATE`/`DELETE`; test with `SELECT` first; use transactions for risky changes.
- Use `NOT NULL` and `DEFAULT` where possible; enforce rules with constraints, not only app code.
- Use `utf8mb4` and consistent collation.
- Keep timestamps in UTC; add `created_at` / `updated_at` columns.
- Prefer soft deletes (`is_deleted`) when you need history.
- Format SQL readably (uppercase keywords, one clause per line); comment complex queries.
- Version-control schema changes with migrations (Flyway, Liquibase, Alembic, Prisma).
- Back up before big changes; test restores.
- Never store secrets or plain-text passwords.

### Reserved words you must watch
`SELECT, FROM, WHERE, ORDER, GROUP, BY, INSERT, UPDATE, DELETE, TABLE, INDEX, KEY, USER, DATE, TIME, LIMIT, RANGE, RANK, ROWS, WINDOW, LIKE, DESC`

---

## 45. A–Z Command Index

| Command | Section | Command | Section |
|---|---|---|---|
| `ALTER` | 5 | `LIKE` | 9 |
| `AND / OR / NOT` | 9 | `LIMIT` | 10 |
| `ANY / ALL` | 9, 16 | `MERGE` | 7 |
| `AS` | 11 | `OFFSET` | 10 |
| `AVG` | 12 | `ON DUPLICATE KEY` | 7 |
| `BEGIN / START TRANSACTION` | 24 | `ORDER BY` | 10 |
| `BETWEEN` | 9 | `OVER / PARTITION BY` | 18 |
| `CALL` | 26 | `PREPARE / EXECUTE` | 26 |
| `CASE` | 19 | `PRIMARY KEY` | 6 |
| `CAST / CONVERT` | 12 | `RANK / DENSE_RANK / ROW_NUMBER` | 18 |
| `CHECK` | 6 | `RENAME` | 5 |
| `COALESCE` | 12 | `REPLACE` | 7, 12 |
| `COMMIT` | 24 | `RETURNING` | 37 |
| `COUNT` | 12 | `REVOKE` | 25 |
| `CREATE` (DB/TABLE/INDEX/VIEW) | 4, 5, 20, 21 | `ROLLBACK` | 24 |
| `CROSS JOIN` | 14 | `ROLLUP / CUBE` | 13 |
| `CTE / WITH` | 17 | `SAVEPOINT` | 24 |
| `CURSOR` | 26 | `SELECT` | 8 |
| `DEFAULT` | 6 | `SET` | 7 |
| `DELETE` | 7 | `SHOW / DESCRIBE` | 4 |
| `DISTINCT` | 10 | `SUBSTRING` | 12 |
| `DROP` | 5 | `SUM` | 12 |
| `EXCEPT / MINUS` | 15 | `TRIGGER` | 26, 38 |
| `EXISTS` | 9, 16 | `TRUNCATE` | 5 |
| `EXPLAIN` | 29 | `UNION / UNION ALL` | 15 |
| `FOREIGN KEY` | 6, 22 | `UNIQUE` | 6 |
| `FULL JOIN` | 14 | `UPDATE` | 7 |
| `GRANT` | 25 | `USE` | 4 |
| `GROUP BY` | 13 | `VIEW` | 20 |
| `HAVING` | 13 | `WHERE` | 8 |
| `IN` | 9 | `WINDOW functions` | 18 |
| `INDEX` | 21 | `INNER / LEFT / RIGHT JOIN` | 14 |
| `INSERT` | 7 | `INTERSECT` | 15 |
| `IS NULL` | 9 | `LAG / LEAD` | 18 |

---

### ✅ End of Notes
You now have: basics → DDL/DML/DQL/DCL/TCL → joins, subqueries, CTEs, window functions → views, indexes, keys, normalization → transactions, procedures, triggers → security, backups, internals → interview Q&A, practice problems and a cheat sheet.

---

## 34. Additional Topics (Missing Pieces)

Everything else that completes the notes, in one place.

### 34.1 Data Integrity Types
| Type | Enforced by |
|---|---|
| Entity integrity | Primary key (unique, not NULL) |
| Referential integrity | Foreign key |
| Domain integrity | Data types, CHECK, DEFAULT, NOT NULL |
| User-defined integrity | Triggers, business rules |

### 34.2 Storage Engines (MySQL)
| | InnoDB (default) | MyISAM |
|---|---|---|
| Transactions / ACID | Yes | No |
| Foreign keys | Yes | No |
| Locking | Row-level | Table-level |
| Crash recovery | Yes | Weak |
| Full-text | Yes (5.6+) | Yes |

```sql
CREATE TABLE t (id INT) ENGINE = InnoDB;
SHOW ENGINES;
```
Other engines: MEMORY, ARCHIVE, CSV.

### 34.3 MVCC (Multi-Version Concurrency Control)
Readers see a snapshot of data, so reads don't block writes and writes don't block reads. Used by PostgreSQL, MySQL InnoDB, Oracle.

### 34.4 SQL Injection (Example and Prevention)
```sql
-- Vulnerable: input  ' OR '1'='1
SELECT * FROM users WHERE name = '' OR '1'='1' AND password = '';
```
Prevention: prepared/parameterized statements, input validation, least-privilege accounts, avoid dynamic SQL built by string concatenation, hide error details, use an ORM/query builder.

### 34.5 Dynamic SQL
```sql
-- MySQL
SET @sql = CONCAT('SELECT * FROM ', 'employees', ' WHERE dept_id = ?');
PREPARE stmt FROM @sql; SET @d = 10; EXECUTE stmt USING @d; DEALLOCATE PREPARE stmt;

-- SQL Server
EXEC sp_executesql N'SELECT * FROM employees WHERE dept_id = @d', N'@d INT', @d = 10;

-- PostgreSQL (PL/pgSQL)
EXECUTE format('SELECT * FROM %I WHERE dept_id = $1', 'employees') USING 10;
```

### 34.6 Error Handling
```sql
-- SQL Server (T-SQL)
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE accounts SET balance = balance - 100 WHERE id = 1;
    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    SELECT ERROR_MESSAGE(), ERROR_NUMBER();
END CATCH;

-- PostgreSQL
DO $$ BEGIN
    PERFORM 1/0;
EXCEPTION WHEN division_by_zero THEN RAISE NOTICE 'Divide by zero';
END $$;
```

### 34.7 More Useful Commands
```sql
-- Return inserted/updated rows (PostgreSQL)
INSERT INTO employees (name) VALUES ('X') RETURNING emp_id;

-- Create table from query (SQL Server / PostgreSQL)
SELECT * INTO emp_copy FROM employees;

-- Last inserted ID
SELECT LAST_INSERT_ID();                 -- MySQL
SELECT SCOPE_IDENTITY();                 -- SQL Server

-- Reset auto-increment
ALTER TABLE employees AUTO_INCREMENT = 1;

-- Limit inside UPDATE / DELETE (MySQL)
DELETE FROM logs ORDER BY created LIMIT 100;

-- Custom sort order (MySQL)
SELECT * FROM t ORDER BY FIELD(status, 'new', 'open', 'closed');

-- Index hints (MySQL)
SELECT * FROM employees USE INDEX (idx_name) WHERE last_name = 'Sharma';

-- Lock tables
LOCK TABLES employees WRITE; UNLOCK TABLES;

-- Rename database objects
RENAME TABLE old TO new;
ALTER TABLE t RENAME INDEX old_idx TO new_idx;

-- Check / repair (MySQL)
CHECK TABLE t; REPAIR TABLE t; ANALYZE TABLE t; OPTIMIZE TABLE t;

-- Variables
SET @x = 10; SELECT @x;
SELECT COUNT(*) INTO @total FROM employees;
```

### 34.8 Dialect Comparison
| Feature | MySQL | PostgreSQL | SQL Server | Oracle |
|---|---|---|---|---|
| Limit rows | `LIMIT n` | `LIMIT n` | `TOP n` | `FETCH FIRST n ROWS` / `ROWNUM` |
| Auto ID | `AUTO_INCREMENT` | `SERIAL` / `IDENTITY` | `IDENTITY(1,1)` | `SEQUENCE` / `IDENTITY` |
| Current time | `NOW()` | `NOW()` | `GETDATE()` | `SYSDATE` |
| Concat | `CONCAT()` | `\|\|` | `+` / `CONCAT()` | `\|\|` |
| NULL replace | `IFNULL` | `COALESCE` | `ISNULL` | `NVL` |
| String length | `LENGTH` | `LENGTH` | `LEN` | `LENGTH` |
| Full outer join | No | Yes | Yes | Yes |
| Procedural language | SQL/PSM | PL/pgSQL | T-SQL | PL/SQL |
| Dummy table | none needed | none needed | none needed | `FROM DUAL` |
| Quote identifiers | `` `name` `` | `"name"` | `[name]` | `"name"` |
| Boolean type | TINYINT(1) | BOOLEAN | BIT | NUMBER(1) |

### 34.9 PL/SQL and T-SQL Basics
```sql
-- Oracle PL/SQL
DECLARE v_sal NUMBER;
BEGIN
  SELECT salary INTO v_sal FROM employees WHERE emp_id = 1;
  DBMS_OUTPUT.PUT_LINE('Salary: ' || v_sal);
END;

-- SQL Server T-SQL
DECLARE @sal DECIMAL(10,2);
SELECT @sal = salary FROM employees WHERE emp_id = 1;
PRINT 'Salary: ' + CAST(@sal AS VARCHAR);
```

### 34.10 Data Warehousing Concepts
| Term | Meaning |
|---|---|
| OLTP | Many small transactions, normalized (banking, orders) |
| OLAP | Analytics on large data, denormalized |
| Fact table | Numeric measures (sales amount) + foreign keys |
| Dimension table | Descriptive attributes (customer, product, date) |
| Star schema | Fact table surrounded by dimension tables |
| Snowflake schema | Dimensions normalized into sub-dimensions |
| ETL / ELT | Extract, Transform, Load pipeline |
| Data mart | Subset of a warehouse for one team |
| SCD (Slowly Changing Dimension) | Handling history: Type 1 overwrite, Type 2 new row, Type 3 new column |

### 34.11 CAP Theorem and BASE
- **CAP:** a distributed system can guarantee only two of **C**onsistency, **A**vailability, **P**artition tolerance.
- **BASE:** Basically Available, Soft state, Eventually consistent (NoSQL), the contrast to ACID.

### 34.12 Backup, Replication, High Availability
- **Backup types:** full, incremental, differential, logical (`mysqldump`, `pg_dump`), physical (file copy / snapshot).
- **Point-in-time recovery:** full backup + binary logs/WAL.
- **Replication:** primary-replica (async/sync), multi-primary.
- **High availability:** failover, clustering, load balancing.
- **Sharding:** horizontal split of data across servers; **partitioning** splits within one server.

### 34.13 Database Design Steps
1. Gather requirements
2. Identify entities and attributes
3. Define relationships (ER diagram)
4. Choose primary keys and data types
5. Normalize (to 3NF)
6. Add constraints and indexes
7. Denormalize only where measured performance needs it

### 34.14 Synonyms and Dual
```sql
-- Oracle: DUAL is a one-row dummy table
SELECT SYSDATE FROM DUAL;
-- SQL Server / Oracle synonym
CREATE SYNONYM emp FOR company.dbo.employees;
```

### 34.15 Best Practices and Common Mistakes
- Use meaningful, consistent names: `snake_case`, singular/plural consistently, avoid reserved words.
- Always write column lists in `INSERT`; avoid `SELECT *` in production.
- Always back up before `DROP`, `TRUNCATE`, bulk `UPDATE`/`DELETE`; test with `SELECT` first using the same `WHERE`.
- Run risky changes inside a transaction.
- Use `DECIMAL` for money, `utf8mb4` for text, `TIMESTAMP`/`DATETIME` in UTC.
- Every table gets a primary key.
- Don't store comma-separated lists in one column.
- Don't use `= NULL`, use `IS NULL`.
- `NOT IN` with NULLs returns no rows; use `NOT EXISTS`.
- Don't mix `AND`/`OR` without parentheses.
- Don't store passwords in plain text (use bcrypt/argon2 in the app, not `MD5`).
- Format SQL consistently (keywords uppercase, one clause per line).

### 34.16 SQL Standards
SQL is standardized by ANSI/ISO (SQL-86, SQL-92, SQL:1999 (CTE, triggers), SQL:2003 (window functions), SQL:2011 (temporal tables), SQL:2016 (JSON)). Each database adds its own extensions.

### 34.17 Learning Roadmap
1. Basics: `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
2. Aggregates: `GROUP BY`, `HAVING`
3. Joins and subqueries
4. DDL, constraints, keys
5. Window functions and CTEs
6. Indexes, `EXPLAIN`, optimization
7. Transactions, views, procedures, triggers
8. Practice: LeetCode SQL, HackerRank SQL, StrataScratch, SQLZoo, Mode SQL Tutorial

---

## 🤝 Contributing
Found a mistake or want to add something? Fork the repo, edit, and open a pull request.

## ⭐ Support
If these notes helped you, give the repo a star!

## 📜 License
Free to use for learning. Add a `LICENSE` file (e.g. MIT) as you prefer.
