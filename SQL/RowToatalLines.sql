select  u.FullName,RequestId TotalRFQ,	Month,
				RequestLineId CancelledLines,SaleNumber HasSo,PurchaseNumber HasPo,RequestLineLineId TotalLines,BidLineId HasOffer,
				case when u.UserId in (901050,901006,901069,901074,15,901075,901073,1059,901085,901071,901070,901007) then 'Foreign' else 'Local' end as Types
				from Users u 
				left join
					(select prloh.UserId, prl.RequestId,MONTH(prl.CreatedDate) Month ,prlx.RequestLineId,so.SaleNumber,po.PurchaseNumber,prl.RequestLineId Requestlinelineid, bl.RequestLineId BidLineId
							from  PRRequestLineOfferHeaders prloh  
							left join PRRequestLines prl on prloh.RequestLineId = prl.RequestLineId
							left join PRRequestHeaders prh on prh.RequestId = prl.RequestId
							left join one_bid.BidLines bl on bl.RequestLineId = prl.RequestLineId
							left join one_bid.Bids b on b.bidid = bl.bidid
							left join PRRequestLines prlx on prlx.RequestLineId = prl.RequestLineId and prlx.DocumentTypeStageId in (
							20015,311052,3020015,3311052,4020015,4311052,8120015,8411052
							) and prlx.PriceProcurement is null
							left join ModuleTypeStages mts on mts.Id=prl.DocumentTypeStageId
							left join ModuleStages ms on ms.Id=mts.StageId
							left join SaleOrderLines sol on sol.RequestLineId = prl.RequestLineId
							left join SaleOrders so on so.SaleOrderId = sol.SaleOrderId and so.TypeStageId not in (90027,90028,90029  ,310111 ,310118 ,310124 ,3090027,3090028,3090029,4090027,4090028,4090029,8190027,8190028,8190029)
							left join PurchaseOrderLines pol on pol.RequestLineId = sol.RequestLineId
							left join PurchaseOrders po on pol.PurchaseOrderId = po.PurchaseOrderId and po.TypeStageId not in (50024,50025,50026,260035,260045,260053,310092,310098,310105,310024,320024,3050024,3050025,3050026,4050024,4050025,4050026,8150024,8150025,8150026) and po.StatusId = 1
							left outer join one_bid.BidStageInfos bsi on bsi.BidId = bl.BidId and  bsi.ActionId in 
							(90248  ,90734  ,90848  ,90908  ,90974  ,3090248,4091042,3090734,4091025,3090908,3090974,4090248,4090734,4090908,4090974) 
							where prl.CreatedDate >'2023-02-28'  and prh.StatusId = 1 and prh.CreatedUserId != 2 and prl.StatusId = 1 and prloh.UserId != 2 
							and prloh.Status = 2301  and prh.ModuleEntryDestinationId <> 6 and  (prl.SupplierCode not in (N'V-000621',N'V-000012','V-000211') or prl.SupplierCode is null)  
    --ms.Id not in(20015,310096,311052,3020015,4020015) and 
group by  prl.RequestId, prloh.UserId,prlx.RequestLineId,so.SaleNumber,po.PurchaseNumber,prl.RequestLineId,bl.RequestLineId,prl.CreatedDate) dataset on dataset.UserId = u.UserId
				where u.UserId in (
901050,901006,901069,901074,19,15,901075,901073,1059,901014,901085,49,900003,17,901070,1080,901007,1099)