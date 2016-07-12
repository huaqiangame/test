/**
 * Created by Administrator on 2016/7/8 0008.
 */
package test.testMyScrollContent
{
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollBar;
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollWindow;
	import com.test.McScrollSkin;

	import flash.display.Sprite;

	public class AppMyScrollContent extends Sprite
	{
		public static const TITLE:String = "MyScrollContent";

		public function AppMyScrollContent()
		{
			super();

			var bg:Sprite = new Sprite();
			bg.graphics.clear();
			bg.graphics.beginFill(0x333333);
			bg.graphics.drawRect(0, 0, 400, 400);
			bg.graphics.endFill();

			var myScroll:MyScrollContentContainer = new MyScrollContentContainer(bg, 400, 400);
			myScroll.verPageScrollValue = 200;
			var scrollBar:ScrollBar = new ScrollBar(new McScrollSkin());
			scrollBar.height = 400;
			scrollBar.x = 400;

			var scrollW:ScrollWindow = new ScrollWindow(myScroll, null, scrollBar);
			this.addChild(scrollW);
		}
	}
}
