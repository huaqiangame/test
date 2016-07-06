package com.tencent.morefun.naruto.plugin.prewar
{
	import com.tencent.morefun.framework.apf.core.plugin.Plugin;
	import com.tencent.morefun.naruto.plugin.prewar.data.PrewarModel;
	import com.tencent.morefun.naruto.plugin.prewar.executer.PrewarExecuter;
	import com.tencent.morefun.naruto.plugin.prewar.executer.TeamFroamtionExecuter;
	
	import def.PluginDef;
	
	import prewar.IPrewarPlugin;
	
	public class PrewarPlugin extends Plugin implements IPrewarPlugin
	{
		public function PrewarPlugin()
		{
			super();
		}
		
		override public function initialize(config:XML):void
		{
			this.registerModel(new PrewarModel());
			
			this.registerExecuter(new PrewarExecuter());
			this.registerExecuter(new TeamFroamtionExecuter());
		}
		
		override public function getPluginName():String
		{
			return PluginDef.PREWAR;
		}
	}
}