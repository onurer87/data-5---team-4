/*
 * find out top three selling products according to number of selling
 * Initially we are solving this query by taking joining orders,order Deatails,products
 * Number of sellings are sum of Quantity of each product ordered from the company
 * Results are ordered in descending to show top 3 products */
select p.ProductName,sum(od.Quantity) as Quantity
from Orders o 
join "Order Details" od on o.OrderID = od.OrderID
join Products p on p.ProductID =od.ProductID 
group by p.ProductID
ORDER by Quantity DESC 
LIMIT 3;


