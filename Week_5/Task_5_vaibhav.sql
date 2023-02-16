/*1- find the average shipping date for each category for low sales 
 region and compare it with the Required date of the order 
 (using shipped date - order date - required date)
2- find the effects of the discount on the low sales region by
 comparing it with high sales regions discount*/

/*1- find the average shipping date for each category for low sales 
 region and compare it with the Required date of the order 
 (using shipped date - order date - required date)*/

--low_sales!!
with sales_per_year as
(select *,o.ShipCountry ,STRFTIME('%Y',o.ShippedDate) as year ,
round(sum((1 - od.Discount) * od.UnitPrice * od.Quantity)) as Sales_Amount
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
join Products p on p.ProductID =od.ProductID 
join categories c on c.CategoryID  = p.CategoryID 
group by year,o.ShipCountry )
select CategoryName,round(AVG(Actual_delivery)) as real_del,round(AVG(Expected_delivery)) as exp_del
from
(select CategoryName,
JULIANDAY(ShippedDate)-JULIANDAY(OrderDate) as Actual_delivery, 
JULIANDAY(RequiredDate)-JULIANDAY(OrderDate) as Expected_delivery,
case 
	when Sales_Amount < 19500 then "Low sales"
	when Sales_Amount >19500 and Sales_Amount < 42900 then "Medium Sales" 
	else "High Sales"
end as sales_Quaters
from sales_per_year
where sales_Quaters="Low sales" and ShippedDate is not NULL)
group by CategoryName ;

--High_Sales!!
with sales_per_year as
(select *,o.ShipCountry ,STRFTIME('%Y',o.ShippedDate) as year ,
round(sum((1 - od.Discount) * od.UnitPrice * od.Quantity)) as Sales_Amount
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
join Products p on p.ProductID =od.ProductID 
join categories c on c.CategoryID  = p.CategoryID 
group by year,o.ShipCountry )
select CategoryName,round(AVG(Actual_delivery)) as real_del,round(AVG(Expected_delivery)) as exp_del
from
(select CategoryName,
JULIANDAY(ShippedDate)-JULIANDAY(OrderDate) as Actual_delivery, 
JULIANDAY(RequiredDate)-JULIANDAY(OrderDate) as Expected_delivery,
case 
	when Sales_Amount < 19500 then "Low sales"
	when Sales_Amount >19500 and Sales_Amount < 42900 then "Medium Sales" 
	else "High Sales"
end as sales_Quaters
from sales_per_year
where sales_Quaters="High Sales" and ShippedDate is not NULL)
group by CategoryName ;

/*2- find the effects of the discount on the low sales region by
 comparing it with high sales regions discount*/
with sales_per_year as
(select *,o.ShipCountry ,STRFTIME('%Y',o.ShippedDate) as year ,
round(sum((1 - od.Discount) * od.UnitPrice * od.Quantity)) as Sales_Amount
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
join Products p on p.ProductID =od.ProductID 
join categories c on c.CategoryID  = p.CategoryID 
group by year,o.ShipCountry )
select CategoryName, "(" || Group_concat(Discount) || ")" ,
case 
	when Sales_Amount < 19500 then "Low sales"
	when Sales_Amount >19500 and Sales_Amount < 42900 then "Medium Sales" 
	else "High Sales"
end as sales_Quaters, "(" || Group_concat( DISTINCT ShipCountry) || ")" 
from sales_per_year
group by CategoryName
having sales_Quaters="Low sales";

with sales_per_year as
(select *,o.ShipCountry ,STRFTIME('%Y',o.ShippedDate) as year ,
round(sum((1 - od.Discount) * od.UnitPrice * od.Quantity)) as Sales_Amount
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
join Products p on p.ProductID =od.ProductID 
join categories c on c.CategoryID  = p.CategoryID 
group by year,o.ShipCountry )
select CategoryName,Discount ,
case 
	when Sales_Amount < 19500 then "Low sales"
	when Sales_Amount >19500 and Sales_Amount < 42900 then "Medium Sales" 
	else "High Sales"
end as sales_Quaters, ShipCountry
from sales_per_year
where sales_Quaters="High Sales";




