package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.tencent.morefun.naruto.plugin.ui.core.CoreCompoundValueBar;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreMultiCompoundValueBar;
	import flash.display.MovieClip;

	public class HpBar
	{
		public static const TYPE_SINGLE:int = 0;
		public static const TYPE_MULTI:int = 1;
		public static const TYPE_MULTI_BOSS:int = 3;
		
		private static const LAYER_NUMBER:int = 5;
		private static const LAYER_VALUE:int = 1000;
		
		private var type:int;
		
		private var singleCompoundValueBar:CoreCompoundValueBar;
		private var multiCompoundValueBar:CoreMultiCompoundValueBar;
		
		private var res:MovieClip;
		private var warn:MovieClip;
		private var _lastMaxHp:int;
		private var _layerValue:int;
		
		public function HpBar(res:MovieClip)
		{
			this.res = res;
			this.warn = res.warn;
			
			singleCompoundValueBar = new CoreCompoundValueBar(res["singleValueBar"]);
			multiCompoundValueBar = new CoreMultiCompoundValueBar(LAYER_NUMBER, LAYER_VALUE, res["multiValueBar"]);
			
			setHpType(type);
		}
		
		public function showWarn():void
		{
			res.addChild(warn);
		}
		
		public function hideWarn():void
		{
			if(res.contains(warn))
			{
				res.removeChild(warn);
			}
		}
		
		public function zeroValue():void
		{
			singleCompoundValueBar.zeroValue();
			multiCompoundValueBar.zeroValue();
		}
		
		public function update(curValue:int, maxValue:int):void
		{
			if (type == TYPE_MULTI_BOSS && _lastMaxHp != maxValue && maxValue > 100) {
				_lastMaxHp = maxValue;
				_layerValue = Math.ceil(_lastMaxHp / 20);
				multiCompoundValueBar.layerValue = _layerValue;
				updateImmediately(curValue, maxValue);
				return;
			}
			singleCompoundValueBar.update(curValue, maxValue);
			multiCompoundValueBar.update(curValue, maxValue);
		}
		
		public function updateImmediately(curValue:int, maxValue:int):void
		{
			singleCompoundValueBar.updateImmediately(curValue, maxValue);
			multiCompoundValueBar.updateImmediately(curValue, maxValue);
		}
		
		public function setHpType(value:int):void
		{
			type = value;
			switch(type)
			{
				case TYPE_SINGLE:
					singleCompoundValueBar.show();
					multiCompoundValueBar.hide();
					break;
				case TYPE_MULTI:
					singleCompoundValueBar.hide();
					multiCompoundValueBar.show();
					break;
				case TYPE_MULTI_BOSS:
					singleCompoundValueBar.hide();
					multiCompoundValueBar.show();
					break;
			}
		}
		
		public function destory():void
		{
			res = null;
			warn = null;
			
			singleCompoundValueBar.destory();
			multiCompoundValueBar.destory();
		}
																
		public function autoSetNull():void
		{

			singleCompoundValueBar = null;
			multiCompoundValueBar = null;
			res = null;
			warn = null;
		}
	}
}