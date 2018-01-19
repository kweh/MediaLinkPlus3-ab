;
; SITE IDs
; ==========================================

eposten := "5e8cef39-1026-403d-ac2d-706b2ebb5004"
dnns := "kcgf20kpz3np2zxl" 


adnTime(time, offset)
{
	StringReplace, time, time, -,,All
	StringReplace, time, time, :,,All
	StringReplace, time, time, T,,All
	StringReplace, time, time, Z,,All

	if (offset != 0)
	{
		EnvAdd, time, %offset%, hours
	}
	FormatTime, time, %time%, yyyy-MM-dd HH:mm:ss
	return time
}

adnFormatTime(time)
{
	StringReplace, time, time, %A_Space%, T
	time := time "Z"
	return time
}


adnAuth()
{
	console_log("============================")
	console_log("Funktion: adnAuth()")
	console_log("----------------------------")

	data = 
	(
		{
		"grant_type": "password",
		"scope": "ng_api",
		"username": "digital.support@ntm.eu",
		"password": "Pass123"
		}
	)
	console_log("Data in:`n" . data)
	console_log("----------------------------")
	
	url := "https://api.adnuntius.com/api/authenticate"
	head := "Content-Type: application/json"
	httprequest(url, data, head)

	console_log("Data ut:`n" . data)
	console_log("----------------------------")
	console_log("`n`n`n")

	resp := JSON.Load(data)

	return resp
}

adnSearch(access_token, what, search)
{
	console_log("============================")
	console_log("Funktion: adnSearch(access_token=" . access_token . ", what=" . what . ", search=" . search . ")")
	console_log("----------------------------")

	url := "https://api.adnuntius.com/api/v1/search?context=ntm&types=" . what . "&q=" . search
	console_log("url: `n" . url)
	console_log("----------------------------")
	head := "Content-Type: application/json`nAuthorization: Bearer " . access_token
	opts := "Charset: utf-8"
	httprequest(url, data, head, opts)

	console_log("Data ut:`n" . data)
	console_log(url)
	console_log(head)
	if (!InStr(head, "HTTP/1.1 200"))
	{
		MsgBox, , Fel, Fel vid anrop till adNuntius API:`n`nURL:%url%`n%head%
		return false
	}
	console_log("----------------------------")
	console_log("`n`n`n")

	resp := JSON.Load(data)
	return resp
}

adnAdvertiser(access_token, advertiser_id, data:="")
{
	console_log("============================")
	console_log("Funktion: adnAdvertiser(access_token=" . access_token . ", advertiser_id=advertiser_" . advertiser_id . ")")
	console_log("----------------------------")

	console_log("Data in:`n" . data)
	console_log("----------------------------")

	url := "https://api.adnuntius.com/api/v1/advertisers/advertiser_" . advertiser_id . "?context=ntm"
	console_log("url: `n" . url)
	console_log("----------------------------")
	head := "Content-Type: application/json`nAuthorization: Bearer " . access_token
	opts := "Charset: utf-8"
	httprequest(url, data, head, opts)

	console_log("Data ut:`n" . data)
	console_log("----------------------------")
	console_log("`n`n`n")

	resp := JSON.Load(data)
	return resp
}

adnOrder(access_token, order_id, data:="")
{
	console_log("============================")
	console_log("Funktion: adnOrder(access_token=" . access_token . ", order_id=order_" . order_id . ")")
	console_log("----------------------------")

	console_log("Data in:`n" . data)
	console_log("----------------------------")

	url := "https://api.adnuntius.com/api/v1/orders/order_" . order_id . "?context=ntm"

	console_log("url: `n" . url)
	console_log("----------------------------")

	head := "Content-Type: application/json`nAuthorization: Bearer " . access_token
	opts := "Charset: utf-8"
	httprequest(url, data, head, opts)

	console_log("Data ut:`n" . data)
	console_log("----------------------------")
	console_log("`n`n`n")

	resp := JSON.Load(data)
	return resp
}

adnNotes(access_token, notes_id, notes_data)
{
	console_log("============================")
	console_log("Funktion: adnNotes(access_token=" . access_token . ", notes_id=order_" . notes_id . ")")
	console_log("----------------------------")

	console_log("Data in:`n" . notes_data)
	console_log("----------------------------")

	url := "https://api.adnuntius.com/api/v1/notes/note_" . notes_id . "?context=ntm"

	console_log("url: `n" . url)
	console_log("----------------------------")

	head := "Content-Type: application/json`nAuthorization: Bearer " . access_token
	opts := "Charset: utf-8"
	httprequest(url, notes_data, head, opts)

	console_log("Data ut:`n" . notes_data)
	console_log("----------------------------")
	console_log("`n`n`n")

	resp := JSON.Load(data)
	return resp
}

adnLineItem(access_token, lineitem_id, data:="")
{
	console_log("============================")
	console_log("Funktion: adnLineItem(access_token=" . access_token . ", lineitem_id=" . lineitem_id . ")")
	console_log("----------------------------")

	console_log("Data in:`n" . data)
	console_log("----------------------------")

	url := "https://api.adnuntius.com/api/v1/lineitems/" . lineitem_id . "?context=ntm"

	console_log("url: `n" . url)
	console_log("----------------------------")

	head := "Content-Type: application/json`nAuthorization: Bearer " . access_token
	opts := "Charset: utf-8"
	httprequest(url, data, head, opts)

	console_log("Data ut:`n" . data)
	console_log("----------------------------")
	console_log("`n`n`n")

	resp := JSON.Load(data)
	return resp
}

adnCreative(access_token, creative_id, lineitem_id, data:="")
{
	console_log("============================")
	; console_log("Funktion: adnCreative(access_token=" . access_token . ", creative_id=" . creative_id .", lineitem_id=lineitem_" . lineitem_id . ")")
	console_log("----------------------------")

	console_log("Data in:`n" . data)
	console_log("----------------------------")

	url := "https://api.adnuntius.com/api/v1/creatives/creative_" . lineitem_id . "?context=ntm"

	console_log("url: `n" . url)
	console_log("----------------------------")

	head := "Content-Type: application/json`nAuthorization: Bearer " . access_token
	opts := "Charset: utf-8"
	httprequest(url, data, head, opts)

	console_log("Data ut:`n" . data)
	console_log("----------------------------")
	console_log("`n`n`n")

	resp := JSON.Load(data)
	return resp
}

adnGetCreatives(access_token, lineitem_id, data:="")
{
	console_log("============================")
	; console_log("Funktion: adnCreative(access_token=" . access_token . ", creative_id=" . creative_id .", lineitem_id=lineitem_" . lineitem_id . ")")
	console_log("----------------------------")

	console_log("Data in:`n" . data)
	console_log("----------------------------")

	url := "https://api.adnuntius.com/api/v1/creatives/?context=ntm&lineItem=" . lineitem_id

	console_log("url: `n" . url)
	console_log("----------------------------")

	head := "Content-Type: application/json`nAuthorization: Bearer " . access_token
	opts := "Charset: utf-8"
	httprequest(url, data, head, opts)

	; console_log("Data ut:`n" . data)
	; console_log("----------------------------")
	; console_log("`n`n`n")

	resp := JSON.Load(data)
	console_log("response")
	console_log(JSON.Load(data))
	return resp
}



adnLineItemStats(access_token, lineitem_id)
{
	console_log("============================")
	console_log("Funktion: adnLineItemStats(access_token=" . access_token . ", lineitem_id=" . lineitem_id . ")")
	console_log("----------------------------")

	url := "https://api.adnuntius.com/api/v1/advertisingstats-totals/" . lineitem_id . "?auth_token=" . access_token . "&context=ntm&currency=SEK"

	console_log("url: `n" . url)
	console_log("----------------------------")

	head := "Content-Type: application/json"
	opts := "Charset: utf-8"
	httprequest(url, data, head, opts)

	console_log("Data ut:`n" . data)
	console_log("----------------------------")
	console_log("`n`n`n")

	resp := JSON.Load(data)
	return resp
}


adnBooking(access_token, customer_id, customer_data, order_id, order_data, lineitem_id, lineitem_data, creative_id, creative_data, notes_id:="", notes_data:="")
{
	; Kolla om kunden finns
	advertiser := adnAdvertiser(access_token, customer_id )
	if(advertiser.name && advertiser.objectState = "ACTIVE")
	{
		; Kunden finns och är aktiverad
		; Gör ingenting
		console_log("Hittade kund, använder den.")
		Progress, 1, Hittade kund att boka på
	}
	Else
	{
		; Kunden finns inte
		; Skapa kund
		console_log("Hittade ingen kund, skapar den")
		advertiser := adnAdvertiser(access_token, customer_id, customer_data )
		Progress, 1, Kund skapades i adNuntius
	}

	; Kolla om order finns
	order := adnOrder(access_token, order_id)
	if(order.name && order.objectState = "ACTIVE")
	{
		; Ordern finns och är aktiverad
		; Gör ingenting
		console_log("Hittade order, använder den.")
		Progress, 2, Hittade order att boka på
	}
	Else
	{
		; Ordern finns inte
		; Skapa order
		console_log("Hittade ingen order, skapar den")
		adnOrder(access_token, order_id, order_data)
		Progress, 2, Order skapades i adNuntius
	}

	;om det finns en note
	note := adnNotes(access_token, notes_id, notes_data)


	; Kolla om lineitem finns
	lineitem := adnLineItem(access_token, lineitem_id)
	if(lineitem.name && lineitem.objectState = "ACTIVE")
	{
		; LineItem finns och är aktiverat
		; Gör ingenting
		console_log("Hittade lineitem, använder det")
		lineitem := adnLineItem(access_token, lineitem_id, lineitem_data)
		Progress, 3, Uppdaterade befintligt lineitem
	}
	Else
	{
		; LineItem finns inte
		; Skapa LineItem
		lineitem := adnLineItem(access_token, lineitem_id, lineitem_data)
		Progress, 3, Skapade lineitem i adNuntius
	}

	creative := adnCreative(access_token, creative_id, lineitem_id)
	if (creative.name && creative.objectState = "ACTIVE")
	{
		console_log("Hittade creative, använder den")
		creative := adnCreative(access_token, creative_id, lineitem_id, creative_data)
		Progress, 4, Uppdaterade befintlig creative
	}
	else 
	{
		creative := adnCreative(access_token, creative_id, lineitem_id, creative_data)
		Progress, 4, Skapade creative i adNuntius
	}
	return lineitem
}

adnParseNote(text)
{
	split := StrSplit(text, "`r`n")
	Loop, % split.MaxIndex()
	{
		row := split[A_Index]
		; rex := "(http[s]?:\/\/|www.).+?\s"
		rex := "(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"
		RegExMatch(row, rex, match)
		row := StrReplace(row, """" , "\""")
		newUrl := "<a href=\""" . match . "\"" target=\""_blank\"">" . match . "</a>"
		row := StrReplace(row, match, newUrl)

		splat := splat . row . "<br>"
		StringReplace, splat, splat, `n, <br>, All
	}
	return splat
}


^!k::
	auth := adnAuth()
	result := adnSearch(auth.access_token, "LineItem", mlOrdernummer)
	console_log(result.searchResults[1].name)
	console_log(result.searchResults[1].id)
return

UtfEncode( str ) {
  RawLen := StrLen(str)

  BufSize := (RawLen + 1) * 2
  VarSetCapacity(Buf1, BufSize, 0)    ; For UTF-16.
  VarSetCapacity(Buf2, BufSize, 0)    ; For UTF-8.

  DllCall("MultiByteToWideChar", "uint", 0, "int", 0, "str", str
                               , "int", -1, "uint", &Buf1, "uint", RawLen + 1)
  DllCall("WideCharToMultiByte", "uint", 65001, "int", 0, "uint", &Buf1
                               , "int", -1, "str", Buf2, "uint", BufSize
                               , "int", 0, "int", 0)
  Return Buf2
}

adnTimeDiff(start, stopp)
{	
	start := StrSplit(start, "   ")
	stopp := StrSplit(stopp, "   ")
	start := StrReplace(start[1], "-", "")
	stopp := StrReplace(stopp[1], "-", "")
	FormatTime, start,%start%,yyyyMMdd
	FormatTime, stopp,%stopp%,yyyyMMdd
	console_log(stopp)
	distance := dateto := stopp
	distance -= start, days
	return distance
}