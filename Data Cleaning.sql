--create database superstoreproject

use superstoreproject
Select top 10 * from[dbo].[EachOrderBreakdown] 
Select top 10 * from [dbo].[OrdersList]

Select ol.OrderID,eob.subcategory, count(*) from OrdersList ol
inner join EachOrderBreakdown eob
on ol.OrderID = eob.OrderID
where ol.OrderID = 'AZ-2011-1087704'
group by ol.OrderID,eob.subcategory

-----------------------DATA CLEANING---------------------

--1. Establish the relationship between two tables as per ER Diagram

Alter table [dbo].[OrdersList]
add constraint Pk_orderid primary key (orderid)

Alter table [dbo].[OrdersList]
alter column orderid nvarchar(255) not null

Alter table [dbo].[EachOrderBreakdown] 
alter column orderid nvarchar(255) not null

Alter table [dbo].[EachOrderBreakdown] 
add constraint FK_orderid foreign key (orderid) references [OrdersList](orderid)

---2. Split City,State and country into three individual columns

alter table [OrdersList]
add City nvarchar(255),
    State nvarchar(255),
	Country nvarchar(255)

Select * from [OrdersList] where [City State Country] is not null
Select PARSename([City State Country], 1), * from [OrdersList]
Select parsename(replace([City State Country],',','.'),1),parsename(replace([City State Country],',','.'),2),
parsename(replace([City State Country],',','.'),3) from [OrdersList]

update [OrdersList]
set Country = parsename(replace([City State Country],',','.'),1),
    State = parsename(replace([City State Country],',','.'),2),
	City = parsename(replace([City State Country],',','.'),3)


Select * from [OrdersList] where city is null --St. Gallen,St. Gallen,Switzerland

Select replace('St. Gallen,St. Gallen,Switzerland',',','.')
Select parsename(replace(reverse('St. Gallen,St. Gallen,Switzerland'),',','.'),1)

Select reverse ('St. Gallen,St. Gallen,Switzerland')


----3.Add a new category column using the following mapping as per the first 3 characters in
--TEC - Technology
--ofs - Office Supplies
--FUR -Furniture

Select * from EachOrderBreakdown where category = 'Technology'

alter table EachOrderBreakdown
Add category nvarchar(255)

update EachOrderBreakdown
set category = case when left(Productname,3) = 'OFS' then 'Office Supplies'
                    when left(Productname,3) = 'FUR' then 'Furniture' else 'Technology' end

--4.Delete the first four Characters from Product name column

Select Substring(Productname,charindex('-',Productname)+1,len(Productname)),* from EachOrderBreakdown 
where category = 'Technology'

update EachOrderBreakdown 
set Productname = Substring(Productname,charindex('-',Productname)+1,len(Productname))

Select * from EachOrderBreakdown where OrderID = 'AZ-2011-6674300'


--5. Remove duplicate rows from EachOrderBreakdown table, if all column values are matching AZ-2011-6674300

Select orderid,ProductName,Discount,Sales,Profit,Quantity,SubCategory,category, Count(*) [TOT] from EachOrderBreakdown
group by orderid,ProductName,Discount,Sales,Profit,Quantity,SubCategory,category
having count(*) > 1

with cte as (
Select * ,row_number() over (partition by orderid,ProductName,Discount,Sales,Profit,Quantity,SubCategory,category order by orderid) rn
from EachOrderBreakdown
)
delete from cte where rn > 1


--6. Replace blank with NA in orderpriority column in orderlist table
Select * from orderslist
Select * from orderslist where OrderPriority is null -- 3283
Select * from orderslist where OrderPriority is not null -- 834
Select Count (*),3283+834 from orderslist

update orderslist set OrderPriority = case when OrderPriority is null then 'N/A' end

Select * from orderslist where ShipMode in ('Priority','Immediate')

update orderslist set OrderPriority = 'Critical' where ShipMode in ('Priority','Immediate')
update orderslist set OrderPriority = 'N/A' where OrderPriority is null




