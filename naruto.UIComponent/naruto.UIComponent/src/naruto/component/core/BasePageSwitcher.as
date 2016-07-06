package naruto.component.core
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import naruto.component.core.event.PageSwitcherEvent;

	[Event(name = "pageSwitcherValueChanged", type = "naruto.component.core.event.PageSwitcherEvent")]
	public class BasePageSwitcher extends UIComponent
	{
		public var txt:TextField;
		public var upBtn:Button;
		public var downBtn:Button;
		public var textBg:MovieClip;
		
		protected var _min:int;
		protected var _max:int;
		protected var _value:int;
		
		public function BasePageSwitcher()
		{
			super();
			
			_min = 0;
			_max = 3;
			this.value = 0;
			
			txt.autoSize = TextFieldAutoSize.LEFT;
			
			upBtn.addEventListener(MouseEvent.CLICK, onUpButtonClicked);
			downBtn.addEventListener(MouseEvent.CLICK, onDownButtonClicked);
		}
		
		protected function onDownButtonClicked(event:MouseEvent):void
		{
			this.value = _value + 1;
		}
		
		protected function onUpButtonClicked(event:MouseEvent):void
		{
			this.value = _value - 1;
		}
		
		protected function updateText():void
		{
			txt.text = _value + "/" + _max;
		}
		
		public function get min():int
		{
			return _min;
		}

		public function set min(value:int):void
		{
			_min = value;
			this.value = _value;
		}

		public function get max():int
		{
			return _max;
		}

		public function set max(value:int):void
		{
			_max = value;
			this.value = _value;
		}

		public function get value():int
		{
			return _value;
		}

		public function set value(value:int):void
		{
			_value = value;
			if (_value > _max)
			{
				_value = _max;
			}
			else if (_value < _min)
			{
				_value = _min;
			}
			
			upBtn.enabled = (_value > _min);
			downBtn.enabled = (_value < _max);
			
			dispatchChangeEvent(_value);
			invalidate(InvalidationType.STATE);
		}
		
		override protected function draw():void
		{
			if (isInvalid(InvalidationType.STATE))
			{
				updateText();
				updateTextPosition();
			}
			
			if (isInvalid(InvalidationType.SIZE))
			{
				updateSize();
				updateTextPosition();
			}
			super.draw();
		}
		
		protected function dispatchChangeEvent(newValue:int):void
		{
			var evt:PageSwitcherEvent = new PageSwitcherEvent(PageSwitcherEvent.PAGE_SWITCHER_VALUE_CHANGED);
			evt.newValue = newValue;
			dispatchEvent(evt);
		}
		
		protected function updateSize():void
		{
			textBg.width = _width - textBg.x - downBtn.width + 11;
			downBtn.x = _width - downBtn.width;
		}
		
		protected function updateTextPosition():void
		{
			txt.x = (_width - txt.textWidth) / 2;
		}
		
		override public function dispose():void
		{
			// 事件
			this.upBtn.removeEventListener(MouseEvent.CLICK, onUpButtonClicked);
			this.downBtn.removeEventListener(MouseEvent.CLICK, onDownButtonClicked);
			
			// 置空
			this.txt = null;
			this.upBtn.dispose();
			this.upBtn = null;
			this.downBtn.dispose();
			this.downBtn = null;
			this.textBg.stop();
			this.textBg = null;
			
			super.dispose();
		}
		
	}
}