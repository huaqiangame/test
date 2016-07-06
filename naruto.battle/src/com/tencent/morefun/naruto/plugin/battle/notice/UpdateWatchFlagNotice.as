package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;

	public class UpdateWatchFlagNotice extends BaseNotice
	{
		public var model:int;
		
		public function UpdateWatchFlagNotice(model:int=0)
		{
			super();
			
			this.model = model;
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