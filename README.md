# 🚀 SQL-DATA-LAB

A hands-on SQL learning lab, from first `SELECT` to indexing, transactions and data warehousing concepts. Every topic has runnable **T-SQL (SQL Server)** code, and a practice section at the end lets you test yourself.

> **Dialect:** T-SQL (SQL Server 2016 SP1 or newer). Most querying topics also work in PostgreSQL and MySQL; differences are listed in [Dialect cheat sheet](#dialect-cheat-sheet).

---

## Table of contents

- [Quick start](#quick-start)
- [Repository structure](#repository-structure)
- [Sample database](#sample-database)
- [1. Fundamentals](#1-fundamentals)
- [2. Querying data](#2-querying-data)
- [3. Advanced querying](#3-advanced-querying)
- [4. Programmability](#4-programmability)
- [5. Performance and indexing](#5-performance-and-indexing)
- [6. Transactions and concurrency](#6-transactions-and-concurrency)
- [7. Data modeling and architecture](#7-data-modeling-and-architecture)
- [8. Security](#8-security)
- [9. Extra topics with examples](#9-extra-topics-with-examples)
- [10. Common pitfalls](#10-common-pitfalls)
- [Dialect cheat sheet](#dialect-cheat-sheet)
- [11. Practice questions](#11-practice-questions)
- [Learning roadmap](#learning-roadmap)
- [Contributing and license](#contributing-and-license)

---

## Quick start

**Requirements:** SQL Server 2016 SP1+ (Developer or Express edition is free) and SQL Server Management Studio (SSMS) or Azure Data Studio.

1. Clone the repo:
   ```bash
   git clone https://github.com/Aman-Code-Lab/SQL-DATA-LAB.git
   ```
2. Open `scripts/master_sql_commands.sql` in SSMS.
3. Run the whole script (**F5**). It creates the `TechCorpDB` database, loads sample data and runs every module.
4. The script is **re-runnable**: it drops and recreates its tables each time.
5. To study one topic, run only that module. Each module starts with a banner comment such as `MODULE 05`.

---

## Repository structure

```text
SQL-DATA-LAB/
├── README.md                      <- you are here
└── scripts/
    └── master_sql_commands.sql    <- 17 runnable modules (see table below)
```

| Script module | Topic | Section in this README |
|---|---|---|
| 01 | Database and schema management (DDL) | [1](#1-fundamentals) |
| 02 | Insert, update, delete (DML) | [1](#1-fundamentals) |
| 03 | Filtering and wildcards | [2](#2-querying-data) |
| 04 | Aggregates and grouping | [2](#2-querying-data) |
| 05 | Joins (all variants) | [2](#2-querying-data) |
| 06 | Subqueries | [2](#2-querying-data) |
| 07 | Built-in functions and `CASE` | [2](#2-querying-data) |
| 08 | Window functions | [3](#3-advanced-querying) |
| 09 | CTEs (standard and recursive) | [3](#3-advanced-querying) |
| 10 | Set operators | [3](#3-advanced-querying) |
| 11 | Procedures, functions, triggers | [4](#4-programmability) |
| 12 | Transaction control | [6](#6-transactions-and-concurrency) |
| 13 | Indexing and sargability | [5](#5-performance-and-indexing) |
| 14 | `MERGE` (upsert) | [9](#9-extra-topics-with-examples) |
| 15 | `PIVOT` | [9](#9-extra-topics-with-examples) |
| 16 | Cursors | [4](#4-programmability) |
| 17 | JSON | [9](#9-extra-topics-with-examples) |

Topics in this README that are **not yet in the script** (views, security, temp tables, temporal tables, `UNPIVOT`, XML, full-text search, pagination, `ROLLUP`, dynamic SQL) include their own runnable examples in [section 9](#9-extra-topics-with-examples).

---

## Sample database

All examples use **TechCorpDB**, created by the script:

| Table | Columns (key ones) | Notes |
|---|---|---|
| `Departments` | `DeptID` (PK), `DeptName` (unique), `Location` | 4 departments |
| `Employees` | `EmpID` (PK, starts at 101), `FirstName`, `LastName`, `Email`, `Salary`, `Age`, `DeptID` (FK), `ManagerID` (self-FK), `HireDate`, `IsActive` | 6 employees, includes one top-level manager and one employee with no department |
| `Orders` | `OrderID` (PK, starts at 1001), `EmpID` (FK), `OrderDate`, `TotalAmount`, `Status` | `ON DELETE CASCADE` from `Employees` |
| `AuditLog` | `LogID`, `ActionDescription`, `LoggedAt` | filled by a trigger |

---

## 1. Fundamentals

- **RDBMS basics:** data lives in tables (rows and columns) linked by keys. Benefits: structure, integrity, concurrent access, and powerful querying.
- **System databases (SQL Server):** `master` (server configuration and logins), `model` (template for new databases), `msdb` (SQL Agent jobs, backups history), `tempdb` (temporary objects; recreated on every restart).
- **SQL command categories:**

| Category | Purpose | Examples |
|---|---|---|
| DDL | Define structure | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| DML | Change data | `INSERT`, `UPDATE`, `DELETE`, `MERGE` |
| DQL | Read data | `SELECT` |
| DCL | Permissions | `GRANT`, `REVOKE`, `DENY` |
| TCL | Transactions | `BEGIN TRAN`, `COMMIT`, `ROLLBACK`, `SAVE TRAN` |

- **Common data types:** numeric (`INT`, `BIGINT`, `DECIMAL(p,s)`), text (`CHAR`, `VARCHAR`, `NVARCHAR` for Unicode), date/time (`DATE`, `DATETIME2`), and `BIT`, `VARBINARY`. Choose the smallest type that fits your data.
- **Constraints:** `NOT NULL`, `UNIQUE`, `PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `DEFAULT`, and `IDENTITY` for auto-increment.
- **Operators:** arithmetic, comparison (`=`, `<>`, `!=`), logical (`AND`, `OR`, `NOT`), and special (`LIKE`, `BETWEEN`, `IN`, `EXISTS`).

> 📂 Script: Modules **01** and **02**. 

---

## 2. Querying data

**Logical processing order** (not the order you type it):

```text
FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> TOP / OFFSET-FETCH
```

This is why you can use a column alias in `ORDER BY` but not in `WHERE`.

- **Filtering:** `WHERE` filters rows before grouping; `HAVING` filters groups after aggregation.
- **Aggregates:** `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`. Aggregates ignore `NULL` (except `COUNT(*)`).
- **Joins:**

| Join | Returns |
|---|---|
| `INNER` | Only matching rows from both tables |
| `LEFT` | All rows from the left table, matches from the right (else `NULL`) |
| `RIGHT` | All rows from the right table, matches from the left |
| `FULL OUTER` | All rows from both tables |
| `CROSS` | Every combination (N x M rows) |
| Self join | A table joined to itself, e.g. employee to manager |

- **Subqueries:** scalar (one value), multi-row (`IN`, `ANY`, `ALL`), and correlated (references the outer query; uses `EXISTS` / `NOT EXISTS`).
- **Wildcards:** `%` (any characters) and `_` (exactly one character).
- **Functions:** string (`UPPER`, `SUBSTRING`, `CHARINDEX`, `REPLACE`, `CONCAT`), math (`ROUND`, `FLOOR`, `CEILING`, `ABS`), dates (`GETDATE`, `DATEDIFF`, `DATEADD`, `DATEPART`), and `NULL` handling (`ISNULL`, `COALESCE`, `NULLIF`).

```sql
SELECT FirstName,
       CASE WHEN Salary >= 100000 THEN 'Executive'
            WHEN Salary >= 60000  THEN 'Mid-Level'
            ELSE 'Associate' END AS CompensationBand
FROM Employees;
```

> 📂 Script: Modules **03** to **07**.

---

## 3. Advanced querying

### Window functions

Calculate across related rows **without collapsing them** like `GROUP BY` does.

| Function | Behavior |
|---|---|
| `ROW_NUMBER()` | Unique sequential number per partition |
| `RANK()` | Ties share a rank, then a gap (1, 2, 2, 4) |
| `DENSE_RANK()` | Ties share a rank, no gap (1, 2, 2, 3). Useful for "Nth highest salary" |
| `NTILE(n)` | Splits rows into `n` equal buckets (quartiles, deciles) |
| `LAG()` / `LEAD()` | Value from the previous / next row |
| `FIRST_VALUE()` / `LAST_VALUE()` | First / last value in the window frame |
| `SUM() OVER (... ROWS BETWEEN ...)` | Running totals and moving averages |

```sql
SELECT FirstName, DeptID, Salary,
       DENSE_RANK() OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS DeptRank,
       AVG(Salary) OVER (ORDER BY HireDate
                         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM Employees;
```

### Common Table Expressions (CTEs)

- **Standard CTE:** turns nested subqueries into readable, named steps.
- **Recursive CTE:** walks hierarchies such as manager to employee, folders, or bills of materials. It needs an anchor member, `UNION ALL`, and a recursive member.

### Set operators

| Operator | Result |
|---|---|
| `UNION` | Combined rows, duplicates removed |
| `UNION ALL` | Combined rows, duplicates kept (faster) |
| `INTERSECT` | Rows present in both queries |
| `EXCEPT` (`MINUS` in Oracle) | Rows in the first query but not the second |

All queries in a set operation need the same number of columns with compatible types.

> 📂 Script: Modules **08**, **09**, **10**.

---

## 4. Programmability

- **Stored procedures:** reusable, parameterized logic with input/output parameters, `IF/ELSE`, loops and `TRY/CATCH`. Execution plans are cached, and **using parameters (not string concatenation) protects against SQL injection**. Avoid the `sp_` name prefix, which is reserved for system procedures; use `usp_`.
- **User-defined functions:** *scalar* functions return one value; *table-valued* functions return a table. Scalar UDFs can be slow on large tables.
- **Triggers:** run automatically on DML. `AFTER` triggers suit audit logging; `INSTEAD OF` triggers override inserts/updates, often on views. Inside a trigger, the `inserted` and `deleted` tables hold the new and old rows.
- **Cursors:** process rows one at a time: `DECLARE` -> `OPEN` -> `FETCH NEXT` (loop) -> `CLOSE` -> `DEALLOCATE`. Prefer **set-based** queries: the optimizer handles whole sets efficiently, while cursors are slow and hold resources. Use cursors only for administrative tasks or row-by-row procedure calls.

```sql
EXEC usp_GetDepartmentPayroll @DepartmentID = 1, @TotalPayroll = @Payroll OUTPUT;
```

> 📂 Script: Modules **11** and **16**.

---

## 5. Performance and indexing

- **Clustered index:** defines the physical row order. One per table (the primary key by default).
- **Non-clustered index:** a separate structure with pointers to rows. Many allowed.
- **Composite index:** column order matters. Put the column you filter by equality first. An index on `(DeptID, Salary)` also serves queries on `DeptID` alone, so a separate `DeptID` index is redundant.
- **Covering index:** `INCLUDE` extra columns so the query never needs a **Key Lookup**.
- **Seek vs scan:** an *Index Seek* jumps straight to rows (good). A *Scan* reads everything (fine for small tables, a warning sign on large ones).
- **Join algorithms:** Nested Loops (small/indexed inputs), Hash Match (large unsorted inputs), Merge Join (large pre-sorted inputs).
- **Sargable queries:** do not wrap an indexed column in a function.

```sql
-- ❌ Non-sargable: function on the column forces a scan
SELECT * FROM Employees WHERE YEAR(HireDate) = 2022;

-- ✅ Sargable: the index can seek
SELECT * FROM Employees
WHERE HireDate >= '2022-01-01' AND HireDate < '2023-01-01';
```

**Measure, don't guess:**

```sql
SET STATISTICS IO ON;    -- logical reads per table
SET STATISTICS TIME ON;  -- CPU and elapsed time
-- In SSMS: Ctrl+M = include actual execution plan, Ctrl+L = estimated plan
```

> 📂 Script: Module **13**.

---

## 6. Transactions and concurrency

- **ACID:** Atomicity (all or nothing), Consistency (constraints hold), Isolation (concurrent safety), Durability (survives crashes via the write-ahead log).
- **T-SQL commands:** `BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`, and `SAVE TRANSACTION name` + `ROLLBACK TRANSACTION name` for savepoints (T-SQL does not use the `SAVEPOINT` keyword).
- **Safe pattern:**

```sql
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    -- your changes here
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;   -- re-raise the original error
END CATCH;
```

- **Isolation levels:**

| Level | Dirty read | Non-repeatable read | Phantom read |
|---|---|---|---|
| `READ UNCOMMITTED` | Possible | Possible | Possible |
| `READ COMMITTED` (default) | No | Possible | Possible |
| `REPEATABLE READ` | No | No | Possible |
| `SERIALIZABLE` | No | No | No |
| `SNAPSHOT` / RCSI | No | No | No (row-versioning, readers don't block writers) |

- **Deadlock prevention:** access tables in the same order in every transaction, keep transactions short, and index the columns you filter on.

> 📂 Script: Module **12**.

---

## 7. Data modeling and architecture

- **Normalization:**
  - **1NF:** atomic values, no repeating groups.
  - **2NF:** 1NF + no partial dependency on part of a composite key.
  - **3NF:** 2NF + no transitive dependency (`A -> B -> C`).
  - **BCNF:** every determinant is a candidate key.
- **OLTP vs OLAP:** OLTP is normalized and write-heavy (orders, payments). OLAP is denormalized and read-heavy (reports, dashboards).
- **Dimensional modeling:** *fact tables* hold measurable events (sales amount, units); *dimension tables* hold context (customer, product, date). A **star schema** keeps dimensions flat; a **snowflake schema** normalizes them further.
- **Partitioning:** *horizontal* splits rows (by date or tenant) so queries can skip partitions; *vertical* moves rarely used heavy columns to another table.
- **Sharding and replication:** sharding spreads data across servers by key; read replicas move reporting load away from the primary.

---

## 8. Security

- **Login vs user:** a *login* authenticates to the server; a *user* is that identity inside one database.
- **Roles:** fixed roles such as `db_datareader`, `db_datawriter`, `db_owner`, plus custom roles. Grant to roles, not individuals.
- **Permissions:** `GRANT` allows, `REVOKE` removes a grant or deny, and `DENY` blocks and **overrides** any grant.
- **Dynamic Data Masking:** hides sensitive values for non-privileged users in query results.
- **Row-Level Security:** SQL Server has a native feature (`CREATE SECURITY POLICY`) for filtering rows per user. Views can limit columns and rows too, but are not a complete security boundary on their own.

```sql
CREATE USER ReportUser WITHOUT LOGIN;           -- demo user, no server login
GRANT  SELECT ON vw_EmployeeDirectory TO ReportUser;
DENY   SELECT ON dbo.Employees (Salary) TO ReportUser;   -- column-level block
REVOKE SELECT ON vw_EmployeeDirectory FROM ReportUser;
```

---

## 9. Extra topics with examples

All examples run against `TechCorpDB` after the main script.

### Views

A view is a **saved query**, not pre-computed data (unless indexed). Use it to simplify joins and expose only selected columns.

```sql
GO
CREATE OR ALTER VIEW vw_EmployeeDirectory AS
SELECT e.EmpID, e.FirstName, e.LastName, d.DeptName
FROM Employees e
LEFT JOIN Departments d ON e.DeptID = d.DeptID;
GO
SELECT * FROM vw_EmployeeDirectory;
```

A view is updatable when it maps to one base table without aggregates or `DISTINCT`.

### Temporary storage

```sql
-- Local temp table: visible to your session, dropped when it ends
SELECT EmpID, FirstName, Salary
INTO #HighEarners
FROM Employees
WHERE Salary > 90000;

-- Global temp table (##Name): visible to all sessions until the last one disconnects

-- Table variable: scoped to the batch; stored in tempdb, best for small row counts
DECLARE @Recent TABLE (EmpID INT, HireDate DATE);
INSERT INTO @Recent
SELECT EmpID, HireDate FROM Employees WHERE HireDate >= '2023-01-01';
```

### Pagination

```sql
SELECT EmpID, FirstName, LastName
FROM Employees
ORDER BY EmpID
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;   -- page 1, 3 rows per page
```

### Subtotals with `ROLLUP`

```sql
SELECT DeptID, COUNT(*) AS Headcount, SUM(Salary) AS Payroll
FROM Employees
GROUP BY ROLLUP (DeptID);               -- extra row = grand total
-- Also see CUBE and GROUPING SETS
```

### Combining text: `STRING_AGG` (SQL Server 2017+)

```sql
SELECT DeptID, STRING_AGG(FirstName, ', ') AS Members
FROM Employees
WHERE DeptID IS NOT NULL
GROUP BY DeptID;
```

### Upsert with `MERGE`

`MERGE` compares a target to a source in one statement: `WHEN MATCHED THEN UPDATE`, `WHEN NOT MATCHED BY TARGET THEN INSERT`, `WHEN NOT MATCHED BY SOURCE THEN DELETE`. Add `WITH (HOLDLOCK)` on the target to avoid race conditions. Note that an `IDENTITY` key is generated by the database, so you cannot choose it from the source. (Module **14**.)

### `PIVOT` and `UNPIVOT`

`PIVOT` turns row values into columns (Module **15**). `UNPIVOT` does the reverse:

```sql
SELECT EmpID, Metric, Value
FROM (SELECT EmpID,
             CAST(Salary AS DECIMAL(12,2)) AS Salary,
             CAST(Age    AS DECIMAL(12,2)) AS Age
      FROM Employees) AS src
UNPIVOT (Value FOR Metric IN (Salary, Age)) AS u;
```

For a variable list of pivot columns, build the query with **dynamic SQL**.

### Dynamic SQL, safely

```sql
DECLARE @sql NVARCHAR(MAX) = N'SELECT * FROM Employees WHERE DeptID = @Dept';
EXEC sp_executesql @sql, N'@Dept INT', @Dept = 1;   -- parameterized: injection-safe
```

Never build queries by concatenating user input into the string.

### Error handling with `THROW`

```sql
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmpID = 999)
        THROW 50001, 'Employee 999 was not found.', 1;
END TRY
BEGIN CATCH
    PRINT ERROR_NUMBER();
    PRINT ERROR_MESSAGE();
END CATCH;
```

### JSON and XML

```sql
-- Rows -> JSON
SELECT EmpID, FirstName FROM Employees FOR JSON PATH, ROOT('Employees');

-- JSON -> rows
SELECT * FROM OPENJSON(N'[{"id":1,"name":"Asha"}]')
WITH (id INT '$.id', name VARCHAR(50) '$.name');

-- Single values
SELECT JSON_VALUE(N'{"city":"Pune"}', '$.city');

-- XML -> rows
DECLARE @x XML = N'<emps><emp id="1"><name>Asha</name></emp></emps>';
SELECT n.value('@id', 'INT') AS EmpID,
       n.value('(name)[1]', 'VARCHAR(50)') AS Name
FROM @x.nodes('/emps/emp') AS t(n);
```

### System-versioned temporal tables

SQL Server keeps full row history automatically.

```sql
CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
    ValidTo   DATETIME2 GENERATED ALWAYS AS ROW END   HIDDEN,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ProductsHistory));

-- What did the table look like at a point in time?
SELECT * FROM dbo.Products FOR SYSTEM_TIME AS OF '2026-01-01T00:00:00';
```

**Slowly Changing Dimensions (data warehousing):**

| Type | Behavior |
|---|---|
| 0 | Value never changes (e.g. original birth date) |
| 1 | Overwrite the old value, no history |
| 2 | Add a new row with validity dates and an active flag (full history) |
| 3 | Keep the previous value in an extra column (one level of history) |

### Full-text search

A standard B-tree index cannot speed up `LIKE '%word%'`. A full-text index tokenizes words, ignores stop-words, and supports linguistic matching.

```sql
-- One-time setup (needs the Full-Text Search feature installed)
CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;
-- CREATE FULLTEXT INDEX ON Employees(FirstName) KEY INDEX <your_primary_key_index_name>;

SELECT * FROM Employees WHERE CONTAINS(FirstName, 'Aman');       -- exact/inflected terms
SELECT * FROM Employees WHERE FREETEXT(FirstName, 'Aman');       -- natural-language match
```

> 📂 Script: Modules **14**, **15**, **17**.

---

## 10. Common pitfalls

| Mistake | Why it hurts | Fix |
|---|---|---|
| `WHERE col = NULL` | Comparing to `NULL` is never true | `WHERE col IS NULL` |
| `NOT IN (subquery)` where the subquery can return `NULL` | Returns no rows | Use `NOT EXISTS` |
| `SELECT *` in production code | Extra I/O, breaks on schema change, blocks covering indexes | List needed columns |
| Function on an indexed column in `WHERE` | Index scan instead of seek | Rewrite as a range (sargable) |
| Missing `ORDER BY` with `TOP` or `OFFSET` | Row order is undefined | Always add `ORDER BY` |
| `DATEDIFF(YEAR, a, b)` for age or tenure | Counts year boundaries, not full years | Adjust for the anniversary (see Module 07) |
| Naming procedures `sp_...` | Reserved prefix; SQL Server checks `master` first | Use `usp_` |
| Cursor for a job a single `UPDATE` can do | Slow, holds locks | Use a set-based s
