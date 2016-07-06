package com.tencent.morefun.naruto.plugin.battle.data
{
	import com.tencent.morefun.framework.apf.core.facade.Facade;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import def.ModelDef;
	
	import user.model.UserModel;


	public class BattleData extends EventDispatcher
	{
		public static const SKILL_STATUS_NONE:int = 0;
		public static const SKILL_STATUS_WATCH_ON:int = 1;
		public static const SKILL_STATUS_WATCH_OFF:int = 2;
		
		public static const SKILL_STATUS_GIVE_UP:int = 3;
		public static const SKILL_STATUS_AUTO_FIGHT:int = 4;
		
		public static const RES_STATE_NONE:int = 0;
		public static const RES_STATE_INIT_RES:int = 1;
		public static const RES_STATE_INIT_PREWAR_RES:int = 2;
		public static const RES_STATE_COMPLETE:int = 3;
		
		public static const FIGHT_STATE_NONE:int = 0;
		public static const FIGHT_STATE_START_BATTLE:int = 1;
		public static const FIGHT_STATE_WAIT_FIGHT_TIPS:int = 2;
		public static const FIGHT_STATE_SHOW_FIGHT_TIPS:int = 3;
		public static const FIGHT_STATE_PREWAR_OPTION:int = 4;
		public static const FIGHT_STATE_FIGHTING:int = 5;
		
		public static const GUID_SKILL_NONE:int = 0
		public static const GUID_SKILL_REQUEST:int = 1;
		public static const GUID_CHOOSE_TARGET_REQUEST:int = 2;
		public static const FRIST_BATTLE_GUID_SKILL:int = 3;
		
		public static const SOCKET_CLOSE_PHARSE_RES_LOADING:int = 1;
		public static const SOCKET_CLOSE_PHARSE_ROUND_END:int = 2;
		public static const SOCKET_CLOSE_PHARSE_ROUND_SPEED:int = 3;
		
		private static var ms_instance:BattleData;
		
		public var socketClosePharse:int = SOCKET_CLOSE_PHARSE_RES_LOADING;
		
		public var resState:int;
		public var skillStatus:int;
		public var needShowFightTips:Boolean;
		/**
		 * 气绝回合数
		 */
		public var enervationCountDown:int = -1;
		private var _fightType:int;
		public var subFightType:int;
		public var isTimeOut:Boolean;
		
		public var timeout:int;
		
		public var guidState:int;
		
		private var _isReplay:Boolean;
		
		private var _fightState:int;
		private var _serverWatchFlag:int;
		private var _userInfoProxy:UserInfoProxy;
		
		public var isGVGFightOverState:int = 0;
		public var curCustomBattleId:int = 0;
		public var curSectionId:int = 0;
		public function BattleData()
		{
			_userInfoProxy = new UserInfoProxy;
		}
		
		public function get serverWatchFlag():int
		{
			return _serverWatchFlag;
		}

		public function set serverWatchFlag(value:int):void
		{
			_serverWatchFlag = value;
		}

		public function get fightState():int
		{
			return _fightState;
		}

		public function set fightState(value:int):void
		{
			_fightState = value;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public static function get singleton():BattleData
		{
			if(ms_instance == null)
			{
				ms_instance = new BattleData();
			}
			
			return ms_instance;
		}
		
		public function getUIdata():UIData
		{
			return UIData.singleton;
		}
																
		public function autoSetNull():void
		{

			ms_instance = null;
		}
		public function get userInfoProxy():UserInfoProxy {
		
			return _userInfoProxy;
		}
			
		public function get userModel():UserModel
		{
			return Facade.getInstance().model.retrieveModel(ModelDef.USER) as UserModel;
		}
		
		public function get isReplay():Boolean 
		{
			return _isReplay;
		}
		
		public function set isReplay(value:Boolean):void 
		{
			_isReplay = value;
			userInfoProxy.isReplayMode = value;
		}
		
		public function get fightType():int 
		{
			return _fightType;
		}
		
		public function set fightType(value:int):void 
		{
			_fightType = value;
		}
	}
}