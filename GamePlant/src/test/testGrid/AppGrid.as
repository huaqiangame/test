/**
 * Created by Administrator on 2016/7/7 0007.
 */
package test.testGrid
{
	import com.tencent.morefun.naruto.plugin.ui.base.Grid;
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollBar;
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollWindow;
	import com.test.McGridRow;
	import com.test.McScrollSkin;

	import flash.display.Sprite;

	import test.MyGridItemRender;

	public class AppGrid extends Sprite
	{
		public static const TITLE:String = "Grid";

		private var grid:Grid;
		private var scroller:ScrollBar;
		private var scrollWindow:ScrollWindow;

		public function AppGrid()
		{
			super();

			grid = new Grid(1, 10, MyGridItemRender, McGridRow);
			grid.verPageScrollValue=100;
			for (var i:int = 0; i < 50; i++)
			{
				var obj:Object={};
				obj.name="张三"+(i+1);
				obj.level="lv"+(i+1);
				obj.family="江湖风云";
				obj.online=new Date().toDateString();
				grid.addItem(i,0,obj);
			}

			scroller=new ScrollBar(new McScrollSkin(),"vertical",false);
			scroller.height=370;
			scroller.x=600-25;
			
			scrollWindow=new ScrollWindow(grid,null,scroller,true);
			this.addChild(scrollWindow);
		}
	}
}
