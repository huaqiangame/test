package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.tencent.morefun.naruto.plugin.battle.event.ValueBarEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	public class MultiCompoundValueBar extends EventDispatcher
	{
		private var res:MovieClip;
		private var backgroundLayer:DisplayObject;
		
		private var layerNum:int;
		private var layerValue:int;
		
		private var curRealValue:int;
		private var curDelayRealValue:int;
		
		private var valueLayers:Array = [];
		
		private var _curValue:int;
		private var _maxValue:int;
		public function MultiCompoundValueBar(layerNum:int, layerValue:int, res:MovieClip)
		{
			super();
			
			this.layerNum = layerNum;
			this.layerValue = layerValue;
			
			var compoundValueBar:CompoundValueBar;
			for(var i:int = 0;i < layerNum;i ++)
			{
				compoundValueBar = new CompoundValueBar(res["valueBar" + i]);
				compoundValueBar.addEventListener(ValueBarEvent.COMPOUND_VALUE_BAR_UPDATE, onValueBarUpdate);
				compoundValueBar.addEventListener(ValueBarEvent.COMPOUND_VALUE_BAR_COMPLETE, onValueBarComplete);
				compoundValueBar.addEventListener(ValueBarEvent.COMPOUND_DELAY_VALUE_BAR_UPDATE, onDelayValueBarUpdate);
				compoundValueBar.addEventListener(ValueBarEvent.COMPOUND_DELAY_VALUE_BAR_COMPLETE, onDelayValueBarComplete);
				compoundValueBar.updateImmediately(0, layerValue);
				valueLayers.push(compoundValueBar);
			}
			
			backgroundLayer = res["backgroundValueBar"];
			backgroundLayer.visible = false;
		}
		
		public function zeroValue():void
		{
			for each(var compoundValueBar:CompoundValueBar in valueLayers)
			{
				compoundValueBar.zeroValue();
			}
			
			backgroundLayer.visible = false;
		}
		
		public function show():void
		{
			for each(var compoundValueBar:CompoundValueBar in valueLayers)
			{
				compoundValueBar.show();
			}
			
			backgroundLayer.alpha = 1;
		}
		
		public function hide():void
		{
			for each(var compoundValueBar:CompoundValueBar in valueLayers)
			{
				compoundValueBar.hide();
			}
			
			backgroundLayer.alpha = 0;
		}
		
		public function update(curValue:int, maxValue:int):void
		{
			this._curValue = curValue;
			this._maxValue = maxValue;
			
			getCurCompoundValueBar().stop();
			updateToDestValue();
		}
		
		public function updateImmediately(curValue:int, maxValue:int):void
		{
			var curIndex:int;
			var compoundValueBar:CompoundValueBar;
			
			getCurCompoundValueBar().stop();
			
			this._curValue = curValue;
			this._maxValue = maxValue;
			this.curRealValue = curValue;
			this.curDelayRealValue = curValue;
			
			curIndex = getCurCompoundValueBarIndex();
			for(var i:int = 0;i < curIndex;i ++)
			{
				compoundValueBar = valueLayers[i];
				compoundValueBar.reset();
			}
			
			for(var j:int = layerNum;j > curIndex;j --)
			{
				compoundValueBar = valueLayers[j];
				compoundValueBar.clear();
			}
			
			compoundValueBar = getCurCompoundValueBar();
			compoundValueBar.updateImmediately(curRealValue % layerValue, layerValue);
			backgroundLayer.visible = curRealValue >= layerValue * layerNum;
		}
		
		public function get curValue():int
		{
			return _curValue;
		}
		
		public function get maxValue():int
		{
			return _maxValue;
		}
		
		public function destory():void
		{
			for each(var compoundValueBar:CompoundValueBar in valueLayers)
			{
				compoundValueBar.removeEventListener(ValueBarEvent.COMPOUND_VALUE_BAR_UPDATE, onValueBarUpdate);
				compoundValueBar.removeEventListener(ValueBarEvent.COMPOUND_VALUE_BAR_COMPLETE, onValueBarComplete);
				compoundValueBar.removeEventListener(ValueBarEvent.COMPOUND_DELAY_VALUE_BAR_UPDATE, onDelayValueBarUpdate);
				compoundValueBar.removeEventListener(ValueBarEvent.COMPOUND_DELAY_VALUE_BAR_COMPLETE, onDelayValueBarComplete);
				
				compoundValueBar.destory();
			}
		}
		
		private function onValueBarUpdate(evt:ValueBarEvent):void
		{
			var compoundValueBar:CompoundValueBar;
			
			compoundValueBar = evt.currentTarget as CompoundValueBar;
			curRealValue = compoundValueBar.index * layerValue + compoundValueBar.curRealValue;
		}
		
		private function onValueBarComplete(evt:ValueBarEvent):void
		{
			var compoundValueBar:CompoundValueBar;
			
			compoundValueBar = evt.currentTarget as CompoundValueBar;
			curRealValue = compoundValueBar.index * layerValue + compoundValueBar.curRealValue;
		}
		
		private function onDelayValueBarUpdate(evt:ValueBarEvent):void
		{
			var compoundValueBar:CompoundValueBar;
			
			compoundValueBar = evt.currentTarget as CompoundValueBar;
			curDelayRealValue = compoundValueBar.index * layerValue + compoundValueBar.curDelayRealValue;
		}
		
		private function onDelayValueBarComplete(evt:ValueBarEvent):void
		{
			var compoundValueBar:CompoundValueBar;
			
			compoundValueBar = evt.currentTarget as CompoundValueBar;
			curDelayRealValue = compoundValueBar.index * layerValue + compoundValueBar.curRealValue;
			updateToDestValue();
		}
		
		private function updateToDestValue():void
		{
			var curLayerIndex:int;
			var compoundValueBar:CompoundValueBar;
			
			if(curRealValue < _curValue)
			{
				var nextDestValue:int;
				
				curLayerIndex = Math.floor(curRealValue /  layerValue);
				if(curRealValue % layerValue == 0 &&
					Math.floor(curRealValue / layerValue) % layerNum == 0)
				{
					clearAllLater();
				}
				
				compoundValueBar = getCurCompoundValueBar();
				
				nextDestValue = curValue - curRealValue;
				nextDestValue = nextDestValue + compoundValueBar.curRealValue;
				nextDestValue = Math.min(nextDestValue, layerValue);
				
				compoundValueBar.update(nextDestValue, layerValue);
				compoundValueBar.index = Math.floor(curRealValue / layerValue);
			}
			
			if(curRealValue > _curValue)
			{
				var previousDestValue:int;
				
				curLayerIndex = Math.floor(curValue /  layerValue);
				if(curRealValue % layerValue == 0 &&
					Math.floor(curRealValue / layerValue) % layerNum == 0)
				{
					clearAllLater();
				}
				
				if(curRealValue % layerValue != 0)
				{
					compoundValueBar = getCurCompoundValueBar();
				}
				else
				{
					compoundValueBar = getPreviousCompoundValueBar();
				}
				
				previousDestValue = curRealValue - curValue;
				previousDestValue = compoundValueBar.curRealValue - previousDestValue;
				previousDestValue = Math.max(0, previousDestValue);
				
				compoundValueBar.update(previousDestValue, layerValue);
				compoundValueBar.index = Math.floor(curRealValue / layerValue);
			}
			
			backgroundLayer.visible = curRealValue >= layerValue * layerNum;
		}
		
		/**
		 * 5000,4000,3000,2000,1000
		 * @return 
		 * 
		 */		
		private function getNextCompoundValueBar():CompoundValueBar
		{
			var curIndex:int;
			
			curIndex = getCurCompoundValueBarIndex();
			if(curIndex == 0)
			{
				return valueLayers[layerNum - 1];
			}
			
			return valueLayers[curIndex - 1];
		}
		
		/**
		 * 1000,2000,3000,4000,5000
		 * @return 
		 * 
		 */		
		private function getPreviousCompoundValueBar():CompoundValueBar
		{
			var curIndex:int;
			
			curIndex = getCurCompoundValueBarIndex();
			if(curIndex == (layerNum - 1))
			{
				return valueLayers[0];
			}
			
			return valueLayers[curIndex + 1];
		}
		
		private function getCurCompoundValueBar():CompoundValueBar
		{
			return valueLayers[getCurCompoundValueBarIndex()];
		}
		
		/**
		 *[0, 1000) 
		 * @return 
		 * 
		 */		
		private function getCurCompoundValueBarIndex():int
		{
			var compoundValueBarIndex:int;
			
			compoundValueBarIndex = Math.floor(curRealValue / layerValue);
			compoundValueBarIndex = compoundValueBarIndex % layerNum;
			
			return compoundValueBarIndex;
		}
		
		private function clearAllLater():void
		{
			for each(var compoundValueBar:CompoundValueBar in valueLayers)
			{
				compoundValueBar.updateImmediately(0, layerValue);
			}
		}
																
		public function autoSetNull():void
		{

			res = null;
			backgroundLayer = null;
			valueLayers = null;
		}
	}
}