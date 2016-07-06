package com.tencent.morefun.naruto.plugin.ui.core
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.ui.core.event.ValueBarEvent;
	import com.tencent.morefun.naruto.plugin.ui.util.TweenManager;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	public class CoreValueBar extends EventDispatcher
	{
		private var res:MovieClip;
		
		private var _curValue:int;
		private var _maxValue:int;
		
		public var curRealValue:int;
		
		public function CoreValueBar(res:MovieClip)	
		{
			super();
			
			this.res = res;
		}
		
		public function show():void
		{
			res.visible = true;
		}
		
		public function hide():void
		{
			res.visible = false;
		}
		
		public function get curValue():int
		{
			return _curValue;
		}
		
		public function get maxValue():int
		{
			return _maxValue;
		}
		
		public function stop():void
		{
			_curValue = curRealValue;
			TweenManager.killTweensOf(this);
		}
		
		public function reset():void
		{
			_curValue = curRealValue = _maxValue;
			
			res.scaleX = 1;
			TweenManager.killTweensOf(this);
		}
		
		public function clear():void
		{
			_curValue = _maxValue = curRealValue = 0;
			
			res.scaleX = 0;
			TweenManager.killTweensOf(this);
		}
		
		public function zeroValue():void
		{
			_curValue = 0;
			TweenManager.killTweensOf(this);
			
			update(0, maxValue);
		}
		
		public function updateImmediately(curValue:int, maxValue:int):void
		{
			var p:Number;
			
			if(this._curValue == curValue && this._maxValue == maxValue)
			{
				return ;
			}
			
			this._curValue = curValue;
			this._maxValue = maxValue;
			this.curRealValue = curValue;
			
			p = curValue / maxValue;
			
			TweenManager.killTweensOf(this);
			res.scaleX = p;
		}
		
		public function update(curValue:int, maxValue:int, time:Number = 0.3):void
		{
			var p:Number;
			
			if(this._curValue == curValue && this._maxValue == maxValue)
			{
				return ;
			}
			
			p = maxValue / Math.max(1, this._maxValue);
			curRealValue = curRealValue * p;
			
			this._curValue = curValue;
			this._maxValue = maxValue;
			
			TweenLite.killTweensOf(this);
			TweenLite.to(this,time,{curRealValue:curValue, onUpdate:onUpdate, onComplete:onComplete});
		}
		
		private function onUpdate():void
		{
			var p:Number;
			
			p = curRealValue / maxValue;
			res.scaleX = p;
			
			this.dispatchEvent(new ValueBarEvent(ValueBarEvent.UPDATE));
		}
		
		private function onComplete():void
		{
			var p:Number;
			
			p = curRealValue / maxValue;
			res.scaleX = p;
			
			this.dispatchEvent(new ValueBarEvent(ValueBarEvent.COMPLETE));
		}
		}
}