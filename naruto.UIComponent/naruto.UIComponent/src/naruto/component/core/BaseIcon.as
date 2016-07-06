package naruto.component.core
{
	public class BaseIcon extends UIComponent
	{
		public function BaseIcon()
		{
			super();
		}
		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.SIZE))
			{
				if (this["skin"])
				{
					this["skin"].width = this.width;
					this["skin"].height = this.height;
				}
			}
			super.draw();
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			
			super.dispose();
		}
		
	}
	
}
