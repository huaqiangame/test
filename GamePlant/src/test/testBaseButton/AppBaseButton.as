/**
 * Created by Administrator on 2016/7/5 0005.
 */
package test.testBaseButton
{
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.base.HBox;
	import com.tencent.morefun.naruto.plugin.ui.base.VBox;
	import com.test.McMyButton;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class AppBaseButton extends Sprite
	{
		public static const TITLE:String = "BaseButton";

		public function AppBaseButton()
		{
			super();

			var vBox:VBox = new VBox();
			vBox.vergap = 100;
			this.addChild(vBox);

			var hbox1:HBox = new HBox();
			vBox.addChild(hbox1);

			hbox1.horgap = 100;
			var title1:TextField = getTxt("未选中时的按钮");
			hbox1.addChild(title1);

			var btn1:BaseButton = new BaseButton(new McMyButton(), false);
			hbox1.addChild(btn1);


			var hbox2:HBox = new HBox();
			hbox2.horgap = 100;
			vBox.addChild(hbox2);

			var title2:TextField = getTxt("选中按钮时");
			hbox2.addChild(title2);
			var btn2:BaseButton = new BaseButton(new McMyButton(), true);
			hbox2.addChild(btn2);
			btn2.selected = true;
			btn2.addEventListener(MouseEvent.CLICK, function ():void
			{
				title2.text = btn2.selected ? "选中按钮时" : "未选中按钮时";
			});
		}

		private function getTxt(value:String):TextField
		{
			var tf:TextField = new TextField();
			tf.autoSize = "left";
			tf.mouseEnabled = false;
			tf.text = value;
			return tf;
		}

	}
}
