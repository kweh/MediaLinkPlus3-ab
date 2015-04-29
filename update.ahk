updateStart:
	FileDelete, %dir_update%\MedialinkPlus.msi
	UrlDownloadToFile, http://kweh.github.io/MediaLinkPlus/mlp/version.txt, %dir_update%\version.txt
	FileRead, newversion, %dir_update%\version.txt
	FileDelete, %dir_update%\version.txt
	if (newversion > version)
	{
		msgbox,4,Ny version tillgänglig, Det finns en ny version av Medialink Plus. Vill du ladda ned och installera den? Medialink Plus kommer att stängas ned när uppdateringen startar.
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
	FileRead, newversion, %dir_update%\version.txt
	FileDelete, %dir_update%\version.txt
	if (newversion > version)
	{
		msgbox,4,Ny version tillgänglig, Det finns en ny version av Medialink Plus. Vill du ladda ned och installera den? Medialink Plus kommer att stängas ned när uppdateringen startar.
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



