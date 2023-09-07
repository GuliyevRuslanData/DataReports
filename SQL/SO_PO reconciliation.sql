use OneData_Universal
go
select distinct po.PurchaseNumber,po.CreatedDate,sum(pol.FinalAmount),pol.CurrencyCode,sum(pol.FinalBaseAmount),s.SupplierName,
case when po.BuId=1 then 'Universal' when po.BuId=2 then 'LSS' end Company,u.FullName,u.FullName,po.[Description]
from PurchaseOrders po
left join PurchaseOrderLines pol on pol.PurchaseOrderId=po.PurchaseOrderId
left join Suppliers s on s.SupplierCode=po.SupplierCode
left join users u on u.userid=po.CreatedUserId
where po.CreatedUserId!=2 and po.CreatedDate between '2023-03-01' and '2023-03-14' and po.StatusId=1
group by po.PurchaseNumber,po.CreatedDate,pol.CurrencyCode ,s.SupplierName,FullName,u.FullName,po.Description,po.BuId