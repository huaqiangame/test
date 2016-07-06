package com.tencent.morefun.naruto.plugin.battle.data 
{
	import base.ApplicationData;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Devin Lee
	 */
	public class UserInfoProxy  extends EventDispatcher
	{
		private var _teamId:String;
		private var _level:uint;
		private var _isReplayMode:Boolean;
		public function UserInfoProxy() 
		{
			
		}
		
		public function set isReplayMode(value:Boolean):void 
		{
			_isReplayMode = value;
		}
		
		public function get uin():uint
		{
			if (_isReplayMode) {
				return ApplicationData.singleton.selfuin;
			}
			return ApplicationData.singleton.selfInfo.uin;
		}
		
		public function get svrId():uint
		{
			if (_isReplayMode) {
				return ApplicationData.singleton.selfSrv;
			}
			return ApplicationData.singleton.selfInfo.svrId;
		}
		
		public function get role():uint
		{
			if (_isReplayMode) {
				return ApplicationData.singleton.selfRole;
			}
			return ApplicationData.singleton.selfInfo.role;
		}
		
		public function get ninja():uint
		{
			if (_isReplayMode) {
				return 0;
			}
			
			return ApplicationData.singleton.selfInfo.baseNinja;
		}
		
		public function get level():uint 
		{
			if (_isReplayMode) {
				return 1;
			}
			return ApplicationData.singleton.selfInfo.level;
		}
		
		public function get teamId():String 
		{
			if (_isReplayMode) {
				return "";
			}
			return ApplicationData.singleton.selfInfo.teamId;
		}
		
		public function get isCaptain():Boolean 
		{
			if (_isReplayMode) {
				return false;
			}
			return ApplicationData.singleton.selfInfo.isCaptain;
		}
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			if(!_isReplayMode) {
				ApplicationData.singleton.selfInfo.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			if(!_isReplayMode) {
				ApplicationData.singleton.selfInfo.removeEventListener(type, listener, useCapture);
			}
		}
	}

}