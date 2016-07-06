package com.tencent.morefun.naruto.plugin.exui.tooltip.data
{


    import com.tencent.morefun.naruto.i18n.I18n;
	public class AttributeTipsInfo
	{
		public static const HP:int = 1;//生命值
		public static const ATTACK:int = 2;//攻击力
		public static const DEFENCE:int = 3;//防御
		public static const NINJA_ATTACK:int = 4;//忍术
		public static const NINJA_DEFENCE:int = 5;//抗性
		
		public static const WIND_RESIST:int = 10;//风抗
		public static const FIRE_RESIST:int = 11;//火炕
		public static const WATER_RESIST:int = 12;//水炕
		public static const EARTH_RESIST:int = 13;//土炕
		public static const THUNDER_RESIST:int = 14;//雷抗
		
		public static const HP_POTENTIAL:int = 15;//生命潜力
		public static const ATTACK_POTENTIAL:int = 16;//攻击潜力
		public static const DEFENCE_POTENTIAL:int = 17;//防御潜力
		public static const NINJA_ATTACK_POTENTIAL:int = 18;//忍术潜力
		public static const NINJA_DEFENCE_POTENTIAL:int = 19;//抗性潜力
		
		public static const COMBO:int = 6;//连击率
		public static const CRIT:int = 7;//暴击率
		public static const CRIT_HARM:int = 20;//暴伤
		public static const FIRST_ATTACK:int = 21;//先攻
		public static const CONTROL:int = 22;//控制
		
		public static const BODY_ATTACK_PENETRATE:int = 8;//体术穿透
		public static const NINJA_ATTACK_PENETRATE:int = 9;//忍术穿透
		public static const LIFE_RECOVER:int = 23;//生命恢复
		public static const HARM_REMISSION:int = 24;//伤害减免
		
		public static function getTipsInfo(type:int):String
		{
			switch(type)
			{
				case HP:
					return I18n.lang("as_exui_1451031568_1314");
					break;
				case ATTACK:
					return I18n.lang("as_exui_1451031568_1315");
					break;
				case DEFENCE:
					return I18n.lang("as_exui_1451031568_1316");
					break;
				case NINJA_ATTACK:
					return I18n.lang("as_exui_1451031568_1317");
					break;
				case NINJA_DEFENCE:
					return I18n.lang("as_exui_1451031568_1318");
					break;
				case WIND_RESIST:
					return I18n.lang("as_exui_1451031568_1319");
					break;
				case FIRE_RESIST:
					return I18n.lang("as_exui_1451031568_1320");
					break;
				case WATER_RESIST:
					return I18n.lang("as_exui_1451031568_1321");
					break;
				case EARTH_RESIST:
					return I18n.lang("as_exui_1451031568_1322");
					break;
				case THUNDER_RESIST:
					return I18n.lang("as_exui_1451031568_1323");
					break;
				case HP_POTENTIAL:
					return I18n.lang("as_exui_1451031568_1324");
					break;
				case ATTACK_POTENTIAL:
					return I18n.lang("as_exui_1451031568_1325");
					break;
				case DEFENCE_POTENTIAL:
					return I18n.lang("as_exui_1451031568_1326");
					break;
				case NINJA_ATTACK_POTENTIAL:
					return I18n.lang("as_exui_1451031568_1327");
					break;
				case NINJA_DEFENCE_POTENTIAL:
					return I18n.lang("as_exui_1451031568_1328");
					break;
				case CRIT:
					return I18n.lang("as_exui_1451031568_1329");
					break;
				case COMBO:
					return I18n.lang("as_exui_1451031568_1330");
					break;
				case CRIT_HARM:
					return I18n.lang("as_exui_1451031568_1331");
					break;
				case FIRST_ATTACK:
					return I18n.lang("as_exui_1451031568_1332");
					break;
				case CONTROL:
					return I18n.lang("as_exui_1451031568_1333");
					break;
				case BODY_ATTACK_PENETRATE:
					return I18n.lang("as_exui_1451031568_1334");
					break;
				case NINJA_ATTACK_PENETRATE:
					return I18n.lang("as_exui_1451031568_1335");
					break;
				case HARM_REMISSION:
					return I18n.lang("as_exui_1451031568_1336");
					break;
				case LIFE_RECOVER:
					return I18n.lang("as_exui_1451031568_1337");
					break;
			}
			
			return "";
		}
	}
}