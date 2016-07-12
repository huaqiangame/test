/**
 * Created by Administrator on 2016/7/7 0007.
 */
package test.testColorBubbleUpText
{
	import com.tencent.morefun.naruto.plugin.ui.base.ColorBubbleUpText;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class AppColorBubbleUpText extends Sprite
	{
		public static const TITLE:String = "ColorBubbleUpText";

		public function AppColorBubbleUpText()
		{
			super();

			var tf:TextField = new TextField();
			tf.htmlText = "<font color='#ff' size='30'>单击舞台</font>";
			this.addChild(tf);
			tf.width = tf.textWidth;
			tf.mouseEnabled = false;


			var msgs:Array = ["ColorBubbleUpText0000000000001", "ColorBubbleUpText00000000002", "ColorBubbleUpText0000000003", "ColorBubbleUpText0000000000004"];
			var colorBubble:ColorBubbleUpText = new ColorBubbleUpText(0xff0000);
			this.addChild(colorBubble);
			addEventListener(Event.ADDED_TO_STAGE, function ():void
			{
				removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
				stage.addEventListener(MouseEvent.CLICK, function ():void
				{
					colorBubble.bubbleUp(msgs[int(Math.random() * msgs.length)]);
				});
			});
		}
	}
}
