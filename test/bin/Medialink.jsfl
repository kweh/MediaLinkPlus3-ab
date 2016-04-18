// *********************************************************
// Medialink.jsfl
//
// @purpose : Open / Crteate a FLA for Ad. If Ad document 
//			  exists, open the Ad or if it doesn't exist
//			  create a new document of the right size & 
//			  save the Ad on file server	
// *********************************************************

//Call C++ DLL for Values
var path = MediaLinkFL.mlGetAdFilePath();
fl.trace(path);
var nWidth = MediaLinkFL.mlGetAdWidth();
fl.trace(nWidth);
var nHeight = MediaLinkFL.mlGetAdHeight();
fl.trace(nHeight);

//Open a existing document or create
var osFileURI = FLfile.platformPathToURI(path);
if(fl.fileExists(osFileURI))
{
	fl.openDocument(osFileURI);
	
	//Check for Size Changes
}
else
{
	//Create a new document & save in folder
	fl.createDocument("timeline");
	fl.getDocumentDOM().height = nHeight;
	fl.getDocumentDOM().width = nWidth;
	fl.saveDocument(fl.getDocumentDOM(), osFileURI);
}

// ************************************
// Sample test Code
// ************************************

// store directory to a variable  
// -- var configDir = fl.configDirectory; 
// display directory in the Output panel 
// -- fl.trace(fl.configDirectory);
