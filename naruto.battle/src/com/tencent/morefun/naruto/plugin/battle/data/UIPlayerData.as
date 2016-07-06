package com.tencent.morefun.naruto.plugin.battle.data
{

	import com.tencent.morefun.naruto.plugin.battle.event.UIDataEvent;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.NinjaConfig;
	import majorRole.def.MajorNinjaDef;
	
	import flash.events.EventDispatcher;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class UIPlayerData extends EventDispatcher
	{
		static private const majorNinjaList:Array = [10000101, 10000201, 10000301, 10000401, 10000501];
		public var teamId:int  = -1;
		public var battlePower:int;
		public var type:int;
		public var level:int;
		public var hp:int;
		public var hpMax:int;
		public var mp:int;
		public var mpMax:int = 100;
		public var ninjas:Array = [];
		public var contractPetId:uint;
		public var isOnline:Boolean = true;
		public var isLeft:Boolean;
		public var stageNinjaList:Array = [];
		
		private var _uin:uint;
		private var _roleId:uint;
		private var _serId:uint;
		
		public var head:int = 0;
		public var name:String = I18n.lang("as_battle_1451031565_271");
		private var mainNinjaId:int = -1;
		
		public function UIPlayerData()
		{
			
		}
		
		public function get serId():uint
		{
			return _serId;
		}

		public function set serId(value:uint):void
		{
			_serId = value;
		}

		public function get roleId():uint
		{
			return _roleId;
		}

		public function set roleId(value:uint):void
		{
			_roleId = value;
		}

		public function get uin():uint
		{
			return _uin;
		}

		public function set uin(value:uint):void
		{
			_uin = value;
		}

		public function getNinja(ninjaPos:int):UINinjaData
		{
			for each(var nd:UINinjaData in ninjas)
			{
				if(nd.pos == ninjaPos)
				{
					return nd;
				}
			}
			return null;
		}
		
		public function setOnline(value:Boolean):void
		{
			isOnline = value;
			
			dispathOnlineUpdate();
		}
		
		public function setMainNinjaId(value:int):void
		{
			mainNinjaId = value;
		}
		
		public function getMianNinjaId():int
		{
			if(mainNinjaId != -1)
			{
				return mainNinjaId;
			}
			
			return -1; 
		}
		
		public function getContractPetId():int
		{
			for each(var nd:UINinjaData in ninjas)
			{
				if(NinjaConfig.getNinjaInfoById(nd.id).cfgInfo.type == 2)
				{
					return nd.id;
				}
			}
			
			return 0;
		}
		
		public function getHeadId():int
		{
			var headId:int;
			
			headId = getContractPetId();
			if(headId != 0)
			{
				return headId;
			}
			
			headId = head;
			if(headId != 0)
			{
				return headId;
			}
			
			headId = getMianNinjaId();
			if(headId != -1)
			{
				return headId;
			}
			
			for (var i:int = 0; i < ninjas.length; i++) 
			{
				if ( majorNinjaList.indexOf( ninjas[i].id) > -1) {
					headId = ninjas[i].id;
					return headId;
				}
			}
			if(ninjas[0])
			{
				headId = (ninjas[0] as UINinjaData).id;
			}
			
			return headId;
		}
		
		/**
		 * 添加忍者数据
		 * @param ninja 忍者数据
		 */
		public function addNinja(ninja:UINinjaData):void
		{
			ninjas.push(ninja);
			dispathAddNinja(ninja.pos);
			dispathBaseInfoUpdate();
		}
		
		/**
		 * 移除忍者数据
		 * @param ninja 忍者数据
		 * 
		 */		
		public function removeNinja(ninja:UINinjaData):void
		{
			if(ninja == null)
			{
				return ;
			}
			
			ninjas.splice(ninjas.indexOf(ninja), 1);
			dispathRemoveNinja(ninja.pos);
			dispathBaseInfoUpdate();
		}
		
		public function removeAllNinja():void
		{
			var cloneNinjas:Array;
			
			cloneNinjas = ninjas.concat();
			for each(var ninja:UINinjaData in cloneNinjas)
			{
				removeNinja(ninja);
			}
		}
		
		/**
		 * 根据当前忍者计算总hp,hpMax 
		 */
		public function calculateHP():void
		{
			hp = hpMax = 0;
			for each(var ninja:UINinjaData in ninjas)
			{
				if(ninja.hpInfoVisible == true)
				{
					hp += ninja.hp;
					hpMax += ninja.hpMax;
				}
			}
		}
		
		public function destroy():void
		{
			for each(var ninja:UINinjaData in ninjas)
			{
				ninja.destroy();
			}
			ninjas = null;
		}
		
		public function dispathAddNinja(pos:int):void
		{
			var event:UIDataEvent;
			
			event = new UIDataEvent(UIDataEvent.ADD_NINJA)
			event.ninjaPos = pos;
			this.dispatchEvent(event);
		}
		
		public function dispathRemoveNinja(pos:int):void
		{
			var event:UIDataEvent;
			
			event = new UIDataEvent(UIDataEvent.REMOVE_NINJA)
			event.ninjaPos = pos;
			this.dispatchEvent(event);
		}
		
		public function dispathBaseInfoUpdate():void
		{
			this.dispatchEvent(new UIDataEvent(UIDataEvent.BASE_INFO_UPDATE));
		}
		
		public function dispathMainNinjaUpdate():void
		{
			this.dispatchEvent(new UIDataEvent(UIDataEvent.BASE_INFO_UPDATE));
		}
		
		public function dispathOnlineUpdate():void
		{
			this.dispatchEvent(new UIDataEvent(UIDataEvent.ONLINE_INFO_UPDATE));
		}
		
		public function dispathUpdateAll():void
		{
			this.dispatchEvent(new UIDataEvent(UIDataEvent.UPDATE_ALL));
		}
																
		public function autoSetNull():void
		{

			ninjas = null;
			stageNinjaList = null;
			name = null;
		}
	}
}