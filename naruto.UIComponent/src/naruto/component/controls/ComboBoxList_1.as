package naruto.component.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import naruto.component.core.BaseList;
	import naruto.component.core.BaseListItemRenderer;
	import naruto.component.core.InvalidationType;
	
	[Event(name="select", type="flash.events.Event")]
	
	/**
	 * 下拉菜单的列表。
	 * @author yboyjiang
	 */	
	public class ComboBoxList_1 extends BaseList
	{
		public var background:DisplayObject;
		
		protected const paddingLeft:int = 5;
		protected const paddingRight:int = 5;
		protected const paddingTop:int = 7;
		protected const paddingBottom:int = 7;
		protected const gapH:int = 0;
		protected const beginY:int = 1;
		protected const itemHeight:int = 24;
		
		protected var isSelecting:Boolean; // 用于避免同一时间里多次抛 change 事件
		protected var itemList:Vector.<ComboBoxListItemRenderer_1>;
		protected var itemContainer:Sprite;
		protected var scrollBar:ScrollBar_1;
		
		public function ComboBoxList_1()
		{
			super(ComboBoxListItemRenderer_1);
			this.itemList = new Vector.<ComboBoxListItemRenderer_1>();
			this.itemContainer = new Sprite();
			this.itemContainer.x = this.paddingLeft;
			this.itemContainer.y = this.paddingTop;
			this.addChild(this.itemContainer);
		}
		
		override public function set rowCount(value:int):void
		{
			this.height = (this.itemHeight+this.gapH)*value + this.paddingBottom + this.paddingTop;
		}
		
		override public function get rowCount():int
		{
			return int(this.scrollViewHeight/(this.itemHeight+this.gapH));
		}
		
		override public function get viewAreaPercent():Number
		{
			var contentTotalHeight:int = this.contentTotalHeight;
			if (contentTotalHeight == 0)
			{
				return 1;
			}
			
			var num:Number = this.scrollViewHeight/this.contentTotalHeight;
			return num > 1 ? 1 : num;
		}
		
		override public function set data(value:Array):void
		{
			super.data = value ? value : [];
			
			var oldLen:int = this.itemList.length;
			var newLen:int = this.data.length;
			
			// 创建对应多的 itemRenderer
			var num:int;
			var item:ComboBoxListItemRenderer_1;
			if (oldLen < newLen) // 创建
			{
				num = newLen - oldLen;
				while (num--)
				{
					item = new ComboBoxListItemRenderer_1();
					item.addEventListener(Event.CHANGE, this.onItemSelectChange);
					this.itemList.push(item);
				}
			}
			else if (newLen < oldLen) // 删除多余的
			{
				num = oldLen - newLen;
				while (num--)
				{
					item = this.itemList.pop();
					item.dispose();
					item.removeEventListener(Event.CHANGE, this.onItemSelectChange);
					this.itemContainer.removeChild(item);
				}
			}
			
			// 刷新
			for (var i:int = 0; i < newLen; i++)
			{
				item = this.itemList[i];
				item.removeEventListener(Event.CHANGE, this.onItemSelectChange);
				item.index = i;
				item.selected = false;
				item.dataKey = this.dataKey;
				item.data = this.data[i];
				item.x = 0;
				item.y = i*(this.itemHeight+this.gapH) + this.beginY;
				this.itemContainer.addChild(item);
				item.addEventListener(Event.CHANGE, this.onItemSelectChange);
			}
			this.selectedIndex = -1;
			this.checkScrollBar();
		}
		
		override public function set selectedIndex(value:int):void
		{
			if (this.isSelecting)
			{
				return;
			}
			
			value = Math.max(-1, Math.min(value, this.itemList.length));
			//if (value == this.selectedIndex)
			//{
				//return;
			//}
			
			this.isSelecting = true;
			if (this.selectedIndex > -1 && this.selectedIndex < this.itemList.length) // 处理旧的
			{
				this.itemList[this.selectedIndex].selected = false;
			}
			if (value > -1)
			{
				this.itemList[value].selected = true; // 处理新的
			}
			this.isSelecting = false;
			super.selectedIndex = value;
		}
		
		override public function set scrollPercent(value:Number):void
		{
			super.scrollPercent = value;
			this.checkScrollBar();
		}
		
		protected function onItemSelectChange(event:Event):void
		{
			var item:BaseListItemRenderer = (event.currentTarget as BaseListItemRenderer);
			if (item.index == this.selectedIndex)
			{
				if (!item.selected)
				{
					this.selectedIndex = -1;
				}
			}
			else
			{
				this.selectedIndex = item.index;
			}
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			this.checkScrollBar();
		}
		
		protected function checkScrollBar():void
		{
			var dw:int = 0;
			if (this.viewAreaPercent < 1) // 出现滚动条
			{
				if (!this.scrollBar)
				{
					this.scrollBar = new ScrollBar_1();
					this.scrollBar.addEventListener(Event.CHANGE, this.onScrollBarChange);
					this.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
				}
				this.scrollBar.x = this.width - this.paddingRight - this.scrollBar.width;
				this.scrollBar.y = this.paddingTop;
				this.scrollBar.height = this.height - this.paddingTop - this.paddingBottom;
				this.scrollBar.viewAreaPercent = this.viewAreaPercent;
				this.scrollBar.scrollPercent = this.scrollPercent;
				this.addChild(this.scrollBar);
				dw = this.scrollBar.width;
			}
			else if (this.scrollBar && this.scrollBar.parent)
			{
				this.removeChild(this.scrollBar);
				this.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
			}
			
			// 调整 item 的宽度
			var toW:int = this.width - this.paddingLeft - this.paddingRight - dw;
			toW = toW > 0 ? toW : 0;
			for each (var item:ComboBoxListItemRenderer_1 in this.itemList)
			{
				item.width = toW;
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			this.scrollBar.scrollPercent -= e.delta * (1/data.length);
		}
		
		protected function onScrollBarChange(event:Event):void
		{
			super.scrollPercent = this.scrollBar.scrollPercent;
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.SCROLL))
			{
				this.updateScrollView();
			}
			
			if (this.isInvalid(InvalidationType.SIZE))
			{
				this.updateLayout();
				this.updateScrollView();
			}
			super.draw();
		}
		
		protected function updateLayout():void
		{
			this.background.width = this.width;
			this.background.height = this.height;
		}
		
		protected function updateScrollView():void
		{
			var scrollViewWidth:int = this.width-this.paddingLeft-this.paddingRight;
			var toY:int = this.scrollTotalHeight*this.scrollPercent;
			this.itemContainer.scrollRect = new Rectangle(0, toY, scrollViewWidth, this.scrollViewHeight);
		}
		
		protected function get scrollViewHeight():int
		{
			var num:int = this.height-this.paddingBottom-this.paddingTop;
			return num > 0 ? num : 0;
		}
		
		// 不能显示的那一部分高度。
		protected function get scrollTotalHeight():int
		{
			if (!this.data)
			{
				return 0;
			}
			
			var scrollViewHeight:int = this.scrollViewHeight;
			var scrollTotalHeight:int = (this.itemHeight+this.gapH)*this.data.length - scrollViewHeight;
			return scrollTotalHeight > 0 ? scrollTotalHeight : 0;
		}
		
		protected function get contentTotalHeight():int
		{
			if (!this.data)
			{
				return 0;
			}
			
			return (this.itemHeight+this.gapH)*this.data.length;
		}
		
		override public function dispose():void
		{
			// 事件
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
			if (this.scrollBar)
			{
				this.scrollBar.removeEventListener(Event.CHANGE, this.onScrollBarChange);
				this.scrollBar.dispose();
			}
			while (this.itemList.length)
			{
				var item:ComboBoxListItemRenderer_1 = this.itemList.pop();
				item.dispose();
				item.removeEventListener(Event.CHANGE, this.onItemSelectChange);
				this.itemContainer.removeChild(item);	
			}
			
			// 置空
			this.background = null;
			this.itemList.length = 0;
			this.itemList = null;
			this.itemContainer = null;
			
			
			super.dispose();
		}
		
	}
}