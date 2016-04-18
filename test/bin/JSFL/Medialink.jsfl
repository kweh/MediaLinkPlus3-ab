// *********************************************************
// Medialink.jsfl
//
// @purpose : Open / Create a FLA for Ad. If Ad document 
//			  exists, open the Ad or if it doesn't exist
//			  create a new document of the right size & 
//			  save the Ad on file server	
// *********************************************************

//Call C++ DLL for Values
//alert('');
var configDir = fl.configDirectory;
//fl.trace(configDir);
var path = MediaLinkFL.mlGetAdFilePath();
//fl.trace(path);
var nWidth = MediaLinkFL.mlGetAdWidth();
//fl.trace(nWidth);
var nHeight = MediaLinkFL.mlGetAdHeight();
//fl.trace(nHeight);

//Open a existing document or create
var osFileURI = FLfile.platformPathToURI(path);
if(fl.fileExists(osFileURI))
{
	var doc = fl.openDocument(osFileURI);
	if(doc)
	{
		//update internal datastructure of AdList with the opened document
		MediaLinkFL.mlUpdateAdOpenList(configDir);

		//Check for Size Changes
		if(doc.height != nHeight || doc.width != nWidth)
		{
			fl.getDocumentDOM().height = parseInt(nHeight);
			fl.getDocumentDOM().width = parseInt(nWidth);
		}
	}
	else
	{
		//report alert that document open failed
		  alert("Unable to Open the Document");
	}
}
else
{
	//Create a new document & save in folder
	fl.createDocument("timeline");
	fl.getDocumentDOM().height = parseInt(nHeight);
	fl.getDocumentDOM().width = parseInt(nWidth);
	fl.saveDocument(fl.getDocumentDOM(), osFileURI);
	var doc = fl.openDocument(osFileURI);
	if(doc)
	{
		//update internal datastructure of AdList with the opened document
		  MediaLinkFL.mlUpdateAdOpenList(configDir);
	}
	else
	{
		//report alert that document open failed
		   alert("Unable to Open the Document");
	}
}
//alert(configDir);
