<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>SQL Command Cheat Sheet</title>
<style>
:root{--bg:#f6f8fc;--card:#fff;--text:#1b2433;--mute:#5d6b82;--line:#e3e8f0;--acc:#2563eb;--code:#0f172a;--codet:#e2e8f0;--chip:#e8eefc;box-sizing:border-box;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#0d1117;--card:#161b22;--text:#e6edf3;--mute:#8b98a9;--line:#262d38;--acc:#58a6ff;--code:#010409;--codet:#d5dde8;--chip:#1c2740}}
:root[data-theme="dark"]{--bg:#0d1117;--card:#161b22;--text:#e6edf3;--mute:#8b98a9;--line:#262d38;--acc:#58a6ff;--code:#010409;--codet:#d5dde8;--chip:#1c2740}
*{box-sizing:border-box}
html{scroll-behavior:smooth;scroll-padding-top:90px}
body{margin:0;background:var(--bg);color:var(--text);font:16px/1.55 system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
header{text-align:center;padding:36px 16px 20px}
h1{margin:0 0 6px;font-size:clamp(1.6rem,5vw,2.4rem)}
header p{margin:0;color:var(--mute)}
.bar{position:sticky;top:0;z-index:5;background:var(--bg);padding:10px 16px;border-bottom:1px solid var(--line);display:flex;gap:8px;max-width:1000px;margin:0 auto}
.bar input{flex:1;padding:11px 14px;border-radius:10px;border:1px solid var(--line);background:var(--card);color:var(--text);font:inherit}
.bar button{padding:0 14px;border-radius:10px;border:1px solid var(--line);background:var(--card);color:var(--text);cursor:pointer;font-size:1.1rem}
nav{display:flex;flex-wrap:wrap;gap:8px;justify-content:center;max-width:1000px;margin:16px auto 0;padding:0 16px}
nav a{background:var(--chip);color:var(--acc);text-decoration:none;padding:5px 12px;border-radius:99px;font-size:.85rem;font-weight:600}
main{max-width:1000px;margin:0 auto;padding:16px}
section{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:18px;margin:0 0 18px}
h2{margin:0 0 12px;font-size:1.25rem}
h2 small{color:var(--mute);font-weight:500;font-size:.8rem}
.row{display:flex;gap:12px;align-items:flex-start;padding:8px 0;border-top:1px solid var(--line)}
.row:first-of-type{border-top:0}
.row code{flex:1 1 55%;min-width:0;word-break:break-word}
.row span{flex:1 1 45%;color:var(--mute);font-size:.92rem}
code,pre{font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:.84rem}
code{background:var(--chip);padding:2px 6px;border-radius:6px}
.codebox{position:relative;margin-top:12px}
pre{margin:0;background:var(--code);color:var(--codet);padding:14px;border-radius:10px;overflow-x:auto}
.copy{position:absolute;top:8px;right:8px;background:#2b3a55;color:#fff;border:0;border-radius:8px;padding:4px 10px;font-size:.75rem;cursor:pointer}
.empty{text-align:center;color:var(--mute);padding:40px 0;display:none}
footer{text-align:center;color:var(--mute);padding:10px 16px 40px;font-size:.9rem}
@media (max-width:560px){.row{flex-direction:column;gap:2px}}
</style>
</head>
<body>
<header>
  <h1>⚡ SQL Command Cheat Sheet</h1>
  <p>Searchable and copy-ready. Default syntax is MySQL 8.0+. Tags: (PG) PostgreSQL, (SS) SQL Server, (ORA) Oracle.</p>
</header>
<div class="bar">
  <input id="q" type="search" placeholder="Search commands, e.g. JOIN, DATE, index…" autocomplete="off">
  <button id="theme" title="Toggle theme" aria-label="Toggle theme">🌓</button>
</div>
<nav id="nav"></nav>
<main id="main"></main>
<p class="empty" id="empty">No matching commands found.</p>
<footer>Run the sample database first, then every “Try it” block works as written.</footer>

<script>
var SETUP = `DROP DATABASE IF EXISTS sql_cheatsheet;
CREATE DATABASE sql_cheatsheet CHARACTER SET utf8mb4;
USE sql_cheatsheet;

CREATE TABLE departments (
  dept_id INT PRIMARY KEY AUTO_INCREMENT,
  dept_name VARCHAR(50) NOT NULL UNIQUE,
  location VARCHAR(50)
);
CREATE TABLE employees (
  emp_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  salary DECIMAL(10,2) DEFAULT 30000,
  age INT, dept_id INT, manager_id INT, hire_date DATE,
  CONSTRAINT ck_age CHECK (age >= 18),
  CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_mgr FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);
CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  order_date DATE NOT NULL,
  FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO departments (dept_name, location) VALUES
 ('IT','Bengaluru'),('HR','Delhi'),('Sales','Mumbai'),('Finance','Pune');
INSERT INTO employees (name,email,salary,age,dept_id,manager_id,hire_date) VALUES
 ('Asha Rao','asha@corp.com',95000,42,1,NULL,'2015-03-01'),
 ('Ravi Kumar','ravi@corp.com',72000,35,1,1,'2018-07-15'),
 ('Meera Nair','meera@corp.com',68000,29,1,1,'2020-01-10'),
 ('Karan Shah','karan@corp.com',55000,31,2,1,'2019-09-23'),
 ('Priya Singh','priya@corp.com',60000,27,3,1,'2021-05-17'),
 ('Arjun Mehta','arjun@corp.com',58000,33,3,5,'2017-11-02'),
 ('Neha Gupta','neha@corp.com',52000,26,3,5,'2022-02-28'),
 ('Vikram Das',NULL,45000,24,NULL,4,'2023-06-12');
INSERT INTO orders (emp_id,amount,order_date) VALUES
 (5,1200.50,'2024-01-15'),(5,800,'2024-02-20'),(6,2500,'2024-01-30'),
 (6,300.75,'2024-03-05'),(7,150,'2024-03-18'),(3,999.99,'2024-02-02');`;

var S = [
["Sample Database","🚀",[["Finance has no staff","Deliberate: shows LEFT / RIGHT join differences"],["Vikram Das has no department","Deliberate: shows NULL handling"]],SETUP],
["Database","🗄️",[["CREATE DATABASE db;","Create database"],["CREATE DATABASE IF NOT EXISTS db;","Create only if missing"],["SHOW DATABASES;","List databases (PG: \\l)"],["USE db;","Select database (PG: \\c db)"],["SELECT DATABASE();","Current database"],["DROP DATABASE IF EXISTS db;","Delete if it exists"]]],
["Tables (DDL)","🧱",[["CREATE TABLE t (id INT PRIMARY KEY, name VARCHAR(50));","Create table"],["CREATE TABLE t2 AS SELECT * FROM t;","Copy structure + data"],["CREATE TABLE t2 LIKE t;","Copy structure (MySQL)"],["SHOW TABLES;","List tables (PG: \\dt)"],["DESCRIBE t;","Show columns"],["SHOW CREATE TABLE t;","Show full DDL"],["RENAME TABLE old TO new;","Rename (MySQL)"],["TRUNCATE TABLE t;","Delete all rows, reset identity"],["DROP TABLE IF EXISTS t;","Delete table"]]],
["ALTER TABLE","🔧",[["ALTER TABLE t ADD col INT AFTER other;","Add column (MySQL)"],["ALTER TABLE t DROP COLUMN col;","Drop column"],["ALTER TABLE t MODIFY col BIGINT;","Change type (MySQL, ORA)"],["ALTER TABLE t ALTER COLUMN col TYPE BIGINT;","Change type (PG)"],["ALTER TABLE t RENAME COLUMN old TO new;","Rename column"],["ALTER TABLE t RENAME TO new_t;","Rename table"],["ALTER TABLE t ALTER COLUMN col SET DEFAULT 0;","Set default"],["ALTER TABLE t AUTO_INCREMENT = 100;","Next auto-increment value"]],
`ALTER TABLE employees ADD bonus DECIMAL(8,2) DEFAULT 0 AFTER salary;
ALTER TABLE employees RENAME COLUMN bonus TO annual_bonus;
ALTER TABLE employees DROP COLUMN annual_bonus;`],
["Constraints","🔒",[["col INT NOT NULL","Value required"],["col INT UNIQUE","No duplicates"],["PRIMARY KEY (c1, c2)","Composite primary key"],["FOREIGN KEY (c) REFERENCES p(id)","Link to parent table"],["CHECK (age >= 18)","Validate values (MySQL 8.0.16+)"],["ON DELETE CASCADE / SET NULL / RESTRICT","Referential action"],["ALTER TABLE t DROP FOREIGN KEY fk;","Drop FK (MySQL)"],["ALTER TABLE t DROP CONSTRAINT name;","Drop constraint (PG / SS / ORA)"],["SET FOREIGN_KEY_CHECKS = 0;","Disable FK checks (MySQL)"]]],
["INSERT / UPDATE / DELETE","✏️",[["INSERT INTO t (a,b) VALUES (1,'x'),(2,'y');","Insert multiple rows"],["INSERT INTO t2 SELECT * FROM t;","Insert from query"],["INSERT IGNORE INTO t ...;","Skip duplicate errors (MySQL)"],["... ON DUPLICATE KEY UPDATE a = 1;","Upsert (MySQL)"],["... ON CONFLICT (id) DO UPDATE SET ...;","Upsert (PG)"],["UPDATE t SET a = 1 WHERE id = 5;","Update rows"],["UPDATE a JOIN b ON a.id=b.id SET a.x=b.x;","Update with join (MySQL)"],["DELETE FROM t WHERE id = 5;","Delete rows"],["MERGE INTO t USING s ON ...;","Upsert (SS / ORA / PG 15+)"]],
`UPDATE employees SET salary = salary * 1.10 WHERE dept_id = 1;
UPDATE employees SET salary = CASE WHEN salary < 50000 THEN salary * 1.2 ELSE salary END;`],
["SELECT","🔍",[["SELECT DISTINCT col FROM t;","Unique values"],["SELECT a AS alias FROM t;","Alias"],["... ORDER BY a ASC, b DESC;","Sort"],["... LIMIT 10 OFFSET 20;","Paginate (MySQL, PG)"],["SELECT TOP 10 * FROM t;","Limit (SS)"],["... FETCH FIRST 10 ROWS ONLY;","Limit (ORA / PG / SS)"],["... FOR UPDATE;","Lock rows in a transaction"],["... GROUP BY a HAVING COUNT(*) > 1;","Group, then filter groups"]],
`SELECT dept_id, COUNT(*) AS headcount
FROM employees GROUP BY dept_id HAVING COUNT(*) > 1;`],
["Operators","🧮",[["= <> != > < >= <=","Comparison"],["a <=> b","NULL-safe equal (MySQL)"],["BETWEEN x AND y","Inclusive range"],["IN (1,2,3) / NOT IN (...)","List match (NOT IN breaks on NULLs)"],["LIKE 'A%'  '%a'  '%a%'  '_a%'","Starts, ends, contains, 2nd letter"],["REGEXP '^[AEIOU]'","Regex (PG: ~)"],["IS NULL / IS NOT NULL","NULL test"],["EXISTS (SELECT 1 ...)","Row exists"],["> ALL (...) / > ANY (...)","Compare with a set"]]],
["Joins","🔗",[["INNER JOIN","Matches in both tables"],["LEFT JOIN","All left rows + matches"],["RIGHT JOIN","All right rows + matches"],["FULL OUTER JOIN","All rows (not MySQL: use LEFT UNION RIGHT)"],["CROSS JOIN","Every combination"],["JOIN b USING (id)","Shared column name"],["LEFT JOIN b ... WHERE b.id IS NULL","Anti join"]],
`-- employee and manager (self join)
SELECT e.name AS employee, m.name AS manager
FROM employees e LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- departments with no employees
SELECT d.dept_name FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;`],
["Set Operations","🧩",[["UNION","Combine, remove duplicates"],["UNION ALL","Combine, keep duplicates"],["INTERSECT","Common rows (MySQL 8.0.31+)"],["EXCEPT","In left only (ORA: MINUS)"]]],
["Subqueries and CTE","🪆",[["WHERE x > (SELECT AVG(x) FROM t)","Scalar subquery"],["WHERE id IN (SELECT id FROM t2)","IN subquery"],["FROM (SELECT ...) AS x","Derived table"],["WITH c AS (SELECT ...) SELECT * FROM c;","CTE"],["WITH RECURSIVE n AS (...)","Recursive CTE"]],
`SELECT name, salary FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id);

WITH RECURSIVE chain AS (
  SELECT emp_id, name, manager_id, 1 AS level FROM employees WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.name, e.manager_id, c.level + 1
  FROM employees e JOIN chain c ON e.manager_id = c.emp_id
)
SELECT * FROM chain ORDER BY level;`],
["Aggregates","📊",[["COUNT(*) / COUNT(col)","All rows / non-NULL values"],["COUNT(DISTINCT col)","Unique non-NULL"],["SUM / AVG / MIN / MAX","Basic statistics"],["GROUP_CONCAT(col SEPARATOR ',')","Join values (MySQL)"],["STRING_AGG(col, ',')","Join values (PG, SS)"],["GROUP BY a WITH ROLLUP","Subtotals (MySQL)"]]],
["String Functions","🔤",[["UPPER(s) / LOWER(s)","Case"],["LENGTH(s) / CHAR_LENGTH(s)","Bytes / characters"],["CONCAT(a,b) / CONCAT_WS(sep,a,b)","Join strings"],["SUBSTRING(s,pos,len) / LEFT / RIGHT","Slice"],["TRIM / LTRIM / RTRIM","Remove spaces"],["REPLACE(s,from,to)","Replace text"],["INSTR(s,sub) / LOCATE(sub,s)","Find position"],["LPAD(s,n,p) / RPAD(s,n,p)","Pad"],["SUBSTRING_INDEX(s,'@',1)","Split by delimiter (MySQL)"],["REGEXP_REPLACE(s,pat,rep)","Regex replace (MySQL 8+)"]]],
["Numeric Functions","🔢",[["ROUND(n,d) / CEIL(n) / FLOOR(n)","Rounding"],["TRUNCATE(n,d)","Cut decimals (PG/ORA: TRUNC)"],["ABS(n) / SIGN(n)","Absolute / sign"],["MOD(a,b) / a % b / a DIV b","Remainder / integer division"],["POWER(a,b) / SQRT(n)","Power / root"],["RAND()","Random 0 to 1 (PG: RANDOM())"],["GREATEST(a,b,..) / LEAST(a,b,..)","Max / min of values"]]],
["Date and Time","📅",[["NOW() / CURDATE() / CURTIME()","Current datetime / date / time"],["YEAR(x) MONTH(x) DAY(x)","Date parts"],["DAYNAME(x) / MONTHNAME(x)","Names"],["DATE_ADD(x, INTERVAL 7 DAY)","Add interval"],["DATEDIFF(d1,d2)","Days between"],["TIMESTAMPDIFF(YEAR,d1,d2)","Difference in a unit"],["DATE_FORMAT(x,'%d %b %Y')","Format (PG: TO_CHAR)"],["STR_TO_DATE(s,'%d-%m-%Y')","Parse text"],["LAST_DAY(x)","Last day of month"]],
`SELECT name, TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service FROM employees;
SELECT DATE_FORMAT('2024-03-05','%d %b %Y, %W');`],
["Conditional and NULL","🔀",[["CASE WHEN c THEN a ELSE b END","If / else (standard)"],["IF(cond, yes, no)","Inline if (MySQL)"],["IFNULL(a,b)","b if a is NULL (MySQL)"],["COALESCE(a,b,c)","First non-NULL (standard)"],["NULLIF(a,b)","NULL if a = b (avoids divide by zero)"]],
`SELECT name, salary,
  CASE WHEN salary >= 70000 THEN 'High'
       WHEN salary >= 55000 THEN 'Medium'
       ELSE 'Low' END AS band
FROM employees;`],
["Window Functions","🪟",[["ROW_NUMBER()","Unique row number"],["RANK() / DENSE_RANK()","Rank with / without gaps"],["NTILE(n)","Split into n buckets"],["LAG(col) / LEAD(col)","Previous / next row"],["FIRST_VALUE / LAST_VALUE","First / last in window"],["SUM(x) OVER (ORDER BY d)","Running total"]],
`SELECT name, dept_id, salary,
  RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
FROM employees;

SELECT order_id, amount,
  SUM(amount) OVER (ORDER BY order_date, order_id) AS running_total
FROM orders;`],
["Views and Indexes","👁️",[["CREATE VIEW v AS SELECT ...;","Create view"],["CREATE OR REPLACE VIEW v AS ...;","Replace view"],["DROP VIEW IF EXISTS v;","Delete view"],["CREATE INDEX idx ON t (col);","Create index"],["CREATE INDEX idx ON t (c1, c2);","Composite index"],["CREATE UNIQUE INDEX idx ON t (col);","Unique index"],["SHOW INDEX FROM t;","List indexes"],["DROP INDEX idx ON t;","Delete index (MySQL / SS)"]]],
["Transactions","🔁",[["START TRANSACTION;","Begin"],["COMMIT;","Save changes"],["ROLLBACK;","Undo changes"],["SAVEPOINT sp1;","Set a savepoint"],["ROLLBACK TO SAVEPOINT sp1;","Undo to savepoint"],["SET autocommit = 0;","Manual commit mode"]],
`START TRANSACTION;
UPDATE employees SET salary = salary - 1000 WHERE emp_id = 2;
UPDATE employees SET salary = salary + 1000 WHERE emp_id = 3;
COMMIT;`],
["Users and Permissions","🛡️",[["CREATE USER 'u'@'localhost' IDENTIFIED BY 'pw';","Create user"],["GRANT SELECT ON db.* TO 'u'@'localhost';","Give access"],["REVOKE SELECT ON db.* FROM 'u'@'localhost';","Remove access"],["SHOW GRANTS FOR 'u'@'localhost';","View permissions"],["DROP USER 'u'@'localhost';","Delete user"]]],
["Procedures, Functions, Triggers","🧠",[["DELIMITER //","Client command: set body delimiter (CLI / Workbench)"],["CALL proc(args);","Run a procedure"],["SHOW TRIGGERS;","List triggers"],["DROP PROCEDURE IF EXISTS p;","Delete procedure"]],
`DELIMITER //
CREATE PROCEDURE raise_salary(IN p_dept INT, IN p_pct DECIMAL(5,2))
BEGIN
  UPDATE employees SET salary = salary * (1 + p_pct / 100) WHERE dept_id = p_dept;
  SELECT ROW_COUNT() AS rows_updated;
END //
DELIMITER ;

CALL raise_salary(1, 5);`],
["JSON Functions","🧾",[["col->'$.name' / col->>'$.name'","Extract (quoted / unquoted), MySQL"],["JSON_EXTRACT(col,'$.name')","Extract value"],["JSON_OBJECT('k',v) / JSON_ARRAY(1,2)","Build JSON"],["JSON_SET / JSON_INSERT / JSON_REPLACE","Modify JSON"],["JSON_REMOVE(col,'$.a')","Remove key"],["JSON_CONTAINS(col,'1','$.arr')","Contains value"],["JSON_LENGTH / JSON_KEYS / JSON_VALID","Inspect"],["JSON_TABLE(...)","JSON to rows"],["col @> '{\"a\":1}'  jsonb_set(...)","PG"],["JSON_VALUE(col,'$.n')  OPENJSON(col)","SS"]]],
["Triggers, Events, Cursors","⏰",[["CREATE TRIGGER t AFTER UPDATE ON tbl FOR EACH ROW ...","BEFORE / AFTER + INSERT / UPDATE / DELETE"],["OLD.col / NEW.col","Row before / after change"],["CREATE EVENT e ON SCHEDULE EVERY 1 DAY DO ...;","Scheduled job"],["SET GLOBAL event_scheduler = ON;","Enable scheduler"],["DECLARE cur CURSOR FOR SELECT ...;","Row-by-row processing"],["OPEN cur; FETCH cur INTO v; CLOSE cur;","Use cursor"]],
`CREATE TABLE salary_log (log_id INT PRIMARY KEY AUTO_INCREMENT, emp_id INT,
  old_salary DECIMAL(10,2), new_salary DECIMAL(10,2), changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

DELIMITER //
CREATE TRIGGER trg_salary_audit AFTER UPDATE ON employees FOR EACH ROW
BEGIN
  IF OLD.salary <> NEW.salary THEN
    INSERT INTO salary_log (emp_id, old_salary, new_salary)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary);
  END IF;
END //
DELIMITER ;

UPDATE employees SET salary = salary + 500 WHERE emp_id = 2;
SELECT * FROM salary_log;`],
["Control Flow","🚦",[["IF c THEN ... ELSEIF ... ELSE ... END IF;","Branching"],["CASE WHEN ... THEN ... END CASE;","Case statement"],["WHILE c DO ... END WHILE;","While loop"],["REPEAT ... UNTIL c END REPEAT;","Repeat loop"],["lbl: LOOP ... LEAVE lbl; ITERATE lbl; END LOOP;","Loop, break, continue"],["DECLARE EXIT HANDLER FOR SQLEXCEPTION ...","Error handling"],["SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='msg';","Raise an error"]]],
["Variables and Prepared Statements","📦",[["SET @v = 5; SELECT @v;","User variable"],["SELECT COUNT(*) INTO @n FROM t;","Query into variable"],["SHOW VARIABLES LIKE 'max_conn%';","System variables"],["SELECT @@version, @@sql_mode;","Read system variable"],["DECLARE v INT DEFAULT 0;","Local variable (routines only)"],["PREPARE s FROM 'SELECT ... WHERE id = ?';","Prepare"],["EXECUTE s USING @id; DEALLOCATE PREPARE s;","Run and free"]],
`PREPARE stmt FROM 'SELECT name, salary FROM employees WHERE dept_id = ? AND salary > ?';
SET @d = 1, @s = 60000;
EXECUTE stmt USING @d, @s;
DEALLOCATE PREPARE stmt;`],
["Temp Tables and Sequences","🧪",[["CREATE TEMPORARY TABLE tmp AS SELECT ...;","Session-only table"],["DROP TEMPORARY TABLE tmp;","Delete temp table"],["SELECT LAST_INSERT_ID();","Last auto-increment value"],["CREATE SEQUENCE s START WITH 1 INCREMENT BY 1;","Sequence (PG / ORA / SS)"],["NEXTVAL('s')  s.NEXTVAL  NEXT VALUE FOR s","PG  ORA  SS"],["CREATE TABLE #tmp (...)  CREATE TEMP TABLE tmp (...)","SS  PG"]]],
["Admin and Info","🛠️",[["SHOW TABLE STATUS LIKE 't';","Rows, size, engine"],["SHOW PROCESSLIST; KILL 123;","Running queries, stop one"],["SHOW STATUS; SHOW ENGINES;","Server counters, engines"],["SHOW WARNINGS; SHOW ERRORS;","Last statement problems"],["SELECT VERSION(), USER(), CONNECTION_ID();","Server info"],["SELECT ROW_COUNT();","Rows affected by last statement"],["SELECT * FROM information_schema.tables;","Catalog (also .columns, .table_constraints)"],["SQL Server: sp_help 't'  Oracle: user_tables","Other dialects"]]],
["Import, Export, Backup","💾",[["SELECT ... INTO OUTFILE '/path/f.csv' ...;","Export CSV (needs secure_file_priv path)"],["LOAD DATA INFILE '/path/f.csv' INTO TABLE t ... IGNORE 1 LINES;","Import CSV"],["SHOW VARIABLES LIKE 'secure_file_priv';","Allowed file folder"],["mysqldump -u root -p db > backup.sql","Backup (terminal)"],["mysqldump --no-data db > schema.sql","Schema only"],["mysqldump --routines --triggers --events db","Include routines, triggers, events"],["mysql -u root -p db < backup.sql","Restore (terminal)"],["pg_dump db > f.sql  psql db < f.sql","PostgreSQL"]]],
["Partitioning","🧱",[["PARTITION BY RANGE (YEAR(d)) (...)","Split by ranges"],["PARTITION BY LIST (col) (...)","Split by value lists"],["PARTITION BY HASH (col) PARTITIONS 4","Even spread"],["SELECT * FROM t PARTITION (p1);","Query one partition"],["ALTER TABLE t DROP PARTITION p1;","Delete partition data fast"]],
`CREATE TABLE sales (
  sale_id INT NOT NULL AUTO_INCREMENT,
  sale_date DATE NOT NULL,
  amount DECIMAL(10,2),
  PRIMARY KEY (sale_id, sale_date)
)
PARTITION BY RANGE (YEAR(sale_date)) (
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION pmax  VALUES LESS THAN MAXVALUE
);`],
["Data Types","🏷️",[["TINYINT SMALLINT MEDIUMINT INT BIGINT","Integers (1, 2, 3, 4, 8 bytes), add UNSIGNED"],["DECIMAL(p,s)","Exact numbers, use for money"],["FLOAT DOUBLE","Approximate numbers"],["BOOLEAN","Alias of TINYINT(1) (SS: BIT)"],["CHAR(n) VARCHAR(n) TEXT LONGTEXT","Text"],["BINARY VARBINARY BLOB","Binary data"],["DATE TIME DATETIME TIMESTAMP YEAR","Date and time"],["ENUM('a','b') SET('x','y')","Fixed choices"],["JSON  BIT(n)  POINT  GEOMETRY","Other types"]]],
["Dialect Differences","🌐",[["Limit: LIMIT n | TOP n | FETCH FIRST n ROWS","MySQL/PG | SS | ORA"],["Concat: CONCAT() | || | +","MySQL | PG, ORA | SS"],["Now: NOW() | GETDATE() | SYSDATE","MySQL, PG | SS | ORA"],["NULL default: IFNULL | COALESCE | ISNULL | NVL","MySQL | PG | SS | ORA"],["Auto id: AUTO_INCREMENT | SERIAL | IDENTITY","MySQL | PG | SS, ORA"],["Upsert: ON DUPLICATE KEY | ON CONFLICT | MERGE","MySQL | PG | SS, ORA"],["Group concat: GROUP_CONCAT | STRING_AGG | LISTAGG","MySQL | PG, SS | ORA"],["Except: EXCEPT | MINUS","MySQL, PG, SS | ORA"],["Date format: DATE_FORMAT | TO_CHAR | FORMAT","MySQL | PG, ORA | SS"],["Quote names: `x` | \"x\" | [x]","MySQL | PG, ORA | SS"],["Return inserted row: RETURNING | OUTPUT","PG, ORA | SS"]]],
["Performance","🏎️",[["EXPLAIN SELECT ...;","Show query plan"],["EXPLAIN ANALYZE SELECT ...;","Run and time it (MySQL 8.0.18+)"],["ANALYZE TABLE t;","Refresh index statistics"],["OPTIMIZE TABLE t;","Defragment table"],["SHOW PROCESSLIST;","Running queries"]]],
["JSON Functions","🧾",[["JSON_EXTRACT(col,'$.name')","Read a value (also col->'$.name')"],["col->>'$.name'","Read as unquoted text"],["JSON_OBJECT('k',v) / JSON_ARRAY(1,2)","Build JSON"],["JSON_SET / JSON_INSERT / JSON_REPLACE","Change values"],["JSON_REMOVE(col,'$.a')","Remove a key"],["JSON_CONTAINS(col,'1','$.arr')","Search inside"],["JSON_LENGTH / JSON_KEYS / JSON_VALID","Inspect"],["JSON_TABLE(...)","JSON to rows"],["col @> '{\"a\":1}'","Contains (PG)"],["JSON_VALUE(col,'$.a') / OPENJSON","SQL Server"]],
`CREATE TABLE products (id INT PRIMARY KEY AUTO_INCREMENT, info JSON);
INSERT INTO products (info) VALUES ('{"name":"Laptop","price":55000,"tags":["tech"]}');
SELECT info->>'$.name' AS name FROM products;
UPDATE products SET info = JSON_SET(info, '$.price', 50000);
DROP TABLE products;`],
["Triggers, Events, Cursors, Flow","⏰",[["CREATE TRIGGER t BEFORE|AFTER INSERT|UPDATE|DELETE ON tbl FOR EACH ROW ...","Trigger (OLD = before row, NEW = after row)"],["CREATE EVENT e ON SCHEDULE EVERY 1 DAY DO ...;","Scheduled job (SET GLOBAL event_scheduler = ON)"],["DECLARE cur CURSOR FOR SELECT ...; OPEN / FETCH / CLOSE","Row-by-row loop"],["DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;","End of cursor"],["IF c THEN ... ELSEIF ... ELSE ... END IF;","Branching"],["CASE WHEN c THEN ... END CASE;","Branching"],["WHILE c DO ... END WHILE; / REPEAT ... UNTIL c END REPEAT;","Loops"],["lbl: LOOP ... LEAVE lbl; ITERATE lbl; END LOOP;","Loop with exit / skip"],["DECLARE EXIT HANDLER FOR SQLEXCEPTION ...","Error handling"],["SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'msg';","Raise an error"]],
`CREATE TABLE salary_log (
  log_id INT PRIMARY KEY AUTO_INCREMENT, emp_id INT,
  old_salary DECIMAL(10,2), new_salary DECIMAL(10,2),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //
CREATE TRIGGER trg_salary_audit AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  IF OLD.salary <> NEW.salary THEN
    INSERT INTO salary_log (emp_id, old_salary, new_salary)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary);
  END IF;
END //
DELIMITER ;
UPDATE employees SET salary = salary + 500 WHERE emp_id = 2;
SELECT * FROM salary_log;`],
["Variables and Prepared Statements","📦",[["SET @v = 10; SELECT @v;","User variable (per session)"],["SELECT COUNT(*) INTO @n FROM t;","Query result into variable"],["DECLARE v INT DEFAULT 0;","Local variable (inside routines)"],["SHOW VARIABLES LIKE 'x%';","System variables"],["SET GLOBAL name = value;","Server setting (needs privilege)"],["PREPARE s FROM 'SELECT * FROM t WHERE id = ?';","Prepare statement"],["EXECUTE s USING @id;","Run it"],["DEALLOCATE PREPARE s;","Free it"]],
`PREPARE stmt FROM 'SELECT name, salary FROM employees WHERE dept_id = ? AND salary > ?';
SET @d = 1, @s = 60000;
EXECUTE stmt USING @d, @s;
DEALLOCATE PREPARE stmt;`],
["Temp Tables and Sequences","🧪",[["CREATE TEMPORARY TABLE tmp AS SELECT ...;","Session-only table (SS: #tmp, PG: TEMP)"],["DROP TEMPORARY TABLE tmp;","Delete it"],["SELECT LAST_INSERT_ID();","Last auto-increment value"],["CREATE SEQUENCE s START WITH 1 INCREMENT BY 1;","Sequence (PG / ORA / SS, not MySQL)"],["NEXTVAL('s') / s.NEXTVAL / NEXT VALUE FOR s","Next value (PG / ORA / SS)"]]],
["Admin and Info","🛠️",[["SHOW TABLES LIKE 'emp%';","Filter tables"],["SHOW FULL COLUMNS FROM t;","Columns with details"],["SHOW TABLE STATUS LIKE 't';","Rows, size, engine"],["SHOW PROCESSLIST; KILL id;","See / stop connections"],["SHOW STATUS; SHOW ENGINES;","Server info"],["SHOW WARNINGS; SHOW ERRORS;","Last statement problems"],["SELECT VERSION(), USER(), CONNECTION_ID();","Environment"],["SELECT ROW_COUNT();","Rows affected by last statement"],["information_schema.tables / .columns","Query the catalog"]],
`SELECT table_name, table_rows FROM information_schema.tables
WHERE table_schema = 'sql_cheatsheet';`],
["Import, Export, Backup","💾",[["SELECT ... INTO OUTFILE '/path/f.csv' FIELDS TERMINATED BY ',';","Export CSV (needs FILE privilege)"],["LOAD DATA INFILE '/path/f.csv' INTO TABLE t IGNORE 1 LINES;","Import CSV (target table must exist)"],["SHOW VARIABLES LIKE 'secure_file_priv';","Allowed file folder"],["mysqldump -u root -p db > backup.sql","Backup (run in terminal)"],["mysqldump -u root -p --no-data db > schema.sql","Structure only"],["mysql -u root -p db < backup.sql","Restore (terminal)"],["pg_dump db > backup.sql","Backup (PG)"]]],
["Partitioning","🧱",[["PARTITION BY RANGE (YEAR(d)) (...)","Split by value ranges"],["PARTITION BY LIST (col) (...)","Split by value lists"],["PARTITION BY HASH (col) PARTITIONS 4;","Even spread"],["SELECT * FROM t PARTITION (p2024);","Read one partition"],["ALTER TABLE t DROP PARTITION p2023;","Drop partition and its data"],["ALTER TABLE t REORGANIZE PARTITION ...","Split / merge partitions"]],
`CREATE TABLE sales (
  sale_id INT NOT NULL AUTO_INCREMENT, sale_date DATE NOT NULL, amount DECIMAL(10,2),
  PRIMARY KEY (sale_id, sale_date)
)
PARTITION BY RANGE (YEAR(sale_date)) (
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION pmax VALUES LESS THAN MAXVALUE
);`],
["Data Types","🏷️",[["TINYINT SMALLINT MEDIUMINT INT BIGINT","Integers (1, 2, 3, 4, 8 bytes; add UNSIGNED)"],["DECIMAL(p,s)","Exact numbers: use for money"],["FLOAT / DOUBLE","Approximate numbers"],["BOOLEAN","Alias of TINYINT(1) (PG: real boolean, SS: BIT)"],["CHAR(n) / VARCHAR(n)","Fixed / variable text"],["TEXT / MEDIUMTEXT / LONGTEXT","Long text (SS: VARCHAR(MAX), ORA: CLOB)"],["BINARY / VARBINARY / BLOB","Binary data"],["DATE TIME DATETIME TIMESTAMP YEAR","Date and time"],["ENUM('a','b') / SET('x','y')","Fixed value lists"],["JSON","JSON documents"]]],
["Dialect Differences","🌐",[["Limit rows","MySQL / PG: LIMIT n · SS: TOP n · ORA: FETCH FIRST n ROWS ONLY"],["Concatenate","MySQL: CONCAT() · PG / ORA: || · SS: +"],["Current time","MySQL / PG: NOW() · SS: GETDATE() · ORA: SYSDATE"],["NULL default","MySQL: IFNULL · PG: COALESCE · SS: ISNULL · ORA: NVL"],["String length","SS: LEN · others: LENGTH"],["Auto id","MySQL: AUTO_INCREMENT · PG: SERIAL · SS: IDENTITY · ORA: IDENTITY / sequence"],["Upsert","MySQL: ON DUPLICATE KEY · PG: ON CONFLICT · SS / ORA: MERGE"],["Group concat","MySQL: GROUP_CONCAT · PG / SS: STRING_AGG · ORA: LISTAGG"],["Quote names","MySQL: `name` · PG / ORA: \"name\" · SS: [name]"],["Date format","MySQL: DATE_FORMAT · PG / ORA: TO_CHAR · SS: FORMAT"],["Return inserted","PG: RETURNING · SS: OUTPUT · MySQL: not available"],["Except","ORA: MINUS · others: EXCEPT"]]],
["Command Types","📚",[["DDL","CREATE ALTER DROP TRUNCATE RENAME"],["DML","INSERT UPDATE DELETE MERGE REPLACE"],["DQL","SELECT"],["DCL","GRANT REVOKE"],["TCL","COMMIT ROLLBACK SAVEPOINT START TRANSACTION"],["DELETE vs TRUNCATE vs DROP","Rows with WHERE / all rows, resets ids / whole table"]]],
["Order of Execution","🧭",[["1. FROM / JOIN","Pick and combine tables"],["2. WHERE","Filter rows"],["3. GROUP BY","Build groups"],["4. HAVING","Filter groups"],["5. SELECT","Compute columns and aliases"],["6. DISTINCT, window functions","Dedupe, windows"],["7. ORDER BY","Sort"],["8. LIMIT / OFFSET","Trim result"]]]
];

var main = document.getElementById("main"), nav = document.getElementById("nav");
var secEls = [];

function el(tag, cls, txt) {
  var e = document.createElement(tag);
  if (cls) e.className = cls;
  if (txt != null) e.textContent = txt;
  return e;
}

S.forEach(function (s, i) {
  var sec = el("section"); sec.id = "s" + i;
  var h = el("h2", null, s[1] + " " + (i + 1) + ". " + s[0]);
  sec.appendChild(h);
  var rows = [];
  s[2].forEach(function (r) {
    var row = el("div", "row");
    row.appendChild(el("code", null, r[0]));
    row.appendChild(el("span", null, r[1]));
    row.dataset.t = (r[0] + " " + r[1]).toLowerCase();
    sec.appendChild(row); rows.push(row);
  });
  var box = null;
  if (s[3]) {
    box = el("div", "codebox");
    var pre = el("pre"); pre.appendChild(el("code", null, s[3]));
    pre.firstChild.style.background = "none"; pre.firstChild.style.padding = "0";
    var b = el("button", "copy", "Copy");
    b.onclick = function () {
      var done = function () { b.textContent = "Copied ✓"; setTimeout(function () { b.textContent = "Copy"; }, 1500); };
      try { navigator.clipboard.writeText(s[3]).then(done, fallback); } catch (e) { fallback(); }
      function fallback() {
        var ta = document.createElement("textarea"); ta.value = s[3];
        document.body.appendChild(ta); ta.select();
        try { document.execCommand("copy"); done(); } catch (e) {}
        document.body.removeChild(ta);
      }
    };
    box.appendChild(pre); box.appendChild(b); sec.appendChild(box);
  }
  main.appendChild(sec);
  secEls.push({ sec: sec, rows: rows, box: box, title: s[0].toLowerCase(), code: (s[3] || "").toLowerCase() });
  var a = el("a", null, (i + 1) + ". " + s[0]); a.href = "#s" + i; nav.appendChild(a);
});

document.getElementById("q").addEventListener("input", function (e) {
  var q = e.target.value.trim().toLowerCase(), any = false;
  secEls.forEach(function (o) {
    var titleHit = q && o.title.indexOf(q) > -1, codeHit = q && o.code.indexOf(q) > -1, shown = 0;
    o.rows.forEach(function (r) {
      var ok = !q || titleHit || r.dataset.t.indexOf(q) > -1;
      r.style.display = ok ? "" : "none"; if (ok) shown++;
    });
    var vis = !q || shown > 0 || codeHit;
    o.sec.style.display = vis ? "" : "none";
    if (vis) any = true;
  });
  document.getElementById("empty").style.display = any ? "none" : "block";
});

document.getElementById("theme").onclick = function () {
  var r = document.documentElement;
  var dark = r.dataset.theme ? r.dataset.theme === "dark" : matchMedia("(prefers-color-scheme: dark)").matches;
  r.dataset.theme = dark ? "light" : "dark";
};
</script>
</body>
</html>
