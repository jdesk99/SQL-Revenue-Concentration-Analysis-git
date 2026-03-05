with OrderRevenueBase as (
    SELECT OrderID,
           CustomerID,
           OrderDate,
           CustomerName,
           CustomerCountry,
           sum(netlinerevenue) AS OrderTotal
      
    FROM lineitembase lib
      
    GROUP BY orderid,
             customerid,
             orderdate,
             customername,
             customercountry
         )

Select *
from OrderRevenueBase