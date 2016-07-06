package com.tencent.morefun.naruto.plugin.battle.cfg
{

	import com.tencent.morefun.naruto.sound.data.BgMusicConfig;

	public class CustomBattleConfig
	{
		[StaticAutoDestroy]
		private static var list:Array;
		public static const musicConfig:BgMusicConfig = new BgMusicConfig();
		
		public function CustomBattleConfig()
		{
		}
		
		public static function setXML(xml:XML):void
		{
			list = [];
			for each(var cfgXML:XML in xml.customBattle)
			{
				var cfg:CustomBattleCfg = new CustomBattleCfg();
				cfg.music = musicConfig.getMusicInfo(parseInt(cfgXML.@bgMusic));
				cfg.setXML(cfgXML);
				list.push(cfg);
			}
		}
		
		public static function getCustomBattleCfg(id:int,sectionId:int):CustomBattleCfg
		{
			for each(var cfg:CustomBattleCfg in list)
			{
				if(cfg.id == id && cfg.sectionId == sectionId)
				{
					return cfg;
				}
			}
			return null;
		}
		
		public static function getCustomBattleIdLsit():Array
		{
			var idList:Array = [];
			
			for each(var cfg:CustomBattleCfg in list)
			{
				idList.push(cfg.id);
			}
			
			return idList;
		}
																
		public static function autoSetNull():void
		{

			list = null;
		}
	}
}