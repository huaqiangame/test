package com.tencent.morefun.naruto.plugin.battle.messageConverter
{
	

	public class MessageRecoData
	{
		private static var ms_instance:MessageRecoData;
		
		public var money:int = -1;
		public function MessageRecoData()
		{
		}
		
		public static function get singleton():MessageRecoData
		{
			if(ms_instance == null)
			{
				ms_instance = new MessageRecoData();
			}
			
			return ms_instance;
		}
		
		public function reset():void
		{
			money = -1;
		}
	}
}