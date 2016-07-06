/**
 * Created by Administrator on 2016/7/5 0005.
 */
package test.testBitmapText
{
	import com.tencent.morefun.naruto.plugin.ui.base.BitmapTextIntAnim;
	import com.tencent.morefun.naruto.plugin.ui.base.BitmapTextRandomIntAnim;
	import com.tencent.morefun.naruto.plugin.ui.base.NumberBitmapText;
	import com.tencent.morefun.naruto.plugin.ui.base.NumberBitmapTextStyle;
	import com.tencent.morefun.naruto.plugin.ui.base.VBox;

	import flash.display.Sprite;

	public class AppBitmapText extends Sprite
	{
		public static const TITLE:String = "BitmapText";

		public function AppBitmapText()
		{
			super();

			var vBox:VBox = new VBox();
			vBox.vergap = 80;
			this.addChild(vBox);

			var bmpTxt:NumberBitmapText = new NumberBitmapText(NumberBitmapTextStyle.STYLE_1);
			vBox.addChild(bmpTxt);
			var bitTxtInitAnim:BitmapTextIntAnim = new BitmapTextIntAnim(bmpTxt);
			bitTxtInitAnim.start(1, 50);


			var bmpTxt1:NumberBitmapText = new NumberBitmapText(NumberBitmapTextStyle.STYLE_2);
			vBox.addChild(bmpTxt1);
			var bitTxtInitAnim1:BitmapTextIntAnim = new BitmapTextIntAnim(bmpTxt1);
			bitTxtInitAnim1.start(1, 100);


			var bmpTxt2:NumberBitmapText = new NumberBitmapText(NumberBitmapTextStyle.STYLE_3);
			vBox.addChild(bmpTxt2);
			var bitTxtInitAnim2:BitmapTextRandomIntAnim = new BitmapTextRandomIntAnim(bmpTxt2);
			bitTxtInitAnim2.start(1, 150);
		}
	}
}
