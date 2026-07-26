use TechStoreDB;

-------------------------------------------
--Task 1: Clean Customer and Inquiry Data--
-------------------------------------------

--1 Display customer city as Unknown when city is missing ISNULL / COALESCE

select customer_id,customer_name,Phone,email,ISNULL(city,'Unknown') as clean_city,registration_date
	from Customers;

--2 Display customer phone as No Phone when phone is missing. ISNULL / COALESCE

select customer_id,customer_name,ISNULL(phone,'NO phone') as clean_phone,email,city,registration_date
	from Customers;

--3 Remove extra spaces from customer names. TRIM

select customer_id,TRIM(customer_name) as clean_Name,phone,email,city,registration_date
	from Customers;

--4 Standardize customer city names.UPPER

select customer_id,UPPER(customer_name) as clean_Name,phone,email,city,registration_date
	from Customers;

--4 Standardize customer city names.LOWER

select customer_id,LOWER(customer_name) as clean_Name,phone,email,city,registration_date
	from Customers;

----------------------------------------
--Task 2: Detect Data Quality Problems--
----------------------------------------

--1 Find customers with missing phone numbers. IS NULL

select customer_id,customer_name,Phone,email,city,registration_date 
	from Customers
		where Phone is null;

--2 Find customers with missing cities.IS NULL

select customer_id,customer_name,Phone,email,city,registration_date 
	from Customers
		where city is null;

--3 Find inquiries with missing phone numbers.IS NULL

select * from CustomerInquiries
	where phone is null;

--4Find duplicate customer emails.GROUP BY + HAVING

select email, count(*) as duplicate_emails  from Customers
	group by email
		having count(*)>1;

--5 Find duplicate inquiry phone numbers.GROUP BY + HAVING

select Phone, count(*) as duplicate_emails  from Customers
	group by Phone
		having count(*)>1;

--------------------------------------
--Task 3: Create Business Categories--
--------------------------------------

--1 Classify customer region from city:Cairo/Giza = Greater Cairo, Alexandria =North Coast, Mansoura = Delta, missing= Unknown, otherwise Other.CASE WHEN

select customer_id,customer_name,Phone,email,
case 
	when LOWER(trim(city)) in ('cairo','giza') then 'greater cairo'
	when LOWER(trim(city)) in ('alexandria') then 'North Coast'
	when LOWER(trim(city)) in ('Mansoura') then 'Delta'
	when LOWER(trim(city)) is null then 'unknown'
	else lower(trim(city)) 
		end as clean_city
	,registration_date
	from Customers;

--2 Classify product stock status: 0 = Out of Stock, 1-10 = Low Stock, more than 10 = Available. CASE WHEN

SELECT product_id,product_name,stock_quantity,
CASE
	WHEN stock_quantity = 0 THEN 'Out of Stock'
	WHEN stock_quantity BETWEEN 1 AND 10 THEN 'Low Stock'
	ELSE 'Available'
	END AS stock_status
FROM Products;

--3 Classify payment status group: Paid = Successful, Pending = Waiting, Failed = Problem, otherwise Other. CASE WHEN

select payment_id,payment_amount,Payment_date,payment_method,
case 
	when LOWER(trim(payment_status)) in ('Paid') then 'Successful'
	when LOWER(trim(payment_status)) in ('Pending') then 'Waiting'
	when LOWER(trim(payment_status)) in ('Failed') then 'Problem'
	else 'ather' 
	end as payment_status
from Payments;

-------------------------------
--Task 4: Order Date Analysis--
-------------------------------
--1 Show orders created this year.YEAR / GETDATE

select * from Orders where YEAR(order_date) =YEAR(GETDATE());

--2 Show orders created this month.YEAR + MONTH

select * from Orders where MONTH(order_date)=MONTH(GETDATE());

--3 Show orders created in the last 30 days. DATEADD

select * from Orders where order_date>=DATEADD(DAY,-30,GETDATE());

--4 Count orders by year. YEAR + GROUP BY

select year(order_date),count(*) as count_orders
	from orders
		group by YEAR(order_date);

--5 Count orders by month.YEAR + MONTH + GROUP BY

select year(order_date) as year,MONTH(order_date) as month,count(*) as count_orders
	from orders
		group by year(order_date),MONTH(order_date);

--6 Calculate monthly total order value. JOIN + GROUP BY

select year(order_date) as year,MONTH(order_date) as month,sum(OI.quantity*OI.Unit_price) as value
	from orders O
	join OrderItems OI
		on o.order_id=OI.order_id
		group by year(order_date),MONTH(order_date);

----------------------------------------------
--Task 5: Customer and Inquiry Time Analysis--
----------------------------------------------
--1 Count customers registered by month. YEAR + MONTH

select YEAR(registration_date) as year,MONTH(registration_date) as month,count(*) as count_customer
	from Customers
		group by YEAR(registration_date),MONTH(registration_date);

--2 Count inquiries by month. YEAR + MONTH

select  year(inquiry_date) as year,MONTH(inquiry_date) as month,count(*) as count_inquiries
	from CustomerInquiries
		group by year(inquiry_date),MONTH(inquiry_date);

--3 Find inquiries created in the last 7 days.DATEADD

select * 
	from CustomerInquiries
		where inquiry_date>=DATEADD(day,-7,getdate());

--4 Find customers registered more than 90 days ago. DATEDIFF / DATEADD

SELECT customer_id,
       customer_name,
       registration_date
	FROM Customers
		WHERE DATEDIFF(DAY, registration_date, GETDATE()) > 90;

--5 Calculate how many days passed since each customer registered.DATEDIFF

SELECT
    customer_id,
    customer_name,
    registration_date,
    DATEDIFF(DAY, registration_date, GETDATE()) AS days_since_registration
FROM Customers;

----------------------
--Task 6: Subqueries--
----------------------

--1 Find products with a price higher than the average product price.Subquery in WHERE

select *
	from Products
		where unit_price>(select avg(unit_price)from Products);

--2 Find orders with payment amount higher than the average payment amount. Subquery in WHERE

select *
	from Orders O
	join Payments P
		on O.order_id=P.order_id
			where P.payment_amount>(select avg(payment_amount) from Payments);

--3 Find customers who have at least one order. Subquery / IN

select top(1) * 
	from Customers C
	join Orders O
		on O.customer_id=C.customer_id
			order by O.order_date desc;

--4 Find products that were ordered at least once. Subquery / IN

select *
	from Products
		where product_id in (select product_id from Orders);

----------------
--Task 7: CTEs--
----------------
--1 Total sales value per product. CTE + JOIN + SUM

WITH ProductSales AS
(
    SELECT
    product_id,SUM(quantity * unit_price) AS total_sales
		FROM OrderItems
			GROUP BY product_id
)

select * from ProductSales;

--2 Total sales value per category. CTE + GROUP BY

WITH CategorySales  AS
(
	select P.category_id,sum(OI.quantity*OI.Unit_price) as totalsales
		from Products P
		join OrderItems OI
			on P.product_id=OI.product_id
				group by P.category_id

)

select *from CategorySales ;
--3 Total payment amount per customer. CTE + GROUP BY

with customeramount as
(
	select c.customer_name,sum(p.payment_amount) as customer_amount
		from Customers c
		left join orders o
			on c.customer_id=o.customer_id
		left join Payments p
			on o.order_id=p.order_id
				group by c.customer_name
)

select * from customeramount;

--4 Monthly revenue summary. CTE + date functions

with revenue as 
(
	select YEAR(Payment_date) as year,MONTH(payment_date) as month,SUM(payment_amount) as total_revenue
		from Payments
			group by YEAR(Payment_date),MONTH(payment_date)
)

select * from revenue;

----------------------------------
--Task 8: Create Reporting Views--
----------------------------------
--1 Create vw_sales_summary with order, customer, product, category, quantity, unit price, and item total value. CREATE VIEW

create view vw_sales_summary as
	select o.order_id,c.customer_name,o.order_date,
			o.order_status,p.product_name,ca.category_name,
			oi.quantity,oi.Unit_price,oi.quantity*oi.Unit_price as item_total_value
		from Orders o
			join Customers c 
				on o.customer_id=c.customer_id
			join OrderItems oi
				on o.order_id=oi.order_id
			join Products p
				on oi.product_id=p.product_id
			join Categories ca
				on p.category_id=ca.category_id;

select * from vw_sales_summary;

--2 Create vw_customer_inquiry_analysis with inquiry, source, city, campaign, representative, converted customer, and conversion status. CREATE VIEW + CASE  

create view vw_customer_inquiry_analysis as
select c.inquiry_id,c.inquiry_source,c.city,m.campaign_name,c.representative_id,cc.customer_name,
	case 
		when representative_id is not null then 'converted'
			else 'not cinverted' 
			end as status
from CustomerInquiries c
	join MarketingCampaigns m
		on c.campaign_id=m.campaign_id
	join Customers cc
		on c.representative_id=cc.customer_id

select * from vw_customer_inquiry_analysis;

-----------------------------------
--Task 9: Ranking and Row Numbers--
-----------------------------------
--1 Rank products by total sales value. RANK

select product_id,
	sum(oi.quantity*oi.Unit_price) as total,
	rank () over(order by sum(oi.quantity*oi.Unit_price) desc ) as rank
	from OrderItems oi
		GROUP BY product_id;

--2 Rank categories by total sales value. RANK

select p.category_id,
		sum(oi.quantity*oi.Unit_price) as total,
		rank() over(order by sum(oi.quantity*oi.Unit_price)desc) as rank
	from Products p
	join OrderItems oi
		on p.product_id=oi.product_id
			group by p.category_id;

--3 Rank sales representatives by number of orders. RANK

select sr.representative_id,count(o.order_id) as total_orders,rank()over( order by count(o.order_id)desc) as rank
	from SalesRepresentatives sr
	join orders o
		on sr.representative_id=o.representative_id
			group by sr.representative_id;

--4 Show the latest order for each customer. ROW_NUMBER

with customer_last_order as 
	(
	select c.customer_id,ROW_NUMBER() over (partition by c. customer_id order by order_date desc) as rankk
		from Customers c
		join Orders o
			on c.customer_id=o.customer_id
		)

	select * from customer_last_order
	where rankk=1;

--5 Show the latest payment for each order. ROW_NUMBER

with payments_lastest_orders as 
(
	select 
		p.payment_id,
			ROW_NUMBER() over(partition by p.payment_id order by o.order_date) as rankk
	from Orders o
		join Payments p
			on o.order_id=p.order_id
)

select * 
	from payments_lastest_orders
		where rankk =1;

-------------------------------------------
--Task 10: Running Totals and Comparisons--
-------------------------------------------
--1 Calculate running total revenue by order date. SUM OVER

select o.order_date,sum(p.payment_amount) over(order by o.order_date) as total_revenue
	from Payments P
	join orders o
		on p.order_id=o.order_id;

--2 Calculate running total payment amount by payment date. SUM OVER

select p.Payment_date,sum(p.payment_amount) over(order by p.Payment_date) as total_revenue
	from Payments P;

--3 Calculate monthly revenue. GROUP BY

select YEAR(p.Payment_date) as year,MONTH(p.payment_date) as month,SUM(p.payment_amount) as total_revenue
	from Payments p
		group by YEAR(p.Payment_date),MONTH(p.payment_date);

--4 Compare each month revenue with the previous month. LAG

select YEAR(p.Payment_date)as year,MONTH(p.payment_date)as month,SUM(p.payment_amount) as total_revenue,
	lag(SUM(p.payment_amount))
		over( order by YEAR(p.Payment_date),MONTH(p.payment_date)) as  previous_month_revenue
from Payments p
	group by YEAR(p.Payment_date),MONTH(p.payment_date);

--5 Show revenue difference between current month and previous month. LAG + calculation

select YEAR(p.Payment_date)as year,MONTH(p.payment_date)as month,SUM(p.payment_amount) as total_revenue,
	lag(SUM(p.payment_amount))
		over(order by YEAR(p.Payment_date),MONTH(p.payment_date)) as previous_month_revenue,
	(SUM(p.payment_amount)-lag(SUM(p.payment_amount))
		over(order by YEAR(p.Payment_date),MONTH(p.payment_date))) as difference_
from Payments p
	group by YEAR(p.Payment_date),MONTH(p.payment_date);

-------------------------------------
--Task 11: Business Insight Summary--
-------------------------------------
--1.Which product has the highest total sales value?

select top 1 product_id,sum(quantity*Unit_price) as total
	from OrderItems
		group by product_id
			order by total desc;

--2.Which category generates the highest revenue?

select top 1 c.category_id,sum(o.quantity*o.Unit_price) as total
	from Categories c
	join Products p
		on p.category_id=c.category_id
	join OrderItems o
		on p.product_id=o.product_id
			group by c.category_id
				order by total;

--3.Which month has the highest revenue?

select top 1 YEAR(p.Payment_date)as year,MONTH(p.payment_date)as month,sum(p.payment_amount)as total
	from Payments p
		group by YEAR(p.Payment_date),MONTH(p.payment_date)
			order by total desc;

--4.Which campaign has the highest number of converted inquiries?

select *
	from MarketingCampaigns
		group by campaign_id;
--5.Which customers placed more than one order?

select customer_id,count(*) as total_orders
	from Orders
		group by customer_id
			having count(order_id)>1;

--6.Are there products with low stock but high sales?

select p.product_id,sum(p.stock_quantity) as stock_quantityy,sum(o.quantity*o.Unit_price) as total_sales
	from Products p
	join OrderItems o
		on p.product_id=o.product_id
			group by p.product_id
				order by stock_quantityy desc;

--7.Are there orders with no successful payment?

select o.order_id,p.payment_status
	from Orders o
	join Payments p
		on o.order_id=p.order_id
			where p.payment_status in ('failed');
--8.What is the latest order for each customer?

select customer_id,MAX(order_date) as last_order
	from Orders
		group by customer_id;