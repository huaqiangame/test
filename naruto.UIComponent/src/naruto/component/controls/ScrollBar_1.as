package naruto.component.controls
{
	import flash.display.MovieClip;
	
	import naruto.component.core.BaseScrollBar;
	import naruto.component.core.Button;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class ScrollBar_1 extends BaseScrollBar
	{
		public var upArrowButton:Button;
		public var downArrowButton:Button;
		public var thumbArrowButton:Button;
		public var background:MovieClip;
		
		public function ScrollBar_1()
		{
			super();
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.upArrowButton.dispose();
			this.upArrowButton = null;
			this.downArrowButton.dispose();
			this.downArrowButton = null;
			this.thumbArrowButton.dispose();
			this.thumbArrowButton = null;
			this.background = null;
			
			super.dispose();
		}
		
	}
}