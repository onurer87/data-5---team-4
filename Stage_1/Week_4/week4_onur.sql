-- SQLite
--Task 1
SELECT e.FirstName || " " || e.LastName as "Employee Name", 
		Count(DISTINCT et.TerritoryID) as "Total of Territories",
		"("|| GROUP_Concat(TRIM(DISTINCT t.TerritoryDescription))||")" as "Territories"
FROM Employees e
JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
JOIN Territories t on et.TerritoryID = t.TerritoryID
GROUP by "Employee Name"
ORDER BY "Total of Territories" DESC;

--Task2
SELECT e.FirstName || " " || e.LastName as "Employee Name",
       round(Sum(od.UnitPrice*od.Quantity*(1-od.Discount))) as "Sales Amount"
FROM Employees e
JOIN Orders o on e.EmployeeID= o.EmployeeID
JOIN "Order Details" od on o.OrderID=od.OrderID
GROUP by "Employee Name"
Order by "Sales Amount" DESC;


--Task3
--Thresholds are multiplied by 3 as previous thresholds where yearly sales numbers.
with Countries AS (SELECT c.Country as "Country",Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount', 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 19500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 19500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 42900 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY c.Country
							HAVING "Category"= "Low"
							Order by "Sales Amount" DESC)
SELECT co.Country, "("|| GROUP_Concat(DISTINCT ca.CategoryName)||")" as "Product Categories"
FROM Countries as co
JOIN Customers as c ON co.Country = c.Country
JOIN Orders as o ON c.CustomerID = o.CustomerID
JOIN "Order Details" as od on o.OrderID = od.OrderID
JOIN Products as p ON od.ProductID = p.ProductID
JOIN Categories as ca ON p.CategoryID = ca.CategoryID
GROUP by co.Country;

--Getting the "Low-Category" countries to validate above query
SELECT c.Country as "Country",Sum( od.UnitPrice*od.Quantity*(1-od.Discount)) as 'Sales Amount', 
					       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 19500 then "Low"
					       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) >= 19500 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 42900 THEN "Medium"
					       		else "High"
					       end  as "Category"
					       FROM Orders o
					       		JOIN "Order Details" od ON o.OrderID=od.OrderID
								JOIN Customers c On o.CustomerID =c.CustomerID
							Group BY c.Country
							HAVING "Category"= "Low"
							Order by "Sales Amount" DESC;

