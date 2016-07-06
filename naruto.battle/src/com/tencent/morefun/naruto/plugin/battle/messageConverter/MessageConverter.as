package com.tencent.morefun.naruto.plugin.battle.messageConverter
{

	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import serverProto.fight.FightStartType;
	import serverProto.fight.MetaActionType;
	import serverProto.fight.ProtoMetaAction;

	public class MessageConverter
	{
		public function MessageConverter()
		{
		}
		
		private static var acceptComboActionType:Array = [MetaActionType.ENCHANTMENT_ACITON, MetaActionType.NORMAL_ACTION, MetaActionType.MASTER_ACTION, MetaActionType.BUFF_ACTION];
		public static function convertMetaActionArr(metaActionList:Array, roundId:int):Array
		{
			var comboHold:Boolean;
			var metaAction:ProtoMetaAction;
			var comboAction:ProtoMetaAction;
			
			BuffConverter.reset();
			EnchantmentConverter.reset();
			FollowActionConverter.reset();
			ShieldConverter.reset();
			
			BuffConverter.convertMetaBuffs(metaActionList);//BUFF预处理
			ShieldConverter.convertMetaBuffs(metaActionList);//护盾预处理
			EnchantmentConverter.convertEnchantments(metaActionList);//结界预处理
			FollowActionConverter.converFollowActions(metaActionList);//追击信息预处理
			
			ConverterResultInfo.updateRoundId(roundId);
			for(var i:int = 0;i < metaActionList.length;i ++)
			{
				metaAction = metaActionList[i];
				if (BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GVG && BattleData.singleton.isGVGFightOverState == 0) {
					if (metaAction.isOver) {
						BattleData.singleton.isGVGFightOverState = 1;
					}
				}
				if(acceptComboActionType.indexOf(metaAction.type) == -1 && comboHold)
				{
					for(var j:int = i;j < metaActionList.length;j ++)
					{
						comboAction = metaActionList[j];
						if(acceptComboActionType.indexOf(comboAction.type) != -1)
						{
							metaActionList.splice(j + 1, 0, metaAction);
							i = j;
							metaAction = comboAction;
							break;
						}
					}
				}
				
				ConverterResultInfo.pushActionId(metaAction.id);
				switch(metaAction.type)
				{
					case MetaActionType.BUBBLE_DIALOGUE:
						BubbleDialogueConverter.convertBubbleDialogue(metaAction);
						break;
					case MetaActionType.ENCHANTMENT_ACITON:
						comboHold = EnchantmentConverter.convertEnchantment(metaAction);
						break;
					case MetaActionType.FORMATION_ACITON:
						FormationActionConverter.convertFormationAction(metaAction);
						break;
					case MetaActionType.STAGE_ACTION:
						StageActionConverter.convertStageAction(metaAction);
						break;
					case MetaActionType.SCRIPT_ACTION:
						ScriptActionConverter.convertScript(metaAction);
						break;
					case MetaActionType.NORMAL_ACTION:
						comboHold = NormalActionConverter.convertNormalAction(metaAction);
						break;
					case MetaActionType.MASTER_ACTION:
						comboHold = MasterActionConverter.convertMasterAction(metaAction);
						break;
					case MetaActionType.REBIRTH_ACTION:
						RebirthActionConverter.convertRebirthAction(metaAction);
						break;
					case MetaActionType.ABORT_ACTION:
						AbortSkillActionConverter.convertAbortSkillAction(metaAction);
						break;
					case MetaActionType.TRANSFORM_ACTION:
						TransformActionConverter.convertTransformAction(metaAction);
						break;
				}
			}
			
			return ConverterResultInfo.dumpActionInfos();
		}
		
		public static function dumpUpdatePlayerInfoNotice():Array
		{
			return ConverterResultInfo.dumpUpdatePlayerNoticeInfo();
		}
																
		public function autoSetNull():void
		{

			acceptComboActionType = null;
		}
	}
}