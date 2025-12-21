/*
Product Performance Report – Bike Store Dataset

This query analyzes product-level sales performance using the Bike Store sample database.
It combines order, customer, product, and category data to generate key business metrics,
including revenue, order frequency, customer reach, product lifecycle, and recency.

The report segments products into performance tiers (High, Mid, Low) based on total sales
and provides additional insights such as average order revenue and average monthly revenue.

SQL concepts used:
- Common Table Expressions (CTEs)
- Multi-table joins
- Aggregations and grouping
- Date-based calculations (lifespan and recency)
- Conditional logic for segmentation and KPIs

Purpose:
To demonstrate analytical SQL skills and business-oriented thinking for product performance evaluation.
*/

with base_query as (select
    oi.order_id,
    o.order_date,
    o.customer_id,
    oi.product_id,
    p.product_name,
	c.category_id,
	c.category_name,
    oi.quantity,
    oi.list_price,
    oi.discount
from sales.order_items oi
left join sales.orders o
    on oi.order_id = o.order_id
left join production.products p
    on oi.product_id = p.product_id
left join production.categories c
    on p.category_id = c.category_id
where o.order_date is not null),

product_aggregations as(
select 
    product_id,
	product_name,
	category_id,
	category_name,
	count(distinct order_id) as total_orders,
	datediff(month,min(order_date),max(order_date)) as lifespan_months,
	max(order_date) as last_sale_date,
	count(distinct customer_id) as total_customers,
	sum(quantity) as total_quantity,
	cast(sum(quantity*list_price*(1-discount))as decimal(12,0)) as total_sales
from base_query
group by product_id,
         product_name,
	     category_id,
		 category_name)

select
product_id,
product_name,
category_id,
category_name,
total_orders,
lifespan_months,
last_sale_date,
datediff(month,last_sale_date,getdate()) as recency_month,
total_customers,
total_quantity,
total_sales,
case when total_sales> 80000 then 'High Performance'
     when total_sales>= 10000 then 'Mid Performance'
	                          else 'Low Performance'
	end product_segment,
case when total_orders=0 then 0 
     else cast(total_sales/total_orders as decimal(12,0))
	 end as avg_order_revenue,
case when lifespan_months=0 then total_sales
     else cast(total_sales/lifespan_months as decimal(12,0))
	 end as avg_monthly_revenue
from product_aggregations
