CREATE TABLE Projects (
  Task_ID INT PRIMARY KEY NOT NULL,  
  Start_Date DATE NOT NULL,         
  End_Date DATE                      
);
INSERT INTO Projects (Task_ID, Start_Date, End_Date)
 values (1, '2024-06-10', '2024-06-11');
 INSERT INTO Projects (Task_ID, Start_Date, End_Date)
 values(2, '2024-06-11', '2024-06-12');
 INSERT INTO Projects (Task_ID, Start_Date, End_Date)
 values(3, '2024-06-13', '2024-06-14');
 INSERT INTO Projects (Task_ID, Start_Date, End_Date)
 values(4, '2024-06-14', '2024-06-15');
 INSERT INTO Projects (Task_ID, Start_Date, End_Date)
 values(5, '2024-06-25', '2024-06-26');
 SELECT * FROM Projects;
SELECT Start_Date, MAX(End_Date) AS Latest_End_Date
FROM (
  SELECT *, DATEDIFF(day, Start_Date, End_Date) AS Completion_Days
  FROM Projects
) AS ProjectData
GROUP BY Start_Date, Completion_Days
ORDER BY Completion_Days ASC, Start_Date ASC;

 -- Task 2

  CREATE TABLE Students (
  ID INT PRIMARY KEY NOT NULL,  
  Name VARCHAR(255) NOT NULL   
);
INSERT INTO Students (ID, Name)
VALUES (1, 'Alice'),
       (2, 'Bob'),
       (3, 'Charlie');
CREATE TABLE Friends (
  ID INT PRIMARY KEY NOT NULL,    
  Friend_ID INT NOT NULL,         
  FOREIGN KEY (ID) REFERENCES Students(ID)  
);
INSERT INTO Friends (ID, Friend_ID)
VALUES (1, 2),  
       (2, 3),  
       (3, 1);
CREATE TABLE Packages (
  ID INT PRIMARY KEY NOT NULL,    
  Salary DECIMAL(10,2) NOT NULL  
);
INSERT INTO Packages (ID, Salary)
VALUES (1, 5.5),  
       (2, 6.2),  
       (3, 7.0);  
SELECT s1.Name AS Student_Name
FROM Students s1
INNER JOIN Friends f ON s1.ID = f.ID
INNER JOIN Students f2 ON f.Friend_ID = f2.ID
INNER JOIN Packages p1 ON s1.ID = p1.ID
INNER JOIN Packages p2 ON f2.ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary DESC;

-- Task 3

 CREATE TABLE Functions (
  X int NOT NULL,  
  Y int NOT NULL  
);
INSERT INTO Functions (X, Y)
VALUES (10, 10);
INSERT INTO Functions (X, Y)
VALUES (10, 11);
INSERT INTO Functions (X, Y)
VALUES (50, 50);
INSERT INTO Functions (X, Y)
VALUES (100, 500);
INSERT INTO Functions (X, Y)
VALUES (211, 510);
SELECT f1.X AS X1, f1.Y AS Y1, f2.X AS X2, f2.Y AS Y2
FROM Functions AS f1
INNER JOIN Functions AS f2 ON f1.Y = f2.X AND f1.X = f2.Y
WHERE f1.X <= f2.X;

-- Task 4
CREATE TABLE contests (
    contest_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE hackers (
    hacker_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE submissions (
    contest_id INT,
    hacker_id INT,
    total_submissions INT,
    total_accepted_submissions INT,
    total_views INT,
    total_unique_views INT,
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id),
    FOREIGN KEY (hacker_id) REFERENCES hackers(hacker_id)
);
INSERT INTO contests (contest_id, name) VALUES
(1, 'Contest A'),
(2, 'Contest B'),
(3, 'Contest C');

INSERT INTO hackers (hacker_id, name) VALUES
(1, 'Sumit'),
(2, 'Harsh'),
(3, 'Aman');

INSERT INTO submissions (contest_id, hacker_id, total_submissions, total_accepted_submissions, total_views, total_unique_views) VALUES
(1, 1, 10, 5, 100, 50),
(1, 2, 20, 10, 200, 100),
(2, 1, 0, 0, 0, 0),
(2, 3, 15, 7, 150, 75),
(3, 2, 30, 15, 300, 150);
SELECT 
    s.contest_id,
    s.hacker_id,
    h.name,
    SUM(s.total_submissions) AS total_submissions,
    SUM(s.total_accepted_submissions) AS total_accepted_submissions,
    SUM(s.total_views) AS total_views,
    SUM(s.total_unique_views) AS total_unique_views
FROM 
    submissions s
JOIN 
    hackers h ON s.hacker_id = h.hacker_id
GROUP BY 
    s.contest_id, s.hacker_id, h.name
HAVING 
    SUM(s.total_submissions) > 0 
    OR SUM(s.total_accepted_submissions) > 0 
    OR SUM(s.total_views) > 0 
    OR SUM(s.total_unique_views) > 0
ORDER BY 
    s.contest_id;

	-- Task 5

	CREATE TABLE submission_dates (
    contest_id INT,
    hacker_id INT,
    submission_date DATE,
    submissions INT,
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id),
    FOREIGN KEY (hacker_id) REFERENCES hackers(hacker_id)
);
INSERT INTO submission_dates (contest_id, hacker_id, submission_date, submissions) VALUES
(1, 1, '2016-03-01', 5),
(1, 2, '2016-03-01', 3),
(1, 3, '2016-03-01', 2),
(1, 1, '2016-03-02', 4),
(1, 2, '2016-03-02', 6),
(1, 3, '2016-03-02', 1);
WITH DailySubmissions AS (
    SELECT 
        submission_date,
        hacker_id,
        SUM(submissions) AS total_submissions
    FROM 
        submission_dates
    WHERE 
        submission_date BETWEEN '2016-03-01' AND '2016-03-15'
    GROUP BY 
        submission_date, hacker_id
),
UniqueHackers AS (
    SELECT 
        submission_date,
        COUNT(DISTINCT hacker_id) AS unique_hackers
    FROM 
        DailySubmissions
    GROUP BY 
        submission_date
),
MaxSubmissions AS (
    SELECT 
        submission_date,
        hacker_id,
        total_submissions,
        ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY total_submissions DESC, hacker_id ASC) AS rn
    FROM 
        DailySubmissions
)
SELECT 
    u.submission_date,
    u.unique_hackers,
    m.hacker_id,
    h.name,
    m.total_submissions
FROM 
    UniqueHackers u
JOIN 
    MaxSubmissions m ON u.submission_date = m.submission_date AND m.rn = 1
JOIN 
    hackers h ON m.hacker_id = h.hacker_id
ORDER BY 
    u.submission_date;

	-- Task 7
WITH primes AS (
  SELECT num
  FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY num) AS rn, num
    FROM (
      SELECT DISTINCT n
      FROM GENERATE_SERIES(2, 1000) AS n
      WHERE n NOT IN (SELECT DISTINCT multiple FROM GENERATE_SERIES(4, 1000) AS m(multiple)
                       WHERE m.multiple % 2 = 0 OR m.multiple % 3 = 0)
    ) AS all_numbers
  ) AS ranked_numbers
  WHERE ranked_numbers.rn <= SQRT(ranked_numbers.num) OR ranked_numbers.num = 2
)
SELECT STRING_AGG(CAST(num AS VARCHAR), '&') AS prime_numbers
FROM primes;

-- Task 8
CREATE TABLE OCCUPATIONS (
    Name VARCHAR(50),
    Occupation VARCHAR(50)
);

INSERT INTO OCCUPATIONS (Name, Occupation) VALUES
('John', 'Doctor'),
('Alice', 'Professor'),
('Bob', 'Actor'),
('Eve', 'Singer'),
('Charlie', 'Doctor'),
('Dave', 'Actor'),
('Faythe', 'Singer'),
('Grace', 'Professor');
SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM (
    SELECT Name, Occupation,
           ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) as RowNum
    FROM OCCUPATIONS
) AS SubQuery
GROUP BY RowNum
ORDER BY RowNum;
-- Task 9
CREATE TABLE BST (
    N INT,
    P INT
);
INSERT INTO BST (N, P) VALUES (1, NULL);  -- Root node
INSERT INTO BST (N, P) VALUES (2, 1);
INSERT INTO BST (N, P) VALUES (3, 1);
INSERT INTO BST (N, P) VALUES (4, 2);
INSERT INTO BST (N, P) VALUES (5, 2);
INSERT INTO BST (N, P) VALUES (6, 3);
INSERT INTO BST (N, P) VALUES (7, 3);
SELECT 
    N,
    CASE 
        WHEN P IS NULL THEN 'Root'
        WHEN N NOT IN (SELECT DISTINCT P FROM BST) THEN 'Leaf'
        ELSE 'Inner'
    END AS NodeType
FROM 
    BST
ORDER BY 
    N;


	-- Task 10


	SELECT 
    F.company_code,
    F.name AS founder_name,
    COALESCE(LM.lead_manager_count, 0) AS total_lead_managers,
    COALESCE(SM.senior_manager_count, 0) AS total_senior_managers,
    COALESCE(M.manager_count, 0) AS total_managers,
    COALESCE(E.employee_count, 0) AS total_employees
FROM 
    Founders F
LEFT JOIN (
    SELECT 
        company_code,
        COUNT(DISTINCT name) AS lead_manager_count
    FROM 
        LeadManagers
    GROUP BY 
        company_code
) LM ON F.company_code = LM.company_code
LEFT JOIN (
    SELECT 
        company_code,
        COUNT(DISTINCT name) AS senior_manager_count
    FROM 
        SeniorManagers
    GROUP BY 
        company_code
) SM ON F.company_code = SM.company_code
LEFT JOIN (
    SELECT 
        company_code,
        COUNT(DISTINCT name) AS manager_count
    FROM 
        Managers
    GROUP BY 
        company_code
) M ON F.company_code = M.company_code
LEFT JOIN (
    SELECT 
        company_code,
        COUNT(DISTINCT name) AS employee_count
    FROM 
        Employees
    GROUP BY 
        company_code
) E ON F.company_code = E.company_code
ORDER BY 
    F.company_code;

