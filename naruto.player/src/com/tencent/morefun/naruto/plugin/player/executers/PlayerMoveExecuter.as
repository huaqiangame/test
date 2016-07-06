package com.tencent.morefun.naruto.plugin.player.executers
{
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.framework.base.CommandEvent;
	import com.tencent.morefun.naruto.base.def.GlobelModelKeyDef;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.player.commands.RequestSelfMoveToCommand;
	import com.tencent.morefun.naruto.plugin.player.datas.SpecialMoveData;
	import com.tencent.morefun.naruto.plugin.player.events.WalkablePlayerEvent;
	import com.tencent.morefun.naruto.plugin.player.models.PlayerModel;
	import com.tencent.morefun.naruto.plugin.player.players.BaseWalkablePlayer;
	import com.tencent.morefun.naruto.plugin.player.views.PlayerView;
	import com.tencent.morefun.naruto.util.StateInfo;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import base.ApplicationData;
	import base.NarutoExecuter;
	
	import battle.command.RequestPvpFightStartCommand;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	
	import map.command.HideMoveTargetUiCommand;
	import map.command.ShowMoveTargetUiCommand;
	import map.commands.FindPathMapCommand;
	import map.commands.GetPixelBlockCommand;
	import map.def.ShortenPathType;
	
	import npc.commands.CheckPathCrossObstacleCommand;
	import npc.commands.ContactNpcCommand;
	import npc.commands.FindCrossBlockNpcsCommand;
	import npc.commands.FindPortalToSceneCommand;
	import npc.commands.GetNpcPositionCommand;
	import npc.commands.GetNpcWalkableCommand;
	
	import player.commands.CheckMoveToNextSceneCommand;
	import player.commands.CrossSceneGotoNpcCommand;
	import player.commands.CrossSceneGotoPixelPointCommand;
	import player.commands.HideAutoFindingAniCommand;
	import player.commands.PlayerJumpCommand;
	import player.commands.SelfMoveToNpcCommand;
	import player.commands.SelfMoveToPixcelCommand;
	import player.commands.SelfMoveToPlayerCommand;
	import player.commands.ShowAutoFindingAniCommand;
	import player.commands.StopCrossBlockCommand;
	import player.commands.StopCrossSceneCommand;
	import player.commands.StopSelfMoveCommand;
	
	import serverProto.fight.FightStartType;
	
	import task.datas.TaskTrackPanelDoingData;
	
	import team.data.TeamMemberData;
	import team.model.TeamModel;
	
	import user.def.UserStateDef;
	
	import world.command.FindCrossScenePathCommand;
	
	public class PlayerMoveExecuter extends NarutoExecuter
	{
		private var currentMoveCmd:SelfMoveToPixcelCommand;
		private var crossScenePath:Array;  //跨场景寻路时的路径，数组元素是场景id
		private var crossSceneGotoNpcCommand:CrossSceneGotoNpcCommand;  //跨场景寻路到NPC的命令;
		private var crossSceneGotoPixelPointCommand:CrossSceneGotoPixelPointCommand; //跨场景寻路到像素点的命令
		private var crossBlockNpcs:Array; //跨区域寻路时，要经过的一系列NPC，数组元素是ropeNpc或者portalNpc的id
		private var crossBlockMoveCmd:SelfMoveToPixcelCommand;  //跨区域寻路到像素点的命令
		
		
		public function PlayerMoveExecuter()
		{
			super(PluginDef.PLAYER, ExecuterDef.PLAYER_MOVE);
			
			playerModel.selfPlayer.addEventListener(WalkablePlayerEvent.MOVE_FINISH, onSelfMoveFinish);
			ApplicationData.singleton.globelInfo.addEventListener(ModelEvent.UPDATE, onGlobelUpdate);
		}
		
		override public function doCommand(cmd:Command):void
		{
			switch(true)
			{
				case cmd is SelfMoveToPixcelCommand:
					if (!inSameBlock((cmd as SelfMoveToPixcelCommand).pixcel, ApplicationData.singleton.selfInfo.getPosition()))
					{
						tryCrossBlockTo((cmd as SelfMoveToPixcelCommand).pixcel, cmd as SelfMoveToPixcelCommand);
					}
					else
					{
						doSelfMoveToPixcelCommand(cmd as SelfMoveToPixcelCommand);
					}
					break;
				case cmd is SelfMoveToNpcCommand:
					doSelfMoveToNpcCommand(cmd as SelfMoveToNpcCommand);
					break;
				
				case cmd is SelfMoveToPlayerCommand:
					doSelfMoveToPlayerCommand(cmd as SelfMoveToPlayerCommand);
					break;
				
				case cmd is StopSelfMoveCommand:
					doStopSelfMoveCommand(cmd as StopSelfMoveCommand);
					break;
				
				case cmd is CrossSceneGotoNpcCommand:
					crossSceneGotoNpc(cmd as CrossSceneGotoNpcCommand);
					break;
				
				case cmd is CrossSceneGotoPixelPointCommand:
					crossSceneGotoPixelPoint(cmd as CrossSceneGotoPixelPointCommand);
					break;
				
				case cmd is StopCrossSceneCommand:
					stopMoveAcrossScene();
					break;
				
				case cmd is PlayerJumpCommand:
					jump(cmd as PlayerJumpCommand);
					break;
				
				case cmd is CheckMoveToNextSceneCommand:
					checkMoveToNextScene();
					break;
				
				case cmd is StopCrossBlockCommand:
					stopMoveAcrossBlock();
					break;
			}
		}
		
		private function doSelfMoveToPixcelCommand(cmd:SelfMoveToPixcelCommand):void
		{
			var playerView:PlayerView;
			if (playerModel.hasFollowPlayer)
			{
				playerView = playerModel.followLeader;
			}
			else
			{
				playerView = playerModel.selfPlayer;
			}
			
			var state:StateInfo = ApplicationData.singleton.selfInfo.state;
			
			//玩家正在跳跃过程中不响应移动命令
			if (state.getFlagByName(UserStateDef.BASE_JUMPING))
			{
				cmd.faild(1);
				return;
			}
			
			var beginPoint:Point = new Point(playerView.x, playerView.y);
			var findPathCMD:FindPathMapCommand = new FindPathMapCommand(beginPoint, cmd.pixcel, cmd.shorten, cmd.shortenType);
			findPathCMD.call();
			if(findPathCMD.ecode == 0)
			{
				if(findPathCMD.resultPixcels && findPathCMD.resultPixcels.length>0)
				{
					findPathCMD.resultPixcels[0] = beginPoint;   //把第一个像素点换成起点像素点，因为不换的话，第一个点是网格中心像素点，与玩家所处的像素点不一样，这在判断是否经过障碍的时候会有误差
					if (crossObstacle(findPathCMD, cmd))
					{
						return;
					}
					var targetPoint:Point = findPathCMD.resultPixcels[findPathCMD.resultPixcels.length-1];
					new ShowMoveTargetUiCommand(targetPoint.x,targetPoint.y).call();
					//如果只有一个点，，那就不发了，，因为正常的协议，至少需要2个点，当前点（起始点）+目标点
					if(findPathCMD.resultPixcels.length>1)
					{
						new RequestSelfMoveToCommand(beginPoint,findPathCMD.resultPixcels).call();
					}
					
					//					var selfMovePixcels:Array = findPathCMD.resultPixcels.concat();
					//					selfMovePixcels.shift();
					//					playerView.moveTo(selfMovePixcels);
					if (currentMoveCmd)
					{
						currentMoveCmd.faild(1);
						currentMoveCmd = null;
					}
					currentMoveCmd = cmd;
					playerView.moveTo(findPathCMD.resultPixcels.concat());
				}else
				{
					cmd.finish();
				}
			}else
			{
				cmd.faild(1);
			}
		}
		
		private function doSelfMoveToNpcCommand(cmd:SelfMoveToNpcCommand):void
		{
			var selfPoint:Point = new Point(playerModel.selfPlayer.x, playerModel.selfPlayer.y);
			var getNpcPositionCmd:GetNpcPositionCommand = new GetNpcPositionCommand(cmd.npcId,cmd.useListId);
			var getNpcWalkableCmd:GetNpcWalkableCommand = new GetNpcWalkableCommand(cmd.npcId,cmd.useListId);
			var selfMoveToPixelCmd:SelfMoveToPixcelCommand;
			
			var state:StateInfo = ApplicationData.singleton.selfInfo.state;
			
			//玩家正在跳跃过程中不响应移动命令
			if (state.getFlagByName(UserStateDef.BASE_JUMPING))
			{
				cmd.faild(1);
				return;
			}
			
			getNpcPositionCmd.call();
			getNpcWalkableCmd.call();
			if (getNpcPositionCmd.ecode == 0)
			{
				selfMoveToPixelCmd = new SelfMoveToPixcelCommand(getNpcPositionCmd.position, cmd.shorten, cmd.shortenType);
				cmd.addSubCommand(selfMoveToPixelCmd);
				selfMoveToPixelCmd.addEventListener(CommandEvent.FINISH, onMoveToPixelFinish);
				selfMoveToPixelCmd.call();
			}
			else
			{
				cmd.faild(1);
			}
			
			function onMoveToPixelFinish(evt:Event):void
			{
				var dist:Number;
				var currNpcPoint:Point;
				var subMoveCommand:SelfMoveToPixcelCommand = evt.target as SelfMoveToPixcelCommand;
				var contactNpcCmd:ContactNpcCommand;
				subMoveCommand.removeEventListener(CommandEvent.FINISH, onMoveToPixelFinish);
				
				if (getNpcWalkableCmd.walkable)
				{
					getNpcPositionCmd.call();
					currNpcPoint = getNpcPositionCmd.position;
					dist= Point.distance(currNpcPoint, subMoveCommand.pixcel);
					
					if(dist <= (cmd.shorten + 32))  //32是留一定的误差，32是网格的宽度
					{
						onArriveNpc(cmd);
					}
					else
					{
						subMoveCommand = new SelfMoveToPixcelCommand(getNpcPositionCmd.position, cmd.shorten, cmd.shortenType);
						cmd.addSubCommand(selfMoveToPixelCmd);
						subMoveCommand.addEventListener(CommandEvent.FINISH, onMoveToPixelFinish);
						subMoveCommand.call();
					}
				}
				else
				{
					onArriveNpc(cmd);
				}
			}
		}
		
		private function doSelfMoveToPlayerCommand(cmd:SelfMoveToPlayerCommand):void
		{
			var playerView:PlayerView;
			var playerPoint:Point;
			var selfMoveToPixelCmd:SelfMoveToPixcelCommand;
			var selfPoint:Point = new Point(playerModel.selfPlayer.x, playerModel.selfPlayer.y);
			
			playerView = playerModel.getPlayer(cmd.uin, cmd.roleId, cmd.svrId);
			
			if(playerView == null)
			{
				return ;
			}
			
			playerPoint = new Point(playerView.x, playerView.y);
			
			selfMoveToPixelCmd = new SelfMoveToPixcelCommand(playerPoint, 100);
			cmd.addSubCommand(selfMoveToPixelCmd);
			selfMoveToPixelCmd.addEventListener(CommandEvent.FINISH, onMoveToPixelFinish);
			selfMoveToPixelCmd.call();
			
			function onMoveToPixelFinish(evt:Event):void
			{
				var subMoveCommand:SelfMoveToPixcelCommand = evt.target as SelfMoveToPixcelCommand;
				
				subMoveCommand.removeEventListener(CommandEvent.FINISH, onMoveToPixelFinish);
				onArrivePlayer(cmd);
			}
		}
		
		private function onArriveNpc(cmd:SelfMoveToNpcCommand):void
		{
			var contactNpcCmd:ContactNpcCommand;
			
			if (cmd.autoClick)
			{
				contactNpcCmd = new ContactNpcCommand(cmd.npcId,cmd.useListId);
				(cmd.waitClickFinish) && (cmd.addSubCommand(contactNpcCmd));
				contactNpcCmd.call();
			}
			cmd.finish();
		}
		
		private function onArrivePlayer(cmd:SelfMoveToPlayerCommand):void
		{
			var playerView:PlayerView;
			
			cmd.finish();
			
			playerView = playerModel.getPlayer(cmd.uin, cmd.roleId, cmd.svrId);
			if(playerView && playerView.getData().camp != ApplicationData.singleton.selfInfo.camp)
			{
				if(playerView.getData().isDead == false)
				{
					new RequestPvpFightStartCommand(cmd.uin, cmd.roleId, cmd.svrId, 0, FightStartType.FIGHT_START_TYPE_BATTLE_ROYALE).call();
				}
			}
			
		}
		
		private function doStopSelfMoveCommand(cmd:StopSelfMoveCommand):void
		{
			if(playerModel.hasFollowPlayer)
			{
				playerModel.stopAllSelfFollowPlayerMove();
			}
			(cmd.stopCrossScene) && (stopMoveAcrossScene());
			(cmd.stopCrossBlock) && (stopMoveAcrossBlock());
			
			
			
			var selfPoint:Point = selfInfo.getPosition();
			if(ApplicationData.singleton.selfInfo.state.getFlagByName(UserStateDef.BASE_JUMPING))
			{
				playerModel.selfPlayer.stopMoveWithJumping();
				var specialMoveDatas:Vector.<SpecialMoveData> = playerModel.selfPlayer.getSpecialMoveDatas();
				if(specialMoveDatas.length)
				{
					selfPoint = specialMoveDatas[0].endPoint;
				}
			}else
			{
				playerModel.selfPlayer.stopMove();
				if(teamModel.isJoined)
				{
					for each(var tmd:TeamMemberData in teamModel.members)
					{
						var pv:PlayerView = playerModel.getGroupPlayer(tmd.uin, tmd.roleId, tmd.svrId);
						if(pv)
						{
							pv.stopMove();
						}
					}
				}
			}
			if(cmd.needSendStop)
			{
				if(ApplicationData.singleton.globelInfo.sceneToId && ApplicationData.singleton.globelInfo.sceneToId != ApplicationData.singleton.globelInfo.sceneId)
				{
					//如果正在跨场景，那么就不应该请求停止操作，因为这个时候，后台已经是新的地图了，而这里的selfPoint还是老的地图
					//从而会导致别人在下个场景收到上个场景的坐标，导致坐标错乱
				}else
				{
					new RequestSelfMoveToCommand(selfPoint,[selfPoint]).call();
				}
			}
			
			new HideMoveTargetUiCommand().call();
			new HideAutoFindingAniCommand().call();
		}
		
		private function onSelfMoveFinish(evt:WalkablePlayerEvent):void
		{
			new HideMoveTargetUiCommand().call();
			new HideAutoFindingAniCommand().call();
			if (currentMoveCmd)
			{
				currentMoveCmd.finish();
				currentMoveCmd = null;
			}
		}
		
		private function crossSceneGotoPixelPoint(command:CrossSceneGotoPixelPointCommand):void
		{
			var findCrossScenePathCmd:FindCrossScenePathCommand;
			
			crossSceneGotoPixelPointCommand = command;
			findCrossScenePathCmd = new FindCrossScenePathCommand(ApplicationData.singleton.globelInfo.sceneId, command.sceneId);
			findCrossScenePathCmd.call();
			crossScenePath = findCrossScenePathCmd.scenePath;
			checkMoveToNextScene();
		}
		
		
		private function crossSceneGotoNpc(command:CrossSceneGotoNpcCommand):void
		{
			var findCrossScenePathCmd:FindCrossScenePathCommand;
			
			crossSceneGotoNpcCommand = command;
			findCrossScenePathCmd = new FindCrossScenePathCommand(ApplicationData.singleton.globelInfo.sceneId, command.sceneId);
			findCrossScenePathCmd.call();
			crossScenePath = findCrossScenePathCmd.scenePath;
			checkMoveToNextScene();
		}
		
		private function stopMoveAcrossScene():void
		{
			TaskTrackPanelDoingData.href = null;
			crossScenePath = null;
			crossSceneGotoNpcCommand = null;
			crossSceneGotoPixelPointCommand = null;
		}
		
		private function stopMoveAcrossBlock():void
		{
			crossBlockNpcs = null;
			crossBlockMoveCmd = null;
		}
		
		public function checkMoveToNextScene():void
		{
			var nextSceneId:int;
			var nextPixelPoint:Point;
			var moveToNpcCommand:SelfMoveToNpcCommand;
			var moveToPixelCommand:SelfMoveToPixcelCommand;
			var findPortalToSceneCommand:FindPortalToSceneCommand;
			
			if (crossScenePath && crossScenePath.length != 0)
			{
				new ShowAutoFindingAniCommand().call();
				nextSceneId = crossScenePath.shift();
				findPortalToSceneCommand = new FindPortalToSceneCommand(nextSceneId);
				findPortalToSceneCommand.call();
				moveToNpcCommand = new SelfMoveToNpcCommand(findPortalToSceneCommand.portalId, 0);  //调这个命令就是跑到传送门并请求传送
				if(crossSceneGotoPixelPointCommand != null) 
				{
					crossSceneGotoPixelPointCommand.addSubCommand(moveToNpcCommand);
				}
				if(crossSceneGotoNpcCommand != null)
				{
					crossSceneGotoNpcCommand.addSubCommand(moveToNpcCommand);
				}
				moveToNpcCommand.call();
				return;
			}
			
			if (crossSceneGotoPixelPointCommand)
			{
				new ShowAutoFindingAniCommand().call();
				nextPixelPoint = crossSceneGotoPixelPointCommand.point;
				moveToPixelCommand = new SelfMoveToPixcelCommand(nextPixelPoint);
				crossSceneGotoPixelPointCommand.addSubCommand(moveToPixelCommand);
				crossSceneGotoPixelPointCommand.finish();
				moveToPixelCommand.call();
				crossSceneGotoPixelPointCommand = null;
				return;
			}
			
			if (crossSceneGotoNpcCommand)
			{
				if (crossSceneGotoNpcCommand.npcId != 0)
				{
					new ShowAutoFindingAniCommand().call();
					moveToNpcCommand = new SelfMoveToNpcCommand(crossSceneGotoNpcCommand.npcId, crossSceneGotoNpcCommand.shorten, crossSceneGotoNpcCommand.useListId, crossSceneGotoNpcCommand.autoClick);
					crossSceneGotoNpcCommand.addSubCommand(moveToNpcCommand);
					crossSceneGotoNpcCommand.finish();
					moveToNpcCommand.call();
					crossSceneGotoNpcCommand = null;
					return;
				}
				else
				{
					crossSceneGotoNpcCommand.finish();
					crossSceneGotoNpcCommand = null;
				}
				return;
			}
		}
		
		public function checkMoveToNextBlock(evt:Event = null):void
		{
			var moveToNpcCmd:SelfMoveToNpcCommand;
			var moveToPixelCmd:SelfMoveToPixcelCommand;
			
			if (evt)
			{
				moveToNpcCmd = evt.target as SelfMoveToNpcCommand;
				moveToNpcCmd.removeEventListener(CommandEvent.FINISH, checkMoveToNextBlock);
				moveToNpcCmd.removeEventListener(CommandEvent.FAILD, checkMoveToNextBlock);
			}
			
			if (crossBlockNpcs && crossBlockNpcs.length > 0)
			{
				moveToNpcCmd = new SelfMoveToNpcCommand(crossBlockNpcs.shift() as int, 0, false, true, true);
				moveToNpcCmd.addEventListener(CommandEvent.FINISH, checkMoveToNextBlock);
				moveToNpcCmd.addEventListener(CommandEvent.FAILD, checkMoveToNextBlock);
				moveToNpcCmd.call();
			}
			else if (crossBlockMoveCmd)
			{
				moveToPixelCmd = crossBlockMoveCmd;
				stopMoveAcrossBlock();
				moveToPixelCmd.call();
			}
		}
		
		private function onGlobelUpdate(evt:ModelEvent):void
		{
			switch(evt.key)
			{
				case GlobelModelKeyDef.SCENE_ID:
					if(teamModel.isJoined)
					{
						return;
					}
					checkMoveToNextScene();
					break;
			}
		}
		
		/**
		 * 跳跃
		 */
		private function jump(cmd:PlayerJumpCommand):void
		{
			var playerView:BaseWalkablePlayer;
			if(selfInfo.equeal(cmd.uin, cmd.roleId, cmd.svrId))
			{
				playerView = playerModel.selfPlayer;
			}else
			{
				playerView = playerModel.getPlayer(cmd.uin, cmd.roleId, cmd.svrId);
			}
			playerView.specialMoveTo(new Point(playerView.x,playerView.y),cmd.location,SpecialMoveData.JUMP,function():void{
				cmd.finish();
			});
		}
		
		private function inSameBlock(pointOne:Point, pointTwo:Point):Boolean
		{
			var pointOneBlock:int;
			var pointTwoBlock:int;
			var getPixelBlockCmd:GetPixelBlockCommand;
			
			getPixelBlockCmd = new GetPixelBlockCommand(pointOne);
			getPixelBlockCmd.call();
			pointOneBlock = getPixelBlockCmd.block;
			
			getPixelBlockCmd = new GetPixelBlockCommand(pointTwo);
			getPixelBlockCmd.call();
			pointTwoBlock = getPixelBlockCmd.block;
			
			if ((pointOneBlock != -1) && (pointTwoBlock != -1))
			{	
				return (pointOneBlock == pointTwoBlock);
			}
			return true;
		}
		
		private function tryCrossBlockTo(toPixel:Point, cmd:SelfMoveToPixcelCommand):void
		{
			var findCrossBlockNpcsCmd:FindCrossBlockNpcsCommand;
			
			findCrossBlockNpcsCmd = new FindCrossBlockNpcsCommand(ApplicationData.singleton.selfInfo.getPosition(), toPixel);
			findCrossBlockNpcsCmd.call();
			
			if (findCrossBlockNpcsCmd.npcIds && findCrossBlockNpcsCmd.npcIds.length > 0)
			{
				crossBlockNpcs = findCrossBlockNpcsCmd.npcIds;
				crossBlockMoveCmd = cmd;
				checkMoveToNextBlock();
			}
			else
			{
				cmd.faild(0);
			}
		}
		
		//		private function tryCrossBlockTo(toPixel:Point, cmd:SelfMoveToPixcelCommand):void
		//		{
		//			var findNearestRopeCmd:FindNearestRopeCommand;
		//			var selfMoveToNpcCommand:SelfMoveToNpcCommand;
		//			var findCrossBlockPortalCommand:FindCrossBlockPortalCommand;
		//			
		//			findNearestRopeCmd = new FindNearestRopeCommand(ApplicationData.singleton.selfInfo.getPosition(), toPixel);
		//			findNearestRopeCmd.call();
		//			
		//			if (findNearestRopeCmd.ropeNpcId != -1)
		//			{
		//				selfMoveToNpcCommand = new SelfMoveToNpcCommand(findNearestRopeCmd.ropeNpcId, 0, false, true, true);
		//				selfMoveToNpcCommand.addEventListener(CommandEvent.FINISH, onFinishCrossBlock);
		//				selfMoveToNpcCommand.call();
		//			}
		//			else
		//			{
		//				findCrossBlockPortalCommand = new FindCrossBlockPortalCommand(ApplicationData.singleton.selfInfo.getPosition(), toPixel);
		//				findCrossBlockPortalCommand.call();
		//				if (findCrossBlockPortalCommand.portalId != -1)
		//				{
		//					selfMoveToNpcCommand = new SelfMoveToNpcCommand(findCrossBlockPortalCommand.portalId, 0, false, true, true);
		//					selfMoveToNpcCommand.addEventListener(CommandEvent.FINISH, onFinishCrossBlock);
		//					selfMoveToNpcCommand.call();
		//				}
		//				else
		//				{
		//					cmd.faild(0);
		//				}
		//			}
		//			
		//			function onFinishCrossBlock(evt:CommandEvent):void
		//			{
		//				selfMoveToNpcCommand.removeEventListener(CommandEvent.FINISH, onFinishCrossBlock);
		//				cmd.call();
		//			}
		//		}
		
		private function crossObstacle(findPathCMD:FindPathMapCommand, cmd:SelfMoveToPixcelCommand):Boolean
		{
			var checkPathCrossObstacleCommand:CheckPathCrossObstacleCommand;
			var selfMoveToNpcCommand:SelfMoveToNpcCommand;
			
			checkPathCrossObstacleCommand = new CheckPathCrossObstacleCommand(findPathCMD.resultPixcels);
			checkPathCrossObstacleCommand.call();
			
			if (checkPathCrossObstacleCommand.obstacleNpcId != -1)
			{
				selfMoveToNpcCommand = new SelfMoveToNpcCommand(checkPathCrossObstacleCommand.obstacleNpcId, checkPathCrossObstacleCommand.obstacleRadius, false, true, true, ShortenPathType.CEIL);
				selfMoveToNpcCommand.addEventListener(CommandEvent.FINISH, onMoveToObstacleFinish);
				selfMoveToNpcCommand.call();
				return true;
			}
			
			return false;
			
			function onMoveToObstacleFinish(evt:CommandEvent):void
			{
				selfMoveToNpcCommand.removeEventListener(CommandEvent.FINISH, onMoveToObstacleFinish);
				cmd.call();
			}
		}
		
		
		private var _playerModel:PlayerModel;
		private function get playerModel():PlayerModel
		{
			this._playerModel = this._playerModel || plugin.retrieveModel(PlayerModel.NAME) as PlayerModel;
			return this._playerModel;
		}
		private function get teamModel():TeamModel
		{
			return plugin.retrieveModel(ModelDef.TEAM) as TeamModel;
		}
	}
}