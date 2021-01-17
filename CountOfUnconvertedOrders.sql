/*
Q2: Identify all "offending" customers, i.e. potential "time waisters".
Customers passing an order but not confirming it: orders not invoiced

Extract a list of offending customers, with their number of unconverted orders
(no dates restrictions)
CustomerID, CustomerName, NbOfUnconvertedOrders

Back at 11.05 :)
NOT A COFFEE BREAK :)
*/

-- Copyright Babatunde :)
select 
 bbc.CustomerID, scu.CustomerName, bbc.NbOfUnconvertedOrders
from 
		Sales.Customers as scu
		,(
		-- The previous query we wrote gave us all the other information apart from CustomerName

			SELECT 
					od.CustomerID,
					count(*) NbOfUnconvertedOrders
			FROM
				Sales.Orders as Od 
			WHERE NOT EXISTS
			(
	
				SELECT *
				FROM Sales.Invoices as Iv
				WHERE Iv.OrderID = Od.OrderID
			)
				group by od.CustomerID
		) as bbc

where scu.CustomerID = bbc.CustomerID;


-- More condensed version, one less subquery (same results)
SELECT
	Cu.CustomerID
	, Cu.CustomerName
	, COUNT(*) AS NbOfUnconvertedOrders
FROM
	Sales.Customers as Cu
	, Sales.Orders as Od
WHERE
	Cu.CustomerID = Od.CustomerID
	AND NOT EXISTS
	(
		SELECT *
		FROM Sales.Invoices as Iv
		WHERE Iv.OrderId = Od.OrderID
	)
GROUP BY Cu.CustomerID, Cu.CustomerName
ORDER BY NbOfUnconvertedOrders DESC