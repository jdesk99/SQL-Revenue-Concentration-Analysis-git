with LineItemBase as (

    SELECT od.OrderID,
            od.ProductID,
            o.CustomerID,
            o.OrderDate,
            
            p.CategoryID as ProductCategoryID,
            p.SupplierID,
    
            c.CompanyName as CustomerName,
            c.Country as CustomerCountry,
            p.ProductName,
            v.CompanyName as SupplierName,
    
           od.unitprice,
           od.quantity,
           od.discount,
           od.UnitPrice * od.Quantity * (1-(coalesce(od.discount,0))) as NetLineRevenue
    
      FROM orderdetails od
      join orders o
          on od.OrderID = o.OrderID
      join customers c
          on o.CustomerID = c.CustomerID
      join products p
          on od.ProductID = p.ProductID
      left join vendors v
          on p.SupplierID = v.SupplierID
      )
      
Select *
from lineitembase
