package com.tencent.morefun.naruto.plugin.battle.view
{
	
	import com.tencent.morefun.naruto.plugin.battle.command.ShowPrewarChooseCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.components.buttons.Button;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.text.TextField;
	
	import base.ApplicationData;
	
	import naruto.component.controls.ButtonNormalBlue;
	import naruto.component.core.LabelButton;
	
	import serverProto.fight.FightStartType;
	
	import sound.commands.PlayUISoundCommand;
	import sound.def.UISoundDef;
	
	import user.event.UserInfoEvent;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class PrewarChooseView extends Sprite
	{
		private static const TIME_COUNT_DOWN:int = 5;
		
		public var view:PrewarEffect;
		public var okBtn:Sprite;
		public var cancelBtn:BaseButton;
		public var start1Btn:LabelButton;
		public var start2Btn:LabelButton;
		
		private var countDown:int;
		//private var start1Label:TextField;
		//private var start2Label:TextField;
		
		//		public var guidArrow:PrewarGuidArrow;
		
		private var _isClose:Boolean;		
		private var _command:ShowPrewarChooseCommand;
		private var _cancelBtnIndex:int;
		public function PrewarChooseView()
		{
			super();
			
			initUI();
		}
		
		
		public function get command():ShowPrewarChooseCommand
		{
			return _command;
		}
		
		public function set command(value:ShowPrewarChooseCommand):void
		{
			_command = value;
			checkEnableChoose();
			
			this.mouseEnabled = value.enableClick;
			this.mouseChildren = value.enableClick;
			
			if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_EXPEDITION)
			{
				command.choose = 1;
				command.finish();
				close();
			}
		}
		
		public function close():void
		{
			_isClose = true;
			
			DisplayUtils.stop(this);
			
			TimerProvider.removeTimeTask(1000, onTimeEvent);
			okBtn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			start1Btn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			start2Btn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			
			BattleData.singleton.userInfoProxy.removeEventListener(UserInfoEvent.TEAM_INFO_UPDATE, onTeamInfoUpdate);
			this.parent.removeChild(this);
			
			if(cancelBtn != null)
			{
				cancelBtn.removeEventListener(MouseEvent.CLICK, okBtnClick);
				DisplayUtils.stop(cancelBtn.skin);
				cancelBtn.destroy();
				cancelBtn.parent.removeChild(cancelBtn);
				view.removeEventListener("initCancelBtn", initCancelBtn);
				cancelBtn = null;
			}
		}
		
		public function initUI():void
		{
			view = new PrewarEffect();
			
			addChild(view);
			_cancelBtnIndex = view["effect"]["content"].getChildIndex(view["effect"]["content"]["cancelBtn"]);
			okBtn = view["effect"]["btns"]["okBtn"];
			start1Btn = view["effect"]["btns"]["start1Btn"];
			start2Btn = view["effect"]["btns"]["start2Btn"];
			
			okBtn.addEventListener(MouseEvent.CLICK, okBtnClick);
			start1Btn.addEventListener(MouseEvent.CLICK, okBtnClick);
			start2Btn.addEventListener(MouseEvent.CLICK, okBtnClick);
			
			countDown = TIME_COUNT_DOWN;
			start1Btn.label = I18n.lang("as_battle_1451031565_384") + countDown + ")";
			start2Btn.label= I18n.lang("as_battle_1451031565_385") + countDown + ")";
			
			BattleData.singleton.userInfoProxy.addEventListener(UserInfoEvent.TEAM_INFO_UPDATE, onTeamInfoUpdate);
		}
		
		public function showEffect():void
		{
			_isClose = false;
			
			if(start1Btn)
			{
				start1Btn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			}
			
			if(start2Btn)
			{
				start2Btn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			}
			
			if(okBtn)
			{
				okBtn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			}
			
			view.addEventListener("initCancelBtn", initCancelBtn);
			
			view.gotoAndStop("closeEffect");
			view.gotoAndStop("showEffect");
			okBtn = view["effect"]["btns"]["okBtn"];
			start1Btn = view["effect"]["btns"]["start1Btn"];
			start2Btn = view["effect"]["btns"]["start2Btn"];
			okBtn.addEventListener(MouseEvent.CLICK, okBtnClick);
			start1Btn.addEventListener(MouseEvent.CLICK, okBtnClick);
			start2Btn.addEventListener(MouseEvent.CLICK, okBtnClick);
			countDown = TIME_COUNT_DOWN;
			start1Btn.label = I18n.lang("as_battle_1451031565_386") + countDown + ")";
			start2Btn.label = I18n.lang("as_battle_1451031565_387") + countDown + ")";
			
			TimerProvider.addTimeTask(1000, onTimeEvent);
			new PlayUISoundCommand(UISoundDef.BATTLE_START_SHOW).call();
		}
		
		private function initCancelBtn(evt:Event):void
		{
			var cancelBtnDisp:MovieClip;
			var cancelBtnDispParent:DisplayObjectContainer;
			
			if(cancelBtn)
			{
				DisplayUtils.stop(cancelBtn.skin);
				cancelBtn.destroy();
				cancelBtn.parent.removeChild(cancelBtn);
				cancelBtn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			}
			
			cancelBtnDisp = view["effect"]["content"]["cancelBtn"];
			cancelBtnDispParent = cancelBtnDisp.parent;
			if(cancelBtnDisp.parent == null){return ;}
			
			_cancelBtnIndex = cancelBtnDisp.parent.getChildIndex(cancelBtnDisp);
			cancelBtn = new BaseButton(cancelBtnDisp);
			cancelBtnDispParent.addChildAt(cancelBtn, _cancelBtnIndex);
			cancelBtn.addEventListener(MouseEvent.CLICK, okBtnClick);
			cancelBtn.buttonMode = true;
		}
		
		private function onTimeEvent():void
		{
			countDown -= 1;
			start1Btn.label = I18n.lang("as_battle_1451031565_388") + countDown + ")";
			start2Btn.label = I18n.lang("as_battle_1451031565_389") + countDown + ")";
			if(countDown <= 0)
			{
				closeEffect();
			}
		}
		
		public function hide():void
		{
			if(_isClose)
			{
				return ;
			}
			
			command.choose = 1;
			command.finish();
			//			close();
			
			//			if(guidArrow && guidArrow.parent)
			//			{
			//				guidArrow.parent.removeChild(guidArrow);
			//			}
		}
		
		public function showHideEffect():void
		{
			if(_isClose)
			{
				return ;
			}
			
			closeEffect();
			
			//			if(guidArrow && guidArrow.parent)
			//			{
			//				guidArrow.parent.removeChild(guidArrow);
			//			}
		}
		
		private function okBtnClick(evt:MouseEvent):void
		{
			if(_isClose)
			{
				return ;
			}
			
			switch(evt.currentTarget)
			{
				case okBtn:
					command.choose = 1;
					command.finish();
					close();
					break;
				case cancelBtn:
				{
					new PlayUISoundCommand(UISoundDef.BATTLE_START).call();
				}
				case start1Btn:
				case start2Btn:
					closeEffect();
					break;
			}
			
			new PlayUISoundCommand(UISoundDef.BUTTON_CLICK).call();
			
			//			if(guidArrow && guidArrow.parent)
			//			{
			//				guidArrow.parent.removeChild(guidArrow);
			//			}
		}
		
		private function closeEffect():void
		{
			_isClose = true;
			
			DisplayUtils.stop(this);
			
			TimerProvider.removeTimeTask(1000, onTimeEvent);
			
			okBtn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			start1Btn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			start2Btn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			view.addEventListener(Event.COMPLETE, onCloseComplete);
			view.gotoAndStop("closeEffect");
			
			if(cancelBtn){cancelBtn.removeEventListener(MouseEvent.CLICK, okBtnClick);}
		}
		
		private function onCloseComplete(evt:Event):void
		{
			view.removeEventListener(Event.COMPLETE, onCloseComplete);
			
			if(cancelBtn != null)
			{
				cancelBtn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			}
			
			okBtn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			start1Btn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			start2Btn.removeEventListener(MouseEvent.CLICK, okBtnClick);
			command.choose = 0;
			command.finish();
			close();
		}
		
		private function checkEnableChoose():void
		{
			if(!command)
			{
				return ;
			}
			
			okBtn.visible = command.enableChoose;
			start1Btn.visible = command.enableChoose;
			
			if(!command.enableChoose && command.isControl)
			{
				start2Btn.visible = true;
			}
			else
			{
				start2Btn.visible = false;
			}
		}
		
		private function onTeamInfoUpdate(evt:UserInfoEvent):void
		{
			checkEnableChoose();
		}
		
		public function autoSetNull():void
		{
			
			view = null;
			okBtn = null;
			cancelBtn = null;
			start1Btn = null;
			start2Btn = null;
			//start1Label = null;
			//start2Label = null;
			//			guidArrow = null;
			_command = null;
		}
	}
}