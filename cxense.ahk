 cx_start:
  c_impCheck := false
  gosub, getList
  Progress, R0-4 FM8 FS7 CBGray P1, Kontrollerar om kund finns..., Kundsök:, Annonsbokning
  xml := get_url("cxad.cxense.com/api/secure/folder/advertising")
  kund = - %mlKundnr% -
  folderId := cx_xml_read(xml, "childFolder", kund, "folderId")

  campaignName := mlTidning " - " format " - " mlOrdernummer
  if (format = "MOB" || format = "PAN")
  {
    campaignName := mlTidning " - " format "" mlH " - " mlOrdernummer    
  }

  folderName := mlTidning " - " mlKundnr " - " mlKundnamn

  if (mlSite = "affärsliv.com" || mlSite = "mobil.affarsliv.com" )
  {
    campaignName := "AF - " format " - " mlOrdernummer
    folderName := "AF - " mlKundnr " - " mlKundnamn
  }
  if (mlEnhet = "")
  {
    Progress, Off
    msgbox, Kunde inte läsa ut "internetenhet". Försök igen.
    goto, die
  }

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

      Gui, booking:Destroy
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

  Gui, booking:Destroy
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

; Kollar om copy-checken var satt senast
IniRead, copyCheck, %mlpSettings%, copyCheck, checked
if (copyCheck = "ERROR")
  {
    copyCheck = 0
  }

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

  if (cpm_rounded = 0){
    cpm_rounded = 1
  }

defaultType := 1 ; Run On Site
expView = 
cpmView = 
if (mlSite = "affarsliv.com" || mlSite = "mobil.affarsliv.com" || mlSite = "gotland.net" || mlSite = "norrbottensaffarer.se" || mlSite = "uppsala.com" || mlSite = "duonoje.se" || mlSite = "almedalen.net" || mlSite = "uppsalavimmel.se")
  { 
    ; c_impCheck := true
    Gosub, CPCcheck
    cpm_rounded = 0
    
  }

if (mlSite = "sigtunabygden.se")
{
  target = ntm-sigtunabygden||%target%
  defaultType := 2
}

  adbase := getExtendedOrder(mlOrdernummer)

  ; FÄRGER
  ; Färgschema https://coolors.co/ee6352-59cd90-3fa7d6-fac05e-f79d84
  col1 := "3FA7D6"
  col2 := "EE6352"
  col3 := "FAC05E"
  col4 := "59CD90"
  col5 := "F79D84"
  colbg := "f8f8f8"
  shadows := true


  ; col1 := "666666"
  ; col2 := "999999"
  ; col3 := "cccccc"
  ; col4 := "444444"
  ; col5 := "777777"
  ; colbg := "555555"
  ; shadows := false


  ico_cancel := chr(0xf05e) ; ASCII-kod för urkryssad checkbox (FontAwesome)
  ico_submit := chr(0xf1d8) ; ASCII-kod för ikryssad checkbox (FontAwesome)


  
  Gui, booking:Font,, Open Sans
  ; Progressbars - UI-dekoration
  Gui, booking:Add, Progress,x0 y0 w600 h80 Background%col1%

  Gui, booking:Font, s24 cFFFFFF
  Gui, booking:Add, Text, xp+10 yp+5 BackgroundTrans vUI_CustomerName, % adbase.customer_name
  Gui, booking:Font, s14 cFFFFFF, Open Sans Light
  Gui, booking:Add, Text, xp+1 yp+40 BackgroundTrans vUI_OrderNumber, % mlOrdernummer

  ; HEADERS TIER 1
    drawFilledRect("180", "50", "10", "90", "ffffff", "ffffff", "booking", shadows ) ; SITE BOX
    drawFilledRect("180", "20", "10", "90", col2, col2, "booking" ) ; SITE
    drawFilledRect("180", "50", "210", "90", "ffffff", "ffffff", "booking", shadows ) ; FORMAT BOX
    drawFilledRect("180", "20", "210", "90", col2, col2, "booking" ) ; FORMAT
    drawRect("180", "50", "410", "90", "ffffff", "booking", shadows ) ; VISNINGSTYP BOX
    drawFilledRect("180", "20", "410", "90", col2, col2, "booking" ) ; VISNINGSTYP
    Gui, booking:Font, s10 cFFFFFF, Open Sans
    Gui, booking:Add, Text, x14 y91 BackgroundTrans, SITE
    Gui, booking:Add, Text, xp+200 yp BackgroundTrans, FORMAT
    Gui, booking:Add, Text, xp+200 yp BackgroundTrans, VISNINGSTYP


  ; CONTENT TIER 1
    Gui, booking:Font, c666666 s12
    Gui, booking:Add, Text, x15 y115 BackgroundTrans vUI_site, % adbase.site
    Gui, booking:Add, Text, xp+200 yp BackgroundTrans vUI_format, % adbase.format
    ; Gui, booking:Add, Text, xp+200 yp BackgroundTrans vUI_keyword, % adbase.section
    Gui, booking:-Theme,
    Gui, booking:Add, DropDownList, xp+195 yp-4 w181 h34 HWNDhwnd_viewType vType r5 gType Choose%defaulttype%, Run On Site||Riktad|Backfill|Retarget|CPC
    Gui, booking:+Theme,

  ;HEADERS TIER 2
    drawRect("180", "50", "10", "160", "ffffff", "booking", shadows ) ; START BOX
    drawFilledRect("180", "20", "10", "160", col3, col3, "booking" ) ; START
    drawRect("180", "50", "210", "160", "ffffff", "booking", shadows ) ; STOPP BOX
    drawFilledRect("180", "20", "210", "160", col3, col3, "booking" ) ; STOPP
    drawRect("180", "50", "410", "160", "ffffff", "booking", shadows) ; IMPS BOX
    drawFilledRect("180", "20", "410", "160", col3, col3, "booking", false, "impBox") ; IMPS
    ; drawRect("130", "50", "460", "160", "ffffff", "booking", shadows ) ; BACKFILL BOX
    ; drawFilledRect("130", "20", "460", "160", col3, col3, "booking" ) ; BACKFILL
    Gui, booking:Font, s10 cFFFFFF, Open Sans
    Gui, booking:Add, Text, x14 y161 BackgroundTrans, START
    Gui, booking:Add, Text, xp+200 yp BackgroundTrans, STOPP
    Gui, booking:Add, Text, xp+200 yp BackgroundTrans vui_imps_text, EXPONERINGAR
    ; Gui, booking:Add, Text, xp+150 yp BackgroundTrans, BACKFILL              CPC

  ; CONTENT TIER 2
    Gui, booking:Font, c666666 s10
    Gui, booking:Add, DateTime, x9 y179 w184 h34 HWNDhwnd_start vUI_start Choose%mlStartdatumStrip%0000, yyyy-MM-dd HH:mm
    Gui, booking:Add, DateTime, xp+200 yp wp hp HWNDhwnd_stop vUI_stop Choose%mlStoppdatumStrip%2359, yyyy-MM-dd HH:mm
    ; Utfyllnad för Edit-fältets marginal -v
    drawFilledRect(180, 4, 410, 180, "ffffff", "ffffff", "booking", false, "impFill")
    Gui, booking:Font, c000000 s12
    Gui, booking:Add, Edit, xp y182 w183 vUI_imps HWNDhwnd_imps, % adbase.imps
    Gui, booking:Font, c666666 s12

    ; Gui, booking:Add, Picture, xp+152 yp-1 vUI_backfill gBackCheck, img/uncheck_l.png
    ; Gui, booking:Add, Picture, xp+65 yp vUI_cpc gCPCCheck, img/uncheck_r.png

  ; HEADERS TIER 3
    drawFilledRect("580", "200", "10", "230", "ffffff", "ffffff", "booking", shadows ) ; NOTES BOX
    drawFilledRect("580", "20", "10", "230", col4, col4, "booking" ) ; NOTES
    Gui, booking:Font, s10 cFFFFFF, Open Sans
    Gui, booking:Add, Text, x14 y231 BackgroundTrans, INTERNA NOTERINGAR

  ; CONTENT TIER 3
    Gui, booking:Font, c777777 s8
    Gui, booking:Add, Text, x15 y255 w560 BackgroundTrans vUI_notes, % adbase.internalnotes

  ; HEADERS TIER 4
    drawFilledRect("580", "75", "10", "450", "ffffff", "ffffff", "booking", shadows ) ; BOOKNG BOX
    drawFilledRect("580", "20", "10", "450", col5, col5, "booking" ) ; BOOKNG
    Gui, booking:Font, s10 cFFFFFF, Open Sans
    Gui, booking:Add, Text, x14 y451 BackgroundTrans, BOKNINGSINFORMATION

  ; CONTENT TIER 4
    Gui, booking:Font, c777777 s7
    Gui, booking:Add, Text, x15 yp+25 w560 BackgroundTrans, CPM
    Gui, booking:Add, Text, xp yp+15 w560 BackgroundTrans, PRIS
    Gui, booking:Add, Text, xp yp+15 w560 BackgroundTrans, SÄLJARE

    Gui, booking:Font, c999999 s7
    Gui, booking:Add, Text, x170 y476 w560 BackgroundTrans vUI_cpm, % adbase.cpm
    Gui, booking:Add, Text, xp yp+15 w560 BackgroundTrans vUI_pris, % Round(adbase.fprice) " kr"
    Gui, booking:Add, Text, xp yp+15 w560 BackgroundTrans vUI_saljare, % adbase.fname " " adbase.lname

    Gui, booking:Font, c777777 s7
    Gui, booking:Add, Text, x300 y476 w560 BackgroundTrans, ORDER SKAPAD
    Gui, booking:Add, Text, xp yp+15 w560 BackgroundTrans, ORDER ÄNDRAD

    Gui, booking:Font, c999999 s7
    Gui, booking:Add, Text, x485 y476 w560 BackgroundTrans vUI_skapad, % adbase.createdate
    Gui, booking:Add, Text, xp yp+15 w560 BackgroundTrans vUI_andrad, % adbase.changedate

  ; HEADERS TIER 5
    drawRect("180", "46", "10", "545", "ff0000", "booking", shadows ) ; Keyword BOX
    drawFilledRect("180", "20", "10", "545", col3, col3, "booking" ) ; Keyword
    Gui, booking:Font, s10 cFFFFFF, Open Sans
    Gui, booking:Add, Text, x14 y546 BackgroundTrans, KEYWORD

  ; CONTENT TIER 5
    Gui, booking:-Theme
    Gui, booking:Add, ComboBox, x10 y566 w181 h30 vKeyword R10 HWNDhwnd_keyword -Border, %target%
    Gui, booking:+Theme

  ; KNAPPAR
    Gui, booking:Font, c%col2% s40, FontAwesome
    Gui, booking:Add, Text, y600 x425 vUI_cancel gbookingGuiClose,  % ico_cancel
    Gui, booking:Font, c777777 s8, Open Sans
    Gui, booking:Add, Text, yp+55 xp+3 , AVBRYT
    
    Gui, booking:Font, c%col4% s40, FontAwesome
    Gui, booking:Add, Text, y600 x525 vUI_submit gBoka,  % ico_submit
    Gui, booking:Font, c777777 s8, Open Sans
    Gui, booking:Add, Text, yp+55 xp+7, BOKA

  ; Hämtar mått och position på kontroller för beskärning
  GuiControlGet, starttime, booking:pos, UI_start
  GuiControlGet, stoptime, booking:pos, UI_stop
  GuiControlGet, imps, booking:pos, UI_imps
  GuiControlGet, viewType, booking:pos, Type

  ; Färg på DDL
  CtlColors.Attach(Type, "FFFFFF", "777777")

  ; Beskär kontroller
  WinSet, region, % "2-2 w" starttimew-4  " h" starttimeh-4, % "ahk_id " hwnd_start
  WinSet, region, % "2-2 w" stoptimew-4   " h" stoptimeh-4, % "ahk_id " hwnd_stop
  WinSet, region, % "2-2 w" impsw-4       " h" impsh-4, %     "ahk_id " hwnd_imps

  ; WinSet, region, % "2-2 w" viewTypew-4   " h" viewTypeh-4, % "ahk_id " hwnd_viewType

  ; Dold knapp för fokus och enterknappsbokning
  Gui, booking:Add, Button, x0 y0 h0 w0 gBoka vHiddenButton Default, knapp

  ; Gui, booking:Color, ff0000
  Gui, booking:Color, %colbg%
  Gui, booking:Show, w600 h680, Bokningsöversikt
  GuiControl, booking:Focus, HiddenButton
  Winset, Redraw,, Bokningsöversikt

  ;Conditions för siter:
  if (mlSite = "affarsliv.com" || mlSite = "mobil.affarsliv.com" || mlSite = "gotland.net" || mlSite = "norrbottensaffarer.se" || mlSite = "uppsala.com" || mlSite = "duonoje.se" || mlSite = "almedalen.net" || mlSite = "uppsalavimmel.se")
  { 
    Gui, booking:Default
    c_impCheck := false
    b_impCheck := false
    Gosub, CPCcheck
    cpm_rounded = 0
    GuiControl, Choose, Type, 5 ; Väljer CPC i dropdown    
  }

  if (backfill_cx)
  {
    Gui, booking:Default
    console_log("is backfill, yes")
    GuiControl, Choose, Type, 3 ; Väljer Backfill i dropdown    
  }

stop := true
; Winset, Transparent, 200, Bokningsöversikt
Return

bookingGuiClose:
  Gui, booking:Destroy
return

IABsub:
  Gui, booking:Submit, NoHide
  if (IAB = 1)
  {
    IfInString, campaignname, |
    {
      StringSplit, campaignname, campaignname, |
      campaignname := campaignname1
      StringTrimRight, campaignname, campaignname, 1
      GuiControl,, campaignname ,% campaignname
    }
  }
  else
  {
    IfInString, campaignname, |
    {
      StringSplit, campaignname, campaignname, |
      campaignname := campaignname1
      StringTrimRight, campaignname, campaignname, 1
    }
    GuiControl,, campaignname ,% campaignname " | IAB" IAB-1
  }

return

Type:
  Gui, booking:Submit, NoHide
  if (Type = "Retarget" || Type = "CPC" || Type = "Backfill")
  {
    GuiControl, booking:Disable, UI_imps
    if (Type = "Backfill")
    {
      cpm_before := cpm_rounded
      GuiControl, ,cpm_edit, 0.01
    }
  } else {
    GuiControl, booking:Enable, UI_imps
    GuiControl, ,cpm_edit, %cpm_before%

  }
return

CopyCheck:
  Gui, booking:Submit, NoHide
    ; Sätter standardvärdet för copy-checkboxen
  IniDelete, %mlpSettings%, copyCheck, checked
  IniWrite, %Copy%, %mlpSettings%, copyCheck, checked
Return

Boka:
  Gui, booking:Submit
  Gui, booking:Destroy

  FormatTime, Startdatum, %UI_start%, yyyy-MM-dd HH:mm:ss
  FormatTime, Stoppdatum, %UI_stop%, yyyy-MM-dd HH:mm:ss

  StringSplit, Stopp, Stoppdatum , %A_Space%
  Stoppdatum := Stopp1
  Stopptid := Stopp2

  StringSplit, Start, Startdatum , %A_Space%
  Startdatum := Start1
  Starttid := Start2

  prog := 5
  prog_on := true

  ;Keywords-listan
  IfNotInString, Target, %Keyword%
  {
    FileAppend, %Keyword%|, G:\NTM\NTM Digital Produktion\MedialinkPlus\dev\target.txt
  }


  Progress, R0-100 FM8 FS7 P5 CBGray M, Kontrollerar produkt..., Bokningsförlopp:, Annonsbokning
  Progress, Show
  Progress, %prog%
  sleep, 200

  if (b_impCheck)
  {
    type := "Backfill"
  }
  else if (c_impCheck)
  {
    type := "CPC"
  }


  prod := cxProduct(format, type)
  productId := prod.prodID
  sitetargetingID := prod.siteTargetingID
  keywordsID := prod.keywordsID
  cost := prod.cost

  if (b_impcheck)
  {
    campaignName := mlTidning " - " format " - BACKFILL - " mlOrdernummer
  }
  campaign := cx_post_campaign(campaignName, mlKundnr, mlEnhet, format, Type, productId, prog_on)
  campaignID := campaign.Id
  sleep, 100

  prog := 40
  Progress, %prog%, Bokar kontrakt..., Bokningsförlopp:, Annonsbokning
  contract := cx_post_contract(campaign.Id, cost, Startdatum, Starttid, Stoppdatum, Stopptid, UI_imps, cpm_rounded, Type)

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
  
  if (copyCheck = 1)
  {
    Clipboard := mlOrdernummer
  }

log = 
(
-------------------------------------------------`n
Bokning: %campaignName%`n
-------------------------------------------------`n
Bokad av:       %me%`n
Datum:          %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%`n
Ordernummer:    %mlOrdernummer%`n
Kundnamn:       %mlKundnamn%`n
Kundnr:         %mlKundnr%`n
Säljare:        %mlSaljare%`n
Site:           %mlSite%`n
Internetenhet:  %mlEnhet%`n
Startdatum:     %mlStartdatum%`n
Stoppdatum:     %mlStoppdatum%`n
Exponeringar:   %mlExponeringar%`n
`n
Interna Noteringar:`n
%mlNoteringar%`n
`n
Länk till kampanj:`n
https://cxad.cxense.com/adv/campaign/%campaignID%/overview`n
-------------------------------------------------`n
`n
)

FileAppend, %log%, %dir_log%\%mlOrdernummer%.txt
  MsgBox,4, Bokning klar, Inbokning klar, öppna i webbläsaren?
  IfMsgBox, Yes
    run, https://cxad.cxense.com/adv/campaign/%campaignID%/overview
    stop = false
  IfMsgBox, No
    stop = false
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


cx_post_contract(campaignID, cost, startDate, startTime, stopDate, stopTime, exp, cpm, type)
{
  ; --------------------------- HTTP-Request ---------------------------
  exp := exp+100
  time := getTime()
  diff := time.diff
  URL = https://cxad.cxense.com/api/secure/contract/%campaignID%
  DATA := ""
  HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==

  if (cost = "cpm")
  {
    XML =
    (
    <?xml version="1.0" encoding="utf-8"?>
    <cx:cpmContract xmlns:cx="http://cxense.com/cxad/api/cxad">
    <cx:startDate>%startDate%T%startTime%.000+0%diff%:00</cx:startDate>
    <cx:endDate>%stopDate%T%stopTime%.000+0%diff%:00</cx:endDate>
    <cx:priority>0.50</cx:priority>
    <cx:requiredImpressions>%exp%</cx:requiredImpressions>
    <cx:costPerThousand class="currency" currencyCode="SEK" value="%cpm%.00"/>
    </cx:cpmContract>
    )
    if (type = "Backfill")
    {
      XML =
      (
      <?xml version="1.0" encoding="utf-8"?>
      <cx:cpmContract xmlns:cx="http://cxense.com/cxad/api/cxad">
      <cx:startDate>%startDate%T%startTime%.000+0%diff%:00</cx:startDate>
      <cx:endDate>%stopDate%T%stopTime%.000+0%diff%:00</cx:endDate>
      <cx:priority>0.25</cx:priority>
      <cx:requiredImpressions>%exp%</cx:requiredImpressions>
      <cx:costPerThousand class="currency" currencyCode="SEK" value="%cpm%.00"/>
      </cx:cpmContract>
      )
    }
  }
  if (cost = "cpc")
  {
    XML =
    (
    <?xml version="1.0"?>
    <cx:cpcContract xmlns:cx="http://cxense.com/cxad/api/cxad">
    <cx:startDate>%startDate%T%startTime%.000+0%diff%:00</cx:startDate>
    <cx:endDate>%stopDate%T%stopTime%.000+0%diff%:00</cx:endDate>
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
  rensaTecken(kundnamn)
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
        <cx:url>http://www.affarsliv.com</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  if (mlSite = "mobil.affarsliv.com")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://mobil.affarsliv.com</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://m.affarsliv.com</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.nt.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://app-mobil.folkbladet.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; FB MOBIL
  if (mlSite = "m.folkbladet.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://m.folkbladet.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://mobil.folkbladet.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://app-mobil.folkbladet.se</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.pt.se</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.kuriren.nu</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://app-mobil.nsd.se</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.corren.se</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.mvt.se</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.vt.se</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.unt.se</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.unt.se</cx:url>
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
      <cx:publisherTarget>
        <cx:url>http://app-mobil.helagotland.se</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }

  ; UPPGÅNG
  if (mlSite = "uppgång.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://www.uppgang.com</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
    )
  }
  if (mlSite = "mobil.uppgang.com" ||mlSite = "mobil.uppgång.se")
  {
    targeting =
    (
    <cx:publisherTarget>
        <cx:url>http://mobil.uppgang.com</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://m.uppgang.com</cx:url>
        <cx:targetType>POSITIVE</cx:targetType>
      </cx:publisherTarget>
      <cx:publisherTarget>
        <cx:url>http://app-mobil.uppgang.com</cx:url>
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
      ; StringSplit, xmlSplit, DATA, >
      ; StringSplit, xmlSplit, xmlSplit6, <
      ; kundID = %xmlSplit1% ; kundID innehåller kundens ID
       regex := "<folderId>(.{16})</folderId>"
      RegExMatch(A_LoopField, regex,test)
      kundID = test1

      goto, cx_ui
    }
    return
  }
  IfMsgBox, No
    return
return


; SUBRUTINER FÖR GUI
backCheck:
  if (!b_impCheck)
  {
    if(c_impCheck)
    {
      return
    }
    GuiControl,booking:, UI_backfill, img/check_l.png
    GuiControl,booking:, UI_cpc, img/nocheck_r.png
    GuiControl,booking: Disable, UI_imps
    GuiControl,booking: +BackgroundFFE2B1,impBox
    GuiControl,booking: +Background%colbg%, impFill
    GuiControl,booking: Hide, UI_imps_text
    GuiControl,booking: Show, UI_imps_text
    b_impCheck := true
  }
  else
  {
    if(c_impCheck)
    {
      return
    }
    GuiControl,booking:, UI_backfill, img/uncheck_l.png
    GuiControl,booking:, UI_cpc, img/uncheck_r.png
    GuiControl,booking: Enable, UI_imps
    GuiControl,booking: +BackgroundFAC05E,impBox
    GuiControl,booking: +BackgroundFFFFFF, impFill
    GuiControl,booking: Hide, UI_imps_text
    GuiControl,booking: Show, UI_imps_text
    b_impCheck := false
  }
return

CPCcheck:
  if (!c_impCheck)
  {
    if(b_impCheck)
    {
      return
    }
    GuiControl,booking:, UI_cpc, img/check_r.png
    GuiControl,booking:, UI_backfill, img/nocheck_l.png
    GuiControl,booking: Disable, UI_imps
    GuiControl,booking: +BackgroundFFE2B1,impBox
    GuiControl,booking: +Background%colbg%, impFill
    GuiControl,booking: Hide, UI_imps_text
    GuiControl,booking: Show, UI_imps_text
    c_impCheck := true
  }
  else
  {
    if(b_impCheck)
    {
      return
    }
    GuiControl,booking:, UI_cpc, img/uncheck_r.png
    GuiControl,booking:, UI_backfill, img/uncheck_l.png
    GuiControl,booking: Enable, UI_imps
    GuiControl,booking: +BackgroundFAC05E,impBox
    GuiControl,booking: +BackgroundFFFFFF, impFill
    GuiControl,booking: Hide, UI_imps_text
    GuiControl,booking: Show, UI_imps_text
    c_impCheck := false
  }
return
