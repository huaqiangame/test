package naruto.component.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import naruto.component.core.BaseListItemRenderer;
	import naruto.component.core.InvalidationType;
	import naruto.component.core.enum.ButtonState;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 下拉菜单的列表项渲染器。
	 * @author yboyjiang
	 */	
	public class ComboBoxListItemRenderer_1 extends BaseListItemRenderer
	{
		public static const TEXT_COLOR_OVER:String = "#675B46";
		
		public var textField:TextField;
		public var bg:DisplayObject;
		
		protected const paddingLeft:int = 2;
		protected const paddingRight:int = 2;
		
		protected var currentState:String;
		protected var _dataKey:String;
		
		public function ComboBoxListItemRenderer_1()
		{
			super();
			this.currentState = ButtonState.UP;
			this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			this.addEventListener(MouseEvent.CLICK, this.onClick);
			this.bg.visible = false;
		}
		
		public function get dataKey():String 
		{
			return _dataKey;
		}
		
		public function set dataKey(value:String):void 
		{
			_dataKey = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		
		protected function onClick(event:MouseEvent):void
		{
			this.selected = true;
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			this.currentState = ButtonState.OVER;
			this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			this.invalidate(InvalidationType.STATE);
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			this.currentState = ButtonState.UP;
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			this.invalidate(InvalidationType.STATE);
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.STATE))
			{
				this.textField.htmlText = "<font color='"+TEXT_COLOR_OVER+"'><b>"+(this.dataKey?this.data[dataKey]:this.data)+"</b></font>";
				if (this.currentState == ButtonState.OVER || this.selected)
				{
					this.bg.visible = true;
				}else 
				{
					this.bg.visible = false;
				}
			}
			
			if (this.isInvalid(InvalidationType.SIZE))
			{
				this.textField.x = this.paddingLeft;
				this.textField.width = this.width - this.paddingLeft - this.paddingRight;
				this.bg.width = this.width;
			}
			
			super.draw();
		}
		
		override public function dispose():void
		{
			// 事件
			this.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			this.removeEventListener(MouseEvent.CLICK, this.onClick);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			
			// 置空
			this.textField = null;
			this.bg = null;
			this._dataKey = null;
			
			super.dispose();
		}
		
	}
}