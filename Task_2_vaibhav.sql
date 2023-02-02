/* 
 1. The results in the table shows about the total sales of northwind company 
 over 3years(2016,2017,2018).
 2.Total Sales has been calculated by considering countries where the company delivered
 it's products over 3 years
 3.By setting up threshold value the sales has be grouped by countries it delivered in each year
 into HIGH SALES,MEDIUM SALES AND LOW SALES
 
 */

select "(" || GROUP_concat(DISTINCT ShipCountry) || ")" as countries,year,"(" || GROUP_concat( Total_sales) || ")" as Sales,sales_Quaters
from
(select ShipCountry,year,(UnitPrice-Discount_price) * sum(Quantity) as Total_sales,
case 
	when (UnitPrice-Discount_price) * sum(Quantity) < 6500 then "Low sales"
	when (UnitPrice-Discount_price) * sum(Quantity) >6500 and (UnitPrice-Discount_price) * sum(Quantity) < 14300 then "Medium Sales" 
	else "High Sales"
end as sales_Quaters
from
(select o.ShipCountry ,STRFTIME('%Y',o.ShippedDate) as year , od.Discount * od.UnitPrice as Discount_price,
od.UnitPrice,od.Quantity
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
where year is not null
ORDER by od.ProductID)
group by ShipCountry,year)
group by year,sales_Quaters
ORDER by year,sales_Quaters;

--Corrected Sales amount Query!!
/*
  Revised the corrections and made some changes.
  country wise sales in each year are taken int high,middle,low sales.
  Null dates are ignored as we are looking for 2016,2017,2018.
 */
with sales_per_year as
(select o.ShipCountry ,STRFTIME('%Y',o.ShippedDate) as year ,
round(sum((1 - od.Discount) * od.UnitPrice * od.Quantity)) as Sales_Amount
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
group by year,o.ShipCountry 
having year is not null)
select '(' || group_concat(DISTINCT ShipCountry) || ')' as countries,year,'(' || group_concat(Sales_Amount) || ')' as Sales,
case 
	when Sales_Amount < 6500 then "Low sales"
	when Sales_Amount >6500 and Sales_Amount < 14300 then "Medium Sales" 
	else "High Sales"
end as sales_Quaters
from sales_per_year
group by year,sales_Quaters;


/* 
 * Null valus has been ignored and the rest year wise results shown below :-
 */

select STRFTIME('%Y',o.ShippedDate) as year ,
round(sum((1 - od.Discount) * od.UnitPrice * od.Quantity)) as Sales_Amount
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
group by year
having year is not null;









