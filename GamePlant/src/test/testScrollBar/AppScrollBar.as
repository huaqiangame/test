/**
 * Created by Administrator on 2016/7/5 0005.
 */
package test.testScrollBar
{
	import flash.display.Sprite;

	public class AppScrollBar extends Sprite
	{
		public static const TITLE:String = "ScrollBar+ScrollWindow+DirectionGrid";

		public function AppScrollBar()
		{
			super();

			var scro:MyScrollContent=new MyScrollContent();
			this.addChild(scro);
		}
	}
}