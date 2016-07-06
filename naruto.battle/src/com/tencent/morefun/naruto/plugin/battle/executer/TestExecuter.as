package com.tencent.morefun.naruto.plugin.battle.executer
{
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.naruto.executer.Executer;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.battle.cfg.TestBattleConfig;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateContinueTestFlagCommand;
	
	import flash.utils.setTimeout;
	
	import avmplus.getQualifiedClassName;
	
	import battle.command.ContinueTestBattleCommand;
	import battle.command.RequestPveFightStartCommand;
	import battle.data.BattleInfo;
	import battle.def.BattleKeyDef;
	import battle.def.RequestFightStartTypeDef;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;

	public class TestExecuter extends Executer
	{
		private var battleModel:BattleInfo;
		
		public function TestExecuter()
		{
			super(PluginDef.BATTLE, ExecuterDef.BATTLE_TEST); 
			
			battleModel = plugin.retrieveModel(ModelDef.BATTLE) as BattleInfo;
			battleModel.addEventListener(ModelEvent.UPDATE, onModelUpdate);
		}
		
		private function onModelUpdate(evt:ModelEvent):void
		{
			switch(evt.key)
			{
				case BattleKeyDef.END:
					setTimeout(startNextFight, 1000);
					break;
			}
		}
		
		private function startNextFight():void
		{
			if(customBattleIndex < customBattleIdList.length)
			{
				customBattleIndex ++;
				new RequestPveFightStartCommand(RequestFightStartTypeDef.CUSTOM_FIGHT, customBattleIdList[customBattleIndex]).call();
			}
			else
			{
				new UpdateContinueTestFlagCommand(false).call();
			}
		}
		
		private var customBattleIndex:int;
		private var customBattleIdList:Array = [];
		override public function doCommand(command:Command):void
		{
			switch(getQualifiedClassName(command))
			{
				case getQualifiedClassName(ContinueTestBattleCommand):
					customBattleIndex = 0;
					customBattleIdList = TestBattleConfig.getTestBattleIdList();
					new RequestPveFightStartCommand(RequestFightStartTypeDef.CUSTOM_FIGHT, customBattleIdList[customBattleIndex]).call();
					new UpdateContinueTestFlagCommand(true).call();
					break;
			}
		}
		
		
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			battleModel = null;
			customBattleIdList = null;
		}
	}
}