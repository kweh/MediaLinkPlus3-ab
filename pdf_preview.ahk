pdf-preview:
Gui, 39:Destroy
gosub, manageimg
Gui, 39:add, picture, x0 y0 w%mypicW% h%mypicH% vprintimg, %img%
data := checkPrints(mlOrdernummer)
if (from_fc = true)
{
    data := checkPrints(line2)
    from_fc := false
}
    if (data != "")
    {
        Gui, 39:add, dropdownlist, vselectedPrint gupdatePrint w100 x%dx% y%dy% Choose1, %data%
    }
Gui, 39:add, button, gdownload vdownload w75 h40 x%bx% y%by%,Ladda ned
Gui, 39:show, w%mypicW% h%mypicH% xCenter yCenter, PDF-preview
return

39GuiClose:
    Gui, 39:Destroy
return

download:
    Gui, 39:submit
    Gui, 39:Destroy
    Stringtrimleft, selectedprint, selectedprint, 3
    IniRead, startfolder, %mlpSettings%, Folder, Standardfolder
    FileSelectFolder, userFolder, %startfolder%,,Välj mapp att spara PDF-filen i.
    IniDelete, %mlpSettings%, Folder
    IniWrite, *%userFolder%, %mlpSettings%, Folder, Standardfolder
    FileCopy, %printdir_short%%selectedPrint%.pdf, %userfolder%, 0
    msgbox,4, Visa fil?, Visa fil i utforskaren?
    IfMsgBox, yes
        Run %COMSPEC% /c explorer.exe /select`, "%userfolder%\10%selectedPrint%.pdf",, Hide 
return

checkPrints(x)
{
    StringSplit, y, x, -, 
    mnr := y2
    onr := x
    i := 1
    while i <= y2
    {
        mnrLit := "-0" i
        result := printCheck(onr, mnrLit)
        if (result = "print" || result = "bild")
        {
            data .= y1 "" mnrLit "|"
        }

        i++
    }
    return data
}

updatePrint:
    Gui, 39:Submit, NoHide
    StringSplit, getSelectedPrint, selectedPrint, -
    printCheck(selectedPrint, "-"getSelectedPrint2)
    gosub, manageimg

    GuiControl, , printimg,*w%mypicW% *h%mypicH% %img% 
    GuiControl, Move, download, x%bx% y%by%
    GuiControl, Move, selectedprint, x%dx% y%dy%
    Gui, 39:show, w%mypicW% h%mypicH% xCenter yCenter, PDF-preview
return

manageimg:
    img = %dir_img%\nopreview.jpg
    ifExist, %imgdir%
        {
        img := imgdir
        }

    gui, 40:add, picture, vmypic, %img%
    GuiControlGet, mypic, 40:Pos
    gui, 40:destroy

    if (mypicW < 100)
    {
        mypicW = 100
    }
    if (mypicH < 100)
    {
        mypicH = 100
    }

    bx := mypicW - 85
    by := mypicH - 50

    dx := bx - 110
    dy := by +20

return