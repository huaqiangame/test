package naruto.component.core
{
	import flash.events.MouseEvent;

	public class ToggleButton extends LabelButton
	{
		protected var _selected:Boolean;
		
		public function ToggleButton()
		{
			super();
			
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			selected = !selected;
		}
		
		[Inspectable(defaultValue="false")]
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			invalidate(InvalidationType.STATE);
			invalidate(InvalidationType.SELECTED);
		}
		
		override protected function drawSkin():void
		{
			var state:String = _state;
			if(selected)
			{
				state = state + "Selected";
			}
			
			this.gotoAndStop(state);
			var skinName:String = state + "Skin";
			if (this[skinName])
			{
				this.currentSkin = this[skinName];
			}
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK,onMouseClick);
			super.dispose();
		}
		
	}
}