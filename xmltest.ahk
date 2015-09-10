FileRead, data, xml.xml
ordernummer = 0001835941-04
test := ab_xmlFind(data, ordernummer, "FlightGroup", "Flight", "InvoiceText")
msgbox % test
ab_getDimensions(data, ordernummer)

ab_xmlFind(DATA, ordernummer, str*)
{
  i := 1
  regex := "ms)<CampaignNumber>" ordernummer "</CampaignNumber>"
  num_str := str.MaxIndex()
  ett := str[i]
  while (i <= num_str)
  {
    string := str[i]
    regex := regex ".+? <" string ">"
    i++
  }
  last := i-1
  regex := regex "(.+?)</" str[last] ">"
  RegExMatch(DATA, regex, catch)
  StringReplace, catch, catch1, &amp`;, &, A
  return catch
}

ab_getDimensions(DATA, ordernummer)
{
  regex := "ms)<CampaignNumber>" ordernummer "</CampaignNumber>.+?<CampaignUnit>.+?<Width>(.+?)</Width>.+?<Height>(.+?)</Height>"
  RegExMatch(DATA, regex, catch)
  msgbox % "W: " catch1 "`nH: " catch2
}

checkFormat(w,h)
{
  ; Bredd 468
  if (w = "468") 
  {
    format := h = "120"         ? "NTFB"  : mlTidning
  }
}