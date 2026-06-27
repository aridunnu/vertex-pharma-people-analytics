-- =============================================
-- Project:  Vertex Pharma People Analytics
-- Script:   04_staging_and_load.sql
-- Purpose:  Create staging table, bulk load raw CSV,
--           transform and insert into FactEmployee
-- Note:     Update file path in BULK INSERT before running
-- Author:   Kehinde Fakeye
-- Date:     June 2026
-- =============================================



CREATE TABLE Staging_Employee(
    Age int,
    Attrition nvarchar(5),
    BusinessTravel nvarchar(30),
    DailyRate int,
    Department nvarchar(50),
    DistanceFromHome int,
    Education int,
    EducationField nvarchar(50),
    EmployeeCount int,
    EmployeeNumber int,
    EnvironmentSatisfaction int,
    Gender nvarchar(10),
    HourlyRate int,
    JobInvolvement int,
    JobLevel int,
    JobRole nvarchar(50),
    JobSatisfaction int,
    MaritalStatus nvarchar(15),
    MonthlyIncome int,
    MonthlyRate int,
    NumCompaniesWorked int,
    Over18 nvarchar(5),
    OverTime nvarchar(5),
    PercentSalaryHike int,
    PerformanceRating int,
    RelationshipSatisfaction int,
    StandardHours int,
    StockOptionLevel int,
    TotalWorkingYears int,
    TrainingTimesLastYear int,
    WorkLifeBalance int,
    YearsAtCompany int,
    YearsInCurrentRole int,
    YearsSinceLastPromotion int,
    YearsWithCurrManager int
);

BULK INSERT Staging_Employee
FROM 'C:\Users\hp\Documents\vertex-pharma-people-analytics\WA_Clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);

SELECT TOP 5 * FROM Staging_Employee;

INSERT INTO FactEmployee (
    EmployeeNumber, DepartmentKey, JobRoleKey, EducationFieldKey, BusinessTravelKey,
    Age, Gender, MaritalStatus, OverTime, Attrition,
    DailyRate, HourlyRate, MonthlyIncome, MonthlyRate, PercentSalaryHike,
    StockOptionLevel, Education, JobLevel, JobInvolvement, EnvironmentSatisfaction,
    JobSatisfaction, RelationshipSatisfaction, WorkLifeBalance, PerformanceRating,
    DistanceFromHome, NumCompaniesWorked, TotalWorkingYears, TrainingTimesLastYear,
    YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager
)
SELECT
    s.EmployeeNumber,
    d.DepartmentKey,
    jr.JobRoleKey,
    ef.EducationFieldKey,
    bt.BusinessTravelKey,
    s.Age,
    CASE WHEN s.Gender = 'Male' THEN 1 ELSE 0 END,
    CASE s.MaritalStatus 
        WHEN 'Single' THEN 1 
        WHEN 'Married' THEN 2 
        WHEN 'Divorced' THEN 3 
    END,
    CASE WHEN s.OverTime = 'Yes' THEN 1 ELSE 0 END,
    CASE WHEN s.Attrition = 'Yes' THEN 1 ELSE 0 END,
    s.DailyRate, s.HourlyRate, s.MonthlyIncome, s.MonthlyRate, s.PercentSalaryHike,
    s.StockOptionLevel, s.Education, s.JobLevel, s.JobInvolvement,
    s.EnvironmentSatisfaction, s.JobSatisfaction, s.RelationshipSatisfaction,
    s.WorkLifeBalance, s.PerformanceRating, s.DistanceFromHome,
    s.NumCompaniesWorked, s.TotalWorkingYears, s.TrainingTimesLastYear,
    s.YearsAtCompany, s.YearsInCurrentRole, s.YearsSinceLastPromotion,
    s.YearsWithCurrManager
FROM Staging_Employee s
INNER JOIN DimDepartment d ON d.DepartmentName = s.Department
INNER JOIN DimJobRole jr ON jr.JobRoleName = s.JobRole
INNER JOIN DimEducationField ef ON ef.EducationFieldName = s.EducationField
INNER JOIN DimBusinessTravel bt ON bt.BusinessTravelName = s.BusinessTravel;


