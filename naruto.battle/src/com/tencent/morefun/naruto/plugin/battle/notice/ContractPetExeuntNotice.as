package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;

	public class ContractPetExeuntNotice extends BaseNotice
	{
		public function ContractPetExeuntNotice()
		{
			super();
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