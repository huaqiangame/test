package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	
	public class LockAllSkillBtnNotice extends BaseNotice
	{
		public var lock:Boolean;
		
		public function LockAllSkillBtnNotice(lock:Boolean)
		{
			super();
			
			this.lock = lock;
		}
	}
}