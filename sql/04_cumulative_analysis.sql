-- Cumulative and Trend Analysis (Monthly)
-- This query analyzes monthly sales performance over time.
-- It calculates:
-- 1) Total monthly sales
-- 2) Running total of sales within each year
-- 3) Average product price per month
-- 4) Moving average of prices within each year
-- The analysis helps identify growth trends and seasonality patterns.

select 
	order_date,
	total_sales,
	sum(total_sales) over (partition by year(order_date) order by order_date) as running_total_sales,
	avg_price,
	avg(avg_price) over (partition by year(order_date) order by order_date) as moving_average_price
from(select
	datetrunc(month,o.order_date) order_date,
	cast(sum(s.quantity*s.list_price*(1-s.discount))as int) as total_sales,
	cast(avg(s.list_price)as int) as avg_price
from sales.order_items as s
left join sales.orders as o
on s.order_id=o.order_id
where datetrunc(month,o.order_date) is not null
group by datetrunc(month,o.order_date)
)t
