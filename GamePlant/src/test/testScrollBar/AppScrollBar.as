/**
 * Created by Administrator on 2016/7/5 0005.
 */
package test.testScrollBar
{
	import com.tencent.morefun.naruto.plugin.ui.base.Grid;
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollBar;
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollWindow;
	import com.tencent.morefun.naruto.plugin.ui.base.event.ScrollBarEvent;
	import com.test.McScrollSkin;

	import flash.display.Sprite;

	import test.MyGridItemRender;

	public class AppScrollBar extends Sprite
	{
		public static const TITLE:String = "ScrollBar+ScrollWindow+DirectionGrid";

		private var grid:Grid;

		public function AppScrollBar()
		{
			super();

			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x333333);
			bg.graphics.drawRect(0, 0, 600, 400);
			bg.graphics.endFill();

			grid = new Grid(1, 8, MyGridItemRender, null, bg);
			grid.vergap = 5;

			var datas:Array = [];
			for (var i:int = 0; i < 10; i++)
			{
				var obj:Object = {
					"name": "张三" + i,
					"level": "lv" + (i + 1),
					"family": "江湖岁月",
					"online": new Date().toDateString()
				};
				datas.push(obj);
				grid.addItem(i, 0, obj);
			}
//			grid.source = datas;

			scrollBar = new ScrollBar(new McScrollSkin(), "vertical", true);

			m_listWindow = new ScrollWindow(grid, null, scrollBar, true);
			scrollBar.x = 600 - 28;
			this.addChild(m_listWindow);
		}

		private var scrollBar:ScrollBar;
		private var m_listWindow:ScrollWindow;

		private function onValueChange(event:ScrollBarEvent):void
		{
		}
	}
}