package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;

	public class SpeedUpNotice extends BaseNotice
	{
		public var time:int;
		public function SpeedUpNotice(time:int)
		{
			super();
			
			this.time = time;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

		}
	}
}