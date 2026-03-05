WITH firstpass AS (
     SELECT ProductCategoryID AS CategoryID,
            ProductID,
            ProductName,
            Sum(quantity) AS ItemsSold,
            Sum(NetlineRevenue) AS ProductRevenue
       FROM LineItemBase
      GROUP BY ProductCategoryID,
               ProductID,
               ProductName
),
rankwithin AS (
     SELECT *,
            ProductRevenue * 1.0 / sum(productrevenue) OVER (PARTITION BY categoryid) AS ProductRevShare,
            row_number() OVER (PARTITION BY categoryid ORDER BY productrevenue DESC,
            productid) AS ProductRanking,
            count( * ) OVER (PARTITION BY categoryid) AS ProductsInCategory
       FROM firstpass
),
HHI_CategorySKU AS (
     SELECT CategoryID,
            sum(productrevenue) AS CategoryRevenue,
            sum(power(ProductRevShare, 2) ) AS HHI_CategorySKU,
            1 * 1.0 / sum(power(productrevshare, 2) ) AS EffectiveSKUCount,
            max(ProductsIncategory) AS ProductsInCategory
       FROM rankwithin
      GROUP BY categoryid
),
next AS (
     SELECT *,
            ProductsInCategory * 1.0 / EffectiveSKUCount AS SKUCountToEffectiveRatio,
            1 - (EffectiveSKUCount * 1.0 / ProductsInCategory) AS RevenueConcentrationIndex_Bounded,
            categoryrevenue / sum(categoryrevenue) OVER () AS CategoryRevenueShare
       FROM HHI_CategorySKU
)
SELECT CategoryID,
       ProductsInCategory,
       CategoryRevenue,
       round(CategoryRevenueShare, 3) AS CategoryRevenueShare,
       round(HHI_CategorySKU, 3) AS HHI_CategorySKU,
       round(effectiveskucount, 2) AS EffectiveSKUCount,
       round(SKUCOuntToEffectiveRatio, 2) AS SKUCountToEffectiveRatio,
       round(RevenueConcentrationIndex_Bounded, 3) AS RevenueConcentrationIndex_Bounded,
       round(sum(power(CategoryRevenueShare, 2) ) OVER (), 3) AS HHI_CompanyCategory
  FROM next
 ORDER BY categoryrevenue DESC;
