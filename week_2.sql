--task for this week is : 
--1- Calculating the sales amount for the company 2016 2017-2018 using order and order details tables 
--2- Separate the sales amounts for 3 categories low-medium-high 
--  team leader will decide the threshold of each category according to the Normal distribution of the sales
--team leader: onur

--thresholds are set as constant. Mean value of all 3 years is calculated as 10,586.00
-- -35% +35% is set to be "Medium", below 35% is set to be low, and higher 35% is set to be high.
-- <6500 is "Low", >14300 is "High"

-- All years are calculated in one table. if needed WHERE comment @ line 24 can be uncommented

--Getting annual sales amounts
SELECT strftime('%Y', o.OrderDate) as 'Year', 
       Round(Sum(od.UnitPrice*od.Quantity*(1-od.Discount)),0) as 'Sales Amount' 
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
SELECT cc.'Year', round(SUM(cc."Sales Amount"),0) as "Category Sum", cc."Category" ||" ("|| GROUP_Concat(DISTINCT cc."Country")||")" as "Country Category"
FROM country_category cc
--WHERE cc.'Year'='2016'
Group by cc.'Year',cc."Category";