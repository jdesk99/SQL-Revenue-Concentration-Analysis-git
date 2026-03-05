SELECT CustomerCountry,
       count( * ) AS CustomerCount,
       sum(OrderCount) AS OrderCount,
       sum(Totalrevenue) AS CountryRevenue,
       sum(totalrevenue) * 1.0 / sum(sum(totalrevenue) ) OVER () AS RevenueShare,
       sum(totalrevenue) * 1.0 / nullif(sum(ordercount), 0) AS WeightedAOV
  FROM CustomerRevenueBase
 GROUP BY customercountry
 ORDER BY CountryRevenue DESC;
