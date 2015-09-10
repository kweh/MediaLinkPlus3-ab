#include paths.ahk



folder := "C:\Users\dennis.stromberg\Desktop\Temp"
files := list_files(folder)
Sort, files, D

Loop, parse, files, `n
{
	if (A_LoopField != "")
	{
		IfInString, A_LoopField, .jpg
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\shell32_63001.ico
		}
		IfInString, A_LoopField, .png
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\shell32_63001.ico
		}
		IfInString, A_LoopField, .gif
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\shell32_63001.ico
		}
		IfInString, A_LoopField, .fla
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\Flash_2.ico
		}
		IfInString, A_LoopField, .swf
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\Flash_3.ico
		}
		IfInString, A_LoopField, .psd
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\Photoshop_1001.ico
		}
		IfInString, A_LoopField, .mp4
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\shell32_224.ico
		}
		IfInString, A_LoopField, .avi
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\shell32_224.ico
		}
		IfInString, A_LoopField, .mov
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\shell32_224.ico
		}
		IfInString, A_LoopField, .pdf
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\AcroRd32_2.ico
		}

		; Mapphantering
		IfInString, A_LoopField, +%A_Space%
		{
			menu, dblclck, icon, %A_LoopField%, %dir_icons%\shell32_4.ico

		}

		IfNotInString, A_LoopField, +%A_Space%
		{
			menu, dblclck, add, %A_LoopField%, GoFile
		}
	}
}

menu, dblclck, show
return 

GoFile:
	IfInString, A_ThisMenuItem, +%A_Space%
	{
		StringReplace, item, A_ThisMenuItem, +%A_Space%,, All
		run, %folder%\%item%
	}
	else
	{
		run, %folder%\%A_ThisMenuItem%
	}
return

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

isFolder(folder)
{
	IfInString, folder, +%A_Space%
}