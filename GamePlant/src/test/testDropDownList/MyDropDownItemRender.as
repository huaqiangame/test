/**
 * Created by Administrator on 2016/7/6 0006.
 */
package test.testDropDownList
{
	import com.tencent.morefun.naruto.plugin.ui.base.ItemRenderer;
	import com.test.McDropItemSkin;

	import flash.display.DisplayObject;

	public class MyDropDownItemRender extends ItemRenderer
	{
		public function MyDropDownItemRender(skin:DisplayObject = null)
		{
			super(new McDropItemSkin());
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			view.txt.text = value.toString();
		}

		protected function get view():McDropItemSkin
		{
			return m_skin as McDropItemSkin;
		}
	}
}
