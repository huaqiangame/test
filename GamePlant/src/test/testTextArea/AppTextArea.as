/**
 * Created by Administrator on 2016/7/7 0007.
 */
package test.testTextArea
{
	import com.tencent.morefun.naruto.plugin.ui.base.ScrollBar;
	import com.tencent.morefun.naruto.plugin.ui.base.TextArea;
	import com.test.McScrollSkin;

	import flash.display.Sprite;
	import flash.text.TextField;

	public class AppTextArea extends Sprite
	{
		public static const TITLE:String = "TextArea";

		public function AppTextArea()
		{
			super();

			var scrollBar:ScrollBar = new ScrollBar(new McScrollSkin());

			var tf:TextField = new TextField();
			tf.width = 300;
			tf.height = 200;
			tf.multiline = true;
			tf.wordWrap = true;

			var textArea:TextArea = new TextArea(tf);
			textArea.verScrollBar = scrollBar;
			var msg:String = "aaaaaaaaaaaaaaaaaaaabbbbbbbbb\nbbbbbbbbbbbcccccccccccccccccccccdddd\nddddddddddddddddddddddd";
			msg += msg;
			msg += msg;
			msg += msg;
			msg += msg;
			msg += msg;
			msg += msg;
			textArea.text = msg;

			this.addChild(textArea);
			this.addChild(scrollBar);
			scrollBar.x = 300;
			scrollBar.height = 200;

		}
	}
}
