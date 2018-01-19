getSql(start, stop, status*)
{
	result := []
	ConnectString := "Provider=SQLOLEDB.1;Password=adops2015;Persist Security Info=True;User ID=adops;Initial Catalog=adbprod;Data Source=adbasedb1.nt.se;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
	; Query = SELECT campaignnumber, quantityrequested, startdate, enddate FROM AoInCampaign WHERE startdate >= '%startdate%' AND enddate <= '%enddate%'
	Query =
(
	SELECT 
	aoincampaign.campaignnumber 		as 'Kampanjnummer', 
	aoincampaign.quantityrequested 	as 'Exponeringar', 
	aoincampaign.startdate 				as 'Startdatum', 
	aoincampaign.enddate 				as 'Stoppdatum', 
	aoproducts.name 						as 'Produkt',
	CfInUnitType.name 					as 'Internetenhet',
	Customer.AccountNumber 				as 'Kundnummer',
	Customer.Name1 						as 'Kundnamn',	
	UsrUsers.EmailAddress				as 'Säljarmail',
	CfInCampaignCategory.Name			as 'Kampanjkategori',
	convert(varchar(max), convert(varbinary(8000),shblobdata.blobdata)) as 'Interna noteringar',
	AoAdOrder.CreateDate					as 'Skapad datum',
	AoAdOrder.LastEditDate				as 'Senast ändrad',
	CfInUnitType.height 					as 'Höjd',
	CfInUnitType.width 					as 'Bredd',
	CfInSection.Name						as 'Sektion',
	UsrUsers.UserFname					as 'Säljare förnamn',
	UsrUsers.UserLname					as 'Säljare efternamn',
	aoinflight.price						as 'prrrrris',
	AoAdProdStatus.Name as 'Status'


FROM aoincampaign
LEFT JOIN AoInflight 			ON aoinflight.campaignid 				= aoincampaign.id
LEFT JOIN AoProducts 			ON AoProducts.Id 							= aoinflight.siteID
LEFT JOIN CfInUnitType 			ON CfInUnitType.Id 						= aoinflight.internetunitid
LEFT JOIN AoOrderCustomers 	ON AoOrderCustomers.AdOrderId			= aoinflight.adorderid
LEFT JOIN Customer 				ON Customer.AccountId					= AoOrderCustomers.CustomerId 
LEFT JOIN AoAdOrder 			ON AoAdOrder.Id 							= AoInCampaign.AdOrderId
LEFT JOIN AoSpecialPrice 		ON AoSpecialPrice.AoInFlightId		= AoInflight.Id
LEFT JOIN UsrUsers				ON UsrUsers.UserId						= AoAdOrder.RepId
LEFT JOIN ShBlobData			ON ShBlobData.Id							= AoInCampaign.InternalNotesID
LEFT JOIN CfInSection			ON CfInSection.Id							= AoInFlight.SectionId
LEFT JOIN CfInCampaignCategory ON CfInCampaignCategory.Id			= AoInCampaign.CampaignCatId
LEFT JOIN ML_INTERNETADINFO 	on ML_INTERNETADINFO.CAMPAIGNID = aoincampaign.id
LEFT JOIN AoAdProdStatus		on AoAdProdStatus.Id						= ML_INTERNETADINFO.STATUSID

WHERE 
   campaigntypeid IN (1,4,7,8,9,12,13,14)
   AND CfInCampaignCategory.Name NOT IN ('Fakturering')
   AND aoincampaign.startdate >= '%start%'
   AND aoincampaign.startdate <= '%stop%'
)
	; Om kampanjstatus har skickats med som parameter..
	if(status[1])
	{
		Query .= "`nAND AoAdProdStatus.Name IN ("
		; Iterera genom samtliga statusar 
		for index, status in status
			{
				statuslist .= "'" . status . "', "
			}
			StringTrimRight, statuslist, statuslist, 2

			Query .= statuslist . ")"
	}
	; print(query)
	query := ADOSQL(ConnectString, query) ; Kör SQL-frågan

	Loop % Query.MaxIndex()
	{
		i := A_Index + 1
		arr := Object()
		thisCampaign := query[i, 1]
		; print(thisCampaign . " --> " . lastCampaign)
		if (thisCampaign = lastCampaign)
		{
			; print(thisCampaign . " är samma som " . lastCampaign)
			continue
		}
		arr.campaignnumber := query[i, 1]
		arr.impressions := query[i, 2]
		arr.startdate := query[i, 3]
		arr.enddate := query[i, 4]
		site := query[i, 5]
		StringSplit, site, site, %A_Space%
		arr.site := site2
		arr.unit := query[i, 6]
		arr.customernumber := query[i, 7]
		arr.customer := query[i, 8]
		arr.sellermail := query[i, 9]
		arr.category := query[i, 10]
		arr.notes := query[i, 11]
		arr.createdate := query[i, 12]
		arr.lasteditdate := query[i, 13]
		arr.height := query[i, 14]
		arr.width := query[i, 15]
		arr.section := query[i, 16]
		arr.sellerfname := query[i, 17]
		arr.sellerlname := query[i, 18]
		arr.status := query[i, 20]
		result.Push(arr)
		; Spara kampanjnumret för att jämföra med nästa.
		lastCampaign := arr.campaignnumber
	}

	return result
}