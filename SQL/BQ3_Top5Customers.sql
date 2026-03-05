WITH revshare AS (
    SELECT *,
           totalrevenue * 1.0 / sum(totalrevenue) OVER () AS RevenueShare,
           row_number() OVER (ORDER BY totalrevenue DESC, customerid) AS rownumber,
           count( * ) OVER () AS totalcustomers
      FROM CustomerRevenueBase
),
metrics AS (
    SELECT RowNumber as Rank,
           Customerid,
           TotalRevenue,
           RevenueShare,
           sum(revenueshare) OVER (ORDER BY totalrevenue DESC,customerid) AS CumulativeRevenueShare

      FROM revshare
)
SELECT *
  FROM metrics
 WHERE Rank <= 5
 ORDER BY rank
