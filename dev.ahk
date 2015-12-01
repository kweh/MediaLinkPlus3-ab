whatsthis:
	gosub, getlist
	text = 
(
Ordernummer: %mlOrdernummer%
Startdatum: %mlStartdatum%
Stoppdatum: %mlStoppdatum%
Exponeringar: %mlExponeringar%
Kundnr: %mlKundnr%
Kundnamn: %mlKundnamn%
Säljare: %mlSaljare%
Produkt: %mlProdukt%
EnhetsID: %mlEnhetsID%
Site: %mlSite%
Kortnamn produkt: %mlEnhet%
Status: %mlStatus%
Tilldelad: %mlTilldelad%
CPM: %cpm_rounded%
special price: %special_price%
)
	msgbox % text
return

cxprod_cpc:
	format := getFormat(mlEnhet)
	prod := cxProduct(format, "cpc")
	prodID := prod.prodID
	cost := prod.cost
	siteTargetingID := prod.siteTargetingID
	keywordsID := prod.keywordsID
	text = 
(
ProduktID: %prodID%
Annonstyp: %cost%
SiteTargetingID: %siteTargetingID%
KeywordID: %keywordsID%
)
	msgbox % text
return

cxprod_ros:
	format := getFormat(mlEnhet)
	prod := cxProduct(format, "Run On Site")
	prodID := prod.prodID
	cost := prod.cost
	siteTargetingID := prod.siteTargetingID
	keywordsID := prod.keywordsID
	text = 
(
ProduktID: %prodID%
Annonstyp: %cost%
SiteTargetingID: %siteTargetingID%
KeywordID: %keywordsID%
)
	msgbox % text
return

cxprod_riktad:
	format := getFormat(mlEnhet)
	prod := cxProduct(format, "Riktad")
	prodID := prod.prodID
	cost := prod.cost
	siteTargetingID := prod.siteTargetingID
	keywordsID := prod.keywordsID
	text = 
(
ProduktID: %prodID%
Annonstyp: %cost%
SiteTargetingID: %siteTargetingID%
KeywordID: %keywordsID%
)
	msgbox % text
return

menutime:
	msgbox, Active: %activeDone% `n List: %listDone% `n Note: %noteDone% `n Print: %printDone% `n Check: %fileDone% `n ----------- `n Användarnamn: %anv_done%
return

opencxpath:
	run, %A_WorkingDir%\cxense
Return