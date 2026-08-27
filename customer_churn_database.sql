CREATE DATABASE customer_churn;
USE customer_churn;
SHOW DATABASES;
SHOW TABLES;

SELECT * FROM cleaned_customer_churn_analysis LIMIT 10 ;

SELECT COUNT(*) AS Total_Rows,
COUNT(DISTINCT Customer_ID) AS unique_customers,
COUNT(DISTINCT Contract_ID) AS unique_contracts,
COUNT(DISTINCT Payment_ID) AS unique_payments 
FROM cleaned_customer_churn_analysis;

CREATE TABLE Customers AS 
SELECT DISTINCT
Customer_ID,
Gender,
Age,
Senior_Citizen,
Partner,
Dependents,
Churn
FROM cleaned_customer_churn_analysis;

SELECT * FROM Customers LIMIT 5 ;

CREATE TABLE Contracts AS 
SELECT DISTINCT
Contract_ID,
Customer_ID,
Tenure_Months
FROM cleaned_customer_churn_analysis;

SELECT * FROM Contracts LIMIT 5 ;

CREATE TABLE Payment AS
SELECT DISTINCT
Payment_ID,
Customer_ID,
Monthly_Charges,
Total_Charges
FROM cleaned_customer_churn_analysis;

SELECT * FROM Payment LIMIT 5 ;

CREATE TABLE Services AS 
SELECT DISTINCT
Customer_ID,
Internet_Service,
Customer_Support_Calls
FROM cleaned_customer_churn_analysis;

SELECT * FROM Services LIMIT 5 ;

#BASIC QUERIES

##Total Customers
SELECT COUNT(*) AS Total_Customers From cleaned_customer_churn_analysis;

#Churned Customers
SELECT COUNT(*) AS churned_customers FROM cleaned_customer_churn_analysis WHERE Churn = 'yes';

#Customer who stayed
SELECT COUNT(*) AS Retained_Customers FROM cleaned_customer_churn_analysis WHERE Churn = 'no';

# Overall customer Churn Rate 
SELECT ROUND(SUM(CASE WHEN Churn = 'yes'
 THEN 1 ELSE 0 END ) * 100.0 / COUNT(*), 2) AS Churn_rate 
 FROM cleaned_customer_churn_analysis;
 
 #Average monthly charges of customers
 SELECT ROUND(AVG(Monthly_Charges), 2) AS Average_monthly_charge 
 FROM cleaned_customer_churn_analysis;
 
 #Monthly tenure of churned vs retained customers
 SELECT Churn,
 ROUND(AVG(Tenure_Months), 2) AS Average_tenure
 FROM cleaned_customer_churn_analysis
 GROUP BY Churn;
 
 ##INTERMEDIATE QUERIES
 
 #Churn rate by gender
 SELECT Gender,
 COUNT(* ) AS Total_customers,
 SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) AS Churned_customers,
 ROUND(SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Churn_rate
 FROM cleaned_customer_churn_analysis
 GROUP BY Gender
 ORDER BY Churn_rate DESC;
 
 #Churn difference between senior citizen and non senior citizen cutomers
 SELECT Senior_Citizen,
 COUNT(*) AS Total_customers,
 SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) AS Churned_customers,
 ROUND(SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Churn_rate
 FROM cleaned_customer_churn_analysis
 GROUP BY Senior_Citizen
 ORDER BY Churn_rate DESC; 
 
 #which tenure group has the highest churn
 SELECT CASE 
  WHEN Tenure_Months < 12 THEN '0-11 Months'
  WHEN Tenure_Months BETWEEN 12 and 23 THEN '12-23 Months'
  WHEN Tenure_Months BETWEEN 24 and 47 THEN '24-47 Months'
ELSE '48+ Months' 
END AS Tenure_Group,
COUNT(*) AS Total_customers,
SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) AS Churned_customers,
ROUND(SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Churn_rate
FROM cleaned_customer_churn_analysis
GROUP BY  Tenure_Group
ORDER BY Churn_rate DESC;

#Customer having monthly charges above the overall average
SELECT 
Customer_ID,
Monthly_Charges
FROM cleaned_customer_churn_analysis
WHERE Monthly_Charges>(
SELECT AVG(Monthly_Charges)
FROM cleaned_customer_churn_analysis)
ORDER BY Monthly_Charges DESC;

# Compare average Customer support calls from churned and retained customers
SELECT Churn,
COUNT(*) AS Total_customers,
AVG(Customer_Support_Calls) AS Average_support_calls
FROM cleaned_customer_churn_analysis
GROUP BY Churn;

# ADVANCED QUERIES

# What is the churn rate for different tenure groups using contract table     (JOINS)
SELECT
CASE
WHEN ct.Tenure_Months < 12 THEN '0-11 Months'
WHEN ct.Tenure_Months BETWEEN 12 AND 23 THEN '12-23 Months'
WHEN ct.Tenure_Months BETWEEN 24 AND 47 THEN '24-47 Months'
ELSE '48+ Months'
END AS Tenure_Group,
COUNT(*)AS Total_customers,
SUM(CASE WHEN c.Churn = 'yes' THEN 1 ELSE 0 END) AS Churned_customers,
SUM(CASE WHEN c.Churn = 'yes' THEN 1 ELSE 0 END) *100 / COUNT(*) AS Churned_rate
FROM customers c
JOIN contracts ct ON c.Customer_ID = ct.Customer_ID
GROUP BY Tenure_Group
ORDER BY Churned_rate DESC;

#Which churned customer have above-average monthly charges   (SUBQUERY)
SELECT
Customer_ID,
Monthly_Charges,
Churn
FROM cleaned_customer_churn_analysis
WHERE Churn = 'yes' AND  Monthly_Charges > (
SELECT AVG(Monthly_Charges) 
FROM cleaned_customer_churn_analysis)
ORDER BY Monthly_Charges DESC;

##Who are the highest paying customer within each churn category      (WINDOW FUNCTION)     

SELECT
Customer_ID,
Monthly_Charges,
Churn,
DENSE_RANK() OVER(
ORDER BY Monthly_Charges DESC ) AS Charge_Rank
FROM cleaned_customer_churn_analysis; 

#Which churned customers use internet services and have high support calls     (JOINS,SUBQUERY)
SELECT
c.Customer_ID,
c.Churn,
S.Internet_Service,
S.Customer_Support_Calls
FROM customers c
JOIN services s ON 
c.Customer_ID = s.Customer_ID
WHERE Churn = 'yes' AND s.Internet_Service IN('DSL','Fiber_Optic','Cable') AND s.Customer_Support_Calls>(
SELECT AVG(Customer_Support_Calls)
FROM services)
ORDER BY s.Customer_Support_Calls DESC
LIMIT 50;

##BUSSINESS QUERIES

#Which customer group has the highest churn risk based on senior citizen status

SELECT Senior_Citizen,
COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) AS Churned_customers,
SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) * 100 / count(*) AS Churned_rate
FROM cleaned_customer_churn_analysis
GROUP BY Senior_Citizen
ORDER BY Churned_rate DESC;

#Explanation:  Non senior citizens hashigher churn risk with a churn rate 52.02% slightly higher then senior citizen 51.53%

# Does having a partner or dependent affect customer churn

SELECT
Partner,
Dependents,
COUNT(*) AS Total_customers,
SUM(CASE WHEN Churn ='yes' THEN 1 ELSE 0 END) AS Churned_customers,
SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) *100 / COUNT(*) AS Churned_rate
FROM cleaned_customer_churn_analysis
GROUP BY Partner, Dependents
ORDER BY Churned_rate DESC;

#Explanation: It has a little or no noticable effect on churn while the highest churn rate is 55.52% which have no partner and dependents.

#Which internet service category has the highest churn rate

SELECT
Internet_Service,
COUNT(*) AS Total_customers,
SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) AS Churned_customers,
SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) *100/COUNT(*) AS Churned_rate
FROM cleaned_customer_churn_analysis
GROUP BY Internet_Service
ORDER BY Churned_rate DESC
LIMIT 1;


#Explanation : Fiber optic has the highest churn rate

#How much monthly revenue is associated with churned customers

SELECT
COUNT(*) AS Total_customers,
ROUND(SUM(Monthly_Charges), 2) AS Monthly_charges_at_risk
FROM cleaned_customer_churn_analysis
WHERE Churn = 'yes';

#Which customer should be prioritised for retention based on high charges and short tenture
SELECT
Customer_ID,
Monthly_Charges,
Tenure_Months,
Total_Charges,
Churn
FROM cleaned_customer_churn_analysis
WHERE Churn = 'no' AND Monthly_Charges > (SELECT AVG(Monthly_Charges)
FROM cleaned_customer_churn_analysis)
AND Tenure_Months < (SELECT AVG(Tenure_Months)  
FROM cleaned_customer_churn_analysis)
ORDER BY Monthly_Charges DESC
LIMIT 1;

# Is high customer support activity associated with higher churn

SELECT
   CASE
		WHEN
        Customer_Support_Calls = 0 THEN 'No Calls'
        WHEN
        Customer_Support_Calls BETWEEN 1 AND 3 THEN '1-3 Calls'
        WHEN
        Customer_Support_Calls BETWEEN 4 AND 6 THEN '4-6 Calls'
        ELSE '7+ Calls'
        END AS Support_Call_Group,
        COUNT(*) AS Total_Customers,
        SUM(CASE WHEN Churn = 'yes'THEN 1 ELSE 0 END) AS Churned_customers,
        SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END)* 100 / COUNT(*) AS Churned_rate
        FROM cleaned_customer_churn_analysis
        GROUP BY Support_Call_Group
        ORDER BY Churned_rate DESC;
        
#EXPLANATION : Yes . There is  a clear positive association in the data that customer with more support calls tend to have higher churn rate .7+ calls group have the churn rate 63.54% .So, It is the highest risk segment call.