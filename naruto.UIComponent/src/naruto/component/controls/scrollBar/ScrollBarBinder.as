package naruto.component.controls.scrollBar 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import naruto.component.core.BaseScrollBar;
	/**
	 * 滚动条与滚动目标衔接的逻辑类
	 * @author fixchen
	 */
	public class ScrollBarBinder
	{
		protected var bar:BaseScrollBar;
		protected var target:DisplayObject;
		protected var rect:Rectangle;
		protected var targetHeight:Number;
		
		/**
		 * @param	bar 哪个滚动条
		 * @param	target 目标显示对象
		 * @param	targetRect 显示对象的呈现大小，默认值为 {0 0 target.width bar.height}
		 */
		public function ScrollBarBinder(bar:BaseScrollBar, target:DisplayObject, targetRect:Rectangle=null)
		{
			this.bar = bar;
			this.target = target;
			this.targetHeight = target.height;
			this.rect = targetRect || new Rectangle(0, 0, target.width, bar.height);
			
			if (this.target is InteractiveObject)
			{
				(this.target as InteractiveObject).addEventListener(MouseEvent.MOUSE_WHEEL, onTargetMouseWheel);
			}
			this.bar.addEventListener(Event.CHANGE, onBarChange);
			this.targetHeightUpdate();
			this.update();
		}
		
		/**
		 * 目标显示对象的高度发生变化的时候，需要调用一下，为的是修改滚动条里的滚动块改变大小
		 */
		public function targetHeightUpdate():void
		{
			this.bar.viewAreaPercent = this.rect.height / this.target.height;
		}
		
		protected function onTargetMouseWheel(e:MouseEvent):void
		{
			if (e.delta > 0)
			{
				this.bar.scrollPercent -= this.bar.viewAreaPercent * 0.5;
			}else 
			{
				this.bar.scrollPercent += this.bar.viewAreaPercent * 0.5;
			}
		}
		
		protected function onBarChange(e:Event):void 
		{
			this.rect.y = int((this.targetHeight - this.rect.height) * this.bar.scrollPercent);
			this.update();
		}
		
		protected function update():void
		{
			this.target.scrollRect = null;
			this.target.scrollRect = rect;
		}
		
		public function dispose():void
		{
			this.bar.removeEventListener(Event.CHANGE, onBarChange);
			this.bar = null;
			if (this.target is InteractiveObject)
			{
				(this.target as InteractiveObject).removeEventListener(MouseEvent.MOUSE_WHEEL, onTargetMouseWheel);
			}
			this.target = null;
			this.rect = null;
		}
	}

}