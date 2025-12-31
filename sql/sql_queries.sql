CREATE DATABASE churn;
use churn;
 
SHOW VARIABLES LIKE "secure_file_priv";

CREATE TABLE customer_churn(
customer_id INT PRIMARY KEY ,
plan_type VARCHAR(10),
monthly_fee DECIMAL(10,2),
tenure_months INT,
avg_weekly_usage_hours DECIMAL(5,2),
last_login_days INT,
support_tickets INT,
payment_failures INT,
discount_used VARCHAR(10),
churn_flag TINYINT);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\customer_churn_data.csv'
INTO TABLE customer_churn
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

select count(*) from customer_churn;
select * from customer_churn;

#churn_rate_percentage
select 
ROUND(AVG(churn_flag)*100,2) as churn_rate_percentage
FROM customer_churn;

select
plan_type,ROUND(AVG(churn_flag)*100,2) as churn_rate_percentage,
count(*) AS total_customers
from customer_churn
group by plan_type
order by churn_rate_percentage desc;

select churn_flag,
ROUND(AVG(tenure_months)) as avg_tenure,
ROUND(AVG(avg_weekly_usage_hours)) as avg_weekly_usage_hours,
ROUND(AVG(support_tickets)) as support_tickets,
ROUND(AVG(payment_failures)) as payment_failures
from customer_churn
group by churn_flag;

select sum(monthly_fee) as monthly_revenue_lost
from customer_churn
where churn_flag=1;

select count(*) as high_risk_customers,
round(sum(monthly_fee)) as revennue_at_risk 
from customer_churn
where churn_flag=1
and tenure_months<6
and avg_weekly_usage_hours<5;

select plan_type,round(avg(churn_flag)*100,2) as churn_rate_percentage
from customer_churn
group by plan_type
having avg(churn_flag)>0.30;

