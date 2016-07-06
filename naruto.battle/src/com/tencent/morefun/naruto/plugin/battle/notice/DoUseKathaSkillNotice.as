package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	
	public class DoUseKathaSkillNotice extends BaseNotice
	{
		public var active_pos:uint;
		public var passive_pos:uint;
		public var skill_index:int;
		
		public function DoUseKathaSkillNotice(active_pos:uint, passive_pos:uint, skill_index:int)
		{
			super();
			
			this.active_pos = active_pos;
			this.passive_pos = passive_pos;
			this.skill_index = skill_index;
		}
	}
}