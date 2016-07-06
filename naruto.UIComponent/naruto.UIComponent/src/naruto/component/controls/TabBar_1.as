package naruto.component.controls
{
	import flash.display.MovieClip;
	
	import naruto.component.core.ToggleButtonGroup;
	
	public class TabBar_1 extends ToggleButtonGroup
	{
		public var bgSkin:MovieClip;
		
		public function TabBar_1()
		{
			super(TabBarButton_1);
		}
		
		/**
		 * 获取当前的所有页签按钮，类型是 TabBarButton_1
		 */
		public function get tabBarButtons():Array
		{
			return buttons;
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.bgSkin = null;
			
			super.dispose();
		}
		
	}
}