-- This query analyzes sales performance by product category.
-- It calculates total revenue per category, overall revenue across all categories,
-- and each category’s percentage contribution to total sales.
-- This helps identify which categories drive the most value for the business.

with category_sales as (
select
	c.category_name,
	cast(sum(s.quantity*p.list_price*(1-s.discount))as int) as total_sales
from sales.order_items as s
left join production.products as p
on s.product_id=p.product_id
left join production.categories as c
on p.category_id=c.category_id
group by c.category_name)

select
category_name,
total_sales,
sum(total_sales) over() as overall_sales,
concat(round((cast(total_sales as float)/sum(total_sales) over())*100,2),'%') as percentage_of_total
from category_sales
order by total_sales desc
