/*
Time Trend Analysis
-------------------
This file explores sales performance over time using the Bike Store dataset.
The analysis focuses on yearly and monthly trends, seasonality, and identification
of best and worst performing periods based on revenue, customer activity, and quantity sold.
*/


-- Yearly Sales Performance
-- Analyzes total revenue, number of active customers, and total quantity sold per year.
-- Helps identify long-term business growth and overall sales performance trends.

select
	year(d.order_date) order_year,
	sum(s.quantity*s.list_price*(1-s.discount)) as total_sales,
	count(distinct d.customer_id) as total_customers,
	sum(s.quantity) as total_quantity
from sales.order_items as s
left join sales.orders as d
on s.order_id=d.order_id
where d.order_date is not null
group by year(d.order_date)
order by year(d.order_date)

-- Monthly Sales Trends (Seasonality Analysis)
-- Aggregates sales metrics by month number across all years.
-- Used to identify seasonal patterns and high/low performing months regardless of year.

select
	month(d.order_date) order_month,
	sum(s.quantity*s.list_price*(1-s.discount)) as total_sales,
	count(distinct d.customer_id) as total_customers,
	sum(s.quantity) as total_quantity
from sales.order_items as s
left join sales.orders as d
on s.order_id=d.order_id
where d.order_date is not null
group by month(d.order_date)
order by month(d.order_date)

-- Monthly Sales Trends Over Time
-- Analyzes sales performance by month and year using a continuous timeline.
-- Provides a clear view of revenue trends, customer activity, and sales volume over time.

select
	datetrunc(month,d.order_date) order_date,
	sum(s.quantity*s.list_price*(1-s.discount)) as total_sales,
	count(distinct d.customer_id) as total_customers,
	sum(s.quantity) as total_quantity
from sales.order_items as s
left join sales.orders as d
on s.order_id=d.order_id
where d.order_date is not null
group by datetrunc(month,d.order_date)
order by datetrunc(month,d.order_date)

-- Best Performing Month by Revenue
-- Identifies the month with the highest total revenue.
-- Useful for understanding peak business performance periods.

with monthly_sales as (
select 
	datetrunc(month,d.order_date) as month,
	sum(s.quantity*s.list_price*(1-s.discount)) as total_sales
from sales.order_items as s
join sales.orders as d
on s.order_id=d.order_id
where d.order_date is not null
group by datetrunc(month,d.order_date)
)
select top 1 *
from monthly_sales
order by total_sales desc

-- Worst Performing Month by Revenue
-- Identifies the month with the lowest total revenue.
-- Highlights periods of weaker performance that may require further investigation.

with monthly_sales as (
select 
	datetrunc(month,d.order_date) as month,
	sum(s.quantity*s.list_price*(1-s.discount)) as total_sales
from sales.order_items as s
join sales.orders as d
on s.order_id=d.order_id
where d.order_date is not null
group by datetrunc(month,d.order_date)
)
select top 1 *
from monthly_sales
order by total_sales





