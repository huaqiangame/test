package com.tencent.morefun.naruto.plugin.battle.executer.controlClasses 
{
	
	import com.tencent.morefun.framework.apf.managers.plugin.NarutoAssetsEvent;
	import com.tencent.morefun.framework.apf.managers.plugin.NarutoAssetsLoader;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.framework.net.LoadManager;
	import com.tencent.morefun.framework.net.pub;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.WaitLoadingData;
	import com.tencent.morefun.naruto.plugin.battle.executer.ControlExecuter;
	import com.tencent.morefun.naruto.plugin.exui.loading.NarutoLoading;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	import com.tencent.morefun.naruto.util.def.TimerDef;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import serverProto.fight.FightStartType;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class LoadAssetHelper extends EventDispatcher
	{
		
		static public const LOAD_SELF_COMPLETE:String = "loadSelfComplete";
		static public const ALL_PLAYER_COMPLETE:String = "allPlayerComplete";
		
		public static var ctrl:ControlExecuter;
		public static var pluginName:String;
		private static var instance:LoadAssetHelper;
		
		private var preLoadingCompleteOffsetFile:int;
		private var _missionMap:Dictionary = new Dictionary();
		private var _loadMgr:LoadManager;
		private var _quenCompleteNotify:Boolean;
		private var _resTimeOut:int;
		
		private var _narutoAssetsLoading:NarutoAssetsLoader;
		
		public function LoadAssetHelper() 
		{
			
		}
		
		public static function get singleton():LoadAssetHelper
		{
			if(!instance)
			{
				instance = new LoadAssetHelper();
			}
			
			return instance;
		}
		
		public function reset():void
		{
			_loadMgr = LoadManager.getManager("battle");
			_loadMgr.pub::log = logger.output;
		}
		public function dispose():void {
			if(_loadMgr)
			{
				trace("LoadAssetHelper", "dispose");
				_loadMgr.disposeAll(true);
				_loadMgr = null;
			}
			
			if(_narutoAssetsLoading != null)
			{
				_narutoAssetsLoading.removeEventListener(NarutoAssetsEvent.ALL_COMPLETE, onAllAssetsComplete);
				_narutoAssetsLoading.removeEventListener(NarutoAssetsEvent.ASSET_COMPLETE, onAssetComplete);
				_narutoAssetsLoading.removeEventListener(NarutoAssetsEvent.PROGRESS, onAssetsProgress);
				_narutoAssetsLoading.dispose();
				_narutoAssetsLoading = null;
			}
			WaitLoadingData.singleton.dispose();
			TimerProvider.removeTimeTask(1000, onCountDown);
			TimerProvider.removeTimeTask(_resTimeOut * TimerDef.SECOND, onResQueueTimeOut);
			
			NarutoLoading.loadingView.hide();
			NarutoLoading.loadingView.setWaitingInfo("");
		}
		
		private function onResQueueTimeOut():void
		{
			logger.output("onResQueueTimeOut");
			
			dispathComplete();
		}
		
		private function onAllAssetsComplete(e:NarutoAssetsEvent):void
		{
			_narutoAssetsLoading.removeEventListener(NarutoAssetsEvent.ALL_COMPLETE, onAllAssetsComplete);
			if(_quenCompleteNotify){dispathComplete();}
		}
		
		private function onAssetComplete(e:NarutoAssetsEvent):void
		{
			if(e.data == null)
			{
				NarutoLoading.loadingView.errorTips = I18n.lang("as_battle_1451031565_277") + e.url;
			}
			else
			{
				NarutoLoading.loadingView.assetTips = I18n.lang("as_battle_1451031565_278") + e.url;
			}
			
		}
		
		private function onAssetsProgress(e:NarutoAssetsEvent):void
		{
			NarutoLoading.loadingView.percent = e.data;
		}
		
		/**加载主角小组忍者资源*/
		public function loadAssets(sceneId:int, ninjaInfoList:Array, contractPetInfo:NinjaInfo, mask:Boolean = true):void
		{
			var resourceList:Vector.<String>;
			
			if(_narutoAssetsLoading != null)
			{
				_narutoAssetsLoading.dispose();
				_narutoAssetsLoading.removeEventListener(NarutoAssetsEvent.ALL_COMPLETE, onAllAssetsComplete);
				_narutoAssetsLoading.removeEventListener(NarutoAssetsEvent.ASSET_COMPLETE, onAssetComplete);
				_narutoAssetsLoading.removeEventListener(NarutoAssetsEvent.PROGRESS, onAssetsProgress);
				_narutoAssetsLoading = null;
			}
			
			_narutoAssetsLoading = new NarutoAssetsLoader();
			_narutoAssetsLoading.addEventListener(NarutoAssetsEvent.ALL_COMPLETE, onAllAssetsComplete);
			_narutoAssetsLoading.addEventListener(NarutoAssetsEvent.ASSET_COMPLETE, onAssetComplete);
			_narutoAssetsLoading.addEventListener(NarutoAssetsEvent.PROGRESS, onAssetsProgress);
			
			_quenCompleteNotify = true;
			_resTimeOut = BattleData.singleton.timeout - 5;
			TimerProvider.addTimeTask(_resTimeOut * TimerDef.SECOND, onResQueueTimeOut);
			
			resourceList = ctrl.motionPlayer.preLoadRoelRes(sceneId, ninjaInfoList, contractPetInfo);
			_narutoAssetsLoading.pushNewDomainAssets(resourceList);
			_narutoAssetsLoading.start(_loadMgr);
			
			logger.output("loadAssets", resourceList.length);
			
			NarutoLoading.loadingView.keepClean(true);
			NarutoLoading.loadingView.show();
			if(WaitLoadingData.singleton.needShowWait && !WaitLoadingData.singleton.isComplete)
			{
				NarutoLoading.loadingView.setWaitingInfo(WaitLoadingData.singleton.getWaitText());
			}
			
			if(resourceList.length == 0)
			{
				NarutoLoading.loadingView.percent = 100;
				
				// TODO 修改了，要验
				NarutoLoading.loadingView.assetTips = I18n.lang("as_battle_1451031565_279");
				dispathComplete();
			}
			
			if(BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_BATTLE_ROYALE ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_EXPEDITION ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GUILD_ROBBERY ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_GVG ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_BASE_MAIN_FORMATION ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_BASE_MONEY_FORMATION ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_BASE_RASHOMON_FORMATION ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_INFERIOR ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_PVP_SINGLE_ARENA_MEDIUM ||
				BattleData.singleton.fightType == FightStartType.FIGHT_START_TYPE_RANK_BATTLE)
			{
				updateCountdown();
			}
		}
		
		private var countdown:int;
		private function updateCountdown():void
		{
			countdown = BattleData.singleton.timeout;
			
			updateCountdownText();
			TimerProvider.addTimeTask(1000, onCountDown);
		}
		
		private function updateCountdownText():void
		{
			countdown = Math.max(0, --countdown);
			NarutoLoading.loadingView.setCountDownInfo(countdown + I18n.lang("as_battle_1451031565_280"));
		}
		
		private function onCountDown():void
		{
			updateCountdownText();
		}
		
		private var _teamId:int;
		public function set teamId(value:int):void
		{
			logger.output("loadAssets", "set teamId", value);
			
			_teamId = value;
		}
		
		private function dispathComplete():void 
		{
			logger.output("onResQueueTimeOut");
			
			BattleData.singleton.socketClosePharse = BattleData.SOCKET_CLOSE_PHARSE_ROUND_END;
			
			_quenCompleteNotify = false;
			TimerProvider.removeTimeTask(_resTimeOut * TimerDef.SECOND, onResQueueTimeOut);
			
			if(BattleData.singleton.skillStatus != BattleData.SKILL_STATUS_WATCH_ON)
			{
				WaitLoadingData.singleton.addCompletePlayer(_teamId);
			}
			if(WaitLoadingData.singleton.isComplete)
			{
				logger.output("onNinjaEnter", "WaitLoadingData.singleton.isComplete self");
				WaitLoadingData.singleton.waitComplete = true;
				
				NarutoLoading.loadingView.hide();
			}
			dispatchEvent(new Event(LOAD_SELF_COMPLETE));
		}
		
		public function addCompletePlayer(pos:int):void {
			logger.output("onNinjaEnter", "OtherPlayerResCompleteNotce", pos);
			WaitLoadingData.singleton.addCompletePlayer(pos);
			
			NarutoLoading.loadingView.setWaitingInfo(WaitLoadingData.singleton.getWaitText());
			checkComplete();
		}
		
		public function finishAllWaitPlayer():void
		{
			logger.output("finishAllWaitPlayer");
			WaitLoadingData.singleton.finishAllWaitPlayer();
			NarutoLoading.loadingView.setWaitingInfo(WaitLoadingData.singleton.getWaitText());
			checkComplete();
		}
		
		public function checkComplete():void
		{
			if(WaitLoadingData.singleton.isComplete && !WaitLoadingData.singleton.waitComplete)
			{
				logger.output("onNinjaEnter", "WaitLoadingData.singleton.isComplete other");
				
				WaitLoadingData.singleton.waitComplete = true;
				TimerProvider.removeTimeTask(1000, onCountDown);
				
				NarutoLoading.loadingView.hide();
				
				dispatchEvent(new Event(ALL_PLAYER_COMPLETE));
			}
		}
		
		public function setWaitComplete():void {
			if(!WaitLoadingData.singleton.waitComplete)
			{
				WaitLoadingData.singleton.waitComplete = true;
				
				TimerProvider.removeTimeTask(1000, onCountDown);
				
				
				NarutoLoading.loadingView.hide();
				dispatchEvent(new Event(ALL_PLAYER_COMPLETE));
			}
		}
		
		public function autoSetNull():void
		{
			
			_missionMap = null;
			_loadMgr = null;
			ctrl = null;
			pluginName = null;
		}
	}
	
}