package com.tencent.morefun.naruto.plugin.ui.util
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;

	public class TweenManager
	{
		private static var tweenArr:Array = [];
		
		public function TweenManager()
		{
		}
		
		public static function addTweenTo(target:Object, duration:Number, vars:Object):void
		{
			var tween:TweenLite;
			var userOnComplete:Function;
			var userOnCompleteParams:Array;
			
			userOnComplete = vars.onComplete;
			userOnCompleteParams = vars.onCompleteParams;     //保存原有的回调函数，因为后面要被替换
			
			vars.paused = true;
			vars.onComplete = onTweenComplete;
			tween = TweenLite.to(target, duration, vars);
			vars.onCompleteParams = [tween];
			tween.data = {userOnComplete:userOnComplete, userOnCompleteParams:userOnCompleteParams};  //把原有的回调函数放入data中
			tweenArr.push(tween);
		}
		
		private static function onTweenComplete(tweenParam:TweenLite):void
		{
			var tweenLineIndex:int;
			var tween:TweenLite;
			var userOnComplete:Function; 
			var userOnCompleteParams:Array; 
			
			tweenLineIndex = tweenArr.indexOf(tweenParam);
			if(tweenLineIndex == -1)
			{
				return ;
			}
			
			tween = tweenArr[tweenLineIndex];
			userOnComplete = tween.data.userOnComplete;
			userOnCompleteParams = tween.data.userOnCompleteParams;
			
			if (userOnComplete != null)
			{
				userOnComplete.apply(null,userOnCompleteParams);
			}			
			
			tween.kill();
			if(tweenArr.indexOf(tween) != -1)
			{
				tweenArr.splice(tweenArr.indexOf(tween),1);
			}
		}
		
		public static function render():void
		{
			for each (var tween:TweenLite in tweenArr)
			{
				if (tween.delay > 0)
				{
					tween.delay -= 1 / LayerManager.singleton.stage.frameRate;
					continue;
				}
				tween.renderTime(tween.cachedTime + 1 / LayerManager.singleton.stage.frameRate);
			}
		}
		
		public static function killTweensOf(target:Object):void
		{
			var tween:TweenLite;
			for(var i:int = tweenArr.length-1;i >= 0;i --)
			{
				tween = tweenArr[i];
				if(tween.target == target)
				{
					tween.kill();
					tweenArr.splice(i, 1);
				}
			}
		}
		
		public static function killAll():void
		{
			for each (var tween:TweenLite in tweenArr)
			{
				tween.kill();
			}
			tweenArr.length = 0;
		}
		
		public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array=null):void
		{
			if (delay == 0)
			{
				onComplete.apply(null, onCompleteParams);
				return;
			}
			addTweenTo(onComplete, 0, {delay:delay, onComplete:onComplete, onCompleteParams:onCompleteParams, immediateRender:false, useFrames:false, overwrite:0});
			return;
		}
		
		}
}