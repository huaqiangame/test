package com.tencent.morefun.naruto.plugin.battle.view
{
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleTypeGroup;
	import com.tencent.morefun.naruto.plugin.battle.notice.GiveUpBattleRequestNotice;
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import base.ApplicationData;
	
	import naruto.component.controls.ButtonLittle;
	
	import serverProto.fight.FightStartType;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class BattleGiveUpAreaView
	{
		private var res:MovieClip;
		private var exitBtn:BaseButton;
		
		public function BattleGiveUpAreaView()
		{
		}
		
		public function init(res:MovieClip):void
		{
			this.res = res;
			
			exitAskPanel["bg"]["skin"].width = 261;
			
			exitBtn = new BaseButton(exitBtnRes);
			res.addChild(exitBtn);
			//exitBtn.visible = BattleTypeGroup.isEnableExitType(BattleData.singleton.fightType);
			
			if(BattleData.singleton.userInfoProxy.teamId != null && BattleData.singleton.userInfoProxy.teamId != "")
			{
				if(!BattleData.singleton.userInfoProxy.isCaptain){exitBtn.visible = false;}
			}
			
			TipsManager.singleton.binding(remainRoundText, I18n.lang("as_battle_1451031565_366") +
				I18n.lang("as_battle_1451031565_367") +
				I18n.lang("as_battle_1451031565_368") +
				I18n.lang("as_battle_1451031565_369"));
			
			if(BattleData.singleton.fightType != FightStartType.FIGHT_START_TYPE_EXPEDITION)
			{
				exitAskPanel.gotoAndStop("default");
			}
			else
			{
				exitAskPanel.gotoAndStop("expeditionary");
			}
			
			exitAskPanel.visible = false;
			remainRoundRes.visible = false;
			
			if(BattleData.singleton.userInfoProxy.level < 15)
			{
				exitBtn.disable = true;
				exitBtn.mouseEnabled = true;
				exitBtn.visible = false;
				TipsManager.singleton.binding(exitBtn, I18n.lang("as_battle_1451031565_370"));
			}
			
			exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			exitAskYesBtn.addEventListener(MouseEvent.CLICK, onExitAskPanelBtnClick);
			exitAskNoBtn.addEventListener(MouseEvent.CLICK, onExitAskPanelBtnClick);
			
			LayerManager.singleton.stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		private function onStageMouseDown(evt:MouseEvent):void
		{
			if(evt.target != exitAskPanel && !exitAskPanel.contains(evt.target as DisplayObject))
			{
				exitAskPanel.visible = false;
			}
		}
		
		public function set exitBtnVisible(value:Boolean):void
		{
			exitBtn.visible = value;
		}
		
		public function set visible(value:Boolean):void
		{
			res.visible = value;
		}
		
		public function get width():Number
		{
			return res.width;
		}
		
		public function get height():Number
		{
			return res.height;
		}
		
		public function set x(value:int):void
		{
			res.x = value;
		}
		
		public function set y(value:int):void
		{
			res.y = value;
		}
		
		private function onExitAskPanelBtnClick(evt:MouseEvent):void
		{
			switch(evt.currentTarget)
			{
				case exitAskYesBtn:
					exitAskPanel.visible = false;
					new GiveUpBattleRequestNotice().send();
					break;
				case exitAskNoBtn:
					exitAskPanel.visible = false;
					break;
			}
		}
		
		private function onExitBtnClick(evt:MouseEvent):void
		{
			if(BattleData.singleton.userInfoProxy.level < 15)
			{
				return ;
			}
			exitAskPanel.visible = true;
		}
		
		public function disableExit():void
		{
			exitAskPanel.visible = false;
			exitBtn.disable = true;
		}
		
		public function enableExit():void
		{
			if(BattleData.singleton.userInfoProxy.level < 15)
			{
				return ;
			}
			exitBtn.disable = false;
		}
		
		private var round:int;
		public function updateRound(round:int):void
		{
			this.round = round;
			updateRoundText();
		}
		
		public function subRound():void
		{
			round -= 1;
			updateRoundText();
		}
		
		public function getRound():int
		{
			return round;
		}
		
		private function updateRoundText():void
		{
			remainRoundText.htmlText = I18n.lang("as_battle_1451031565_371_0") + round + I18n.lang("as_battle_1451031565_371_1");
		}
		
		public function destroy():void
		{
			exitBtn.destroy();
			
			exitBtn.removeEventListener(MouseEvent.CLICK, onExitBtnClick);
			exitAskYesBtn.removeEventListener(MouseEvent.CLICK, onExitAskPanelBtnClick);
			exitAskNoBtn.removeEventListener(MouseEvent.CLICK, onExitAskPanelBtnClick);
			LayerManager.singleton.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			
			TipsManager.singleton.unbinding(exitBtn);
			TipsManager.singleton.unbinding(remainRoundText);
		}
		
		private function get remainRoundRes():MovieClip
		{
			return res["remainRound"];
		}
		
		private function get remainRoundText():TextField
		{
			return res["remainRound"]["txt"];
		}
		
		private function get exitBtnRes():MovieClip
		{
			return res["exitBtn"];
		}
		
		private function get exitAskPanel():MovieClip
		{
			return res["exitAskPanel"];
		}
		
		private function get exitAskYesBtn():ButtonLittle
		{
			return res["exitAskPanel"]["yes"];
		}
		
		private function get exitAskNoBtn():ButtonLittle
		{
			return res["exitAskPanel"]["no"];
		}
	}
}