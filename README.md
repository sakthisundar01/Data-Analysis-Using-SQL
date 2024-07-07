# Pizza Runner SQL Data Analysis Queries 

## Overview

The Pizza Runner SQL Data Analysis project aims to provide insights into the operations of a fictional pizza delivery service called "Pizza Runner." By using a set of SQL queries, we can analyze various aspects of the business such as customer ordering patterns, runner performance, and overall business efficiency.

## Analysis and Insights

To analyze the operations of Pizza Runner, I executed a series of SQL queries to gather comprehensive insights into key performance metrics. First, I determined the total number of pizzas ordered to understand the overall demand and business volume. This was achieved by querying the total count of orders in the customer_orders table. Next, I identified the number of unique customers to assess the reach and customer base, using a query that counted distinct customer IDs.

To evaluate runner performance, I analyzed the number of successful orders delivered by each runner, joining the customer_orders and runner_orders tables and filtering out any orders with null pickup times. Understanding the types of pizzas most frequently ordered was crucial for menu optimization, so I joined the customer_orders with the pizza_names table to count and categorize the different pizzas delivered.

Further, I analyzed the number of orders with modifications (exclusions or extras) to gain insights into customer customization preferences, which involved checking the length and presence of non-null values in the exclusions and extras fields. Lastly, I identified the maximum number of pizzas delivered in a single order by joining the customer_orders and runner_orders tables, grouping by order ID, and counting the number of pizzas in each order. This holistic analysis, leveraging a range of SQL queries, provided a detailed understanding of Pizza Runner's operations, customer behavior, and runner efficiency.
