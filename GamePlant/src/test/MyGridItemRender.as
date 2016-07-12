/**
 * Created by Administrator on 2016/7/5 0005.
 */
package test
{
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.test.McGridRow;

	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;

	public class MyGridItemRender extends ItemRenderer
	{
		public function MyGridItemRender(skin:DisplayObject = null)
		{
			super(skin);
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			var str:String = value.level;
			str = str.substr(2);
			if (int(str) <= 3)
			{
				view.bg.gotoAndStop(str);
			}
			else
			{
				view.bg.gotoAndStop(1);
			}
			view.txtName.text = value.name;
			view.txtLv.text = value.level;
			view.txtFamily.text = value.family;
			view.txtOnline.text = value.online;
		}


		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			if (value)
			{
				view.filters = [new GlowFilter()];
			} else
			{
				view.filters = null;
			}
		}

		protected function get view():McGridRow
		{
			return m_skin as McGridRow;
		}
	}
}
