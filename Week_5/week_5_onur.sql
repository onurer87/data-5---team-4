-- SQLite
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

with Countries AS (SELECT c.Country as "Country",--Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount', 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 19500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 19500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 42900 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY c.Country
							HAVING "Category"= "High"
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
SELECT co.Category as "Sales Category", 
        PRINTF('%.2f%%',avg(od.Discount)*100) as "Average Discount"
FROM "Order Details" as od
JOIN Orders as o on od.OrderID=o.OrderID
JOIN Customers as c on o.CustomerID=c.CustomerID
JOIN Countries as co on co.Country=c.Country
GROUP BY "Sales Category";


