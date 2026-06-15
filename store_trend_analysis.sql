-- dt - superstore dataset
-- du - segmented customer
-- ds - sales forecast
----------------------------------------------------------------------------------------------------------
-- 1.Top 10 Most Sold Products
------------------------------------------------------------------------------------------------------------
SELECT product_name, SUM(quantity) AS total_quantity_sold
FROM dt
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;
-------------------------------------------------------------------------------------------------------------
-- 2. Top 10 Most Profitable Products
-----------------------------------------------------------------------------------------------------------
SELECT product_name, SUM(profit) AS total_profit
FROM dt
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;
------------------------------------------------------------------------------------------------------------
--3. Sales Analysis by Category and sub-category
------------------------------------------------------------------------------------------------------------
SELECT category, sub_category, SUM(sales) AS total_sales
FROM dt
GROUP BY category, sub_category
ORDER BY category, total_sales DESC;
-------------------------------------------------------------------------------------------------------------
--4. Profit by Region 
-------------------------------------------------------------------------------------------------------------
SELECT region, SUM(profit) AS total_profit
FROM dt
GROUP BY region
ORDER BY total_profit DESC;
---------------------------------------------------------------------------------------------------------------
-- 5.Top 10 Most Profitable Customers and thier frequency 
----------------------------------------------------------------------------------------------------------------
SELECT a.customer_name, b.frequency , SUM(a.profit) AS total_profit
FROM dt a
join du b
on a.customer_id = b.customer_id 
GROUP BY a.customer_name , b.frequency
ORDER BY total_profit DESC
LIMIT 10;
-----------------------------------------------------------------------------------------------------------------
-- 6.Monthly Sales Trend
----------------------------------------------------------------------------------------------------------------
SELECT DATE_TRUNC('month', order_date) AS sales_month,
       SUM(sales) AS total_sales
FROM dt
GROUP BY sales_month
ORDER BY sales_month;
------------------------------------------------------------------------------------------------------------------
-- 7.Sales Contribution by Shipping Mode
------------------------------------------------------------------------------------------------------------------
SELECT ship_mode, SUM(sales) as total_sales, (SUM(sales) * 100.0 / (SELECT SUM(sales) FROM dt)) as percentage_contribution
FROM dt
GROUP BY ship_mode
ORDER BY total_sales DESC;
--------------------------------------------------------------------------------------------------------------------
-- 8.Customer Life time value 
--------------------------------------------------------------------------------------------------------------
WITH customer_metrics AS (
SELECT customer_id,COUNT(DISTINCT order_id) AS total_orders,SUM(sales) AS total_revenue,
SUM(profit) AS total_profit, AVG(sales) AS avg_order_value,MAX(order_date) AS last_order_date,
MIN(order_date) AS first_order_date FROM dt
GROUP BY customer_id
),
customer_lifespan AS (
SELECT *, EXTRACT(DAY FROM (last_order_date - first_order_date)) + 1 AS lifespan_days
FROM customer_metrics
)

SELECT *, total_revenue / NULLIF(total_orders, 0) AS AOV,
total_orders / NULLIF(lifespan_days, 0) AS purchase_frequency,(total_revenue) AS CLV
FROM customer_lifespan
ORDER BY CLV DESC;
-----------------------------------------------------------------------------------------------------------------
--9. Revenue Retension
-----------------------------------------------------------------------------------------------------------------
WITH customer_cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM dt
    GROUP BY customer_id
),
order_data AS (
    SELECT
        d.customer_id,
        DATE_TRUNC('month', d.order_date) AS order_month,
        d.sales
    FROM dt d
)
SELECT
    c.cohort_month,
    o.order_month,
    EXTRACT(YEAR FROM AGE(o.order_month, c.cohort_month)) * 12 +
    EXTRACT(MONTH FROM AGE(o.order_month, c.cohort_month)) AS cohort_index,
    SUM(o.sales) AS revenue
FROM customer_cohorts c
JOIN order_data o ON c.customer_id = o.customer_id
GROUP BY 1,2,3
ORDER BY 1,3;
------------------------------------------------------------------------------------------------------------
--10. Profit Margin Analysis
--------------------------------------------------------------------------------------------------------------
SELECT
    category,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(((SUM(profit) / NULLIF(SUM(sales),0)) * 100)::numeric, 2) AS profit_margin_pct
FROM dt
GROUP BY category
ORDER BY profit_margin_pct DESC;
-------------------------------------------------------------------------------------------------------------
-- 11. Segment-wise Product Preference
---------------------------------------------------------------------------------------------------------------
SELECT d.cluster,t.category, ROUND(SUM(t.sales)::numeric, 2) AS revenue
FROM dt t
JOIN du d ON t.customer_id = d.customer_id
GROUP BY d.cluster, t.category
ORDER BY d.cluster, revenue DESC;
----------------------------------------------------------------------------------------------------------------
-- 12. High-Value Customers Shipping Behavior
----------------------------------------------------------------------------------------------------------------
SELECT d.cluster, t.ship_mode, COUNT(*) AS orders
FROM dt t
JOIN du d ON t.customer_id = d.customer_id
WHERE d.cluster = 1 
GROUP BY d.cluster, t.ship_mode
ORDER BY orders DESC;
----------------------------------------------------------------------------------------------------------------
13.Segment-wise Discount Sensitivity
-------------------------------------------------------------------------------------------------------------
SELECT
    d.cluster,
    ROUND(AVG(t.discount)::numeric, 2) AS avg_discount,
    ROUND(AVG(t.profit)::numeric, 2) AS avg_profit
FROM dt t
JOIN du d ON t.customer_id = d.customer_id
GROUP BY d.cluster
ORDER BY avg_discount DESC;
-----------------------------------------------------------------------------------------------------------------