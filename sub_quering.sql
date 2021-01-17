/*
	Q2: Output a table, one row, two columns, with the following:
	the total number of customers
	the total number of products in the catalog
	sub querying
*/

SELECT
   (
	SELECT COUNT(*) as CustomerCount
	From Sales.Customers
	) AS CustomerCount
	,
	(
	SELECT COUNT(*)
	From Warehouse.StockItems) AS ProductCount
