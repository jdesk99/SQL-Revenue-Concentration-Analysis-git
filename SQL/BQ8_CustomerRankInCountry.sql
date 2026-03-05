WITH RankedCustomers AS (
    SELECT CustomerCountry,
           row_number() OVER (PARTITION BY CustomerCountry ORDER BY TotalRevenue DESC,
           CustomerID) AS RankWithinCountry,
           CustomerID,
           TotalRevenue,
           OrderCount,
           AverageOrderValue AS AOV
      FROM CustomerRevenueBase
)
SELECT *
  FROM RankedCustomers
 WHERE RankWithinCountry <= 3;
