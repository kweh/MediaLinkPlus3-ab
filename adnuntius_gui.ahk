;
; UI - TEST
;


adnuntius_gui:
	adn_multi_running := true
	gosub, getList

	StringReplace, mlStartdatumStrip, mlStartdatum, - ,, All
	StringReplace, mlStoppdatumStrip, mlStoppdatum, - ,, All
	StringTrimLeft, mlStartdatumStripYY, mlStartdatumStrip, 2
	FormatTime, idag, , yyyyMMdd
	checkDate := mlStartdatumStrip - idag
	console_log(mlnoteringar)
	if (checkDate < 0)
	{
	  MsgBox,48,Fel i startdatum, Startdatumet på kampanjen har redan passerat. `r`nDagens datum har satts som startdatum istället.
	  mlStartdatumStrip = %idag%
	}

	rev_cpm := order.CPM
	if (rev_cpm = 0)
	{
		rev_cpm := 1
	}
	if (rev_cpm < 15 && order.viewType = "Backfill lång") {
		rev_cpm := 15
	}

	gui, adn:Destroy
	gui, adn:Add, Picture, x0 y0, img\ui.png

	gui, adn:Font, s18 c666666, Open Sans
	gui, adn:Add, Text, x220 y34 BackgroundTrans vOrdernumber, %mlOrdernummer%
	gui, adn:Font, s16 c000000 w100
	gui, adn:Add, Edit,		HWNDhwnd_kundnummer 	x50 y130 w140 h40 vCustomernumber -Multi, % order.customer_nr
	gui, adn:Add, Edit, 	HWNDhwnd_kundnamn 		x210 y130 w320 h40 vCustomername -Multi, % order.customer_name
	gui, adn:Add, DateTime, HWNDhwnd_startdatum 	x60 y220 w230 h40 vStartdate Choose%mlStartdatumStrip%0000, yyyy-MM-dd HH:mm
	gui, adn:Add, DateTime, HWNDhwnd_slutdatum 		x310 yp w230 h40 vEnddate Choose%mlStoppdatumStrip%2359, yyyy-MM-dd HH:mm
	gui, adn:Add, Edit,		HWNDhwnd_exponeringar 	x50 y310 w230 h40 -Multi vImpressions, % order.imps
	gui, adn:Add, Edit,		HWNDhwnd_cpm 			x300 yp w230 h40 -Multi vCPM, % rev_cpm	
	gui, adn:Add, Edit,		HWNDhwnd_site 			x50 y400 w230 h40 -Multi vSite, % order.site
	gui, adn:Add, Edit,		HWNDhwnd_enhet 			x300 yp w230 h40 -Multi vUnit_name, % order.unit_name

	gui, adn:Font, c000000
	gui, adn:Color, FFFFFF
	gui, adn:Add, Picture, x310 y480 gAdnPost, img\knapp.png
	gui, adn:Add, Button, 	x10 yp+66 w460 h50 Default Hidden gAdnPost vBtn_boka, Boka
	gui, adn:Show, w600 h540, Annonsbokning adNuntius
  	WinSet, TransColor, 00FF00, Annonsbokning

	; Hämtar mått och position på kontroller för beskärning
  	GuiControlGet, pos_customernumber, adn:pos, customernumber
  	GuiControlGet, pos_customername, adn:pos, customername
  	GuiControlGet, pos_startdate, adn:pos, startdate
  	GuiControlGet, pos_enddate, adn:pos, enddate
  	GuiControlGet, pos_impressions, adn:pos, impressions
  	GuiControlGet, pos_cpm, adn:pos, cpm
  	GuiControlGet, pos_site, adn:pos, site
  	GuiControlGet, pos_unit_name, adn:pos, unit_name

  	; Beskär kontroller
  	WinSet, region, % "2-2 w" pos_customernumberw-4  " h" pos_customernumberh-4, % "ahk_id " hwnd_kundnummer
  	WinSet, region, % "2-2 w" pos_customernamew-4  " h" pos_customernameh-4, % "ahk_id " hwnd_kundnamn
  	WinSet, region, % "2-2 w" pos_startdatew-4  " h" pos_startdateh-4, % "ahk_id " hwnd_startdatum
  	WinSet, region, % "2-2 w" pos_enddatew-4  " h" pos_enddateh-4, % "ahk_id " hwnd_slutdatum
  	WinSet, region, % "2-2 w" pos_impressionsw-4  " h" pos_impressionsh-4, % "ahk_id " hwnd_exponeringar
  	WinSet, region, % "2-2 w" pos_cpmw-4  " h" pos_cpmh-4, % "ahk_id " hwnd_cpm
  	WinSet, region, % "2-2 w" pos_sitew-4  " h" pos_siteh-4, % "ahk_id " hwnd_site
  	WinSet, region, % "2-2 w" pos_unitw-4  " h" pos_unith-4, % "ahk_id " hwnd_enhet

  	GuiControl, adn:Focus, Btn_boka, 
return


adnGuiClose:
	gui, adn:Destroy
	adn_multi_running := false
return

adnPost:
	Gui, adn:Submit
	gui, adn:Destroy
	StringSplit, ordernumber, ordernumber, `n
	ordernumber := ordernumber1
	console_log(ordernumber)

	; SITE IDs
	; ==========================================
	
	site_id := ""
	site_eposten := "5e8cef39-1026-403d-ac2d-706b2ebb5004"
	site_dnns := "kcgf20kpz3np2zxl" 
	site_nsd := "ca721403-c319-4d97-a46f-e9845b0aa726"
	site_kuriren := "ee805e8d-ff72-4d85-b78f-ff87ddeeafac"
	site_pt := "ywpkl320kd5xhmsn"
	site_na := "trz7jkll007k7cgl"
	site_mvt := "l0tcgg9c6v5xddw9"
	site_co := "dlg78gbyz9lnph2p"
	site_uc := "gw60wz6d2c63hzs5"
	site_nt := "c426e5d9-2761-4037-a3b1-37e7ac8e2781"
	site_fb := "1k9shklhg0dhs63n"
	site_vt := "lnl3m88jshlh6jf0"
	site_af := "vgq85skgw3ctshh1"
	site_ks := "c6n8h0kv2382sq6p"
	site_hg := "7rkyqrbjkslvnxlj"
	site_unt := "3rdyx80ljnlfm8bs"
	site_ug := "2knr6n567h7g0rdc"
	site_afg := "1sgmbkrbjxx78t3b"

	; =========================================

	console_log("%site%")
	customer_owner := getOwner(customernumber)
	site_cost := "CPM"
	if (site = "eposten.se" || site = "mobil.eposten.se")
	{
		site_id = "%site_eposten%"
	}
	else if (site = "kuriren.nu" || site = "nsd.se" || site = "mobil.nsd.se" || site = "mobil.kuriren.nu")
	{
		site_id = 
		(
			"%site_nsd%",
			"%site_kuriren%"
		)
	}
	else if (site = "pt.se" || site = "m.pitea-tidn.se")
	{
		site_id = "%site_pt%"
	}
	else if (site = "norrbottensaffarer.se" || site = "mobil.norrbottensaffarer.se")
	{
		site_id = "%site_na%"
	}
	else if (site = "mvt.se" || site = "mobil.mvt.se")
	{
		site_id = "%site_mvt%"
	}
	else if (site = "corren.se" || site = "mobil.corren.se")
	{
		site_id = "%site_co%"
	}
	else if (site = "uppsala.com")
	{
		site_id = "%site_uc%"
	}
	else if (site = "nt.se" || site = "folkbladet.se" || site = "mobil.nt.se" || site = "m.folkbladet.se")
	{
		site_id =
		(
			"%site_nt%",
			"%site_fb%"
		)
	}
	else if (site = "vt.se" || site = "mobil.vt.se")
	{
		site_id = "%site_vt%"
	}
	else if (site = "Affärsliv.com" || site = "mobil.affarsliv.com")
	{
		site_id = "%site_af%"
		site_cost := "CPC"
		mlTidning := "AF"
	}
	; else if (site = "Affärsliv.com" || site = "mobil.affarsliv.com")
	; {
	; 	site_id = "%site_af%"
	; 	site_cost := "CPC"
	; 	mlTidning := "AF"
	; }
	else if (site = "klackspark.com" || site = "mobil.klackspark.com")
	{
		site_id = "%site_ks%"
		site_cost := "CPC"
		mlTidning := "KS"
	}
	else if (site = "helagotland.se" || site = "m.helagotland.se")
	{
		site_id = "%site_hg%"
	}
	else if (site = "unt.se" || site = "unt.mobil.se" || site = "sigtunabygden.se")
	{
		site_id = "%site_unt%"
	}
	else if (site = "uppgång.se")
	{
		site_id = "%site_ug%"
	}






	start_date := adnFormatTime(adnTime(startdate, -1))
	end_date := adnFormatTime(adnTime(enddate, -1))

	auth := adnAuth()
	customer_id := customernumber
	customer_data =
	(
		{
		  "name": "%mlTidning% - %customername%",
		  "externalReference": "%customer_id%",
		  "objectState": "ACTIVE"
		}
	)
	order_id := StrSplit(ordernumber, "-")
	order_id := order_id[1]
	order_data =
	(
		{
			"name": "%order_id%",
			"team": {
				"id": "defaultsitegroup"
			},
			"advertiser": {
				"id": "advertiser_%customer_id%"
			},
			"objectState": "ACTIVE"
		}
	)

	notes_id := ordernumber . "_" . A_Now
	notes_text := adnParseNote(mlNoteringar)
	if (InStr(notes_text, "AUTOBOKAD"))
	{
		notes_text := ""
	}
	notes_data =
	(
	{
		"data": [
			"%notes_text%<br></br>Automatbokad av: %me%"
		],
		"dataType": "TEXT"
	}
	)

	lineitem_id := "lineitem_" . ordernumber

	; Objectives är olika beroende på site-typ:
	objectives = 
	(
		"objectives": {
			"IMPRESSION": %impressions%
		}
	)

	campaignType = 
	(
		"type": "AUCTION"
	)

	tier = 
	(
		"tier": {
		    "id": "defaulttier",
		    "name": "Default",
		    "url": "/api/v1/tiers/defaulttier"
		}
	)

	if (InStr(order.viewType, "Backfill"))
	{
		objectives = 
		(
			"objectives": {}
		)
		cpm = 100

		campaignType = 
		(
			"type": "SPONSORSHIP",
			"sponsorshipPercentage": 100
		)

		tier = 
		(
  			"tier": {
			    "id": "wrdl880fshdch8sr",
			    "name": "Egenannonser",
			    "url": "/api/v1/tiers/wrdl880fshdch8sr"
			}
		)
	}

	if (site_cost = "CPC") 
	{
		objectives = 
		(
			"objectives": {}
		)
		cpm = 100

		campaignType = 
		(
			"type": "SPONSORSHIP",
			"sponsorshipPercentage": 100
		)
	}

	if (mlEnhetsnamn = "Väderspons" || mlEnhetsnamn = "Vädersponsring")
	{
		objectives = 
		(
			"objectives": {}
		)
		cpm = 100

		campaignType = 
		(
			"type": "SPONSORSHIP",
			"sponsorshipPercentage": 100
		)
	}

	lineitem_data =
	(
	{
		"name": "%mlTidning% - %format% - %ordernumber%",
		"startDate": "%start_date%",
		"endDate": "%end_date%",
		"bidSpecification": {
			"cpm": {
				"amount": %cpm%,
				"currency": "SEK"
			}
		},
		%objectives%,
		"order": {
			"id": "order_%order_id%"
		},
		"labels": [
			"%unit_name%",
			"%customer_owner%"
		],
		"notes": [
			{
				"id": "note_%notes_id%"
			}
		],
		%campaignType%,
		%tier%,
		"targeting" : {
				"siteTarget": {
					"sites": [
						%site_id%
					]
				},
				"siteGroupTarget": {
					"siteGroups": [
						{
						"id": "ky5781q8mm6t1fhh",
						"name": "NTM - Alla sajter",
						"url": "/api/v1/sitegroups/ky5781q8mm6t1fhh"
						}
					]
				}
			},
		"userState": "APPROVED",
		"objectState": "ACTIVE"
	}
	)

	StringSplit, creative_start, start_date, T
	creative_start := creative_start1
	creative_id := ordernumber
	creative_data =
	(
	{
		"description": "Creative för lineitem: %ordernumber%",
		"name": "%customername% - %creative_start%",
		"height": %mlH%,
		"width": %mlW%,
		"lineItem": "lineitem_%ordernumber%",
		"userState": "APPROVED",
		"layout": "y913lncrj2mm7xnq"
	}
	)
	Progress, b w300 R0-4 FS8, Startar bokning, Bokar annons i adNuntius, Bokning i adNuntius
	order := adnBooking(auth.access_token, customer_id, customer_data, order_id, order_data, lineitem_id, lineitem_data, creative_id, creative_data, notes_id, notes_data )
	Sleep, 1000
	Progress, Off
	console_log(lineitem.name)
	Msgbox,4,Öppna bokning i webbläsare, Vill du öppna denna bokning i din webbläsare?
	IfMsgBox, Yes
		Run, https://admin.adnuntius.com/line-items/line-item/lineitem_%ordernumber%

	adn_multi_running := false

return

adn_copy:
	auth := adnAuth()
	lid = lineitem_%mlOrdernummer%
	inputbox, old, Vilket ordernummer ska repeteras?, Fyll i ordernummer på den order som ska repeteras
	if (ErrorLevel)
	{
		return
	}
	oldid = lineitem_%old%
	oldlitem := adnLineItem(auth.access_token, oldid)
	if (oldlitem.id)
	{
		id_to_copy := oldlitem.id
		; All is well, use oldlitem.id
	} else {
		search := adnSearch(auth.access_token, "LineItem", mlOrdernummer)
		id_to_copy := search.searchResults[1].id
	}
	console_log(id_to_copy)
	; NU bygger vi det nya objektet.
	original := adnLineItem(auth.access_token, id_to_copy)
	original_creatives := adnGetCreatives(auth.access_token, original.id)
	console_log("Mina loggar")
	console_log(original_creatives)
	console_log(original_creatives.results[1].constraintsToAssets)
	repetition = True
	; gosub, adnPost
return

adnuntius_copy:
	gosub, getList
	rev_cpm := order.CPM
	if (rev_cpm = 0)
	{
		rev_cpm := 1
	}
	impses := order.imps
	inputBox, oldnr, Ange ordernummer, Ange det ordernummer som ska repeteras (0001234567-89):
	if (ErrorLevel)
	{
		return
	}
	else 
	{
		x_start = %mlStartdatum%T00:00:00Z
		x_end = %mlStoppdatum%T23:59:00Z
		start_date := adnFormatTime(adnTime(x_start, -1))
		end_date := adnFormatTime(adnTime(x_end, -1))
		data = 
		(
			{
			"campaignNumber":"%oldnr%",
			"newNumber":"%mlOrdernummer%",
			"startDate":"%start_date%",
			"endDate":"%end_date%",
			"impressions":%impses%,
			"cpm": %rev_cpm%,
			"name": "%mlTidning% - %format% - %mlOrdernummer%"
			}
		)
		console_log(mlStartdatum)
		console_log(mlStoppdatum)
		console_log(data)
		url := "http://medialinkplus.ntm.digital/rep/"
		opts := "Charset: utf-8"
		head := ""
		httprequest(url, data, head, opts)
		resp := JSON.Load(data)
		if (resp.error = "No match found") {
			Msgbox, Hittade ingen kampanj att repetera.
		} else {
			console_log(data)
			Msgbox, 4, Kampanj bokad, Kampanj bokad, Öppna i webbläsaren?
			IfMsgBox, Yes
			{
				Run, https://admin.adnuntius.com/line-items/line-item/lineitem_%mlOrdernummer%
			}
		}
	}
return

adnuntius_open:
	auth := adnAuth()
	lid = lineitem_%mlOrdernummer%
	litem := adnLineItem(auth.access_token, lid)
	console_log("DATA ==========================")
	console_log(litem)
	if (InStr(mlNoteringar, "'inviso': 'true'"))
	{
		msgbox,4,Invisomätning, Denna order ska även mätas med RAM/Inviso. Klicka på 'Ja' för att öppna i webbläsaren.
		IfMsgBox, Yes
			run, http://www2.rampanel.com/sv/login
	}
	if (litem.id)
	{
		console_log("ID FINNS!")
		Run, https://admin.adnuntius.com/line-items/line-item/lineitem_%mlOrdernummer%
	} else {
		console_log("ID FINNS INTE :((((")
		search := adnSearch(auth.access_token, "LineItem", mlOrdernummer)
		lid := search.searchResults[1].id
		Run, https://admin.adnuntius.com/line-items/line-item/%lid%
	}
return

adnuntius_customer:
	gosub, getList
	auth := adnAuth()
	; search_customer := StrReplace(mlKundnamn, A_Space, "`%20")
	search_customer := UriEncode(mlKundnamn)
	result := adnSearch(auth.access_token, "Advertiser", search_customer)
	if (!result)
	{
		MsgBox,, Fel, Begäran misslyckades
		return
	}
	advId := result.searchResults[1].id
	if (advId)
	{
		run, https://admin.adnuntius.com/advertisers/advertiser/%advId%
	}
	else
	{
		MsgBox,, Fel, Kunde inte hitta kunden i adNuntius.
	}

return

#include functions.ahk
#include cxense.ahk
#include subroutines.ahk
#include pdf_preview.ahk
#include settings.ahk
#include httpreq.ahk
; #include json.ahk
#include json2.ahk
#include note.ahk
#include dev.ahk
#include mlFileCheck.ahk
#include xml.ahk
#include adosql.ahk
#include material.ahk
#include support.ahk
#include Urifunc.ahk
#include ctlColors.ahk
#include korrektur.ahk
#include adnuntius.ahk
