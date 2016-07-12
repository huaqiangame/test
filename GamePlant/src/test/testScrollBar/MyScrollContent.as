/**
 * Created by Administrator on 2016/7/7 0007.
 */
package test.testScrollBar
{
	import com.test.McGridRow;
	import com.test.McMyPanel;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import scrollBar.IScrollee;
	import scrollBar.ScrollBar;

	public class MyScrollContent extends Sprite implements IScrollee
	{
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _contentHeight:int;

		private var skin:McMyPanel;

		public function MyScrollContent()
		{
			skin = new McMyPanel();
			skin.mcTitle.textField.text = "排行榜";
			this.addChild(skin);

			for (var i:int = 0; i < 20; i++)
			{
				var mc:McGridRow = new McGridRow();
				mc.mouseChildren = false;
				mc.bg.stop();
				skin.mcContainer.addChild(mc);
				mc.y = mc.height * i;
				mc.txtLv.text = "lv" + (i + 1);
			}
			_scrollRect = new Rectangle(0, 0, skin.mcContainer.width, 450);
			skin.mcContainer.scrollRect = _scrollRect;

			_contentHeight = skin.mcContainer.height;

			initScroll(skin.scrollbar);
		}

		public function initScroll(mc:MovieClip):void
		{
			_scrollBar = new ScrollBar(this, mc, 0, skin.mcContainer, 15);
			_scrollBar.resetHeight(_scrollRect.height);
			_scrollBar.resetScroll();
		}

		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			skin.mcContainer.scrollRect = _scrollRect;
		}

		public function get contentHeight():int
		{
			return _contentHeight;
		}

		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}

		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
	}
}
