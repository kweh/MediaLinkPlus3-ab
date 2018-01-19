#SingleInstance, force

init:
	gui, Destroy
	expanded := false
	stick := false
	mini := false
	result := getSql("2017-01-13","2017-01-16")
	; print("Vilande: " . vilande.MaxIndex()-1)
	allCampaigns := result.MaxIndex()-1
	c_bearbetas := countType("Bearbetas", result)
	c_vilande := countType("Vilande", result)
	c_obekraftad := countType("Obekräftad", result)
	c_obekraftad += countType("Klar", result)
	c_obekraftad += countType("Bokad", result)
	c_korrektur := countType("Korrektur", result)
	c_ny := countType("Ny", result)
	c_levfardig := countType("Lev", result)
	c_rep := countType("Rep", result)
	c_undersoks := countType("Under", result)

	c_ej_prod := 0
	c_ej_prod += countType("Under ", result)

	prod := c_vilande+c_ny+c_levfardig+c_rep
	diff := allCampaigns-prod

	prod_diff := prod-c_undersoks
	; c_ej_prod += countType("Under", result)
	print(c_bearbetas)
	print(c_vilande)
	print(c_obekraftad)
	print(c_ny)

	; gui, Add, Progress, w300 h30 cBlue vAll Range0-%allCampaigns%
	gui, Font, s6 cAAAAAA, Open Sans
	; gui, add, text, w100 yp10 x10 gCheck vtObekraftad,Obekräftade/klara
	; gui, add, progress, w5 h99 y9 x9 BackgroundCCCCCC Range0-100, 100
	; gui, add, progress, w5 h99 y9 x292 BackgroundCCCCCC Range0-100, 100
	gui, Add, Progress, w16 h16 y12 x0 c8AD56C BackgroundBEEEAB vObekraftad Range0-%allCampaigns%, %allCampaigns%
	gui, Add, Progress, w16 h16 xp+17 yp cE5E16B BackgroundF1EFA6 vBearbetas Range0-%allCampaigns%, %allCampaigns%
	gui, Add, Progress, w16 h16 xp+17 yp cDB9B50 BackgroundF4D0A7 vVilande Range0-%allCampaigns%, %allCampaigns%
	gui, Add, Progress, w16 h16 xp+17 yp c5992CC Background9FC7F0 vKorrektur Range0-%allCampaigns%, %allCampaigns%
	gui, Add, Progress, w16 h16 xp+17 yp cE46E6E BackgroundF5AAAA vNy Range0-%allCampaigns%, %allCampaigns%
	gui, Add, Progress, w16 h16 xp+17 yp c55744A Background90A588 vFardig Range0-%allCampaigns%, %allCampaigns%
	gui, Add, Progress, w16 h16 xp+17 yp c926DA7 BackgroundBE9BD2 vRep Range0-%allCampaigns%, %allCampaigns%
	gui, Add, Progress, w16 h16 xp+17 yp c333333 BackgroundAAAAAA vUndersoks Range0-%allCampaigns%, %allCampaigns%
	gui, Add, Picture, xp+17 yp gSettings, dash/settings.png
	gui, Add, Picture, xp+17 yp gGuiMove, dash/move.png
	gui, add, progress, w80 h7 xp+17 yp c498CBF BackgroundB6D9F4 vdiff_prog Range0-%allCampaigns%, %diff%
	gui, add, progress, w80 h7 xp yp+9 cBCB132 BackgroundE5DE89 vdiff_proddable Range0-%prod%, %prod_diff%
	gui, font, c000000
	gui, add, text, x4 y14 BackgroundTrans vnum_obekraftad, 10
	gui, add, text, yp xp+17 BackgroundTrans vnum_bearbetas, 10
	gui, add, text, yp xp+17 BackgroundTrans vnum_vilande, 10
	gui, add, text, yp xp+17 BackgroundTrans vnum_korrektur, 10
	gui, add, text, yp xp+17 BackgroundTrans vnum_ny, 10
	gui, add, text, yp xp+17 BackgroundTrans vnum_fardig, 10
	gui, add, text, yp xp+17 BackgroundTrans vnum_rep, 10
	gui, font, cFEFEFE
	gui, add, text, yp xp+17 BackgroundTrans vnum_undersoks, 10

	; gui, add, text, x5 yp+15 w200 vnum_total, TOTALT ANTAL KAMPANJER: `t%allCampaigns%
	; gui, add, text, x5 yp+11 w200 vnum_totalprod, KVAR ATT HANTERA: `t%prod%
	; gui, add, button, w20 h40 y5 x320 vExpand gExpand, >
	; gui, add, button, w20 h20 yp+40 x320 vStick gStick, v
	; gui, add, button, w20 h20 yp+20 x320 vMini gMini, -
	; gui, add, progress, x0 w349 h30 y150 BackgroundFFFFFF cB8F2A1 Range0-%allCampaigns% vdiff_prog, %diff%
	; gui, add, text, x0 w1920 h500 y0 BackgroundTrans gGuiMove vMover, 
	; Gui, add, picture, x0 y0 gGuiMove, move.png 



	; gui, add, 
	gui, color, feffff
	gui, show,,Dashboard
	; 

	; GuiControl,, All, %allCampaigns%
	; GuiControl,, Bearbetas, %c_bearbetas%
	GuiControl,, num_Bearbetas, %c_bearbetas%
	; GuiControl,, Vilande, %c_vilande%
	GuiControl,, num_Vilande, %c_vilande%
	; GuiControl,, Obekraftad, %c_obekraftad%
	GuiControl,, num_Obekraftad, %c_obekraftad%
	; GuiControl,, Korrektur, %c_korrektur%
	GuiControl,, num_Korrektur, %c_korrektur%
	; GuiControl,, Ny, %c_ny%
	GuiControl,, num_Ny, %c_ny%
	; GuiControl,, Fardig, %c_levfardig%
	GuiControl,, num_Fardig, %c_levfardig%
	; GuiControl,, Rep, %c_rep%
	GuiControl,, num_Rep, %c_rep%
	; GuiControl,, Undersoks, %c_undersoks%
	GuiControl,, num_Undersoks, %c_undersoks%

	SetTimer, reset, 60000
return

settings:
	gui, settings:Add, Monthcal, x10 y10 Multi 4 vDates gReset,
	gui, settings:Add, Button, gstick, Dölj window-chrome
	gui, settings:show
return

SettingsGuiClose:
	gui, settings:destroy
return

GuiMove:
   PostMessage, 0xA1, 2
return

check:
	StringTrimLeft, control, A_GuiControl, 1
	number := c_%control%
	msgbox, %control%: %number%
return

mini:
	mini := !mini
	; Winset, Style, ^0xC00000, A
	; WinSet, ExStyle, ^0x80, A
	; WinSet, AlwaysOnTop,,A
	if (mini)
	{
		GuiControl, MoveDraw, diff_prog, y0
		; GuiControl, Move, mover, y0 x0 w349 h30
		GuiControl, Hide, stick
		GuiControl, Hide, expand
		GuiControl, Move, mini, y0
		WinMove, Dashboard,,,,1920,120
	}
	else
	{
		GuiControl, MoveDraw, diff_prog, y150
		; GuiControl, Move, mover, y150 x0 w349 h30
		GuiControl, Move, mini, y65 
		GuiControl, Show, stick
		GuiControl, Show, expand
		WinMove, Dashboard,,,,,209
	}

return

stick:
	stick := !stick
	if (stick)
	{
		Winset, TransColor, feffff , Dashboard
		Winset, Style, ^0xC00000, Dashboard
		WinSet, ExStyle, ^0x80, Dashboard
		WinSet, AlwaysOnTop,,Dashboard
	}
	else
	{
		Winset, TransColor, Off, Dashboard
		Winset, Style, ^0xC00000, Dashboard
		WinSet, ExStyle, ^0x80, Dashboard
		WinSet, AlwaysOnTop,,Dashboard
	}
return

expand:	
	expanded := !expanded
	print(expanded)
	
	if (expanded)
	{
		GuiControl,, expand, <
		WinMove, Dashboard,,,,610
	}
	else
	{
		GuiControl,, expand, >
		WinMove, Dashboard,,,,355
	}
return

reset:
	Gui, 1:default
	print(dates)
	StringSplit, dates, dates, -
	result := getSql(dates1,dates2)
	; print("Vilande: " . vilande.MaxIndex()-1)
	allCampaigns := result.MaxIndex()-1
	c_bearbetas := countType("Bearbetas", result)
	c_vilande := countType("Vilande", result)
	c_obekraftad := countType("Obekräftad", result)
	c_obekraftad += countType("Klar", result)
	c_obekraftad += countType("Bokad", result)
	c_korrektur := countType("Korrektur", result)
	c_ny := countType("Ny", result)
	c_levfardig := countType("Lev", result)
	c_rep := countType("Rep", result)
	c_undersoks := countType("Under", result)
	print(result.MaxIndex()-1)
	print(c_ny)
	c_ej_prod := 0
	c_ej_prod += countType("Under", result)

	prod := c_vilande+c_ny+c_levfardig+c_rep
	print("prod: " . (prod+c_undersoks))
	diff := (allCampaigns+c_undersoks)-prod
	hubba := prod+c_undersoks
	prod_diff := (prod+c_undersoks)-c_undersoks
	print("diff: " . prod_diff)

	GuiControl,+Range0-%allCampaigns%, Bearbetas, %c_bearbetas%
	GuiControl,, Bearbetas, %c_bearbetas%
	GuiControl,+Range0-%allCampaigns%, Vilande, %c_vilande%
	GuiControl,, Vilande, %c_vilande%
	GuiControl,+Range0-%allCampaigns%, Obekraftad, %c_obekraftad%
	GuiControl,, Obekraftad, %c_obekraftad%
	GuiControl,+Range0-%allCampaigns%, Korrektur, %c_korrektur%
	GuiControl,, Korrektur, %c_korrektur%
	GuiControl,+Range0-%allCampaigns%, Ny, %c_ny%
	GuiControl,, Ny, %c_ny%
	GuiControl,+Range0-%allCampaigns%, Fardig, %c_levfardig%
	GuiControl,, Fardig, %c_levfardig%
	GuiControl,+Range0-%allCampaigns%, Rep, %c_rep%
	GuiControl,, Rep, %c_rep%
	GuiControl,+Range0-%allCampaigns%, Undersoks, %c_undersoks%
	GuiControl,, Undersoks, %c_undersoks%
	GuiControl,, num_Bearbetas, %c_bearbetas%
	GuiControl,, num_Vilande, %c_vilande%
	GuiControl,, num_Obekraftad, %c_obekraftad%
	GuiControl,, num_Korrektur, %c_korrektur%
	GuiControl,, num_Ny, %c_ny%
	GuiControl,, num_Fardig, %c_levfardig%
	GuiControl,, num_Rep, %c_rep%
	GuiControl,, num_Undersoks, %c_undersoks%
	GuiControl,, num_total, TOTALT ANTAL KAMPANJER: %allCampaigns%
	GuiControl,, num_totalprod, KVAR ATT HANTERA: `t%prod%
	GuiControl, +Range0-%allCampaigns%, diff_prog
	GuiControl,, diff_prog, %diff%
	GuiControl, +Range0-%hubba%, diff_proddable
	GuiControl,, diff_proddable, %prod_diff%
return


#IfWinActive, Dashboard
F5::
	gosub, reset
return

^!x::
	gosub, stick
return

~LButton::	
	MouseGetPos,,,,ctrl
	print(ctrl)
	if(ctrl = "Static3" || ctrl = "msctls_progress321") ; Klara
	{
		showOrders(result, "Klar")
	}
	if(ctrl = "Static4" || ctrl = "msctls_progress322") ; Bearbetas
	{
		showOrders(result, "Bearbetas")
	}
	if(ctrl = "Static5" || ctrl = "msctls_progress323") ; Vilande
	{
		showOrders(result, "Vilande")
	}
	if(ctrl = "Static6" || ctrl = "msctls_progress324") ; Korrektur
	{
		showOrders(result, "Korrektur")
	}
	if(ctrl = "Static7" || ctrl = "msctls_progress325") ; Ny
	{
		showOrders(result, "Ny")
	}
	if(ctrl = "Static8" || ctrl = "msctls_progress326") ; Lev. Färdigt
	{
		showOrders(result, "Lev")
	}
	if(ctrl = "Static9" || ctrl = "msctls_progress327") ; Rep
	{
		showOrders(result, "Rep")
	}
	if(ctrl = "Static10" || ctrl = "msctls_progress328") ; Undersöks
	{
		showOrders(result, "Under")
	}
return
#If

;  ___________________________________________________________________
; |																	  |
; |  Functions														  |
; |___________________________________________________________________|

print(text)
{
	FormatTime, time, ,HH:mm:ss
	FileAppend, %time%: %text%`n, *, UTF-8
}

countType(type, sql)
{
	count := 0
	Loop, % sql.MaxIndex()
	{
		if (InStr(sql[A_Index].status, type))
			count++
	}
	return count
}
lv := ""
showOrders(sql, type) {
	gui, showOrders:Destroy
	LV_Delete()
	gui, showOrders:Add, ListView, w500 h500 vLv,Kampanjnummer|Kund 
	gui, showOrders:Default
	types := StrSplit(type, ",")
	Loop, % sql.MaxIndex()
	{
		if (InStr(sql[A_Index].status, type))
			LV_Add("", sql[A_Index].campaignnumber, sql[A_Index].customer)
	}
	LV_ModifyCol()
	gui, showOrders:Show,, Visar ordrar med status: "%type%"
}
;  ___________________________________________________________________
; |																	  |
; |  Imports														  |
; |___________________________________________________________________|
#Include, dash/sql_query.ahk