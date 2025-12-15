with yearly_product_sales as 
(select
	year(o.order_date) order_year,
	p.product_name,
	cast(sum(s.quantity*s.list_price*(1-s.discount))as int) as total_sales
from sales.order_items as s
left join sales.orders as o
on s.order_id=o.order_id
left join production.products as p
on s.product_id=p.product_id
where year(o.order_date) is not null
group by year(o.order_date), p.product_name
)
select 
	order_year,
	product_name,
	total_sales,
	lag(total_sales) over(partition by product_name order by order_year) as py_sales,
	total_sales - lag(total_sales) over(partition by product_name order by order_year) as diff_py,
	case when total_sales - lag(total_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
	when total_sales - lag(total_sales) over(partition by product_name order by order_year) < 0 then 'Decrease' 
	else 'No change'
	end py_change,
	avg(total_sales) over (partition by product_name) as avg_total_sales,
	total_sales - avg(total_sales) over (partition by product_name) as diff_avg,
	case when total_sales - avg(total_sales) over (partition by product_name) > 0 then 'Above Avg'
	when total_sales - avg(total_sales) over (partition by product_name) < 0 then 'Below Avg' 
	else 'Avg'
	end avg_change
from yearly_product_sales
