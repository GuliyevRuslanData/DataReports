

--AllSigns LLC,GP STOCK FEED MMC,Naxçıvan MR Dövlət Energetika Xidməti  duplicate olub  status id - si 3 olanlar
--Duplicate Suppliers Names

SELECT  s.SupplierName, s.SupplierCode ,s.SupplierTypeCode
FROM Suppliers s
where s.StatusId=1 and s.SupplierName in (SELECT  s.SupplierName
from suppliers s 
where s.StatusId=1
GROUP BY s.SupplierName ,s.SupplierTypeCode
HAVING COUNT(*) > 1 ) 



SELECT suppliername, SupplierCode, s.StatusId
FROM suppliers s
WHERE s.StatusId = 3
  AND (suppliername LIKE N'AllSigns LLC'
       OR suppliername LIKE N'GP STOCK FEED MMC'
       OR suppliername LIKE N'Naxçıvan MR Dövlət Energetika Xidməti')



	   /*
suppliername	                                   SupplierCode	     StatusId
AllSigns LLC	                                     V-000962	         3
GP STOCK FEED MMC	                                 V-000993	         3
Naxçıvan MR Dövlət Energetika Xidməti	             V-001175	         3              */


--Duplicate Item names

select i.OriginalName from one_item.Items i
where StatusId=1
group by i.OriginalName	
having count(*)>1




SELECT i.OriginalName, i.ItemId
FROM one_item.Items i
WHERE i.StatusId = 1
AND i.OriginalName IN (
    SELECT OriginalName
    FROM one_item.Items
    WHERE StatusId = 1
    GROUP BY OriginalName
    HAVING COUNT(*) > 1
)