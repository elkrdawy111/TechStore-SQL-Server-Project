create database TechStoreDB;
use TechStoreDB;

create table Customers
(
	customer_id int identity(1,1) primary key,
	customer_name varchar(100) Not Null,
	Phone varchar(20),
	email varchar(150),
	city varchar (50),
	registration_date date default getdate()
);


create table Categories 
(
	category_id int identity(1,1) primary key,
	category_name varchar(100) Not Null unique
);

create table Products 
(
	product_id int identity(1,1) primary key,
	product_name varchar(150) Not Null,
	category_id int,
	unit_price decimal(10,2) Not Null,
	stock_quantity int Not Null,
	is_available bit default 1,
		constraint fk_category 
			foreign key (category_id)
				references Categories(category_id)
);


create table SalesRepresentatives
(
	representative_id int identity(1,1) ,
	representative_name varchar(100) Not Null,
	hire_date date default getdate(),
	region varchar(50)
);


alter table SalesRepresentatives add constraint PK_SalesRepresentatives primary key (representative_id);

create table MrketingCampaigns
(
	campaign_id int identity(1,1) primary key,
	campaign_name varchar(100) Not Null,
	campaign_channel varchar(50) Not Null,
	start_date date Not Null,
	end_date date ,
	campaign_budget decimal(12,2) Not Null
);


create table CustomerInquiries 
(
	inquiry_id int identity (1,1) primary key,
	customer_name varchar(100) Not Null,
	phone varchar(20),
	city varchar(50),
	inquiry_source varchar(50) Not Null,
	inquiry_date datetime default getdate(),
	campaign_id int ,
	representative_id int,
	converted_customer_id int,
		constraint fk_campaign
			foreign key (campaign_id)
			references MrketingCampaigns(campaign_id),
		constraint fk_representative
			foreign key (representative_id)
			references SalesRepresentatives(representative_id),
		constraint fk_customer
			foreign key (converted_customer_id)
			references Customers(customer_id)
	
);

create table Orders
(
	order_id int identity(1,1) primary key,
	customer_id int ,
	representative_id int,
	order_date datetime default getdate(),
	order_status varchar(30) default 'Pending',
	delivery_city varchar(50) Not Null,
		constraint fk_customer_order
			foreign key (customer_id)
			references Customers(customer_id),
		constraint fk_representative_id_order
			foreign key (representative_id)
			references SalesRepresentatives(representative_id)
);

create table OrderItems
(
	order_item_id int identity (1,1) primary key,
	order_id int,
	product_id int,
	quantity int NOt Null,
	Unit_price int Not Null,
		constraint fk_order
			foreign key (order_id)
			references Orders(order_id),
		constraint fk_product_order_item
			foreign key (product_id)
			references Products(product_id)
);


create table Payments
(
	payment_id int identity (1,1) primary key,
	order_id int,
	payment_amount decimal(12,2) Not Null,
	Payment_date datetime,
	payment_method varchar(30) Not Null,
	payment_status varchar(20) default 'Pending',
		constraint fk_order_Payment
			foreign key (order_id)
			references Orders(order_id)
);

alter table Products add brand varchar(100);
----------------------
--INSERT INTO TABLES--
----------------------
use TechStoreDB;
------------
--Custimor--
------------
insert into Customers(customer_name, Phone, email, city)
values
('Ahmed Ali', '01012345678', 'ahmed@gmail.com', 'Cairo'),
('Sara Mohamed', '01123456789', 'sara@gmail.com', 'Alexandria'),
('Omar Hassan', '01234567890', 'omar@gmail.com', 'Giza'),
('Mona Adel', null, 'mona@gmail.com', 'Mansoura'),
('Youssef Tarek', '01056789012', 'youssef@gmail.com', 'Tanta'),
('Nour Emad', '01167890123', 'nour@gmail.com', 'Zagazig'),
('Khaled Samy', '01278901234', 'khaled@gmail.com', 'Aswan'),
('Aya Mostafa', null, 'aya@gmail.com', 'Luxor'),
('Mahmoud Fathy', '01090123456', 'mahmoud@gmail.com', 'Damietta'),
('Salma Hany', '01101234567', 'salma@gmail.com', 'Port Said'),
('Karim Nabil', '01211223344', 'karim@gmail.com', 'Suez'),
('Laila Ashraf', '01522334455', 'laila@gmail.com', 'Ismailia');

--------------
--categories--
--------------
insert into Categories(category_name)
values
('Laptops'),
('Smartphones'),
('Accessories'),
('Gaming'),
('Networking');

-----------
--Product--
-----------
insert into Products(product_name, category_id, unit_price, stock_quantity, is_available, brand)
values
('Dell Inspiron 15', 1, 25000, 0, 1, 'Dell'),
('iPhone 14', 2, 42000, 7, 1, 'Apple'),
('Samsung Galaxy S24', 2, 36000, 12, 1, 'Samsung'),
('Logitech Wireless Mouse', 3, 750, 40, 1, 'Logitech'),
('HP Pavilion Gaming', 4, 31000, 5, 1, 'HP'),
('TP-Link Router AX1800', 5, 2200, 15, 1, 'TP-Link'),
('Lenovo IdeaPad 3', 1, 21000, 8, 1, 'Lenovo'),
('Redragon Gaming Keyboard', 4, 1400, 20, 1, 'Redragon'),
('Anker Power Bank', 3, 1200, 25, 1, 'Anker'),
('Asus ROG Laptop', 4, 47000, 4, 1, 'Asus'),
('Xiaomi Redmi Note 13', 2, 14500, 14, 1, 'Xiaomi'),
('Cisco Switch 24-Port', 5, 6800, 6, 1, 'Cisco');

------------------------
--SalesRepresentatives--
------------------------
insert into SalesRepresentatives (representative_name, region)
values
('Ahmed Hassan', 'Cairo'),
('Mariam Ali', 'Alexandria'),
('Omar Khaled', 'Delta');

----------------------
--MarketingCampaigns--
----------------------
EXEC sp_rename 'MrketingCampaigns', 'MarketingCampaigns';

insert into MarketingCampaigns
(campaign_name, campaign_channel, start_date, end_date, campaign_budget)
values
('Summer Tech Deals', 'Facebook Ads', '2026-07-01', '2026-07-31', 15000),
('Back to School Offer', 'Instagram', '2026-08-01', '2026-08-20', 10000),
('Gaming Week Campaign', 'Google Ads', '2026-09-05', '2026-09-15', 20000),
('New Arrivals Launch', 'TikTok Ads', '2026-10-01', '2026-10-25', 12000);

---------------------
--customerlnguiries--
---------------------
insert into CustomerInquiries
(customer_name, phone, city, inquiry_source, campaign_id, representative_id, converted_customer_id)
values
('Sara Ahmed', '01122334455', 'Alexandria', 'Instagram', 2, 2, NULL),
('Karim Adel', '01233445566', 'Giza', 'Google Ads', 3, 1, 2),
('Mona Samy', '01544556677', 'Mansoura', 'TikTok', 4, null, 8),
('Youssef Hany', '01055667788', 'Tanta', 'Facebook', 1, 2, NULL),
('Nour Khaled', '01166778899', 'Zagazig', 'Instagram', 2, 1, 1),
('Omar Fathy', '01277889900', 'Damietta', 'Google Ads', 3, 3, 10),
('Aya Emad', '01588990011', 'Port Said', 'TikTok', 4, 2, 7),
('Hassan Mahmoud', '01099887766', 'Suez', 'Facebook', 1, 1, 4),
('Salma Tarek', '01188776655', 'Luxor', 'Instagram', 2, 3, 9),
('Mahmoud Ashraf', '01277665544', 'Aswan', 'Google Ads', 3, 2, 11),
('Laila Nabil', '01566554433', 'Ismailia', 'TikTok', 4, 1, 12),
('Adel Hossam', '01055443322', 'Fayoum', 'Facebook', 1, 3, 5),
('Reem Wael', '01144332211', 'Minya', 'Instagram', 2, 2, 2),
('Tamer Essam', '01233221100', 'Benha', 'Google Ads', 3, 1, 8);

----------
--Orders--
----------
insert into Orders (customer_id, representative_id, order_status, delivery_city)
values
(1, 1, 'Delivered', 'Cairo'),
(2, 2, 'Pending', 'Alexandria'),
(3, 1, 'Shipped', 'Giza'),
(4, 3, 'Delivered', 'Mansoura'),
(5, 2, 'Cancelled', 'Tanta'),
(6, 1, 'Delivered', 'Zagazig'),
(7, 3, 'Processing', 'Damietta'),
(8, 2, 'Shipped', 'Port Said'),
(9, 1, 'Delivered', 'Suez'),
(10, 3, 'Pending', 'Luxor'),
(11, 2, 'Delivered', 'Aswan'),
(12, 1, 'Processing', 'Ismailia');

--------------
--OrderItems--
--------------
insert into OrderItems
(order_id, product_id, quantity, Unit_price)
values
(1, 1, 1, 25000),
(1, 4, 2, 750),
(2, 2, 1, 42000),
(2, 9, 1, 1200),
(3, 3, 1, 36000),
(3, 8, 1, 1400),
(4, 5, 1, 31000),
(4, 4, 1, 750),
(5, 10, 1, 47000),
(5, 3, 2, 36000),
(6, 6, 1, 2200),
(7, 7, 1, 21000),
(7, 9, 2, 1200),
(8, 11, 1, 14500),
(9, 12, 1, 6800),
(9, 4, 3, 750),
(10, 2, 1, 42000),
(11, 1, 1, 25000),
(12, 5, 1, 31000),
(12, 8, 2, 1400);

------------
--payments--
------------
insert into Payments
(order_id, payment_amount, Payment_date, payment_method, payment_status)
values
(1, 26500, '2026-07-01', 'Credit Card', 'Paid'),
(2, 43200, '2026-07-02', 'Cash', 'Paid'),
(2, 43200, '2026-07-02', 'Cash', 'Paid'),
(4, 31750, '2026-07-04', 'Bank Transfer', 'Paid'),
(5, 119000, '2026-07-05', 'Credit Card', 'Pending'),
(6, 2200, '2026-07-06', 'Cash', 'failed'),
(7, 23400, '2026-07-07', 'Instapay', 'Paid'),
(8, 14500, '2026-07-08', 'Vodafone Cash', 'Pending'),
(9, 9050, '2026-07-09', 'Bank Transfer', 'Cancelled'),
(10, 42000, '2026-07-10', 'Credit Card', 'Cancelled');

update Products
	set stock_quantity=14
		where product_name ='iPhone 14';

update Customers
	set city ='Damietta'
		where customer_name ='Youssef Tarek';

update Orders
	set order_status='Confirmed'
		where order_id=2;

update CustomerInquiries
	set representative_id =2
		where inquiry_id=3;

-- DELETE Statement--
insert into Products 
	values ('test_product',1,500,5,1,'test');
delete from Products 
	where product_name='test_product';

