package com.tencent.morefun.naruto.plugin.player.executers
{
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.player.datas.PlayerGroupData;
	import com.tencent.morefun.naruto.plugin.player.models.PlayerModel;
	import com.tencent.morefun.naruto.plugin.player.views.AutoFindingAniView;
	import com.tencent.morefun.naruto.plugin.player.views.PlayerView;
	import com.tencent.morefun.naruto.plugin.player.views.SelfPlayerView;
	
	import flash.geom.Point;
	
	import base.ApplicationData;
	import base.NarutoExecuter;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	
	import map.commands.AddMapElementCommand;
	import map.commands.BindCameraMapElementCommand;
	import map.def.MapLayerDef;
	import map.element.BaseMapElement;
	
	import npc.commands.GetNpcPositionCommand;
	
	import player.commands.CheckPlayerAllowPromptCommand;
	import player.commands.CleanPlayerCommand;
	import player.commands.ClearPvpFieldPlayerStateCommand;
	import player.commands.GetAllLeaderPlayerDataCommand;
	import player.commands.GetLeaderPlayerDataCommand;
	import player.commands.GetOtherPlayersBodyVisibleCommand;
	import player.commands.GetPlayerNinjaCommand;
	import player.commands.GetPlayerTeamMemberNumCommand;
	import player.commands.HideAutoFindingAniCommand;
	import player.commands.LadePlayerCommand;
	import player.commands.RequestGetPlayerViewListCommand;
	import player.commands.SelectPlayerCommand;
	import player.commands.SetAllLeaderPlayerPosAndDirCommand;
	import player.commands.SetLeaderPlayerPosAndDirCommand;
	import player.commands.SetOtherPlayersBodyVisibleCommand;
	import player.commands.SetSelfPlayerPosAndDirCommand;
	import player.commands.ShowAutoFindingAniCommand;
	import player.commands.ShowPlayerDialogCommand;
	import player.commands.ShowPlayerLevelUpCommand;
	import player.commands.ShowSmileyPlayerCommand;
	import player.commands.StopSelfMoveCommand;
	import player.commands.UpdatePlayerCampCommand;
	import player.commands.UpdatePlayerDeadCommand;
	import player.commands.UpdateWinStreakTimeCommand;
	import player.datas.PlayerData;
	
	import task.datas.TaskConditionCfg;
	import task.datas.TaskInfo;
	import task.defs.TaskTypeDef;
	import task.models.TaskModel;
	
	import team.model.TeamModel;
	
	import ui.command.SetSelectedPlayerCommand;
	
	import user.def.UserStateDef;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class PlayerViewExecuter extends NarutoExecuter
	{
		public function PlayerViewExecuter()
		{
			super(PluginDef.PLAYER, ExecuterDef.PLAYER_VIEW);
			
			playerModel.selfPlayer = new SelfPlayerView();
			playerModel.selfPlayer.setData(selfInfo);
			
			addSelfStateListener(UserStateDef.INTERRUPT_ACTION_WALK,onInterrupt);
			addSelfStateListener(UserStateDef.BASE_PVE, onFightStateChanged);
			addSelfStateListener(UserStateDef.BASE_PVP, onFightStateChanged);
			taskModel.addEventListener(ModelEvent.UPDATE, onTaskModel);
		}
		
		protected function onTaskModel(event:ModelEvent):void
		{
			switch(event.key)
			{
				case TaskModel.KEY_TASK_INFOS:
				case TaskModel.KEY_TASK_INFO_REMOVE:
				case TaskModel.KEY_TASK_INFO_GIVEUP:
				case TaskModel.KEY_TASK_INFO_COMMIT:
				case TaskModel.KEY_TASK_INFO_RECEIVE:
					new CheckPlayerAllowPromptCommand().call();
					break;
			}
		}
		
		private function onInterrupt():void
		{
			if(selfInfo.state.getFlagByName(UserStateDef.INTERRUPT_ACTION_WALK))
			{
				if (selfInfo.state.getFlagByName(UserStateDef.BASE_WALK))
				{
					new StopSelfMoveCommand().call();
				}
			}
		}
		
		private function onFightStateChanged():void
		{
			playerModel.selfPlayer.getData().isFighting = ApplicationData.singleton.selfInfo.isBattling;
		}
		
		override public function doCommand(cmd:Command):void
		{
			switch(true)
			{
				case cmd is LadePlayerCommand:
					doLadePlayerCommand(cmd as LadePlayerCommand);
					break;
				case cmd is CleanPlayerCommand:
					doCleanPlayerCommand(cmd as CleanPlayerCommand)
					break;
				case cmd is ShowSmileyPlayerCommand:
					doShowSmileyPlayerCommand(cmd as ShowSmileyPlayerCommand);
					break;
				
				
				
				case cmd is SetLeaderPlayerPosAndDirCommand:
					doSetLeaderPlayerPosAndDirCommand(cmd as SetLeaderPlayerPosAndDirCommand);
					break;
				case cmd is GetLeaderPlayerDataCommand:
					doGetLeaderPlayerDataCommand(cmd as GetLeaderPlayerDataCommand);
					break;
				case cmd is SetAllLeaderPlayerPosAndDirCommand:
					doSetAllLeaderPlayerPosAndDirCommand(cmd as SetAllLeaderPlayerPosAndDirCommand);
					break;
				case cmd is GetAllLeaderPlayerDataCommand:
					doGetAllLeaderPlayerDataCommand(cmd as GetAllLeaderPlayerDataCommand);
					break;
				
				
				
				case cmd is SetSelfPlayerPosAndDirCommand:
					doSetSelfPlayerPosAndDirCommand(cmd as SetSelfPlayerPosAndDirCommand);
					break;
				
				

                case cmd is ShowPlayerLevelUpCommand:
					doShowPlayerLevelUpCommand(cmd as ShowPlayerLevelUpCommand);
                    break;
				
				case cmd is ShowAutoFindingAniCommand:
					doShowAutoFindingAniCommand(cmd as ShowAutoFindingAniCommand);
					break;
				case cmd is HideAutoFindingAniCommand:
					doHideAutoFindingAniCommand(cmd as HideAutoFindingAniCommand);
					break;
				
				
				case cmd is SetOtherPlayersBodyVisibleCommand:
					doSetOtherPlayersBodyVisibleCommand(cmd as SetOtherPlayersBodyVisibleCommand);
					break;
				case cmd is GetOtherPlayersBodyVisibleCommand:
					doGetOtherPlayersBodyVisibleCommand(cmd as GetOtherPlayersBodyVisibleCommand);
					break;
				
				case cmd is SelectPlayerCommand:
					doSelectPlayerCommand(cmd as SelectPlayerCommand);
					break;
				case cmd is GetPlayerTeamMemberNumCommand:
					doGetPlayerTeamMemberNumCommand(cmd as GetPlayerTeamMemberNumCommand);
					break;
				
				case cmd is ShowPlayerDialogCommand:
					doShowPlayerDialogCommand(cmd as ShowPlayerDialogCommand);
					break;
				
				case cmd is UpdatePlayerDeadCommand:
					playerModel.updateDeadState((cmd as UpdatePlayerDeadCommand).uin, (cmd as UpdatePlayerDeadCommand).roleId, (cmd as UpdatePlayerDeadCommand).svrId, (cmd as UpdatePlayerDeadCommand).isDead);
					break;
				case cmd is UpdatePlayerCampCommand:
					playerModel.updateCampState((cmd as UpdatePlayerCampCommand).uin, (cmd as UpdatePlayerCampCommand).roleId, (cmd as UpdatePlayerCampCommand).svrId, (cmd as UpdatePlayerCampCommand).camp);
					break;
				case cmd is UpdateWinStreakTimeCommand:
					playerModel.updateWinStreakTime((cmd as UpdateWinStreakTimeCommand).uin, (cmd as UpdateWinStreakTimeCommand).roleId, (cmd as UpdateWinStreakTimeCommand).svrId, (cmd as UpdateWinStreakTimeCommand).winStreakTime);
					break;
				case cmd is ClearPvpFieldPlayerStateCommand:
					playerModel.clearCampState();
					playerModel.clearDeadState();
					playerModel.clearWinStreakTime();
					break;
				
				case cmd is GetPlayerNinjaCommand:
					doGetPlayerNinjaCommand(cmd as GetPlayerNinjaCommand);
					break;
				case cmd is CheckPlayerAllowPromptCommand:
					//doCheckPlayerAllowPromptCommand(cmd as CheckPlayerAllowPromptCommand);
					cmd.faild();
					break;
			}
		}
		
		private function doCheckPlayerAllowPromptCommand(cmd:CheckPlayerAllowPromptCommand):void
		{
			var tx:int;
			var ty:int;
			
			var taskInfos:Array = taskModel.getTaskInfosByType(TaskTypeDef.WANTED);
			if(taskInfos.length)
			{
				var ti:TaskInfo = taskInfos[0];
				if(ti.conditions.length)
				{
					var tcc:TaskConditionCfg = ti.cfg.conditions[0];
					var arr:Array = tcc.args.split(";");
					if(arr.length==2)
					{
						var sceneId:int = appData.globelInfo.sceneToId || appData.globelInfo.sceneId;
						if(sceneId == arr[0])
						{
							var cmd2:GetNpcPositionCommand = new GetNpcPositionCommand(arr[1],true);
							cmd2.call();
							if(cmd2.position)
							{
								tx = cmd2.position.x;
								ty = cmd2.position.y;
							}
						}
					}
				}
			}
			
			if(teamModel.isJoined)
			{
				var pgd:PlayerGroupData = playerModel.getGroup(teamModel.id);
				var pv:PlayerView;
				if(pgd.captain.equal2(appData.selfInfo))
				{
					pv = playerModel.selfPlayer;
				}else
				{
					pv = playerModel.getGroupPlayer(pgd.captain.uin,pgd.captain.role, pgd.captain.svrId);
				}
				if(pv)
				{
					pv.setAllowTargetPos(tx, ty);
				}
				for each(var pd:PlayerData in pgd.members)
				{
					if(pd.equal2(appData.selfInfo))
					{
						pv = playerModel.selfPlayer;
					}else
					{
						pv = playerModel.getGroupPlayer(pd.uin, pd.role, pd.svrId);
					}
					if(pv)
					{
						pv.setAllowTargetPos(tx, ty);
					}
				}
			}else
			{
				playerModel.selfPlayer.setAllowTargetPos(tx, ty);
			}
			cmd.finish();
		}
		
		private function doGetPlayerNinjaCommand(cmd:GetPlayerNinjaCommand):void
		{
			var pv:PlayerView = playerModel.getPlayer(cmd.uin, cmd.roleId, cmd.svrId);
			if(pv == null || pv.getData() == null)
			{
				pv = playerModel.getGroupPlayer(cmd.uin, cmd.roleId, cmd.svrId);
			}
			if(pv && pv.getData())
			{
				cmd.ninjaId = pv.getData().ninja;
				if(cmd.isShowNinja)
				{
					cmd.ninjaId = pv.getData().showNinja || pv.getData().ninja;
				}
			}
			cmd.finish();
		}
		
		private function doSetOtherPlayersBodyVisibleCommand(cmd:SetOtherPlayersBodyVisibleCommand):void
		{
			this.playerModel.otherPlayersBodyVisible = cmd.visible;
			cmd.finish();
		}
		
		private function doGetOtherPlayersBodyVisibleCommand(cmd:GetOtherPlayersBodyVisibleCommand):void
		{
			cmd.visible = this.playerModel.otherPlayersBodyVisible;
			cmd.finish();
		}
		
		private function doGetPlayerTeamMemberNumCommand(cmd:GetPlayerTeamMemberNumCommand):void
		{
			var pv:PlayerView = this.playerModel.getGroupPlayer(cmd.uin, cmd.roleId, cmd.serverId);
			if(pv && pv.getData().teamId)
			{
				var pgd:PlayerGroupData = playerModel.getGroup(pv.getData().teamId);
				cmd.num = pgd.members.length + 1;
			}
			cmd.finish();
		}
		
		private function doSelectPlayerCommand(cmd:SelectPlayerCommand):void
		{
			var pv:PlayerView = playerModel.getPlayer(cmd.uin, cmd.roleId, cmd.svrId);
			if(pv == null)
			{
				pv = playerModel.getGroupPlayer(cmd.uin, cmd.roleId, cmd.svrId);
			}
			if(pv != null)
			{
				new SetSelectedPlayerCommand(pv.getData()).call();
				cmd.finish();
			}else
			{
				cmd.faild();
			}
		}
		
		private function doSetAllLeaderPlayerPosAndDirCommand(cmd:SetAllLeaderPlayerPosAndDirCommand):void
		{
			if (playerModel.hasFollowPlayer)
			{
				for (var i:int = cmd.ninjiaList.length-1; i >= 0; i--)
				{
					playerModel.setSelfFollowPlayerPositionAndDir(cmd.ninjiaList[i],
						cmd.positionXList[i],
						cmd.positionYList[i],
						cmd.directionList[i]);
				}
			}
			cmd.finish();
		}
		
		private function doSetLeaderPlayerPosAndDirCommand(cmd:SetLeaderPlayerPosAndDirCommand):void
		{
			var leader:PlayerView = this.playerModel.followLeader;
			if (leader)
			{
				if (cmd.position)
				{
					this.playerModel.setSelfFollowPlayerPositionAndDir(leader.getData().ninja, cmd.position.x, cmd.position.y, cmd.direction);
				}
				else
				{
					var position:Point = leader.getData().getPosition();
					this.playerModel.setSelfFollowPlayerPositionAndDir(leader.getData().ninja, position.x, position.y, cmd.direction);
				}
			}
			cmd.finish();
		}
		
		private function doGetLeaderPlayerDataCommand(cmd:GetLeaderPlayerDataCommand):void
		{
			if (playerModel.hasFollowPlayer)
			{
				cmd.playerData = playerModel.followLeader.getData();
			}
			cmd.finish();
		}
		
		private function doGetAllLeaderPlayerDataCommand(cmd:GetAllLeaderPlayerDataCommand):void
		{
			if (playerModel.hasFollowPlayer)
			{
				var playerDataList:Vector.<PlayerData> = new Vector.<PlayerData>();
				for each (var playerView:PlayerView in this.playerModel.selfFollowPlayerList)
				{
					playerDataList.push(playerView.getData());
				}
				cmd.playerDataList = playerDataList;
			}
			cmd.finish();
		}
		
		private function doShowSmileyPlayerCommand(cmd:ShowSmileyPlayerCommand):void
		{
			if(selfInfo.equeal(cmd.uin, cmd.roleId, cmd.svrId))
			{
				playerModel.selfPlayer.showSmiley(cmd.smiley);
			}else
			{
				var playerView:PlayerView = playerModel.getPlayer(cmd.uin, cmd.roleId, cmd.svrId);
				if(playerView == null)
				{
					playerView = playerModel.getGroupPlayer(cmd.uin, cmd.roleId, cmd.svrId);
				}
				if(playerView)
				{
					playerView.showSmiley(cmd.smiley);
				}else
				{
//					throw new Error("显示表情出错，原因:未找到uin:"+cmd.uin+"的玩家");
					logger.output("[player]","[PlayerViewExecuter.doShowSmileyPlayerCommand()]",I18n.lang("as_player_1451031577_5308_0")+cmd.uin+I18n.lang("as_player_1451031577_5308_1"));
				}
			}
			cmd.finish();
		}

        private function doShowPlayerLevelUpCommand(cmd:ShowPlayerLevelUpCommand):void
        {
            if(selfInfo.equeal(cmd.uin,cmd.roleId,cmd.svrId))
            {
                playerModel.selfPlayer.showLevelUp();
            }
            else
            {
                var playerView:PlayerView = playerModel.getPlayer(cmd.uin, cmd.roleId, cmd.svrId);
                if(playerView)
                {
                    playerView.showLevelUp();
                }else
                {
//                    throw new Error("显示升级出错，原因:未找到uin:"+cmd.uin+"的玩家");
					logger.output("[player]","[PlayerViewExecuter.doShowPlayerLevelUpCommand()]",I18n.lang("as_player_1451031577_5309_0")+cmd.uin+I18n.lang("as_player_1451031577_5309_1"));
                }
            }
            cmd.finish();
        }
		
		private function doLadePlayerCommand(cmd:LadePlayerCommand):void
		{
			if(cmd.direction >= 0)
			{
				playerModel.selfPlayer.getData().direction = cmd.direction;
			}
			playerModel.selfPlayer.playIdleAction();
			playerModel.selfPlayer.setXY(cmd.position.x,cmd.position.y);
			
			new AddMapElementCommand(playerModel.selfPlayer, MapLayerDef.MIDDLE_ELEMENT).call();
			new BindCameraMapElementCommand(playerModel.selfPlayer).call();
			new RequestGetPlayerViewListCommand(true).call();
			if(cmd.leaderNinjaIds && cmd.leaderNinjaIds.length)
			{
				playerModel.setSelfFollowPlayer(cmd.leaderNinjaIds);
				for each (var follower:BaseMapElement in playerModel.selfFollowPlayerList)
				{
					new AddMapElementCommand(follower, MapLayerDef.MIDDLE_ELEMENT).call();
				}
			}
			cmd.finish();
			playerModel.selfPlayer.checkChangeShowNinja();
		}
		
		private function doCleanPlayerCommand(cmd:CleanPlayerCommand):void
		{
			playerModel.removeAllPlayers();
			playerModel.removeAllGroupPlayers();
			playerModel.removeAllGroups();
			playerModel.cleanAllSelfFollowPlayer();
			playerModel.selfPlayer.stopMove();
//			AssetDef.MME_ASSET.disposeAllAssets();
			
			cmd.finish();
		}
		
		private function doSetSelfPlayerPosAndDirCommand(cmd:SetSelfPlayerPosAndDirCommand):void
		{		
			if(!teamModel.isJoined)
			{
				if(cmd.position)
				{
					playerModel.selfPlayer.setXY(cmd.position.x, cmd.position.y);
					if(playerModel.selfPlayer.getFollowPlayer())
					{
						playerModel.selfPlayer.getFollowPlayer().setXY(cmd.position.x, cmd.position.y);
					}
				}
				if(cmd.direction != -1 && !playerModel.selfPlayer.getFollowPlayer())
				{
					playerModel.selfPlayer.getData().direction = cmd.direction;
					playerModel.selfPlayer.playIdleAction();
				}
			}else
			{
				var pgd:PlayerGroupData = playerModel.getGroup(playerModel.selfPlayer.getData().teamId);
				if(pgd)
				{
					if(cmd.position)
					{
						var pv:PlayerView;
						for each(var pd:PlayerData in pgd.members)
						{
							if(pd.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
							{
								pv = playerModel.selfPlayer;
							}else
							{
								pv = playerModel.getGroupPlayer(pd.uin, pd.role, pd.svrId);
							}
							pv.setXY(cmd.position.x, cmd.position.y);
						}
						if(pgd.captain.equeal(selfInfo.uin, selfInfo.role, selfInfo.svrId))
						{
							pv = playerModel.selfPlayer;
						}else
						{
							pv = playerModel.getGroupPlayer(pgd.captain.uin, pgd.captain.role, pgd.captain.svrId);
						}
						pv.setXY(cmd.position.x, cmd.position.y);
					}
					if(cmd.direction != -1)
					{
						pv.getData().direction = cmd.direction;
						pv.playIdleAction();
					}
				}
			}
			cmd.finish();
		}
		
		private var autoFindingAniView:AutoFindingAniView;
		private function doShowAutoFindingAniCommand(cmd:ShowAutoFindingAniCommand):void
		{
			if(autoFindingAniView == null)
			{
				autoFindingAniView = new AutoFindingAniView();
			}
			autoFindingAniView.show();
			cmd.finish();
		}
		private function doHideAutoFindingAniCommand(cmd:HideAutoFindingAniCommand):void
		{
			if(autoFindingAniView)
			{
				autoFindingAniView.hide();
			}
			cmd.finish();
		}
		
		private function doShowPlayerDialogCommand(cmd:ShowPlayerDialogCommand):void
		{
			if(selfInfo.equeal(cmd.uin, cmd.roleId, cmd.svrId))
			{
				playerModel.selfPlayer.showDialog(cmd.dialogText);
			}
			else
			{
				var playerView:PlayerView = playerModel.getPlayer(cmd.uin, cmd.roleId, cmd.svrId);
				if(playerView == null)
				{
					playerView = playerModel.getGroupPlayer(cmd.uin, cmd.roleId, cmd.svrId);
				}
				if(playerView)
				{
					playerView.showDialog(cmd.dialogText);
				}else
				{
//					throw new Error("显示对话框出错，原因:未找到uin:"+cmd.uin+"的玩家");
					logger.output("[player]","[PlayerViewExecuter.doShowPlayerDialogCommand()]",I18n.lang("as_player_1451031577_5310_0")+cmd.uin+I18n.lang("as_player_1451031577_5310_1"));
				}
			}
			cmd.finish();
		}
		
		private function get playerModel():PlayerModel
		{
			return plugin.retrieveModel(PlayerModel.NAME) as PlayerModel;
		}
		private function get teamModel():TeamModel
		{
			return plugin.retrieveModel(ModelDef.TEAM) as TeamModel;
		}
		private function get taskModel():TaskModel
		{
			return plugin.retrieveModel(ModelDef.TASK) as TaskModel;
		}
	}
}