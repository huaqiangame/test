package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;

	public class RequestAutoFightNotice extends BaseNotice
	{
		public var isAuto:Boolean;
		
		public function RequestAutoFightNotice(isAuto:Boolean)
		{
			super();
			
			this.isAuto = isAuto;
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