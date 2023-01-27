--task for this week is : 
--1- Calculating the sales amount for the company 2016 2017-2018 using order and order details tables 
--2- Separate the sales amounts for 3 categories low-medium-high 
--  team leader will decide the threshold of each category according to the Normal distribution of the sales
--team leader: onur

SELECT strftime('%Y', o.OrderDate) as 'Year', 
       Round(Sum(od.UnitPrice*od.Quantity*(1-od.Discount)),0) as 'Sales Amount', 
       CASE when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 300000 then "low"
       		when Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) > 300000 AND Sum(od.UnitPrice*od.Quantity*(1-od.Discount)) < 500000 THEN "medium"
       		else "high"
       end category
FROM Orders o
JOIN "Order Details" od ON o.OrderID=od.OrderID
GROUP BY strftime('%Y', o.OrderDate)
ORDER BY strftime('%Y', o.OrderDate);
