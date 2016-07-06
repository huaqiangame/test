package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	
	public class RefreshSkillStateNotice extends BaseNotice
	{
		public var skillStateList:Array;
		
		public function RefreshSkillStateNotice(skillStateList:Array)
		{
			super();
			
			this.skillStateList = skillStateList;
		}
	}
}