package com.tencent.morefun.naruto.plugin.ui.util
{
	import base.ApplicationData;
	
	import login.def.LoginWayDef;
	
	import naruto.component.controls.Icon_VipLevel;
	
	import player.def.VipLevelDef;
	
	import serverProto.inc.ProtoDiamondInfo;

	public class VipUtil
	{
		public function VipUtil()
		{
		}
		
		static public function setSelfInfo(icon:Icon_VipLevel, show3366:Boolean=false):void
		{
			setOtherInfo(icon, ApplicationData.singleton.selfInfo.vip, ApplicationData.singleton.selfInfo.diamondInfo, show3366);
		}
		
		static public function setOtherInfo(icon:Icon_VipLevel, vipLevel:int, diamondInfo:ProtoDiamondInfo, show3366:Boolean=false):void
		{
			icon.vipLevel = vipLevel;
			if(diamondInfo == null)
			{
				icon.diamondType = 0;
				icon.diamondLevel = 0;
				icon.diamondYear = false;
				icon.diamondSuper = false;
				icon.diamondCommon = false;
//				icon.qq3366Level = 0;
				return;
			}
			switch(ApplicationData.singleton.loginWay)
			{
				case LoginWayDef._3366:
//					if(show3366)
//					{
//						icon.qq3366Level = 1;
//					}
				case LoginWayDef.QQGAME:
//				case LoginWayDef.GAMEVIP:
					icon.diamondType = 1;
					icon.diamondLevel = diamondInfo.blueLevel;
					icon.diamondYear = diamondInfo.blueYear;
					icon.diamondSuper = diamondInfo.blueSuper;
					icon.diamondCommon = diamondInfo.blueCommon;
					break;
				case LoginWayDef.QZONE:
					icon.diamondType = 2;
					icon.diamondLevel = diamondInfo.yellowLevel;
					icon.diamondYear = diamondInfo.yellowYear;
					icon.diamondSuper = diamondInfo.yellowSuper;
					icon.diamondCommon = diamondInfo.yellowCommon;
					break;
//				case LoginWayDef.QQVIP:
//					icon.diamondType = 3;
//					icon.diamondLevel = diamondInfo.qqLevel;
//					icon.diamondYear = diamondInfo.qqYear;
//					icon.diamondSuper = diamondInfo.qqSuper;
//					icon.diamondCommon = diamondInfo.qqCommon;
//					break;
				default:
					icon.diamondType = 0;
					icon.diamondLevel = 0;
					icon.diamondYear = false;
					icon.diamondSuper = false;
					icon.diamondCommon = false;
					break;
			}
		}

        public static function hasDiscount():Boolean
        {
            if (ApplicationData.singleton.selfInfo.vip == VipLevelDef.LOW_LEVEL_VIP || ApplicationData.singleton.selfInfo.vip == VipLevelDef.MIDDLE_LEVEL_VIP || ApplicationData.singleton.selfInfo.vip == VipLevelDef.HIGH_LEVEL_VIP)
                return true;
            else if (ApplicationData.singleton.loginWay == LoginWayDef.QQGAME && ApplicationData.singleton.selfInfo.diamondInfo.blueCommon)
                return true;
            else if (ApplicationData.singleton.loginWay == LoginWayDef.QZONE && ApplicationData.singleton.selfInfo.diamondInfo.yellowCommon)
                return true;
            else if (ApplicationData.singleton.loginWay == LoginWayDef.QQVIP &&  ApplicationData.singleton.selfInfo.diamondInfo.qqCommon)
                return true;
            else if (ApplicationData.singleton.loginWay == LoginWayDef._3366 && ApplicationData.singleton.selfInfo.diamondInfo.blueCommon)
                return true;

            return false;
        }
	}
}