package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	
	public class SkillVidoNotice extends BaseNotice
	{
		public var isStart:Boolean;
		public function SkillVidoNotice(isStart:Boolean)
		{
			super();
			
			this.isStart = isStart;
		}
	}
}