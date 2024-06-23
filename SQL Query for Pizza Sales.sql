-- CReating a tables
create database pizzahut;
select*
from pizzahut.pizza_types;

create table pizzahut.orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));

create table pizzahut.order_details(
order_detail_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_detail_id));

-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Q2 Calculate the total revenue generated from pizza sales.
select  round(sum(a.price*d.quantity),2) total_revenue
from pizzas as a
join order_details d
on a.pizza_id=d.pizza_id;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Q3 Identify the highest-priced pizza.
select c.name,a.price as highest_price
from pizzas as a
join pizza_types as c
on a.pizza_type_id=c.pizza_type_id
order by a.price desc
limit 1;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Q4 Identify the most common pizza size ordered.
select a.size,count(d.order_details_id)as ordered
from order_details as d
join pizzas as a
on a.pizza_id=d.pizza_id
group by a.size
order by ordered desc;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Q5 List the top 5 most ordered 
-- pizza types along with their quantities.
SELECT c.name,sum(d.quantity) top_ordered
FROM order_details as d
JOIN pizzas as a
ON a.pizza_id=d.pizza_id
join pizza_types as c
on c.pizza_type_id=a.pizza_type_id
group by c.name
order by sum(d.quantity) desc
limit 5 ;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Q6 Join the necessary tables to find the 
-- total quantity of each pizza category ordered.
SELECT c.category,sum(d.quantity) ordered
FROM order_details as d
JOIN pizzas as a
ON a.pizza_id=d.pizza_id
join pizza_types as c
on c.pizza_type_id=a.pizza_type_id
group by c.category ;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
--  Q7 Determine the distribution of orders by hour of the day.-- 
Select hour(b.order_time) as Hours ,count(b.order_id) as orders
from orders as b
group by hour(b.order_time)
order by hour(b.order_time) asc ;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Q 8 Join relevant tables to find the 
-- category-wise distribution of pizzas.
select c.category,count(c.name) as namess
from pizza_types AS c
group by c.category ;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

--  Q9 Group the orders by date and 
-- calculate the average number of pizzas ordered per day
SELECT 
    ROUND(AVG(order_quantity.total_quantity), 2) AS average_pizzas_per_day
FROM
    (SELECT 
        b.order_date, SUM(d.quantity) AS total_quantity
    FROM
        orders AS b
    JOIN order_details AS d ON b.order_id = d.order_id
    GROUP BY b.order_date) AS order_quantity;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
--  Q10 Determine the top 3 most ordered pizza types
-- based on revenue.
SELECT c.name,round(sum(d.quantity*a.price),2) revenue
FROM order_details as d
JOIN pizzas as a
ON a.pizza_id=d.pizza_id
join pizza_types as c
on c.pizza_type_id=a.pizza_type_id
group by c.name
order by revenue 
limit 3 ;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Q11 Calculate the percentage contribution of each 
-- pizza type to total revenue.
SELECT c.name,
    round((SUM(d.quantity * a.price) / 
    (SELECT SUM(t1.revenue) 
    FROM 
        (SELECT c.name, ROUND(SUM(d.quantity * a.price), 2) AS revenue
        FROM order_details AS d
        JOIN pizzas AS a ON a.pizza_id = d.pizza_id
        JOIN pizza_types AS c ON c.pizza_type_id = a.pizza_type_id
        GROUP BY c.name) AS t1
    )
    ) * 100 ,2) AS per_revenue
FROM pizza_types AS c
JOIN pizzas AS a 
ON c.pizza_type_id = a.pizza_type_id
JOIN order_details AS d 
ON a.pizza_id = d.pizza_id
GROUP BY c.name;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

--  Q12 Analyze the cumulative revenue generated over time.
select order_date,revenue,round(sum(revenue)over (order by order_date),2) as cumulative_revenue
from

(select b.order_date,round(sum(a.price*d.quantity),2) as revenue
from orders as b
join order_details d
on b.order_id=d.order_id
join pizzas as a
on a.pizza_id=d.pizza_id
group by b.order_date) as sales ;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Q 13 Determine the (top 3 most ordered ) (pizza types) 
-- (based on revenue) for each (pizza category
select category,name,round(revenue,2),rn
from(

select category,name,revenue,
rank()over(partition by category order by revenue desc) as rn
from(

select c.category,c.name,sum(d.quantity*a.price) revenue
from pizza_types as c
join pizzas as a
on a.pizza_type_id=c.pizza_type_id
join order_details d
on d.pizza_id=a.pizza_id
group by c.category,c.name ) as t1   ) t2

where rn<=3;
-- -------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

SELECT c.name,
    round((SUM(d.quantity * a.price) / 
    (SELECT SUM(t1.revenue) 
    FROM 
        (SELECT c.name, ROUND(SUM(d.quantity * a.price), 2) AS revenue
        FROM order_details AS d
        JOIN pizzas AS a ON a.pizza_id = d.pizza_id
        JOIN pizza_types AS c ON c.pizza_type_id = a.pizza_type_id
        GROUP BY c.name) AS t1
    )
    ) * 100 ,2) AS per_revenue
FROM pizza_types AS c
JOIN pizzas AS a 
ON c.pizza_type_id = a.pizza_type_id
JOIN order_details AS d 
ON a.pizza_id = d.pizza_id
GROUP BY c.name;


















