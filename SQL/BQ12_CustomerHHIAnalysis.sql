WITH repeatcustomers AS (
    SELECT CustomerID,
           CustomerName,
           TotalRevenue AS CustomersRevenue,
           (
               SELECT sum(totalrevenue) 
                 FROM customerrevenuebase
                WHERE customertype = 'Repeat'
           )
           AS CompanyRevenue
      FROM CustomerRevenueBase
     WHERE customertype = 'Repeat'
),
revenueshare AS (
    SELECT *,
           (customersrevenue * 1.0 / companyrevenue) AS CustomerRevenueShare,
           power( (customersrevenue * 1.0 / companyrevenue), 2) AS PowerRevShare
      FROM repeatcustomers
),
hhi AS (
    SELECT *,
           sum(PowerRevShare) OVER () AS HHI,
           1.0 / sum(PowerRevShare) OVER () AS EffectiveCustomers,
           (
               SELECT count(DISTINCT customerid) AS CustomerCount
                 FROM customerrevenuebase
                WHERE customertype = 'Repeat'
           )
           AS CustomerCount
      FROM revenueshare
),
ratios AS (
    SELECT *,
           CustomerCount * 1.0 / EffectiveCustomers AS ConcentrationRatio,
           (1 - (EffectiveCustomers*1.0 / customercount) ) AS BoundedRCI
      FROM hhi
)
SELECT CustomerID,
       CustomerName,
       round(CustomersRevenue,2) as CustomersRevenue,
       round(CustomerRevenueShare,4) as CustomerRevenueShare,
       round(HHI, 4) AS HHI,
       CustomerCount,
       round(EffectiveCustomers,4) as EffectiveCustomers,       
       round(ConcentrationRatio,4) as ConcentrationRatio,
       round(BoundedRCI,4) as BoundedRCI
  FROM ratios
 ORDER BY customerrevenueshare DESC;
