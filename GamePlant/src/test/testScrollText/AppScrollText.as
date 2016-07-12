/**
 * Created by Administrator on 2016/7/7 0007.
 */
package test.testScrollText
{
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollText;
	import com.tencent.morefun.naruto.plugin.ui.base.VBox;
	import com.tencent.morefun.naruto.plugin.ui.base.def.ScrollTextType;

	import flash.display.Sprite;

	public class AppScrollText extends Sprite
	{
		public static const TITLE:String = "ScrollText";

		public function AppScrollText()
		{
			super();

			var vBox:VBox = new VBox();
			vBox.vergap=100;
			this.addChild(vBox);

			var scrollText:ScrollText = new ScrollText();
			scrollText.addAppendText("我是ScrollText文本0001");
			vBox.addChild(scrollText);


			scrollText = new ScrollText();
			scrollText.addAppendText("我是ScrollText文本0002", ScrollTextType.FLY_SAKURA, "恭喜张三");
			vBox.addChild(scrollText);
		}
	}
}
