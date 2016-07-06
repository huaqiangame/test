package com.tencent.morefun.naruto.plugin.ui.base.event
{
	import flash.events.Event;

	public class NumberStepperEvent extends Event
	{
		public static const NUMBER_STEPPER_VALUE_CHANGED:String = "numberStepperValueChanged";
		
		public var oldValue:Number;
		public var newValue:Number;
		public function NumberStepperEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}