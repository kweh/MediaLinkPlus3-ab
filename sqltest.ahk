#include sql.ahk
DRIVER={SQL SERVER};SERVER=192.168.0.12,1234\SQLEXPRESS;DATABASE=mydb;UID=admin;PWD=12345;APP=AHK
connection = Server=adbasedb1.nt.se;Database=adbprod;User Id=adops;Password=adops2015;
query = select * from aoincampaign where campaignnumber = '0001851527-02'
msgbox % ADOSQL(connection, query)
msgbox % ErrorLevel