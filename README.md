# Vertex Pharma UK Limited | People Analytics Engagement

**Simulated Big 4 consulting engagement | People & Organisation Practice**

A end-to-end people analytics project built around a fictional pharmaceutical client, Vertex Pharma UK Limited, commissioned to investigate rising voluntary attrition and deliver data-led retention recommendations to the Board People Committee.

The project spans the full analytics pipeline: SQL Server data modelling, Python-based exploratory analysis and predictive modelling, and a four-page Power BI dashboard, supported by two formal consulting documents.

---

## Business Context

Vertex Pharma UK Limited is a mid-sized pharmaceutical organisation employing 1,470 staff across three departments: Sales, Research & Development, and Human Resources. Over a 12-month period, voluntary attrition rose to 16.1%, representing 237 departures and an estimated financial cost of £12.4 million based on standard replacement cost assumptions.

The Chief People Officer commissioned this engagement to:

- Quantify attrition at organisational, departmental, and role level
- Identify the primary drivers of voluntary departure
- Build a predictive model to identify employees at risk of leaving
- Deliver prioritised, actionable recommendations for the Board

---

## Project Structure

```
vertex-pharma-people-analytics/
│
├── README.md
│
├── docs/
│   ├── VP_Engagement_Brief.docx        # Formal client engagement brief
│   └── VP_Executive_Summary.docx       # Board-ready two-page summary
│
├── sql/
│   ├── 01_create_database.sql          # Database creation
│   ├── 02_create_tables.sql            # Star schema table definitions
│   ├── 03_insert_dimensions.sql        # Dimension table population
│   ├── 04_staging_and_load.sql         # Staging table, BULK INSERT, fact load
│   └── 05_exploratory_analysis.sql     # 11 analytical queries
│
├── notebooks/
│   └── VertexPharma.ipynb              # Full audit, feature engineering, modelling
│
├── dashboard/
│   └── VertexPharma.pbix               # Four-page Power BI dashboard
│
├── data/
│   ├── VP_Dashboard_Data.csv           # Scored dataset for Power BI
│   └── VP_EmployeeRiskScores.csv       # Individual risk scores and bands
│
└── images/
    └── StarSchema.png                  # SQL Server star schema diagram
```

---

## Dataset

This project uses the IBM HR Analytics Employee Attrition and Performance dataset, available on Kaggle:

[IBM HR Analytics Employee Attrition Dataset](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)

The raw CSV is not included in this repository. Download `WA_Fn-UseC_-HR-Employee-Attrition.csv` from Kaggle and place it in the `data/` folder before running the SQL load scripts or the Python notebook.

---

## Technical Stack

| Layer | Technology |
|---|---|
| Database | SQL Server (SSMS) |
| Data modelling | Star schema (1 fact table, 8 dimension tables) |
| Analysis and modelling | Python, Pandas, Scikit-learn, XGBoost, Imbalanced-learn |
| Visualisation | Power BI Desktop |
| Documents | Microsoft Word (.docx) |

---

## SQL Schema

The data is modelled as a star schema with `FactEmployee` at the centre referencing eight dimension tables:

- `DimDepartment`
- `DimJobRole`
- `DimEducationField`
- `DimBusinessTravel`
- `DimEducation`
- `DimPerformanceRating`
- `DimWorkLifeBalance`
- `DimSatisfactionScale`

![Star Schema](images/StarSchema.png)

Data is loaded via a staging table (`Staging_Employee`) which accepts the raw CSV strings before transforming and inserting into the fact table with integer foreign keys and binary encoded columns.

To run the SQL scripts, execute them in numerical order against a SQL Server instance. Update the file path in `04_staging_and_load.sql` to match your local CSV location before running.

---

## Exploratory Analysis

Eleven SQL queries were developed across `05_exploratory_analysis.sql` covering:

| Query | Finding |
|---|---|
| Overall attrition rate | 16.1% across 1,470 employees |
| Attrition by department | Sales highest at 20.6% |
| Attrition by job role | Sales Representatives at 39.8%, nearly 2.5x the average |
| Attrition by overtime status | Overtime employees at 30.5% vs 10.4% for non-overtime |
| Overtime rate by department | Consistent at 27-29% across all departments |
| Overtime rate by job role | Research Scientists highest at 33.2% |
| Attrition by income band | Below £3,000/month at 28.6%, highest of any band |
| Average income by job role | Sales Representatives lowest paid at £2,626/month |
| Attrition by promotion band | Weak signal, not a primary driver |
| Attrition by business travel | Frequent travellers at 24.9% |
| Attrition by stock option level | No options group at 24.4% |

---

## Python Notebook

The notebook (`notebooks/VertexPharma.ipynb`) covers the full modelling pipeline in documented, markdown-annotated cells:

**Data Audit**
- Shape and structure check
- Null and missing value assessment
- Target variable distribution and class imbalance identification (5:1 ratio)
- Cardinality check on categorical columns
- Numerical distribution analysis

**Feature Engineering**
Four derived features were created to improve predictive power:
- `PromotionGap`: years at company minus years since last promotion
- `TenureRatio`: proportion of total career spent at Vertex
- `IncomePerJobLevel`: compensation relative to seniority
- `SatisfactionIndex`: composite of four satisfaction scores

**Preprocessing**
- Binary encoding for Gender, OverTime, Attrition
- One-hot encoding for Department, JobRole, BusinessTravel, EducationField, MaritalStatus
- SMOTE applied to training set only to address 5:1 class imbalance
- StandardScaler applied for logistic regression

**Model Evaluation**

| Model | ROC-AUC | Recall (Left) |
|---|---|---|
| Logistic Regression | 0.812 | 0.38 |
| XGBoost | 0.761 | 0.32 |
| Random Forest | 0.755 | 0.28 |

Logistic Regression was selected as the final model on the basis of superior ROC-AUC performance and interpretability for client-facing recommendations.

**Risk Segmentation**

| Risk Band | Employees | Avg Risk Score |
|---|---|---|
| High (score above 0.60) | 101 | 77.3% |
| Medium (score 0.30-0.60) | 182 | 42.5% |
| Low (score below 0.30) | 1,187 | 7.4% |

The 101 high-risk employees are disproportionately junior (65% at Job Level 1), single (72%), working overtime (59%), and earning below the organisational median of £4,919/month.

---

## Power BI Dashboard

The dashboard comprises four pages:

**Page 1: Executive Overview**
Headline KPIs, attrition by department and job role, income band analysis, and workforce risk distribution. Includes a Key Insights text box summarising the four most critical findings.

**Page 2: Attrition Drivers**
Eight driver charts covering overtime, business travel, distance from home, job level, marital status, training frequency, stock option level, and age band. All charts use conditional colouring (red above 16.1% organisational average, green below) with reference lines.

**Page 3: Risk Segmentation**
Traffic light KPI cards, high-risk employee breakdown by department and job role, overtime distribution among high-risk employees, and a scatter chart of risk score versus monthly income confirming the income-attrition relationship at the individual employee level.

**Page 4: Employee Risk Explorer**
Operational table for HR use, filterable by department, job role, and risk band. Sorted by risk score descending so the highest-risk employees appear first. Includes dynamic KPI cards showing selected employee count, average risk score, median income, and high-risk count.

---

## Key Findings

1. Sales Representatives have an attrition rate of 39.8%, nearly 2.5 times the organisational average
2. Employees earning below £3,000 per month leave at 28.6%, 77% above the organisational average
3. Overtime employees have an attrition rate of 30.5%, 89% above the organisational average
4. 101 employees are currently at high risk of leaving, concentrated in Sales and R&D
5. The estimated annual cost of attrition is £12.4 million

---

## Recommendations

| Priority | Recommendation | Target Group |
|---|---|---|
| 1 | Compensation review for Job Level 1 and 2 roles in Sales and R&D | Sales Representatives, Laboratory Technicians |
| 2 | Overtime reduction policy for junior employees | 101 high-risk employees, 60% of whom work overtime |
| 3 | Mandatory minimum training programme of 3 sessions per year | 54 employees who received no training last year |
| 4 | Extend stock option scheme to Job Level 1 and 2 employees | 631 employees with no current stock options |

---

## Deliverables

- `docs/VP_Engagement_Brief.docx`: Formal nine-section engagement brief written in Big 4 consulting style, covering client background, objectives, scope, workstreams, data requirements, and governance
- `docs/VP_Executive_Summary.docx`: Two-page Board-ready summary covering situation, key findings, prioritised recommendations, next steps, and analytical methodology

---

## Author

**Kehinde Aridunnu**
MSc Data Science, University of Salford
Former BI Analyst | People Analytics | NHS and Public Sector Data

[GitHub](https://github.com/aridunnu) | [LinkedIn](https://www.linkedin.com/in/)

---

*Vertex Pharma UK Limited is a fictional organisation created for portfolio and analytical demonstration purposes. All data referenced is synthetic, based on the IBM HR Analytics Employee Attrition dataset.*
