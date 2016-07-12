package naruto.component.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import adobe.utils.MMExecute;
	
	public class UpdateUtils
	{
		private const URL:String = "http://toolres.naruto.qq.com/NarutoComponents/update.xml";
		private const UPDATE_TIME_GAP:uint = 1000*60*10;//10分钟
		
		private var urlLoader:URLLoader;
		
		public function UpdateUtils()
		{
			XML.ignoreWhitespace = true;
		}
		
		public function checkUpdate():void
		{
			if (this.canUpdate())
			{
				var updateTime:uint = new Date().time;
				this.setUpdateTime(updateTime);
				this.urlLoader = new URLLoader();
				this.urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				this.urlLoader.addEventListener(Event.COMPLETE, this.onEventHandler);
				this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onEventHandler);
				this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onEventHandler);
				this.urlLoader.load(new URLRequest(this.URL + "?updateTime=" + updateTime));
			}
		}
		
		private function onEventHandler(event:Event):void
		{
			if (event.type == Event.COMPLETE)
			{
				var updateData:XML = new XML(this.urlLoader.data);
				var newVersion:String = String(updateData.@version);
				var path:String = String(updateData.@path)
				MMExecute("var file = fl.configURI + 'NarutoComponents/NarutoComponnentsJsfl.jsfl'; fl.runScript(file, 'checkVersion', '" + newVersion + "', '" + Version.version + "', '" + path + "')");
			}
			else
			{
				MMExecute("var file = fl.configURI + 'NarutoComponents/NarutoComponnentsJsfl.jsfl'; fl.runScript(file, 'checkVersionError')");
			}
			this.urlLoader.removeEventListener(Event.COMPLETE, this.onEventHandler);
			this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onEventHandler);
			this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onEventHandler);
			this.urlLoader = null;
		}
		
		private function canUpdate():Boolean
		{
			var now:uint = new Date().time;
			return (now - this.getUpdateTime() > this.UPDATE_TIME_GAP);
		}
		
		private function setUpdateTime(time:uint):void
		{
			MMExecute("var doc = fl.getDocumentDOM();if (doc){doc.addDataToDocument('NarutoComponentsUpdateTime', 'double', "+time+");}");
		}
		
		private function getUpdateTime():uint
		{
			var time:uint = parseInt(MMExecute("var doc = fl.getDocumentDOM();if (doc){doc.getDataFromDocument('NarutoComponentsUpdateTime');}"), 10);
			return time;
		}
		
		private function getLocalVersion():String
		{
			return MMExecute("fl.configURI");
		}
		
	}
}