-- ============================================================================
-- REPOSITORY: SQL-DATA-LAB
-- BRANCH: feature/sql-commands
-- FILE: scripts/master_sql_commands.sql
-- DESCRIPTION: Comprehensive SQL Command Lab (Beginner to Advanced)
-- DIALECT: T-SQL (SQL Server 2016 SP1+). Uses GO, IDENTITY, TRY/CATCH, MERGE,
--          PIVOT, OPENJSON etc. Modules 03-06 and 09-10 are close to ANSI SQL;
--          the rest needs adapting for PostgreSQL / MySQL.
-- RE-RUNNABLE: Yes (database, tables, procedures are dropped/recreated).
-- ============================================================================

-- ============================================================================
-- 📌 MODULE 01: DATABASE & SCHEMA MANAGEMENT (DDL - DATA DEFINITION LANGUAGE)
-- ============================================================================

-- 1. Database Operations (guarded so the script can be re-run)
IF DB_ID('TechCorpDB') IS NULL
    CREATE DATABASE TechCorpDB;
GO

USE TechCorpDB;
GO

-- 2. Drop Tables if they exist (Cleanup sequence respecting foreign keys)
IF OBJECT_ID('Staging_Employees', 'U') IS NOT NULL DROP TABLE Staging_Employees;
IF OBJECT_ID('AuditLog', 'U')          IS NOT NULL DROP TABLE AuditLog;
IF OBJECT_ID('Orders', 'U')            IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Employees', 'U')         IS NOT NULL DROP TABLE Employees;
IF OBJECT_ID('Departments', 'U')       IS NOT NULL DROP TABLE Departments;
GO

-- 3. Table Creation with Comprehensive Constraints
CREATE TABLE Departments (
    DeptID       INT IDENTITY(1,1) PRIMARY KEY,                    -- Auto-incrementing Primary Key
    DeptName     VARCHAR(50) NOT NULL UNIQUE,                       -- Unique & Not Null constraint
    Location     VARCHAR(100) DEFAULT 'Remote',                     -- Default constraint
    CreatedAt    DATETIME2 DEFAULT SYSDATETIME()                    -- System timestamp (matches DATETIME2 precision)
);

CREATE TABLE Employees (
    EmpID        INT IDENTITY(101,1) PRIMARY KEY,
    FirstName    VARCHAR(50) NOT NULL,
    LastName     VARCHAR(50) NOT NULL,
    Email        VARCHAR(100) UNIQUE,                               -- NOTE: SQL Server allows only ONE NULL in a UNIQUE column
    Salary       DECIMAL(10, 2) CHECK (Salary >= 20000.00),         -- Boundary validation check
    Age          INT CHECK (Age BETWEEN 18 AND 65),                 -- Range check
    DeptID       INT,
    ManagerID    INT NULL,                                          -- Self-reference for hierarchy
    HireDate     DATE DEFAULT CAST(GETDATE() AS DATE),
    IsActive     BIT DEFAULT 1,
    CONSTRAINT FK_Employee_Department
        FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT FK_Employee_Manager
        FOREIGN KEY (ManagerID) REFERENCES Employees(EmpID)
);

CREATE TABLE Orders (
    OrderID      INT IDENTITY(1001,1) PRIMARY KEY,
    EmpID        INT NOT NULL,
    OrderDate    DATE NOT NULL,
    TotalAmount  DECIMAL(12, 2) CHECK (TotalAmount >= 0),
    Status       VARCHAR(20) DEFAULT 'Pending',
    CONSTRAINT FK_Orders_Employee
        FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
        ON DELETE CASCADE
);
GO

-- 4. Alter Table Mechanics (Schema Evolution)
ALTER TABLE Employees ADD PhoneNumber VARCHAR(20);
GO
ALTER TABLE Employees ALTER COLUMN PhoneNumber VARCHAR(25);
GO
EXEC sp_rename 'Employees.PhoneNumber', 'ContactNumber', 'COLUMN';   -- T-SQL Column Rename
GO
ALTER TABLE Employees DROP COLUMN ContactNumber;
GO

-- Truncate vs Drop:
-- TRUNCATE TABLE Orders;  -- Removes all rows quickly and resets IDENTITY. Fully logged page deallocations,
--                         -- so it CAN be rolled back inside a transaction in SQL Server.
--                         -- Fails if the table is referenced by a foreign key.
-- DROP TABLE Orders;      -- Deletes table metadata and schema completely

-- ============================================================================
-- 📌 MODULE 02: DATA POPULATION & MUTATION (DML - DATA MANIPULATION LANGUAGE)
-- ============================================================================

-- 1. Single & Multi-Row Inserts
INSERT INTO Departments (DeptName, Location)
VALUES
    ('Engineering', 'Bengaluru'),
    ('Marketing',   'Mumbai'),
    ('Finance',     'Delhi'),
    ('Operations',  'Hyderabad');

-- Insert with Explicit and Hierarchical Self-References
-- (EmpIDs are generated 101..106 in order because IDENTITY starts at 101)
INSERT INTO Employees (FirstName, LastName, Email, Salary, Age, DeptID, ManagerID, HireDate)
VALUES
    ('Aman',    'Verma',   'aman@techcorp.com',   125000.00, 28, 1,    NULL, '2022-01-15'), -- 101 Top Level Manager
    ('Priya',   'Sharma',  'priya@techcorp.com',  98000.00,  26, 1,    101,  '2022-06-01'), -- 102
    ('Rahul',   'Mehta',   'rahul@techcorp.com',  72000.00,  31, 2,    101,  '2023-03-10'), -- 103
    ('Sneha',   'Patel',   'sneha@techcorp.com',  65000.00,  24, 2,    103,  '2023-08-20'), -- 104
    ('Vikram',  'Singh',   'vikram@techcorp.com', 85000.00,  35, 3,    101,  '2021-11-05'), -- 105
    ('Ananya',  'Iyer',    'ananya@techcorp.com', 45000.00,  23, NULL, NULL, '2024-02-12');  -- 106 Orphan Employee

INSERT INTO Orders (EmpID, OrderDate, TotalAmount, Status)
VALUES
    (101, '2026-01-10', 45000.00, 'Completed'),
    (101, '2026-02-15', 32000.00, 'Completed'),
    (102, '2026-01-20', 12500.00, 'Completed'),
    (103, '2026-03-05', 84000.00, 'Pending'),
    (104, '2026-03-18', 21000.00, 'Cancelled');

-- 2. Data Updates (Conditional and Computational)
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DeptID = 1 AND Age < 30;

-- 3. Controlled Deletion
DELETE FROM Orders
WHERE Status = 'Cancelled';

GO

-- ============================================================================
-- 📌 MODULE 03: QUERY FILTERING & STRING WILDCARDS (DQL)
-- ============================================================================

-- 1. Logical Filtering & Predicates
SELECT EmpID, FirstName, LastName, Salary
FROM Employees
WHERE Salary BETWEEN 60000 AND 100000
  AND DeptID IN (1, 2)
  AND Age >= 25;

-- 2. Null Checks & Boolean Logic
SELECT EmpID, FirstName, Email
FROM Employees
WHERE DeptID IS NULL OR ManagerID IS NOT NULL;

-- 3. Wildcard Pattern Matching
-- % (any number of characters), _ (exact single character)
SELECT * FROM Employees WHERE LastName LIKE 'S%';         -- Starts with 'S'
SELECT * FROM Employees WHERE Email LIKE '%techcorp.com'; -- Ends with domain
SELECT * FROM Employees WHERE FirstName LIKE '_a%';       -- Second character is 'a'

GO

-- ============================================================================
-- 📌 MODULE 04: AGGREGATE FUNCTIONS & GROUPING LOGIC
-- ============================================================================

-- Logical Query Processing Order: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
SELECT
    DeptID,
    COUNT(EmpID)            AS TotalEmployees,
    ROUND(AVG(Salary), 2)   AS AverageSalary,
    MIN(Salary)             AS MinimumSalary,
    MAX(Salary)             AS MaximumSalary,
    SUM(Salary)             AS TotalDepartmentSpend
FROM Employees
WHERE IsActive = 1
GROUP BY DeptID
HAVING COUNT(EmpID) >= 2
ORDER BY TotalDepartmentSpend DESC;

GO

-- ============================================================================
-- 📌 MODULE 05: RELATIONAL MULTI-TABLE JOINS (ALL VARIANTS)
-- ============================================================================

-- 1. INNER JOIN (Strict intersecting pairs)
SELECT
    e.EmpID, e.FirstName, e.LastName, d.DeptName, d.Location
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;

-- 2. LEFT (OUTER) JOIN (Preserves all employees, even without department)
SELECT
    e.FirstName, e.LastName, COALESCE(d.DeptName, 'Unassigned') AS Department
FROM Employees e
LEFT JOIN Departments d ON e.DeptID = d.DeptID;

-- 3. RIGHT (OUTER) JOIN (Preserves all departments, even without employees)
SELECT
    d.DeptName, e.FirstName, e.LastName
FROM Employees e
RIGHT JOIN Departments d ON e.DeptID = d.DeptID;

-- 4. FULL OUTER JOIN (Comprehensive audit reconciliation)
SELECT
    e.FirstName, d.DeptName
FROM Employees e
FULL OUTER JOIN Departments d ON e.DeptID = d.DeptID;

-- 5. CROSS JOIN (Cartesian Product)
SELECT
    e.FirstName, d.DeptName
FROM Employees e
CROSS JOIN Departments d;

-- 6. SELF JOIN (Organizational Hierarchy)
SELECT
    emp.FirstName + ' ' + emp.LastName AS Employee,
    COALESCE(mgr.FirstName + ' ' + mgr.LastName, 'Executive / Top-Level') AS ReportingManager
FROM Employees emp
LEFT JOIN Employees mgr ON emp.ManagerID = mgr.EmpID;

GO

-- ============================================================================
-- 📌 MODULE 06: SUBQUERIES & INLINE EXPRESSIONS
-- ============================================================================

-- 1. Scalar Subquery in SELECT
SELECT
    FirstName,
    Salary,
    (SELECT AVG(Salary) FROM Employees)             AS OverallCompanyAvg,
    Salary - (SELECT AVG(Salary) FROM Employees)    AS DifferenceFromAvg
FROM Employees;

-- 2. Subquery in WHERE (Multi-Row IN)
SELECT FirstName, Salary
FROM Employees
WHERE DeptID IN (
    SELECT DeptID FROM Departments WHERE Location IN ('Bengaluru', 'Delhi')
);

-- 3. Correlated Subquery with EXISTS
SELECT d.DeptName
FROM Departments d
WHERE EXISTS (
    SELECT 1 FROM Employees e
    WHERE e.DeptID = d.DeptID AND e.Salary > 90000
);

GO

-- ============================================================================
-- 📌 MODULE 07: BUILT-IN UTILITY FUNCTIONS & CASE LOGIC
-- ============================================================================

SELECT
    -- String Transformations
    UPPER(FirstName)                                    AS UpperName,
    CASE WHEN CHARINDEX('@', Email) > 1
         THEN SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1)
    END                                                 AS Username,   -- NULL-safe: no error if '@' is missing
    CONCAT(FirstName, ' ', LastName)                    AS FullName,

    -- Date Formatting & Math
    -- DATEDIFF(YEAR) only counts calendar-year boundaries, so subtract 1 if the anniversary hasn't happened yet
    DATEDIFF(YEAR, HireDate, GETDATE())
        - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, HireDate, GETDATE()), HireDate) > CAST(GETDATE() AS DATE)
               THEN 1 ELSE 0 END                        AS YearsOfService,
    DATEADD(MONTH, 6, HireDate)                         AS ProbationEnd,

    -- Conditional Business Logic (CASE WHEN)
    CASE
        WHEN Salary >= 100000 THEN 'Grade A: Executive'
        WHEN Salary >= 70000  THEN 'Grade B: Senior'
        ELSE 'Grade C: Professional'
    END                                                 AS CompensationTier
FROM Employees;

GO

-- ============================================================================
-- 📌 MODULE 08: ADVANCED ANALYTICAL WINDOW FUNCTIONS
-- ============================================================================

SELECT
    EmpID,
    FirstName,
    DeptID,
    Salary,

    -- Ranking Functions
    ROW_NUMBER() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS RowNum,
    RANK()       OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS RankGap,
    DENSE_RANK() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS DenseRankContinuous,
    NTILE(4)     OVER(ORDER BY Salary DESC)                     AS SalaryQuartile,

    -- Running Totals
    SUM(Salary)  OVER(PARTITION BY DeptID ORDER BY EmpID
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal,

    -- Offset Functions (previous / next row in salary order; default 0 for the first/last row)
    LAG(Salary, 1, 0)  OVER(ORDER BY Salary)                    AS PrevLowerSalary,
    LEAD(Salary, 1, 0) OVER(ORDER BY Salary)                    AS NextHigherSalary
FROM Employees;

GO

-- ============================================================================
-- 📌 MODULE 09: COMMON TABLE EXPRESSIONS (CTEs)
-- ============================================================================

-- 1. Standard Modular CTE (Find Department Top Earners)
WITH RankedSalaries AS (
    SELECT
        EmpID, FirstName, LastName, DeptID, Salary,
        DENSE_RANK() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS RankNum
    FROM Employees
    WHERE DeptID IS NOT NULL
)
SELECT EmpID, FirstName, LastName, DeptID, Salary
FROM RankedSalaries
WHERE RankNum = 1;

-- 2. Recursive CTE (Traverse Management Tree Hierarchy)
WITH OrgHierarchyCTE AS (
    -- Anchor Member: Top-level manager(s)
    SELECT EmpID, FirstName, LastName, ManagerID, 1 AS HierarchyLevel
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive Member: Subordinates joining to parents
    SELECT e.EmpID, e.FirstName, e.LastName, e.ManagerID, o.HierarchyLevel + 1
    FROM Employees e
    INNER JOIN OrgHierarchyCTE o ON e.ManagerID = o.EmpID
)
SELECT HierarchyLevel, EmpID, FirstName + ' ' + LastName AS Employee
FROM OrgHierarchyCTE
ORDER BY HierarchyLevel, EmpID;

GO

-- ============================================================================
-- 📌 MODULE 10: SET THEORY OPERATORS
-- ============================================================================

-- UNION ALL (Preserves duplicates, no de-duplication/sorting overhead)
SELECT FirstName, Email FROM Employees WHERE DeptID = 1
UNION ALL
SELECT FirstName, Email FROM Employees WHERE DeptID = 2;

-- INTERSECT (Only mutual records) - compare on the key, since names are not unique
SELECT EmpID FROM Employees WHERE Salary > 70000
INTERSECT
SELECT EmpID FROM Employees WHERE Age < 30;

-- EXCEPT (SQL Server/PostgreSQL) / MINUS (Oracle): rows in the first set but not the second
SELECT EmpID FROM Employees
EXCEPT
SELECT DISTINCT EmpID FROM Orders;

GO

-- ============================================================================
-- 📌 MODULE 11: DATABASE PROGRAMMABILITY (PROCEDURES, FUNCTIONS, TRIGGERS)
-- ============================================================================

-- 1. Stored Procedure with Parameters & Output
-- (Named usp_, not sp_: the sp_ prefix is reserved for system procedures and
--  makes SQL Server search the master database first.)
IF OBJECT_ID('usp_GetDepartmentPayroll', 'P') IS NOT NULL DROP PROCEDURE usp_GetDepartmentPayroll;
GO

CREATE PROCEDURE usp_GetDepartmentPayroll
    @DepartmentID INT,
    @TotalPayroll DECIMAL(12,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @TotalPayroll = SUM(Salary)
    FROM Employees
    WHERE DeptID = @DepartmentID;

    SELECT EmpID, FirstName, LastName, Salary
    FROM Employees
    WHERE DeptID = @DepartmentID;
END;
GO

-- Example call:
DECLARE @Payroll DECIMAL(12,2);
EXEC usp_GetDepartmentPayroll @DepartmentID = 1, @TotalPayroll = @Payroll OUTPUT;
PRINT 'Engineering payroll: ' + CAST(@Payroll AS VARCHAR(20));
GO

-- 2. User-Defined Scalar Function (UDF)
IF OBJECT_ID('fn_CalculateAnnualTax', 'FN') IS NOT NULL DROP FUNCTION fn_CalculateAnnualTax;
GO

CREATE FUNCTION fn_CalculateAnnualTax (@AnnualSalary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Tax DECIMAL(10,2) = 0.00;
    IF @AnnualSalary > 100000.00
        SET @Tax = @AnnualSalary * 0.30;
    ELSE
        SET @Tax = @AnnualSalary * 0.20;
    RETURN @Tax;
END;
GO

-- Example call (schema prefix is required for scalar UDFs):
SELECT FirstName, Salary, dbo.fn_CalculateAnnualTax(Salary) AS AnnualTax
FROM Employees;
GO

-- 3. Audit Trigger (AFTER INSERT)
CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ActionDescription VARCHAR(255),
    LoggedAt DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE OR ALTER TRIGGER trg_AfterEmployeeInsert
ON Employees
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AuditLog (ActionDescription)
    SELECT 'New employee created with ID: ' + CAST(EmpID AS VARCHAR(10))
    FROM inserted;
END;
GO

-- ============================================================================
-- 📌 MODULE 12: TRANSACTION CONTROL (TCL & ACID BOUNDARIES)
-- ============================================================================

SET XACT_ABORT ON;   -- Any runtime error dooms the transaction instead of leaving it half-open

BEGIN TRY
    BEGIN TRANSACTION;

    -- Record a new completed order
    INSERT INTO Orders (EmpID, OrderDate, TotalAmount, Status)
    VALUES (101, CAST(GETDATE() AS DATE), 9999.00, 'Completed');

    SAVE TRANSACTION PointBeforeBonus; -- Savepoint boundary (use ROLLBACK TRANSACTION PointBeforeBonus to undo only what follows)

    -- Conditional update
    UPDATE Employees
    SET Salary = Salary + 1000.00
    WHERE EmpID = 101;

    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    -- Roll back only if a transaction is still open
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    PRINT 'Error occurred! Transaction completely rolled back.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

SET XACT_ABORT OFF;
GO

-- ============================================================================
-- 📌 MODULE 13: PERFORMANCE OPTIMIZATION & INDEXING
-- ============================================================================

-- 1. Covering Composite Index (Eliminates Key Lookup)
--    Its leading key is DeptID, so a separate single-column index on DeptID
--    would be redundant and only slow down writes.
CREATE NONCLUSTERED INDEX IX_Employees_DeptID_Salary
ON Employees (DeptID, Salary)
INCLUDE (FirstName, LastName, Email);

-- 2. Index for date-range searches
CREATE NONCLUSTERED INDEX IX_Employees_HireDate
ON Employees (HireDate);

-- 3. Sargable vs Non-Sargable Comparison:
-- ❌ Non-Sargable (function on the column prevents an Index Seek):
-- SELECT * FROM Employees WHERE YEAR(HireDate) = 2022;

-- ✅ Sargable (Enables Fast B-Tree Index Seek):
SELECT * FROM Employees
WHERE HireDate >= '2022-01-01' AND HireDate < '2023-01-01';

GO

-- ============================================================================
-- 📌 MODULE 14: UPSERT & DATA SYNCHRONIZATION (MERGE STATEMENT)
-- ============================================================================

-- Staging table simulation
CREATE TABLE Staging_Employees (
    EmpID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Staging_Employees (EmpID, FirstName, LastName, Salary)
VALUES
    (101, 'Aman',  'Verma', 135000.00),  -- Existing employee: salary will be updated
    (999, 'Karan', 'Johar', 80000.00);   -- Not in Employees: will be inserted

-- Atomic Merge operation
-- HOLDLOCK avoids race conditions between the match check and the insert.
-- EmpID is an IDENTITY column, so the new row gets the next generated ID (e.g. 107), NOT 999.
MERGE Employees WITH (HOLDLOCK) AS Target
USING Staging_Employees AS Source
ON (Target.EmpID = Source.EmpID)
WHEN MATCHED THEN
    UPDATE SET Target.Salary = Source.Salary
WHEN NOT MATCHED BY TARGET THEN
    INSERT (FirstName, LastName, Salary)
    VALUES (Source.FirstName, Source.LastName, Source.Salary);

DROP TABLE Staging_Employees;
GO

-- ============================================================================
-- 📌 MODULE 15: DATA RESHAPING (PIVOT & UNPIVOT)
-- ============================================================================

-- 1. PIVOT: Rows to Columns (Employee count per department, by location)
SELECT Location, [Engineering], [Marketing], [Finance]
FROM (
    SELECT d.Location, d.DeptName, e.EmpID
    FROM Employees e
    INNER JOIN Departments d ON e.DeptID = d.DeptID
) AS SourceTable
PIVOT (
    COUNT(EmpID)
    FOR DeptName IN ([Engineering], [Marketing], [Finance])
) AS PivotTable;

GO

-- ============================================================================
-- 📌 MODULE 16: PROCEDURAL CURSORS (ROW-BY-ROW FETCHING)
-- ============================================================================

DECLARE @EmpName VARCHAR(100);
DECLARE @EmpSal DECIMAL(10,2);

-- 1. Declare cursor
DECLARE EmployeeCursor CURSOR FAST_FORW
