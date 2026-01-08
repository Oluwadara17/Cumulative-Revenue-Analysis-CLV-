## Title: Cumulative ANALYSIS (CLV)
# Author: Oluwadara Olamide 

# Customer Lifetime Value (CLV) Analysis Using Cohort Modelling

## Project Overview

This project is a follow-up analysis aimed at improving the accuracy and usefulness of **Customer Lifetime Value (CLV)** calculations. Following management feedback, the traditional **Shopify CLV formula** was deemed overly simplistic. Instead, a **cohort-based approach** was adopted to produce more reliable and actionable insights.
The analysis uses **weekly user cohorts**, includes **all website visitors** (not only purchasers), and evaluates revenue behaviour over a **12-week customer lifetime window**. This approach provides a clearer understanding of customer value over time and enables **future revenue prediction** for newly acquired cohorts.

## Business Context & Objectives
The objectives of this project were to:

* Replace the simplistic Shopify CLV formula with a **cohort-based CLV model**
* Include **all users who visited the website**, not only those who made purchases
* Analyse revenue performance on a **weekly cohort basis**
* Limit customer lifetime assumptions to **12 weeks**, reflecting actual user behaviour
* Predict future revenue for **incomplete cohorts**
* Provide management with a **more realistic estimate of CLV**

The analysis assumes that the **current week is 2021-01-24**, which represents the final cohort available in the dataset.

## Data Sources

* **BigQuery Table:** `turing_data_analytics.raw_events`
* **User identifier:** `user_pseudo_id`
* **Registration definition:** First recorded website visit
* **Revenue source:** Ecommerce purchase events


## Methodology

### 1. Cohort Definition

* Users were grouped into **weekly registration cohorts** based on their **first website visit**
* Revenue was tracked for each cohort across **12 weeks since registration**

### 2. Weekly Average Revenue by Cohort

* Weekly revenue was divided by the number of registered users in each cohort
* This produced **average revenue per user per week**
* Results were visualised using **conditional formatting** to highlight trends

### 3. Cumulative Revenue by Cohort

* Weekly average revenue was converted into **cumulative revenue**
* Averages were calculated across all cohorts for each week
* **Week-over-week cumulative growth percentages** were derived from these averages

### 4. Revenue Prediction for New Cohorts

* For incomplete cohorts (e.g. users acquired in the final week), future revenue was predicted
* Predictions were based on **historical cumulative growth percentages**
* Revenue was forecasted up to **Week 12** for each cohort
* This produced a **forward-looking CLV estimate**

### 5. Final CLV Estimate

* The **average cumulative revenue at Week 12** across all cohorts was used as the final CLV
* This CLV includes **all users**, including those who never made a purchase


## Tools & Files

### SQL

* **RFM.sql**
  Contains SQL queries used to extract user-level data from BigQuery, including cohort assignment and revenue calculations.

### Data

* **RFM data.csv**
  Exported dataset from BigQuery used for cohort analysis.

### Analysis & Visualisation

* **module 3 sprint 3.xlsx**
  Excel workbook containing:

  * Weekly Average Revenue by Cohorts
  * Cumulative Revenue by Cohorts
  * Revenue Prediction by Cohorts (up to 12 weeks)
  * Conditional formatting for trend analysis

## Key Findings

### Overall Insights

The cohort-based approach provides a **more granular and realistic view of customer behaviour and CLV** compared to traditional methods.

1. Weekly average revenue per cohort reveals how user value evolves during the first 12 weeks after registration.
2. Cumulative revenue analysis shows that **early engagement and repeat visits** are critical drivers of long-term revenue.
3. Predictive modelling enables estimation of future revenue for newer cohorts with incomplete data.

### Weekly Average Revenue by Cohorts

**Findings:**

* Average revenue per user varies significantly across cohorts and weeks.
* Later cohorts show lower retention and revenue growth, suggesting potential engagement or content issues after initial visits.

### Cumulative Revenue by Cohorts

**Findings:**

* Cumulative revenue increases over time but begins to plateau for many cohorts after **Week 6**.
* Cohorts with strong early engagement demonstrate **higher long-term value**.
* More recent cohorts generally show slower revenue growth.

### Revenue Prediction by Cohorts (Up to 12 Weeks)

**Findings:**

* Historical cohort behaviour enables reliable prediction of future revenue.
* Cohorts with strong initial performance show higher projected CLV.
* Predicted CLV values are **more realistic and data-driven** than Shopify’s simple CLV model.

## Recommendations

**A. Improve Early Engagement**
Focus on onboarding, personalised recommendations, and targeted campaigns to increase early user engagement.

**B. Re-engage Low-Performance Cohorts**
Introduce re-engagement strategies such as email campaigns, loyalty programmes, and promotional offers.

**C. Optimise Marketing Spend**
Allocate marketing budgets based on cohort performance, prioritising high-value cohorts.

**D. Strengthen Retention Strategies**
Invest in retention through exclusive content, personalised rewards, and customer success initiatives.

**E. Use Cohort-Based Forecasting for CLV**
Apply cumulative growth rates to forecast CLV for new cohorts and guide strategic planning.

## Key Takeaway
By incorporating **all users**, analysing behaviour through **weekly cohorts**, and applying **predictive modelling**, this project delivers a **robust and actionable CLV framework** that supports better marketing decisions, budgeting, and long-term growth planning.
