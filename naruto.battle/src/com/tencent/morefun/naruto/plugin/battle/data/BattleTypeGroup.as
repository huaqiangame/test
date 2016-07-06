package com.tencent.morefun.naruto.plugin.battle.data
{
	import flash.utils.Dictionary;
	
	import base.ApplicationData;
	
	import serverProto.fight.FightStartSubType;
	import serverProto.fight.FightStartType;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class BattleTypeGroup
	{
		private static var autoStatusMap:Dictionary = new Dictionary();
		private static var speedStatusMap:Dictionary = new Dictionary();
		
		private static var instance:BattleTypeGroup;
		
		private static function init():void
		{
			autoStatusMap[1] = true;
			speedStatusMap[1] = true;
		}
		
		public static function getAutoTips(type:int):String
		{
			init();
			
			if(type == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				return I18n.lang("as_battle_1451031565_262");
			}
			
			if(BattleData.singleton.userInfoProxy.level < 13)
			{
				return I18n.lang("as_battle_1451031565_263");
			}
			
			return "";
		}
		
		
		public static function getSpeedTips(type:int):String
		{
			init();
			
			if(type == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				return I18n.lang("as_battle_1451031565_264");
			}
			
			if(BattleData.singleton.userInfoProxy.level < 13)
			{
				return I18n.lang("as_battle_1451031565_265");
			}
			
			if(type == FightStartType.FIGHT_START_TYPE_NPC ||
				type == FightStartType.FIGHT_START_TYPE_BEFALL_DUNGEON ||
				type == FightStartType.FIGHT_START_TYPE_SCENE_ESCORT ||
				type == FightStartType.FIGHT_START_TYPE_GUILD_DUNGEON ||
				type == FightStartType.FIGHT_START_TYPE_SANDBAG)
			{
				if(ApplicationData.singleton.selfInfo.teamId != "" && ApplicationData.singleton.selfInfo.teamId != null && ApplicationData.singleton.selfInfo.isCaptain == false)
				{
					return I18n.lang("as_battle_1451031565_266");
				}
			}
			
			if(isEnableSpeedType(type) == false)
			{
				return I18n.lang("as_battle_1451031565_267");
			}
			
			return null;
		}
		
		private static function checkAutoType(type:int):Boolean
		{
			if(isEnableAutoType(type) == false)
			{
				return false;
			}
			
			return getAutoStatus(type);
		}
		
		private static function getAutoTypeGroup(type:int):int
		{
			if(type == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				return 1;
			}
			
			return 2;
		}
		
		public static function isEnableAutoType(type:int):Boolean
		{
			if(type == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				return false;
			}
			
			if(BattleData.singleton.userInfoProxy.level < 13)
			{
				return false;
			}
			
			if(BattleData.singleton.isReplay == true)
			{
				return false;
			}
			
			return true;
		}
		
		public static function setAutoStatus(type:int, value:Boolean):void
		{
			init();
			
			autoStatusMap[getAutoTypeGroup(type)] = value;
		}
		
		public static function getAutoStatus(type:int):Boolean
		{
			init();
			
			return autoStatusMap[getAutoTypeGroup(type)];
		}
		
		private static function checkSpeedType(type:int):Boolean
		{
			if(isEnableSpeedType(type))
			{
				return false;
			}
			
			return getSpeedStatus(type);
		}
		
		private static function getSpeedTypeGroup(type:int):int
		{
			if(type == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				return 1;
			}
			
			if(type == FightStartType.FIGHT_START_TYPE_PVP
				|| type ==FightStartType.FIGHT_START_TYPE_BATTLE_ROYALE
				|| type == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_INFERIOR
				|| type == FightStartType.FIGHT_START_TYPE_GUILD_ROBBERY
				|| type == FightStartType.FIGHT_START_TYPE_GVG)
			{
				return 2;
			}
			
			if(type == FightStartType.FIGHT_START_TYPE_NPC ||
				type == FightStartType.FIGHT_START_TYPE_BEFALL_DUNGEON ||
				type == FightStartType.FIGHT_START_TYPE_SCENE_ESCORT ||
				type == FightStartType.FIGHT_START_TYPE_GUILD_DUNGEON ||
				type == FightStartType.FIGHT_START_TYPE_SANDBAG)
			{
				return 3;
			}
			
			return 100;
		}
		
		public static function setSpeedStatus(type:int, value:Boolean):void
		{
			init();
			
			speedStatusMap[getSpeedTypeGroup(type)] = value;
		}
		
		public static function getSpeedStatus(type:int):Boolean
		{
			init();
			
			return speedStatusMap[getSpeedTypeGroup(type)];
		}
		
		public static function isEnableSpeedType(type:int):Boolean
		{
			if(type == FightStartType.FIGHT_START_TYPE_RANK_BATTLE
			|| type == FightStartType.FIGHT_START_TYPE_PVP
			|| type == FightStartType.FIGHT_START_TYPE_BATTLE_ROYALE
			|| type == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_INFERIOR
			|| type == FightStartType.FIGHT_START_TYPE_GUILD_ROBBERY
			|| type == FightStartType.FIGHT_START_TYPE_WAR_WORSHIP
			|| type == FightStartType.FIGHT_START_TYPE_GVG)
			{
				return false;
			}
			
			if(BattleData.singleton.userInfoProxy.level < 13)
			{
				return false;
			}
			
			if(BattleData.singleton.isReplay == true)
			{
				return false;
			}
			
			if(type == FightStartType.FIGHT_START_TYPE_NPC ||
				type == FightStartType.FIGHT_START_TYPE_BEFALL_DUNGEON ||
				type == FightStartType.FIGHT_START_TYPE_SCENE_ESCORT ||
				type == FightStartType.FIGHT_START_TYPE_GUILD_DUNGEON ||
				type == FightStartType.FIGHT_START_TYPE_SANDBAG)
			{
				if(ApplicationData.singleton.selfInfo.teamId != "" && ApplicationData.singleton.selfInfo.teamId != null && ApplicationData.singleton.selfInfo.isCaptain == false)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function isEnableExitType(type:int):Boolean
		{
			init();
			
			if(type == FightStartType.FIGHT_START_TYPE_PVP
				|| type ==FightStartType.FIGHT_START_TYPE_BATTLE_ROYALE
				|| type == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_INFERIOR
				|| type == FightStartType.FIGHT_START_TYPE_GUILD_ROBBERY
				|| type == FightStartType.FIGHT_START_TYPE_GVG)
			{
				return false;
			}
			
			return true;
		}
		
		public static function getDefaultSpeedStatus(type:int):Boolean
		{
			if(type == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				return true;
			}
			
			return false;
		}
		
		public static function getDefaultAutoStatus(type:int):Boolean
		{
			if(type == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				return true;
			}
			
			return false;
		}
		
		public static function isShowMoneyType(type:int, subType:int):Boolean
		{
			init();
			
			if(type == FightStartType.FIGHT_START_TYPE_DUNGEON_SPECIAL && subType == FightStartSubType.FIGHT_START_SUB_TYPE_LUCKY_CAT)
			{
				return true;
			}
			
			return false;
		}
		
		public static function isShowFoodType(type:int, subType:int):Boolean
		{
			init();
			
			if(type == FightStartType.FIGHT_START_TYPE_DUNGEON_SPECIAL && subType == FightStartSubType.FIGHT_START_SUB_TYPE_EXP_ITEM)
			{
				return true;
			}
			
			return false;
		}
	}
}