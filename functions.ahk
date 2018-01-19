SetTitleMatchMode, 2

;
;	Medialink-funktioner
;___________________________________________________________________ 

; Kontrollera om Medialink är aktivt fönster och att användaren klickat i listvyn

mlActive(x=false)
{
	IfWinActive, NewsCycle MediaLink ; Om det aktiva fönstrets titelrad innehåller "NewsCycle MediaLink"
	{
		MouseGetPos, pos_x, pos_y, win_name, control ; Spara namnet på den control som är under muspekaren och lagra det i %control%
		if (InStr(control, "SysListView")) ; Om %control% innehåller "SysListView"
		{
			return control ; returnera 'true'
		}
		return false ; returnerar 'false'
	}
	return false ; MediaLink är inte det aktiva fönstret.
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

status_reason(x, r)
{
	Send, !s
	WinWaitActive, Change Status
	Send, % r
	Control, ChooseString, %x%, ComboBox1
	Send, !o
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
	SplashImage, Off
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
WinWaitClose, Ändra tilldelad,, 10
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

prio(x) ;Sätter prio enligt x
{
	Send, !d
	WinWaitActive, Tilldela komplexitet
	Control, ChooseString, %x%, ComboBox1
	Send, !o
	log = 
(
-------------------------------------------------`n
Prio: %x%
-------------------------------------------------`n
%A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%`n
%me% satte prio på ordern till "%x%"`n
`n
)
FileAppend, %log%, %dir_log%\%mlOrdernummer%.txt
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
	format := id = "299"		? "MOB" : format ; Mobil swipe bokas i vanligt mobiladspace
	format := id = "19"			? "VADER" : format ; Mobil swipe bokas i vanligt mobiladspace



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

	if (x = "Portal 350")
	{
		format = 350
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
	}
	if (x = "Artikel 240")
	{
		format = ARTIKEL
	}
	if (x = "Väderspons")
	{
		format = VADER
	}
	return format

}

; hämtar productID, sitetargetingID och keywordID för aktuell bokning
cxProduct(format, type)
{
	if (type = "Backfill")
	{
		type = Plugg
	}
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

	if (format = "WID" && type = "CPC")
	{
		cxName := "- RIKTAD - Widescreen - CPC"
		cost := "cpc"
	}

	if (format = "WID" && type = "Plugg")
	{
		cxName := "- ROS - Widescreen"
		cost := "cpm"
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
		cxName := "- ROS - Modul"
		cost := "cpm"
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
		cxName := "- ROS - Panorama"
		cost := "cpm"
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
		cxName := "- ROS - Outsider"
		cost := "cpm"
	}

	if (format = "OUT" && type = "CPC")
	{
		cxName := "CPC - Outsider"
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
		cxName := "- ROS - Mobil"
		cost := "cpm"
	}

	if (format = "MOB" && type = "Retarget")
	{	
		cxName := "RETRARGET - Mobil"
		cost := "cpc"
	}

	if (format = "MOB" && type = "Riktad")
	{	
		cxName := "Mobil - RIKTAD - CPM"
		cost := "cpm"
	}

	if (format = "MOB" && type = "CPC")
	{	
		cxName := "Mobil - CPC"
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

	; Portal 350 ----------------------------------

	if (format = "350")	
	{ 
		cxName := "- ROS - 350 - CPC"
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
		cxName := "Modul - RIKTAD - CPM"
		cost := "cpm"
	}

	; VÄDER ---------------------------------------
	if (format = "VADER")
	{
		cxName := "Väderspons - RIKTAD - CPC"
		cost := "cpc"
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
	SetKeyDelay, 0,0 
	IfExist, C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE
		Run, C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE /c IPM.Note
	IfExist, C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE
		Run, C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE /c IPM.Note
	IfExist, C:\Program Files (x86)\Microsoft Office\Office16\OUTLOOK.EXE
	{
		sleep, 100
		Run, C:\Program Files (x86)\Microsoft Office\Office16\OUTLOOK.EXE /c IPM.Note
	}
	IfExist, C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE
	{
		sleep, 100
		Run, C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE /c IPM.Note
	}
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
	console_log(body)
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
	IfExist, C:\Program Files (x86)\Microsoft Office\Office16\OUTLOOK.EXE
	{
		sleep, 100
		Run, C:\Program Files (x86)\Microsoft Office\Office16\OUTLOOK.EXE /c IPM.Note
	}
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
Gui, XPT99:Show, x%X% y%Y% NoActivate, splash
Winset, transparent, 0, splash

transvar := 0
steps := 10

Loop
{
	transvar := transvar+steps
	WinSet, Transparent, %transvar%, splash
	sleep 10
	if (transvar > 255)
	{
		break
	}
} 

SetTimer, DestroySplashGUI, -%Duration%
return

DestroySplashGUI:
transvar := 255
steps := 5

Loop
{
	transvar := transvar-steps
	WinSet, Transparent, %transvar%, splash
	sleep 10
	if (transvar < 1)
	{
		break
	}
} 
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
	CfInUnitType.width 					as 'Bredd',
	CfInCampaignCategory.Name			as 'Kampanjkategori',
	convert(varchar(max), convert(varbinary(8000),shblobdata.blobdata)) as 'Interna noteringar',
	AoAdOrder.CreateDate					as 'Skapad datum',
	AoAdOrder.LastEditDate				as 'Senast ändrad',
	CfInSection.Name						as 'Sektion',
	UsrUsers.UserFname					as 'Säljare förnamn',
	UsrUsers.UserLname					as 'Säljare efternamn',
	aoinflight.price						as 'flightpris',
	CfInViewType.Name						as 'Visningstyp'

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
LEFT JOIN CfInViewType 			ON  CfInViewType.Id						= AoInCampaign.ViewType

WHERE 
	CampaignNumber = '%onr%'
	AND AoOrderCustomers.OrderedBy = '1'
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
	c_viewtype := 24

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
	fprice 					:= query[2,c_fprice]
	order.CPM 				:= Round(fprice/(imps/1000))
	order.email 			:= query[2, c_email]
	order.height 			:= query[2,c_height]
	order.width 			:= query[2,c_width]
	order.internalnotes 	:= query[2,c_internalnotes]
	order.createdate 		:= query[2,c_createdate]
	order.changedate 		:= query[2,c_changedate]
	order.section 			:= query[2,c_section]
	order.fname 			:= query[2,c_fname]
	order.lname 			:= query[2,c_lname]
	order.fprice 			:= query[2,c_fprice]
	order.viewType 			:= query[2,c_viewtype]
	; if (ADOSQL_LastError)
		; msgbox % ADOSQL_LastError	
	return order
}

getOwner(customernumber)
{
	ConnectString := "Provider=SQLOLEDB.1;Password=adops2015;Persist Security Info=True;User ID=adops;Initial Catalog=adbprod;Data Source=adbasedb1.nt.se;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
	; Query = SELECT campaignnumber, quantityrequested, startdate, enddate FROM AoInCampaign WHERE startdate >= '%startdate%' AND enddate <= '%enddate%'
	Query =
(
	select 
			accountnumber,
			Name1,
			UsrUsers.LoginName,
			ShCompanies.Name
		from Customer
		left join UsrUsers on UsrUsers.UserId = Customer.PrimarySalesPersonId
		left join ShCompanies on ShCompanies.Id = Customer.CompanyId
		where
			accountnumber like '%customernumber%' and
			Customer.BookingStatusCode = 0
		order by accountnumber
)
	query := ADOSQL(ConnectString, query)
	return query[2,4]
}


getUser(username)
{
	user := Object()
	ConnectString := "Provider=SQLOLEDB.1;Password=adops2015;Persist Security Info=True;User ID=adops;Initial Catalog=adbprod;Data Source=adbasedb1.nt.se;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
	; Query = SELECT campaignnumber, quantityrequested, startdate, enddate FROM AoInCampaign WHERE startdate >= '%startdate%' AND enddate <= '%enddate%'
	Query := "SELECT userfname, userlname, emailaddress FROM usrusers WHERE loginname = '" . username . "'"
	query := ADOSQL(ConnectString, query)
	if (ADOSQL_LastError)
		msgbox % ADOSQL_LastError	

	user.fname := query[2, 1]
	user.lname := query[2, 2]
	user.email := query[2, 3]
	return user
}

getComponents(ordernr)
{
	result := []
	ConnectString := "Provider=SQLOLEDB.1;Password=adops2015;Persist Security Info=True;User ID=adops;Initial Catalog=adbprod;Data Source=adbasedb1.nt.se;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
	; Query = SELECT campaignnumber, quantityrequested, startdate, enddate FROM AoInCampaign WHERE startdate >= '%startdate%' AND enddate <= '%enddate%'
	Query =
(
SELECT 
	ml_graphicascustomer.GRAPHICADLOGOID as 'logo-id',
	ML_GraphicAdLogo.Description as 'logo-namn',
	ML_GraphicAdLogo.datecreated as 'tid komp',
	ML_GraphicAdLogo.StatusId as 'Finns?',
	ML_GRAPHICTYPE.DISPLAYNAME as 'Extension'


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
LEFT JOIN ML_GRAPHICASINTERNETADINFO ON ML_GRAPHICASINTERNETADINFO.CAMPAIGNID = AoInCampaign.Id
LEFT JOIN ml_graphicascustomer on ml_graphicascustomer.customeraccountid = AoOrderCustomers.CustomerId
LEFT JOIN ML_GraphicAdLogo	  		ON ML_GraphicAdLogo.GraphicAdLogoId		= ml_graphicascustomer.GRAPHICADLOGOID
LEFT JOIN ML_GRAPHICTYPE		ON ML_GRAPHICTYPE.ID						=ML_GraphicAdLogo.GraphicType

WHERE CampaignNumber = '%ordernr%'
AND AoOrderCustomers.OrderedBy = '1'
)

query := ADOSQL(ConnectString, query)

Loop % query.MaxIndex()
{
	i := A_Index + 1
	if (query[i,2])
	{
		arr := Object()
		arr.id := query[i,1]
		arr.desc := query[i,2]
		arr.create := query[i,3]
		arr.ext := query[i,5]
		result.push(arr)
	}
}
return result
}

getComponentsOnOrder(ordernr)
{
	result := []
	ConnectString := "Provider=SQLOLEDB.1;Password=adops2015;Persist Security Info=True;User ID=adops;Initial Catalog=adbprod;Data Source=adbasedb1.nt.se;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
	; Query = SELECT campaignnumber, quantityrequested, startdate, enddate FROM AoInCampaign WHERE startdate >= '%startdate%' AND enddate <= '%enddate%'
	Query =
(
SELECT 
	ML_GRAPHICASINTERNETADINFO.GRAPHICADLOGOID AS 'Komponent-ID',
	ML_GraphicAdLogo.Description AS 'Komponentnamn',
	ML_GraphicAdLogo.DateCreated 				AS 'Skapad',
	ML_GRAPHICTYPE.PCEXTENSION AS 'Filändelse'
FROM
	AoInCampaign
LEFT JOIN ML_GRAPHICASINTERNETADINFO ON ML_GRAPHICASINTERNETADINFO.CAMPAIGNID = AoInCampaign.Id
LEFT JOIN ML_GraphicAdLogo ON ML_GraphicAdLogo.GraphicAdLogoId = ML_GRAPHICASINTERNETADINFO.GRAPHICADLOGOID
LEFT JOIN ML_GRAPHICTYPE ON ML_GRAPHICTYPE.ID = ML_GraphicAdLogo.GraphicType
WHERE
	AoInCampaign.CampaignNumber = '%ordernr%'
)
console_log(query)
query := ADOSQL(ConnectString, query)
Loop % query.MaxIndex()
{
	i := A_Index + 1
	if (query[i,2])
	{
		arr := Object()
		arr.id := query[i,1]
		arr.desc := query[i,2]
		arr.create := query[i,3]
		arr.ext := query[i,4]
		result.push(arr)
	}
}
return result
}


getTime()
{
	o := Object()
	FormatTime, here, %A_Now%, HH
	FormatTime, there, %A_NowUTC%, HH
	o.local := here
	o.utc := there
	o.diff := here - there
	return o
}

timeDiff(start, stopp)
{
	StringReplace, stopp, stopp, -,, All
	FormatTime, start,,yyyyMMdd
	distance := dateto := stopp
	distance -= start, days
	return distance
}


; ******************************************************************************************
; *  drawRect()
; * ----------------------------------------------------------------------------------------
; * Ritar en rektangel (endast ram) med progressbars
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - Bredd i px
; * - Höjd i px
; * - Position i x
; * - Position i y
; * - Färg på ram
; * - Eventuellt UI-id att knyta rektangeln till
; * - Eventuell skugga på rektangel
; * - Eventuellt namn (vXxxxx) på rektangeln för att kunna ändra mha GuiControl
; * 
; *   Exempel:
; *	  Om name sätts till "myBox" heter kantlinjen "myBoxB" följt av den kantlinje man anropar: 
; *   Top = T, Bottom = B, Left = L, Right = R.
; *   
; *   Översta kantlinjen i exemplet heter då alltså "myBoxBT".
; *
; * OUTPUT:
; * - Inget
; *
; ******************************************************************************************

drawRect(w, h, x, y, color, uiid = "", shadow := false, name := "")
{
	global
	local thisUiid 
	thisUiid = %uiid%:
	if (name)
	{
		Gui, %thisUiid%Add, Progress, x%x% y%y% w%w% h1 background%color% v%name%BT ; top line
		Gui, %thisUiid%Add, Progress, xp yp w1 h%h% background%color% v%name%BL ; left line
		rx := w+x
		Gui, %thisUiid%Add, Progress, x%rx% yp w1 h%h% background%color% v%name%BR ; right line
	}
	else
	{
		Gui, %thisUiid%Add, Progress, x%x% y%y% w%w% h1 background%color% ; top line
		Gui, %thisUiid%Add, Progress, xp yp w1 h%h% background%color% ; left line
		rx := w+x
		Gui, %thisUiid%Add, Progress, x%rx% yp w1 h%h% background%color% ; right line
	}
	if (shadow)
	{
		Gui, %thisUiid%Add, Progress, xp+1 yp+1 hp wp backgroundE0E0E0 ; right 1
		Gui, %thisUiid%Add, Progress, xp+1 yp+1 hp wp backgroundEAEAEA ; right 1
		Gui, %thisUiid%Add, Progress, xp+1 yp+1 hp wp backgroundF0F0F0 ; right 1
	}

	by := y+h
	bw := w+1
	if (name)
	{
		Gui, %thisUiid%Add, Progress, x%x% y%by% w%bw% h1 background%color% v%name%BB ; bottom line
	}
	Else
	{
		Gui, %thisUiid%Add, Progress, x%x% y%by% w%bw% h1 background%color% ; bottom line
	}
	if (shadow)
	{
		Gui, %thisUiid%Add, Progress, xp+1 yp+1 hp wp backgroundE0E0E0 ; bottom 1
		Gui, %thisUiid%Add, Progress, xp+1 yp+1 hp wp backgroundEAEAEA ; bottom 1
		Gui, %thisUiid%Add, Progress, xp+1 yp+1 hp wp backgroundF0F0F0 ; bottom 1
	}
}


; ******************************************************************************************
; *  drawFilledRect()
; * ----------------------------------------------------------------------------------------
; * Ritar en rektangel med progressbars. Kantlinjer och innehållsfärg sätts separat.
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - Bredd i px
; * - Höjd i px
; * - Position i x
; * - Position i y
; * - Färg på ram
; * - Färg på innehåll
; * - Eventuellt UI-id att knyta rektangeln till
; * - Eventuell skugga på rektangeln
; * - Eventuellt namn (vXxxxx) på den inre rektangeln för att kunna ändra mha GuiControl. 
; *   '--> Kantlinjens namn blir då angivet namn + "B" + kantlinjens position. 
; *   
; *   Exempel:
; *	  Om name sätts till "myBox" heter den inre rektangeln "myBox" och den övre kantlinjen
; *	  heter "myBoxB" följt av den kantlinje man anropar: 
; *   Top = T, Bottom = B, Left = L, Right = R.
; *   
; *   Översta kantlinjen i exemplet heter då alltså "myBoxBT".
; *
; *
; * OUTPUT:
; * - Inget
; *
; ******************************************************************************************

drawFilledRect(w, h, x, y, color, bcolor, uiid = "", shadow := false, name := "")
{
	global
	local thisUiid
	thisUiid = %uiid%:
	if (name)
	{
		Gui, %thisUiid%Add, Progress, x%x% y%y% w%w% h%h% background%bcolor% v%name% ; fill
	}
	else
	{
		Gui, %thisUiid%Add, Progress, x%x% y%y% w%w% h%h% background%bcolor% ; fill
	}
	drawRect(w, h, x, y, color, uiid, shadow, name) ; rect
}

stripLocal(text)
{
	StringReplace, text, text, å, a, All
 	StringReplace, text, text, ä, a, All
  	StringReplace, text, text, ö, o, All
  	return text
}

; ******************************************************************************************
; *  openPhotoshop()
; * ----------------------------------------------------------------------------------------
; * Hämtar och returnerar url till print-pdf och eProof på vald post i MediaLink
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - Komplett ordernummer (0001234567-89)
; *
; * OUTPUT:
; * - Inget
; *
; ******************************************************************************************

openPhotoshop(order)
{
	adbase := getExtendedOrder(order)
	customer_name := adbase.customer_name
	unit_name := adbase.unit_name
	start_date := adbase.startdate
	dir := getCustomerDir(customer_name, start_date)
	StringReplace, start_date, start_date, - ,, All
	StringTrimLeft, start_date, start_date, 2
	StringUpper, unit_upper, unit_name
	unit_short := SubStr(unit_upper, 1, 3)
	width := adbase.width
	height := adbase.height
	paper := adbase.paper
	if (width = 320)
		{
			height *= 2
			width *= 2
		}
	format := getFormat(adbase.unit_id)

	path := dir.path . "\" . start_date
	IfNotExist, %path%
		FileCreateDir, %path%
		
	StringReplace, path, path, \, /, All
	; msgbox % path
	script =
	(
documents.add("%width%px", "%height%px");
app.activeDocument.saveAs(new File('%path%/%paper%%format% - %customer_name% - %start_date%'));
	)
	; msgbox % script
	FileDelete, ps_temp_script.jsx
	FileAppend, %script%, ps_temp_script.jsx
	Run, photoshop.exe %A_ScriptDir%\ps_temp_script.jsx
}

; ******************************************************************************************
; *  openAnimate()
; * ----------------------------------------------------------------------------------------
; * Skapar ett nytt dokument i Adobe Animate som matchar vald annons. 
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - Ordernummer
; *
; * OUTPUT:
; * - Ett nytt Animate-dokument i rätt kundmapp
; *
; ******************************************************************************************

openAnimate(order)
{
	global skylt
	adbase := getExtendedOrder(order)
	customer_name := adbase.customer_name
	unit_name := adbase.unit_name
	start_date := adbase.startdate
	dir := getCustomerDir(customer_name, start_date)
	StringReplace, start_date, start_date, - ,, All
	StringTrimLeft, start_date, start_date, 2
	StringUpper, unit_upper, unit_name
	unit_short := SubStr(unit_upper, 1, 3)
	width := adbase.width
	height := adbase.height
	if (width = 320)
		{
			height *= 2
			width *= 2
		}
	format := getFormat(adbase.unit_id)

	path := dir.path . "\" . start_date
	IfNotExist, %path%
		FileCreateDir, %path%
		
	StringReplace, path, path, \, /, All
	StringReplace, path, path, G:, G|, All
	path := "file:///" . path

	if (skylt)
	{
		script =
	(
fl.createDocument("timeline");
var workPath = "%path%/%format% - %customer_name% - %start_date%.fla" 
var doc = fl.getDocumentDOM();
var tLine = fl.getDocumentDOM().getTimeline();
var layerOne = doc.getTimeline().layers[0];
doc.width = %width%;
doc.height = %height%;
doc.frameRate = 30
layerOne.name = 'Lager 1';
fl.saveDocument(fl.documents, workPath);
	)	
	}
	
	else
	{
		script =
	(
an.createDocument("htmlcanvas");
var workPath = "%path%/%format% - %customer_name% - %start_date%.fla" 
var doc = an.getDocumentDOM();
var tLine = an.getDocumentDOM().getTimeline();
var clickTagLayer = doc.getTimeline().layers[0];
doc.width = %width%;
doc.height = %height%;
clickTagLayer.name = 'ClickTAG';
doc.addNewRectangle({left:0,top:0,right:%width%,bottom:%height%}, 0, false, true);
var clickTag = doc.selectAll();
clickTag = doc.convertToSymbol('button', 'ClickTAG', 'top left');
clickTagLayer.frames[0].elements[0].colorMode = 'alpha';
doc.setInstanceAlpha(0);
clickTagLayer.frames[0].actionScript = 'canvas.addEventListener("click", klick, false); \r function klick() { \r window.open("#", "_blank"); \r };'
clickTagLayer.locked = true;
doc.selectNone();
doc.getTimeline().addNewLayer('lager 1', 'normal', false);
an.saveDocument(an.documents, workPath);
	)
	}
	FileDelete, an_temp_script.jsfl
	FileAppend, %script%, an_temp_script.jsfl
	Run, Animate.exe "%A_ScriptDir%\an_temp_script.jsfl" -AlwaysRunJSFL
}


getCustomerDir(name, startdate)
{
	obj := Object()
	; Sätter key 'year' till det år startdatumet är
	StringTrimRight, year, startdate, 6
	obj.year := year
	; Nedanstående rensar och ersätter ogiltiga tecken i kundnamnet och sätter det nya namnet i key 'name'
	StringReplace, name, name, &&, &, All
	StringReplace, name, name, &, %A_SPACE%, All
	StringReplace, name, name, /, %A_SPACE%, All
	StringReplace, name, name, \, %A_SPACE%, All
	StringReplace, name, name, :, %A_SPACE%, All
	obj.name := name

	; Sätter key 'first' till första bokstaven i kundens namn
	StringLen, num_letters, name
	to_remove := num_letters - 1
	StringTrimRight, first, name, %to_remove%
	obj.first := first

	obj.path := "G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\" . year . "\" . first . "\" . name . ""
	return obj ; returnerar objektet
}

b64encode(string)
{
	URL = http://korrektur.ntm.digital/encode/%string%
	DATA := ""
	HEAD = 
	OPTS = 
	HTTPRequest( URL, DATA, HEAD, OPTS )
	return data
}

getEmailAddress(user)
{
	result := []
	ConnectString := "Provider=SQLOLEDB.1;Password=adops2015;Persist Security Info=True;User ID=adops;Initial Catalog=adbprod;Data Source=adbasedb1.nt.se;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
	; Query = SELECT campaignnumber, quantityrequested, startdate, enddate FROM AoInCampaign WHERE startdate >= '%startdate%' AND enddate <= '%enddate%'
	Query = select emailaddress from usrusers where loginname = '%user%'
	query := ADOSQL(ConnectString, query)
	return query[2,1]
}

getProofUrl(user, order)
{
	email := getEmailAddress(user)
	string = {"order":"%order%", "email": "%email%"}
	console_log(string)
	b64 := b64encode(string)
	return b64
}

console_log(text)
{
	FormatTime, time, ,HH:mm:ss
	FileAppend, %time%: %text%`n, *, UTF-8
}