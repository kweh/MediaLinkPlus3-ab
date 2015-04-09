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
checked := ""
IniRead, zenNote, %mlpDir%\settings.ini, ZenNotes, aktiv
	if (zenNote = 1)
	{
		checked := "Checked"
	}
Gui, 20:Add, Tab, x2 y0 w580 h430 , Allmänt|Kolumner
Gui, 20:Tab, Allmänt ; -------------------------------------------------
Gui, 20:Add, Picture, x132 y120 w300 h190 , %devDir%\mplus_settings.jpg
Gui, 20:Add, Checkbox, x20 y400 vZenUpdates gZenUpdates %checked%, Notifiering av nya ärenden i zendesk
Gui, 20:Add, Text, x472 y400 w100 h20 , Version %version%
Gui, 20:Tab, Kolumner ; ------------------------------------------------
Gui, 20:Add, Text, x42 y50 w80 h20 , Startdatum
Gui, 20:Add, Text, x42 y80 w80 h20 , Stoppdatum
Gui, 20:Add, Text, x42 y110 w80 h20 , Exponeringar
Gui, 20:Add, Text, x42 y140 w80 h20 , Kundnr
Gui, 20:Add, Text, x42 y170 w80 h20 , Kundnamn
Gui, 20:Add, Text, x42 y200 w80 h20 , Faktisk säljare
Gui, 20:Add, Text, x42 y230 w80 h20 , Produkt
Gui, 20:Add, Text, x42 y260 w80 h20 , Internetenhet
Gui, 20:Add, Text, x42 y290 w80 h20 , Status
Gui, 20:Add, Text, x42 y320 w80 h20 , Tilldelad
Gui, 20:Add, DropDownList, x142 y50 w90 h20 Choose%iniStart% vddStart, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y80 w90 h20 Choose%iniStopp% vddStopp, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y110 w90 h20 Choose%iniExponeringar% vddExp, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y140 w90 h30 Choose%iniKundnr% vddKnr, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y170 w90 h20 Choose%iniKundnamn% vddKnamn, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y200 w90 h20 Choose%iniSaljare% vddSaljare, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y230 w90 h20 Choose%iniProdukt% vddProdukt, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y260 w90 h20 Choose%iniEnhet% vddInternetenhet, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y290 w90 h20 Choose%iniStatus% vddStatus, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, DropDownList, x142 y320 w90 h20 Choose%iniTilldelad% vddTilldelad, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui, 20:Add, Text, x292 y50 w260 h290 , %kolumnlista%
Gui, 20:add, button, x500 y380 w70 h40 gsaveCols, Spara

Gui, 20:Show, xCenter yCenter h434 w585, Inställningar - MediaLink Plus
Return

20GuiClose:
	Gui, 20:destroy
	reload
return

saveCols:
	Gui, 20:Submit, NoHide
	msgbox % "Inställningar sparade!"
	IniDelete, %mlpDir%\kolumner.ini, Kolumner
	IniWrite, %ddStart%, %mlpDir%\kolumner.ini, Kolumner, Start
	IniWrite, %ddStopp%, %mlpDir%\kolumner.ini, Kolumner, Stopp
	IniWrite, %ddExp%, %mlpDir%\kolumner.ini, Kolumner, Exponeringar
	IniWrite, %ddKnr%, %mlpDir%\kolumner.ini, Kolumner, Kundnr
	IniWrite, %ddKnamn%, %mlpDir%\kolumner.ini, Kolumner, Kundnamn
	IniWrite, %ddSaljare%, %mlpDir%\kolumner.ini, Kolumner, Saljare
	IniWrite, %ddProdukt%, %mlpDir%\kolumner.ini, Kolumner, Produkt
	IniWrite, %ddInternetenhet%, %mlpDir%\kolumner.ini, Kolumner, Internetenhet
	IniWrite, %ddStatus%, %mlpDir%\kolumner.ini, Kolumner, Status
	IniWrite, %ddTilldelad%, %mlpDir%\kolumner.ini, Kolumner, Tilldelad
Return

ZenUpdates:
	Gui, 20:Submit, NoHide
	IniWrite, %ZenUpdates%, %mlpDir%\settings.ini, ZenNotes, aktiv
return