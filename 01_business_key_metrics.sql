-- BUSINESS KEY METRICS REPORT
-- This query summarizes key business indicators from the BikeStores dataset.
-- It combines multiple KPIs into one unified output using UNION ALL for clarity.

select 'Total Sales' as measure_name,cast(sum(quantity*list_price*(1-discount))as int) as measure_value from sales.order_items
union all
select 'Total Quantity' as measure_name, cast(sum(quantity)as int) as measure_value from sales.order_items
union all
select 'Average Price' as measure_name, cast(avg(list_price)as int) as measure_value from sales.order_items
union all
select 'Total Nr. of Orders' as measure_name, cast(count(order_id)as int) as measure_value from sales.order_items
union all
select 'Total Nr. of Products' as measure_name, cast(count(product_name)as int) as measure_value from production.products
union all
select 'Total Nr. of Customes' as measure_name, cast(count(customer_id)as int) as measure_value from sales.customers
