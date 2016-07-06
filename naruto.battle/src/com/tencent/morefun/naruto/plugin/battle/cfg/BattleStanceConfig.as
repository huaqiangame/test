package com.tencent.morefun.naruto.plugin.battle.cfg
{
	
	import flash.utils.Dictionary;

	public class BattleStanceConfig
	{
		[StaticAutoDestroy]
		
		public static var xml:XML;
		public static var inited:Boolean;
		
		public static var battleStanceMap:Dictionary = new Dictionary();
		
		public function BattleStanceConfig()
		{
		}
		
		private static function init():void
		{
			if(inited)
			{
				return ;
			}
			
			inited = true;
			
			for each(var battleStanceCfgObj:Object in xml.BattleStanceItem)
			{
				var ballteStanceCfgList:Array;
				var battleStanceCfg:BattleStanceCfg;
				var exeuntStageAction:int;
				
				ballteStanceCfgList = new Array();
				for(var i:int = 0;i < 9;i ++)
				{
					battleStanceCfg = new BattleStanceCfg();
					battleStanceCfg.pos = i;
					exeuntStageAction = battleStanceCfgObj.@["exeuntStageAction" + i];
					if(exeuntStageAction == 0)
					{
						battleStanceCfg.exeuntStageAction = -1;
					}
					else
					{
						battleStanceCfg.exeuntStageAction = exeuntStageAction;
					}
					ballteStanceCfgList.push(battleStanceCfg);
				}
				
				battleStanceMap[String(battleStanceCfgObj.@id)] = ballteStanceCfgList;
			}
		}
		
		public static function getNinjaBattleStanceCfg(battleStanceId:int, teamId:int, ninjaPos:int):BattleStanceCfg
		{
			var ballteStanceCfgList:Array;
			
			init();
			
			ballteStanceCfgList = battleStanceMap[battleStanceId];
			if(!ballteStanceCfgList)
			{
				return null;
			}
			
			for each(var battleStanceCfg:BattleStanceCfg in ballteStanceCfgList)
			{
				if(isDestPos(battleStanceCfg.pos, teamId, ninjaPos))
				{
					return battleStanceCfg;
				}
			}
			
			return null;
		}
		
		private static function isDestPos(cfgPos:int, teamId:int, ninjaPos:int):Boolean
		{
			var pos:int;
			var realCfgPos:int;
			
			if(ninjaPos >= 100)
			{
				ninjaPos = ninjaPos - 100;
			}
			
			realCfgPos = cfgPos + Math.floor(teamId / 2) * 9;
			
			return ninjaPos == realCfgPos;
		}
																
		public static function autoSetNull():void
		{

			xml = null;
			battleStanceMap = null;
		}
	}
}