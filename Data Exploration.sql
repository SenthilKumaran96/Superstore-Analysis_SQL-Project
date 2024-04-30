-----------------------Data Exploration--------------------

--1.List the top 10 orders with the highest sales from Eachorderbreakdown Table
Select top 10 * from EachOrderBreakdown
order by sales desc

--2.Show the number of orders for each productcategory in the Eachorderbreakdown Table

Select category, Count(*) [No of Orders] from EachOrderBreakdown
group by category

--3.FInd the profit for each sub-category in the Eachorderbreakdown Table
Select SubCategory, Sum(profit) [Total Profit] from EachOrderBreakdown
group by SubCategory
order by [Total Profit] desc

--4.Identify the customer with the highest total sales across all orders
Select * from EachOrderBreakdown
Select * from OrdersList

Select top 1 CustomerName, Sum(eob.sales) Totalsales from OrdersList ol
join EachOrderBreakdown eob
on ol.OrderID = eob.OrderID
group by CustomerName
order by Totalsales desc

--5. Find the month with highest average sales in the orderlist tables

Select top 1 datename(mm,orderdate) [Month Name],avg(sales) [Avg Sales]  from OrdersList ol
join EachOrderBreakdown eob
on ol.OrderID = eob.OrderID
group by datename(mm,orderdate)
order by [Avg Sales] desc


--6.Find out the average quantity ordered by customers whose first name starts with an alphabet 'S'
Select  Round(avg(Quantity),2) [Avg Quantity] from OrdersList ol
join EachOrderBreakdown eob
on ol.OrderID = eob.OrderID 
where left(CustomerName,1) = 'S'


--7.Find out how many new customers were acquired in the year 2014
Select Count(*) Newcustomer from (
Select CustomerName, min(orderdate) as firstorderdate from OrdersList
group by CustomerName
having year(min(orderdate)) = '2014') a

--8.Calcualte the percentage of Total Profit contributed by each subcategory to the overall profit

Select * from OrdersList

Select SubCategory ,sum(profit) as subcategoryprofit,
Sum(Profit)/(Select sum(Profit) from EachOrderBreakdown) * 100 as Percentagebreakdown
from EachOrderBreakdown
group by SubCategory
order by Percentagebreakdown desc


--9.Find the average sales per customer,consider only customers who have more than one order
Select ol.CustomerName, count(distinct ol.orderid) Totalcount,avg(eob.Sales) Avgsales from OrdersList ol
join EachOrderBreakdown eob
on ol.OrderID = eob.OrderID
group by ol.CustomerName
having count(distinct ol.orderid) > 10
order by Totalcount desc,Avgsales desc

----10.Identify the top-performing subcastegory in each category based on total sales.Include the subcategory, totoal sales
--and rnking of subcategory within each category

With cte as (
Select category,SubCategory,sum(Sales) TotalSales,DENSE_RANK() over(partition by category order by sum(Sales) desc) Rnk
from EachOrderBreakdown
group by category,SubCategory
) 
Select * from cte where Rnk = 1


