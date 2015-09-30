whatsthis:
	gosub, getlist
	format := getFormat(mlID)
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
Site: %mlSite%
Kortnamn produkt: %format%
Status: %mlStatus%
Tilldelad: %mlTilldelad%
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