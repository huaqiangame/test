/**
 * Created by Administrator on 2016/7/7 0007.
 */
package test.testTree
{
	import com.tencent.morefun.naruto.plugin.ui.base.TreeRenderer;
	import com.test.McTree;

	import flash.display.MovieClip;

	public class MyTreeRender extends TreeRenderer
	{
		public function MyTreeRender(skin:MovieClip)
		{
			super(skin);
			view.mcBar.stop();
			selected = true;
			view.txt.mouseEnabled=false;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			if (value)
			{
				view.txt.text = value.name;
			}
		}

		override public function set open(value:Boolean):void
		{
			super.open = value;
			trace("open " + id);
			if (view)
			{
				var frame:int;
				if (id == "1")
				{
					frame = value ? 2 : 1;
				} else
				{
					frame = 2;
				}
				view.mcBar.gotoAndStop(frame);
			}
		}

		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			if (view)
			{
				var frame:int = value ? 2 : 1;
				view.bg.gotoAndStop(frame);
			}
		}

		override public function set id(value:String):void
		{
			super.id = value;
		}

		public function get view():McTree
		{
			return skin as McTree;
		}

	}
}
