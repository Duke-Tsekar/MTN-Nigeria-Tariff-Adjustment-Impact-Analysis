# MTN Nigeria Tariff Adjustment Impact Analysis
**Tools:** PostgreSQL · AI· SQL ·Microsoft Excel· GitHub  
**Industry:** Telecommunications  
**Analysis Period:** 1 December 2024 – 30 April 2025  
**Tariff Adjustment Date:** 11 February 2025  
**Project Type:** Business Performance and Customer Behaviour Analysis

# **Project Background**

MTN Nigeria is Nigeria's largest mobile network operator, selling mobile data and voice plans alongside fixed broadband and fibre services. Revenue is driven by how many customers are active, how often they buy, and how much each purchase is worth.

On **11 February 2025**, MTN adjusted the prices of its tariff plans. As a data analyst on the commercial analytics team, I was asked to assess what changed for the business after the tariff increase, comparing **72 days before (1 Dec 2024 to 10 Feb 2025)** with **79 days after (11 Feb to 30 Apr 2025)**.

Framed from the perspective of a data analyst supporting MTN Nigeria's commercial decision-making, the analysis uses PostgreSQL and MS Excel to evaluate transaction performance, data-plan demand, customer purchasing behaviour, and service-level performance.

The objective is to identify meaningful changes in purchasing activity and revenue, assess differences across plans and services, and translate the findings into actionable recommendations for relevant business teams.

**Dataset disclosure:** The dataset used in this project was generated with the assistance of Claude AI. It is a synthetic dataset created for portfolio analysis and is not official MTN Nigeria transaction data. The findings demonstrate SQL analysis and business interpretation; they should not be interpreted as verified findings about MTN Nigeria's actual commercial performance.

Insights and recommendations are provided on the following key areas:
1. **Overall Tariff Adjustment Impact:** How did transaction volume, customer activity, and revenue change after the tariff adjustment?
2. **Plan Performance Analysis:** Which data plans experienced the largest changes in demand after the tariff adjustment?
3. **Customer Behaviour Analysis:** How did customer purchasing behaviour change after the tariff adjustment?
4. **Service Performance Analysis:** Did customer behaviour and business performance differ across service types? (Mobile SIM, Fixed Broadband and Fibre)


The SQL queries used to inspect and clean the data for this analysis can be found here: ** **.

The SQL queries answering each business question can be found here, one self-contained script per question:


## Data Structure & Initial Checks

The PostgreSQL database, `mtn_price_hike`, contains six tables with **2,191,114 records** across the dataset.

| Table | Records | Purpose |
|---|---:|---|
| `fact_transactions` | 1,000,000 | Transaction activity, dates, amounts, and customer and plan references |
| `fact_subscriptions` | 740,936 | Customer subscription records |
| `dim_customers` | 450,000 | Customer dimension |
| `dim_plans` | 24 | Data-plan dimension |
| `dim_date` | 151 | Date dimension and tariff-period classification |
| `dim_service_types` | 3 | Service-type dimension |
| **Total** | **2,191,114** | |

The database follows a dimensional structure, with transaction and subscription fact tables connected to customer, plan, date, and service dimensions where applicable.

<img width="5420" height="2692" alt="ERD" src="https://github.com/user-attachments/assets/df422dbb-630d-4ee9-b6e1-cb77f491e850" />



### Data Validation

Initial validation and script checks covered:

- Verification of imported table row counts.
- Validation of the pre-adjustment and post-adjustment date boundaries.
- Checks of transaction dates against the date dimension.
- Validation of tariff-period flags against the corresponding date classifications.
- Consistency of calculations and aggregate metrics across the four SQL analyses.

## Executive Summary

The analysis reveals a mixed pattern of business performance following the tariff adjustment. Transaction volume and active customer counts declined, while total recorded revenue increased. However, average transaction value rose substantially, and average daily revenue was slightly lower after the adjustment.

These results highlight why revenue alone is insufficient for assessing performance. Customer participation, purchase frequency, plan-level demand, and service-level differences are also important when evaluating commercial outcomes.





