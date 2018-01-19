; modified from jackieku's code (http://www.autohotkey.com/forum/post-310959.html#310959)
UriEncode(Uri, Enc = "UTF-8")
{
	StrPutVar(Uri, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop
	{
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else If (Code = 0x0A)
			Res .= `%0A
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}

UriDecode(Uri, Enc = "UTF-8")
{
	Pos := 1
	Loop
	{
		Pos := RegExMatch(Uri, "i)(?:%[\da-f]{2})+", Code, Pos++)
		If (Pos = 0)
			Break
		VarSetCapacity(Var, StrLen(Code) // 3, 0)
		StringTrimLeft, Code, Code, 1
		Loop, Parse, Code, `%
			NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
		StringReplace, Uri, Uri, `%%Code%, % StrGet(&Var, Enc), All
	}
	Return, Uri
}

StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}

;============================================================
; encode special characters in a string (usually for url encoding)
;============================================================ 

fn_encode(str) {
   f = %A_FormatInteger%
   SetFormat, Integer, Hex   ; set integer format to hex
   
   If RegExMatch(str, "^\w+:/{0,2}", pr)   
      StringTrimLeft, str, str, StrLen(pr)
   
   StringReplace, str, str, `%, `%25, All    ; replace all % with %25
   
   Loop
      If RegExMatch(str, "i)[^\w\.~%/:]", char)    ; exclude alphnumeric . ~ % / : 
         StringReplace, str, str, %char%, % "%" . fn_zerofill(SubStr(Asc(char),3),2) , All
      Else Break
   
   SetFormat, Integer, %f%   ; restore integer format
   Return, pr . str
}

;============================================================
; decode encoded string
;============================================================ 

fn_decode(str) {
    Loop
        If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
            StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
        Else Break
    Return, str
}

;-------------------------------------
; example call to zerofill
; n := zerofill(n, 3)
;-------------------------------------

fn_zerofill(num, size){   ; returns num zerofilled to size digits
    StringLen, length, num
    c := size - length 
    loop, %c%
        num := "0" num
    return num
}