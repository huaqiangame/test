package com.tencent.morefun.naruto.plugin.ui.smart
{
	import com.tencent.morefun.naruto.plugin.ui.smart.events.SmartListEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SmartList extends Sprite
	{
		public static const DIRECTION_VERTICAL:String = "vertical";
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		private var itemRendererClass:Class;
		private var direction:String;
		private var row:int;
		private var col:int;
		
		public var rowGap:int;
		public var colGap:int;
		public var itemWidth:int;
		public var itemHeight:int;
		
		private var items:Array;
		private var datas:Array;
		
		public function SmartList(itemRendererClass:Class,row:int,col:int=1,direction:String="vertical")
		{
			super();
			
			this.itemRendererClass = itemRendererClass;
			this.row = row;
			this.col = col;
			this.direction = direction;
			
			this.items = [];
		}
		
		public function setDatas(datas:Array):void
		{
			this.datas = datas;
			
			refresh();
		}
		
		private function removeItems():void
		{
			for each(var item:SmartListItemRenderer in items)
			{
				item.removeEventListener(MouseEvent.CLICK, onItemClick);
				item.destroy();
				if(item.parent)
				{
					item.parent.addChild(item);
				}
			}
			items.length = 0;
		}
		
		private function refresh():void
		{
			removeItems();
			
			var r:int;
			var c:int;
			var iw:int;
			var ih:int;
			
			for(var i:int=0;i<datas.length;i++)
			{
				if(direction == DIRECTION_VERTICAL)
				{
					r = i%row;
					c = i/row;
				}else
				{
					r = i/col;
					c = i%col;
				}
				
				var item:SmartListItemRenderer = createItem();
				item.setData(datas[i]);
				item.addEventListener(MouseEvent.CLICK, onItemClick);
				if(itemWidth==0 && iw==0)
				{
					iw = item.width;
				}
				if(itemHeight==0 && ih==0)
				{
					ih = item.height;
				}
				
				item.x = c * (iw + colGap);
				item.y = r * (ih + rowGap);
				
				addChild(item);
				
				items.push(item);
			}
		}
		
		protected function onItemClick(event:MouseEvent):void
		{
			var sle:SmartListEvent = new SmartListEvent(SmartListEvent.ITEM_CLICK);
			sle.item = event.currentTarget as SmartListItemRenderer;
			dispatchEvent(sle);
		}
		
		private function createItem():SmartListItemRenderer
		{
			return new itemRendererClass;
		}
		
		public function destroy():void
		{
			removeItems();
			itemRendererClass = null;
			direction = null;
			items = null;
			datas = null;
		}
		}
}