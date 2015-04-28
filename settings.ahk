mlpSettings:

kolumnLista =
	(
1: %kolumn1%
2: %kolumn2%
3: %kolumn3%
4: %kolumn4%
5: %kolumn5%
6: %kolumn6%
7: %kolumn7%
8: %kolumn8%
9: %kolumn9%
10: %kolumn10%
11: %kolumn11%
12: %kolumn12%
13: %kolumn13%
14: %kolumn14%
15: %kolumn15%
16: %kolumn16%
17: %kolumn17%
18: %kolumn18%
19: %kolumn19%
20: %kolumn20%
	)

kolumnChoose = 1: %kolumn1%|2: %kolumn2%|3: %kolumn3%|4: %kolumn4%|5: %kolumn5%|6: %kolumn6%|7: %kolumn7%|8: %kolumn8%|9: %kolumn9%|10: %kolumn10%|11: %kolumn11%|12: %kolumn12%|13: %kolumn13%|14: %kolumn14%|15: %kolumn15%|16: %kolumn16%|17: %kolumn17%|18: %kolumn18%|19: %kolumn19%|20: %kolumn20%

checked := ""

IniRead, dev, %mlpSettings%, Misc, Dev
	if (dev = 1)
	{
		dev_checked := "Checked"
	}
IniRead, RMenuColor, %mlpSettings%, Theme, RMenuColor
	if (RMenuColor = "ERROR")
	{
		RMenuColor = FFFFFF
	}
; IniRead, menunames, %mlpSettings%, Misc, Menunames
; 	if (menunames = 1)
; 	{
; 		menu_checked := "Checked"
; 	}

Gui, 20:Add, Tab, x2 y0 w580 h430 , Allmänt|Kolumner|Utseende|Övrigt
Gui, 20:Tab, Allmänt ; -------------------------------------------------
Gui, 20:Add, Picture, x132 y120 w300 h190 , %dir_img%\mplus_settings.jpg
; Gui, 20:Add, Checkbox, x20 y400 vZenUpdates gZenUpdates %checked%, Notifiering av nya ärenden i zendesk
; Gui, 20:Add, Text, x472 y400 w100 h20 , Version %version%
Gui, 20:Tab, Kolumner ; ------------------------------------------------
Gui, 20:Add, Text, x42 y53 w80 h20 , Startdatum
Gui, 20:Add, Text, x42 y83 w80 h20 , Stoppdatum
Gui, 20:Add, Text, x42 y113 w80 h20 , Exponeringar
Gui, 20:Add, Text, x42 y143 w80 h20 , Kundnr
Gui, 20:Add, Text, x42 y173 w80 h20 , Kundnamn
Gui, 20:Add, Text, x42 y203 w80 h20 , Faktisk säljare
Gui, 20:Add, Text, x42 y233 w80 h20 , Produkt
Gui, 20:Add, Text, x42 y263 w80 h20 , Internetenhet
Gui, 20:Add, Text, x42 y293 w80 h20 , Status
Gui, 20:Add, Text, x42 y323 w80 h20 , Tilldelad
Gui, 20:Add, DropDownList, x142 y50 w150 h20 vddStart r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddStart, %iniStart%:
Gui, 20:Add, DropDownList, x142 y80 w150 h20 Choose%iniStopp% vddStopp r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddStopp, %iniStopp%:
Gui, 20:Add, DropDownList, x142 y110 w150 h20 Choose%iniExponeringar% vddExp r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddExp, %iniExponeringar%:
Gui, 20:Add, DropDownList, x142 y140 w150 h30 Choose%iniKundnr% vddKnr r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddKnr, %iniKundnr%:
Gui, 20:Add, DropDownList, x142 y170 w150 h20 Choose%iniKundnamn% vddKnamn r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddKnamn, %iniKundnamn%:
Gui, 20:Add, DropDownList, x142 y200 w150 h20 Choose%iniSaljare% vddSaljare r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddSaljare, %iniSaljare%:
Gui, 20:Add, DropDownList, x142 y230 w150 h20 Choose%iniProdukt% vddProdukt r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddProdukt, %iniProdukt%:
Gui, 20:Add, DropDownList, x142 y260 w150 h20 Choose%iniEnhet% vddInternetenhet r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddInternetenhet, %iniEnhet%:
Gui, 20:Add, DropDownList, x142 y290 w150 h20 Choose%iniStatus% vddStatus r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddStatus, %iniStatus%:
Gui, 20:Add, DropDownList, x142 y320 w150 h20 Choose%iniTilldelad% vddTilldelad r20, %kolumnChoose%
GuiControl, 20:ChooseString, ddTilldelad, %iniTilldelad%:
; Gui, 20:Add, Text, x300 y50 w260 h290 , %kolumnlista%
Gui, 20:add, button, x500 y380 w70 h40 gsaveCols, Spara
Gui, 20:Tab, Utseende ; ------------------------------------------------
Gui, 20:Add, Text, x42 y50 w150 h20 , Färg på högerklicksmeny
Gui, 20:Add, Edit, x42 y70 w80 h20 vRMenuColor, %RMenuColor%
Gui, 20:add, button, x500 y380 w70 h40 gsaveTheme, Spara
Gui, 20:Tab, Övrigt ; ------------------------------------------------
Gui, 20:Add, Checkbox, x42 y50 vdevbutton %dev_checked%, Visa felsökningsalternativ i högerklicksmeny
; Gui, 20:Add, Checkbox, x42 y65 vmenunames %menu_checked%,Dölj namn i huvudmeny (på egen risk!)
Gui, 20:add, button, x500 y380 w70 h40 gsaveMisc, Spara

Gui, 20:Show, xCenter yCenter h434 w585, Inställningar - MediaLink Plus
Return

20GuiClose:
	Gui, 20:destroy
	reload
return

saveCols:
	Gui, 20:Submit, NoHide
	IniDelete, %mlpKolumner%, Kolumner
	StringSplit, ddStart, ddStart, :
	IniWrite, %ddStart1%, %mlpKolumner%, Kolumner, Start
	StringSplit, ddStopp, ddStopp, :
	IniWrite, %ddStopp1%, %mlpKolumner%, Kolumner, Stopp
	StringSplit, ddExp, ddExp, :
	IniWrite, %ddExp1%, %mlpKolumner%, Kolumner, Exponeringar
	StringSplit, ddKnr, ddKnr, :
	IniWrite, %ddKnr1%, %mlpKolumner%, Kolumner, Kundnr
	StringSplit, ddKnamn, ddKnamn, :
	IniWrite, %ddKnamn1%, %mlpKolumner%, Kolumner, Kundnamn
	StringSplit, ddSaljare, ddSaljare, :
	IniWrite, %ddSaljare1%, %mlpKolumner%, Kolumner, Saljare
	StringSplit, ddProdukt, ddProdukt, :
	IniWrite, %ddProdukt1%, %mlpKolumner%, Kolumner, Produkt
	StringSplit, ddInternetenhet, ddInternetenhet, :
	IniWrite, %ddInternetenhet1%, %mlpKolumner%, Kolumner, Internetenhet
	StringSplit, ddStatus, ddStatus, :
	IniWrite, %ddStatus1%, %mlpKolumner%, Kolumner, Status
	StringSplit, ddTilldelad, ddTilldelad, :
	IniWrite, %ddTilldelad1%, %mlpKolumner%, Kolumner, Tilldelad
	msgbox % "Inställningar sparade!"
Return

saveTheme:
	Gui, 20:Submit, NoHide
	msgbox % "Inställningar sparade!"
	IniDelete, %mlpSettings%, %Theme%
	IniWrite, %RMenuColor%, %mlpSettings%, Theme, RMenuColor
	reload
return


saveMisc:
	Gui, 20:Submit, NoHide
	IniWrite, %devbutton%, %mlpSettings%, Misc, Dev
	; IniWrite, %menunames%, %mlpSettings%, Misc, Menunames
return
  