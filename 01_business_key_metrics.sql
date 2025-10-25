-- Project: Business Key Metrics Dashboard
-- Goal: Generate a report that summarizes all main business KPIs such as
-- total sales,total quantity total orders,total products, total customers, and average price.
-- This query combines data from multiple tables (sales, products, customers)
-- to provide a high-level view of business performance.

-- Find the total sales 

SELECT
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales]

-- Find how many items are sold

SELECT
	SUM(quantity) as total_quantity
FROM [gold.fact_sales]

-- Find the average selling price

SELECT
	AVG(price) as avg_price
FROM [gold.fact_sales]

-- Find the toal number of orders

SELECT
	COUNT(DISTINCT order_number) as total_orders
FROM [gold.fact_sales]

-- Find the total number of products

SELECT
	COUNT(DISTINCT product_number) as total_products
FROM [gold.dim_products]

-- Find the total number of customers

SELECT
	COUNT(customer_key) as total_customers
FROM [gold.dim_customers]

-- Find the total number of customers who have placed an order

SELECT
	COUNT(DISTINCT c.customer_key) as total_customers
FROM [gold.dim_customers] as c
LEFT JOIN [gold.fact_sales] as s
on c.customer_key=s.customer_key

-- Generate a report that shows all key metrics of the business

SELECT 'Total Sales' as measure_name, SUM(sales_amount) as measure_value FROM [gold.fact_sales]
UNION ALL
SELECT 'Total Quantity' as measure_name, SUM(quantity) as measure_value FROM [gold.fact_sales]
UNION ALL 
SELECT 'Average Price' as measure_name, AVG(price) as measure_value FROM [gold.fact_sales]
UNION ALL
SELECT 'Total Orders' as measure_name, COUNT(DISTINCT order_number) as measure_value FROM [gold.fact_sales]
UNION ALL 
SELECT 'Total Products' as measure_name, COUNT(DISTINCT product_number) as measure_value FROM [gold.dim_products]
UNION ALL
SELECT 'Total Customers' as measure_name, COUNT(customer_key) as measure_value FROM [gold.dim_customers]