DetectHiddenWindows, On
SetTitleMatchMode, 2
DetectHiddenText, On
#SingleInstance force
#include paths.ahk

; count := zen_get_ticket_count()
;
; IniRead, zenNote, %mlpDir%\settings.ini, ZenNotes, aktiv
; 	if (zenNote = 1)
; 	{
; 		SetTimer, zen_notify, 60000
; 	}

menu, tray, add, Starta om Medialink Plus, reload

~RButton::
	if (mlActive())
	{
		if (menu)
		{
			menu, mlp, DeleteAll ; Initialisera
			menu = False
		}


		Click, right
		Send, {Esc}
		MouseGetPos, , , id, control
		gosub, getList

		;Hitta print-knappen
		menu, mlp, add, &Hitta Print-PDF, pdf-preview
		menu, mlp, Icon, &Hitta Print-PDF, %dir_icons%\inteprint.ico
		menu, mlp, disable, &Hitta Print-PDF
		print := printCheck(mlOrdernummer, "-01")
		if (print = "print" || print = "bild") ; Kollar om det finns en print
		{
			menu, mlp, Icon, &Hitta Print-PDF, %dir_icons%\print.ico
			menu, mlp, enable, &Hitta Print-PDF
		}

		menu, mlp, add, Kopiera orderinfo, kundOrder
		menu, mlp, Icon, Kopiera orderinfo, %dir_icons%\kopiera.ico
		menu, mlp, add

		; Cxense
		menu, cx, add, Boka kampanj, multiCxStart
		menu, cx, Icon, Boka kampanj, %dir_icons%\bokacxense.ico
		menu, cx, add, Öppna kampanj i cxense, openCampaignCx
		menu, cx, Icon, Öppna kampanj i cxense, %dir_icons%\oppnakampanjcxense.ico
		menu, cx, add, Öppna kund i cxense, openCustomerCx
		menu, cx, Icon, Öppna kund i cxense, %dir_icons%\oppnakundcxense.ico
		menu, mlp, add, Cxense, :cx
		menu, mlp, Icon, Cxense, %dir_icons%\cxense.ico

		; rapportverktyget
		menu, rapport, add, Öppna kampanj i rapportverktyget, openCampaignRapportMulti
		menu, rapport, Icon, Öppna kampanj i rapportverktyget, %dir_icons%\oppnakampanjcxense.ico
		menu, rapport, add, Öppna kund i rapportverktyget, openCustomerRapportMulti
		menu, rapport, Icon, Öppna kund i rapportverktyget, %dir_icons%\oppnakundcxense.ico
		menu, mlp, add, Rapport, :rapport
		menu, mlp, Icon, Rapport, %dir_icons%\rapport.ico
		menu, mlp, add

		; Mail
		menu, mlp, add, Maila säljare, mailGeneral
		menu, mlp, Icon, Maila säljare, %dir_icons%\fraga.ico
		menu, mlp, add, Skicka korrektur, mailKorr
		menu, mlp, Icon, Skicka korrektur, %dir_icons%\mailakorr.ico
		menu, mlp, add


		menu, mlp, add, Sök på ordernummer, sokOrder
		menu, mlp, Icon, Sök på ordernummer, %dir_icons%\sok.ico
		menu, mlp, add, Inställningar, mlpSettings


		; Felsökning
		menu, dev, add, Vad är detta?, whatsthis
		menu, dev, add, Produktinfo CX (cpc), cxprod_cpc
		menu, dev, add, Produktinfo CX (ros), cxprod_ros
		menu, dev, add, Produktinfo CX (riktad), cxprod_riktad
		menu, dev, add, Skriv fil till \cxense\, testWrite
		menu, mlp, add, Felsökning, :dev
		
		
		menu, mlp, Color, FFFFFF

		menu = true
		menu, mlp, show

	}

~LButton::
	MouseGetPos, , , id, control
	gosub, getList
	gosub, note
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
	mail := mlSaljare
	subject := "Ang. " mlKundnamn " (" mlOrdernummer ")"
	body := ""
	mail(mail, subject, body)
return

mailKorr:
	mail := mlSaljare
	subject := "Korrektur:  " mlKundnamn " (" mlOrdernummer ")"
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
	mail(mail, subject, body)
return

^#r::
reload
return

;
;	INCLUDES
;__________________________________________________________

#include func.ahk
#include cxense.ahk
#include subs.ahk
#include pdf_preview.ahk
#include settings.ahk
#include httpreq.ahk
#include json.ahk
; #include zendesk.ahk
#include note.ahk
#include dev.ahk
