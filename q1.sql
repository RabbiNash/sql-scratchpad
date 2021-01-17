USE WideWorldImporters;

/* Q1: Extract a list of CustomerId, CustomerName & Customer to Invoice Name (not ID) */


SELECT Cu2.CustomerID
		, Cu2.CustomerName
		, Cu1.CustomerName AS CustomerToInvoiceName
		, Cu1.CustomerID AS CustomerToInvoiceID 
		, Cu1.PostalAddressLine1
		, Cu1.PostalAddressLine2 
		, Cu1.PostalPostalCode
		, Cu1.PostalCityID
		, Ci.CityName 
FROM [Sales].Customers AS Cu1 -- One Ram load as Cui1
	, [Sales].[Customers] as Cu2 --another RAM load as "Cu2"
	, [Application].[Cities] as Ci
WHERE
	-- NATURAL JOIN BETWEEN (e.g) Cu1 is PK table and Cu2 is FK
	Cu1.CustomerID = cu2.BillToCustomerID
	AND ci.CityID = Cu1.PostalCityID
	--cui1 and cu2 are c pointers, giving access to each dataset in RAM