select us.FullName,
case when us.UserId in (901050,901006,901069,901074,15,901075,901073,1059,901085,901071,901070,901007) then 'Foreign' else 'Local' end as Types,
Priority,Count(distinct RequestId) TotalRFQ,Count(d.RequestLineId) TotalLines,isnull(Sum(Successfull),0) Successfull,
isnull(Sum(NoOffer),0) NoOffer_pastDeadline,isnull(SUM(Late),0) Late,count(Cancel) CancelledLines,
isnull(Cast(Sum(Successfull)as decimal(5,2))/ Cast(Count(d.RequestLineId) as decimal(5,2)),0) as Rate ,Month,isnull(Sum(NoOfferBazar),0) NoOfferBazar

	from Users us
	left join						
						(select RequestId,UserId,RequestLineId,DATEDIFF(DAY,CreatedDate,TDDueDate) as DateDifference,
						case when  DATEDIFF(DAY,CreatedDate,TDDueDate) > 3 then 'Normal' when DATEDIFF(DAY,CreatedDate,TDDueDate) <= 3 then 'Urgent'  when UserId is null then  'Undelegated' end Priority, 
						case when (DATEDIFF(DAY,CreatedDate,TDDueDate) > 3 and TMOfferDate<TDDueDate) or (DATEDIFF(DAY,CreatedDate,TDDueDate) between 0 and 3 and  TMOfferDate<TDDueDate) then 1 else 0 end as Successfull, 
						case When TMOfferDate is null and TDDueDate<GETDATE() then 1 else 0  end NoOffer, 
						case when TMOfferDate is not null and TMOfferDate>TDDueDate then 1 else 0 end as Late,
						Cancel, Month, case when bazarid is not null and TDDueDate<GETDATE() then 1 else 0  end NoOfferBazar 
						from 
								   (select  RequestId,RequestLineId,UserId,CreatedDate,DueDate,TDDueDate,TMOfferDate,Cancel, Month,bazarid
										from
											(select prloh.RequestId,prloh.RequestLineId,prloh.UserId,prl.CreatedDate,prl.DueDate, prl.TransactionAmountDueDate TDDueDate, max(bsi.ApproveDate) TMOfferDate,prlx.RequestLineId Cancel,
											Month(prl.CreatedDate) Month,bazar.RequestLineId bazarid
								
												from PRRequestLineOfferHeaders prloh 
												left join PRRequestLines prl on prloh.RequestLineId = prl.RequestLineId
												left join PRRequestHeaders prh on prh.RequestId = prl.RequestId
												left join one_bid.BidLines bl on bl.RequestLineId = prl.RequestLineId
												left join PRRequestLines prlx on prlx.RequestLineId = prl.RequestLineId and prlx.DocumentTypeStageId in (
																	20015,311052,3020015,3311052,4020015,4311052,8120015,8411052
																	) and prlx.PriceProcurement is null

												left join PRRequestLines bazar on bazar.RequestLineId = prl.RequestLineId and bazar.DocumentTypeStageId = 20004
												left outer join one_bid.BidStageInfos bsi on bsi.BidId = bl.BidId and  bsi.ActionId in 
												(90248  ,90734  ,90848  ,90908  ,90974  ,3090248,4091042,3090734,4091025,3090908,3090974,
												4090248,4090734,4090908,4090974) 

												where prl.CreatedDate >'2023-02-28' and prh.StatusId = 1 and prh.CreatedUserId != 2 and prl.StatusId = 1 and prloh.UserId != 2 
												and  prloh.Status = 2301 and prh.ModuleEntryDestinationId <> 6 and  (prl.SupplierCode not in (N'V-000621',N'V-000012',N'V-000211') or prl.SupplierCode is null)
												
												group by  prloh.RequestId,prloh.RequestLineId,prl.CreatedDate,prl.DueDate, prl.TransactionAmountDueDate,prloh.UserId,prlx.RequestLineId,prl.CreatedDate,bazar.RequestLineId ) i) dataset ) d on d.userid = us.userid
												where us.UserId in (
															901050,901006,901069,901074,19,15,901075,901073,1059,901014,901085,49,900003,17,901070,1080,901007,1099)
		group by us.FullName,us.UserId,Priority,Month 