-- Total Sales
SELECT 
    SUM(CAST(price AS DECIMAL(10,2))) AS total_sales
FROM df_orderitems;

-- Total Orders
SELECT 
    COUNT(*) AS total_orders
FROM df_orders;

-- Total Customers
SELECT COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM df_customers;

-- Average Delivery Time
SELECT 
AVG( 
	DATEDIFF(
		STR_TO_DATE(order_delivered_date, '%d-%m-%Y'),
        STR_TO_DATE(order_purchase_date, '%d-%m-%Y')
        )
	) AS delivery_date
    FROM df_orders;
        
-- Delivered Orders
 SELECT COUNT(*) AS delivered_orders
 FROM df_orders
 WHERE order_status = 'delivered';
 
 -- Not Delivered Orders
SELECT COUNT(*)
FROM df_orders
WHERE order_status != 'delivered';

-- Shipping Charges
SELECT 
	SUM(CAST(shipping_charges AS DECIMAL (10,2))) AS total_shipping_charges
    FROM df_orderitems;
    
-- Total Revenue
SELECT
	SUM(CAST(price + shipping_charges AS DECIMAL (10,2))) AS Total_Revenue
    FROM df_orderitems;

-- MOST SALES BY CATEGORY
SELECT 
	SUM(CAST(df_orderitems.price AS DECIMAL(10,2))) AS TOTAL_SALES,
    df_products_clean.product_category_name
FROM df_orderitems INNER JOIN df_products_clean 
ON df_orderitems.product_id = df_products_clean.product_id
GROUP BY df_products_clean.product_category_name
ORDER BY TOTAL_SALES DESC;

-- Top 10 Products by Total Sales
SELECT
product_id,
 SUM(CAST(price AS DECIMAL(10,2))) AS Best_Selling_Products
 FROM df_orderitems
GROUP BY product_id
ORDER BY Best_Selling_Products desc
limit 10;

-- Individual products were sold the most times
SELECT 
product_id,
COUNT(*) AS Most_Sold_Products
FROM df_orderitems
GROUP BY product_id
ORDER BY Most_Sold_Products DESC
LIMIT 10;

-- product categories have the highest number of products sold
SELECT
df_products_clean.product_category_name,
COUNT(*) AS Highest_Number_of_Product_Sold
FROM df_orderitems INNER JOIN df_products_clean
ON df_orderitems.product_id = df_products_clean.product_id
GROUP BY df_products_clean.product_category_name
ORDER BY Highest_Number_of_Product_Sold DESC;

-- Orders Placed Each Year
		SELECT 
	YEAR(STR_TO_DATE(order_purchase_date , '%d-%m-%Y')) AS Order_Placed_Each_Year,
    COUNT(*) AS Total_No_Of_Orders
	 FROM df_orders
     GROUP BY YEAR(STR_TO_DATE(order_purchase_date , '%d-%m-%Y')); 
     
  -- Orders Placed Each Month   
     SELECT 
	MONTH(STR_TO_DATE(order_purchase_date , '%d-%m-%Y')) AS Order_Placed_Each_Month,
    COUNT(*) AS Total_No_Of_Orders
	 FROM df_orders
     GROUP BY MONTH(STR_TO_DATE(order_purchase_date , '%d-%m-%Y')); 
     
  -- Average Order Value
SELECT 
    AVG(order_total) AS average_order_value
FROM (
    SELECT 
        order_id,
        SUM(CAST(price AS DECIMAL(10,2))) AS order_total
    FROM df_orderitems
    GROUP BY order_id
) AS order_totals;

-- TOP 10 Customers Who Spent Most Money
	SELECT
    df_customers.customer_id,
    SUM(CAST(df_orderitems.price AS DECIMAL(10,2))) AS total_spent
FROM df_customers
INNER JOIN df_orders
    ON df_customers.customer_id = df_orders.customer_id
INNER JOIN df_orderitems
    ON df_orders.order_id = df_orderitems.order_id
GROUP BY df_customers.customer_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT 
customer_id,
COUNT(order_id) AS Top_10_Customers
FROM df_orders
GROUP BY customer_id
ORDER BY Top_10_Customers DESC
LIMIT 10;

SELECT 
order_status,
COUNT(*) AS most_frequent_order_status
FROM df_orders
GROUP BY order_status
ORDER BY most_frequent_order_status DESC;

-- Total Sales Per Year
SELECT
SUM(CAST(price AS DECIMAL(10,2))) AS Total_Sales,
YEAR(STR_TO_DATE(order_purchase_date , '%d-%m-%Y')) AS Sales_Per_Year
FROM df_orders INNER JOIN df_orderitems
ON df_orders.order_id = df_orderitems.order_id
GROUP BY YEAR(STR_TO_DATE(order_purchase_date , '%d-%m-%Y'));

-- Product Category Analysis
SELECT 
YEAR(STR_TO_DATE(order_purchase_date , '%d-%m-%Y')) AS Purchase_Year,
MONTH(STR_TO_DATE(order_purchase_date , '%d-%m-%Y')) AS Purchase_Month,
SUM(CAST(price AS DECIMAL(10,2))) AS Total_Sales
FROM df_orders INNER JOIN df_orderitems
ON df_orders.order_id = df_orderitems.order_id
GROUP BY YEAR(STR_TO_DATE(order_purchase_date , '%d-%m-%Y')) , MONTH(STR_TO_DATE(order_purchase_date , '%d-%m-%Y'));

-- On-Time vs Late Delivery
SELECT
    delivery_status,
    COUNT(*) AS total_orders
FROM (
    SELECT
        CASE
            WHEN STR_TO_DATE(order_delivered_date, '%d-%m-%Y')
                 <= STR_TO_DATE(order_estimated_delivery_date, '%d-%m-%Y')
            THEN 'On Time'

            WHEN STR_TO_DATE(order_delivered_date, '%d-%m-%Y')
                 > STR_TO_DATE(order_estimated_delivery_date, '%d-%m-%Y')
            THEN 'Late'
        END AS delivery_status
    FROM df_orders
    WHERE order_delivered_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
) AS delivery_analysis
GROUP BY delivery_status;

-- Customer Location Analysis
SELECT 
df_customers.customer_state,
COUNT(*) AS orders
FROM df_customers INNER JOIN df_orders ON
df_customers.customer_id = df_orders.customer_id
GROUP BY df_customers.customer_state
ORDER BY orders DESC
LIMIT 10;

SHOW DATABASES;

    
    
    
