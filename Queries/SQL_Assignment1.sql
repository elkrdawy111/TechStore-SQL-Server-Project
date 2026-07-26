--------------------
--Customer Queries--
--------------------
--1. Display all customer records.
select * from Customers;
--2. Display customer name, city, email, and registration date.
select customer_name,city,email,registration_date from Customers;
--3. Display customers ordered from newest to oldest.
select * from Orders
	order by order_date desc;
--4. Display customers from Cairo.
select * from Customers
	where city ='cairo';
--5. Display customers from Cairo or Giza.
select * from Customers
	where city in ('cairo','giza');
--6. Display customers whose phone number is missing.
select * from Customers
	where Phone is null;
--7. Display customers whose names contain Mohamed.
select * from Customers
	where customer_name like '%mohamed%';
--8. Display the five earliest registered customers.
select top 5 * from Customers
	order by registration_date desc;

-----------
--porduct--
-----------
--1. Display all available products.
select * from Products;
--2. Display products costing more than 10,000.
select * from Products
	where unit_price>10000;
--3. Display products costing between 2,000 and 15,000.
select * from Products
	where unit_price between 2000 and 15000;
--4. Display products with zero stock.
select * from Products
	where stock_quantity =0;
--5. Display products from selected categories using IN.
select * from Products
	where category_id in(1,2,3);
--6. Display products whose names begin with Samsung.
select * from Products 
	where product_name like 'Samsung%';
--7. Display products ordered from highest to lowest price.
select * from Products
	order by unit_price desc;
--8. Display the five cheapest products.
select top 5 * from Products
	order by unit_price asc;

-----------------
--Order Queries--
-----------------
--1. Display all delivered orders.
select * from Orders
	where order_status ='Delivered';
--2. Display all pending or confirmed orders.
select * from Orders
	where order_status in ('pending','confirmed');
--3. Display cancelled orders from Cairo.
select * from Orders 
	where delivery_city='cairo' and order_status='cancelled';
--4. Display orders created during a selected date range.
select * from Orders
	where order_date between '2026-07-01' and '2026-07-10';
--5. Display the ten latest orders.
select top 10 *from Orders 
	order by order_date desc;
--6. Display orders that are not cancelled.
select * from Orders
	where order_status!='cancelled';
--7. Display orders where the sales representative is missing.
select * from Orders
	where representative_id is null;
--8. Display distinct order statuses.
select distinct order_status from Orders;
-------------------
--Inquiry Queries--
-------------------

--1. Display inquiries from Facebook.

select * from CustomerInquiries
	where inquiry_source ='Facebook';

--2. Display inquiries from Facebook or Instagram.

select * from CustomerInquiries
	where inquiry_source in('Facebook','Instagram');

--3. Display Google inquiries from Cairo or Giza.

select * from CustomerInquiries
	where inquiry_source like 'Google%' and city in('Cairo','Giza');
--Note I don't have google in my data i have google ads so i use like

--4. Display inquiries that did not convert.

select * from CustomerInquiries
where converted_customer_id is null;

--5. Display inquiries with missing phone numbers.

select * from CustomerInquiries
where phone is null;

--6. Display the latest inquiries ordered by inquiry date.

select top 1 * from CustomerInquiries
order by inquiry_date desc;

----------------------
--Basic Aggregations--
----------------------
--1. Calculate the total number of customers.

select count(*) as count_customer from Customers;

--2. Calculate the total number of products.

select count(*) as count_Product from Products;

--3. Calculate the total number of orders.

select count(*) as count_Orders from Orders;

--4. Calculate the total number of inquiries.

select count(*) as count_inquiries from CustomerInquiries;

---5. Calculate the total payment amount.

select sum(payment_amount) as total_payment from Payments;

--6. Calculate the average payment amount.

select avg(payment_amount) as total_payment from Payments;

---7. Find the highest product price.

select top 1 * from Products
	order by unit_price desc;

--8. Find the lowest product price.

select top 1 * from Products
	order by unit_price asc;

--------------------
--GROUP BY Queries--
--------------------
--1. Calculate the number of customers per city.

select city ,count(*) as count_customer from Customers
	group by city;

--2. Calculate the number of products per category.

select category_id,count(*)as count_product from Products
	group by category_id;

--3. Calculate the number of orders per order status.

select order_status,count(*) as count_order from Orders
	group by order_status;

--4. Calculate the number of inquiries per source.

select inquiry_source,count(*) as count_inquiries from CustomerInquiries
	group by inquiry_source;

--5. Calculate the number of inquiries per campaign.

select campaign_id,count(*) as count_inquiries from CustomerInquiries
	group by campaign_id;

--6. Calculate total payments per payment method.

select payment_method,count(*) from Payments
	group by payment_method;

--7. Calculate the average product price per category.

select category_id,avg(unit_price)as avg_price from Products
	group by category_id;

--8. Calculate the total stock quantity per category.

select category_id,sum(stock_quantity) from Products
	group by category_id;

--9. Calculate the number of orders per delivery city.

select delivery_city,count(*)as count_orders from Orders
	group by delivery_city;

--10. Calculate the number of payments per payment status.

select payment_status,count(*) from Payments
	group by payment_status;

------------------
--HAVING Queries--
------------------
--1. Find cities with more than two customers.

select city,count(*) as customer_Count from Customers
	group by city
		having count(*)>=2;

--2. Find categories containing more than two products.

select category_id,count(product_id) as total_products from Products
	group by category_id
		having count(product_id)>=2;

--3. Find campaigns that generated more than three inquiries.

select campaign_id,count(*) from CustomerInquiries
	group by campaign_id
		having count(*)>3;

--4. Find customers who created more than one order.

select customer_id,count(*) from Orders
	group by customer_id
		having count(*)>1;

-----------------
--Business KPIs--
-----------------
--1. Calculate the overall inquiry conversion rate.

select count(converted_customer_id) * 100.0 / count(*) as conversion_rate
	from CustomerInquiries;

--2. Calculate the conversion rate by campaign.

select campaign_id ,count(converted_customer_id) * 100.0 / count(*) as conversion_rate
	from CustomerInquiries
		group by campaign_id;

--3. Calculate the conversion rate by inquiry source.

select inquiry_source ,count(converted_customer_id) * 100.0 / count(*) as conversion_rate
	from CustomerInquiries
		group by inquiry_source;

----------------------------
--Basic INNER JOIN Queries--
----------------------------
--1. Display products with their category names.

select product_id,product_name,C.category_name,unit_price,stock_quantity,is_available,brand
	from Products P
	inner join Categories C
		on P.category_id=C.category_id;
--2. Display orders with customer names.

select order_id,C.customer_name,representative_id,order_date,order_status,delivery_city
	from Orders O
	inner join Customers C
		on O.customer_id=C.customer_id;
--3. Display orders with sales representative names.

select S.representative_name,O.*
	from Orders O
	inner join SalesRepresentatives S
		on O.representative_id=S.representative_id;
--4. Display order items with product names.

select P.product_name,O.*
	from OrderItems O
	inner join Products P
		on O.product_id=P.product_id;
--5. Display payments with customer names.

select C.customer_name,P.*
	from Payments P
	inner join Orders O
		on P.order_id=O.order_id
	inner join Customers C
		on O.customer_id=C.customer_id;

--6. Display inquiries with campaign names.

select M.campaign_name,C.*
	from CustomerInquiries C
	inner join MarketingCampaigns M
		on C.campaign_id=M.campaign_id;
--7. Display inquiries with sales representative names.

select S.representative_name,C.*
	from CustomerInquiries C
	inner join SalesRepresentatives S
		on C.representative_id=S.representative_id;

---------------------
--Multi-Table Joins--
---------------------
--1. Display customer name, order date, and order status.

select C.customer_name,order_date,order_status
	from Orders O
	inner join Customers C
		on O.customer_id=C.customer_id;

--2. Display customer name, ordered product, and quantity.

select C.customer_name,P.product_name,OI.quantity
	from OrderItems OI 
	inner join Orders O
		on OI.order_id=O.order_id
	inner join Customers C
		on O.customer_id=C.customer_id
	inner join Products P
		on OI.product_id=P.product_id;

--3. Display order ID, customer name, product name, quantity, and unit price.

select O.order_id,C.customer_name,P.product_name,quantity,OI.unit_price
	from OrderItems OI
	inner join Orders O
		on OI.order_id=O.order_id
	inner join Customers C
		on O.customer_id=C.customer_id
	inner join Products P
		on OI.product_id=P.product_id;

--4. Display payment ID, customer name, order ID, and payment amount.

select payment_id,C.customer_name,O.order_id,payment_amount
	from Payments P
	inner join Orders O
		on P.order_id=O.order_id
	inner join Customers C
		on O.customer_id=C.customer_id;

--5. Display campaign name, inquiry name, and assigned representative.

select campaign_name,CI.customer_name,SR.representative_name
	from MarketingCampaigns MC
	inner join CustomerInquiries CI
		on MC.campaign_id=CI.campaign_id
	inner join SalesRepresentatives SR
		on CI.representative_id=SR.representative_id;

--6. Display customer name, product category, and ordered product.

select C.customer_name,CA.category_name,P.product_name
	from Customers C
	inner join Orders O 
		on C.customer_id=O.customer_id
	inner join OrderItems OI
		on O.order_id=OI.order_id
	inner join Products P
		on OI.product_id=P.product_id
	inner join Categories CA
		on P.category_id =CA.category_id;

--7. Display representative name, customer name, and order status.

SELECT CI.customer_name,O.order_status,SR.representative_name
	from SalesRepresentatives SR
	inner join CustomerInquiries CI
		on SR.representative_id = CI.representative_id
	inner join Orders O
		on SR.representative_id = O.representative_id;

--8. Display order ID, product name, quantity, and calculated item value.

SELECT O.order_id,p.product_name,OI.quantity,OI.quantity*OI.Unit_price as item_value
	from Orders O
	inner join OrderItems OI
		on O.order_id=OI.order_id
	inner join Products P
		on OI.product_id=P.product_id;

----------------------------------------
-- full outer join and Missing Records--
----------------------------------------

--1. Find customers who have never created an order.

select C.customer_name,O.order_id
	from Customers C
	full outer join Orders O
		on C.customer_id=O.customer_id
			where O.order_id is null;

--2. Find products that have never been ordered.

select P.product_name,O.order_id
	from Products P
	full outer join OrderItems OI
		on P.product_id=OI.product_id
	full outer join Orders O
		on OI.order_id=O.order_id
			where O.order_id is null;

--3. Find orders without payment records.

select O.order_id,p.payment_id
	from Orders O
	full outer join Payments P
		on O.order_id=P.order_id
			where P.payment_id is NULL;

--4. Find sales representatives who have no orders.

select SR.representative_name,O.order_id
	from SalesRepresentatives SR
	full outer join Orders O
		on SR.representative_id = O.representative_id
			where O.order_id is NULL;

--5. Find marketing campaigns with no inquiries.

select MC.campaign_name,CI.inquiry_id
	from MarketingCampaigns MC
	full outer join CustomerInquiries CI
		on MC.campaign_id = CI.campaign_id
			where CI.inquiry_id is NULL;

--6. Find inquiries that did not convert into customers.

select CI.inquiry_id,C.customer_id
	from CustomerInquiries CI
	full outer join Customers C
		on CI.converted_customer_id = C.customer_id
			where C.customer_id is NULL;

--7. Find customers whose orders have no successful payment.

select C.customer_name,P.payment_status
	from Customers C
	full outer join Orders O
		on C.customer_id = O.customer_id
	full outer join Payments P
		on O.order_id = P.order_id
			where P.payment_status in('Failed','Cancelled');

--------------------------
--Joins with Aggregation--
--------------------------

--1. Calculate the number of orders per customer.

select c.customer_name,count(o.order_id) AS count_order
	from Customers C
	full outer join Orders O
		on C.customer_id = o.customer_id
			group by c.customer_name;

--2. Calculate the number of products in each category.

select category_name,count(P.product_id) AS count_product
	from Categories C
	full outer join Products P
		on C.category_id = P.category_id
			group by category_name;

--3. Calculate the total quantity sold per product.

select product_name,sum(OI.quantity) as Total_quantity
	from Products P
	full outer join OrderItems OI
		on P.product_id=OI.product_id
			group by product_name;

--4. Calculate the total sales value per product.

select product_name,sum(o.quantity*O.Unit_price )as Total
	from Products P
	full outer join OrderItems O
		on p.product_id = o.product_id
			group by product_name;

--5. Calculate the total sales value per category.

select c.category_name,sum(o.quantity*O.Unit_price)as Total
	from Products P
	full outer join Categories C
		on c.category_id = p.category_id
	full outer join OrderItems O
		on p.product_id = o.product_id
			group by c.category_name;

--6. Calculate the total payment amount per customer.

select customer_name,SUM(p.payment_amount) as total_payment_per_customer
	from Customers C
	full outer join Orders O
		on c.customer_id = o.customer_id
	full outer join Payments P
		on o.order_id = p.order_id
			group by c.customer_name;

--7. Calculate the number of converted inquiries per campaign.

select MC.campaign_name,count(CI.inquiry_id) as number_of_converted_inquiries
	from MarketingCampaigns MC
	full outer join CustomerInquiries CI
		on MC.campaign_id = CI.campaign_id
			group by campaign_name;

--8. Calculate the number of orders handled by each sales representative.

select representative_name,count(o.order_id) as number_of_orders_handled
	from SalesRepresentatives SR
	full outer join Orders O
		on SR.representative_id = o.representative_id
			group by representative_name;

-----------------------------------
--Create one SQL report containing:
--Order ID
--customer name
--Order date
--Order status
--Number of different products
--Total ordered quantity
--Total order value
--Total paid amount
------------------------------------
select O.order_id,C.customer_name,O.order_date,O.order_status,count(OI.product_id),SUM(OI.quantity),sum(OI.quantity*OI.Unit_price),SUM(P.payment_amount)
	from Orders O
	full outer join Customers C 
		on O.customer_id =C.customer_id
	full outer join OrderItems OI
		on O.order_id=OI.order_id
	full outer join Payments P
		on O.order_id=P.order_id
			group by O.order_id,c.customer_name,o.order_date,o.order_status;

--------------------------------------
---Task 21: Business Interpretation---
--------------------------------------
--1. Which product generated the highest sales value?

select p.product_name,SUM(oi.quantity*oi.Unit_price) AS sales_value
	from Products P
	left join OrderItems OI
		on p.product_id = OI.product_id
			group by p.product_name
				order by sales_value desc;

--2. Which product category generated the highest revenue?

select category_name,SUM(oi.quantity*oi.Unit_price) AS sales_value
	from Categories C
	left join Products P
		on C.category_id=P.category_id
	left join OrderItems OI
		on P.product_id=OI.product_id
			group by category_name
				order by sales_value desc;

--3. Which city created the largest number of orders?

select city,counT (o.order_id) as number
	from Customers C
	left join Orders O
		on C.customer_id=O.customer_id
			group by city
				order by number desc;

--4. Which marketing campaign generated the most converted inquiries?

select campaign_name,count(CI.inquiry_id) as number
	from MarketingCampaigns MC
	left join CustomerInquiries CI
		on MC.campaign_id = CI.campaign_id
			group by campaign_name
				order by number desc;

--5. Which sales representative handled the most orders?

select representative_name,count(o.order_id) as number
	from SalesRepresentatives SR
	left join Orders O
		on SR.representative_id = O.representative_id
			group by representative_name
				order by number desc;

--6. Which products have stock but have never been ordered?

select product_name,SUM(stock_quantity) as number
	from Products p
	full outer join OrderItems OI
		on p.product_id = OI.product_id
	full outer join Orders O
		on OI.order_id=o.order_id
			group by product_name,O.order_id 
				having O.order_id is null;

--7. How many orders have not been paid?

select count(o.order_id) as number_of_orders_not_paid
	from orders O
	left join Payments P
		on o.order_id = p.order_id
			where p.payment_status in('cancelled','failed','pending');

--8. What percentage of inquiries converted into customers?

select (count(CI.converted_customer_id)*100/count(C.customer_id))  as percentage_of_inquiries_converted
	from Customers C
	left join CustomerInquiries CI
		on C.customer_id = CI.converted_customer_id;