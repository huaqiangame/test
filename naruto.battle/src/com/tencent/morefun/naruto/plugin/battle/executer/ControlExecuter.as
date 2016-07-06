package com.tencent.morefun.naruto.plugin.battle.executer
{
	
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.framework.net.LoadManager;
	import com.tencent.morefun.framework.net.pub;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.battle.cfg.CustomBattleCfg;
	import com.tencent.morefun.naruto.plugin.battle.cfg.CustomBattleConfig;
	import com.tencent.morefun.naruto.plugin.battle.cfg.SpecialbattleConfig;
	import com.tencent.morefun.naruto.plugin.battle.command.BattleScriptAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.BattleWatchResAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.CancelSkillActionCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ChangeWatchFlgCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ChangedCustomIDCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.DestroyBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.DoRoundSysncAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.EndGuidCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.FightResLoadedCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.GiveUpBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.GotoNextFightCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.GuidSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.GuidUpdateSkillStateCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.HidePerwarCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.HideTargetGuidTipsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.InitializeBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.InsertBattleInitCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NinjaEnterCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NinjaExeuntCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyAutoFightCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyCloseFightTipsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyFightCompleteCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyFightOverCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyKathaSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyPrewarResToLoadCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyRoundSyncCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyShowResLoadCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyStartBattleCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyTinyRoundsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.NotifyWatchTransfomResAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.PrewarResCompleteCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RequestAutoFightCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RequestKathaSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RequestSummonContractPetCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.RoundSyncAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.SendSpeedMessageCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowGuidSkillCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowNinjaGuidCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowPrewarChooseCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.ShowTargetGuidTipsCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.StartGuidCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.StartPrewarOptionNotifyCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateContinueTestFlagCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateLeftBattleRoundCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdatePlayerOnlineInfoCommand;
	import com.tencent.morefun.naruto.plugin.battle.command.UpdateSkillStateCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleTypeGroup;
	import com.tencent.morefun.naruto.plugin.battle.data.CustomInfo;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.battle.data.UINinjaData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIPlayerData;
	import com.tencent.morefun.naruto.plugin.battle.data.WaitLoadingData;
	import com.tencent.morefun.naruto.plugin.battle.executer.controlClasses.CommandToHandler;
	import com.tencent.morefun.naruto.plugin.battle.executer.controlClasses.DebugHelper;
	import com.tencent.morefun.naruto.plugin.battle.executer.controlClasses.LoadAssetHelper;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.ConverterResultInfo;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.MessageRecoData;
	import com.tencent.morefun.naruto.plugin.battle.messageConverter.StageActionConverter;
	import com.tencent.morefun.naruto.plugin.battle.notice.ContinueTinyRoundNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.ContractPetEnterNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.ContractPetExeuntNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.DoUseKathaSkillNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.GVGFightOverNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.GiveUpBattleRequestNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.GiveUpBroadcastNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.LockAllSkillBtnNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.OtherPlayerResCompleteNotce;
	import com.tencent.morefun.naruto.plugin.battle.notice.RequestAutoFightNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.RequestSpeedUpNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.SkillVidoNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.SpeedUpNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.SpeedUpRenderNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.StopTinyRoundNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdatePlayerInfoNotice;
	import com.tencent.morefun.naruto.plugin.battle.notice.UpdateWatchFlagNotice;
	import com.tencent.morefun.naruto.plugin.battle.view.BattleView;
	import com.tencent.morefun.naruto.plugin.battle.view.fightOver.damage.DamageInfo;
	import com.tencent.morefun.naruto.plugin.motion.IMotionNotifyReceiver;
	import com.tencent.morefun.naruto.plugin.motion.MotionLogger;
	import com.tencent.morefun.naruto.plugin.motion.MotionNotifyCenter;
	import com.tencent.morefun.naruto.plugin.motion.MotionPlayer;
	import com.tencent.morefun.naruto.plugin.motion.data.BaseActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.NinjaBattleCfgInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.ScriptActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.SkillStatuInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.FightManagerCenter;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.Ninja;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.NinjaConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.def.NinjaDef;
	import com.tencent.morefun.naruto.plugin.motion.manager.res.ResManager;
	import com.tencent.morefun.naruto.plugin.motion.manager.res.data.MMEAssetsProvider;
	import com.tencent.morefun.naruto.plugin.motion.manager.scene.SceneConfig;
	import com.tencent.morefun.naruto.plugin.motion.manager.scene.data.SceneInfo;
	import com.tencent.morefun.naruto.plugin.motion.notice.CancelSkillNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.ComboMoreThan5Notice;
	import com.tencent.morefun.naruto.plugin.motion.notice.ComboPauseTimeNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.ComboResumeTimeNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.CurtainNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.HpChangedNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.HpUpdateNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.KathaChangedNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.NinjaEnterNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.NinjaExeuntNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.NinjaReplaceNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.PlayNinjaDeadSoundNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.PlaySoundNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.PromptSkillClearNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.PromptSkillStartNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.RoundChangedNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.SlowRenderNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.SpellBeginSkillNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.StartScriptNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.StartVideoNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.UIHitNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.UpdateSkillStatusNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.UseKathaSkillNotice;
	import com.tencent.morefun.naruto.plugin.motion.notice.base.BaseNotice;
	import com.tencent.morefun.naruto.plugin.motion.player.action.Action;
	import com.tencent.morefun.naruto.plugin.ui.base.BackGround;
	import com.tencent.morefun.naruto.plugin.ui.base.def.BackGroundDef;
	import com.tencent.morefun.naruto.plugin.ui.base.def.BackgroundGroupDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.FrameSizeDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LocationDef;
	import com.tencent.morefun.naruto.plugin.ui.util.DisplayUtils;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import com.tencent.morefun.naruto.plugin.ui.util.TweenManager;
	import com.tencent.morefun.naruto.sound.data.BgMusicInfo;
	import com.tencent.morefun.naruto.sound.def.BgMusicTypeDef;
	import com.tencent.morefun.naruto.util.CollectionClearUtil;
	import com.tencent.morefun.naruto.util.GameTip;
	import com.tencent.morefun.naruto.util.StateInfo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import base.ApplicationData;
	import base.NarutoExecuter;
	
	import battle.command.RequestPveFightStartCommand;
	import battle.command.ShowDamageViewCmd;
	import battle.command.StartBattleReplayCommond;
	import battle.command.StartGuidScriptCommand;
	import battle.command.StartGuideBattleReplay;
	import battle.data.BattleInfo;
	import battle.def.BattleKeyDef;
	import battle.def.RequestFightStartTypeDef;
	
	import cfgData.dataStruct.SpecialbattleCFG;
	
	import chat.command.PasteMessageCommand;
	import chat.def.ChatChanelDef;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	
	import hud.command.UpdateHudBattlePowerLockCommand;
	
	import plot.command.CancelPlotCommand;
	import plot.command.FirstFightPlotCommand;
	import plot.command.PlotCommand;
	
	import prewar.command.ExitPrewarCommand;
	
	import serverProto.fight.FightStartType;
	import serverProto.fight.StageActionType;
	
	import ui.LoadingManager;
	
	import user.data.UserInfo;
	import user.def.UserStateDef;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class ControlExecuter extends NarutoExecuter implements IMotionNotifyReceiver
	{
		
		/**每次startBattle时更新*/
		public var uiData:UIData;
		public var battleData:BattleData;
		
		public var motionPlayer:MotionPlayer;
		
		private var sceneId:int;
		private var inited:Boolean;
		
		
		private var battleModel:BattleInfo;
		
		
		private var battleView:BattleView;
		private var backGround:Shape;
		
		private var isWin:Boolean = false;
		private var _needShowResult:Boolean = false;
		private var isContinueTest:Boolean = false;
		
		private var _roundIndex:int = 0;
		private var _sceneIndex:int = 0;
		
		
		private var isInsert:Boolean;
		/**战前配置后为1，默认是0*/
		private var resNoticed:Boolean;
		
		private var scriptActionInfo:ScriptActionInfo;
		
		
		private var _loadMgr:LoadManager;
		/**播放速度的倍数*/
		static public const Speed_Slow:Number = 0.25;
		static public const Speed_Normal:Number = 1;
		static public const Speed_X1:Number = 1.3;
		static public const Speed_X2:Number = 2;
		private var _speedTime:Number = Speed_X1;
		private var _isTemporarySpeedUp:Boolean;
		private var _beginSkillcount:int = 0;
		private var _isSlowRate:Boolean;
		private var _cmd2Handler:CommandToHandler;
		/**记录回合数据*/
		private var _roundMgr:RoundManager;
		private var _debugHelper:DebugHelper;
		private var _loadHelper:LoadAssetHelper;
		private var _timeOutList:Array = [];
		public function ControlExecuter()
		{
			super(PluginDef.BATTLE, ExecuterDef.BATTLE_LOGIC);
			
			
			battleData = BattleData.singleton;
			
			_cmd2Handler = new CommandToHandler();
			_cmd2Handler.addToMap(InitializeBattleCommand, doInitializeBattleCommand);//Sever，战斗初始化
			_cmd2Handler.addToMap(NotifyStartBattleCommand, doStartBattleCommand);//Sever，战斗开始
			_cmd2Handler.addToMap(InsertBattleInitCommand, doInsertBattleInitCommand);
			_cmd2Handler.addToMap(NotifyTinyRoundsCommand, doTinyRoundsCommand);//Sever，中回合数据
			_cmd2Handler.addToMap(NotifyRoundSyncCommand, doRoundSyncCommand);//Sever，大回合数据   （skillStates更新CD，mp）
			_cmd2Handler.addToMap(NotifyKathaSkillCommand, doKathaSkillCommand);//Sever，使用查克拉技能
			_cmd2Handler.addToMap(UpdateSkillStateCommand, doUpdateSkillStateCommand);//Sever，奥义技按钮状态 （skillStates更新CD，控）
			_cmd2Handler.addToMap(NotifyFightOverCommand, doFightOverCommand);//Sever，可以显示卷轴赢败动画。
			_cmd2Handler.addToMap(CancelSkillActionCommand, doCancelSkillActionCommand);
			_cmd2Handler.addToMap(ChangedCustomIDCommand, doChangedCustomIDCommand);
			_cmd2Handler.addToMap(UpdateContinueTestFlagCommand, doUpdateContinueTestFlagCommand);//Sever，标记忍者考试
			_cmd2Handler.addToMap(NotifyAutoFightCommand, doNotifyAutoFightCommand);//Sever，是否自动战斗中
			_cmd2Handler.addToMap(UpdatePlayerOnlineInfoCommand, doUpdatePlayerOnlineInfoCommand);
			_cmd2Handler.addToMap(ShowPrewarChooseCommand, doShowPrewarChooseCommand);//Sever，显示是否要战前配置的面板
			_cmd2Handler.addToMap(StartPrewarOptionNotifyCommand, doStartPrewarOptionNotifyCommand);
			_cmd2Handler.addToMap(HidePerwarCommand, doHidePerwarCommand);
			_cmd2Handler.addToMap(NotifyPrewarResToLoadCommand, doNotifyPrewarResToLoadCommand);
			_cmd2Handler.addToMap(NotifyWatchTransfomResAckCommand, doNotifyWatchTransfomResAckCommand);
			_cmd2Handler.addToMap(NotifyShowResLoadCommand, doShowResLoadCommand);
			_cmd2Handler.addToMap(ChangeWatchFlgCommand, doChangeWatchFlgCommand);
			_cmd2Handler.addToMap(ShowGuidSkillCommand, doShowGuidSkillCommand);
			_cmd2Handler.addToMap(ShowNinjaGuidCommand, doShowNinjaGuidCommand);
			_cmd2Handler.addToMap(ShowTargetGuidTipsCommand, doShowTargetGuidTipsCommand);
			_cmd2Handler.addToMap(HideTargetGuidTipsCommand, doHideTargetGuidTipsCommand);
			_cmd2Handler.addToMap(DestroyBattleCommand, doDestroyBattleCommand);
			_cmd2Handler.addToMap(NotifyCloseFightTipsCommand, doCloseFightTipsCommand);
			_cmd2Handler.addToMap(GotoNextFightCommand, doGotoNextFightCommand);
			_cmd2Handler.addToMap(UpdateLeftBattleRoundCommand, doUpdateLeftBattleRoundCommad);
			_cmd2Handler.addToMap(GuidUpdateSkillStateCommand, doGuidUpdateSkillStateCommand);
			_cmd2Handler.addToMap(StartGuidScriptCommand, doStartGuidScriptCommand);
			_cmd2Handler.addToMap(GuidSkillCommand, doGuidSkillCommand);
			
			_cmd2Handler.addToMap(StartBattleReplayCommond, doStartBattleReplayCommond);
			_cmd2Handler.addToMap(StartGuideBattleReplay, doStartGuideBattleReplay);
			_cmd2Handler.addToMap(DoRoundSysncAckCommand, roundEnd);
			_cmd2Handler.addToMap(ShowDamageViewCmd, doShowDamageViewCmd);
			
			LoadAssetHelper.ctrl = this;
			LoadAssetHelper.pluginName = this.pluginName;
			
			_timeOutList = [];
			_debugHelper = new DebugHelper(this);
			_loadHelper = LoadAssetHelper.singleton;
			battleModel = this.plugin.retrieveModel(ModelDef.BATTLE) as BattleInfo;
			BackGround.createGroup(BackgroundGroupDef.BATTLE);
		}
		
		override public function doCommand(command:Command):void
		{
			
			_cmd2Handler.handle(command);
		}
		
		private function doStartGuideBattleReplay(c:Object):void {
			var state:StateInfo = new StateInfo;
			
			
			var userInfo:UserInfo = new UserInfo(state);
			userInfo.svrId = ApplicationData.singleton.selfSrv;
			userInfo.role = ApplicationData.singleton.selfRole;
			userInfo.uin = ApplicationData.singleton.selfuin;
			ApplicationData.singleton.selfInfo = userInfo;
			
			doStartBattleReplayCommond(c);
		}
		private function doStartBattleReplayCommond(c:Object):void 
		{
			this.dispose();
			LoadingManager.hideFullLoading();
			
			var replayData:ByteArray;
			if (c.recordData) {
				replayData = c.recordData;
			}else{
				replayData = getPluginAsset("plugin.battle.recoInfo") as ByteArray;
			}
			
			
			_debugHelper.startReplay(replayData);
			
			if(BattleData.singleton.fightType == RequestFightStartTypeDef.FIRST_GUID_FIGHT)
			{
				LayerManager.singleton.setLayerVisible(LayerDef.CHAT, false);
			}
		}
		
		
		private function doCancelSkillActionCommand(c:CancelSkillActionCommand):void 
		{
			_roundMgr.pushMetaDataNew(handCancelSkill, [c.ninjaPos],"doCancelSkillActionCommand");
			_debugHelper.record(c);
		}
		
		private function doInitializeBattleCommand(c:InitializeBattleCommand):void 
		{
			if(motionPlayer != null)
			{
				return ;//观战会执行到这里
			}
			
			_debugHelper.resetRecord( { uin:ApplicationData.singleton.selfuin, role:ApplicationData.singleton.selfRole, srv:ApplicationData.singleton.selfSrv, type:BattleData.singleton.fightType} );
			_debugHelper.record(c,true);
			initMotionPlayer();
		}
		private function doStartBattleCommand(c:NotifyStartBattleCommand):void 
		{
			if(battleData.fightState != BattleData.FIGHT_STATE_NONE)
			{
				return ;
			}
			
			if(battleData.needShowFightTips)
			{
				battleData.fightState = BattleData.FIGHT_STATE_WAIT_FIGHT_TIPS;
			}
			else
			{
				battleData.fightState = BattleData.FIGHT_STATE_START_BATTLE;
			}
			
			hasPushFrameSize = false;
			
			battleData.resState = BattleData.RES_STATE_INIT_RES;
			
			_debugHelper.record(c,true);
			inited = true;
			_roundIndex = c.beginRoundIndex;
			_sceneIndex = 0;
			startBattle(c.uiData, c.ninjaList, c.custom, c.scriptInfo, c.teamId, c.isInsert, c.contractPetInfo);
		}
		private function doChangedCustomIDCommand(c:ChangedCustomIDCommand):void 
		{
			var customInfo:CustomInfo = new CustomInfo();
			customInfo.sceneId = c.sceneId;
			customInfo.sectionId = c.sectionId;
			customInfo.customFightId = c.customFightId;
			customInfo.curWave = c.curWave;
			customInfo.totalWave = c.totalWave;
			changedCustomId(customInfo);
			
			_debugHelper.record(c);
		}
		
		private function doInsertBattleInitCommand(c:InsertBattleInitCommand):void
		{
			_debugHelper.record(c);

			
			if(c.isAuto == true)
			{
				BattleTypeGroup.setAutoStatus(BattleData.singleton.fightType, c.isAuto);
				battleView.updateAutoFightLabel(c.isAuto);
			}
			
			//因为在玩家收到资源包 到加载资源完成应答这段时间其他玩家的资源进度行为玩家是不知道的 所以会有可能玩家在应答资源加载完成后服务器直接下发第一个战斗包
			if(WaitLoadingData.singleton.isComplete == false)
			{
				LoadAssetHelper.singleton.finishAllWaitPlayer();
			}
		}
		
		private function doTinyRoundsCommand(c:NotifyTinyRoundsCommand):void 
		{
			_debugHelper.record(c);
			nextMiddleRoundAction(c.actions, true);
			
			if(c.notice && c.notice.length != 0)
			{
				for each(var notice:UpdatePlayerInfoNotice in c.notice)
				{
					_roundMgr.pushMetaDataNew(handModifyPlayerInfo, [notice], "UpdatePlayerInfoNotice");
				}
			}
		}
		
		private var index:int;
		private function doRoundSyncCommand(c:NotifyRoundSyncCommand):void 
		{
			index ++;
			
			logger.output(I18n.lang("as_battle_1451031565_292"), getTimer()); 
			
			//			if(roundSynFlag)
			//			{
			//				logger.output("watchSpeedUp");
			//				speedUpRender();
			//			}
			
			roundSynFlag = true;
			//			new ShowTextBoxCommand("speedUpStart").call();
			battleView.showCountdown();
			
			if(c.customEndRound)
			{
				battleView.disableExit();
			}
			
			_roundIndex = c.roundIndex + _sceneIndex;
			
			_debugHelper.record(c);
			logger.output("[battle]", "roundSync", c.actionList.length, "roundIndex", _roundIndex);
			_roundMgr.pushMetaDataNew(handRoundSync, [c.shieldInfos, c.buffInfos, c.actionList, c.skillStates,c.teamInfos, _roundIndex, c.isFightOver], "doRoundSyncCommand");
			_roundMgr.markMetaToPost();
			
			
		}
		private function doFightOverCommand(c:NotifyFightOverCommand):void 
		{
			//护送掠夺中 掠夺者掉线 观战方收到fightOver的情况
			if(battleView == null)
			{
				battleView ||= new BattleView(onUseSkill);
				battleView.addMotionPlayer(motionPlayer);
				
				hasPushFrameSize = true;
				LayoutManager.singleton.pushFrameSize(FrameSizeDef.FIGHT_MIN_WIDTH, FrameSizeDef.FIGHT_MAX_WIDHT, FrameSizeDef.FIGHT_MIN_HEIGHT, FrameSizeDef.FIGHT_MAX_HEIGHT);
				
				TimerProvider.addEnterFrameTask(onRenderer);
			}
			
			if(BattleData.singleton.guidState != BattleData.GUID_SKILL_REQUEST)
			{
				battleView.lockAllSkillBtns();
			}
			
			isWin = c.isWin;
			battleModel.isWin = isWin;
			_needShowResult = c.showResult;
			_roundMgr.pushMetaDataNew(handFightOver,[c],"doFightOverCommand");
			
			_debugHelper.record(c);
		}
		
		private function doUpdateSkillStateCommand(c:UpdateSkillStateCommand):void 
		{
			updateSkillStates(c.skillStates);
			_debugHelper.record(c);
			//_roundMgr.pushMetaDataNew(updateSkillStates, [c.skillStates]);
		}
		
		private function doStartGuidScriptCommand(c:StartGuidScriptCommand):void
		{
			var scriptCommand:Command;
			
			scripteNoticeDelay = (c as StartGuidScriptCommand).delay;
			if (BattleData.singleton.fightType == RequestFightStartTypeDef.FIRST_GUID_FIGHT)
			{
				scriptCommand = new FirstFightPlotCommand((c as StartGuidScriptCommand).scriptId);
			}
			else
			{
				scriptCommand = new PlotCommand((c as StartGuidScriptCommand).scriptId);
			}
			c.addSubCommand(scriptCommand);
			scriptCommand.call();
			c.finish();
		}
		
		private var curGuidSkillCommand:GuidSkillCommand;
		private function doGuidSkillCommand(c:GuidSkillCommand):void
		{
			_roundMgr.pushMetaDataNew(handGuidSkillCommand,[c],"handGuidSkillCommand");
		}
		
		private function handGuidSkillCommand(c:GuidSkillCommand):void
		{
			curGuidSkillCommand = c;
			BattleData.singleton.guidState = BattleData.FRIST_BATTLE_GUID_SKILL;
			new ShowGuidSkillCommand(1, curGuidSkillCommand.skillIndex).call();
			new StopTinyRoundNotice().send();
		}
		
		private function doGuidUpdateSkillStateCommand(c:GuidUpdateSkillStateCommand):void
		{
			_debugHelper.record(c);
			_roundMgr.pushMetaDataNew(handGuidUpdateSkillState,[c.skillStates],"GuidUpdateSkillStateCommand");
		}
		
		private function handGuidUpdateSkillState(skillStates:Array):void
		{
			updateSkillStates(skillStates);
		}
		
		private function doKathaSkillCommand(c:NotifyKathaSkillCommand):void 
		{
			_debugHelper.record(c);
			if(!c.dontDelay || _roundMgr.isPostMeta()){
				_roundMgr.pushMetaDataNew(handNotifyKathaSkill, [c.ninjaPos, c.skillIndex, c.mp],"doKathaSkillCommand");
			}else {
				handNotifyKathaSkill(c.ninjaPos, c.skillIndex, c.mp);//
				updateSkillStates(c.skillState);
			}
		}
		
		private function handShowPrewarChoose(command:ShowPrewarChooseCommand):void
		{
			if(isContinueTest  == false)
			{
				battleView.showPerwarChoose(command);
			}
			else
			{
				command.finish();
			}
		}
		/**战前布阵的选择面板关闭后回调*/
		private function onPrewarChooseResult(evt:CommandEvent):void
		{
			var cmd:ShowPrewarChooseCommand;
			
			if(BattleData.singleton.guidState != BattleData.GUID_SKILL_REQUEST)
			{
				battleView.unlockAllSkillBtns();
			}
			
			cmd = evt.currentTarget as ShowPrewarChooseCommand;
			cmd.removeEventListener(CommandEvent.FINISH, onPrewarChooseResult);
			if(cmd.choose == 1)
			{
				battleModel.prewarStart();
				battleView.clearAllSkillBtn();
			}
			else
			{
				battleData.fightState = BattleData.FIGHT_STATE_START_BATTLE;
			}
			battleView.showGiveUpInfo();
			
			updateState();
		}
		
		private function doCloseFightTipsCommand(c:NotifyCloseFightTipsCommand):void
		{
			battleData.fightState = BattleData.FIGHT_STATE_START_BATTLE;
			
			updateState();
		}
		
		private function pauseRender():void
		{
			TimerProvider.removeEnterFrameTask(onRenderer);
		}
		
		private function changeToGiveStatus():void
		{
			if(battleView == null){return ;}
			
			battleData.skillStatus = BattleData.SKILL_STATUS_GIVE_UP;
			battleView.hideSkillPanel();
			if(battleView.getUIIsShowing()){battleView.updateBattleSkillStatus(battleData.skillStatus)};
		}
		
		private function changeWatchFlg():void
		{
			if(!battleView)
			{
				return ;
			}
			
			if(battleData.skillStatus != BattleData.SKILL_STATUS_WATCH_ON && battleData.skillStatus != BattleData.SKILL_STATUS_WATCH_OFF)
			{
				return ;
			}
			
			//			if(battleView.getUIIsShowing()){battleView.updateBattleSkillStatus(battleData.skillStatus)};
			if(battleData.skillStatus == BattleData.SKILL_STATUS_WATCH_ON)
			{
				battleView.hideSkillPanel();
			}
			//			else
			//			{
			_timeOutList.push(setTimeout(showWatchEffect, 3000));
			//			}
		}
		
		private function showWatchEffect():void
		{
			if(battleView.getUIIsShowing()){battleView.updateBattleSkillStatus(battleData.skillStatus)};
			if(battleData.skillStatus == BattleData.SKILL_STATUS_WATCH_OFF)
			{
				logger.output("BattleData.SKILL_STATUS_WATCH_OFF");
				battleView.showSkillPanel();
			}
			
			if(battleData.skillStatus == BattleData.SKILL_STATUS_WATCH_ON)
			{
				logger.output("BattleData.SKILL_STATUS_WATCH_ON");
				battleView.hideSkillPanel();
			}
		}
		
		private function prewarOptionEnd():void
		{
			LoadingManager.setLoingString(I18n.lang("as_battle_1451031565_293"));
			
			TimerProvider.addTimeTask(400, resumeTimeUpdate);
			new ExitPrewarCommand().call();
			battleModel.prewarEnd();
		}
		
		private function resumeTimeUpdate():void
		{
			TimerProvider.removeTimeTask(400, resumeTimeUpdate);
			
			TimerProvider.addEnterFrameTask(onRenderer);
		}
		
		private function changedCustomId(customInfo:CustomInfo):void
		{
			_roundMgr.pushMetaDataNew(handChangedCustom, [customInfo],"changedCustomId");
		}
		
		private function handNotifyKathaSkill(pos:int, index:int, mp:int):void
		{
			var teamId:int;
			
			teamId = uiData.getNinjaTeamId(pos);
			uiData.modifyNinjaMp(teamId, mp, true);
			motionPlayer.useSpecialSkillReady(pos, index);
		}
		
		private function handWatchFlgUpdate(model:int):void
		{
			battleData.skillStatus = model;
			changeWatchFlg();
			if(model == BattleData.SKILL_STATUS_NONE || model == BattleData.SKILL_STATUS_WATCH_OFF)
			{
				if(uiData.self)
				{
					var battlePlayer:UIPlayerData = uiData.findPlayerByKey(uiData.self.uin, uiData.self.roleId, uiData.self.serId, uiData.self.teamId);
					battlePlayer.uin = ApplicationData.singleton.selfuin;
				}
				if(battleView == null){showBattleViewUI();}
				battleView.clearAllSkillBtn();
			}
			else
			{
				if(uiData.self)
				{
					uiData.removePlayer(uiData.self);
					uiData.self = null;
				}
			}
			
			UIData.singleton.updateWatchSelf();
		}
		
		private function handContractPet(stage:Boolean, contractPetInfo:UpdatePlayerInfoNotice):void
		{
			var ninja:Ninja;
			var isLeft:Boolean;
			var player:UIPlayerData;
			
			if(stage)
			{
				player = new UIPlayerData();
				
				for each(var uiNinjaData:UINinjaData in uiData.self.ninjas)
				{
					ninja = FightManagerCenter.ninjaMgr.getNinjaByPos(uiNinjaData.pos);
					ninja.data.teamId = contractPetInfo.teamId;
					uiNinjaData.teamId = contractPetInfo.teamId;
				}
				
				isLeft = uiData.isOurPlayerPos(contractPetInfo.teamId);
				
				contractPetInfo.teamId = uiData.self.teamId;
				updatePlayerInfo(player, contractPetInfo);
				uiData.removeAllOurPlayer();
				uiData.addPlayer(player, isLeft);
				uiData.self = player;
				
				uiData.isContractPet = true;
			}
			else
			{
				uiData.isContractPet = false;
			}
		}
		
		private function updatePlayerInfo(playerInfo:UIPlayerData, notice:UpdatePlayerInfoNotice):void
		{
			var isLeft:Boolean;
			
			if(notice.type == StageActionType.JUST_SHOW_INFO)
			{
				
				playerInfo.hp = notice.hp;
				playerInfo.hpMax = notice.maxHp;
			}
			
			isLeft = uiData.isOurPlayerPos(notice.teamId);
			
			playerInfo.teamId = notice.teamId;
			playerInfo.mpMax = 100;
			playerInfo.mp = notice.mp;
			playerInfo.uin = notice.uin;
			playerInfo.roleId = notice.roleId;
			playerInfo.serId = notice.svrId;
			playerInfo.name = (notice.name == null)?playerInfo.name:notice.name;
			playerInfo.level = (notice.level == -1)?playerInfo.level:notice.level;
			playerInfo.battlePower = (notice.battlePower == -1)?playerInfo.battlePower:notice.battlePower;
			playerInfo.head = (notice.head == -1)?playerInfo.head:notice.head;
			playerInfo.contractPetId = notice.contractPetId;
			playerInfo.isOnline = !notice.offlineFlg;
			playerInfo.stageNinjaList = notice.stageNinjaList;
			playerInfo.isLeft = isLeft;
			
			motionPlayer.updateNinjaOnline(playerInfo.teamId, playerInfo.isOnline);
			
			playerInfo.dispathUpdateAll();
			
			if(uiData.monster && uiData.monster.teamId == playerInfo.teamId)
			{
				uiData.monster.head = playerInfo.head;
				uiData.monster.name = playerInfo.name;
				uiData.monster.level = playerInfo.level;
				uiData.monster.battlePower = playerInfo.battlePower;
				uiData.monster.mp = playerInfo.mp;
				uiData.monster.mpMax = playerInfo.mpMax;
				uiData.monster.dispathUpdateAll();
			}
			uiData.updateMonsterBattlePower();
		}
		
		private function handModifyPlayerInfo(notice:UpdatePlayerInfoNotice):void
		{
			var ninja:Ninja;
			var player:UIPlayerData;
			var isLeft:Boolean;
			
			if(uiData.isContractPet)
			{
				if(uiData.isOurPlayerPos(notice.teamId))
				{
					return ;
				}
			}
			
			if(notice.teamType != 0 && notice.teamType != 1)//怪不会调整阵型
			{
				player = uiData.getPlayer(notice.teamId);
			}
			else
			{
				player = uiData.findPlayerByKey(notice.uin, notice.roleId, notice.svrId, notice.teamId);
			}
			
			isLeft = uiData.isOurPlayerPos(notice.teamId);
			if(!player)
			{
				player = new UIPlayerData();
				updatePlayerInfo(player, notice);
				if(uiData.getPlayer(player.teamId)){uiData.removePlayer(uiData.getPlayer(player.teamId));}
				uiData.addPlayer(player, isLeft);
			}
			else
			{
				if(player.teamId != notice.teamId)
				{
					for each(var ninjaUIData:UINinjaData in player.ninjas)
					{
						FightManagerCenter.ninjaMgr.getNinjaByPos(ninjaUIData.pos).data.teamId = notice.teamId;
					}
				}
				
				updatePlayerInfo(player, notice);
			}
			
		}
		
		private function handWatchTransformResAck(c:NotifyWatchTransfomResAckCommand):void
		{
			logger.output("handWatchTransformResAck");
			
			resNoticed = false;
			
			_loadHelper.teamId = c.teamId;
			_loadHelper.removeEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, onLoadAllPlayerComplete);
			_loadHelper.addEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, doWatchTransformResAck);
			_loadHelper.addEventListener(LoadAssetHelper.LOAD_SELF_COMPLETE, doWatchTransformResAck);
			_loadHelper.loadAssets(c.sceneId, c.ninjaList, c.contractPetInfo);
		}
		
		private function doWatchTransformResAck(evt:Event):void
		{
			logger.output("doWatchTransformResAck");
			
			if(WaitLoadingData.singleton.isComplete == true)
			{
				_loadHelper.addEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, onLoadAllPlayerComplete);
				_loadHelper.removeEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, doWatchTransformResAck);
				_loadHelper.removeEventListener(LoadAssetHelper.LOAD_SELF_COMPLETE, doWatchTransformResAck);
			}
		}
		
		private function handShowResLoadCommand():void
		{
			if(WaitLoadingData.singleton.isComplete == false)
			{
				resNoticed = false;
				_loadHelper.removeEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, onLoadAllPlayerComplete);
				_loadHelper.addEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, onShowResLoadComplete);
				_loadHelper.addEventListener(LoadAssetHelper.LOAD_SELF_COMPLETE, onShowResLoadComplete);
				_loadHelper.loadAssets(SceneConfig.sceneId, [], null);
			}
		}
		
		private function onShowResLoadComplete(evt:Event):void
		{
			if(battleData.resState == BattleData.RES_STATE_INIT_RES)//掠夺护送 掠夺方在第一场的护送遮资源加载超时会触发这里
			{
				BackGround.disposeGroup(BackgroundGroupDef.BATTLE);
				startMotionPlayer();//在加载资源完成，进入战场时再开启比较适合，开启同时，重播才开始
				showBattleViewUI();
				showBlackBackGround();
				new StartGuidCommand().call();
				
				if(battleData.needShowFightTips == false){battleData.resState = BattleData.RES_STATE_COMPLETE;}
			}
			
			if(WaitLoadingData.singleton.isComplete == true)
			{
				_loadHelper.addEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, onLoadAllPlayerComplete);
				_loadHelper.removeEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, onShowResLoadComplete);
				_loadHelper.removeEventListener(LoadAssetHelper.LOAD_SELF_COMPLETE, onShowResLoadComplete);
			}
		}
		
		private function handOtherPlayerResComplete(pos:int):void
		{
			_loadHelper.addCompletePlayer(pos);
		}
		
		private function handRoundSync(shields:Array, buffs:Array, stages:Array, skillStates:Array,teamInfos:Array, roundIndex:int, isOver:Boolean):void
		{
			if(isOver == true)
			{
				slowRender(6, 1.5);
			}
			
			if(battleView.getLeftRound() == 1)
			{
				BattleData.singleton.isTimeOut = true;
			}
			_roundMgr.pushRound(shields, buffs, stages, roundIndex, isOver);
			
			syncUIPlayerDatas(teamInfos);
			
			updateSkillStates(skillStates);
			
			_roundMgr.markBigRoundSynced();
		}
		
		private function syncUIPlayerDatas(teamInfos:Array):void
		{
			var battleNinja:Ninja;
			var oldPlayer:UIPlayerData;
			var oldNinja:UINinjaData;
			
			for each(var player:UIPlayerData in teamInfos)
			{
				oldPlayer = uiData.getPlayer(player.teamId);
				
				uiData.modifyPlayerMp(player.teamId,player.mp, false);
				
				for each(var ninjaInfo:UINinjaData in player.ninjas)
				{
					battleNinja = FightManagerCenter.ninjaMgr.getNinjaByPos(ninjaInfo.pos);
					if(battleNinja)
					{
						if(battleNinja.cfg.cfgInfo.type == NinjaDef.TYPE_CONTRACT_PET && uiData.isOurPlayerPos(player.teamId))
						{
							player.teamId = uiData.self.teamId;
							oldPlayer = uiData.getPlayer(player.teamId);
							uiData.modifyPlayerMp(player.teamId,player.mp, false);
						}
						
						oldNinja = oldPlayer.getNinja(ninjaInfo.pos);
						oldNinja.hp = ninjaInfo.hp;
						//new UpdateNinjaHpNotice(ninjaInfo.pos, ninjaInfo.hp).send();
						//motionPlayer.updateNinjaHp(ninjaInfo.pos, ninjaInfo.hp);
					}
					motionPlayer.updateNinjaHp(ninjaInfo.pos, ninjaInfo.hp);
				}
				
				uiData.updatePlayerHp(player.teamId);
			}
			
		}
		
		private var speedUpFlag:Boolean;
		private var roundSynFlag:Boolean;
		private function speedUpRender():void
		{
			var startSpeedTime:Number;
			
			BattleData.singleton.socketClosePharse = BattleData.SOCKET_CLOSE_PHARSE_ROUND_SPEED;
			
			speedUpFlag = true;
			logger.output("speedUpRender");
			//			new ShowTextBoxCommand("speedUpRender").call();
			//			TimerProvider.removeEnterFrameTask(onRenderer);
			startSpeedTime = getTimer();
			logger.output(I18n.lang("as_battle_1451031565_297"), startSpeedTime);
			while(speedUpFlag)
			{
				TimerProvider.updateLastTime(-(1000 / TimerProvider.stageFrameRate));
				
				if((getTimer() - startSpeedTime) >= 5000)
				{
					clearSpeedUpRender();
					logger.output(I18n.lang("as_battle_1451031565_298"), getTimer());
					break;
				}
			}
			
			//			TimerProvider.addTimeTask(0, onRenderer);
		}
		
		private function clearSpeedUpRender():void
		{
			speedUpFlag = false;
			logger.output("clearSpeedUpRender");
			//			TimerProvider.removeTimeTask(0, onRenderer);
			//			TimerProvider.addEnterFrameTask(onRenderer);
		}
		
		private function roundEnd():void
		{
			BattleData.singleton.socketClosePharse = BattleData.SOCKET_CLOSE_PHARSE_ROUND_END;
			
			//			new ShowTextBoxCommand("speedUpEnd").call();
			battleView.hideCountDown();
			roundSynFlag = false;
			
			logger.output("[battle]", "roundEnd");
			if(_debugHelper.replaying == false && (battleData.skillStatus == BattleData.SKILL_STATUS_NONE || battleData.skillStatus == BattleData.SKILL_STATUS_WATCH_OFF || battleData.skillStatus == BattleData.FIGHT_STATE_SHOW_FIGHT_TIPS))
			{
				logger.output("[ControlExecuter][Devin]>>>roundEnd:RoundSyncAckCommand");
				new RoundSyncAckCommand(uiData.self.teamId).call();//应答大回合同步完成，
			}
			
			clearSpeedUpRender();
			_roundMgr.markBigRoundEnded();
		}
		
		private function handSyncLock(pos:int, index:int):void
		{
			battleView.setSyncLock(pos, false, index);
		}
		
		private function handChangedCustom(custom:CustomInfo):void
		{
			var customCfg:CustomBattleCfg;
			
			if(custom.sceneId != 0)
			{
				motionPlayer.updateSceneInfo(custom.sceneId);
			}
			BattleData.singleton.curCustomBattleId = custom.customFightId;
			BattleData.singleton.curSectionId = custom.sectionId;
			
			uiData.setLockHp(true);
			customCfg = CustomBattleConfig.getCustomBattleCfg(custom.customFightId, custom.sectionId);
			if(customCfg)
			{
				battleView.setCustomFightInfo(custom, customCfg.endTipsModel, customCfg.enableExit, customCfg.endCondition);
			}
			else
			{
				battleView.setCustomFightInfo(custom, 0, true, "");
			}
		}
		
		private function handUpdateHp():void
		{
			uiData.setLockHp(false);
			uiData.updateAllPlayerHp();
		}
		
		private function handCancelSkill(ninjaList:Array):void
		{
			motionPlayer.cancelSpecialSkillReady(ninjaList);
		}
		private function startBattle(uiData:UIData,ninjaInfoList:Array,custom:CustomInfo,
									 scriptInfo:ScriptActionInfo,
									 teamId:int,
									 isInsert:Boolean = false,
									 /* contractPetId:int = 0,*/
									 contractPetInfo:NinjaInfo = null):void
		{
			//this.ninjaInfoList = ninjaInfoList;
			//this.contractPetId = contractPetId;
			//this.contractPetInfo = contractPetInfo;
			
			this.uiData = uiData;
			this.isInsert = isInsert;
			this.scriptActionInfo = scriptInfo;
			sceneId = custom.sceneId;
			SceneConfig.sceneId = sceneId;
			SceneConfig.selfInLeft = uiData.selfInLeft;
			
			
			//这里开始加载资源，监听资源加载事件，并显示信息
			_loadHelper.reset();
			_loadHelper.addEventListener(LoadAssetHelper.LOAD_SELF_COMPLETE, onLoadSelfComplete);
			_loadHelper.addEventListener(LoadAssetHelper.ALL_PLAYER_COMPLETE, onLoadAllPlayerComplete);
			
			_loadHelper.teamId = teamId;
			loadAssets(sceneId, ninjaInfoList, contractPetInfo);
			
			// 播放战斗音乐，并停止地图背景音乐
			var battleCfg:CustomBattleCfg = CustomBattleConfig.getCustomBattleCfg(custom.customFightId, custom.sectionId);
			BattleData.singleton.curCustomBattleId = custom.customFightId;
			BattleData.singleton.curSectionId = custom.sectionId;
			
			var music:BgMusicInfo;
			if (battleCfg) music = battleCfg.music;
			
			if(music == null){
				var specialbattleItem:SpecialbattleCFG;
				specialbattleItem = SpecialbattleConfig.getSpecialbattleItem(BattleData.singleton.fightType);
				if(specialbattleItem)music = CustomBattleConfig.musicConfig.getMusicInfo(specialbattleItem.music);
			}
			
			logger.output(I18n.lang("as_battle_1451031565_300") + (music? music.url : null));
			plugin.getSoundManager().battleMusicMgr.restoreVolume(false);
			plugin.getSoundManager().battleMusicMgr.playBgMusic(music, custom.customFightId? BgMusicTypeDef.PVE_BATTLE_MUSIC : BgMusicTypeDef.PVP_BATTLE_MUSIC);
			plugin.getSoundManager().bgMusicMgr.stop();
		}
		
		private function onLoadAllPlayerComplete(e:Event):void 
		{
			if(battleData.resState == BattleData.RES_STATE_INIT_RES)
			{
				BackGround.addBackground(BackgroundGroupDef.BATTLE, BackGroundDef.BATTLE_MASK_ANIMATION, LayerDef.BATTLE_FRAME);
			}
			onResComplete();//BattleData.STATE_INIT_FIGHT_RES_START
		}
		private function loadAssets(sceneId:int, ninjaInfoList:Array, contractPetInfo:NinjaInfo, mask:Boolean = true):void
		{
			//_loadHelper.motionPlayer = motionPlayer;
			_loadHelper.loadAssets(sceneId, ninjaInfoList, contractPetInfo, mask);
		}
		/**忍者小队的资源加载完成*/
		private function onLoadSelfComplete(e:Event):void 
		{
			if(WaitLoadingData.singleton.isComplete)
			{
				if(battleData.resState == BattleData.RES_STATE_INIT_RES)
				{
					showMaskEffect();
				}
				else
				{
					onResComplete();
				}
			}
			_timeOutList.push(setTimeout(notifyResComplete, 250));
		}
		
		private function showMaskEffect():void
		{
			logger.output("onNinjaEnter", "showMaskEffect");
			
			BackGround.addBackground(BackgroundGroupDef.BATTLE, BackGroundDef.BATTLE_MASK_ANIMATION, LayerDef.BATTLE_FRAME);
			_timeOutList.push(setTimeout(onResComplete, 200));
		}
		
		/**主角资源加载完成调度 ，关闭暗黑动画，显示战斗场景，播剧情*/
		private function onResComplete():void
		{
			logger.output("onNinjaEnter", "onResComplete");
			
			if(battleData.resState == BattleData.RES_STATE_INIT_RES)
			{
				BackGround.disposeGroup(BackgroundGroupDef.BATTLE);
				startMotionPlayer();//在加载资源完成，进入战场时再开启比较适合，开启同时，重播才开始
				showBattleViewUI();
				showBlackBackGround();
				new StartGuidCommand().call();
				
				if(battleData.needShowFightTips == false){battleData.resState = BattleData.RES_STATE_COMPLETE;}
			}
			else
			{
				//上报服务器 战前重置资源加载完
				new PrewarResCompleteCommand().call();
				battleData.resState = BattleData.RES_STATE_COMPLETE;
			}
			//如果有战前剧情
			if(scriptActionInfo != null)
			{
				this.nextMiddleRoundAction([scriptActionInfo], false);
				return ;
			}
		}
		
		/**资源加载完成，通知Sever剧情播完，资源加完，*/
		private function notifyResComplete():void
		{
			logger.output("onNinjaEnter", "notifyResComplete");
			
			if (scriptActionInfo) {
				return;
			}
			if(resNoticed)//资源应答过之后，只用于剧情播完上报
			{
				_timeOutList.push(setTimeout(ackScriptFinish, scripteNoticeDelay));
				return ;
			}
			
			if(battleData.skillStatus == BattleData.SKILL_STATUS_NONE || battleData.skillStatus == BattleData.SKILL_STATUS_WATCH_OFF)
			{
				if(resNoticed == false && _debugHelper.replaying == false)
				{
					resNoticed = true;
					scriptActionInfo = null;
					new FightResLoadedCommand(isInsert).call();//确定之后，回合数据才来
					return ;
				}
			}
			else
			{
				new BattleWatchResAckCommand().call();
			}
		}
		
		private function updateStateByMiddleRound():void
		{
			if(battleData.fightState == BattleData.FIGHT_STATE_START_BATTLE
				|| battleData.fightState == BattleData.FIGHT_STATE_SHOW_FIGHT_TIPS 
				|| battleData.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION
				|| battleData.fightState == BattleData.FIGHT_STATE_WAIT_FIGHT_TIPS)
			{
				startFightUI();
			}
			
			if(battleData.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION)
			{
				prewarOptionEnd();
			}
			
			if(battleData.fightState == BattleData.FIGHT_STATE_SHOW_FIGHT_TIPS ||
				battleData.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION  ||
				battleData.fightState == BattleData.FIGHT_STATE_START_BATTLE ||
				battleData.fightState == BattleData.FIGHT_STATE_WAIT_FIGHT_TIPS)
			{
				battleView.showGiveUpInfo();
				battleData.fightState = BattleData.FIGHT_STATE_FIGHTING;
			}
		}
		
		private function updateState():void
		{
			if(battleData.fightState == BattleData.FIGHT_STATE_START_BATTLE
				|| battleData.fightState == BattleData.FIGHT_STATE_SHOW_FIGHT_TIPS 
				|| battleData.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION)
			{
				startFightUI();
			}
			
			if(battleData.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION)
			{
				prewarOptionEnd();
			}
			
			if(battleData.fightState == BattleData.FIGHT_STATE_SHOW_FIGHT_TIPS ||
				battleData.fightState == BattleData.FIGHT_STATE_PREWAR_OPTION  ||
				battleData.fightState == BattleData.FIGHT_STATE_START_BATTLE)
			{
				battleView.showGiveUpInfo();
				battleData.fightState = BattleData.FIGHT_STATE_FIGHTING;
			}
			
			//过度函数 等确认等待玩家列表以后服务器都会想办法通知客户端后去掉
			//			if(battleData.resState == BattleData.RES_STATE_COMPLETE && BattleData.singleton.fightType != FightStartType.FIGHT_START_TYPE_GVG)
			//			{
			//				_loadHelper.setWaitComplete();
			//			}
		}
		
		private function startFightUI():void
		{
			battleView.showUI();
			
			if(selfInfo && selfInfo.teamId && selfInfo.isCaptain == false)//队员在队长点了直接开战是没通知的
			{
				battleView.showPrewarCloseEffect();
			}
			
			logger.output("startFightUI", battleData.skillStatus);
			if(battleData.skillStatus != BattleData.SKILL_STATUS_NONE){battleView.updateBattleSkillStatus(battleData.skillStatus)};
		}
		
		private function nextMiddleRoundAction(actions:Array, isSever:Boolean):void
		{
			if(sceneSnapshot)
			{
				sceneSnapshot.bitmapData.dispose();
				LayoutManager.singleton.removeItem(sceneSnapshot);
				sceneSnapshot = null;
				
				frameSnapshot.bitmapData.dispose();
				LayoutManager.singleton.removeItem(frameSnapshot);
				frameSnapshot = null;
			}
			
			for each(var action:BaseActionInfo in actions)
			{
				if(!(action is StageActionInfo) && !(action is ScriptActionInfo))
				{
					battleView.enableExit();
					updateStateByMiddleRound();
				}
			}
			
			_roundMgr.pushTinyRound(actions, _roundIndex, isSever);
		}
		
		private function initMotionPlayer():void
		{
			motionPlayer = new MotionPlayer();
			motionPlayer.scrollRect = new Rectangle(0,0,1300,825);
			MotionLogger.output = logger.output;
			//MotionLogger.output = logger.output;
			
			ResManager.pub::getPluginAsset = getPluginAsset;
			
			motionPlayer.updateConfig();
			
			_roundMgr = new RoundManager(this,motionPlayer);
			
			MotionNotifyCenter.add(this);
		}
		
		
		
		private function slowRender(slowRate:int, slowTime:Number):void//注意，这里的slowRate已经不生效了。
		{
			_isSlowRate = true;
			updateSpeedTime();
			TweenManager.delayedCall(slowTime, onSlowEnd);
		}
		
		private function onSlowEnd():void
		{ 
			_isSlowRate = false;
			updateSpeedTime();
		}
		
		private function startMotionPlayer():void
		{
			updateSpeedTime();
			TimerProvider.addEnterFrameTask(onRenderer);
			
			motionPlayer.updateEffect();
			motionPlayer.updateRole();
			motionPlayer.showScene(sceneId);
		}
		
		private function onRenderer():void
		{
			
			if(motionPlayer != null)
			{
				motionPlayer.render();
			}
			
		}
		
		/**接收motion包的消息*/
		public function receive(notice:BaseNotice):void
		{
			switch(getQualifiedClassName(notice))
			{
				case getQualifiedClassName(RoundChangedNotice):
					logger.output("[battle]", "MotionPlayerEvent.ROUND_CHANGED",(notice as RoundChangedNotice).roundIndex);
					if(battleView)
					{
						battleView.addRoundCount((notice as RoundChangedNotice).roundIndex);
					}
					break;
				case getQualifiedClassName(HpChangedNotice):
					if((notice as HpChangedNotice).hp != 0)
					{
						uiData.modifyNinjaHp((notice as HpChangedNotice).teamId, (notice as HpChangedNotice).pos, (notice as HpChangedNotice).hp, true);
					}
					break;
				case getQualifiedClassName(HpUpdateNotice):
					uiData.modifyNinjaHp((notice as HpUpdateNotice).teamId, (notice as HpUpdateNotice).pos, (notice as HpUpdateNotice).hp, false);
					break;
				
				case getQualifiedClassName(KathaChangedNotice):
					if((notice as KathaChangedNotice).katha != 0)
					{
						if((notice as KathaChangedNotice).team == -1)//buff结算
						{
							uiData.modifyNinjaMp((notice as KathaChangedNotice).team, (notice as KathaChangedNotice).katha, true);
						}else
						{
							uiData.modifyPlayerMp((notice as KathaChangedNotice).team, (notice as KathaChangedNotice).katha, true);
						}
					}
					break;
				case getQualifiedClassName(UIHitNotice):
					var isLeft:Boolean = uiData.isOurNinjaPos((notice as UIHitNotice).pos);
					
					if((notice as UIHitNotice).addNum == 0)
					{
						return ;
					}
					
					if((notice as UIHitNotice).hitNum == -1)
					{
						battleView.clearHitCount(isLeft);
					}
					else
					{
						battleView.hitCount(isLeft,(notice as UIHitNotice).hitNum);
					}
					break;
				case getQualifiedClassName(UseKathaSkillNotice):
					motionPlayer.noticeUseSkill((notice as UseKathaSkillNotice).pos, (notice as UseKathaSkillNotice).skillId);
					break;
				case getQualifiedClassName(PromptSkillStartNotice):
					battleView.showSkillPrompt((notice as PromptSkillStartNotice).pos, (notice as PromptSkillStartNotice).comboIndex, int((notice as PromptSkillStartNotice).skillId));
					break;
				case getQualifiedClassName(PromptSkillClearNotice):
					battleView.clearSkillPrompt();
					break;
				case getQualifiedClassName(SlowRenderNotice):
					//if(battleData.skillStatus != BattleData.SKILL_STATUS_WATCH_ON)
				{
					slowRender((notice as SlowRenderNotice).slowRate, (notice as SlowRenderNotice).slowTime);
					plugin.getSoundManager().battleMusicMgr.changeVolume(30);
					motionPlayer.slowOver();
				}
					battleView.lockAllSkillBtns();
					battleView.disableExit();
					break;
				case getQualifiedClassName(PlaySoundNotice):
					plugin.getSoundManager().play((notice as PlaySoundNotice).soundId, (notice as PlaySoundNotice).volume);
					break;
				case getQualifiedClassName(PlayNinjaDeadSoundNotice):
					plugin.getSoundManager().playDeathSound((notice as PlayNinjaDeadSoundNotice).ninjaId);
					break;
				case getQualifiedClassName(NinjaEnterNotice):
					onNinjaEnter((notice as NinjaEnterNotice).ninjaInfos);
					break;
				case getQualifiedClassName(NinjaExeuntNotice):
					onNinjaExeunt((notice as NinjaExeuntNotice).ninjaInfos);
					break;
				case getQualifiedClassName(NinjaReplaceNotice):
					onNinjaReplace((notice as NinjaReplaceNotice).ninjaInfos);
					break;
				case getQualifiedClassName(StartScriptNotice):
					var scriptCommand:PlotCommand;
					if(!isContinueTest)
					{
						scripteNoticeDelay = (notice as StartScriptNotice).delay;
						scriptCommand = new PlotCommand((notice as StartScriptNotice).scriptId);
						scriptCommand.addEventListener(CommandEvent.FINISH, onScriptFinish);
						scriptCommand.call();
					}
					else
					{
						notifyResComplete();
					}
					break;
				case getQualifiedClassName(UpdateSkillStatusNotice):
					updateSkillStates((notice as UpdateSkillStatusNotice).skillStates);//（skillStates更新，死）
					break;
				case getQualifiedClassName(StartVideoNotice):
					battleView.playVideo((notice as StartVideoNotice).url);
					break;
				case getQualifiedClassName(CancelSkillNotice):
					motionPlayer.cancelSpecialSkillReady((notice as CancelSkillNotice).cancelSkillList);
					break;
				case getQualifiedClassName(CurtainNotice):
					battleView.updateCurtain((notice as CurtainNotice).start);
					break;
				case getQualifiedClassName(RequestSpeedUpNotice):
					if((notice as RequestSpeedUpNotice).speedUp)
					{
						new SendSpeedMessageCommand(1).call();
					}
					else
					{
						new SendSpeedMessageCommand(0).call();
					}
					break;
				case getQualifiedClassName(ComboMoreThan5Notice):
					setIsTemporarySpeedUp(ComboMoreThan5Notice(notice).isStart);
					break;
				case getQualifiedClassName(SpellBeginSkillNotice):
					if (SpellBeginSkillNotice(notice).isStart) {
						_beginSkillcount++;
					}else {
						_beginSkillcount--;
					}
					setIsTemporarySpeedUp(_beginSkillcount>0);
					break;
				case getQualifiedClassName(SpeedUpNotice):
					if((notice as SpeedUpNotice).time == 1)
					{
						speedTime = 2;
						BattleTypeGroup.setSpeedStatus(BattleData.singleton.fightType, true);
					}
					else
					{
						speedTime = 1.3;
						BattleTypeGroup.setSpeedStatus(BattleData.singleton.fightType, false);
					}
					if(battleView != null)
					{
						battleView.updateSpeedUpLabel(BattleTypeGroup.getSpeedStatus(BattleData.singleton.fightType));
					}
					
					break;
				case getQualifiedClassName(RequestAutoFightNotice):
					if(!_debugHelper.replaying){
						new RequestAutoFightCommand().call();//查询是否自动战斗
					}
					break;
				case getQualifiedClassName(ComboPauseTimeNotice):
					TimerProvider.removeEnterFrameTask(onRenderer);
					break;
				case getQualifiedClassName(ComboResumeTimeNotice):
					TimerProvider.addEnterFrameTask(onRenderer);
					break;
				case getQualifiedClassName(OtherPlayerResCompleteNotce):
					_roundMgr.pushMetaDataNew(handOtherPlayerResComplete, [(notice as OtherPlayerResCompleteNotce).pos],"handOtherPlayerResComplete");
					break;
				
				case getQualifiedClassName(UpdatePlayerInfoNotice):
					_roundMgr.pushMetaDataNew(handModifyPlayerInfo, [notice],"UpdatePlayerInfoNotice");
					_debugHelper.record(notice);
					break;
				case getQualifiedClassName(ContractPetEnterNotice):
					_roundMgr.pushMetaDataNew(handContractPet, [true, (notice as ContractPetEnterNotice).contractPetInfo],"ContractPetEnterNotice");
					_debugHelper.record(notice);
					break;
				case getQualifiedClassName(ContractPetExeuntNotice):
					_roundMgr.pushMetaDataNew(handContractPet, [false,null],"ContractPetExeuntNotice");
					_debugHelper.record(notice);
					break;
				case getQualifiedClassName(UpdateWatchFlagNotice):
					var model:int = (notice as UpdateWatchFlagNotice).model;
					BattleData.singleton.serverWatchFlag = model;
					_roundMgr.pushMetaDataNew(handWatchFlgUpdate, [model],"UpdateWatchFlagNotice");
					_debugHelper.record(notice);
					break;
				case getQualifiedClassName(GiveUpBattleRequestNotice):
					var giveUpCommand:GiveUpBattleCommand;
					
					giveUpCommand = new GiveUpBattleCommand();
					giveUpCommand.addEventListener(CommandEvent.FINISH, onGiveUpFinish);
					giveUpCommand.addEventListener(CommandEvent.FAILD, onGiveUpFinish);
					giveUpCommand.call();
					break;
				case getQualifiedClassName(GiveUpBroadcastNotice):
					changeToGiveStatus();
					battleView.disableExit();
					break;
				case getQualifiedClassName(StopTinyRoundNotice):
					_roundMgr.stopTiny();
					break;
				case getQualifiedClassName(ContinueTinyRoundNotice):
					_roundMgr.continueTiny();
					break;
				case getQualifiedClassName(LockAllSkillBtnNotice):
					if((notice as LockAllSkillBtnNotice).lock)
					{
						battleView.lockAllSkillBtns();
					}
					else
					{
						battleView.unlockAllSkillBtns();
					}
					break;
				case getQualifiedClassName(SkillVidoNotice):
					if((notice as SkillVidoNotice).isStart)
					{
						speedTime = Speed_Normal;
					}
					else
					{
						if(BattleTypeGroup.getSpeedStatus(BattleData.singleton.fightType))
						{
							speedTime = Speed_X2;
						}
						else
						{
							speedTime = Speed_X1;
						}
					}
					break;
				case getQualifiedClassName(GVGFightOverNotice):
					battleView.clearAllSkillBtn();
					_sceneIndex += 100000;
					_roundMgr.pushMetaDataNew(handGVGFightOver, null, "GVGFightOverNotice");
					_debugHelper.record(notice);
					break;
				case getQualifiedClassName(SpeedUpRenderNotice):
					speedUpRender();
					break;
			}
		}
		
		private function handGVGFightOver():void 
		{
			uiData.removeAllOurPlayer();
			uiData.self = null;
			BattleData.singleton.isGVGFightOverState = 0;
			plugin.getSoundManager().battleMusicMgr.restoreVolume();
			handleRoundTimeOut();
		}
		private function doShowDamageViewCmd(c:ShowDamageViewCmd):void {
			battleView.showDamageView();
		}
		private function onGiveUpFinish(evt:CommandEvent):void
		{
			var giveUpCommand:GiveUpBattleCommand;
			
			if(evt.type == CommandEvent.FAILD){return ;}
			
			giveUpCommand = evt.currentTarget as GiveUpBattleCommand;
			giveUpCommand.removeEventListener(CommandEvent.FINISH, onGiveUpFinish);
			giveUpCommand.removeEventListener(CommandEvent.FAILD, onGiveUpFinish);
			
			changeToGiveStatus();
			
			if(evt.type == CommandEvent.FINISH)
			{
				battleView.disableExit();
			}
		}
		
		//private var uiEffects:Array = [];
		private function updateSkillStates(skillStates:Array):void
		{
			for each(var skillState:SkillStatuInfo in skillStates)
			{
				battleView.updateSkillStates(skillState);
			}
		}
		
		private var scripteNoticeDelay:int;
		private function onScriptFinish(evt:CommandEvent):void
		{
			if (!inited) return ;
			
			scriptActionInfo = null;//开关剧情清掉
			notifyResComplete();
		}
		//上报SEVER，剧情播完
		private function ackScriptFinish():void
		{
			scripteNoticeDelay = 0;
			new BattleScriptAckCommand(uiData.selfTeamId).call();
		}
		
		private function onNinjaEnter(ninjaInfos:Array):void
		{
			var battlePlayer:UIPlayerData;
			var ninjaCfg:NinjaBattleCfgInfo;
			var uiNinjaData:UINinjaData;
			var teamId:int;
			
			uiData.setLockHp(false);
			new NinjaEnterCommand(ninjaInfos).call();
			for each(var ninjiaInfo:NinjaInfo in ninjaInfos)
			{
				if(uiData.self)
				{
					ninjiaInfo.selfTeam = (uiData.self.teamId == ninjiaInfo.teamId);
				}
				
				ninjaCfg = NinjaConfig.getNinjaInfoById(ninjiaInfo.ninjaId);
				logger.output("onNinjaEnter", "pos", ninjiaInfo.pos, "ninjaId", ninjiaInfo.ninjaId, "cfg", ninjaCfg == null);
				if(ninjaCfg.cfgInfo.type == NinjaDef.TYPE_CONTRACT_PET && uiData.isOurPlayerPos(ninjiaInfo.teamId))
				{
					teamId = uiData.self.teamId;
					ninjiaInfo.teamId = uiData.self.teamId;
					
					if(selfInfo.teamId != null && selfInfo.isCaptain == false)
					{
						battleView.petLock(true);
					}
				}
				else
				{
					teamId = ninjiaInfo.teamId;
				}
				
				logger.output("onNinjaEnter", "pos", ninjiaInfo.pos, "ninjaId", ninjiaInfo.ninjaId, "teamId", teamId);
				battlePlayer = uiData.getPlayer(teamId);
				if(!battlePlayer)
				{
					battlePlayer = new UIPlayerData();
					battlePlayer.teamId = teamId;
					uiData.addPlayer(battlePlayer, uiData.isOurPlayerPos(teamId));
				}
				
				ninjiaInfo.playerOnline = battlePlayer.isOnline;
				
				uiNinjaData = uiData.getPlayer(teamId).getNinja(ninjiaInfo.pos);
				if(uiNinjaData != null)
				{
					logger.output("onNinjaEnter", "pos", ninjiaInfo.pos, "ninjaId", ninjiaInfo.ninjaId, "Player", uiData.getPlayer(teamId) == null);
					uiData.getPlayer(teamId).removeNinja(uiNinjaData);
					battleView.clearSkillBtn(uiNinjaData.pos);
				}
				logger.output("onNinjaEnter", "pos", ninjiaInfo.pos, "ninjaId", ninjiaInfo.ninjaId, "battleView", battleView == null);
				
				uiNinjaData = new UINinjaData();
				uiNinjaData.pos = ninjiaInfo.pos;
				uiNinjaData.id = ninjiaInfo.ninjaId;
				uiNinjaData.hp = ninjiaInfo.hp;
				uiNinjaData.level = ninjiaInfo.level;
				uiNinjaData.hpMax = ninjiaInfo.maxHP;
				uiNinjaData.hpInfoVisible = ninjiaInfo.hpInfoVisible;
				uiNinjaData.teamId = ninjiaInfo.teamId;
				uiNinjaData.controlTeam = ninjiaInfo.controlTeam;
				uiData.getPlayer(teamId).addNinja(uiNinjaData);
				uiData.updatePlayerHp(teamId);
				
				//				if(ninjiaInfo.selfTeam)
				//				{
				battleView.setHpBarType(ninjaCfg.cfgInfo.hpType, ninjiaInfo.pos);
				//				}
				checkAndUpdateEnervation(ninjiaInfo);
				
				battleView.ninjaEnter();
				battleView.updateSkillBtn(ninjiaInfo.pos, ninjiaInfo.ninjaId, ninjiaInfo.skillIndex, ninjiaInfo.skillStates);
				updateSkillStates(ninjiaInfo.skillStates);
			}
		}
		
		private function checkAndUpdateEnervation(ninjaInfo:NinjaInfo):void
		{
			if(BattleData.singleton.enervationCountDown > 0)
			{
				if(BattleData.singleton.getUIdata().isOurNinjaPos(ninjaInfo.pos) == false)
				{
					if(NinjaConfig.getNinjaInfoById(ninjaInfo.ninjaId).cfgInfo.type == NinjaDef.TYPE_CONTRACT_PET)
					{
						ninjaInfo.enervation = true;
					}
				}
			}
		}
		
		private function onNinjaExeunt(ninjaInfos:Array):void
		{
			var teamId:int;
			var ninjaCfg:NinjaBattleCfgInfo;
			var player:UIPlayerData;
			
			new NinjaExeuntCommand(ninjaInfos).call();
			for each(var ninjiaInfo:NinjaInfo in ninjaInfos)
			{
				teamId = ninjiaInfo.teamId;
				ninjaCfg = NinjaConfig.getNinjaInfoById(ninjiaInfo.ninjaId);
				if(ninjaCfg.cfgInfo.type == NinjaDef.TYPE_CONTRACT_PET && uiData.isOurPlayerPos(ninjiaInfo.teamId))
				{
					if(selfInfo.teamId != null && selfInfo.isCaptain == false)
					{
						battleView.petLock(false);
					}
				}
				
				player = uiData.getPlayer(ninjiaInfo.teamId);
				if(player == null){logger.output(I18n.lang("as_battle_1451031565_310_0") + ninjiaInfo.pos + I18n.lang("as_battle_1451031565_310_1") + ninjiaInfo.teamId + I18n.lang("as_battle_1451031565_310_2"));  return ;}
				player.removeNinja(player.getNinja(ninjiaInfo.pos));
				uiData.updatePlayerHp(player.teamId);
				battleView.ninjaExeunt();
				battleView.clearSkillBtn(ninjiaInfo.pos);
			}
		}
		
		private function onNinjaReplace(ninjaInfos:Array):void
		{
			
		}
		private function showBattleResult(damageInfo:DamageInfo):void
		{
			///
			
			if(isContinueTest)
			{
				dispose();
				return ;
			}
			
			new NotifyFightCompleteCommand().call();
			
			//if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			//{
			//damageInfo = null;
			//}
			
			if(_needShowResult)
			{
				plugin.getSoundManager().battleMusicMgr.stop();
				battleView.showResult(isWin, damageInfo != null);
			}
			else
			{
				_timeOutList.push(setTimeout(dispose, 1000));
			}
			
			battleModel.showResult();
		}
		
		private var sceneSnapshot:Bitmap;
		private var frameSnapshot:Bitmap;
		private function doGotoNextFightCommand(c:GotoNextFightCommand):void
		{
			var sceneInfo:SceneInfo;
			var scceneBitmapData:BitmapData;
			var frameBitmapData:BitmapData;
			var fightFrame:FightFrameUI;
			
			if(sceneSnapshot)
			{
				sceneSnapshot.bitmapData.dispose();
				LayoutManager.singleton.removeItem(sceneSnapshot);
				sceneSnapshot = null;
				
				frameSnapshot.bitmapData.dispose();
				LayoutManager.singleton.removeItem(frameSnapshot);
				frameSnapshot = null;
			}
			
			sceneInfo = SceneConfig.getSceneInfo(sceneId);
			
			sceneSnapshot = new Bitmap();
			scceneBitmapData = new BitmapData(this.motionPlayer.width, this.motionPlayer.height);
			scceneBitmapData.draw(motionPlayer);
			sceneSnapshot.bitmapData = scceneBitmapData;
			LayoutManager.singleton.addItemAndLayout(sceneSnapshot, LayerDef.FIGHT_UI, LocationDef.MIDCENTRE);
			
			fightFrame = new FightFrameUI();
			
			frameSnapshot = new Bitmap();
			frameBitmapData = new BitmapData(fightFrame.width, fightFrame.height, true, 0x00000000);
			frameBitmapData.draw(fightFrame);
			frameSnapshot.bitmapData = frameBitmapData;
			LayoutManager.singleton.addItemAndLayout(frameSnapshot, LayerDef.BATTLE_FRAME, LocationDef.MIDCENTRE);
			
			battleModel.addEventListener(ModelEvent.UPDATE, onBattleModelUpdate);
			
			dispose(false);
			//			BackGround.addBackground(BackgroundGroupDef.BATTLE, BackGroundDef.BATTLE_FRAME, LayerDef.BATTLE_FRAME);
			new RequestPveFightStartCommand(FightStartType.FIGHT_START_TYPE_NINJA_EXAM, c.battleID).call();
		}
		
		private function doUpdateLeftBattleRoundCommad(c:UpdateLeftBattleRoundCommand):void
		{
			_debugHelper.record(c);
			_roundMgr.pushMetaDataNew(handUpdateLeftBattleRoundCommand, [c.round],"doUpdateLeftBattleRoundCommad");
		}
		
		private function handUpdateLeftBattleRoundCommand(round:int):void
		{
			battleView.updateLeftRound(round);
		}
		
		private function onBattleModelUpdate(evt:ModelEvent):void
		{
			switch(evt.key)
			{
				case BattleKeyDef.START:
					battleModel.removeEventListener(ModelEvent.UPDATE, onBattleModelUpdate);
					break;
				case BattleKeyDef.FAIL:
					BackGround.disposeGroup(BackgroundGroupDef.BATTLE);
					battleModel.removeEventListener(ModelEvent.UPDATE, onBattleModelUpdate);
					break;
			}
		}
		
		private function showBlackBackGround():void
		{
			if (backGround) {
				logger.output(I18n.lang("as_battle_1451031565_311"));
			}else{
				backGround = new Shape();
				backGround.graphics.beginFill(0x0, 1);
				backGround.graphics.drawRect(0, 0, LayerManager.singleton.stage.width, LayerManager.singleton.stage.height);
				LayoutManager.singleton.addItemAndLayout(backGround, LayerDef.BATTLE_MASK_DEF, LocationDef.TOPLEFT);
			}
		}
		
		
		//////////////////////////   battle View
		
		
		public function hideUI():void
		{
			//			motionPlayer.hideUI();
			//			battleView.hideBattleUI();
		}
		
		private var hasPushFrameSize:Boolean;
		private function showBattleViewUI():void
		{
			//			if(!BackGround.hasBackground(BackgroundGroupDef.BATTLE, BackGroundDef.BATTLE_FRAME))
			//			{
			//				BackGround.addBackground(BackgroundGroupDef.BATTLE, BackGroundDef.BATTLE_FRAME, LayerDef.BATTLE_FRAME);
			//			}
			hasPushFrameSize = true;
			LayoutManager.singleton.pushFrameSize(FrameSizeDef.FIGHT_MIN_WIDTH, FrameSizeDef.FIGHT_MAX_WIDHT, FrameSizeDef.FIGHT_MIN_HEIGHT, FrameSizeDef.FIGHT_MAX_HEIGHT);
			
			battleView ||= new BattleView(onUseSkill);
			battleView.addMotionPlayer(motionPlayer);
			LayerManager.singleton.addItemToLayer(battleView, LayerDef.FIGHT_UI);
			battleView.setUIData(uiData);
			battleView.y = -BattleView.PLAYER_OFFSET;
			changedCustomId(uiData.customInfo);
			changeWatchFlg();
			battleModel.showFightScene();
			
			if(BattleTypeGroup.getAutoStatus(BattleData.singleton.fightType))
			{
				new RequestAutoFightCommand().call();//自动战斗
			}
			
			if(BattleTypeGroup.getSpeedStatus(BattleData.singleton.fightType))
			{
				new SendSpeedMessageCommand(1, false).call();
			}
			else
			{
				new SendSpeedMessageCommand(0, false).call();
			}
			
			if(ApplicationData.singleton.selfInfo.teamId != "" && ApplicationData.singleton.selfInfo.teamId != null && ApplicationData.singleton.selfInfo.isCaptain == false)
			{
				battleView.updateSpeedUpLabel(BattleTypeGroup.getSpeedStatus(BattleData.singleton.fightType));
			}
			
			updateState();
		}
		/**技能键点击后调用*/
		private function onUseSkill(ninjaPos:int, index:int, isContractPet:Boolean):void
		{
			if(BattleData.singleton.guidState != BattleData.GUID_SKILL_REQUEST && BattleData.singleton.guidState != BattleData.FRIST_BATTLE_GUID_SKILL)
			{
				//召唤召唤兽
				if(isContractPet)
				{
					battleView.setLock(ninjaPos, true, index);
					new RequestSummonContractPetCommand().call();
					return ;
				}
				
				var passivePos:int = motionPlayer.getSelectedNinjaPos();
				if(ninjaPos!=-1)
				{
					battleView.setLock(ninjaPos, true, index);
					
					var c:RequestKathaSkillCommand = new RequestKathaSkillCommand(ninjaPos,passivePos,index);
					c.addEventListener(CommandEvent.FINISH,onReqKathaSkillCommand);
					c.addEventListener(CommandEvent.FAILD, onReqKathaSkillFaild);
					c.call();
				}
			}
			
			if(BattleData.singleton.guidState == BattleData.FRIST_BATTLE_GUID_SKILL)
			{
				battleView.setLock(ninjaPos, true, index);
				
				BattleData.singleton.guidState = BattleData.GUID_SKILL_NONE;
				new ContinueTinyRoundNotice().send();
				new ShowGuidSkillCommand(-1, -1).call();
				
				uiData.self.mp += curGuidSkillCommand.mp;
				uiData.self.dispathUpdateAll();
				curGuidSkillCommand = null;
			}
			
			new DoUseKathaSkillNotice(ninjaPos, passivePos, index).send();
		}
		/**Sever返回的技能键点击后，成功的结果*/
		protected function onReqKathaSkillCommand(event:CommandEvent):void
		{
			var c:RequestKathaSkillCommand = event.currentTarget as RequestKathaSkillCommand;
			c.removeEventListener(CommandEvent.FINISH,onReqKathaSkillCommand);
			c.removeEventListener(CommandEvent.FAILD, onReqKathaSkillFaild);
			switch(event.type)
			{
				case CommandEvent.FINISH:
					//模拟一个更新command，延迟更新;
					var fake:NotifyKathaSkillCommand = new NotifyKathaSkillCommand;
					fake.ninjaPos = c.activePos;
					fake.skillIndex = c.skillIndex;
					fake.mp = c.kathaChange;
					fake.skillState = c.skillStates;
					fake.dontDelay = true;
					fake.call();
					break;
			}
		}
		/**Sever返回的技能键点击后，失败的结果*/
		private function onReqKathaSkillFaild(event:CommandEvent):void
		{
			var c:RequestKathaSkillCommand = event.currentTarget as RequestKathaSkillCommand;
			c.removeEventListener(CommandEvent.FINISH,onReqKathaSkillCommand);
			c.removeEventListener(CommandEvent.FAILD, onReqKathaSkillFaild);
			
			if(battleView)
			{
				battleView.setLock(c.activePos, false, c.skillIndex);
				battleView.setSyncLock(c.activePos, true, c.skillIndex);
				
				_roundMgr.pushMetaDataNew(handSyncLock, [c.activePos, c.skillIndex],"onReqKathaSkillFaild");
			}
		}
		
		
		private function doUpdateContinueTestFlagCommand(c:UpdateContinueTestFlagCommand):void 
		{
			isContinueTest = c.isContinueTest;
		}
		
		private function doNotifyAutoFightCommand(c:NotifyAutoFightCommand):void 
		{
			battleView.updateAutoFightLabel(c.isAutoFight);
			BattleTypeGroup.setAutoStatus(BattleData.singleton.fightType, c.isAutoFight);
			
			//			if(ApplicationData.singleton.isAutoFight)
			//			{
			//				new RequestSpeedUpNotice(true).send();
			//			}
			//			else
			//			{
			//				new RequestSpeedUpNotice(false).send();
			//			}
		}
		
		private function doUpdatePlayerOnlineInfoCommand(c:UpdatePlayerOnlineInfoCommand):void 
		{
			var teamId:int;
			var isOnline:Boolean;
			var battlePlayerInfo:UIPlayerData;
			
			_debugHelper.record(c);
			
			teamId = c.teamId;
			isOnline = c.isOnline;
			battlePlayerInfo = uiData.getPlayer(teamId);
			if(battlePlayerInfo)
			{
				battlePlayerInfo.setOnline(isOnline);
				motionPlayer.updateNinjaOnline(battlePlayerInfo.teamId, isOnline);
			}
			
			WaitLoadingData.singleton.removeWaitPlayer(c.teamId);
			_loadHelper.checkComplete();
		}
		
		private function doShowPrewarChooseCommand(c:ShowPrewarChooseCommand):void 
		{
			if(battleData.skillStatus == BattleData.SKILL_STATUS_NONE || battleData.skillStatus == BattleData.SKILL_STATUS_WATCH_OFF)
			{
				if(BattleData.singleton.guidState != BattleData.GUID_SKILL_REQUEST)
				{
					battleView.lockAllSkillBtns();
				}
				c.addEventListener(CommandEvent.FINISH, onPrewarChooseResult);
				_roundMgr.pushMetaDataNew(handShowPrewarChoose, [c],"doShowPrewarChooseCommand");
			}
			
			battleData.fightState = BattleData.FIGHT_STATE_SHOW_FIGHT_TIPS;
		}
		
		private function doStartPrewarOptionNotifyCommand(c:StartPrewarOptionNotifyCommand):void 
		{
			LoadingManager.hideWaitLoading();
			pauseRender();
			
			battleView.clearAllSkillBtn();
			
			battleData.resState = BattleData.RES_STATE_INIT_PREWAR_RES;
			battleData.fightState = BattleData.FIGHT_STATE_PREWAR_OPTION;
		}
		
		private function doHidePerwarCommand(c:HidePerwarCommand):void 
		{
			battleView.hidePrewar();
		}
		
		private function doNotifyPrewarResToLoadCommand(c:NotifyPrewarResToLoadCommand):void 
		{
			resNoticed = false;
			loadAssets(sceneId, c.ninjaList, c.contractPetInfo, false);
		}
		
		private function doNotifyWatchTransfomResAckCommand(c:NotifyWatchTransfomResAckCommand):void 
		{
			_roundMgr.pushMetaDataNew(handWatchTransformResAck,[c],"doNotifyWatchTransfomResAckCommand");
		}
		
		private function doShowResLoadCommand():void
		{
			_roundMgr.pushMetaDataNew(handShowResLoadCommand,null,"doShowResLoadCommand");
		}
		
		private function doChangeWatchFlgCommand(c:ChangeWatchFlgCommand):void 
		{
			battleData.skillStatus = c.watchFlg;
			changeWatchFlg();
		}
		
		private function doShowGuidSkillCommand(c:ShowGuidSkillCommand):void 
		{
			battleView.showGuidSkill(c.type, c.skillIndex);
		}
		
		private function doShowNinjaGuidCommand(c:ShowNinjaGuidCommand):void 
		{
			motionPlayer.showNinjaGuid(c.pos);
		}
		
		private function doShowTargetGuidTipsCommand(c:ShowTargetGuidTipsCommand):void 
		{
			battleView ||= new BattleView(onUseSkill);
			battleView.showTargetGuidTips();
			
			changeWatchFlg();
		}
		
		private function doHideTargetGuidTipsCommand(c:HideTargetGuidTipsCommand):void 
		{
			battleView.hideTargetGuidTips();
		}
		
		private function doDestroyBattleCommand(c:DestroyBattleCommand):void 
		{
			dispose(c.isNotifyEnd);
		}
		
		private function dispose(notifyOver:Boolean = true):void
		{
			var wailtDestroyActionList:Array;
			
			if (!inited) return ;
			
			BattleData.singleton.socketClosePharse = BattleData.SOCKET_CLOSE_PHARSE_RES_LOADING;
			
			wailtDestroyActionList = Action.waitDestroyActionList;
			CollectionClearUtil.clearList(wailtDestroyActionList, "destroy");
			
			inited = false;
			speedUpFlag = false;
			roundSynFlag = false;
			_roundIndex = 0;
			_sceneIndex = 0;
			_speedTime = Speed_X1;
			_isTemporarySpeedUp = false;
			_beginSkillcount = 0;
			
			TimerProvider.removeTimeTask(0, onRenderer);
			TimerProvider.removeEnterFrameTask(onRenderer);
			TweenManager.killAll();
			BattleData.singleton.isReplay = false;
			LayerManager.singleton.setLayerVisible(LayerDef.CHAT, true);
			
			BackGround.disposeGroup(BackgroundGroupDef.BATTLE);
			
			// 战斗结束播放地图背景音乐，并停止战斗音乐
			plugin.getSoundManager().battleMusicMgr.stop();
			plugin.getSoundManager().bgMusicMgr.resume();
			
			for each(var timeId:int in _timeOutList)
			{
				clearTimeout(timeId);
			}
			
			_timeOutList.splice(0, _timeOutList.length);
			
			if(backGround != null)
			{
				LayoutManager.singleton.removeItem(backGround);
				this.backGround.graphics.clear();
				this.backGround = null;
			}
			
			var curFrameSizeInfo:Object;
			curFrameSizeInfo = LayoutManager.singleton.getCurFrameSize();
			if(hasPushFrameSize)
			{
				LayoutManager.singleton.popFrameSize();
			}
			
			if(motionPlayer)
			{
				motionPlayer.destroy();
			}
			
			motionPlayer = null;
			
			if(battleView)
			{
				battleView.updateMoneyNow();
				DisplayUtils.clear(battleView);
				LayerManager.singleton.removeItemToLayer(battleView);
				battleView.destroy();
				battleView = null;
			}
			
			battleData.resState = BattleData.RES_STATE_NONE;
			battleData.fightState = BattleData.FIGHT_STATE_NONE;
			
			scriptActionInfo = null;
			if(uiData)
			{
				battleData.skillStatus = BattleData.SKILL_STATUS_NONE;
				uiData.rest();
				uiData = null;
			}
			
			ResManager.pub::getPluginAsset = null;
			
			resNoticed = false;
			BattleData.singleton.needShowFightTips = false;
			
			MMEAssetsProvider.asstets.dispose();
			MotionNotifyCenter.destroy();
			
			TimerProvider.stageFrameRate = 30;
			
			if(notifyOver){battleModel.battleEnd();}
			if (BattleData.singleton.fightType != RequestFightStartTypeDef.FIRST_GUID_FIGHT)
			{
				changeSelfState(UserStateDef.BASE_PVE, false);
				changeSelfState(UserStateDef.BASE_PVP, false);
			}
			if(_loadHelper)
			{
				_loadHelper.dispose();
			}
			//			if(_debugHelper)
			//			{
			//				_debugHelper.dispose();
			//			}
			if(_roundMgr)
			{
				_roundMgr.dispose();
			}
			new EndGuidCommand().call();
			
			handleRoundTimeOut();
			
			StageActionConverter.clearRealStageNinja();
			MessageRecoData.singleton.reset();
			if (BattleData.singleton.fightType != RequestFightStartTypeDef.FIRST_GUID_FIGHT)
			{
				new UpdateHudBattlePowerLockCommand(false).call();
				new ExitPrewarCommand().call();
			}
			
			//结束时一定要重设这个值
			BattleData.singleton.isGVGFightOverState = 0;
			//			autoDestroy();
			
			LayerManager.singleton.setLayerVisible(LayerDef.LOADING, true);
			
			ConverterResultInfo.clear();
			new CancelPlotCommand().call();
//			new ReportFightLogInfoCommand().call();
		}
		
		private function handFightOver(c:NotifyFightOverCommand):void 
		{
			battleView.updateDamageInfo(c.damageInfo);
			battleView.setSkillButtonEnabled(false);
			TweenManager.delayedCall(0.7,showBattleResult, [c.damageInfo]);
		}
		
		private function handleRoundTimeOut():void 
		{
			if(BattleData.singleton.isTimeOut)
			{
				new PasteMessageCommand(ChatChanelDef.SYSTEM, I18n.lang("as_battle_1451031565_313")).call();
				GameTip.show(I18n.lang("as_battle_1451031565_314"));
				
				BattleData.singleton.isTimeOut = false;
			}
		}
		
		
		private function set speedTime(time:Number):void
		{
			_speedTime = time;
			updateSpeedTime();
		}
		private function setIsTemporarySpeedUp(value:Boolean):void {
			logger.output("[ControlExecuter][Devin]>>>setIsTemporarySpeedUp:" , value,_beginSkillcount);
			_isTemporarySpeedUp = value;
			updateSpeedTime();
		}
		private function updateSpeedTime():void {
			if (_isSlowRate) {
				TimerProvider.stageFrameRate = 24 * Speed_Slow;
			}else if (_isTemporarySpeedUp) {
				TimerProvider.stageFrameRate = 24 * Speed_X2;
			}else {
				TimerProvider.stageFrameRate = 24 * _speedTime;
			}
			
		}
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}
			
			uiData = null;
			battleData = null;
			motionPlayer = null;
			battleModel = null;
			battleView = null;
			backGround = null;
			scriptActionInfo = null;
			_loadMgr = null;
			_cmd2Handler = null;
			_roundMgr = null;
			_debugHelper = null;
			_loadHelper = null;
			_timeOutList = null;
		}
	}
}