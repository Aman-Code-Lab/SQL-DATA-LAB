# 🚀 SQL-DATA-LAB

## basic concept of SQL 

**•👋 Introduction to SQL & RDBMS:** Core relational modeling rules, database advantages, and organizing unstructured data into structured Tables, Rows, and Columns.

**•⚙️🛢️ System Databases:** Understanding the native, pre-installed engine databases essential for SQL Server management: master, model, msdb, and tempdb.

**• ⌨️⚡SQL Commands Classification:** Deep-dive configuration into the structural statement categories: DDL, DML, DQL, DCL, and TCL.

**• 🛢️📜Database & Table Management:** Primary administrative storage mechanics including the instantiation and destruction of components using CREATE, ALTER, and DROP statements.

**•🔢 SQL Data Types:** Choosing optimal byte sizes for accurate storage indexing: Numeric (INT, BIGINT, DECIMAL), String (CHAR, VARCHAR, NVARCHAR), Date & Time, and Binary variants.

**•📦 Data Constraints:** Hardcoded gatekeeper validation checks to block garbage input values: NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT, and IDENTITY (Auto-increment).

**• 🛢️🔍🔀 SQL Operators:** Computational mathematical and filtration expression operators: Arithmetic, Comparison (=, !=, <>), Logical (AND, OR, NOT), and Special Operators (LIKE, BETWEEN, IN, EXISTS).

# ⚡ Advanced SQL Queries

This functional query-building layer deals with parsing, filtering, and running complex analytical workflows across multi-layered business metrics:

* 🧩 **SQL Clauses:** Segmenting database operations using precise condition evaluation modifiers: `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, and `TOP` / `LIMIT`.
* 🔄 **Logical Order of Query Evaluation:** Mastering the exact algorithmic phase-sequence the SQL compilation engine utilizes back-end to parse query tokens (e.g., executing `FROM` and `WHERE` before evaluating `SELECT`).
* 📊 **Aggregate Functions:** Performing cross-row vector calculations to extract localized statistical summaries: `COUNT()`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`.
* 🔗 **Joins (Critical Core Skill):** Merging multiple distinct tables together across overlapping validation records using `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `FULL OUTER JOIN` structures.
* 📦 **Subqueries & Nested Statements:** Compiling and embedding complete internal query expressions inside parent operation statements.
* ⚙️ **Built-in Functions:** Formatting data variables directly on the server layer using standard scalar, mathematical, string, and date utility functions.
* 🔍 **SQL Wildcards & Pattern Scanning:** Utilizing fluid text token characters (such as `%` or `_`) to search through wide text columns.
* 🛡️ **SQL Transactions:** Safeguarding transaction durability, consistency, and isolation using structural recovery boundaries: `COMMIT`, `ROLLBACK`, and `SAVEPOINT`.

# 🔗 Multi-Table Relational Modeling & Joins Architecture

Relational databases mein normalized schemas se analytical views aur unified records construct karne ke liye multi-table integration layer:

* 🔀 **Relational Integrity & Join Predicates:** Primary Key to Foreign Key association matrix rules jo relational normalization form (1NF to 3NF) maintain karti hain.
* 🎯 **INNER JOIN:** Emitting strictly intersected records where foreign key equals referenced primary key (`ON a.id = b.id`), filtering non-matching orphan rows.
* ⬅️ **LEFT (OUTER) JOIN:** Complete preservation of base/parent driving dataset (`FROM Table_A`) while projecting matched attributes from secondary tables, substituting absent attributes with persistent `NULL` states.
* ➡️ **RIGHT (OUTER) JOIN:** Inverse outer persistence prioritized towards the dependent dataset, maintaining lookup tables with optional parent linkages.
* 🌐 **FULL OUTER JOIN:** Dual-directional union-style join extracting both matched and unmatched entities across both sides for reconciling database audit mismatches.
* ✖️ **CROSS JOIN (Cartesian Product):** Unconstrained matrix permutation producing $N \times M$ output rows, used in creating master planning templates, calendar schedules, and product SKU variations.
* 🔄 **SELF JOIN:** Unary hierarchical referencing where a table joins against its own alias schema (essential for Manager-Employee hierarchy trees, assembly bill-of-materials, and sequential log tracking).

---

# 📦 Advanced Filtering, Grouping & Subqueries

Analytical metrics aggregation aur complex conditional partitioning ke core mechanisms:

* 🗂️ **Multi-Column GROUP BY & Aggregation:** Structuring dimensional cubes across non-aggregated categorical variables paired with statistical vectors (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`).
* ⚖️ **Execution Boundary: WHERE vs. HAVING:** Enforcing strict pre-aggregation filtering via index-compatible `WHERE` vs. post-aggregation partition pruning via `HAVING`.
* 📥 **Scalar Subqueries:** Single-value returning internal expressions evaluated dynamically within `SELECT`, `WHERE`, or conditional assignment pipelines.
* 📋 **Multi-Row Subqueries:** Evaluating list arrays using vectorized predicate operators: `IN`, `NOT IN`, `ANY`, `ALL`, aur boolean presence via `EXISTS` / `NOT EXISTS`.
* 🔁 **Correlated Subqueries:** Row-by-row context-dependent subqueries referencing attributes from outer parent loops, executing dynamically per candidate row.

---

# 🛠️ Built-in Functions & Procedural Transformations

Server-side dynamic data cleanup, type casting, mathematical operations, aur conditional logic:

* 🔤 **String Manipulation Engine:** Transforming raw user input and text records via `UPPER()`, `LOWER()`, `SUBSTRING()`, `CONCAT()`, `LTRIM()`, `RTRIM()`, `CHARINDEX()`, aur `REPLACE()`.
* 📐 **Mathematical & Rounding Functions:** Precision management in financial ledgers using `ROUND()`, `FLOOR()`, `CEILING()`, `ABS()`, aur `POWER()`.
* 📅 **Date & Time Pipelines:** Managing timestamps, retention limits, and SLA intervals using `GETDATE()`, `DATEDIFF()`, `DATEADD()`, `DATEPART()`, aur `DATENAME()`.
* 🔀 **Conditional Business Logic (`CASE WHEN`):** Embedded runtime branching enabling dynamic segmentations, pivot-style reporting, and categorizations directly inside projections:
```sql
CASE 
    WHEN salary >= 100000 THEN 'Executive Tier'
    WHEN salary >= 60000  THEN 'Mid-Level Tier'
    ELSE 'Associate Tier'
END AS compensation_band

```


* 🛡️ **Null Handling & Defensiveness:** Preventing downstream application runtime errors via `ISNULL()`, `COALESCE()`, aur `NULLIF()`.

---

# 👁️ Views, Security & Physical Storage Abstraction

Production databases mein tables ko directly expose na karke secure, high-performance interfaces build karna:

* 🪟 **Standard Views (`CREATE VIEW`):** Pre-compiled query wrappers simplifying complex nested joins for reporting analysts while preserving strict table schema opacity.
* 🔐 **Row & Column-Level Security via Views:** Restricting direct access to sensitive payroll, PII, and financial attributes by exposing only filtered slices of tables.
* 📑 **Updatable Views:** Managing direct write-back transactions into underlying base tables adhering to view modification rules (single-table mutations without aggregate interference).

---

# 🛡️ Transaction Control & Database Integrity (ACID Mechanics)

High-concurrency e-commerce aur financial ledger consistency boundaries:

* ⚛️ **ACID Architecture:** Enforcing Atomicity (all-or-nothing), Consistency (rules/constraints check), Isolation (concurrent safety), and Durability (WAL logging).
* 🚦 **Boundary Execution (`BEGIN TRAN`, `COMMIT`, `ROLLBACK`):** Explicit transaction demarcation preventing partial batch commits during runtime network or software crashes.
* 📍 **Savepoint Recovery (`SAVEPOINT`):** Setting granular rollback checkpoints inside complex long-running business workflows to undo isolated exceptions without voiding entire transactions.

---

