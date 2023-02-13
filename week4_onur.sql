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
       round(Sum(od.UnitPrice*od.Quantity*(1-od.Discount)),0) as "Sales Amount"
FROM Employees e
JOIN Orders o on e.EmployeeID= o.EmployeeID
JOIN "Order Details" od on o.OrderID=od.OrderID
GROUP by "Employee Name"
Order by "Sales Amount" DESC


--Task3

--SELECT 