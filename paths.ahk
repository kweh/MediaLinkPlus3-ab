version = 2.45

mlpDir = G:\NTM\NTM Digital Produktion\MedialinkPlus\user\%A_UserName% ; Sätter användarens användarmapp
ifNotExist, %mlpDir% ; om mappen inte finns
	FileCreateDir, %mlpDir% ; skapa mappen

cxDir = %A_AppData%\MLP\cx
IfNotExist, %cxDir%
	FileCreateDir, %cxDir%
IfNotExist, %mlpDir%\skin
	FileCreateDir, %mlpDir%\skin

devDir = G:\NTM\NTM Digital Produktion\MedialinkPlus\dev
iconDir = G:\NTM\NTM Digital Produktion\MedialinkPlus\dev\ico ; Sätter mapp för ikoner
templateDir = G:\NTM\NTM Digital Produktion\MedialinkPlus\assets\toCopy ; Sätter mapp för psd- pch fla-mallar
webbannonsDir = G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\%A_YYYY%
lagerDir = X:\digital.ntm.eu\lager
weblinkDir = X:\digital.ntm.eu\weblink
notesDir = G:\NTM\NTM Digital Produktion\MedialinkPlus\mlNotes
mlpSettings = %mlpDir%\settings.ini 
IfNotExist, %mlpSettings%
	{
	IniWrite, ERROR, %mlpDir%\settings.ini, Settings, Skin
	IniWrite, 1, %mlpDir%\settings.ini, Settings, NoteWin
	}	

mlpKolumner = %mlpDir%\kolumner.ini
FileAppend,,%mlpDir%\settings.ini
IniWrite, %version%, %mlpSettings%, Version, Version

IniRead, mainVersion, G:\NTM\NTM Digital Produktion\MedialinkPlus\dev\master.ini, Version, Version