package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;

	public class OtherPlayerResCompleteNotce extends BaseNotice
	{
		public var pos:int;
		
		public function OtherPlayerResCompleteNotce(pos:int)
		{
			super();
			
			this.pos = pos;
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