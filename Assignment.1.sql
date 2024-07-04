-- Create Employees table with unique name

Drop table if exists Employees_New
CREATE TABLE Employees_New (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(255),
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);

-- Create Department table with unique name
CREATE TABLE Department_New (
    DepartmentID INT PRIMARY KEY,
    Name VARCHAR(255)
);

-- Insert data into Employees_New table
INSERT INTO Employees_New (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'John Doe', 1, 60000.00),
(2, 'Jane Smith', 1, 70000.00),
(3, 'Alice Johnson', 1, 65000.00),
(4, 'Bob Brown', 1, 75000.00),
(5, 'Charlie Wilson', 1, 80000.00),
(6, 'Eva Lee', 2, 70000.00),
(7, 'Michael Clark', 2, 75000.00),
(8, 'Sarah Davis', 2, 80000.00),
(9, 'Ryan Harris', 2, 85000.00),
(10, 'Emily White', 2, 90000.00),
(11, 'David Martinez', 3, 95000.00),
(12, 'Jessica Taylor', 3, 100000.00),
(13, 'William Rodriguez', 3, 105000.00);

-- Insert data into Department_New table
INSERT INTO Department_New (DepartmentID, Name) VALUES
(1, 'Marketing'),
(2, 'Research'),
(3, 'Development');

-- Run the main query with new table names
WITH department_avg AS (
    SELECT 
        e.DepartmentID,
        d.Name AS DepartmentName,
        AVG(e.Salary) AS avg_salary,
        COUNT(e.EmployeeID) AS employee_count
    FROM 
        Employees_New e
    JOIN 
        Department_New d ON e.DepartmentID = d.DepartmentID
    GROUP BY 
        e.DepartmentID, d.Name
),
overall_avg AS (
    SELECT 
        AVG(Salary) AS overall_avg_salary
    FROM 
        Employees_New
)
SELECT 
    da.DepartmentName,
    da.avg_salary,
    da.employee_count
FROM 
    department_avg da
JOIN 
    overall_avg oa
ON 
    da.avg_salary > oa.overall_avg_salary;
