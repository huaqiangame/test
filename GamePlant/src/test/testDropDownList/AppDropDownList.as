/**
 * Created by Administrator on 2016/7/6 0006.
 */
package test.testDropDownList
{
	import com.tencent.morefun.naruto.plugin.ui.base.DropDownList;
	import com.test.McScrollSkin;

	import flash.display.Sprite;

	public class AppDropDownList extends Sprite
	{
		public static const TITLE:String = "DropDownList";

		private var dropDownList:DropDownList;

		public function AppDropDownList()
		{
			super();
			var datas:Array = ["武器", "服装", "首饰", "宠物", "宝石"];
			datas = datas.concat(datas).concat(datas);


			var bg:Sprite=new Sprite();
			bg.graphics.clear();
			bg.graphics.beginFill(0xff0000);
			bg.graphics.drawRect(0,0,150,200);
			bg.graphics.endFill();

			dropDownList = new DropDownList(5, MyDropDownItemRender, null, new McScrollSkin(), bg, datas[0]);
			this.addChild(dropDownList);
			dropDownList.source = datas;
		}
	}
}
