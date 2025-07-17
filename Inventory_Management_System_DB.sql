#  **** INVENTORY MANAGEMENT SYSTEM *****

# DATABASE FOR INVENTORY MANAGEMENT SYSTEM

Create Database Inventory_DB;
Use Inventory_DB;

# TABLES

#Product Table
Create Table Products( Prod_ID int auto_increment Primary key,
Prod_Name varchar(100) not null,
Price decimal(10,2) not null,
Prod_Category varchar(100) not null);

#Supplier Table
Create Table Suppliers(Supplier_ID int auto_increment Primary key,
Supplier_Name varchar(255) not null,
Email_ID varchar(255),
Phone_Number varchar(50),
Category varchar(50)
);

#Inventory Table
Create Table Inventory( Inventory_ID int auto_increment primary key,
Prod_ID int,
Quantity int,
Supplier_ID int,
foreign key (prod_ID) references Products(Prod_ID),
foreign key (Supplier_ID) references Suppliers(Supplier_ID)
);

# Transactions Table
Create Table Transactions( Transaction_ID int auto_increment primary key,
Prod_ID int,
Transaction_Type enum("Sale", "Purchase"),
Transaction_Date date default (current_date) ,
Quantity int not null,
Foreign Key (Prod_ID) references Products(Prod_ID)
);

# MODIFICATION IN TABLE STRUCTURE

Alter table Inventory
Add Restock_level int not null;

Alter table Products
modify Prod_ID int auto_increment primary key;

describe inventory;
describe Transactions;
# INSERTING DATA

Insert into Products( Prod_Name, Price, Prod_Category) values 
("Laptop", 50000 , "Electronic"),
("Mobile", 25000, "Electronic"),
("Chair", 5000, "Furniture");

Insert into Suppliers ( Supplier_Name, Email_ID, Phone_Number) values
('Tech Supplies Co.', 'contact@techsupplies.com', '1234567890'),
('Office Furniture Inc.', 'support@officefurniture.com', '0987654321');

Insert into Inventory (Prod_ID, Quantity, Supplier_ID, Restock_level) values
(1,30,1,5),
(2,50,1,10),
(3,78,2,10);

Insert into Transactions (Prod_ID, Transaction_Type, Quantity) values
(1, 'Purchase', 10), -- Purchased 10 laptops
(3, 'Purchase', 20), -- Purchased 20  chairs
(2, 'Purchase', 100); -- Purchased 100 mobile

-- Sales transaction: selling 5 laptops
Insert into Transactions (Prod_ID, Transaction_Type, Quantity) values
(1, 'Sale', 5);

# QUERYING

Select * from Products;
select * from suppliers;
select * from inventory;
select * from transactions;

# To check Product Stock Level
select p.Prod_Name, p.Prod_Category, p.Price, i.Quantity from Products as p
inner join Inventory as i on 
p.Prod_ID= i.Prod_ID
order by p.Prod_Name;

#To monitor stock level of Products , altering when product running low
select  p.Prod_Name, i.Quantity, p.Prod_Category,
Case
	when i.Quantity > i.Restock_level then "Excess"
	when i.Quantity >= i.Restock_level then "Reorder"
	else "Alert: Low Stock"
end as "Reorder_Status"
from products as p
join Inventory as i
on p.Prod_ID= i.Prod_ID;

# To check products running low
select p.Prod_Name, i.Quantity, p.Prod_Category, i.Restock_level from Products p
inner join Inventory i
on p.Prod_ID= i.Prod_ID
where i.Quantity < i.Restock_Level
order by i.Quantity;

# To find the supplier info for products that are running low to place an order
create view Restock as 
select p.Prod_Name, i.Quantity, p.Prod_Category, i.Restock_level from Products p
inner join Inventory i
on p.Prod_ID= i.Prod_ID
where i.Quantity < i.Restock_Level
order by i.Quantity;

select r.*, s.* from Restock r
inner join Suppliers s
on r.Prod_Category= s.Category
order by i.Quantity;

# No. of supplier for each Product Category
select Category, count(*) as 'No. of Supplier' from Suppliers
group by Category;

# To find no. of Items running low
select count(*) from Restock;

# To update the product info in product Table
update Products
set Price = 250 
where Prod_Name= "Pen";

# To Delete the product
delete from products
where Prod_Name="Milk";

# Create store procedure for updating product details

DELIMITER  $$
create procedure update_product( 
	IN p_id int,
	IN prod_name varchar(50),
	IN prod_price decimal(10,2),
	IN prod_category varchar(50))
begin 
 update products
 set 
	Prod_Name = prod_name,
	Price = prod_price,
	Prod_Category =prod_category
where Prod_ID =p_id;
end $$

DELIMITER ;

select * from Products;

Call update_product(1, "Stapler", 100, "Stationery");


