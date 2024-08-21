# SQL
This repository contains a collection of SQL projects that I am working on as I advance my skills in data analysis. Each project demonstrates my proficiency in querying, manipulating, and analyzing datasets using SQL.

## Project - 1 (Pizza Sales Analysis)

- This project involves analyzing a pizza sales dataset to extract meaningful insights using SQL. 
- The dataset includes details on orders, pizzas, their types, sizes, prices, and the ingredients used. 
- The project is structured around three levels of questions: Basic, Intermediate, and Advanced.

### Dataset Description

#### Table - 1 (order_details)

| Column Name        | Description                                          |
|--------------------|------------------------------------------------------|
| `order_details_id` | Unique identifier for each order detail entry.       |
| `order_id`         | Identifier that links the order detail to a specific order. |
| `pizza_id`         | Identifier that represents the type and size of the pizza ordered. |
| `quantity`         | The number of pizzas ordered in that specific entry. |

#### Table - 2 (orders)

| Column Name | Description                                           |
|-------------|-------------------------------------------------------|
| `order_id`  | Unique identifier for each order.                     |
| `date`      | The date when the order was placed (YYYY-MM-DD).      |
| `time`      | The time when the order was placed (HH:MM:SS).        |

#### Table - 3 (pizza_types)

| Column Name      | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `pizza_type_id`  | Unique identifier representing the specific type of pizza.                 |
| `name`           | The name of the pizza.                                                      |
| `category`       | The category of the pizza (e.g., Chicken, Classic, Supreme, Veggie).        |
| `ingredients`    | A list of ingredients used in the pizza.                                    |

#### Table - 4 (pizzas)

| Column Name    | Description                                                      |
|----------------|------------------------------------------------------------------|
| `pizza_id`     | Unique identifier for each pizza, indicating its type and size.  |
| `pizza_type_id`| Identifier representing the specific type of pizza.              |
| `size`         | The size of the pizza (e.g., S, M, L, XL, XXL).                  |
| `price`        | The price of the pizza based on its size and type.               |

### Questions

#### Basic:
- Q1. Retrieve the total number of orders placed.
- Q2. Calculate the total revenue generated from pizza sales.
- Q3. Identify the highest-priced pizza.
- Q4. Identify the most common pizza size ordered.
- Q5. List the top 5 most ordered pizza types along with their quantities.

#### Intermediate:
- Q1. Join the necessary tables to find the total quantity of each pizza category ordered.
- Q2. Determine the distribution of orders by hour of the day.
- Q3. Join relevant tables to find the category-wise distribution of pizzas.
- Q4. Group the orders by date and calculate the average number of pizzas ordered per day.
- Q5. Determine the top 3 most ordered pizza types based on revenue.

#### Advanced:
- Q1. Calculate the percentage contribution of each pizza type to total revenue.
- Q2. Analyze the cumulative revenue generated over time.
- Q3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.