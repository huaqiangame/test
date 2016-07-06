package com.tencent.morefun.naruto.plugin.battle.view
{
	
	import com.greensock.TweenLite;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRender;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRenderEvent;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.battle.cfg.CustomBattleCfg;
	import com.tencent.morefun.naruto.plugin.battle.cfg.CustomBattleConfig;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowPrewarChooseCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleTypeGroup;
	import com.tencent.morefun.naruto.plugin.battle.data.CustomInfo;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.battle.data.UINinjaData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIPlayerData;
	import com.tencent.morefun.naruto.plugin.battle.event.UIDataEvent;
	import com.tencent.morefun.naruto.plugin.battle.event.VideoViewEvent;
	import com.tencent.morefun.naruto.plugin.battle.notice.RequestAutoFightNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.RequestSpeedUpNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.SpeedUpRenderNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdateBattleViewSkillStateNotice;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.FightDamageView;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageInfo;
	import com.tencent.morefun.naruto.plugin.exui.base.Image;
	import com.tencent.morefun.naruto.plugin.motion.data.NinjaBattleCfgInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.SkillStatuInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.FightManagerCenter;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.Ninja;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.NinjaConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.def.NinjaDef;
	import com.tencent.morefun.naruto.plugin.ui.base.BaseButton;
	import com.tencent.morefun.naruto.plugin.ui.core.CoreValueBar;
	import com.tencent.morefun.naruto.plugin.ui.core.event.ValueBarEvent;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.tips.TipsManager;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import com.tencent.morefun.naruto.plugin.ui.util.TweenManager;
	import com.tencent.morefun.naruto.util.def.TimerDef;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import base.ApplicationData;
	
	import battle.def.RequestFightStartTypeDef;
	
	import cfgData.dataStruct.SkillCFG;
	
	import chat.data.ChatItem;
	
	import def.TipsTypeDef;
	
	import serverProto.fight.FightStartType;
	import serverProto.fight.SkillProhibitType;
	
	import skill.SkillAssetDef;
	import skill.config.SkillConfig;
	
	import team.model.TeamModel;
	import team.utils.TeamUtils;
	
	import ui.battle.BattleViewUI;
	import ui.battle.FightPlayerTipsUI;
	
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class BattleView extends Sprite
	{
		public static const PLAYER_OFFSET:int = 25;
		
		private static const minWidth:int = 1020;
		private static const minHeight:int = 600;
		private static const maxWidth:int = 1300;
		private static const maxHeight:int = 825;
		private static const COOL_DOWN:int = 2;
		private static const SKILL_BTN_NUM:int = 5;
		
		private var viewUI:BattleViewUI;
		private var motionPlayer:Sprite;
		private var skillBtns:Array;
		private var curtainLayer:Sprite;//幕布
		
		private var skillPanelHeight:int;
		
		private var leftHitNumberView:HitNumberView;
		private var rightHitNumberView:HitNumberView;
		private var rightHitPosRight:int;
		private var rightSkillPromptPos:int;
		
		
		private var uiData:UIData;
		private var battleData:BattleData;
		
		private var useSkillFun:Function;
		
		private var damageInfo:DamageInfo;
		private var damageInfoView:FightDamageView;
		
		private var roundCountView:RoundCountView;
		private var fightOverView:FightOverView;
		private var prewarChooseView:PrewarChooseView;
		
		private var oursSkillPromptView:MultiSkillPromptView;
		private var theirsSkillPromptView:MultiSkillPromptView;
		
		private var selfHpType:int = -1;
		private var theirsHpType:int = -1;
		
		private var videoView:VideoView = new VideoView();
		
		private var leftMainPlayer:MainPlayerView;
		private var leftPlayer1:PlayerView;
		private var leftPlayer2:PlayerView;
		private var rightMainPlayer:MainPlayerView;
		private var rightPlayer1:PlayerView;
		private var rightPlayer2:PlayerView;
		
		private var battleGiveUpAreaView:BattleGiveUpAreaView;
		
		private var skillMpText:TextField;
		private var skillMpFire:MovieClip;
		private var skillMpValueBar:CoreValueBar;
		
		private var skillCountDown:TextField;
		
		private var skillGuidView:SkillGuidView;
		private var targetGuidTips:TargetGuidTips;
		
		private var battleInfoView:BattleInfoView;
		
		private var speedUpBtn:BaseButton;
		private var autoFightBtn:BaseButton;
		private var _uiShowing:Boolean;
		
		private var _frameUI:FightFrameUI;
		
		public function BattleView(useSkillFun:Function)
		{
			TipsManager.singleton.registerTipsClass(TipsTypeDef.BATTLE_PLAYER, BattlePlayerTipsView, FightPlayerTipsUI);
			
			super();
			this.useSkillFun = useSkillFun;
			
			battleData = BattleData.singleton;
			
			initUI();
			addEvents();
			if(BattleData.singleton.fightType != RequestFightStartTypeDef.FIRST_GUID_FIGHT)
			{
				TeamUtils.model.addEventListener(ModelEvent.UPDATE, onTeamModelUpdate);
			}
		}
		
		public function addMotionPlayer(motionPlayer:Sprite):void
		{
			this.motionPlayer = motionPlayer;
			addChildAt(motionPlayer, 0);
		}
		
		public function setHpBarType(type:int, pos:int):void
		{
			var isOurs:Boolean;
			var isSelf:Boolean;
			
			isOurs = uiData.isOurNinjaPos(pos);
			
			if(uiData.self == null)
			{
				logger.output(I18n.lang("as_battle_1451031565_374"));
				return;
			}
			isSelf = uiData.self.getNinja(pos) != null;
			if(isOurs)
			{
				if(isSelf)
				{
					leftMainPlayer.setHpType(type);
				}
			}
			
			if(isOurs == false)
			{
				rightMainPlayer.setHpType(type);
			}
		}
		
		private function addEvents():void
		{
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,onStage);
			
			if(stage)
			{
				onResize(null);
			}
			
			UIData.singleton.addEventListener(UIDataEvent.UPDATE_SELF, onUpdateSelf);
		}
		
		private function onUpdateSelf(evt:UIDataEvent):void
		{
			var btn:SkillButtonView;
			
			if(evt.oldSelf)
			{
				evt.oldSelf.removeEventListener(UIDataEvent.BASE_INFO_UPDATE, onMainPlayerUpdate);
			}
			
			if(evt.newSelf)
			{
				evt.newSelf.addEventListener(UIDataEvent.BASE_INFO_UPDATE, onMainPlayerUpdate);
			}
			
			updatePetSkillInfo();
			updatePlayerViewInfo();
			updateSelfMp();
			updateCustomPlayerInfo();
		}
		
		private function initUI():void
		{
			viewUI = new BattleViewUI();
			viewUI.skillPanelView.gotoAndStop(4);
			
			skillMpText = viewUI.skillPanelView.indicator["mpTxt"];
			//skillMpFire = viewUI["skill"]["mpFire"];
			skillMpValueBar = new CoreValueBar(viewUI.skillPanelView.indicator["mp"]);
			TipsManager.singleton.binding(viewUI.skillPanelView.indicator, I18n.lang("as_battle_1451031565_375"));
			skillMpText.text = "0/0";
			skillMpValueBar.addEventListener(ValueBarEvent.UPDATE, onSelfMpValueBarUpdate);
			skillMpValueBar.addEventListener(ValueBarEvent.COMPLETE, onSelfMpValueBarUpdate);
			
			skillCountDown = viewUI.skillPanelView["countdown"];
			skillCountDown.visible = false;
			
			viewUI.ours["mainPlayer"]["hptxt"].scaleX = -1;
			viewUI.ours["mainPlayer"]["mptxt"].scaleX = -1;
			
			viewUI.leftHitPos.mouseEnabled = viewUI.leftHitPos.mouseChildren = false;
			viewUI.rightHitPos.mouseEnabled = viewUI.rightHitPos.mouseChildren = false;
			
			rightHitPosRight = viewUI.theirs.x - viewUI.rightHitPos.x;
			rightSkillPromptPos = viewUI.theirs.x - viewUI.rightSkillPromptPos.x;
			
			battleGiveUpAreaView = new BattleGiveUpAreaView();
			battleGiveUpAreaView.init(viewUI["giveUpArea"]);
			battleGiveUpAreaView.visible = false;
			
			viewUI.resultPos.mouseEnabled = false;
			
			leftMainPlayer = new MainPlayerView(viewUI.ours.mainPlayer);
			leftPlayer1 = new PlayerView(viewUI.ours.player1);
			leftPlayer2 = new PlayerView(viewUI.ours.player2);
			
			rightMainPlayer = new MainPlayerView(viewUI.theirs.mainPlayer);
			rightPlayer1 = new PlayerView(viewUI.theirs.player1);
			rightPlayer2 = new PlayerView(viewUI.theirs.player2);
			
			oursSkillPromptView = new MultiSkillPromptView();
			oursSkillPromptView.x = viewUI.x + viewUI.leftSkillPromptPos.x;
			oursSkillPromptView.y = viewUI.y + viewUI.leftSkillPromptPos.y;
			theirsSkillPromptView = new MultiSkillPromptView();
			theirsSkillPromptView.x = viewUI.x + viewUI.rightSkillPromptPos.x;
			theirsSkillPromptView.y = viewUI.y + viewUI.rightSkillPromptPos.y;
			theirsSkillPromptView.scaleX = -1;
			
			addChild(oursSkillPromptView)
			addChild(theirsSkillPromptView)
			
			skillBtns = [];
			//var posX:int = viewUI.skill["btnPos0"].x;
			//var posY:int = viewUI.skill["btnPos0"].y;
			//var posW:int = viewUI.skill["btnPos1"].x - posX;
			
			var ks:Array = ["Q","W","E","R","T"];
			for(var i:int=0;i<SKILL_BTN_NUM;i++)
			{
				var ninjaId:int = -1;
				var ninjaPos:int = -1;
				var skillId:int = -1;
				var k:String = "";
				var btn:SkillButtonView
				
				k = ks[i];
				
				btn = new SkillButtonView(k, onClickBtn, viewUI.skillPanelView["item" + (i + 1)]);
				//btn.x = posX + i * posW;
				//btn.y = posY;
				btn.updateState();
				skillBtns.push(btn);
			}
			
			curtainLayer = new Sprite();
			curtainLayer.graphics.beginFill(0x000000, 1);
			curtainLayer.graphics.drawRect(0, 0, maxWidth, maxHeight);
			curtainLayer.graphics.endFill();
			curtainLayer.mouseEnabled = curtainLayer.mouseChildren = false;
			curtainLayer.alpha = 0;
			
			addChild(viewUI);
			addChild(curtainLayer);
			
			viewUI.ours.y = -viewUI.ours.height;
			viewUI.theirs.y = -viewUI.ours.height;
			skillYOffset = 82;
			
			//			viewUI.speedUpBtn.x = 0;
			//			viewUI.speedUpBtn.y = 0;
			viewUI.skillPanelView.speedUpBtn.buttonMode = true;
			speedUpBtn = new BaseButton(viewUI.skillPanelView.speedUpBtn);
			viewUI.skillPanelView.addChild(speedUpBtn);
			speedUpBtn.addEventListener(MouseEvent.CLICK, onSpeedUp);
			
			autoFightBtn = new BaseButton(viewUI.skillPanelView.autoFight);
			viewUI.skillPanelView.addChild(autoFightBtn);
			autoFightBtn.addEventListener(MouseEvent.CLICK, onAutoFight);
			
			skillGuidView = new SkillGuidView();
			skillGuidView.hideAnimation();
			viewUI.guid.addChild(skillGuidView);
			videoView.addEventListener(VideoViewEvent.VIDEO_COMPLETE, onVideoComplete);
			//viewUI.skill.setChildIndex(skillMpFire,viewUI.skill.numChildren - 1);
			
			battleInfoView = new BattleInfoView(viewUI["battleInfo"]);
			battleInfoView.hide();
			
			viewUI.skillStatus.visible = false;
			viewUI.watchOffEffect.visible = false;
			
			mouseEnabled = false;
			viewUI.leftHitPos.mouseEnabled = viewUI.leftHitPos.mouseChildren = false;
			viewUI.rightHitPos.mouseEnabled = viewUI.leftHitPos.mouseChildren = false;
			
			var speedTips:String;
			var autoTips:String;
			
			autoTips = BattleTypeGroup.getAutoTips(BattleData.singleton.fightType);
			speedTips = BattleTypeGroup.getSpeedTips(BattleData.singleton.fightType);
			
			if(autoTips)
			{
				TipsManager.singleton.binding(autoFightBtn, autoTips);
			}
			
			autoFightBtn.selected = BattleTypeGroup.getDefaultSpeedStatus(BattleData.singleton.fightType);
			updateAutoFightLabel(autoFightBtn.selected);
			
			if(BattleTypeGroup.isEnableAutoType(BattleData.singleton.fightType) == false)
			{
				autoFightBtn.disable = true;
				autoFightBtn.mouseEnabled = true;
			}
			
			if(speedTips)
			{
				TipsManager.singleton.binding(speedUpBtn, speedTips);
			}
			
			speedUpBtn.selected = BattleTypeGroup.getDefaultSpeedStatus(BattleData.singleton.fightType);
			
			if(BattleTypeGroup.isEnableSpeedType(BattleData.singleton.fightType) == false)
			{
				speedUpBtn.disable = true;
				speedUpBtn.mouseEnabled = true;
			}
			else
			{
				updateSpeedUpLabel(speedUpBtn.selected);
			}
			
			viewUI.autoFightTips.visible = false;
			viewUI.autoFightTips.alpha = 0;
			
			_frameUI = new FightFrameUI();
			LayerManager.singleton.addItemToLayer(_frameUI, LayerDef.BATTLE_FRAME);
			
			if(BattleData.singleton.fightType == RequestFightStartTypeDef.FIRST_GUID_FIGHT)
			{
				speedUpBtn.visible = false;
				autoFightBtn.visible = false;
			}
			/*
			roundCountView = new RoundCountView();
			roundCountView.count = UIData.singleton.startRoundIndex;
			*/
			skillPanelHeight = 82;
		}
		
		private var countdown:int;
		public function showCountdown():void
		{
			countdown = BattleData.singleton.timeout;
			TimerProvider.addTimeTask(TimerDef.SECOND, onCountDownEvent);
			
		}
		
		public function hideCountDown():void
		{
			skillCountDown.visible = false;
			TimerProvider.removeTimeTask(TimerDef.SECOND, onCountDownEvent);
		}
		
		private function onCountDownEvent():void
		{
			countdown = Math.max(--countdown, 0);
//			if(BattleData.singleton.timeout - countdown >= 10){skillCountDown.visible = true;}
//			skillCountDown.text = countdown + "秒后回合同步超时";
			if(countdown == 0){logger.output(I18n.lang("as_battle_1451031565_376"));}
			
			if(countdown == 5)
			{
				logger.output("speedupRender");
				new SpeedUpRenderNotice().send();
			}
		}
		
		public function hideBattleUI():void
		{
			viewUI.visible = false;
			//			oursSkillPromptView.visible = false;
			//			theirsSkillPromptView.visible = false;
		}
		
		private function onSpeedUp(evt:MouseEvent):void
		{
			if(BattleTypeGroup.isEnableSpeedType(BattleData.singleton.fightType) == false)
			{
				return ;
			}
			
			if(BattleTypeGroup.getSpeedStatus(BattleData.singleton.fightType))
			{
				new RequestSpeedUpNotice(false).send();
			}
			else
			{
				new RequestSpeedUpNotice(true).send();
			}
		}
		
		private function onAutoFight(evt:MouseEvent):void
		{
			if(BattleTypeGroup.isEnableAutoType(BattleData.singleton.fightType) == true)
			{
				new RequestAutoFightNotice(!autoFightBtn.selected).send();
			}
		}
		
		protected function onClickBtn(btn:SkillButtonView):void
		{
			useSkillFun(btn.ninjaPos, btn.index, btn.isContractPet);
		}
		
		private function onAddPlayer(evt:UIDataEvent):void
		{
			updatePlayerViewInfo();
		}
		
		private function onRemovePlayer(evt:UIDataEvent):void
		{
			updatePlayerViewInfo();
		}
		
		private function onPlayerUpdate(evt:UIDataEvent):void
		{
			updatePlayerViewInfo();
		}
		
		protected function onStage(event:Event):void
		{
			switch(event.type)
			{
				case Event.ADDED_TO_STAGE:
					onResize(null);
					stage.addEventListener(Event.RESIZE,onResize);
					stage.addEventListener(KeyboardEvent.KEY_UP,onKeyDown);
					break;
				case Event.REMOVED_FROM_STAGE:
					stage.removeEventListener(Event.RESIZE,onResize);
					stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyDown);
					break;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(skillBtns==null || !_uiShowing || battleData.skillStatus == BattleData.SKILL_STATUS_WATCH_ON)
			{
				return;
			}
			var btnIndex:int = -1;
			var btn:SkillButtonView;
			switch(e.keyCode)
			{
				case Keyboard.Q:
					btnIndex = 0;
					break;
				case Keyboard.W:
					btnIndex = 1;
					break;
				case Keyboard.E:
					btnIndex = 2;
					break;
				case Keyboard.R:
					btnIndex = 3;
					break;
				//				case Keyboard.T:
				//					btnIndex = 4;
				//					break;
			}
			
			
			if(skillBtns[btnIndex] && skillBtns[btnIndex].visible == true && btnIndex != -1)
			{
				btn = this.skillBtns[btnIndex];
			}
			
			if(btn && !btn.disabled && btn.mouseEnabled && btn.skillId != 0)
			{
				useSkillFun(btn.ninjaPos, btn.index, btn.isContractPet);
			}
		}
		
		public function onResize(event:Event):void
		{
			var offsetX:int;
			var offsetY:int;
			var stageWidth:int;
			var stageHeight:int;
			
			_frameUI.x = (stage.stageWidth - _frameUI.width) / 2;
			_frameUI.y = (stage.stageHeight - _frameUI.height) / 2;
			
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			stageWidth = Math.min(stageWidth, maxWidth);
			stageWidth = Math.max(stageWidth, minWidth);
			stageHeight = Math.min(stageHeight, maxHeight);
			stageHeight = Math.max(stageHeight, minHeight);
			offsetX = (stage.stageWidth - stageWidth) / 2;
			offsetY = (stage.stageHeight - stageHeight) / 2 + PLAYER_OFFSET;
			
			viewUI.scrollRect = new Rectangle(0,0,stageWidth,stageHeight);
			
			viewUI.x = offsetX;
			viewUI.y = offsetY;
			curtainLayer.x = offsetX;
			curtainLayer.y = offsetY;
			//			speedUpBtn.x = stageWidth - speedUpBtn.width;
			//			speedUpBtn.y = stageHeight - speedUpBtn.height;
			battleGiveUpAreaView.x = stageWidth - battleGiveUpAreaView.width + 6;
			battleGiveUpAreaView.y = stageHeight - battleGiveUpAreaView.height + 6;
			
			viewUI.theirs.x = stageWidth;
			
			if(stageWidth < 1250)
			{
				battleInfoView.minFrameSizePosition();
			}
			else
			{
				battleInfoView.normalFrameSizePosition();
			}
			
			battleInfoView.res.x = (stageWidth - battleInfoView.res.width) / 2;
			viewUI.autoFightTips.x = stageWidth / 2;
			
			viewUI.skillPanelView.x = (stageWidth - viewUI.skillPanelView.width) / 2;
			viewUI.skillPanelView.y = stageHeight - skillPanelHeight + skillYOffset;
			viewUI.targetGuidTipsPos.x = (stageWidth - viewUI.skillPanelView.width) / 2;
			
			viewUI.rightSkillPromptPos.x = stageWidth - rightSkillPromptPos;
			if(oursSkillPromptView)
			{
				oursSkillPromptView.x = viewUI.x + viewUI.leftSkillPromptPos.x;
				oursSkillPromptView.y = viewUI.y + viewUI.leftSkillPromptPos.y;
			}
			
			if(theirsSkillPromptView)
			{
				theirsSkillPromptView.x = viewUI.x + viewUI.rightSkillPromptPos.x;
				theirsSkillPromptView.y = viewUI.y + viewUI.rightSkillPromptPos.y;
			}
			
			if(leftHitNumberView)
			{
				leftHitNumberView.x = viewUI.x + viewUI.leftHitPos.x;
				leftHitNumberView.y = viewUI.y + viewUI.leftHitPos.y;
			}
			
			viewUI.rightHitPos.x = stageWidth - rightHitPosRight;
			if(rightHitNumberView)
			{
				rightHitNumberView.x = viewUI.x + viewUI.rightHitPos.x;
				rightHitNumberView.y = viewUI.y + viewUI.rightHitPos.y;
			}
			
			viewUI.roundCountPos.x = stageWidth / 2;
			
			viewUI.resultPos.x = stageWidth / 2;
			viewUI.resultPos.y = stageHeight / 2;
			
			viewUI.prewarPos.x = stageWidth / 2;
			viewUI.prewarPos.y = stageHeight / 2;
			
			motionPlayer.x = int((stageWidth-motionPlayer.width) / 2 + offsetX);
			motionPlayer.y = int((stageHeight-motionPlayer.height) / 2 + offsetY);
			
			
			if(stageWidth <= 1185)
			{
				viewUI.skillPanelView.x = stageWidth - (stageWidth - 235);
			}
			viewUI.skillStatus.x = viewUI.skillPanelView.x + (viewUI.skillPanelView.width - viewUI.skillStatus.width) / 2 + viewUI.skillStatus.width / 2;
			viewUI.skillStatus.y = stageHeight;
			viewUI.watchOffEffect.x = viewUI.skillPanelView.x + (viewUI.skillPanelView.width - viewUI.watchOffEffect.width) / 2 + viewUI.watchOffEffect.width / 2;
			viewUI.watchOffEffect.y = stageHeight / 2;
			
			
			skillGuidView.update();
			
			if(targetGuidTips)
			{
				targetGuidTips.x = stageWidth / 2;
			}
		}
		
		public function clearSkillBtn(ninjaPos:int):void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				if(btn.ninjaPos == ninjaPos)
				{
					btn.clear();
					TipsManager.singleton.unbinding(btn, TipsTypeDef.SKILL);
				}
			}
		}
		
		public function petLock(lock:Boolean):void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				btn.petLock = lock;
			}
		}
		
		public function updateAutoFightLabel(isAutoFight:Boolean):void
		{
			viewUI.autoFightTips.visible = isAutoFight;
			viewUI.autoFightTips.rankTips.visible = BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_RANK_BATTLE;
			
			autoFightBtn.selected = isAutoFight;
		}
		
		public function updateSpeedUpLabel(isSpeed:Boolean):void
		{
			if(isSpeed)
			{
				speedUpBtn.selected = true;
				if(speedUpBtn.disable == false)
				{
					TipsManager.singleton.binding(speedUpBtn, I18n.lang("as_battle_1451031565_377"));
				}
			}
			else
			{
				speedUpBtn.selected = false;
				if(speedUpBtn.disable == false)
				{
					TipsManager.singleton.binding(speedUpBtn, I18n.lang("as_battle_1451031565_378"));
				}
			}
		}
		
		public function updateLockSkillStateUpdate(value:Boolean):void
		{
			lockSkillStateUpdate = value;
		}
		
		private var lockSkillStateUpdate:Boolean;
		public function updateSkillStates(skillState:SkillStatuInfo):void
		{
			var battleNinja:Ninja;
			
			new UpdateBattleViewSkillStateNotice(skillState).send();
			
			if(BattleData.singleton.guidState == BattleData.GUID_SKILL_REQUEST){
				updateSkillBtnWithSkillCfg();
				return ;
			}
			
			checkCDFinish(skillState.pos, skillState.skillIndex, skillState.cdRound);
			this.setDied(skillState.pos, false);
			setMpLack(skillState.pos, false, skillState.skillIndex);
			this.setLock(skillState.pos, false, skillState.skillIndex);
			this.setControled(skillState.pos, false);
			this.showCoolDown(skillState.pos, skillState.skillIndex, 0);
			this.setSkillId(skillState.pos, skillState.skillIndex, skillState.skillId);
			
			battleNinja = FightManagerCenter.ninjaMgr.getNinjaByPos(skillState.pos);
			if(battleNinja)
			{
				battleNinja.data.specialSkillIds[skillState.skillIndex] = skillState.skillId;
			}
			
			if(skillState.canUseSkill == false)
			{
				for each(var skillProhibitType:int in skillState.skillProhibitType)
				{
					switch(skillProhibitType)
					{
						case SkillProhibitType.NINJA_DEAD:
							this.setDied(skillState.pos, true);
							break;
						case SkillProhibitType.NINJA_NOT_ATTACK:
						case SkillProhibitType.NINJA_SKILL_CONGEST:
							this.setLock(skillState.pos, true, skillState.skillIndex);
							break;
						case SkillProhibitType.SKILL_CHAKRA_LACK:
							setMpLack(skillState.pos, true, skillState.skillIndex);
							setLock(skillState.pos, true, skillState.skillIndex);
							break;
						case SkillProhibitType.NINJA_UNDER_CONTROL:
							this.setControled(skillState.pos, true);
							break;
						case SkillProhibitType.SKILL_COOL_DOWN:
							this.showCoolDown(skillState.pos, skillState.skillIndex, skillState.cdRound);
							break;
					}
				}
			}
			else
			{
				this.setDied(skillState.pos, false);
				this.setLock(skillState.pos, false, skillState.skillIndex);
				this.setControled(skillState.pos, false);
				this.showCoolDown(skillState.pos, skillState.skillIndex, skillState.cdRound);
				this.setMpLack(skillState.pos, false, skillState.skillIndex);
			}
			
			if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				this.setLock(skillState.pos, true, skillState.skillIndex);
			}
			
			
			updateSkillBtnWithSkillCfg();
			nofitySkillStates();
		}
		
		public function lockAllSkillBtns():void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				btn.lock = true;
			}
		}
		
		public function unlockAllSkillBtns():void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				btn.lock = false;
			}
		}
		
		public function ninjaEnter():void
		{
			this.updatePlayerViewInfo();
		}
		
		public function ninjaExeunt():void
		{
			this.updatePlayerViewInfo();
		}
		
		public function updatePlayerOnline(teamId:uint, isOnline:Boolean):void
		{
			var player:UIPlayerData;
			
			player = uiData.getPlayer(teamId);
			if(player)
			{
				player.setOnline(isOnline);
			}
		}
		
		public function updateSkillBtn(ninjaPos:int, ninjaId:int, skillIndex:int, skillStatusInfos:Array):void
		{
			var ninjaIndex:int;
			var ninjaUi:UINinjaData;
			var btn:SkillButtonView;
			var skillId:int;
			var skillStatus:SkillStatuInfo;
			var ninjaCfg:NinjaBattleCfgInfo;
			
			if(uiData.self == null)
			{
				return ;
			}
			
			ninjaCfg = NinjaConfig.getNinjaInfoById(ninjaId)
			ninjaUi = uiData.isControlNinja(ninjaPos);
			
			if(ninjaUi == null)
			{
				return ;
			}
			
			if(ninjaCfg.cfgInfo.type == NinjaDef.TYPE_CONTRACT_PET)//召唤兽
			{
				ninjaIndex = uiData.self.ninjas.indexOf(ninjaUi);
				for each(skillStatus in skillStatusInfos)
				{
					btn = skillBtns[ninjaIndex + skillStatus.skillIndex];
					btn.updateBase(ninjaId, ninjaPos, skillStatus.skillId, skillStatus.skillIndex);
				}
			}
			else if(skillIndex != -1)//服务器下发了位置
			{
				btn = skillBtns[skillIndex];
				skillStatus = skillStatusInfos[0];
				if(skillStatus)
				{
					btn.updateBase(ninjaId, ninjaPos, skillStatus.skillId, skillStatus.skillIndex);
				}
				else//登场的忍者没有奥义技
				{
					btn.clear();
				}
			}
			else//找个坑填进去
			{
				for(var i:int=0;i<skillBtns.length;i++)
				{
					btn = skillBtns[i];
					if(btn.skillId == 0)
					{
						skillStatus = skillStatusInfos[0];
						if(skillStatus)
						{
							btn.updateBase(ninjaId, ninjaPos, skillStatus.skillId, skillStatus.skillIndex);
						}
						else//登场的忍者没有奥义技
						{
							btn.clear();
						}
						break;
					}
				}
			}
			
		}
		
		private function nofitySkillStates():void
		{
			var skillBtn:SkillButtonView;
			var skillEnableList:Array = [];
			var skillBtnList:Array = [];
			
			for(var i:int = 0;i < skillBtns.length - 1;i ++)
			{
				skillBtn = skillBtns[i];
				skillEnableList.push(!skillBtn.disabled);
				skillBtnList.push(skillBtn);
			}
			
			new UpdateGuidSkillStateCommand(skillEnableList, skillBtnList).call();
		}
		
		public function showGuidSkill(type:int, index:int):void
		{
			skillGuidView.updateGuidState(type, skillBtns[index]);
		}
		
		public function showTargetGuidTips():void
		{
			if(!targetGuidTips)
			{
				targetGuidTips = new TargetGuidTips();
				targetGuidTips.visible = false;
			}
			
			if(_uiShowing == true)
			{
				targetGuidTips.visible = true;
			}
			
			DisplayUtils.replaceDisplay(viewUI.targetGuidTipsPos, targetGuidTips);
			
			onResize(null);
		}
		
		public function hideTargetGuidTips():void
		{
			if(targetGuidTips && targetGuidTips.parent)
			{
				targetGuidTips.parent.removeChild(targetGuidTips);
			}
		}
		
		private function updateSkillBtnWithSkillCfg():void 
		{
			
			var btn:SkillButtonView;
			var skillCfg:SkillCFG;
			for(var i:int=0;i<skillBtns.length;i++)
			{
				btn = skillBtns[i];
				
				if(btn.skillId == 0 || btn.isContractPet == true)
				{
					continue ;
				}
				
				skillCfg = SkillConfig.instance.getSkill(btn.skillId);
				
				btn.mp = skillCfg.mp;
				btn.skillCoolDown = skillCfg.cd;
				//				btn.openType = skillCfg.openType;
				btn.updateState();
				
				TipsManager.singleton.binding(btn,skillCfg,TipsTypeDef.SKILL);
			}
		}
		
		public function showDamageView():void
		{
			damageInfoView = new FightDamageView();
			damageInfoView.update(damageInfo);
			damageInfoView.show();
		}
		
		public function updateDamageInfo(damageInfo:DamageInfo):void
		{
			this.damageInfo = damageInfo;
		}
		
		public function setSkillButtonEnabled(value:Boolean):void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				btn.mouseEnabled = value;
			}
		}
		
		public function reduceCoolDown():void
		{
			var btn:SkillButtonView
			
			for each(btn in skillBtns)
			{
				if(btn.lock == false && btn.cd > 0)
				{
					btn.cd = Math.max(0,btn.cd-1);
					btn.updateState();
				}
			}
		}
		
		public function setSyncLock(ninjaPos:int, value:Boolean, index:int):void
		{
			var btn:SkillButtonView
			
			for each(btn in skillBtns)
			{
				if(btn.ninjaPos == ninjaPos && btn.index == index)
				{
					btn.syncLock = value;
					btn.updateState();
				}
			}
		}
		
		public function setMpLack(ninjaPos:int, value:Boolean, index:int):void
		{
			var btn:SkillButtonView
			
			for each(btn in skillBtns)
			{
				if(btn.ninjaPos == ninjaPos && btn.index == index)
				{
					btn.lackMp = value;
					btn.updateState();
				}
			}
		}
		
		public function setLock(ninjaPos:int, value:Boolean, index:int):void
		{
			var btn:SkillButtonView
			
			for each(btn in skillBtns)
			{
				if(btn.visible == false)
				{
					continue ;
				}
				
				if(btn.ninjaPos == ninjaPos && btn.index == index)
				{
					btn.lock = value;
					btn.updateState();
				}
			}
		}
		
		public function isLocked(ninjaPos:int):Boolean
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				if(btn.visible == false)
				{
					continue ;
				}
				
				if(btn.ninjaPos == ninjaPos)
				{
					return btn.lock;
				}
			}
			
			return false;
		}
		
		private function checkCDFinish(ninjaPos:int, index:int, cd:int):void
		{
			var btn:SkillButtonView;
			
			for each(btn in skillBtns)
			{
				if(btn.visible == false)
				{
					continue ;
				}
				
				if(btn.ninjaPos == ninjaPos && btn.index == index && btn.died == false)
				{
					if(cd == 0 && btn.cd != 0)
					{
						btn.showCDEffect();
					}
				}
			}
		}
		
		public function showCoolDown(ninjaPos:int, index:int, cd:int):void
		{
			var btn:SkillButtonView;
			
			for each(btn in skillBtns)
			{
				if(btn.visible == false)
				{
					continue ;
				}
				
				if(btn.ninjaPos == ninjaPos && btn.index == index)
				{
					btn.cd = cd;
					btn.updateState();
					break;
				}
			}
		}
		
		public function setControled(ninjaPos:int,value:Boolean):void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				if(btn.ninjaPos == ninjaPos)
				{
					btn.controlled = value;
					btn.updateState();
					break;
				}
			}
		}
		
		public function setDied(ninjaPos:int,value:Boolean):void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				if(btn.ninjaPos == ninjaPos)
				{
					btn.died = value;
					btn.updateState();
					break;
				}
			}
		}
		
		public function setSkillId(ninjaPos:int, skillIndex:int, skillId:int):void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				if(btn.ninjaPos == ninjaPos && btn.index == skillIndex)
				{
					btn.skillId = skillId;
				}
			}
		}
		
		public function clearHitCount(isLeft:Boolean):void
		{
			if(isLeft)
			{
				if(leftHitNumberView){leftHitNumberView.clear()};
			}else
			{
				if(rightHitNumberView){rightHitNumberView.clear()};
			}
		}
		
		public function hitCount(isLeft:Boolean,v:int):void
		{
			if(isLeft)
			{
				if(leftHitNumberView == null)
				{
					leftHitNumberView = new HitNumberView();
					addChild(leftHitNumberView);
				}
				leftHitNumberView.to(v);
				leftHitNumberView.x = viewUI.x + viewUI.leftHitPos.x;
				leftHitNumberView.y = viewUI.y + viewUI.leftHitPos.y;
			}else
			{
				if(rightHitNumberView == null)
				{
					rightHitNumberView = new HitNumberView();
					addChild(rightHitNumberView);
				}
				rightHitNumberView.to(v);
				rightHitNumberView.x = viewUI.x + viewUI.rightHitPos.x;
				rightHitNumberView.y = viewUI.y + viewUI.rightHitPos.y;
			}
		}
		
		public function setUIData(uiData:UIData):void
		{
			if(uiData)
			{
				uiData.removeEventListener(UIDataEvent.ADD_PLAYER, onAddPlayer);
				uiData.removeEventListener(UIDataEvent.REMOVE_PLAYER, onRemovePlayer);
				uiData.removeEventListener(UIDataEvent.PLAYER_UPDATE, onPlayerUpdate);
				if(uiData.self)
				{
					uiData.self.removeEventListener(UIDataEvent.UPDATE_ALL, onMainPlayerUpdate);
					uiData.self.removeEventListener(UIDataEvent.BASE_INFO_UPDATE, onMainPlayerUpdate);
				}
			}
			
			this.uiData = uiData;
			this.uiData.addEventListener(UIDataEvent.ADD_PLAYER, onAddPlayer);
			this.uiData.addEventListener(UIDataEvent.REMOVE_PLAYER, onRemovePlayer);
			this.uiData.addEventListener(UIDataEvent.PLAYER_UPDATE, onPlayerUpdate);
			if(uiData.self)
			{
				uiData.self.addEventListener(UIDataEvent.UPDATE_ALL, onMainPlayerUpdate);
				uiData.self.addEventListener(UIDataEvent.BASE_INFO_UPDATE, onMainPlayerUpdate);
			}
			
			updatePetSkillInfo();
			updatePlayerViewInfo();
			updateSelfMp();
		}
		
		private function onMainPlayerUpdate(evt:UIDataEvent):void
		{
			updateSelfMp();
		}
		
		private function updateSelfMp():void
		{
			if(uiData.self == null)
			{
				return ;
			}
			
			skillMpText:TextField;
			skillMpFire:MovieClip;
			skillMpValueBar;
			
			skillMpText.text = Math.max(0, uiData.self.mp) + "/" + uiData.self.mpMax;
			skillMpValueBar.update(uiData.self.mp, uiData.self.mpMax);
			viewUI.skillPanelView.indicator["bar"].gotoAndPlay(2);
		}
		
		private function updateCustomPlayerInfo():void
		{
			var customBattleCfg:CustomBattleCfg;
			var leftMainPlayer:UIPlayerData;
			var rightMainPlayer:UIPlayerData;
			
			if(uiData.self == null || uiData.customInfo == null)
			{
				return ;
			}
			
			leftMainPlayer = getLeftMainPlayerInfo();
			rightMainPlayer = getRightMainPlayerInfo();
			
			if(leftMainPlayer)
			{
				leftMainPlayer.setMainNinjaId(-1);
			}
			
			if(rightMainPlayer)
			{
				rightMainPlayer.setMainNinjaId(-1);
			}
			
			if(uiData.customInfo.customFightId != 0)
			{
				customBattleCfg = CustomBattleConfig.getCustomBattleCfg(uiData.customInfo.customFightId, uiData.customInfo.sectionId);
				
				if(customBattleCfg != null && customBattleCfg.leftHead != 0)
				{
					getLeftMainPlayerInfo().setMainNinjaId(customBattleCfg.leftHead);
				}
				
				if(customBattleCfg != null && customBattleCfg.rightHead != 0)
				{
					getRightMainPlayerInfo().setMainNinjaId(customBattleCfg.rightHead);
				}
			}
		}
		
		private function onSelfMpValueBarUpdate(evt:ValueBarEvent):void
		{
			var mpRes:MovieClip;
			
			//mpRes = viewUI["skill"]["mp"];
			//skillMpFire.x = mpRes.x + mpRes.width;
		}
		
		public function setCustomFightInfo(custom:CustomInfo, endTipsModel:int, enableExit:Boolean, endCondition:String):void
		{
			var customBattleCfg:CustomBattleCfg;
			
			
			updateExitBtnVisible();
			if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_DUNGEON_SPECIAL)
			{
				return ;
			}
			
			uiData.customInfo = custom;
			
			if(endTipsModel != 0)
			{
				battleInfoView.show();
				battleInfoView.updateEndInfo(custom.curWave, custom.totalWave, endCondition, endTipsModel);
			}
			else
			{
				battleInfoView.hide();
			}
			
			updateCustomPlayerInfo();
		}
		
		private function setLackMp(value:Boolean):void
		{
			var btn:SkillButtonView;
			
			for each(btn in skillBtns)
			{
				btn.lackMp =  value;
				btn.updateState();
			}
		}
		
		public function destroy():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onStage);
			removeEventListener(Event.REMOVED_FROM_STAGE,onStage);
			if(BattleData.singleton.fightType != RequestFightStartTypeDef.FIRST_GUID_FIGHT)
			{
				TeamUtils.model.removeEventListener(ModelEvent.UPDATE, onTeamModelUpdate);
			}
			TweenManager.killTweensOf(this);
			TweenLite.killTweensOf(roundCountView);
			if(parent)
			{
				parent.removeChild(this);
			}
			
			if(roundCountView)
			{
				roundCountView.destroy();
			}
			
			if(damageInfoView)
			{
				damageInfoView.destroy();
				damageInfoView = null;
			}
			
			skillGuidView.destroy();
			if(skillGuidView.parent){skillGuidView.parent.removeChild(skillGuidView);}
			
			
			UIData.singleton.removeEventListener(UIDataEvent.UPDATE_SELF, onUpdateSelf);
			if(uiData)
			{
				if(uiData.self){uiData.self.removeEventListener(UIDataEvent.BASE_INFO_UPDATE, onMainPlayerUpdate);}
				
				uiData.removeEventListener(UIDataEvent.ADD_PLAYER, onAddPlayer);
				uiData.removeEventListener(UIDataEvent.REMOVE_PLAYER, onRemovePlayer);
				uiData.removeEventListener(UIDataEvent.PLAYER_UPDATE, onPlayerUpdate);
				skillMpValueBar.removeEventListener(ValueBarEvent.UPDATE, onSelfMpValueBarUpdate);
				skillMpValueBar.removeEventListener(ValueBarEvent.COMPLETE, onSelfMpValueBarUpdate);
				uiData.rest();
				uiData = null;
			}
			
			TipsManager.singleton.unbinding(autoFightBtn);
			autoFightBtn.removeEventListener(MouseEvent.CLICK, onAutoFight);
			
			var btn:SkillButtonView;
			for each(btn in skillBtns)
			{
				TipsManager.singleton.unbinding(btn, TipsTypeDef.SKILL);
				btn.removeEventListener(MouseEvent.CLICK,onClickBtn);
				btn.destroy();
			}
			skillBtns = null;
			
			if(fightOverView)
			{
				fightOverView.destroy();
				fightOverView = null;
			}
			
			if(motionPlayer)
			{
				if(motionPlayer.parent)
				{
					motionPlayer.parent.removeChild(motionPlayer);
				}
				motionPlayer = null;
			}
			
			if(oursSkillPromptView)
			{
				if(oursSkillPromptView.parent)
				{
					oursSkillPromptView.parent.removeChild(oursSkillPromptView);
				}
				oursSkillPromptView.destroy();
				oursSkillPromptView = null;
			}
			
			if(theirsSkillPromptView)
			{
				if(theirsSkillPromptView.parent)
				{
					theirsSkillPromptView.parent.removeChild(theirsSkillPromptView);
				}
				theirsSkillPromptView.destroy();
				theirsSkillPromptView = null;
			}
			
			if(leftHitNumberView)
			{
				if(leftHitNumberView.parent)
				{
					leftHitNumberView.parent.removeChild(leftHitNumberView);
				}
				leftHitNumberView.destroy();
				leftHitNumberView = null;
			}
			if(rightHitNumberView)
			{
				if(rightHitNumberView.parent)
				{
					rightHitNumberView.parent.removeChild(rightHitNumberView);
				}
				rightHitNumberView.destroy();
				rightHitNumberView = null;
			}
			
			if(viewUI)
			{
				if(viewUI.parent)
				{
					viewUI.parent.removeChild(viewUI);
				}
				viewUI = null;
			}
			
			if(targetGuidTips && targetGuidTips.parent)
			{
				targetGuidTips.parent.removeChild(targetGuidTips);
			}
			
			speedUpBtn.destroy();
			leftMainPlayer.destroy();
			leftPlayer1.destroy();
			leftPlayer2.destroy();
			rightMainPlayer.destroy();
			rightPlayer1.destroy();
			rightPlayer2.destroy();
			battleInfoView.destroy();
			
			useSkillFun = null;
			prewarChooseView = null;
			
			LayerManager.singleton.removeItemToLayer(videoView);
			speedUpBtn.removeEventListener(MouseEvent.CLICK, onSpeedUp);
			videoView.removeEventListener(VideoViewEvent.VIDEO_COMPLETE, onVideoComplete);
			videoView.destroy();
			
			battleGiveUpAreaView.destroy();
			
			LayerManager.singleton.removeItemToLayer(_frameUI);
			
			TimerProvider.removeTimeTask(TimerDef.SECOND, onCountDownEvent);
			
			autoSetNull();
		}
		
		public function disableExit():void
		{
			battleGiveUpAreaView.disableExit();
		}
		
		public function enableExit():void
		{
			battleGiveUpAreaView.enableExit();
		}
		
		public function updateLeftRound(round:int):void
		{
			battleGiveUpAreaView.updateRound(round);
		}
		
		public function getLeftRound():int
		{
			return battleGiveUpAreaView.getRound();
		}
		
		public function addRoundCount(roundIndex:int):void
		{
			if (!roundCountView)
			{
				roundCountView = new RoundCountView();
			}
			roundCountView.count = roundIndex;
			battleGiveUpAreaView.subRound();
			roundCountAppear();
		}
		
		private function roundCountAppear():void
		{
			if(BattleData.singleton.fightType != RequestFightStartTypeDef.FIRST_GUID_FIGHT)
			{
				viewUI.roundCountPos.addChild(roundCountView);
				roundCountView.alpha = 0;
				TweenManager.addTweenTo(roundCountView, 0.5, {alpha:1, onComplete:roundCountDisappear});
			}
		}
		
		private function roundCountDisappear():void
		{
			TweenManager.addTweenTo(roundCountView, 0.5, {alpha:0, delay:1.5});
		}
		
		public function showSkillPrompt(pos:int, comboIndex:int, skillId:uint):void
		{
			var skillCfg:SkillCFG = SkillConfig.instance.getSkill(skillId);
			var nd:UINinjaData = uiData.getNinja(pos);
			if(uiData.isOurNinjaPos(pos))
			{
				oursSkillPromptView.addPrompt(nd.id, comboIndex, skillCfg, false);
			}
			else
			{
				theirsSkillPromptView.addPrompt(nd.id, comboIndex, skillCfg, true);
			}
		}
		
		public function clearSkillPrompt():void
		{
			oursSkillPromptView.clearPrompt();
			theirsSkillPromptView.clearPrompt();
		}
		/**打开战前准备的选择面板*/
		public function showPerwarChoose(command:ShowPrewarChooseCommand):void
		{
			prewarChooseView ||= new PrewarChooseView();
			
			viewUI.prewarPos.addChild(prewarChooseView);
			prewarChooseView.showEffect();
			prewarChooseView.command = command;
		}
		
		public function hidePrewar():void
		{
			if(prewarChooseView)
			{
				prewarChooseView.hide();
			}
		}
		
		public function showPrewarCloseEffect():void
		{
			if(prewarChooseView)
			{
				prewarChooseView.showHideEffect();
			}
		}
		
		public function showResult(isWin:Boolean, showDamage:Boolean):void
		{
			skillGuidView.updateGuidState(-1, null);
			
			fightOverView = new FightOverView(isWin, showDamage);
			viewUI.resultPos.addChild(fightOverView);
			
			clearSkillPrompt();
		}
		
		public function getUIIsShowing():Boolean
		{
			return _uiShowing;
		}
		
		public var skillYOffset:int;
		public function showUI():void
		{
			stage.focus = null;
			
			TweenManager.addTweenTo(viewUI.ours, 0.5, {y:0});
			TweenManager.addTweenTo(viewUI.theirs, 0.5, {y:0});
			TweenManager.addTweenTo(battleInfoView.res, 0.5, {alpha:1});
			
			TweenManager.addTweenTo(this, 0.5, {skillYOffset:0, onUpdate:onSkillOffsetUpdate, onComplete:onSkillOffsetComplete});
			
			_uiShowing = true;
		}
		
		public function updateBattleSkillStatus(status:int):void
		{
			trace("updateBattleSkillStatus", status);
			switch(status)
			{
				case BattleData.SKILL_STATUS_WATCH_ON:
					viewUI.watchOffEffect.visible = false;
					viewUI.skillStatus.label.gotoAndStop(1);
					viewUI.skillStatus.visible = true;
					viewUI.skillStatus.gotoAndStop(1);
					viewUI.skillStatus.gotoAndPlay(0);
					break;
				case BattleData.SKILL_STATUS_WATCH_OFF:
					viewUI.skillStatus.visible = false;
					viewUI.watchOffEffect.visible = true;
					viewUI.watchOffEffect.gotoAndStop(1);
					viewUI.watchOffEffect.gotoAndPlay(0);
					break;
				case BattleData.SKILL_STATUS_GIVE_UP:
					viewUI.watchOffEffect.visible = false;
					viewUI.skillStatus.label.gotoAndStop(2);
					viewUI.skillStatus.visible = true;
					viewUI.skillStatus.gotoAndStop(1);
					viewUI.skillStatus.gotoAndPlay(0);
					break;
				case BattleData.SKILL_STATUS_AUTO_FIGHT:
					viewUI.watchOffEffect.visible = false;
					viewUI.skillStatus.label.gotoAndStop(3);
					viewUI.skillStatus.visible = true;
					viewUI.skillStatus.gotoAndStop(1);
					viewUI.skillStatus.gotoAndPlay(0);
					break;
			}
		}
		
		public function showGiveUpInfo():void
		{
			battleGiveUpAreaView.visible = true;		
			updateExitBtnVisible();		
		}
		
		public function clearAllSkillBtn():void
		{
			for each(var skillView:SkillButtonView in skillBtns)
			{
				if(skillView.isContractPet)
				{
					continue ;
				}
				
				skillView.clear();
				TipsManager.singleton.unbinding(skillView, TipsTypeDef.SKILL);
			}
		}
		
		private function updateExitBtnVisible():void
		{
			var customCfg:CustomBattleCfg;
			
			customCfg = CustomBattleConfig.getCustomBattleCfg(BattleData.singleton.curCustomBattleId, BattleData.singleton.curSectionId);
			if((customCfg && customCfg.enableExit == false) || BattleTypeGroup.isEnableExitType(BattleData.singleton.fightType) == false)
			{
				battleGiveUpAreaView.exitBtnVisible = false;
			}
			else
			{
				if(ApplicationData.singleton.selfInfo.teamId != null && ApplicationData.singleton.selfInfo.teamId != "")
				{
					battleGiveUpAreaView.exitBtnVisible = ApplicationData.singleton.selfInfo.isCaptain;
				}
				else
				{
					battleGiveUpAreaView.exitBtnVisible = true;
				}
			}
			
			//队员不给撤退

		}
		
		private function onSkillOffsetUpdate():void
		{
			var stageHeight:int;
			
			if(stage)
			{
				stageHeight = stage.stageHeight;
				stageHeight = Math.min(stageHeight, maxHeight);
				stageHeight = Math.max(stageHeight, minHeight);
				viewUI.skillPanelView.y = stageHeight - skillPanelHeight + skillYOffset;
			}
		}
		
		private function onSkillOffsetComplete():void
		{
			var stageHeight:int;
			
			viewUI.autoFightTips.alpha = 1;
			
			if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_DUNGEON_SPECIAL)
			{
				battleInfoView.show();
			}
			
			if(stage)
			{
				stageHeight = stage.stageHeight;
				stageHeight = Math.min(stageHeight, maxHeight);
				stageHeight = Math.max(stageHeight, minHeight);
				viewUI.skillPanelView.y = stageHeight - skillPanelHeight + skillYOffset;
			}
			setTimeout(updateGuid, 200);
		}
		
		public function showSkillPanel():void
		{
			viewUI.skillPanelView.visible = true;
		}
		
		public function hideSkillPanel():void
		{
			viewUI.skillPanelView.visible = false;
		}
		
		private function updateGuid():void
		{
			skillGuidView.showAnimation();
			skillGuidView.update();
			
			if(targetGuidTips)
			{
				targetGuidTips.visible = true;
			}
		}
		
		public function showUIEffect(globePos:Point, ninjaPos:int, effect:MmeAssetRender):void
		{
			var localPos:Point;
			var dest:Point;
			var isOurNinjaPos:Boolean;
			
			localPos = globalToLocal(globePos);
			addChild(effect);
			effect.x = localPos.x;
			effect.y = localPos.y;
			
			isOurNinjaPos = uiData.isOurNinjaPos(ninjaPos);
			
			dest = new Point();
			
			if(isOurNinjaPos)
			{
				dest.x = viewUI.x + viewUI.ours.x - viewUI.ours["mpbar"].x + viewUI.ours["mpbar"].width;
				dest.y = viewUI.y + viewUI.ours["mpbar"].y;
			}
			else
			{
				dest.x = viewUI.x + viewUI.theirs.x + viewUI.ours["mpbar"].x + viewUI.theirs["mpbar"].width;
				dest.y = viewUI.y + viewUI.theirs["mpbar"].y;
			}
			
			effect.gotoAction("flying", 0, true);
			TweenManager.addTweenTo(effect, 0.4, {x:dest.x,y:dest.y,onComplete:onUIEffectDone,onCompleteParams:[effect]});
		}
		
		private function onUIEffectDone(effect:MmeAssetRender):void
		{
			
			effect.gotoAction("flyEnd", 0, true);
			effect.addEventListener(MmeAssetRenderEvent.PLAY_END, onUIEffectEnd);
		}
		
		private function onUIEffectEnd(evt:Event):void
		{
			var effect:MmeAssetRender;
			
			effect = evt.target as MmeAssetRender;
			effect.removeEventListener(MmeAssetRenderEvent.PLAY_END, onUIEffectEnd);
			removeChild(effect);
		}
		
		public function showSkillOrbit(ninjaPos:uint, ninjaXY:Point):void
		{
			for each(var btn:SkillButtonView in skillBtns)
			{
				if(btn.ninjaPos == ninjaPos)
				{
					var img:Image = new Image();
					img.load(SkillAssetDef.getAsset(SkillAssetDef.SKILL_ICON,btn.skillId));
					img.x = btn.x + viewUI.skillPanelView.x + viewUI.x;
					img.y = btn.y + viewUI.skillPanelView.y + viewUI.y;
					addChild(img);
					
					var tp:Point = globalToLocal(ninjaXY);
					tp.x -= 20;
					tp.y -= 150;
					
					TweenManager.addTweenTo(img,0.4,{x:tp.x,y:tp.y,onComplete:onSkillOrbitDone,onCompleteParams:[img]});
					
					break;
				}
			}
		}
		
		private function onSkillOrbitDone(img:Image):void
		{
			img.dispose();
			if(img.parent)
			{
				img.parent.removeChild(img);
			}
		}
		
		public function updateCurtain(start:Boolean):void
		{
			if(start)
			{
				curtainLayer.mouseEnabled = true;
				TweenManager.addTweenTo(curtainLayer, 0.5, {alpha:1});
			}
			else
			{
				TweenManager.addTweenTo(curtainLayer, 0.5, {alpha:0, onComplete:onCurtainComplete});
			}
		}
		
		private function onCurtainComplete():void
		{
			curtainLayer.mouseEnabled = false;
		}
		
		public function playVideo(url:String):void
		{
			videoView.play(url);
			LayerManager.singleton.addItemToLayer(videoView, LayerDef.VIDEO);
		}
		
		private function onVideoComplete(evt:VideoViewEvent):void
		{
			LayerManager.singleton.removeItemToLayer(videoView);
			this.dispatchEvent(evt);
		}
		
		private function updatePetSkillInfo():void
		{
			var btn:SkillButtonView;
			
			if(uiData.self == null)
			{
				return ;
			}
			
			if(uiData.self.contractPetId != 0)
			{
				btn = skillBtns[4];
				btn.isContractPet = true;
				//				btn.updateBase(uiData.selfNinja.id, -100, uiData.self.contractPetId, 0);
				btn.updateBase(-1, -100, uiData.self.contractPetId, 0);
			}
			
			//			if(!ApplicationData.singleton.isDebug)
			//			{
			btn = skillBtns[4];
			btn.visible = false;
			//			}
		}
		
		private function updatePlayerViewInfo():void
		{
			if(uiData.self == null)
			{
				return ;
			}
			
			leftMainPlayer.setPlayer(getLeftMainPlayerInfo());
			leftPlayer1.setPlayer(getLeftPlayer1Info());
			leftPlayer2.setPlayer(getLeftPlayer2Info());
			
			rightMainPlayer.setPlayer(getRightMainPlayerInfo());
			if(uiData.customInfo.customFightId == 0)
			{
				rightPlayer1.setPlayer(getRightPlayer1Info());
				rightPlayer2.setPlayer(getRightPlayer2Info());
			}
			else
			{
				rightPlayer1.setPlayer(null);
				rightPlayer2.setPlayer(null);
			}
		}
		
		private function getLeftMainPlayerInfo():UIPlayerData
		{
			var playerInfo:UIPlayerData;
			
			playerInfo = uiData.self;
			if(playerInfo && playerInfo.ninjas.length != 0)
			{
				return playerInfo;
			}
			
			for each(var otherPlayerInfo:UIPlayerData in uiData.ours)
			{
				return otherPlayerInfo;
			}
			
			return playerInfo;
		}
		
		private function getLeftPlayer1Info():UIPlayerData
		{
			for each(var playerInfo:UIPlayerData in uiData.ours)
			{
				if(playerInfo == leftMainPlayer.getPlayer())
				{
					continue ;
				}
				
				if(playerInfo.ninjas.length == 0)
				{
					continue ;
				}
				
				return playerInfo;
			}
			
			return null;
		}
		
		private function getLeftPlayer2Info():UIPlayerData
		{
			for each(var playerInfo:UIPlayerData in uiData.ours)
			{
				if(playerInfo == leftMainPlayer.getPlayer())
				{
					continue ;
				}
				
				if(playerInfo == leftPlayer1.getPlayer())
				{
					continue ;
				}
				
				if(playerInfo.ninjas.length == 0)
				{
					continue ;
				}
				
				return playerInfo;
			}
			
			return null;
		}
		
		private function getRightMainPlayerInfo():UIPlayerData
		{
			var player:UIPlayerData;
			var mainPlayerTeamId:int;
			
			if(uiData.customInfo.customFightId != 0)
			{
				return uiData.monster;
			}
			
			mainPlayerTeamId = getRightMainPlayerTeamId();
			if(mainPlayerTeamId != -1)
			{
				return uiData.getPlayer(mainPlayerTeamId);
			}
			
			return null;
		}
		
		private function getRightPlayer1Info():UIPlayerData
		{
			for each(var playerInfo:UIPlayerData in uiData.theirs)
			{
				if(rightMainPlayer.getPlayer() && playerInfo.teamId == rightMainPlayer.getPlayer().teamId)
				{
					continue ;
				}
				
				if(playerInfo.ninjas.length == 0)
				{
					continue ;
				}
				
				return playerInfo;
			}
			
			return null;
		}
		
		private function getRightPlayer2Info():UIPlayerData
		{
			for each(var playerInfo:UIPlayerData in uiData.theirs)
			{
				if(rightMainPlayer.getPlayer() && playerInfo.teamId == rightMainPlayer.getPlayer().teamId)
				{
					continue ;
				}
				
				if(rightPlayer1.getPlayer() && playerInfo.teamId == rightPlayer1.getPlayer().teamId)
				{
					continue ;
				}
				
				if(playerInfo.ninjas.length == 0)
				{
					continue ;
				}
				
				return playerInfo;
			}
			
			return null;
		}
		
		private function getRightMainPlayerTeamId():int
		{
			var destTeamId:int = -1;
			
			switch(uiData.self.teamId)
			{
				case 2:
					if(checkPlayerExist(3)){destTeamId = 3; break;}
					if(checkPlayerExist(5)){destTeamId = 5; break;}
					if(checkPlayerExist(1)){destTeamId = 1; break;}
					break;
				case 0:
					if(checkPlayerExist(1)){destTeamId = 1; break;}
					if(checkPlayerExist(5)){destTeamId = 5; break;}
					if(checkPlayerExist(3)){destTeamId = 3; break;}
					break;
				case 4:
					if(checkPlayerExist(5)){destTeamId = 5; break;}
					if(checkPlayerExist(1)){destTeamId = 1; break;}
					if(checkPlayerExist(3)){destTeamId = 3; break;}
					break;
			}
			
			switch(uiData.self.teamId)
			{
				case 3:
					if(checkPlayerExist(2)){destTeamId = 2; break;}
					if(checkPlayerExist(4)){destTeamId = 4; break;}
					if(checkPlayerExist(0)){destTeamId = 0; break;}
					break;
				case 1:
					if(checkPlayerExist(0)){destTeamId = 0; break;}
					if(checkPlayerExist(4)){destTeamId = 4; break;}
					if(checkPlayerExist(2)){destTeamId = 2; break;}
					break;
				case 5:
					if(checkPlayerExist(4)){destTeamId = 4; break;}
					if(checkPlayerExist(0)){destTeamId = 0; break;}
					if(checkPlayerExist(2)){destTeamId = 2; break;}
					break;
			}
			
			return destTeamId;
		}
		
		private function checkPlayerExist(teamId:int):Boolean
		{
			var player:UIPlayerData;
			
			for each(player in uiData.theirs)
			{
				if(player.teamId == teamId && player.ninjas.length != 0)
				{
					return true;
				}
			}
			
			for each(player in uiData.ours)
			{
				if(player.teamId == teamId && player.ninjas.length != 0)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function onTeamModelUpdate(evt:ModelEvent):void
		{
			var chatItem:ChatItem;
			var uiPlayerData:UIPlayerData;
			
			if (evt.key == TeamModel.KEY_MEMBER_TALK)
			{
				chatItem = evt.newValue as ChatItem;
				if (leftPlayer1)
				{
					uiPlayerData = leftPlayer1.getPlayer();
					if (uiPlayerData && uiPlayerData.uin == chatItem.talker_key.uin && uiPlayerData.serId == chatItem.talker_key.svrId && uiPlayerData.roleId == chatItem.talker_key.roleId)
					{
						leftPlayer1.showTalkText(chatItem.chatContext);
					}
				}
				if (leftPlayer2)
				{
					uiPlayerData = leftPlayer2.getPlayer();
					if (uiPlayerData && uiPlayerData.uin == chatItem.talker_key.uin && uiPlayerData.serId == chatItem.talker_key.svrId && uiPlayerData.roleId == chatItem.talker_key.roleId)
					{
						leftPlayer2.showTalkText(chatItem.chatContext);
					}
				}
			}
		}
		
		public function updateMoneyNow():void
		{
			battleInfoView.updateMoneyNow();
		}
		
		public function autoSetNull():void
		{
			
			viewUI = null;
			motionPlayer = null;
			skillBtns = null;
			leftHitNumberView = null;
			rightHitNumberView = null;
			uiData = null;
			battleData = null;
			useSkillFun = null;
			roundCountView = null;
			fightOverView = null;
			prewarChooseView = null;
			oursSkillPromptView = null;
			theirsSkillPromptView = null;
			videoView = null;
			leftMainPlayer = null;
			leftPlayer1 = null;
			leftPlayer2 = null;
			rightMainPlayer = null;
			rightPlayer1 = null;
			rightPlayer2 = null;
			skillMpText = null;
			skillMpFire = null;
			skillMpValueBar = null;
			skillGuidView = null;
			targetGuidTips = null;
			battleInfoView = null;
			speedUpBtn = null;
			autoFightBtn = null;
		}
	}
}
