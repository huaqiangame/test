package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;

	public class RequestSpeedUpNotice extends BaseNotice
	{
		public var speedUp:Boolean;
		public function RequestSpeedUpNotice(speedUp:Boolean)
		{
			super();
			
			this.speedUp = speedUp;
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