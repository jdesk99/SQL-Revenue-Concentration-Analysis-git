with month as (

    select *,
    strftime('%Y-%m', orderdate) AS year_month
    from orderrevenuebase
)
, metrics as (
        Select year_month,
            sum(ordertotal) as MonthlyRevenue,
            count(*) as MonthlyOrders,
            avg(ordertotal) as AOV
        from month
        group by year_month
)
, PrevMonth as (
        Select 
            *,
           lag(MonthlyRevenue) over (order by year_month) as RevenuePrevMonth
        from metrics
)
, final as (
Select *,
   monthlyrevenue - RevenuePrevMonth  as MoMChange,
   ((monthlyrevenue - revenueprevmonth)/ nullif(revenueprevmonth,0)) as MoMPercentChange,
   Sum(monthlyrevenue) over(order by year_month) as RunningRevenue
from PrevMonth
)

Select 
    Year_Month,
    MonthlyOrders,
    AOV,
    MonthlyRevenue,
    RevenuePrevMonth,
    MoMChange,
    MoMPercentChange,
    RunningRevenue
from final


