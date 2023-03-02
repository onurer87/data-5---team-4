--SQLite
--Week_1

SELECT c.Country  as 'Country', 
	count(DISTINCT c1.CategoryName) as "# of Categories",
	GROUP_CONCAT(DISTINCT c1.CategoryName ) as 'Categories' 
From Categories c1
join Customers c on c.CustomerID =o.customerID
join orders o on o.OrderID =od.orderID
join "Order Details" od on od.ProductID =p.productID
join Products p on p.CategoryID = c1.CategoryID 
GROUP by c.Country;
--Week_2

--Getting annual sales amounts
SELECT strftime('%Y', o.OrderDate) as 'Year', 
       Printf('$%,d',Sum(od.UnitPrice*od.Quantity*(1-od.Discount))) as 'Sales Amount' 
FROM Orders o
JOIN "Order Details" od ON o.OrderID=od.OrderID
GROUP BY strftime('%Y', o.OrderDate)
ORDER BY strftime('%Y', o.OrderDate);

-- All years are calculated in one table. if needed WHERE comment @ line 24 can be uncommented
with country_category AS (SELECT strftime('%Y', o.OrderDate) as 'Year',Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount',c.Country as "Country", 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 6500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 6500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 14300 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY STRFTIME(strftime('%Y', o.OrderDate)), c.Country)
SELECT cc.'Year', Printf('$%,d',SUM(cc."Sales Amount")) as "Category Sum", cc."Category" ||" ("|| GROUP_Concat(DISTINCT cc."Country")||")" as "Country Category"
FROM country_category cc
--WHERE cc.'Year'='2016'
Group by cc.'Year',cc."Category";

--Week_3
select p.ProductName,printf('%,d',sum(od.Quantity)) as Quantity
from Orders o 
join "Order Details" od on o.OrderID = od.OrderID
join Products p on p.ProductID =od.ProductID 
group by p.ProductID
ORDER by sum(od.Quantity) DESC 
LIMIT 3;

--Week_4
with EmployeeSalesAmount as (SELECT e.EmployeeID as "EmployeeID", e.FirstName || " " || e.LastName as "Employee Name",
								round(Sum(od.UnitPrice*od.Quantity*(1-od.Discount))) as "Sales Amount"
							FROM Employees e
							JOIN Orders o on e.EmployeeID= o.EmployeeID
							JOIN "Order Details" od on o.OrderID=od.OrderID
							GROUP by "Employee Name"
							Order by "Sales Amount" DESC)
SELECT e.FirstName || " " || e.LastName as "Employee Name", 
		Count(DISTINCT et.TerritoryID) as "Total Territories", 
		Printf('$%,d', es."Sales Amount") as "Total Sales", 
		Printf('$%,d',es."Sales Amount"/Count(DISTINCT et.TerritoryID)) as "Sales per Territory",
		"("|| GROUP_Concat(TRIM(DISTINCT t.TerritoryDescription))||")" as "Territories"
FROM Employees e
JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
JOIN Territories t on et.TerritoryID = t.TerritoryID
JOIN EmployeeSalesAmount es on e.EmployeeID=es.EmployeeID 
GROUP by "Employee Name"
ORDER BY es."Sales Amount"/Count(DISTINCT et.TerritoryID) DESC;

--Week_5

--Average Shippment Periods of Low Sales Countries
with Countries AS (SELECT c.Country as "Country",--Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount', 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 19500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 19500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 42900 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY c.Country
							HAVING "Category"= "Low"-- or "Category"= "High"
							Order by "Sales Amount" DESC)
SELECT ca.CategoryName as "Product Categories", 
        round(avg(Julianday(o.RequiredDate)-Julianday(o.OrderDate)),1) as "Avg Deadline", 
        round(avg(Julianday(o.ShippedDate)-Julianday(o.OrderDate)),1) as "Avg Procurement Time",
        round(avg(julianday(o.RequiredDate)-Julianday(o.ShippedDate)),1) as "Avg Delivery Time Left"
FROM Categories as ca
JOIN Products as p on ca.CategoryID = p.CategoryID
JOIN "Order Details" as od on p.ProductID=od.ProductID
JOIN Orders as o on od.OrderID = o.OrderID
JOIN Customers as c on o.CustomerID = c.CustomerID
JOIN Countries as co on c.Country = co.Country
GROUP BY ca.CategoryName;

--Average Shippment Periods of High Sales Category Countries
with Countries AS (SELECT c.Country as "Country",--Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount', 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 19500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 19500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 42900 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY c.Country
							HAVING "Category"= "High" --or "Category" = "Low"
							Order by "Sales Amount" DESC)
SELECT ca.CategoryName as "Product Categories", --co.Category as "Sales Category",
        round(avg(Julianday(o.RequiredDate)-Julianday(o.OrderDate)),1) as "Avg Deadline", 
        round(avg(Julianday(o.ShippedDate)-Julianday(o.OrderDate)),1) as "Avg Procurement Time",
        round(avg(julianday(o.RequiredDate)-Julianday(o.ShippedDate)),1) as "Avg Delivery Time Left"
FROM Categories as ca
JOIN Products as p on ca.CategoryID = p.CategoryID
JOIN "Order Details" as od on p.ProductID=od.ProductID
JOIN Orders as o on od.OrderID = o.OrderID
JOIN Customers as c on o.CustomerID = c.CustomerID
JOIN Countries as co on c.Country = co.Country
GROUP BY ca.CategoryName;
--Order by "Product Categories", "Sales Category";

--List of Low AND High Sales Countries
SELECT c.Country as "Country",--Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount', 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 19500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 19500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 42900 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY c.Country
							HAVING "Category"= "Low" or "Category"= "High"
							Order by "Category" DESC;

--Average of Discount of Sales Categories
with Countries AS (SELECT c.Country as "Country", Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount', 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 19500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 19500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 42900 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY c.Country
							HAVING "Category"= "Low" or "Category"= "High"
							Order by "Sales Amount" DESC)
SELECT co.Category as "Sales Category", co.Country as "Country Name", 
        round(avg(od.Discount)*100,2)||'%' as "Average Discount", Printf('$%,d', co."Sales Amount") as "Sales Amount"
FROM "Order Details" as od
JOIN Orders as o on od.OrderID=o.OrderID
JOIN Customers as c on o.CustomerID=c.CustomerID
JOIN Countries as co on co.Country=c.Country
GROUP BY "Country Name"
ORder by  round(avg(od.Discount)*100,2) DESC;


--Getting the Number of Delayed Orders(RequiredDate-ShippedDate<0) per Country
with Countries AS (SELECT c.Country as "Country",--Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount', 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 19500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 19500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 42900 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY c.Country
							HAVING "Category"= "Low" or "Category"= "High"
							Order by "Sales Amount" DESC)
select co.Category as "Sales Category",co.Country as "Country",count(o.OrderID) as "# of Delayed Orders",
	--"("|| GROUP_Concat(DISTINCT o.OrderID)||")" as "Order ID", 
	round(avg(julianday(o.RequiredDate)-julianday(o.ShippedDate)),2) as "AVG Delay(days)"
From Orders as o
JOIN Customers as cu on o.CustomerID=cu.CustomerID
JOIN Countries as co on co.Country=cu.Country
WHERE (julianday(o.RequiredDate)-julianday(o.ShippedDate)) <0
GROUP by co.Country
Order by "Sales Category" DESC ,"Number of Orders" DESC;
