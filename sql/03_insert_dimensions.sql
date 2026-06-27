-- =============================================
-- Project:  Vertex Pharma People Analytics
-- Script:   03_insert_dimensions.sql
-- Purpose:  Populate all dimension tables with
--           reference data
-- Author:   Kehinde Fakeye
-- Date:     June 2026
-- =============================================




-- DimDepartment
INSERT INTO DimDepartment (DepartmentName) VALUES
('Research & Development'),
('Sales'),
('Human Resources');

-- DimJobRole
INSERT INTO DimJobRole (JobRoleName) VALUES
('Sales Executive'),
('Research Scientist'),
('Laboratory Technician'),
('Manufacturing Director'),
('Healthcare Representative'),
('Manager'),
('Sales Representative'),
('Research Director'),
('Human Resources');

-- DimEducationField
INSERT INTO DimEducationField (EducationFieldName) VALUES
('Life Sciences'),
('Medical'),
('Marketing'),
('Technical Degree'),
('Other'),
('Human Resources');

-- DimBusinessTravel
INSERT INTO DimBusinessTravel (BusinessTravelName) VALUES
('Travel_Rarely'),
('Travel_Frequently'),
('Non-Travel');

-- DimEducation
INSERT INTO DimEducation (EducationScaleValue, EducationScaleLabel) VALUES
(1, 'Below College'),
(2, 'College'),
(3, 'Bachelor'),
(4, 'Master'),
(5, 'Doctor');

-- DimPerformanceRating
INSERT INTO DimPerformanceRating (PerformanceRatingScaleValue, PerformanceRatingScaleLabel) VALUES
(1, 'Low'),
(2, 'Good'),
(3, 'Excellent'),
(4, 'Outstanding');

-- DimWorkLifeBalance
INSERT INTO DimWorkLifeBalance (WorkLifeBalanceScaleValue, WorkLifeBalanceScaleLabel) VALUES
(1, 'Bad'),
(2, 'Good'),
(3, 'Better'),
(4, 'Best');

-- DimSatisfactionScale
INSERT INTO DimSatisfactionScale (ScaleValue, ScaleLabel) VALUES
(1, 'Low'),
(2, 'Medium'),
(3, 'High'),
(4, 'Very High');
