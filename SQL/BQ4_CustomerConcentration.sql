WITH revshare AS (
    SELECT *,
           totalrevenue * 1.0 / sum(totalrevenue) OVER () AS RevenueShare,
           row_number() OVER (ORDER BY totalrevenue DESC,
           customerid) AS rownumber,
           count( * ) OVER () AS totalcustomers
      FROM CustomerRevenueBase
),
metrics AS (
    SELECT customerid,
           TotalRevenue,
           RevenueShare,
           rownumber * 1.0 / totalcustomers AS PctCustomerIncluded,
           sum(revenueshare) OVER (ORDER BY totalrevenue DESC,
           customerid) AS CumulativeRevenueShare
      FROM revshare
)
SELECT *
  FROM metrics
 WHERE pctcustomerincluded <= 0.2
 ORDER BY totalrevenue DESC,
          customerid;

