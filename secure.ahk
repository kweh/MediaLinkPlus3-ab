cxUser := "QVBJLlVzZXI6cGFzczEyMw=="


ftp_init(timestamp, upload)
{
ftpSettings = 
(
open ftp.ntm-digital.se
120516_lager
lager123
binary
rename lager.xml lager%timestamp%.xml
put "%upload%"
ls -l
quit
)
return %ftpSettings%
}


ftp_init_weblink(timestamp, upload)
{
ftpSettings = 
(
open ftp.dnns.se
dnns.se
n173m4r3!
binary
rename xml.xml weblink%timestamp%.xml
put "%upload%"
ls -l
quit
)
return %ftpSettings%
}