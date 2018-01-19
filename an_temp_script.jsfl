fl.createDocument("timeline");
var workPath = "file:///G|/NTM/NTM Digital Produktion/Webbannonser/0-Arkiv/2017/M/MOHV/170814/SKYLT - MOHV - 170814.fla"
var doc = fl.getDocumentDOM();
var tLine = fl.getDocumentDOM().getTimeline();
var layerOne = doc.getTimeline().layers[0];
doc.width = 256;
doc.height = 400;
doc.frameRate = 30
layerOne.name = 'Lager 1';
fl.saveDocument(fl.documents, workPath);