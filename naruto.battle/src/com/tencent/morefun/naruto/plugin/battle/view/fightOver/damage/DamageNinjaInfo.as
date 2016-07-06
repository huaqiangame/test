package com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage
{
	import ninja.model.data.NinjaInfo;
	
	import user.data.NinjaInfoConfig;

	public class DamageNinjaInfo
	{
		public var ninjaId:int;
		public var level:int;
		public var starLevel:int;
		public var makeDamage:int;
		public var affordDamage:int;
		public var maxMakeDamage:int;
		public var maxAffordDamage:int;
		public var levelUpgrade:int;
		
		private var ninjaInfo:NinjaInfo;
		public function getNinjaInfo():NinjaInfo
		{
			if(ninjaInfo == null)
			{
				ninjaInfo = new NinjaInfo();
				ninjaInfo.sequence = -1;
				ninjaInfo.id = ninjaId;
				ninjaInfo.level = level;
				ninjaInfo.starLevel = starLevel;
				ninjaInfo.levelUpgrade = levelUpgrade;
				ninjaInfo.cfg = NinjaInfoConfig.getNinjaCfgInfo(ninjaId);
			}
			
			return ninjaInfo;
		}
	}
}