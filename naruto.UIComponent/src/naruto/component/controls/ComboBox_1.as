package naruto.component.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import naruto.component.core.BaseComboBox;
	import naruto.component.core.Button;
	import naruto.component.core.InvalidationType;
	
	[Event(name="change", type="flash.events.Event")]
	[Event(name="open", type = "flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	/**
	 * 下拉菜单。
	 * @author yboyjiang
	 */	
	public class ComboBox_1 extends BaseComboBox
	{
		public static const TEXT_COLOR_UP:String = "#9C8A64";
		
		protected var listYOffset:int = -2;
		protected var paddingLeft:int = 7;
		protected var paddingRight:int = 5;
		protected var _list:ComboBoxList_1;
		protected var _label:String = "请选择...";
		protected var isSelecting:Boolean;
		protected var isOpen:Boolean = false;
		
		public var textField:TextField;
		public var button:Button;
		public var background:MovieClip;
		
		public function ComboBox_1()
		{
			super(ComboBoxList_1);
			this.button.addEventListener(MouseEvent.CLICK, this.openOrCloseList);
			this.textField.addEventListener(MouseEvent.CLICK, this.openOrCloseList);
		}
		
		override public function set rowCount(value:int):void
		{
			super.rowCount = value;
			if (_list)
			{
				_list.rowCount = value;
			}
		}
		
		protected function openOrCloseList(e:MouseEvent):void
		{
			if (isOpen)
			{
				closeList();
			}else
			{
				openList();
			}
		}
		
		protected function openList():void
		{
			if (isOpen == true)
			{
				return;
			}
			isOpen = true;
			this.invalidate(InvalidationType.SIZE);
			trace("ComboBox_1.openList()");
			this.addChildAt(this.list, 0);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.onStageMouseUp);
			this.dispatchEvent(new Event(Event.OPEN));
		}
		
		private function onStageMouseUp(e:MouseEvent):void 
		{
			if (this.checkEventInObjectClass(e.target as DisplayObject))
			{
				return;
			}
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onStageMouseUp);
			closeList();
		}
		
		protected function closeList():void
		{
			if (isOpen == false)
			{
				return;
			}
			isOpen = false;
			trace("ComboBox_1.closeList()");
			removeChild(_list);
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function checkEventInObjectClass(eventTarget:DisplayObject):Boolean
		{
			if (eventTarget == this)
			{
				return true;
			}
			
			var parent:DisplayObjectContainer = eventTarget.parent;
			while (parent && !(parent is Stage))
			{
				if (parent == this)
				{
					return true;
				}
				else
				{
					parent = parent.parent
				}
			}
			return false;
		}
		
		[Inspectable(defaultValue="请选择...")]
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		override public function set data(value:Array):void
		{
			super.data = value;
			if (_list)
			{
				_list.data = value;
			}
			this.selectedIndex = -1;
		}
		
		override public function set dataKey(value:String):void 
		{
			super.dataKey = value;
			if (_list)
			{
				_list.dataKey = value;
			}
		}
		
		override public function set selectedIndex(value:int):void
		{
			if (this.isSelecting)
			{
				return;
			}
			
			value = Math.max(-1, Math.min(value, this.data.length));
			if (this.selectedIndex == value)
			{
				return;
			}
			
			if (_list)
			{
				this.setListSelectedIndex(value);
			}
			super.selectedIndex = value;
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.STATE))
			{
				if (this.selectedIndex > -1)
				{
					this.textField.htmlText = "<font color='"+TEXT_COLOR_UP+"'><b>"+(this.dataKey?this.data[this.selectedIndex][this.dataKey]:this.data[this.selectedIndex])+"</b></font>";
				}
				else
				{
					this.textField.htmlText = "<font color='"+TEXT_COLOR_UP+"'><b>"+_label+"</b></font>";
				}
			}
			
			if (this.isInvalid(InvalidationType.SIZE))
			{
				this.background.width = this.width;
				this.button.x = this.width - this.button.width - this.paddingRight;
				this.textField.width = this.button.x - this.paddingLeft;
			}
			
			if (this.isInvalid(InvalidationType.STATE) || this.isInvalid(InvalidationType.SIZE))
			{
				if (_list)
				{
					_list.y = this.height + this.listYOffset;
					_list.width = this.width - 8;
					
					if(stage)
					{
						var rect:Rectangle = _list.getRect(stage);
						if(rect && rect.bottom > stage.stageHeight)
						{
							_list.y = -(_list.height + this.listYOffset);
						}
					}
				}
			}
			
			super.draw();
		}
		
		protected function get list():ComboBoxList_1
		{
			if (!_list)
			{
				_list = new ComboBoxList_1();
				_list.dataKey = this.dataKey;
				_list.data = this.data;
				if(this.rowCount>0)
				{
					_list.rowCount = this.rowCount;
				}else
				{
					_list.rowCount = data.length;
				}
				_list.x = 4;
				_list.selectedIndex = this.selectedIndex;
				_list.addEventListener(Event.SELECT, this.onListSelectChange);
				this.invalidate(InvalidationType.STATE);
			}
			return _list;
		}
		
		// 选择了。
		protected function onListSelectChange(event:Event):void
		{
			this.selectedIndex = _list.selectedIndex;
			closeList();
		}
		
		// 设置 list 的选中项。
		protected function setListSelectedIndex(value:int):void
		{
			this.isSelecting = true;
			_list.selectedIndex = value;
			this.isSelecting = false;
		}
		
		override public function dispose():void
		{
			// 事件
			this.textField.removeEventListener(MouseEvent.CLICK, this.openOrCloseList);
			this.button.removeEventListener(MouseEvent.CLICK, this.openOrCloseList);
			if (this.stage)
			{
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onStageMouseUp);
			}
			if (this._list)
			{
				this._list.removeEventListener(Event.SELECT, this.onListSelectChange);
				this._list.dispose();
				this._list = null;
			}
			
			// 置空
			
			this.textField = null;
			this.background = null;
			
			super.dispose();
		}
		
	}
}