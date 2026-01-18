Create database Zepto_project
use Zepto_project


--DATA EXPLORATION--

BEGIN Transaction
--count of rows
SELECT COUNT(*) FROM ZEPTO_V2

--sample data
SELECT TOP 10 * FROM zepto_v2;

--different product categories
SELECT DISTINCT category
FROM zepto_v2
ORDER BY category

--Products in stock vs outof stock

select outofstock,count(*) as [count]
FROM zepto_v2
GROUP BY outofstock

--Product name present multiple times

select name,count(*) as count_name
from zepto_v2
group by name
Having count(*) > 1
order by count_name DESC

--DATA CLEANING--

--Products with price zero

select * 
from zepto_v2
where mrp =0 or discountedsellingprice = 0

DELETE FROM zepto_v2 
WHERE mrp = 0

--convert mrp paise to rupees

update zepto_v2
set mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0

select * from zepto_v2

--BUSINESS INSIGHT--

--Q1. Find the top 10 best-value products based on the discount percentage.

select distinct top 10 name, mrp, discountpercent
from zepto_v2
order by discountPercent desc

--Q2. What are the products with High MRP but out of stock.
SELECT DISTINCT name, mrp
FROM zepto_v2
WHERE mrp > 300 AND outofstock = 1
ORDER BY mrp DESC

--Q3. Calculate Estimated Revenue for each category.

SELECT category,
SUM(discountedSellingPrice * availableQuantity) as Total_revenue
FROM zepto_v2
GROUP BY category
ORDER BY Total_revenue DESC

--Q4. Find all products where MRP is greater than Rs500 and discount is less than 10%
SELECT DISTINCT name, mrp, discountpercent
FROM zepto_v2
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC

--Q5.Identify the top 5 categories offering the highest average discount percentage.
SELECT Top 5 category,
ROUND(AVG(discountpercent),2)  AS avg_discountpercent
FROM zepto_v2
GROUP BY category
ORDER BY avg_discountpercent DESC

--Q6. Find the price per gram for products above 100g and short by best value.
SELECT DISTINCT name, weightingms, discountedSellingPrice,
ROUND(discountedsellingprice / weightingms, 2) AS price_per_gram
FROM zepto_v2
WHERE weightInGms >=100
ORDER BY price_per_gram

--Q7. Group the products into categories like Low, medium, Bulk.
SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'High'
     ELSE 'Bulk'
     END AS weight_category
FROM zepto_v2
--Q8. What is the total inventory weight per category.
SELECT category,
SUM(CAST(weightingms AS BIGINT) * CAST(availablequantity AS BIGINT)) AS total_weight
FROM zepto_v2
GROUP BY category
ORDER BY  total_weight


COMMIT TRANSACTION