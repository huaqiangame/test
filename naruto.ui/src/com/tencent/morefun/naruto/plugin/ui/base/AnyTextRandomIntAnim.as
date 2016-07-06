package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import flash.utils.setTimeout;

	public class AnyTextRandomIntAnim
	{
		protected static const TEXT_ANIM_TIME:Number        =   0.5;
		
		protected var _txt:Object;
		protected var _onChange:Function;
		protected var _onComplete:Function;
		protected var _value:int;
		protected var _desValue:int;
		
		public function AnyTextRandomIntAnim(txt:Object, onChange:Function=null, onComplete:Function=null)
		{
			_txt = txt;
			_onChange = onChange;
			_onComplete = onComplete;
			_value = 0;
			_desValue = 0;
		}
		
		public function destroy():void
		{
			_onChange = null;
			_onComplete = null;
			_txt = null;
			
			TweenLite.killTweensOf(this);
		}
		
		public function reset():void
		{
			TweenLite.killTweensOf(this);
			_txt.text = "";
		}
		
		private var curTextNum:int;
		private var maxTextNum:int;
		public function start(from:int, to:int):void
		{
			_value = from;
			_desValue = to;
			
			maxTextNum = getMaxTextNum(to);
			curTextNum = maxTextNum;//这里本来是说要从第一位滚起 后来改了
			
			_txt.text = from;
			
			TweenLite.killTweensOf(this);
			TweenLite.to(this, maxTextNum / 4, {onUpdate:onUpdate, onComplete:onComplete} );
			
			TimerProvider.addEnterFrameTask(onUpdate);
//			if(maxTextNum > 1){TimerProvider.addTimeTask(200, addTextNum, null, 0, 0, maxTextNum - 1)};
		}
		
//		private function addTextNum():void
//		{
//			curTextNum += 1;
//			curTextNum = Math.min(curTextNum, maxTextNum);
//		}
		
		private function getMaxTextNum(to:int):int
		{
			var divideTime:int;
			var maxDivideValue:int;
			
			maxDivideValue = 1;
			while((to / maxDivideValue) >= 1)
			{
				divideTime ++;
				maxDivideValue *= 10;
			}
			
			return Math.max(1, divideTime);
		}
		
		private function onUpdate():void
		{
			var i:int;
			var randomText:String;
			
			randomText = "";
			for(i = 0;i < curTextNum;i ++)
			{
				randomText += int(Math.random() * 9);
			}
			_txt.text = randomText;
			
			if (_onChange != null){_onChange(parseInt(randomText));}
		}
		
		private function onComplete():void
		{
			TweenLite.killTweensOf(this);
			
			_txt.text = _desValue.toString();
			setTimeout(onUpdateComplete, 500);
			if (_onComplete != null){_onComplete(_desValue);}
			
		}
		
		private function onUpdateComplete():void
		{
			_txt.text = _desValue.toString();
			TimerProvider.removeEnterFrameTask(onUpdate);
			if (_onChange != null){_onChange(_desValue);}
		}
		}
}