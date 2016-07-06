package com.tencent.morefun.naruto.plugin.battle.notice
{
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;

	public class ContractPetEnterNotice extends BaseNotice
	{
		public var contractPetInfo:UpdatePlayerInfoNotice;
		
		public function ContractPetEnterNotice(contractPetInfo:UpdatePlayerInfoNotice=null)
		{
			super();
			
			this.contractPetInfo = contractPetInfo;
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}

			contractPetInfo = null;
		}
	}
}