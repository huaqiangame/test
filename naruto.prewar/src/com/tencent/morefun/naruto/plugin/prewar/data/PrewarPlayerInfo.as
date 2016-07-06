package com.tencent.morefun.naruto.plugin.prewar.data
{
	import com.tencent.morefun.naruto.plugin.prewar.event.PrewarPlayerInfoEvent;
	
	import flash.events.EventDispatcher;
	
	import ninja.model.data.FormationInfo;
	import ninja.model.data.NinjaHotkeyInfo;

	[Event(name = "indexUpdate", type = "com.tencent.morefun.naruto.plugin.prewar.event.PrewarPlayerInfoEvent")]
	[Event(name = "statusUpdate", type = "com.tencent.morefun.naruto.plugin.prewar.event.PrewarPlayerInfoEvent")]
	[Event(name = "formationNinjaUpdate", type = "com.tencent.morefun.naruto.plugin.prewar.event.PrewarPlayerInfoEvent")]
	public class PrewarPlayerInfo extends EventDispatcher
	{
		private var _teamPos:int;
		private var _type:int;
		private var _status:int;
		private var _isSelf:Boolean;
		private var _mp:int;
		private var _uin:uint;
		private var _formationInfo:FormationInfo;
		private var _hotkeyInfo:NinjaHotkeyInfo;

		public function get formationInfo():FormationInfo
		{
			return _formationInfo;
		}

		public function set formationInfo(value:FormationInfo):void
		{
			_formationInfo = value;
			
			this.dispatchEvent(new PrewarPlayerInfoEvent(PrewarPlayerInfoEvent.FORMATION_NINJA_UPDATE));
		}

		public function get mp():int
		{
			return _mp;
		}

		public function set mp(value:int):void
		{
			_mp = value;
		}

		public function get hotkeyInfo():NinjaHotkeyInfo
		{
			return _hotkeyInfo;
		}

		public function set hotkeyInfo(value:NinjaHotkeyInfo):void
		{
			_hotkeyInfo = value;
		}

		public function get isSelf():Boolean
		{
			return _isSelf;
		}

		public function set isSelf(value:Boolean):void
		{
			_isSelf = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get uin():uint
		{
			return _uin;
		}

		public function set uin(value:uint):void
		{
			_uin = value;
		}

		public function get teamPos():int
		{
			return _teamPos;
		}

		public function set teamPos(value:int):void
		{
			_teamPos = value;
			this.dispatchEvent(new PrewarPlayerInfoEvent(PrewarPlayerInfoEvent.INDEX_UPDATE));
		}

		public function get status():int
		{
			return _status;
		}

		public function set status(value:int):void
		{
			_status = value;
			this.dispatchEvent(new PrewarPlayerInfoEvent(PrewarPlayerInfoEvent.STATUS_UPDATE));
		}

		public function get isOur():Boolean
		{
			return _teamPos % 2 == 0;
		}
	}
}