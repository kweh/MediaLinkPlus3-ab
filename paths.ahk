version = 3.00

dir_cxense = %A_WorkingDir%\cxense
dir_skins = %A_WorkingDir%\skins
dir_icons = %A_WorkingDir%\ico 
dir_templates = %A_WorkingDir%\templates ; Sätter mapp för psd- pch fla-mallar
dir_webbannons = G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\%A_YYYY%
dir_img = %A_WorkingDir%\img
lagerDir = X:\digital.ntm.eu\lager
weblinkDir = X:\digital.ntm.eu\weblink
notesDir = G:\NTM\NTM Digital Produktion\MedialinkPlus\mlNotes
mlpSettings = %A_WorkingDir%\settings\settings.ini
IfNotExist, %mlpSettings%
	{
	IniWrite, ERROR, %mlpDir%\settings.ini, Settings, Skin
	IniWrite, 1, %mlpDir%\settings.ini, Settings, NoteWin
	}
mlpKolumner = %A_WorkingDir%\settings\kolumner.ini
