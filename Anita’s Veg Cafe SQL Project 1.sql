-- Anita’s Veg Cafe 
select * from members 
select * from menu
select * from sales 

1 -- What is the total amount each customer has spent at the café?

SELECT s.customer_id,
SUM(m.price) AS total_spent
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

2 -- How many distinct days has each customer placed an order?
SELECT customer_id,
COUNT(DISTINCT order_date) AS total_days
FROM sales
GROUP BY customer_id
ORDER BY customer_id;

3 -- What was the fi rst dish ordered by each customer?
SELECT DISTINCT ON (s.customer_id)
s.customer_id,
m.product_name,
s.order_date
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
ORDER BY s.customer_id, s.order_date;

4.-- Which menu item is the most popular overall?
SELECT m.product_name,
COUNT(*) AS total_orders
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_orders DESC
LIMIT 1;

5 -- What is the most frequently ordered dish for each customer?
SELECT customer_id, product_name, order_count
FROM ( SELECT s.customer_id, m.product_name,
COUNT(*) AS order_count,
RANK() OVER (PARTITION BY s.customer_id
ORDER BY COUNT(*) DESC) AS rnk
FROM sales s JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name) sub 
WHERE rnk = 1;

6 -- After joining the loyalty program, what dish did each member fi rst order? 
SELECT DISTINCT ON (s.customer_id)
s.customer_id,
s.order_date,
m.product_name
FROM sales s
JOIN members mb ON s.customer_id = mb.customer_id
JOIN menu m ON s.product_id = m.product_id
WHERE s.order_date >= mb.join_date
ORDER BY s.customer_id, s.order_date;

7 -- Before joining the loyalty program, what dish did each customer order last?
SELECT DISTINCT ON (s.customer_id)
s.customer_id,
s.order_date,
m.product_name
FROM sales s
JOIN members mb ON s.customer_id = mb.customer_id
JOIN menu m ON s.product_id = m.product_id
WHERE s.order_date < mb.join_date
ORDER BY s.customer_id, s.order_date
DESC;
