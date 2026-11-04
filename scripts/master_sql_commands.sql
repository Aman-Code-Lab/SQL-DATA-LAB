# ⚡ SQL Command Cheat Sheet

Every SQL command in one place. Default syntax is **MySQL**; `(PG)` = PostgreSQL, `(SS)` = SQL Server, `(ORA)` = Oracle.

## 📑 Contents
1. [Database](#1-database)
2. [Table (DDL)](#2-table-ddl)
3. [ALTER TABLE](#3-alter-table)
4. [Constraints](#4-constraints)
5. [INSERT / UPDATE / DELETE (DML)](#5-insert--update--delete-dml)
6. [SELECT (DQL)](#6-select-dql)
7. [Operators and Keywords](#7-operators-and-keywords)
8. [Joins](#8-joins)
9. [Set Operations](#9-set-operations)
10. [Subqueries and CTE](#10-subqueries-and-cte)
11. [Aggregate Functions](#11-aggregate-functions)
12. [String Functions](#12-string-functions)
13. [Numeric Functions](#13-numeric-functions)
14. [Date and Time Functions](#14-date-and-time-functions)
15. [Conditional and NULL Functions](#15-conditional-and-null-functions)
16. [Type Conversion](#16-type-conversion)
17. [Window Functions](#17-window-functions)
18. [JSON Functions](#18-json-functions)
19. [Views](#19-views)
20. [Indexes](#20-indexes)
21. [Transactions (TCL)](#21-transactions-tcl)
22. [Users and Permissions (DCL)](#22-users-and-permissions-dcl)
23. [Stored Procedures and Functions](#23-stored-procedures-and-functions)
24. [Triggers, Events, Cursors](#24-triggers-events-cursors)
25. [Control Flow](#25-control-flow)
26. [Variables and Prepared Statements](#26-variables-and-prepared-statements)
27. [Temporary Tables and Sequences](#27-temporary-tables-and-sequences)
28. [Admin and Info Commands](#28-admin-and-info-commands)
29. [Performance Commands](#29-performance-commands)
30. [Import, Export, Backup](#30-import-export-backup)
31. [Partitioning](#31-partitioning)
32. [Data Types](#32-data-types)
33. [Dialect Differences](#33-dialect-differences)
34. [Order of Execution and Command Types](#34-order-of-execution-and-command-types)

---

## 1. Database

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
| `CREATE SCHEMA s;` / `DROP SCHEMA s;` | Schemas (PG/SS/ORA) |

---

## 2. Table (DDL)

| Command | Purpose |
|---|---|
| `CREATE TABLE t (id INT PRIMARY KEY, name VARCHAR(50));` | Create table |
| `CREATE TABLE IF NOT EXISTS t (...);` | Create if missing |
| `CREATE TABLE t2 AS SELECT * FROM t;` | Copy structure + data |
| `CREATE TABLE t2 AS SELECT * FROM t WHERE 1=0;` | Copy structure only |
| `CREATE TABLE t2 LIKE t;` | Copy structure with indexes (MySQL) |
| `SELECT * INTO t2 FROM t;` | Copy table (SS/PG) |
| `SHOW TABLES;` | List tables (PG: `\dt`) |
| `DESCRIBE t;` / `DESC t;` | Show columns |
| `SHOW COLUMNS FROM t;` | Show columns |
| `SHOW CREATE TABLE t;` | Show full DDL |
| `RENAME TABLE old TO new;` | Rename (MySQL) |
| `TRUNCATE TABLE t;` | Delete all rows, reset identity |
| `DROP TABLE t;` | Delete table |
| `DROP TABLE IF EXISTS t;` | Delete if exists |
| `DROP TABLE t1, t2;` | Delete multiple |

```sql
CREATE TABLE employees (
    emp_id     INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(50) NOT NULL,
    email      VARCHAR(100) UNIQUE,
    salary     DECIMAL(10,2) DEFAULT 30000,
    age        INT CHECK (age >= 18),
    dept_id    INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE ON UPDATE CASCADE
);
```

---

## 3. ALTER TABLE

| Command | Purpose |
|---|---|
| `ALTER TABLE t ADD col INT;` | Add column |
| `ALTER TABLE t ADD col INT AFTER other;` | Add at position (MySQL) |
| `ALTER TABLE t ADD col INT FIRST;` | Add as first column (MySQL) |
| `ALTER TABLE t ADD (c1 INT, c2 INT);` | Add multiple |
| `ALTER TABLE t DROP COLUMN col;` | Drop column |
| `ALTER TABLE t MODIFY col BIGINT;` | Change type (MySQL, ORA) |
| `ALTER TABLE t ALTER COLUMN col TYPE BIGINT;` | Change type (PG) |
| `ALTER TABLE t ALTER COLUMN col BIGINT;` | Change type (SS) |
| `ALTER TABLE t CHANGE old new INT;` | Rename + redefine (MySQL) |
| `ALTER TABLE t RENAME COLUMN old TO new;` | Rename column |
| `ALTER TABLE t RENAME TO new_t;` | Rename table |
| `ALTER TABLE t ALTER COLUMN col SET DEFAULT 0;` | Set default |
| `ALTER TABLE t ALTER COLUMN col DROP DEFAULT;` | Drop default |
| `ALTER TABLE t MODIFY col INT NOT NULL;` | Add NOT NULL (MySQL) |
| `ALTER TABLE t ALTER COLUMN col SET NOT NULL;` | Add NOT NULL (PG) |
| `ALTER TABLE t ALTER COLUMN col DROP NOT NULL;` | Remove NOT NULL (PG) |
| `ALTER TABLE t AUTO_INCREMENT = 100;` | Set next auto-increment |
| `ALTER TABLE t ENGINE = InnoDB;` | Change engine |
| `ALTER TABLE t CONVERT TO CHARACTER SET utf8mb4;` | Change charset |

---

## 4. Constraints

| Command | Purpose |
|---|---|
| `col INT NOT NULL` | Not null |
| `col INT UNIQUE` | Unique |
| `col INT PRIMARY KEY` | Primary key |
| `PRIMARY KEY (c1, c2)` | Composite primary key |
| `FOREIGN KEY (c) REFERENCES p(id)` | Foreign key |
| `CHECK (age >= 18)` | Check |
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

---

## 5. INSERT / UPDATE / DELETE (DML)

```sql
-- INSERT
INSERT INTO t VALUES (1, 'A', 100);
INSERT INTO t (id, name) VALUES (1, 'A');
INSERT INTO t (id, name) VALUES (1,'A'), (2,'B'), (3,'C');       -- multiple rows
INSERT INTO t2 SELECT * FROM t;                                  -- from query
INSERT INTO t2 (a, b) SELECT a, b FROM t WHERE x > 5;
INSERT INTO t DEFAULT VALUES;                                    -- PG / SS
INSERT IGNORE INTO t (...) VALUES (...);                         -- skip errors (MySQL)
REPLACE INTO t (id, name) VALUES (1, 'A');                       -- delete + insert (MySQL)
INSERT INTO t (id, n) VALUES (1,'A') ON DUPLICATE KEY UPDATE n = VALUES(n);   -- UPSERT MySQL
INSERT INTO t (id, n) VALUES (1,'A') ON CONFLICT (id) DO UPDATE SET n = EXCLUDED.n;  -- UPSERT PG
INSERT INTO t (n) VALUES ('A') RETURNING id;                     -- PG

-- UPDATE
UPDATE t SET name = 'B' WHERE id = 1;
UPDATE t SET a = 1, b = 2 WHERE id = 1;
UPDATE t SET salary = salary * 1.1;                              -- all rows!
UPDATE t SET x = CASE WHEN y > 5 THEN 1 ELSE 0 END;
UPDATE a JOIN b ON a.id = b.id SET a.x = b.x;                    -- MySQL
UPDATE a SET x = b.x FROM b WHERE a.id = b.id;                   -- PG / SS
UPDATE t SET x = x + 1 ORDER BY id LIMIT 10;                     -- MySQL

-- DELETE
DELETE FROM t WHERE id = 1;
DELETE FROM t WHERE id IN (1,2,3);
DELETE FROM t;                                                   -- all rows
DELETE a FROM a JOIN b ON a.id = b.id WHERE b.x = 1;             -- MySQL
DELETE FROM t ORDER BY id LIMIT 10;                              -- MySQL

-- MERGE (SS / ORA / PG 15+)
MERGE INTO target t USING source s ON t.id = s.id
WHEN MATCHED THEN UPDATE SET t.v = s.v
WHEN NOT MATCHED THEN INSERT (id, v) VALUES (s.id, s.v);
```

---

## 6. SELECT (DQL)

```sql
SELECT * FROM t;
SELECT a, b FROM t;
SELECT DISTINCT a FROM t;
SELECT a AS alias FROM t;
SELECT a, b FROM t WHERE cond;
SELECT a, COUNT(*) FROM t GROUP BY a HAVING COUNT(*) > 1;
SELECT * FROM t ORDER BY a ASC, b DESC;
SELECT * FROM t LIMIT 10;
SELECT * FROM t LIMIT 10 OFFSET 20;
SELECT * FROM t LIMIT 20, 10;                                    -- offset, count (MySQL)
SELECT TOP 10 * FROM t;                                          -- SS
SELECT * FROM t FETCH FIRST 10 ROWS ONLY;                        -- ORA / PG / SS
SELECT 1 + 1;
SELECT * FROM t FOR UPDATE;                                      -- lock rows
SELECT * FROM t LOCK IN SHARE MODE;                              -- shared lock (MySQL)
SELECT SQL_CALC_FOUND_ROWS * FROM t LIMIT 10;                    -- MySQL (deprecated)
SELECT COUNT(*) INTO @cnt FROM t;                                -- into variable
```

Full order:
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

## 7. Operators and Keywords

| Operator | Example |
|---|---|
| `=`, `<>`, `!=`, `>`, `<`, `>=`, `<=` | `WHERE age >= 18` |
| `<=>` | NULL-safe equal (MySQL) |
| `AND`, `OR`, `NOT` | `WHERE a = 1 AND (b = 2 OR c = 3)` |
| `BETWEEN x AND y` | `WHERE age BETWEEN 18 AND 30` (inclusive) |
| `NOT BETWEEN` | |
| `IN (...)` | `WHERE id IN (1,2,3)` |
| `NOT IN (...)` | |
| `LIKE` | `'A%'` starts, `'%a'` ends, `'%a%'` contains, `'_a%'` 2nd letter a |
| `NOT LIKE` | |
| `ILIKE` | Case-insensitive LIKE (PG) |
| `REGEXP` / `RLIKE` | `WHERE name REGEXP '^[AEIOU]'` (MySQL); `~` (PG) |
| `IS NULL` / `IS NOT NULL` | `WHERE email IS NULL` |
| `EXISTS` / `NOT EXISTS` | `WHERE EXISTS (SELECT 1 FROM ...)` |
| `ANY` / `SOME` / `ALL` | `WHERE sal > ALL (SELECT ...)` |
| `+ - * / %` | Arithmetic (`DIV`, `MOD`) |
| `& \| ^ ~ << >>` | Bitwise |
| `\|\|` | Concatenate (PG, ORA) |
| `+` | Concatenate (SS) |
| `AS` | Alias |
| `DISTINCT` | Unique values |
| `UNION`, `INTERSECT`, `EXCEPT` | Set operators |
| `COLLATE` | Specify collation |
| `ESCAPE` | `LIKE '50\%' ESCAPE '\'` |

---

## 8. Joins

```sql
SELECT * FROM a INNER JOIN b ON a.id = b.a_id;          -- matches only
SELECT * FROM a LEFT JOIN b ON a.id = b.a_id;           -- all left
SELECT * FROM a RIGHT JOIN b ON a.id = b.a_id;          -- all right
SELECT * FROM a FULL OUTER JOIN b ON a.id = b.a_id;     -- all both (not MySQL)
SELECT * FROM a CROSS JOIN b;                           -- cartesian
SELECT * FROM a NATURAL JOIN b;                         -- same-named columns
SELECT * FROM a JOIN b USING (id);                      -- shared column name
SELECT e.name, m.name FROM emp e JOIN emp m ON e.mgr = m.id;   -- self join
SELECT * FROM a LEFT JOIN b ON a.id = b.a_id WHERE b.a_id IS NULL;  -- anti join
SELECT * FROM a JOIN b ON a.x BETWEEN b.lo AND b.hi;    -- non-equi join
SELECT * FROM a JOIN b ON ... JOIN c ON ...;            -- multi-table
-- LATERAL (PG / MySQL 8.0.14+), CROSS APPLY / OUTER APPLY (SS)
-- FULL JOIN in MySQL:  LEFT JOIN ... UNION ... RIGHT JOIN ...
```

---

## 9. Set Operations

```sql
SELECT a FROM t1 UNION SELECT a FROM t2;        -- no duplicates
SELECT a FROM t1 UNION ALL SELECT a FROM t2;    -- keep duplicates
SELECT a FROM t1 INTERSECT SELECT a FROM t2;    -- common rows
SELECT a FROM t1 EXCEPT SELECT a FROM t2;       -- in t1 not t2 (ORA: MINUS)
```

---

## 10. Subqueries and CTE

```sql
-- Scalar
SELECT * FROM t WHERE x > (SELECT AVG(x) FROM t);
-- IN
SELECT * FROM t WHERE id IN (SELECT id FROM t2);
-- Derived table
SELECT * FROM (SELECT a, SUM(b) s FROM t GROUP BY a) x WHERE s > 10;
-- Correlated
SELECT * FROM t e WHERE x > (SELECT AVG(x) FROM t WHERE g = e.g);
-- EXISTS
SELECT * FROM a WHERE EXISTS (SELECT 1 FROM b WHERE b.id = a.id);
-- In SELECT list
SELECT name, (SELECT COUNT(*) FROM orders o WHERE o.cid = c.id) FROM customers c;

-- CTE
WITH cte AS (SELECT ...) SELECT * FROM cte;
WITH c1 AS (...), c2 AS (SELECT ... FROM c1) SELECT * FROM c2;

-- Recursive CTE
WITH RECURSIVE n AS (
  SELECT 1 AS x UNION ALL SELECT x + 1 FROM n WHERE x < 10
) SELECT * FROM n;
```

---

## 11. Aggregate Functions

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

---

## 12. String Functions

| Function | Purpose |
|---|---|
| `UPPER(s)`, `LOWER(s)` | Case |
| `LENGTH(s)`, `CHAR_LENGTH(s)` | Length (SS: `LEN`) |
| `CONCAT(a,b,...)`, `CONCAT_WS(sep,a,b)` | Join strings |
| `SUBSTRING(s,pos,len)`, `SUBSTR` | Substring |
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
| `FORMAT(n,d)` | Number format |
| `STRCMP(a,b)` | Compare |
| `FIELD(s,a,b,c)` | Index in list |
| `FIND_IN_SET(s,'a,b,c')` | Position in CSV |
| `SUBSTRING_INDEX(s,delim,n)` | Split by delimiter (MySQL) |
| `SPLIT_PART(s,delim,n)` | Split (PG) |
| `INITCAP(s)` | Capitalize words (PG/ORA) |
| `TRANSLATE(s,from,to)` | Replace char by char |
| `OVERLAY()`, `INSERT(s,pos,len,new)` | Insert/replace part |
| `SOUNDEX(s)` | Phonetic code |
| `REGEXP_REPLACE()`, `REGEXP_SUBSTR()`, `REGEXP_LIKE()`, `REGEXP_INSTR()` | Regex |
| `QUOTE(s)` | Escape string |
| `HEX(s)`, `UNHEX(s)` | Hex |
| `MD5(s)`, `SHA2(s,256)` | Hashing |
| `TO_BASE64(s)`, `FROM_BASE64(s)` | Base64 |

---

## 13. Numeric Functions

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

---

## 14. Date and Time Functions

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

---

## 15. Conditional and NULL Functions

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

---

## 16. Type Conversion

```sql
CAST(x AS CHAR)         CAST(x AS SIGNED)       CAST(x AS UNSIGNED)
CAST(x AS DECIMAL(10,2))   CAST(x AS DATE)      CAST(x AS DATETIME)
CONVERT(x, SIGNED)      CONVERT(x USING utf8mb4)
x::INT                  -- PG shorthand
TO_CHAR(x,'fmt')  TO_NUMBER(s)  TO_DATE(s,'fmt')   -- PG / ORA
TRY_CAST(x AS INT)  TRY_CONVERT(...)               -- SS (returns NULL on failure)
```

---

## 17. Window Functions

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

---

## 18. JSON Functions

```sql
JSON_EXTRACT(col, '$.name')        col->'$.name'        col->>'$.name'   -- MySQL
JSON_OBJECT('k', v)                JSON_ARRAY(1,2,3)
JSON_SET(col,'$.a',1)              JSON_INSERT()        JSON_REPLACE()   JSON_REMOVE(col,'$.a')
JSON_CONTAINS(col, '1', '$.arr')   JSON_LENGTH(col)     JSON_KEYS(col)
JSON_TABLE(...)                    JSON_VALID(col)      JSON_TYPE(col)
col->'name'   col->>'name'   col @> '{"a":1}'   jsonb_set(...)           -- PG
JSON_VALUE(col,'$.name')   OPENJSON(col)   FOR JSON PATH                  -- SS
```

---

## 19. Views

```sql
CREATE VIEW v AS SELECT ...;
CREATE OR REPLACE VIEW v AS SELECT ...;
CREATE VIEW v AS SELECT ... WITH CHECK OPTION;
ALTER VIEW v AS SELECT ...;
DROP VIEW v;
DROP VIEW IF EXISTS v;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW CREATE VIEW v;
CREATE MATERIALIZED VIEW mv AS SELECT ...;      -- PG / ORA
REFRESH MATERIALIZED VIEW mv;                   -- PG
```

---

## 20. Indexes

```sql
CREATE INDEX idx ON t (col);
CREATE INDEX idx ON t (c1, c2);                 -- composite
CREATE UNIQUE INDEX idx ON t (col);
CREATE FULLTEXT INDEX idx ON t (col);           -- MySQL
CREATE INDEX idx ON t (col DESC);
CREATE INDEX idx ON t (col) WHERE active = 1;   -- partial (PG / SS)
CREATE INDEX idx ON t (LOWER(col));             -- functional (PG / MySQL 8)
ALTER TABLE t ADD INDEX idx (col);
DROP INDEX idx ON t;                            -- MySQL / SS
DROP INDEX idx;                                 -- PG / ORA
SHOW INDEXES FROM t;                            -- MySQL
ALTER TABLE t DROP INDEX idx;
REINDEX INDEX idx;                              -- PG
ANALYZE TABLE t;   OPTIMIZE TABLE t;            -- MySQL
SELECT * FROM t USE INDEX (idx);   FORCE INDEX (idx);   IGNORE INDEX (idx);   -- hints
```

---

## 21. Transactions (TCL)

```sql
START TRANSACTION;   -- or BEGIN;  (SS: BEGIN TRAN)
COMMIT;
ROLLBACK;
SAVEPOINT sp1;
ROLLBACK TO SAVEPOINT sp1;
RELEASE SAVEPOINT sp1;
SET autocommit = 0;          -- off  (1 = on)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT ... FOR UPDATE;                 -- exclusive row lock
SELECT ... FOR SHARE;                  -- shared lock (PG / MySQL 8)
SELECT ... FOR UPDATE NOWAIT;          -- fail instead of wait
SELECT ... FOR UPDATE SKIP LOCKED;     -- skip locked rows
LOCK TABLES t READ | WRITE;   UNLOCK TABLES;    -- MySQL
LOCK TABLE t IN EXCLUSIVE MODE;                  -- PG / ORA
```

---

## 22. Users and Permissions (DCL)

```sql
CREATE USER 'u'@'localhost' IDENTIFIED BY 'pass';
ALTER USER 'u'@'localhost' IDENTIFIED BY 'newpass';
RENAME USER 'u'@'localhost' TO 'v'@'localhost';
DROP USER 'u'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON db.t TO 'u'@'localhost';
GRANT ALL PRIVILEGES ON db.* TO 'u'@'localhost';
GRANT SELECT ON *.* TO 'u'@'%' WITH GRANT OPTION;
GRANT SELECT (col1, col2) ON db.t TO 'u'@'localhost';     -- column-level
GRANT EXECUTE ON PROCEDURE db.p TO 'u'@'localhost';
REVOKE INSERT ON db.t FROM 'u'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'u'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'u'@'localhost';

CREATE ROLE r;   GRANT SELECT ON db.* TO r;   GRANT r TO 'u'@'localhost';
SET ROLE r;      DROP ROLE r;
DENY SELECT ON t TO u;                                    -- SS
```
Privileges: `SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, REFERENCES, EXECUTE, CREATE VIEW, SHOW VIEW, TRIGGER, CREATE ROUTINE, ALL PRIVILEGES, USAGE, GRANT OPTION`.

---

## 23. Stored Procedures and Functions

```sql
DELIMITER //
CREATE PROCEDURE p (IN a INT, OUT b INT, INOUT c INT)
BEGIN
    SELECT COUNT(*) INTO b FROM t WHERE x = a;
END //
DELIMITER ;

CALL p(1, @out, @inout);       -- SS: EXEC p ...
SHOW PROCEDURE STATUS WHERE Db = 'db';
SHOW CREATE PROCEDURE p;
DROP PROCEDURE IF EXISTS p;

DELIMITER //
CREATE FUNCTION f (x INT) RETURNS INT DETERMINISTIC
BEGIN
    RETURN x * 2;
END //
DELIMITER ;

SELECT f(5);
SHOW FUNCTION STATUS WHERE Db = 'db';
DROP FUNCTION IF EXISTS f;
```

---

## 24. Triggers, Events, Cursors

```sql
-- Trigger
CREATE TRIGGER trg BEFORE | AFTER INSERT | UPDATE | DELETE ON t
FOR EACH ROW
BEGIN
    -- NEW.col (insert/update), OLD.col (update/delete)
    SET NEW.updated_at = NOW();
END;
SHOW TRIGGERS;
DROP TRIGGER IF EXISTS trg;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error message';   -- raise error
-- PG: CREATE TRIGGER ... EXECUTE FUNCTION fn();   SS: INSTEAD OF triggers, inserted/deleted tables

-- Event (scheduler)
SET GLOBAL event_scheduler = ON;
CREATE EVENT e ON SCHEDULE EVERY 1 DAY STARTS NOW() DO DELETE FROM logs WHERE created < NOW() - INTERVAL 30 DAY;
ALTER EVENT e DISABLE;
SHOW EVENTS;
DROP EVENT e;

-- Cursor
DECLARE cur CURSOR FOR SELECT ...;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
OPEN cur;
FETCH cur INTO v1, v2;
CLOSE cur;
```

---

## 25. Control Flow

```sql
DECLARE x INT DEFAULT 0;
SET x = x + 1;

IF x > 5 THEN ... ELSEIF x = 5 THEN ... ELSE ... END IF;
CASE WHEN x = 1 THEN ... WHEN x = 2 THEN ... ELSE ... END CASE;
WHILE x < 10 DO ... END WHILE;
REPEAT ... UNTIL x > 10 END REPEAT;
lbl: LOOP ... IF x > 10 THEN LEAVE lbl; END IF; ITERATE lbl; END LOOP;

DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; END;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
RESIGNAL;   GET DIAGNOSTICS ...;

-- SS: BEGIN TRY ... END TRY BEGIN CATCH ... END CATCH;   RAISERROR / THROW
-- PG: EXCEPTION WHEN ... THEN ...;   RAISE NOTICE '...';
```

---

## 26. Variables and Prepared Statements

```sql
SET @v = 10;                      SELECT @v;               -- user variable
SELECT col INTO @v FROM t LIMIT 1;
SET GLOBAL max_connections = 500; SET SESSION sql_mode = 'STRICT_ALL_TABLES';
SHOW VARIABLES LIKE 'max%';       SHOW STATUS LIKE 'Threads%';
DECLARE @v INT = 5;                                       -- SS

PREPARE stmt FROM 'SELECT * FROM t WHERE id = ?';
SET @id = 1;
EXECUTE stmt USING @id;
DEALLOCATE PREPARE stmt;
-- SS: EXEC sp_executesql N'...', N'@id INT', @id = 1;
```

---

## 27. Temporary Tables and Sequences

```sql
CREATE TEMPORARY TABLE tmp (id INT);
CREATE TEMPORARY TABLE tmp AS SELECT ...;
DROP TEMPORARY TABLE tmp;
-- SS: #tmp (local), ##tmp (global)

CREATE SEQUENCE s START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 1000 CYCLE;   -- PG / ORA / SS / MariaDB
SELECT nextval('s');   SELECT currval('s');   SELECT setval('s', 100);           -- PG
SELECT s.NEXTVAL FROM DUAL;                                                      -- ORA
ALTER SEQUENCE s RESTART WITH 1;
DROP SEQUENCE s;
```

---

## 28. Admin and Info Commands

| Command | Purpose |
|---|---|
| `SHOW DATABASES;` | List databases |
| `SHOW TABLES;` | List tables |
| `SHOW FULL TABLES;` | Tables + type |
| `SHOW COLUMNS FROM t;` / `DESCRIBE t;` | Columns |
| `SHOW INDEXES FROM t;` | Indexes |
| `SHOW CREATE TABLE t;` | DDL |
| `SHOW TABLE STATUS;` | Table info |
| `SHOW PROCESSLIST;` | Running queries |
| `KILL id;` | Stop a query/connection |
| `SHOW VARIABLES;` | Config |
| `SHOW STATUS;` | Server status |
| `SHOW ENGINES;` | Storage engines |
| `SHOW GRANTS;` | Permissions |
| `SHOW WARNINGS;` / `SHOW ERRORS;` | Last warnings / errors |
| `SHOW CHARACTER SET;` / `SHOW COLLATION;` | Charsets |
| `SHOW MASTER STATUS;` / `SHOW REPLICA STATUS;` | Replication |
| `SELECT VERSION();` | Server version |
| `SELECT USER();` / `CURRENT_USER();` | Current user |
| `SELECT LAST_INSERT_ID();` | Last auto ID (SS: `SCOPE_IDENTITY()`) |
| `SELECT ROW_COUNT();` | Rows affected by last statement |
| `SELECT FOUND_ROWS();` | Rows before LIMIT |
| `SELECT UUID();` | Generate UUID |
| `SELECT CONNECTION_ID();` | Current connection id |
| `FLUSH TABLES;` / `FLUSH PRIVILEGES;` / `FLUSH LOGS;` | Flush |
| `RESET MASTER;` | Reset binlogs |
| `HELP 'topic';` | MySQL built-in help |
| `SOURCE file.sql;` | Run script (MySQL client) |
| `\i file.sql` / `\d t` / `\du` / `\q` | psql meta-commands |
| `EXIT;` / `QUIT;` | Leave client |

```sql
-- Metadata via information_schema
SELECT table_name FROM information_schema.tables WHERE table_schema = 'db';
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 't';
SELECT * FROM information_schema.table_constraints WHERE table_name = 't';
SELECT * FROM information_schema.key_column_usage WHERE table_name = 't';
```

---

## 29. Performance Commands

```sql
EXPLAIN SELECT ...;
EXPLAIN FORMAT=JSON SELECT ...;
EXPLAIN ANALYZE SELECT ...;          -- runs the query (MySQL 8.0.18+, PG)
ANALYZE TABLE t;                     -- refresh statistics
OPTIMIZE TABLE t;                    -- defragment
CHECK TABLE t;   REPAIR TABLE t;
SET profiling = 1;   SHOW PROFILES;
SET GLOBAL slow_query_log = 'ON';   SET GLOBAL long_query_time = 1;
VACUUM;   VACUUM ANALYZE t;   REINDEX TABLE t;                -- PG
UPDATE STATISTICS t;   SET STATISTICS IO ON;   SET SHOWPLAN_ALL ON;  -- SS
```
EXPLAIN `type` column (best → worst): `system, const, eq_ref, ref, range, index, ALL`.

---

## 30. Import, Export, Backup

```sql
LOAD DATA INFILE '/path/f.csv' INTO TABLE t FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE '/path/f.csv' INTO TABLE t ...;
SELECT * FROM t INTO OUTFILE '/path/out.csv' FIELDS TERMINATED BY ',';
COPY t FROM '/path/f.csv' CSV HEADER;            -- PG
COPY t TO '/path/out.csv' CSV HEADER;            -- PG
BULK INSERT t FROM 'f.csv' WITH (FIELDTERMINATOR = ',');   -- SS
```
```bash
mysqldump -u root -p db > backup.sql                 # backup database
mysqldump -u root -p db table > table.sql            # one table
mysqldump -u root -p --all-databases > all.sql       # everything
mysql -u root -p db < backup.sql                     # restore
mysql -u root -p -e "SELECT 1;"                      # run a command
pg_dump db > backup.sql      psql db < backup.sql    # PostgreSQL
pg_dumpall > all.sql
```

---

## 31. Partitioning

```sql
CREATE TABLE s (id INT, d DATE) PARTITION BY RANGE (YEAR(d)) (
    PARTITION p0 VALUES LESS THAN (2023),
    PARTITION p1 VALUES LESS THAN (2024),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);
PARTITION BY LIST (region_id) (PARTITION pa VALUES IN (1,2), PARTITION pb VALUES IN (3,4));
PARTITION BY HASH (id) PARTITIONS 4;
PARTITION BY KEY (id) PARTITIONS 4;

ALTER TABLE s ADD PARTITION (PARTITION p2 VALUES LESS THAN (2025));
ALTER TABLE s DROP PARTITION p0;
ALTER TABLE s TRUNCATE PARTITION p1;
ALTER TABLE s REORGANIZE PARTITION ...;
SELECT * FROM s PARTITION (p1);
```

---

## 32. Data Types

| Category | Types |
|---|---|
| Integer | `TINYINT, SMALLINT, MEDIUMINT, INT, BIGINT` (+ `UNSIGNED`) |
| Decimal | `DECIMAL(p,s), NUMERIC(p,s), FLOAT, DOUBLE, REAL` |
| Boolean | `BOOLEAN` (TINYINT(1)), `BIT` |
| String | `CHAR(n), VARCHAR(n), TINYTEXT, TEXT, MEDIUMTEXT, LONGTEXT` |
| Binary | `BINARY, VARBINARY, TINYBLOB, BLOB, MEDIUMBLOB, LONGBLOB` |
| Date/Time | `DATE, TIME, DATETIME, TIMESTAMP, YEAR` |
| Special | `ENUM('a','b'), SET('a','b'), JSON, GEOMETRY, POINT` |
| PG extras | `SERIAL, BIGSERIAL, UUID, ARRAY, JSONB, TEXT, BYTEA, INET, MONEY` |
| SS extras | `NVARCHAR, NCHAR, MONEY, UNIQUEIDENTIFIER, DATETIME2, BIT` |
| ORA extras | `NUMBER, VARCHAR2, NVARCHAR2, CLOB, BLOB, DATE, RAW` |

---

## 33. Dialect Differences

| Task | MySQL | PostgreSQL | SQL Server | Oracle |
|---|---|---|---|---|
| Limit rows | `LIMIT n` | `LIMIT n` | `TOP n` | `FETCH FIRST n ROWS ONLY` |
| Auto ID | `AUTO_INCREMENT` | `SERIAL` / `IDENTITY` | `IDENTITY(1,1)` | `IDENTITY` / sequence |
| Now | `NOW()` | `NOW()` | `GETDATE()` | `SYSDATE` |
| Concat | `CONCAT()` | `\|\|` | `+` | `\|\|` |
| NULL default | `IFNULL` | `COALESCE` | `ISNULL` | `NVL` |
| Length | `LENGTH` | `LENGTH` | `LEN` | `LENGTH` |
| Full outer join | ✗ | ✓ | ✓ | ✓ |
| Modify column | `MODIFY` | `ALTER COLUMN ... TYPE` | `ALTER COLUMN` | `MODIFY` |
| Show tables | `SHOW TABLES` | `\dt` | `sp_tables` | `SELECT * FROM user_tables` |
| Describe | `DESCRIBE t` | `\d t` | `sp_help t` | `DESC t` |
| Quote names | `` `x` `` | `"x"` | `[x]` | `"x"` |
| Upsert | `ON DUPLICATE KEY UPDATE` | `ON CONFLICT` | `MERGE` | `MERGE` |
| Group concat | `GROUP_CONCAT` | `STRING_AGG` | `STRING_AGG` | `LISTAGG` |
| Set difference | `EXCEPT` | `EXCEPT` | `EXCEPT` | `MINUS` |
| Dummy table | not needed | not needed | not needed | `FROM DUAL` |
| Run proc | `CALL p()` | `CALL p()` | `EXEC p` | `EXEC p` |

---

## 34. Order of Execution and Command Types

**Execution order:** `FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT`

| Category | Commands |
|---|---|
| **DDL** (structure) | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME`, `COMMENT` |
| **DML** (data) | `INSERT`, `UPDATE`, `DELETE`, `MERGE`, `REPLACE`, `CALL` |
| **DQL** (query) | `SELECT` |
| **DCL** (access) | `GRANT`, `REVOKE`, `DENY` (SS) |
| **TCL** (transaction) | `COMMIT`, `ROLLBACK`, `SAVEPOINT`, `SET TRANSACTION`, `START TRANSACTION` |

**Quick memory:**
- `DROP` = remove structure · `TRUNCATE` = remove all rows fast · `DELETE` = remove chosen rows
- `WHERE` = filter rows · `HAVING` = filter groups
- `UNION` = no duplicates · `UNION ALL` = with duplicates
- `RANK` = gaps · `DENSE_RANK` = no gaps · `ROW_NUMBER` = unique
- `INNER` = matches · `LEFT` = all left · `RIGHT` = all right · `FULL` = all · `CROSS` = every combination

---

⭐ Star the repo if this helped!
