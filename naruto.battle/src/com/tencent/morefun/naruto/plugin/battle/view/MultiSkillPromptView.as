package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	
	import com.tencent.morefun.naruto.util.def.TimerDef;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	import cfgData.dataStruct.SkillCFG;

	public class MultiSkillPromptView extends Sprite
	{
		private static const MAX_PROMPT_NUM:int = 3;
		
		private var removeTimer:Timer;
		private var skillPromptList:Array = [];
		private var lastSkillCfg:SkillCFG;
		
		private var promptNum:int;
		
		public function MultiSkillPromptView()
		{
			super();
			
			mouseChildren = mouseEnabled = false;
			
			//			removeTimer = new Timer(2000);
			//			removeTimer.addEventListener(TimerEvent.TIMER, onRemoveTimer);
			//			removeTimer.start();
		}
		
		private function onRemoveTimer(evt:TimerEvent):void
		{
			var baseSkillPromptView:MultiBaseSkillPromptView;
			
			if(skillPromptNum == 0)
			{
				return ;
			}
			
			removeFirsetPrompt();
		}
		
		private function get skillPromptNum():int
		{
			var num:int;
			
			for(var i:int = 0;i < skillPromptList.length;i ++)
			{
				if(!(skillPromptList[i] as MultiBaseSkillPromptView).isHiding)
				{
					num ++;
				}
			}
			
			return num;
		}
		
		public function clearPrompt():void
		{
			if(promptNum == 0)
			{
				return ;
			}
			
			TimerProvider.addTimeTask(TimerDef.FPS_24 * 6, onClearPrompt, promptNum, 0, 0, 1);
			logger.output("[clearPrompt]", promptNum);
			promptNum = 0;
		}
		
		private function onClearPrompt(clearNum:int):void
		{
			var time:int;
			
			logger.output("[onClearPrompt]", clearNum);
			
			while(clearNum > 0)
			{
				//				removeFirsetPrompt();
				setTimeout(removeFirsetPrompt, 100 * time);
				clearNum --;
				time ++;
			}
		}
		
		public function addPrompt(ninjaId:int, comboIndex:int, skillCfg:SkillCFG, mirror:Boolean):void
		{
			var baseSkillPromptView:MultiBaseSkillPromptView;
			
			promptNum ++;
			
			baseSkillPromptView = new MultiBaseSkillPromptView(ninjaId, comboIndex, lastSkillCfg, skillCfg, mirror);
			addChild(baseSkillPromptView);
			
			skillPromptList.push(baseSkillPromptView);
			
			updateTweenPromptParam();
			removeOutSidePrompt();
			
			//			removeTimer.reset();
			//			removeTimer.start();
			
			lastSkillCfg = skillCfg;
		}
		
		public function updateTweenPromptParam():void
		{
			var i:int;
			var nextPromptY:int;
			var baseSkillPromptView:MultiBaseSkillPromptView;
			var tweenPromptParam:TweenPromptParam;
			var tweenPromptParamList:Array = [];
			
			for(i = 0;i < skillPromptList.length;i ++)
			{
				baseSkillPromptView = skillPromptList[i];
				
				TweenLite.killTweensOf(baseSkillPromptView);
				
				tweenPromptParam = new TweenPromptParam();
				//				tweenPromptParam.destScaleX = 1 - (skillPromptList.length - i - 1) * 0.2;
				//				tweenPromptParam.destScaleY = 1 - (skillPromptList.length - i - 1) * 0.2;
				//				tweenPromptParam.destAlpha = 1 - (skillPromptList.length - i - 1) * 0.2;
				tweenPromptParam.destWidth = baseSkillPromptView.originalWidth; // * tweenPromptParam.destScaleX;
				tweenPromptParam.destHeight = baseSkillPromptView.originalHeight; // * tweenPromptParam.destScaleY;
				tweenPromptParam.view = baseSkillPromptView;
				
				tweenPromptParamList.push(tweenPromptParam);
			}
			
			for(i = tweenPromptParamList.length - 1;i >= 0;i --)
			{
				tweenPromptParam = tweenPromptParamList[i];
				tweenPromptParam.destY = nextPromptY;
				nextPromptY = tweenPromptParam.destY - tweenPromptParam.destHeight;
			}
			
			for each(tweenPromptParam in tweenPromptParamList)
			{
				//				TweenLite.to(tweenPromptParam.view, 0.2, {scaleX:tweenPromptParam.destScaleX, scaleY:tweenPromptParam.destScaleY, y:tweenPromptParam.destY, alpha:tweenPromptParam.destAlpha});
				TweenLite.to(tweenPromptParam.view, 0.2, {y:tweenPromptParam.destY});
			}
		}
		
		public function destroy():void
		{
			var baseSkillPromptView:MultiBaseSkillPromptView;
			
			//			removeTimer.stop();
			for each(baseSkillPromptView in skillPromptList)
			{
				if(!baseSkillPromptView.isHiding)
				{
					TweenLite.killTweensOf(baseSkillPromptView);
					baseSkillPromptView.removeEventListener(Event.COMPLETE, onHideComplete);
					baseSkillPromptView.destroy();
					if(baseSkillPromptView.parent){removeChild(baseSkillPromptView);}
				}
			}
			
		}
		
		private function removeOutSidePrompt():void
		{
			while(promptNum > 3)
			{
				removeFirsetPrompt();
				promptNum --;
			}
		}
		
		private function removeFirsetPrompt():void
		{
			var baseSkillPromptView:MultiBaseSkillPromptView;
			
			for(var i:int = 0;i < skillPromptList.length;i ++)
			{
				baseSkillPromptView = skillPromptList[i];
				if(!baseSkillPromptView.isHiding)
				{
					baseSkillPromptView.addEventListener(Event.COMPLETE, onHideComplete);
					baseSkillPromptView.hide();
					break;
				}
			}
			
			
			
		}
		
		private function onHideComplete(evt:Event):void
		{
			var baseSkillPromptView:MultiBaseSkillPromptView;
			
			baseSkillPromptView = evt.currentTarget as MultiBaseSkillPromptView;
			baseSkillPromptView.removeEventListener(Event.COMPLETE, onHideComplete);
			TweenLite.killTweensOf(baseSkillPromptView);
			baseSkillPromptView = skillPromptList.shift();
			if(baseSkillPromptView.parent){removeChild(baseSkillPromptView);}
			baseSkillPromptView.destroy();
		}
		
																
		public function autoSetNull():void
		{

			removeTimer = null;
			skillPromptList = null;
			lastSkillCfg = null;
		}
	}
}

import com.tencent.morefun.naruto.plugin.battle.view.MultiBaseSkillPromptView;

class TweenPromptParam
{
	public var destY:int;
	public var destScaleX:Number;
	public var destScaleY:Number;
	public var destAlpha:Number;
	public var destWidth:int;
	public var destHeight:int;
	public var view:MultiBaseSkillPromptView;
	
	public function TweenPromptParam()
	{
		
	}

	public function autoSetNull():void
	{

		view = null;
	}
}