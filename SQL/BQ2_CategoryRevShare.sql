WITH categorycore AS (
    SELECT ProductCategoryId,
           count( * ) AS LineItemCount,
           count(distinct orderid) as OrderCount,
           count(DISTINCT productid) AS ProductCount,
           sum(netlinerevenue) AS CategoryRevenue
      FROM lineitembase
     GROUP BY productcategoryid
), totals as (
    SELECT *,
        categoryrevenue/ sum(categoryrevenue) over () as Revenueshare
      FROM categorycore
)
Select *,
    sum(revenueshare) over (order by categoryrevenue desc) as RunningShare

from totals








/*,revshare as (    
    Select *,
        categoryrevenue/revenuetotals * 100 as RevenueShare
    from totals
)*/


/*categoryrevenue/ sum(categoryrevenue) over ()*/

/*Next, calculate each category's revenueshare; Also sort by revenueshare
Select *
from lineitembase */