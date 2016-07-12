package naruto.component.core
{
	public class BaseBackground extends UIComponent
	{
		public function BaseBackground()
		{
			super();
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.SIZE))
			{
				this.drawLayout();
			}
			super.draw();
		}
		
		public function drawLayout():void
		{
			if (this["skin"])
			{
				this["skin"].width = this.width;
				this["skin"].height = this.height;
			}
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			
			super.dispose();
		}
		
	}
	
}
