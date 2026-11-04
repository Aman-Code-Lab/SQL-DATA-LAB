𝗦𝗤𝗟 – 𝗣𝗥𝗘𝗦𝗖𝗥𝗜𝗭𝗜𝗢𝗡𝗘 𝗗𝗘𝗜 𝗖𝗢𝗠𝗔𝗡𝗗𝗜 (𝗖𝗛𝗘𝗔𝗧 𝗦𝗛𝗘𝗘𝗧)
=====================================================

Tutti i comandi SQL in un solo posto, con codice funzionante.
La sintassi predefinita è MySQL 8.0+.
Sigle: (PG) PostgreSQL, (SS) SQL Server, (ORA) Oracle.
Gli esempi funzionano sul database di prova della sezione 0.

INDICE
 0. Database di prova            18. Funzioni JSON
 1. Database                     19. Viste
 2. Tabelle (DDL)                20. Indici
 3. ALTER TABLE                  21. Transazioni (TCL)
 4. Vincoli                      22. Utenti e permessi (DCL)
 5. INSERT / UPDATE / DELETE     23. Procedure e funzioni
 6. SELECT (DQL)                 24. Trigger, eventi, cursori
 7. Operatori                    25. Controllo di flusso
 8. Join                         26. Variabili e prepared statement
 9. Operazioni su insiemi        27. Tabelle temporanee e sequenze
10. Sottoquery e CTE             28. Comandi di amministrazione
11. Funzioni di aggregazione     29. Prestazioni
12. Funzioni per stringhe        30. Import, export, backup
13. Funzioni numeriche           31. Partizionamento
14. Funzioni data e ora          32. Tipi di dato
15. Condizioni e NULL            33. Differenze tra dialetti
16. Conversione di tipo          34. Ordine di esecuzione e categorie
17. Funzioni finestra (window)

Avvisi prima di iniziare:
- Usa MySQL 8.0.31 o superiore (INTERSECT ed EXCEPT non esistono prima).
- Esegui le sezioni in ordine: alcune dipendono da oggetti creati prima.
- I blocchi con nomi generici (t, a, b, fk) sono modelli, non eseguibili.
- DELIMITER è un comando del client (mysql CLI e Workbench), non SQL.
- In Workbench la "Safe Updates" può bloccare UPDATE/DELETE senza chiave:
  usa SET SQL_SAFE_UPDATES = 0;


𝗣𝗔𝗥𝗧𝗘 𝟭 – 𝗗𝗔𝗧𝗔𝗕𝗔𝗦𝗘 𝗘 𝗧𝗔𝗕𝗘𝗟𝗟𝗘
=====================================================

0. DATABASE DI PROVA
--------------------
Eseguilo una volta sola. Finance non ha dipendenti e Vikram Das non ha
reparto: è voluto, per mostrare le differenze tra i join.

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
CREATE DATABASE db;                      Crea il database
CREATE DATABASE IF NOT EXISTS db;        Crea solo se non esiste
CREATE DATABASE db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
                                         Crea con codifica caratteri
SHOW DATABASES;                          Elenca i database (PG: \l)
USE db;                                  Seleziona il database (PG: \c db)
SELECT DATABASE();                       Database corrente
ALTER DATABASE db CHARACTER SET utf8mb4; Modifica il database
DROP DATABASE db;                        Elimina il database
DROP DATABASE IF EXISTS db;              Elimina se esiste
CREATE SCHEMA s; / DROP SCHEMA s;        Schemi (PG/SS/ORA; in MySQL = database)


2. TABELLE (DDL)
----------------
CREATE TABLE t (id INT PRIMARY KEY, name VARCHAR(50));   Crea tabella
CREATE TABLE IF NOT EXISTS t (...);      Crea se non esiste
CREATE TABLE t2 AS SELECT * FROM t;      Copia struttura e dati
CREATE TABLE t2 AS SELECT * FROM t WHERE 1=0;   Copia solo la struttura
CREATE TABLE t2 LIKE t;                  Copia struttura con indici (MySQL)
SELECT * INTO t2 FROM t;                 Copia tabella (SS)
SHOW TABLES;                             Elenca le tabelle (PG: \dt)
DESCRIBE t;  /  DESC t;                  Mostra le colonne
SHOW COLUMNS FROM t;                     Mostra le colonne
SHOW CREATE TABLE t;                     Mostra il DDL completo
RENAME TABLE vecchio TO nuovo;           Rinomina (MySQL)
TRUNCATE TABLE t;                        Svuota la tabella, azzera l'identity
                                         (in MySQL non si può annullare)
DROP TABLE t;                            Elimina la tabella
DROP TABLE IF EXISTS t;                  Elimina se esiste
DROP TABLE t1, t2;                       Elimina più tabelle

Prova:
CREATE TABLE emp_copy  AS SELECT * FROM employees;   -- struttura + dati
CREATE TABLE emp_shape LIKE employees;               -- solo struttura
DESCRIBE emp_copy;
DROP TABLE IF EXISTS emp_copy, emp_shape;            -- pulizia


3. ALTER TABLE
--------------
ALTER TABLE t ADD col INT;                     Aggiunge una colonna
ALTER TABLE t ADD col INT AFTER altra;         Aggiunge in una posizione (MySQL)
ALTER TABLE t ADD col INT FIRST;               Aggiunge come prima colonna (MySQL)
ALTER TABLE t ADD c1 INT, ADD c2 INT;          Aggiunge più colonne (MySQL)
ALTER TABLE t DROP COLUMN col;                 Elimina una colonna
ALTER TABLE t MODIFY col BIGINT;               Cambia tipo (MySQL, ORA)
ALTER TABLE t ALTER COLUMN col TYPE BIGINT;    Cambia tipo (PG)
ALTER TABLE t ALTER COLUMN col BIGINT;         Cambia tipo (SS)
ALTER TABLE t CHANGE vecchio nuovo INT;        Rinomina + ridefinisce (MySQL)
ALTER TABLE t RENAME COLUMN vecchio TO nuovo;  Rinomina colonna
ALTER TABLE t RENAME TO nuova_t;               Rinomina tabella
ALTER TABLE t ALTER COLUMN col SET DEFAULT 0;  Imposta valore predefinito
ALTER TABLE t ALTER COLUMN col DROP DEFAULT;   Rimuove valore predefinito
ALTER TABLE t MODIFY col INT NOT NULL;         Aggiunge NOT NULL (MySQL)
ALTER TABLE t ALTER COLUMN col SET NOT NULL;   Aggiunge NOT NULL (PG)
ALTER TABLE t AUTO_INCREMENT = 100;            Prossimo valore auto-increment
ALTER TABLE t ENGINE = InnoDB;                 Cambia motore
ALTER TABLE t CONVERT TO CHARACTER SET utf8mb4;  Cambia codifica

Prova:
ALTER TABLE employees ADD bonus DECIMAL(8,2) DEFAULT 0 AFTER salary;
ALTER TABLE employees RENAME COLUMN bonus TO annual_bonus;
ALTER TABLE employees DROP COLUMN annual_bonus;


4. VINCOLI
----------
col INT NOT NULL              Valore obbligatorio
col INT UNIQUE                Nessun duplicato
col INT PRIMARY KEY           Chiave primaria
PRIMARY KEY (c1, c2)          Chiave primaria composta
FOREIGN KEY (c) REFERENCES p(id)   Chiave esterna
CHECK (age >= 18)             Controllo (applicato da MySQL 8.0.16+)
col INT DEFAULT 0             Valore predefinito
col INT AUTO_INCREMENT        Numero automatico (PG: SERIAL, SS: IDENTITY(1,1))
ON DELETE CASCADE / SET NULL / RESTRICT / NO ACTION / SET DEFAULT
ON UPDATE CASCADE / SET NULL / RESTRICT / NO ACTION
CONSTRAINT nome ...           Dà un nome al vincolo

Modelli (t, d, fk non esistono nel database di prova):
ALTER TABLE t ADD PRIMARY KEY (id);
ALTER TABLE t ADD CONSTRAINT uq UNIQUE (email);
ALTER TABLE t ADD CONSTRAINT fk FOREIGN KEY (dept_id) REFERENCES d(dept_id);
ALTER TABLE t ADD CONSTRAINT ck CHECK (salary > 0);
ALTER TABLE t DROP PRIMARY KEY;          -- MySQL
ALTER TABLE t DROP FOREIGN KEY fk;       -- MySQL
ALTER TABLE t DROP INDEX uq;             -- MySQL (unique)
ALTER TABLE t DROP CHECK ck;             -- MySQL 8.0.16+
ALTER TABLE t DROP CONSTRAINT nome;      -- PG / SS / ORA
SET FOREIGN_KEY_CHECKS = 0;              -- disattiva (MySQL)
SET FOREIGN_KEY_CHECKS = 1;              -- riattiva

Prova (deve dare errore: il vincolo CHECK blocca il dato):
INSERT INTO employees (name, age) VALUES ('Troppo Giovane', 15);


𝗣𝗔𝗥𝗧𝗘 𝟮 – 𝗗𝗔𝗧𝗜 𝗘 𝗤𝗨𝗘𝗥𝗬
=====================================================

5. INSERT / UPDATE / DELETE (DML)
---------------------------------
-- INSERT
INSERT INTO departments (dept_name, location) VALUES ('Legal', 'Chennai');
INSERT INTO departments (dept_name, location) VALUES ('R&D','Pune'), ('Ops','Delhi');

CREATE TABLE emp_backup LIKE employees;
INSERT INTO emp_backup SELECT * FROM employees;           -- da una query
INSERT INTO emp_backup (name, salary) SELECT name, salary FROM employees WHERE salary > 100000;

INSERT IGNORE INTO departments (dept_name) VALUES ('IT'); -- ignora duplicati (MySQL)
REPLACE INTO emp_backup (emp_id, name, salary) VALUES (1, 'Asha Rao', 99000);
                                                          -- elimina + inserisce (MySQL)

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
DELETE FROM emp_backup;                                      -- tutte le righe
DROP TABLE emp_backup;

ATTENZIONE: UPDATE o DELETE senza WHERE modificano TUTTE le righe.
Prima prova la condizione con una SELECT.

-- MERGE (SS / ORA / PG 15+; non esiste in MySQL)
MERGE INTO target t USING source s ON t.id = s.id
WHEN MATCHED THEN UPDATE SET t.v = s.v
WHEN NOT MATCHED THEN INSERT (id, v) VALUES (s.id, s.v);


6. SELECT (DQL)
---------------
SELECT * FROM employees;
SELECT name, salary FROM employees;
SELECT DISTINCT dept_id FROM employees;                        -- valori unici
SELECT name AS dipendente, salary * 12 AS annuale FROM employees;   -- alias
SELECT name FROM employees WHERE salary > 60000;
SELECT dept_id, COUNT(*) AS n FROM employees GROUP BY dept_id HAVING COUNT(*) > 1;
SELECT * FROM employees ORDER BY dept_id ASC, salary DESC;     -- ordinamento
SELECT * FROM employees LIMIT 3;
SELECT * FROM employees LIMIT 3 OFFSET 3;
SELECT * FROM employees LIMIT 3, 3;                            -- offset, quanti (MySQL)
SELECT 1 + 1;
SELECT COUNT(*) INTO @cnt FROM employees;                      -- in una variabile
SELECT @cnt;

Altri dialetti e blocchi (non funzionano in MySQL le prime due):
-- SELECT TOP 3 * FROM employees;                      (SS)
-- SELECT * FROM employees FETCH FIRST 3 ROWS ONLY;    (ORA / PG / SS)
START TRANSACTION;
SELECT * FROM employees WHERE emp_id = 1 FOR UPDATE;   -- blocca le righe
SELECT * FROM employees WHERE emp_id = 1 FOR SHARE;    -- blocco condiviso
ROLLBACK;                                              -- rilascia i blocchi

Ordine in cui SCRIVI le clausole:
SELECT [DISTINCT] colonne
FROM tabella
[JOIN ... ON ...]
[WHERE ...]
[GROUP BY ...]
[HAVING ...]
[ORDER BY ...]
[LIMIT ... OFFSET ...];


7. OPERATORI E PAROLE CHIAVE
----------------------------
=  <>  !=  >  <  >=  <=       Confronto
<=>                           Uguale che gestisce NULL (MySQL)
AND, OR, NOT                  Logici
BETWEEN x AND y               Intervallo, estremi inclusi
NOT BETWEEN                   Fuori dall'intervallo
IN (...) / NOT IN (...)       Elenco (attenzione ai NULL con NOT IN)
LIKE 'A%'                     Inizia con A
LIKE '%a'                     Finisce con a
LIKE '%a%'                    Contiene a
LIKE '_a%'                    Seconda lettera a
ILIKE                         LIKE senza maiuscole/minuscole (PG)
REGEXP / RLIKE                Espressione regolare (MySQL); ~ in PG
IS NULL / IS NOT NULL         Test sul NULL
EXISTS / NOT EXISTS           Esiste almeno una riga
ANY / SOME / ALL              Confronto con un insieme
+ - * / %   DIV   MOD         Aritmetici
& | ^ ~ << >>                 Bit a bit
||                            Concatenazione (PG, ORA)
+                             Concatenazione (SS)
COLLATE                       Sceglie il confronto dei caratteri
ESCAPE                        LIKE '50\%' ESCAPE '\\'

Prova:
SELECT name FROM employees WHERE name LIKE 'A%';
SELECT name FROM employees WHERE name REGEXP '^[AEIOU]';
SELECT name FROM employees WHERE email IS NULL;
SELECT name, salary FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE dept_id = 2);


8. JOIN
-------
-- INNER: solo le righe che corrispondono
SELECT e.name, d.dept_name FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id;
-- LEFT: tutti i dipendenti (Vikram: reparto NULL)
SELECT e.name, d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id;
-- RIGHT: tutti i reparti (Finance: dipendente NULL)
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;
-- CROSS: prodotto cartesiano
SELECT d.dept_name, e.name FROM departments d CROSS JOIN employees e;
-- USING / NATURAL
SELECT * FROM employees e JOIN departments d USING (dept_id);
SELECT * FROM employees NATURAL JOIN departments;

-- Self join: dipendente e responsabile
SELECT e.name AS dipendente, m.name AS responsabile
FROM employees e LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Anti join: reparti senza dipendenti
SELECT d.dept_name FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;

-- Join su più tabelle
SELECT e.name, d.dept_name, o.amount
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN orders o ON o.emp_id = e.emp_id;

-- FULL OUTER JOIN esiste in PG / SS / ORA. In MySQL si simula:
SELECT e.name, d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;

Riepilogo:
INNER            Righe presenti in entrambe
LEFT             Tutta la sinistra + corrispondenze
RIGHT            Tutta la destra + corrispondenze
FULL             Tutte le righe di entrambe
CROSS            Ogni combinazione
LATERAL / CROSS APPLY   Sottoquery correlata per riga (PG, MySQL 8.0.14+ / SS)


9. OPERAZIONI SU INSIEMI
------------------------
SELECT dept_id FROM employees UNION     SELECT dept_id FROM departments;  -- senza duplicati
SELECT dept_id FROM employees UNION ALL SELECT dept_id FROM departments;  -- con duplicati
SELECT dept_id FROM departments INTERSECT SELECT dept_id FROM employees;  -- in comune (MySQL 8.0.31+)
SELECT dept_id FROM departments EXCEPT    SELECT dept_id FROM employees;  -- solo a sinistra (ORA: MINUS)

Le due query devono avere lo stesso numero di colonne con tipi compatibili.


10. SOTTOQUERY E CTE
--------------------
-- Scalare
SELECT name, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);
-- IN
SELECT name FROM employees WHERE emp_id IN (SELECT emp_id FROM orders);
-- Tabella derivata
SELECT * FROM (SELECT emp_id, SUM(amount) AS totale FROM orders GROUP BY emp_id) x WHERE totale > 1000;
-- Correlata: guadagna più della media del proprio reparto
SELECT name, salary FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id);
-- EXISTS
SELECT d.dept_name FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id);
-- Nell'elenco SELECT
SELECT name, (SELECT COUNT(*) FROM orders o WHERE o.emp_id = e.emp_id) AS n_ordini FROM employees e;

-- CTE
WITH media_reparto AS (
  SELECT dept_id, AVG(salary) AS media FROM employees GROUP BY dept_id
)
SELECT e.name, e.salary, m.media
FROM employees e JOIN media_reparto m ON e.dept_id = m.dept_id;

-- CTE ricorsiva: numeri da 1 a 10
WITH RECURSIVE n AS (
  SELECT 1 AS x UNION ALL SELECT x + 1 FROM n WHERE x < 10
)
SELECT * FROM n;

-- CTE ricorsiva: catena gerarchica
WITH RECURSIVE catena AS (
  SELECT emp_id, name, manager_id, 1 AS livello FROM employees WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.name, e.manager_id, c.livello + 1
  FROM employees e JOIN catena c ON e.manager_id = c.emp_id
)
SELECT * FROM catena ORDER BY livello, emp_id;


𝗣𝗔𝗥𝗧𝗘 𝟯 – 𝗙𝗨𝗡𝗭𝗜𝗢𝗡𝗜
=====================================================

11. FUNZIONI DI AGGREGAZIONE
----------------------------
COUNT(*)                       Tutte le righe
COUNT(col)                     Valori non NULL
COUNT(DISTINCT col)            Valori unici non NULL
SUM(col)  AVG(col)             Somma, media
MIN(col)  MAX(col)             Minimo, massimo
GROUP_CONCAT(col SEPARATOR ',')   Unisce i valori (MySQL)
STRING_AGG(col, ',')           Unisce i valori (PG, SS)
LISTAGG(col, ',')              Unisce i valori (ORA)
STDDEV()  VARIANCE()           Statistica
BIT_AND() BIT_OR() BIT_XOR()   Aggregati bit a bit
JSON_ARRAYAGG() JSON_OBJECTAGG()   Aggregati JSON
GROUP BY ... WITH ROLLUP       Subtotali (MySQL); PG/SS/ORA: ROLLUP(a,b)
GROUP BY CUBE(a,b)             Tutte le combinazioni (PG/SS/ORA)
GROUP BY GROUPING SETS (...)   Raggruppamenti personalizzati

Prova:
SELECT COUNT(*), COUNT(email), COUNT(DISTINCT dept_id) FROM employees;   -- 8, 7, 3
SELECT dept_id, COUNT(*) AS n, ROUND(AVG(salary),2) AS media, MAX(salary) AS massimo
FROM employees GROUP BY dept_id;
SELECT dept_id, GROUP_CONCAT(name ORDER BY name SEPARATOR ', ') AS team FROM employees GROUP BY dept_id;
SELECT dept_id, SUM(salary) FROM employees GROUP BY dept_id WITH ROLLUP;

COUNT(*) conta le righe; COUNT(col) salta i NULL.


12. FUNZIONI PER STRINGHE
-------------------------
UPPER(s) / LOWER(s)                   Maiuscolo / minuscolo
LENGTH(s) / CHAR_LENGTH(s)            Byte / caratteri (SS: LEN)
CONCAT(a,b,...) / CONCAT_WS(sep,a,b)  Unisce stringhe
SUBSTRING(s,pos,len) / SUBSTR         Sottostringa (parte da 1)
LEFT(s,n) / RIGHT(s,n)                Primi / ultimi n caratteri
TRIM(s) / LTRIM(s) / RTRIM(s)         Toglie gli spazi
TRIM(BOTH 'x' FROM s)                 Toglie caratteri specifici
REPLACE(s,da,a)                       Sostituisce testo
REVERSE(s)                            Inverte
INSTR(s,sub) / LOCATE(sub,s)          Trova la posizione
LPAD(s,n,p) / RPAD(s,n,p)             Riempie fino a n caratteri
REPEAT(s,n)                           Ripete
SPACE(n)                              n spazi
ASCII(c) / CHAR(n)                    Carattere / codice
FORMAT(n,d)                           Formatta il numero (1,234.50)
STRCMP(a,b)                           Confronta
FIELD(s,a,b,c)                        Indice nell'elenco
FIND_IN_SET(s,'a,b,c')                Posizione in una lista CSV
SUBSTRING_INDEX(s,delim,n)            Divide per delimitatore (MySQL)
SPLIT_PART(s,delim,n)                 Divide (PG)
INITCAP(s)                            Iniziali maiuscole (PG/ORA)
TRANSLATE(s,da,a)                     Sostituisce carattere per carattere (PG/ORA)
INSERT(s,pos,len,nuovo)               Inserisce / sostituisce una parte (OVERLAY in PG)
SOUNDEX(s)                            Codice fonetico
REGEXP_REPLACE() REGEXP_SUBSTR() REGEXP_LIKE() REGEXP_INSTR()   Regex (MySQL 8+)
QUOTE(s)                              Protegge la stringa
HEX(s) / UNHEX(s)                     Esadecimale
MD5(s) / SHA2(s,256)                  Hash
TO_BASE64(s) / FROM_BASE64(s)         Base64

Prova:
SELECT UPPER(name), LENGTH(name), LEFT(name,3), SUBSTRING(name,1,4) FROM employees LIMIT 3;
SELECT CONCAT(name, ' <', IFNULL(email,'nessuna email'), '>') AS contatto FROM employees;
SELECT SUBSTRING_INDEX(email,'@',1) AS utente, SUBSTRING_INDEX(email,'@',-1) AS dominio
FROM employees WHERE email IS NOT NULL;
SELECT REPLACE('2024-01-15','-','/'), LPAD(7,3,'0'), REPEAT('ab',3), REVERSE('SQL');
SELECT REGEXP_REPLACE('a1b22c333','[0-9]+','#');     -- a#b#c#
SELECT SHA2('segreto',256);


13. FUNZIONI NUMERICHE
----------------------
ROUND(n,d)                     Arrotonda
CEIL(n) / CEILING(n)           Per eccesso
FLOOR(n)                       Per difetto
TRUNCATE(n,d)                  Taglia i decimali (PG/ORA: TRUNC)
ABS(n)                         Valore assoluto
MOD(a,b) / a % b               Resto
POWER(a,b) / POW               Potenza
SQRT(n)                        Radice quadrata
EXP(n) LN(n) LOG(n) LOG10(n) LOG2(n)   Esponenziale e logaritmi
SIGN(n)                        -1 / 0 / 1
RAND()                         Casuale tra 0 e 1 (PG: RANDOM())
GREATEST(a,b,...) / LEAST(a,b,...)     Massimo / minimo tra valori
PI()                           Pi greco
SIN() COS() TAN() ASIN() ACOS() ATAN() Trigonometria
DEGREES() / RADIANS()          Conversione angoli
CONV(n,da,a)                   Cambio di base
DIV                            Divisione intera (MySQL)

Prova:
SELECT ROUND(3.14159,2), CEIL(4.1), FLOOR(4.9), TRUNCATE(4.987,1), ABS(-5);   -- 3.14, 5, 4, 4.9, 5
SELECT MOD(17,5), 17 % 5, 17 DIV 5, POWER(2,10), SQRT(144), SIGN(-9);         -- 2, 2, 3, 1024, 12, -1
SELECT GREATEST(3,9,2), LEAST(3,9,2), CONV('FF',16,10);                       -- 9, 2, 255
SELECT name FROM employees ORDER BY RAND() LIMIT 1;                           -- dipendente a caso


14. FUNZIONI DATA E ORA
-----------------------
NOW() / CURRENT_TIMESTAMP / SYSDATE()   Data e ora attuali (SS: GETDATE(), ORA: SYSDATE)
CURDATE() / CURRENT_DATE                Data attuale
CURTIME() / CURRENT_TIME                Ora attuale
UTC_TIMESTAMP() / UTC_DATE()            UTC
DATE(x) / TIME(x)                       Estrae data / ora
YEAR(x) MONTH(x) DAY(x) HOUR(x) MINUTE(x) SECOND(x)   Parti
QUARTER(x) WEEK(x) WEEKDAY(x) DAYOFWEEK(x) DAYOFMONTH(x) DAYOFYEAR(x)
DAYNAME(x) / MONTHNAME(x)               Nomi (in inglese per impostazione predefinita)
EXTRACT(unità FROM x)                   Estrazione standard
DATE_ADD(x, INTERVAL n unità)           Aggiunge
DATE_SUB(x, INTERVAL n unità)           Sottrae
x + INTERVAL 7 DAY                      Aggiunge un intervallo
DATEDIFF(d1,d2)                         Giorni tra due date (SS: DATEDIFF(day,d1,d2))
TIMESTAMPDIFF(unità,d1,d2)              Differenza in una unità
TIMEDIFF(t1,t2)                         Differenza di orario
DATE_FORMAT(x,'%Y-%m-%d')               Formatta (PG: TO_CHAR, SS: FORMAT)
STR_TO_DATE(s,'%d-%m-%Y')               Legge un testo (PG/ORA: TO_DATE)
LAST_DAY(x)                             Ultimo giorno del mese
MAKEDATE(a,giorno_anno) MAKETIME(h,m,s) Costruisce data / ora
FROM_UNIXTIME(n) / UNIX_TIMESTAMP(x)    Conversione da/verso epoch
TO_DAYS(x) / FROM_DAYS(n)               Numero di giorno
SEC_TO_TIME(n) / TIME_TO_SEC(t)         Conversione secondi
AGE(d1,d2)                              Intervallo (PG)
DATE_TRUNC('month', x)                  Tronca (PG)
DATEADD(day,7,x)  DATEPART(year,x)      (SS)
ADD_MONTHS(x,n)  MONTHS_BETWEEN(a,b)    (ORA)

Unità: MICROSECOND, SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, YEAR

Codici di formato: %Y anno | %y anno a 2 cifre | %m mese (01-12) | %M nome mese |
%b mese breve | %d giorno | %e giorno senza zero | %H ore 24h | %h ore 12h |
%i minuti | %s secondi | %p AM/PM | %W nome giorno | %a giorno breve | %j giorno dell'anno

Prova:
SELECT NOW(), CURDATE(), CURTIME();
SELECT name, hire_date, YEAR(hire_date) AS anno, MONTHNAME(hire_date) AS mese FROM employees;
SELECT name, TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS anni_di_servizio FROM employees;
SELECT DATE_ADD('2024-01-31', INTERVAL 1 MONTH), '2024-01-15' + INTERVAL 7 DAY, LAST_DAY('2024-02-10');
SELECT DATEDIFF('2024-12-25','2024-01-01');                -- 359
SELECT DATE_FORMAT('2024-03-05','%d %b %Y, %W');           -- 05 Mar 2024, Tuesday
SELECT STR_TO_DATE('15-08-2024','%d-%m-%Y');               -- 2024-08-15
SELECT YEAR(order_date) AS anno, MONTH(order_date) AS mese, SUM(amount)
FROM orders GROUP BY anno, mese ORDER BY anno, mese;


15. CONDIZIONI E FUNZIONI SUI NULL
----------------------------------
CASE WHEN c THEN a ELSE b END           Se-altrimenti (standard)
CASE col WHEN 1 THEN 'a' WHEN 2 THEN 'b' END   CASE semplice
IF(cond, si, no)                        Se in linea (MySQL)
IIF(cond, si, no)                       Se in linea (SS)
IFNULL(a,b)                             b se a è NULL (MySQL)
ISNULL(a,b)                             (SS)
NVL(a,b)  NVL2(a,b,c)                   (ORA)
COALESCE(a,b,c)                         Primo valore non NULL (standard)
NULLIF(a,b)                             NULL se a = b
GREATEST() / LEAST()                    Massimo / minimo tra colonne
DECODE(col,v1,r1,v2,r2,predef)          (ORA)

Prova:
SELECT name, salary,
  CASE WHEN salary >= 70000 THEN 'Alto'
       WHEN salary >= 55000 THEN 'Medio'
       ELSE 'Basso' END AS fascia
FROM employees;

SELECT name, IF(dept_id IS NULL, 'Senza reparto', 'Assegnato') AS stato FROM employees;
SELECT name, COALESCE(email, 'nessuna-email') FROM employees;
SELECT NULLIF(10, 10), NULLIF(10, 5);       -- NULL, 10
SELECT 100 / NULLIF(0, 0);                  -- NULL invece di un errore di divisione per zero


16. CONVERSIONE DI TIPO
-----------------------
SELECT CAST('123' AS SIGNED), CAST(12.3456 AS DECIMAL(10,2)), CAST('2024-05-01' AS DATE);
SELECT CAST(NOW() AS DATE), CAST(65 AS CHAR), CONVERT('42', SIGNED), CONVERT('abc' USING utf8mb4);
SELECT '10' + 5;                            -- 15 (conversione implicita)

Altri dialetti:
x::INT                                      (PG, forma abbreviata)
TO_CHAR(x,'fmt')  TO_NUMBER(s)  TO_DATE(s,'fmt')   (PG / ORA)
TRY_CAST(x AS INT)  TRY_CONVERT(...)        (SS: NULL se fallisce)


17. FUNZIONI FINESTRA (WINDOW)
------------------------------
Forma: funzione() OVER (PARTITION BY a ORDER BY b ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

ROW_NUMBER()                   Numero di riga unico
RANK()                         Posizione con salti
DENSE_RANK()                   Posizione senza salti
NTILE(n)                       Divide in n gruppi
PERCENT_RANK()                 Posizione relativa 0-1
CUME_DIST()                    Distribuzione cumulativa
LAG(col,n,predef)              Valore della riga precedente
LEAD(col,n,predef)             Valore della riga successiva
FIRST_VALUE(col) / LAST_VALUE(col) / NTH_VALUE(col,n)
SUM() AVG() COUNT() MIN() MAX() OVER (...)   Aggregati correnti / per gruppo
WINDOW w AS (PARTITION BY ...)  Finestra con nome

Parole per il frame: ROWS, RANGE, UNBOUNDED PRECEDING, n PRECEDING, CURRENT ROW,
n FOLLOWING, UNBOUNDED FOLLOWING.

Prova:
-- Classifica degli stipendi nel reparto
SELECT name, dept_id, salary,
  ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn,
  RANK()       OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS drnk
FROM employees;

-- Il più pagato di ogni reparto
SELECT * FROM (
  SELECT name, dept_id, salary,
         RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS r
  FROM employees
) t WHERE r = 1;

-- Totale progressivo, precedente e successivo
SELECT order_id, order_date, amount,
  SUM(amount) OVER (ORDER BY order_date, order_id) AS totale_progressivo,
  LAG(amount)  OVER (ORDER BY order_date, order_id) AS precedente,
  LEAD(amount) OVER (ORDER BY order_date, order_id) AS successivo
FROM orders;

-- Media mobile su 3 righe e quota sul totale del reparto
SELECT order_id, AVG(amount) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS media_mobile FROM orders;
SELECT name, dept_id, salary, ROUND(100 * salary / SUM(salary) OVER (PARTITION BY dept_id), 1) AS pct_reparto FROM employees;

-- Finestra con nome + NTILE
SELECT name, salary, NTILE(4) OVER w AS quartile FROM employees WINDOW w AS (ORDER BY salary);


18. FUNZIONI JSON
-----------------
CREATE TABLE products (id INT PRIMARY KEY AUTO_INCREMENT, info JSON);
INSERT INTO products (info) VALUES
  ('{"name":"Laptop","price":55000,"tags":["tech","work"]}'),
  ('{"name":"Desk","price":12000,"tags":["furniture"]}');

SELECT JSON_EXTRACT(info,'$.name') FROM products;             -- "Laptop"
SELECT info->'$.name', info->>'$.name' FROM products;         -- con / senza virgolette
SELECT JSON_OBJECT('k', 1, 'x', 'y'), JSON_ARRAY(1,2,3);
UPDATE products SET info = JSON_SET(info, '$.price', 50000) WHERE id = 1;
UPDATE products SET info = JSON_REMOVE(info, '$.tags') WHERE id = 2;
SELECT * FROM products WHERE JSON_CONTAINS(info->'$.tags', '"tech"');
SELECT JSON_LENGTH(info), JSON_KEYS(info), JSON_VALID(info), JSON_TYPE(info) FROM products;
SELECT jt.* FROM products p,
  JSON_TABLE(p.info, '$' COLUMNS (name VARCHAR(50) PATH '$.name', price INT PATH '$.price')) jt;
DROP TABLE products;

Altre funzioni: JSON_INSERT(), JSON_REPLACE(), JSON_ARRAYAGG(), JSON_OBJECTAGG().
PG: col->'name'  col->>'name'  col @> '{"a":1}'  jsonb_set(...)
SS: JSON_VALUE(col,'$.name')  OPENJSON(col)  FOR JSON PATH


𝗣𝗔𝗥𝗧𝗘 𝟰 – 𝗢𝗚𝗚𝗘𝗧𝗧𝗜 𝗘 𝗣𝗥𝗢𝗚𝗥𝗔𝗠𝗠𝗔𝗭𝗜𝗢𝗡𝗘
=====================================================

19. VISTE
---------
CREATE VIEW v_it AS SELECT emp_id, name, salary FROM employees WHERE dept_id = 1;
CREATE OR REPLACE VIEW v_it AS SELECT emp_id, name, salary, hire_date FROM employees WHERE dept_id = 1;
CREATE VIEW v_economici AS SELECT * FROM employees WHERE salary < 60000 WITH CHECK OPTION;
                                  -- blocca le righe che uscirebbero dalla vista
SELECT * FROM v_it;
ALTER VIEW v_it AS SELECT emp_id, name FROM employees WHERE dept_id = 1;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW CREATE VIEW v_it;
DROP VIEW IF EXISTS v_it, v_economici;

Solo PG / ORA:
CREATE MATERIALIZED VIEW mv AS SELECT ...;
REFRESH MATERIALIZED VIEW mv;     -- PG


20. INDICI
----------
CREATE INDEX idx_dept ON employees (dept_id);
CREATE INDEX idx_dept_sal ON employees (dept_id, salary);     -- composto (regola del prefisso sinistro)
CREATE FULLTEXT INDEX idx_ft ON departments (dept_name, location);   -- MySQL
CREATE INDEX idx_sal_desc ON employees (salary DESC);         -- MySQL 8+
CREATE INDEX idx_name5 ON employees (name(5));                -- indice sul prefisso (MySQL)

SHOW INDEX FROM employees;
ALTER TABLE employees ADD INDEX idx_age (age);
ALTER TABLE employees ALTER INDEX idx_age INVISIBLE;          -- MySQL 8+: nascosto all'ottimizzatore
DROP INDEX idx_age ON employees;                              -- MySQL / SS  (PG/ORA: DROP INDEX idx_age;)

SELECT * FROM departments WHERE MATCH(dept_name, location) AGAINST('Delhi');   -- usa il FULLTEXT

PG: indice parziale  CREATE INDEX idx ON t (col) WHERE attivo;
PG: su espressione   CREATE INDEX idx ON t (LOWER(email));
SS: colonne incluse  CREATE INDEX idx ON t (a) INCLUDE (b);

Consiglio: indicizza le colonne che usi in filtri, join e ordinamenti.
Troppi indici rallentano le scritture.


21. TRANSAZIONI (TCL)
---------------------
START TRANSACTION;               -- oppure BEGIN
UPDATE employees SET salary = salary - 1000 WHERE emp_id = 2;
UPDATE employees SET salary = salary + 1000 WHERE emp_id = 3;
COMMIT;                          -- salva

START TRANSACTION;
DELETE FROM orders WHERE emp_id = 6;
ROLLBACK;                        -- annulla tutto

START TRANSACTION;
UPDATE employees SET age = age + 1 WHERE emp_id = 1;
SAVEPOINT sp1;
UPDATE employees SET age = age + 1 WHERE emp_id = 2;
ROLLBACK TO SAVEPOINT sp1;       -- annulla solo il secondo update
RELEASE SAVEPOINT sp1;
COMMIT;

SET autocommit = 0;              -- commit manuale
SET autocommit = 1;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;   -- vale per la transazione successiva
SELECT @@transaction_isolation;

Livelli di isolamento:
READ UNCOMMITTED   lettura sporca: sì | non ripetibile: sì | fantasma: sì
READ COMMITTED     lettura sporca: no | non ripetibile: sì | fantasma: sì
REPEATABLE READ    lettura sporca: no | non ripetibile: no | fantasma: quasi mai (InnoDB)
                   (predefinito in MySQL)
SERIALIZABLE       lettura sporca: no | non ripetibile: no | fantasma: no

ACID: Atomicità, Coerenza, Isolamento, Durabilità.
Le istruzioni DDL (CREATE, DROP, TRUNCATE) fanno commit automatico in MySQL.


22. UTENTI E PERMESSI (DCL)
---------------------------
CREATE USER 'alice'@'localhost' IDENTIFIED BY 'Str0ng#Pass';
CREATE USER 'bob'@'%' IDENTIFIED BY 'Str0ng#Pass2';           -- da qualsiasi host

GRANT SELECT ON sql_cheatsheet.* TO 'alice'@'localhost';
GRANT SELECT, INSERT, UPDATE ON sql_cheatsheet.employees TO 'alice'@'localhost';
GRANT ALL PRIVILEGES ON sql_cheatsheet.* TO 'bob'@'%' WITH GRANT OPTION;
-- GRANT EXECUTE ON PROCEDURE sql_cheatsheet.raise_salary TO 'alice'@'localhost';
--   (eseguila dopo la sezione 23, quando la procedura esiste)

SHOW GRANTS FOR 'alice'@'localhost';
REVOKE INSERT ON sql_cheatsheet.employees FROM 'alice'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'bob'@'%';

ALTER USER 'alice'@'localhost' IDENTIFIED BY 'N3w#Pass';
RENAME USER 'bob'@'%' TO 'roberto'@'%';
DROP USER 'alice'@'localhost', 'roberto'@'%';
FLUSH PRIVILEGES;

-- Ruoli (MySQL 8+)
CREATE ROLE 'lettore';
GRANT SELECT ON sql_cheatsheet.* TO 'lettore';
DROP ROLE 'lettore';


23. PROCEDURE E FUNZIONI MEMORIZZATE
------------------------------------
DELIMITER //

CREATE PROCEDURE raise_salary(IN p_dept INT, IN p_pct DECIMAL(5,2))
BEGIN
    UPDATE employees SET salary = salary * (1 + p_pct / 100) WHERE dept_id = p_dept;
    SELECT ROW_COUNT() AS righe_modificate;
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

Note:
- DELIMITER è un comando del CLIENT, non SQL. Funziona in mysql CLI e MySQL
  Workbench. In phpMyAdmin o DBeaver imposta il delimitatore nell'opzione del
  programma e cancella le righe DELIMITER. Molti editor SQL online non lo supportano.
- Modalità dei parametri: IN (predefinita), OUT, INOUT.
- Se la creazione di una funzione dà un errore sul binary log, serve:
  SET GLOBAL log_bin_trust_function_creators = 1;  (richiede privilegi)


24. TRIGGER, EVENTI, CURSORI
----------------------------
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

Momento: BEFORE / AFTER. Evento: INSERT / UPDATE / DELETE.
OLD = riga prima della modifica, NEW = riga dopo.

-- EVENTI (pianificatore)
SET GLOBAL event_scheduler = ON;

CREATE EVENT ev_purge_log
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP
DO DELETE FROM salary_log WHERE changed_at < NOW() - INTERVAL 30 DAY;

SHOW EVENTS;
ALTER EVENT ev_purge_log DISABLE;
DROP EVENT IF EXISTS ev_purge_log;

-- CURSORI
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


25. CONTROLLO DI FLUSSO
-----------------------
DELIMITER //
CREATE PROCEDURE flow_demo(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE s INT DEFAULT 0;

    -- IF / ELSEIF / ELSE
    IF n < 0 THEN SELECT 'negativo';
    ELSEIF n = 0 THEN SELECT 'zero';
    ELSE SELECT 'positivo';
    END IF;

    -- CASE
    CASE WHEN n > 100 THEN SELECT 'grande'; ELSE SELECT 'piccolo'; END CASE;

    -- WHILE
    WHILE i <= n DO SET s = s + i; SET i = i + 1; END WHILE;
    SELECT s AS somma_da_1_a_n;

    -- REPEAT
    SET i = 0;
    REPEAT SET i = i + 1; UNTIL i >= 3 END REPEAT;

    -- LOOP con LEAVE (esci) / ITERATE (continua)
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

Gestione degli errori:
DELIMITER //
CREATE PROCEDURE safe_transfer(IN p_from INT, IN p_to INT, IN p_amt DECIMAL(10,2))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Trasferimento fallito, annullato' AS msg;
    END;

    START TRANSACTION;
    UPDATE employees SET salary = salary - p_amt WHERE emp_id = p_from;
    UPDATE employees SET salary = salary + p_amt WHERE emp_id = p_to;
    IF (SELECT salary FROM employees WHERE emp_id = p_from) < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fondi insufficienti';
    END IF;
    COMMIT;
END //
DELIMITER ;


26. VARIABILI E PREPARED STATEMENT
----------------------------------
-- Variabili utente (valgono per tutta la sessione)
SET @nome = 'Asha Rao';
SET @min_sal := 60000;
SELECT @nome, @min_sal;
SELECT COUNT(*) INTO @n FROM employees WHERE salary > @min_sal;
SELECT @n;

-- Variabili di sistema
SHOW VARIABLES LIKE 'max_connections';
SET SESSION sql_mode = 'STRICT_ALL_TABLES';
SET GLOBAL max_connections = 300;               -- richiede privilegi
SELECT @@version, @@sql_mode, @@global.time_zone;

-- Variabili locali (solo dentro le routine)
-- DECLARE v INT DEFAULT 0;  SET v = 5;

-- Prepared statement (SQL dinamico sicuro)
PREPARE stmt FROM 'SELECT name, salary FROM employees WHERE dept_id = ? AND salary > ?';
SET @d = 1, @s = 60000;
EXECUTE stmt USING @d, @s;
DEALLOCATE PREPARE stmt;

-- Nome di tabella dinamico
SET @tbl = 'employees';
SET @sql = CONCAT('SELECT COUNT(*) AS n FROM ', @tbl);
PREPARE s2 FROM @sql; EXECUTE s2; DEALLOCATE PREPARE s2;

ATTENZIONE: usa i segnaposto ? per i valori. Non incollare mai input non fidato
dentro l'SQL (SQL injection).


27. TABELLE TEMPORANEE E SEQUENZE
---------------------------------
-- Tabella temporanea: visibile solo alla tua sessione, sparisce alla disconnessione
CREATE TEMPORARY TABLE tmp_alti AS SELECT * FROM employees WHERE salary > 60000;
SELECT * FROM tmp_alti;
DROP TEMPORARY TABLE tmp_alti;

SELECT LAST_INSERT_ID();                  -- ultimo valore auto-increment
ALTER TABLE departments AUTO_INCREMENT = 100;

Sequenze (MySQL non le ha: usa AUTO_INCREMENT):
CREATE SEQUENCE seq_id START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999 CACHE 20;
SELECT NEXTVAL('seq_id');                 -- PG
SELECT seq_id.NEXTVAL FROM dual;          -- ORA
SELECT NEXT VALUE FOR seq_id;             -- SS
ALTER SEQUENCE seq_id RESTART WITH 100;
DROP SEQUENCE seq_id;

Tabelle temporanee in altri dialetti:
SS: CREATE TABLE #tmp (...)     PG: CREATE TEMP TABLE tmp (...)


𝗣𝗔𝗥𝗧𝗘 𝟱 – 𝗔𝗠𝗠𝗜𝗡𝗜𝗦𝗧𝗥𝗔𝗭𝗜𝗢𝗡𝗘 𝗘 𝗥𝗜𝗙𝗘𝗥𝗜𝗠𝗘𝗡𝗧𝗜
=====================================================

28. COMANDI DI AMMINISTRAZIONE E INFORMAZIONE
---------------------------------------------
SHOW DATABASES;  SHOW TABLES;            Elenca gli oggetti
SHOW TABLES LIKE 'emp%';                 Filtra per modello
SHOW FULL COLUMNS FROM t;                Colonne con commenti e collation
SHOW CREATE TABLE t;                     DDL completo
SHOW INDEX FROM t;                       Indici
SHOW TABLE STATUS LIKE 't';              Righe, dimensione, motore
SHOW PROCESSLIST;                        Query in esecuzione
KILL 123;                                Chiude una connessione per ID
SHOW STATUS;                             Contatori del server
SHOW VARIABLES LIKE '%x%';               Valori di configurazione
SHOW ENGINES;                            Motori di archiviazione
SHOW WARNINGS;  SHOW ERRORS;             Problemi dell'ultima istruzione
SHOW GRANTS;                             I tuoi permessi
SHOW CHARACTER SET;  SHOW COLLATION;     Codifiche
SELECT VERSION();                        Versione del server
SELECT USER(), CURRENT_USER();           Chi sono
SELECT CONNECTION_ID();                  ID della connessione
SELECT ROW_COUNT();                      Righe toccate dall'ultima istruzione
SELECT LAST_INSERT_ID();                 Ultimo valore auto-increment
HELP 'SELECT';                           Aiuto integrato (client mysql)

-- information_schema: il catalogo si interroga come una tabella
SELECT table_name, table_rows FROM information_schema.tables
WHERE table_schema = 'sql_cheatsheet';
SELECT column_name, data_type, is_nullable FROM information_schema.columns
WHERE table_schema = 'sql_cheatsheet' AND table_name = 'employees';
SELECT constraint_name, constraint_type FROM information_schema.table_constraints
WHERE table_schema = 'sql_cheatsheet' AND table_name = 'employees';

Altri dialetti:
PG:  \l  \c db  \dt  \d t  \du  \q
SS:  sp_help 't';  sp_who;  SELECT * FROM sys.tables;
ORA: SELECT * FROM user_tables;  DESC t;


29. PRESTAZIONI
---------------
EXPLAIN SELECT * FROM employees WHERE dept_id = 1;
EXPLAIN FORMAT=JSON SELECT * FROM employees WHERE salary > 60000;
EXPLAIN ANALYZE SELECT * FROM employees e JOIN departments d USING (dept_id);
                                         -- MySQL 8.0.18+, ESEGUE la query

ANALYZE TABLE employees;                 Aggiorna le statistiche degli indici
OPTIMIZE TABLE employees;                Deframmenta / ricostruisce
CHECK TABLE employees;                   Controlla
REPAIR TABLE employees;                  Ripara (MyISAM e pochi altri)

SET profiling = 1;                       Deprecato: usa Performance Schema
SHOW PROFILES;
SHOW STATUS LIKE 'Slow_queries';
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;

Come leggere EXPLAIN:
type    dal migliore al peggiore: const, eq_ref, ref, range, index, ALL (scansione completa)
key     indice realmente usato (NULL = nessuno)
rows    righe stimate da leggere: meno è meglio
Extra   "Using filesort" e "Using temporary" sono campanelli d'allarme

Trucchi veloci:
- Indicizza le colonne di filtro e join.
- Seleziona solo le colonne che servono.
- Non usare funzioni su colonne indicizzate nel WHERE:
  WHERE YEAR(d) = 2024  ->  WHERE d >= '2024-01-01' AND d < '2025-01-01'
- Evita i caratteri jolly iniziali: LIKE '%x'.
- Per grandi paginazioni usa il metodo "keyset" invece di un OFFSET grande.
- Con sottoquery grandi, EXISTS è spesso meglio di IN.


30. IMPORT, EXPORT, BACKUP
--------------------------
-- Esporta in CSV (lato server: serve il privilegio FILE e la cartella di secure_file_priv)
SELECT * FROM employees
INTO OUTFILE '/var/lib/mysql-files/employees.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Importa da CSV (la tabella di destinazione deve esistere; il file di output non deve esistere già)
CREATE TABLE IF NOT EXISTS emp_copy LIKE employees;
LOAD DATA INFILE '/var/lib/mysql-files/employees.csv'
INTO TABLE emp_copy
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;                          -- salta l'intestazione
-- LOAD DATA LOCAL INFILE 'file.csv' ... -- file sul computer client (va abilitato)

SHOW VARIABLES LIKE 'secure_file_priv';

Da riga di comando (nel TERMINALE, non nel prompt SQL):

# Backup
mysqldump -u root -p sql_cheatsheet > backup.sql
mysqldump -u root -p --all-databases > tutto.sql
mysqldump -u root -p --no-data sql_cheatsheet > solo_schema.sql
mysqldump -u root -p --routines --triggers --events sql_cheatsheet > completo.sql
mysqldump -u root -p sql_cheatsheet employees departments > due_tabelle.sql

# Ripristino
mysql -u root -p sql_cheatsheet < backup.sql
mysql -u root -p -e "source backup.sql"

# Eseguire una query dalla shell
mysql -u root -p -e "SELECT COUNT(*) FROM sql_cheatsheet.employees"

# PostgreSQL
pg_dump -U postgres mydb > backup.sql
psql -U postgres mydb < backup.sql


31. PARTIZIONAMENTO
-------------------
CREATE TABLE sales (
    sale_id   INT NOT NULL AUTO_INCREMENT,
    sale_date DATE NOT NULL,
    amount    DECIMAL(10,2),
    PRIMARY KEY (sale_id, sale_date)     -- la chiave di partizione deve stare in ogni chiave unica
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
ALTER TABLE sales DROP PARTITION p2023;       -- elimina subito i dati di quella partizione
ALTER TABLE sales TRUNCATE PARTITION p2024;
SELECT partition_name, table_rows FROM information_schema.partitions WHERE table_name = 'sales';
DROP TABLE sales;

Tipi di partizione:
RANGE   per intervalli di valori (date, id)
LIST    per elenchi espliciti (VALUES IN (1,2,3))
HASH    hash di un'espressione (distribuzione uniforme)
KEY     hash interno di MySQL su una o più colonne


32. TIPI DI DATO
----------------
Interi:           TINYINT (1 byte), SMALLINT (2), MEDIUMINT (3), INT (4), BIGINT (8);
                  aggiungi UNSIGNED per solo non negativi
Decimali esatti:  DECIMAL(p,s) / NUMERIC(p,s)  -> da usare per il denaro
Approssimati:     FLOAT, DOUBLE
Booleano:         BOOLEAN / BOOL (alias di TINYINT(1)); PG ha un vero BOOLEAN; SS: BIT
Testo fisso:      CHAR(n)
Testo variabile:  VARCHAR(n), TINYTEXT, TEXT, MEDIUMTEXT, LONGTEXT
Binari:           BINARY(n), VARBINARY(n), famiglia BLOB
Data / ora:       DATE, TIME, DATETIME, TIMESTAMP, YEAR
Altri:            ENUM('a','b'), SET('x','y'), JSON, BIT(n), POINT, GEOMETRY

Prova:
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

Equivalenze tra dialetti:
                MySQL            PostgreSQL                      SQL Server    Oracle
ID automatico   AUTO_INCREMENT   SERIAL / GENERATED AS IDENTITY  IDENTITY(1,1) GENERATED AS IDENTITY
Testo lungo     TEXT             TEXT                            VARCHAR(MAX)  CLOB
Intero          INT              INTEGER                         INT           NUMBER(10)
Data e ora      DATETIME         TIMESTAMP                       DATETIME2     TIMESTAMP
Stringa         VARCHAR          VARCHAR                         NVARCHAR      VARCHAR2


33. DIFFERENZE TRA DIALETTI
---------------------------
Limitare le righe:    MySQL LIMIT n | PG LIMIT n | SS TOP n / OFFSET FETCH | ORA FETCH FIRST n ROWS ONLY
Concatenare:          MySQL CONCAT() | PG || | SS + o CONCAT() | ORA ||
Ora attuale:          MySQL NOW() | PG NOW() | SS GETDATE() | ORA SYSDATE
Predefinito per NULL: MySQL IFNULL | PG COALESCE | SS ISNULL | ORA NVL
Lunghezza stringa:    MySQL LENGTH | PG LENGTH | SS LEN | ORA LENGTH
ID automatico:        MySQL AUTO_INCREMENT | PG SERIAL | SS IDENTITY | ORA IDENTITY / sequenza
Upsert:               MySQL ON DUPLICATE KEY UPDATE | PG ON CONFLICT DO UPDATE | SS MERGE | ORA MERGE
Full outer join:      MySQL simulato con UNION | PG, SS, ORA supportato
Differenza insiemi:   MySQL EXCEPT (8.0.31+) | PG EXCEPT | SS EXCEPT | ORA MINUS
Unire valori:         MySQL GROUP_CONCAT | PG STRING_AGG | SS STRING_AGG | ORA LISTAGG
Nomi tra virgolette:  MySQL `nome` | PG "nome" | SS [nome] | ORA "nome"
Mostra tabelle:       MySQL SHOW TABLES | PG \dt | SS sys.tables | ORA user_tables
Formato data:         MySQL DATE_FORMAT | PG TO_CHAR | SS FORMAT | ORA TO_CHAR
Booleano:             MySQL TINYINT(1) | PG BOOLEAN | SS BIT | ORA NUMBER(1)
Restituire la riga:   MySQL no | PG RETURNING | SS OUTPUT | ORA RETURNING INTO
Senza maiuscole:      MySQL collation predefinita | PG ILIKE | SS collation predefinita | ORA UPPER()


34. ORDINE DI ESECUZIONE E CATEGORIE DI COMANDI
-----------------------------------------------
Ordine LOGICO in cui il database esegue una query:
 1. FROM / JOIN      sceglie e combina le tabelle
 2. WHERE            filtra le righe
 3. GROUP BY         crea i gruppi
 4. HAVING           filtra i gruppi
 5. SELECT           calcola colonne e alias
 6. DISTINCT         toglie i duplicati
 7. Funzioni finestra
 8. ORDER BY         ordina (può usare gli alias)
 9. LIMIT / OFFSET   riduce il risultato

Per questo NON puoi usare un alias del SELECT nel WHERE (non esiste ancora),
ma puoi usarlo nell'ORDER BY. MySQL lo permette anche in GROUP BY e HAVING.

Categorie di comandi:
DDL  Definizione dei dati     CREATE  ALTER  DROP  TRUNCATE  RENAME
DML  Manipolazione dei dati   INSERT  UPDATE  DELETE  MERGE  REPLACE
DQL  Interrogazione           SELECT
DCL  Controllo accessi        GRANT  REVOKE
TCL  Controllo transazioni    COMMIT  ROLLBACK  SAVEPOINT  START TRANSACTION

Chiavi:
Chiave primaria     Unica e non nulla, identifica la riga (una per tabella)
Chiave esterna      Punta alla chiave primaria/unica di un'altra tabella
Chiave unica        Nessun duplicato (i NULL sono ammessi)
Chiave composta     Chiave fatta da 2 o più colonne
Chiave candidata    Qualsiasi insieme di colonne che potrebbe essere la chiave primaria
Chiave surrogata    ID artificiale (es. AUTO_INCREMENT)

DELETE, TRUNCATE e DROP:
                         DELETE             TRUNCATE                  DROP
Cosa elimina             righe scelte       tutte le righe            l'intera tabella
WHERE                    sì                 no                        no
Azzera auto-increment    no                 sì                        non si applica
Attiva i trigger         sì                 no                        no
Annullabile (rollback)   sì                 no in MySQL (sì in PG/SS) no in MySQL
Tipo                     DML                DDL                       DDL


=====================================================
Fine. Buono studio con l'SQL!
