SetTitleMatchMode, 2

;
;	Medialink-funktioner
;___________________________________________________________________ 

; Kontrollera om Medialink är aktivt fönster och att användaren klickat i listvyn

mlActive(x=0)
{
	MouseGetPos, , , id, control
	IfInString, control, SysListView
		{
			IfWinActive, Atex MediaLink
			{
				x := true
			}

			IfWinActive, NewsCycle MediaLink
			{
				x := true
			}
		}
	return x
}

noteActive(x=0)
{
	MouseGetPos, , , id, control
	IfInString, control, Static29
		{
			IfWinActive, Atex MediaLink
			{
				x := true
			}
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
}

assign(x) ; tilldelar till x 
{
	Send, !a
	WinWaitActive, Ändra tilldelad
	Control, ChooseString, %x%, ComboBox1
	Send, !o
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

list_files(Directory, file)
{
	Loop %Directory%\*.%file%
	{
		files = %files%£%A_LoopFileName%
	}
	return files
}

stripDash(ByRef x)
{
	StringReplace, x, x,-,,All
}

rensaTecken(ByRef x) ; Rensar ur valda tecken ur en variabel
{
		StringReplace, x, x, &&, &, All
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
getFormat(x)
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
		format = 980
		file = 980 x 360
	}



	; Widescreen
	if (x = "Widescreen 240")
	{
		format = WID
		file = 250 x 240
	}

	if (x = "Annonstorget WS")
	{
		format = WID
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
}

; hämtar productID, sitetargetingID och keywordID för aktuell bokning
cxProduct(format, type)
{
	;global ; Alla variabler är globala
	output := {}

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

	; Portal 180 ----------------------------------
	if (format = "180" && type = "Run On Site")	
	{
		cxName := "- ROS - 180"
		cost := "cpc"
	}

	if (format = "180" && type = "Plugg")	
	{
		cxName := ". PLUGG - 180 - CPC"
		cost := "cpc"
	}

	if (format = "180" && type = "CPC")	
	{
		cxName := "- ROS - 180"
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
		cxName := ". PLUGG - 380 - CPC"
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
	SetKeyDelay, 0
	Run, C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE /c IPM.Note
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