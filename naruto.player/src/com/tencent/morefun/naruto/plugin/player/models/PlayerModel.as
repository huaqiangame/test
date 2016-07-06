package com.tencent.morefun.naruto.plugin.player.models
{
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.model.BaseModel;
	import com.tencent.morefun.naruto.plugin.player.datas.PlayerGroupData;
	import com.tencent.morefun.naruto.plugin.player.managers.PlayerViewManager;
	import com.tencent.morefun.naruto.plugin.player.players.BaseWalkablePlayer;
	import com.tencent.morefun.naruto.plugin.player.views.PlayerView;
	import com.tencent.morefun.naruto.plugin.player.views.SelfPlayerView;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import base.ApplicationData;
	
	import cfgData.dataStruct.NinjaInfoCFG;
	
	import player.datas.PlayerData;
	
	import pvpBattlefield.model.def.PVPFieldModelDef;
	
	import rank.model.data.RankTitleCfgInfo;
	
	import serverProto.inc.ProtoDiamondInfo;
	
	import user.data.NinjaInfoConfig;
	
	[Event(name="added", type="flash.events.Event")]
    import com.tencent.morefun.naruto.i18n.I18n;
	public class PlayerModel extends BaseModel
	{
		public static const NAME:String = "player.PlayerModel";
		
		public var selfPlayer:SelfPlayerView;
		public var selfFollowPlayerList:Vector.<PlayerView> = new Vector.<PlayerView>();
		public var players:Vector.<PlayerView> = new Vector.<PlayerView>;
		public var groups:Vector.<PlayerGroupData> = new Vector.<PlayerGroupData>;
		
		public var deadStateList:Array = new Array();
		public var campStateList:Array = new Array();
		public var winStreakTimeList:Array = new Array();
		
		public function PlayerModel()
		{
			super(NAME);
		}
		
		/**
		 * 是否有跟随者。
		 */		
		public function get hasFollowPlayer():Boolean
		{
			return this.selfFollowPlayerList.length > 0;
		}
		
		/**
		 * 跟随者中的领队。
		 */		
		public function get followLeader():PlayerView
		{
			if (this.hasFollowPlayer)
			{
				return this.selfFollowPlayerList[0];
			}
			return null;
		}
		
		/**
		 * 设置一个或多个跟随者。
		 * @param ninjaList
		 */		
		public function setSelfFollowPlayer(ninjaList:Vector.<uint>):void
		{
			var len:int = ninjaList.length;
			var followWho:BaseWalkablePlayer;
			for (var i:int = 0; i < len; i++)
			{
				followWho = this.addFollowPlayer(ninjaList[i], followWho);
				if (i == 0) // 把主玩家放在第二位
				{
					this.selfPlayer.setFollowPlayer(followWho);
					followWho = this.selfPlayer;
				}
			}
		}
		
		// 添加一个跟随者。
		private function addFollowPlayer(ninjaId:uint, followWho:BaseWalkablePlayer=null):PlayerView
		{
			var playerData:PlayerData = new PlayerData();
			playerData.direction = selfPlayer.getData().direction;
			var ninjaCfg:NinjaInfoCFG = NinjaInfoConfig.getNinjaCfgInfo(ninjaId);
			playerData.name = ninjaCfg.name;
			playerData.ninja = ninjaId;
			var follower:PlayerView = PlayerViewManager.instance.createPlayerView(ninjaId,0,0);
			follower.setData(playerData);
			follower.setXY(selfPlayer.x, selfPlayer.y);
			if (followWho)
			{
				follower.setFollowPlayer(followWho);
			}
			this.selfFollowPlayerList.push(follower);
			return follower;
		}
		
		/**
		 * 让所有跟随者止步。
		 */		
		public function stopAllSelfFollowPlayerMove():void
		{
			for each (var follwer:PlayerView in this.selfFollowPlayerList)
			{
				follwer.stopMove();
			}
		}
		
		/**
		 * 改变指定跟随者的位置和朝向。
		 */		
		public function setSelfFollowPlayerPositionAndDir(ninjia:uint, positionX:int, positionY:int, direction:int=-1):void
		{
			for each (var follower:PlayerView in this.selfFollowPlayerList)
			{
				var playerData:PlayerData = follower.getData();
				if (playerData.ninja == ninjia)
				{
					follower.setXY(positionX, positionY);
					follower.moveTo([]);
					if (direction != -1)
					{
						playerData.direction = direction;
						follower.playIdleAction();
					}
				}
			}
		}
		
		/**
		 * 清空所有跟随者。
		 */		
		public function cleanAllSelfFollowPlayer():void
		{
			if (this.hasFollowPlayer)
			{
				for each (var follwer:PlayerView in this.selfFollowPlayerList)
				{
					follwer.destroy();
				}
				this.selfFollowPlayerList.length = 0;
				this.selfPlayer.destroyFollowPlayer();
			}
		}
		
		public function createPlayer(uin:uint,roleId:uint,svrId:uint, name:String, teamId:String, isCaptain:Boolean, isFighting:Boolean, ninja:int, showNinja:int, fashionNinja:int, level:int, vipLevel:int, diamondInfo:ProtoDiamondInfo, pos:Point, title:RankTitleCfgInfo, taskSign:int):void
		{
			logger.output("createPlayer",uin);
			if(containsPlayer(uin,roleId,svrId))
			{
				//按照后台的要求，有创建同样的uin，暂时先把之前的老的删掉
//				throw new Error("创建玩家异常，原因是该玩家已存在:"+uin+","+name,"(暂时先把之前的删除)");
				logger.output("[PlayerPlugin]", "createPlayer",I18n.lang("as_player_1451031577_5312_0")+uin+","+name,I18n.lang("as_player_1451031577_5312_1"));
				removePlayerByUin(uin,roleId,svrId);
			}
			var playerData:PlayerData = new PlayerData();
			playerData.uin = uin;
			playerData.role = roleId;
			playerData.svrId = svrId;
			playerData.teamId = teamId;
			playerData.isCaptain = isCaptain;
			playerData.isFighting = isFighting;
			playerData.ninja = ninja;
			playerData.showNinja = showNinja;
			playerData.fashionNinja = fashionNinja;
			playerData.level = level;
			playerData.vip = vipLevel;
			playerData.isDead = getDeadState(uin, roleId, svrId);
			playerData.camp = getCampState(uin, roleId, svrId);
			if(playerData.camp == -1)
			{
				playerData.name = name;
			}
			else
			{
				playerData.name = PVPFieldModelDef.campToNinjaName(playerData.camp);
			}
			playerData.winStreakTimes = getWinStreakTime(uin, roleId, svrId);
			playerData.diamondInfo = diamondInfo;
			playerData.title = title;
			playerData.taskSign = taskSign;
			
			var playerView:PlayerView = PlayerViewManager.instance.createPlayerView(playerData.ninja, playerData.showNinja, playerData.fashionNinja);
			playerView.setData(playerData);
			playerView.setXY(pos.x,pos.y);
			playerView.bodyVisible = (teamId && teamId == this.selfPlayer.getData().teamId) ? true : this._otherPlayersBodyVisible;
			playerView.mouseEnabled = playerView.bodyVisible;
			players.push(playerView);
			
			if(hasEventListener(Event.ADDED))
			{
				dispatchEvent(new Event(Event.ADDED));
			}
		}
		
		public function createPlayerByData(data:PlayerData):PlayerView
		{
			logger.output("createPlayerByData",data.uin);
			if(containsPlayer(data.uin,data.role,data.svrId))
			{
//				throw new Error("创建玩家失败#2，原因是该玩家已存在:"+data.uin+","+data.name);
				logger.output("[PlayerPlugin]", "createPlayerByData",I18n.lang("as_player_1451031577_5313_0")+data.uin+","+data.name,I18n.lang("as_player_1451031577_5313_1"));
			}
			
			var playerView:PlayerView = PlayerViewManager.instance.createPlayerView(data.ninja, data.showNinja, data.fashionNinja);
			playerView.setData(data);
			playerView.setXY(data.getPosition().x,data.getPosition().y);
			playerView.bodyVisible = (data.teamId && data.teamId == this.selfPlayer.getData().teamId) ? true : this._otherPlayersBodyVisible;
			playerView.mouseEnabled = playerView.bodyVisible;
			players.push(playerView);
			if(hasEventListener(Event.ADDED))
			{
				dispatchEvent(new Event(Event.ADDED));
			}
			return playerView;
		}
		
		public function clearWinStreakTime():void
		{
			winStreakTimeList.splice(0, winStreakTimeList.length);
			
			selfPlayer.getData().winStreakTimes = -1;
			for each(var playerView:PlayerView in players)
			{
				playerView.getData().winStreakTimes = -1;
			}
		}
		
		public function clearDeadState():void
		{
			deadStateList.splice(0, deadStateList.length);
			
			selfPlayer.getData().isDead = false;
			for each(var playerView:PlayerView in players)
			{
				playerView.getData().isDead = false;
			}
		}
		
		public function clearCampState():void
		{
			campStateList.splice(0, campStateList.length);
			
			selfPlayer.getData().camp = -1;
			
			for each(var playerView:PlayerView in players)
			{
				playerView.getData().camp = -1;
			}
		}
		
		public function updateDeadState(uin:uint, role:uint, svrId:uint, isDead:Boolean):void
		{
			var obj:Object;
			var playerView:PlayerView;
			
			obj = getDeadStateObj(uin, role, svrId);
			if(obj == null)
			{
				deadStateList.push({uin:uin, role:role, svrId:svrId, isDead:isDead});
			}
			else
			{
				obj.isDead = isDead;
			}
			
			playerView = getPlayer(uin, role, svrId);
			if(playerView)
			{
				playerView.getData().isDead = isDead;
			}
			
			if(uin == ApplicationData.singleton.selfuin && role == ApplicationData.singleton.selfRole && svrId == ApplicationData.singleton.selfSrv)
			{
				selfPlayer.getData().isDead = isDead;
			}
		}
		
		public function updateCampState(uin:uint, role:uint, svrId:uint, camp:int):void
		{
			var obj:Object;
			var playerView:PlayerView;
			
			obj = getCampStateObj(uin, role, svrId);
			if(obj == null)
			{
				campStateList.push({uin:uin, role:role, svrId:svrId, camp:camp});
			}
			else
			{
				obj.camp = camp;
			}
			
			playerView = getPlayer(uin, role, svrId);
			if(playerView)
			{
				playerView.getData().camp = camp;
				if(playerView.getData().camp != -1)
				{
					playerView.getData().name = PVPFieldModelDef.campToNinjaName(playerView.getData().camp);
				}
			}
			
			if(uin == ApplicationData.singleton.selfuin && role == ApplicationData.singleton.selfRole && svrId == ApplicationData.singleton.selfSrv)
			{
				selfPlayer.getData().camp = camp;
				for each(var p:PlayerView in players)
				{
					p.getData().camp = p.getData().camp;
				}
			}
		}
		
		public function updateWinStreakTime(uin:uint, role:uint, svrId:uint, winStreakTime:int):void
		{
			var obj:Object;
			var playerView:PlayerView;
			
			obj = getWinStreakTimeObj(uin, role, svrId);
			if(obj == null)
			{
				campStateList.push({uin:uin, role:role, svrId:svrId, winStreakTime:winStreakTime});
			}
			else
			{
				obj.winStreakTime = winStreakTime;
			}
			
			playerView = getPlayer(uin, role, svrId);
			if(playerView)
			{
				playerView.getData().winStreakTimes = winStreakTime;
			}
			
			if(uin == ApplicationData.singleton.selfuin && role == ApplicationData.singleton.selfRole && svrId == ApplicationData.singleton.selfSrv)
			{
				selfPlayer.getData().winStreakTimes = winStreakTime;
			}
		}
		
		private function getDeadState(uin:uint, role:uint, svrId:uint):Boolean
		{
			for each(var obj:Object in deadStateList)
			{
				if(obj.uin == uin && obj.role == role && obj.svrId == svrId)
				{
					return obj.isDead;
				}
			}
			
			return false;
		}
		
		private function getCampState(uin:uint, role:uint, svrId:uint):int
		{
			for each(var obj:Object in campStateList)
			{
				if(obj.uin == uin && obj.role == role && obj.svrId == svrId)
				{
					return obj.camp;
				}
			}
			
			return -1;
		}
		
		private function getWinStreakTime(uin:uint, role:uint, svrId:uint):int
		{
			for each(var obj:Object in winStreakTimeList)
			{
				if(obj.uin == uin && obj.role == role && obj.svrId == svrId)
				{
					return obj.camp;
				}
			}
			
			return -1;
		}
		
		private function getDeadStateObj(uin:uint, role:uint, svrId:uint):Object
		{
			for each(var obj:Object in deadStateList)
			{
				if(obj.uin == uin && obj.role == role && obj.svrId == svrId)
				{
					return obj;
				}
			}
			
			return null;
		}
		
		private function getCampStateObj(uin:uint, role:uint, svrId:uint):Object
		{
			for each(var obj:Object in campStateList)
			{
				if(obj.uin == uin && obj.role == role && obj.svrId == svrId)
				{
					return obj;
				}
			}
			
			return null;
		}
		
		private function getWinStreakTimeObj(uin:uint, role:uint, svrId:uint):Object
		{
			for each(var obj:Object in winStreakTimeList)
			{
				if(obj.uin == uin && obj.role == role && obj.svrId == svrId)
				{
					return obj;
				}
			}
			
			return null;
		}
		
//		public function removePlayer(playerView:PlayerView):void
//		{
//			var index:int = 
//		}
		
		public function removePlayerByUin(uin:uint,roleId:uint,svrId:uint):void
		{
			logger.output("removePlayerByUin",uin);
			for(var i:int=players.length-1; i>=0; i--)
			{
				if(players[i].getData().equeal(uin, roleId, svrId))
				{
					var playerView:PlayerView = players[i];
					players.splice(i,1);
//					playerView.destroy();
					PlayerViewManager.instance.disposePlayerView(playerView.resNinjaId,playerView);
					break;
				}
			}
		}
		
		public function removeAllPlayers():void
		{
			logger.output("removeAllPlayers");
			for each(var playerView:PlayerView in players)
			{
//				playerView.destroy();
				PlayerViewManager.instance.disposePlayerView(playerView.resNinjaId,playerView);
			}
			players.length = 0;
		}
		
		public function containsPlayer(uin:uint,roleId:uint,svrId:uint):Boolean
		{
			return getPlayer(uin,roleId,svrId) != null;
		}
		
		public function getPlayer(uin:uint,roleId:uint,svrId:uint):PlayerView
		{
			for each(var p:PlayerView in players)
			{
				if(p.getData().equeal(uin, roleId, svrId))
				{
					return p;
				}
			}
			return null;
		}
		
		public function containsGroup(teamId:String):Boolean
		{
			return getGroup(teamId) != null;
		}
		
		public function getGroup(teamId:String):PlayerGroupData
		{
			for each(var g:PlayerGroupData in groups)
			{
				if(g.teamId == teamId)
				{
					return g;
				}
			}
			return null;
		}
		
		public function addGroup(group:PlayerGroupData):void
		{
			logger.output("addGroup",group.teamId);
			if(containsGroup(group.teamId))
			{
//				throw new Error("添加组队玩家失败，原因是该组队玩家已存在:"+group.teamId);
				logger.output("[PlayerPlugin]", "addGroup",I18n.lang("as_player_1451031577_5314")+group.teamId);
				return;
			}
			groups.push(group);
		}
		
		public function removeGroup(teamId:String):PlayerGroupData
		{
			logger.output("removeGroup",teamId);
			for(var i:int=groups.length-1;i>=0;i--)
			{
				var g:PlayerGroupData = groups[i];
				if(g.teamId == teamId)
				{
					groups.splice(i,1);
					return g;
				}
			}
			return null;
		}
		
		public function removeAllGroups():void
		{
			logger.output("removeAllGroups");
			groups.length = 0;
		}
		
		
		private var groupPlayers:Vector.<PlayerView> = new Vector.<PlayerView>;
		public function getGroupPlayer(uin:uint,roleId:uint,svrId:uint):PlayerView
		{
			for each(var p:PlayerView in groupPlayers)
			{
				if(p.getData().equeal(uin, roleId, svrId))
				{
					return p;
				}
			}
			return null;
		}
		
		public function containsGroupPlayer(uin:uint,roleId:uint,svrId:uint):Boolean
		{
			return getGroupPlayer(uin,roleId,svrId) != null;
		}
		
		public function createGroupPlayer(data:PlayerData):PlayerView
		{
			logger.output("createGroupPlayer");
			if(containsGroupPlayer(data.uin,data.role,data.svrId))
			{
//				throw new Error("创建玩家失败#2，原因是该玩家已存在:"+data.uin+","+data.name);
				logger.output("[PlayerPlugin]", "createGroupPlayer",I18n.lang("as_player_1451031577_5315")+data.uin+","+data.name);
				return getGroupPlayer(data.uin,data.role,data.svrId);
			}
			
			var playerView:PlayerView = PlayerViewManager.instance.createPlayerView(data.ninja,data.showNinja,data.fashionNinja);
			playerView.setData(data);
//			var x:int = data.getPosition().x;
//			var y:int = data.getPosition().y;
//			playerView.x = x;
//			playerView.y = y;
			playerView.setXY(data.getPosition().x,data.getPosition().y);
			playerView.bodyVisible = (data.teamId && data.teamId == this.selfPlayer.getData().teamId) ? true : this._otherPlayersBodyVisible;
			playerView.mouseEnabled = playerView.bodyVisible;
			groupPlayers.push(playerView);
			if(hasEventListener(Event.ADDED))
			{
				dispatchEvent(new Event(Event.ADDED));
			}
			return playerView;
		}
		
		
		public function removeGroupPlayer(uin:uint,roleId:uint,svrId:uint):void
		{
			logger.output("removeGroupPlayer");
			for(var i:int=groupPlayers.length-1; i>=0; i--)
			{
				if(groupPlayers[i].getData().equeal(uin, roleId, svrId))
				{
					var playerView:PlayerView = groupPlayers[i];
					groupPlayers.splice(i,1);
					playerView.destroy();
					break;
				}
			}
		}
		
		public function removeAllGroupPlayers():void
		{
			logger.output("removeAllGroupPlayers");
			for(var i:int=groupPlayers.length-1; i>=0; i--)
			{
				groupPlayers[i].destroy();
			}
			groupPlayers.length = 0;
		}
		
		protected var _otherPlayersBodyVisible:Boolean = true;
		public function set otherPlayersBodyVisible(value:Boolean):void
		{
			if (this._otherPlayersBodyVisible != value)
			{
				this._otherPlayersBodyVisible = value;
				
				// 处理非组队玩家
				for each (var playerView:PlayerView in this.players)
				{
					playerView.bodyVisible = value;
					playerView.mouseEnabled = value;
				}
				
				// 处理组队的玩家
				var myTeamID:String = this.selfPlayer.getData().teamId;
				for each (playerView in this.groupPlayers)
				{
					if (playerView.getData().teamId != myTeamID)
					{
						playerView.bodyVisible = value;
						playerView.mouseEnabled = value;
					}
				}
			}
		}
		
		public function get otherPlayersBodyVisible():Boolean
		{
			return this._otherPlayersBodyVisible;
		}
		
	}
}