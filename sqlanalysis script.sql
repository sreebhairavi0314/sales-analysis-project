SELECT * from sales;
use analysis;
SELECT SUM(Amount) as total_revenue
from sales;
-- Step 1: Update the Amount column to remove commas and store as integer
-- Disable safe update mode for this session
SET SQL_SAFE_UPDATES = 0;

-- Run your update
UPDATE sales
SET Amount = REPLACE(Amount, ',', '');

-- Enable it again (optional)
SET SQL_SAFE_UPDATES = 1;


-- Step 2: Alter the column to INT
ALTER TABLE sales
MODIFY Amount INT;
-- Top selling products
SELECT Product,SUM(Amount)AS total_revenue,SUM(no_of_units) AS total_units
FROM sales
group by Product
order by total_revenue DESC
LIMIT 5;
ALTER TABLE sales
CHANGE COLUMN `No.of Units` no_of_units INT;
-- Total sales vs units sold
SELECT 
    Category,
    SUM(Amount) AS total_revenue,
    SUM(no_of_units) AS total_units_sold
FROM sales
GROUP BY Category
ORDER BY total_revenue DESC;
ALTER TABLE sales
CHANGE COLUMN `Sales Rep` sales_rep text;
-- Calculate total sales amount  units sold per sales representative.
SELECT sales_rep, SUM(Amount) AS total_sales, SUM(no_of_units) AS total_units
FROM sales
GROUP BY sales_rep
order by total_sales DESC;
-- Determine which city has the highest total sales amount.
SELECT city,SUM(Amount) as highest_sale_amount
FROM sales
group by city
order by highest_sale_amount DESC
limit 1;
-- Group sales by month to see revenue trends over time.
SELECT 
    DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%Y-%m') AS month,
    SUM(Amount) AS total_revenue,SUM(no_of_units) AS total_units_sold
FROM sales
GROUP BY month
ORDER BY month;
ALTER TABLE sales
CHANGE COLUMN ï»¿Date order_date TEXT;
-- Identify all orders where the amount is greater than ₹5,000.
SELECT * 
FROM sales 
WHERE Amount > 5000 
ORDER BY Amount DESC;
-- Compare which products have high units sold but low revenue, and vice versa.
SELECT 
    product,
    SUM(no_of_units) AS total_units_sold,
    SUM(Amount) AS total_revenue,
    ROUND(SUM(Amount) / SUM(no_of_units), 2) AS avg_revenue_per_unit
FROM sales
GROUP BY product
ORDER BY avg_revenue_per_unit DESC;
--  For each category, find the product with the highest sales amount.
SELECT category, product, total_amount
FROM (
    SELECT 
        category,
        product,
        SUM(Amount) AS total_amount,
        RANK() OVER (PARTITION BY category ORDER BY SUM(Amount) DESC) AS rank_in_category
    FROM sales
    GROUP BY category, product
) ranked_sales
WHERE rank_in_category = 1;
-- For each city, find the sales rep with the maximum sales.
SELECT city, sales_rep, total_sales
FROM (
    SELECT 
        city,
        sales_rep,
        SUM(Amount) AS total_sales,
        RANK() OVER (PARTITION BY city ORDER BY SUM(Amount) DESC) AS rank_in_city
    FROM sales
    GROUP BY city, sales_rep
) ranked_sales
WHERE rank_in_city = 1;
-- List products that have sold less than 1500 units in total.
SELECT Product, SUM(no_of_units) AS total_units_sold
FROM sales
GROUP BY Product
HAVING total_units_sold < 1500;






