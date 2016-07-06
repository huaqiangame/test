package com.tencent.morefun.naruto.plugin.battle.executer 
{

	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.plugin.battle.command.DoRoundSysncAckCommand;
	import com.tencent.morefun.naruto.plugin.battle.data.BattleData;
	import com.tencent.morefun.naruto.plugin.battle.data.MetaData;
	import com.tencent.morefun.naruto.plugin.battle.data.UIData;
	import com.tencent.morefun.naruto.plugin.motion.MotionLogger;
	import com.tencent.morefun.naruto.plugin.motion.MotionPlayer;
	import com.tencent.morefun.naruto.plugin.motion.data.BaseActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.EnervationActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.data.StageActionInfo;
	import com.tencent.morefun.naruto.plugin.motion.event.MotionEvent;
	import com.tencent.morefun.naruto.plugin.motion.manager.FightManagerCenter;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.Ninja;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.def.NinjaDef;
	import com.tencent.morefun.naruto.plugin.motion.notice.RoundChangedNotice;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import com.tencent.morefun.naruto.i18n.I18n;

	public class RoundManager extends EventDispatcher
	{
		private var _motionPlayer:MotionPlayer;
		//数据
		private var _rounds:Vector.<Round> = new Vector.<Round>;
		private var _roundMap:Dictionary = new Dictionary(false);
		
		private var _totalRoleList:Array = [];
		private var _tempRoleList:Array = [];
		
		private var _curRoundIndex:int = -1;
		private var _isHolding:Boolean;
		private var _ctrl:ControlExecuter;
		public function RoundManager(controlExecuter:ControlExecuter,motionPlayer:MotionPlayer)
		{
			_ctrl = controlExecuter;
			_motionPlayer = motionPlayer;
			_motionPlayer.addEventListener(MotionEvent.ACTION_COMPLETE, onActionComplete);
			_motionPlayer.addEventListener(MotionEvent.ROUND_END, onRoundEnd);
		}
		/**
		 * 添加【中回合】，一个【中回合】包括若干action,
		 */
		public function pushTinyRound(actions:Array, roundIndex:int, isSever:Boolean):void {
			var r:Round = getRoundByIndex(roundIndex);
			r.pushTiny(actions, isSever);
			
			_motionPlayer.updateFrameRate();
			playActions();
		}
		/**
		 * 添加【大回合】，一个【大回合】包括所有可能的六个小队的【中回合】
		 */
		private var lastRoundIndex:int;
		private var lastRoundEndStageInfo:Array;
		/**这个方法不该叫pushRound了，实际的作用是大回合同步，执行StageActon,告诉MotionPlayer.RoundEnd*/
		public function pushRound(shields:Array, buffs:Array, stages:Array, roundIndex:int, isOver:Boolean):void 
		{
			MotionLogger.output("[RoundManager].pushRound: [" + Number(getTimer() / 1000) + "s]" , I18n.lang("as_battle_1451031565_315")+roundIndex);
			if(isOver == true)
			{
				_motionPlayer.slowOver();
			}
			
			var r:Round;
			
			lastRoundIndex = roundIndex;
			lastRoundEndStageInfo = stages;
			
			BattleData.singleton.enervationCountDown -= 1;
			if(BattleData.singleton.enervationCountDown == 0)
			{
				var ninjaMap:Dictionary;
				var enervationActionInfo:EnervationActionInfo;
				
				enervationActionInfo = new EnervationActionInfo();
				ninjaMap = FightManagerCenter.ninjaMgr.getNinjaMap();
				
				for each(var battleNinja:Ninja in ninjaMap)
				{
					if(BattleData.singleton.getUIdata().isOurNinjaPos(battleNinja.data.pos) == false && battleNinja.cfg.cfgInfo.type == NinjaDef.TYPE_CONTRACT_PET)
					{
						enervationActionInfo.posList.push(battleNinja.data.pos);
						enervationActionInfo.type = EnervationActionInfo.TYPE_OUT;
					}
				}
				
				r = getRoundByIndex(roundIndex);
				r.pushTiny([enervationActionInfo], false);
			}
//			
//			if(lastRoundEndStageInfo.length != 0)
//			{
//				r = getRoundByIndex(lastRoundIndex);
//				r.pushTiny(lastRoundEndStageInfo, false);
//			}
			
			
			var stageActionNum:int;
			for each(var actionInfo:BaseActionInfo in lastRoundEndStageInfo)
			{
				if(actionInfo is StageActionInfo)
				{
					stageActionNum += 1;
				}
				
				if(stageActionNum > 1){throw new Error(I18n.lang("as_battle_1451031565_316"));}
			}
			
			_motionPlayer.roundEndStageAction(lastRoundEndStageInfo);
			_motionPlayer.roundEnd(shields, buffs, roundIndex);
		}
		
		private var isStopTiny:Boolean;
		public function stopTiny():void
		{
			isStopTiny = true;
		}
		
		public function continueTiny():void
		{
			isStopTiny = false;
			playActions();
		}
		
		/*public function getRoundStr():String {
			if (_rounds.length > 0) {
				var r:Round = _rounds[_rounds.length - 1];
				return "round.index:" + r.index + ", tinyID:" + r.curID;
			}
			return "round=null";
		}*/
		/**
		 * 添加【同步数据】。收到【中回合】后,可能会收到若干【同步数据】。
		 */
		public function pushMetaDataNew(fn:Function, args:Array = null, debugName:String = ""):void {
			MotionLogger.output("[RoundManager].pushMetaDataNew: debugName=" , debugName);
			if (args == null) 
				args = [];
			
			if (_rounds.length > 0) {
				var r:Round = _rounds[_rounds.length - 1];//观战的时候，有可能出现两个大回合都没播完！
				//var r:Round = _rounds[0];
				if (checkAllTinyFinish(Round.curID, r)) {
					MotionLogger.output(I18n.lang("as_battle_1451031565_318"),debugName);
					fn.apply(_ctrl, args);
				}else{
					r.pushMetaData(fn, args, debugName);
				}
			}else {
				MotionLogger.output(I18n.lang("as_battle_1451031565_319"),debugName);
				fn.apply(_ctrl, args);
			}
		}
		
		private function getRoundByIndex(i:int):Round 
		{
			var r:Round = _roundMap[i];
			if (r) return r;
			
			_roundMap[i] = r = new Round;
			r.index = i;
			_rounds.push(r);
			return r;
		}
		
		private function removeActionInfo(actionInfo:Object):void
		{
			MotionLogger.output("[RoundManager].removeActionInfo:===>start" , actionInfo);
			
			if (_rounds.length == 0) return ;//这里是有可能的 回合同步的的等退场Action不放入tinyRound 但执行完会派发playerComplete触发这里的逻辑
			
			var i:int;
			var l:int;
			var r:Round = _rounds[0];
			var tinyRounds:Vector.<TinyRound> = r.tinyRounds;
			l  = tinyRounds.length;
			for(i = 0; i < l; i++){
				var t:TinyRound = tinyRounds[i];
				var actions:Array = t.actions;
				var index:int = actions.indexOf(actionInfo);
				if (index != -1) {
					actions.splice(index, 1);
					MotionLogger.output(I18n.lang("as_battle_1451031565_321_0") , I18n.lang("as_battle_1451031565_321_1")+r.index,I18n.lang("as_battle_1451031565_321_2")+t.roundID,"action="+index);
					if (actions.length == 0) {//这时，中回合可以删除
						tinyRounds.splice(i, 1);
						MotionLogger.output(I18n.lang("as_battle_1451031565_323_0") , I18n.lang("as_battle_1451031565_323_1") + r.index, I18n.lang("as_battle_1451031565_323_2") + t.roundID);
							
						var enableMeatas:Array = [];
						for (var j:int = 0; j < r.metadatas.length; j++) 
						{
							var m:MetaData = r.metadatas[j];
							if (!m.isPostMeta && checkAllTinyFinish(m.roundID, r)) {
								MotionLogger.output(I18n.lang("as_battle_1451031565_324_0") , I18n.lang("as_battle_1451031565_324_1") + r.index, I18n.lang("as_battle_1451031565_324_2") + m.roundID, m.type);
								r.metadatas.splice(j, 1);
								j--;
								enableMeatas.push(m);
							}
						}
						for (j = 0; j < enableMeatas.length; j++) {
							m = enableMeatas[j];
							MotionLogger.output(I18n.lang("as_battle_1451031565_325_0") , I18n.lang("as_battle_1451031565_325_1") + r.index, I18n.lang("as_battle_1451031565_325_2") + m.roundID, m.type);
							dispatchMDE(m);//handRoundSync 必然是最后一个前期Meta
						}
						
						
					}
					break;
				}
			}
			removeRoleList(actionInfo.getMotionPos());
			MotionLogger.output("[RoundManager].removeActionInfo:===>end" , actionInfo);
			execPostMetaData();
		}
		public function markBigRoundSynced():void {
			MotionLogger.output("[RoundManager]>>>markBigRoundSynced: _rounds.length=" , _rounds.length);
			if (_rounds.length == 0) return ;
			var r:Round = _rounds[0];
			r.isSynced = true;
			execPostMetaData();
		}
		public function markBigRoundEnded():void {
			MotionLogger.output("[RoundManager]>>>markBigRoundEnded: _rounds.length=" , _rounds.length);
			if (_rounds.length == 0) return ;
			var r:Round = _rounds[0];
			r.isEnded = true;
			execPostMetaData();
		}
		public function execPostMetaData():void {
			MotionLogger.output("[RoundManager]>>>execPostMetaData: _rounds.length=" , _rounds.length);
			if (_rounds.length == 0) return ;
			var r:Round = _rounds[0];
			var i:int;
			var l:int;
			if (r.tinyRounds.length == 0 && r.isSynced && r.isEnded) {//这时，大回合可以删除
				_rounds.splice(0, 1);
				delete(_roundMap[r.index]);
				MotionLogger.output(I18n.lang("as_battle_1451031565_328_0") , I18n.lang("as_battle_1451031565_328_1")+r.index);
				l = r.metadatas.length;//
				for (i = 0; i < l; i++) {
					var m:MetaData = r.metadatas[i];
					MotionLogger.output(I18n.lang("as_battle_1451031565_329_0") ,I18n.lang("as_battle_1451031565_329_1")+r.index,I18n.lang("as_battle_1451031565_329_2")+m.roundID,m.type,I18n.lang("as_battle_1451031565_329_3")+m.isPostMeta);
					dispatchMDE(m);
				}
			}
			playActions();
		}
		/**用于检查，绑定到特定的roundID的同步元数据，是否可以执行*/
		private function checkAllTinyFinish(roundID:int, r:Round):Boolean {
			var i:int;
			var l:int;
			var tinyRounds:Vector.<TinyRound> = r.tinyRounds;
			l  = tinyRounds.length;
			for(i = 0; i < l; i++){
				var t:TinyRound = tinyRounds[i];
				if (t.roundID <= roundID && t.roundID>-2) {
					return false;
				}
			}
			return true;
		}
		private function getEnablePlayActions():Array
		{
			var enableList:Array = [];
			_tempRoleList = [];
			
			if (_rounds.length == 0) return [];
			var i:int;
			var l:int;
			var j:int;
			var jl:int;
			var r:Round = _rounds[0];
			var tinyRounds:Vector.<TinyRound> = r.tinyRounds;
			l  = tinyRounds.length;
			for (i = 0; i < l; i++) {
				var t:TinyRound = tinyRounds[i];
				var actions:Array = t.actions;
				jl  = actions.length;
				
				if(actions.length == 0){throw new Error(I18n.lang("as_battle_1451031565_330"));}
				
				for(j = 0; j < jl; j++){
					var action:BaseActionInfo = actions[j];
					if(checkRoleList(action.getMotionPos()) == false)//检查出没有跟执行中的忍者冲突
					{
						logger.output("[Action]", "getEnablePlayActions", action.getMotionPos(), _totalRoleList);
						if(action.isHoldAction())//独占技
						{
							if(_motionPlayer.hasPlayingPlayer() || enableList.length != 0)
							{
								return enableList;
							}
						}
						addRoleList(action.getMotionPos());//记录执行中的忍者
						
						enableList.push(action);
						
						if(action.isHoldAction())
						{
							_isHolding = true;
						}
					}
					
					addTempRoleList(action.getMotionPos());
					
					if (_isHolding) break;
				}
				if(_curRoundIndex != r.index)
				{
					_curRoundIndex = r.index;
					new RoundChangedNotice(r.index%100000 + 1).send();
				}
				
				if (_isHolding) break;
				
				if (r.metadatas.length > 0) return enableList;
			}
			
			return enableList;
		}
		
		private function checkRoleList(value:Array):Boolean
		{
			var pos:int;
			
			for each(pos in value)
			{
				if(_totalRoleList.indexOf(pos) != -1)
				{
					return true;
				}
			}
			
			for each(pos in value)
			{
				if(_tempRoleList.indexOf(pos) != -1)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function removeRoleList(value:Array):void
		{
			var posArr:Array;
			
			logger.output("roleListModfiy", "[reoveRole]", value);
			for each(var pos:int in value)
			{
				if(_totalRoleList.indexOf(pos) != -1)
				{
					_totalRoleList.splice(_totalRoleList.indexOf(pos), 1);
				}
			}
		}
		
		private function addRoleList(value:Array):void
		{
			logger.output("roleListModfiy", "[addRoleList]", value, "curRoleList", _totalRoleList);
			_totalRoleList = _totalRoleList.concat(value);
		}
		
		private function addTempRoleList(value:Array):void
		{
			_tempRoleList = _tempRoleList.concat(value);
		}
		
		private function onRoundEnd(e:MotionEvent):void 
		{
			logger.output("[RoundManager].onRoundEnd","[" + Number(getTimer() / 1000) + "s]");
			new DoRoundSysncAckCommand().call();
		}
		
		private function onActionComplete(e:MotionEvent):void 
		{
			
			if(e.actionInfo.isHoldAction() == true)
			{
				_isHolding = false;
			}
			
			removeActionInfo(e.actionInfo);
			playActions();
			UIData.singleton.firsetAction = false;
		}
		private function playActions():void {
			if(isStopTiny)
			{
				return ;
			}
			if(_isHolding)
			{
				return ;
			}
			var actions:Array = getEnablePlayActions();
			MotionLogger.output("[RoundManager].playActions:" , actions, "time:" + getTimer());
			_motionPlayer.playActions(actions);
		}
		/**抛到controlexcuter，同步元数据*/
		private function dispatchMDE(m:MetaData):void 
		{
			if (m.fn != null) {
				m.fn.apply(_ctrl, m.args);
				return;
			}
			//var e:MetaDataEvent = new MetaDataEvent;
			//e.args = m.args;
			//e.metaType = m.type;
			//dispatchEvent(e);
		}
		public function dispose():void 
		{
			if(_motionPlayer){
				_motionPlayer.removeEventListener(MotionEvent.ACTION_COMPLETE, onActionComplete);
				_motionPlayer.removeEventListener(MotionEvent.ROUND_END, onRoundEnd);
				_motionPlayer = null;
			}
			Round.curID = 0;
		}
		/**
		 * RoundSyncCommand 执行时，调用这个标记
		 */
		public function markMetaToPost():void 
		{
			if (_rounds.length > 0) {
				_rounds[_rounds.length - 1].isPostMeta = true;
			}
		}
		
		public function isPostMeta():Boolean 
		{
			if (_rounds.length > 0) {
				return _rounds[_rounds.length - 1].isPostMeta;
			}
			return false;
		}
		
																
		public function autoSetNull():void
		{

			_motionPlayer = null;
			_roundMap = null;
			_totalRoleList = null;
			_tempRoleList = null;
			_ctrl = null;
			lastRoundEndStageInfo = null;
		}
	}

}

import com.tencent.morefun.naruto.plugin.battle.data.MetaData;
import com.tencent.morefun.naruto.plugin.motion.MotionLogger;
import com.tencent.morefun.naruto.i18n.I18n;
/**
 * 以roundSync是否已经下发，区别 前期同步 和 后期同步
 */
class Round {
	
	public var tinyRounds:Vector.<TinyRound> = new Vector.<TinyRound>;
	/**第几个大回合*/
	public var index:int;
	public var metadatas:Vector.<MetaData> = new Vector.<MetaData>;
	/**大回合当前的中回合索引*/
	static public var curID:int = 0;
	
	/**
	 * 是否需要加到后期同步
	 */
	public var isPostMeta:Boolean;
	public var isSynced:Boolean;
	public var isEnded:Boolean;
	
	
	public function Round() {
		
	}
	/**
	 * roundId == -2时,是前台添加的中合回。roundId >-1时，是后台返回的中合回
	 * @param	actions
	 * @param	roundId
	 */
	public function pushTiny(actions:Array, isSever:Boolean=true):void 
	{
		var roundId:int = -2;
		if (isSever) {
			curID++;
			roundId = curID;
		}
		
		MotionLogger.output("[Round].pushTiny: =" , I18n.lang("as_battle_1451031565_334_0") + index , I18n.lang("as_battle_1451031565_334_1") + roundId);
		
		var t:TinyRound = new TinyRound;
		t.actions = actions;
		t.roundID = roundId;
		tinyRounds.push(t);
	}
	
	public function pushMetaData(fn:Function, args:Array,debugName:String):void 
	{
		MotionLogger.output("[Round].pushMetaData: " ,debugName,I18n.lang("as_battle_1451031565_335_0")+ index,I18n.lang("as_battle_1451031565_335_1")+curID,I18n.lang("as_battle_1451031565_335_2")+isPostMeta);
		var m:MetaData = new MetaData("", args, curID);
		m.fn = fn;
		m.type = debugName;
		m.isPostMeta = isPostMeta;
		metadatas.push(m);
	}

	public function autoSetNull():void
	{

	}
}


class TinyRound {
	/**中回合要执行的动作*/
	public var actions:Array;
	/**第几个中回合*/
	public var roundID:int;
	public function TinyRound() {
		
	}

	public function autoSetNull():void
	{

		actions = null;
	}
}

