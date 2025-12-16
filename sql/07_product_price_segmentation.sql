-- Product Price Segmentation
-- This analysis groups products into predefined price ranges to understand the structure of the product portfolio
-- and identify concentration across low, mid, and high price segments.

with product_segments as
(select
	product_name,
	list_price as price,
	case when list_price < 500 then 'Below 500'
	when list_price between 500 and 1500 then '500-1500'
	when list_price between 1500 and 2500 then '1500-2500'
	when list_price between 2500 and 5000 then '2500-5000'
	else 'Above 5000'
	end as cost_range
from production.products
)
  
select 
	cost_range,
	count(product_name) as total_products
from product_segments
group by cost_range
order by total_products desc
