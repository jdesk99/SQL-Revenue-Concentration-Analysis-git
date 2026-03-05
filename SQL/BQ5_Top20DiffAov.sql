WITH revshare AS (
    SELECT *,
           totalrevenue*1.0 / sum(totalrevenue) OVER () AS RevenueShare,
           row_number() OVER (ORDER BY totalrevenue DESC,
           customerid) AS rn,
           count( * ) OVER () AS TotalCustomers
      FROM customerrevenuebase

),
pareto AS (
    SELECT CustomerID,
           TotalRevenue,
           AverageOrderValue,
           OrderCount,
           RevenueShare,
           rn * 1.0 / totalcustomers AS PctCustomerIncluded
      FROM revshare
),Customersplit as (
SELECT *,
       CASE WHEN pctcustomerincluded <= 0.2 THEN 'Top20Pct' ELSE 'Bottom80Pct' END AS Top20Percent
  FROM pareto
)

Select 
    Top20Percent,
    count(*) as CustomersInGroup,
    sum(totalrevenue) as TotalRevenue,
    avg(totalrevenue) as AvgRevenuePerCustomer,
    sum(ordercount) as TotalOrders,
    sum(totalrevenue)*1.0/sum(sum(totalrevenue)) over () as RevenueShareofGroup,
    avg(averageordervalue) as AvgAOV_Simple,
    sum(Totalrevenue)*1.0 /nullif(sum(ordercount),0) as AOV_Weighted
    
from customersplit
group by top20percent
order by top20percent desc
