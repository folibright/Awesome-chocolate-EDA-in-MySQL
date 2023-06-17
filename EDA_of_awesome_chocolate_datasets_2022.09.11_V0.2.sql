-- Name: BRIGHT TEIKO FOLI
-- Email: folib1@gmail.com
-- Topic: Exploratory Data Analysis (EDA) of datasets in the "awesome chocolates" database. 



show databases;
show tables;
desc sales;
select * from sales;                      -- All Columns
select count(*) from sales;				  -- Count all rows


-- CALCULATIONS------------------------
select 
SaleDate, Amount, Boxes, Amount / Boxes 'Amount per box' 
from 
Sales;


-- CONDITIONS---
select * from sales
where Amount  > 10000;

select * from 
sales
where Amount  > 10000
order by Amount desc;

select * from 
sales
where GeoID = 'g1'
order by PID, Amount desc;

select * from sales						-- Sales amounts greater than 10,000 in the year 2022
where Amount > 10000 and SaleDate >= '2022-01-01 00:00:00';

select SaleDate, Amount 					-- Sales amounts greater than 10,000 in the year 2022 (descending order)
from 
sales		
where Amount > 10000 and year(SaleDate) = 2022
order by Amount desc;

select * from sales  								-- Sales where num of boxes is between 0 and 50
where Boxes between 0 and 50;

select *, weekday(SaleDate) as 'Day of week' from sales				   -- Display Friday Shipments 
where weekday(SaleDate) = 4
order by Amount desc;				

select 															--  Maximun Sale on Fridays
SaleDate, Boxes, Customers, max(Amount), weekday(SaleDate) 
from 
sales		
where weekday(SaleDate) = 4;				

select count(*) as 'Number of Friday shipments' 				--  Count of Shipments on Fridays
from 
sales								
where weekday(SaleDate) = 4;				


## Using the "people" table

select * from people;

select * from people									-- All eople in 'Delish' or 'Jucies' Teams
where team = 'Delish' or Team = 'Jucies';

select * from people									-- All eople in 'Delish' or 'Jucies' Teams
where team in ('Delish' , 'Jucies');

select count(*) from people								-- Num of people in 'Delish' or 'Jucies' Teams
where team = 'Delish' or Team = 'Jucies';
# or
select count(*) from people								-- Num of people in 'Delish' or 'Jucies' Teams
where team in ('Delish' , 'Jucies');

select * from people									-- All salespersons starting with 'B'
where Salesperson like 'B%';

--  --------------------------
-- Case operator for branching 
select  SaleDate, Amount,								-- Categorize Amount into 4: Under 1K, Under 5K, Under 10K, 10K or Above
		case when Amount < 1000 then 'Under 1K'
			 when Amount < 5000 then 'Under 5K'
			 when Amount < 10000 then 'Under 10K'
			 else '10K or Above'
		end as 'Amoumt category'
from sales;

-- --------------------------------------------
-- JOIN QUERIES--------------------------------
desc people;
-- -----------------------------
select * from sales 										-- Join Salespersons from 'People' table and their related Sales.
join people on sales.SPID = people.SPID;

desc products;
-- ----------------------------
select SaleDate, Amount, Product from sales					-- Join 'Product name' in the Sales shipmenet from 'products' table
left join products
on sales.PID = products.PID;

-- Joining 2 Tables
select SaleDate, Amount, Salesperson, Team, Product from sales
join people on sales.SPID = people.SPID
join products on sales.PID = products.PID; 

-- Conditions with Joins 
select SaleDate, Amount, Salesperson, Team, Product from sales
join people on sales.SPID = people.SPID
join products on sales.PID = products.PID
where sales.Amount <20 and people.Team ='Delish'; 

-- Show records where 'Team' is Blank
select SaleDate, Amount, Salesperson, Team, Product from sales
join people on sales.SPID = people.SPID
join products on sales.PID = products.PID
where sales.Amount <100 and people.Team =''; 

desc geo;
select * from geo;

select SaleDate,Amount, Salesperson, Team, Product, Geo from sales		-- Goegraphy is New Zealand or India.
join people on sales.SPID = people.SPID
join products on sales.PID = products.PID
join geo on sales.GeoID = geo.GeoID
where Geo in ('New Zealand' , 'India');


-- GROUP BY---------------------------------
select GeoID, sum(Amount), avg(boxes) from sales			-- Group sales data by 'GeoID'
group by GeoID
order by GeoID;																	

select Geo, sum(Amount), avg(boxes) from sales				-- Group sales data by 'geographical location' from geo Table
join geo on sales.GeoID = geo.GeoID
group by geo.Geo;																


desc people;

select products.Category, people.Team,  sum(sales.Amount) from sales			-- Total amount from a 'Team' from People table and 'Category' from Product table
join people on sales.SPID = people.SPID
join products on sales.PID = products.PID 
group by Category, Team
order by Category, Team;												

select products.Category, people.Team,  sum(sales.Amount) from sales			-- Total amount from a 'Team' from People table and 'Category' from Product table (Exclude empty Teams)
join people on sales.SPID = people.SPID
join products on sales.PID = products.PID 
where Team <> ''
group by Category, Team
order by Category, Team;												

-- HAVING FUNCTION: in place of where for conditions on Aggregate Functions
select GeoID,sum(Amount) from sales
group by GeoID
having sum(amount) > 10000;



--  Top 10 products by Total Amount-----------------------------
select sales.PID, Product Product_name, sum(Amount)  from sales
join products on sales.PID = products.PID 
group by Product 
order by sum(Amount) desc
limit 10;

