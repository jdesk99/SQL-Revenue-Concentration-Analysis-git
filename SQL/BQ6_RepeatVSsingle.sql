SELECT CustomerType,
       count( * ) AS CustomerCount,
       sum(totalrevenue) AS TotalRevenue,
       sum(ordercount) AS OrderCount,
       sum(totalrevenue) * 1.0 / nullif(sum(ordercount), 0) AS WeightedAOV,
       sum(ordercount) * 1.0 / count( * ) AS AvgOrderPerCustomer
  FROM CustomerRevenueBase
 GROUP BY CustomerType
 ORDER BY customertype DESC;
