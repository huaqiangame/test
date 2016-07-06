package com.tencent.morefun.naruto.plugin.battle
{
	import com.tencent.morefun.framework.loader.LoaderAssist;
	import com.tencent.morefun.framework.loader.LoaderEvent;
	import com.tencent.morefun.framework.loader.mission.Mission;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
    import com.tencent.morefun.naruto.i18n.I18n;

	import org.osmf.events.LoaderEvent;

	public class BattleAssetLoader extends LoaderAssist
	{
		private var currentCacheCheckMission:Mission;
		private var cacheCheckTimer:Timer;
		private var cacheCheckedQueue:Array;
		
		public function BattleAssetLoader(name:String)
		{
			super(name);
			
			cacheCheckedQueue = [];
		}
		
		override public function loadMission(mission:Mission):void
		{
			super.loadMission(mission);
			loadNextCacheCheckMission();
		}
		
		override protected function loadNextMisson():void
		{
			//正在加载,返回
			if(currentMission)
			{
				return;
			}
			
			//没有任务了
			if(missionCount<1 && cacheCheckedQueue.length<1)
			{
				if(currentCacheCheckMission==null)
				{
					trace("[CACHE]",I18n.lang("as_battle_1436356108_139_0"),I18n.lang("as_battle_1436356108_139_1"));
					dispatchEvent(new LoaderEvent(LoaderEvent.MISSION_EMPTY));
					
					//开始懒加载
					startLazyQueue();
				}
				return;
			}
			
			//获取一个新任务
			var mission:Mission = _queue.shift() as Mission;
			if(!mission)
			{
				mission = cacheCheckedQueue.shift() as Mission;
			}
			trace("[CACHE]",I18n.lang("as_battle_1436356108_140"),mission.name);
			
			setCurrentMission(mission);
			
			if(mission.useCache)
			{
				mission.start(getBytes(mission.name));
			}else
			{
				mission.start(null);
			}
		}
		
		private function loadNextCacheCheckMission():void
		{
			if(currentCacheCheckMission)
			{
				return;
			}
			
			if(missionCount < 1)
			{
				if(currentMission == null)
				{
					trace("[CACHE]",I18n.lang("as_battle_1436356108_141_0"),I18n.lang("as_battle_1436356108_141_1"));
					dispatchEvent(new LoaderEvent(LoaderEvent.MISSION_EMPTY));
					
					//开始懒加载
					startLazyQueue();
				}
				return;
			}
			
			var mission:Mission = _queue.shift() as Mission;
			
			
			setCurrentCacheCheckMission(mission);
			if(!cacheCheckTimer)
			{
				cacheCheckTimer = new Timer(100,1);
				cacheCheckTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onCacheCheckTimer);
			}
			cacheCheckTimer.reset();
			cacheCheckTimer.start();
			if(mission.useCache)
			{
				mission.start(getBytes(mission.name));
			}else
			{
				mission.start(null);
			}
		}
		
		private function onCacheCheckTimer(event:TimerEvent):void
		{
			if(currentCacheCheckMission.bytesLoaded < currentCacheCheckMission.bytesTotal && currentCacheCheckMission.bytesTotal != 0)
			{
				cacheCheckedQueue.push(currentCacheCheckMission);
				
				currentCacheCheckMission.abort();
			}
		}
		
		private function setCurrentCacheCheckMission(mission:Mission):void
		{
			if(currentCacheCheckMission)
			{
				currentCacheCheckMission.removeEventListener(LoaderEvent.MISSION_START,cacheMissionHandler);
				currentCacheCheckMission.removeEventListener(LoaderEvent.MISSION_PROGRESS,cacheMissionHandler);
				currentCacheCheckMission.removeEventListener(LoaderEvent.MISSION_COMPLETE,cacheMissionHandler);
				currentCacheCheckMission.removeEventListener(LoaderEvent.MISSION_ERROR,cacheMissionHandler);
				currentCacheCheckMission.removeEventListener(LoaderEvent.MISSION_ABORT,cacheMissionHandler);
				currentCacheCheckMission = null;
			}
			if(cacheCheckTimer)
			{
				cacheCheckTimer.stop();
			}
			
			if(!mission)
			{
				return;
			}
			currentCacheCheckMission = mission;
			mission.addEventListener(LoaderEvent.MISSION_START,cacheMissionHandler);
			mission.addEventListener(LoaderEvent.MISSION_PROGRESS,cacheMissionHandler);
			mission.addEventListener(LoaderEvent.MISSION_COMPLETE,cacheMissionHandler);
			mission.addEventListener(LoaderEvent.MISSION_ERROR,cacheMissionHandler);
			mission.addEventListener(LoaderEvent.MISSION_ABORT,cacheMissionHandler);
		}
		
		private function cacheMissionHandler(event:LoaderEvent):void
		{
			var mission:Mission = event.mission;;
			switch(event.type)
			{
				case LoaderEvent.MISSION_COMPLETE:
					trace("[BattleAssetLoader]",I18n.lang("as_battle_1436356108_142"),mission.name);
					
					saveCache(mission);
					
					setCurrentCacheCheckMission(null);
					
					dispatchEvent(event);
					
					loadNextCacheCheckMission();
					break;
				
				case LoaderEvent.MISSION_ERROR:
					trace("[BattleAssetLoader]",I18n.lang("as_battle_1436356108_143"),mission.name);
					
					setCurrentCacheCheckMission(null);
					
					dispatchEvent(event);
					
					loadNextCacheCheckMission();
					break;
				case LoaderEvent.MISSION_START:
					trace("[BattleAssetLoader]",I18n.lang("as_battle_1436356108_144"),mission.name);
					break;
				case LoaderEvent.MISSION_PROGRESS:
					trace("[BattleAssetLoader]",I18n.lang("as_battle_1436356108_145"),mission.name,mission.bytesLoaded,mission.bytesTotal);
					break;
				case LoaderEvent.MISSION_ABORT:
					trace("[BattleAssetLoader]",I18n.lang("as_battle_1436356108_146"),mission.name,mission.bytesLoaded,mission.bytesTotal);
					setCurrentCacheCheckMission(null);
					loadNextMisson();
					loadNextCacheCheckMission();
					break;
			}
			
			
		}
																
		override public function autoSetNull():void
		{
			if(super.hasOwnProperty("autoSetNull"))
			{
				super["autoSetNull"]();
			}
			currentCacheCheckMission = null;
			cacheCheckTimer = null;
			cacheCheckedQueue = null;
		}
	}
}
