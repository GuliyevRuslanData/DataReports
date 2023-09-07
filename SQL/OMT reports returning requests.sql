  --1) 
  SELECT DISTINCT ph.RequestNumber, prl.RequestLineId, ms.StageName stagename, MST.StageName stagenamessss, prlsi.UserDescription
    FROM PRRequestLineStageInfoes prlsi
    LEFT JOIN PRRequestLines prl ON prlsi.RequestLineId = prl.RequestLineId
    LEFT JOIN PRRequestHeaders ph ON prl.RequestId = ph.RequestId
    LEFT JOIN ModuleActions ma ON ma.Id = prlsi.ActionId
    LEFT JOIN ModuleTypeStages mts ON ma.FromTypeStageId = mts.Id
    LEFT JOIN ModuleTypeStages mts1 ON ma.ToTypeStageId = mts1.Id
    LEFT JOIN ModuleStages ms ON ms.Id = mts.StageId
    LEFT JOIN ModuleStages msT ON msT.Id = mts1.StageId
	WHERE ma.ActionTypeId=2 and msT.StageName like N'%Yeni sor?unun daxil edilm?si (OMT)%' and prl.CreatedDate< '2023-05-23'





 -- 2) 
 SELECT distinct  ph.RequestNumber,count(  ph.RequestNumber) Count_Request_Number, count(prl.RequestLineId)Count_Requestline , ms.StageName stagename, MST.StageName TO_Stagename, prlsi.UserDescription,prlsi.ApproveDate 
    FROM PRRequestLineStageInfoes prlsi
    LEFT JOIN PRRequestLines prl ON prlsi.RequestLineId = prl.RequestLineId
    LEFT JOIN PRRequestHeaders ph ON prl.RequestId = ph.RequestId
    LEFT JOIN ModuleActions ma ON ma.Id = prlsi.ActionId
    LEFT JOIN ModuleTypeStages mts ON ma.FromTypeStageId = mts.Id
    LEFT JOIN ModuleTypeStages mts1 ON ma.ToTypeStageId = mts1.Id
    LEFT JOIN ModuleStages ms ON ms.Id = mts.StageId
    LEFT JOIN ModuleStages msT ON msT.Id = mts1.StageId
	WHERE ma.ActionTypeId=2 and msT.StageName like N'%Yeni sor?unun daxil edilm?si (OMT)%' and prl.CreatedDate< '2023-05-23'
	group by ph.RequestNumber,ms.StageName , MST.StageName , prlsi.UserDescription,prlsi.ApproveDate 




	--3) 
	with cte as ( SELECT  ph.RequestNumber reqnumbers,count( distinct ph.RequestNumber) Count_Request_Number, count (prl.RequestLineId)Count_Requestline , ms.StageName stagename,
	 MST.StageName TO_Stagename, prlsi.UserDescription descriptions,prlsi.ApproveDate  appdates
    FROM PRRequestLineStageInfoes prlsi
    LEFT JOIN PRRequestLines prl ON prlsi.RequestLineId = prl.RequestLineId
    LEFT JOIN PRRequestHeaders ph ON prl.RequestId = ph.RequestId
    LEFT JOIN ModuleActions ma ON ma.Id = prlsi.ActionId
    LEFT JOIN ModuleTypeStages mts ON ma.FromTypeStageId = mts.Id
    LEFT JOIN ModuleTypeStages mts1 ON ma.ToTypeStageId = mts1.Id
    LEFT JOIN ModuleStages ms ON ms.Id = mts.StageId
    LEFT JOIN ModuleStages msT ON msT.Id = mts1.StageId

	WHERE ma.ActionTypeId=2 and msT.StageName like N'%Yeni sor?unun daxil edilm?si (OMT)%' 
	group by ms.StageName ,ph.RequestNumber, MST.StageName , prlsi.UserDescription,prlsi.ApproveDate) 



	select  stagename, sum (Count_Request_Number) Sum_Request_Number,sum(Count_Requestline)Sum_Requestline_Number   from cte
	group by stagename