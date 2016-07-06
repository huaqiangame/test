package com.tencent.morefun.naruto.plugin.player.base
{
	import com.tencent.morefun.naruto.effect.jump.JumpSimulator;
	import com.tencent.morefun.naruto.plugin.player.players.BaseWalkablePlayer;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 跳跃模拟器
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * 攀岩效果
	 * @author larryhou
	 * @createTime 2013/8/31 13:42
	 */
	public class JumpRopeSimulator extends EventDispatcher
	{
		private static const JUMP_START:uint = 1;
		private static const JUMPING:uint = 2;
		private static const JUMP_ARRIVE:uint = 3;
		
		private var _target:BaseWalkablePlayer;
		private var _id:uint;
		
		private var _simulator:JumpSimulator;
		private var _location:Point;
		
		/**
		 * 构造函数
		 * create a [JumpRopeSimulator] object
		 */
		public function JumpRopeSimulator(target:BaseWalkablePlayer) 
		{
			_target = target;
			
			_simulator = new JumpSimulator(_target, 30);
			_simulator.frameRate = 24;
		}
		
		/**
		 * 获取动作名称
		 */
		private function getActionName(state:uint):String
		{
			return "jump" + getActionId(_target.getData().direction) + "_" + state;
		}
		
		private function getActionId(direction:uint):int
		{
			//"idle_6", "idle_7", "idle_0", "idle_1", "idle_2", "idle_3", "idle_4", "idle_5"
//			const HASH:Array = [6, 7, 0, 1, 2, 3, 4, 5];
//			return HASH[direction]
			return direction;
		}
		
		/**
		 * 开始攀岩
		 */
		public function jump(location:Point):void
		{
			_location = location;
			
			var dx:Number = location.x - _target.x;
			var dy:Number = location.y - _target.y;
			var radian:Number = Math.atan2(dy, dx);
			
			_target.setDirection(radian);
			_target.playAction(getActionName(JUMP_START), true, true);
			
			_id && clearTimeout(_id);
			_id = setTimeout(startJump, 200);
		}
		
		/**
		 * 腾空跳跃
		 */
		private function startJump():void
		{
			_target.ghostVisible = true;
			_target.playAction(getActionName(JUMPING), true, true);
			_simulator.addEventListener(Event.COMPLETE, jumpArriveHandler);
			_simulator.jumpTo(_location);
		}
		
		private function jumpArriveHandler(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			_target.ghostVisible = false;
			_target.playAction(getActionName(JUMP_ARRIVE), true, true);
			_id = setTimeout(finishJump, 200);
		}
		
		private function finishJump():void
		{
			_target.playIdleAction();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		public function destroy():void
		{
			_id && clearTimeout(_id);
			_simulator.removeEventListener(Event.COMPLETE,jumpArriveHandler);
			_simulator.dispose();
			_simulator = null;
			_target.ghostVisible = false;
			_target = null;
			_location = null;
		}
	}

}