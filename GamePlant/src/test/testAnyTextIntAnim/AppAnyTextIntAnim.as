/**
 * Created by Administrator on 2016/7/5 0005.
 */
package test.testAnyTextIntAnim
{
	import com.tencent.morefun.naruto.plugin.ui.base.AnyTextIntAnim;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class AppAnyTextIntAnim extends Sprite
	{
		public static const TITLE:String = "测试 AnyTextIntAnim";

		public function AppAnyTextIntAnim()
		{
			super();

			var tf:TextField = new TextField();
			this.addChild(tf);
			tf.autoSize = "left";

			var anyTxt:AnyTextIntAnim = new AnyTextIntAnim(tf, function ():void
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
