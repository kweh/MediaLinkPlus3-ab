support_material(ordernr, email, subject, state)
{
	body = 
(
Hej,<br />
Vi saknar material/manus för (%ordernr%).<br />
Vi skulle uppskatta om ni, så snart som möjligt, kunde maila in detta till digital.material@ntm.eu och även svara på detta mail med information om att material/manus har lämnats.<br />
<br />
Deadline för inlämning av material/manus är två arbetsdagar innan införande. Sen leverans ökar risken för att annonsen startar sent.	<br />
<br />
Hälsningar,<br />
Digital Produktion
)

StringReplace, previewBody, body, <br />,, All
msgbox,4,, Skicka följande meddelande till %email%?`n====================================================`n`n%previewBody%
IfMsgBox, Yes
{
  body := UriEncode(body)
  stripLocal(subject)

  URL =  https://api.groovehq.com/v1/tickets?access_token=098f7a6eb82088a51d1443b539ba36efc21ab436ded6bc688a1bac1bfe3852ed&body=%body%&from=digital.support@ntm.eu&send_copy_to_customer=true&to=%email%&subject=%subject%&state=%state%
  DATA := ""
  HEAD = Content-Type: application/json
  OPTS = Method: POST
  HTTPRequest( URL, DATA, HEAD, OPTS )
  WinActivate, NewsCycle MediaLink
  return true
}
Else
{
  return false
}
}

support_manus(ordernr, email, subject, state)
{
	body = 
(
Hej,<br />
Din bokade kampanj (%ordernr%) saknar interna noteringar och kan därför inte produceras.<br />
Var vänlig korrigera detta och svara på detta mail när det är gjort.<br />
<br />
För att säkerställa att kampanjen startar i tid rekommenderas du att flytta fram din order så att vi har minst 2 arbetsdagars produktionstid från det att manus och material inkommit till oss.<br />
Om detta inte är möjligt vill vi flagga för att vi kommer att prioritera de annonser som inkommit med manus/material i tid högst. Vid hög belastning kan det i värsta fall resultera i en försenad kampanjstart.<br />
<br />
Hälsningar,<br />
Digital Produktion
)

StringReplace, previewBody, body, <br />,, All
msgbox,4,, Skicka följande meddelande till %email%?`n====================================================`n`n%previewBody%
IfMsgBox, Yes
{

  body := UriEncode(body)
  stripLocal(subject)

  URL =  https://api.groovehq.com/v1/tickets?access_token=098f7a6eb82088a51d1443b539ba36efc21ab436ded6bc688a1bac1bfe3852ed&body=%body%&from=digital.support@ntm.eu&send_copy_to_customer=true&to=%email%&subject=%subject%&state=%state%
  DATA := ""
  HEAD = Content-Type: application/json
  OPTS = Method: POST
  HTTPRequest( URL, DATA, HEAD, OPTS )
  return true
}
Else
{
  return false
}
}

support_fardigt(ordernr, email, subject, state)
{
  body = 
(
Hej,<br />
Vi saknar färdigt material för (%ordernr%).<br />
Vi skulle uppskatta om ni, så snart som möjligt, kunde maila in materialet till digital.material@ntm.eu och även svara på detta mail med information om att material har lämnats.<br />
<br />
Deadline för inlämning av färdigt material är kl 12.00 en arbetsdag innan införande. Sen leverans ökar risken för att annonsen startar sent.<br />
<br />
Hälsningar,<br />
Digital Produktion
)

StringReplace, previewBody, body, <br />,, All
msgbox,4,, Skicka följande meddelande till %email%?`n====================================================`n`n%previewBody%
IfMsgBox, Yes
{
  body := UriEncode(body)
  stripLocal(subject)

  URL =  https://api.groovehq.com/v1/tickets?access_token=098f7a6eb82088a51d1443b539ba36efc21ab436ded6bc688a1bac1bfe3852ed&body=%body%&from=digital.support@ntm.eu&send_copy_to_customer=true&to=%email%&subject=%subject%&state=%state%
  DATA := ""
  HEAD = Content-Type: application/json
  OPTS = Method: POST
  HTTPRequest( URL, DATA, HEAD, OPTS )
  return true
}
Else
{
  return false
}
}

support_prodtid(ordernr, email, subject, state)
{
  body = 
(
Hej,<br />
Din kampanj (%ordernr%) är inbokad på ett sätt som innebär att vi inte har 2 dagars produktionstid.<br />
Allt material för produktion ska vara Digital Produktion tillhanda senast 2 arbetsdagar innan kampanjstart. Om materialet annonsen ska produceras efter är en printannons måste denna vara klar innan vår deadline.<br />
<br />
Vi rekommenderar att du antingen flyttar fram startdatum på kampanjen eller skickar in material separat till digital.material@ntm.eu.<br />
<br />
Kampanjer där material inte finns tillgängligt innan deadline kommer att prioriteras ned.<br />
<br />
Hälsningar,<br />
Digital Produktion
)

StringReplace, previewBody, body, <br />,, All
msgbox,4,, Skicka följande meddelande till %email%?`n====================================================`n`n%previewBody%
IfMsgBox, Yes
{
  body := UriEncode(body)
  stripLocal(subject)

  URL =  https://api.groovehq.com/v1/tickets?access_token=098f7a6eb82088a51d1443b539ba36efc21ab436ded6bc688a1bac1bfe3852ed&body=%body%&from=digital.support@ntm.eu&send_copy_to_customer=true&to=%email%&subject=%subject%&state=%state%
  DATA := ""
  HEAD = Content-Type: application/json
  OPTS = Method: POST
  HTTPRequest( URL, DATA, HEAD, OPTS )
  return true
}
Else
{
  return false
}
}

support_custom(subject, body, email, state, tag)
{
  StringReplace, body, body, `n, <br />, All
  body := UriEncode(body)
  ; stripLocal(subject)
  subject := UriEncode(subject)

  URL =  https://api.groovehq.com/v1/tickets?access_token=098f7a6eb82088a51d1443b539ba36efc21ab436ded6bc688a1bac1bfe3852ed&body=%body%&from=digital.support@ntm.eu&send_copy_to_customer=true&to=%email%&subject=%subject%&state=%state%&tags=%tag%
  DATA := ""
  HEAD = Content-Type: application/json
  OPTS = Method: POST
  HTTPRequest( URL, DATA, HEAD, OPTS )
  WinActivate, NewsCycle MediaLink

}

customSupportClose:
    Gui, customSupport:Destroy
  Return

