﻿getList: ; Hämtar information från valt objekt i listvyn
	gosub, getAnvnamn

	DllCall("QueryPerformanceCounter", "Int64 *", t_list_start)
	ControlGet, listCount, List, Count Selected, %control%, NewsCycle MediaLink
	ControlGet, getList, List, Selected, %control%, NewsCycle MediaLink
	StringSplit, getListRow, getList, `n
	listRow = %getListRow1%
	Stringsplit, kolumn, listRow, `t
	DllCall("QueryPerformanceCounter", "Int64 *", t_list_stopp)
	t_list_done := t_list_stopp - t_list_start

	;Läs kolumn-info från användarens kolumner.ini
	DllCall("QueryPerformanceCounter", "Int64 *", t_ini_start)
	IniRead, iniStart, %mlpKolumner%, kolumner, Start
	IniRead, iniStopp, %mlpKolumner%, kolumner, Stopp
	IniRead, iniExponeringar, %mlpKolumner%, kolumner, Exponeringar
	IniRead, iniKundnr, %mlpKolumner%, kolumner, Kundnr
	IniRead, iniKundnamn, %mlpKolumner%, kolumner, Kundnamn
	IniRead, iniSaljare, %mlpKolumner%, kolumner, Saljare
	IniRead, iniProdukt, %mlpKolumner%, kolumner, Produkt
	IniRead, iniEnhet, %mlpKolumner%, kolumner, Internetenhet
	IniRead, iniStatus, %mlpKolumner%, kolumner, Status
	IniRead, iniTilldelad, %mlpKolumner%, kolumner, Tilldelad
	DllCall("QueryPerformanceCounter", "Int64 *", t_ini_stopp)
	t_ini_done := t_ini_stopp - t_ini_start


	mlStartdatum := kolumn%iniStart%
	mlStoppdatum := kolumn%iniStopp%
	mlExponeringar := kolumn%iniExponeringar%
	mlKundnr := kolumn%iniKundnr%
	mlKundnamn := kolumn%iniKundnamn%
	mlSaljare := kolumn%iniSaljare%
	mlProdukt := kolumn%iniProdukt%
	mlStatus := kolumn%iniStatus%
	mlTilldelad := kolumn%iniTilldelad%

	StringSplit, prodArray, mlProdukt , %A_Space%
	mlTidning = %prodArray1%
	mlSite = %prodArray2%

	if (mlSite = "gotland.net")
	{
		mlTidning = GN
	}
	if (mlSite = "nt.se")
	{
		mlTidning = NTFB
	}

	if (mlSite = "mobil.nt.se")
	{
		mlTidning = NTFB
	}
	if (mlSite = "Affärsliv.com")
	{
		mlSite = affarsliv.com
		mlTidning = AF
	}
	if (mlSite = "Uppsalavimmel.se")
	{
		mlSite = uppsalavimmel.se
		mlTidning = UV
	}
	if (mlSite = "uppgång.se")
	{
		mlSite = uppgang.com
		mlTidning = UG
	}
	if (mlSite = "mobil.uppgång.se")
	{
		mlSite = mobil.uppgang.com
		mlTidning = UG
	}

	mlEnhet := kolumn%iniEnhet%
	mlOrdernummer = %kolumn1%
	weblinkget = 0
return


; Hämtar användarnamn från Medialink-fönstrets titelrad
getAnvnamn:
	WinGetTitle, Windowtext, NewsCycle MediaLink
	StringSplit, WindowSplit, Windowtext, =
	StringSplit, WindowSplit, WindowSplit2, %A_Space%
	anvNamn =  %WindowSplit1%
	StringTrimRight, me, anvNamn, 2 ; Sätter me till användarens förnamn
return

; Kopierar kundnamn och ordernummer i formatet "Kundnamn (xxxxxxxxxx-xx)"
kundOrder:
	clipboard = %mlKundnamn% (%mlOrdernummer%)
return

; Söker i Medialink på ordernumret
sokOrder:
	StringTrimRight, OrderNummerUtanMnr, mlOrdernummer, 3 ; Tar bort tre sista tecken i ordernumret, dvs materialnummer inkl bindestreck
	ControlSetText, Edit1, %OrderNummerUtanMnr%, NewsCycle MediaLink ; Sätt ovanstående i sökfältet
	Control, ChooseString, "Alla annonser", ComboBox1 ; Väljer "Alla annonser" i sökalternativsrutan
	ControlFocus, Edit1, NewsCycle MediaLink	; Sätter fokus på sökfältet
	Send, {Enter} ; Trycker enter för att starta sök.
return

; Interna noteringar
~Mbutton::
	 if(mlactive())
	 {
	 	if(internaActive)
	 	{
	 		gosub, 30GuiClose
	 	}
	 	Send {Click}
	 	Sleep, 100
	 	CoordMode, Mouse, Screen
	 	MouseGetPos, mx, my
	 	wx := mx-150
	 	wy := my+5
	 	ControlGetText, getInterna, Edit3, NewsCycle MediaLink
	 	Gui, 30:Add, Edit, r15 w300 x0 y0 vinternaNoteringar, %getInterna%
	 	Gui, 30:+AlwaysOnTop +ToolWindow
	 	Gui, 30:Show, w300 h200 x%wx% y%wy%, Interna Noteringar
	 	internaActive = true
	 }
return

30GuiClose:
	Gui, 30:Destroy
	internaActive = false
return


;--------------
;	Statusar
;--------------

statusKlar:
	status("klar")
return

statusNy:
	status("ny")
return

statusBearbetas:
	status("bearbetas")
return

statusVilande:
	status("vilande")
return

statusManusMail:
	status("vilande")
	assign("Manus på Mail")
return

statusKorrSkickat:
	status("korrektur skickat")
return

statusKorrekturKlart:
	status("korrektur klart")
return

statusUndersoks:
	status("undersöks")
return

statusRep:
	status("repetition")
return

statusLevFardig:
	status("Lev. färdig")
return

statusPreflight:
	status("preflight")
return

statusArkiverad:
	status("Arkiverad")
return

statusTilldelaBearbetas:
	status("bearbetas")
	assign(AnvKort)
return

statusBokad:
	status("Bokad")
return

statusObekraftad:
	status("Obekräftad")
return

statusEjkomplett:
	status("Ej komplett manus")
return

openCampaignRapportMulti:
	if (listCount > 1)
	{
		antalAnnonser := listCount
		aktuellAnnons = 1
		Msgbox, 4, Öppna flera annonser, Öppna %listCount% annonser i Rapportverktyget?
		IFmsgbox, yes
			{
			Progress, R0-%antalAnnonser% FM8 FS7 CBGray, Söker annonser..., Öppnar annonser i Rapportverktyget:, Annonsrapport
			while aktuellAnnons <= antalAnnonser
			{
				progress % aktuellAnnons-1
				listRow := getListRow%aktuellAnnons%
				Stringsplit, kolumn, listRow, `t

				mlStartdatum := kolumn%iniStart%
				mlStoppdatum := kolumn%iniStopp%
				mlExponeringar := kolumn%iniExponeringar%
				mlKundnr := kolumn%iniKundnr%
				mlKundnamn := kolumn%iniKundnamn%
				mlSaljare := kolumn%iniSaljare%
				mlProdukt := kolumn%iniProdukt%
				mlOrdernummer = %kolumn1%

				gosub, openCampaignRapport
				aktuellAnnons++
				progress % aktuellAnnons-1
				sleep, 500
			}
			if (aktuellAnnons > antalAnnonser)
			{
				Progress, Off
			}
		}
	}
	if (listCount = 1)
	{
		gosub, openCampaignRapport
		return
	}
return

openCustomerRapportMulti:
	if (listCount > 1)
	{
		antalKunder := listCount
		aktuellKund = 1
		Msgbox, 4, Öppna flera kunder, Öppna %listCount% kunder i Rapportverktyget?
		IFmsgbox, yes
			{
			Progress, R0-%antalKunder% FM8 FS7 CBGray, Söker kunder..., Öppnar kunder i Rapportverktyget:, Kundrapport
			while aktuellKund <= antalKunder
			{
				progress % aktuellKund-1
				listRow := getListRow%aktuellKund%
				Stringsplit, kolumn, listRow, `t

				mlStartdatum := kolumn%iniStart%
				mlStoppdatum := kolumn%iniStopp%
				mlExponeringar := kolumn%iniExponeringar%
				mlKundnr := kolumn%iniKundnr%
				mlKundnamn := kolumn%iniKundnamn%
				mlSaljare := kolumn%iniSaljare%
				mlProdukt := kolumn%iniProdukt%
				mlOrdernummer = %kolumn1%

				gosub, openCustomerRapport
				aktuellKund++
				progress % aktuellKund-1
				sleep, 500
			}
			if (aktuellKund > antalKunder)
			{
				Progress, Off
			}
		}
	}
	if (listCount = 1)
	{
		gosub, openCustomerRapport
		return
	}
return

openCampaignCx:
	xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
	kund = - %mlKundnr% -
	folderId := cx_xml_read(xml, "childFolder", kund, "folderId")
	xml := get_url("cxad.cxense.com/api/secure/campaigns/" folderId)
	campaignId := cx_xml_read(xml, "campaign", mlOrdernummer, "campaignId")
	if (campaignID = "")
	{
		Msgbox, Ingen kampanj hittad på detta ordernummer. Avbryter.
	}
	else {
		run,  https://cxad.cxense.com/adv/campaign/%campaignId%
	}
Return

openCustomerCx:
	xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
	kund = - %mlKundnr% -
	folderId := cx_xml_read(xml, "childFolder", kund, "folderId")
	run,  https://cxad.cxense.com/adv/folder/%folderId%
Return

openCampaignRapport:
	xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
	kund = - %mlKundnr% -
	folderId := cx_xml_read(xml, "childFolder", kund, "folderId")
	xml := get_url("cxad.cxense.com/api/secure/campaigns/" folderId)
	campaignId := cx_xml_read(xml, "campaign", mlOrdernummer, "campaignId")
	run,  http://rapport.ntm-digital.se/advertiser/%folderId%/campaign/%campaignId%/
Return

openCustomerRapport:
	xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
	kund = - %mlKundnr% -
	folderId := cx_xml_read(xml, "childFolder", kund, "folderId")
	run,  http://rapport.ntm-digital.se/advertiser/%folderId%/campaigns
Return

getKorr:
	if (listCount > 1)
	{
		goto, getMultiKorr
	}
	xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
	kund = - %mlKundnr% -
	folderId := cx_xml_read(xml, "childFolder", kund, "folderId")
	xml := get_url("cxad.cxense.com/api/secure/campaigns/" folderId)
	campaignId := cx_xml_read(xml, "campaign", mlOrdernummer, "campaignId")
	rapportUrl = http://rapport.ntm-digital.se/advertiser/%folderId%/campaign/%campaignId%/
Return

getMultiKorr:
	Progress, R0-%listCount% FM8 FS7 CBGray, Hämtar länk (), Hämtar korrekturlänkar:, Korrmail
	subject := "Korrektur:  " mlKundnamn " ("
	rapportUrl := ""
	i = 1
	while i <= listCount
		{
			progress % i-1
			progress, ,Hämtar länk (%i% av %listCount%), Hämtar korrekturlänkar:, Korrmail
			listRow := getListRow%i%
			Stringsplit, kolumn, listRow, `t

			mlStartdatum := kolumn%iniStart%
			mlStoppdatum := kolumn%iniStopp%
			mlExponeringar := kolumn%iniExponeringar%
			mlKundnr := kolumn%iniKundnr%
			mlKundnamn := kolumn%iniKundnamn%
			mlSaljare := kolumn%iniSaljare%
			mlProdukt := kolumn%iniProdukt%
			mlOrdernummer = %kolumn1%

			xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
			kund = - %mlKundnr% -
			folderId := cx_xml_read(xml, "childFolder", kund, "folderId")
			xml := get_url("cxad.cxense.com/api/secure/campaigns/" folderId)
			campaignId := cx_xml_read(xml, "campaign", mlOrdernummer, "campaignId")

			rapportUrl = %rapportUrl%%mlOrdernummer%: http://rapport.ntm-digital.se/advertiser/%folderId%/campaign/%campaignId%/`n
			if (i < listCount)
			{
				subject := subject "" mlOrdernummer ","
			}
			if (i = listCount)
			{
				subject := subject "" mlOrdernummer ")"
			}
			i++
			progress % i-1
			sleep, 500
		}
		Progress, Off
return

multiCxStart:
	if (listCount > 1)
	{
		Msgbox, 4, Boka flera kampanjer, Boka %listCount% kampanjer i Cxense?
		IFmsgbox, yes
		{
			i = 1
			stop = false
			while (i <= listCount)
				{
					while (stop = true)
					{

					}

					listRow := getListRow%i%
					Stringsplit, kolumn, listRow, `t

					mlStartdatum := kolumn%iniStart%
					mlStoppdatum := kolumn%iniStopp%
					mlExponeringar := kolumn%iniExponeringar%
					mlKundnr := kolumn%iniKundnr%
					mlKundnamn := kolumn%iniKundnamn%
					mlSaljare := kolumn%iniSaljare%
					mlProdukt := kolumn%iniProdukt%
					mlOrdernummer = %kolumn1%
					mlEnhet := kolumn%iniEnhet%
					StringSplit, prodArray, mlProdukt , %A_Space%
					mlTidning = %prodArray1%
					mlSite = %prodArray2%

					if (mlSite = "gotland.net")
					{
						mlTidning = GN
					}
					if (mlSite = "nt.se")
					{
						mlTidning = NTFB
					}

					if (mlSite = "mobil.nt.se")
					{
						mlTidning = NTFB
					}
					if (mlSite = "Affärsliv.com")
					{
						mlSite = affarsliv.com
					}	

					gosub, cx_start
					i++
				}
		}
	}
	if (listCount = 1)
	{
		goto, cx_start
	}
Return

multiCxOpen:
if (listCount > 1)
	{
		Msgbox, 4, Öppna flera kampanjer, Öppna %listCount% kampanjer i Cxense?
		IFmsgbox, yes
		Progress, R0-%listCount% FM8 FS7 CBGray, Hämtar länk (%i%/%listCount%), Hämtar kampanjlänkar:, Öppnar kampanjer
		{
			i = 1
			Progress, %i%, Hämtar länk (%i%/%listCount%), Hämtar kampanjlänkar:, Öppnar kampanjer
			while (i <= listCount)
				{
					progress % i-1, Hämtar länk (%i%/%listCount%), Hämtar kampanjlänkar:, Öppnar kampanjer
					listRow := getListRow%i%
					Stringsplit, kolumn, listRow, `t

					mlStartdatum := kolumn%iniStart%
					mlStoppdatum := kolumn%iniStopp%
					mlExponeringar := kolumn%iniExponeringar%
					mlKundnr := kolumn%iniKundnr%
					mlKundnamn := kolumn%iniKundnamn%
					mlSaljare := kolumn%iniSaljare%
					mlProdukt := kolumn%iniProdukt%
					mlOrdernummer = %kolumn1%
					mlEnhet := kolumn%iniEnhet%
					StringSplit, prodArray, mlProdukt , %A_Space%
					mlTidning = %prodArray1%
					mlSite = %prodArray2%
					
					xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
					kund = - %mlKundnr% -
					folderId := cx_xml_read(xml, "childFolder", kund, "folderId")
					xml := get_url("cxad.cxense.com/api/secure/campaigns/" folderId)
					campaignId := cx_xml_read(xml, "campaign", mlOrdernummer, "campaignId")
					if (campaignID = "")
						{
							Msgbox, 4096, Kampanj saknas, Ingen kampanj hittad på ordernummer "%mlOrdernummer%". Avbryter.
						}
						else {
							run,  https://cxad.cxense.com/adv/campaign/%campaignId%
						}

					i++
				}
			sleep, 500
			Progress, Off
		}
	}
	else {
		goto, openCampaignCx
	}
return


listaKundmapp:
	getFormat(mlEnhet) ; Hämtar formatet utifrån internetenhet
	stripDash(mlStartdatum) ; Tar bort - ur startdatum
	rensaTecken(mlKundnamn)
	StringTrimLeft, mlStartdatum, mlStartdatum, 2 ; tar bort första två tecknen ur datumet
	forstaBokstav := forstaBokstav(mlKundnamn)
	adDir = G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\%A_YYYY%\%forstaBokstav%\%mlKundnamn%\%mlStartdatum%
	ifExist, %adDir%
	{
		fla := list_files(adDir, "fla")
		psd := list_files(adDir, "psd")
	} else {
		msgbox, Ingen mapp hittades på denna sökväg:`r`n%adDir%
	}
return

photoshop:
	if (listcount = 1)
		{
		getFormat(mlEnhet) ; Hämtar formatet utifrån internetenhet
		stripDash(mlStartdatum) ; Tar bort - ur startdatum
		rensaTecken(mlKundnamn) 
		StringTrimLeft, mlStartdatum, mlStartdatum, 2 ; tar bort första två tecknen ur datumet
		forstaBokstav := forstaBokstav(mlKundnamn)

		adDir = %dir_webbannons%\%forstaBokstav%\%mlKundnamn%\%mlStartdatum%
		if FileExist(adDir)
		{
			FileCopy, %dir_templates%\%file%.psd, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.psd
			run, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.psd
		} else {
			FileCreateDir, %adDir%
			FileCopy, %dir_templates%\%file%.psd, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.psd
			run, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.psd
		}
	}
	if (listcount > 1) ; Producera flera
	{
		antalKunder := listCount
		aktuellKund = 1
		Msgbox, 4, Starta flera produktioner, Producera %listCount% annonser i Photoshop?
		IFmsgbox, yes
			{
			while aktuellKund <= antalKunder
			{
				msgbox % aktuellKund
				listRow := getListRow%aktuellKund%
				Stringsplit, kolumn, listRow, `t

				mlStartdatum := kolumn%iniStart%
				mlStoppdatum := kolumn%iniStopp%
				mlExponeringar := kolumn%iniExponeringar%
				mlKundnr := kolumn%iniKundnr%
				mlKundnamn := kolumn%iniKundnamn%
				mlSaljare := kolumn%iniSaljare%
				mlProdukt := kolumn%iniProdukt%
				mlOrdernummer = %kolumn1%

				getFormat(mlEnhet) ; Hämtar formatet utifrån internetenhet
				stripDash(mlStartdatum) ; Tar bort - ur startdatum
				rensaTecken(mlKundnamn) 
				StringTrimLeft, mlStartdatum, mlStartdatum, 2 ; tar bort första två tecknen ur datumet
				forstaBokstav := forstaBokstav(mlKundnamn)

				adDir = %dir_webbannons%\%forstaBokstav%\%mlKundnamn%\%mlStartdatum%
				if FileExist(adDir)
				{
					FileCopy, %dir_templates%\%file%.psd, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.psd
					run, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.psd
				} else {
					FileCreateDir, %adDir%
					FileCopy, %dir_templates%\%file%.psd, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.psd
					run, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.psd
				}

				aktuellKund++
				sleep, 500
			}
		}
	}
Return

flash:
	getFormat(mlEnhet) ; Hämtar formatet utifrån internetenhet
	stripDash(mlStartdatum) ; Tar bort - ur startdatum
	rensaTecken(mlKundnamn) 
	StringTrimLeft, mlStartdatum, mlStartdatum, 2 ; tar bort första två tecknen ur datumet
	forstaBokstav := forstaBokstav(mlKundnamn)

	adDir = %dir_webbannons%\%forstaBokstav%\%mlKundnamn%\%mlStartdatum%
	if FileExist(adDir)
	{
		FileCopy, %dir_templates%\%file%.fla, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.fla
		run, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.fla
	} else {
		FileCreateDir, %adDir%
		FileCopy, %dir_templates%\%file%.fla, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.fla
		run, %adDir%\%mlTidning%%format%-%mlKundnamn%-%mlStartdatum%.fla
	}

oppna:
	getFormat(mlEnhet) ; Hämtar formatet utifrån internetenhet
	stripDash(mlStartdatum) ; Tar bort - ur startdatum
	rensaTecken(mlKundnamn) 
	StringTrimLeft, mlStartdatum, mlStartdatum, 2 ; tar bort första två tecknen ur datumet
	forstaBokstav := forstaBokstav(mlKundnamn)

	adDir = %dir_webbannons%\%forstaBokstav%\%mlKundnamn%\
	ifExist, %adDir%
	{
		run, G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\%A_YYYY%\%forstaBokstav%\%mlKundnamn%\
	} else {
		msgbox,4,, Ingen mapp hittades på denna sökväg:`r`n%adDir%`r`n`r`nVill du skapa den?
		IfMsgBox, Yes
		{
			FileCreateDir, G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\%A_YYYY%\%forstaBokstav%\%mlKundnamn%\
			run, G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\%A_YYYY%\%forstaBokstav%\%mlKundnamn%\
		}
		IfMsgBox, No
			return
	}
return

reload:
	Reload
return

lager:
	Send, {Shift Down}
	Sleep, 100
	Send, {End}
	sleep, 100
	Send, {Shift Up}
	gosub, getList
	timestamp = %A_Now%
	FormatTime, timestamp, %timestamp%,yyyy-MM-dd HH:mm
	XML = 
	Loop, Parse, getList, `n
	{
		StringSplit, kolumn, A_LoopField, %A_Tab%
		produkt := kolumn%iniProdukt%
		StringSplit, prodArray, produkt , %A_Space%
		Tidning = %prodArray1%
		getFormat(kolumn%iniEnhet%) ; sätter format
		Ordernr = %kolumn1%
		Start := kolumn%iniStart%
		Stopp := kolumn%iniStopp%

		;~ StringTrimRight, startYear, Start, 6 ; startYear
		;~ StringTrimRight, startMonth, Start, 3 ; startMonth
		;~ StringTrimLeft, startMonth, startMonth, 5 ; startMonth
		;~ StringTrimLeft, startDay, Start, 8 ; startDay
		;~ startMonth := startMonth-1
		;~ Start = %startYear%-%startMonth%-%startDay%
		
		;~ StringTrimRight, stoppYear, Stopp, 6 ; stoppYear
		;~ StringTrimRight, stoppMonth, Stopp, 3 ; stoppMonth
		;~ StringTrimLeft, stoppMonth, stoppMonth, 5 ; stoppMonth
		;~ StringTrimLeft, stoppDay, Stopp, 8 ; stoppDay
		;~ stoppMonth := stoppMonth-1
		;~ Stopp = %stoppYear%-%stoppMonth%-%stoppDay%

		Kundnamn := kolumn%iniKundnamn%
		StringReplace, Kundnamn, Kundnamn, & , &amp;, All
		Exponeringar := kolumn%iniExponeringar%
		
		if (Tidning = "NT")
		{
			Tidning = NTFB
		}
		
		addToXML =
		(
		<kampanj>
			<tidning>%Tidning%</tidning>
			<format>%format%</format>
			<ordernr>%Ordernr%</ordernr>
			<kund>%Kundnamn%</kund>
			<start>%Start%</start>
			<stopp>%Stopp%</stopp>
			<exponeringar>%Exponeringar%</exponeringar>
		</kampanj>
		)
		
		XML = %XML%%addToXML%
	}
	fullXML =
	(
	<lager>
	<timestamp>%timestamp%</timestamp>
	%XML%
	</lager>		
	)
	
	;ftp-script
	FileDelete, %dir_ftp%\lager.xml
	FileEncoding, UTF-8-RAW
	FileAppend, %fullXML%, %dir_ftp%\lager.xml
	FileEncoding
	sleep, 500
	upload = %dir_ftp%\lager.xml
	ftpSettings := ftp_init(timestamp, upload)
	FTPCommandFile = %dir_ftp%\FTPCommands.txt
	FTPLogFile = %dir_ftp%\FTPLog.txt
	FileDelete %FTPCommandFile%  ; In case previous run was terminated prematurely.
	FileAppend, %ftpSettings%, %FTPCommandFile%

	RunWait %comspec% /c ftp.exe -s:"%FTPCommandFile%" >"%FTPLogFile%"
	FileDelete %FTPCommandFile%  ; Delete for security reasons.
	Msgbox,4,, Färdig! Visa logg?
		IfMsgBox, Yes
			Run %FTPLogFile%  ; Display the log for review.
		IfMsgBox, No
			return
return

rakna:
	msgbox % listCount " annonser markerade"
return

raknaExp:
	totExp = 0
	count = 0
	Loop, Parse, getList, `n 
	{
		StringSplit, kolumn, A_LoopField, `t
		totExp := totExp + kolumn%iniExponeringar%
		count++
		if(count = listCount)
		{
			break
		}
	}
	msgbox % totExp " exponeringar begärda av " listCount " annonser."
return


; STATUSAR
status_ny:
	status("ny")
Return

status_vilande:
	status("vilande")
Return

status_bearbetas:
	status("bearbetas")
Return

status_repetition:
	status("repetition")
Return

status_korrekturskickat:
	status("korrektur skickat")
Return

status_korrekturklart:
	status("korrektur klart")
Return

status_undersoks:
	status("undersöks")
Return

status_sentbokad:
	status("Sent bokad")
Return

status_klar:
	status("klar")
Return

status_levfardig:
	status("Lev. färdig")
Return

status_manusmail:
	status("Vilande")
	assign("Manus  på mail")
Return

status_zendesk:
	status("Vilande")
	assign("  Zendesk")
Return

status_vilandefardigt:
	status("Vilande färdigt")
return

status_under2d:
 	status("Under 2d prod. tid")
return

status_repmfor:
	status("Repetition m. ändrin")
return

status_bokad:
	status("bokad")
return

status_tilldela:
	status("bearbetas")
	assign(me)
return

status_obekraftad:
	status("Obekräftad")
return

status_annan:
	Send, !s
return


; TILLDELA
assign_me:
	assign(me)
Return

assign_other:
	Send, !a
Return

assign_none:
	assign(" ")
Return



copyCampaigns:
	i = 1
	copyList =
	;~ gosub, getList
	loop, parse, getList
	{
		if (i > listCount)
		{	
			break
		}
		thisRow := getListRow%i%
		if (thisRow != "")
		{
			copyList = %copyList%`n%thisRow%
		}
		i++
	}
	clipboard = %copyList%
return

raknaProd:
	ads = 0
	count = 0
	Loop, Parse, getList, `n 
	{
		if(count = listCount)
		{
			break
		}
		if (InStr(A_Loopfield, "Lev. Färdig") || InStr(A_LoopField, "Repetition"))
		{
			ads := ads
		} else 
		{
			ads++
		}
		count++
	}
	msgbox % ads " annonser att producera."
return

epaper:
	FileDelete, %dir_ftp%\epaper.htm
	StringReplace, sDate, mlStartdatum, - ,, All ; sDate = startdatum utan bindestreck
	i := 1
	divs = <body style="background: #EEE;">
	Loop, 48
	{
		num := i
		if (i<10)
		{
			num :="0"i
		}
		div = <div style="font-family: sans-serif; float: left; height: 400px; background: #FFF; border: 1px solid #DDD; margin: 10px; box-shadow: 1px 1px 5px rgba(0,0,0,0.1);"><iframe style="width: 250px; height: 350px; border: 1px solid #DDD; margin: 10px;" src="http://etidning.ntm.eu/Converted/%mlStartdatum%/VTIVTI-%sDate%-A0%num%-E1.pdf"></iframe><br><center><a style="text-decoration: none; margin-top: 5px;" href="http://etidning.ntm.eu/Converted/%mlStartdatum%/VTIVTI-%sDate%-A0%num%-E1.pdf">Sida %num% - Ladda ned</a></center></div>
		divs = %divs%`n%div%
		i++
	}
	FileAppend, %divs%, %dir_ftp%\epaper.htm
	Run, %dir_ftp%\epaper.htm
Return

weblink:
	Send, {Shift Down}
	Send, {F5}
	Send, {Shift Up}

	sleep, 10000

	Send, {Home}
	Send, {Shift Down}
	Send, {End}
	Send, {Shift Up}

	sleep, 2000

	timestamp = %A_Now%
	FormatTime, timestamp, %timestamp%,yyyy-MM-dd HH:mm

	weblinkget = 1
	StatusBarGetText, count, 3, NewsCycle MediaLink
	StringSplit, count, count , %A_Space%
	count := count1
	gosub, getList
	XML = 
	i := 0
	Loop, Parse, getList, `n
	{
		if (i = count)
		{
			break
		}
		StringSplit, kolumn, A_LoopField, %A_Tab%
		produkt := kolumn%iniProdukt%
		StringSplit, prodArray, produkt , %A_Space%
		Tidning = %prodArray1%
		getFormat(kolumn%iniEnhet%) ; sätter format
		Ordernr = %kolumn1%
		Start := kolumn%iniStart%
		Stopp := kolumn%iniStopp%
		Status := kolumn%iniStatus%
		Saljare := kolumn%iniSaljare%
		Kundnr := kolumn%iniKundnr%
		Tilldelad := kolumn%iniTilldelad%

		;~ StringTrimRight, startYear, Start, 6 ; startYear
		;~ StringTrimRight, startMonth, Start, 3 ; startMonth
		;~ StringTrimLeft, startMonth, startMonth, 5 ; startMonth
		;~ StringTrimLeft, startDay, Start, 8 ; startDay
		;~ startMonth := startMonth-1
		;~ Start = %startYear%-%startMonth%-%startDay%
		
		;~ StringTrimRight, stoppYear, Stopp, 6 ; stoppYear
		;~ StringTrimRight, stoppMonth, Stopp, 3 ; stoppMonth
		;~ StringTrimLeft, stoppMonth, stoppMonth, 5 ; stoppMonth
		;~ StringTrimLeft, stoppDay, Stopp, 8 ; stoppDay
		;~ stoppMonth := stoppMonth-1
		;~ Stopp = %stoppYear%-%stoppMonth%-%stoppDay%

		Kundnamn := kolumn%iniKundnamn%
		StringReplace, Kundnamn, Kundnamn, & , &amp;, All
		Exponeringar := kolumn%iniExponeringar%
		
		if (Tidning = "NT")
		{
			Tidning = NTFB
		}
		
		addToXML =
		(
		<kampanj>
			<tidning>%Tidning%</tidning>
			<format>%format%</format>
			<ordernr>%Ordernr%</ordernr>
			<kund>%Kundnamn%</kund>
			<kundnr>%Kundnr%</kundnr>
			<start>%Start%</start>
			<stopp>%Stopp%</stopp>
			<status>%Status%</status>
			<saljare>%Saljare%</saljare>
			<tilldelad>%Tilldelad%</tilldelad>
			<exponeringar>%Exponeringar%</exponeringar>
		</kampanj>
		)
		XML = %XML%%addToXML%
		i++
	}
	fullXML =
	(
	<weblink>
	<timestamp>%A_Now%</timestamp>
	%XML%
	</weblink>		
	)
	FileEncoding, UTF-8-RAW
	FileDelete, %dir_weblink%\xml.xml
	FileAppend, %fullXML%, %dir_weblink%\xml.xml

	;ftp-script
	upload = %dir_weblink%\xml.xml
	ftpSettings := ftp_init_weblink(timestamp, upload)
	FTPCommandFile = %dir_ftp%\FTPCommands.txt
	FTPLogFile = %dir_ftp%\FTPLog.txt
	FileDelete %FTPCommandFile%  ; In case previous run was terminated prematurely.
	FileAppend, %ftpSettings%, %FTPCommandFile%

	RunWait %comspec% /c ftp.exe -s:"%FTPCommandFile%" >"%FTPLogFile%"
	FileDelete %FTPCommandFile%  ; Delete for security reasons.
return

fileInfo:
	clipTemp := Clipboard
	Send, ^c
	ordernummer := Clipboard
	Clipboard := clipTemp
	IfWinExist, toolBox
	{
		WinActivate, toolBox
	}
	else
	{
		Run, %A_WorkingDir%\toolBox.exe
		Sleep, 700
	}
	WinWaitActive, toolBox
	ControlSetText, Edit2, %ordernummer%, toolBox
	ControlClick, Button12, toolBox

return

fileCheck:
	clipTemp := Clipboard
	Send, ^c
	ordernummer := Clipboard
	Clipboard := clipTemp
	IfWinExist, toolBox
	{
		WinActivate, toolBox
	}
	else
	{
		Run, %A_WorkingDir%\toolBox.exe
		Sleep, 700
	}
	WinWaitActive, toolBox
	ControlSetText, Edit1, %ordernummer%, toolBox
return

