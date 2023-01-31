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










