package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.data.SkillStatuInfo;
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	
	public class UpdateBattleViewSkillStateNotice extends BaseNotice
	{
		public var skillState:SkillStatuInfo;
		
		public function UpdateBattleViewSkillStateNotice(skillState:SkillStatuInfo)
		{
			super();
			
			this.skillState = skillState;
		}
	}
}