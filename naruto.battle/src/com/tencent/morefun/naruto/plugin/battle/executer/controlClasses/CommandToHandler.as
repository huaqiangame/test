package com.tencent.morefun.naruto.plugin.battle.executer.controlClasses 
{

	import com.tencent.morefun.framework.base.Command;
	
	import flash.utils.Dictionary;
	
	import avmplus.getQualifiedClassName;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class CommandToHandler 
	{
		private var _cmdMap:Dictionary = new Dictionary;;
		public function CommandToHandler() 
		{
			
		}
		
		public function handle(command:Command):void 
		{
			var key:String = getQualifiedClassName(command);
			if (key in _cmdMap) {
				var fn:Function = _cmdMap[key];
				if (fn.length == 1) {
					fn(command);
				}
				else if (fn.length == 0) {
					fn();
				}
				else {
					throw ArgumentError(I18n.lang("as_battle_1451031565_275"));
				}
			}
		}
		
		public function addToMap(Cmd:Class,handler:Function):void 
		{
			_cmdMap[getQualifiedClassName(Cmd)] = handler;
		}
		
																
		public function autoSetNull():void
		{

			_cmdMap = null;
		}
	}

}