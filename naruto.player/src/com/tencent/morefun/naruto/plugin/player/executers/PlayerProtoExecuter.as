package com.tencent.morefun.naruto.plugin.player.executers
{
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.plugin.player.commands.RequestSelfMoveToCommand;
	import com.tencent.morefun.naruto.plugin.player.datas.PlayerGroupData;
	import com.tencent.morefun.naruto.plugin.player.datas.SpecialMoveData;
	import com.tencent.morefun.naruto.plugin.player.models.PlayerModel;
	import com.tencent.morefun.naruto.plugin.player.views.PlayerView;
	
	import flash.geom.Point;
	
	import avmplus.getQualifiedClassName;
	
	import base.ApplicationData;
	import base.NarutoExecuter;
	
	import battle.data.BattleInfo;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	import def.ProtocolCmdDef;
	
	import map.commands.AddMapElementCommand;
	import map.def.MapLayerDef;
	
	import player.commands.CheckPlayerAllowPromptCommand;
	import player.commands.CleanPlayerCommand;
	import player.commands.RequestGetPlayerViewListCommand;
	import player.commands.RequestGohomeCommand;
	import player.commands.StopSelfMoveCommand;
	import player.datas.PlayerData;
	
	import pvpBattlefield.model.BasePvpFieldModel;
	import pvpBattlefield.model.def.PVPFieldModelDef;
	
	import rank.model.TitleModel;
	import rank.model.data.RankTitleCfgInfo;
	
	import server.SocketProtocol;
	
	import serverProto.inc.ProtoDiamondInfo;
	import serverProto.inc.ProtoPoint;
	import serverProto.player.ProtoGetPlayerViewListRequest;
	import serverProto.player.ProtoGetPlayerViewListResponse;
	import serverProto.player.ProtoMoveNotifyList;
	import serverProto.player.ProtoMoveNotifyType;
	import serverProto.player.ProtoPlayerHearthStoneRequest;
	import serverProto.player.ProtoPlayerHearthStoneResponse;
	import serverProto.player.ProtoPlayerMoveRequest;
	import serverProto.player.ProtoPlayerMoveResponse;
	import serverProto.player.ProtoPlayerShowInfo;
	import serverProto.player.ProtoPlayerShowInfoChangeNotify;
	import serverProto.player.ProtoTeamShowInfo;
	
	import world.SceneConfig;
	import world.command.ChangeSceneCommand;
	import world.data.SceneType;
	import world.def.ChangeSceneReasonDef;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class PlayerProtoExecuter extends NarutoExecuter
	{
		private var ignoreMoveNotify:Boolean = true; 
		private var pvpFiledModel:BasePvpFieldModel;
		public function PlayerProtoExecuter()
		{
			super(PluginDef.PLAYER, ExecuterDef.PLAYER_PROTO);
			
			this.gameServer.registerMessage(ProtocolCmdDef.NTF_MOVE, ProtoMoveNotifyList);
			
			this.gameServer.addProtocolListener(ProtocolCmdDef.REQ_MOVE_TO, respondSelfMoveTo);
			//			在收到getPlayerView回包后开始监听
			this.gameServer.addProtocolListener(ProtocolCmdDef.NTF_MOVE, notifyMove);
			
			this.gameServer.addProtocolListener(ProtocolCmdDef.GET_PLAYER_VIEW, respondGetPlayerViewList);
			
			this.gameServer.addProtocolListener(ProtocolCmdDef.PLAYER_GOHOME, respondGohome);
			
			this.gameServer.registerMessage(ProtocolCmdDef.USER_DISPLAY_STATE_CHANGE_NOTIFY, ProtoPlayerShowInfoChangeNotify);
			this.gameServer.addProtocolListener(ProtocolCmdDef.USER_DISPLAY_STATE_CHANGE_NOTIFY, notifyPlayerShowInfoChange);
		}
		
		
		override public function doCommand(cmd:Command):void
		{
			switch(getQualifiedClassName(cmd))
			{
				case getQualifiedClassName(RequestSelfMoveToCommand):
					requestSelfMoveTo(cmd as RequestSelfMoveToCommand);
					break;
				case getQualifiedClassName(RequestGohomeCommand):
					requestGohome(cmd as RequestGohomeCommand);
					break;
				case getQualifiedClassName(CleanPlayerCommand):
					ignoreMoveNotify = true;
					logger.output("[player]","[CleanPlayerCommand] ignoreMoveNotify:",ignoreMoveNotify);
					break;
				case getQualifiedClassName(RequestGetPlayerViewListCommand):
					requestGetPlayerViewList(cmd as RequestGetPlayerViewListCommand);
					break;
			}
		}
		
		private function requestSelfMoveTo(cmd:RequestSelfMoveToCommand):void
		{
			var req:ProtoPlayerMoveRequest = new ProtoPlayerMoveRequest();
			var rsp:ProtoPlayerMoveResponse = new ProtoPlayerMoveResponse();
			
			req.points = [];
			var p:ProtoPoint = new ProtoPoint();
			
			for(var i:int=0;i<cmd.moveToPixcels.length;i++)
			{
				p = new ProtoPoint();
				p.x = cmd.moveToPixcels[i].x;
				p.y = cmd.moveToPixcels[i].y;
				
				req.points.push(p);
			}
			
			gameServer.sendMessage(ProtocolCmdDef.REQ_MOVE_TO, req, rsp);
		}
		
		private function respondSelfMoveTo(protocol:SocketProtocol):void
		{
			//理论上这里什么都可以不用做，因为自己的移动已经过去了，，只需要考虑别的notifyMove就可以了
		}
		
		private function notifyMove(protocol:SocketProtocol):void
		{
			//在请求1f和应答1f之间的移动需要忽略
			if(ignoreMoveNotify)
			{
				return;
			}
			var rsp:ProtoMoveNotifyList = protocol.serverMessage as ProtoMoveNotifyList;
			notfiyPlayerMove(rsp.playerMoveNotify);
			notifyTeamMove(rsp.teamMoveNotify);
		}
		
		private function notfiyPlayerMove(list:Array):void
		{
			var fightStateList:Array = [];
			
			for each(var  moveNotify:ProtoPlayerShowInfo in list)
			{
				if(selfInfo.equeal(moveNotify.playerKey.uin,moveNotify.playerKey.roleId,moveNotify.playerKey.svrId))
				{
					//					throw new Error("服务器下发了uin为自己的移动通知@"+moveNotify.playerKey.uin);
					continue;
				}
				
				//通知类型 1进入视野, 2离开视野 , 3改变行走路径
				if(moveNotify.notifyType == 2)
				{
					playerModel.removePlayerByUin(moveNotify.playerKey.uin,moveNotify.playerKey.roleId,moveNotify.playerKey.svrId);
				}else
				{
					var name:String = null;
					if(moveNotify.hasName)
					{
						name = moveNotify.name;
					}
					var teamId:String = null;
					//					if(moveNotify.teamId)
					//					{
					//						teamId = moveNotify.teamId.toString();
					//					}
					var isCaptain:Boolean = false;
					//					if(moveNotify.hasIsCaptain)
					//					{
					//						isCaptain = moveNotify.isCaptain;
					//					}
					var isFight:Boolean = false;
					if(moveNotify.hasIsFight)
					{
						isFight = moveNotify.isFight;
						fightStateList.push(moveNotify);
					}
					var ninja:int = 0;
					if(moveNotify.hasNinja)
					{
						ninja = moveNotify.ninja;
					}
					var showNinja:int = 0;
					if(moveNotify.hasShowNinja)
					{
						showNinja = moveNotify.showNinja;
					}
					var fashionNinja:int = 0;
					if(moveNotify.hasFashionNinja)
					{
						fashionNinja = moveNotify.fashionNinja;
					}
					var level:int=0;
					if(moveNotify.hasLevel)
					{
						level = moveNotify.level;
					}
					var vipLevel:int = 0;
					if(moveNotify.hasVipLevel)
					{
						vipLevel = moveNotify.vipLevel;
					}
					var pixcels:Array = [];
					for(var i:int=0;i<moveNotify.points.length;i++)
					{
						var p:ProtoPoint = moveNotify.points[i];
						pixcels.push(new Point(p.x,p.y));
					}
					
					var title:RankTitleCfgInfo = (plugin.retrieveModel(ModelDef.TITLE) as TitleModel).getTitle(moveNotify.titleId);
					var taskSign:int = moveNotify.taskSign;
					
					var playerView:PlayerView = null;
					//通知类型 1进入视野, 2离开视野 , 3改变行走路径
					switch(moveNotify.notifyType)
					{
						case 1://进入视野
							if(pixcels.length<1)
							{
								throw new Error(I18n.lang("as_player_1451031577_5289"));
							}
							var initPos:Point = pixcels[0];
							playerModel.createPlayer(moveNotify.playerKey.uin,moveNotify.playerKey.roleId,moveNotify.playerKey.svrId, name, teamId, isCaptain, isFight, ninja, showNinja, fashionNinja, level, vipLevel, moveNotify.diamondInfo, initPos, title, taskSign);
							playerView = playerModel.getPlayer(moveNotify.playerKey.uin,moveNotify.playerKey.roleId,moveNotify.playerKey.svrId);
							new AddMapElementCommand(playerView,MapLayerDef.MIDDLE_ELEMENT).call();
							
							if(pixcels.length > 1)
							{
								playerView.moveTo(pixcels);
							}
							break;
						case 3://改变行走路径
							playerView = playerModel.getPlayer(moveNotify.playerKey.uin,moveNotify.playerKey.roleId,moveNotify.playerKey.svrId);
							if(playerView==null)//临时解决服务器已经把这个人删掉了，还发移动通知过来
							{
								return;
							}
							if(pixcels.length > 1)
							{
								playerView.moveTo(pixcels);
							}else
							{
								playerView.stopMove();
							}
							break;
						case 4:
							playerView = playerModel.getPlayer(moveNotify.playerKey.uin,moveNotify.playerKey.roleId,moveNotify.playerKey.svrId);
							if(playerView==null)//临时解决服务器已经把这个人删掉了，还发移动通知过来
							{
								return;
							}
							if(pixcels.length == 1)
							{
								playerView.stopMove();
								playerView.setXY(pixcels[0].x, pixcels[0].y);
							}else if(pixcels.length == 2)
							{
								playerView.stopMove();
								playerView.setXY(pixcels[1].x, pixcels[1].y);
							}
							break;
						case ProtoMoveNotifyType.PROTO_MOVE_NOTIFY_TYPE_ROPE:
							playerView = playerModel.getPlayer(moveNotify.playerKey.uin,moveNotify.playerKey.roleId,moveNotify.playerKey.svrId);
							if(playerView==null)//临时解决服务器已经把这个人删掉了，还发移动通知过来
							{
								return;
							}
							playerView.specialMoveTo(pixcels[0],pixcels[1],SpecialMoveData.JUMP,null);
							break;
					}
					
					if(moveNotify.notifyType != ProtoMoveNotifyType.PROTO_MOVE_NOTIFY_TYPE_ENTER && playerView && playerView.getData())
					{
						if(moveNotify.hasName)
						{
							if(playerView.getData().camp == -1)
							{
								playerView.getData().name = moveNotify.name;
							}
							else
							{
								playerView.getData().name = PVPFieldModelDef.campToNinjaName(playerView.getData().camp);
							}
						}
						if(moveNotify.hasNinja)
						{
							playerView.getData().ninja = moveNotify.ninja;
						}
						if(moveNotify.hasShowNinja)
						{
							playerView.getData().showNinja = moveNotify.showNinja;
						}
						if(moveNotify.hasTitleId)
						{
							playerView.getData().title = title;
						}
						if(moveNotify.hasTaskSign)
						{
							playerView.getData().taskSign = moveNotify.taskSign;
						}
					}
				}
			}
			
			if(fightStateList.length != 0)
			{
				pvpFiledModel = this.plugin.retrieveModel(ModelDef.BATTLE_FILE_MODEL) as BasePvpFieldModel;
				if(pvpFiledModel){pvpFiledModel.dispathFightStateUpdate(fightStateList)}
			}
		}
		
		private function notifyTeamMove(list:Array):void
		{
			for each(var ntf:ProtoTeamShowInfo in list)
			{
				var playerData:PlayerData = null;
				var playerView:PlayerView = null;
				var playerGroupData:PlayerGroupData = null;
				var captainView:PlayerView = null;
				var i:int;
				var points:Array = null;
				if(ntf.points)
				{
					points = [];
					for(i=0;i<ntf.points.length;i++)
					{
						points.push(new Point(ntf.points[i].x,ntf.points[i].y));
					}
				}
				if(ntf.notifyType == ProtoMoveNotifyType.PROTO_MOVE_NOTIFY_TYPE_ENTER)
				{
					//队伍进入视野
					playerGroupData = transformPlayerGroupData(ntf);
					{//#########临时屏蔽
						if(playerModel.containsGroup(playerGroupData.teamId))
						{
							//							throw new Error("警告,收到队伍移动包#ENTER，，但是这个队伍已存在@"+playerGroupData.teamId);
							logger.output("[player]","[PlayerProtoExecuter]",I18n.lang("as_player_1451031577_5295")+playerGroupData.teamId);
							playerModel.removeGroup(playerGroupData.teamId);
						}
					}
					playerModel.addGroup(playerGroupData);
					if(ntf.hasTeamId)
					{
						playerGroupData.teamId = ntf.teamId.toString();
					}
					if(ntf.hasIsFight)
					{
						playerGroupData.isFighting = ntf.isFight;
					}
					
					captainView = playerModel.createGroupPlayer(playerGroupData.captain);
					new AddMapElementCommand(captainView,MapLayerDef.MIDDLE_ELEMENT).call();
					for(i=0;i<playerGroupData.members.length;i++)
					{
						playerView = playerModel.createGroupPlayer(playerGroupData.members[i]);
						new AddMapElementCommand(playerView, MapLayerDef.MIDDLE_ELEMENT).call();
						playerView.setFollowPlayer(captainView,(i+1)*50);
					}
					if(points.length>1)
					{
						captainView.moveTo(points);
					}else
					{
						captainView.stopMove();
					}
				}else if(ntf.notifyType == ProtoMoveNotifyType.PROTO_MOVE_NOTIFY_TYPE_LEAVE)
				{
					//队伍离开视野
					if(playerModel.containsGroup(ntf.teamId.toString()))
					{
						playerGroupData = playerModel.removeGroup(ntf.teamId.toString());
						for each(playerData in playerGroupData.members)
						{
							playerModel.removeGroupPlayer(playerData.uin,playerData.role,playerData.svrId);
						}
						playerModel.removeGroupPlayer(playerGroupData.captain.uin,playerGroupData.captain.role,playerGroupData.captain.svrId);
					}else
					{
						//						throw new Error("收到队伍离开视野的包，，但是这个队伍不在我的视野范围里",ntf.teamId.toString());
						//先忽略davey那边发来的队伍离开视野
						{//#########临时屏蔽
							//							throw new Error("警告,收到队伍移动包#LEAVE，，但是这个队伍不存在@"+ntf.teamId.toString());
							logger.output("[player]","[PlayerProtoExecuter]",I18n.lang("as_player_1451031577_5297")+ntf.teamId.toString());
						}
						continue;
					}
					
				}else if(ntf.notifyType == ProtoMoveNotifyType.PROTO_MOVE_NOTIFY_TYPE_MOVE)
				{
					//队伍移动
					playerGroupData = playerModel.getGroup(ntf.teamId.toString());
					if(playerGroupData == null)
					{
						{//#########临时屏蔽
							//							throw new Error("警告,收到队伍移动包#MOVE，，但是这个队伍不存在@"+ntf.teamId.toString());
							logger.output("[player]","[PlayerProtoExecuter]",I18n.lang("as_player_1451031577_5299")+ntf.teamId.toString());
							continue;
						}
					}
					if(ntf.hasIsFight)
					{
						playerGroupData.isFighting = ntf.isFight;
					}
					if(playerGroupData.captain.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
					{
						//						throw new Error("队长收到了自己的移动通知");
						captainView = playerModel.selfPlayer;
					}else
					{
						captainView = playerModel.getGroupPlayer(playerGroupData.captain.uin,playerGroupData.captain.role,playerGroupData.captain.svrId);
					}
					if(points.length>1)
					{
						captainView.moveTo(points);
					}else
					{
						captainView.stopMove();
					}
				}else if(ntf.notifyType == ProtoMoveNotifyType.PROTO_MOVE_NOTIFY_TYPE_FLASH)
				{
					//队伍闪现到目标点
					playerGroupData = playerModel.getGroup(ntf.teamId.toString());
					if(playerGroupData == null)
					{
						{//#########临时屏蔽
							//							throw new Error("警告,收到队伍移动包#FLASH，，但是这个队伍不存在@"+ntf.teamId.toString());
							logger.output("[player]","[PlayerProtoExecuter]",I18n.lang("as_player_1451031577_5301")+ntf.teamId.toString());
							continue;
						}
					}
					if(playerGroupData.captain.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
					{
						captainView = playerModel.selfPlayer;
					}else
					{
						captainView = playerModel.getGroupPlayer(playerGroupData.captain.uin,playerGroupData.captain.role,playerGroupData.captain.svrId);
					}
					captainView.specialMoveTo(points[0], points[1], SpecialMoveData.FLASH,null);
					//					for each(playerData in playerGroupData.members)
					//					{
					//						if(playerData.uin == ApplicationData.singleton.selfInfo.uin)
					//						{
					//							playerView = playerModel.selfPlayer;
					//						}else
					//						{
					//							playerView = playerModel.getPlayer(playerData.uin);
					//						}
					//						playerView.specialMoveTo(points[0], points[1], SpecialMoveData.FLASH);
					//					}
				}else if(ntf.notifyType == ProtoMoveNotifyType.PROTO_MOVE_NOTIFY_TYPE_ROPE)
				{
					//队伍跳跃到目标点
					playerGroupData = playerModel.getGroup(ntf.teamId.toString());
					if(playerGroupData == null)
					{
						{//#########临时屏蔽
							//							throw new Error("警告,收到队伍移动包#ROPE，，但是这个队伍不存在@"+ntf.teamId.toString());
							logger.output("[player]","[PlayerProtoExecuter]",I18n.lang("as_player_1451031577_5303")+ntf.teamId.toString());
							continue;
						}
					}
					if(playerGroupData.captain.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
					{
						captainView = playerModel.selfPlayer;
					}else
					{
						captainView = playerModel.getGroupPlayer(playerGroupData.captain.uin,playerGroupData.captain.role,playerGroupData.captain.svrId);
					}
					captainView.specialMoveTo(points[0], points[1], SpecialMoveData.JUMP,null);
					//					for each(playerData in playerGroupData.members)
					//					{
					//						if(playerData.uin == ApplicationData.singleton.selfInfo.uin)
					//						{
					//							playerView = playerModel.selfPlayer;
					//						}else
					//						{
					//							playerView = playerModel.getPlayer(playerData.uin);
					//						}
					//						playerView.specialMoveTo(points[0], points[1], SpecialMoveData.JUMP);
					//					}
				}else if(ntf.notifyType == ProtoMoveNotifyType.PROTO_MOVE_NOTIFY_TYPE_TEAM_INFO_CHANGE)
				{
					//修改队伍的成员信息
					var newPlayerGroupData:PlayerGroupData = transformPlayerGroupData(ntf);
					playerGroupData = playerModel.getGroup(ntf.teamId.toString());
					if(playerGroupData == null)
					{
						//如果老的没有，那就是全新的进入
						playerGroupData = newPlayerGroupData;
						playerModel.addGroup(playerGroupData);
						if(ntf.hasTeamId)
						{
							playerGroupData.teamId = ntf.teamId.toString();
						}
						if(ntf.hasIsFight)
						{
							playerGroupData.isFighting = ntf.isFight;
						}
						
						captainView = playerModel.createGroupPlayer(playerGroupData.captain);
						new AddMapElementCommand(captainView,MapLayerDef.MIDDLE_ELEMENT).call();
						for(i=0;i<playerGroupData.members.length;i++)
						{
							playerView = playerModel.createGroupPlayer(playerGroupData.members[i]);
							new AddMapElementCommand(playerView, MapLayerDef.MIDDLE_ELEMENT).call();
							playerView.setFollowPlayer(captainView,(i+1)*50);
						}
					}else
					{
						var oldPlayerDatas:Vector.<PlayerData> = buildPlayerDatas(playerGroupData.captain, playerGroupData.members);
						
						playerGroupData.captain = getPlayerData(oldPlayerDatas, newPlayerGroupData.captain.uin, newPlayerGroupData.captain.role, newPlayerGroupData.captain.svrId);
						if(playerGroupData.captain == null)
						{
							playerGroupData.captain = newPlayerGroupData.captain;
							if(playerGroupData.captain.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
							{
								captainView = playerModel.selfPlayer;
							}else
							{
								captainView = playerModel.createGroupPlayer(playerGroupData.captain);
							}
							new AddMapElementCommand(captainView,MapLayerDef.MIDDLE_ELEMENT).call();
						}else
						{
							if(newPlayerGroupData.captain.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
							{
								captainView = playerModel.selfPlayer;
							}else
							{
								captainView = playerModel.getGroupPlayer(newPlayerGroupData.captain.uin,newPlayerGroupData.captain.role,newPlayerGroupData.captain.svrId);
							}
							captainView.destroyFollowPlayer();
							//						captainView.setFollowPlayer(null);
						}
						playerGroupData.captain.isCaptain = true;
						playerGroupData.members.length = 0;
						for(i=0;i<newPlayerGroupData.members.length;i++)
						{
							playerData = getPlayerData(oldPlayerDatas,newPlayerGroupData.members[i].uin,newPlayerGroupData.members[i].role,newPlayerGroupData.members[i].svrId);
							if(playerData == null)
							{
								playerData = newPlayerGroupData.members[i];
								if(playerData.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
								{
									playerView = playerModel.selfPlayer;
								}else
								{
									playerView = playerModel.createGroupPlayer(playerData);
								}
								new AddMapElementCommand(playerView,MapLayerDef.MIDDLE_ELEMENT).call();
							}else
							{
								playerData.isCaptain = false;
								if(playerData.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
								{
									playerView = playerModel.selfPlayer;
								}else
								{
									playerView = playerModel.getGroupPlayer(playerData.uin, playerData.role, playerData.svrId);
								}
							}
							playerView.setFollowPlayer(captainView,(i+1)*50);
							
							playerGroupData.members.push(playerData);
						}
						//删除老的多余playeView
						var newPlayerDatas:Vector.<PlayerData> = buildPlayerDatas(playerGroupData.captain, playerGroupData.members);
						for each(var oldPlayerData:PlayerData in oldPlayerDatas)
						{
							playerData = getPlayerData(newPlayerDatas,oldPlayerData.uin,oldPlayerData.role,oldPlayerData.svrId);
							if(playerData == null)
							{
								playerModel.removeGroupPlayer(oldPlayerData.uin,oldPlayerData.role,oldPlayerData.svrId);
							}
						}
					}
				}
			}
		}
		
		private static function buildPlayerDatas(captain:PlayerData,members:Vector.<PlayerData>):Vector.<PlayerData>
		{
			var pds:Vector.<PlayerData> = members.concat();
			pds.push(captain);
			return pds;
		}
		
		private static function getPlayerData(playerDatas:Vector.<PlayerData>, uin:uint, roleId:uint, svrId:uint):PlayerData
		{
			for each(var pd:PlayerData in playerDatas)
			{
				if(pd.equeal(uin,roleId,svrId))
				{
					return pd;
				}
			}
			return null;
		}
		
		private function transformPlayerGroupData(ntf:ProtoTeamShowInfo):PlayerGroupData
		{
			var playerGroupData:PlayerGroupData = new PlayerGroupData();
			if(ntf.hasTeamId)
			{
				playerGroupData.teamId = ntf.teamId.toString();
			}
			if(ntf.hasIsFight)
			{
				playerGroupData.isFighting = ntf.isFight;
			}
			
			playerGroupData.captain = transformPlayerData(ntf.captain, true, playerGroupData.teamId.toString(), playerGroupData.isFighting, ntf.points[0].x, ntf.points[0].y, ntf.captain.vipLevel, ntf.captain.diamondInfo, ntf.captain.titleId);
			playerGroupData.members = new Vector.<PlayerData>;
			for(var i:int=0;i<ntf.followMember.length;i++)
			{
				var ptmi:ProtoPlayerShowInfo = ntf.followMember[i] as ProtoPlayerShowInfo;
				var playerData:PlayerData = transformPlayerData(ptmi, false, playerGroupData.teamId.toString(), playerGroupData.isFighting, ntf.points[0].x, ntf.points[0].y, ptmi.vipLevel, ptmi.diamondInfo, ptmi.titleId);
				playerGroupData.members.push(playerData);
			}
			return playerGroupData;
		}
		
		private function transformPlayerData(ptmi:ProtoPlayerShowInfo, isCaptain:Boolean, teamId:String, isFighting:Boolean, x:int, y:int, vip:int, diamondInfo:ProtoDiamondInfo, title:uint):PlayerData
		{
			var pd:PlayerData = new PlayerData();
			pd.uin = ptmi.playerKey.uin;
			pd.role = ptmi.playerKey.roleId;
			pd.svrId = ptmi.playerKey.svrId;
			pd.name = ptmi.name;
			pd.ninja = ptmi.ninja;
			pd.showNinja = ptmi.showNinja;
			
			pd.isCaptain = isCaptain;
			pd.teamId = teamId;
			pd.isFighting = isFighting;
			pd.setPosition(x, y);
			pd.vip = vip;
			pd.diamondInfo = diamondInfo;
			pd.title = (plugin.retrieveModel(ModelDef.TITLE) as TitleModel).getTitle(title);
			return pd;
		}
		
		private function requestGetPlayerViewList(cmd:RequestGetPlayerViewListCommand):void
		{
			//如果是在切换场的时候拉的请求，，要判断下，是不是在lade的时候的请求
			if(cmd.isChangeScene == false && ignoreMoveNotify)
			{
				return;
			}
			var req:ProtoGetPlayerViewListRequest = new ProtoGetPlayerViewListRequest();
			req.sceneId = appData.globelInfo.sceneToId || appData.globelInfo.sceneId;
			//因为现在进入组织基地时，前端会根据组织等级的不同而进入不同的场景，而后台始终认为只有一个组织基地场景，所以要统一一下
			if (SceneConfig.getSceneInfo(req.sceneId).type == SceneType.NINJA_BASE_SCENE)
			{
				req.sceneId = 1600003;
			}
			var rsp:ProtoGetPlayerViewListResponse = new ProtoGetPlayerViewListResponse();
			gameServer.sendMessage(ProtocolCmdDef.GET_PLAYER_VIEW, req, rsp, cmd);
		}
		
		private function respondGetPlayerViewList(proto:SocketProtocol):void
		{
			var cmd:RequestGetPlayerViewListCommand = proto.clientData as RequestGetPlayerViewListCommand;
			//如果在忽略情况下,,只有是isChangeScene的才会执行回包信息,才会取消忽略状态
			if(ignoreMoveNotify && !cmd.isChangeScene)
			{
				//				throw new Error("切换场时出现的RequestGetPlayerViewList应该要去掉");
				cmd.faild(1);
				return;
			}
			var rsp:ProtoGetPlayerViewListResponse = proto.serverMessage as ProtoGetPlayerViewListResponse;
			
			
			if(proto.error == 0)
			{
				ignoreMoveNotify = false;
				logger.output("[player]","[respondGetPlayerViewList] ignoreMoveNotify:",ignoreMoveNotify);
				
				if(appData.globelInfo.sceneId != rsp.sceneId && appData.globelInfo.sceneToId != rsp.sceneId )
				{
					//因为现在进入组织基地时，前端会根据组织等级的不同而进入不同的场景，而后台始终认为只有一个组织基地场景，所以要统一一下
					if (SceneConfig.getSceneInfo(rsp.sceneId).type == SceneType.NINJA_BASE_SCENE && 
						((appData.globelInfo.sceneId != 0 && SceneConfig.getSceneInfo(appData.globelInfo.sceneId).type == SceneType.NINJA_BASE_SCENE) || 
							(appData.globelInfo.sceneToId != 0 && SceneConfig.getSceneInfo(appData.globelInfo.sceneToId).type == SceneType.NINJA_BASE_SCENE)))
					{
						
					}else
					{
						throw new Error(I18n.lang("as_player_1451031577_5304_0")+rsp.sceneId+I18n.lang("as_player_1451031577_5304_1")+(appData.globelInfo.sceneToId||appData.globelInfo.sceneId)+I18n.lang("as_player_1451031577_5304_2"));
						cmd.faild(1);
						return;	
					}
					
					
				}
				playerModel.removeAllPlayers();
				playerModel.removeAllGroupPlayers();
				playerModel.removeAllGroups();
				if(rsp.hasSelfTeam)
				{
					respondGetPlayerViewBySelfTeam(rsp.selfTeam);
				}
				respondGetPlayerViewByPlayer(rsp.playerViewList);
				notifyTeamMove(rsp.teamMoveList);
				new CheckPlayerAllowPromptCommand().call();
			}else
			{
				cmd.faild(proto.error);
			}
			
			//			百人同屏测试代码
			//			for(var i:int=0;i<100;i++)
			//			{
			//				var id:int = 3000+i
			//				playerModel.createPlayer(id,id.toString(),null,false,false,10000101+(i%5)*100,new Point(700,500));
			//				var playerView:PlayerView = playerModel.getPlayer(id);
			//				new AddMapElementCommand(playerView,MapLayerDef.MIDDLE_ELEMENT).call();
			//			}
			//			
			//			setInterval(function():void{
			//				var pv:PlayerView = playerModel.getPlayer(3000 + Math.random()*100);
			//				pv.moveTo([new Point(),new Point(200 + Math.random()*2000, 300 + Math.random()*1000)]);
			//			},200);
		}
		
		
		private function respondGetPlayerViewBySelfTeam(selfTeam:ProtoTeamShowInfo):void
		{
			var points:Array = null;
			if(selfTeam.points)
			{
				points = [];
				for(i=0;i<selfTeam.points.length;i++)
				{
					points.push(new Point(selfTeam.points[i].x, selfTeam.points[i].y));
				}
			}
			
			var playerGroupData:PlayerGroupData = transformPlayerGroupData(selfTeam);
			playerModel.addGroup(playerGroupData);
			playerGroupData.teamId = selfTeam.teamId.toString();
			if(selfTeam.hasIsFight)
			{
				playerGroupData.isFighting = selfTeam.isFight;
			}
			
			var captainView:PlayerView;
			if(ApplicationData.singleton.selfInfo.equal2(playerGroupData.captain))
			{
				captainView = playerModel.selfPlayer;
			}else
			{
				captainView = playerModel.createGroupPlayer(playerGroupData.captain);
			}
			captainView.getData().isCaptain = true;
			
			new AddMapElementCommand(captainView,MapLayerDef.MIDDLE_ELEMENT).call();
			
			for(var i:int=0;i<playerGroupData.members.length;i++)
			{
				var playerView:PlayerView;
				if(ApplicationData.singleton.selfInfo.equal2(playerGroupData.members[i]))
				{
					playerView = playerModel.selfPlayer;
					playerView.setXY(points[0].x,points[0].y);
				}else
				{
					playerView = playerModel.createGroupPlayer(playerGroupData.members[i]);
				}
				playerView.getData().isCaptain = false;
				new AddMapElementCommand(playerView, MapLayerDef.MIDDLE_ELEMENT).call();
				playerView.setFollowPlayer(captainView,(i+1)*50);
			}
			
			if(points.length>1)
			{
				captainView.moveTo(points);
			}
			
//			//如果自己不在战斗，，但是队伍又在战斗，那就请求进入战斗
//			if(!selfInfo.isBattling && playerGroupData.isFighting)
//			{
//				new RequestInsertFightCommand(playerGroupData.captain.uin, playerGroupData.captain.role, playerGroupData.captain.svrId).call();
//			}
		}
		
		private function respondGetPlayerViewByPlayer(playerViewList:Array):void
		{
			var fightStateList:Array = [];
			for each(var pvi:ProtoPlayerShowInfo in playerViewList)
			{
				var name:String = null;
				if(pvi.hasName)
				{
					name = pvi.name;
				}
				var teamId:String = null;
				//				if(pvi.teamId)
				//				{
				//					teamId = pvi.teamId.toString();
				//				}
				var isCaptain:Boolean = false;
				//				if(pvi.hasIsCaptain)
				//				{
				//					isCaptain = pvi.isCaptain;
				//				}
				var isFight:Boolean = false;
				if(pvi.hasIsFight)
				{
					isFight = pvi.isFight;
					fightStateList.push(pvi);
				}
				var ninja:int = 0;
				if(pvi.hasNinja)
				{
					ninja = pvi.ninja;
				}
				var showNinja:int=0;
				if(pvi.hasShowNinja)
				{
					showNinja = pvi.showNinja;
				}
				var fashionNinja:int=0;
				if(pvi.hasFashionNinja)
				{
					fashionNinja = pvi.fashionNinja;
				}
				var level:int=0;
				if(pvi.hasLevel)
				{
					level = pvi.level;
				}
				var vipLevel:int = 0;
				if(pvi.hasVipLevel)
				{
					vipLevel = pvi.vipLevel;
				}
				var pixcels:Array = [];
				for(var i:int=0;i<pvi.points.length;i++)
				{
					var p:ProtoPoint = pvi.points[i];
					pixcels.push(new Point(p.x,p.y));
				}
				
				var title:RankTitleCfgInfo = (plugin.retrieveModel(ModelDef.TITLE) as TitleModel).getTitle(pvi.titleId);
				var taskSign:int = pvi.taskSign;
				
				var initPos:Point = pixcels.shift();
				playerModel.createPlayer(pvi.playerKey.uin, pvi.playerKey.roleId, pvi.playerKey.svrId, name, teamId, isCaptain, isFight, ninja, showNinja, fashionNinja, level, vipLevel, pvi.diamondInfo, initPos, title, taskSign);
				var playerView:PlayerView = playerModel.getPlayer(pvi.playerKey.uin, pvi.playerKey.roleId, pvi.playerKey.svrId);
				new AddMapElementCommand(playerView,MapLayerDef.MIDDLE_ELEMENT).call();
				
				if(pvi.points.length > 0)
				{
					playerView.moveTo(pixcels);
				}
			}
			
			if(fightStateList.length != 0)
			{
				pvpFiledModel = this.plugin.retrieveModel(ModelDef.BATTLE_FILE_MODEL) as BasePvpFieldModel;
				if(pvpFiledModel){pvpFiledModel.dispathFightStateUpdate(fightStateList)}
			}
		}
		
		private function requestGohome(cmd:RequestGohomeCommand):void
		{
			new StopSelfMoveCommand().call();
			var req:ProtoPlayerHearthStoneRequest = new ProtoPlayerHearthStoneRequest();
			var rsp:ProtoPlayerHearthStoneResponse = new ProtoPlayerHearthStoneResponse();
			
			gameServer.sendMessage(ProtocolCmdDef.PLAYER_GOHOME,req,rsp,cmd);
		}
		private function respondGohome(protocol:SocketProtocol):void
		{
			var rsp:ProtoPlayerHearthStoneResponse = protocol.serverMessage as ProtoPlayerHearthStoneResponse;
			
			if(protocol.error == 0)
			{
				//				if(ApplicationData.singleton.globelInfo.sceneId == rsp.location.scene)
				//				{
				//					new SetSelfPlayerPosAndDirCommand(
				//						new Point(rsp.location.x,rsp.location.y),
				//						rsp.location.face
				//					).call();
				//				}else
				//				{
				new ChangeSceneCommand(
					rsp.location.scene, 
					new Point(rsp.location.x,rsp.location.y),
					rsp.location.face,
					ChangeSceneReasonDef.GOHOME
				).call();
				//				}
			}
		}
		
		private function notifyPlayerShowInfoChange(protocol:SocketProtocol):void
		{
			var fightStateList:Array = [];
			
			//在请求1f和应答1f之间的状态变更包需要忽略
			if(ignoreMoveNotify)
			{
				return;
			}
			var ntf:ProtoPlayerShowInfoChangeNotify = protocol.serverMessage as ProtoPlayerShowInfoChangeNotify;
			
			//playerData
			if(ntf.hasPlayerInfo)
			{
				var pv:PlayerView = playerModel.getPlayer(ntf.playerInfo.playerKey.uin, ntf.playerInfo.playerKey.roleId, ntf.playerInfo.playerKey.svrId);
				if(pv == null)
				{
					pv = playerModel.getGroupPlayer(ntf.playerInfo.playerKey.uin, ntf.playerInfo.playerKey.roleId, ntf.playerInfo.playerKey.svrId);
				}
				if(pv)
				{
					syncPlayerData(pv.getData(), ntf.playerInfo);
				}else
				{
//					throw new Error("wrong，收到玩家显示状态变更通知，但是该玩家不存在@"+ntf.playerInfo.playerKey.uin);
					logger.output(I18n.lang("as_player_1451031577_5305")+ntf.playerInfo.playerKey.uin);
				}
				
				fightStateList.push(ntf.playerInfo);
			}
			
			//playerGroupData
			if(ntf.hasTeamInfo)
			{
				var teamId:String = ntf.teamInfo.teamId.toString();
				var pgd:PlayerGroupData = playerModel.getGroup(teamId);
				if(pgd)
				{
					var isFight:Boolean = ntf.teamInfo.isFight;
					pgd.captain.isFighting = isFight;
					for each(var pd:PlayerData in pgd.members)
					{
						pd.isFighting = isFight;
					}
				}else
				{
//					throw new Error("wrong，收到队伍显示状态变更通知，但是队伍不存在@"+teamId);
					logger.output(I18n.lang("as_player_1451031577_5306")+teamId);
				}
				//				var isFight:Boolean = ntf.teamInfo.isFight;
				//				pv = playerModel.getGroupPlayer(ntf.teamInfo.captain.playerKey.uin, ntf.teamInfo.captain.playerKey.roleId, ntf.teamInfo.captain.playerKey.svrId);
				//				if(pv)
				//				{
				//					syncPlayerData(pv.getData(), ntf.playerInfo);
				//					pv.getData().isFighting = isFight;
				//					pv.getData().teamId = teamId;
				//				}else
				//				{
				//					throw new Error("wrong，收到玩家显示状态变更通知，但是该组队队长不存在@"+ntf.teamInfo.captain.playerKey.uin);
				//				}
				//				for each(var pi:ProtoPlayerShowInfo in ntf.teamInfo.followMember)
				//				{
				//					pv = playerModel.getGroupPlayer(ntf.teamInfo.captain.playerKey.uin, ntf.teamInfo.captain.playerKey.roleId, ntf.teamInfo.captain.playerKey.svrId);
				//					if(pv)
				//					{
				//						syncPlayerData(pv.getData(), ntf.playerInfo);
				//						pv.getData().isFighting = isFight;
				//						pv.getData().teamId = teamId;
				//					}else
				//					{
				//						throw new Error("wrong，收到玩家显示状态变更通知，但是该组队成员不存在@"+ntf.teamInfo.captain.playerKey.uin);
				//					}
				//				}
			}
			
			
			//			var pv:PlayerView = playerModel.getPlayer(ntf.playerKey.uin, ntf.playerKey.roleId, ntf.playerKey.svrId);
			//			if(pv == null)
			//			{
			//				pv = playerModel.getGroupPlayer(ntf.playerKey.uin, ntf.playerKey.roleId, ntf.playerKey.svrId);
			//			}
			//			if(ntf.hasBattleState)
			//			{
			//				//0表示脱离战斗,1表示挑战对手等待应答,2表示pvp战斗中,3表示pve战斗中
			//				pv.getData().isFighting = ntf.battleState == 2 || ntf.battleState == 3;
			//				
			//				if(pv.getData().equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
			//				{
			//					ApplicationData.singleton.selfInfo.state.setFlagByName(UserStateDef.BASE_PVP, ntf.battleState == 2);
			//					ApplicationData.singleton.selfInfo.state.setFlagByName(UserStateDef.BASE_PVE, ntf.battleState == 3);
			//					ApplicationData.singleton.selfInfo.dispatchRoleStateUpdate();
			//				}
			//			}
			//			if(ntf.hasShowNinjaId)
			//			{
			//				pv.getData().ninja = ntf.showNinjaId;
			//			}
			if(fightStateList.length != 0)
			{
				pvpFiledModel = this.plugin.retrieveModel(ModelDef.BATTLE_FILE_MODEL) as BasePvpFieldModel;
				if(pvpFiledModel){pvpFiledModel.dispathFightStateUpdate(fightStateList)}
			}
		}
		
		private function syncPlayerData(pd:PlayerData, pi:ProtoPlayerShowInfo):void
		{
			if(pi.hasName)
			{
				pd.name = pi.name;
			}
			
			if(pi.hasNinja)
			{
				pd.ninja = pi.ninja;
			}
			
			if(pi.hasFashionNinja)
			{
				pd.fashionNinja = pi.fashionNinja;
			}
			
			if(pi.hasShowNinja)
			{
				pd.showNinja = pi.showNinja;
			}
			
			if(pi.hasIsFight)
			{
				pd.isFighting = pi.isFight;
			}
			
			if(pi.hasLevel)
			{
				pd.level = pi.level;
			}
			
			if(pi.hasVipLevel)
			{
				pd.vip = pi.vipLevel;
			}
			
			if (pi.hasTitleId)
			{
				pd.title = (plugin.retrieveModel(ModelDef.TITLE) as TitleModel).getTitle(pi.titleId);
			}
			
			if(pi.hasTaskSign)
			{
				pd.taskSign = pi.taskSign;
			}
		}
		
		private function get battleModel():BattleInfo
		{
			return plugin.retrieveModel(ModelDef.BATTLE) as BattleInfo;
		}
		
		private var _playerModel:PlayerModel;
		private function get playerModel():PlayerModel
		{
			this._playerModel = this._playerModel || plugin.retrieveModel(PlayerModel.NAME) as PlayerModel;
			return this._playerModel;
		}
	}
}