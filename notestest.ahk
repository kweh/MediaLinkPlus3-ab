mlNoteringar =
(
Samma material som -04`r`n
`r`n
Placering:`r`n
http://gotland.net/ata`r`n
Länkas:`r`n
http://gotland.net/ata/nyarssupeer-catering`r`n
)

console_log(adnsplitText(mlNoteringar))


adnSplitText(text)
{
	split := StrSplit(text, "`r`n")
	Loop, % split.MaxIndex()
	{
		row := split[A_Index]
		; rex := "(http[s]?:\/\/|www.).+?\s"
		rex := "(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"
		RegExMatch(row, rex, match)
		newUrl := "<a href=""" . match . """ target=""_blank"">" . match . "</a>"
		row := StrReplace(row, match, newUrl)

		splat := splat . row . "<br>"
	}
	return splat
}




console_log(text)
{
	FormatTime, time, ,HH:mm:ss
	FileAppend, %time%: %text%`n, *, UTF-8
}