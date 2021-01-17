SELECT 
Cu.CustomerID
,Cu.CustomerName
, ( Select Count(*)
	From Sales.Orders as Od
	Where Od.CustomerID = Cu.CustomerID
	) as TotalNumberOrders
,
(
	Select count(*)
	From Sales.Orders as Od,
	Sales.Invoices as Iv
	Where Od.CustomerID = Cu.CustomerID
	AND Od.OrderID = Iv.OrderId
) as NumberOfInvoicedOrders
,
(
	Select Count(*)
	From Sales.Orders as Od
	Where
	Od.CustomerID = cu.CustomerID
	and Not Exists 
	(
		SELECT *
		FROM Sales.Invoices as Iv
		WHERE 
			Iv.OrderID = Od.OrderID
	) 
) as NumberOfUnconvertedOrders
FROM 
Sales.Customers as CU

Select *, ( TotalNumberOrders - NumberOfInvoicedOrders) as NumberOfUncovertedOrders
From
(
	SELECT
	Cu.CustomerID
	,Cu.CustomerName
	, ( Select Count(*)
		From Sales.Orders as Od
		Where Od.CustomerID = Cu.CustomerID
		) as TotalNumberOrders
	,
	(
		Select count(*)
		From Sales.Orders as Od,
		Sales.Invoices as Iv
		Where Od.CustomerID = Cu.CustomerID
		AND Od.OrderID = Iv.OrderId
	) as NumberOfInvoicedOrders
	FROM 
	Sales.Customers as CU
) as t