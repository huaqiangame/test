package naruto.component.utils
{
	import adobe.utils.MMExecute;
	
	public class MMUtils
	{
		private static var updateUtils:UpdateUtils;
		
		public function MMUtils()
		{
		}
		
		/**
		 * 检查是否处于 Flash Professional 的创作环境中。
		 * @return 
		 */		
		public static function checkFlashProfessional():Boolean
		{
			try
			{
				if (MMExecute("fl.version"))
				{
					return true;
				}
			}
			catch (e:Error)
			{
				return false;
			}
			return false;
		}
		
		/**
		 * 设置火影组件为“为运行时共享而导入的”。
		 */		
		public static function setNarutoComponentExternal():void
		{
			var code:String = "var file = fl.configURI + 'NarutoComponents/NarutoComponnentsJsfl.jsfl';" +
				"fl.runScript(file, 'setNarutoComponentExternal');";
			MMExecute(code);
		}
		
		/**
		 * 添加火影库（外部库）。不这样做的话，fla 导致 swc 时可能不包含“组件导入的类”。
		 */		
		public static function addNarutoComponentSWCExternalLibraryPath():void
		{
			var code:String = "var file = fl.configURI + 'NarutoComponents/NarutoComponnentsJsfl.jsfl';" +
				"fl.runScript(file, 'addNarutoComponentSWCExternalLibraryPath');";
			MMExecute(code);
		}
		
		/**
		 * 检查 zxp 扩展包有没有更新。
		 */		
		public static function checkExtensionUpdate():void
		{
			if (!MMUtils.updateUtils)
			{
				MMUtils.updateUtils = new UpdateUtils();
			}
			MMUtils.updateUtils.checkUpdate();
		}
		
		/**
		 * 在 Flash IDE 中 trace 内容。
		 * @param str
		 */		
		public static function mmTrace(str:String):void
		{
			MMExecute("fl.trace('" + str + "');");
		}
		
		/**
		 * 刷新“组件”面板的组件列表。 
		 */		
		public static function reloadComponentsPanel(str:String):void
		{
			MMExecute(" fl.componentsPanel.reload();");
		}
		
	}
}