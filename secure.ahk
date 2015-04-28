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