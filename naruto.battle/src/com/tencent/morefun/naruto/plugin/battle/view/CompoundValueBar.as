package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.tencent.morefun.naruto.plugin.battle.event.ValueBarEvent;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	public class CompoundValueBar extends EventDispatcher
	{
		private var _index:int;
		
		private var valueBar:ValueBar;
		private var delayValyeBar:DelayValueBar;
		
		public function CompoundValueBar(res:MovieClip)
		{
			super();
			
			valueBar = new ValueBar(res["valueBar"]);
			delayValyeBar = new DelayValueBar(res["delayValueBar"]);
			
			valueBar.addEventListener(ValueBarEvent.UPDATE, onValueBarUpdate);
			valueBar.addEventListener(ValueBarEvent.COMPLETE, onValueBarComplete);
			delayValyeBar.addEventListener(ValueBarEvent.UPDATE, onDelayValueBarUpdate);
			delayValyeBar.addEventListener(ValueBarEvent.COMPLETE, onDelayValueBarComplete);
		}
		
		public function show():void
		{
			valueBar.show();
			delayValyeBar.show();
		}
		
		public function hide():void
		{
			valueBar.hide();
			delayValyeBar.hide();
		}

		public function get curRealValue():int
		{
			return valueBar.curRealValue;
		}
		
		public function get curDelayRealValue():int
		{
			return delayValyeBar.curRealValue;
		}
		
		public function get curValue():int
		{
			return valueBar.curValue;
		}
		
		public function get maxValue():int
		{
			return valueBar.maxValue;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function update(curValue:int, maxValue:int):void
		{
			valueBar.update(curValue, maxValue);
			delayValyeBar.update(curValue, maxValue);
		}
		
		public function updateImmediately(curValue:int, maxValue:int):void
		{
			valueBar.updateImmediately(curValue, maxValue);
			delayValyeBar.updateImmediately(curValue, maxValue);
		}
		
		public function stop():void
		{
			valueBar.stop();
			delayValyeBar.stop();
		}
		
		public function reset():void
		{
			valueBar.reset();
			delayValyeBar.reset();
		}
		
		public function clear():void
		{
			valueBar.clear();
			delayValyeBar.clear();
		}
		
		public function zeroValue():void
		{
			valueBar.zeroValue();
			delayValyeBar.zeroValue();
		}
		
		public function destory():void
		{
			valueBar.removeEventListener(ValueBarEvent.UPDATE, onValueBarUpdate);
			valueBar.removeEventListener(ValueBarEvent.COMPLETE, onValueBarComplete);
			delayValyeBar.removeEventListener(ValueBarEvent.UPDATE, onDelayValueBarUpdate);
			delayValyeBar.removeEventListener(ValueBarEvent.COMPLETE, onDelayValueBarComplete);
		}

		private function onValueBarUpdate(evt:ValueBarEvent):void
		{
			var event:ValueBarEvent;
			
			event = new ValueBarEvent(ValueBarEvent.COMPOUND_VALUE_BAR_UPDATE);
			dispatchEvent(event);
		}
		
		private function onValueBarComplete(evt:ValueBarEvent):void
		{
			var event:ValueBarEvent;
			
			event = new ValueBarEvent(ValueBarEvent.COMPOUND_VALUE_BAR_COMPLETE);
			dispatchEvent(event);
		}
		
		private function onDelayValueBarUpdate(evt:ValueBarEvent):void
		{
			var event:ValueBarEvent;
			
			event = new ValueBarEvent(ValueBarEvent.COMPOUND_DELAY_VALUE_BAR_UPDATE);
			dispatchEvent(event);
		}
		
		private function onDelayValueBarComplete(evt:ValueBarEvent):void
		{
			var event:ValueBarEvent;
			
			event = new ValueBarEvent(ValueBarEvent.COMPOUND_DELAY_VALUE_BAR_COMPLETE);
			dispatchEvent(event);
		}
																
		public function autoSetNull():void
		{

			valueBar = null;
			delayValyeBar = null;
		}
	}
}