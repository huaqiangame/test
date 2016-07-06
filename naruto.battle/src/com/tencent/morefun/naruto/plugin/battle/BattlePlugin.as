package com.tencent.morefun.naruto.plugin.battle
{

	import com.tencent.morefun.framework.apf.core.facade.Facade;
	import com.tencent.morefun.framework.apf.core.plugin.Plugin;
	import com.tencent.morefun.framework.apf.plugin.pluginmanager.interfaces.IPluginManager;
	import com.tencent.morefun.naruto.plugin.battle.cfg.BattleStanceConfig;
	import com.tencent.morefun.naruto.plugin.battle.cfg.CustomBattleConfig;
	import com.tencent.morefun.naruto.plugin.battle.cfg.SpecialbattleConfig;
	import com.tencent.morefun.naruto.plugin.battle.executer.ControlExecuter;
	import com.tencent.morefun.naruto.plugin.battle.executer.GuidExecuter;
	import com.tencent.morefun.naruto.plugin.battle.executer.PerwarServerExecuter;
	import com.tencent.morefun.naruto.plugin.battle.executer.ServerExecuter;
	import com.tencent.morefun.naruto.plugin.battle.executer.TestExecuter;
	import com.tencent.morefun.naruto.sound.data.BgMusicConfig;
	import com.tencent.morefun.naruto.sound.def.BgMusicTypeDef;
	
	import flash.utils.ByteArray;
	
	import battle.IBattlePlugin;
	
	import def.PluginDef;
	
	import ui.command.ShowTextBoxCommand;

	public class BattlePlugin extends Plugin implements IBattlePlugin
	{
		public function BattlePlugin()
		{
			super();//
		}
		
		override public function getPluginName():String
		{
			return PluginDef.BATTLE;
		}
		
		override public function initialize(config:XML):void
		{
			trace("BattlePlugin.initialize");
			
			var config:XML;
			var musicConfig:BgMusicConfig = CustomBattleConfig.musicConfig;
			config = getResource(PluginDef.BATTLE)["plugin.battle.music"] as XML;
			musicConfig.importConfig(config);
			
			config = getResource(PluginDef.BATTLE)["plugin.battle.customBattle"] as XML;
			CustomBattleConfig.setXML(config);
			
			BattleStanceConfig.xml = getResource(PluginDef.BATTLE)["plugin.battle.battlestance"] as XML;
			SpecialbattleConfig.specialbattleBin = getResource(PluginDef.BATTLE)["plugin.battle.specialbattle"] as ByteArray;
			
			// 注册默认背景音乐
			getSoundManager().battleMusicMgr.setDefaultMusicPool(musicConfig.getDefaultMusicPool(BgMusicTypeDef.PVE_BATTLE_MUSIC), BgMusicTypeDef.PVE_BATTLE_MUSIC);
			getSoundManager().battleMusicMgr.setDefaultMusicPool(musicConfig.getDefaultMusicPool(BgMusicTypeDef.PVP_BATTLE_MUSIC), BgMusicTypeDef.PVP_BATTLE_MUSIC);
			
			
			this.registerExecuter(new ControlExecuter());
			this.registerExecuter(new ServerExecuter());
			this.registerExecuter(new PerwarServerExecuter());
			this.registerExecuter(new GuidExecuter());
			this.registerExecuter(new TestExecuter());
		}
		
		override public function finalize():void
		{
			
			
			
		}
		
		override public function handlerUncatchError(error:Error):void
		{
			new ShowTextBoxCommand(error.message).call();
		}
		
		public function getPluginManager():IPluginManager
		{
			return Facade.getInstance().retrievePlugin("com.tencent.apf.plugin.pluginmanager.interfaces.IPluginManager") as IPluginManager
		}
		
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

		}
	}
}