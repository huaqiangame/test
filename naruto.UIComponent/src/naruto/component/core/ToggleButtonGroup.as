package naruto.component.core
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="change", type="flash.events.Event")]
	public class ToggleButtonGroup extends UIComponent
	{
		protected var buttonClass:Class;
		protected var buttons:Array = [];
		
		private var _labels:Array = ["label0"];
		private var _selectedIndex:int = 0;
		private var _gap:int = -14;
		
		public function ToggleButtonGroup(buttonClass:Class)
		{
			this.buttonClass = buttonClass;
			super();
		}
		
		[Inspectable(type="Array",defaultValue="label0")]
		public function get labels():Array
		{
			return _labels;
		}

		public function set labels(value:Array):void
		{
			_labels = value;
			updateData();
			if (value.length > this.selectedIndex + 1)
			{
				this.selectedIndex = 0;
			}
			else
			{
				this.selectedIndex = this.selectedIndex;
			}
		}
		
		
		protected function updateData():void
		{
			var i:int = 0;
			var len:int = labels.length;
			var btn:ToggleButton;
			var xx:int;
			for(;i<len;i++)
			{
				if(i < buttons.length)
				{
					btn = buttons[i];
				}else
				{
					btn = createToggleButton();
					buttons.push(btn);
				}
				addChildAt(btn,0);
				btn.label = labels[i];
				btn.x = xx;
				xx = btn.x + btn.width + _gap;
			}
			while(buttons.length > len)
			{
				btn = buttons.pop();
				disposeToggleButton(btn);
				if(btn.parent)
				{
					btn.parent.removeChild(btn);
				}
			}
			this.width = xx - _gap;
		}
		
		
		[Inspectable(defaultValue=0)]
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			
			for(var i:int=buttons.length-1; i>=0; i--)
			{
				var btn:ToggleButton = buttons[i];
				
				if (selectedIndex == i)
				{
					btn.selected = true;
				}else {
					btn.selected = false;
					addChild(btn);
				}
			}
			
			addChild(buttons[selectedIndex]);
		}
		
		[Inspectable(defaultValue=-14)]
		public function get gap():int 
		{
			return _gap;
		}
		
		public function set gap(value:int):void 
		{
			_gap = value;
		}
		
		private function createToggleButton():ToggleButton
		{
			var btn:ToggleButton = new buttonClass();
			btn.addEventListener(MouseEvent.CLICK, onToggleButtonClick);
			return btn;
		}
		
		private function disposeToggleButton(btn:ToggleButton):void
		{
			btn.removeEventListener(MouseEvent.CLICK, onToggleButtonClick);
			btn.dispose();
		}
		
		protected function onToggleButtonClick(event:MouseEvent):void
		{
			selectedIndex = buttons.indexOf(event.currentTarget as ToggleButton);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function dispose():void
		{
			this.buttonClass = null;
			this._labels = null;
			for each (var btn:ToggleButton in this.buttons)
			{
				this.disposeToggleButton(btn);
			}
			this.buttons.length = 0;
			this.buttons = null;
			super.dispose();
		}
		
	}
}