package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.tencent.morefun.naruto.plugin.ui.core.CoreValueBar;
	import com.tencent.morefun.naruto.plugin.ui.core.event.ValueBarEvent;
	import flash.display.MovieClip;

	public class MpBar
	{
		private var fireRes:MovieClip;
		private var valueBarRes:MovieClip;
		private var valueBar:CoreValueBar;
		
		public function MpBar(valueBarRes:MovieClip, fireRes:MovieClip = null)
		{
			valueBar = new CoreValueBar(valueBarRes);
			
			this.fireRes = fireRes;
			this.valueBarRes = valueBarRes;
			
			if(fireRes != null)
			{
				valueBar.addEventListener(ValueBarEvent.UPDATE, onValueUpdate);
				valueBar.addEventListener(ValueBarEvent.COMPLETE, onValueComplete);
			}
		}
		
		public function zeroValue():void
		{
			valueBar.zeroValue();
		}
		
		public function update(curValue:int, maxValue:int):void
		{
			valueBar.update(curValue, maxValue);
		}
		
		public function updateImmediately(curValue:int, maxValue:int):void
		{
			valueBar.updateImmediately(curValue, maxValue);
		}
		
		private function onValueUpdate(evt:ValueBarEvent):void
		{
			fireRes.x = valueBarRes.x - valueBarRes.width;
			fireRes.visible = valueBar.curRealValue != 0;
		}
		
		private function onValueComplete(evt:ValueBarEvent):void
		{
			fireRes.x = valueBarRes.x - valueBarRes.width;
			fireRes.visible = valueBar.curRealValue != 0;
		}
		
		public function destroy():void
		{
			if(fireRes != null)
			{
				valueBar.removeEventListener(ValueBarEvent.UPDATE, onValueUpdate);
				valueBar.removeEventListener(ValueBarEvent.COMPLETE, onValueComplete);
			}
		}
																
		public function autoSetNull():void
		{

			fireRes = null;
			valueBarRes = null;
			valueBar = null;
		}
	}
}