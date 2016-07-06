package com.tencent.morefun.naruto.plugin.battle.cfg
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import cfgData.CFGDataEnum;
	import cfgData.CFGDataLibs;
	import cfgData.dataStruct.SpecialbattleCFG;

	public class SpecialbattleConfig
	{
		public static var specialbattleBin:ByteArray;
		
		private static var inited:Boolean;
		private static var specialbattleItemMap:Dictionary;
		
		public function SpecialbattleConfig()
		{
			
		}
		
		public static function init():void
		{
			if(inited)
			{
				return ;
			}
			
			inited = true;
			
			specialbattleBin.position = 0;
			specialbattleItemMap = CFGDataLibs.parseData(specialbattleBin, CFGDataEnum.ENUM_SpecialbattleCFG);
		}
		
		public static function getSpecialbattleItem(type:int):SpecialbattleCFG
		{
			init();
			
			return specialbattleItemMap[type];
		}
	}
}