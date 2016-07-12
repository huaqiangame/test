package naruto.component.core
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import naruto.component.core.enum.ButtonState;
	
	public class BaseButton extends UIComponent
	{
		protected var currentSkin:DisplayObject;
		protected var _state:String; // 状态：up、over、down、disabled
		
		public function BaseButton()
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK, this.onMouseClickHandler, false, 0, true);
		}
		
		protected function onMouseClickHandler(event:MouseEvent):void
		{
			if(!enabled)
			{
				event.stopImmediatePropagation();
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
//			this.mouseEnabled = value;
			this.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverHandler);
			if (value)
			{
				this.setState(_state == ButtonState.DISABLED ? ButtonState.UP : _state);
				this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverHandler);
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
				this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
				this.setState(ButtonState.DISABLED);
			}
		}
		
		override protected function configUI():void
		{
			super.configUI();
			this.mouseChildren = false;
			this.setState(ButtonState.UP);
			this.enabled = true;
		}
		
		protected function onMouseOverHandler(event:MouseEvent):void
		{
			this.setState(ButtonState.OVER);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			this.setState(ButtonState.DOWN);
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			this.setState(ButtonState.OVER);
		}
		
		protected function mouseOutHandler(event:MouseEvent=null):void
		{
			this.setState(ButtonState.UP);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
		}
		
		protected function setState(state:String):void
		{
			if (_state == state)
			{
				return;
			}
			if (this.enabled || state == ButtonState.DISABLED)
			{
				_state = state;
				this.invalidate(InvalidationType.STATE);
				this.invalidate(InvalidationType.SIZE);
			}
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.STATE))
			{
				this.drawSkin();
			}
			
			if (this.isInvalid(InvalidationType.SIZE))
			{
				this.drawLayout();
			}
			
			super.draw();
		}
		
		protected function drawSkin():void
		{
			this.gotoAndStop(_state);
			var skinName:String = _state + "Skin";
			if (this[skinName])
			{
				this.currentSkin = this[skinName];
			}
		}
		
		protected function drawLayout():void
		{
			// 背景皮肤
			if (this.currentSkin)
			{
				this.currentSkin.width = this.width;
				this.currentSkin.height = this.height;
			}
		}
		
		override public function dispose():void
		{
			// 事件
			this.removeEventListener(MouseEvent.CLICK, this.onMouseClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
			
			// 置空
			this.currentSkin = null;
			
			super.dispose();
		}
		
	}
	
}
