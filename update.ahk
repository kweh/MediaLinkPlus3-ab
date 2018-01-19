updateStart:
	FileDelete, %dir_update%\MedialinkPlus.msi
	UrlDownloadToFile, https://raw.githubusercontent.com/kweh/MediaLinkPlus3-ab/html/version.txt, %dir_update%\version.txt
	UrlDownloadToFile, https://raw.githubusercontent.com/kweh/MediaLinkPlus3-ab/html/nyheter.txt, %dir_update%\nyheter.txt

	FileRead, newversion, %dir_update%\version.txt
	FileRead, nyheter, %dir_update%\nyheter.txt

	FileDelete, %dir_update%\version.txt
	FileDelete, %dir_update%\nyheter.txt
	if (newversion > version)
	{
		msgbox,4,Ny version tillgänglig, Det finns en ny version av Medialink Plus.`n`n%nyheter%`n`n Vill du ladda ned och installera? Medialink Plus kommer att stängas ned när uppdateringen startar.
		IfMsgBox, yes
		{
			Splashimage,,,Laddar ned uppdatering, Laddar ned..., Uppdatering
			UrlDownloadToFile, http://kweh.github.io/MediaLinkPlus/mlp/MedialinkPlus.msi, %dir_update%\MedialinkPlus.msi
			Splashimage, Off
			Run, %dir_update%\MedialinkPlus.msi
			ExitApp 
		}
	}
return

update:
	FileDelete, %dir_update%\MedialinkPlus.msi
	UrlDownloadToFile, http://kweh.github.io/MediaLinkPlus/mlp/version.txt, %dir_update%\version.txt
	UrlDownloadToFile, http://kweh.github.io/MediaLinkPlus/mlp/nyheter.txt, %dir_update%\nyheter.txt

	FileRead, newversion, %dir_update%\version.txt
	FileRead, nyheter, %dir_update%\nyheter.txt

	FileDelete, %dir_update%\version.txt
	FileDelete, %dir_update%\nyheter.txt
	if (newversion > version)
	{
		msgbox,4,Ny version tillgänglig, Det finns en ny version av Medialink Plus.`n`n%nyheter%`n`n Vill du ladda ned och installera? Medialink Plus kommer att stängas ned när uppdateringen startar.
		IfMsgBox, yes
		{
			Splashimage,,,Laddar ned uppdatering, Laddar ned..., Uppdatering
			UrlDownloadToFile, http://kweh.github.io/MediaLinkPlus/mlp/MedialinkPlus.msi, %dir_update%\MedialinkPlus.msi
			Splashimage, Off
			Run, %dir_update%\MedialinkPlus.msi
			ExitApp 
		}
	}
	if (newversion = version)
	{
		msgbox, Det finns ingen ny version för närvarande. :(
	}
return



