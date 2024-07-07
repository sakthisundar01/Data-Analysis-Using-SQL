create schema pizza_runner;
set search_path = pizza_runner;

drop table if exists runners;
create table runners (
	"runner_id" integer,
	"registration_date" date
);
insert into runners
	("runner_id", "registration_date")
values
(1, '2021-01-01'),
(2, '2021-01-03'),
(3, '2021-01-08'),
(4, '2021-01-15');	

Drop table if exists customer_orders;
create table customer_orders (
	"order_id" integer,
	"customer_id" integer,
	"pizza_id" integer,
	"exclusions" varchar(4),
	"extras" varchar(4),
	"order_time" timestamp);

insert into customer_orders
	("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
values
	 ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

select * from customer_orders

DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

select * from runner_orders

drop table if exists pizza_names;
create table pizza_names (
	"pizza_id" integer,
	"pizza_name" text
);

insert into pizza_names
	("pizza_id","pizza_name")
values
	(1, 'meatlovers'),
	(2, 'vegetarians')
	
select * from pizza_names

DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
--how many pizzas were ordered?

select count(*) as pizzas_ordered 
from customer_orders 


---how many unique customers order were made?

select count(distinct order_id) as unique_customers 
from customer_orders 

---How many successful orders were delivered by each runner?

SELECT runner_id,
COUNT (DISTINCT ro.order_id) as delivered_orders
FROM customer_orders as co
INNER JOIN runner_orders as ro on co.order_id = ro.order_id
WHERE pickup_time<> 'null'
GROUP BY runner_id;

--- how many of each type of pizza was delivered?

SELECT
pn.pizza_name,
count(pn.pizza_id) as pizzas_delivered
FROM runner_orders as ro
INNER JOIN customer_orders as co on ro.order_id = co.order_id
INNER JOIN pizza_names as pn on co.pizza_id = pn.pizza_id
WHERE pickup_time<> 'null'
group by pizza_name;

--how many veg and meatlovers were ordered by each customers?

SELECT
pn.pizza_name,
co.customer_id,
count(pn.pizza_id) as pizzas_ordered
FROM customer_orders as co
INNER JOIN pizza_names as pn on co.pizza_id = pn.pizza_id
group by pizza_name,
co.customer_id;

--What was the maximum number of pizzas delivered in a single order?

select 
co.order_id,
count(pizza_id)
from customer_orders as co
inner join runner_orders as ro on co.order_id = ro.order_id
where pickup_time<>'null'
group by co.order_id
order by count(pizza_id) desc
limit 1
 
--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
 
Select co.customer_id,
sum(case 
	when (
			(exclusions is not null and exclusions <> 'null' and Length(exclusions)>0) or 
			(extras is not null and extras <> 'null' and Length(extras)>0)
		)=true 
		then 1 
		else 0
end) as changes,

sum(case 
	when (
			(exclusions is not null and exclusions <> 'null' and Length(exclusions)>0) or 
			(extras is not null and extras <> 'null' and Length(extras)>0)
		)=true 
		then 0
		else 1
end) as no_changes
--count (pizza_id)
from customer_orders as co
inner join runner_orders as ro on ro.order_id = co.order_id
where pickup_time<>'null'
group by co.customer_id


--How many pizzas were delivered that had both exclusions and extras
 
SELECT
COUNT (pizza_id) as pizzas_delivered_with_exclusions_and_extras
FROM customer_orders as co
INNER JOIN runner_orders as ro on ro.order_id = co.order_id
WHERE pickup_time<> 'null'
AND (exclusions IS NOT NULL AND exclusions<>'null' AND LENGTH(exclusions)>0)
AND (extras IS NOT NULL AND extras<>'null' AND LENGTH(extras) >0)

--what was the total volume of pizzas ordered for each hour of the day

select
date_part('hour', order_time)as hour,
count(pizza_id) as pizzas_ordered
from customer_orders
group by date_part('hour', order_time)

--what was the volume of orders for each day of the week?

SELECT EXTRACT(DOW FROM order_time) AS day_of_week,
       COUNT(pizza_id) AS pizzas_ordered
FROM customer_orders
GROUP BY EXTRACT(DOW FROM order_time)

--how many runner signed up for each 1 week period? -week starts 2-21-01-01

SELECT
  DATE_TRUNC('week', registration_date) + INTERVAL '4 days' AS week_start,
  COUNT(runner_id) AS runners
FROM
  runners
GROUP BY
  DATE_TRUNC('week', registration_date) + INTERVAL '4 days';

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT runner_id,
       AVG(EXTRACT(EPOCH FROM (CAST(pickup_time AS TIMESTAMP) - CAST(order_time AS TIMESTAMP))) / 60) AS avg_time_diff_in_mins
FROM runner_orders AS ro
INNER JOIN customer_orders AS co ON ro.order_id = co.order_id
WHERE pickup_time<>'null'
GROUP BY runner_id;


--Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT co.order_id,
       COUNT(co.pizza_id) AS number_of_pizzas,
       EXTRACT(EPOCH FROM (ro.pickup_time::timestamp - co.order_time::timestamp)) / 60 AS time_to_pickup_minutes
FROM runner_orders AS ro
INNER JOIN customer_orders AS co ON ro.order_id = co.order_id
WHERE ro.pickup_time<>'null'
GROUP BY co.order_id, co.order_time, ro.pickup_time


--What was the average distance travelled for each customer?

SELECT co.customer_id,
AVG(REPLACE (distance, 'km', '') :: numeric (3,1)) as avg_distance
FROM runner_orders as ro
INNER JOIN customer_orders as co on co.order_id = ro.order_id
Where distance<>'null'
GROUP BY co.customer_id

--What was the difference between the longest and shortest delivery times for all orders?

SELECT
    MAX(REGEXP_REPLACE(duration, '[^0-9]', '', 'g')::int) - MIN(REGEXP_REPLACE(duration, '[^0-9]', '', 'g')::int) as time_diff
FROM runner_orders
WHERE duration<> 'null'

--What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT 
    runner_id,
    order_id,
    AVG(REPLACE(distance, 'km', '')::numeric / 
        (REGEXP_REPLACE(duration, '[^0-9]', '', 'g')::numeric / 60)) AS avg_speed
FROM 
    runner_orders
WHERE 
    duration <> 'null'  -- Assuming duration is a string column where 'null' is represented as a string
GROUP BY 
    runner_id, order_id;



--What is the successful delivery percentage for each runner?

SELECT runner_id,
SUM (CASE
WHEN pickup_time='null' THEN 0
ELSE 1
END)/COUNT (order_id) as successful_delivery_percentage
FROM runner_orders
GROUP BY runner_id


