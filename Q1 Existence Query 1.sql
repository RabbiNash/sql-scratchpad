
/* 

can we identify all orders converted into an invoice

*/

SELECT O.*
FROM
	Sales.Orders as O,
	Sales.Invoices as I
WHERE O.OrderID = I.OrderID

--existence query

SELECT *
FROM
	Sales.Orders as O

WHERE NOT EXISTS
(
	SELECT *
	FROM Sales.Invoices as Iv
	WHERE Iv.OrderId = O.OrderID

)