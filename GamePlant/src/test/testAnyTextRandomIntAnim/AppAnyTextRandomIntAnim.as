/**
 * Created by Administrator on 2016/7/5 0005.
 */
package test.testAnyTextRandomIntAnim
{
	import com.tencent.morefun.naruto.plugin.ui.base.AnyTextRandomIntAnim;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class AppAnyTextRandomIntAnim extends Sprite
	{
		public static const TITLE:String = "AnyTextRandomIntAnim";

		public function AppAnyTextRandomIntAnim()
		{
			super();

			var tf:TextField = new TextField();
			this.addChild(tf);
			tf.autoSize = "left";

			var anyTxt:AnyTextRandomIntAnim = new AnyTextRandomIntAnim(tf, function ():void
			{
				var format:TextFormat = tf.defaultTextFormat;
				format.size = 30;
				format.color = 0xff00;
				tf.setTextFormat(format);
			});
			anyTxt.start(0, 100);
		}
	}
}
