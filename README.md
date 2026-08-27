
# Customer Churn Analysis & Dashboard

## 📌 Project Overview

This project analyzes customer churn data to identify patterns, understand customer attrition, and present key business insights through an interactive Power BI dashboard.

The project follows an end-to-end data analytics workflow:

*Raw Data → Excel → Python/Jupyter Notebook → Pandas → Clean CSV → SQL Analysis → Power BI Dashboard*

## 🔄 Project Workflow

### 1. Data Preparation — Excel

- Imported and reviewed the raw dataset in Excel.
- Checked the data structure and identified data quality issues.
- Performed initial data cleaning and preparation.

### 2. Data Cleaning — Python

- Loaded the Excel data into a Jupyter Notebook.
- Used the *Pandas* library for data cleaning and transformation.
- Handled missing values and inconsistent data where required.
- Standardized the dataset for further analysis.
- Exported the cleaned dataset as a *CSV file*.

### 3. SQL Analysis

- Used the cleaned CSV file for SQL analysis.
- Wrote SQL queries to explore customer behavior and churn patterns.
- Analyzed relevant customer segments and business metrics.
- Used SQL analysis to support the insights presented in the dashboard.

### 4. Power BI Visualization

- Imported the cleaned data into Power BI.
- Created an interactive dashboard to visualize customer churn.
- Used charts, KPIs, filters, and other visual elements.
- Designed the dashboard to highlight important churn patterns and business insights.

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| *Microsoft Excel* | Raw data preparation and review |
| *Python* | Data cleaning and transformation |
| *Jupyter Notebook* | Python-based data analysis |
| *Pandas* | Data manipulation and cleaning |
| *SQL* | Data analysis and querying |
| *Power BI* | Data visualization and dashboard creation |

## 📊 Key Analysis Areas

- Customer churn and retention
- Customer demographics and characteristics
- Churn patterns across different customer segments
- Factors associated with higher churn
- Key business metrics related to customer retention

## 📈 Dashboard

The final Power BI dashboard provides an interactive view of the analysis, allowing users to explore customer churn patterns through visualizations, KPIs, and filters.

### Dashboard Preview

<img width="467" height="284" alt="customer churn dashboard" src="https://github.com/user-attachments/assets/dee1b591-3aac-4dfc-9cfc-8f35fdb28309" />


## 📁 Project Structure

```text
Customer-Churn-Analysis/
│
├── data/
│   ├── raw_data.xlsx
│   └── clean_data.csv
│
├── python/
│   └── data_cleaning.ipynb
│
├── sql/
│   └── churn_analysis.sql
│
├── powerbi/
│   └── customer_churn_dashboard.pbix
│
├── images/
   └── dashboard-preview.png



