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

# 🪟 Advanced Analytical Window Functions & CTEs

High-volume reporting, moving trends, aur hierarchical dataset processing ke liye advanced analytical engines:

* 🪟 **Window Architecture (`OVER` Clause):** Row-level detail maintain karte hue aggregate aur analytic calculations perform karna (raw records ko `GROUP BY` ki tarah collapse kiye bina):
* `PARTITION BY`: Data ko logical segments ya categories mein divide karna.
* `ORDER BY`: Window frame ke andar calculation sequence enforce karna.
* `ROWS / RANGE BETWEEN`: Moving averages aur cumulative running totals ke liye dynamic sliding boundaries define karna.


* 🥇 **Ranking & Distribution Functions:**
* `ROW_NUMBER()`: Partition ke andar har record ko unique, continuous sequential integer allocate karna.
* `RANK()`: Tied values par same rank assign karna, aur next rank par gap/skip generate karna (e.g., 1, 2, 2, 4).
* `DENSE_RANK()`: Tied values par same rank assign karna bina koi next rank skip kiye (e.g., 1, 2, 2, 3) — top Nth salary/performance analysis ke liye essential.
* `NTILE(n)`: Distribution profiling aur quartile/decile cohort segmentation ke liye records ko equal buckets mein divide karna.


* 🧭 **Value & Navigation Functions:**
* `LEAD()` & `LAG()`: Self-join use kiye bina current row se agle ya pichle row ki value access karna (MoM revenue growth aur churn time-deltas calculate karne ke liye).
* `FIRST_VALUE()` & `LAST_VALUE()`: Partition window ke boundary reference points retrieve karna.


* 🧱 **Common Table Expressions (CTEs - `WITH` Clause):**
* **Standard CTEs:** Unreadable nested subqueries ko modular, reusable, named temporary result sets mein simplify karna.
* **Recursive CTEs:** Multi-level organizational charts (Employee-Manager hierarchy), folder structures, aur graph dependency trees traverse karne ke liye iterative self-referencing queries.


* 🔀 **Set Theory Operators:**
* `UNION` vs `UNION ALL`: Duplicate removal overhead ke sath combine karna vs bina deduplication overhead ke fast set appending.
* `INTERSECT`: Multiple queries mein strictly common projection rows extract karna.
* `EXCEPT` / `MINUS`: Pehle query dataset se second query dataset ke common records filter/prune karna.



---

# ⚙️ Database Programmability & Procedural Objects

Business workflows encapsulate karne aur database server par directly procedural logic compile/execute karne ke mechanics:

* 📜 **Stored Procedures (`CREATE PROCEDURE`):**
* Pre-compiled execution plans, input/output parameter binding, execution plan caching, aur dynamic SQL injection protection.
* Procedural control structures: `IF...ELSE`, loops, try-catch exception handling blocks, aur custom transactional rollbacks.


* 🛠️ **User-Defined Functions (UDFs):**
* **Scalar Functions:** Calculated transformations return karne wale deterministic reusable algorithms.
* **Table-Valued Functions (TVFs):** Parameterized virtual tables provide karne wale inline/multi-statement subroutines.


* 🚨 **Triggers (Automated Event Listeners):**
* `AFTER / FOR Triggers`: Table DML mutations complete hone ke baad audit logging aur notification pipelines trigger karna.
* `INSTEAD OF Triggers`: Complex non-updatable multi-table views ke upar custom update/insert routing logic override karna.


* 🗃️ **Temporary Storage Structures:**
* **Local Temp Tables (`#Table`):** Session-scoped volatile storage jo complex intermediate operations streamline karta hai.
* **Global Temp Tables (`##Table`):** Cross-session shared cache partitions.
* **Table Variables (`@Table`):** Memory-optimized lightweight procedural containers for small data lookups.



---

# 🚀 Query Optimization, Indexing & Performance Tuning

Mission-critical enterprise workloads mein query latency millisecond level par lane aur compute bottlenecks reduce karne ke rules:

* 📇 **B-Tree Indexing Architecture:**
* **Clustered Index:** Table ke physical rows ko disk par leaf-level sorting order mein arrange karna (Primary Key standard, ek table par exactly 1 allowed).
* **Non-Clustered Index:** Pointers (row locators) ke sath secondary lookup structures maintain karna jo base data table se logically decoupled hote hain.
* **Composite Indexes & Column Ordering:** Left-to-right indexing principle (high-cardinality filters leading columns par rakhna).
* **Covering Indexes (`INCLUDE` Columns):** Non-key payload attributes leaf-node par inject karke expensive **Key Lookup / Bookmark Lookup** operations eliminate karna.


* 🗺️ **Execution Plan Analysis & Cost Profiling:**
* **Index Seek vs. Index Scan:** Direct pointer navigation vs pura index read karna (Seek is optimal, Scan signifies sub-optimal index utilization).
* **Table Scan:** Complete unindexed table disk sweep (production warning sign).
* **Join Internals:** Nested Loops Join (low-volume indexed), Hash Match Join (large unsorted volumes), aur Merge Join (pre-sorted indexed large sets).


* 🚫 **Sargable Query Writing (Search Argument Able):**
* `WHERE` clause ke indexed columns par wrapping functions avoid karna taaki index seek degrade na ho:
```sql
-- ❌ Non-Sargable (Triggers complete Table Scan):
WHERE YEAR(created_at) = 2026;

-- ✅ Sargable (Enables fast Index Seek):
WHERE created_at >= '2026-01-01' AND created_at < '2027-01-01';

```




* 🔒 **Transaction Concurrency & Deadlock Prevention:**
* Isolation level tradeoffs: Dirty Reads, Non-Repeatable Reads, aur Phantom Reads ko balance karna.
* `READ COMMITTED`, `REPEATABLE READ`, `SERIALIZABLE`, aur non-blocking `SNAPSHOT / READ COMMITTED SNAPSHOT (RCSI)`.
* Multi-query lock acquisition sequence standardize karke resource graph deadlocks eliminate karna.



---

# 🛡️ Data Modeling, Normalization & Warehouse Architecture

Scalable transactional backends (OLTP) se high-throughput analytical warehouses (OLAP) design karne ke core concepts:

* 📐 **Database Normalization:**
* **1NF:** Atomic attributes, unique row identification, repeating multi-value groups eliminate karna.
* **2NF:** 1NF compliance + composite primary key ke upar zero partial functional dependencies.
* **3NF:** 2NF compliance + non-key attributes ke beech transitive dependencies (`A -> B -> C`) eliminate karna.
* **BCNF (Boyce-Codd Normal Form):** Anomalies wipe out karne ke liye strict candidate key dependency enforcement.


* 🏬 **OLTP vs. OLAP Paradigm:**
* **OLTP (Online Transaction Processing):** Highly normalized (3NF), frequent point write-heavy operational databases.
* **OLAP (Online Analytical Processing):** Denormalized, column-oriented read-heavy reporting systems.


* ⭐ **Dimensional Modeling (Star vs. Snowflake Schema):**
* **Fact Tables:** Central quantitative business event metrics (sales amounts, units sold, call durations).
* **Dimension Tables:** Surrounding descriptive context hierarchies (customer profiles, store locations, calendar periods).


# 🛡️ Data Security, Auditing & Access Control (DCL Deep-Dive)

Database security, user governance aur enterprise data masking ke core rules:

* 🔐 **Authentication vs. Authorization:** Server-level logins (Windows Authentication, SQL Authentication) aur Database-level users ke beech ka physical separation.
* 🛡️ **Role-Based Access Control (RBAC):** Built-in fixed roles (`db_owner`, `db_datareader`, `db_datawriter`) aur customized application roles define karna.
* 🚦 **Privilege Hierarchy (`GRANT`, `REVOKE`, `DENY`):**
* `GRANT`: Specific table ya schema level read/write permissions allocate karna.
* `REVOKE`: Pehle se di gayi permissions ko remove karna.
* `DENY`: Explicit block lagana (jo kisi bhi inherited group permission ko override kar deta hai).


* 🎭 **Dynamic Data Masking (DDM):** Sensitive user data (Credit Card numbers, PII, Email IDs) ko non-privileged users ke liye query-level par automate karke obscure karna (`xxxx-xxxx-xxxx-1234`).

---

# 🧱 Sharding, Partitioning & Scalability Mechanics

Massive scale datasets (terabytes/petabytes) ko horizontally split aur manage karne ke architectural concepts:

* 🗂️ **Table Partitioning (Horizontal Splitting):** Single table ke large data pages ko background filegroups mein distribute karna (e.g., Year/Date range ke basis par partitions banana) taaki query execution mein *Partition Elimination/Pruning* ka fayda mile.
* ✂️ **Vertical Partitioning:** Rarely used columns (large text, BLOBs) ko alag tables mein split karke memory I/O footprint kam karna.
* 🌐 **Database Sharding:** Data ko multiple physical database servers/nodes par hash keys ya geographic regions ke basis par distribute karna.
* 🔄 **Replication & High Availability (HA):** Primary read-write nodes aur dedicated read-only replicas ka setup taaki reporting analytics production operational OLTP workload ko slow na kare.

---

# ⏳ Temporal Tables & Slowly Changing Dimensions (SCD)

Historical audit logs aur analytical point-in-time point changes ko track karne ke design patterns:

* ⏱️ **System-Versioned Temporal Tables:** Database engine level par automated valid-from aur valid-to timestamps ke sath historical data maintain karna (`FOR SYSTEM_TIME AS OF`).
* 📊 **SCD Types (Data Warehousing Standard):**
* **SCD Type 0:** Fixed original values (e.g., Original Date of Birth, kabhi update nahi hoti).
* **SCD Type 1:** Purana data overwrite kar dena (No history tracking).
* **SCD Type 2:** Har attribute update par nayi row create karna with active flags aur date ranges (Complete historical audit tracking).
* **SCD Type 3:** Purani value ko preserve karne ke liye alag se "Previous_Value" column add karna.



---

# 🗃️ Semi-Structured Data Handling (JSON & XML in SQL)

Modern backend APIs aur NoSQL document structures ke sath relational SQL ka integration:

* 📄 **JSON Serialization & Extraction:** Relational rows ko JSON payloads mein export karna (`FOR JSON PATH`) aur runtime parsing functions (`JSON_VALUE`, `JSON_QUERY`).
* 🔍 **JSON Arrays Unnesting (`OPENJSON`):** Multi-nested JSON objects ko tabular relational rows aur columns mein explode karna.
* 📑 **XML Parsing:** Semi-structured hierarchical tags ko extract aur query karna using `.nodes()` aur `.value()` XQuery methods.

