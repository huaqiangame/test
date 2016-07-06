package com.tencent.morefun.naruto.plugin.exui.dropDownList.data
{
	/**
	 * @author woodychen
	 * @createTime 2015-3-17 上午11:42:03
	 **/
	public class NinjaPropertyData
	{
		/**
		 * @see NinjaDefConfig
		 */
		public var type:String;
		public var id:int;
		
		public function NinjaPropertyData(type:String = "", id:int = -1)
		{
			this.type = type;
			this.id = id;
		}
	}
}