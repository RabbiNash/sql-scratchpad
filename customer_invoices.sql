

select Cu.CustomerID, Cu.CustomerName, COUNT(*) as TotalNbOfInvoicedProducts, sum(IL.Quantity * IL.ExtendedPrice) as TotalInvoiced
from Sales.Customers as Cu, Sales.Invoices as Iv, Sales.InvoiceLines as IL
where cu.CustomerID = iv.CustomerID and Iv.InvoiceID = IL.InvoiceID and YEAR(Iv.InvoiceDate) = 2016
group by Cu.CustomerID, Cu.CustomerName
--having count(*) > 50  --podt filtering query produces full result set
order by TotalInvoiced DESC