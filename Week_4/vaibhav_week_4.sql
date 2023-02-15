
--1-generate a report for the number of territories each employee responsible for!!
select e.EmployeeID,"(" || GROUP_concat(Trim(DISTINCT t.TerritoryDescription)) || ")" as Territories,Count(*) as Num_of_territories from Employees e 
join EmployeeTerritories et on e.EmployeeID =et.EmployeeID 
join Territories t  ON t.TerritoryID =et.TerritoryID
GROUP by e.EmployeeID

--2- generate a report for employee's performance according to sales amount and order them!!

select o.EmployeeID,
round(sum((1 - od.Discount) * od.UnitPrice * od.Quantity)) as Sales_Amount
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
group by o.EmployeeID
ORDER by Sales_Amount DESC ;


--3_for low-sales regions what is the shipped category there?!!
with sales_per_year as
(select *,o.ShipCountry ,STRFTIME('%Y',o.ShippedDate) as year ,
round(sum((1 - od.Discount) * od.UnitPrice * od.Quantity)) as Sales_Amount
from Orders o  
join "Order Details" od on o.OrderID =od.OrderID
join Products p on p.ProductID =od.ProductID 
join categories c on c.CategoryID  = p.CategoryID 
group by year,o.ShipCountry )
select ShipCountry ,'(' || group_concat(CategoryName) || ')' as Category_List ,'(' || group_concat(Sales_Amount) || ')' as Sales,
case 
	when Sales_Amount < 19500 then "Low sales"
	when Sales_Amount >19500 and Sales_Amount < 42900 then "Medium Sales" 
	else "High Sales"
end as sales_Quaters
from sales_per_year
group by ShipCountry 
having sales_Quaters="Low sales";



