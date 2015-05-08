DetectHiddenWindows, On
SetTitleMatchMode, 2
DetectHiddenText, On
#SingleInstance force
FileDelete,%A_Temp%\*.DELETEME.html ;clean tmp file
CoordMode, Mouse, Screen

#include paths.ahk
#include secure.ahk
#include menu_names.ahk

version = 310

SplashImage = %dir_img%\splash.png
SplashImageGUI(SplashImage, "Center", "Center", 3000, true)
sleep, 2000

#include update.ahk

;Timer för filecheck
from_fc := false
SetTimer, fc_go, 60000


IniRead, RMenuColor, %mlpSettings%, Theme, RMenuColor
	if (RMenuColor = "ERROR")
	{
		RMenuColor = FFFFFF
	}


menu, tray, add, Starta om Medialink Plus, reload


gosub, updateStart

~RButton::
	menuActive()
	if (mlActive())
	{
		; RBUTTON

	}

~LButton::
	CoordMode, Mouse, Screen
	MouseGetPos,mX ,mY , id, control
	menuActive()
	; ifWinActive, Atex MediaLink
	; {
	; 	gosub, getList
	; 	gosub, note
	; }

	IfWinActive, NewsCycle MediaLink
	{
		gosub, getList
		gosub, note
	}
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
	mail := mlSaljare
	subject := "Ang. " mlKundnamn " (" mlOrdernummer ")"
	body := ""
	mail(mail, subject, body)
return

mailKorr:
	mail := mlSaljare
	subject := "Korrektur: " mlKundnamn " (" mlOrdernummer ")"
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
	status("korrektur skickat")
	mail(mail, subject, body)
return

^#r::
reload
return



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

nothing:
return

; ========================================================================

OnExit:
    FileDelete,%A_Temp%\*.DELETEME.html ;clean tmp file
ExitApp

class WB_events
{
    ;for more events and other, see http://msdn.microsoft.com/en-us/library/aa752085
    
    NavigateComplete2(wb) {
        wb.Stop() ;blocked all navigation, we want our own stuff happening
    }
    DownloadComplete(wb, NewURL) {
        wb.Stop() ;blocked all navigation, we want our own stuff happening
    }
    DocumentComplete(wb, NewURL) {
        wb.Stop() ;blocked all navigation, we want our own stuff happening
    }
    
    BeforeNavigate2(wb, NewURL)
    {
        wb.Stop() ;blocked all navigation, we want our own stuff happening
        ;parse the url
        global MYAPP_PROTOCOL
        if (InStr(NewURL,MYAPP_PROTOCOL "://")==1) { ;if url starts with "myapp://"
            what := SubStr(NewURL,Strlen(MYAPP_PROTOCOL)+4) ;get stuff after "myapp://"
            if InStr(what,"msg-hej")
                MsgBox Hej!
            else if InStr(what,"sub-print")
                Gosub, pdf-preview
        }
        ;else do nothing
    }
}

Display(WB,html_str) {
    Count:=0
    while % FileExist(f:=A_Temp "\" A_TickCount A_NowUTC "-tmp" Count ".DELETEME.html")
        Count+=1
    FileAppend,%html_str%,%f%
    WB.Navigate("file://" . f)
}



menuActive(x=0)
{
	global  
	MouseGetPos, mX, mY , id, control
	IfNotInString, id, %menu_id%
		Gui, 11:Hide
	return
}

; =======================================================================


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
#include mlFileCheck.ahk


