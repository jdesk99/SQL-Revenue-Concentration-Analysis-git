WITH firstpass AS (
    SELECT ProductCategoryID AS CategoryID,
           ProductID,
           ProductName,
           sum(Quantity) AS Quantity,
           sum(NetlineRevenue) AS ProductRevenue
      FROM LineItemBase
     GROUP BY productcategoryid,
              productid,
              productname
),
RankedProducts AS (
    SELECT CategoryID,
           ProductId,
           ProductName,
           quantity,
           productrevenue,
           row_number() OVER (PARTITION BY categoryid ORDER BY productrevenue DESC,
           productid) AS ProductRankinCategory,
           sum(productrevenue) over (partition by categoryid) as CategoryTotalRevenue
      FROM firstpass
)
SELECT CategoryID,
       ProductID,
       ProductName,
       Quantity AS UnitsSold,
       ProductRevenue,
       ProductRankinCategory,
       round(CategoryTotalRevenue,2) as CategoryTotalRevenue,
       round(ProductRevenue/categorytotalrevenue,2) as SkuRevShare
  FROM RankedProducts
/* WHERE productrankincategory <= 3*/
 ORDER BY categoryid,
          productrankincategory;
