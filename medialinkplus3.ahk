
DetectHiddenWindows, On
SetTitleMatchMode, 2
DetectHiddenText, On
#SingleInstance force

#include paths.ahk
#include secure.ahk
#include menu_names.ahk

version = 4.3.962

SplashImage = %dir_img%\splash4.png
SplashImageGUI(SplashImage, "Center", "Center", 2000, true)
sleep, 1000


IniRead, RMenuColor, %mlpSettings%, Theme, RMenuColor
	if (RMenuColor = "ERROR")
	{
		RMenuColor = FFFFFF
	}

menu, tray, add, Starta om Medialink Plus, reload
; json = {"order":"0002129204-03", "email":"dennis.stromberg@ntm.eu"}
; getEmailAddress("dennisst")
; b64string := b64encode(json)
; run, http://korrektur.ntm.digital/order/%b64string%

; #include update.ahk
; gosub, updateStart


#if (mlActive()) ;Triggar endast om MediaLink är aktivt
*RButton::
		if (menu)
		{
			menu, mlp, DeleteAll ; Initialisera
			menu, traffic, DeleteAll ; Initialisera
			menu, adn, DeleteAll ; Initialisera
			menu = False
		}
		; MouseGetPos, , , id, control
		skylt := false
		backfill := false
		backfill_cx := false
		adnSite := false
		gosub, ordernumber
		; order := getExtendedOrder(mlOrdernummer)
		; Click, left
		gosub, note
		gosub, getList

		;Hitta print-knappen
		;print-nummer:
		StringSplit, no_mtrl, mlOrdernummer, -
		printnr = %no_mtrl1%-01

		print := printCheck(mlOrdernummer, "-01")
		if (print = "print" || print = "bild") ; Kollar om det finns en print
		{
			menu, mlp, add, Visa PDF (%printnr%), pdf-preview
			menu, mlp, Icon, Visa PDF (%printnr%), %dir_icons%\24\print.png,,0
			; menu, mlp, Icon, %m_findprint%, %dir_icons%\print.ico
		}
		else 
		{
			menu, mlp, add, PDF saknas, pdf-preview
			menu, mlp, Icon, PDF saknas, %dir_icons%\24\inteprint.png,,0
			menu, mlp, disable, PDF saknas
		}

		menu, mlp, add, %m_copy%, kundOrder
		; menu, mlp, Icon, %m_copy%, %dir_icons%\kopiera.ico
		menu, mlp, Icon, %m_copy%, %dir_icons%\24\kopiera.png,,0
		

		menu, mlp, add
		menu, mlp, add, Tilldela och Planera, status_tilldela
		menu, mlp, Icon, Tilldela och Planera, %dir_icons%\tilldelabearbeta.ico
		menu, mlp, Icon, Tilldela och Planera, %dir_icons%\24\tilldelabearbeta.png,,0
		menu, mlp, add, Bearbeta, status_Bearbetas
		menu, mlp, Icon, Bearbeta, %dir_icons%\24\bearbeta.png,,0
		menu, mlp, add, Visa komponenter, components
		menu, mlp, Icon, Visa komponenter, %dir_icons%\24\component.png,,0
		menu, mlp, Add, Material..., material
		menu, mlp, Icon, Material..., %dir_icons%\24\material.png,,0
		; Skapa annons
		menu, mlp, add, %m_createPS%, photoshop
		; menu, mlp, Icon, %m_createPS%, %dir_icons%\photoshop.ico
		menu, mlp, Icon, %m_createPS%, %dir_icons%\24\photoshop.png,,0
		menu, mlp, add, %m_createFL%, flash
		menu, mlp, Icon, %m_createFL%, %dir_icons%\24\animate.png,,0
		; menu, mlp, Icon, %m_createFL%, %dir_icons%\flash.ico
		menu, mlp, add, %m_dir%, oppna
		; menu, mlp, Icon, %m_dir%, %dir_icons%\oppnacxense.ico
		menu, mlp, Icon, %m_dir%, %dir_icons%\24\kundmapp.png,,0
		
		if (!skylt && !backfill)
		{
			; Cxense
			if (!adnSite)
			{
			menu, cx, add, Boka kampanj, multiCxStart
			; menu, cx, Icon, Boka kampanj, %dir_icons%\cx.png,,0
			menu, cx, Icon, Boka kampanj, %dir_icons%\24\bokacxense.png,,0
			; menu, cx, Icon, Boka kampanj, %dir_icons%\bokacxense.ico
			}
			menu, cx, add, Öppna kampanj i cxense, multiCxOpen
			menu, cx, Icon, Öppna kampanj i cxense, %dir_icons%\24\oppnakampanjcxense.png,,0
			; menu, cx, Icon, Öppna kampanj i cxense, %dir_icons%\oppnakampanjcxense.ico
			menu, cx, add, Öppna kund i cxense, openCustomerCx
			menu, cx, Icon, Öppna kund i cxense, %dir_icons%\24\oppnakundcxense.png,,0
			; menu, cx, Icon, Öppna kund i cxense, %dir_icons%\oppnakundcxense.ico
			menu, mlp, add, %m_cx%, :cx
			; menu, mlp, Icon, %m_cx%, %dir_icons%\cxense.ico
			menu, mlp, Icon, %m_cx%, %dir_icons%\24\cxense.png,,0
		}

		;Adn
		if (!InStr(mlNoteringar, "AUTOBOKAD") || GetKeyState("LControl"))
		{
			console_log(mlNoteringar)
			menu, adn, add, Boka i adNuntius, multiAdn
		}
		menu, adn, add, Repetera order, adnuntius_copy
		menu, adn, add, Öppna i adNuntius, adnuntius_open
		menu, adn, add, Öppna kund i adNuntius, adnuntius_customer

		menu, mlp, add, adNuntius, :adn
		menu, mlp, Icon, adNuntius, %dir_icons%\24\adn.png,,0


		if (skylt)
		{
			menu, mlp, add, Boka skylt, bokaSkylt
			menu, mlp, Icon, Boka skylt, %dir_icons%\24\skylt.png,,0
		}

		if (backfill) {
			menu, mlp, add, Boka backfill (AdMeta), bokaBackfill
			menu, mlp, Icon, Boka backfill (AdMeta), %dir_icons%\24\backfill.png,,0
		}

		if ((!skylt && !backfill) || GetKeyState("LControl"))
		{
		console_log("AAAH")
		; rapportverktyget
		menu, rapport, add, Öppna kampanj i rapportverktyget, openCampaignRapportMulti
		menu, rapport, Icon, Öppna kampanj i rapportverktyget, %dir_icons%\24\oppnakampanjcxense.png,,0
		; menu, rapport, Icon, Öppna kampanj i rapportverktyget, %dir_icons%\oppnakampanjcxense.ico
		menu, rapport, add, Öppna kund i rapportverktyget, openCustomerRapportMulti
		menu, rapport, Icon, Öppna kund i rapportverktyget, %dir_icons%\24\oppnakundcxense.png,,0
		; menu, rapport, Icon, Öppna kund i rapportverktyget, %dir_icons%\oppnakundcxense.ico
		menu, mlp, add, %m_report%, :rapport
		menu, mlp, Icon, %m_report%, %dir_icons%\24\rapport.png,,0
		; menu, mlp, Icon, %m_report%, %dir_icons%\rapport.ico
		}	
			menu, mlp, add

		; Status
		menu, status, add, Ny, status_ny
		menu, status, icon, Ny, %dir_icons%\status\ny.ico

		menu, status, add, Inväntar print, status_print
		menu, status, icon, Inväntar print, %dir_icons%\status\ny.ico

		menu, status, add, Bokad, status_bokad
		menu, status, icon, Bokad, %dir_icons%\status\ny.ico

		menu, status, add, Vilande, status_vilande
		menu, status, icon, vilande, %dir_icons%\status\vilande.ico

		menu, status, add, Zendesk, status_zendesk
		menu, status, icon, Zendesk, %dir_icons%\status\vilande.ico

		menu, status, add, Vilande färdigt, status_vilandefardigt
		menu, status, icon, Vilande färdigt, %dir_icons%\status\vilande.ico

		menu, status, add, Manus på mail, status_manusmail
		menu, status, icon, Manus på mail, %dir_icons%\status\vilande.ico

		menu, status, add, Bearbetas, status_Bearbetas
		menu, status, icon, Bearbetas, %dir_icons%\status\Bearbetas.ico

		menu, status, add, Planerad, status_Planerad
		menu, status, icon, Planerad, %dir_icons%\status\Bearbetas.ico

		menu, status, add, Repetition, status_Repetition
		menu, status, icon, Repetition, %dir_icons%\status\Repetition.ico

		menu, status, add, Repetition m. förändring, status_repmfor
		menu, status, icon, Repetition m. förändring, %dir_icons%\status\Repetition.ico

		menu, status, add, Korrektur skickat, status_korrekturskickat
		menu, status, icon, Korrektur skickat, %dir_icons%\status\korrektur.ico

		menu, status, add, Korrektur klart, status_korrekturklart
		menu, status, icon, Korrektur klart, %dir_icons%\status\korrektur.ico

		menu, status, add, Lev. Färdig, status_levfardig
		menu, status, icon, Lev. Färdig, %dir_icons%\status\levfardig.ico

		menu, status, add, Under 2d prod. tid, status_under2d
		menu, status, icon, Under 2d prod. tid, %dir_icons%\status\undersoks.ico
		
		menu, status, add, Undersöks, status_undersoks
		menu, status, icon, Undersöks, %dir_icons%\status\undersoks.ico

		menu, status, add, Sent bokad, status_sentbokad
		menu, status, icon, Sent bokad, %dir_icons%\status\sentbokad.ico

		menu, status, add, Ej komplett manus, status_EjKomplett
		menu, status, icon, Ej komplett manus, %dir_icons%\status\ny.ico

		menu, status, add, Obekräftad, status_obekraftad
		menu, status, icon, Obekräftad, %dir_icons%\status\Klar.ico

		menu, status, add, Klar, status_Klar
		menu, status, icon, Klar, %dir_icons%\status\Klar.ico

		menu, status, add, Annan..., status_annan

		menu, mlp, add, %m_status%, :status
		menu, mlp, Icon, %m_status%, %dir_icons%\24\status.png,,0
		; menu, mlp, Icon, %m_status%, %dir_icons%\status.ico



		; Tilldela
		menu, assign, add, ...mig, assign_me
		menu, assign, add, ...annan, assign_other
		menu, assign, add, ...ingen, assign_none
		menu, assign, add, ...UNiT, assign_unit
		menu, mlp, add, %m_assign%, :assign
		menu, mlp, Icon, %m_assign%, %dir_icons%\24\tilldela.png,,0
		; menu, mlp, Icon, %m_assign%, %dir_icons%\tilldela.ico
		; Mail
		menu, mlp, add, %m_mail%, custom_ticket
		menu, mlp, Icon, %m_mail%, %dir_icons%\24\groove.png,,0
		menu, mlp, add, Skicka mail, custom_email
		menu, mlp, Icon, Skicka mail, %dir_icons%\24\fraga.png,,0
		; menu, mlp, Icon, %m_mail%, %dir_icons%\fraga.ico

		menu, proof, add, Skicka korrektur, proofUrl
		menu, proof, Icon, Skicka korrektur, %dir_icons%\24\mailakorr.png,,0
		menu, proof, add, Visa korrektur, showProof
		menu, proof, Icon, Visa korrektur, %dir_icons%\24\visakorr.png,,0

		; menu, mlp, add, Skicka korrektur, proofUrl
		; menu, mlp, Icon, Skicka korrektur, %dir_icons%\24\mailakorr.png,,0
		menu, mlp, add, Korrektur, :proof
		menu, mlp, Icon, Korrektur, %dir_icons%\24\mailakorr.png,,0
		menu, mlp, add, Skicka rapportlänk, mailKorr
		menu, mlp, Icon, Skicka rapportlänk, %dir_icons%\24\mailakorr.png,,0
		menu, mlp, add



		; Kommentera
		menu, mlp, add, %m_comment%, comment
		menu, mlp, Icon, %m_comment%, %dir_icons%\24\kommentera.png,,0
		; menu, mlp, Icon, %m_comment%, %dir_icons%\kommentera.ico


		menu, mlp, add, %m_search%, sokOrder
		menu, mlp, Icon, %m_search%, %dir_icons%\24\sok.png,,0

		menu, mlp, add, Filövervakning, fileCheck
		menu, mlp, Icon, Filövervakning, %dir_icons%\24\filecheck.png,,0
		; menu, mlp, Icon, Filövervakning, %dir_icons%\filecheck.ico

		; Traffic
		; menu, traffic, add, Uppdatera lagerverktyget, lager
		menu, traffic, add, Meddela ej komplett manus/interna noteringar, ej_komplett
		menu, traffic, add, Meddela saknat färdigt material, ej_fardigt
		menu, traffic, add, Meddela saknat/ej levererat material el. manus, ej_manus
		menu, traffic, add, Meddela under 2 dagar produktionstid, ej_prodtid
		menu, traffic, add, Skapa eget ärende, custom_ticket
		menu, traffic, add,
		; menu, traffic, add, Räkna markerade annonser, rakna
		; menu, traffic, add, Räkna annonser för produktion, raknaProd
		; menu, traffic, add, Räkna exponeringar, raknaExp
		; menu, traffic, add, Kopiera rader, copyCampaigns
		menu, traffic, add, Hitta tidningssida, epaper
		menu, traffic, add, Skicka till TVISTer, tvister
		menu, traffic, add, Kontrollera bokning, fileInfo
		menu, traffic, add,

			menu, prio, add, Prio 1, prio1
			menu, prio, add, Prio 2, prio2
			menu, prio, add, Prio 3, prio3

		menu, traffic, add, Prio, :prio
		menu, traffic, add, 
		menu, traffic, add, Öppna nytt MediaLink-fönster, multilink
		menu, traffic, add, Öppna order i nytt MediaLink-fönster, multilinkOpenNew
		menu, traffic, add, Öppna mini-dashboard, init
		menu, traffic, Add
		menu, traffic, add, Öppna komponentuppladdning för mail, openCompMailGui

		menu, mlp, add, %m_traffic%, :traffic
		menu, mlp, Icon, %m_traffic%, %dir_icons%\24\traffic.png,,0
		; menu, mlp, Icon, %m_traffic%, %dir_icons%\traffic.ico

		menu, mlp, add, %m_settings%, mlpSettings
		menu, mlp, Icon, %m_settings%, %dir_icons%\24\settings.png,,0
		; menu, mlp, Icon, %m_settings%, %dir_icons%\settings.ico

		; Felsökning
		IniRead, dev, %mlpSettings%, Misc, Dev
			if (dev = 1)
				{
					menu, dev, add, Vad är detta?, whatsthis
					menu, dev, add, Produktinfo CX (cpc), cxprod_cpc
					menu, dev, add, Produktinfo CX (ros), cxprod_ros
					menu, dev, add, Produktinfo CX (riktad), cxprod_riktad
					menu, dev, add, Skriv fil till \cxense\, testWrite
					menu, dev, add, Öppna \cxense\, opencxpath
					menu, dev, add, Kolla tid för att ladda meny, menutime
					menu, mlp, add, %m_dev%, :dev
				}
		
		
		menu, mlp, Color, %RMenuColor%

		menu = true
		menu, mlp, show
		gosub, note
return 


~LButton:: 
	CoordMode, Mouse, Screen
	MouseGetPos,mX ,mY , id, control
		tempClip := Clipboard
		Send, ^c
		mlOrdernummer := Clipboard
		if (mlOrdernummer = tempClip)
		{
			Send, ^c
			mlOrdernummer := Clipboard
		}
		Clipboard := tempClip
		; gosub, getList
		gosub, note
return

#if

^+Rbutton::
	gosub, rightcontrol
return

~Delete::
if (mlActive())
	{
	status("Klar")
	sleep, 100
	Send, {Shift down}{F5}{Shift up}
	}
return

GuiClose:
	Gui, Destroy
return

prodInfo:
	getFormat(mlEnhet)
	cxProduct(format, "riktad") ; returnerar productId, siteTargetingId och keywordsId
return

fleraPrint:
	data := checkPrints(mlOrdernummer)
return

testWrite:
	FileAppend, test, %dir_cxense%\test.txt
return


mailGeneral:
	gosub, getlist
	subject := "Ang. kampanj " mlOrdernummer " (" mlKundnamn ")"
	body := "`n`nHälsningar,`nDigital Produktion"
	gosub, maila_saljare
return

mailKorr:
	gosub, getList
	mail := mlSaljare
	subject := "Rapport: " mlKundnamn " (" mlOrdernummer ")"
	gosub, getKorr
	body =
(


----

{CTRL down}f{CTRL up}Länk för rapport:{CTRL down}f{CTRL up}
%rapportUrl%

Spara denna länk{Shift down}1{Shift up}
På denna länk finns information om hur ordern är inbokad. Kontrollera så att start/stoppdatum stämmer och att antal exponeringar är korrekt. Om vi inte får något svar startar kampanjen på startdatumet. Denna länk fungerar även som statusrapport för denna kampanj. Här kan du se exakt hur många exponeringar/klick som levererats hittills i kampanjen. Om du någon gång under kampanjens gång upplever att något inte står rätt till, kontakta digital.support@ntm.eu.

----

{CTRL down}{Home}{CTRL up}
)
	if (campaignID = "")
	{
		body = 
	}
	mail(mail, subject, body)
return

^#r::
reload
return

#z::
Send ^c ; copy selected text and images to the clipboard
FileAppend,  %ClipboardAll%, defaultMsg.clip
Return



~+<:: ; Låter Shift+< agera som Shift+F5
	if (mlActive())
	{
		Send, {Shift Down}{F5}{Shift Up}
	}
return

~^a:: ; Gör att ctrl+a fungerar i MediaLink
	if (mlActive())
	{
		Send, {Home}
		Send, {Shift Down}
		Send, {End}
		Send, {Shift Up}
	}
return


context_print:
	StringSplit, nummer, line2, -
	data := printCheck(line2, nummer2)
	if(data != "")
	{
		IfNotInString, line2, 000
		{
			line2 := "000"line2
		}
		gosub, pdf-preview
	}
Return

bokaSkylt:
	Run, iexplore.exe http://lohts.edge3.se
return

bokaBackfill:
	Run, https://tango.admeta.com/Login.aspx?pn=NTM-Koncernen
return

prio1:
	prio("Prio 1")
return

prio2:
	prio("Prio 2")
return

prio3:
	prio("Prio 3")
return

nothing:
return

^#A::  
Winset, Alwaysontop, , A
return


^!#s::
	WinGetTitle, NP, ahk_class SpotifyMainWindow,
	msgbox % NP
return

pause::
if (tog_spot = "false" || tog_spot = "")
{
	tip = 
(

-------------[ Spotify Toggles ON]-------------
.
)
	ToolTip
	tog_spot = true
	ToolTip, %tip%
	Sleep, 1000
	ToolTip
	return
}

if (tog_spot = "true")
{
	tip = 
(

-------------[ Spotify Toggles OFF]-------------
. 
)
	ToolTip
	tog_spot = false
	ToolTip, %tip%
	Sleep, 1000
	ToolTip
	return
}

Return

~^Right::
	if (tog_spot = "true")
	{
		Send, {Media_Next}
	}
return

~^Left::
	if (tog_spot = "true")
	{
		Send, {Media_Prev}
	}
return

~^Up::
	if (tog_spot = "true")
	{
		Send, {Media_Play_Pause}
	}
return

#!m::
	Run, C:\Program Files (x86)\NEWSCYCLE Solutions\MediaLink\bin\MediaLink.exe, C:\Users\dennis.stromberg\Google Drive\MediaLinkPlus3-ab\test\bin
return

#!g::
	o := getTime()
	msgbox % "local: " o.local "`nUTC: " o.utc "`nDiff: " o.diff
return

^#!c::
	gosub, openCompMailGui
return

^!r::
	gosub, adn_copy
return

openCompMailGui:
	gosub, ordernumber
	thisordernumber := mlOrdernummer
	gosub, compmail
return


;
;	INCLUDES
;__________________________________________________________

#include functions.ahk
#include cxense.ahk
#include subroutines.ahk
#include pdf_preview.ahk
#include settings.ahk
#include httpreq.ahk
; #include json.ahk
#include json2.ahk
#include note.ahk
#include dev.ahk
#include mlFileCheck.ahk
#include xml.ahk
#include adosql.ahk
#include material.ahk
#include support.ahk
#include Urifunc.ahk
#include ctlColors.ahk
#include korrektur.ahk
#include adnuntius.ahk
#include adnuntius_gui.ahk
#include multilink.ahk
#include components.ahk
#include rightcontrol.ahk
#include dash/dash.ahk
#include base64.ahk