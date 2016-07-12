/**
 * Created by Administrator on 2016/7/7 0007.
 */
package test.testDirectionGrid
{
	import com.tencent.morefun.naruto.plugin.ui.base.DirectionGrid;
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollBar;
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollWindow;
	import com.test.McGridRow;
	import com.test.McScrollSkin;

	import flash.display.Sprite;

	import test.MyGridItemRender;

	public class AppDirectionGrid extends Sprite
	{
		public static const TITLE:String = "DirectionGrid";

		private var scrollWindow:ScrollWindow;
		private var scrollBar:ScrollBar;
		private var directionGrid:DirectionGrid;

		public function AppDirectionGrid()
		{
			super();

			directionGrid = new DirectionGrid(10, 1, MyGridItemRender, McGridRow);
			directionGrid.verPageScrollValue=100;

			var datas:Array = [];
			for (var i:int = 0; i < 50; i++)
			{
				var obj:Object = {};
				obj.name = "李四" + (i + 1);
				obj.level = "lv" + (i + 1);
				obj.family = "风火连城";
				obj.online = new Date().toDateString();
				datas.push(obj);
			}
			directionGrid.source = datas;

			scrollBar = new ScrollBar(new McScrollSkin(), "vertical", false);
			scrollWindow = new ScrollWindow(directionGrid, null, scrollBar, true);
			this.addChild(scrollWindow);
			scrollBar.x = 600 - 25;
			scrollBar.height = 370;
		}
	}
}
