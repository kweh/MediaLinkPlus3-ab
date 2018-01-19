multiLink:
	IfNotExist, C:\Program Files\Sandboxie\Start.exe
	{
		MsgBox, 4, Program saknas, Möjligheten att öppna ett ytterligare MediaLink-fönster kräver programmet Sandboxie. Vill du ladda hem det?
		IfMsgBox, Yes
		{
			Run, http://www.sandboxie.com/attic/SandboxieInstall64-512.exe
		}
	}
	else
	{
		Run, C:\Program Files\Sandboxie\Start.exe C:\Program Files (x86)\NEWSCYCLE Solutions\MediaLink\bin\MediaLink.exe, C:\Program Files (x86)\NEWSCYCLE Solutions\MediaLink\bin
		WinWaitActive, [#] MediaLink Login,,5
		if (ErrorLevel = 1)
		{
			MsgBox,, Fel, Kunde inte hitta inloggningsfönster.
			return
		}

		Send, {Enter}
	}
return

multiLinkOpenNew:
	Gosub, multiLink
	WinWaitActive, [#] NewsCycle MediaLink,,10
	if (ErrorLevel = 1)
		{
			MsgBox,, Fel, Kunde inte hitta MediaLink-fönster.
			return
		}
	Sleep, 3000
	Control, ChooseString, Alla annonser, ComboBox1, [#] NewsCycle MediaLink
	StringSplit, split, mlOrdernummer, -
	justOrder := split1
	Control, EditPaste, %justOrder%, Edit1, [#] NewsCycle MediaLink
	ControlFocus, Edit1, [#] NewsCycle MediaLink
	Send, {Enter}

return
