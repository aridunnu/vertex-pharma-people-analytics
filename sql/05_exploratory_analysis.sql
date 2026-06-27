-- =============================================
-- Project:  Vertex Pharma People Analytics
-- Script:   05_exploratory_analysis.sql
-- Purpose:  Exploratory SQL analysis answering the
--           six key questions from the engagement brief
-- Author:   Kehinde Fakeye
-- Date:     June 2026
-- =============================================

--Q1: Overall Attrition Rate

SELECT
    COUNT(DISTINCT EmployeeNumber) AS TotalEmployees,
    SUM(CAST(Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(DISTINCT EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM FactEmployee;

--Q2: Attrition rate by department

SELECT
    dd.DepartmentName,
    COUNT(DISTINCT fe.EmployeeNumber) AS TotalEmployees,
    SUM(CAST(fe.Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(fe.Attrition AS INT)) * 100.0 / COUNT(DISTINCT fe.EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM FactEmployee fe
LEFT JOIN DimDepartment dd ON dd.DepartmentKey = fe.DepartmentKey
GROUP BY DepartmentName
ORDER BY AttritionRate Desc;


--Q3: Attrition rate by job role

SELECT
    djr.JobRoleName,
    COUNT(DISTINCT fe.EmployeeNumber) AS TotalEmployees,
    SUM(CAST(fe.Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(fe.Attrition AS INT)) * 100.0 / COUNT(DISTINCT fe.EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM FactEmployee fe
LEFT JOIN DimJobRole djr ON djr.JobRoleKey = fe.JobRoleKey
GROUP BY JobRoleName
ORDER BY AttritionRate Desc;


-- Q4: Attrition rate by overtime status

SELECT
CASE WHEN OverTime =1 THEN 'Yes' ELSE 'No' END AS OverTimeStatus,
    COUNT(DISTINCT fe.EmployeeNumber) AS TotalEmployees,
    SUM(CAST(fe.Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(fe.Attrition AS INT)) * 100.0 / COUNT(DISTINCT fe.EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM FactEmployee fe
GROUP BY OverTime
ORDER BY AttritionRate DESC;

-- Q4b: Overtime rate by department (context for Q4)

SELECT
    dd.DepartmentName,
    COUNT(DISTINCT fe.EmployeeNumber) AS TotalEmployees,
    SUM(CAST(fe.Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(fe.Attrition AS INT)) * 100.0 / COUNT(DISTINCT fe.EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate,
    SUM(CASE WHEN fe.OverTime = 1 THEN 1 ELSE 0 END) AS OvertimeCount,
    CAST(
        (SUM(CASE WHEN fe.OverTime = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT fe.EmployeeNumber))
    AS DECIMAL(5,2)) AS OvertimeRate
FROM FactEmployee fe
LEFT JOIN DimDepartment dd ON dd.DepartmentKey = fe.DepartmentKey
GROUP BY dd.DepartmentName
ORDER BY AttritionRate DESC;

-- Q4c: Overtime rate by job role (context for Q4)

SELECT
    djr.JobRoleName,
    COUNT(DISTINCT fe.EmployeeNumber) AS TotalEmployees,
    SUM(CAST(fe.Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(fe.Attrition AS INT)) * 100.0 / COUNT(DISTINCT fe.EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate,
    SUM(CASE WHEN fe.OverTime = 1 THEN 1 ELSE 0 END) AS OvertimeCount,
    CAST(
        (SUM(CASE WHEN fe.OverTime = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT fe.EmployeeNumber))
    AS DECIMAL(5,2)) AS OvertimeRate
FROM FactEmployee fe
LEFT JOIN DimJobRole djr ON djr.JobRoleKey = fe.JobRoleKey
GROUP BY djr.JobRoleName
ORDER BY AttritionRate DESC;

-- Q5: Attrition by years since last promotion

SELECT
    PromotionBand,
    COUNT(DISTINCT EmployeeNumber) AS TotalEmployees,
    SUM(CAST(Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(DISTINCT EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM (
    SELECT
        EmployeeNumber,
        Attrition,
        CASE
            WHEN YearsSinceLastPromotion <= 1 THEN '0-1 Years'
            WHEN YearsSinceLastPromotion <= 4 THEN '2-4 Years'
            WHEN YearsSinceLastPromotion <= 9 THEN '5-9 Years'
            ELSE '10+ Years'
        END AS PromotionBand
    FROM FactEmployee
) sub
GROUP BY PromotionBand
ORDER BY AttritionRate DESC;

-- Q6: Attrition by monthly income band

SELECT
MonthlyIncomeBand,
    COUNT(DISTINCT EmployeeNumber) AS TotalEmployees,
    SUM(CAST(Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(DISTINCT EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM (
    SELECT
        EmployeeNumber,
        Attrition,
        CASE
            WHEN MonthlyIncome <= 3000 THEN 'Below 3000'
            WHEN MonthlyIncome <= 6000 THEN '3000-6000'
            WHEN MonthlyIncome <= 10000 THEN '6001-10000'
            ELSE 'Above 10000'
        END AS MonthlyIncomeBand
    FROM FactEmployee
) sub
GROUP BY MonthlyIncomeBand
ORDER BY AttritionRate DESC;


-- Q6b: Average monthly income by job role (confirmatory)

SELECT
    djr.JobRoleName,
    CAST(AVG(fe.MonthlyIncome) AS DECIMAL(10,2)) AS AvgMonthlyIncome
FROM FactEmployee fe
LEFT JOIN DimJobRole djr ON djr.JobRoleKey = fe.JobRoleKey
GROUP BY djr.JobRoleName
ORDER BY AvgMonthlyIncome ASC;

-- Q7: Attrition rate by business travel frequency
SELECT
    dbt.BusinessTravelName,
    COUNT(DISTINCT fe.EmployeeNumber) AS TotalEmployees,
    SUM(CAST(fe.Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(fe.Attrition AS INT)) * 100.0 / COUNT(DISTINCT fe.EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM FactEmployee fe
LEFT JOIN DimBusinessTravel dbt ON dbt.BusinessTravelKey = fe.BusinessTravelKey
GROUP BY dbt.BusinessTravelName
ORDER BY AttritionRate DESC;

-- Q8: Attrition rate by distance from home band
SELECT
    DistanceBand,
    COUNT(DISTINCT EmployeeNumber) AS TotalEmployees,
    SUM(CAST(Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(DISTINCT EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM (
    SELECT
        EmployeeNumber,
        Attrition,
        CASE
            WHEN DistanceFromHome <= 5 THEN '0-5 Miles'
            WHEN DistanceFromHome <= 10 THEN '6-10 Miles'
            WHEN DistanceFromHome <= 20 THEN '11-20 Miles'
            ELSE '21+ Miles'
        END AS DistanceBand
    FROM FactEmployee
) sub
GROUP BY DistanceBand
ORDER BY AttritionRate DESC;

-- Q9: Attrition rate by gender
SELECT
    CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END AS Gender,
    COUNT(DISTINCT EmployeeNumber) AS TotalEmployees,
    SUM(CAST(Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(DISTINCT EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM FactEmployee
GROUP BY Gender
ORDER BY AttritionRate DESC;


-- Q10: Attrition rate by training times last year
SELECT
    TrainingTimesLastYear,
    COUNT(DISTINCT EmployeeNumber) AS TotalEmployees,
    SUM(CAST(Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(DISTINCT EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM FactEmployee
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear ASC;

-- Q12: Attrition by stock option level

SELECT StockOptionLevel,
COUNT(DISTINCT EmployeeNumber) AS TotalEmployees,
SUM(CAST(Attrition AS INT)) AS TotalAttrition,
CAST((SUM(CAST(Attrition AS INT)) * 100.0 / 
COUNT(DISTINCT EmployeeNumber)) AS DECIMAL(5,2)) AS AttritionRate
FROM FactEmployee
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel ASC;


-- Q11: Attrition rate by age band
SELECT
    AgeBand,
    COUNT(DISTINCT EmployeeNumber) AS TotalEmployees,
    SUM(CAST(Attrition AS INT)) AS TotalAttrition,
    CAST(
        (SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(DISTINCT EmployeeNumber))
    AS DECIMAL(5,2)) AS AttritionRate
FROM (
    SELECT
        EmployeeNumber,
        Attrition,
        CASE
            WHEN Age <= 25 THEN '18-25'
            WHEN Age <= 35 THEN '26-35'
            WHEN Age <= 45 THEN '36-45'
            WHEN Age <= 55 THEN '46-55'
            ELSE '56+'
        END AS AgeBand
    FROM FactEmployee
) sub
GROUP BY AgeBand
ORDER BY AgeBand ASC;