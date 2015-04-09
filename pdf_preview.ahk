pdf-preview:

gosub, manageimg
Gui, 39:add, picture, x0 y0 w%mypicW% h%mypicH% vprintimg, %img%
data := checkPrints(mlOrdernummer)
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
    Gui, 39:Destroy
    IniRead, startfolder, %mlpSettings%, Folder, Standardfolder
    FileSelectFolder, userFolder, %startfolder%,,Välj mapp att spara PDF-filen i.
    IniDelete, %mlpSettings%, Folder
    IniWrite, *%userFolder%, %mlpSettings%, Folder, Standardfolder
    FileCopy, %printdir%, %userfolder%\
return

checkPrints(x)
{
    StringSplit, y, x, -, 
    mnr := y2
    onr := x
    i := 1
    while i < y2
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
    img = %devdir%\nopreview.jpg
    ifExist, %imgdir%
        {
        img := imgdir
        }

    gui, 40:add, picture, vmypic, %img%
    GuiControlGet, mypic, 40:Pos
    gui, 40:destroy

    bx := mypicW - 85
    by := mypicH - 50

    dx := bx - 110
    dy := by +20
return