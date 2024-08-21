-- Create Database
create database pizza_sales;

-- Use Database 'pizza_sales'
USE pizza_sales;

-- Create Table 'orders'
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

-- Modify 'pizza_id' column type from 'text' to 'varchar'
alter table pizzas
modify pizza_id varchar(255) not null;

-- Add Primary Key for Table 'pizzas'
alter table pizzas
add primary key (pizza_id);

-- Create Table 'order_details'
CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id varchar(255) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id),
    FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    FOREIGN KEY (pizza_id)
        REFERENCES pizzas (pizza_id)
);

-- Modify 'pizza_type_id' column type from 'text' to 'varchar'
alter table pizza_types
modify pizza_type_id varchar(255) not null;

alter table pizzas
modify pizza_type_id varchar(255) not null;

-- Add Primary Key for Table 'pizza_types'
alter table pizza_types
add primary key (pizza_type_id);

-- Add Foreign Key for Table 'pizzas'
alter table pizzas
add constraint fk_pizza_type
foreign key (pizza_type_id) references pizza_types(pizza_type_id);

-- Basic:
-- Q1. Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) as Total_Orders
FROM
    orders;

-- Q2. Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(p.price * od.quantity), 2) AS Total_Revenue
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id;

-- Q3. Identify the highest-priced pizza.
-- Method_1
SELECT 
    name
FROM
    pizzas AS p
        JOIN
    pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id
WHERE
    price = (SELECT 
            MAX(price) AS Highest_Priced_Pizza
        FROM
            pizzas);

-- Method_2
SELECT 
    pt.name, p.price
FROM
    pizzas AS p
        JOIN
    pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Q4. Identify the most common pizza size ordered.
SELECT 
    p.size, SUM(od.quantity) AS Quantity
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY Quantity DESC;

-- Q5. List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) AS Total_Quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY Total_Quantity DESC
LIMIT 5;

-- Intermediate:
-- Q1. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS Quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY Quantity DESC;

-- Q2. Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS Hour, COUNT(order_id) as Order_Count
FROM
    orders
GROUP BY Hour;

-- Q3. Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name) AS Count
FROM
    pizza_types
GROUP BY category;

-- Q4. Group the orders by date and calculate the average number of pizzas ordered per day.
with count_of_pizza_per_day as (
	SELECT 
		order_date, SUM(od.quantity) AS Pizza_Count
	FROM
		orders AS o
			JOIN
		order_details AS od ON o.order_id = od.order_id
	GROUP BY order_date
)
SELECT 
    ROUND(AVG(Pizza_Count), 0) as avg_pizza_per_day
FROM
    count_of_pizza_per_day;

-- Q5. Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name, SUM(od.quantity * p.price) AS Total_Revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Total_Revenue DESC
LIMIT 3;

-- Advanced:
-- Q1. Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.name,
    ROUND(((SUM(od.quantity * p.price) / (SELECT 
                    SUM(od.quantity * p.price)
                FROM
                    order_details AS od
                        JOIN
                    pizzas AS p ON p.pizza_id = od.pizza_id)) * 100),
            2) AS Pizza_Type_Percentage
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Pizza_Type_Percentage DESC;

-- Q2. Analyze the cumulative revenue generated over time.
with date_revenue as (
	SELECT 
		o.order_date,
		ROUND(SUM(p.price * od.quantity), 2) AS revenue
	FROM
		orders AS o
			JOIN
		order_details AS od ON o.order_id = od.order_id
			JOIN
		pizzas AS p ON p.pizza_id = od.pizza_id
	GROUP BY o.order_date
)
SELECT 
	order_date, 
	ROUND(sum(revenue) over(order by order_date), 2) as cumulative_revenue
FROM 
	date_revenue;

-- Q3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category, name, ROUND(revenue, 2) AS _revenue, _rank 
FROM 
(SELECT 
	category, name, revenue, rank() over(partition by category order by revenue desc) as _rank
FROM 
	(SELECT 
		pt.category, pt.name, SUM(od.quantity * p.price) AS revenue
	FROM
		pizza_types AS pt
			JOIN
		pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
			JOIN
		order_details AS od ON od.pizza_id = p.pizza_id
	GROUP BY pt.category , pt.name) as a) as b
WHERE
	_rank <= 3;