CREATE TABLE "Nexa_sat".Nexa_sat(
       Customer_Id Varchar(50),
       Gender Varchar(10),
       Partner Varchar(3),	
       Dependents Varchar(3),	
       Senior_Citizen INT,	
       Call_Duration FLOAT,	
       Data_Usage FLOAT,	
       Plan_Type Varchar(20),	
       Plan_Level Varchar(20),	
       Monthly_Bill_Amount	FLOAT,	
       Tenure_Months INT,	
       Multiple_Lines Varchar(3),
       Tech_Support Varchar(3),
       Churn INT);

--confirm current schema--
SELECT current_schema();

-- set path for query--
SET search_path TO "Nexa_sat";

SELECT *
FROM nexa_sat;

--Data Cleaning--
--Check for Duplicates--
SELECT Customer_Id, Gender, Partner, Dependents, 
       Senior_Citizen, Call_Duration,	Data_Usage,	
       Plan_Type, Plan_Level, Monthly_Bill_Amount, Tenure_Months,	
       Multiple_Lines,Tech_Support,Churn
FROM nexa_sat
GROUP BY Customer_Id, Gender, Partner, Dependents, 
       Senior_Citizen, Call_Duration,	Data_Usage,	
       Plan_Type, Plan_Level, Monthly_Bill_Amount, Tenure_Months,	
       Multiple_Lines,Tech_Support,Churn
HAVING COUNT (*) > 1;


SELECT *
FROM nexa_sat
WHERE Customer_Id IS NULL
OR Gender IS NULL
OR Partner IS NULL	
OR Dependents IS NULL
OR Senior_Citizen IS NULL	
OR Call_Duration IS NULL
OR Data_Usage IS NULL
OR Plan_Type IS NULL	
OR Plan_Level IS NULL
OR Monthly_Bill_Amount IS NULL
OR Tenure_Months IS NULL
OR Multiple_Lines IS NULL
OR Tech_Support IS NULL
OR Churn IS NULL;

--EDA--
--How many Users does Nexa Sat currently have--
SELECT COUNT (customer_id) AS current_users
FROM nexa_sat
WHERE churn = 0;


--Total Users By level--
SELECT plan_level, COUNT(customer_id) as total_users
FROM nexa_sat
GROUP BY 1

--Distinct Total Users By level--
SELECT plan_level, COUNT(customer_id) as total_users
FROM nexa_sat
WHERE churn = 0
GROUP BY 1

--Total Revenue--
SELECT ROUND (SUM(monthly_bill_amount ::numeric),2) AS total_revenue
FROM nexa_sat

--Revenue by plan level--
SELECT plan_level, ROUND (SUM(monthly_bill_amount ::numeric),2) AS total_revenue
FROM nexa_sat
GROUP BY 1
ORDER BY 2

--Churn count by plan type and plan level--
SELECT plan_level, plan_type,
       COUNT(*) AS total_customers,
	   SUM(churn) AS churn_count
FROM nexa_sat
GROUP BY 1,2
ORDER BY 1

---Average Tenure by plan level--
SELECT plan_level, ROUND(AVG(tenure_months),2) AS Avg_tenure
FROM nexa_sat
GROUP BY 1

--Which gender patronize nexa sat more--
SELECT gender, count(gender)
FROM nexa_sat
GROUP BY 1
ORDER BY 2

--Total Data Usage--
SELECT ROUND (SUM(data_usage ::numeric),2) AS total_data_usage
FROM nexa_sat

---Marketing Segment--
--Create table for existing users only--
CREATE TABLE existing_users AS
SELECT *
FROM nexa_sat
WHERE churn = 0;

--View our new table--
SELECT * 
FROM existing_users

--calculate average revenue per user (ARPU) for existing users--
SELECT ROUND(AVG(monthly_bill_amount::INT),2) AS ARPU
FROM existing_users;


--Calculate CLV and add column--
ALTER TABLE existing_users
ADD COLUMN CLV FLOAT;

UPDATE existing_users
SET clv = monthly_bill_amount * tenure_months;

--View CLV column--
SELECT customer_id, clv
FROM existing_users;

-- CLV score--
--monthly_bill = 40%, tenure = 30%, call_duration = 10%, data_usage= 10%, premium = 10%
ALTER TABLE existing_users
ADD COLUMN CLV_score NUMERIC(10,2);

UPDATE existing_users
SET clv_score =
         (0.4 * monthly_bill_amount) +
		 (0.3 * tenure_months) +
		 (0.1 * call_duration) +
		 (0.1 * data_usage) +
		 (0.1 * CASE WHEN plan_level = 'Premium'
		          THEN 1 ELSE 0
				  END);

--View CLV_score column--
SELECT customer_id, clv_score
FROM existing_users;

--Group users into segments based on their clv_scores--
ALTER TABLE existing_users
ADD COLUMN CLV_segments VARCHAR;

UPDATE existing_users
SET clv_segments =
            CASE WHEN clv_score > (SELECT percentile_cont(0.85)
			                       WITHIN GROUP (ORDER BY clv_score)
			                       FROM existing_users) THEN 'High Value'
				WHEN clv_score > (SELECT percentile_cont(0.50)
			                       WITHIN GROUP (ORDER BY clv_score)
			                       FROM existing_users) THEN 'Moderate Value'
				WHEN clv_score > (SELECT percentile_cont(0.25)
			                       WITHIN GROUP (ORDER BY clv_score)
			                       FROM existing_users) THEN 'Low Value'
				Else 'Churn Risk'
				END;


--View segments--
SELECT customer_id, clv,clv_score,clv_segments
FROM existing_users;

--Analyzing the segments
--Avg bill and tenure per segment
SELECT clv_segments,
       ROUND(AVG(monthly_bill_amount::INT),2) AS avg_monthly_charges,
       ROUND(AVG(tenure_months::INT),2) AS avg_tenure
FROM existing_users
GROUP BY 1;

--tech_support and multiple_lines count
SELECT clv_segments,
       ROUND(AVG(CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END),2) AS tech_support_pct,
       ROUND(AVG(CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END),2) AS multiple_lines_pct
FROM existing_users
GROUP BY 1;

--revenue by segment
SELECT clv_segments, COUNT(customer_id),
       CAST(SUM(monthly_bill_amount * tenure_months)AS NUMERIC(10,2)) AS total_revenue
FROM existing_users
GROUP BY 1;


--Cross-selling and Up-selling
--Cross-selling: tech support to our senior_citizens
SELECT customer_id
FROM existing_users
WHERE senior_citizen = 1
AND dependents = 'No' --- no children  or tech savvy helpers
AND tech_support = 'No' --- do not already haave this service
AND (clv_segments = 'Churn Risk' OR clv_segments = 'Low Value');


--Cross-selling: multiple lines for partners and dependents
SELECT customer_id
FROM existing_users
WHERE multiple_lines = 'No'
AND (dependents = 'Yes' OR partner = 'Yes')
AND plan_level ='Basic';

--Up-selling: premium discount for users with churn risk
SELECT customer_id
FROM existing_users
WHERE clv_segments = 'Churn Risk'
AND plan_level ='Basic';

--Up-selling: Basic to Premium for longer lock in period and in turn higher ARPU
SELECT plan_level, ROUND(AVG(monthly_bill_amount::INT),2) AS Avg_bill, ROUND(AVG(tenure_months::INT),2) AS avg_tenure
FROM existing_users
WHERE clv_segments = 'High Value'
OR clv_segments = 'Moderate Value'
GROUP BY 1;

---Select the customers
SELECT customer_id, monthly_bill_amount
FROM existing_users
WHERE plan_level = 'Basic'
AND (clv_segments = 'High Value' OR clv_segments = 'Moderate Value')
And monthly_bill_amount > 150;

--Create Stored Procedures
--snr citizens who will be offered tech support

CREATE FUNCTION tech_support_snr_citizens()
RETURNS TABLE (customer_id VARCHAR(50))
AS $$
BEGIN
    RETURN QUERY
	SELECT eu.customer_id
    FROM existing_users eu
    WHERE eu.senior_citizen = 1
    AND eu.dependents = 'No' --- no children  or tech savvy helpers
    AND eu.tech_support = 'No' --- do not already haave this service
    AND (eu.clv_segments = 'Churn Risk' OR eu.clv_segments = 'Low Value');
END;
$$ LANGUAGE plpgsql;

---At risk customers who would be offered premium discount
CREATE FUNCTION churn_risk_discount()
RETURNS TABLE (customer_id VARCHAR(50))
AS $$
BEGIN
    RETURN QUERY
	SELECT eu.customer_id
    FROM existing_users eu
    WHERE eu.clv_segments = 'Churn Risk'
    AND eu.plan_level ='Basic';
END;
$$ LANGUAGE plpgsql;

--high usage customers who will be offered premium upgrade
CREATE FUNCTION high_usage_basic()
RETURNS TABLE (customer_id VARCHAR(50))
AS $$
BEGIN
    RETURN QUERY
	SELECT eu.customer_id
    FROM existing_users eu
    WHERE eu.plan_level = 'Basic'
    AND (eu.clv_segments = 'High Value' OR eu.clv_segments = 'Moderate Value')
    And eu.monthly_bill_amount > 150;
END;
$$ LANGUAGE plpgsql;


--multiple_lines_partners_dependents
CREATE FUNCTION multiple_lines_partners_dependents()
RETURNS TABLE (customer_id VARCHAR(50))
AS $$
BEGIN
    RETURN QUERY
	SELECT eu.customer_id
    FROM existing_users eu
    WHERE eu.multiple_lines = 'No'
    AND (eu.dependents = 'Yes' OR eu.partner = 'Yes')
    AND eu.plan_level ='Basic';
END;
$$ LANGUAGE plpgsql;

--Use procedures
SELECT *
FROM tech_support_snr_citizens();

SELECT *
FROM churn_risk_discount();

SELECT *
FROM high_usage_basic()

SELECT *
FROM multiple_lines_partners_dependents()





