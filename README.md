# Retail_Customer_Analytics-_and_Predictive_Modeling
# Retail Analytics Project

## Overview

This project presents an end-to-end retail data analysis pipeline, starting from raw transactional data to advanced analytics and predictive modeling. It combines SQL and Python to extract insights, segment customers, forecast sales, and build a profitability prediction model.

---

## Project Structure

```
Retail-Analytics-Project/
│
├── 1_Data_Cleaning_and_EDA.ipynb
├── 2_SQL_Exploratory_Analysis.sql
├── 3_Advanced_Analytics_and_Modeling.ipynb
```

---

## Key Components


### 1. Data Cleaning and EDA (Python)

* Cleaned and prepared dataset for analysis
* Handled missing values and data types
* Performed exploratory data analysis to identify trends and patterns

---
### 2. SQL Exploratory Analysis

* Performed initial analysis using SQL queries
* Identified top products, customer behavior, and regional performance
* Aggregated sales, profit, and order-level insights

---

### 3. Advanced Analytics and Modeling

#### Customer Segmentation (RFM + Clustering)

* Built RFM (Recency, Frequency, Monetary) metrics using SQL
* Applied K-Means clustering to segment customers
* Analyzed cluster behavior and business value

#### Cohort Analysis

* Tracked customer retention over time
* Built retention matrix to understand repeat behavior

#### Sales Forecasting

* Aggregated monthly sales data
* Built time series forecasting model using Prophet

#### Profitability Prediction

* Created classification model to predict profitable vs unprofitable orders
* Handled class imbalance using appropriate techniques
* Evaluated model performance (~94% accuracy)

---

## Tools and Technologies

* **SQL (PostgreSQL)** – Data extraction and aggregation
* **Python** – Data analysis and modeling
* **Pandas, NumPy** – Data manipulation
* **Matplotlib** – Data visualization
* **Scikit-learn** – Machine learning (clustering, classification)
* **Prophet** – Time series forecasting

---

## Conclusion

This project demonstrates the complete analytics workflow:

* Data extraction → Cleaning → Analysis → Modeling 

It highlights the ability to combine SQL and Python for real-world business problem solving.

---
