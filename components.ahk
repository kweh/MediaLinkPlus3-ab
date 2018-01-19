components:
	result := getComponents(mlOrdernummer)
	gosub, getList
	thisOrdernumber := mlOrdernummer
	console_log("Totalt antal komponenter: " result.MaxIndex()-1)

	; Lägger till listview i UI't så att vi kan lägga saker däri.
	gui, comp:Destroy
	gui, comp:Color, eeeeee
	gui, comp:add, Picture, w200 h-1 vprev_pic gpreview AltSubmit,
	gui, comp:add, Text,yp+512 x220, Fritext-sök:
	gui, comp:add, Edit, vcompedit gcompedit w520 xp+80 yp-2,
	gui, comp:add, button, gcompUpload x10 y450 w200, Ladda upp komponent
	gui, comp:add, button, gcompMail x10 y481 w200, Ladda upp mail
	gui, comp:add, Tab3, xp+210 w600 h500 y5 -Theme AltSubmit vTabCtrl gTabClick, Order|Kund
	gui, comp:add, ListView, c555555 Count100 xp yp+20 h480 w600 AltSubmit gComponentRun vlist_order, Komponentnamn|Skapad|ID
	gui, comp:Tab, 2
	gui, comp:add, ListView, c555555 Count100 xp yp h480 w600 AltSubmit gComponentRun vlist, Komponentnamn|Skapad|ID

	gui, comp:Default

	maxindex := result.MaxIndex()
	gosub, componentLoad

	i := 0
	break := false
	str := ""
	Gui, ListView, list

	; | HÄMTAR ALLA KOMPONENTER PÅ KUNDEN
	; |____________________________________________________________________________________
	loop % result.MaxIndex()
	{

		id := result[A_Index].id
		IfNotInString, str, %id%
		{
			if (break)
			{
				break
			}

			GuiControl,load:,comp_prog, %A_Index%
			GuiControl,load:,progText, Laddar komponent nr: %A_Index%


			ext := result[A_Index].ext
			if (ext = "ico")
			{
				ext := "zip"
			}
			; console_log(result[A_Index].id . ": " . result[A_Index].desc . " | " . result[A_Index].ext . " | " . path_low)
			id_length := strLen(id)
			toRemove := id_length - 2
			StringTrimLeft, pre_id, id, %toremove%
			path_low := "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\LowRes\" . id . ".jpg"
			path_low_png := "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\LowRes\" . id . ".png"
			path_high := "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\HighRes\" . id . ".jpg"
			if(FileExist(path_low) || FileExist(path_low_png) || ext = "zip")
			{
				if (ext = "zip")
				{
					LV_Add("",result[A_Index].desc, result[A_Index].create, result[A_Index].id)
				}
				Else
				{
					LV_Add("",result[A_Index].desc . "." . result[A_Index].ext, result[A_Index].create, result[A_Index].id)
				}
			}
			i++
			str := str . id . ","
		}
	}

	; | HÄMTAR KOMPONENTER FÖR ORDERNUMRET
	; |____________________________________________________________________________________


	i := 0
	break := false
	str := ""
	Gui, Listview, list_order
	result := getComponentsOnOrder(mlOrdernummer)
	loop % result.MaxIndex()
	{
		console_log(result[A_Index].desc)
		id := result[A_Index].id
		IfNotInString, str, %id%
		{
			if (break)
			{
				break
			}

			GuiControl,load:,comp_prog, %A_Index%
			GuiControl,load:,progText, Laddar komponent nr: %A_Index%


			ext := result[A_Index].ext
			if (ext = "ico")
			{
				ext := "zip"
			}
			; console_log(result[A_Index].id . ": " . result[A_Index].desc . " | " . result[A_Index].ext . " | " . path_low)
			id_length := strLen(id)
			toRemove := id_length - 2
			StringTrimLeft, pre_id, id, %toremove%
			path_low := "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\LowRes\" . id . ".jpg"
			path_low_png := "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\LowRes\" . id . ".png"
			path_high := "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\HighRes\" . id . ".jpg"
			if(FileExist(path_low) || FileExist(path_low_png) || ext = "zip")
			{
				if (ext = "zip")
				{
					LV_Add("",result[A_Index].desc, result[A_Index].create, result[A_Index].id)
				}
				Else
				{
					LV_Add("",result[A_Index].desc . "." . result[A_Index].ext, result[A_Index].create, result[A_Index].id)
				}
			}
			i++
			str := str . id . ","
		}
	}




	; console_log("Innan sortering: " . result.MaxIndex() . ", efter: " . i)
	; console_log("Str: `n" . str)

	Gui, ListView, list
	numrows := LV_GetCount()
	full_list := ""
	Loop, %numrows%
	{
		LV_GetText(getName, A_Index, 1)
		LV_GetText(getCreate, A_Index, 2)
		LV_GetText(getId, A_Index, 3)
		full_list := full_list . getName . "|" . getCreate . "|" . getId . ","
	}
	; console_log(full_list)
	LV_ModifyCol(1)
	LV_ModifyCol(2)
	LV_ModifyCol(2, "SortDesc Center")
	LV_ModifyCol(3)
	gui, load:Destroy
	gui, comp:Show,, Alla komponenter för %mlKundnamn% - %thisOrdernumber%
return

componentLoad:
	gui, load:Add, Progress, w300 vcomp_prog Range0-%maxindex%
	Gui, load:Add, Text, vprogText w300, Laddar komponent nr: 
	Gui, load:Add, Text, , Totalt antal komponenter att ladda: %maxindex% 
	gui, load:Add, Button, w300 gCompStop, Nepp, orkar inte vänta mer.
	Gui, load:Show

return

tabClick:

return

compStop:
	break := true
	Gui, load:Destroy
return

loadGuiClose:
	gosub, compStop
return

compGuiClose:
	gui, comp:Destroy
	FileRemoveDir, %A_ScriptDir%\tempMail, 1
	SetTimer, checkForMsgFile, Off
return

compGuiDropFiles:
	Loop, parse, A_GuiEvent, `n
	{
		dropFilePath := A_LoopField
		splitpath, dropFilePath, dropFileName, dropFileDir, dropFileExt, dropFileNameNoExt
		gosub, dropGui
		console_log(A_LoopField)

	}
return

compUpload:
	FileSelectFile, selectedComponent,,,Välj en fil att ladda upp.
	if (!selectedComponent)
		return
	dropFilePath := selectedComponent
	splitpath, dropFilePath, dropFileName, dropFileDir, dropFileExt, dropFileNameNoExt
	gosub, dropGui
	console_log(selectedComponent)
return

compMail:
	FileRemoveDir, %A_ScriptDir%\tempMail, 1
	FileCreateDir, %A_ScriptDir%\tempMail
	gui, compmail:Add, Text, , Dra och släpp ditt mail i rutan.
	gui, compmail:Add, ActiveX, w400 h300 vWB, Shell.Explorer
	WB.Navigate(A_ScriptDir . "\tempMail")
	gui, compmail:Show,,Ladda upp mail
	SetTimer, checkForMsgFile
return

checkForMsgFile:
	ifExist, %A_ScriptDir%\tempMail\*.msg
	{
		Loop, %A_ScriptDir%\tempMail\*.msg
		{
			SetTimer, checkForMsgFile, Off
			msgPath := A_LoopFileFullPath
			Gosub, extractMsg
		}
	}
return

extractMsg:
	FileCreateDir, %A_ScriptDir%\tempMail\Process
	if !IsObject(olApp := ComObjActive("Outlook.Application")) 
	{ ; Get the Outlook application object if Outlook is open
	    olApp  := ComObjCreate("Outlook.Application") ; Create an Outlook application object if Outlook is not open
	    CloseOutlook := true
	}

	item := olApp.CreateItemFromTemplate(msgPath)
	info := item.body
	subject := item.subject
	FileAppend, %info%, %A_ScriptDir%\tempMail\Process\%thisOrdernumber%_manus_%subject%.txt, UTF-8
	attachments := item.attachments
	For attachment in item.attachments
	{
		attachment.SaveAsFile(A_ScriptDir . "\tempMail\Process\" . thisOrdernumber . "_" . attachment.FileName)
		thisfile := A_ScriptDir . "\tempMail\Process\" . thisOrdernumber . "_" . attachment.FileName
		if (InStr(thisfile, "image0"))
		{
			stayandwait := true
			gosub, showPreviewGui
			while (stayandwait)
			{
				; Gör ingenting förrän användaren agerat på UIt
			}
		}
		if (InStr(thisfile, ".zip"))
		{
			thisnewfile := StrReplace(thisfile, ".zip", ".zip.ico")
			FileMove, %thisfile%, %thisnewfile%
		}
		WinClose, Ladda upp mail

	}

	FileCopy, %A_ScriptDir%\tempMail\Process\*.*, \\nt.se\Adbase\System\Import\Digital Produktion\*.*
	FileDelete, %msgPath%
	if(CloseOutlook)
		olApp.Quit
return

showPreviewGui:
	gui, previewMsg:Add, Text, , Vill du spara denna fil?
	gui, previewMsg:Add, Text, , %thisfile%
	Gui, previewMsg:Add, Picture, w200 h-1, %thisfile%
	gui, previewMsg:Add, button, w90 gSave, Ja
	gui, previewMsg:Add, button, xp+100 yp w90 gDontSave +Default, Nej
	gui, previewMsg:Show,,Vill du spara denna bild?
return

save:
	Gui, previewMsg:Destroy
	stayandwait := false
return

dontsave:
	Gui, previewMsg:Destroy
	FileDelete, %thisfile%
	stayandwait := false
return

compMailGuiClose:
	gui, compmail:Destroy
return

dropGui:
	Gui, drop:Destroy
	Gui, drop:Add, Text, , Ange ett namn på komponenten:
	Gui, drop:Add, Edit, vDropname w400, %dropFileNameNoExt%
	Gui, drop:Add, Button, gDropAction , Lägg in material
	Gui, drop:Show,,Lägg till komponent
return

dropAction:
	Gui, drop:Submit
	filename := thisOrdernumber . "_" . dropname . "." . dropFileExt
	if(dropFileExt = "zip")
	{
		filename := filename . ".ico"
	}
	console_log(dropFilePath)
	copyPath := "\\nt.se\Adbase\System\Import\Digital Produktion\" . filename
	console_log(copyPath)
	Run, xcopy "%dropFilePath%" "%copyPath%"
	WinWaitActive, xcopy
	sleep, 100
	Send, f
return

componentRun:
	if (A_GuiEvent = "RightClick")
	{
		row := A_EventInfo
		LV_GetText(id, row, 3)
		LV_GetText(name, row, 1)
		extension := StrSplit(name, ".")
		extension := extension[extension.MaxIndex()]

		id_length := strLen(id)
		toRemove := id_length - 2
		StringTrimLeft, pre_id, id, %toremove%
		if (extension = "zip")
		{
			path:= "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\Original\" . id . ".ico"
		}
		else
		{
			path:= "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\Original\" . id . "." . extension
		}
		
		menu, compmenu, Add, Endast detta ordernummer, filterComponents
		menu, compmenu, Add, Spara komponent(er), saveComponent
		menu, compmenu, Show

	}
	if (A_GuiEvent = "Normal")
	{
		row := A_EventInfo
		LV_GetText(id, row, 3)
		LV_GetText(name, row, 1)
		
		id_length := strLen(id)
		toRemove := id_length - 2
		StringTrimLeft, pre_id, id, %toremove%
		path_low := "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\LowRes\" . id . ".jpg"
		path_high := "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\HighRes\" . id . ".jpg"
		IfExist, %path_high%
		{
			GuiControl,comp:,prev_pic, *w200 *h-1 %path_high%
			console_log(path_high)
		}
		Else
		{
			GuiControl,comp:,prev_pic, *w200 *h-1 %path_low%
			console_log(path_low)
		}
	}
return

filterComponents:
	if(!compCheck)
	{
		GuiControl, comp:,compedit, %thisOrdernumber%
		menu, compmenu, Check, Endast detta ordernummer
		checkrunonce := 1
		compCheck := true
	}
	Else
	{
		GuiControl, comp:,compedit, 
		menu, compmenu, Uncheck, Endast detta ordernummer
		compCheck := false
		checkrunonce := 0
	}
	gosub, compedit
return

saveComponent:
	Gui, comp:ListView, list
	Gui, comp:Default
	GuiControlGet, tabsel, , TabCtrl, comp:
	console_log(tabsel)
	if(tabsel = 1)
	{
		gui, comp:ListView, list_order
	}
	numSelected := LV_GetCount("S")
	console_log(numSelected)
	if (numSelected = 1)
	{
		FileSelectFolder, selPath, ,3, Välj var du vill spara din komponent
		FileCopy, %path%, %selPath%\%name%
	}
	else
	{
		FileSelectFolder, selPath, ,3, Välj var du vill spara dina komponenter
		rownum := 0
		if (selPath)
		{
			Loop
			{
				rownum := LV_GetNext(rownum)
				console_log("nästa vald rad: " . rownum)
				if (!rownum) ; Om det inte finns någon vald rad kvar
					break ; avbryt

				LV_GetText(name, rownum, 1)
				LV_GetText(id, rownum, 3)
				extension := StrSplit(name, ".")
				extension := extension[extension.MaxIndex()]

				id_length := strLen(id)
				toRemove := id_length - 2
				StringTrimLeft, pre_id, id, %toremove%
				if (extension = "zip")
				{
					path:= "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\Original\" . id . ".ico"
				}
				else if (extension = "jpeg")
				{
					path:= "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\Original\" . id . ".jpg"
					name := StrReplace(name, ".jpeg", ".jpg")
				}
				else if (extension = "text")
				{
					path:= "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\Original\" . id . ".txt"
					name := StrReplace(name, ".text", ".txt")
				}
				else
				{
					path:= "\\nt.se\Adbase\Komponenter\" . pre_id . "\" . id . "\Original\" . id . "." . extension
				}
				FileCopy, %path%, %selPath%\%name%
				console_log("fil att spara: " . path)
				console_log("sparar: " . selPath . "\" . name)
			}
		}
	}
return

preview:
	Gui, prev:Destroy
	IfExist, %path_high%
	{
		Gui, prev:Add, Picture, w900 h-1, %path_high%
	}
	Else
	{
		Gui, prev:Add, Picture, w900 h-1, %path_low%
	}
	Gui, prev:Show,, Förhandsvisar: %name%

	GetKeyState, keystate, LButton,P

	while (keystate != "U")
		GetKeyState, keystate, LButton,P

	Gui, prev:Destroy
return

compedit:
	GuiControl, Choose, tabctrl, 2
	Gui, ListView, list
	Gui, comp:Submit, NoHide
	search := compedit
	; Töm hela listan
	LV_Delete()

	if(search)
	{
		Loop, Parse, full_list, `,
		{
			StringSplit, array, A_LoopField, |
			loopname := array1
			create := array2
			loopID := array3
			If(InStr(loopname, search))
			{
				LV_Add("", loopname, create, LoopId)
			}
		}
	}
	Else
	{
		Loop, Parse, full_list, `,
		{
			StringSplit, array, A_LoopField, |
			loopname := array1
			create := array2
			loopID := array3
			LV_Add("", loopname, create, loopId)
		}
	}
return