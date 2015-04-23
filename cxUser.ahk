cxUser := "QVBJLlVzZXI6cGFzczEyMw=="

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