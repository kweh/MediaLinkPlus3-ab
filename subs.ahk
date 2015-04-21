getList: ; Hämtar information från valt objekt i listvyn
	gosub, getAnvnamn
	ControlGet, listCount, List, Count Selected, %control%, Atex MediaLink
	ControlGet, getList, List, Selected, %control%, Atex MediaLink
	if (weblinkget = 1)
		ControlGet, getList, List, , %control%, Atex MediaLink
	StringSplit, getListRow, getList, `n
	listRow = %getListRow1%
	Stringsplit, kolumn, listRow, `t

	;Läs kolumn-info från användarens kolumner.ini
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
	if (mlSite = "Affärsliv.com")
	{
		mlSite = affarsliv.com
	}

	mlEnhet := kolumn%iniEnhet%
	mlOrdernummer = %kolumn1%
	weblinkget = 0
return


; Hämtar användarnamn från Medialink-fönstrets titelrad
getAnvnamn:
	WinGetTitle, Windowtext, Atex MediaLink
	StringSplit, WindowSplit, Windowtext, =
	StringSplit, WindowSplit, WindowSplit2, %A_Space%
	Anvandare =  %WindowSplit1%
	StringTrimRight, AnvKort, Anvandare, 2 ; Sätter AnvKort till användarens förnamn
return

; Kopierar kundnamn och ordernummer i formatet "Kundnamn (xxxxxxxxxx-xx)"
kundOrder:
	clipboard = %mlKundnamn% (%mlOrdernummer%)
return

; Söker i Medialink på ordernumret
sokOrder:
	StringTrimRight, OrderNummerUtanMnr, mlOrdernummer, 3 ; Tar bort tre sista tecken i ordernumret, dvs materialnummer inkl bindestreck
	ControlSetText, Edit1, %OrderNummerUtanMnr%, Atex MediaLink ; Sätt ovanstående i sökfältet
	Control, ChooseString, "Alla annonser", ComboBox1 ; Väljer "Alla annonser" i sökalternativsrutan
	ControlFocus, Edit1, Atex MediaLink	; Sätter fokus på sökfältet
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
	 	ControlGetText, getInterna, Edit3, Atex MediaLink
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
	run,  https://cxad.cxense.com/adv/campaign/%campaignId%
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
		Msgbox, 4, Boka flera kunder, Boka %listCount% kunder i Cxense?
		IFmsgbox, yes
		{
			proceed = true
			i = 1
			while (i <= listCount)
				{
					if (proceed = "true")
					{
						msgbox % proceed
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
						msgbox, next
						proceed = false
						gosub, cx_start
						i++
					}
				}
		}
	}
	if (listCount = 1)
	{
		goto, cx_start
	}

Return

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

reload:
	Reload
return