-- ===========================================================
-- SECTION 1 : DATABASE SETUP
-- Objective: Create a dedicated workspace to organize the project. 
-- ===========================================================

/*
Purpose:
Create a dedicated schema to organize all project tables in one place.
A schema acts like a folder inside a database, helping keep related
objects together and making the database easier to manage.
*/

----- Schema Creation -----
CREATE SCHEMA AI_Workforce;

-- Verify that the schema was created successfully.
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'ai_workforce';



-- =========================================================== 
-- SECTION 2 : CREATE THE RAW DATA TABLE 
-- Objective: -- Create a table that mirrors the origin CSV dataset. 
-- No transformation is performed at this stage. 
-- This table serves as the source of truth for the project. 
-- Preserve the original dataset. 
-- ===========================================================

---- Table Creation ------
CREATE TABLE AI_Workforce.Raw_AI_Workforce(
	EMP_ID SERIAL PRIMARY KEY, 
	Age INT, 
	Edu_Level VARCHAR(50),
	Year_of_Exp INT, 
	Industry VARCHAR(100),
	Job_Role VARCHAR(100), 
	Company_Size VARCHAR(50), 
	Job_Level VARCHAR(50),
	Routine_Task_Percentage NUMERIC(5,2), 
	Creativity_Requirement VARCHAR(50), 
	Human_Interaction_Level INT,
	AI_Adoption_Level VARCHAR(50), 
	No_of_AI_Tools_Used INT,
	AI_Usage_Hours_Per_Week NUMERIC(5,2),
	Task_Automated_Group NUMERIC(5,2),
	AI_Training_Hours NUMERIC(5,2), 
	Layoff_Risk VARCHAR(50)
);


-- Verify that the table was created successfully. 
SELECT * FROM AI_Workforce.Raw_AI_Workforce;
--- Initially this table should be empty, however, I already inserted values ahead. 



-- ===========================================================
-- DEMONSTRATION : MANUAL DATA INSERT
-- ===========================================================

/*
Purpose:
Before importing thousands of employee records, demonstrate how
the INSERT statement works by manually adding a few sample records.
This table is used only for learning and does not affect the main project.
*/

---- DEMO TABLE CREATION TO DEMONSTRATE INSERT COMMAND -----
CREATE TABLE AI_Workforce.Manual_Insert_Demo(
	Demo_ID SERIAL PRIMARY KEY,
	Industry VARCHAR(100),
	Job_Role VARCHAR(100), 
	AI_Adoption_Level VARCHAR(50), 
	AI_Training_Hours NUMERIC(5,2), 
	Layoff_Risk VARCHAR(50)
);

---- Manually INSERT sample records into the Demo Table -----
INSERT INTO AI_Workforce.Manual_Insert_Demo(
Industry, Job_Role, AI_Adoption_Level, AI_Training_Hours, Layoff_Risk
) VALUES
('Finance', 'Accountant', 'Medium', 12.50, 'High'),
('Healthcare', 'Medical Assistant', 'Low', 6.00, 'High'),
('IT', 'Software Engineer', 'High', 20.00, 'Low'),
('Retail', 'Cashier', 'Low', 3.50, 'High'),
('Education', 'Teacher', 'Medium', 10.00, 'Medium');

-- Verify that the records were inserted successfully.
SELECT * FROM AI_Workforce.Manual_Insert_Demo;
 

-- ===========================================================
-- SECTION 3 : IMPORT DATA INTO A STAGING TABLE
-- Objective:
-- Create a staging table to receive the imported CSV file.
-- This acts as a temporary landing area where imported data
-- can be verified before moving into the project's raw table.
-- ===========================================================


-- Staging table serves as an intermediate between the imported CSV file, and the raw table. 

CREATE TABLE AI_Workforce.Staging_AI_Workforce (
    Age INT,
    Edu_Level VARCHAR(50),
    Year_of_Exp INT,
    Industry VARCHAR(100),
    Job_Role VARCHAR(100),
    Company_Size VARCHAR(50),
    Job_Level VARCHAR(50),
    Routine_Task_Percentage NUMERIC(5,2),
    Creativity_Requirement VARCHAR(50),
    Human_Interaction_Level VARCHAR(50),
    AI_Adoption_Level VARCHAR(50),
    No_of_AI_Tools_Used INT,
    AI_Usage_Hours_Per_Week NUMERIC(5,2),
    Task_Automated_Group NUMERIC(5,2),
    AI_Training_Hours NUMERIC(5,2),
    Layoff_Risk VARCHAR(50)
);

-- Import the CSV file into this table using PostgreSQL's Import feature.

-- Verify that all records were imported successfully.
SELECT COUNT(*)
FROM AI_Workforce.Staging_AI_Workforce;
-- shows empty, because data has already been imported to the raw table. 


-- ===========================================================
-- SECTION 4 : LOAD DATA INTO THE RAW TABLE
-- Objective:
-- Transfer the verified employee data from the staging table
-- into the Raw_AI_Workforce table. The raw table becomes the
-- permanent source of truth for all transformations and analysis.
-- ===========================================================


INSERT INTO AI_Workforce.Raw_AI_Workforce(
	AGE, 
	Edu_Level, 
	Year_of_Exp, 
	Industry, 
	Job_Role, 
	Company_Size, 
	Job_Level, 
	Routine_Task_Percentage, 
	Creativity_Requirement,
	Human_Interaction_Level,
	AI_Adoption_Level,
	No_of_AI_Tools_Used,
	AI_Usage_Hours_Per_Week,
	Task_Automated_Group,
	AI_Training_Hours,
	Layoff_Risk
)
SELECT
	AGE, 
	Edu_Level, 
	Year_of_Exp, 
	Industry, 
	Job_Role, 
	Company_Size, 
	Job_Level, 
	Routine_Task_Percentage, 
	Creativity_Requirement,
	Human_Interaction_Level,
	AI_Adoption_Level,
	No_of_AI_Tools_Used,
	AI_Usage_Hours_Per_Week,
	Task_Automated_Group,
	AI_Training_Hours,
	Layoff_Risk

FROM AI_Workforce.Staging_AI_Workforce;


SELECT COUNT (*)
FROM AI_Workforce.Raw_AI_Workforce;

SELECT * FROM AI_Workforce.Raw_AI_Workforce
LIMIT 10;



-- ===========================================================
-- SECTION 5 : BUILD DIMENSION TABLES & EMPLOYEE PROFILE
-- Objective:
-- Normalize repeated categorical fields into dimension tables
-- and create a structured employee profile table using IDs.
-- This reduces redundancy and enables efficient joins.
-- ===========================================================

-- Industry Dimension Table
CREATE TABLE AI_Workforce.Industry_Dim(
Industry_ID SERIAL PRIMARY KEY,
Industry_Name VARCHAR(100) UNIQUE NOT NULL
);

-- Role Dimension Table
CREATE TABLE AI_Workforce.Role_Dim(
Role_ID SERIAL PRIMARY KEY,
Role_Name VARCHAR(100) UNIQUE NOT NULL
);

-- Company Size Dimension Table
CREATE TABLE AI_Workforce.Company_Size_Dim(
Company_Size_ID SERIAL PRIMARY KEY,
Company_Size_Name VARCHAR(100) UNIQUE NOT NULL
);

-- Job Level Dimension Table
CREATE TABLE AI_Workforce.Job_Level_Dim(
Job_Level_ID SERIAL PRIMARY KEY,
Job_Level_Name VARCHAR(100) UNIQUE NOT NULL
);


-- Employee Profile (Fact-Like Table)
CREATE TABLE AI_Workforce.Employee_Profile(
EMP_ID INT PRIMARY KEY, 
Age INT, 
Edu_Level VARCHAR(50),
Year_of_Exp INT, 
Industry_ID INT,
Role_ID INT, 
Company_Size_ID INT, 
Job_Level_ID INT,

CONSTRAINT FK_Employee_Industry
	FOREIGN KEY (Industry_ID)
	REFERENCES AI_Workforce.Industry_Dim(Industry_ID), 

CONSTRAINT FK_Employee_Role
	FOREIGN KEY (Role_ID)
	REFERENCES AI_Workforce.Role_Dim(Role_ID), 

CONSTRAINT FK_Employee_Company_Size
	FOREIGN KEY (Company_Size_ID)
	REFERENCES AI_Workforce.Company_Size_Dim(Company_Size_ID), 

CONSTRAINT FK_Employee_Job_Level
	FOREIGN KEY (Job_Level_ID)
	REFERENCES AI_Workforce.Job_Level_Dim(Job_Level_ID)
);



SELECT * FROM AI_Workforce.Industry_Dim;
SELECT * FROM AI_Workforce.Role_Dim;
SELECT * FROM AI_Workforce.Company_Size_Dim;
SELECT * FROM AI_Workforce.Job_Level_Dim;
SELECT * FROM AI_Workforce.Employee_Profile;





-- ===========================================================
-- SECTION 6 : Adoption Metrics
-- Objective: Stepping into how people are using AI
-- ===========================================================



-- AI Behavior Metrics -- What people are doing with AI?
CREATE TABLE AI_Workforce.AI_Adoption_Metrics(
	EMP_ID INT PRIMARY KEY,
	Routine_Task_Percentage NUMERIC(5,2), 
	Creativity_Requirement VARCHAR(50), 
	Human_Interaction_Level INT,
	AI_Adoption_Level VARCHAR(50), 
	No_of_AI_Tools_Used INT,
	AI_Usage_Hours_Per_Week NUMERIC(5,2),
	Task_Automated_Group NUMERIC(5,2),
	AI_Training_Hours NUMERIC(5,2),

	CONSTRAINT FK_AI_Metrics_Employees
		FOREIGN KEY (EMP_ID)
		REFERENCES AI_Workforce.Employee_Profile(EMP_ID)
);


-- Risk Outcome Metrics -- What might happen to them?
CREATE TABLE AI_Workforce.Job_Risk_Metrics(
	EMP_ID INT PRIMARY KEY,
	Layoff_Risk VARCHAR(50),

	CONSTRAINT FK_Risk_Employee
		FOREIGN KEY (EMP_ID)
		REFERENCES AI_Workforce.Employee_Profile(EMP_ID)
);


---- DEMONSTRATION: DISTINCT KEYWORD

--- Distinct Keyword use to filter out only Unique Values
SELECT DISTINCT Industry
FROM AI_Workforce.Raw_AI_Workforce;

--- Distinct doesn't not removes duplicates value, but it just filters the view. 
SELECT COUNT(*)
FROM AI_Workforce.Raw_AI_Workforce;


-- ALTER TABLE: Can add new column,
-- delete a column, 
-- rename a column, 
-- change a data type, 
-- add constraints
-- remove constraints

/*
ALTER TABLE AI_Workforce.AI_Adoption_Metrics
ALTER COLUMN Human_Interaction_Level
TYPE INT
USING Human_Interaction_Level::INT;
*/

--------------------------------------------------------------------------------


-- Populate Industry Dimension
INSERT INTO AI_Workforce.Industry_Dim (Industry_Name)
SELECT DISTINCT Industry
FROM AI_Workforce.Raw_AI_Workforce;

--- Validation
SELECT * FROM AI_Workforce.Industry_Dim;

INSERT INTO AI_Workforce.Role_Dim (Role_Name)
SELECT DISTINCT Job_Role
FROM AI_Workforce.Raw_AI_Workforce;

--- Validation
SELECT * FROM AI_Workforce.Role_Dim;

INSERT INTO AI_Workforce.Company_Size_Dim (Company_Size_Name)
SELECT DISTINCT Company_Size
FROM AI_Workforce.Raw_AI_Workforce;

--- Validation
SELECT * FROM AI_Workforce.Company_Size_Dim;

INSERT INTO AI_Workforce.Job_Level_Dim (Job_Level_Name)
SELECT DISTINCT Job_Level
FROM AI_Workforce.Raw_AI_Workforce;

--- Validation
SELECT * FROM AI_Workforce.Job_Level_Dim;




/*
--- Join ----
SELECT
	r.EMP_ID, 
	r.Industry, 
	i.Industry_ID, 
	i.Industry_Name
FROM AI_Workforce.Raw_AI_Workforce r
JOIN AI_Workforce.Industry_Dim i
ON r.Industry = i.Industry_Name
LIMIT 10;


INSERT INTO AI_Workforce.Employee_Profile (
Emp_ID, 
Age, 
Edu_Level,
Year_of_Exp,
Industry_ID, 
Role_ID, 
Company_Size_ID, 
Job_Level_ID
)
SELECT 
	r.Emp_ID, 
	r.Age,
	r.Edu_Level, 
	r.Year_of_Exp,
	i.Industry_ID, 
	rd.Role_ID, 
	cs.Company_Size_ID, 
	jl.Job_Level_ID

FROM AI_Workforce.Raw_AI_Workforce r

JOIN AI_Workforce.Industry_Dim i
ON r.Industry = i.Industry_Name 

JOIN AI_Workforce.Role_Dim rd
ON r.Job_Role = rd.Role_Name

JOIN AI_Workforce.Company_Size_Dim cs
ON r.Company_Size = cs.Company_Size_Name

JOIN AI_Workforce.Job_Level_Dim jl
ON r.Job_Level = jl.Job_Level_Name

SELECT * FROM AI_Workforce.Employee_Profile
LIMIT 5;

SELECT * FROM AI_Workforce.Raw_AI_Workforce
LIMIT 5;
*/




--- TRUNCATE Used to empty the table ----
--- CASCASE deletes relation belonging to that table

TRUNCATE TABLE AI_Workforce.Employee_Profile CASCADE;

SELECT * FROM AI_Workforce.Employee_Profile
LIMIT 5;


-- ===========================================================
-- SECTION 7 : Populating Employee Profile Table
-- Objective:
-- Populate the Employee_Profile table by replacing repeated
-- text values with their corresponding IDs from the dimension
-- tables. This establishes relationships across the database.
-- ===========================================================


INSERT INTO AI_Workforce.Employee_Profile (
Emp_ID, 
Age, 
Edu_Level,
Year_of_Exp,
Industry_ID, 
Role_ID, 
Company_Size_ID, 
Job_Level_ID
)
SELECT 
	r.Emp_ID, 
	r.Age,
	r.Edu_Level, 
	r.Year_of_Exp,
	i.Industry_ID, 
	rd.Role_ID, 
	cs.Company_Size_ID, 
	jl.Job_Level_ID

FROM AI_Workforce.Raw_AI_Workforce r

-- Join the raw dataset with each dimension table
-- to replace descriptive text with unique IDs.

JOIN AI_Workforce.Industry_Dim i
ON r.Industry = i.Industry_Name 

JOIN AI_Workforce.Role_Dim rd
ON r.Job_Role = rd.Role_Name

JOIN AI_Workforce.Company_Size_Dim cs
ON r.Company_Size = cs.Company_Size_Name

JOIN AI_Workforce.Job_Level_Dim jl
ON r.Job_Level = jl.Job_Level_Name

-- Verify that the employee profile was populated successfully.
SELECT * FROM AI_Workforce.Employee_Profile

-- The Employee_Profile table now serves as the central table
-- connecting employee information with AI adoption and job
-- risk metrics.


--- DEMONSTRATION: 
--- Demonstrating WHERE function

--- View Employee Age > 50
SELECT * FROM AI_Workforce.Employee_Profile
WHERE Age > 50;

SELECT * FROM AI_Workforce.AI_Adoption_Metrics
LIMIT 5;

SELECT * FROM AI_Workforce.Job_Risk_Metrics
LIMIT 5;

-- ====================================================

/*
SELECT Column_Name
FROM Information_Schema.Columns
WHERE Table_Schema = 'AI_Workforce'
AND Table_Name = 'AI_Adoption_Metrics';

SELECT Column_Name
FROM Information_Schema.Columns
WHERE Table_Schema = 'AI_Workforce'
AND Table_Name = 'Job_Risk_Metrics';
*/


/*
INSERT INTO AI_Workforce.AI_Adoption_Metrics (
EMP_ID,
Routine_Task_Percentage, 
Creativity_Requirement, 
Human_Interaction_Level,
AI_Adoption_Level, 
No_of_AI_Tools_Used,
AI_Usage_Hours_Per_Week,
Task_Automated_Group,
AI_Training_Hours
)
SELECT 
	EMP_ID,
	Routine_Task_Percentage, 
	Creativity_Requirement, 
	CASE
		WHEN Human_Interaction_Level::INT BETWEEN 20 AND 45 THEN 'Low'
		WHEN Human_Interaction_Level::INT BETWEEN 46 AND 70 THEN 'Medium'
		ELSE 'High'
	END AS Human_Interaction_Level,
	AI_Adoption_Level, 
	No_of_AI_Tools_Used,
	AI_Usage_Hours_Per_Week,
	Task_Automated_Group,
	AI_Training_Hours

FROM AI_Workforce.Raw_AI_Workforce;

SELECT
	MIN(Human_Interaction_Level) AS Min_Value,
	Max(Human_Interaction_Level) AS Max_Value 
FROM AI_Workforce.Raw_AI_Workforce; 

SELECT COUNT(*)
FROM AI_Workforce.AI_Adoption_Metrics;
*/

SELECT * FROM AI_Workforce.AI_Adoption_Metrics;

TRUNCATE TABLE AI_Workforce.AI_Adoption_Metrics;


-- ===========================================================
-- SECTION 8 : POPULATE ANALYTICAL TABLES
-- Objective:
-- Populate the analytical tables by separating AI behavior
-- metrics from job risk outcomes. During this process,
-- convert raw numeric scores into meaningful business categories.
-- ===========================================================


-- Transform raw numeric scores into business-friendly
-- categories (Low, Medium, High) to improve readability
-- and simplify downstream analysis.

-- -----------------------------------------------------------
-- Populate AI Adoption Metrics
-- -----------------------------------------------------------

INSERT INTO AI_Workforce.AI_Adoption_Metrics (
EMP_ID,
Routine_Task_Percentage, 
Creativity_Requirement, 
Human_Interaction_Level,
AI_Adoption_Level, 
No_of_AI_Tools_Used,
AI_Usage_Hours_Per_Week,
Task_Automated_Group,
AI_Training_Hours
)
SELECT 
	EMP_ID,
	Routine_Task_Percentage, 
	CASE
		WHEN Creativity_Requirement::INT BETWEEN 0 AND 33 THEN 'Low'
		WHEN Creativity_Requirement::INT BETWEEN 34 AND 66 THEN 'Medium'
		ELSE 'High'
	END AS Creativity_Requirement,
	
	CASE
		WHEN Human_Interaction_Level::INT BETWEEN 20 AND 45 THEN 'Low'
		WHEN Human_Interaction_Level::INT BETWEEN 46 AND 70 THEN 'Medium'
		ELSE 'High'
	END AS Human_Interaction_Level,
	AI_Adoption_Level, 
	No_of_AI_Tools_Used,
	AI_Usage_Hours_Per_Week,
	Task_Automated_Group,
	AI_Training_Hours

FROM AI_Workforce.Raw_AI_Workforce;

-- Verify that AI adoption metrics were populated successfully.
SELECT *
FROM AI_Workforce.AI_Adoption_Metrics
LIMIT 10;

/*
SELECT
	MIN(Creativity_Requirement) AS Min_Value,
	Max(Creativity_Requirement) AS Max_Value 
FROM AI_Workforce.Raw_AI_Workforce; 
*/


-- -----------------------------------------------------------
-- Populate Job Risk Metrics
-- -----------------------------------------------------------

INSERT INTO AI_Workforce.Job_Risk_Metrics (
EMP_ID,
Layoff_Risk
)
SELECT 
	EMP_ID,
	Layoff_Risk

FROM AI_Workforce.Raw_AI_Workforce;

-- Verify that job risk metrics were populated successfully.
SELECT *
FROM AI_Workforce.Job_Risk_Metrics
LIMIT 10;


-- The analytical tables are now populated and ready for
-- business analysis using SQL queries and Power BI.


-- ===========================================================
-- SECTION 9 : BUSINESS INVESTIGATION
-- Objective:
-- Use SQL to investigate factors associated with employee layoff
-- risk and identify areas where management can intervene.
-- ===========================================================



-- ===========================================================
-- QUESTION 1:
-- Which employees require immediate intervention?
--
-- Criteria:
-- • High Layoff Risk
-- • Low AI Adoption
-- • Less than 10 hours of AI Training
-- ===========================================================

SELECT
	ep.EMP_ID, 
	ep.Year_of_Exp, 
	am.AI_Adoption_Level,
	am.AI_Training_Hours, 
	jm.Layoff_Risk

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.AI_Adoption_Metrics am
ON ep.EMP_ID = am.EMP_ID

JOIN AI_Workforce.Job_Risk_Metrics jm
ON ep.EMP_ID = jm.EMP_ID

WHERE
	jm.Layoff_Risk = 'High'
	AND am.AI_Adoption_Level = 'Low'
	AND am.AI_Training_Hours < 10;


-- ===========================================================
-- QUESTION 2:
-- Which industries have the highest number of employees
-- requiring AI intervention?
-- ===========================================================


SELECT
	i.Industry_Name AS Industry, 
	COUNT(*) AS Employees_Needing_Intervention

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.Industry_Dim i
ON ep.Industry_ID = i.Industry_ID

JOIN AI_Workforce.AI_Adoption_Metrics am
ON ep.EMP_ID = am.EMP_ID

JOIN AI_Workforce.Job_Risk_Metrics jm
ON ep.EMP_ID = jm.EMP_ID

WHERE
	jm.Layoff_Risk = 'High'
	AND am.AI_Adoption_Level = 'Low'
	AND am.AI_Training_Hours < 10

GROUP BY
	i.Industry_Name

ORDER BY
	Employees_Needing_Intervention DESC;

-- ===========================================================
-- QUESTION 3:
-- Does AI training differ across layoff risk categories?
-- ===========================================================

SELECT
	jm.Layoff_Risk,
	COUNT(*) AS Number_of_Employees,
	AVG(am.AI_Training_Hours) AS Avg_Training_Hours

FROM AI_Workforce.AI_Adoption_Metrics am

JOIN AI_Workforce.Job_Risk_Metrics jm
ON am.EMP_ID = jm.EMP_ID

GROUP BY
	jm.Layoff_Risk

ORDER BY
	Avg_Training_Hours;


-- ===========================================================
-- QUESTION 4:
-- Is routine work associated with higher layoff risk?
-- ===========================================================


SELECT
	jm.Layoff_Risk,
	COUNT(*) AS Number_of_Employees,
	AVG(am.Routine_Task_Percentage) AS Avg_Routine_Task_Percentage

FROM AI_Workforce.AI_Adoption_Metrics am

JOIN AI_Workforce.Job_Risk_Metrics jm
ON am.EMP_ID = jm.EMP_ID

GROUP BY
	jm.Layoff_Risk

ORDER BY
	Avg_Routine_Task_Percentage;


-- ===========================================================
-- QUESTION 5:
-- Does the level of human interaction vary across
-- different layoff risk categories?
-- ===========================================================


SELECT
	jm.Layoff_Risk,
	am.Human_Interaction_Level,
	COUNT(*) AS Employee_Count

FROM AI_Workforce.AI_Adoption_Metrics am

JOIN AI_Workforce.Job_Risk_Metrics jm
ON am.EMP_ID = jm.EMP_ID

GROUP BY
	jm.Layoff_Risk,
	am.Human_Interaction_Level

ORDER BY
	jm.Layoff_Risk, 
	Employee_Count DESC;

/*
SELECT
	Human_Interaction_Level
FROM AI_Workforce.AI_Adoption_Metrics
LIMIT 20; 
*/



-- ===========================================================
-- QUESTION 6:
-- Does creativity requirement influence layoff risk?
-- ===========================================================

SELECT
	jm.Layoff_Risk,
	am.Creativity_Requirement,
	COUNT(*) AS Employee_Count

FROM AI_Workforce.AI_Adoption_Metrics am

JOIN AI_Workforce.Job_Risk_Metrics jm
ON am.EMP_ID = jm.EMP_ID

GROUP BY
	jm.Layoff_Risk,
	am.Creativity_Requirement

ORDER BY
	jm.Layoff_Risk, 
	Employee_Count DESC;


-- ===========================================================
-- QUESTION 7:
-- Is AI adoption level associated with layoff risk?
-- ===========================================================

SELECT
	jm.Layoff_Risk,
	am.AI_Adoption_Level,
	COUNT(*) AS Employee_Count

FROM AI_Workforce.AI_Adoption_Metrics am

JOIN AI_Workforce.Job_Risk_Metrics jm
ON am.EMP_ID = jm.EMP_ID

GROUP BY
	jm.Layoff_Risk,
	am.AI_Adoption_Level

ORDER BY
	jm.Layoff_Risk, 
	Employee_Count DESC;



-- ===========================================================
-- QUESTION 8:
-- Which employees should be prioritized for intervention?
--
-- Criteria:
-- • High Layoff Risk
-- • High Routine Task Percentage
-- • Low Creativity Requirement
-- • Low Human Interaction
--
-- These employees perform highly automatable work and may
-- require immediate upskilling or role redesign.
-- ===========================================================


-- Employees which should be intervene first --

SELECT
	ep.EMP_ID,
	ep.Age, 
	ep.Year_of_Exp, 
	am.Routine_Task_Percentage, 
	am.Creativity_Requirement, 
	am.Human_Interaction_Level,
	am.AI_Training_Hours, 
	jm.Layoff_Risk

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.AI_Adoption_Metrics am
ON ep.EMP_ID = am.EMP_ID

JOIN AI_Workforce.Job_Risk_Metrics jm
ON ep.EMP_ID = jm.EMP_ID

WHERE
    jm.Layoff_Risk = 'High'
	AND am.Routine_Task_Percentage >= 70
	AND am.Creativity_Requirement = 'Low'
	AND am.Human_Interaction_Level = 'Low'

ORDER BY
    am.Routine_Task_Percentage DESC,
    am.AI_Training_Hours ASC;





-- ===========================================================
-- QUESTION:
-- Which industry has received the highest total AI training
-- investment?
--
-- Demonstrates: SUM()
-- ===========================================================

SELECT
	i.Industry_Name,
	SUM(am.AI_Training_Hours) AS Total_Training_Hours

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.Industry_Dim i
ON ep.Industry_ID = i.Industry_ID

JOIN AI_Workforce.AI_Adoption_Metrics am
ON ep.EMP_ID = am.EMP_ID

GROUP BY
	i.Industry_Name

ORDER BY
	Total_Training_Hours DESC;


-- ===========================================================
-- QUESTION:
-- Which industry has the employee with the highest AI
-- training hours?
--
-- Demonstrates: MAX()
-- ===========================================================

SELECT
	i.Industry_Name,
	MAX(am.AI_Training_Hours) AS Highest_Training_Hours

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.Industry_Dim i
ON ep.Industry_ID = i.Industry_ID

JOIN AI_Workforce.AI_Adoption_Metrics am
ON ep.EMP_ID = am.EMP_ID

GROUP BY
	i.Industry_Name

ORDER BY
	Highest_Training_Hours DESC;


-- ===========================================================
-- QUESTION:
-- Which industry has the employee with the lowest AI
-- training hours?
--
-- Demonstrates: MIN()
-- ===========================================================

SELECT
	i.Industry_Name,
	MIN(am.AI_Training_Hours) AS Lowest_Training_Hours

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.Industry_Dim i
ON ep.Industry_ID = i.Industry_ID

JOIN AI_Workforce.AI_Adoption_Metrics am
ON ep.EMP_ID = am.EMP_ID

GROUP BY
	i.Industry_Name

ORDER BY
	Lowest_Training_Hours;



-- ===========================================================
-- QUESTION:
-- Which industries have more than 2,000 employees?
--
-- Demonstrates: HAVING
-- ===========================================================

SELECT
	i.Industry_Name,
	COUNT(*) AS Total_Employees

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.Industry_Dim i
ON ep.Industry_ID = i.Industry_ID

GROUP BY
	i.Industry_Name

HAVING
	COUNT(*) > 2000

ORDER BY
	Total_Employees DESC;



-- ===========================================================
-- QUESTION:
-- How can HR generate the intervention report without
-- rewriting the SQL query every time?
--
-- Demonstrates:
-- PostgreSQL Function 
-- ===========================================================

CREATE OR REPLACE FUNCTION AI_Workforce.Get_High_Risk_Employees()

RETURNS TABLE (
    EMP_ID INT,
    Age INT,
    Year_of_Exp INT,
    Routine_Task_Percentage NUMERIC,
    Creativity_Requirement VARCHAR,
    Human_Interaction_Level VARCHAR,
    AI_Training_Hours NUMERIC,
    Layoff_Risk VARCHAR
)

LANGUAGE plpgsql

AS
$$
BEGIN

RETURN QUERY

SELECT
    ep.EMP_ID,
    ep.Age,
    ep.Year_of_Exp,
    am.Routine_Task_Percentage,
    am.Creativity_Requirement,
    am.Human_Interaction_Level,
    am.AI_Training_Hours,
    jm.Layoff_Risk

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.AI_Adoption_Metrics am
ON ep.EMP_ID = am.EMP_ID

JOIN AI_Workforce.Job_Risk_Metrics jm
ON ep.EMP_ID = jm.EMP_ID

WHERE
    jm.Layoff_Risk = 'High'
    AND am.Routine_Task_Percentage >= 70
    AND am.Creativity_Requirement = 'Low'
    AND am.Human_Interaction_Level = 'Low'

ORDER BY
    am.Routine_Task_Percentage DESC,
    am.AI_Training_Hours ASC;

END;
$$;


SELECT *
FROM AI_Workforce.Get_High_Risk_Employees();



-- ===========================================================
-- QUESTION:
-- How can we automatically prepare new employees for future
-- AI and Risk tracking?
--
-- Demonstrates:
-- Trigger + Trigger Function
-- ===========================================================



CREATE OR REPLACE FUNCTION AI_Workforce.Create_Employee_Records()

RETURNS TRIGGER

LANGUAGE plpgsql

AS
$$

BEGIN

    INSERT INTO AI_Workforce.AI_Adoption_Metrics(
        EMP_ID
    )
    VALUES
    (
        NEW.EMP_ID
    );

    INSERT INTO AI_Workforce.Job_Risk_Metrics(
        EMP_ID
    )
    VALUES
    (
        NEW.EMP_ID
    );

    RETURN NEW;

END;
$$;


--- TRIGGER CREATION --

CREATE TRIGGER trg_Create_Employee_Records

AFTER INSERT

ON AI_Workforce.Employee_Profile

FOR EACH ROW

EXECUTE FUNCTION AI_Workforce.Create_Employee_Records();

--- DEMO: INSERT a brand new employee

INSERT INTO AI_Workforce.Employee_Profile
(
    EMP_ID,
    Age,
    Edu_Level,
    Year_of_Exp,
    Industry_ID,
    Role_ID,
    Company_Size_ID,
    Job_Level_ID
)

VALUES
(
    20001,
    28,
    'Bachelor',
    4,
    2,
    5,
    1,
    2
);


SELECT *
FROM AI_Workforce.AI_Adoption_Metrics
WHERE EMP_ID = 20001;

SELECT *
FROM AI_Workforce.Job_Risk_Metrics
WHERE EMP_ID = 20001;



-- ===========================================================
-- QUESTION:
-- How can HR automatically track employees whose Layoff Risk
-- changes to HIGH without manually monitoring the database?
--
-- Demonstrates:
-- Trigger + Trigger Function
-- ===========================================================

CREATE TABLE AI_Workforce.Intervention_Log(

    Log_ID SERIAL PRIMARY KEY,

    EMP_ID INT,

    Layoff_Risk VARCHAR(50),

    Logged_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



SELECT *
FROM AI_Workforce.Intervention_Log;

CREATE OR REPLACE FUNCTION AI_Workforce.Log_High_Risk_Employee()

RETURNS TRIGGER

LANGUAGE plpgsql

AS
$$

BEGIN

    IF NEW.Layoff_Risk = 'High'
       AND OLD.Layoff_Risk IS DISTINCT FROM 'High'
    THEN

        INSERT INTO AI_Workforce.Intervention_Log
        (
            EMP_ID,
            Layoff_Risk
        )

        VALUES
        (
            NEW.EMP_ID,
            NEW.Layoff_Risk
        );

    END IF;

    RETURN NEW;

END;
$$;


CREATE TRIGGER trg_Log_High_Risk

AFTER UPDATE OF Layoff_Risk

ON AI_Workforce.Job_Risk_Metrics

FOR EACH ROW

EXECUTE FUNCTION AI_Workforce.Log_High_Risk_Employee();


UPDATE AI_Workforce.Job_Risk_Metrics
SET Layoff_Risk = 'High'
WHERE EMP_ID = 2;


SELECT *
FROM AI_Workforce.Intervention_Log
ORDER BY Logged_At DESC;


-- ===========================================================
-- SECTION 11 : Reporting View
-- Objective: Create a single reporting layer for Power BI.
-- ===========================================================

CREATE OR REPLACE VIEW AI_Workforce.Reporting_View AS

SELECT

    ep.EMP_ID,
    ep.Age,
    ep.Edu_Level,
    ep.Year_of_Exp,

    i.Industry_Name,
    rd.Role_Name,
    cs.Company_Size_Name,
    jl.Job_Level_Name,

    am.Routine_Task_Percentage,
    am.Creativity_Requirement,
    am.Human_Interaction_Level,
    am.AI_Adoption_Level,
    am.No_of_AI_Tools_Used,
    am.AI_Usage_Hours_Per_Week,
    am.Task_Automated_Group,
    am.AI_Training_Hours,

    jm.Layoff_Risk

FROM AI_Workforce.Employee_Profile ep

JOIN AI_Workforce.Industry_Dim i
ON ep.Industry_ID = i.Industry_ID

JOIN AI_Workforce.Role_Dim rd
ON ep.Role_ID = rd.Role_ID

JOIN AI_Workforce.Company_Size_Dim cs
ON ep.Company_Size_ID = cs.Company_Size_ID

JOIN AI_Workforce.Job_Level_Dim jl
ON ep.Job_Level_ID = jl.Job_Level_ID

JOIN AI_Workforce.AI_Adoption_Metrics am
ON ep.EMP_ID = am.EMP_ID

JOIN AI_Workforce.Job_Risk_Metrics jm
ON ep.EMP_ID = jm.EMP_ID;


SELECT *
FROM AI_Workforce.Reporting_View
LIMIT 10;

-- ===========================================================
-- INVESTIGATION SUMMARY
--
-- Key Findings:
-- • Employees performing more routine work were more likely
--   to have a higher layoff risk.
--
-- • High-risk employees also received more AI training,
--   suggesting training may be reactive rather than preventive.
--
-- • Human interaction, creativity requirement, and AI adoption
--   level showed relatively weak relationships with layoff risk
--   in this dataset.
--
-- These findings will be explored further through interactive
-- visualizations in Power BI.
-- ===========================================================

SELECT * FROM AI_Workforce.Employee_Profile;


SELECT Current_Database();



SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'AI_Workforce';


SELECT *
FROM AI_Workforce.Reporting_View
LIMIT 5;

















