package com.tencent.morefun.naruto.plugin.battle.data 
{
	

	public class MetaData 
	{
		public var type:String;
		public var args:Array;
		/**
		 * 中回合ID
		 */
		public var roundID:int;
		public var fn:Function;
		/**
		 * 是否后期执行
		 */
		public var isPostMeta:Boolean;
		public function MetaData(type:String,args:Array,roundID:int=-1) 
		{
			this.type = type;
			this.args = args;
			this.roundID = roundID;
		}
		
																
		public function autoSetNull():void
		{

			type = null;
			args = null;
			fn = null;
		}
	}

}