SetTitleMatchMode, 2

;
;	Medialink-funktioner
;___________________________________________________________________ 

; Kontrollera om Medialink är aktivt fönster och att användaren klickat i listvyn

mlActive(x=0) ; Returnerar "true" om medialink är det aktiva fönstret och listvyn är under muspekaren.
{
	IfWinActive, NewsCycle MediaLink
	{
	MouseGetPos, , , id, control
	IfInString, control, SysListView
		{
			IfWinActive, NewsCycle MediaLink
			{
				x := true
			}
		}
	return control
	}
}

noteActive(x=0)
{
	MouseGetPos, , , id, control
	IfInString, control, Static29
		{
			; IfWinActive, Atex MediaLink
			; {
			; 	x := true
			; }
			IfWinActive, NewsCycle MediaLink
			{
				x := true
			}
		}
	return x
}

; Kontrollera om högerklicksmenyn är Uppe
rmActive(x=false)
{
		IfWinActive, RightMenu
			{
				x := true
			}
	return x
}

; Kontrollera om print finns på mtrl 01 på ordernumret x
printCheck(x, mnr)
{
	global
	data := false
	StringTrimRight, OrderNummerUtanMnr, x, 3 ; Tar bort tre sista tecken i ordernumret, dvs materialnummer inkl bindestreck
	StringTrimLeft, SistaTvaSiffrorna, OrderNummerUtanMnr, 8 ; Plockar ut sista två siffrorna ur ordernumret
	StringTrimLeft, OrderNummerUtanNollor, OrderNummerUtanMnr, 3 ; Tar bort inledande nollor i ordernumret
	printdir = \\nt.se\Adbase\Annonser\Ad\%SistaTvaSiffrorna%\10%OrderNummerUtanNollor%%mnr%.pdf
	printdir_short = \\nt.se\Adbase\Annonser\Ad\%SistaTvaSiffrorna%\10
	imgdir = \\nt.se\Adbase\Annonser\eProof\%OrderNummerUtanMnr%%mnr%.jpg
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



secondTimer:
		i := i+100
return

replace_split(x, y)
{
	StringReplace, x, x, y, ¤, A
	StringSplit, x, x, ¤
	return x
}

status(x) ; Sätter status enligt x
{
	Send, !s
	WinWaitActive, Change Status
	Control, ChooseString, %x%, ComboBox1
	Send, !o
	log = 
(
-------------------------------------------------`n
Status: %x%
-------------------------------------------------`n
%A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%`n
%me% satte status på ordern till "%x%"`n
`n
)
FileAppend, %log%, %dir_log%\%mlOrdernummer%.txt
}

assign(x) ; tilldelar till x 
{
	gosub, getAnvnamn
	Send, !a
	WinWaitActive, Ändra tilldelad
	Sleep, 200
	Control, ChooseString, %x%, ComboBox1
	Send, !o
		log = 
(
-------------------------------------------------`n
Tilldela: %x%
-------------------------------------------------`n
%A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%`n
%me% tilldelade ordern till "%x%"`n
`n
)
FileAppend, %log%, %dir_log%\%mlOrdernummer%.txt
}

refreshFile(content, file)
{
	FileDelete, %file%
	FileEncoding, UTF-8-RAW
	FileAppend, %content%, %file%
	if (ErrorLevel = 1)
	{
		msgbox, Kunda inte skriva fil till %file%
	}
	FileEncoding
}

stripDash(ByRef x)
{
	StringReplace, x, x,-,,All
}

rensaTecken(ByRef x) ; Rensar ur valda tecken ur en variabel
{
		StringReplace, x, x, &&, &, All
		StringReplace, x, x, &,%A_SPACE% , All
		StringReplace, x, x, /,%A_SPACE%, All
		StringReplace, x, x, \,%A_SPACE%, All
		StringReplace, x, x, :,%A_SPACE%, All
}

forstaBokstav(x)
{
	StringLen, tecken, x
	tecken := tecken - 1
	StringTrimRight, forstaBokstav, x, %tecken%
	return forstaBokstav
}

; Sätter format och file för aktuell order
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
	format := id = "112"		? "380" : format
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

getFormatTraffic(x)
{
	global
	;Skyltar
	if (x = "Eurosize")
		{
		format = 1080x1920
		file = 1080 x 1920
		}
	if (x = "Söderköpingsvägen")
		{
		format = 1024x384	
		file = 1024 x 384
		}
	if (x = "Hamnbron")
		{
		format = 1024x384
		file = 1024 x 384
		}
	if (x = "Sjötull")
		{
		format = 512x128
		file = 512 x 128
		}
	if (x = "Skylt HD")
		{
		format = 1920x1080
		file = 1920 x 1080
		}
	if (x = "Ståthögaleden")
		{
		format = 768x384
		file = 768 x 384
		}
	if (x = "Östcentrum Visby")
		{
		format = 1920x720
		file = 1920 x 720
		}

	; Moduler
	if (x = "Artikel 120")
	{
		format = MOD
		file = 468 x 120
	}
	if (x = "Artikel 60")
	{
		format = MOD
		file = 468 x 60
	}
	if (x = "Mittbanner 1")
	{
		format = MOD
		file = 468 x 240
	}
	if (x = "Modul 240")
	{
		format = MOD
		file = 468 x 240
	}
	if (x = "Modul MK")
	{
		format = MKMOD
	}
	
	; Mobiler
	if (x = "Mobil Bottom Panorama")
	{
		format = MOB
		file = 320 x 80
	}
	if (x = "Mobil Bottom Panorama XL")
	{
		format = MOB
		file = 320 x 160
	}
	if (x = "Mobil Bottom Takeover")
	{
		format = MOB
		file = 320 x 320
	}
	if (x = "Mobil Top Panorama")
	{
		format = MOB
		file = 320 x 80
	}
	if (x = "Mobil Top Panorama XL")
	{
		format = MOB
		file = 320 x 160
	}
	if (x = "Mobil Top Takeover")
	{
		format = MOB
		file = 320 x 320
	}
	if (x = "Mobil Stor")
	{
		format = MOB
		file = 320 x 320
	}
	if (x = "Mobil Mellan")
	{
		format = MOB
		file = 320 x 160
	}
	if (x = "Mobil Liten")
	{
		format = MOB
		file = 320 x 80
	}
	if (x = "Mobil Swipe")
	{
		format = MOB
		file = 320 x 320
	}
	; -- Nya Mobiler
	if (x = "Panorama")
	{
		format = MOB
		file = 320 x 80
	}
	if (x = "Mobil Panorama Double")
	{
		format = MOB
		file = 320 x 160
	}
	if (x = "Mobil Panorama Large")
	{
		format = MOB
		file = 320 x 320
	}
	if (x = "Mobil Take Over")
	{
		format = MOB
		file = 320 x 480
	}

	; Outsider
	if (x = "Outsider 600")
	{
		format = OUT
		file = 250 x 600
	}
	if (x = "Outsider 800")
	{
		format = OUT
		file = 250 x 800
	}
	if (x = "Skyskrapa")
	{
		format = OUT
		file = 250 x 600
	}

	; Panorama
	if (x = "Panorama")
	{
		format = PAN
		file = 980 x 240
	}
	if (x = "Panorama 1 120")
	{
		format = PAN
		file = 980 x 120
	}
	if (x = "Panorama 1 240")
	{
		format = PAN	
		file = 980 x 240
	}
	
	if (x = "Panorama 480")
	{
		format = PAN	
		file = 980 x 480
	}
	
	if (x = "Panorama 120")
	{
		format = PAN
		file = 980 x 120
	}
	if (x = "Panorama 2 120")
	{
		format = PAN
		file = 980 x 120
	}
	if (x = "Panorama 2 240")
	{
		format = PAN
		file = 980 x 240
	}
	if (x = "Panorama 2 480")
	{
		format = PAN
		file = 980 x 480
	}
	if (x = "Panorama 240")
	{
		format = PAN
		file = 980 x 240
	}
	if (x = "Panorama 360")
	{
		format = PAN
		file = 980 x 360
	}

	if (x = "Portal 980")
	{
		format = PAN
		file = 980 x 360
	}

	if (x = "Bigbanner XL")
	{
		format = PAN
		file = 980 x 360
	}



	; Widescreen
	if (x = "Widescreen 240")
	{
		format = WID
		file = 250 x 240
	}

	if (x = "Guld")
	{
		format = WID
		file = 250 x 240
	}

	if (x = "Annonstorget WS")
	{
		format = TORGET
		file = 250 x 240
	}

	; Portaler
	if (x = "Kvadrat")
	{
		format = 180
		file = 180 x 180
	}
	if (x = "Portal 180")
	{
		format = 180
		file = 180 x 180
	}
	if (x = "Stortavla")
	{
		format = 380
		file = 380 x 280
	}

	if (x = "Portal 380")
	{
		format = 380
		file = 380 x 280
	}

	if (x = "Portal 580")
	{
		format = 580
		file = 580 x 280
	}
	if (x = "Textannons")
	{
		format = TXT
	}

	; Reach
	if (x = "Reach 250")
	{
		format = REACH250
		file = 250 x 360
	}
	if (x = "Reach 468")
	{
		format = REACH468
		file = 468 x 240
	}

	; Väder
	if (x = "Väderspons")
	{
		format = VADER
	}
	
	if (x = "Julkalender")
	{
		format = MOB
	}

	if (x = "Helsida")
	{
		format = HEL
	}
	return format

	; Artikel
	if (x = "Artikel 60")
	{
		format = ARTIKEL
	}
	if (x = "Artikel 120")
	{
		format = ARTIKEL
	}if (x = "Artikel 240")
	{
		format = ARTIKEL
	}
	return format

}

; hämtar productID, sitetargetingID och keywordID för aktuell bokning
cxProduct(format, type)
{
	;global ; Alla variabler är globala
	output := {}
	; Annonstorget --------------------------------
	if (format = "TORGET")	
	{
		cxName := "Annonstorget"
		cost := "cpm"
	}


	; Reach ---------------------------------------
	if (format = "REACH250" && type = "Run On Site")	
	{
		cxName := "Reach"
		cost := "cpm"
	}
	if (format = "REACH468" && type = "Run On Site")	
	{
		cxName := "Reach"
		cost := "cpm"
	}
	

	; Widescreen ----------------------------------
	if (format = "WID" && type = "Run On Site")	
	{
		cxName := "- ROS - Widescreen"
		cost := "cpm"
	}

	if (format = "WID" && type = "Riktad")
	{
		cxName := "- RIKTAD - Widescreen"
		cost := "cpm"
	}

	if (format = "WID" && type = "Plugg")
	{
		cxName := ". PLUGG - Widescreen - CPC"
		cost := "cpc"
	}

	; Modul ---------------------------------------
	if (format = "MOD" && type = "Run On Site")	
	{
		cxName := "- ROS - Modul"
		cost := "cpm"
	}

	if (format = "MOD" && type = "Riktad")
	{
		cxName := "- RIKTAD - Modul"
		cost := "cpm"
	}

	if (format = "MOD" && type = "Plugg")
	{
		cxName := ". PLUGG - Modul - CPC"
		cost := "cpc"
	}

	if (format = "MOD" && type = "CPC")
	{
		cxName := "CPC - Modul"
		cost := "cpc"
	}

	; Panorama ------------------------------------
	if (format = "PAN" && type = "Run On Site")	
	{
		cxName := "- ROS - Panorama"
		cost := "cpm"
	}

	if (format = "PAN" && type = "Riktad")
	{
		cxName := "- RIKTAD - Panorama"
		cost := "cpm"
	}

	if (format = "PAN" && type = "Plugg")
	{
		cxName := ". PLUGG - Panorama - CPC"
		cost := "cpc"
	}

	if (format = "PAN" && type = "CPC")
	{
		cxName := "CPC - Panorama"
		cost := "cpc"
	}

	if (format = "PAN" && type = "Retarget")
	{
		cxName := "RETARGET - Panorama"
		cost := "cpc"
	}

	; Outsider ------------------------------------
	if (format = "OUT" && type = "Run On Site")	
	{
		cxName := "- ROS - Outsider"
		cost := "cpm"
	}

	if (format = "OUT" && type = "Riktad")
	{
		cxName := "- RIKTAD - Outsider"
		cost := "cpm"
	}

	if (format = "OUT" && type = "Plugg")
	{
		cxName := ". PLUGG - Outsider - CPC"
		cost := "cpc"
	}

	; Mobil ---------------------------------------
	if (format = "MOB" && type = "Run On Site")	
	{
		cxName := "- ROS - Mobil"
		cost := "cpm"
	}

	if (format = "MOB" && type = "Plugg")
	{	
		cxName := ". PLUGG - Mobil - CPC"
		cost := "cpc"
	}

	if (format = "MOB" && type = "Retarget")
	{	
		cxName := "RETRARGET - Mobil"
		cost := "cpc"
	}

	if (format = "MOB" && type = "Riktad")
	{	
		cxName := "- ROS - Mobil"
		cost := "cpc"
	}

	; Portal 180 ----------------------------------
	if (format = "180" && type = "Run On Site")	
	{
		cxName := "- ROS - 180"
		cost := "cpc"
	}

	if (format = "TXT" && type = "Run On Site")	
	{
		cxName := "- ROS - Textannons"
		cost := "cpc"
	}

	if (format = "TXT" && type = "Riktad")	
	{
		cxName := "- ROS - Textannons"
		cost := "cpc"
	}

	if (format = "180" && type = "Plugg")	
	{
		cxName := ". PLUGG - 180 - CPC"
		cost := "cpc"
	}

	if (format = "TXT" && type = "Plugg")	
	{
		cxName := "- ROS - Textannons"
		cost := "cpc"
	}

	if (format = "180" && type = "CPC")	
	{
		cxName := "- ROS - 180"
		cost := "cpc"
	}

	if (format = "TXT" && type = "CPC")	
	{
		cxName := "- ROS - Textannons"
		cost := "cpc"
	}

	if (format = "180" && type = "Riktad")	
	{
		cxName := "- ROS - 180"
		cost := "cpc"
	}

	; Portal 380 ----------------------------------
	if (format = "380" && type = "Run On Site")	
	{ 
		cxName := "- ROS - 380"
		cost := "cpc"
	}

	if (format = "380" && type = "Plugg")	
	{
		cxName := ". PLUGG - 380 - CPC"
		cost := "cpc"
	}

	if (format = "380" && type = "CPC")	
	{
		cxName := "- ROS - 380"
		cost := "cpc"
	}

	if (format = "380" && type = "Riktad")	
	{
		cxName := "- ROS - 380"
		cost := "cpc"
	}

	; Portal 580 ----------------------------------
	if (format = "580" && type = "Run On Site")	
	{
		cxName := "- ROS - 580"
		cost := "cpc" 
	}

	if (format = "580" && type = "Plugg")	
	{
		cxName := ". PLUGG - 580 - CPC"
		cost := "cpc"
	}

	if (format = "580" && type = "CPC")	
	{
		cxName := "- ROS - 580"
		cost := "cpc"
	}

	if (format = "580" && type = "Riktad")	
	{
		cxName := "- ROS - 580"
		cost := "cpc"
	}

	; Textannons ----------------------------------
	if (format = "TXT" && type = "Run On Site")	
	{
		cxName := "- ROS - Textannons"
		cost := "cpc"
	}

	if (format = "TXT" && type = "Plugg")	
	{
		cxName := ". PLUGG - Textannons"
		cost := "cpc"
	}

	; Helsida -------------------------------------
	if (format = "HEL")	
	{
		cxName := "Helsida"
		cost := "cpm"
	}

	; MK Modul ------------------------------------
	if (format = "MKMOD")	
	{
		cxName := "Mediekompaniet 468"
		cost := "cpm"
	}

	; Snurra --------------------------------------
	if (format = "SNURRA")	
	{
		cxName := "Snurran"
		cost := "cpc"
	}

	; Artikel -------------------------------------
	if (format = "ARTIKEL")
	{
		cxName := "- RIKTAD - Modul"
		cost := "cpm"
	}


	xml := get_url("cxad.cxense.com/api/secure/products")
	product := cost "Product"
	productId := cx_xml_read(xml, product, cxName, "productId") ; Sätter productId
	output.Insert("prodID", productId)
	output.Insert("cost", cost)


	StringReplace, splitXml, xml, cx:,, All ; Tar bort CX: namespace
	prod := "<" product ">" ; ex. "cpmProduct"
	StringReplace, splitXml, splitXml, `<cpmProduct`>, ~, A
	StringReplace, splitXml, splitXml, `</cpmProduct`>, ~, A
	StringReplace, splitXml, splitXml, `<cpcProduct`>, ~, A
	StringReplace, splitXml, splitXml, `</cpcProduct`>, ~, A

	Loop, parse, splitXml, ~ ; loopar genom alla produkter
	{	
		IfInString, A_LoopField, %productId%
		{
			StringReplace, step1, A_LoopField, `<template`>, §, A
			Loop, parse, step1, §
			{
				site = false
				keyword = false
				IfInString, A_LoopField, Site Targeting
				{
					regex := "<templateId>(.{16})</templateId>"
	      			RegExMatch(A_LoopField, regex,tmplid)
	      			siteTargetingId := tmplid1 ; Sätter site targeting
	      			output.Insert("siteTargetingID", siteTargetingId)
	      			site = true
      			}
      			IfInString, A_LoopField, Keywords
      			{
	      			regex := "<templateId>(.{16})</templateId>"
	      			RegExMatch(A_LoopField, regex,tmplid)
	      			keywordsId := tmplid1 ; Sätter keywords
	      			output.Insert("keywordsID", keywordsId)
	      			keyword = true
      			}
      			if (site = true && keyword = true)
      			{
      				return output
      				break
      			}
			}
		}
	}
	return output
}

; Maila säljare
mail(mail, subject, body)
{
	gosub, getList
	SetKeyDelay, -1, -1
	IfExist, C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE
		Run, C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE /c IPM.Note
	IfExist, C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE
		Run, C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE /c IPM.Note
	WinWaitActive, Namnlös - Meddelande
	Sleep, 200
	clipTemp := Clipboard
	
	Clipboard := mail
	ControlFocus, RichEdit20WPT1, Namnlös - Meddelande
	sleep, 100
	Send, ^v
	sleep, 300

	Clipboard := subject
	ControlFocus, RichEdit20WPT4, Namnlös - Meddelande
	sleep, 100
	Send, ^v {Tab}
	sleep, 300

	Clipboard := body
	ControlFocus, _WwG1, Namnlös - Meddelande
	sleep, 100
	Send, %body%

	Sleep, 100
	Clipboard := clipTemp
}

; Maila säljare (snabb)
qmail(mail, subject, body)
{
	SetKeyDelay, -1, -1
	IfExist, C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE
		Run, C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE /c IPM.Note
	IfExist, C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE
		Run, C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE /c IPM.Note
	WinWaitActive, Namnlös - Meddelande
	Sleep, 200
	clipTemp := Clipboard
	
	Clipboard := mail
	ControlFocus, RichEdit20WPT1, Namnlös - Meddelande
	sleep, 100
	Send, ^v
	sleep, 300

	Clipboard := subject
	ControlFocus, RichEdit20WPT4, Namnlös - Meddelande
	sleep, 100
	Send, ^v {Tab}
	sleep, 300

	Clipboard := body
	ControlFocus, _WwG1, Namnlös - Meddelande
	sleep, 100
	Send, ^v

	Sleep, 100
	Clipboard := clipTemp
}


SplashImageGUI(Picture, X, Y, Duration, Transparent = false)
{
Gui, XPT99:Margin , 0, 0
Gui, XPT99:Add, Picture,, %Picture%
Gui, XPT99:Color, ECE9D8
Gui, XPT99:+LastFound -Caption +AlwaysOnTop +ToolWindow -Border
If Transparent
{
Winset, TransColor, ECE9D8
}
Gui, XPT99:Show, x%X% y%Y% NoActivate
SetTimer, DestroySplashGUI, -%Duration%
return

DestroySplashGUI:
Gui, XPT99:Destroy
return
}

getCustId(kundnr)
{
	xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
	StringReplace, xml, xml, <cx:childFolder>, ¤, A
	StringSplit, xml, xml , ¤
	Loop, parse, xml, ¤
	{
		IfInString, A_LoopField, %kundnr%
		{
			RegExMatch(A_LoopField, ">([a-z0-9]{16})<", match)
			return match1
		}
	}
}



ab_auth(x=true)
{
	ACTION = http://www.atex.com/adbase/v3.3.1/utilities/Authenticate
	HEAD = SOAPAction: %ACTION%
	URL = http://ntm-adbase-003/AdBaseService/Utilities.asmx?op=Authenticate
	DATA = 
	(
	<?xml version="1.0" encoding="utf-16"?>
	<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	  <soap:Body>
	    <Authenticate xmlns="http://www.atex.com/adbase/v3.3.1/utilities">
	      <username>dennisst</username>
	      <password>dest2013</password>
	    </Authenticate>
	  </soap:Body>
	</soap:Envelope>
	)
	OPTS = 
	HTTPRequest(URL, DATA, HEAD, OPTS)

	regex = ms)<AuthenticationToken>(.+?)</AuthenticationToken>
	RegExMatch(DATA, regex, catch)
	AUTH := catch1
	return AUTH
}

ab_getOrderByNumber(number)
{
	global AUTH

	StringSplit, number, number,-
	number := number1

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

ab_find(name, DATA)
{
	regex = ms)<%name%>(.+?)</%name%>
	RegExMatch(DATA, regex, catch)
	StringReplace, catch1, catch1, &amp`;, &, A
	return catch1
}

ab_findSub(name, sub, DATA)
{
	regex = ms)<%name%>.+?<%sub%>(.+?)</%sub%>.+?</%name%>
	RegExMatch(DATA, regex, catch)
	StringReplace, catch1, catch1, &amp`;, &, A
	return catch1
}

ab_campaignSplit(DATA, split, number)
{
	StringSplit, number, number,-
	number := number1
	mnr := number2

	campaign = %number%-%mnr%
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
	if (campaignArray%i% = "")
	{
		; msgbox, hittade inget
	}
	return
}

ab_fixTime(ByRef time)
{
	StringTrimRight, month, time, 6
	StringTrimLeft, year, time, 4

	StringTrimLeft, temp, time, 2
	StringTrimRight, day, temp, 4

	time = %year%-%month%-%day%
}

list_files(Directory)
{
	files =
	Loop %Directory%\*.*, 1
	{
		if (A_LoopFileExt = "")
		{
			files = %files%`n+ %A_LoopFileName%
		} 
		else
		{
			files = %files%`n%A_LoopFileName%
		}
	}
	return files
} 

find_user(u)
{
	user2 = 
	Loop, read, %A_WorkingDir%\users.txt
	{
		IfInString, A_LoopReadLine, %u%
		{
			StringSplit, user, A_LoopReadLine, :
			return user2
		}
	}
	if(!user2)
	{
		return "Hittade inte användare"
	}
}

;
; SAXAT FRÅN ML+4
;
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
	CfInUnitType.width 					as 'Bredd'	

FROM aoincampaign
LEFT JOIN AoInflight 			ON aoinflight.campaignid 				= aoincampaign.id
LEFT JOIN AoProducts 			ON AoProducts.Id 							= aoinflight.siteID
LEFT JOIN CfInUnitType 		ON CfInUnitType.Id 						= aoinflight.internetunitid
LEFT JOIN AoOrderCustomers 	ON AoOrderCustomers.AdOrderId			= aoinflight.adorderid
LEFT JOIN Customer 				ON Customer.AccountId					= AoOrderCustomers.CustomerId 
LEFT JOIN AoAdOrder 			ON AoAdOrder.Id 							= AoInCampaign.AdOrderId
LEFT JOIN AoSpecialPrice 		ON AoSpecialPrice.AoInFlightId		= AoInflight.Id
LEFT JOIN UsrUsers				ON UsrUsers.UserId						= AoAdOrder.SellerId

WHERE 
	campaigntypeid IN (1,4,8)
	AND Customer.TypeID IN (1,2,6,16)
	AND aoincampaign.campaignnumber = '%onr%'
)
	query := ADOSQL(Connectstring, Query)

	; Kolumner
	c_imps 				:= 2
	c_startdate 		:= 3
	c_enddate 			:= 4
	c_product 			:= 5
	c_unit_id 			:= 6
	c_customer_nr 		:= 8
	c_customer_name 	:= 9
	c_net_price 		:= 11
	c_special_price 	:= 12
	c_email 			:= 13
	c_height 			:= 14
	c_width 			:= 15

	order.customer_name := query[2, c_customer_name]
	order.customer_nr := query[2, c_customer_nr]
	order.imps := query[2, c_imps]
	imps := query[2, c_imps]
	order.startdate := query[2, c_startdate]
	order.enddate := query[2, c_enddate]
	unit_id := query[2, c_unit_id]
	order.unit_id := query[2, c_unit_id]
	product := query[2, c_product]	
	order.product := query[2, c_product]	
	order.format := getFormat(unit_id)
	product_split := StrSplit(product, A_Space)
	order.paper := product_split[1]
	order.site := product_split[2]
	order.net_price := Round(query[2, c_net_price])
	order.special_price := Round(query[2, c_special_price])
	special_price := Round(query[2, c_special_price])
	order.CPM := Round(special_price/(imps/1000))
	order.email := query[2,c_email]
	order.height := query[2,c_height]
	order.width := query[2,c_width]

	; msgbox % ADOSQL_LastError	
	return order
}
