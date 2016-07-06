package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	
	import com.tencent.morefun.naruto.plugin.battle.cfg.BattleStanceCfg;
	import com.tencent.morefun.naruto.plugin.battle.cfg.BattleStanceConfig;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.motion.data.ActivityHero;
	import com.tencent.morefun.naruto.plugin.motion.data.AttributeChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.BaseChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.BuffEffectInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.HpChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.KathaChangedInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.LogicEffectInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.PassiveEffectConfig;
	import com.tencent.morefun.naruto.plugin.motion.data.PassiveHero;
	import com.tencent.morefun.naruto.plugin.motion.data.SkillStatuInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageActionType;
	import com.tencent.morefun.naruto.plugin.motion.data.StageNinjaActionType;
	import com.tencent.morefun.naruto.plugin.motion.manager.buff.data.BuffInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.shield.data.ShieldConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.shield.data.ShieldInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.skill.SkillConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.skill.data.SkillDef;
	import com.tencent.morefun.naruto.plugin.motion.manager.skill.data.SkillInfo;
	
	import flash.utils.Dictionary;
	
	import cfgData.CFGDataEnum;
	import cfgData.CFGDataLibs;
	import cfgData.dataStruct.ArenaBadgeCFG;
	import cfgData.dataStruct.NinjaSkillCFG;
	
	import majorRole.def.MajorNinjaDef;
	
	import serverProto.fight.FightStartType;
	import serverProto.fight.ProtoAbortNinjaAwakenSkill;
	import serverProto.fight.ProtoActiveNinjaInfo;
	import serverProto.fight.ProtoBuffAction;
	import serverProto.fight.ProtoBuffInfo;
	import serverProto.fight.ProtoHintInfo;
	import serverProto.fight.ProtoHpChangeDescribe;
	import serverProto.fight.ProtoNinja;
	import serverProto.fight.ProtoNinjaHintInfo;
	import serverProto.fight.ProtoNinjaHpChange;
	import serverProto.fight.ProtoNormalAction;
	import serverProto.fight.ProtoPassiveNinjaInfo;
	import serverProto.fight.ProtoPlayerTeamPos;
	import serverProto.fight.ProtoRebirthAction;
	import serverProto.fight.ProtoSkillState;
	import serverProto.fight.ProtoStageInfo;
	import serverProto.fight.ProtoTeamInfo;
	import serverProto.fight.ProtoTeamKathaChange;
	import serverProto.fight.ProtoTransformAction;
	
	import skill.command.GetNinjaSkillConfigSkillCommnad;
	import skill.config.NinjaSkillConfig;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class BaseConverter
	{
		public function BaseConverter()
		{
		}
		
		/**
		 *解析BUFF 
		 * @param buffAction
		 * @param isOver
		 * @return 
		 * 
		 */		
		public static function convertBuffAction(buffAction:ProtoBuffAction, isOver:Boolean):BuffInfo
		{
			var buffInfo:BuffInfo = new BuffInfo();
			var changedInfo:BaseChangedInfo;
			var logicEffectInfo:LogicEffectInfo;
			
			buffInfo.buffId = buffAction.buff.buffId;
			buffInfo.newBuffId = buffAction.buff.buffId;
			buffInfo.oldBuffId = buffAction.oldBuffId;
			buffInfo.pos = buffAction.realPos;
			buffInfo.hp = buffAction.hp;
			buffInfo.type = buffAction.actionType;
			buffInfo.close = buffAction.buffActionTime;
			buffInfo.katha = buffAction.katha;
			buffInfo.maxHp = buffAction.buff.buffArg1;
			buffInfo.protectHp = buffAction.buff.buffArg2;
			buffInfo.group = buffAction.buff.buffGroup;
			buffInfo.overlay = buffAction.buff.buffOverlay;
			if(buffAction.hasMoney){buffInfo.money = getMoneyChangedValue(buffAction.money);}
			buffInfo.isOver = isOver;
			
			logicEffectInfo = new LogicEffectInfo();
			logicEffectInfo.buffId = buffInfo.buffId;
			logicEffectInfo.id = buffInfo.buffId;
			logicEffectInfo.cfg = PassiveEffectConfig.getBuffLogicEffectCfg(buffInfo.buffId);
			buffInfo.logicEffectInfo = logicEffectInfo;
			
			
			for each(var hintInfo:ProtoHintInfo in buffAction.hintInfo)
			{
				if(hintInfo.type == BaseChangedInfo.BLOOD ||
					hintInfo.type == BaseChangedInfo.ALLELOPATHY ||
					hintInfo.type == BaseChangedInfo.RESTRAIN_WATER_TO_FIRE ||
					hintInfo.type == BaseChangedInfo.RESTRAIN_FIRE_TO_WIND ||
					hintInfo.type == BaseChangedInfo.RESTRAIN_WIND_TO_THUNDER ||
					hintInfo.type == BaseChangedInfo.RESTRAIN_THUNDER_TO_EARTH ||
					hintInfo.type == BaseChangedInfo.RESTRAIN_EARTH_TO_WATER ||
					hintInfo.type == BaseChangedInfo.IGNITE ||
					hintInfo.type == BaseChangedInfo.POISON ||
					hintInfo.type == BaseChangedInfo.STEAL_HP ||
					hintInfo.type == BaseChangedInfo.PRISON ||
					hintInfo.type == BaseChangedInfo.DAMAGE_FROM_OTHER)
				{
					changedInfo = new BaseChangedInfo();
					changedInfo.type = hintInfo.type;
					changedInfo.value = hintInfo.arg;
					buffInfo.baseChangedInfo.push(changedInfo);
				}
				else
				{
					changedInfo = new BaseChangedInfo();
					changedInfo.type = hintInfo.type;
					changedInfo.value = hintInfo.arg;
					buffInfo.attributeChangedInfo.push(changedInfo);
				}
			}
			
			return buffInfo;
		}
		
		public static function convertBuffEffectAction(buffAction:ProtoBuffAction, isOver:Boolean):BuffEffectInfo
		{
			var buffEffectInfo:BuffEffectInfo = new BuffEffectInfo();
			
			if(buffAction.addBuffType == 1)
			{
				buffEffectInfo.effect = BuffEffectInfo.EFFCT_IMMUNITY;
				buffEffectInfo.pos = buffAction.wantedPos;
				buffEffectInfo.close = buffAction.buffActionTime;
			}
			else if(buffAction.addBuffType == 2)
			{
				buffEffectInfo.effect = BuffEffectInfo.EFFCT_TRANSFORM;
				buffEffectInfo.pos = buffAction.wantedPos;
				buffEffectInfo.close = buffAction.buffActionTime;
			}
			
			return buffEffectInfo;
		}
		
		/**
		 *解析护盾BUFF 
		 * @param buffAction
		 * @param isOver
		 * @return 
		 * 
		 */		
		public static function convertShieldAction(buffAction:ProtoBuffAction):ShieldInfo
		{
			var shieldInfo:ShieldInfo = new ShieldInfo();
			
			shieldInfo.id = buffAction.buff.buffId;
			shieldInfo.newId = buffAction.buff.buffId;
			shieldInfo.oldId = buffAction.oldBuffId;
			shieldInfo.pos = buffAction.realPos;
			if(buffAction.hasMoney){shieldInfo.money = getMoneyChangedValue(buffAction.money);}
			shieldInfo.close = buffAction.buffActionTime;
			shieldInfo.type = buffAction.actionType;
			shieldInfo.hp = buffAction.buff.buffArg2;
			shieldInfo.maxHp = buffAction.buff.buffArg1;
			shieldInfo.cfg = ShieldConfig.getShieldInfoCfgById(buffAction.buff.buffId);
			
			return shieldInfo;
		}
		
		/**
		 *解析攻击忍者 
		 * @param activtiyNinja
		 * @return 
		 * 
		 */		
		public static function convertNormalActivtiyNinja(activtiyNinja:ProtoActiveNinjaInfo, normalAction:ProtoNormalAction):ActivityHero
		{
			var activityHero:ActivityHero;
			var passiveHerosPos:Array = [];
			
			passiveHerosPos = getNormalActionPassiveHerosPos(normalAction);
			
			activityHero = new ActivityHero();
			activityHero.pos = activtiyNinja.activeNinjaPos;
			activityHero.skillId = activtiyNinja.skillInfo.skillId;
			activityHero.totalAttackTimes = activtiyNinja.totalAttackTimes;
			activityHero.hitNum = activtiyNinja.hitNum;
			activityHero.hasSkillIdle = activtiyNinja.hasSkillCongest;
			activityHero.skillIdle = activtiyNinja.skillCongest != 0;
			activityHero.isRevert = normalAction.isRevert == 1;
			
			activityHero.hpChangedInfo = convertNinjaBaseChangedInfo(activityHero.pos, normalAction.ninjaHpChange, normalAction.teamKathaChange, normalAction.ninjaHintInfo);
			activityHero.attributeChangedInfo =  convertNinjaAttributeChangedInfo(activityHero.pos, normalAction.ninjaHpChange, normalAction.ninjaHintInfo);
			
			activityHero.otherHpChangedInfoList = convertOtherNinjaBaseChangedInfoList(activtiyNinja.activeNinjaPos, normalAction.ninjaHpChange, passiveHerosPos, normalAction.ninjaHintInfo);
			activityHero.otherAttributeChangedInfoList = convertOtherNinjaAttributeChangedInfoList(activtiyNinja.activeNinjaPos, normalAction.ninjaHpChange, passiveHerosPos, normalAction.ninjaHintInfo);
			if(activtiyNinja.skillInfo.hasSkillIndex)
			{
				activityHero.useSpecialSkill = true;
				activityHero.useSpecialSkillIndex = activtiyNinja.skillInfo.skillIndex;
			}
			
			if(activityHero.hpChangedInfo != null && activityHero.hpChangedInfo.hp <= 0)
			{
				activityHero.isDead = true;
			}
			
			return activityHero;
		}
		
		public static function convertActivityNinja(activtiyNinja:ProtoActiveNinjaInfo):ActivityHero
		{
			var activityHero:ActivityHero;
			
			activityHero = new ActivityHero();
			activityHero.pos = activtiyNinja.activeNinjaPos;
			activityHero.skillId = activtiyNinja.skillInfo.skillId;
			activityHero.totalAttackTimes = activtiyNinja.totalAttackTimes;
			activityHero.hitNum = activtiyNinja.hitNum;
			activityHero.hasSkillIdle = activtiyNinja.hasSkillCongest;
			activityHero.skillIdle = activtiyNinja.skillCongest != 0;
			
			if(activtiyNinja.skillInfo.hasSkillIndex)
			{
				activityHero.useSpecialSkill = true;
				activityHero.useSpecialSkillIndex = activtiyNinja.skillInfo.skillIndex;
			}
			
			if(activityHero.hpChangedInfo != null && activityHero.hpChangedInfo.hp <= 0)
			{
				activityHero.isDead = true;
			}
			
			return activityHero;
		}
		
		/**
		 * 根据 ProtoNinja skillId 手动创建 ActivityHero
		 * @param protoNinja
		 * @param skillId
		 * @return 
		 * 
		 */		
		public static function createActivityNinja(protoNinja:ProtoNinja, skillId:int):ActivityHero
		{
			var activityHero:ActivityHero;
			var hpChangedInfo:HpChangedInfo;
			var baseChangedInfo:BaseChangedInfo;
			
			activityHero = new ActivityHero();
			activityHero.pos = protoNinja.pos;
			activityHero.skillId = skillId;
			
			hpChangedInfo = new HpChangedInfo();
			hpChangedInfo.hp = protoNinja.hp;
			
			baseChangedInfo = new BaseChangedInfo();
			baseChangedInfo.type = BaseChangedInfo.BLOOD;
			baseChangedInfo.value = hpChangedInfo.hp;
			hpChangedInfo.baseChangedInfoList = [baseChangedInfo];
			
			activityHero.hpChangedInfo = hpChangedInfo;
			if(activityHero.hpChangedInfo.hp <= 0)
			{
				activityHero.isDead = true;
			}
			
			return activityHero;
		}
		
		/**
		 * 根据 ProtoNinja 手动创建 PassiveHero
		 * @param protoNinja
		 * @param skillId
		 * @return 
		 * 
		 */		
		public static function createPassiveNinja(protoNinja:ProtoNinja):PassiveHero
		{
			var passiveHero:PassiveHero;
			var hpChangedInfo:HpChangedInfo;
			var baseChangedInfo:BaseChangedInfo;
			
			passiveHero = new PassiveHero();
			passiveHero.pos = protoNinja.pos;
			
			passiveHero.behitStatus = 1;
			passiveHero.behitEffect = 1;
			passiveHero.behitResult = 1;
			passiveHero.isMajor = true;
			
			hpChangedInfo = new HpChangedInfo();
			hpChangedInfo.hp = protoNinja.hp;
			
			baseChangedInfo = new BaseChangedInfo();
			baseChangedInfo.type = BaseChangedInfo.BLOOD;
			baseChangedInfo.value = hpChangedInfo.hp;
			hpChangedInfo.baseChangedInfoList = [baseChangedInfo];
			
			passiveHero.hpChangedInfo = hpChangedInfo;
			
			
			if(passiveHero.hpChangedInfo.hp <= 0)
			{
				passiveHero.isDead = true;
			}
			
			return passiveHero;
		}
		
		/**
		 *解析受击忍者 
		 * @param protoPassiveNinjas
		 * @return 
		 * 
		 */		
		public static function convertPassiveNinjas(protoPassiveNinjas:Array, normalAction:ProtoNormalAction):Array
		{
			var passiveHero:PassiveHero;
			var PassiveHeros:Array = new Array();
			for each (var protoPassiveNinjaInfo:ProtoPassiveNinjaInfo in protoPassiveNinjas)
			{
				passiveHero = new PassiveHero();
				passiveHero.pos = protoPassiveNinjaInfo.passiveNinjaPos;
				
				passiveHero.isCritical = protoPassiveNinjaInfo.isCritical;
				passiveHero.behitStatus = protoPassiveNinjaInfo.attackStatus;
				passiveHero.behitEffect = protoPassiveNinjaInfo.attackEffect;
				passiveHero.behitResult = protoPassiveNinjaInfo.attackResult;
				passiveHero.isDodge = protoPassiveNinjaInfo.isDodge == 1;
				passiveHero.dodgeId = protoPassiveNinjaInfo.dodgeId;
				passiveHero.isMajor = protoPassiveNinjaInfo.isMajor != 0;
				passiveHero.time = protoPassiveNinjaInfo.time;
				passiveHero.hasSkillIdle = protoPassiveNinjaInfo.hasSkillCongest;
				passiveHero.skillIdle = protoPassiveNinjaInfo.skillCongest != 0;
				
				passiveHero.hpChangedInfo = convertNinjaBaseChangedInfo(passiveHero.pos, normalAction.ninjaHpChange, normalAction.teamKathaChange);
				passiveHero.attributeChangedInfo = convertNinjaAttributeChangedInfo(passiveHero.pos, normalAction.ninjaHpChange);
				
				if(passiveHero.hpChangedInfo != null && passiveHero.hpChangedInfo.hp <= 0)
				{
					passiveHero.isDead = true;
				}
				
				PassiveHeros.push(passiveHero);
			}
			return PassiveHeros;
		}
		
		/**
		 *解析分身忍者数据 
		 * @param cahootNinja
		 * @return 
		 * 
		 */		
		public static function convertCahootNinja(cahootNinja:ProtoActiveNinjaInfo):ActivityHero
		{
			var activityHero:ActivityHero;
			
			activityHero = new ActivityHero();
			activityHero.pos = cahootNinja.activeNinjaPos;
			activityHero.skillId = cahootNinja.skillInfo.skillId;
			activityHero.hold = false;
			activityHero.realPassiveBeHit = false;
			activityHero.hasSkillIdle = cahootNinja.hasSkillCongest;
			activityHero.skillIdle = cahootNinja.skillCongest != 0;
			
			return activityHero;
		}
		
		/**
		 * 解析结界忍者数据 
		 * @param activtiyNinja
		 * @return 
		 * 
		 */		
		public static function convertEnchantmentNinja(activtiyNinja:ProtoActiveNinjaInfo):ActivityHero
		{
			var activityHero:ActivityHero;
			
			activityHero = new ActivityHero();
			activityHero.pos = activtiyNinja.activeNinjaPos;
			activityHero.skillId = activtiyNinja.skillInfo.skillId;
			activityHero.totalAttackTimes = activtiyNinja.totalAttackTimes;
			activityHero.hitNum = activtiyNinja.hitNum;
			activityHero.hasSkillIdle = activtiyNinja.hasSkillCongest;
			activityHero.skillIdle = activtiyNinja.skillCongest != 0; 
			
			if(activtiyNinja.skillInfo.hasSkillIndex)
			{
				activityHero.useSpecialSkill = true;
				activityHero.useSpecialSkillIndex = activtiyNinja.skillInfo.skillIndex;
			}
			
			return activityHero;
		}
		
		/**
		 *解析忍者信息 
		 * @return 
		 * 
		 */		
		public static function convertNinjaInfos(teamId:int, arenaLevel:int, ninjas:Array, name:String, controlTeam:int = -1):Array
		{
			var skillInfo:SkillInfo;
			var ninjaInfo:NinjaInfo;
			var protoBuffInfo:ProtoBuffInfo;
			var skillStates:SkillStatuInfo;
			var ninjaInfoArr:Array = new Array();
			
			for each (var protoNinja:ProtoNinja in ninjas)
			{
				ninjaInfo = new NinjaInfo();
				
				ninjaInfo.pos = protoNinja.pos;
				ninjaInfo.ninjaId = protoNinja.id;
				ninjaInfo.hp = protoNinja.hp;
				ninjaInfo.maxHP = protoNinja.maxHp;
				ninjaInfo.skillList = protoNinja.skillList;
				ninjaInfo.isCall = protoNinja.isCall;
				ninjaInfo.level = protoNinja.level;
				ninjaInfo.controlTeam = controlTeam;
				ninjaInfo.teamId = teamId;
				if(UIData.singleton.self){ninjaInfo.selfTeam = UIData.singleton.self.teamId == teamId;}
				
				if(MajorNinjaDef.isMajorNinjaId(ninjaInfo.ninjaId))
				{
					if(UIData.singleton.isOurPlayerPos(teamId) == true)
					{
						ninjaInfo.name = name;
					}
					else if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_INFERIOR)
					{
						ninjaInfo.name = MajorNinjaDef.getMajorNinjaName(ninjaInfo.ninjaId);
					}
					else if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_BATTLE_ROYALE)
					{
						ninjaInfo.name = MajorNinjaDef.getMajorNinjaName(ninjaInfo.ninjaId);
					}
					else
					{
						ninjaInfo.name = name;
					}
				}
				
				if(BattleData.singleton.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION)
				{
					ninjaInfo.enterStageAction = StageNinjaActionType.ENTER_VANISH;
				}
				else
				{
					ninjaInfo.enterStageAction = StageNinjaActionType.ENTER_NORMAL;
				}
				
				if(protoNinja.hasStageNinjaActionType)
				{
					ninjaInfo.exeuntStageAction = exeuntStageActionTransfrom(protoNinja.stageNinjaActionType);
				}
				
				ninjaInfo.isDisplayName = protoNinja.isDisplayName;
				ninjaInfo.teamId = teamId;
				ninjaInfo.playerId = teamId;
				if(protoNinja.hasShortKeyIndex)
				{
					ninjaInfo.skillIndex = protoNinja.shortKeyIndex;
				}
				
				for each(protoBuffInfo in protoNinja.buffs)
				{
					var buffInfo:BuffInfo;
					
					if(ShieldConfig.isShieldBuff(protoBuffInfo.buffId) == true)
					{
						continue ;
					}
					
					buffInfo = new BuffInfo();
					buffInfo.buffId = protoBuffInfo.buffId;
					buffInfo.group = protoBuffInfo.buffGroup;
					buffInfo.overlay = protoBuffInfo.buffOverlay;
					buffInfo.maxHp = protoBuffInfo.buffArg1;
					buffInfo.protectHp = protoBuffInfo.buffArg2;
					ninjaInfo.enterBuffList.push(buffInfo);
				}
				
				for each(protoBuffInfo in protoNinja.buffs)
				{
					var shield:ShieldInfo;
					
					if(ShieldConfig.isShieldBuff(protoBuffInfo.buffId) == false)
					{
						continue ;
					}
					
					shield = new ShieldInfo();
					shield.id = protoBuffInfo.buffId;
					shield.pos = ninjaInfo.pos;
					shield.hp = protoBuffInfo.buffArg2;
					shield.maxHp = protoBuffInfo.buffArg1;
					shield.cfg = ShieldConfig.getShieldInfoCfgById(protoBuffInfo.buffId);
					ninjaInfo.enterShield = shield;
					break;
				}
				
				for each(var states:ProtoSkillState in protoNinja.skillState)
				{
					skillStates = new SkillStatuInfo();
					skillStates.canUseSkill = states.canUseSkill;
					skillStates.cdRound = states.cdRound;
					skillStates.pos = ninjaInfo.pos;
					skillStates.skillId = states.skillId;
					skillStates.skillIndex = states.skillIndex;
					skillStates.skillProhibitType = states.skillProhibitType;
					if(states.switchSkillId != 0)
					{
						skillStates.skillId = states.switchSkillId;
					}
					ninjaInfo.skillStates.push(skillStates);
				}
				
				for each(var skillId:int in protoNinja.skillList)
				{
					skillInfo = SkillConfig.getSkillInfo(skillId);
					if(skillInfo.type == SkillDef.TYPE_PASSIVE)
					{
						var logicEffectInfo:LogicEffectInfo;
						
						logicEffectInfo = new LogicEffectInfo();
						logicEffectInfo.id = skillId;
						logicEffectInfo.skillId = skillId;
						logicEffectInfo.cfg = PassiveEffectConfig.getSkillLogicEffectCfg(skillId);
						ninjaInfo.logicEffectList.push(logicEffectInfo);
					}
				}
				
				ninjaInfoArr.push(ninjaInfo);
			}
			return ninjaInfoArr;
		}
		
		private static function exeuntStageActionTransfrom(actionType:int):int
		{
			if(actionType == StageActionType.SUMMON_ENTER_STAGE)
			{
				return StageNinjaActionType.DEAD_SMOKE;
			}
			
			return actionType;
		}
		
		public static function settingExeuntStageAction(ninjas:Array, protoPlayerTeamPos:ProtoPlayerTeamPos = null):void
		{
			var battleStanceCfg:BattleStanceCfg;
			
			for each(var ninjaInfo:NinjaInfo in ninjas)
			{
				if(ninjaInfo.exeuntStageAction != -1)
				{
					continue ;
				}
				
				if(ninjaInfo.isCall)
				{
					ninjaInfo.exeuntStageAction = StageNinjaActionType.EXIT_SMOKE;
					continue ;
				}
				
				if(protoPlayerTeamPos && protoPlayerTeamPos.hasStanceId)
				{
					battleStanceCfg = BattleStanceConfig.getNinjaBattleStanceCfg(protoPlayerTeamPos.stanceId, protoPlayerTeamPos.teamId, ninjaInfo.pos);
					
					if(battleStanceCfg == null)
					{
						throw new Error(I18n.lang("as_battle_1451031565_350_0") + protoPlayerTeamPos.player.uin + I18n.lang("as_battle_1451031565_350_1"));
					}
					
					if(battleStanceCfg.exeuntStageAction != -1)
					{
						ninjaInfo.exeuntStageAction = battleStanceCfg.exeuntStageAction;
						continue ;
					}
				}
				
				ninjaInfo.exeuntStageAction = StageNinjaActionType.EXIT_JUMP;
			}
		}
		
		public static function convertContractPetNinjaInfo(contractPet:int):NinjaInfo
		{
			var ninjaInfo:NinjaInfo;
			var ninjaSkillConfig:NinjaSkillConfig;
			var ninjaSkillCfg:NinjaSkillCFG;
			var getNinjaSkillConfigCommand:GetNinjaSkillConfigSkillCommnad;
			
			if(contractPet == 0)
			{
				return null;
			}
			
			getNinjaSkillConfigCommand = new GetNinjaSkillConfigSkillCommnad();
			getNinjaSkillConfigCommand.call();
			ninjaSkillConfig = getNinjaSkillConfigCommand.ninjaSkillConfig;
			ninjaSkillCfg = ninjaSkillConfig.getNinjaSkillCfg(contractPet);
			
			if(ninjaSkillCfg == null)
			{
				return null;
			}
			
			ninjaInfo = new NinjaInfo();
			ninjaInfo.ninjaId = contractPet;
			ninjaInfo.skillList = ninjaInfo.skillList.concat(ninjaSkillCfg.normals);
			ninjaInfo.skillList = ninjaInfo.skillList.concat(ninjaSkillCfg.skills);
			ninjaInfo.skillList = ninjaInfo.skillList.concat(ninjaSkillCfg.specials);
			ninjaInfo.skillList = ninjaInfo.skillList.concat(ninjaSkillCfg.binding);
			
			return ninjaInfo;
		}
		
		/**
		 *解析技能变更列表 
		 * @param protoSkillStatus
		 * @return
		 * 
		 */
		public static function convertSkillStatus(protoTeamInfo:Array):Array
		{
			var skillStatus:Array;
			var skillStatusInfo:SkillStatuInfo;
			
			skillStatus = [];
			for each(var teamInfo:ProtoTeamInfo in protoTeamInfo)
			{
				for each(var protoNinjaInfo:ProtoNinja in teamInfo.ninja)
				{
					for each(var protoSkillState:ProtoSkillState in protoNinjaInfo.skillState)
					{
						skillStatusInfo = new SkillStatuInfo();
						skillStatusInfo.pos = protoNinjaInfo.pos;
						skillStatusInfo.skillIndex = protoSkillState.skillIndex;
						skillStatusInfo.skillId = protoSkillState.skillId;
						skillStatusInfo.canUseSkill = protoSkillState.canUseSkill;
						skillStatusInfo.cdRound = protoSkillState.cdRound;
						skillStatusInfo.skillProhibitType = protoSkillState.skillProhibitType;
						if(protoSkillState.switchSkillId != 0)
						{
							skillStatusInfo.skillId = protoSkillState.switchSkillId;
						}
						skillStatus.push(skillStatusInfo);
					}
				}
			}
			
			return skillStatus;
		}
		
		/**
		 *解析技能取消列表 
		 * @return 
		 * 
		 */		
		public static function convertAbortNinjaAwakenSkill(protoAbortNinjaAwakenSkillList:Array):Array
		{
			var abortNinjaAwakenSkillList:Array = [];
			
			for each(var abortNinjaAwakenSkill:ProtoAbortNinjaAwakenSkill in protoAbortNinjaAwakenSkillList)
			{
				abortNinjaAwakenSkillList.push(abortNinjaAwakenSkill.ninjaPos);
			}
			
			return abortNinjaAwakenSkillList;
		}
		
		/**
		 *查克拉变更详情 
		 * @return 
		 * 
		 */		
		public static function convertKathaChangeNotify(teamKathaChange:Array):Array
		{
			var katalChangedList:Array = [];
			var katalChangedInfo:KathaChangedInfo;
			
			for each(var protoKatalInfo:ProtoTeamKathaChange in teamKathaChange)
			{
				katalChangedInfo = new KathaChangedInfo();
				katalChangedInfo.teamId = protoKatalInfo.teamId;
				katalChangedInfo.value = protoKatalInfo.kathaChange;
				katalChangedInfo.pos = protoKatalInfo.ninjaPos;
				katalChangedList.push(katalChangedInfo);
			}
			
			return katalChangedList;
		}
		
		public static function convertKathaChange(teamKathaChange:Array):Array
		{
			var katalChangedList:Array = [];
			var katalChangedInfo:KathaChangedInfo;
			
			for each(var protoKatalInfo:ProtoTeamKathaChange in teamKathaChange)
			{
				katalChangedInfo = new KathaChangedInfo();
				katalChangedInfo.teamId = protoKatalInfo.teamId;
				katalChangedInfo.value = protoKatalInfo.kathaChange;
				katalChangedInfo.pos = protoKatalInfo.ninjaPos;
				katalChangedList.push(katalChangedInfo);
			}
			
			return katalChangedList;
		}
		
		public static function convertKathaChangeByNormalAction(teamKathaChange:Array, normalAction:ProtoNormalAction, passiveHeros:Array):Array
		{
			var katalChangedList:Array = [];
			var katalChangedInfo:KathaChangedInfo;
			
			for each(var protoKatalInfo:ProtoTeamKathaChange in teamKathaChange)
			{
				if(isActivityNinjaPos(protoKatalInfo.ninjaPos, normalAction.activeNinja.activeNinjaPos))
				{
					continue ;
				}
				
				if(isPassiveNinjaPos(protoKatalInfo.ninjaPos, passiveHeros))
				{
					continue ;
				}
				
				katalChangedInfo = new KathaChangedInfo();
				katalChangedInfo.teamId = protoKatalInfo.teamId;
				katalChangedInfo.value = protoKatalInfo.kathaChange;
				katalChangedInfo.pos = protoKatalInfo.ninjaPos;
				katalChangedList.push(katalChangedInfo);
			}
			
			return katalChangedList;
		}
		
		public static function convertKathaChangeByPos(pos:int, teamKathaChange:Array):KathaChangedInfo
		{
			var katalChangedList:Array = [];
			var katalChangedInfo:KathaChangedInfo;
			
			for each(var protoKatalInfo:ProtoTeamKathaChange in teamKathaChange)
			{
				if(protoKatalInfo.ninjaPos == pos)
				{
					katalChangedInfo = new KathaChangedInfo();
					katalChangedInfo.teamId = protoKatalInfo.teamId;
					katalChangedInfo.value = protoKatalInfo.kathaChange;
					katalChangedInfo.pos = protoKatalInfo.ninjaPos;
					break;
				}
			}
			
			return katalChangedInfo;
		}
		
		private static function getKathaChangeInfoByPos(ninjaPos:int, normalAction:ProtoNormalAction):BaseChangedInfo
		{
			var baseChangeInfo:BaseChangedInfo;
			var ninjaBaseChangedList:Array = [];
			
			for each(var protoTeamKathaChange:ProtoTeamKathaChange in normalAction.teamKathaChange)
			{
				if(ninjaPos == protoTeamKathaChange.ninjaPos)
				{
					baseChangeInfo = new BaseChangedInfo();
					baseChangeInfo.value = protoTeamKathaChange.kathaChange;
					baseChangeInfo.type = BaseChangedInfo.MP;
					break;
				}
			}
			
			return baseChangeInfo;
		}
		
		public static function getTotalNinjaHp(ninjaList:Array):int
		{
			var hp:int;
			
			for each (var protoNinja:ProtoNinja in ninjaList)
			{
				hp += protoNinja.hp;
			}
			return hp;
		}
		
		public static function getStageNinjaIdList(ninjaList:Array):Array
		{
			var ninjaIdList:Array = [];
			for each (var protoNinja:ProtoNinja in ninjaList)
			{
				ninjaIdList.push(protoNinja.id);
			}
			
			return ninjaIdList;
		}
		
		/**
		 *仅提供id 和 pos  
		 * @return 
		 * 
		 */		
		public static function getBaseNinjaInfoList(ninjaList:Array):Array
		{
			var baseNinjaInfoList:Array = [];
			
			var ninjaInfo:NinjaInfo;
			for each (var protoNinja:ProtoNinja in ninjaList)
			{
				ninjaInfo = new NinjaInfo();
				ninjaInfo.ninjaId = protoNinja.id;
				ninjaInfo.pos = protoNinja.pos;
				baseNinjaInfoList.push(ninjaInfo);
			}
			
			return baseNinjaInfoList;
		}
		
		public static function getTotalNinjaMaxHp(ninjaList:Array):int
		{
			var maxHp:int;
			
			for each (var protoNinja:ProtoNinja in ninjaList)
			{
				maxHp += protoNinja.hp;
			}
			return maxHp;
		}
		
		public static function convertEnchantBaseCHnagedInfo(ninjaHpChange:Array):Array
		{
			var hpChangedInfo:HpChangedInfo;
			var hpChangedInfoList:Array;
			var ninjaBaseChangedList:Array;
			
			hpChangedInfoList = [];
			for each(var protoNinjaHpChanged:ProtoNinjaHpChange in ninjaHpChange)
			{
				ninjaBaseChangedList = [];
				for each(var protoHpChanged:ProtoHpChangeDescribe in protoNinjaHpChanged.hpChangeDescribe)
				{
					ninjaBaseChangedList.push(protoHpChanged);
				}
				
				hpChangedInfo = new HpChangedInfo();
				hpChangedInfo.hp = protoNinjaHpChanged.hp;
				hpChangedInfo.pos = protoNinjaHpChanged.ninjaPos;
				if(protoNinjaHpChanged.hasMoney){hpChangedInfo.money = getMoneyChangedValue(protoNinjaHpChanged.money);}
				hpChangedInfo.baseChangedInfoList = convertBaseChangedList(ninjaBaseChangedList);
				hpChangedInfoList.push(hpChangedInfo);
			}
			
			return hpChangedInfoList;
		}
		
		public static function convertNinjaBaseChangedInfo(ninjaPos:int, ninjaHpChange:Array, teamKathaChange:Array = null, ninjaHintInfos:Array = null):HpChangedInfo
		{
			var hpChangedInfo:HpChangedInfo;
			var ninjaBaseChangedList:Array = [];
			var kathaChangeInfo:BaseChangedInfo;
			
			for each(var protoNinjaHpChanged:ProtoNinjaHpChange in ninjaHpChange)
			{
				if(ninjaPos == protoNinjaHpChanged.ninjaPos)
				{
					for each(var protoHpChanged:ProtoHpChangeDescribe in protoNinjaHpChanged.hpChangeDescribe)
					{
						ninjaBaseChangedList.push(protoHpChanged);
					}
					
					hpChangedInfo = new HpChangedInfo();
					hpChangedInfo.hp = protoNinjaHpChanged.hp;
					hpChangedInfo.pos = protoNinjaHpChanged.ninjaPos;
					if(protoNinjaHpChanged.hasMoney){hpChangedInfo.money = getMoneyChangedValue(protoNinjaHpChanged.money);}
					hpChangedInfo.baseChangedInfoList = convertBaseChangedList(ninjaBaseChangedList);
					hpChangedInfo.baseChangedInfoList = hpChangedInfo.baseChangedInfoList.concat(convertHitInfoBaseInfoListByPos(ninjaHintInfos, ninjaPos));
					break;
				}
			}
			
			if(hpChangedInfo && teamKathaChange)
			{
				for each(var protoTeamKathaChange:ProtoTeamKathaChange in teamKathaChange)
				{
					if(ninjaPos == protoTeamKathaChange.ninjaPos)
					{
						kathaChangeInfo = new BaseChangedInfo();
						kathaChangeInfo.type = BaseChangedInfo.MP;
						kathaChangeInfo.value = -protoTeamKathaChange.kathaChange;
						hpChangedInfo.baseChangedInfoList.push(kathaChangeInfo);
					}
				}
			}
			
			return hpChangedInfo;
		}
		
		private static function getMoneyChangedValue(money:int):int
		{
			var changedValue:int;
			
			if(MessageRecoData.singleton.money == -1)
			{
				changedValue = money;
			}
			else
			{
				changedValue = money - MessageRecoData.singleton.money;
			}
			
			MessageRecoData.singleton.money = money;
			
			trace("money", "changed", changedValue, "current", MessageRecoData.singleton.money);
			return changedValue;
		}
		
		//		private static function convertNinjaBaseChangedInfo(ninjaPos:int, normalAction:ProtoNormalAction):HpChangedInfo
		//		{
		//			var hpChangedInfo:HpChangedInfo;
		//			var ninjaBaseChangedList:Array = [];
		//			var kathaChangeInfo:BaseChangedInfo;
		//			
		//			for each(var protoNinjaHpChanged:ProtoNinjaHpChange in normalAction.ninjaHpChange)
		//			{
		//				if(ninjaPos == protoNinjaHpChanged.ninjaPos)
		//				{
		//					for each(var protoHpChanged:ProtoHpChangeDescribe in protoNinjaHpChanged.hpChangeDescribe)
		//					{
		//						ninjaBaseChangedList.push(protoHpChanged);
		//					}
		//					
		//					hpChangedInfo = new HpChangedInfo();
		//					hpChangedInfo.hp = protoNinjaHpChanged.hp;
		//					hpChangedInfo.pos = protoNinjaHpChanged.ninjaPos;
		//					hpChangedInfo.baseChangedInfoList = convertBaseChangedList(ninjaBaseChangedList);
		//					break;
		//				}
		//			}
		//			
		//			if(hpChangedInfo)
		//			{
		//				for each(var protoTeamKathaChange:ProtoTeamKathaChange in normalAction.teamKathaChange)
		//				{
		//					if(ninjaPos == protoTeamKathaChange.ninjaPos)
		//					{
		//						kathaChangeInfo = new BaseChangedInfo();
		//						kathaChangeInfo.type = BaseChangedInfo.MP;
		//						kathaChangeInfo.value = -protoTeamKathaChange.kathaChange;
		//						hpChangedInfo.baseChangedInfoList.push(kathaChangeInfo);
		//					}
		//				}
		//			}
		//			
		//			
		//			return hpChangedInfo;
		//		}
		
		public static function getNormalActionPassiveHerosPos(normatlAction:ProtoNormalAction):Array
		{
			var passiveHerosPos:Array;
			
			passiveHerosPos = [];
			for each(var passiveHero:ProtoPassiveNinjaInfo in normatlAction.passiveNinja)
			{
				passiveHerosPos.push(passiveHero.passiveNinjaPos);
			}
			
			return passiveHerosPos;
		}
		
		public static function getCallUpActionPasssiveHerosPos(stageInfo:ProtoStageInfo):Array
		{
			var passiveHerosPos:Array;
			
			passiveHerosPos = [];
			for each(var passiveHero:ProtoNinja in stageInfo.ninja)
			{
				passiveHerosPos.push(passiveHero.pos);
			}
			
			return passiveHerosPos;
		}
		
		public static function getRebirthHerosPos(rebirthAction:ProtoRebirthAction):Array
		{
			var passiveHerosPos:Array;
			
			passiveHerosPos = [];
			
			switch(rebirthAction.rebirthType)
			{
				case 1:
				case 3:
					passiveHerosPos.push(rebirthAction.rebirthNinja.pos);
					break;
				case 2:
					passiveHerosPos.push(rebirthAction.killNinja.pos);
					break;
			}
			
			return passiveHerosPos;
		}
		
		public static function getTransformPasssiveHerosPos(transformAction:ProtoTransformAction):Array
		{
			var passiveHerosPos:Array;
			
			passiveHerosPos = [];
			passiveHerosPos.push(transformAction.transformNinja.pos);
			
			return passiveHerosPos;
		}
		
		public static function getEmptyPassiveHerosPos():Array
		{
			return [];
		}
		
		public static function convertOtherNinjaBaseChangedInfoList(activePos:int, ninjaHpChange:Array, passiveHerosPos:Array, ninjaHintInfos:Array = null):Array
		{
			var ninjaHpChangedList:Array = [];
			var ninjaHpChangedInfoList:Array = [];
			var hpChangedInfo:HpChangedInfo;
			var ninjaHitInfo:ProtoNinjaHintInfo;
			
			for each(var protoNinjaHpChanged:ProtoNinjaHpChange in ninjaHpChange)
			{
				if(isActivityNinjaPos(protoNinjaHpChanged.ninjaPos, activePos))
				{
					continue ;
				}
				
				if(isPassiveNinjaPos(protoNinjaHpChanged.ninjaPos, passiveHerosPos))
				{
					continue ;
				}
				
				ninjaHpChangedList = [];
				for each(var protoHpChanged:ProtoHpChangeDescribe in protoNinjaHpChanged.hpChangeDescribe)
				{
					ninjaHpChangedList.push(protoHpChanged);
				}
				hpChangedInfo = new HpChangedInfo();
				hpChangedInfo.pos = protoNinjaHpChanged.ninjaPos;
				hpChangedInfo.hp = protoNinjaHpChanged.hp;
				if(protoNinjaHpChanged.hasMoney){hpChangedInfo.money = getMoneyChangedValue(protoNinjaHpChanged.money);}
				hpChangedInfo.baseChangedInfoList = convertBaseChangedList(protoNinjaHpChanged.hpChangeDescribe);
				
				ninjaHpChangedInfoList.push(hpChangedInfo);
			}
			
			
			if(ninjaHintInfos != null)
			{
				for(var i:int = 0;i < ninjaHintInfos.length;i ++)
				{
					ninjaHitInfo = ninjaHintInfos[i];
					
					ninjaHpChangedList = convertHitInfoBaseInfoList(ninjaHitInfo.hintInfo);
					if(ninjaHpChangedList.length == 0){continue ;}
					
					hpChangedInfo = null;
					for each(var matchHpChangedInfo:HpChangedInfo in ninjaHpChangedInfoList)
					{
						if(matchHpChangedInfo.pos == ninjaHitInfo.pos)
						{
							hpChangedInfo = matchHpChangedInfo;
						}
					}
					
					if(hpChangedInfo == null)
					{
						throw new Error(I18n.lang("as_battle_1451031565_351"));
					}
					
					hpChangedInfo.baseChangedInfoList = hpChangedInfo.baseChangedInfoList.concat(ninjaHpChangedList);
					if(ninjaHitInfo.hintInfo.length == 0)
					{
						ninjaHintInfos.splice(i, 1);
						i --;
					}
				}
			}
			
			return ninjaHpChangedInfoList;
		}
		
		public static function convertNinjaAttributeChangedInfo(ninjaPos:int, ninjaHpChange:Array, ninjaHintInfos:Array = null):AttributeChangedInfo
		{
			var attributeChangedInfo:AttributeChangedInfo;
			var ninjaAttributeChangedList:Array = [];
			
			for each(var protoNinjaHpChanged:ProtoNinjaHpChange in ninjaHpChange)
			{
				if(ninjaPos == protoNinjaHpChanged.ninjaPos)
				{
					for each(var protoHpChanged:ProtoHpChangeDescribe in protoNinjaHpChanged.hpChangeDescribe)
					{
						ninjaAttributeChangedList.push(protoHpChanged);
					}
					attributeChangedInfo = new AttributeChangedInfo();
					attributeChangedInfo.pos = protoNinjaHpChanged.ninjaPos;
					attributeChangedInfo.baseChangedInfoList = convertAttributeChangedList(ninjaAttributeChangedList);
					break;
				}
			}
			
			for each(var ninjaHitInfo:ProtoNinjaHintInfo in ninjaHintInfos)
			{
				if(ninjaPos == ninjaHitInfo.pos)
				{
					ninjaAttributeChangedList = convertHitInfoAttributeListByPos(ninjaHintInfos, ninjaPos);
					if(ninjaAttributeChangedList.length != 0)
					{
						if(attributeChangedInfo == null)
						{
							attributeChangedInfo = new AttributeChangedInfo();
							attributeChangedInfo.pos = ninjaHitInfo.pos;
						}
						
						attributeChangedInfo.baseChangedInfoList = attributeChangedInfo.baseChangedInfoList.concat(ninjaAttributeChangedList);
						break;
					}
				}
			}
			
			return attributeChangedInfo;
		}
		
		public static function convertOtherNinjaAttributeChangedInfoList(activePos:int, ninjaHpChange:Array, passiveHeros:Array, ninjaHintInfos:Array = null):Array
		{
			var attributeChangedInfo:AttributeChangedInfo;
			var ninjaAttributeChangedList:Array = [];
			var ninjaAttributeChangedInfoList:Array = [];
			
			for each(var protoNinjaHpChanged:ProtoNinjaHpChange in ninjaHpChange)
			{
				if(isActivityNinjaPos(protoNinjaHpChanged.ninjaPos, activePos))
				{
					continue ;
				}
				
				if(isPassiveNinjaPos(protoNinjaHpChanged.ninjaPos, passiveHeros))
				{
					continue ;
				}
				
				ninjaAttributeChangedList = [];
				for each(var protoHpChanged:ProtoHpChangeDescribe in protoNinjaHpChanged.hpChangeDescribe)
				{
					ninjaAttributeChangedList.push(protoHpChanged);
					
					attributeChangedInfo = new AttributeChangedInfo();
					attributeChangedInfo.pos = protoNinjaHpChanged.ninjaPos;
					attributeChangedInfo.baseChangedInfoList = convertAttributeChangedList(ninjaAttributeChangedList);
					
					ninjaAttributeChangedInfoList.push(attributeChangedInfo);
				}
			}
			
			var protoNinjaHitInfo:ProtoNinjaHintInfo;
			if(ninjaHintInfos != null)
			{
				for(var i:int = 0;i < ninjaHintInfos.length;i ++)
				{
					protoNinjaHitInfo = ninjaHintInfos[i];
					
					attributeChangedInfo = null;
					for each(var matchAttributeChangedInfo:AttributeChangedInfo in ninjaAttributeChangedInfoList)
					{
						if(matchAttributeChangedInfo.pos == protoNinjaHitInfo.pos)
						{
							attributeChangedInfo = matchAttributeChangedInfo;
						}
					}
					
					if(attributeChangedInfo == null)
					{
						attributeChangedInfo = new AttributeChangedInfo();
						attributeChangedInfo.pos = protoNinjaHitInfo.pos;
						ninjaAttributeChangedInfoList.push(attributeChangedInfo);
					}
					
					attributeChangedInfo.baseChangedInfoList = convertHitInfoAttributeList(protoNinjaHitInfo.hintInfo);
					if(protoNinjaHitInfo.hintInfo.length == 0)
					{
						ninjaHintInfos.splice(i, 1);
						i --;
					}
				}
			}
			
			return ninjaAttributeChangedInfoList;
		}
		
		private static function isActivityNinjaPos(pos:int, activePos:int):Boolean
		{
			return pos == activePos;
		}
		
		private static function isPassiveNinjaPos(pos:int, passiveHeros:Array):Boolean
		{
			for each(var thePos:int in passiveHeros)
			{
				if(pos == thePos)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private static function convertBaseChangedList(protoAttributeChangedList:Array):Array
		{
			var hpChangedList:Array = [];
			var hpChangedInfo:BaseChangedInfo;
			for each (var protoAttributeChanged:ProtoHpChangeDescribe in protoAttributeChangedList)
			{
				if(protoAttributeChanged.hintType != BaseChangedInfo.BLOOD && 
					protoAttributeChanged.hintType != BaseChangedInfo.ALLELOPATHY &&
					protoAttributeChanged.hintType != BaseChangedInfo.RESTRAIN_WATER_TO_FIRE &&
					protoAttributeChanged.hintType != BaseChangedInfo.RESTRAIN_FIRE_TO_WIND &&
					protoAttributeChanged.hintType != BaseChangedInfo.RESTRAIN_WIND_TO_THUNDER &&
					protoAttributeChanged.hintType != BaseChangedInfo.RESTRAIN_THUNDER_TO_EARTH &&
					protoAttributeChanged.hintType != BaseChangedInfo.RESTRAIN_EARTH_TO_WATER &&
					protoAttributeChanged.hintType != BaseChangedInfo.IGNITE &&
					protoAttributeChanged.hintType != BaseChangedInfo.POISON && 
					protoAttributeChanged.hintType != BaseChangedInfo.STEAL_HP && 
					protoAttributeChanged.hintType != BaseChangedInfo.PRISON &&
					protoAttributeChanged.hintType != BaseChangedInfo.DAMAGE_FROM_OTHER)
				{
					continue ;
				}
				
				hpChangedInfo = new BaseChangedInfo();
				hpChangedInfo.type = protoAttributeChanged.hintType;
				hpChangedInfo.value = protoAttributeChanged.hpChange;
				hpChangedList.push(hpChangedInfo);
			}
			
			return hpChangedList;
		}
		
		private static function convertHitInfoAttributeListByPos(protoNinjaHitInfoList:Array, pos:int):Array
		{
			var hitInfo:ProtoHintInfo;
			var protoNinjaHitInfo:ProtoNinjaHintInfo;
			var attributeChangedList:Array = [];
			var attributeChanged:BaseChangedInfo;
			
			if(protoNinjaHitInfoList == null){return attributeChangedList}
			
			for(var i:int = 0;i <  protoNinjaHitInfoList.length;i ++)
			{
				protoNinjaHitInfo = protoNinjaHitInfoList[i];
				if(protoNinjaHitInfo.pos == pos)
				{
					for(var j:int = 0;j < protoNinjaHitInfo.hintInfo.length;j ++)
					{
						hitInfo = protoNinjaHitInfo.hintInfo[j];
						if(hitInfo.type == BaseChangedInfo.BLOOD || 
							hitInfo.type == BaseChangedInfo.ALLELOPATHY ||
							hitInfo.type == BaseChangedInfo.RESTRAIN_WATER_TO_FIRE ||
							hitInfo.type == BaseChangedInfo.RESTRAIN_FIRE_TO_WIND ||
							hitInfo.type == BaseChangedInfo.RESTRAIN_WIND_TO_THUNDER ||
							hitInfo.type == BaseChangedInfo.RESTRAIN_THUNDER_TO_EARTH ||
							hitInfo.type == BaseChangedInfo.RESTRAIN_EARTH_TO_WATER ||
							hitInfo.type == BaseChangedInfo.IGNITE || 
							hitInfo.type == BaseChangedInfo.POISON ||
							hitInfo.type == BaseChangedInfo.STEAL_HP ||
							hitInfo.type == BaseChangedInfo.PRISON ||
							hitInfo.type == BaseChangedInfo.DAMAGE_FROM_OTHER)
						{
							continue ;
						}
						
						attributeChanged = new BaseChangedInfo();
						attributeChanged.type = hitInfo.type;
						attributeChanged.value = hitInfo.arg;
						attributeChangedList.push(attributeChanged);
						
						protoNinjaHitInfo.hintInfo.splice(j, 1);
						j --;
					}
					
					if(protoNinjaHitInfo.hintInfo.length == 0)
					{
						protoNinjaHitInfoList.splice(i, 1);
						i--;
					}
				}
			}
			
			return attributeChangedList;
		}
		
		private static function convertHitInfoAttributeList(hitInfos:Array):Array
		{
			var hitInfo:ProtoHintInfo;
			var attributeChangedList:Array = [];
			var attributeChanged:BaseChangedInfo;
			
			if(hitInfos == null){return attributeChangedList}
			
			for(var i:int = 0;i < hitInfos.length;i ++)
			{
				hitInfo = hitInfos[i];
				if(hitInfo.type == BaseChangedInfo.BLOOD || 
					hitInfo.type == BaseChangedInfo.ALLELOPATHY ||
					hitInfo.type == BaseChangedInfo.RESTRAIN_WATER_TO_FIRE ||
					hitInfo.type == BaseChangedInfo.RESTRAIN_FIRE_TO_WIND ||
					hitInfo.type == BaseChangedInfo.RESTRAIN_WIND_TO_THUNDER ||
					hitInfo.type == BaseChangedInfo.RESTRAIN_THUNDER_TO_EARTH ||
					hitInfo.type == BaseChangedInfo.RESTRAIN_EARTH_TO_WATER ||
					hitInfo.type == BaseChangedInfo.IGNITE || 
					hitInfo.type == BaseChangedInfo.POISON ||
					hitInfo.type == BaseChangedInfo.STEAL_HP ||
					hitInfo.type == BaseChangedInfo.PRISON ||
					hitInfo.type == BaseChangedInfo.DAMAGE_FROM_OTHER)
				{
					continue ;
				}
				
				attributeChanged = new BaseChangedInfo();
				attributeChanged.type = hitInfo.type;
				attributeChanged.value = hitInfo.arg;
				attributeChangedList.push(attributeChanged);
				
				hitInfos.splice(i, 1);
				i --;
			}
			return attributeChangedList;
		}
		
		private static function convertHitInfoBaseInfoListByPos(protoNinjaHitInfoList:Array, pos:int):Array
		{
			var hitInfo:ProtoHintInfo;
			var hpChangedList:Array = [];
			var hpChangedInfo:BaseChangedInfo;
			var protoNinjaHitInfo:ProtoNinjaHintInfo;
			
			if(protoNinjaHitInfoList == null){return hpChangedList}
			
			for(var i:int = 0;i <  protoNinjaHitInfoList.length;i ++)
			{
				protoNinjaHitInfo = protoNinjaHitInfoList[i];
				if(protoNinjaHitInfo.pos == pos)
				{
					for(var j:int = 0;j < protoNinjaHitInfo.hintInfo.length;j ++)
					{
						hitInfo = protoNinjaHitInfo.hintInfo[j];
						if(hitInfo.type != BaseChangedInfo.BLOOD && 
							hitInfo.type != BaseChangedInfo.ALLELOPATHY && 
							hitInfo.type != BaseChangedInfo.RESTRAIN_WATER_TO_FIRE &&
							hitInfo.type != BaseChangedInfo.RESTRAIN_FIRE_TO_WIND &&
							hitInfo.type != BaseChangedInfo.RESTRAIN_WIND_TO_THUNDER &&
							hitInfo.type != BaseChangedInfo.RESTRAIN_THUNDER_TO_EARTH &&
							hitInfo.type != BaseChangedInfo.RESTRAIN_EARTH_TO_WATER &&
							hitInfo.type != BaseChangedInfo.IGNITE && 
							hitInfo.type != BaseChangedInfo.POISON && 
							hitInfo.type != BaseChangedInfo.STEAL_HP && 
							hitInfo.type != BaseChangedInfo.PRISON &&
							hitInfo.type != BaseChangedInfo.DAMAGE_FROM_OTHER)
						{
							continue ;
						}
						
						hpChangedInfo = new BaseChangedInfo();
						hpChangedInfo.type = hitInfo.type;
						hpChangedInfo.value = hitInfo.arg;
						hpChangedList.push(hpChangedInfo);
						
						protoNinjaHitInfo.hintInfo.splice(j, 1);
						j --;
					}
					
					if(protoNinjaHitInfo.hintInfo.length == 0)
					{
						protoNinjaHitInfoList.splice(i, 1);
						i--;
					}
				}
			}
			
			return hpChangedList;
		}
		
		private static function convertHitInfoBaseInfoList(hitInfos:Array):Array
		{
			var hitInfo:ProtoHintInfo;
			var hpChangedList:Array = [];
			var hpChangedInfo:BaseChangedInfo;
			
			if(hitInfos == null){return hpChangedList}
			
			for(var i:int = 0;i < hitInfos.length;i ++)
			{
				hitInfo = hitInfos[i];
				if(hitInfo.type != BaseChangedInfo.BLOOD && 
					hitInfo.type != BaseChangedInfo.ALLELOPATHY && 
					hitInfo.type != BaseChangedInfo.RESTRAIN_WATER_TO_FIRE &&
					hitInfo.type != BaseChangedInfo.RESTRAIN_FIRE_TO_WIND &&
					hitInfo.type != BaseChangedInfo.RESTRAIN_WIND_TO_THUNDER &&
					hitInfo.type != BaseChangedInfo.RESTRAIN_THUNDER_TO_EARTH &&
					hitInfo.type != BaseChangedInfo.RESTRAIN_EARTH_TO_WATER &&
					hitInfo.type != BaseChangedInfo.IGNITE && 
					hitInfo.type != BaseChangedInfo.POISON && 
					hitInfo.type != BaseChangedInfo.STEAL_HP && 
					hitInfo.type != BaseChangedInfo.PRISON &&
					hitInfo.type != BaseChangedInfo.DAMAGE_FROM_OTHER)
				{
					continue ;
				}
				
				hpChangedInfo = new BaseChangedInfo();
				hpChangedInfo.type = hitInfo.type;
				hpChangedInfo.value = hitInfo.arg;
				hpChangedList.push(hpChangedInfo);
				
				hitInfos.splice(i, 1);
				i --;
			}
			return hpChangedList;
		}
		
		/**
		 *Hp变更详情 
		 * @param protoHpChangeDescribeArr
		 * @return 
		 * 
		 */		
		private static function convertAttributeChangedList(protoAttributeChangedList:Array):Array
		{
			var attributeChangedList:Array = [];
			var attributeChanged:BaseChangedInfo;
			for each (var protoAttributeChanged:ProtoHpChangeDescribe in protoAttributeChangedList)
			{
				if(protoAttributeChanged.hintType == BaseChangedInfo.BLOOD || 
					protoAttributeChanged.hintType == BaseChangedInfo.ALLELOPATHY ||
					protoAttributeChanged.hintType == BaseChangedInfo.RESTRAIN_WATER_TO_FIRE ||
					protoAttributeChanged.hintType == BaseChangedInfo.RESTRAIN_FIRE_TO_WIND ||
					protoAttributeChanged.hintType == BaseChangedInfo.RESTRAIN_WIND_TO_THUNDER ||
					protoAttributeChanged.hintType == BaseChangedInfo.RESTRAIN_THUNDER_TO_EARTH ||
					protoAttributeChanged.hintType == BaseChangedInfo.RESTRAIN_EARTH_TO_WATER ||
					protoAttributeChanged.hintType == BaseChangedInfo.IGNITE || 
					protoAttributeChanged.hintType == BaseChangedInfo.POISON ||
					protoAttributeChanged.hintType == BaseChangedInfo.STEAL_HP ||
					protoAttributeChanged.hintType == BaseChangedInfo.PRISON ||
					protoAttributeChanged.hintType == BaseChangedInfo.DAMAGE_FROM_OTHER
				)
				{
					continue ;
				}
				
				attributeChanged = new BaseChangedInfo();
				attributeChanged.type = protoAttributeChanged.hintType;
				attributeChanged.value = protoAttributeChanged.hpChange;
				attributeChangedList.push(attributeChanged);
			}
			return attributeChangedList;
		}
		
		public function autoSetNull():void
		{
			
		}
	}
}