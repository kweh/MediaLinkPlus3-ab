fc_check:
	StringTrimRight, ordernummerutanmnr, mlOrdernummer, 3
	ordernummerutanmnr := ordernummerutanmnr "-01"
	gui, 55:add, Edit, x8 y3 w150 h20 vprint, %ordernummerutanmnr%
	gui, 55:add, Button, x54 y25 w50 h25 gfc_save default, Spara  
	gui, 55:show
return

55GuiClose:
	gui, 55:destroy
return

fc_save:
	gui, 55:submit
	gui, 55:destroy
	print_txt = %mlKundnamn% | %print%`n
	FileAppend, %print_txt%, %mlp_filechecklist%
	FileAppend, false, %dir_filecheck%\%print%.txt
return

fc_clear:
	msgbox, 4, Rensa övervakningslista, Detta rensar övervakningslistan.
	IfMsgBox, Yes
	{
		Loop, %dir_filecheck%\*.txt, 0,0
		{
			FileDelete, %A_LoopFileFullPath%
		}
		FileAppend, ,%mlp_filechecklist%
		msgbox, Övervakningslistan rensad!
	}
return

fc_go:
	write =
	Loop, read, %mlp_filechecklist%
		{
			addLine = %A_LoopReadLine%
			IfNotInString, A_LoopReadLine, +
			{
				StringSplit, line, A_LoopReadLine, |
				StringSplit, order, line2, -
				StringReplace, line2, line2, %A_Space%,, All
				order2 = -%order2%
				file := printcheck(line2, order2)
				if (file = "print" || file = "bild")
				{
					addLine = + %A_LoopReadLine%
					Traytip, Printannons hittad!, Hittade printmaterial för %line1% - %line2%.,10, 1
				}
			}
			write = %write%%addLine%`n
		}
		FileDelete, %mlp_filechecklist%
		FileAppend, %write%, %mlp_filechecklist%
return


fc_select:
	IfNotInString, A_ThisMenuItem, +
	{
		Msgbox, 4, Ingen print finns, Ingen print har hittats på detta ordernummer än. Ta bort övervakning?
		IfMsgBox, Yes
		{
			write = 
			StringSplit, line, A_ThisMenuItem, |
			StringSplit, order, line2, -
			StringReplace, line2, line2, %A_Space%,, All
			order2 = -%order2%
			FileDelete, %dir_filecheck%\%line2%.txt
			Loop, read, %mlp_filechecklist%
			{
				addLine = %A_LoopReadLine%
				IfInString, A_LoopReadLine, %line2%
				{
					addLine := ""
				}
				if (addline != "")
				{
					write = %write%`n%addLine%
				}
			}
			FileDelete, %mlp_filechecklist%
			FileAppend, %write%, %mlp_filechecklist%
		}
	}
	IfInString, A_ThisMenuItem, +
	{
		msgbox,4, Print finns, En printannons har hittat på detta ordernummer. Visa och ta bort bevakning?
		IfMsgBox, Yes
		{
			write = 
			StringSplit, line, A_ThisMenuItem, |
			StringSplit, order, line2, -
			StringReplace, line2, line2, %A_Space%,, All
			order2 = -%order2%
			file := printcheck(line2, order2)
			FileDelete, %dir_filecheck%\%line2%.txt
			Loop, read, %mlp_filechecklist%
			{
				addLine = %A_LoopReadLine%
				IfInString, A_LoopReadLine, %line2%
				{
					addLine := ""
				}
				if (addline != "")
				{
					write = %write%`n%addLine%
				}
			}
			FileDelete, %mlp_filechecklist%
			FileAppend, %write%, %mlp_filechecklist%
			from_fc := true
			gosub, pdf-preview
		}
	}
return