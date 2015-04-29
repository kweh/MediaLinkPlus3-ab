version = 3.00

dir_cxense = %A_WorkingDir%\cxense
dir_skins = %A_WorkingDir%\skins
dir_icons = %A_WorkingDir%\ico 
dir_templates = %A_WorkingDir%\templates ; Sätter mapp för psd- pch fla-mallar
dir_webbannons = G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\%A_YYYY%
dir_img = %A_WorkingDir%\img
dir_ftp = %A_WorkingDir%\ftp
dir_update = %A_WorkingDir%\update
lagerDir = X:\digital.ntm.eu\lager
weblinkDir = X:\digital.ntm.eu\weblink
notesDir = G:\NTM\NTM Digital Produktion\MedialinkPlus\mlNotes
mlpSettings = %A_WorkingDir%\settings\settings.ini
dir_filecheck = %A_WorkingDir%\filecheck
mlp_filechecklist = %A_WorkingDir%\filecheck\list.txt
; IfNotExist, %mlpSettings%
; 	{
; 	msgbox, Du saknar för närvarande inställningar för kolumner. Högerklicka på en order i Medialink och välj "inställningar" följt av "kolumner" för att ställa in detta.
; 	IniWrite, ERROR, %mlpDir%\settings.ini, Settings, Skin
; 	IniWrite, 1, %mlpDir%\settings.ini, Settings, NoteWin
; 	}
mlpKolumner = %A_WorkingDir%\settings\kolumner.ini
