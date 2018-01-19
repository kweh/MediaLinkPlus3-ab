material:
	order := getExtendedOrder(mlOrdernummer)
	StringSplit, orderSplit, mlOrdernummer, -
	ordernr := ordersplit1
	mnr := orderSplit2
	kundnamn := order.customer_name
	StringReplace, kundnamn, kundnamn, \,%A_Space%, All
	StringReplace, kundnamn, kundnamn, /,%A_Space%, All

	orderFolder := "G:\NTM\NTM Digital Produktion\MATERIAL\order\" ordernr
	customerFolder := "G:\NTM\NTM Digital Produktion\MATERIAL\kund\" kundnamn
	IfExist, %orderFolder%
	{
		IfNotExist, %customerFolder%
		{
			FileCreateDir, %customerFolder%
		}
		IfNotExist, %orderFolder%\Kundmapp - %kundnamn%.lnk
		{
			FileCreateShortcut, %customerFolder%, %orderFolder%\Kundmapp - %kundnamn%.lnk
		}
		Run, %orderFolder%
	}
	Else
	{
		FileCreateDir, %orderFolder%
		IfNotExist, %customerFolder%
		{
			FileCreateDir, %customerFolder%
		}
		IfNotExist, %orderFolder%\Kundmapp - %kundnamn%.lnk
		{
			FileCreateShortcut, %customerFolder%, %orderFolder%\Kundmapp - %kundnamn%.lnk
		}
		Run, %orderFolder%
	}

Return