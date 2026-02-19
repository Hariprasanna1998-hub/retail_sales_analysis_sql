create database projects

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    join_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    category VARCHAR(50),
    price DECIMAL(10,2)
);




CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

CREATE TABLE Order_Items (
    order_id INT,
    product_id INT,
    quantity INT
);






select*from customers
select *from products
   
INSERT INTO Customers VALUES
(1,'Amit','Hyderabad','2023-01-10'),
(2,'Sneha','Bangalore','2023-02-05'),
(3,'Rahul','Chennai','2023-02-18'),
(4,'Priya','Hyderabad','2023-03-02'),
(5,'Kiran','Mumbai','2023-03-20'),
(6,'Meena','Delhi','2023-04-01'),
(7,'Arjun','Pune','2023-04-15'),
(8,'Divya','Chennai','2023-05-10');

INSERT INTO Products VALUES
(101,'Electronics',15000),
(102,'Electronics',20000),
(103,'Clothing',2000),
(104,'Clothing',3500),
(105,'Groceries',500),
(106,'Groceries',800),
(107,'Furniture',12000),
(108,'Furniture',18000);


INSERT INTO Orders VALUES
(1001,1,'2023-06-01'),
(1002,2,'2023-06-03'),
(1003,1,'2023-06-10'),
(1004,3,'2023-07-01'),
(1005,4,'2023-07-05'),
(1006,5,'2023-07-18'),
(1007,2,'2023-08-02'),
(1008,6,'2023-08-09'),
(1009,7,'2023-08-20'),
(1010,1,'2023-09-01'),
(1011,8,'2023-09-12'),
(1012,3,'2023-09-25');


INSERT INTO Order_Items VALUES
(1001,101,1),
(1001,105,2),
(1002,103,3),
(1003,102,1),
(1004,104,2),
(1005,106,5),
(1006,107,1),
(1007,105,4),
(1008,108,1),
(1009,103,2),
(1010,101,1),
(1011,106,3),
(1012,104,1);





----SALES PERFORMANCE ANALYSIS----



--- total revenue---

select
SUM(P.price*I.quantity) AS total_revenue
from Order_Items I join Products P on P.product_id= I.product_id


----total orders recieved -----

select COUNT(distinct order_id)as total_orders from Orders



-------total customers purchased-----

select COUNT(distinct customer_id) as customers from Orders



------monthly revenue-----

select MONTH(O.order_date)as month_no,
SUM(P.price*I.quantity) AS total_revenue
from Orders O
inner join  Order_Items I on O.order_Id=I.order_Id 
inner join Products P on P.product_id= I.product_id
group by month(O.order_date)
order by month_no ;





----CUSTOMER ANALYSIS----


----total customers----

select COUNT(*)as total_customers from Customers 


--------top 5 customers based on revenue---

select top 5 o.customer_id,SUM(P.price*I.quantity) AS total_revenue
from Orders O
join  Order_Items I on O.order_Id=I.order_Id 
join Products P on P.product_id= I.product_id
group by o.customer_id
order by total_revenue desc;

--------top 5 customers based on orders and revenue---

select top 5 o.customer_id,COUNT(o.order_id)as total_orders,
SUM(P.price*I.quantity) AS total_revenue
from Orders O
join  Order_Items I on O.order_Id=I.order_Id 
join Products P on P.product_id= I.product_id
group by o.customer_id order by total_orders desc,total_revenue desc;



------customers who never ordered--------
 
select c.customer_id,c.customer_name from customers c left join Orders o on c.customer_id=o.customer_id
where o.order_id is null


------customers who ordered only once--------
 
select c.customer_id from customers c inner join Orders o on c.customer_id=o.customer_id
group by c.customer_id 
having COUNT(o.order_id)=1



-------calcute the total amount spend by each customer-----

select O.customer_id,
SUM(P.price*I.quantity)as total_spent
from Orders O
join Order_Items I on O.order_id=I.order_id
join Products P on P.product_id=I.product_id
group by O.customer_id                                                      



---PRODUCT ANALYSIS-----


--------Total revenue per product----- 

select p.product_id,
SUM(p.price*I.quantity)as total_revenue
from Products p
join Order_Items I on p.product_id=I.product_id
join Orders O on I.order_id=O.order_id
group by p.product_id
order by total_revenue desc


-----Total quantity sold per product----

select p.product_id,
SUM(I.quantity)as total_quantity_sold
from Products p
join Order_Items I on p.product_id=I.product_id
group by p.product_id
order by total_quantity_sold desc


------Products never sold----

select p.product_id
from Products p
left join Order_Items I on p.product_id=I.product_id
where i.product_id is null



-----Top 5 products by revenue----

select p.product_id,SUM(P.price*I.quantity) AS total_revenue
from Products p
join  Order_Items I on  p.product_id= I.product_id
join  Orders o on o.order_id=I.order_id
group by p.product_id
order by total_revenue desc;




------Top 5 products by quantity sold----

 select top 5 p.product_id,SUM(I.quantity) AS total_quantity
from Products p
join  Order_Items I on  p.product_id= I.product_id
join  Orders o on o.order_id=I.order_id
group by p.product_id
order by total_quantity desc;


----BUSINESS METRICS----


-----customers who is repeating ----

select customer_id,COUNT(order_id)as total_orders from Orders
group by customer_id
having COUNT(order_id) >1

-----customers who ordered only once----

select customer_id,COUNT(order_id)as total_orders from Orders
group by customer_id
having COUNT(order_id) =1



-----Average order value(AOV)----

select SUM(p.product_id*I.quantity)/COUNT(distinct o.order_id) AS avg_order_value
from  Orders O
join  Order_Items I on O.order_Id=I.order_Id 
join Products P on P.product_id= I.product_id



------Total spent for a customer----


select O.customer_id,
SUM(P.price*I.quantity)as total_spent
from Orders O
join Order_Items I on O.order_id=I.order_id
join Products P on P.product_id=I.product_id
group by O.customer_id 
order by total_spent desc;



-----most active month(peak sales month)------


select MONTH(O.order_date)as month_no,
SUM(P.price*I.quantity) AS total_revenue
from Orders O
inner join  Order_Items I on O.order_Id=I.order_Id 
inner join Products P on P.product_id= I.product_id
group by month(O.order_date)
order by month_no ;