-- SQLite
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
        round(avg(Julianday(o.RequiredDate)-Julianday(o.OrderDate)),1) as "Required Delivery Time", 
        round(avg(Julianday(o.ShippedDate)-Julianday(o.OrderDate)),1) as "Shippment Time",
        round(avg(julianday(o.RequiredDate)-Julianday(o.ShippedDate)),1) as "Deviation"
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
        round(avg(Julianday(o.RequiredDate)-Julianday(o.OrderDate)),1) as "Required Delivery Time", 
        round(avg(Julianday(o.ShippedDate)-Julianday(o.OrderDate)),1) as "Shippment Time",
        round(avg(julianday(o.RequiredDate)-Julianday(o.ShippedDate)),1) as "Deviation"
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
select co.Category as "Sales Category",co.Country as "Country",count(o.OrderID) as "# of Delayed Orders","("|| GROUP_Concat(DISTINCT o.OrderID)||")" as "Order ID", round(avg(julianday(o.RequiredDate)-julianday(o.ShippedDate)),2) as "AVG Delay(days)"
From Orders as o
JOIN Customers as cu on o.CustomerID=cu.CustomerID
JOIN Countries as co on co.Country=cu.Country
WHERE (julianday(o.RequiredDate)-julianday(o.ShippedDate)) <0
GROUP by co.Country
Order by "Sales Category" DESC ,"Number of Orders" DESC;

