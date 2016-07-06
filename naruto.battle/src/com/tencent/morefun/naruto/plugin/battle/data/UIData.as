package com.tencent.morefun.naruto.plugin.battle.data
{

	import com.tencent.morefun.naruto.plugin.battle.event.UIDataEvent;
	import com.tencent.morefun.naruto.plugin.motion.manager.ninja.data.NinjaInfo;
	
	import flash.events.EventDispatcher;
	
	import base.ApplicationData;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class UIData extends EventDispatcher
	{
		private static var ms_instance:UIData;
		
		public var ours:Array = [];
		public var theirs:Array = [];
		
		public var monster:UIPlayerData;
		public var monsterNinjaId:int;
		
		public var customInfo:CustomInfo;
		
		public var selfTeamId:int;
		public var lockHp:Boolean;
		
		public var selfNinjaId:int;
		
		public var startRoundIndex:int;
		
		private var _self:UIPlayerData;
		
		/**
		 *第一个登场包 
		 */		
		public var firsetAction:Boolean;
		
		/**
		 * 自己是否在左边
		 */
		public var selfInLeft:Boolean;
		/**
		 *召唤兽状态 
		 */
		public var isContractPet:Boolean;
		
		public function UIData()
		{
			
		}
		
		public static function get singleton():UIData
		{
			if(!ms_instance)
			{
				ms_instance = new UIData();
			}
			
			return ms_instance;
		}
		
		public function set self(value:UIPlayerData):void
		{
			var evt:UIDataEvent;
			var old:UIPlayerData;
			
			old = _self;
			_self = value;
			
			evt = new UIDataEvent(UIDataEvent.UPDATE_SELF);
			evt.oldSelf = old;
			evt.newSelf = value;
			this.dispatchEvent(evt);
		}
		
		public function get self():UIPlayerData
		{
			return _self;
		}
		
		public function isOurNinjaPos(pos:int):Boolean
		{
			return selfInLeft?pos<100:pos>=100;
		}
		
		public function isOurPlayerPos(pos:int):Boolean
		{
			return selfInLeft?pos%2==0:pos%2==1;
		}
		
		public function setLockHp(value:Boolean):void
		{
			lockHp = value;
		}
		
		public function getLockHp():Boolean
		{
			return lockHp;
		}
		
		public function ninjaPosToPlayerPos(ninjaPos:int):int
		{
			if (ninjaPos < 100)
			{
				return Math.floor(ninjaPos / 9) * 2;
			}
			else
			{
				return Math.floor((ninjaPos - 100) / 9) * 2 + 1;
			}
		}
		
		public function get ourFirst():UIPlayerData
		{
			return ours[0];
		}
		
		public function get theirFirst():UIPlayerData
		{
			return theirs[0];
		}
		
		
		public function getPlayer(playerPos:int):UIPlayerData
		{
			var isOurs:Boolean = isOurPlayerPos(playerPos);
			var arr:Array = isOurs?ours:theirs;
			for each(var pd:UIPlayerData in arr)
			{
				if(pd.teamId == playerPos)
				{
					return pd;
				}
			}
			return null;
		}
		
		public function findPlayerByKey(uin:uint, roleId:uint, serId:uint, teamId:int):UIPlayerData
		{
			var pd:UIPlayerData;
			
			for each(pd in ours)
			{
				if(pd.uin == uin && pd.roleId == roleId && pd.serId == serId && pd.teamId == teamId)
				{
					return pd;
				}
			}
			
			for each(pd in theirs)
			{
				if(pd.uin == uin && pd.roleId == roleId && pd.serId == serId && pd.teamId == teamId)
				{
					return pd;
				}
			}
			
			return null;
		}
		
		public function getPlayerByNinjaPos(ninjaPos:int):UIPlayerData
		{
			var isOurs:Boolean = isOurNinjaPos(ninjaPos);
			var playerPos:int = ninjaPosToPlayerPos(ninjaPos);
			var arr:Array = isOurs?ours:theirs;
			
			for each(var pd:UIPlayerData in arr)
			{
				if(pd.teamId == playerPos)
				{
					return pd;
				}
			}
			return null;
		}
		
		public function getNinjaTeamId(ninjaPos:int):int
		{
			var nd:UINinjaData;
			var pd:UIPlayerData;
			
			for each(pd in ours)
			{
				nd = pd.getNinja(ninjaPos);
				if(nd)
				{
					return pd.teamId;
				}
			}
			
			for each(pd in theirs)
			{
				nd = pd.getNinja(ninjaPos);
				if(nd)
				{
					return pd.teamId;
				}
			}
			
			return -1;
		}
		
		public function getNinja(ninjaPos:int):UINinjaData
		{
			var nd:UINinjaData;
			var pd:UIPlayerData;
			
			for each(pd in ours)
			{
				nd = pd.getNinja(ninjaPos);
				if(nd)
				{
					return nd;
				}
			}
			
			for each(pd in theirs)
			{
				nd = pd.getNinja(ninjaPos);
				if(nd)
				{
					return nd;
				}
			}
			return null;
		}
		
		public function isControlNinja(pos:int):UINinjaData
		{
			var uiNinja:UINinjaData;
			
			for each(var pd:UIPlayerData in ours)
			{
				uiNinja = pd.getNinja(pos);
				if(uiNinja){break;}
			}
			
			if(!uiNinja)
			{
				return null
			}
			
			if(uiNinja.controlTeam != -1)
			{
				if(uiNinja.controlTeam == _self.teamId)
				{
					return uiNinja;
				}
			}
			else if(uiNinja.teamId == _self.teamId)
			{
				return uiNinja;
			}
			
			return null;
		}
		
		/**
		 * 添加一个玩家数据
		 * @param player 玩家数据
		 * @param isOurs 是否是自己这边
		 * @param isSelf 是否是自己
		 */
		public function addPlayer(playerData:UIPlayerData,isOurs:Boolean):void
		{
			if(isOurs)
			{
				if(findPlayerByKey(playerData.uin, playerData.roleId, playerData.serId, playerData.teamId) != null)
				{
					throw new Error(I18n.lang("as_battle_1451031565_268"));
				}
				
				ours.push(playerData);
			}
			else
			{
				theirs.push(playerData);
				
				monster.stageNinjaList = monster.stageNinjaList.concat(playerData.stageNinjaList);
			}
			
			if(monster.teamId == playerData.teamId)
			{
				monster.name = playerData.name;
//				monster.battlePower = playerData.battlePower;
				monster.level = playerData.level;
				monster.mp = playerData.mp;
				monster.head = playerData.head;
			}
			
			monster.battlePower = 0;
			for each(var playerData:UIPlayerData in theirs)
			{
				monster.battlePower += playerData.battlePower;
			}
			
			updateWatchSelf();
			
			playerData.addEventListener(UIDataEvent.ADD_NINJA, onAddNinja);
			playerData.addEventListener(UIDataEvent.REMOVE_NINJA, onRemoveNinja);
			this.dispatchEvent(new UIDataEvent(UIDataEvent.ADD_PLAYER));
		}
		
		public function removePlayer(player:UIPlayerData):void
		{
			var isOurs:Boolean;
			
			isOurs = isOurPlayerPos(player.teamId);
			if(isOurs)
			{
				ours.splice(ours.indexOf(player), 1);
			}
			else
			{
				theirs.splice(theirs.indexOf(player), 1);
				for each(var ninjaInfoData:UINinjaData in player.ninjas)
				{
					for each(var ninjaInfo:NinjaInfo in monster.stageNinjaList)
					{
						if(ninjaInfoData.pos == ninjaInfo.pos)
						{
							monster.stageNinjaList.splice(monster.stageNinjaList.indexOf(ninjaInfo), 1);
							break;
						}
					}
				}
			}
			
			updateWatchSelf();
			
			player.removeEventListener(UIDataEvent.ADD_NINJA, onAddNinja);
			player.removeEventListener(UIDataEvent.REMOVE_NINJA, onRemoveNinja);
			this.dispatchEvent(new UIDataEvent(UIDataEvent.REMOVE_PLAYER));
		}
		
		public function removeAllOurPlayer():void
		{
			var ourClone:Array;
			
			ourClone = ours.concat();
			for each(var battlePlyer:UIPlayerData in ourClone)
			{
				removePlayer(battlePlyer);
			}
		}
		
		public function updateWatchSelf():void
		{
			_self = null;
			
			if(BattleData.singleton.skillStatus == BattleData.SKILL_STATUS_WATCH_ON)
			{
				self = ours[0];
			}
			else
			{
				for each(var battlePlayer:UIPlayerData in ours)
				{
					if(battlePlayer.uin == ApplicationData.singleton.selfuin && battlePlayer.serId == ApplicationData.singleton.selfSrv && battlePlayer.roleId == ApplicationData.singleton.selfRole)
					{
						self = battlePlayer;
					}
					
					if(BattleData.singleton.isReplay == true && battlePlayer.uin == 0)
					{
						self = battlePlayer;
					}
				}
			}
		}
		
		public function swapPlayer(teamIdA:int, teamIdB:int):void
		{
			var playerA:UIPlayerData;
			var playerB:UIPlayerData;
			
			playerA = getPlayer(teamIdA);
			playerB = getPlayer(teamIdB);
			
			if(playerA)
			{
				playerA.teamId = teamIdB;
			}
			
			if(playerB)
			{
				playerB.teamId = teamIdA;
			}
			
			this.dispatchEvent(new UIDataEvent(UIDataEvent.PLAYER_UPDATE));
		}
		
		public function findPlayerName(playerA:UIPlayerData):void
		{
			var playerB:UIPlayerData;
			
			for each(playerB in ours)
			{
				if(playerB.name == playerA.name)
				{
					if(playerB != playerA)
					{
						throw new Error(I18n.lang("as_battle_1451031565_269"));
					}
				}
			}
			
			for each(playerB in theirs)
			{
				if(playerB.name == playerA.name)
				{
					if(playerB != playerA)
					{
						throw new Error(I18n.lang("as_battle_1451031565_270"));
					}
				}
			}
		}
		
		public function updateAllPlayerHp():void
		{
			var player:UIPlayerData;
			
			for each(player in ours)
			{
				updatePlayerHpByData(player);
			}
			
			for each(player in theirs)
			{
				updatePlayerHpByData(player);
			}
			
			updatePlayerHpByData(monster);
		}
		
		public function updatePlayerHp(playerPos:int):void
		{
			var isOur:Boolean;
			var player:UIPlayerData;
			
			player = getPlayer(playerPos);
			player.calculateHP();
			player.dispathBaseInfoUpdate();
			
			isOur = isOurPlayerPos(playerPos);
			
			if(lockHp == false)
			{
				player.dispathBaseInfoUpdate();
				
				if(isOur == false)
				{
					monster.calculateHP();
					monster.dispathBaseInfoUpdate();
				}
			}
		}
		
		public function modifyNinjaHp(teamId:int,ninjaPos:int,hp:int,isIncrement:Boolean=false):void
		{
			var isOurs:Boolean = isOurNinjaPos(ninjaPos);
			
			var pd:UIPlayerData = getPlayer(teamId);
			if(pd)
			{
				var nd:UINinjaData = pd.getNinja(ninjaPos);
				if(nd)
				{
					if(isIncrement)
					{
						pd.hp += hp;
						nd.hp += hp;
					}
					else
					{
						pd.hp = hp;
						nd.hp = hp;
					}
					
					if(lockHp == false)
					{
						pd.dispathBaseInfoUpdate();
					}
					
					if(isOurs == false)
					{
						monster.calculateHP();
						monster.dispathBaseInfoUpdate();
					}
				}
			}
		}
		
		public function modifyNinjaMp(teamId:int,mp:int,isIncrement:Boolean=false):void
		{
			var isOurs:Boolean = isOurPlayerPos(teamId);
			var pd:UIPlayerData = getPlayer(teamId);
			
			if(pd)
			{
				if(isIncrement)
				{
					pd.mp = Math.min(100, pd.mp + mp);
				}
				else
				{
					pd.mp = mp;
				}
				
				pd.dispathBaseInfoUpdate();
				
				if(isOurs == false)
				{
					if(monster.teamId == pd.teamId)
					{
						monster.mp = pd.mp;
						monster.dispathBaseInfoUpdate();
					}
				}
			}
		}
		
		public function updatePlayerInfo(playerPos:int, head:int, name:String, battlePower:int, hp:int, maxHp:int, mp:int):void
		{
			var isOurs:Boolean = isOurPlayerPos(playerPos);
			var arr:Array = isOurs?ours:theirs;
			var pd:UIPlayerData = getPlayer(playerPos);
			
			if(pd)
			{
				pd.mp = mp;
				pd.hp = hp;
				pd.hpMax = maxHp;
				
				pd.name = (name != null)?name:pd.name;
				pd.head = (head == -1)?pd.head:head;
				pd.battlePower = (battlePower == -1)?pd.battlePower:battlePower;
				pd.teamId = playerPos;
			}
			
			if(monster.teamId == pd.teamId)
			{
				monster.head = (head == -1)?pd.head:head;
				monster.name = (name != null)?name:pd.name;
				monster.battlePower = (battlePower == -1)?pd.battlePower:battlePower;
				monster.dispathBaseInfoUpdate();
			}
		}
		
		public function updateMonsterBattlePower():void
		{
			if(monster == null){return ;}
			monster.battlePower = 0;
			for each(var playerData:UIPlayerData in theirs)
			{
				monster.battlePower += playerData.battlePower;
			}
			monster.dispathUpdateAll();
		}
		
		
		public function modifyPlayerMp(playerPos:int,mp:int,isIncrement:Boolean=false):void
		{
			var isOurs:Boolean = isOurPlayerPos(playerPos);
			var arr:Array = isOurs?ours:theirs;
			
			var pd:UIPlayerData = getPlayer(playerPos);
			if(pd)
			{
				if(isIncrement)
				{
					pd.mp = Math.min(100, pd.mp + mp);
				}else
				{
					pd.mp = mp;
				}
				
				pd.dispathBaseInfoUpdate();
				
				if(isOurs == false)
				{
					if(monster.teamId == pd.teamId)
					{
						monster.mp = pd.mp;
						monster.dispathBaseInfoUpdate();
					}
				}
			}
		}
		
		public static function getTeamIdByPos(pos:int):uint
		{
			if (pos < 100)
			{
				return Math.floor(pos / 9) * 2;
			}
			else
			{
				return Math.floor((pos - 100) / 9) * 2 + 1;
			}
		}
		
		public function resetNinja():void
		{
			var battlePlayer:UIPlayerData;
			for each(battlePlayer in ours)
			{
				battlePlayer.removeAllNinja();
			}
			
			for each(battlePlayer in theirs)
			{
				battlePlayer.removeAllNinja();
			}
			
			monster.removeAllNinja();
		}
		
		public function rest():void
		{
			var player:UIPlayerData;
			for each(player in ours)
			{
				player.removeEventListener(UIDataEvent.ADD_NINJA, onAddNinja);
				player.removeEventListener(UIDataEvent.REMOVE_NINJA, onRemoveNinja);
				player.destroy();
			}
			
			ours = [];
			
			for each(player in theirs)
			{
				player.removeEventListener(UIDataEvent.ADD_NINJA, onAddNinja);
				player.removeEventListener(UIDataEvent.REMOVE_NINJA, onRemoveNinja);
				player.destroy();
			}
			
			theirs = [];
			
			_self = null;
			monster = null;
		}
		
		private function updatePlayerHpByData(value:UIPlayerData):void
		{
			value.calculateHP();
			
			if(lockHp == false)
			{
				value.dispathBaseInfoUpdate();
			}
		}
		
		private function onAddNinja(evt:UIDataEvent):void
		{
			var isOurs:Boolean;
			var ninja:UINinjaData;
			var player:UIPlayerData;
			
			player = evt.currentTarget as UIPlayerData;
			isOurs = isOurPlayerPos(player.teamId);
			
			if(isOurs == false)
			{
				for each(ninja in player.ninjas)
				{
					if(monster.getNinja(ninja.pos) != null)
					{
						monster.removeNinja(monster.getNinja(ninja.pos));
					}
					
					monster.addNinja(ninja);
				}
				monster.calculateHP();
			}
		}
		
		private function onRemoveNinja(evt:UIDataEvent):void
		{
			var isOurs:Boolean;
			var ninja:UINinjaData;
			var player:UIPlayerData;
			
			player = evt.currentTarget as UIPlayerData;
			isOurs = isOurPlayerPos(player.teamId);
			
			if(isOurs == false)
			{
				monster.removeNinja(monster.getNinja(evt.ninjaPos));
				monster.calculateHP();
			}
		}
		
		public function destroy():void
		{
			var totalPlayers:Array;
			
			totalPlayers = ours.concat(theirs);
			for each(var player:UIPlayerData in totalPlayers)
			{
				player.removeEventListener(UIDataEvent.ADD_NINJA, onAddNinja);
				player.removeEventListener(UIDataEvent.REMOVE_NINJA, onRemoveNinja);
			}
			
			ours = [];
			theirs = [];
			
			_self = null;
			selfNinjaId = 0;
			
			monster = null;
			monsterNinjaId = 0;
			
			customInfo = null;
			
			selfTeamId = 0;
			lockHp = false;
		}
																
		public function autoSetNull():void
		{

			ms_instance = null;
			ours = null;
			theirs = null;
			monster = null;
			customInfo = null;
			_self = null;
		}
	}
}