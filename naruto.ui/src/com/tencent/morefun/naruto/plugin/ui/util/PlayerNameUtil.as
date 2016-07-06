package com.tencent.morefun.naruto.plugin.ui.util
{
	import base.ApplicationData;
	import com.netease.protobuf.UInt64;
	
	import serverProto.inc.ProtoPlayerKey;
	
	/**
	 * @author woodychen
	 * @createTime 2015-4-13 下午4:36:47
	 **/
    import com.tencent.morefun.naruto.i18n.I18n;
	public class PlayerNameUtil
	{
		public function PlayerNameUtil()
		{
		}
		
		static public function standardlizeName(svrInfo:Object, playerName:String):String
		{
			var svrId:uint;
			
			if (svrInfo is ProtoPlayerKey)
			{
				svrId = (svrInfo as ProtoPlayerKey).svrId;
			}
			else
			{
				svrId = int(svrInfo);
			}
			
			if (ApplicationData.singleton.hasOwnProperty("isMergedServer") && ApplicationData.singleton["isMergedServer"] == true)
			{
				//6000> <8000 %6000
				//>8000 %8000 + 1
				//(6000,8000)
				//[8000,....8000以上
				//svrId = 6001;
				if(svrId > 6000 && svrId < 8000){
					svrId = int(svrId%6000);
				}
				if(svrId > 8000){
					svrId = int(svrId%8000);
				}
				return svrId + I18n.lang("as_ui_1451031579_6202") + playerName;
			}
			else
			{
				return playerName;
			}
		}
		
		static public function formatGuildName(id:UInt64, name:String):String
		{
			return standardlizeName(id.high & 0x0000FFFF, name);
		}
	}
}