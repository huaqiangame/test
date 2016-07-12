/**
 * Created by Administrator on 2016/7/8 0008.
 */
package test.testTabBar
{
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.base.TabBar;
	import com.tencent.morefun.naruto.plugin.ui.base.event.TabBarEvent;
	import com.test.McTabBtn;
	import com.test.McTestTabBar;

	import flash.display.Sprite;
	import flash.text.TextField;

	public class AppTabBar extends Sprite
	{
		public static const TITLE:String = "TabBar";

		private var tabBar:TabBar;
		private var lastTab:McTabBtn;

		private var panelSkin:McTestTabBar;

		private var tf:TextField;
		private var tabNames:Array;

		public function AppTabBar()
		{
			super();
			panelSkin = new McTestTabBar();
			this.addChild(panelSkin);

			var baseBtns:Array = [];
			tabNames = ["武器", "服装", "首饰", "珠宝"];

			for (var i:int = 0; i < tabNames.length; i++)
			{
				var mc:McTabBtn = panelSkin["tab" + i];
				mc.selectedTxt.text = tabNames[i];
				mc.textField.text = tabNames[i];
				mc.selectedTxt.visible = false;
				baseBtns.push(new BaseButton(mc));
			}
			tabBar = new TabBar(baseBtns[0], baseBtns[1], baseBtns[2], baseBtns[3]);
			this.addChild(tabBar);

			tf = new TextField();
			tf.autoSize = "left";
			tf.width = 500;
			tf.height = 400;
			tf.mouseEnabled = false;
			tf.x = 100;
			tf.y = 100;
			this.addChild(tf);


			tabBar.addEventListener(TabBarEvent.TAB_SELECTED_INDEX_CHANGED, onSelectChange);
			tabBar.selectedIndex = 0;
		}

		private function onSelectChange(event:TabBarEvent):void
		{
			if (lastTab)
			{
				lastTab.selectedTxt.visible = false;
				lastTab.textField.visible = true;
				lastTab = null;
			}
			lastTab = panelSkin["tab" + event.selectedIndex];
			lastTab.selectedTxt.visible = true;
			lastTab.textField.visible = false;

			var colors:Array = [0xff0000, 0xffcc00, 0xff00ff, 0x00ffff, 0xffff00];
			var color:uint = colors[int(Math.random() * colors.length)];
			tf.textColor = color;

			tf.htmlText = "<font size=\'30\'>" + "切换了 " + tabNames[event.selectedIndex] + "</font>";
		}
	}
}
