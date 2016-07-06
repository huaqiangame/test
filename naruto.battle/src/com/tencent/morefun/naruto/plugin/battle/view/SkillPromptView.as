package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.ui.util.TweenManager;
	import flash.display.Sprite;
	import def.NinjaAssetDef;
	import ui.battle.SkillPromptViewUI;

	public class SkillPromptView extends Sprite
	{
		private static const H:int = 35;
		private static const H2:int = 28;
		public function SkillPromptView()
		{
			super();
			mouseChildren = mouseEnabled = false;
		}
		
		public function addPrompt(ninjaId:int, skillName:String):void
		{
			upward();
			
			var viewUI:SkillPromptViewUI = new SkillPromptViewUI();
			viewUI.txt.text = skillName;
			
			var img:Image = new Image();
			img.load(NinjaAssetDef.getAsset(NinjaAssetDef.HEAD_WIDE,ninjaId));
			viewUI.head.addChild(img);
			viewUI.alpha = 0;
			viewUI.y = -30;
			addChild(viewUI);
			
			TweenManager.addTweenTo(viewUI,0.3,{alpha:1,y:0,onComplete:showDone,onCompleteParams:[viewUI]});
		}
		
		private function showDone(viewUI:SkillPromptViewUI):void
		{
			TweenManager.addTweenTo(viewUI,0.3,{delay:2,alpha:0,onComplete:destroyViewUI,onCompleteParams:[viewUI]});
		}
		
		private function upward():void
		{
			for(var i:int=0;i<numChildren;i++)
			{
				var viewUI:SkillPromptViewUI = getChildAt(i) as SkillPromptViewUI;
				var toy:int = H + H2*(numChildren-i-1);
				TweenManager.addTweenTo(viewUI,0.2,{y:toy,alpha:0.7,scaleX:0.8,scaleY:0.8});
			}
		}
		
		private function destroyViewUI(viewUI:SkillPromptViewUI):void
		{
			var img:Image = viewUI.head.getChildAt(0) as Image;
			img.dispose();
			if(viewUI.parent)
			{
				viewUI.parent.removeChild(viewUI);
			}
		}
		
		public function destroy():void
		{
			TweenManager.killTweensOf(destroyViewUI);
			TweenManager.killTweensOf(showDone);
			
			var i:int = numChildren;
			while(i--)
			{
				var viewUI:SkillPromptViewUI = getChildAt(i) as SkillPromptViewUI;
				TweenManager.killTweensOf(viewUI);
				destroyViewUI(viewUI);
			}
			
			
		}
																
		public function autoSetNull():void
		{

		}
	}
}