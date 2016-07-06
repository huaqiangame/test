flash.outputPanel.clear();

var file = fl.configURI + 'NarutoComponents/NarutoComponnentsJsfl.jsfl';
fl.runScript(file, 'reset_setNarutoComponentExternal_ing');
fl.runScript(file, 'setNarutoComponentExternal');
fl.runScript(file, 'addNarutoComponentSWCExternalLibraryPath');



fl.componentsPanel.reload();
var doc = fl.getDocumentDOM();
doc.selectNone();
if (doc)
{
	var tempFolder = "NarutoComponentsTempFolderForRefresh";
	doc.library.newFolder(tempFolder);
	
	var index = doc.getTimeline().addNewLayer("组件", "guide", true);
	
	doc.selectNone();
	var items = doc.library.items;
	for each (var oldItem in items)
	{
		var linkName = oldItem.linkageClassName;
		if (linkName && linkName.indexOf('naruto.component.') == 0)
		{
			var clsName = linkName.split('.').pop();
			var oldFolder = oldItem.name.indexOf("/") < 0 ? "" : oldItem.name.replace("/"+clsName, ""); // 原来的文件夹
			
			// 把旧组件放到临时文件夹
			doc.library.moveToFolder(tempFolder, oldItem.name, true);
			
			// 把新组件放到舞台上，在库中默认放在根目录
			fl.componentsPanel.addItemToDocument({x:0, y:0}, 'Naruto Components', clsName);
			
			// 把新组件从根目录放到临时文件夹，覆盖旧的
			var newPath = doc.selection[0].libraryItem.name;
			doc.library.moveToFolder(tempFolder, newPath, true);
			newPath = tempFolder + "/" + newPath;
			
			// 把新组件从临时文件夹放到原来的文件夹
			doc.library.moveToFolder(oldFolder, newPath, true);
			
			doc.deleteSelection();
		}
	}	
	
	doc.library.deleteItem(tempFolder);
	doc.getTimeline().deleteLayer(index);
}
