package com.tencent.morefun.naruto.plugin.exui.popUpList
{
	import com.tencent.morefun.naruto.plugin.exui.render.PopupListItemRender;
	import com.tencent.morefun.naruto.plugin.ui.components.layouts.EasyLayout;
	import flash.display.Sprite;
	import naruto.component.controls.Background_11;

	public class PopupList extends Sprite
	{
		private var bg:Background_11;
		private var list:EasyLayout;
		
		public function PopupList()
		{
			super();
			initUI();
		}
		
		private function initUI():void
		{
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(-5, -5, 10, 10);
			this.graphics.endFill();
			
			bg = new Background_11();
			addChild(bg);
			
			list = new EasyLayout(PopupListItemRender, 5, 1, 0, 0);
			list.x = 2;
			list.y = 22;
			addChild(list);
			
			bg.height = list.height + 22;
			bg.width = list.width + 4;
		}
		
		/**
		 * @param arr 字符串数组
		 */
		public function set data(arr:Array):void
		{
			if (arr && arr.length > 0)
			{
				list.row = arr.length;
			}
			list.dataProvider = arr;
			bg.height = list.height + 44;
			bg.width = list.width + 4;
		}
		
		public function get data():Array
		{
			return list.dataProvider;
		}
		
		public function destroy():void
		{
			removeChild(bg);
			bg.dispose();
			bg = null;
			
			removeChild(list);
			list.dispose();
			list = null;
		}
		
		public function dispose():void
		{
			destroy();
		}
	}
}