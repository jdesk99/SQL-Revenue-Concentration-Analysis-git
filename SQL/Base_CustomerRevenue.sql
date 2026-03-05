/*CREATE VIEW CustomerRevenueBase as*/

with base as (
        SELECT CustomerID,
                Min(orderdate) as FirstOrderDate,
                Max(orderdate) as LastOrderDate,
               CustomerName,
               CustomerCountry,
               sum(ordertotal) as TotalRevenue,
               avg(ordertotal) as AverageOrderValue,
               count(distinct Orderid) AS OrderCount
        FROM OrderRevenueBase
        GROUP BY customerid,customername,customercountry
        )
        
Select *,
    case when ordercount >= 2 then 'Repeat' 
    else 'One Time' 
    end as CustomerType
from base

