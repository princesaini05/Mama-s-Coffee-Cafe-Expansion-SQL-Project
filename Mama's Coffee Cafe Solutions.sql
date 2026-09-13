use Mama_coffee_cafe_db;
-- Mama's_coffee_cafe_db -- Data Analysis
select * from city;
select * from customers;
select * from products;
select * from sales;

-- Report & Data Analysis

-- Q1. Coffee consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
select 
      city_name,
      round((population * 0.25)/1000000,2) as coffee_consumers_in_millions,
      city_rank
from city
order by 2 desc;

-- Q2. Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in last qtr of 2023

SELECT
	ci.city_name,
    sum(total) as total_revenue
from sales as s
join customers as c
on s.customer_id=c.customer_id
join city as ci
on c.city_id=ci.city_id
where 
    extract(YEAR from s.sale_date) = 2023
    and
    extract(quarter from s.sale_date) = 4
group by 1
order by 2 desc;

-- Q3. Sales Count for Each Product
-- How many units of each coffee product have been sold?
select p.product_name,
	count(s.sale_id) as Total_sale
from
products as p
left join
sales as s
on s.product_id=p.product_id
group by 1
order by 2 desc;

-- Q4. Average Sales Amount per City
-- What is the average sales amount per customer in each city?
select ci.city_name,
	 sum(s.total) as Total_revenue,
     count(distinct s.customer_id) as total_customer,
     round(sum(s.total)/count(distinct s.customer_id),1) as avg_sale
from 
sales as s
join customers as c
on s.customer_id=c.customer_id
join city as ci
on c.city_id=ci.city_id
group by 1
order by 4 desc;


-- Q5. City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.

with city_table as
(select city_name,
      round((population*0.25)/1000000,2) as coffee_consumers
from
city
),
customers_table
as
(
select ci.city_name,
count(distinct c.customer_id) as unique_cx
from sales as s
join customers as c
on c.customer_id=s.customer_id
join city as ci
on c.city_id=ci.city_id
group by 1
)

select city_table.city_name,
city_table.coffee_consumers as coffee_consumers_in_millions,
customers_table.unique_cx
from city_table
join customers_table
on city_table.city_name=customers_table.city_name
order by 2 desc
limit 10;

-- Q6. Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?

select *
from
(
select 
     ci.city_name,
     p.product_name,
     count(s.sale_id) as total_order,
     dense_rank() over(partition by ci.city_name order by count(s.sale_id) desc) as product_rank
from sales as s
join products as p
on s.product_id=p.product_id
join customers as c
on s.customer_id=c.customer_id
join city as ci
on c.city_id=ci.city_id
group by 1,2
-- order by 1,3 desc;
)
as t1
where product_rank <= 3;

-- Q7. Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

SELECT 
    ci.city_name,
     count(distinct s.customer_id) as total_customer
FROM city AS ci
LEFT JOIN customers AS c
    ON ci.city_id = c.city_id
JOIN sales AS s
    ON s.customer_id = c.customer_id
JOIN products AS p
    ON p.product_id = s.product_id
where 
s.product_id in (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
group by 1
order by 2 desc;

-- Q8. Impact of estimated rent on sales:
-- Find each city and their average sale per customer and avg rent per customer

with city_table
as
(select ci.city_name,
      count(distinct s.customer_id) as unique_cx,
      sum(s.total) as total_sale,
      round(sum(s.total)/count(distinct s.customer_id),2) as avg_sale_per_cx
FROM city AS ci
LEFT JOIN customers AS c
    ON ci.city_id = c.city_id
JOIN sales AS s
    ON s.customer_id = c.customer_id
JOIN products AS p
    ON p.product_id = s.product_id
group by 1),
city_rent
as
(select city_name,
      estimated_rent
from city
)
select
      cr.city_name,
      ct.total_sale,
      cr.estimated_rent,
      ct.unique_cx,
      ct.avg_sale_per_cx,
      round((cr.estimated_rent/ct.unique_cx),2) as avg_rent_per_cx,
      round(ct.avg_sale_per_cx/round((cr.estimated_rent/ct.unique_cx),2),2)
from city_rent as cr
join city_table as ct
on cr.city_name=ct.city_name
order by 7 desc;


-- Q9. Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).

with 
monthly_sale
as
(
select ci.city_name,
extract(YEAR from s.sale_date) AS years,
extract(month from s.sale_date) AS months,
sum(s.total) as total_sale
from sales as s

join customers as c
on c.customer_id=s.customer_id

join city as ci
on ci.city_id=c.city_id
group by 1,2,3
order by 1,2,3),
growth
as
(select
     city_name,
     years,
     months,
     total_sale as cr_monthly_sale,
     lag(total_sale,1) over(partition by city_name order by years,months) as last_month_sale
from monthly_sale)

select
     city_name,
     years,
     months,
     cr_monthly_sale,
     last_month_sale,
     round(((cr_monthly_sale-last_month_sale)/last_month_sale)*100,2) as percentage_growth_monthly
from growth
where
    last_month_sale is not null;
    

-- Q10. Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
with city_table
as
(select ci.city_name,
      count(distinct s.customer_id) as unique_cx,
      sum(s.total) as total_sale,
      round(sum(s.total)/count(distinct s.customer_id),2) as avg_sale_per_cx
FROM city AS ci
LEFT JOIN customers AS c
    ON ci.city_id = c.city_id
JOIN sales AS s
    ON s.customer_id = c.customer_id
JOIN products AS p
    ON p.product_id = s.product_id
group by 1),
city_rent
as
(select city_name,
      estimated_rent,
      round((population * 0.25)/1000000,3) as estimated_coffee_consumer
from city
)
select
      cr.city_name,
      ct.total_sale as Total_sale,
      cr.estimated_rent as Total_Rent,
      ct.unique_cx as Total_customers,
      cr.estimated_coffee_consumer as estimated_coffee_consumer_in_millions,
      ct.avg_sale_per_cx,
      round((cr.estimated_rent/ct.unique_cx),2) as avg_rent_per_cx
from city_rent as cr
join city_table as ct
on cr.city_name=ct.city_name
order by 2 desc;

/*
-- Recomendation
City1: Pune
1. Highest average sale per customer (₹24,197)
2. Highest total revenue based on historical data
3. Lowest average rent per customer
4. Strong balance of revenue and cost efficiency

#Verdict: Best overall city for a new outlet.

city2: Delhi
1. Highest estimated coffee consumers (7.7 million)
2. Highest total active customers (68)
3. Affordable average rent per customer (₹330)
4. Largest untapped market potential

#Verdict: Best city for maximum customer reach.

City3: Jaipur

1. Highest number of current customers (69)
2. Lowest average rent per customer (₹156)
3. Good average sale per customer (₹11,600)
4. Low operational cost with steady demand

#Verdict: Best cost-efficient expansion option.
