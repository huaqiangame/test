package naruto.component.core
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 滚动条基类。
	 * @author yboyjiang
	 */	
	public class BaseScrollBar extends UIComponent implements IScrollable
	{
		protected const VIEW_AREA_STEP:Number = 0.5; // 0.5 表示每次滚动半页
		
		protected var _upArrowButton:Button;
		protected var _downArrowButton:Button;
		protected var _thumbArrowButton:Button;
		protected var _background:MovieClip;
		protected var _scrollPercent:Number = 0;
		protected var _viewAreaPerscent:Number = 1;
		
		public function BaseScrollBar()
		{
			super();
		}
		
		public function get scrollPercent():Number
		{
			return _scrollPercent;
		}
		
		public function set scrollPercent(value:Number):void
		{
			value = this.viewAreaPercent < 1 ? Math.max(0, Math.min(value, 1)) : 0;
			if (value != _scrollPercent)
			{
				_scrollPercent = value;
				this.invalidate(InvalidationType.SCROLL);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get viewAreaPercent():Number
		{
			return _viewAreaPerscent;
		}
		
		public function set viewAreaPercent(value:Number):void
		{
			value = Math.max(0, Math.min(value, 1));
			if (value != _viewAreaPerscent)
			{
				_viewAreaPerscent = value;
				this.invalidate(InvalidationType.SIZE);
			}
		}
		
		override public function set enabled(value:Boolean):void 
		{
			this._upArrowButton.enabled = value;
			this._thumbArrowButton.visible = value;
			this._downArrowButton.enabled = value;
			super.enabled = value;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			this._upArrowButton = this["upArrowButton"];
			this._downArrowButton = this["downArrowButton"];
			this._thumbArrowButton = this["thumbArrowButton"];
			this._background = this["background"];
			if (!this._upArrowButton)
			{
				throw new Error("组件里找不到 upArrowButton 实例。");
			}
			else if (!this._downArrowButton)
			{
				throw new Error("组件里找不到 downArrowButton 实例。");
			}
			else if (!this._thumbArrowButton)
			{
				throw new Error("组件里找不到 thumbArrowButton 实例。");
			}
			else if (!this._background)
			{
				throw new Error("组件里找不到 background 实例。");
			}
			else if (this._upArrowButton && this._downArrowButton && this._thumbArrowButton && this._background)
			{
				this._upArrowButton.addEventListener(MouseEvent.CLICK, this.onUp);
				this._downArrowButton.addEventListener(MouseEvent.CLICK, this.onDown);
				this._thumbArrowButton.addEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
			}
		}
		
		protected function onUp(event:MouseEvent):void
		{
			this.scrollPercent -= this.viewAreaPercent * VIEW_AREA_STEP;
		}
		
		protected function onDown(event:MouseEvent):void
		{
			this.scrollPercent += this.viewAreaPercent * VIEW_AREA_STEP;
		}
		
		
		
		// 滚动条。
		protected var _mouseDownStageY:int;
		protected var _oldThumbY:int;
		protected var _stage:Stage;
		protected function onThumbMouseDown(event:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onStageMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.onStageMouseMoveEnd);
			this.stage.addEventListener(MouseEvent.ROLL_OUT, this.onStageMouseMoveEnd);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.onStageMouseMoveEnd);
			this._mouseDownStageY = this.stage.mouseY;
			this._oldThumbY = this._thumbArrowButton.y;
			this._stage = this.stage;
		}
		// 拖动。
		protected function onStageMouseMove(event:MouseEvent):void
		{
			var dy:int = this.stage.mouseY - this._mouseDownStageY;
			this.scrollPercent = (this._oldThumbY - this._upArrowButton.height + dy)/(this._background.height-this._thumbArrowButton.height);
		}
		// 结束拖动。
		protected function onStageMouseMoveEnd(event:MouseEvent):void
		{
			this._stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onStageMouseMove);
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.onStageMouseMoveEnd);
			this._stage.removeEventListener(MouseEvent.ROLL_OUT, this.onStageMouseMoveEnd);
			this._stage = null;
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onStageMouseMoveEnd);
		}
		
		
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.SIZE))
			{
				this._downArrowButton.y = this.height;
				this._background.y = this._upArrowButton.height;
				this._background.height = this.height - this._upArrowButton.height - this._downArrowButton.height;
				this._thumbArrowButton.height = int(this._background.height * this.viewAreaPercent);
			}
			
			if (this.isInvalid(InvalidationType.SCROLL))
			{
				this._thumbArrowButton.y = int((this._background.height-this._thumbArrowButton.height)*this.scrollPercent+this._upArrowButton.height);
			}
			super.draw();
		}
		
		override public function dispose():void
		{
			// 事件
			this._upArrowButton.removeEventListener(MouseEvent.CLICK, this.onUp);
			this._downArrowButton.removeEventListener(MouseEvent.CLICK, this.onDown);
			this._thumbArrowButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
			if (this.stage)
			{
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onStageMouseMove);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onStageMouseMoveEnd);
				this.stage.removeEventListener(MouseEvent.ROLL_OUT, this.onStageMouseMoveEnd);
			}
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onStageMouseMoveEnd);
			
			// 置空
			this._upArrowButton.dispose();
			this._downArrowButton.dispose();
			this._thumbArrowButton.dispose();
			this._upArrowButton = null;
			this._downArrowButton = null;
			this._thumbArrowButton = null;
			this._background.stop();
			this._background = null;
			
			super.dispose();
		}
		
	}
}