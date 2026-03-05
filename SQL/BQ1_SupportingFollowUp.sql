WITH base AS (
    SELECT CustomerID,
           OrderID,
           strftime('%Y-%m', OrderDate) AS YearMonth
      FROM OrderRevenueBase
),
first_month AS (
    SELECT CustomerID,
           MIN(YearMonth) AS FirstYearMonth
      FROM base
     GROUP BY CustomerID
),
cust_month AS (
    SELECT CustomerID,
           YearMonth,
           COUNT(DISTINCT OrderID) AS OrdersInMonth
      FROM base
     GROUP BY CustomerID,
              YearMonth
),
tagged AS (
    SELECT cm.CustomerID,
           cm.YearMonth,
           cm.OrdersInMonth,
           CASE WHEN cm.YearMonth = fm.FirstYearMonth THEN 1 ELSE 0 END AS IsNewCustomer
      FROM cust_month cm
           JOIN first_month fm ON cm.CustomerID = fm.CustomerID
)
SELECT YearMonth,
       COUNT( * ) AS ActiveCustomers,
       SUM(IsNewCustomer) AS NewCustomers,
       COUNT( * ) - SUM(IsNewCustomer) AS ExistingActiveCustomers,
       SUM(OrdersInMonth) AS TotalOrders,
       ROUND(1.0 * SUM(OrdersInMonth) / NULLIF(COUNT( * ), 0), 3) AS OrdersPerActiveCustomer,
       ROUND(1.0 * SUM(CASE 
                           WHEN IsNewCustomer = 0 
                           THEN OrdersInMonth END) / NULLIF(SUM(CASE 
                                                                   WHEN IsNewCustomer = 0 
                                                                   THEN 1 END), 0), 3) AS OrdersPerExistingActiveCustomer
  FROM tagged
 GROUP BY YearMonth
 ORDER BY YearMonth;
