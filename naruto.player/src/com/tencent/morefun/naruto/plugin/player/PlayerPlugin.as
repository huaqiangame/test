package com.tencent.morefun.naruto.plugin.player
{
	import com.tencent.morefun.framework.apf.core.plugin.Plugin;
	import com.tencent.morefun.naruto.plugin.player.executers.PlayerDisplayStateExecuter;
	import com.tencent.morefun.naruto.plugin.player.executers.PlayerKnowledgeExecuter;
	import com.tencent.morefun.naruto.plugin.player.executers.PlayerMoveExecuter;
	import com.tencent.morefun.naruto.plugin.player.executers.PlayerProtoExecuter;
	import com.tencent.morefun.naruto.plugin.player.executers.PlayerTeamExecuter;
	import com.tencent.morefun.naruto.plugin.player.executers.PlayerTodoNotifyExectuer;
	import com.tencent.morefun.naruto.plugin.player.executers.PlayerViewExecuter;
	import com.tencent.morefun.naruto.plugin.player.models.PlayerModel;
	import com.tencent.morefun.naruto.plugin.player.utils.PlayerUtil;
	
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import def.PluginDef;
	
	public class PlayerPlugin extends Plugin
	{
		public function PlayerPlugin()
		{
			super();
		}
		
		override public function getPluginName():String
		{
			return PluginDef.PLAYER;
		}
		
		override public function initialize(config:XML):void
		{
			PlayerUtil.effectMap = new Dictionary();
//			PlayerUtil.effectMap[PlayerUtil.EFFECT_TYP_RUN] = getEffectAppDomain("plugin.role.effect_run");
//			PlayerUtil.effectMap[PlayerUtil.EFFECT_TYP_HP] = getEffectAppDomain("plugin.role.effect_addhp");
//			PlayerUtil.effectMap[PlayerUtil.EFFECT_TYP_MP] = getEffectAppDomain("plugin.role.effect_addmp");
//            PlayerUtil.effectMap[PlayerUtil.EFFECT_TYP_LEVEL_UP] = getEffectAppDomain("plugin.role.effect_levelup");
//            PlayerUtil.effectMap[PlayerUtil.EFFECT_TYP_STRENGTH] = getEffectAppDomain("plugin.role.effect_add_strength");
			
			registerModel(new PlayerModel());
			
			registerExecuter(new PlayerViewExecuter());
			registerExecuter(new PlayerMoveExecuter());
			registerExecuter(new PlayerProtoExecuter());
			registerExecuter(new PlayerDisplayStateExecuter());
			registerExecuter(new PlayerTeamExecuter());
			registerExecuter(new PlayerTodoNotifyExectuer());
			registerExecuter(new PlayerKnowledgeExecuter());
		}
		
		private function getEffectAppDomain(name:String):ApplicationDomain
		{
			return (getResource(PluginDef.PLAYER)[name] as Loader).contentLoaderInfo.applicationDomain;
		}
		
	}
}