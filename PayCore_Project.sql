-- Create a new database
CREATE DATABASE HR_Analytics;

-- Switch to using the 'HR_Analytics' database
USE HR_Analytics;

-- Creating table 'Departments'
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY AUTO_INCREMENT, 
    Name VARCHAR(100) NOT NULL,                    
    Head_ID INT                                     
);

-- Creating table to store employee details
CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Gender ENUM('Male', 'Female'),
    Department_ID INT,
    Salary DECIMAL(10,2),
    Job_Level VARCHAR(20),
    Joining_Date DATE,
    Bonus DECIMAL(10,2),
    City VARCHAR(50),
    FOREIGN KEY (Department_ID)
		REFERENCES Departments(Department_ID)
		ON DELETE CASCADE          -- Deletes employee if the department is deleted
);

-- Creating table to store benefit enrollments
CREATE TABLE Benefits (
    Benefit_ID INT PRIMARY KEY AUTO_INCREMENT,
    Employee_ID INT,
    Benefit_Type VARCHAR(100),
    FOREIGN KEY (Employee_ID)
		REFERENCES Employees(Employee_ID)
        ON DELETE CASCADE           -- Deletes benefit record if employee is deleted
);

-- Creating Performance Table
CREATE TABLE Performance (
    Employee_ID INT PRIMARY KEY,
    Rating DECIMAL(3,1),
    Last_Increment DECIMAL(10,2),
    Manager_ID INT,
    FOREIGN KEY (Employee_ID)
		REFERENCES Employees(Employee_ID)
        ON DELETE CASCADE
);

-- Inserting Data into Departments
INSERT INTO Departments (Department_ID, Name, Head_ID) VALUES
(1, 'HR', 101),
(2, 'Finance', 102),
(3, 'IT', 103),
(4, 'Operations', 104),
(5, 'Marketing', 105);

-- Inserting Data into Employees
INSERT INTO Employees (Employee_ID, Name, Gender, Department_ID, Salary, Job_Level, Joining_Date, Bonus, City)
VALUES
(1, 'Nidhi Verma', 'Female', 1, 76069.00, 'Junior', '2023-07-20', 0, 'Chennai'),
(2, 'Akshat Negi', 'Male', 2, 99530.50, 'Mid', '2021-05-10', 0, 'Delhi'),
(3, 'Harshit Bhagat', 'Male', 3, 96530.50, 'Mid', '2022-01-15', 7152, 'Bangalore'),
(4, 'Apoorva Arora', 'Female', 3, 66530.50, 'Senior', '2023-07-20', 7707, 'Bangalore');

-- Inserting Data into Benefits
INSERT INTO Benefits (Employee_ID, Benefit_Type) VALUES
(1, 'Health'),
(2, 'Pension'),
(3, 'Health'),
(4, 'Health, Pension');

-- Inserting Data into Performance
INSERT INTO Performance (Employee_ID, Rating, Last_Increment, Manager_ID) VALUES
(1, 4.2, 5000, 201),
(2, 3.8, 4000, 202),
(3, 4.7, 6000, 203),
(4, 4.0, 4500, 204);

-- Find the Average Salary by Department 
SELECT d.Name AS Department, ROUND(AVG(e.Salary), 2) AS Avg_Salary
FROM Employees e
JOIN Departments d ON e.Department_ID = d.Department_ID
GROUP BY d.Name;

-- List Employees Without Any Benefits
SELECT e.Name, e.Department_ID, e.Salary
FROM Employees e
LEFT JOIN Benefits b ON e.Employee_ID = b.Employee_ID
WHERE b.Employee_ID IS NULL;

-- Identify Top 2 Highest Paid Employees
SELECT Name, Salary, Job_Level, Department_ID
FROM Employees
ORDER BY Salary DESC
LIMIT 2;

-- Find the Total Bonus Paid per Department
SELECT d.Name AS Department, SUM(e.Bonus) AS Total_Bonus
FROM Employees e
JOIN Departments d ON e.Department_ID = d.Department_ID
GROUP BY d.Name;

-- Find Employees Who Received a Salary Increment Greater Than 5000
SELECT e.Name, p.Rating, p.Last_Increment
FROM Employees e
JOIN Performance p ON e.Employee_ID = p.Employee_ID
WHERE p.Last_Increment > 5000;

-- Find Employees Joined Within Last 2 Years
SELECT Name, Joining_Date, Department_ID
FROM Employees
WHERE Joining_Date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- Identifying Employees Eligible for Promotion
SELECT e.Employee_ID, e.Name, e.Department_ID, e.Job_Level, p.Rating
FROM Employees e
JOIN Performance p ON e.Employee_ID = p.Employee_ID
WHERE p.Rating >= 4.5 AND e.Job_Level IN ('Junior', 'Mid');

-- Updating Employee Salary Based on Performance
UPDATE Employees e
JOIN Performance p ON e.Employee_ID = p.Employee_ID
SET e.Salary = e.Salary * 1.1
WHERE p.Rating >= 4.5;

-- Deleting an Employee (Handling Foreign Key Constraints)
DELETE FROM Employees WHERE Employee_ID = 2;

-- If there's a foreign key issue, use:
ALTER TABLE Employees
ADD CONSTRAINT fk_employee_performance
FOREIGN KEY (Employee_ID) REFERENCES Performance(Employee_ID)
ON DELETE CASCADE;