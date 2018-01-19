korrGui:
	; Först hämtar vi ut mappen som gäller för det material som användaren klickat på
	Gui, korrektur:Destroy
	gosub, getList
	pre_info := ""
	pre_link := ""
	pre_recipients := ""
	IfExist, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%\info.txt
	{
		FileRead, infotxt, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%\info.txt
		infoarr := StrSplit(infotxt, "|")
		Loop, % infoarr.MaxIndex()
		{
			kv := StrSplit(infoarr[A_Index], ":")
			if (kv[1] = "info")
				pre_info := kv[2]

			if (kv[1] = "link")
				pre_link := kv[2]

			if (kv[1] = "recipients")
				pre_recipients := kv[2]
		}
		msgbox, Hittade tidigare korrektur på servern. Vissa fält fylls i med tidigare information.

	}

	Gui, korrektur:Add, Button, gchooseFileProof, Välj fil
	Gui, korrektur:Add, Edit, vChosenFile yp+1 xp+55 w320 h26,

	Gui, korrektur:Font, s8
	Gui, korrektur:Add, Text, x10 , Kundnamn:
	Gui, korrektur:Font, s10
	Gui, korrektur:Add, Edit, HWNDcustomerName vcustomerName x10 w377 h26 yp+13,

	Gui, korrektur:Font, s8
	Gui, korrektur:Add, Text, x10 , Mottagare (kommaseparerat):
	Gui, korrektur:Font, s10
	Gui, korrektur:Add, Edit, HWNDemail vrecipients x10 w377 h26 yp+13, %pre_recipients%

	Gui, korrektur:Font, s8
	Gui, korrektur:Add, Text, x10 , Övrig information:
	Gui, korrektur:Font, s10
	Gui, korrektur:Add, Edit, vinfo r5 x10 w377 h26 yp+13, %pre_info%

	Gui, korrektur:Font, s8
	Gui, korrektur:Add, Text, x10 , Eventuell länk (inte http://):
	Gui, korrektur:Font, s10
	Gui, korrektur:Add, Edit, HWNDlink vlink x10 w377 h26 yp+13, %pre_link%

	Gui, korrektur:Add, Checkbox, vOpenLink, Öppna länk

	Gui, korrektur:Add, Button, gproofSend w377 h40, Skicka
	Gui, korrektur:Color, FFFFFF
	Gui, korrektur:Show, w400



	GuiControl, ,%customerName% , %mlKundnamn%
	GuiControl, ,%email% , %mlSaljare%
return

chooseFileProof:
	getFormat(mlEnhet) ; Hämtar formatet utifrån internetenhet
	stripDash(mlStartdatum) ; Tar bort - ur startdatum
	rensaTecken(mlKundnamn) 
	StringTrimLeft, mlStartdatum, mlStartdatum, 2 ; tar bort första två tecknen ur datumet
	forstaBokstav := forstaBokstav(mlKundnamn)

	adDir = %dir_webbannons%\%forstaBokstav%\%mlKundnamn%\
	ifExist, %adDir%
	{
		path = G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\%A_YYYY%\%forstaBokstav%\%mlKundnamn%\
	}
	else 
	{
		path = G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv
	}
	prompt = Välj en fil att skicka iväg för korrektur
	FileSelectFile, proofFile, 3, %path%, %prompt%,
	GuiControl, , chosenFile, %proofFile%

return

korrekturGuiClose:
	Gui, korrektur:Destroy
return

proofSend:
	Gui, korrektur:Submit
	Gui, korrektyr:Destroy

	if (InStr(link, "http://"))
	{
		msgbox, Hörrö, ingen "http://" sade jag ju :(
			return
	}
	SplashTextOn, 400, 60, Kopierar material, Kopierar material till server och skapar korrekturlänk.
	gosub, getList
	WinGetTitle, Windowtext, NewsCycle MediaLink
	StringSplit, WindowSplit, Windowtext, =
	StringSplit, WindowSplit, WindowSplit2, %A_Space%
	anvNamn =  %WindowSplit1%
	user := getUser(anvNamn)

	SplitPath, chosenFile,filename ,filedir,fileext, filenoext

	console_log("Filnamn: " . proofFile)
	console_log("Mottagare: " . recipients)
	console_log("Höjd: " . mlH)
	console_log("Bredd: " . mlW)
	console_log("Format: " . mlEnhet)
	console_log("Startdatum: " . mlStartdatum)
	console_log("Stoppdatum: " . mlStoppdatum)
	console_log("Site: " . mlSite)
	console_log("Producent: " . user.fname . " " . user.lname)
	console_log("Producentmail: " . user.email)

	infotext := "kund:" . customerName . "|recipients:" . recipients . "|info:" . info . "|height:" . mlH . "|width:" . mlW . "|start:" . mlStartdatum . "|stopp:" . mlStoppdatum . "|site:" . mlSite . "|producer:" . user.fname . " " . user.lname . "|email:" . user.email . "|file:" . filename . "|ext:" . fileext . "|link:" . link
	FileDelete, info.txt
	FileAppend, %infotext%, info.txt, UTF-8

	if (fileext != "html")
	{
		IfNotExist, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%
		{
			FileCreateDir, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%
		}
		FileCopy, %proofFile%, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%, 1
		FileCopy, info.txt, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%, 1
	}
	if (fileext = "html")
	{
		IfNotExist, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%
		{
			FileCreateDir, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%
		}
		FileCopy, %proofFile%, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%, 1
		FileCopy, %fileDir%\%filenoext%.js, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%, 1

		IfNotExist, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%\images
		{
			FileCreateDir, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%\images
		}
		FileCopy, %fileDir%\images\*.*, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%\images\*.*, 1
		FileCopy, info.txt, \\ntm-inet-002\wwwroot\digital.ntm.eu\korrektur\%mlOrdernummer%, 1
	}

	if (openLink) 
	{
		Run, http://digital.ntm.eu/korrektur/?%mlOrdernummer%
	}

	SplashTextOn, 400, 60, Förbereder korrekturmail, Korrekturlänken har nu genererats. Nu skapas en rapportlänk.

	gosub, getKorr
	subject = Korrektur för %mlKundnamn% - %mlOrdernummer%
	body = 
(
Hej,
här kommer en länk för granskning av korrektur för ordernummer %mlOrdernummer% (%mlKundnamn%):
http://digital.ntm.eu/korrektur/?%mlOrdernummer%


Vänligen öppna länken och kontrollera korrekturet noggrant. 
Därefter klickar du på "Godkänn" för att skicka ett godkännandemail till producenten eller på "Ändra" för att begära ändringar i korrekturet.

För att följa kampanjens leverans när den har startat och för slutrapport när den gått färdigt besöker du följande länk:
%rapportUrl%


)
	SplashTextOn, 400, 60, Öppnar Outlook, Rapportlänken har nu genererats. Försöker öppna Outlook.
	mail(recipients, subject, body)
	SplashTextOff
return



pythonKorr:
return