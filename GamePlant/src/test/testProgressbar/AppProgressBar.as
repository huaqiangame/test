/**
 * Created by Administrator on 2016/7/6 0006.
 */
package test.testProgressbar
{
	import com.tencent.morefun.naruto.plugin.ui.base.ProgressBar;
	import com.tencent.morefun.naruto.plugin.ui.base.event.ProgressBarEvent;
	import com.tes.McProgressSkin;

	import flash.display.Sprite;
	import flash.events.Event;

	public class AppProgressBar extends Sprite
	{
		public static const TITLE:String = "ProgressBar";

		public function AppProgressBar()
		{
			super();
			var skin:McProgressSkin = new McProgressSkin();
			var progress:ProgressBar = new ProgressBar(skin);
			this.addChild(progress);
			progress.min = 0;
			progress.max = 100;
			progress.step = 1;

			progress.addEventListener(ProgressBarEvent.PROGRESS_BAR_PROGRESS_COMPLETE, function (ev:ProgressBarEvent):void
			{
				progress.removeEventListener(Event.ENTER_FRAME, onEnter);
			})
			progress.addEventListener(Event.ENTER_FRAME, onEnter);
		}

		private function onEnter(event:Event):void
		{
			var temp:int=event.target.value;
			temp++;
			temp=temp>=100?100:temp;
			event.target.value=temp;
		}
	}
}
