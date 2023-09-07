select   distinct u.FullName Fullname  ,bid.BidNumber  BidNumber,i.OriginalName   ItemName,s.SupplierName, bidofd.Quantity, bidofd.Price, bidofd.Amount,
bidof.TotalAmount , bidofd.TotalPrice ,bidofd.CurrencyCode ,
 bidofd.TotalPrice  Land_Cost,bidofd.BasePrice,bidofd.BaseAmount, bidofd.TotalBaseAmount TotalLandCost_AZN, bidofd.IsSelected  ,bid.CreatedDate,bidofd.OfferDueDate ValidityDate,
 bidofd.OfferItemDescription Description ,  bidofd.OfferItemId
from one_bid.BidLines bidl 
left join one_bid.bids bid on bid.BidId=bidl.BidId
left join one_bid.BidOfferDetails bidofd on bidofd.BidLineId=bidl.Id
left join one_bid.BidOffers bidof on bidof.Id=bidofd.BidOfferId
left join users u on u.UserId=bid.CreatedUserId
left join suppliers s on s.SupplierCode=bidof.SupplierCode
left join one_item.Items i on i.ItemId=bidl.ItemId
left join one_item.Items i2 on i2.ItemId=bidofd.OfferItemId

where   bid.StatusId=1  and bid.CreatedUserId!=2
and u.UserId not in (901050,901006,901069,901074,15,901075,901073,1059,901085,901071,901070,901007)
and bid.CreatedDate <'2023-07-01' 





