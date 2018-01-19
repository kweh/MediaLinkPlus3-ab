rightcontrol:
	original_clip := Clipboard ; Kopierar innehållet i clipboard
	Send, ^c ; Skickar ctrl+c för att kopiera markering
	selected := Clipboard ; Sätter det nya clipboard-innehållet till %selected%
	Clipboard := original_clip ; Sätter tillbaka original-innehållet i clipboard igen.

	adnOrder := false ; Sätter adnOrder till false för att kunna kolla senare om ett adnuntius-lineitem finns på ordernumret.
	formattime, today,,yyyyMMdd

	ordernr_rex := "^0{0,3}\d{7}(-\d{2})*$" ; Regex för att kolla om den markerade texten är ett ordernummer ( https://regex101.com/r/hVS0ko/1 ) 
	RegExMatch(selected, ordernr_rex, match) ; regex-matcha mot ovanstående

	if (match) ; Om det matchar...
	{
		if(!InStr(match, "-")) ; Om ordernumret innehåller ett -
		{
			match := match . "-01" ; då antar vi att det är materialnummer 01
		}
		if(!InStr(match, "000")) ; Om ordernumret innehåller ett -
		{
			match := "000" . match
		}
		mlOrdernummer := match
		Gosub, getList
		
		; ----------------------------
		; - Stuff happens from here
		; ----------------------------

		; Kolla om det finns en order i AdNuntius med detta ordernummer
		auth := adnAuth()
		lineitem_id := mlOrdernummer
		adn_id := "lineitem_" . mlOrdernummer
		lineitem := adnLineItem(auth.access_token, lineitem_id)
		if(lineitem.name && lineitem.objectState = "ACTIVE")
		{
			adnOrder := true ; om det finns, sätt adnOrder till true
			stats := adnLineItemStats(auth.access_token, lineitem_id)
		} else {
			search := adnSearch(auth.access_token, "LineItem", mlOrdernummer)
			lineitem := adnLineItem(auth.access_token, search.searchResults[1].id)
			lineitem_id := search.searchResults[1].id
			adn_id := search.searchResults[1].id
			if (lineitem.name && lineitem.objectState = "ACTIVE")
			{
				adnOrder := true ; om det finns, sätt adnOrder till true
				stats := adnLineItemStats(auth.access_token, lineitem_id)
			}
		}


		if (rcmenushown)
		{
			menu, rc, DeleteAll
			menu, rc_adn, DeleteAll
			rcmenushown := false
		}
		menu, rc, add, Visa i MediaLink, openInMediaLink

		menu, rc_adn, add, Öppna i adNuntius, openInAdn
		menu, rc_adn, add
		menu, rc_adn, add, % "Order:`t" . lineitem.name ,nothing
		menu, rc_adn, add,
		menu, rc_adn, add, % "Impressions:`t" . stats.impressions . " / " . lineitem.objectives.IMPRESSION ,nothing
		menu, rc_adn, add, % "`t" . asciiProgress(lineitem.objectives.IMPRESSION, stats.impressions) , nothing
		menu, rc_adn, add,
		menu, rc_adn, add, % "Start:`t" . adnTime(lineitem.startDate, 1) ,nothing
		menu, rc_adn, add, % "Stopp:`t" . adnTime(lineitem.endDate, 1) ,nothing

		daysInCampaign := adnTimeDiff(adnTime(lineitem.startDate, 1), adnTime(lineitem.endDate, 1))
		daysPassed := adnTimeDiff(adnTime(lineitem.startDate, 1), today)
		menu, rc_adn, add, % "`t" . asciiProgress(daysInCampaign, daysPassed) ,nothing

		menu, rc_adn, add,
		menu, rc_adn, add, % "Klick:`t" . stats.clicks ,nothing
		menu, rc_adn, add, % "Site:`t" . lineitem.targeting.siteTarget.sites[1].name , nothing

		numWarnings := lineitem.validationWarnings.MaxIndex()
		if(numWarnings)
		{
			menu, rc_adn, Add
			if (numWarnings = 1)
				menu, rc_adn, add, % numWarnings . " fel påträffat:", nothing
			Else
				menu, rc_adn, add, % numWarnings . " fel påträffade:", nothing
				
			Loop, % numWarnings
			{
				menu, rc_adn, add, % "`t" . lineitem.validationWarnings[A_Index].text , nothing
			}
		}
		menu, rc_adn, add,
		menu, rc_adn, add, Visa rapport, openReport
		menu, rc, add, AdNuntius, :rc_adn
		menu, rc, disable, AdNuntius

		if(adnOrder)
		{
			menu, rc, enable, AdNuntius
		}

		
		
		menu, rc, add, `t%mlKundnamn%, nothing, +BarBreak
		menu, rc, add,
		menu, rc, add, % "Status:`t" . lineitem.executionState, nothing
		menu, rc, add
		menu, rc, add, Format:`t%mlEnhetsnamn%, nothing
		menu, rc, add, Start:`t%mlStartdatum%, nothing
		menu, rc, add, Stopp:`t%mlStoppdatum%, nothing
		menu, rc, add, Exponeringar:`t%mlExponeringar%, nothing
		rcmenushown := true
		menu, rc, show

	}
	else ; Annars...
	{
		return ; gör ingenting
	}
return


openInMediaLink:
	WinActivate, NewsCycle MediaLink
	Control, ChooseString, Alla, ComboBox1, NewsCycle MediaLink ; Väljer "Alla annonser" i sökalternativsrutan
	ControlSetText, Edit1, %mlOrdernummer%, NewsCycle MediaLink ; Sätt ovanstående i sökfältet
	ControlFocus, Edit1, NewsCycle MediaLink	; Sätter fokus på sökfältet
	Send, {Enter} ; Trycker enter för att starta sök.
return

openInAdn:
	Run, https://admin.adnuntius.com/line-items/line-item/%adn_id%
return

openReport:
	Run, http://adrep.ntm.digital/%adn_id%
return

asciiProgress(req, cur)
{
	steps := 50
	percent := cur/req
	console_log("procent: " . percent)
	prog := steps*percent
	console_log("progress: " . prog)
	Loop, % steps
	{
		if(prog >= A_Index)
		{
			x := x . "I"
		}
		else
		{
			x := x . " "
		}
	}
	return "[" . x . "]"
}

asciiProgressTime(req, cur)
{
	steps := 70
	percent := cur/req
	console_log("procent: " . percent)
	prog := steps*percent
	console_log("progress: " . prog)
	Loop, % steps
	{
		if (Round(prog) = Round(A_Index))
		{
			x := x . "|"
		}
		else if(prog > A_Index)
		{
			x := x . "."
		}
		else
		{
			x := x . " "
		}
		console_log(Round(prog) . " -> " . Round(A_Index))
	}
	return "[" . x . "]"
}