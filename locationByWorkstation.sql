declare @WrkStation varchar(200)
declare @stm NVARCHAR(MAX)
set @WrkStation = 'CC50454'
set @stm = 'xp_cmdshell ''ping ' + @WrkStation + ''''

declare @results table(result varchar(500))

insert into @results
exec sp_executesql @stm

select 

SUBSTRING(substring(result, charindex('[',result,0) + 1,  charindex(']',result,0) - charindex('[',result,0)-1) 
,
1
,
CHARINDEX('.', substring(result, charindex('[',result,0) + 1,  charindex(']',result,0) - charindex('[',result,0)-1) ,
CHARINDEX('.',
substring(result, charindex('[',result,0) + 1,  charindex(']',result,0) - charindex('[',result,0)-1) 
,4) +1)) + '0' as ThirdOct


,
SUBSTRING(substring(result, charindex('[',result,0) + 1,  charindex(']',result,0) - charindex('[',result,0)-1) 
,
1
,
CHARINDEX('.',
substring(result, charindex('[',result,0) + 1,  charindex(']',result,0) - charindex('[',result,0)-1) 
,4)) + '0.0' as SecondOct
, 
substring(result, charindex('[',result,0) + 1,  charindex(']',result,0) - charindex('[',result,0)-1) as ipAdd

into #tmpTbl from @results
where charindex('[',result,0) > 0

Select loc.location from #tmpTbl as ip
inner join [LDAP].[dbo].[ipLoc] as loc on 
loc.[IP] = ip.ThirdOct or loc.[IP] = ip.SecondOct

drop table #tmpTbl
