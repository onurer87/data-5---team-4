/*1-generate a report for the number of territories each employee responsible for
2- generate a report for employee's performance according to sales amount and order them
3- for low-sales regions what is the shipped category there?
*/

select e.EmployeeID ,t.TerritoryID,t.TerritoryDescription,Count(*) from Employees e 
join EmployeeTerritories et on e.EmployeeID =et.EmployeeID 
join Territories t  ON t.TerritoryID =et.TerritoryID
GROUP by e.EmployeeID 


select * from Employees e 