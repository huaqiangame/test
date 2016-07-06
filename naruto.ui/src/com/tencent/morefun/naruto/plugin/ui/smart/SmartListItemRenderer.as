package com.tencent.morefun.naruto.plugin.ui.smart
{
	import flash.display.Sprite;

	public class SmartListItemRenderer extends Sprite
	{
		protected var data:Object;
		
		public function SmartListItemRenderer()
		{
			super();
		}
		
		public function setData(data:Object):void
		{
			this.data = data;
		}
		
		public function getData():Object
		{
			return this.data;
		}
		
		public function destroy():void
		{
			
		}
		}
}