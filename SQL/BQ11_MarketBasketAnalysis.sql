WITH singleproduct AS (
    SELECT DISTINCT OrderID,
                    ProductID
      FROM lineitembase
),
orderproducts AS (
    SELECT a.orderid AS OrderID,
           a.productid AS ProductA,
           b.productid AS ProductB
      FROM singleproduct a
           JOIN singleproduct b ON a.orderid = b.orderid AND 
                                   a.productid < b.productid
),
totalorders AS (
    SELECT count(DISTINCT orderid) AS TotalOrders
      FROM singleproduct
),
paircounts AS (
    SELECT ProductA,
           ProductB,
           count( * ) AS PairCount,
           TotalOrders
      FROM orderproducts
           CROSS JOIN totalorders
     GROUP BY producta,
              productb
    HAVING paircount >= 5
),
OrdersWithProduct AS (
    SELECT ProductID,
           count( * ) AS OrdersWithProduct
      FROM singleproduct
     GROUP BY productid
),
support AS (
    SELECT pc.*,
           a.OrdersWithProduct AS OrdersWithA,
           b.OrdersWithProduct AS OrdersWithB,
           pc.paircount * 1.0 / totalorders AS P_AB,
           a.OrdersWithProduct * 1.0 / totalorders AS P_A,
           b.OrdersWithProduct * 1.0 / totalorders AS P_B
      FROM paircounts pc
           JOIN OrdersWithProduct a ON pc.producta = a.productid
           JOIN OrdersWithProduct b ON pc.productb = b.productid
),
confidence AS (
    SELECT *,
           p_ab * 1.0 / p_a AS ConfidenceAtoB,
           p_ab * 1.0 / p_b AS ConfidenceBtoA
      FROM support
),
lift AS (
    SELECT *,
           p_ab * 1.0 / (p_a * p_b) AS Lift
      FROM confidence
),
WideRevenue AS (
    SELECT op.*,
           lib.netlinerevenue AS ProductRevA,
           libb.netlinerevenue AS ProductRevB,
           sum(lib.netlinerevenue + libb.netlinerevenue) AS PairRevenue
      FROM orderproducts op
           JOIN lineitembase lib ON op.orderid = lib.orderid AND 
                                    op.producta = lib.productid
           JOIN lineitembase libb ON op.orderid = libb.orderid AND 
                                     op.productb = libb.productid
     GROUP BY producta,
              productb
),
totalrevenue AS (
    SELECT sum(netlinerevenue) AS TotalRevenue
      FROM lineitembase
),
pairrevenue AS (
    SELECT l.*,
           w.PairRevenue,
           w.pairrevenue / totalrevenue AS PairRevenueShare
      FROM lift l
           JOIN widerevenue w ON l.producta = w.producta AND 
                                 l.productb = w.productb
           CROSS JOIN totalrevenue
)
SELECT ProductA,
       ProductB,
       PairCount,
       PairRevenue,
       PairRevenueShare,
       P_AB,
       P_A,
       P_B,
       ConfidenceAtoB,
       ConfidenceBtoA,
       Lift,
       TotalOrders,
       OrdersWithA,
       OrdersWithB
  FROM pairrevenue
 ORDER BY paircount DESC,
          PairRevenueShare DESC,
          Lift DESC;
