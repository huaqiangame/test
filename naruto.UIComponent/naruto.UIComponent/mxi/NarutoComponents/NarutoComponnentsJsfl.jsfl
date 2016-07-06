function reset_setNarutoComponentExternal_ing()
{
	fl.getDocumentDOM().addDataToDocument('setNarutoComponentExternal_ing', 'integer', 0);
}
function setNarutoComponentExternal()
{
	var doc = fl.getDocumentDOM();
	if (!doc)
	{
		return;
	}
	
	var ing = doc.getDataFromDocument('setNarutoComponentExternal_ing');
	if (ing == 1)
	{
		return;
	}
	
	doc.addDataToDocument('setNarutoComponentExternal_ing', 'integer', 1);
	try
	{
		var itemList = doc.library.items;
		for each (var item in itemList)
		{
			var clsName = item.linkageClassName;
			if (clsName && clsName.indexOf('naruto.component.') == 0)
			{
				if (!item.linkageImportForRS)
				{
					item.linkageExportForAS = false;
					item.linkageExportForRS = false;
					item.linkageImportForRS = true;
					item.linkageURL = 'http://res.huoying.qq.com/empty.swf';
				}
			}
		}
		doc.addDataToDocument('setNarutoComponentExternal_ing', 'integer', 0);
	}
	catch (e)
	{
		doc.addDataToDocument('setNarutoComponentExternal_ing', 'integer', 0);
	}
}







function addNarutoComponentSWCExternalLibraryPath()
{
	var doc = fl.getDocumentDOM();
	if (!doc)
	{
		return;
	}
	var url = fl.configDirectory + 'Components\\Naruto Components\\NarutoComponents.swc';
	if (FLfile.exists(FLfile.platformPathToURI(url)))
	{
		if (doc.externalLibraryPath.indexOf('NarutoComponents.swc') < 0)
		{
			doc.externalLibraryPath += ';' + url;
		}
		else
		{
			doc.externalLibraryPath = doc.externalLibraryPath.replace(/C:\\.*Components\\Naruto Components\\NarutoComponents\.swc/g, url);
		}
	}
}






function checkVersion(serverVersion, componentVersion, serverPath)
{
	var url = FLfile.platformPathToURI(fl.configDirectory + "NarutoComponents\\NarutoComponentsExtension.mxi");
	var localVersion;
	var str = FLfile.read(url);
	var re = new RegExp("version=\"([^\"]*)\"");
	var rs = re.exec(str);
	if(rs && rs.length == 2)
	{
		localVersion = rs[1];
	}
	
	if(serverVersion == localVersion)
	{
		if(localVersion != componentVersion)
		{
			fl.trace('【火影组件】当前fla文档库里的组件版本 '+componentVersion+' 与本地安装的组件版本 '+localVersion+' 不一致，请刷新fla文档库里的组件\n【火影组件】刷新方法：菜单->命令->【火影】刷新组件');
		}
	}else
	{
		fl.trace('【火影组件】发现新版本:'+serverVersion+',    当前版本:'+localVersion+'\n【火影组件】下载地址: '+serverPath);
	}
}


function checkVersionError()
{
	fl.trace("【火影组件】检查版本更新失败，请尝试配置host：\\n\\n10.12.23.11   toolres.naruto.qq.com");
}








