var itemList = fl.getDocumentDOM().library.items;
var componentList = [];
for each (var item in itemList)
{
	if (item.itemType == "bitmap")
	{
		item.allowSmoothing = true;
		item.compressionType = "photo";
		item.quality = 80; // 位图质量为 80
	}
	else if (item.itemType == "component" && item.linkageClassName.indexOf("naruto.component.") == 0)
	{
		item.linkageExportInFirstFrame = false;
		componentList.push(item);
	}
}

var toFolder = fl.getDocumentDOM().pathURI.replace("fla/NarutoComponents.fla", "");
toFolder += "mxi/Components/Naruto Components/";
for each (var component in componentList)
{
	var clsName = component.linkageClassName.split(".").pop();
	component.exportSWC(toFolder + clsName + ".swc");
}


