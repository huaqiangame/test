package com.tencent.morefun.naruto.plugin.player.players
{
	import com.greensock.TweenLite;
	import com.tencent.morefun.naruto.effect.shadow.MotionShadow;
	import com.tencent.morefun.naruto.mmefile.render.MmeAsset;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRender;
	import com.tencent.morefun.naruto.mmefile.render.MmeAssetRenderEvent;
	import com.tencent.morefun.naruto.plugin.player.base.JumpRopeSimulator;
	import com.tencent.morefun.naruto.plugin.player.datas.SpecialMoveData;
	import com.tencent.morefun.naruto.plugin.player.effects.EntryEffect;
	import com.tencent.morefun.naruto.plugin.player.events.WalkablePlayerEvent;
	import com.tencent.morefun.naruto.plugin.ui.util.TimerProvider;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import map.commands.FindPathMapCommand;
	import map.commands.GetPixelWalkableCommand;
	import map.commands.ShortenPathMapCommand;
	import map.events.MapElementEvent;
	
    import com.tencent.morefun.naruto.i18n.I18n;
	public class BaseWalkablePlayer extends BasePlayer
	{
		protected var moveToPixcels:Array = []; // 要行走的路径
		protected var specialMovedMoveToPixcels:Array;//特殊移动结束后要表现的I18n.lang("as_player_1451031577_5321")
//		protected var direction:int;
		protected static const SPEED:int = 12;
		protected var currSpeed:Point = new Point();
		protected var currSpeedUp:Number = 1;
		protected var currMoveToPixcel:Point;
		protected var currPos:Point = new Point();
		
		
//		protected var _runEffectRenderer:MmeAssetRender;
		
		private var _ghost:MotionShadow;
		
		public function BaseWalkablePlayer(mmeAsset:MmeAsset)
		{
			super(mmeAsset);
			
			// 运动拖影效果
			_ghost = new MotionShadow(this);
			_ghost.frameRate = 24;
			_ghost.speed = 0.19;
			
			_ghost.gap = 35;
		}
		
		/**
		 * 在寻路中，将要到达的终点。如果无，则返回当前点。
		 */		
		private var _endPoint:Point = new Point();
		public function get endPoint():Point
		{
			if (this.moveToPixcels && this.moveToPixcels.length)
			{
				var pt:Point = this.moveToPixcels[this.moveToPixcels.length-1];
				this._endPoint.setTo(pt.x, pt.y);
			}
			else if (this.currMoveToPixcel)
			{
				this._endPoint.setTo(this.currMoveToPixcel.x, this.currMoveToPixcel.y);
			}
			else
			{
				this._endPoint.setTo(this.x, this.y);
			}
			return this._endPoint;
		}
		
		/**
		 * 走到最终点时的朝向。
		 */		
		public function get endDirection():int
		{
			var dx:int;
			var dy:int;
			var pt0:Point;
			var pt1:Point;
			if (this.moveToPixcels && this.moveToPixcels.length)
			{
				if (this.moveToPixcels.length > 1)
				{
					pt0 = this.moveToPixcels[this.moveToPixcels.length-2];
					pt1 = this.moveToPixcels[this.moveToPixcels.length-1];
					dx = pt1.x - pt0.x;
					dy = pt1.y - pt0.y;
				}
				else
				{
					pt0 = this.moveToPixcels[0];
					dx = pt0.x - this.x;
					dx = pt0.y - this.y;
				}
			}
			else
			{
				return this.data.direction;
			}
			
			var angle:Number = Math.atan2(dy, dx);
			var a360:int = angle * 180 / Math.PI;
			a360 = (a360 + 270 + 22)%360;
			var dir:int = a360 / 45;
			return dir;
		}
		
//		public function get runEffectRenderer():MmeAssetRender
//		{
//			if(_runEffectRenderer == null)
//			{
//				_runEffectRenderer = new MmeAssetRender(mmeAsset);
//				_runEffectRenderer.addEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
//				_runEffectRenderer.load(PlayerUtil.getEffectAppDomain(PlayerUtil.EFFECT_TYP_RUN));
//			}
//			return _runEffectRenderer;
//		}
		
		protected function onEffectRendererPlayEnd(event:MmeAssetRenderEvent):void
		{
			var effectRenderer:MmeAssetRender = event.currentTarget as MmeAssetRender
			if(effectRenderer && effectRenderer.parent)
			{
				effectRenderer.parent.removeChild(effectRenderer);
			}
		}
		
		override protected function initResRenderer():void
		{
			super.initResRenderer();
			
			
//			resRenderer.addEventListener(MmeAssetRenderEvent.FRAME_EVENT,onResRendererFrameEvent);
		}
		
//		protected function onResRendererFrameEvent(event:MmeAssetRenderEvent):void
//		{
//			if(!isInViewPoint)
//			{
//				return;
//			}
//			if(event.frameEvent == "touchdown")
//			{
//				addChildAt(runEffectRenderer,0);
//				if(data.direction<4)
//				{
//					runEffectRenderer.play("soot_1");
//				}else
//				{
//					runEffectRenderer.play("soot_2");
//				}
//			}
//		}
		
//		private var moveToStartTimer:uint;
		public function moveTo(moveToPixcels:Array):void
		{
//			moveToStartTimer = getTimer();
//			trace(this,"moveTo",moveToPixcels,moveToStartTimer)
			
			if(specialMoveDatas && specialMoveDatas.length>0)
			{
				//如果当前正在表现特殊动作，，那就等他表现完了特殊动作再移动
				this.specialMovedMoveToPixcels = moveToPixcels;
				return;
			}
			this.moveToPixcels = moveToPixcels || [];
			currMoveToPixcel = null;
			currPos.x = x;
			currPos.y = y;
			calcSpeedUp();
			
			if (this.hasEventListener(WalkablePlayerEvent.MOVE_START))
			{
				var e:WalkablePlayerEvent = new WalkablePlayerEvent(WalkablePlayerEvent.MOVE_START,false,true);
				e.moveToPixcels = this.moveToPixcels.concat();
				dispatchEvent(e);
				if(e.isDefaultPrevented())
				{
					return;
				}
			}
			
			//moveToPixcels.shift();
//			LayerManager.singleton.stage.removeEventListener(Event.ENTER_FRAME,onMoveEnterFrame);
//			LayerManager.singleton.stage.addEventListener(Event.ENTER_FRAME,onMoveEnterFrame,false,10);
//			addEventListener(Event.ENTER_FRAME,onMoveEnterFrame,false,-1);
//			TimerProvider.addEnterFrameTask(onMoveEnterFrame,null,10);
//			TimerProvider.removeEnterFrameTask(onMoveEnterFrame, null, 10);
			TimerProvider.addActiveEnterFrameTask(onMoveEnterFrame,null,1,10);
//			setTimeout(onMoveEnterFrame,0);
			onMoveEnterFrame();
		}
		
		protected function calcSpeedUp():void
		{
			if(moveToPixcels.length>0)
			{
				var dist:Number = (currPos.x-moveToPixcels[0].x)*(currPos.x-moveToPixcels[0].x) + (currPos.y-moveToPixcels[0].y)*(currPos.y-moveToPixcels[0].y);//    Point.distance(currPos,currMoveToPixcel);
				var delay:Number = 2 * dist * SPEED / 30;
				TweenLite.delayedCall(delay,resetSpeedUp)
			}else
			{
				TweenLite.killTweensOf(resetSpeedUp);
				currSpeedUp = 1;
			}
		}
		
		protected function resetSpeedUp():void
		{
			currSpeedUp = 1;
		}
		
		public function stopMoveWithJumping():void
		{
			stopBaseMove();
			if(specialMoveDatas.length>1)
			{
				specialMoveDatas.length = 1;
			}
		}
		
		public function stopMove():void
		{
			stopBaseMove();
			stopSpecialMove();
		}
		
		protected function stopSpecialMove():void
		{
			destroyJumpRoleSimulator();
			this.specialMoveDatas = null;
		}
		
		/**
		 * 停止基本的行走，但是不包括specialMove
		 */
		protected function stopBaseMove():void
		{
			fixUnWalkable();
			playIdleAction();
			this.moveToPixcels.length = 0;
//			LayerManager.singleton.stage.removeEventListener(Event.ENTER_FRAME,onMoveEnterFrame);
			TimerProvider.removeEnterFrameTask(onMoveEnterFrame, null, 10);
			currSpeed.x = currSpeed.y = 0;
			
			if(hasEventListener(WalkablePlayerEvent.MOVE_STOP))
			{
				dispatchEvent(new WalkablePlayerEvent(WalkablePlayerEvent.MOVE_STOP));
			}
		}
		
		protected function fixUnWalkable():void
		{
			var walkableCmd:GetPixelWalkableCommand = new GetPixelWalkableCommand(new Point());
			
			walkableCmd.pixelPoint.x = x;
			walkableCmd.pixelPoint.y = y;
			walkableCmd.call();
			var i:int;
			while (!walkableCmd.walkable)
			{
				if(i++>20)
				{
					break;
				}
				if (!currSpeed || (currSpeed.x==0 && currSpeed.y==0))
				{
					break;
				}
				setXY(x + currSpeed.x, y+ currSpeed.y);
				walkableCmd.pixelPoint.x = x;
				walkableCmd.pixelPoint.y = y;
				walkableCmd.call();
			}
		}
		
		
		protected function onFollowPlayerSpecialMove(e:WalkablePlayerEvent):void
		{
			followMoveToPixcels = null;
			specialMoveTo(e.beginPoint,e.endPoint,e.specialMoveType,null);
		}
		
		protected var specialMoveDatas:Vector.<SpecialMoveData>;
		public function specialMoveTo(beginPixcelPoint:Point, endPixcelPoint:Point, specialMoveType:int, doneFun:Function):void
		{
			var e:WalkablePlayerEvent = new WalkablePlayerEvent(WalkablePlayerEvent.SPECIAL_MOVE);
			e.beginPoint = beginPixcelPoint;
			e.endPoint = endPixcelPoint;
			e.specialMoveType = specialMoveType;
			dispatchEvent(e);
			
			if(specialMoveDatas == null)
			{
				specialMoveDatas = new Vector.<SpecialMoveData>;
			}
			var smd:SpecialMoveData = new SpecialMoveData(beginPixcelPoint,endPixcelPoint,specialMoveType, doneFun);
			specialMoveDatas.push(smd);
			if(specialMoveDatas.length==1)
			{
				doSpecialMove();
			}
		}
		public function getSpecialMoveDatas():Vector.<SpecialMoveData>
		{
			return specialMoveDatas;
		}
		
		protected function doSpecialMove():void
		{
			if(specialMoveDatas && specialMoveDatas.length>0)
			{
				addEventListener(WalkablePlayerEvent.MOVE_FINISH,doSpecialMove__onMoveFinish);
//				moveTo([new Point(x,y),specialMoveDatas[0].beginPoint]);
				this.moveToPixcels = [specialMoveDatas[0].beginPoint];
				currMoveToPixcel = null;
				currPos.x = x;
				currPos.y = y;
//				LayerManager.singleton.stage.removeEventListener(Event.ENTER_FRAME,onMoveEnterFrame);
//				LayerManager.singleton.stage.addEventListener(Event.ENTER_FRAME,onMoveEnterFrame);
//				TimerProvider.addEnterFrameTask(onMoveEnterFrame, null, 10);
//				TimerProvider.removeEnterFrameTask(onMoveEnterFrame, null, 10);
				TimerProvider.addActiveEnterFrameTask(onMoveEnterFrame, null, 1, 10);
				onMoveEnterFrame();
			}else
			{
				specialMoveDatas = null;
				if(specialMovedMoveToPixcels && specialMovedMoveToPixcels.length>0)
				{
					moveTo(specialMovedMoveToPixcels);
					specialMovedMoveToPixcels = null;
				}else
				{
					TweenLite.delayedCall(0.01,checkFollowTo);
//					checkFollowTo();
				}
			}
		}
		protected function doSpecialMove__onMoveFinish(e:WalkablePlayerEvent):void
		{
			removeEventListener(WalkablePlayerEvent.MOVE_FINISH,doSpecialMove__onMoveFinish);
			
			if(specialMoveDatas[0].type == SpecialMoveData.FLASH)
			{
				setXY(specialMoveDatas[0].endPoint.x, specialMoveDatas[0].endPoint.y);
				specialMoveDatas[0].doneFun && specialMoveDatas[0].doneFun();
				specialMoveDatas[0].destroy();
				specialMoveDatas.shift();
				doSpecialMove();
			}else if(specialMoveDatas[0].type == SpecialMoveData.JUMP)
			{
//				var cmd:PlayerJumpCommand = new PlayerJumpCommand(data.uin,0,specialMoveDatas[0].endPoint);
//				cmd.addEventListener(CommandEvent.FINISH, doSpecialMove__onJumpFinish);
//				cmd.call();
				
//				if(resRenderer == null)
//				{
//					setXY(specialMoveDatas[0].endPoint.x, specialMoveDatas[0].endPoint.y);
//					specialMoveDatas[0].doneFun && specialMoveDatas[0].doneFun();
//					specialMoveDatas.shift();
//					doSpecialMove();
//					return;
//				}
				
				if(hasJumpAction())
				{
					doSpecialMove__jump();
				}else
				{
					doSpecialMove__smog();
				}
			}else
			{
				throw new Error(I18n.lang("as_player_1451031577_5322")+specialMoveDatas[0].type);
			}
		}
		
		protected function hasJumpAction():Boolean
		{
			if(resRenderer == null)
			{
				return false;
			}
			for each(var an:String in resRenderer.getActionNames())
			{
				if(an.indexOf("jump") == 0)
				{
					return true;
				}
			}
			return false;
		}
		
		protected var jumpRoleSimulator:JumpRopeSimulator;
		protected function destroyJumpRoleSimulator():void
		{
			if(jumpRoleSimulator)
			{
				jumpRoleSimulator.removeEventListener(Event.COMPLETE,doSpecialMove__onJumpFinish);
				jumpRoleSimulator.destroy();
				jumpRoleSimulator = null;
			}
		}
		protected function doSpecialMove__jump():void
		{
			destroyJumpRoleSimulator();
			jumpRoleSimulator = new JumpRopeSimulator(this);
			jumpRoleSimulator.addEventListener(Event.COMPLETE, doSpecialMove__onJumpFinish);
			jumpRoleSimulator.jump(specialMoveDatas[0].endPoint);
		}
		protected function doSpecialMove__onJumpFinish(e:Event):void
		{
			destroyJumpRoleSimulator();
			
			if(isDestroyed)
			{
				return;
			}
			specialMoveDatas[0].doneFun && specialMoveDatas[0].doneFun();
			specialMoveDatas.shift();
			doSpecialMove();
		}
		
		protected var smogEffect1:EntryEffect;
		protected var smogEffect2:EntryEffect;
		protected function destroySmogEffect():void
		{
			if(smogEffect1)
			{
				smogEffect1.destroy();
				smogEffect1 = null;
			}
			if(smogEffect2)
			{
				smogEffect2.destroy();
				smogEffect2 = null;
			}
		}
		
		protected function doSpecialMove__smog():void
		{
			destroySmogEffect();
			
			smogEffect1 = new EntryEffect();
			smogEffect1.play(this, 2, doSpecialMove__onSmog1);
		}
		
		protected function doSpecialMove__onSmog1():void
		{
			setXY(specialMoveDatas[0].endPoint.x, specialMoveDatas[0].endPoint.y);
			
			smogEffect2 = new EntryEffect();
			smogEffect2.play(this, 2, doSpecialMove__onSmog2);
		}
		
		protected function doSpecialMove__onSmog2():void
		{
			if(isDestroyed)
			{
				return;
			}
			specialMoveDatas[0].doneFun && specialMoveDatas[0].doneFun();
			specialMoveDatas.shift();
			doSpecialMove();
		}
		
		
		private static const ACTION_IDLES:Array = ["idle_0","idle_1","idle_2","idle_3","idle_4","idle_5","idle_6","idle_7"];
		private static const ACTION_RUNS:Array = ["run_0","run_1","run_2","run_3","run_4","run_5","run_6","run_7"];
		public function playIdleAction():void
		{
			playAction(ACTION_IDLES[data.direction],false,true);
		}
		
		public function playRunAction():void
		{
			playAction(ACTION_RUNS[data.direction],true,true);
		}
		
		protected function onMoveEnterFrame(e:Event=null):void
		{
			if (isDestroyed)
			{
				return;
			}
			var end:Boolean = false;
			if (currMoveToPixcel)
			{
				var dist:Number = (currPos.x-currMoveToPixcel.x)*(currPos.x-currMoveToPixcel.x) + (currPos.y-currMoveToPixcel.y)*(currPos.y-currMoveToPixcel.y);//    Point.distance(currPos,currMoveToPixcel);
				if(dist < SPEED * currSpeedUp * 1.5 * SPEED * currSpeedUp * 1.5)
				{
					//最后再去设置，要不然移动会有明显的节点停顿
//					x = int(currMoveToPixcel.x);
//					y = int(currMoveToPixcel.y);
//					currMoveToPixcel = null;
					end = true;
				}
				else
				{
					currPos.x += currSpeed.x * currSpeedUp;
					currPos.y += currSpeed.y * currSpeedUp;
					setXY(currPos.x,currPos.y);
//					x = int(currPos.x);
//					y = int(currPos.y);
				}
			}
			
			if (end || currMoveToPixcel == null)
			{
				//忽略跟自己当前的点一样的坐标
				var tp:Point;
				while (this.moveToPixcels.length)
				{
					tp = this.moveToPixcels.shift();
					if (tp.x == this.x && tp.y == this.y)
					{
						tp = null;
					}
					else
					{
						break;
					}
				}
				
				if (tp)
				{
					currMoveToPixcel = tp;
					var dx:Number = currMoveToPixcel.x - currPos.x;
					var dy:Number = currMoveToPixcel.y - currPos.y;
					
					var angle:Number = Math.atan2(dy,dx);
					
					currSpeed.x = Math.cos(angle) * SPEED;
					currSpeed.y = Math.sin(angle) * SPEED;
					
					setDirection(angle);
					playRunAction();
				}
				else
				{
					if (currMoveToPixcel)
					{
						setXY(int(currMoveToPixcel.x),int(currMoveToPixcel.y));
						currMoveToPixcel = null;
					}
					stopBaseMove();
//					trace(this,"moveFinish","本次移动耗时:",getTimer()-moveToStartTimer)
					if (this.hasEventListener(WalkablePlayerEvent.MOVE_FINISH))
					{
						this.dispatchEvent(new WalkablePlayerEvent(WalkablePlayerEvent.MOVE_FINISH));
					}
				}
				
			}
		}
		
		protected var followPlayer:BaseWalkablePlayer;
		protected var followMoveToPixcels:Array;
		protected var followShorten:int;
		public function setFollowPlayer(followPlayer:BaseWalkablePlayer,shorten:int=20):void
		{
			destroyFollowPlayer();
			
			this.followPlayer = followPlayer;
			this.followPlayer.addEventListener(WalkablePlayerEvent.MOVE_START,onFollowPlayer);
//			this.followPlayer.addEventListener(WalkablePlayerEvent.MOVE_STOP,onFollowPlayerStopMove);
			this.followPlayer.addEventListener(WalkablePlayerEvent.SPECIAL_MOVE,onFollowPlayerSpecialMove);
			this.followShorten = shorten;
		}
		
		public function getFollowPlayer():BaseWalkablePlayer
		{
			if (this.followPlayer && this.followPlayer.data && this.followPlayer.data.name)
			{
				return this.followPlayer;
			}
			return null;
		}
		
		// 找到队长。
		private function getLeader():BaseWalkablePlayer
		{
			var leader:BaseWalkablePlayer = this;
			var temp:BaseWalkablePlayer = this.getFollowPlayer();
			while (temp)
			{
				leader = temp;
				temp = leader.getFollowPlayer();
			}
			return leader;
		}
		
		
//		private function checkFollowPlayer():void
//		{
//			if(followPlayer==null)
//			{
//				return;
//			}
//			var selfPoint:Point = new Point(x,y);
//			var followwPoint:Point = new Point(followPlayer.x,followPlayer.y);
//			
//			if(Point.distance(selfPoint,followwPoint) <= followShorten)
//			{
//				return;
//			}
//			
//			var findPathCmd:FindPathMapCommand = new FindPathMapCommand(selfPoint,followwPoint,followShorten);
//			findPathCmd.call();
//			
//			if(findPathCmd.resultPixcels)
//			{
//				this.moveTo(findPathCmd.resultPixcels);
//			}
//		}
		
		private function followTo(followPixcels:Array):void
		{
			this.moveTo([new Point(x,y)].concat(followPixcels));
		}
		
		protected function onFollowPlayer(e:WalkablePlayerEvent):void
		{
			this.followMoveToPixcels = e.moveToPixcels;
			//如果在执行特殊移动时，就忽略队长的一切行为，因为这些特殊移动的行为都是之前队长引起的
			if(specialMoveDatas)
			{
				return;
			}
			fixUnWalkable();
			TweenLite.delayedCall(0.01,checkFollowTo);
//			checkFollowTo();
		}
		
		private var followPointStart:Point = new Point();
		private var followPointEnd:Point = new Point();
		private var followPointLeader:Point = new Point();
		private function checkFollowTo():void
		{
			var leader:BaseWalkablePlayer = this.getLeader();
			if (leader == null || leader == this)
			{
				return;
			}
			TweenLite.killTweensOf(this.followTo);
			
			this.findFollowEndPoint(leader, this.followPointEnd);
			this.followPointStart.setTo(x, y);
			this.followPointLeader.setTo(leader.x, leader.y);
			
			var findPathCmd:FindPathMapCommand = new FindPathMapCommand(this.followPointStart, this.followPointEnd);
			findPathCmd.call();
			if (findPathCmd.resultPixcels)
			{
				var shortenPathCmd:ShortenPathMapCommand = new ShortenPathMapCommand(findPathCmd.resultPixcels, this.followShorten);
				shortenPathCmd.call();
				if (shortenPathCmd.resultPixcels)
				{
					this.followTo(shortenPathCmd.resultPixcels);
				}
			}
		}
		private function findFollowEndPoint(leader:BaseWalkablePlayer, result:Point):void
		{
			var endPt:Point = leader.endPoint;
			var endDirection:int = leader.endDirection;
			var dx:int;
			var dy:int;
			var rx:int = 150;
			var ry:int = 100;
			switch (endDirection) // x 轴
			{
				case 1:
				case 2:
				case 3: // 右边随机
				{
					dx = Math.random() * rx;
					break;
				}
				case 5:
				case 6:
				case 7: // 左边随机
				{
					
					dx = -(Math.random() * rx);
					break;
				}
				case 4:
				case 0: // 左右随机
				{
					dx = Math.random() * rx;
					dx *= Math.random() > 0.5 ? -1 : 1;
					break;
				}
			}
			switch (endDirection) // y 轴
			{
				case 3:
				case 4:
				case 5: // 下边随机
				{
					dy = Math.random() * ry;
					break;
				}
				case 1:
				case 0:
				case 7: // 上边随机
				{
					
					dy = -(Math.random() * ry);
					break;
				}
				case 2:
				case 6: // 上下随机
				{
					dy = Math.random() * ry;
					dy *= Math.random() > 0.5 ? -1 : 1;
					break;
				}
			}
			result.setTo(endPt.x + dx, endPt.y + dy);
		}
		
//		protected function onFollowPlayerStopMove(e:WalkablePlayerEvent):void
//		{
//			stopMove();
//		}
		
		public function setDirection(angle:Number):void
		{
			var a360:int = angle * 180 / Math.PI;
			a360 = (a360 + 270 + 22)%360;
			var dir:int = a360 / 45;
			data.direction = dir;
		}
		
		public function destroyFollowPlayer():void
		{
			if(followPlayer)
			{
				TweenLite.killTweensOf(this.followTo);
				followPlayer.removeEventListener(WalkablePlayerEvent.MOVE_START,onFollowPlayer);
//				followPlayer.removeEventListener(WalkablePlayerEvent.MOVE_STOP,onFollowPlayerStopMove);
				followPlayer.removeEventListener(WalkablePlayerEvent.SPECIAL_MOVE,onFollowPlayerSpecialMove);
				followPlayer = null;
				followMoveToPixcels = null;
			}
		}
		
//		protected function destroyRunEffectRenderer():void
//		{
//			if(_runEffectRenderer)
//			{
//				_runEffectRenderer.removeEventListener(MmeAssetRenderEvent.PLAY_END,onEffectRendererPlayEnd);
//				_runEffectRenderer.destroy();
//				_runEffectRenderer = null;
//			}
//		}
		
		override public function dispose():void
		{
			TweenLite.killDelayedCallsTo(checkFollowTo);
			removeEventListener(WalkablePlayerEvent.MOVE_FINISH,doSpecialMove__onMoveFinish);
//			LayerManager.singleton.stage.removeEventListener(Event.ENTER_FRAME,onMoveEnterFrame);
			TimerProvider.removeEnterFrameTask(onMoveEnterFrame, null, 10);
			destroyFollowPlayer();
			destroyJumpRoleSimulator();
			destroySmogEffect();
			this.moveToPixcels.length = 0;
			currMoveToPixcel = null;
			if(_ghost)
			{
				_ghost.dispose();
			}
			if(specialMoveDatas)
			{
				specialMoveDatas.length = 0;
			}
			super.dispose();
		}
		
		override public function destroy(needDispatchEvent:Boolean=true):void
		{
			TweenLite.killDelayedCallsTo(checkFollowTo);
			currSpeed = null;
			currPos = null;
			removeEventListener(WalkablePlayerEvent.MOVE_FINISH,doSpecialMove__onMoveFinish);
			//不能调用 dispse();因为super.dispose()里会把data清掉，而super.destroy需要用data来派发事件
//			LayerManager.singleton.stage.removeEventListener(Event.ENTER_FRAME,onMoveEnterFrame);
			TimerProvider.removeEnterFrameTask(onMoveEnterFrame, null, 10);
			destroyFollowPlayer();
			destroyJumpRoleSimulator();
			destroySmogEffect();
			this.moveToPixcels.length = 0;
			currMoveToPixcel = null;
			if(specialMoveDatas)
			{
				specialMoveDatas.length = 0;
			}
			specialMovedMoveToPixcels = null;
			
			if(_ghost)
			{
				_ghost.dispose();
				_ghost = null;
			}
			
			
			super.destroy(needDispatchEvent);
		}
		
		/**
		 * 是否显示拖影
		 */
		public function get ghostVisible():Boolean { return _ghost.running; }
		public function set ghostVisible(value:Boolean):void 
		{
			if (value)
			{
				!_ghost.running && _ghost.start();
			}
			else
			{
				_ghost.running && _ghost.stop();
			}
		}
		
		private function onPositionChanged(evt:MapElementEvent):void
		{
			data.setPosition(x,y);
		}


	}
}