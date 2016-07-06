/**
 * Created by Administrator on 2016/7/5 0005.
 */
package test.testNumberStepper
{
	import com.tencent.morefun.naruto.plugin.ui.base.NumberStepper;
	import com.tencent.morefun.naruto.plugin.ui.base.event.NumberStepperEvent;
	import com.test.McStepper;

	import flash.display.Sprite;

	public class AppNumberStepper extends Sprite
	{
		public static const TITLE:String = "NumberStepper";

		private var stepper:NumberStepper;

		public function AppNumberStepper()
		{
			super();

			stepper = new NumberStepper(new McStepper());
			this.addChild(stepper);
			stepper.min = 1;
			stepper.max = 5;
			stepper.value = 1;
			stepper.addEventListener(NumberStepperEvent.NUMBER_STEPPER_VALUE_CHANGED, onChange);
		}

		private function onChange(event:NumberStepperEvent):void
		{
			trace(event.newValue + "/" + stepper.max);
		}
	}
}
