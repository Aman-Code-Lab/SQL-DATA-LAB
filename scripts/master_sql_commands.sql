<div align="center">

# ⚡ SQL Command Cheat Sheet

**Every SQL command in one place, with code that actually runs.**

![SQL](https://img.shields.io/badge/SQL-Cheat%20Sheet-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-00758F?style=for-the-badge&logo=mysql&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-notes-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-notes-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Oracle](https://img.shields.io/badge/Oracle-notes-F80000?style=for-the-badge&logo=oracle&logoColor=white)

</div>

> Default syntax is **MySQL 8.0+**. Dialect tags: `(PG)` PostgreSQL · `(SS)` SQL Server · `(ORA)` Oracle.
> Every example in this sheet runs against the **sample database** below, so you can copy, paste, and see results.

---

## 🚀 Quick Start: Sample Database

Run this once. All examples below use these tables.

```sql
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
```

> 💡 **Note:** `Finance` has no employees and `Vikram Das` has no department. That is deliberate, so the JOIN examples show real differences.

---

## 📑 Contents

| # | Section | # | Section |
|---|---|---|---|
| 1 | [Database](#1--database) | 18 | [JSON Functions](#18--json-functions) |
| 2 | [Table (DDL)](#2--table-ddl) | 19 | [Views](#19--views) |
| 3 | [ALTER TABLE](#3--alter-table) | 20 | [Indexes](#20--indexes) |
| 4 | [Constraints](#4--constraints) | 21 | [Transactions (TCL)](#21--transactions-tcl) |
| 5 | [INSERT / UPDATE / DELETE](#5--insert--update--delete-dml) | 22 | [Users and Permissions (DCL)](#22--users-and-permissions-dcl) |
| 6 | [SELECT (DQL)](#6--select-dql) | 23 | [Procedures and Functions](#23--stored-procedures-and-functions) |
| 7 | [Operators and Keywords](#7--operators-and-keywords) | 24 | [Triggers, Events, Cursors](#24--triggers-events-cursors) |
| 8 | [Joins](#8--joins) | 25 | [Control Flow](#25--control-flow) |
| 9 | [Set Operations](#9--set-operations) | 26 | [Variables and Prepared Statements](#26--variables-and-prepared-statements) |
| 10 | [Subqueries and CTE](#10--subqueries-and-cte) | 27 | [Temporary Tables and Sequences](#27--temporary-tables-and-sequences) |
| 11 | [Aggregate Functions](#11--aggregate-functions) | 28 | [Admin and Info Commands](#28--admin-and-info-commands) |
| 12 | [String Functions](#12--string-functions) | 29 | [Performance Commands](#29--performance-commands) |
| 13 | [Numeric Functions](#13--numeric-functions) | 30 | [Import, Export, Backup](#30--import-export-backup) |
| 14 | [Date and Time Functions](#14--date-and-time-functions) | 31 | [Partitioning](#31--partitioning) |
| 15 | [Conditional and NULL Functions](#15--conditional-and-null-functions) | 32 | [Data Types](#32--data-types) |
| 16 | [Type Conversion](#16--type-conversion) | 33 | [Dialect Differences](#33--dialect-differences) |
| 17 | [Window Functions](#17--window-functions) | 34 | [Order of Execution and Command Types](#34--order-of-execution-and-command-types) |

---

## 1. 🗄️ Database

| Command | Purpose |
|---|---|
| `CREATE DATABASE db;` | Create database |
| `CREATE DATABASE IF NOT EXISTS db;` | Create only if missing |
| `CREATE DATABASE db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;` | With charset |
| `SHOW DATABASES;` | List databases (PG: `\l`) |
| `USE db;` | Select database (PG: `\c db`) |
| `SELECT DATABASE();` | Current database (PG: `current_database()`) |
| `ALTER DATABASE db CHARACTER SET utf8mb4;` | Modify database |
| `DROP DATABASE db;` | Delete database |
| `DROP DATABASE IF EXISTS db;` | Delete if exists |
| `CREATE SCHEMA s;` / `DROP SCHEMA s;` | Schemas (PG/SS/ORA; in MySQL, schema = database) |

---

## 2. 🧱 Table (DDL)

| Command | Purpose |
|---|---|
| `CREATE TABLE t (id INT PRIMARY KEY, name VARCHAR(50));` | Create table |
| `CREATE TABLE IF NOT EXISTS t (...);` | Create if missing |
| `CREATE TABLE t2 AS SELECT * FROM t;` | Copy structure + data |
| `CREATE TABLE t2 AS SELECT * FROM t WHERE 1=0;` | Copy structure only |
| `CREATE TABLE t2 LIKE t;` | Copy structure with indexes (MySQL) |
| `SELECT * INTO t2 FROM t;` | Copy table (SS) |
| `SHOW TABLES;` | List tables (PG: `\dt`) |
| `DESCRIBE t;` / `DESC t;` | Show columns |
| `SHOW COLUMNS FROM t;` | Show columns |
| `SHOW CREATE TABLE t;` | Show full DDL |
| `RENAME TABLE old TO new;` | Rename (MySQL) |
| `TRUNCATE TABLE t;` | Delete all rows, reset identity (fast, cannot roll back in MySQL) |
| `DROP TABLE t;` | Delete table |
| `DROP TABLE IF EXISTS t;` | Delete if exists |
| `DROP TABLE t1, t2;` | Delete multiple |

```sql
-- Try it: a table with every common column rule
CREATE TABLE staff_demo (
    staff_id   INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(50) NOT NULL,
    email      VARCHAR(100) UNIQUE,
    salary     DECIMAL(10,2) DEFAULT 30000,
    age        INT CHECK (age >= 18),
    dept_id    INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE emp_copy  AS SELECT * FROM employees;           -- structure + data
CREATE TABLE emp_shape LIKE employees;                       -- structure only
DESCRIBE emp_copy;
DROP TABLE IF EXISTS emp_copy, emp_shape, staff_demo;        -- clean up
```

---

## 3. 🔧 ALTER TABLE

| Command | Purpose |
|---|---|
| `ALTER TABLE t ADD col INT;` | Add column |
| `ALTER TABLE t ADD col INT AFTER other;` | Add at position (MySQL) |
| `ALTER TABLE t ADD col INT FIRST;` | Add as first column (MySQL) |
| `ALTER TABLE t ADD (c1 INT, c2 INT);` | Add multiple (ORA); MySQL: `ADD c1 INT, ADD c2 INT` |
| `ALTER TABLE t DROP COLUMN col;` | Drop column |
| `ALTER TABLE t MODIFY col BIGINT;` | Change type (MySQL, ORA) |
| `ALTER TABLE t ALTER COLUMN col TYPE BIGINT;` | Change type (PG) |
| `ALTER TABLE t ALTER COLUMN col BIGINT;` | Change type (SS) |
| `ALTER TABLE t CHANGE old new INT;` | Rename + redefine (MySQL) |
| `ALTER TABLE t RENAME COLUMN old TO new;` | Rename column (MySQL 8+, PG, ORA) |
| `ALTER TABLE t RENAME TO new_t;` | Rename table |
| `ALTER TABLE t ALTER COLUMN col SET DEFAULT 0;` | Set default |
| `ALTER TABLE t ALTER COLUMN col DROP DEFAULT;` | Drop default |
| `ALTER TABLE t MODIFY col INT NOT NULL;` | Add NOT NULL (MySQL) |
| `ALTER TABLE t ALTER COLUMN col SET NOT NULL;` | Add NOT NULL (PG) |
| `ALTER TABLE t ALTER COLUMN col DROP NOT NULL;` | Remove NOT NULL (PG) |
| `ALTER TABLE t AUTO_INCREMENT = 100;` | Set next auto-increment |
| `ALTER TABLE t ENGINE = InnoDB;` | Change engine |
| `ALTER TABLE t CONVERT TO CHARACTER SET utf8mb4;` | Change charset |

```sql
-- Try it
ALTER TABLE employees ADD bonus DECIMAL(8,2) DEFAULT 0 AFTER salary;
ALTER TABLE employees MODIFY bonus DECIMAL(10,2) DEFAULT 0;
ALTER TABLE employees RENAME COLUMN bonus TO annual_bonus;
ALTER TABLE employees DROP COLUMN annual_bonus;
```

---

## 4. 🔒 Constraints

| Command | Purpose |
|---|---|
| `col INT NOT NULL` | Not null |
| `col INT UNIQUE` | Unique |
| `col INT PRIMARY KEY` | Primary key |
| `PRIMARY KEY (c1, c2)` | Composite primary key |
| `FOREIGN KEY (c) REFERENCES p(id)` | Foreign key |
| `CHECK (age >= 18)` | Check (enforced in MySQL 8.0.16+) |
| `col INT DEFAULT 0` | Default |
| `col INT AUTO_INCREMENT` | Auto number (PG: `SERIAL`, SS: `IDENTITY(1,1)`) |
| `ON DELETE CASCADE / SET NULL / RESTRICT / NO ACTION / SET DEFAULT` | Referential action |
| `ON UPDATE CASCADE / SET NULL / RESTRICT / NO ACTION` | Referential action |
| `CONSTRAINT name ...` | Name a constraint |

```sql
ALTER TABLE t ADD PRIMARY KEY (id);
ALTER TABLE t ADD CONSTRAINT uq UNIQUE (email);
ALTER TABLE t ADD CONSTRAINT fk FOREIGN KEY (dept_id) REFERENCES d(dept_id);
ALTER TABLE t ADD CONSTRAINT ck CHECK (salary > 0);

ALTER TABLE t DROP PRIMARY KEY;               -- MySQL
ALTER TABLE t DROP FOREIGN KEY fk;            -- MySQL
ALTER TABLE t DROP INDEX uq;                  -- MySQL (unique)
ALTER TABLE t DROP CHECK ck;                  -- MySQL 8.0.16+
ALTER TABLE t DROP CONSTRAINT name;           -- PG / SS / ORA

SET FOREIGN_KEY_CHECKS = 0;  -- disable (MySQL)
SET FOREIGN_KEY_CHECKS = 1;  -- enable
```

```sql
-- Try it: the CHECK constraint blocks bad data
INSERT INTO employees (name, age) VALUES ('Too Young', 15);   -- ERROR: check constraint violated
```

---

## 5. ✏️ INSERT / UPDATE / DELETE (DML)

```sql
-- INSERT
INSERT INTO departments (dept_name, location) VALUES ('Legal', 'Chennai');
INSERT INTO departments (dept_name, location) VALUES ('R&D','Pune'), ('Ops','Delhi');   -- multiple rows

CREATE TABLE emp_backup LIKE employees;
INSERT INTO emp_backup SELECT * FROM employees;                      -- from query
INSERT INTO emp_backup (name, salary) SELECT name, salary FROM employees WHERE salary > 100000;

INSERT IGNORE INTO departments (dept_name) VALUES ('IT');            -- skip duplicate error (MySQL)
REPLACE INTO departments (dept_id, dept_name, location) VALUES (1,'IT','Hyderabad');   -- delete + insert (MySQL)

-- UPSERT
INSERT INTO departments (dept_id, dept_name, location) VALUES (1,'IT','Bengaluru') AS new
ON DUPLICATE KEY UPDATE location = new.location;                     -- MySQL 8.0.19+

-- INSERT ... DEFAULT VALUES;                                        -- PG / SS
-- INSERT ... ON CONFLICT (id) DO UPDATE SET n = EXCLUDED.n;         -- PG upsert
-- INSERT ... RETURNING id;                                          -- PG

-- UPDATE
UPDATE employees SET salary = 61000 WHERE emp_id = 5;
UPDATE employees SET salary = salary * 1.10, age = age + 1 WHERE dept_id = 1;
UPDATE employees SET salary = CASE WHEN salary < 50000 THEN salary * 1.2 ELSE salary END;
UPDATE employees e JOIN departments d ON e.dept_id = d.dept_id
SET e.salary = e.salary + 1000 WHERE d.dept_name = 'HR';             -- MySQL
-- UPDATE a SET x = b.x FROM b WHERE a.id = b.id;                    -- PG / SS
UPDATE employees SET salary = salary + 1 ORDER BY emp_id LIMIT 2;    -- MySQL

-- DELETE
DELETE FROM departments WHERE dept_name IN ('Legal','R&D','Ops');
DELETE FROM emp_backup WHERE emp_id = 1;
DELETE e FROM emp_backup e JOIN departments d ON e.dept_id = d.dept_id WHERE d.dept_name = 'HR';  -- MySQL
DELETE FROM emp_backup ORDER BY emp_id LIMIT 1;                      -- MySQL
DELETE FROM emp_backup;                                              -- all rows
DROP TABLE emp_backup;
```

> ⚠️ `UPDATE` or `DELETE` **without `WHERE`** touches every row. Run it as a `SELECT` first.

```sql
-- MERGE (SS / ORA / PG 15+); not available in MySQL
MERGE INTO target t USING source s ON t.id = s.id
WHEN MATCHED THEN UPDATE SET t.v = s.v
WHEN NOT MATCHED THEN INSERT (id, v) VALUES (s.id, s.v);
```

---

## 6. 🔍 SELECT (DQL)

```sql
SELECT * FROM employees;
SELECT name, salary FROM employees;
SELECT DISTINCT dept_id FROM employees;
SELECT name AS employee, salary * 12 AS yearly FROM employees;
SELECT name FROM employees WHERE salary > 60000;
SELECT dept_id, COUNT(*) AS headcount FROM employees GROUP BY dept_id HAVING COUNT(*) > 1;
SELECT * FROM employees ORDER BY dept_id ASC, salary DESC;
SELECT * FROM employees LIMIT 3;
SELECT * FROM employees LIMIT 3 OFFSET 3;
SELECT * FROM employees LIMIT 3, 3;                      -- offset, count (MySQL)
SELECT 1 + 1;
SELECT COUNT(*) INTO @cnt FROM employees;                -- into variable
SELECT @cnt;
```

Other dialects and locking:

```sql
SELECT TOP 3 * FROM employees;                           -- SS
SELECT * FROM employees FETCH FIRST 3 ROWS ONLY;         -- ORA / PG / SS
SELECT * FROM employees WHERE emp_id = 1 FOR UPDATE;     -- lock rows (inside a transaction)
SELECT * FROM employees WHERE emp_id = 1 FOR SHARE;      -- shared lock (MySQL 8+, PG)
```

Clause order you **write**:

```sql
SELECT [DISTINCT] columns
FROM table
[JOIN ... ON ...]
[WHERE ...]
[GROUP BY ...]
[HAVING ...]
[ORDER BY ...]
[LIMIT ... OFFSET ...];
```

---

## 7. 🧮 Operators and Keywords

| Operator | Example |
|---|---|
| `=`, `<>`, `!=`, `>`, `<`, `>=`, `<=` | `WHERE age >= 18` |
| `<=>` | NULL-safe equal (MySQL) |
| `AND`, `OR`, `NOT` | `WHERE a = 1 AND (b = 2 OR c = 3)` |
| `BETWEEN x AND y` | `WHERE age BETWEEN 25 AND 35` (inclusive) |
| `NOT BETWEEN` | `WHERE age NOT BETWEEN 25 AND 35` |
| `IN (...)` | `WHERE dept_id IN (1,2)` |
| `NOT IN (...)` | Beware NULLs in the list |
| `LIKE` | `'A%'` starts, `'%a'` ends, `'%a%'` contains, `'_a%'` 2nd letter a |
| `NOT LIKE` | `WHERE name NOT LIKE 'A%'` |
| `ILIKE` | Case-insensitive LIKE (PG) |
| `REGEXP` / `RLIKE` | `WHERE name REGEXP '^[AEIOU]'` (MySQL); `~` (PG) |
| `IS NULL` / `IS NOT NULL` | `WHERE email IS NULL` |
| `EXISTS` / `NOT EXISTS` | `WHERE EXISTS (SELECT 1 FROM ...)` |
| `ANY` / `SOME` / `ALL` | `WHERE salary > ALL (SELECT ...)` |
| `+ - * / %` | Arithmetic (`DIV`, `MOD`) |
| `& \| ^ ~ << >>` | Bitwise |
| `\|\|` | Concatenate (PG, ORA) |
| `+` | Concatenate (SS) |
| `AS` | Alias |
| `DISTINCT` | Unique values |
| `UNION`, `INTERSECT`, `EXCEPT` | Set operators |
| `COLLATE` | Specify collation |
| `ESCAPE` | `LIKE '50\%' ESCAPE '\\'` |

```sql
-- Try it
SELECT name FROM employees WHERE name LIKE 'A%';
SELECT name FROM employees WHERE name REGEXP '^[AEIOU]';
SELECT name FROM employees WHERE email IS NULL;
SELECT name, salary FROM employees WHERE salary > ALL (SELECT salary FROM employees WHERE dept_id = 2);
```

---

## 8. 🔗 Joins

```sql
SELECT e.name, d.dept_name FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id;   -- matches only
SELECT e.name, d.dept_name FROM employees e LEFT  JOIN departments d ON e.dept_id = d.dept_id;   -- all employees (Vikram: NULL dept)
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;   -- all departments (Finance: NULL emp)
SELECT d.dept_name, e.name FROM departments d CROSS JOIN employees e;                            -- cartesian
SELECT * FROM employees e JOIN departments d USING (dept_id);                                    -- shared column name
SELECT * FROM employees NATURAL JOIN departments;                                                -- all same-named columns

-- Self join: employee and manager
SELECT e.name AS employee, m.name AS manager FROM employees e LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Anti join: departments with no employees
SELECT d.dept_name FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id WHERE e.emp_id IS NULL;

-- Non-equi join
SELECT e1.name, e2.name FROM employees e1 JOIN employees e2 ON e1.salary BETWEEN e2.salary - 3000 AND e2.salary + 3000 AND e1.emp_id < e2.emp_id;

-- Multi-table
SELECT e.name, d.dept_name, o.amount
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN orders o ON o.emp_id = e.emp_id;

-- FULL OUTER JOIN (PG / SS / ORA)
-- SELECT * FROM a FULL OUTER JOIN b ON a.id = b.a_id;
-- MySQL workaround:
SELECT e.name, d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

| Join | Returns |
|---|---|
| `INNER` | Rows matching in both |
| `LEFT` | All left + matches (NULL if none) |
| `RIGHT` | All right + matches |
| `FULL` | All rows from both |
| `CROSS` | Every combination |
| `LATERAL` / `CROSS APPLY` | Correlated subquery per row (PG, MySQL 8.0.14+ / SS) |

---

## 9. 🧩 Set Operations

```sql
SELECT dept_id FROM employees UNION     SELECT dept_id FROM departments;   -- no duplicates
SELECT dept_id FROM employees UNION ALL SELECT dept_id FROM departments;   -- keep duplicates
SELECT dept_id FROM departments INTERSECT SELECT dept_id FROM employees;   -- common (MySQL 8.0.31+)
SELECT dept_id FROM departments EXCEPT    SELECT dept_id FROM employees;   -- in left only (ORA: MINUS)
```

> Both queries need the same number of columns with compatible types.

---

## 10. 🪆 Subqueries and CTE

```sql
-- Scalar
SELECT name, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);
-- IN
SELECT name FROM employees WHERE emp_id IN (SELECT emp_id FROM orders);
-- Derived table
SELECT * FROM (SELECT emp_id, SUM(amount) AS total FROM orders GROUP BY emp_id) x WHERE total > 1000;
-- Correlated: earns more than own department's average
SELECT name, salary FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id);
-- EXISTS
SELECT d.dept_name FROM departments d WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id);
-- In SELECT list
SELECT name, (SELECT COUNT(*) FROM orders o WHERE o.emp_id = e.emp_id) AS order_count FROM employees e;

-- CTE
WITH dept_avg AS (
  SELECT dept_id, AVG(salary) AS avg_sal FROM employees GROUP BY dept_id
)
SELECT e.name, e.salary, d.avg_sal
FROM employees e JOIN dept_avg d ON e.dept_id = d.dept_id;

-- Multiple CTEs
WITH totals AS (SELECT emp_id, SUM(amount) AS total FROM orders GROUP BY emp_id),
     top_sellers AS (SELECT * FROM totals WHERE total > 1000)
SELECT e.name, t.total FROM top_sellers t JOIN employees e USING (emp_id);

-- Recursive CTE: numbers 1..10
WITH RECURSIVE n AS (
  SELECT 1 AS x UNION ALL SELECT x + 1 FROM n WHERE x < 10
)
SELECT * FROM n;

-- Recursive CTE: management chain
WITH RECURSIVE chain AS (
  SELECT emp_id, name, manager_id, 1 AS level FROM employees WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.name, e.manager_id, c.level + 1
  FROM employees e JOIN chain c ON e.manager_id = c.emp_id
)
SELECT * FROM chain ORDER BY level, emp_id;
```

---

## 11. 📊 Aggregate Functions

| Function | Purpose |
|---|---|
| `COUNT(*)` | All rows |
| `COUNT(col)` | Non-NULL values |
| `COUNT(DISTINCT col)` | Unique non-NULL |
| `SUM(col)` | Total |
| `AVG(col)` | Average |
| `MIN(col)` / `MAX(col)` | Min / max |
| `GROUP_CONCAT(col SEPARATOR ',')` | Join values (MySQL) |
| `STRING_AGG(col, ',')` | Join values (PG, SS) |
| `LISTAGG(col, ',')` | Join values (ORA) |
| `STDDEV()`, `VARIANCE()` | Statistics |
| `BIT_AND()`, `BIT_OR()`, `BIT_XOR()` | Bitwise aggregate |
| `JSON_ARRAYAGG()`, `JSON_OBJECTAGG()` | JSON aggregate |
| `GROUP BY ROLLUP(a,b)` / `WITH ROLLUP` | Subtotals |
| `GROUP BY CUBE(a,b)` | All combinations (PG/SS/ORA) |
| `GROUP BY GROUPING SETS (...)` | Custom groupings |

```sql
SELECT COUNT(*), COUNT(email), COUNT(DISTINCT dept_id) FROM employees;    -- 8, 7, 3
SELECT dept_id, COUNT(*) AS n, ROUND(AVG(salary),2) AS avg_sal, MAX(salary) AS top
FROM employees GROUP BY dept_id;
SELECT dept_id, GROUP_CONCAT(name ORDER BY name SEPARATOR ', ') AS team FROM employees GROUP BY dept_id;
SELECT dept_id, SUM(salary) AS total FROM employees GROUP BY dept_id WITH ROLLUP;   -- MySQL
```

> `COUNT(*)` counts rows; `COUNT(col)` skips NULLs.

---

## 12. 🔤 String Functions

| Function | Purpose |
|---|---|
| `UPPER(s)`, `LOWER(s)` | Case |
| `LENGTH(s)`, `CHAR_LENGTH(s)` | Bytes / characters (SS: `LEN`) |
| `CONCAT(a,b,...)`, `CONCAT_WS(sep,a,b)` | Join strings |
| `SUBSTRING(s,pos,len)`, `SUBSTR` | Substring (1-based) |
| `LEFT(s,n)`, `RIGHT(s,n)` | First/last n chars |
| `TRIM(s)`, `LTRIM(s)`, `RTRIM(s)` | Remove spaces |
| `TRIM(BOTH 'x' FROM s)` | Remove specific chars |
| `REPLACE(s,from,to)` | Replace text |
| `REVERSE(s)` | Reverse |
| `INSTR(s,sub)`, `LOCATE(sub,s)`, `POSITION(sub IN s)` | Find position |
| `LPAD(s,n,p)`, `RPAD(s,n,p)` | Pad |
| `REPEAT(s,n)` | Repeat |
| `SPACE(n)` | n spaces |
| `ASCII(c)`, `CHAR(n)` | Char/code |
| `FORMAT(n,d)` | Number format (`1,234.50`) |
| `STRCMP(a,b)` | Compare |
| `FIELD(s,a,b,c)` | Index in list |
| `FIND_IN_SET(s,'a,b,c')` | Position in CSV |
| `SUBSTRING_INDEX(s,delim,n)` | Split by delimiter (MySQL) |
| `SPLIT_PART(s,delim,n)` | Split (PG) |
| `INITCAP(s)` | Capitalize words (PG/ORA) |
| `TRANSLATE(s,from,to)` | Replace char by char (PG/ORA) |
| `OVERLAY()`, `INSERT(s,pos,len,new)` | Insert/replace part |
| `SOUNDEX(s)` | Phonetic code |
| `REGEXP_REPLACE()`, `REGEXP_SUBSTR()`, `REGEXP_LIKE()`, `REGEXP_INSTR()` | Regex (MySQL 8+) |
| `QUOTE(s)` | Escape string |
| `HEX(s)`, `UNHEX(s)` | Hex |
| `MD5(s)`, `SHA2(s,256)` | Hashing |
| `TO_BASE64(s)`, `FROM_BASE64(s)` | Base64 |

```sql
SELECT UPPER(name), LENGTH(name), LEFT(name,3), SUBSTRING(name,1,4) FROM employees LIMIT 3;
SELECT CONCAT(name, ' <', IFNULL(email,'no email'), '>') AS contact FROM employees;
SELECT SUBSTRING_INDEX(email,'@',1) AS username, SUBSTRING_INDEX(email,'@',-1) AS domain FROM employees WHERE email IS NOT NULL;
SELECT REPLACE('2024-01-15','-','/'), LPAD(7,3,'0'), REPEAT('ab',3), REVERSE('SQL');
SELECT REGEXP_REPLACE('a1b22c333','[0-9]+','#');    -- a#b#c#
SELECT SHA2('secret',256);
```

---

## 13. 🔢 Numeric Functions

| Function | Purpose |
|---|---|
| `ROUND(n,d)` | Round |
| `CEIL(n)`, `CEILING(n)` | Round up |
| `FLOOR(n)` | Round down |
| `TRUNCATE(n,d)` | Cut decimals (PG/ORA: `TRUNC`) |
| `ABS(n)` | Absolute |
| `MOD(a,b)`, `a % b` | Remainder |
| `POWER(a,b)`, `POW` | Power |
| `SQRT(n)` | Square root |
| `EXP(n)`, `LN(n)`, `LOG(n)`, `LOG10(n)`, `LOG2(n)` | Exponent / logs |
| `SIGN(n)` | -1 / 0 / 1 |
| `RAND()` (PG: `RANDOM()`) | Random 0–1 |
| `GREATEST(a,b,...)`, `LEAST(a,b,...)` | Max/min of values |
| `PI()` | π |
| `SIN()`, `COS()`, `TAN()`, `ASIN()`, `ACOS()`, `ATAN()` | Trigonometry |
| `DEGREES()`, `RADIANS()` | Angle conversion |
| `CONV(n,from,to)` | Base conversion |
| `DIV` | Integer division (MySQL) |

```sql
SELECT ROUND(3.14159,2), CEIL(4.1), FLOOR(4.9), TRUNCATE(4.987,1), ABS(-5);   -- 3.14, 5, 4, 4.9, 5
SELECT MOD(17,5), 17 % 5, 17 DIV 5, POWER(2,10), SQRT(144), SIGN(-9);         -- 2, 2, 3, 1024, 12, -1
SELECT GREATEST(3,9,2), LEAST(3,9,2), CONV('FF',16,10);                       -- 9, 2, 255
SELECT name FROM employees ORDER BY RAND() LIMIT 1;                           -- random employee
```

---

## 14. 📅 Date and Time Functions

| Function | Purpose |
|---|---|
| `NOW()`, `CURRENT_TIMESTAMP`, `SYSDATE()` | Current datetime (SS: `GETDATE()`, ORA: `SYSDATE`) |
| `CURDATE()`, `CURRENT_DATE` | Current date |
| `CURTIME()`, `CURRENT_TIME` | Current time |
| `UTC_TIMESTAMP()`, `UTC_DATE()` | UTC |
| `DATE(x)`, `TIME(x)` | Extract date/time part |
| `YEAR(x)`, `MONTH(x)`, `DAY(x)`, `HOUR(x)`, `MINUTE(x)`, `SECOND(x)` | Parts |
| `QUARTER(x)`, `WEEK(x)`, `WEEKDAY(x)`, `DAYOFWEEK(x)`, `DAYOFMONTH(x)`, `DAYOFYEAR(x)` | Calendar numbers |
| `DAYNAME(x)`, `MONTHNAME(x)` | Names |
| `EXTRACT(unit FROM x)` | Standard extraction |
| `DATE_ADD(x, INTERVAL n unit)`, `ADDDATE` | Add |
| `DATE_SUB(x, INTERVAL n unit)`, `SUBDATE` | Subtract |
| `x + INTERVAL 7 DAY` | Add interval |
| `DATEDIFF(d1,d2)` | Days between (SS: `DATEDIFF(day,d1,d2)`) |
| `TIMESTAMPDIFF(unit,d1,d2)` | Difference in unit |
| `TIMEDIFF(t1,t2)` | Time difference |
| `DATE_FORMAT(x,'%Y-%m-%d')` | Format (PG: `TO_CHAR`, SS: `FORMAT`) |
| `STR_TO_DATE(s,'%d-%m-%Y')` | Parse string (PG/ORA: `TO_DATE`) |
| `LAST_DAY(x)` | Last day of month |
| `MAKEDATE(y,doy)`, `MAKETIME(h,m,s)` | Build date/time |
| `FROM_UNIXTIME(n)`, `UNIX_TIMESTAMP(x)` | Epoch conversion |
| `TO_DAYS(x)`, `FROM_DAYS(n)` | Day number |
| `SEC_TO_TIME(n)`, `TIME_TO_SEC(t)` | Seconds conversion |
| `AGE(d1,d2)` | Interval (PG) |
| `DATE_TRUNC('month', x)` | Truncate (PG) |
| `DATEADD(day,7,x)`, `DATEPART(year,x)` | (SS) |
| `ADD_MONTHS(x,n)`, `MONTHS_BETWEEN(a,b)` | (ORA) |

Units: `MICROSECOND, SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, YEAR`

Format codes: `%Y` year · `%y` 2-digit year · `%m` month (01-12) · `%M` month name · `%b` short month · `%d` day · `%e` day no pad · `%H` 24h · `%h` 12h · `%i` minutes · `%s` seconds · `%p` AM/PM · `%W` weekday name · `%a` short weekday · `%j` day of year

```sql
SELECT NOW(), CURDATE(), CURTIME();
SELECT name, hire_date, YEAR(hire_date) AS yr, MONTHNAME(hire_date) AS mon, DAYNAME(hire_date) AS dow FROM employees;
SELECT name, TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service FROM employees;
SELECT DATE_ADD('2024-01-31', INTERVAL 1 MONTH), '2024-01-15' + INTERVAL 7 DAY, LAST_DAY('2024-02-10');
SELECT DATEDIFF('2024-12-25','2024-01-01');                                  -- 359
SELECT DATE_FORMAT('2024-03-05','%d %b %Y, %W');                             -- 05 Mar 2024, Tuesday
SELECT STR_TO_DATE('15-08-2024','%d-%m-%Y');                                 -- 2024-08-15
SELECT YEAR(order_date) AS yr, MONTH(order_date) AS mon, SUM(amount) FROM orders GROUP BY yr, mon ORDER BY yr, mon;
```

---

## 15. 🔀 Conditional and NULL Functions

| Function | Purpose |
|---|---|
| `CASE WHEN c THEN a ELSE b END` | If-else (standard) |
| `CASE col WHEN 1 THEN 'a' WHEN 2 THEN 'b' END` | Simple CASE |
| `IF(cond, yes, no)` | Inline if (MySQL) |
| `IIF(cond, yes, no)` | Inline if (SS) |
| `IFNULL(a,b)` | b if a is NULL (MySQL) |
| `ISNULL(a,b)` | (SS) |
| `NVL(a,b)`, `NVL2(a,b,c)` | (ORA) |
| `COALESCE(a,b,c)` | First non-NULL (standard) |
| `NULLIF(a,b)` | NULL if a = b |
| `GREATEST()`, `LEAST()` | Max/min across columns |
| `DECODE(col,v1,r1,v2,r2,def)` | (ORA) |

```sql
SELECT name, salary,
  CASE WHEN salary >= 70000 THEN 'High'
       WHEN salary >= 55000 THEN 'Medium'
       ELSE 'Low' END AS band
FROM employees;

SELECT name, IF(dept_id IS NULL, 'Unassigned', 'Assigned') AS status FROM employees;
SELECT name, COALESCE(email, 'no-email') FROM employees;
SELECT NULLIF(10, 10), NULLIF(10, 5);                         -- NULL, 10
SELECT 100 / NULLIF(0, 0);                                    -- NULL instead of a divide-by-zero error
```

---

## 16. 🔄 Type Conversion

```sql
SELECT CAST('123' AS SIGNED), CAST(12.3456 AS DECIMAL(10,2)), CAST('2024-05-01' AS DATE);
SELECT CAST(NOW() AS DATE), CAST(65 AS CHAR), CONVERT('42', SIGNED), CONVERT('abc' USING utf8mb4);
SELECT '10' + 5;                                              -- 15 (implicit conversion)
```

```sql
-- Other dialects
-- x::INT                                   (PG shorthand)
-- TO_CHAR(x,'fmt'), TO_NUMBER(s), TO_DATE(s,'fmt')   (PG / ORA)
-- TRY_CAST(x AS INT), TRY_CONVERT(...)     (SS: returns NULL on failure)
```

---

## 17. 🪟 Window Functions

```sql
func() OVER (PARTITION BY a ORDER BY b ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
```

| Function | Purpose |
|---|---|
| `ROW_NUMBER()` | Unique row number |
| `RANK()` | Rank with gaps |
| `DENSE_RANK()` | Rank without gaps |
| `NTILE(n)` | Split into n buckets |
| `PERCENT_RANK()` | Relative rank 0–1 |
| `CUME_DIST()` | Cumulative distribution |
| `LAG(col,n,default)` | Previous row value |
| `LEAD(col,n,default)` | Next row value |
| `FIRST_VALUE(col)` | First in window |
| `LAST_VALUE(col)` | Last in window |
| `NTH_VALUE(col,n)` | Nth in window |
| `SUM() / AVG() / COUNT() / MIN() / MAX() OVER (...)` | Running / grouped aggregate |
| `WINDOW w AS (PARTITION BY ...)` | Named window |

Frame keywords: `ROWS`, `RANGE`, `UNBOUNDED PRECEDING`, `n PRECEDING`, `CURRENT ROW`, `n FOLLOWING`, `UNBOUNDED FOLLOWING`.

```sql
-- Rank salaries inside each department
SELECT name, dept_id, salary,
  ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn,
  RANK()       OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS drnk
FROM employees;

-- Top earner per department
SELECT * FROM (
  SELECT name, dept_id, salary, RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS r FROM employees
) t WHERE r = 1;

-- Running total and previous/next order
SELECT order_id, order_date, amount,
  SUM(amount) OVER (ORDER BY order_date, order_id) AS running_total,
  LAG(amount)  OVER (ORDER BY order_date, order_id) AS prev_amount,
  LEAD(amount) OVER (ORDER BY order_date, order_id) AS next_amount
FROM orders;

-- Moving average (3 rows) and share of department total
SELECT order_id, AVG(amount) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg FROM orders;
SELECT name, dept_id, salary, ROUND(100 * salary / SUM(salary) OVER (PARTITION BY dept_id), 1) AS pct_of_dept FROM employees;

-- Named window + NTILE
SELECT name, salary, NTILE(4) OVER w AS quartile FROM employees WINDOW w AS (ORDER BY salary);
```

---

## 18. 🧾 JSON Functions

```sql
CREATE TABLE products (id INT PRIMARY KEY AUTO_INCREMENT, info JSON);
INSERT INTO products (info) VALUES
  ('{"name":"Laptop","price":55000,"tags":["tech","work"]}'),
  ('{"name":"Desk","price":12000,"tags":["furniture"]}');

SELECT JSON_EXTRACT(info,'$.name') FROM products;                 -- "Laptop"
SELECT info->'$.name', info->>'$.name' FROM products;             -- quoted / unquoted
SELECT JSON_OBJECT('k', 1, 'x', 'y'), JSON_ARRAY(1,2,3);
UPDATE products SET info = JSON_SET(info, '$.price', 50000) WHERE id = 1;
UPDATE products SET info = JSON_REMOVE(info, '$.tags') WHERE id = 2;
SELECT * FROM products WHERE JSON_CONTAINS(info->'$.tags', '"tech"');
SELECT JSON_LENGTH(info), JSON_KEYS(info), JSON_VALID(info), JSON_TYPE(info) FROM products;
SELECT jt.* FROM products p,
  JSON_TABLE(p.info, '$' COLUMNS (name VARCHAR(50) PATH '$.name', price INT PATH '$.price')) jt;
DROP TABLE products;
```

Other functions: `JSON_INSERT()`, `JSON_REPLACE()`, `JSON_ARRAYAGG()`, `JSON_OBJECTAGG()`.

```sql
-- PG:  col->'name'   col->>'name'   col @> '{"a":1}'   jsonb_set(...)
-- SS:  JSON_VALUE(col,'$.name')   OPENJSON(col)   FOR JSON PATH
```

---

## 19. 👁️ Views

```sql
CREATE VIEW v_it_staff AS SELECT emp_id, name, salary FROM employees WHERE dept_id = 1;
CREATE OR REPLACE VIEW v_it_staff AS SELECT emp_id, name, salary, hire_date FROM employees WHERE dept_id = 1;
CREATE VIEW v_cheap AS SELECT * FROM employees WHERE salary < 60000 WITH CHECK OPTION;  -- blocks rows that would leave the view

SELECT * FROM v_it_staff;
ALTER VIEW v_it_staff AS SELECT emp_id, name FROM employees WHERE dept_id = 1;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW CREATE VIEW v_it_staff;
DROP VIEW IF EXISTS v_it_staff, v_cheap;
```

```sql
-- PG / ORA only
CREATE MATERIALIZED VIEW mv AS SELECT ...;
REFRESH MATERIALIZED VIEW mv;            -- PG
```

---

## 20. ⚡ Indexes

```sql
CREATE INDEX idx_dept ON employees (dept_id);
CREATE INDEX idx_dept_sal ON employees (dept_id, salary);          -- composite (leftmost-prefix rule)
CREATE UNIQUE INDEX idx_email ON employees (email);                -- (skip if already UNIQUE)
CREATE FULLTEXT INDEX idx_ft ON departments (dept_name, location); -- MySQL
CREATE INDEX idx_sal_desc ON employees (salary DESC);              -- MySQL 8+
CREATE INDEX idx_name5 ON employees (name(5));                     -- prefix index (MySQL)

SHOW INDEX FROM employees;
ALTER TABLE employees ADD INDEX idx_age (age);
ALTER TABLE employees ALTER INDEX idx_age INVISIBLE;               -- MySQL 8+: hide from optimizer
DROP INDEX idx_age ON employees;                                   -- MySQL / SS
-- DROP INDEX idx_age;                                             -- PG / ORA

SELECT * FROM departments WHERE MATCH(dept_name, location) AGAINST('Delhi');   -- use FULLTEXT
```

```sql
-- PG: partial index  CREATE INDEX idx ON t (col) WHERE active;
-- PG: expression idx CREATE INDEX idx ON t (LOWER(email));
-- SS: INCLUDE cols   CREATE INDEX idx ON t (a) INCLUDE (b);
```

> 💡 Index columns you filter, join, or sort on. Too many indexes slow down writes.

---

## 21. 🔁 Transactions (TCL)

```sql
START TRANSACTION;              -- or BEGIN
UPDATE employees SET salary = salary - 1000 WHERE emp_id = 2;
UPDATE employees SET salary = salary + 1000 WHERE emp_id = 3;
COMMIT;                         -- save

START TRANSACTION;
DELETE FROM orders WHERE emp_id = 6;
ROLLBACK;                       -- undo everything

START TRANSACTION;
UPDATE employees SET age = age + 1 WHERE emp_id = 1;
SAVEPOINT sp1;
UPDATE employees SET age = age + 1 WHERE emp_id = 2;
ROLLBACK TO SAVEPOINT sp1;      -- undo only the second update
RELEASE SAVEPOINT sp1;
COMMIT;

SET autocommit = 0;             -- manual commit mode
SET autocommit = 1;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;   -- applies to the next transaction
SELECT @@transaction_isolation;
```

| Isolation level | Dirty read | Non-repeatable read | Phantom read |
|---|---|---|---|
| `READ UNCOMMITTED` | Yes | Yes | Yes |
| `READ COMMITTED` | No | Yes | Yes |
| `REPEATABLE READ` (MySQL default) | No | No | Mostly no (InnoDB) |
| `SERIALIZABLE` | No | No | No |

> **ACID:** Atomicity · Consistency · Isolation · Durability. DDL statements (`CREATE`, `DROP`, `TRUNCATE`) auto-commit in MySQL.

---

## 22. 🛡️ Users and Permissions (DCL)

```sql
CREATE USER 'alice'@'localhost' IDENTIFIED BY 'Str0ng#Pass';
CREATE USER 'bob'@'%' IDENTIFIED BY 'Str0ng#Pass2';             -- any host

GRANT SELECT ON sql_cheatsheet.* TO 'alice'@'localhost';
GRANT SELECT, INSERT, UPDATE ON sql_cheatsheet.employees TO 'alice'@'localhost';
GRANT ALL PRIVILEGES ON sql_cheatsheet.* TO 'bob'@'%' WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE sql_cheatsheet.raise_salary TO 'alice'@'localhost';

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
-- GRANT 'reader' TO 'alice'@'localhost'; SET DEFAULT ROLE 'reader' TO 'alice'@'localhost';
DROP ROLE 'reader';
```

> `GRANT ... ` on `procedure raise_salary` needs the procedure from [section 23](#23--stored-procedures-and-functions) to exist first.

---

## 23. 🧠 Stored Procedures and Functions

```sql
DELIMITER //

CREATE PROCEDURE raise_salary(IN p_dept INT, IN p_pct DECIMAL(5,2))
BEGIN
    UPDATE employees SET salary = salary * (1 + p_pct / 100) WHERE dept_id = p_dept;
    SELECT ROW_COUNT() AS rows_updated;
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
```

> `DELIMITER //` lets the client treat `;` inside the body as part of the routine. Parameter modes: `IN` (default), `OUT`, `INOUT`.
> If creating functions fails with a binary-logging error, run `SET GLOBAL log_bin_trust_function_creators = 1;` (needs privilege).

---

## 24. ⏰ Triggers, Events, Cursors

### Triggers

```sql
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
        INSERT INTO salary_log (emp_id, old_salary, new_salary) VALUES (OLD.emp_id, OLD.salary, NEW.salary);
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
```

Timing: `BEFORE` / `AFTER` · Event: `INSERT` / `UPDATE` / `DELETE` · `OLD` = row before, `NEW` = row after.

### Events (scheduler)

```sql
SET GLOBAL event_scheduler = ON;

CREATE EVENT ev_purge_log
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP
DO DELETE FROM salary_log WHERE changed_at < NOW() - INTERVAL 30 DAY;

SHOW EVENTS;
ALTER EVENT ev_purge_log DISABLE;
DROP EVENT IF EXISTS ev_purge_log;
```

### Cursors

```sql
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
```

---

## 25. 🚦 Control Flow

```sql
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
    CASE WHEN n > 100 THEN SELECT 'big'; ELSE SELECT 'small'; END CASE;

    -- WHILE
    WHILE i <= n DO SET s = s + i; SET i = i + 1; END WHILE;
    SELECT s AS sum_1_to_n;

    -- REPEAT
    SET i = 0;
    REPEAT SET i = i + 1; UNTIL i >= 3 END REPEAT;

    -- LOOP with LEAVE / ITERATE
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
```

Error handling:

```sql
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
```

---

## 26. 📦 Variables and Prepared Statements

```sql
-- User variables (session-wide)
SET @name = 'Asha Rao';
SET @min_sal := 60000;
SELECT @name, @min_sal;
SELECT COUNT(*) INTO @n FROM employees WHERE salary > @min_sal;
SELECT @n;

-- System variables
SHOW VARIABLES LIKE 'max_connections';
SET SESSION sql_mode = 'STRICT_ALL_TABLES';
SET GLOBAL max_connections = 300;                 -- needs privilege
SELECT @@version, @@sql_mode, @@global.time_zone;

-- Local variables (inside routines only)
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
```

> ⚠️ Use `?` placeholders for values. Never concatenate untrusted input into SQL (SQL injection).

---

## 27. 🧪 Temporary Tables and Sequences

```sql
-- Temporary table: visible only to your session, dropped on disconnect
CREATE TEMPORARY TABLE tmp_high AS SELECT * FROM employees WHERE salary > 60000;
SELECT * FROM tmp_high;
DROP TEMPORARY TABLE tmp_high;

-- AUTO_INCREMENT helpers
SELECT LAST_INSERT_ID();
ALTER TABLE departments AUTO_INCREMENT = 100;
```

Sequences (MySQL has none; use `AUTO_INCREMENT`):

```sql
-- PG / ORA / SS
CREATE SEQUENCE seq_id START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999 CACHE 20;
SELECT NEXTVAL('seq_id');             -- PG
SELECT seq_id.NEXTVAL FROM dual;      -- ORA
SELECT NEXT VALUE FOR seq_id;         -- SS
ALTER SEQUENCE seq_id RESTART WITH 100;
DROP SEQUENCE seq_id;

-- Other temp-table syntax
-- SS:  CREATE TABLE #tmp (...)       PG: CREATE TEMP TABLE tmp (...)
```

---

## 28. 🛠️ Admin and Info Commands

| Command | Purpose |
|---|---|
| `SHOW DATABASES;` / `SHOW TABLES;` | List objects |
| `SHOW TABLES LIKE 'emp%';` | Filter by pattern |
| `SHOW FULL COLUMNS FROM t;` | Columns with comments / collation |
| `SHOW CREATE TABLE t;` | Full DDL |
| `SHOW INDEX FROM t;` | Indexes |
| `SHOW TABLE STATUS LIKE 't';` | Rows, size, engine |
| `SHOW PROCESSLIST;` | Running queries |
| `KILL 123;` | Stop a connection by ID |
| `SHOW STATUS;` | Server counters |
| `SHOW VARIABLES LIKE '%x%';` | Config values |
| `SHOW ENGINES;` | Storage engines |
| `SHOW WARNINGS;` / `SHOW ERRORS;` | Last statement problems |
| `SHOW GRANTS;` | Your permissions |
| `SHOW CHARACTER SET;` / `SHOW COLLATION;` | Charsets |
| `SELECT VERSION();` | Server version |
| `SELECT USER(), CURRENT_USER();` | Who am I |
| `SELECT CONNECTION_ID();` | Connection ID |
| `SELECT ROW_COUNT();` | Rows affected by last statement |
| `SELECT LAST_INSERT_ID();` | Last auto-increment value |
| `HELP 'SELECT';` | Built-in help (mysql client) |

```sql
-- information_schema: query the catalog like any table
SELECT table_name, table_rows FROM information_schema.tables WHERE table_schema = 'sql_cheatsheet';
SELECT column_name, data_type, is_nullable FROM information_schema.columns
WHERE table_schema = 'sql_cheatsheet' AND table_name = 'employees';
SELECT constraint_name, constraint_type FROM information_schema.table_constraints
WHERE table_schema = 'sql_cheatsheet' AND table_name = 'employees';
```

```sql
-- PG:  \l  \c db  \dt  \d t  \du  \q
-- SS:  sp_help 't'; sp_who; SELECT * FROM sys.tables;
-- ORA: SELECT * FROM user_tables; DESC t;
```

---

## 29. 🏎️ Performance Commands

```sql
EXPLAIN SELECT * FROM employees WHERE dept_id = 1;
EXPLAIN FORMAT=JSON SELECT * FROM employees WHERE salary > 60000;
EXPLAIN ANALYZE SELECT * FROM employees e JOIN departments d USING (dept_id);   -- MySQL 8.0.18+, runs the query

ANALYZE TABLE employees;        -- refresh index statistics
OPTIMIZE TABLE employees;       -- defragment / rebuild
CHECK TABLE employees;
REPAIR TABLE employees;         -- MyISAM and a few others

SET profiling = 1;              -- deprecated, use Performance Schema
SHOW PROFILES;

SHOW STATUS LIKE 'Slow_queries';
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;
```

Reading `EXPLAIN` (key columns):

| Column | Look for |
|---|---|
| `type` | Best → worst: `const`, `eq_ref`, `ref`, `range`, `index`, **`ALL`** (full scan) |
| `key` | Index actually used (`NULL` = none) |
| `rows` | Estimated rows scanned; lower is better |
| `Extra` | `Using filesort` / `Using temporary` are warning signs |

**Quick wins:** index filter/join columns · select only needed columns · avoid functions on indexed columns in `WHERE` (`WHERE YEAR(d)=2024` → `WHERE d >= '2024-01-01' AND d < '2025-01-01'`) · avoid leading wildcards `LIKE '%x'` · paginate with keyset instead of big `OFFSET` · use `EXISTS` over `IN` for big subqueries.

---

## 30. 💾 Import, Export, Backup

```sql
-- Export to CSV (server-side; needs FILE privilege and secure_file_priv path)
SELECT * FROM employees
INTO OUTFILE '/var/lib/mysql-files/employees.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Import from CSV
LOAD DATA INFILE '/var/lib/mysql-files/employees.csv'
INTO TABLE emp_copy
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;                                  -- skip header
-- LOAD DATA LOCAL INFILE 'file.csv' ...         -- file on the client machine (must be enabled)

SHOW VARIABLES LIKE 'secure_file_priv';
```

Command line (run in your terminal, **not** in the SQL prompt):

```bash
# Backup
mysqldump -u root -p sql_cheatsheet > backup.sql
mysqldump -u root -p --all-databases > all.sql
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
```

---

## 31. 🧱 Partitioning

```sql
CREATE TABLE sales (
    sale_id   INT NOT NULL AUTO_INCREMENT,
    sale_date DATE NOT NULL,
    amount    DECIMAL(10,2),
    PRIMARY KEY (sale_id, sale_date)               -- partition key must be in every unique key
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
ALTER TABLE sales DROP PARTITION p2023;            -- deletes that partition's data instantly
ALTER TABLE sales TRUNCATE PARTITION p2024;
SELECT partition_name, table_rows FROM information_schema.partitions WHERE table_name = 'sales';
DROP TABLE sales;
```

| Type | Splits by |
|---|---|
| `RANGE` | Value ranges (dates, ids) |
| `LIST` | Explicit value lists (`VALUES IN (1,2,3)`) |
| `HASH` | Hash of an expression (even spread) |
| `KEY` | MySQL-internal hash of column(s) |

---

## 32. 🏷️ Data Types

| Category | Types |
|---|---|
| **Integer** | `TINYINT` (1B) · `SMALLINT` (2B) · `MEDIUMINT` (3B) · `INT` (4B) · `BIGINT` (8B), add `UNSIGNED` for non-negative |
| **Exact decimal** | `DECIMAL(p,s)` / `NUMERIC(p,s)`, use for money |
| **Approximate** | `FLOAT`, `DOUBLE` |
| **Boolean** | `BOOLEAN` / `BOOL` (alias of `TINYINT(1)`; PG has a real `BOOLEAN`; SS: `BIT`) |
| **Fixed text** | `CHAR(n)` |
| **Variable text** | `VARCHAR(n)` · `TINYTEXT` · `TEXT` · `MEDIUMTEXT` · `LONGTEXT` |
| **Binary** | `BINARY(n)` · `VARBINARY(n)` · `BLOB` family |
| **Date / time** | `DATE` · `TIME` · `DATETIME` · `TIMESTAMP` · `YEAR` |
| **Other** | `ENUM('a','b')` · `SET('x','y')` · `JSON` · `BIT(n)` · spatial types (`POINT`, `GEOMETRY`) |

```sql
-- Try it
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
```

| Dialect equivalents | MySQL | PostgreSQL | SQL Server | Oracle |
|---|---|---|---|---|
| Auto id | `AUTO_INCREMENT` | `SERIAL` / `GENERATED ... AS IDENTITY` | `IDENTITY(1,1)` | `GENERATED AS IDENTITY` |
| Text | `TEXT` | `TEXT` | `VARCHAR(MAX)` | `CLOB` |
| Integer | `INT` | `INTEGER` | `INT` | `NUMBER(10)` |
| Datetime | `DATETIME` | `TIMESTAMP` | `DATETIME2` | `TIMESTAMP` |
| String | `VARCHAR` | `VARCHAR` | `NVARCHAR` | `VARCHAR2` |

---

## 33. 🌐 Dialect Differences

| Task | MySQL | PostgreSQL | SQL Server | Oracle |
|---|---|---|---|---|
| Limit rows | `LIMIT n` | `LIMIT n` | `TOP n` / `OFFSET FETCH` | `FETCH FIRST n ROWS ONLY` |
| Concatenate | `CONCAT()` | `\|\|` | `+` / `CONCAT()` | `\|\|` |
| Current time | `NOW()` | `NOW()` | `GETDATE()` | `SYSDATE` |
| NULL default | `IFNULL` | `COALESCE` | `ISNULL` | `NVL` |
| String length | `LENGTH` | `LENGTH` | `LEN` | `LENGTH` |
| Auto id | `AUTO_INCREMENT` | `SERIAL` | `IDENTITY` | `IDENTITY` / sequence |
| Upsert | `ON DUPLICATE KEY UPDATE` | `ON CONFLICT DO UPDATE` | `MERGE` | `MERGE` |
| Full outer join | emulate with `UNION` | ✅ | ✅ | ✅ |
| Except | `EXCEPT` (8.0.31+) | `EXCEPT` | `EXCEPT` | `MINUS` |
| Group concat | `GROUP_CONCAT` | `STRING_AGG` | `STRING_AGG` | `LISTAGG` |
| Quote identifiers | `` `name` `` | `"name"` | `[name]` | `"name"` |
| Show tables | `SHOW TABLES` | `\dt` | `sys.tables` | `user_tables` |
| Date format | `DATE_FORMAT` | `TO_CHAR` | `FORMAT` | `TO_CHAR` |
| Boolean | `TINYINT(1)` | `BOOLEAN` | `BIT` | `NUMBER(1)` |
| Return inserted | ❌ | `RETURNING` | `OUTPUT` | `RETURNING INTO` |
| Case-insensitive match | default collation | `ILIKE` | default collation | `UPPER()` / `REGEXP_LIKE(...,'i')` |

---

## 34. 🧭 Order of Execution and Command Types

### Logical order the database **runs** a query

```
1. FROM / JOIN     → pick and combine tables
2. WHERE           → filter rows
3. GROUP BY        → build groups
4. HAVING          → filter groups
5. SELECT          → compute columns, aliases
6. DISTINCT        → remove duplicates
7. Window functions
8. ORDER BY        → sort (can use aliases)
9. LIMIT / OFFSET  → trim result
```

> This is why you **cannot** use a `SELECT` alias in `WHERE` (it does not exist yet), but you can in `ORDER BY`. MySQL also allows aliases in `GROUP BY` and `HAVING` as an extension.

### Command categories

| Type | Full name | Commands |
|---|---|---|
| **DDL** | Data Definition | `CREATE` `ALTER` `DROP` `TRUNCATE` `RENAME` |
| **DML** | Data Manipulation | `INSERT` `UPDATE` `DELETE` `MERGE` `REPLACE` |
| **DQL** | Data Query | `SELECT` |
| **DCL** | Data Control | `GRANT` `REVOKE` |
| **TCL** | Transaction Control | `COMMIT` `ROLLBACK` `SAVEPOINT` `START TRANSACTION` |

### Keys at a glance

| Key | Meaning |
|---|---|
| **Primary key** | Unique + not null, identifies a row (one per table) |
| **Foreign key** | Points to a primary/unique key in another table |
| **Unique key** | No duplicates (NULLs allowed) |
| **Composite key** | Key made of 2+ columns |
| **Candidate key** | Any column set that could be the primary key |
| **Surrogate key** | Artificial id (e.g. `AUTO_INCREMENT`) |

### `DELETE` vs `TRUNCATE` vs `DROP`

| | `DELETE` | `TRUNCATE` | `DROP` |
|---|---|---|---|
| Removes | Chosen rows | All rows | Whole table |
| `WHERE` | ✅ | ❌ | ❌ |
| Resets auto-increment | ❌ | ✅ | n/a |
| Fires triggers | ✅ | ❌ | ❌ |
| Rollback | ✅ | ❌ in MySQL (✅ in PG/SS) | ❌ in MySQL |
| Type | DML | DDL | DDL |

---

<div align="center">

### ⭐ Found this useful? Star the repo!

Made with ❤️ for anyone learning SQL.

</div>
