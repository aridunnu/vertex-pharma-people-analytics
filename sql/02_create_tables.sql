-- =============================================
-- Project:  Vertex Pharma People Analytics
-- Script:   02_create_tables.sql
-- Purpose:  Create dimension tables and FactEmployee
--           Run dimension tables first, FactEmployee last
-- Author:   Kehinde Fakeye
-- Date:     June 2026
-- =============================================


CREATE TABLE DimDepartment( 
DepartmentKey int IDENTITY(1,1) PRIMARY KEY, 
DepartmentName nvarchar(30) NOT NULL );

CREATE TABLE DimJobRole( 
JobRoleKey int IDENTITY(1,1) PRIMARY KEY, 
JobRoleName nvarchar(50) NOT NULL );

CREATE TABLE DimEducationField( 
EducationFieldKey int IDENTITY(1,1) PRIMARY KEY, 
EducationFieldName nvarchar(30) NOT NULL );

CREATE TABLE DimBusinessTravel(
BusinessTravelKey int IDENTITY(1,1) PRIMARY KEY, 
BusinessTravelName nvarchar(30) NOT NULL );

CREATE TABLE DimEducation(
EducationScaleValue int  PRIMARY KEY, 
EducationScaleLabel nvarchar(20) NOT NULL
);

CREATE TABLE DimPerformanceRating(
PerformanceRatingScaleValue int PRIMARY KEY, 
PerformanceRatingScaleLabel nvarchar(20) NOT NULL
);

CREATE TABLE DimWorkLifeBalance( 
WorkLifeBalanceScaleValue int PRIMARY KEY, 
WorkLifeBalanceScaleLabel nvarchar(10) NOT NULL
);

CREATE TABLE DimSatisfactionScale(
ScaleValue int PRIMARY KEY, 
ScaleLabel nvarchar(15) NOT NULL
);

CREATE TABLE FactEmployee(
EmployeeNumber int PRIMARY KEY,

DepartmentKey int NOT NULL,
  CONSTRAINT FK_FactEmployee_DimDepartment
  FOREIGN KEY (DepartmentKey)
  REFERENCES DimDepartment(DepartmentKey),

JobRoleKey int NOT NULL,
  CONSTRAINT FK_FactEmployee_DimJobRole
  FOREIGN KEY (JobRoleKey)
  REFERENCES DimJobRole(JobRoleKey),

EducationFieldKey int NOT NULL,
  CONSTRAINT FK_FactEmployee_DimEducationField
  FOREIGN KEY (EducationFieldKey)
  REFERENCES DimEducationField(EducationFieldKey),

BusinessTravelKey int NOT NULL,
  CONSTRAINT FK_FactEmployee_DimBusinessTravel
  FOREIGN KEY (BusinessTravelKey)
  REFERENCES DimBusinessTravel(BusinessTravelKey),

Age int NOT NULL,
Gender bit NOT NULL,
MaritalStatus smallint NOT NULL,
OverTime bit NOT NULL,
Attrition bit NOT NULL,
DailyRate  decimal (18,2) NOT NULL,
HourlyRate decimal (18,2) NOT NULL,
MonthlyIncome decimal (18,2) NOT NULL,
MonthlyRate decimal (18,2) NOT NULL,
PercentSalaryHike int NOT NULL,
StockOptionLevel int NOT NULL,
Education int NOT NULL,
JobLevel int NOT NULL,
JobInvolvement int NOT NULL,
EnvironmentSatisfaction int NOT NULL,
JobSatisfaction int NOT NULL,
RelationshipSatisfaction int NOT NULL,
WorkLifeBalance int NOT NULL,
PerformanceRating int NOT NULL,
DistanceFromHome int NOT NULL,
NumCompaniesWorked int NOT NULL,
TotalWorkingYears int NOT NULL,
TrainingTimesLastYear int NOT NULL,
YearsAtCompany int NOT NULL,
YearsInCurrentRole int NOT NULL,
YearsSinceLastPromotion int NOT NULL,
YearsWithCurrManager int NOT NULL
);