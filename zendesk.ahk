SetTitleMatchMode, 2

zen_post_ticket(sub, com, req_name, req_mail, col_name, col_mail)
{
URL = https://ntmhelp.zendesk.com/api/v2/tickets.json
DATA =
(
{
  "ticket": {
  	"requester": {
  		"name":	"%req_name%",
  		"email": "%req_mail%"
  	},
  	"collaborators": [
  			{
  				"name": "%col_name%",
  				"email": "%col_mail%"
  			}
  		],
    "subject":  "%sub%",
    "comment":  { "body": "%com%" }
  }
}
)
refreshfile(DATA, "c:\temp\json.json")

bat = 
  (
  G:
  cd G:\NTM\NTM Digital Produktion\cURL\bin
  curl.exe -u mikael.lundin@ntm.eu/token:yGedN7Uxd4JUs2igdqWLtZxGvXlPK9DbCMrdQa8G %URL% -d @C:\temp\json.json -H "Content-Type: application/json" -X POST > resp.txt
  pause
  )
fileappend, %bat%, %cxDir%\temp.bat
run, %cxDir%\temp.bat
sleep, 200
FileDelete, %cxDir%\temp.bat
}

zen_get_ticket_count(x=true)
{
	URL = https://ntmhelp.zendesk.com/api/v2/incremental/tickets.json?start_time=0
	bat = 
	  (
	  G:
	  cd G:\NTM\NTM Digital Produktion\cURL\bin
	  curl.exe -u mikael.lundin@ntm.eu/token:yGedN7Uxd4JUs2igdqWLtZxGvXlPK9DbCMrdQa8G %URL% > C:\temp\resp_get.txt
	  )
	fileappend, %bat%, %cxDir%\temp.bat
	run, %cxDir%\temp.bat,,Hide
	sleep, 200
	WinWaitClose, C:\Windows\system32\cmd.exe
	FileDelete, %cxDir%\temp.bat
	FileRead, resp, C:\temp\resp_get.txt
	response := JSON.parse(resp, true)
	count := response.count
	return count
}