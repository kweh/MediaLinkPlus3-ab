DetectHiddenWindows, On
SetTitleMatchMode, 2
DetectHiddenText, On
#SingleInstance force
#include paths.ahk

count := zen_get_ticket_count()

IniRead, zenNote, %mlpDir%\settings.ini, ZenNotes, aktiv
	if (zenNote = 1)
	{
		SetTimer, zen_notify, 60000
	}


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
		menu, mlp, Icon, &Hitta Print-PDF, %iconDir%\inteprint.ico
		menu, mlp, disable, &Hitta Print-PDF
		print := printCheck(mlOrdernummer, "-01")
		if (print = "print" || print = "bild") ; Kollar om det finns en print
		{
			menu, mlp, Icon, &Hitta Print-PDF, %iconDir%\mlp3\print.ico
			menu, mlp, enable, &Hitta Print-PDF
		} 

		; Menyval
		menu, mlp, add, Kopiera kundnamn och ordernummer, kundOrder
		menu, mlp, add, Sök på ordernummer, sokOrder
		menu, mlp, add, Öppna kampanj i cxense, openCampaignCx
		menu, mlp, add, Öppna kund i cxense, openCustomerCx
		menu, mlp, add, Öppna kampanj i rapportverktyget, openCampaignRapportMulti
		menu, mlp, add, Öppna kund i rapportverktyget, openCustomerRapportMulti
		menu, mlp, add, Inställningar, mlpSettings
		menu, mlp, add, Boka kampanj, cxPostCampaign
		menu, mlp, add, Maila säljare, mailGeneral
		menu, mlp, add, Skicka korrektur, mailKorr

		; Felsökning
		menu, dev, add, Vad är detta?, whatsthis
		menu, dev, add, Produktinfo CX (cpc), cxprod_cpc
		menu, dev, add, Produktinfo CX (ros), cxprod_ros
		menu, dev, add, Produktinfo CX (riktad), cxprod_riktad
		menu, mlp, add, Felsökning, :dev

		; Ikoner för Menyval
		menu, mlp, Icon, Kopiera kundnamn och ordernummer, %iconDir%\mlp3\kopiera.ico
		menu, mlp, Icon, Sök på ordernummer, %iconDir%\mlp3\sok.ico

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

cxPostCampaign:
	gosub, cx_start
	; format := getFormat(mlEnhet)
	; campaignName := mlTidning " - " format " - " mlOrdernummer
	; campaign := cx_post_campaign(campaignName, mlKundnr, mlEnhet, format)
	; cx_post_contract(campaign.id, campaign.cost, "2015-05-05", "2015-05-06", "10:10", "10:30", "40000")
	; res := cx_post_advertisement(campaign.id, mlKundnamn, mlStartdatum)
	; msgbox % res

return

zen_post:
title := "Test-titel 2"
comment := "Här skriver vi lite text till"
req_name := "Dennis Strömberg"
req_mail := "dennis.stromberg@ntm.eu"
col_name := "Max Bergström"
col_mail := "max.bergstrom@ntm.eu"

zen_post_ticket(title, comment, req_name, req_mail, col_name, col_mail)
return

zen_notify:
newcount := zen_get_ticket_count()
win_y := A_ScreenHeight - 100
if (newcount > count)
{
	count := newcount
	Gui, 55:add, picture, x0 y0 w300 h100 gzen_close, G:\NTM\NTM Digital Produktion\MedialinkPlus\dev\zendesk.jpg
	Gui, 55:show, w300 h100 x0 y%win_y%
	Gui, 55:-Caption +alwaysontop
	Sleep, 15000
	Gui, 55:Destroy
}
return

zen_close:
	Gui, 55:Destroy
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
#include zendesk.ahk
#include note.ahk
#include dev.ahk