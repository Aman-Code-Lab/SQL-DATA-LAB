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
| `ASCII(c)` / `CHAR(n)` | `ASCII
