package com.tencent.morefun.naruto.plugin.battle.data
{

	import com.tencent.morefun.naruto.plugin.battle.command.CancelSkillActionCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ChangedCustomIDCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.GuidSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.GuidUpdateSkillStateCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.InitializeBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.InsertBattleInitCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyFightOverCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyKathaSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyRoundSyncCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyStartBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyTinyRoundsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowPrewarChooseCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateLeftBattleRoundCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdatePlayerOnlineInfoCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateSkillStateCommand;
	import com.tencent.morefun.naruto.plugin.battle.notice.ContractPetEnterNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.ContractPetExeuntNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.GVGFightOverNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdatePlayerInfoNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdateWatchFlagNotice;
	import com.tencent.morefun.naruto.plugin.motion.data.AbortSkillActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import com.tencent.morefun.naruto.plugin.motion.data.AfterActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.AttributeChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.BaseChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.BubbleDialogueActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.BubbleDialogueData;
	import com.tencent.morefun.naruto.plugin.motion.data.BuffEffectInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.CallupActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.ComboActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.CommonActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.EnchantmentActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.EnchantmentInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.GuidScriptActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.HpChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.KathaChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.LogicEffectInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.LogicEffectInfoCfg;
	import com.tencent.morefun.naruto.plugin.motion.data.LogicEffectResEffectInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.OnlyDefenceEffectActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.PassiveHero;
	import com.tencent.morefun.naruto.plugin.motion.data.ScriptActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.SkillStatuInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.TransformActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.buff.data.BuffInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.shield.data.ShieldInfo;
	
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import avmplus.getQualifiedClassName;
	
	import base.ApplicationData;
	
	import battle.data.BattleInfo;
	
	import def.ModelDef;
	
	import serverProto.fight.ProtoTeamInfo;

	public class RecoData
	{
		private var recoArray:Array = [];
		private var recoBytes:ByteArray = new ByteArray();
		
		public function RecoData()
		{
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.ComboActionInfo", ComboActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.CommonActionInfo", CommonActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.StageActionInfo", StageActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.CallupActionInfo", CallupActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.ScriptActionInfo", ScriptActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.EnchantmentActionInfo", EnchantmentActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.EnchantmentInfo", EnchantmentInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.manager.buff.data.BuffInfo", BuffInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.PassiveHero", PassiveHero);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.ActivityHero", ActivityHero);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.AttributeChangedInfo", AttributeChangedInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.AfterActionInfo", AfterActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo", NinjaInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.data.UIData", UIData);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.data.UIPlayerData", UIPlayerData);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.data.UINinjaData", UINinjaData);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.message.ProtoTeamInfo", ProtoTeamInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.BaseChangedInfo", BaseChangedInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.SkillStatuInfo", SkillStatuInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.BubbleDialogueActionInfo", BubbleDialogueActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.BubbleDialogueData", BubbleDialogueData);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.StageInfo", StageInfo);
			registerClassAlias("flash.geom.Point", Point);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.KathaChangedInfo", KathaChangedInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.PassiveEffectInfo", LogicEffectInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.LogicEffectInfoCfg", LogicEffectInfoCfg);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.manager.shield.data.ShieldInfo", ShieldInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.HpChangedInfo", HpChangedInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.AbortSkillActionInfo", AbortSkillActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.TransformActionInfo", TransformActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.BuffEffectInfo", BuffEffectInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.data.CustomInfo", CustomInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.OnlyDefenceEffectActionInfo", OnlyDefenceEffectActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.command.GuidUpdateSkillStateCommand", GuidUpdateSkillStateCommand);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.GuidScriptActionInfo", GuidScriptActionInfo);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.command.GuidSkillCommand", GuidSkillCommand);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.command.ShowPrewarChooseCommand", ShowPrewarChooseCommand);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.command.UpdatePlayerOnlineInfoCommand", UpdatePlayerOnlineInfoCommand);
			registerClassAlias("com.tencent.morefun.naruto.plugin.battle.command.InsertBattleInitCommand", InsertBattleInitCommand);
			registerClassAlias("com.tencent.morefun.naruto.plugin.motion.data.LogicEffectResEffectInfo", LogicEffectResEffectInfo);
			
			var arr:Array = [
			UpdateSkillStateCommand,
			UpdatePlayerInfoNotice,
			NotifyTinyRoundsCommand,
			NotifyRoundSyncCommand,
			ChangedCustomIDCommand,
			NotifyFightOverCommand,
			CancelSkillActionCommand,
			NotifyKathaSkillCommand,
			ContractPetEnterNotice,
			ContractPetExeuntNotice,
			UpdateWatchFlagNotice,
			NotifyStartBattleCommand,
			InitializeBattleCommand,
			GVGFightOverNotice,
			UpdateLeftBattleRoundCommand
			];
			for (var i:int = 0; i < arr.length; i++) 
			{
				registerClassAlias(getQualifiedClassName(arr[i]), arr[i]);
			}
			
		}
		
		public function reset():void
		{
			recoArray = [];
			recoBytes = new ByteArray();
			
			(ApplicationData.singleton.getModel(ModelDef.BATTLE) as BattleInfo).replayData = recoBytes;
		}
		
		public function load(value:ByteArray):void
		{
			reset();
			
			value.position = 0;
			while(value.bytesAvailable)
			{
				recoArray.push(value.readObject());
			}
			
			this.recoBytes = value;
		}
		
		public function save(value:Object):void
		{
			recoArray.push(value);
			recoBytes.writeObject(value);
		}
		
		public function getRecoBytes():ByteArray
		{
			return recoBytes;
		}
		
		public function getStartReco():Object
		{
			return recoArray[0];
		}
		public function getRecoByRenderIndex(rendererIndex:int):Array
		{
			var recoObjs:Array;
			
			recoObjs = [];
			for each(var recoObj:Object in recoArray)
			{
				if(recoObj.rendererIndex == rendererIndex)
				{
					recoObjs.push(recoObj);
				}
			}
			return recoObjs;
		}
																
		public function autoSetNull():void
		{

			recoArray = null;
			recoBytes = null;
		}
	}
}