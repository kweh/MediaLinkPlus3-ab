cx_start:
  Progress, R0-4 FM8 FS7 CBGray P1, Kontrollerar om kund finns..., Kundsök:, Annonsbokning
  xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
  kund = - %mlKundnr% -
  folderId := cx_xml_read(xml, "childFolder", kund, "folderId")

  format := getFormat(mlEnhet)
  campaignName := mlTidning " - " format " - " mlOrdernummer
  folderName := mlTidning " - " mlKundnr " - " mlKundnamn

  if (folderID = "") ; Om kund saknas
  {
    Progress, 2, Kund saknas!, Kundsök:, Annonsbokning
    sleep, 300
    Progress, Off
    goto, kundSaknas
  }
  Progress, 2, Kund fanns, fortsätter., Kundsök:, Annonsbokning
  sleep, 300

  Progress, 3, Kontrollerar om kampanj finns., Kundsök:, Annonsbokning

  xml := get_url("cxad.cxense.com/api/secure/campaigns/" folderId)
  campaignId := cx_xml_read(xml, "campaign", mlOrdernummer, "campaignId")
  if (campaignId != "")
  {
    SetTimer, knappnamn, 10 
    msgbox, 4403, Kampanj finns redan ,Kampanjen du försöker boka finns redan i Cxense. ; 3 + 4096 + 256 + 48
    IfMsgBox, Yes
    {
      Progress, 4, Öppnar bokningsfönster, Kundsök:, Annonsbokning
      sleep, 200
      Progress, Off

      Gui, 77:Destroy
      goto, cx_ui
    }

    IfMsgBox, No
      Run, https://cxad.cxense.com/adv/campaign/%campaignId%
      Progress, Off
      return
    IfMsgBox, Cancel
      Progress, Off
      return
  }

  Progress, 4, Öppnar bokningsfönster, Kundsök:, Annonsbokning
  sleep, 200
  Progress, Off

  Gui, 77:Destroy
  goto, cx_ui
return

knappnamn: 
IfWinNotExist, Kampanj finns redan
    return  ; Keep waiting.
SetTimer, knappnamn, off 
WinActivate 
ControlSetText, Button1, &Fortsätt boka
ControlSetText, Button2, &Öppna i CX 
ControlSetText, Button3, &Avbryt
return

cx_ui:
; Sätter rätt format på start och stoppdatum samt varnar om startdatum passerat
  StringReplace, mlStartdatumStrip, mlStartdatum, - ,, All
  StringReplace, mlStoppdatumStrip, mlStoppdatum, - ,, All
  StringTrimLeft, mlStartdatumStripYY, mlStartdatumStrip, 2
  FormatTime, idag, , yyyyMMdd
  checkDate := mlStartdatumStrip - idag
  if (checkDate < 0)
  {
    MsgBox,48,Fel i startdatum, Startdatumet på kampanjen har redan passerat. `r`nDagens datum har satts som startdatum istället.
    mlStartdatumStrip = %idag%
  }
FileRead, Target, G:\NTM\NTM Digital Produktion\MedialinkPlus\dev\target.txt

Gui, 77:Font, S15 CDefault, Arial
Gui, 77:Add, Edit, x12 y10 w400 h30 vcampaignName , %campaignName%
Gui, 77:Font, S11 CDefault, Arial
Gui, 77:Add, Edit, x12 y47 w262 h25 , %folderName%
Gui, 77:Add, DropDownList, x282 y47 w130 h25 r7 gType vType, Run On Site||Riktad|Plugg|Retarget|CPC
Gui, 77:Font, S8 CDefault, Arial
Gui, 77:Add, GroupBox, x12 y80 w400 h230 , Kontrakt
Gui, 77:Font, S11 CDefault, Arial
Gui, 77:Add, DateTime, x32 y130 w160 h30 vStartdatum Choose%mlStartdatumStrip%, yyyy-MM-dd
Gui, 77:Add, DateTime, x232 y130 w160 h30 vStoppdatum Choose%mlStoppdatumStrip%, yyyy-MM-dd
Gui, 77:Font, S9 CDefault, Arial
Gui, 77:Add, Text, x32 y110 w90 h20 , Startdatum
Gui, 77:Add, Text, x232 y110 w100 h20 , Stoppdatum
Gui, 77:Add, Text, x32 y170 w100 h20 , Exponeringar
Gui, 77:Font, S11 CDefault, Arial
Gui, 77:Add, Edit, x32 y190 w360 h30 vExponeringar, %mlExponeringar%
Gui, 77:Add, ComboBox, x32 y260 w360 h20 vKeyword R10, %target%
Gui, 77:Font, S10 CDefault, Arial
Gui, 77:Font, S9 CDefault, Arial
Gui, 77:Add, Text, x32 y240 w100 h20 , Styrning
Gui, 77:Add, Button, x202 y320 w100 h30 Default gBoka vBoka, Boka
Gui, 77:Add, Button, x312 y320 w100 h30 g77GuiClose, Avbryt
GuiControl, 77:Focus, boka
Gui, 77:Show, xCenter yCenter h364 w424, Bokningsöversikt
; Winset, Transparent, 200, Bokningsöversikt

Return

77GuiClose:
  Gui, 77:Destroy
return

Type:
  Gui, 77:Submit, NoHide
  if (Type = "Retarget" || Type = "CPC" || Type = "Plugg")
  {
    GuiControl, Disable, Exponeringar
  } else {
    GuiControl, Enable, Exponeringar
  }
return
,
Boka:
  Gui, 77:Submit
  prog := 5
  prog_on := true

  ;Keywords-listan
  IfNotInString, Target, %Keyword%
  {
    FileAppend, %Keyword%|, G:\NTM\NTM Digital Produktion\MedialinkPlus\dev\target.txt
  }

  FormatTime, Startdatum, %Startdatum%, yyyy-MM-dd
  FormatTime, Stoppdatum, %Stoppdatum%, yyyy-MM-dd

  Progress, R0-100 FM8 FS7 P5 CBGray M, Kontrollerar produkt..., Bokningsförlopp:, Annonsbokning
  Progress, Show
  Progress, %prog%
  sleep, 200

  prod := cxProduct(format, type)
  productId := prod.prodID
  sitetargetingID := prod.siteTargetingID
  keywordsID := prod.keywordsID
  cost := prod.cost

  campaign := cx_post_campaign(campaignName, mlKundnr, mlEnhet, format, Type, productId, prog_on)
  campaignID := campaign.Id
  sleep, 100

  prog := 40
  Progress, %prog%, Bokar kontrakt..., Bokningsförlopp:, Annonsbokning
  contract := cx_post_contract(campaign.Id, cost, Startdatum, Stoppdatum, Exponeringar)

  prog := 50
  Progress, %prog%, Sätter site targeting..., Bokningsförlopp:, Annonsbokning


  if (sitetargetingID != "")
  {
    sitetargeting := cx_post_sitetargeting(campaign.Id, mlSite, sitetargetingID)
    ; msgbox % sitetargeting
  }
  if (sitetargetingID = "")
  {
    msgbox, Kunde inte sätta site targeting, gör detta manuellt.
  }

  prog := 60
  Progress, %prog%, Sätter keywords..., Bokningsförlopp:, Annonsbokning
  if (keywordsID != "")
  {
    keyword := cx_post_keywords(campaign.Id, Keyword, keywordsID)
    ; msgbox % keyword
  }
  if (keywordsID = "" && Keyword != "")
  {
    msgbox, Kunde inte sätta keyword, gör detta manuellt.
  }

  prog := 80
  Progress, %prog%, Namnger advertisement..., Bokningsförlopp:, Annonsbokning
  advertisement := cx_post_advertisement(campaign.Id, mlKundnamn, mlStartdatumStrip)

  prog := 100
  Progress, %prog%, Bokning klar!, Bokningsförlopp:, Annonsbokning
  sleep, 800
  Progress, OFF
  prog_on := false
  MsgBox,4, Bokning klar, Inbokning klar, öppna i webbläsaren?
  IfMsgBox, Yes
    run, https://cxad.cxense.com/adv/campaign/%campaignID%/overview
  IfMsgBox, No
    return
return



; Hämtar
get_url(path)
{
  URL = https://%cxUser%@%path%
  DATA := ""
  HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==
  OPTS = 
  HTTPRequest( URL, DATA, HEAD, OPTS )
  return data
}

cx_xml_read(xml, folder, key, value)
{
  StringReplace, xml, xml, cx:,, All ; Tar bort CX: namespace
  StringReplace, xml, xml, <%folder%>, £, All ; Letar efter %folder%
  Loop, parse, xml, £
  {
    IfInString, A_LoopField, %key%
    {
      regex := "<" value ">(.{16})</" value ">"
      RegExMatch(A_LoopField, regex,test)
      return test1
    }
  }
}


cx_xml_read_sub(xml, folder, sub, key, value)
{
  StringReplace, xml, xml, cx:,, All ; Tar bort CX: namespace
  StringReplace, xml, xml, <%folder%>, £, All ; Letar efter %folder%
  Loop, parse, xml, £
  {
    StringReplace, loop2, A_LoopField, <%sub%>, €, All
    Loop, parse, loop2, €
    {
      IfInString, A_LoopField, %key%
      {
        regex := "<" value ">(.{16})</" value ">"
        RegExMatch(A_LoopField, regex,test)
        return test1
      }
    }
  }
}

cx_xml_read_template(xml, folder, sub, key, value)
{
  StringReplace, xml, xml, cx:,, All ; Tar bort CX: namespace
  StringReplace, xml, xml, %folder%, £, All ; Letar efter %folder%
  Loop, parse, xml, £
  {
    StringReplace, loop2, A_LoopField, <%sub%>, €, All
    Loop, parse, loop2, €
    {
      IfInString, A_LoopField, %key%
      {
        regex := "<" value ">(.{16})</" value ">"
        RegExMatch(A_LoopField, regex,test)
        return test1
      }
    }
  }
}


cx_post_campaign(campaignName, kundnr, mlEnhet, format, type, prodId, prog = false)
{
  campaign := {}
  prog := 20
  Progress, %prog%, Kontrollerar kund..., Bokningsförlopp:, Annonsbokning
  xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
  if (prog_on = true)
  {
    prog := prog+5
    Progress, %prog%
  }
  kund = - %kundnr% -
  folderId := cx_xml_read(xml, "childFolder", kund, "folderId")
  URL = https://cxad.cxense.com/api/secure/campaign/%folderId%
  DATA := ""
  HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==
  XML =
  (
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <cx:campaign xmlns:cx="http://cxense.com/cxad/api/cxad" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <cx:name>%campaignName%</cx:name>
    <cx:productId>%prodId%</cx:productId>
    <cx:perUserCap>
    <cx:max>0</cx:max>
    <cx:period>DAILY</cx:period>
    </cx:perUserCap>
  </cx:campaign>
  )
  global dir_cxense
  FILE = %dir_cxense%\campaign.xml
  refreshFile(XML, FILE)
  OPTS = Upload: %FILE%
  prog := 30
  Progress, %prog%, Bokar kampanj..., Bokningsförlopp:, Annonsbokning
  HTTPRequest( URL, DATA, HEAD, OPTS )

  if (prog_on = true)
  {
    prog := prog+5
    Progress, %prog%
  }

      regex := "<cx:campaignId>(.{16})</cx:campaignId>"
      RegExMatch(DATA, regex, match)
      campaign.Insert("Id", match1)
      campaign.Insert("cost", prod.cost)
      campaign.Insert("DATA", DATA)

  return campaign
}


cx_post_contract(campaignID, cost, startDate, stopDate, exp)
{
  ; --------------------------- HTTP-Request ---------------------------
  URL = https://cxad.cxense.com/api/secure/contract/%campaignID%
  DATA := ""
  HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==
  if (cost = "cpm")
  {
    XML =
    (
    <?xml version="1.0" encoding="utf-8"?>
    <cx:cpmContract xmlns:cx="http://cxense.com/cxad/api/cxad">
    <cx:startDate>%startDate%T00:00:00.000+01:00</cx:startDate>
    <cx:endDate>%stopDate%T23:59:00.000+02:00</cx:endDate>
    <cx:priority>0.50</cx:priority>
    <cx:requiredImpressions>%exp%</cx:requiredImpressions>
    <cx:costPerThousand class="currency" currencyCode="SEK" value="100.00"/>
    </cx:cpmContract>
    )
  }
  if (cost = "cpc")
  {
    XML =
    (
    <?xml version="1.0"?>
    <cx:cpcContract xmlns:cx="http://cxense.com/cxad/api/cxad">
    <cx:startDate>%startDate%T00:00:00.000+01:00</cx:startDate>
    <cx:endDate>%stopDate%T23:59:00.000+00:02</cx:endDate>
    <cx:priority>0.50</cx:priority>
    </cx:cpcContract>
    )
  }
  global dir_cxense
  FILE = %dir_cxense%\contract.xml
  refreshFile(XML, FILE)
  OPTS = Upload: %FILE%
  HTTPRequest( URL, DATA, HEAD, OPTS )
  return DATA
}

cx_post_advertisement(campaignID, kundnamn, start)
{
  rensaTecken(kund)
  StringTrimLeft, start, start, 2
  ; --------------------------- HTTP-Request ---------------------------
  URL = https://cxad.cxense.com/api/secure/ad/%campaignID%
  DATA := ""
  XML =
  (
  <?xml version="1.0" encoding="UTF-8"?>
  <cx:ad xmlns:cx="http://cxense.com/cxad/api/cxad">
  <cx:name>%kundnamn% - %start%</cx:name>
  </cx:ad>
  )
  global dir_cxense
  FILE = %dir_cxense%\advertisement.xml
  refreshFile(XML, FILE)
  HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==
  OPTS = Upload: %FILE%
  HTTPRequest( URL, DATA, HEAD, OPTS )
  return DATA
}

cx_post_keywords(campaignID, keyword, template)
{
  keywordTargeting =
      (
      <?xml version="1.0" encoding="UTF-8"?>
      <cx:keyword xmlns:cx="http://cxense.com/cxad/api/cxad">
        <cx:templateId>%template%</cx:templateId>
        <cx:keywordData>
          <cx:text>%keyword%</cx:text>
          <cx:keywordMatchType>EXACT</cx:keywordMatchType>
          <cx:language>SV</cx:language>
          <cx:bid currencyCode="SEK" value="0.10"/>
          <cx:state>ACTIVE</cx:state>
        </cx:keywordData>
      </cx:keyword>
      )

      ; --------------------------- HTTP-Request ---------------------------
      URL = https://cxad.cxense.com/api/secure/keyword/%campaignID%
      DATA := ""
      XML = %keywordTargeting%
      global dir_cxense
      FILE = %dir_cxense%\keywordtargeting.xml
      refreshFile(XML, FILE)
      HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==
      OPTS = Upload: %FILE%
      HTTPRequest( URL, DATA, HEAD, OPTS )
      ; --------------------------------------------------------------------
    return DATA
}


cx_post_sitetargeting(campaignID, mlSite, template)
{
StringReplace, mlKundnamn, mlKundnamn,&,,A
  StringReplace, mlKundnamn, mlKundnamn,ä,a,A
  targeting =
  (
    <cx:publisherTarget>
        <cx:url>http://%mlSite%</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
  )
  ; AFFÄRSLIV
  if (mlSite = "affärsliv.com")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://www.affarsliv.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; NT FOLKBLADET
  if (mlSite = "nt.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://nt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://folkbladet.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; NT FOLKBLADET MOBIL
  if (mlSite = "mobil.nt.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.nt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://m.folkbladet.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.nt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.folkbladet.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; NSD KURIREN
  if (mlSite = "nsd.se" ||mlSite = "kuriren.nu")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://nsd.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://kuriren.nu</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; PT
  if (mlSite = "pt.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://pitea-tidningen.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://pt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; PT MOBIL
  if (mlSite = "m.pitea-tidn.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.pitea-tidningen.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.pitea-tidningen.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    <cx:publisherTarget>
        <cx:url>http://m.pt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.pt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; NSD KURIREN MOBIL
  if (mlSite = "mobil.nsd.se" ||mlSite = "mobil.kuriren.nu")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.nsd.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://m.kuriren.nu</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.nsd.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.kuriren.nu</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; CORREN MOBIL
  if (mlSite = "mobil.corren.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.corren.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.corren.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; MVT MOBIL
  if (mlSite = "mobil.mvt.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.mvt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.mvt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; VT MOBIL
  if (mlSite = "mobil.vt.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.vt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.vt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; UNT MOBIL
  if (mlSite = "mobil.unt.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.unt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.unt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  if (mlSite = "unt.mobil.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.unt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.unt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; UNT Sigtunabygden
  if (mlSite = "sigtunabygden.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://unt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }


  ; HELAGOTLAND MOBIL
  if (mlSite = "m.helagotland.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.helagotland.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.helagotland.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; --------------------------- HTTP-Request ---------------------------
  URL = https://cxad.cxense.com/api/secure/publisherTargeting/%campaignID%
  DATA := ""
  XML =
  (
<?xml version="1.0"?>
<cx:publisherTargeting xmlns:cx="http://cxense.com/cxad/api/cxad">
  <cx:templateId>%template%</cx:templateId>
  %targeting%
</cx:publisherTargeting>
  )
  global dir_cxense
  FILE = %dir_cxense%\targeting.xml
  refreshFile(XML, FILE)
  HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==
  OPTS = Upload: %FILE%
  HTTPRequest( URL, DATA, HEAD, OPTS )
  return DATA
}

kundSaknas:
  MsgBox, 4, Kund saknas, Kund fanns inte. Skapa kund "%mlTidning% - %mlKundnr% - %mlKundnamn%"?
  IfMsgBox, Yes
  {
    StringReplace, mlKundnamn, mlKundnamn,&,,A
    ; --------------------------- HTTP-Request ---------------------------
    URL = https://%cxUser%@cxad.cxense.com/api/secure/folder/advertising
    DATA =
    (
    <?xml version="1.0" encoding="UTF-8"?>
    <cx:folder xmlns:cx="http://cxense.com/cxad/api/cxad">
      <cx:name>%mlTidning% - %mlKundnr% - %mlKundnamn%</cx:name>
    </cx:folder>
    )
    HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==
    OPTS = Charset: utf-8
    HTTPRequest( URL, DATA, HEAD, OPTS )
    ; --------------------------------------------------------------------
    MsgBox,1, Kund inlagd, Kund inlagd. Boka kampanj?
    ifMsgBox, Cancel
    {
      return
    }
    ifMsgBox, OK
    {
      StringSplit, xmlSplit, DATA, >
      StringSplit, xmlSplit, xmlSplit6, <
      kundID = %xmlSplit1% ; kundID innehåller kundens ID
      goto, cx_ui
    }
    return
  }
  IfMsgBox, No
    return
return
