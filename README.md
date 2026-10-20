# MTN Nigeria Tariff Adjustment Impact Analysis

## Project Background

MTN Nigeria is a telecommunications and digital services provider that began commercial operations in 2001. It operates within Nigeria's telecommunications industry, providing mobile connectivity and digital services to consumers and businesses. Its business depends on customer participation, service usage, data-plan purchases, revenue generation, and continued investment in network infrastructure.

On **20 January 2025, the Nigerian Communications Commission (NCC) announced approval for telecommunications tariff adjustments capped at a maximum increase of 50% of existing tariffs**. MTN Nigeria implemented revised tariffs on **11 February 2025**. The NCC stated that the adjustment was intended to address rising operating costs while supporting service sustainability and protecting consumers.

Framed from the perspective of a data analyst on MTN Nigeria's Commercial Analytics team, I conducted this analysis to evaluate changes in purchasing activity, revenue performance, customer behaviour, data plan demand, and service level performance following the tariff adjustment.

The analysis compares:

- **Pre-adjustment period:** 1 December 2024 – 10 February 2025 (72 days)
- **Post-adjustment period:** 11 February 2025 – 30 April 2025 (79 days)

The analysis uses a **synthetic dataset generated with Claude AI for portfolio and analytical demonstration purposes**. It is not official MTN Nigeria customer or transaction data, and the findings should not be interpreted as verified company performance.

Insights and recommendations are provided on the following key areas:
1. **Overall Tariff Adjustment Impact:** How did transaction volume, customer activity, and revenue change after the tariff adjustment?
2. **Plan Performance Analysis:** Which data plans experienced the largest changes in demand after the tariff adjustment?
3. **Customer Behaviour Analysis:** How did customer purchasing behaviour change after the tariff adjustment?
4. **Service Performance Analysis:** How did customer activity, transaction volume, and revenue performance differ across Mobile SIM, Broadband, and Fibre X services?


The SQL scripts used to setup and inspect the data for this analysis can be found here: [sql scripts](https://github.com/Duke-Tsekar/MTN-Nigeria-Tariff-Adjustment-Impact-Analysis/tree/main/sql%20scripts)

The SQL scripts for the project's business questions are available in the folder below.
**[View Business Question SQL Scripts](https://github.com/Duke-Tsekar/MTN-Nigeria-Tariff-Adjustment-Impact-Analysis/tree/main/business%20questions%20sql%20scripts)**

MS Excel was used to further analyze the results exported from PostgreSQL, including calculating percentage changes across the pre- and post-tariff adjustment periods.
**[View Excel Analysis Files](excel%20analysis%20files/)**

**Tools:** SQL(PostgreSQL), AI, Microsoft Excel, Github.

**Industry:** Telecommunications.



## Data Structure & Initial Checks

The project relational database, `mtn_price_hike`, contains six tables with **2,191,114 total records**. The data model separates customer, date, plan, and service dimensions from subscription and transaction records.

| Table | Records | Description |
|---|---:|---|
| `dim_customers` | 450,000 | Customer attributes, including state, segment, age bracket, and registration date. |
| `dim_date` | 151 | Calendar attributes and pre-/post-adjustment period classifications. |
| `dim_plans` | 24 | Data-plan details, service classifications, prices, data allowances, and plan status. |
| `dim_service_types` | 3 | Service type and category classifications. |
| `fact_subscriptions` | 740,936 | Subscription records, customer-plan relationships, activation dates, statuses, and migration references. |
| `fact_transactions` | 1,000,000 | Transaction dates, customer and subscription identifiers, purchased data, service and plan details, and transaction amounts. |


<img width="5420" height="2692" alt="ERD" src="https://github.com/user-attachments/assets/df422dbb-630d-4ee9-b6e1-cb77f491e850" />



## Executive Summary

### Overview of Findings
The analysis indicates that the synthetic dataset recorded fewer transactions and fewer active customers after the tariff adjustment, while total transaction revenue increased. However, average transaction value rose substantially, and average daily revenue declined slightly, showing why total revenue alone is insufficient for evaluating performance across periods of different lengths.

Plan-level results varied considerably, customer activity was not uniform, and service-level performance differed across Mobile SIM, Fixed Broadband, and Fibre X. These findings support a more targeted response from Commercial Strategy, Pricing, Customer Experience, and the relevant service business units rather than relying on a single company wide performance measure.

<img width="755" height="96" alt="Overall Impact Findings" src="https://github.com/user-attachments/assets/8933ef1d-c067-4033-8c9d-aeca47c49124" />

**Key takeaway:** Total revenue increased by 8.14%, but the post-adjustment period covers seven more days. Average daily revenue provides a more comparable view and declined by 1.44%. The observed increase in average transaction value occurred alongside a decline in transaction activity.


## Insights Deep Dive

## Overall Tariff Adjustment Impact

- **Transaction activity declined.** Recorded transactions fell from **560,000** before the adjustment to **440,000** afterward, a decrease of **21.43%**. Average daily transactions declined by **28.39%**, from **7,777.78** to **5,569.62**.

- **Recorded customer participation decreased.** Active customers fell from **286,958** to **225,829**, representing a **21.30%** decline between the periods.

- **Total revenue increased, but the period lengths differ.** Transaction revenue rose from **₦3.203 billion** to **₦3.463 billion**, an increase of **8.14%**. Because the post-adjustment period covers **79 days** compared with **72** days before the adjustment, this increase should not be interpreted on its own as improved underlying performance.

- **Average transaction value increased while daily revenue softened.** Average transaction value rose by **37.63%**, from **₦5,719.11 **to **₦7,871.40**. Meanwhile, average daily revenue declined by **1.44%**. The combination indicates that higher revenue per transaction did not translate into higher average daily revenue in this dataset.

**Business conclusion:** The increase in average transaction value was accompanied by lower transaction frequency and customer participation. Commercial performance should therefore be assessed using revenue, daily activity, and customer participation together.

## Plan Performance Analysis

- **The Monthly 75GB plan recorded substantial growth.** Transactions increased from **23,266** to **54,391 (+133.78%)**, while recorded customers increased from **17,692** to **40,186 (+127.14%)**. Revenue rose from **₦372.256 million** to **₦979.038 million (+163.00%)**.

- **The Monthly 75GB plan also recorded strong daily demand growth.** Average daily transactions increased by **113.06%**, average daily customers by **113.08%**, and average daily revenue by **139.70%**. These daily measures account for the unequal lengths of the comparison periods.

- **The BB Yearly 1.5TB plan recorded strong revenue growth.** Transactions increased from **498** to **978 (+96.39%)**, customers increased from **492** to **963 (+95.73%)**, and revenue increased from **₦74.7 million** to **₦220.05 million (+194.58%)**.

- **Plan-level changes were not uniform.** The 2-Day 2GB plan recorded a **44.72%** increase in transactions and a **46.03%** increase in customers, while the Daily 1GB plan experienced a **7%** decline in transactions. This highlights the need to assess performance at individual plan level rather than assuming all plans respond similarly.

**Business conclusion:** The Monthly 75GB and BB Yearly 1.5TB plans are important candidates for further commercial investigation based on their observed growth. The Daily 1GB decline also warrants investigation. These results do not, by themselves, establish why demand changed or whether the patterns will persist.

## Customer Behaviour Analysis

- **The analysis distinguishes observed customer activity from actual customer acquisition or churn.** Of the 450,000 customers in the customer dimension, 90,328 had no matching transaction records. Behaviour comparisons therefore focus on the 359,672 customers with recorded transactions.

- **Many previously active customers had no recorded transactions after the adjustment.** Of the 286,958 customers active before the adjustment, 153,115 (53.36%) also had recorded transactions afterward, while 133,843 (46.64%) had no recorded post-adjustment transactions.

- **The dataset contains customers observed only in the post-adjustment period.** A total of 72,714 customers had post-adjustment transactions but no matching pre-adjustment transactions. This describes their observed records and does not prove that they were newly acquired by MTN.

- **Spending behaviour varied among customers active in both periods.** Of the 153,115 continuing customers, 48,997 (32.00%) increased their recorded spending, 50,965 (33.29%) reduced it, and 53,153 (34.71%) remained unchanged.

**Business conclusion:** Customer behaviour was mixed. The substantial number of previously active customers without recorded post-adjustment transactions warrants further investigation, while the split in spending patterns supports customer segmentation and targeted retention analysis. The available records do not establish the reasons behind these changes.

## Service Performance Analysis

- **Mobile SIM remained the largest revenue contributor.** Post-adjustment Mobile SIM revenue was ₦1.945 billion, representing 56.15% of recorded revenue across the three service categories.

- **Mobile SIM revenue increased while activity declined.** Transactions decreased from 524,245 to 405,441, and recorded customers decreased from 275,203 to 210,280. Revenue increased from ₦1.901 billion to ₦1.945 billion, showing a divergence between revenue and transaction activity.

- **Fibre recorded growth in both transactions and revenue.** Transactions increased from 17,336 to 18,822, customers increased from 15,142 to 15,995, and revenue rose from ₦751.510 million to ₦817.400 million. Fibre accounted for 23.60% of post-adjustment revenue.

- **Fixed Broadband recorded higher revenue despite lower activity.** Transactions decreased from 18,419 to 15,737, and recorded customers decreased from 16,367 to 13,903. Revenue nevertheless increased from ₦550.186 million to ₦701.334 million, representing 20.25% of post-adjustment revenue.

**Business conclusion:** Service-level results differed meaningfully. Mobile SIM remained the largest revenue contributor, Fibre showed growth in both activity and revenue, and Fixed Broadband generated more revenue despite fewer recorded transactions and customers. These patterns warrant separate investigation by the relevant service business units.

## Recommendations

Based on the observed results, the following actions are recommended for the relevant stakeholder teams.

1. **Commercial Strategy and Revenue Management:** Average daily revenue declined by 1.44% even as average transaction value increased by 37.63%. **Track daily revenue, transaction frequency, average transaction value, and active customers together** to assess whether higher spending per transaction is offsetting reduced purchasing activity.

2. **Pricing and Data Product Teams:** The Monthly 75GB and BB Yearly 1.5TB plans recorded substantial revenue growth, while the Daily 1GB plan recorded a decline in transactions. **Review plan-level demand, price changes, data allowances, and contribution to revenue** before deciding whether to retain, reposition, or further investigate individual plans. Validate demand persistence before making pricing decisions.

3. **Customer Experience and Retention Teams:** A total of 133,843 previously active customers had no recorded post-adjustment transactions. **Investigate these customers through approved customer analytics and feedback processes**, and distinguish temporary inactivity from sustained disengagement before designing retention interventions.

4. **Mobile Business Unit:** Mobile SIM remained the largest revenue contributor, but transactions and recorded customers declined. **Monitor daily purchasing activity and customer participation alongside revenue**, and investigate which plans, customer segments, or purchasing patterns account for the decline.

5. **Broadband Business Units:** Fibre recorded growth in both transactions and revenue, while Fixed Broadband revenue increased despite declining transactions and customers. **Assess Fibre's observed growth patterns and investigate the drivers of Fixed Broadband's higher revenue per transaction**, using additional validated data before changing commercial strategy or resource allocation.

## Assumptions and Caveats

The analysis uses several assumptions and has important limitations:

- **Synthetic data:** The dataset was generated using Claude AI for portfolio purposes. It is not official MTN Nigeria data, and the results do not represent verified internal company performance.

- **Regulatory context:** The NCC announced approval for tariff adjustments capped at 50% of existing tariffs on 20 January 2025. This does not mean every plan increased by 50%. Plan-level price changes in the synthetic dataset should be interpreted according to the values represented in the project data.

- **Comparison periods:** The pre-adjustment period covers 72 days and the post-adjustment period covers 79 days. Total counts and revenue are therefore not directly comparable without considering period length. Daily averages help normalize this difference but do not remove every possible source of bias.

- **Association, not causation:** The analysis compares performance before and after the adjustment. It cannot establish that the tariff adjustment alone caused the observed changes. Other market, customer, operational, or seasonal factors may contribute.

- **Observed customer activity:** A customer with no transaction in a period is classified as having no recorded transaction in that period. This does not prove that the customer left MTN, stopped using every service, or was newly acquired.

- **Customer coverage:** The customer dimension contains 450,000 records, but 90,328 customers have no matching transaction records. Customer behaviour analysis is restricted to customers with observed transactions and must be interpreted within that coverage limitation.

- **Service classification:** The analysis groups service performance into Mobile SIM, Fixed Broadband, and Fibre. Fixed Broadband includes the relevant MiFi and router services represented in the database.

- **Revenue scope:** Revenue refers to the transaction amounts represented in the synthetic transaction table. It should not be treated as audited corporate revenue, total company revenue, or a substitute for official financial reporting.

- **Plan-level interpretation:** Changes in plan transactions, customers, and revenue describe patterns in the dataset. They do not independently establish customer preference, price elasticity, profitability, or the long-term sustainability of demand.






## Assumptions and Caveats

- **Synthetic data:** The dataset was AI-generated for portfolio purposes and does not represent actual MTN Nigeria customer or operational records.
- **Scope of analysis:** The dataset focuses on data purchase transactions. Findings relate to recorded purchasing activity and revenue within the defined pre- and post-tariff adjustment periods.
- **ARPU:** Traditional Average Revenue Per User could not be calculated because a reliable subscriber-base denominator was not available. Revenue per active purchasing customer was used instead and should not be interpreted as ARPU.
- **Subscriber growth and churn:** These metrics were excluded because the available data does not establish reliable subscriber-base movements or confirmed disconnections.
- **Operational and customer experience metrics:** Network uptime, 5G coverage, call duration, customer satisfaction, acquisition costs, and revenue per cell tower were outside the scope of the available dataset.
- **Causal attribution:** Changes observed after the tariff adjustment are temporal comparisons, not proof that the adjustment alone caused those changes. Other factors were not independently controlled for.
