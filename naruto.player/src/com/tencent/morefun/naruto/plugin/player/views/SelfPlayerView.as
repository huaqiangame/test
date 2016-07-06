package com.tencent.morefun.naruto.plugin.player.views
{
	import com.tencent.morefun.naruto.mmefile.render.MmeAsset;
	import com.tencent.morefun.naruto.plugin.player.base.JumpRopeSimulator;
	import com.tencent.morefun.naruto.plugin.ui.util.VipUtil;
	
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	import base.ApplicationData;
	
	import user.def.UserStateDef;

	public class SelfPlayerView extends PlayerView
	{
		private static const MME_ASSET:MmeAsset = new MmeAsset();
		public function SelfPlayerView()
		{
			super(MME_ASSET);
		}
		
		override protected function get mouseOverFilter():GlowFilter
		{
			return null;
		}

		override protected function updateNameText():void
		{
			super.updateNameText();
			
			nameTxt.htmlText = "<font color='#FFDA46'>"+nameTxt.text+ "</font>";
//			nameTxt.x = -nameTxt.width>>1;
		}
		
		override protected function doSpecialMove__jump():void
		{
			ApplicationData.singleton.selfInfo.state.setFlagByName(UserStateDef.BASE_JUMPING, true);
			super.doSpecialMove__jump();
		}
		override protected function doSpecialMove__onJumpFinish(e:Event):void
		{
//			super.doSpecialMove__onJumpFinish(e);
//			ApplicationData.singleton.selfInfo.state.setFlagByName(UserStateDef.BASE_JUMPING, false);
			
			var simulator:JumpRopeSimulator = e.currentTarget as JumpRopeSimulator;
			simulator.removeEventListener(Event.COMPLETE, doSpecialMove__onJumpFinish);
			
			if(isDestroyed)
			{
				return;
			}
			ApplicationData.singleton.selfInfo.state.setFlagByName(UserStateDef.BASE_JUMPING, false);
			specialMoveDatas[0].doneFun && specialMoveDatas[0].doneFun();
			specialMoveDatas.shift();
			doSpecialMove();
		}
		
		override protected function stopSpecialMove():void
		{
			super.stopSpecialMove();
			ApplicationData.singleton.selfInfo.state.setFlagByName(UserStateDef.BASE_JUMPING, false);
		}
		
		override protected function updateVipIconData():void
		{
			VipUtil.setSelfInfo(vipIcon);
		}
		
		public function checkChangeShowNinja():void
		{
			if(!inited)
			{
				return;
			}
			changeNinja_startLoad();
		}
	}
}