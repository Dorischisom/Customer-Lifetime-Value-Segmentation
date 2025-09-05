# Telecom Growth Strategies: Unlocking Customer Lifetime Value Through Smart Segmentation

## Background and Overview

NexaSat, a telecommunications company established in the competitive telecom sector, faces critical challenges in optimizing marketing strategies and maximizing revenue from their existing customer base. The company's diverse customer portfolio ranges from occasional users to loyal high-value customers, creating inefficiencies in their current one-size-fits-all engagement approach.

With intensifying market competition, NexaSat recognized the urgent need to implement data-driven customer segmentation to:

- Identify high-value customer segments for targeted marketing
- Optimize resource allocation for up-selling and cross-selling initiatives
- Maximize Average Revenue Per User (ARPU) through personalized offerings
- Reduce customer churn through strategic retention programs

This project delivers a comprehensive Customer Lifetime Value (CLV) segmentation analysis using advanced SQL techniques to unlock actionable insights from NexaSat's customer data from July 2023.

### Key Analysis Areas:

- Customer lifetime value calculation and scoring
- Behavioral segmentation based on usage patterns
- Revenue optimization through targeted recommendations
- Cross-selling and up-selling opportunity identification

[View SQL Code used for the analysis](Nexa_satelite/Nexa_satelite.txt)

### Data Structure Overview
| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Customer_ID | VARCHAR(50) | Unique identifier for each customer |
| Gender | VARCHAR(10) | Customer gender (Male/Female) |
| Partner | VARCHAR(3) | Whether customer has a partner (Yes/No) |
| Dependents | VARCHAR(3) | Whether customer has dependents (Yes/No) |
| Senior_Citizen | INT | Senior citizen status (1 = Yes, 0 = No) |
| Call_Duration | FLOAT | Total duration of calls made by customer |
| Data_Usage | FLOAT | Amount of data consumed by customer |
| Plan_Type | VARCHAR(20) | Service plan type (Prepaid/Postpaid) |
| Plan_Level | VARCHAR(20) | Service plan tier (Basic/Premium) |
| Monthly_Bill_Amount | FLOAT | Customer's monthly billing amount |
| Tenure_Months | INT | Number of months as active customer |
| Multiple_Lines | VARCHAR(3) | Multiple line service status (Yes/No) |
| Tech_Support | VARCHAR(3) | Tech support service status (Yes/No) |
| Churn | INT | Customer churn status (1 = Churned, 0 = Active) |
| **CLV** | **FLOAT** | **Customer Lifetime Value (Monthly_Bill_Amount × Tenure_Months)** |
| **CLV_Score** | **NUMERIC(10,2)** | **Weighted CLV score (40% bill + 30% tenure + 10% call duration + 10% data usage + 10% premium plan)** |
| **CLV_Segments** | **VARCHAR** | **Customer segment based on CLV percentiles (High Value/Moderate Value/Low Value/Churn Risk)** |


## Executive Summary
#### Key Findings Overview: 

After analyzing NexaSat's customer base of **4,272 active users**, significant opportunities emerged for revenue optimization through targeted segmentation strategies. Premium plan customers demonstrate 2x higher average revenue **($311.84 vs $159.36 monthly)** and longer tenure **(32+ months)**, while Basic plan customers show substantial up-selling potential.

### Critical Insights:

- **Revenue Distribution:** Premium customers generate 59% of total revenue despite representing 71% of active users
- **Churn Risk Identification:** 1,068 customers (25% of base) classified as "Churn Risk" with average monthly bills of $98.97
- **Up-selling Potential:** 641 "High Value" customers on Basic plans represent immediate premium upgrade opportunities
- **Service Gaps:** Significant cross-selling opportunities in tech support (54% penetration among seniors) and multiple lines (87% among families)

The segmentation reveals clear pathways to increase ARPU from the current $157.54 through strategic customer lifecycle management.

### Insights Deep Dive

#### Customer Lifetime Value Segmentation Results

##### Segment Performance Analysis:

###### High Value Customers (15% of base - 641 customers)

- **Average monthly revenue:** $311.84
- **Average tenure:** 32.6 months
- **Total segment revenue:** $6.45M lifetime value
- **Service adoption:** 87% multiple lines, 87% tech support

###### Moderate Value Customers (35% of base - 1,495 customers)

- **Average monthly revenue:** $159.36
- **Average tenure:** 33.6 months
- **Total segment revenue:** $7.72M lifetime value
- **Service adoption:** 93% multiple lines, 92% tech support

###### Low Value Customers (25% of base - 1,068 customers)

- **Average monthly revenue:** $120.94
- **Average tenure:** 27.9 months
- **Total segment revenue:** $3.69M lifetime value
- **Service adoption:** 87% multiple lines, 83% tech support

###### Churn Risk Customers (25% of base - 1,068 customers)

- **Average monthly revenue:** $98.97
- **Average tenure:** 15.0 months
- **Total segment revenue:** $1.63M lifetime value
- **Service adoption:** 63% multiple lines, 54% tech support

##### Revenue Optimization Opportunities
###### Plan Distribution Analysis: 

Premium plan customers show significantly higher engagement and retention rates. Current distribution shows **3,015 Premium vs 1,257 Basic active customers**, with Premium customers generating 60% higher lifetime value on average.

###### Cross-selling Potential Identified:

- **Tech Support for Seniors:** 145 senior citizens without tech support represent immediate cross-selling opportunities
- **Multiple Lines for Families:** 312 customers with partners/dependents currently on single-line Basic plans
- **Premium Upgrades:** 89 high-usage Basic customers with monthly bills >$150 ready for premium conversion

## Recommendations

#### Immediate Revenue Growth Initiatives
1. Churn Prevention Program Target the **1,068 "Churn Risk" customers** currently on Basic plans with premium upgrade promotions. Implementation of retention discounts could prevent an estimated **$1.63M** in lifetime value loss while converting customers to higher ARPU premium services.

2. Strategic Up-selling Campaign Focus on 89 high-value Basic plan customers already spending >$150 monthly. These customers demonstrate premium-level usage patterns and represent the highest probability premium conversion opportunities with minimal acquisition cost.

3. Cross-selling Service Expansion

Senior Tech Support Program: Target 145 senior citizens without current tech support, particularly those without dependents who lack tech-savvy household assistance
Family Line Expansion: Implement family plan promotions for 312 customers with partners/dependents currently on single-line Basic plans

4. Customer Lifecycle Management Develop differentiated engagement strategies by segment:

- **High Value:** VIP retention programs and exclusive premium feature access
- **Moderate Value:** Targeted feature upgrades and loyalty rewards
- **Low Value:** Value-focused communications and basic plan optimization
- **Churn Risk:** Immediate intervention with retention specialists and discount offers

#### Long-term Strategic Recommendations
1. Revenue Optimization Framework: Implement dynamic CLV scoring with monthly updates to identify customers moving between segments, enabling proactive engagement before churn risk materializes.

2. Service Bundle Strategy: Create tiered service packages combining multiple lines, tech support, and premium features to increase customer stickiness and maximize cross-selling effectiveness across all segments.


Revenue projections based on current pricing structure and do not account for potential market changes
