-- task for this week : 
-- What countries does the company sell its products to and what are the categories sold to each country? 


SELECT c.Country  as 'Country', GROUP_CONCAT(DISTINCT c1.CategoryName) as 'Categories'
From Categories c1
join Customers c on c.CustomerID =o.customerID
join orders o on o.OrderID =od.orderID
join "Order Details" od on od.ProductID =p.productID
join Products p on p.CategoryID = c1.CategoryID 
GROUP by c.Country;



SELECT *
FROM Categories

SELECT *
FROM Products


SELECT *
FROM Orders

SELECT *
FROM Customers


SELECT *
FROM [Order Details]




SELECT Customers.Country, Products.CategoryID, Categories.CategoryName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID 
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.Country
