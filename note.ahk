﻿note:
	if (mlActive())
	{
		ControlMove, Static28, , , 50, , NewsCycle MediaLink
		ControlMove, Static29, , , , 100, NewsCycle MediaLink
		ControlSetText, Static28, Info: , NewsCycle MediaLink

		ControlGetPos, cx, cy, , , Static60, NewsCycle MediaLink
		ControlMove, Static61, %cx%, %cy%, 500, , NewsCycle MediaLink
		cy2 := cy+16
		ControlMove, Edit3, ,%cy2% , , 100, NewsCycle MediaLink
		ControlMove, Button10, ,%cy2% , , , NewsCycle MediaLink
		
		Control, Hide, , Static60, NewsCycle MediaLink
		Control, Hide, , Edit2, NewsCycle MediaLink
		Control, Hide, , Static62, NewsCycle MediaLink
		Control, Hide, , Edit4, NewsCycle MediaLink
		Control, Hide, , Button9, NewsCycle MediaLink
		Control, Hide, , Button11, NewsCycle MediaLink



		FileRead, info,	%notesdir%\%mlOrdernummer%.txt
		if (info != "")
		{
			popX := mX-200
			SplashImage = %dir_img%\varning_small_new.png
			SplashImageGUI(SplashImage, popX, mY, 2000, true)

			ControlSetText, Static29, %info%, NewsCycle MediaLink
			ControlSetText, Static61, Interna noteringar (OBS - Egna noteringar finns!), NewsCycle MediaLink
			ControlMove, Static61, , , 500, , NewsCycle MediaLink
			; ToolTip, Observera: Denna kampanj har ytterligare information tillagd.
			; SetTimer, RemoveToolTip, 1500
		}
		if (info = "")
		{
			ControlSetText, Static29, Ingen info, NewsCycle MediaLink
			ControlSetText, Static61, Interna noteringar, NewsCycle MediaLink
		}
	}
return

comment:
	Gui, 3:Add, Edit, x5 y3 w300 h230 vegeninfo, %info%
	Gui, 3:Add, Button, x105 y243 w100 h30 gsparainfo, Spara
	Gui, 3:Show, xCenter yCenter h280 w313, Info
return

3GuiClose:
	Gui, 3:Destroy
return

sparainfo:
	Gui, 3:Submit
	Gui, 3:Destroy
	FileDelete, %notesdir%\%mlOrdernummer%.txt
	FileAppend, %egeninfo%, %notesdir%\%mlOrdernummer%.txt
	ControlSetText, Static29, %egeninfo%, NewsCycle MediaLink
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return