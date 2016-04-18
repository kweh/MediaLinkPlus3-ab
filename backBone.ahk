#SingleInstance force
#include httpreq.ahk
#include xml.ahk
#include adosql.ahk

FileCreateDir, %A_AppData%\backBone
FileRead, prepath, %A_AppData%\backBone\path.txt

;
; AdBase-AUTH
; =====================================================================================
; SplashImage,,H100 W300, Autentiserar, Kontaktar AdBase API, AdBase-autentisering
; ACTION = http://www.atex.com/adbase/v3.3.1/utilities/Authenticate
; HEAD = SOAPAction: %ACTION%
; URL = http://ntm-adbase-003/AdBaseService/Utilities.asmx?op=Authenticate
; DATA = 
; (
; <?xml version="1.0" encoding="utf-16"?>
; <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
;   <soap:Body>
;     <Authenticate xmlns="http://www.atex.com/adbase/v3.3.1/utilities">
;       <username>dennisst</username>
;       <password>dest2013</password>
;     </Authenticate>
;   </soap:Body>
; </soap:Envelope>
; )
; OPTS = 
; HTTPRequest(URL, DATA, HEAD, OPTS)

; regex = ms)<AuthenticationToken>(.+?)</AuthenticationToken>
; RegExMatch(DATA, regex, catch)
; AUTH := catch1

; SplashImage, Off




;
; GUI
; =====================================================================================
;listvy
Gui, Add, ListView, x40 y48 w700 h300 -0x4000000 gLV_Update vLV_Field, Ordernummer|Kund|Klar
Gui, Font, s10 w400, Tahoma
;Radera --
Gui, Add, GroupBox, x760 y40 w170 h60, Radera
Gui, Add, Button, x770 y60 w70 h30 gDeleteOnePrint, Markerad
Gui, Add, Button, x850 y60 w70 h30 gDeleteAllPrint, Alla
;Timer --
Gui, Add, GroupBox, x760 y110 w170 h80, Timer
Gui, Add, Radio, x790 y130 w50 h20 vTimerOn gTimer Checked0, På
Gui, Add, Radio, x860 y130 w40 h20 vTimerOff gTimer Checked1, Av
Gui, Font, s7 c888888, Tahoma
Gui, Add, Text, x790 y160 w70 h20, Senast körd:
Gui, Add, Text, x850 y160 w70 h10 vLastRun,
Gui, Font, s10 w400 c000000, Tahoma
;-- Ordernummer
Gui, Add, Text, x760 y210, Ordernummer:
Gui, Add, Edit, x760 y230 w170 h30 +Multi vOrdernumber,
Gui, Add, Button, x759 y265 w120 h30 gAddPrint Default, Lägg till
Gui, Add, Checkbox, x889 y265 w50 h30 vnollett, -01

Gui, Add, GroupBox, x20 y20 w940 h350, Printordrar
; Gui, Add, GroupBox, x540 y20 w420 h350, Tidningssidor
; Gui, Add, DropDownList, x560 y70 w140 h20 R15 Sort vTidning gTidning, NT|FB|Corren|Corren Bostad|VT|MVT|UNT|GA|GT|NSD|Kuriren|PT
; Gui, Add, Text, x560 y50 w90 h20, Tidning
; Gui, Add, ListBox, x720 y70 w220 h290 vnewsList gnewsList, 
; Gui, Add, Text, x720 y50 w100 h20, Sidor
; Gui, Add, DropDownList, x560 y200 w140 h20 R20 vpath gpath, C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z
; Gui, Add, Text, x560 y180 w140 h20, Sökväg till Converted
; Gui, Add, DateTime, x560 y130 w140 h30 vdatum, yyyy-MM-dd
; Gui, Add, Text, x560 y110 w100 h20, Datum
Gui, Add, GroupBox, x20 y390 w940 h340, AdBooker-info
Gui, Add, Edit, x30 y440 w150 h30 -Multi vABordernummersok, 
Gui, Add, Text, x30 y420 w100 h20, Ordernummer
Gui, Add, Button, x190 y440 w60 h30 gABsok, Sök
Gui, Add, Text, x30 y480 w150 h20, Format:
Gui, Add, Text, x30 y500 w150 h20 vABformat, 
Gui, Add, Text, x200 y480 w90 h20, Kund:
Gui, Add, Text, x200 y500 w270 h20 vABkund, 
Gui, Add, GroupBox, x30 y520 w430 h200, Kontrakt
Gui, Add, Text, x40 y550 w100 h20, Startdatum:
Gui, Add, Text, x40 y570 w100 h20 vABstartdatum, 
Gui, Add, Text, x40 y600 w100 h20, Stoppdatum:
Gui, Add, Text, x40 y620 w100 h20 vABstoppdatum, 
Gui, Add, Text, x160 y600 w90 h20, Exponeringar:
Gui, Add, Text, x160 y620 w100 h20 vABexponeringar, 
Gui, Add, Text, x160 y650 w90 h20, CPM:
Gui, Add, Text, x160 y670 w100 h20 vABcpm, 
Gui, Add, Text, x160 y550 w110 h20, Säljare:
Gui, Add, Text, x160 y570 w110 h20 vABsaljare, 
Gui, Add, Text, x280 y650 w100 h20, Senast ändrad:
Gui, Add, Text, x280 y670 w160 h20 vABandrad, 
Gui, Add, Text, x490 y420 w180 h20, Interna noteringar:
Gui, Add, Edit, x490 y450 w460 h270 vABinternanoteringar, 
Gui, Add, Text, x40 y650 w100 h20, Pris:
Gui, Add, Text, x40 y670 w100 h20 vABpris, 
Gui, Add, Text, x280 y600 w100 h20, Kampanj skapad:
Gui, Add, Text, x280 y620 w150 h20 vABskapad,

IfExist, backbone_recovery.txt
{
	FileRead, recovery_txt, backbone_recovery.txt
	Loop, Parse, recovery_txt, |
	{
		StringSplit, Order, A_LoopField ,-
		customer := getCustomerName(order1)
		LV_Add(, A_LoopField, customer)
	}

}


Gui, Show, Center w978 h745, backBone
GuiControl, ChooseString, path, %prepath%
LV_ModifyCol(1,150)
LV_ModifyCol(2,300)
LV_ModifyCol(3,200)
Return

GuiClose:
	Gui, Submit, NoHide
	count := LV_GetCount()
	if (count = 0)
	{
		FileDelete, backbone_recovery.txt
		ExitApp
	}
	i = 1
	Loop, %count%
	{
		if (i > count)
		{
			break
		}
		LV_GetText(text, i)
		if (i = 1)
		{
			items := text
		}
		Else
		{
		items = %items%|%text%
	}
		i++
	}
	FileDelete, backbone_recovery.txt
	FileAppend, %items%, backbone_recovery.txt
ExitApp

;
;=======================================================================================

AddPrint:
	Gui, Submit, NoHide
	Loop, Parse, Ordernumber, `n
	{
		Order := A_LoopField
		check := RegExMatch(Order,"^000")
		if (check = 0)
		{
			Order = 000%Order%
		}
		check := RegExMatch(Order,"-\d{2}$")
		if (check = 0)
		{
			Order = %Order%-01
		}

		check := RegExMatch(Order,"^000\d{7}-\d{2}$")
		if (check = 0)
		{
			MsgBox, Fel format på ordernummer.`nKorrekt format är "0001234567-01"
		} else 
		{
			if (nollett = 1)
			{
				StringSplit, Order, Order ,-
				Order = %Order1%-01
			}
			StringSplit, Order, Order ,-
			customer := getCustomerName(order1)
			LV_Add("",Order,customer)
			GuiControl,, Ordernumber, 
		}
		GuiControl,, TimerOn, 1
		TimerOn = 1
		Gosub, timer
	}
return

DeleteOnePrint:
	selected := LV_GetNext(0,"F")
	; msgbox % selected
	LV_Delete(selected)
Return

DeleteAllPrint:
	TimerOn = 0
	TimerOff = 1
	GuiControl,, TimerOff, 1
	LV_Delete()
Return

LV_Update:
		selected := LV_GetNext(0,"F")
		LV_GetText(Ordernummer, selected)
		print := printCheck(Ordernummer)
		if (print = "print")
		{
			Run, %printdir%
		}
		; msgbox % Ordernummer
return

Timer:
	Gui, Submit, NoHide
	if (TimerOn = 1)
	{
		gosub, goPrint
		SetTimer, goPrint, 60000
	}
	if (TimerOff = 1)
	{
		SetTimer, goPrint, Off
	}
return

goPrint:
	ControlGet, orderArr, List, Col1 ,SysListView321, backBone
	ControlGet, klarArr, List, Col3 ,SysListView321, backBone
	StringSplit, klarArr, klarArr, `n
	Loop, Parse, orderArr, `n
	{
		row := A_Index
		klarIndex := klarArr%A_Index%
		print := printCheck(A_LoopField)
		if (print = "print" && klarIndex != "Klar!")
		{
			LV_Modify(A_Index, "Col3", "Klar!")
			TrayTip, Printannons hittad, En printannons har hittats på %A_LoopField%, 10,1
		}
		; if (klarIndex != "Klar!" && klarIndex != "Mail!")
		; {
		; 	RegExMatch(A_LoopField, "^000(\d{7})-\d{2}$",shortorder)
		; 	ol := ComObjActive("Outlook.Application")
		; 	olNamespace := ol.GetNamespace("MAPI") 
		; 	; Färdigt material
		; 	InBox := olNamespace.Folders.item("digital material").Folders.item("Inkorgen").Folders.item("Färdigt material")
		; 	loop, % Inbox.Items.Count
		; 	{
		; 		out := Inbox.Items(A_Index).subject "`n"
		; 		IfInString, out, %shortorder1%
		; 		{
		; 			LV_Modify(row, "", A_LoopField, "Mail!")
		; 			TrayTip, Material på mail, Ett mail har kommit med material till %A_LoopField%, 10,1
		; 		}
		; 	}
		; 	; Underlag			
		; 	InBox := olNamespace.Folders.item("digital material").Folders.item("Inkorgen").Folders.item("Underlag")
		; 	loop, % Inbox.Items.Count
		; 	{
		; 		out := Inbox.Items(A_Index).subject "`n"
		; 		IfInString, out, %shortorder1%
		; 		{
		; 			LV_Modify(row, "", A_LoopField, "Mail!")
		; 			TrayTip, Material på mail, Ett mail har kommit med material till %A_LoopField%, 10,1
		; 		}
		; 	}
		; 	; Inkorgen
		; 	InBox := olNamespace.Folders.item("digital material").Folders.item("Inkorgen")
		; 	loop, % Inbox.Items.Count
		; 	{
		; 		out := Inbox.Items(A_Index).subject "`n"
		; 		IfInString, out, %shortorder1%
		; 		{
		; 			LV_Modify(row, "", A_LoopField, "Mail!")
		; 			TrayTip, Material på mail, Ett mail har kommit med material till %A_LoopField%, 10,1
		; 		}
		; 	}
		; }

	}
	Timestamp := A_Hour ":" A_Min ":" A_Sec
	GuiControl,, LastRun, %Timestamp%
return

; path:
; 	Gui, Submit, NoHide
; 	FileDelete, %A_AppData%\backBone\path.txt
; 	FileAppend, %path%, %A_AppData%\backBone\path.txt
; return

; Tidning:
; 	Gui, Submit, NoHide
; 	GuiControl, ,newsList, |
; 	FormatTime, datum, %datum%, yyy-MM-dd
; 	if (Tidning = "NT")
; 	{
; 		prefix = NTINTI
; 	}
; 	if (Tidning = "Corren")
; 	{
; 		prefix = OCOOCO
; 	}
; 	if (Tidning = "Corren Bostad")
; 	{
; 		prefix = OCORTB
; 	}
; 	if (Tidning = "FB")
; 	{
; 		prefix = FB
; 	}
; 	if (Tidning = "UNT")
; 	{
; 		prefix = UNTUNT
; 	}
; 	if (Tidning = "VT")
; 	{
; 		prefix = VTIVTI
; 	}
; 	if (Tidning = "MVT")
; 	{
; 		prefix = MVTMVT
; 	}
; 	if (Tidning = "GA")
; 	{
; 		prefix = GALGAL
; 	}
; 	if (Tidning = "GT")
; 	{
; 		prefix = GTIGTI
; 	}
; 	if (Tidning = "NSD")
; 	{
; 		prefix = NSONSO
; 	}
; 	if (Tidning = "Kuriren")
; 	{
; 		prefix = NKUNKU
; 	}
; 	if (Tidning = "PT")
; 	{
; 		prefix = PITPIT
; 	}


; 	Loop, 100 ; A
; 	{
; 		index := A_Index
; 		if (index < 10)
; 		{
; 			index = 00%index%
; 		}
; 		if (index > 10)
; 		{
; 			index = 0%index%
; 		}
; 		StringReplace, dateNoDash, datum, -,, All
; 		fileName = %prefix%-%dateNoDash%-A%index%-E1.pdf
; 		; msgbox, %path%:\etidning.ntm.eu\Converted\%datum%\%fileName%
; 		IfExist, %path%:\etidning.ntm.eu\Converted\%datum%\%fileName%
; 		{
; 			GuiControl, ,newsList, %fileName%
; 		}
; 	}
; 	Loop, 100 ; B
; 	{
; 		index := A_Index
; 		if (index < 10)
; 		{
; 			index = 00%index%
; 		}
; 		if (index > 10)
; 		{
; 			index = 0%index%
; 		}
; 		StringReplace, dateNoDash, datum, -,, All
; 		fileName = %prefix%-%dateNoDash%-B%index%-E1.pdf
; 		; msgbox, %path%:\etidning.ntm.eu\Converted\%datum%\%fileName%
; 		IfExist, %path%:\etidning.ntm.eu\Converted\%datum%\%fileName%
; 		{
; 			GuiControl, ,newsList, %fileName%
; 		}
; 	}
; 		Loop, 100 ; C
; 	{
; 		index := A_Index
; 		if (index < 10)
; 		{
; 			index = 00%index%
; 		}
; 		if (index > 10)
; 		{
; 			index = 0%index%
; 		}
; 		StringReplace, dateNoDash, datum, -,, All
; 		fileName = %prefix%-%dateNoDash%-C%index%-E1.pdf
; 		; msgbox, %path%:\etidning.ntm.eu\Converted\%datum%\%fileName%
; 		IfExist, %path%:\etidning.ntm.eu\Converted\%datum%\%fileName%
; 		{
; 			GuiControl, ,newsList, %fileName%
; 		}
; 	}
; return

; newsList:
; 	if A_GuiEvent = DoubleClick
; 	{
; 		Gui, Submit, NoHide
; 		FormatTime, datum, %datum%, yyy-MM-dd
; 		GuiControlGet, item, ,newsList
; 		run, %path%:\etidning.ntm.eu\Converted\%datum%\%item%
; 	}
; return

~RButton::
	if (fcActive())
	{
		ControlGet, selected, List, Selected Col1, SysListView321, backBone
		menu, fcmenu, add, Öppna i MediaLink, openML
		menu, fcmenu, add, Öppna i MediaLink (internet), openMLinternet
		menu, fcmenu, add,
		menu, fcmenu, add, Visa ADBooker-info, ABinfo
		menu, fcmenu, show
	}
Return

openML:
	WinActivate, NewsCycle MediaLink
	WinWaitActive, NewsCycle MediaLink
	StringTrimRight, selected, selected, 3
	ControlSetText, Edit1, %selected%, NewsCycle MediaLink ; Sätt ovanstående i sökfältet
	Control, ChooseString, Alla annonser, ComboBox1, NewsCycle MediaLink ; Väljer "Alla annonser" i sökalternativsrutan
	ControlFocus, Edit1, NewsCycle MediaLink ; Sätter fokus på sökfältet
	Sleep, 100
	Send, {Enter} ; Trycker enter för att starta sök.
return

openMLinternet:
	WinActivate, NewsCycle MediaLink
	WinWaitActive, NewsCycle MediaLink
	StringTrimRight, selected, selected, 3
	ControlSetText, Edit1, %selected%, NewsCycle MediaLink ; Sätt ovanstående i sökfältet
	Control, ChooseString, Internetannonser, ComboBox1, NewsCycle MediaLink ; Väljer "Alla annonser" i sökalternativsrutan
	ControlFocus, Edit1, NewsCycle MediaLink ; Sätter fokus på sökfältet
	Sleep, 100
	Send, {Enter} ; Trycker enter för att starta sök.
return

fcActive(x=0)
{
	MouseGetPos, , , id, control
	IfInString, control, SysListView
		{
			IfWinActive, backBone
			{
				x := true
			}
		}
	return x
}

printCheck(x)
{
	global
	data := false
	StringTrimRight, OrderNummerUtanMnr, x, 3 ; Tar bort tre sista tecken i ordernumret, dvs materialnummer inkl bindestreck
	StringTrimLeft, mnr, x, 11 ; Plockar ut sista två siffrorna ur ordernumret
	StringTrimLeft, SistaTvaSiffrorna, OrderNummerUtanMnr, 8 ; Plockar ut sista två siffrorna ur ordernumret
	StringTrimLeft, OrderNummerUtanNollor, OrderNummerUtanMnr, 3 ; Tar bort inledande nollor i ordernumret
	printdir = \\nt.se\Adbase\Annonser\Ad\%SistaTvaSiffrorna%\10%OrderNummerUtanNollor%-%mnr%.pdf
	printdir_short = \\nt.se\Adbase\Annonser\Ad\%SistaTvaSiffrorna%\10
	imgdir = \\nt.se\Adbase\Annonser\eProof\%OrderNummerUtanNollor%-%mnr%.jpg
	ifExist, %printdir%
		{
			data := "print"
			ifExist, %imgdir%
					{
					data := "bild"
					}
		}
	return data

}
!#e::
	ol := ComObjActive("Outlook.Application")
	olNamespace := ol.GetNamespace("MAPI") 
	InBox := olNamespace.Folders.item("digital material").Folders.item("Inkorgen").Folders.item("Färdigt material")
	loop, % Inbox.Items.Count
		out .= Inbox.Items(A_Index).subject "`n"
	MsgBox % out
return

;
; AdBase
; ===================================================================

ABinfo:
	GuiControl, , ABordernummersok, %selected%
	gosub, ABsok
return

ABsok:
	; SplashImage,,H100 W300, Hämtar orderinformation, Kontaktar AdBase API, Hämtar orderinformation
	Gui, Submit, NoHide
	ordernummer = %ABordernummersok%
	order := getExtendedOrder(ordernummer)
	; SplashImage, Off
	kundnummer := order.customer_nr
	kundnamn := order.customer_name
	format := order.format
	startdatum := order.startdate
	stoppdatum := order.enddate
	fnamn := order.fname
	enamn := order.lname
	saljare = %fnamn% %enamn%
	exponeringar := order.imps
	skapad := order.createdate
	andrad := order.changedate
	interna := order.internalnotes
	pris := order.fprice
	cpmr := order.cpm

	GuiControl, , ABkund, %kundnummer% - %kundnamn%
	GuiControl, , ABstartdatum, %startdatum%
	GuiControl, , ABstoppdatum, %stoppdatum%
	GuiControl, , ABexponeringar, %exponeringar%
	GuiControl, , ABcpm, %cpmr%
	GuiControl, , ABformat, %format%
	GuiControl, , ABpris, %pris% kr
	GuiControl, , ABskapad, %skapad%
	GuiControl, , ABandrad, %andrad% %andradtid%
	GuiControl, , ABsaljare, %saljare%
	GuiControl, , ABinternanoteringar, %interna%


return

getOrderByNumber(number)
{
	global AUTH
	ACTION = http://www.atex.com/adbase/v3.3.1/export/GetOrderByNumber
	HEAD = SOAPAction: %ACTION%
	URL = http://ntm-adbase-003.nt.se/AdBaseService/Export.asmx
	DATA = 
	(
	<?xml version="1.0" encoding="utf-8"?>
	<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	  <soap:Body>
	    <GetOrderByNumber xmlns="http://www.atex.com/adbase/v3.3.1/export">
	      <AuthToken>%AUTH%</AuthToken>
	      <OrderNumber>%number%</OrderNumber>
	    </GetOrderByNumber>
	  </soap:Body>
	</soap:Envelope>
	)
	OPTS = 
	HTTPRequest(URL, DATA, HEAD, OPTS)
	return DATA
}


findXML(name, DATA)
{
	regex = ms)<%name%>(.+?)</%name%>
	RegExMatch(DATA, regex, catch)
	return catch1
}

findXMLsub(name, sub, DATA)
{
	regex = ms)<%name%>.+?<%sub%>(.+?)</%sub%>.+?</%name%>
	RegExMatch(DATA, regex, catch)
	return catch1
}

campaignSplit(DATA, split, ordernummer, num)
{
	campaign = %ordernummer%-%num%
	StringReplace, repl_data, DATA, <%split%>,``, All
	StringSplit, campaignArray, repl_data, ``
	i := 0
	Loop, 99
	{
		IfInString, campaignArray%i%, %campaign%
		{
			return campaignArray%i%
		}
		i++
	}
	if (campaignArray%num% = "")
	{
		msgbox, hittade inget
	}
	return
}

fixTime(ByRef time)
{
	StringTrimRight, month, time, 6
	StringTrimLeft, year, time, 4

	StringTrimLeft, temp, time, 2
	StringTrimRight, day, temp, 4

	time = %year%-%month%-%day%
}

getExtendedOrder(onr)
{
	order := Object()
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
	aoinflight.internetunitid 			as 'Internetenhets-ID',
	CfInUnitType.name 					as 'Internetenhet',
	Customer.AccountNumber 				as 'Kundnummer',
	Customer.Name1 						as 'Kundnamn',	
	Customer.TypeID 						as 'Kundtyp',
	AoAdOrder.NetAmount 					as 'pris ink moms eft. fakt',
	AoSpecialPrice.SpecialPriceValue as 'Specialpris',
	UsrUsers.EmailAddress				as 'Säljarmail',
	CfInUnitType.height 					as 'Höjd',
	CfInUnitType.width 					as 'Bredd',
	CfInCampaignCategory.Name			as 'Kampanjkategori',
	convert(varchar(max), convert(varbinary(8000),shblobdata.blobdata)) as 'Interna noteringar',
	AoAdOrder.CreateDate					as 'Skapad datum',
	AoAdOrder.LastEditDate				as 'Senast ändrad',
	CfInSection.Name						as 'Sektion',
	UsrUsers.UserFname					as 'Säljare förnamn',
	UsrUsers.UserLname					as 'Säljare efternamn',
	aoinflight.price						as 'flightpris'


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

WHERE 
	campaigntypeid IN (1,4,7,8)
	AND CampaignNumber = '%onr%'
)

	query := ADOSQL(ConnectString, query)
	; Sätter namn på de olika kolumnerna
	c_imps := 2
	c_startdate := 3
	c_enddate := 4
	c_product := 5
	c_unit_id := 6
	c_unit_name := 7
	c_customer_nr := 8
	c_customer_name := 9
	c_net_price := 11
	c_special_price := 12
	c_email := 13
	c_height := 14
	c_width := 15
	c_internalnotes := 17
	c_createdate := 18
	c_changedate := 19
	c_section := 20
	c_fname := 21
	c_lname := 22
	c_fprice := 23

	; Populerar objektet med keys och values
	order.customer_name 	:= query[2, c_customer_name]
	order.customer_nr 		:= query[2, c_customer_nr]
	order.imps 				:= query[2, c_imps]
	imps 					:= query[2, c_imps]
	order.startdate 		:= query[2, c_startdate]
	order.enddate 			:= query[2, c_enddate]
	unit_id 				:= query[2, c_unit_id]
	order.unit_id 			:= query[2, c_unit_id]	
	order.unit_name 		:= query[2, c_unit_name]	
	product 				:= query[2, c_product]
	order.product 			:= query[2, c_product]	
	order.format 			:= getFormat(unit_id)
	product_split 			:= StrSplit(product, A_Space)
	order.paper 			:= product_split[1]
	order.site 				:= product_split[2]
	order.net_price 		:= Round(query[2, c_net_price])
	order.special_price 	:= Round(query[2, c_special_price])
	special_price 			:= Round(query[2, c_special_price])
	order.email 			:= query[2, c_email]
	order.height 			:= query[2,c_height]
	order.width 			:= query[2,c_width]
	order.internalnotes 	:= query[2,c_internalnotes]
	order.createdate 		:= query[2,c_createdate]
	order.changedate 		:= query[2,c_changedate]
	order.section 			:= query[2,c_section]
	order.fname 			:= query[2,c_fname]
	order.lname 			:= query[2,c_lname]
	order.fprice 			:= Round(query[2,c_fprice])
	fprice 				:= order.fprice
	order.CPM 				:= Round(fprice/(imps/1000))

	if (ADOSQL_LastError)
		msgbox % ADOSQL_LastError	
	return order
}

getCustomerName(adordernumber)
{
	ConnectString := "Provider=SQLOLEDB.1;Password=adops2015;Persist Security Info=True;User ID=adops;Initial Catalog=adbprod;Data Source=adbasedb1.nt.se;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
	; Query = SELECT campaignnumber, quantityrequested, startdate, enddate FROM AoInCampaign WHERE startdate >= '%startdate%' AND enddate <= '%enddate%'
	Query =
(
SELECT Customer.Name1 as 'Kundnamn'
FROM AoAdOrder 

LEFT JOIN AoOrderCustomers ON AoOrderCustomers.AdOrderId	= AoAdOrder.Id
LEFT JOIN Customer ON Customer.AccountId = AoOrderCustomers.CustomerId 

WHERE AdOrderNumber = '%adordernumber%'
)
	query := ADOSQL(ConnectString, query)
	return query[2,1]
}

getFormat(id)
{
	global
	; Lista finns i adbase dbo.CgInUnitType
	format =
	format := id = "139"		? "WID" : format
	format := id = "3"			? "WID" : format
	format := id = "141"		? "OUT" : format
	format := id = "4"			? "OUT" : format
	format := id = "1"			? "PAN" : format
	format := id = "33"			? "PAN" : format
	format := id = "70"			? "PAN" : format
	format := id = "70"			? "PAN" : format
	format := id = "129"		? "PAN" : format
	format := id = "135"		? "PAN" : format
	format := id = "137"		? "PAN" : format
	format := id = "145"		? "PAN" : format
	format := id = "146"		? "PAN" : format
	format := id = "147"		? "PAN" : format
	format := id = "148"		? "PAN" : format
	format := id = "149"		? "PAN" : format
	format := id = "156"		? "PAN" : format
	format := id = "167"		? "PAN" : format
	format := id = "168"		? "PAN" : format
	format := id = "136"		? "PANXL" : format
	format := id = "138"		? "MOD" : format
	format := id = "151"		? "MOD" : format
	format := id = "197"		? "MOD" : format
	format := id = "144"		? "MKMOD" : format
	format := id = "37"			? "180" : format
	format := id = "196"		? "350" : format
	format := id = "34"			? "380" : format
	format := id = "106"		? "380" : format
	format := id = "130"		? "380" : format
	format := id = "112"		? "180" : format
	format := id = "38"			? "580" : format
	format := id = "9"			? "HEL" : format
	format := id = "108"		? "TXT" : format
	format := id = "57"			? "MOB" : format
	format := id = "58"			? "MOB" : format
	format := id = "59"			? "MOB" : format
	format := id = "61"			? "MOB" : format
	format := id = "62"			? "MOB" : format
	format := id = "117"		? "MOB" : format
	format := id = "214"		? "MOB" : format
	format := id = "150"		? "TORGET" : format
	format := id = "118"		? "REACH468" : format
	format := id = "119"		? "REACH250" : format
	format := id = "174"		? "SNURRA" : format
	format := id = "85"			? "SKYLT" : format
	format := id = "98"			? "SKYLT" : format
	format := id = "99"			? "SKYLT" : format
	format := id = "100"		? "SKYLT" : format
	format := id = "101"		? "SKYLT" : format
	format := id = "126"		? "SKYLT" : format
	format := id = "128"		? "SKYLT" : format
	format := id = "128"		? "SKYLT" : format
	format := id = "152"		? "SKYLT" : format
	format := id = "142"		? "ARTIKEL" : format
	format := id = "166"		? "ARTIKEL" : format
	format := id = "200"		? "ARTIKEL" : format



	return format
}