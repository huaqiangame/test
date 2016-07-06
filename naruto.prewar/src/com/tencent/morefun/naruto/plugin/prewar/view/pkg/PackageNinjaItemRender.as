package com.tencent.morefun.naruto.plugin.prewar.view.pkg
{
	import com.tencent.morefun.naruto.plugin.exui.render.StarSimpleNinjaRender;
	import com.tencent.morefun.naruto.plugin.prewar.component.DragMonitor;
	import com.tencent.morefun.naruto.plugin.prewar.event.NinjaEvent;
	
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import ninja.model.data.NinjaArrangeInfo;
	import ninja.model.data.NinjaInfo;
	
	/**
	 * 停止拖拽忍者
	 */
	[Event(name = "stopDragNinja", type = "com.tencent.morefun.naruto.plugin.ninja.event.NinjaEvent")]
	
	/**
	 * 开始拖拽忍者
	 */
	[Event(name = "startDragNinja", type = "com.tencent.morefun.naruto.plugin.ninja.event.NinjaEvent")]
	
	/**
	 * 背包忍者渲染器
	 * @author larryhou
	 * @createTime 2013/9/27 16:17
	 */
	public class PackageNinjaItemRender extends StarSimpleNinjaRender
	{
		private var _monitor:DragMonitor;
		private var _dragData:NinjaArrangeInfo;
		public function PackageNinjaItemRender(skin:MovieClip = null)
		{
			var parent:DisplayObjectContainer;
			
			super(skin);
			parent = m_skin.parent;
//			parent.addChild(this);
			
			this.showHp = true;
			this.showDeath = true;
			
			_monitor = new DragMonitor(this);
			_monitor.addEventListener(Event.INIT, dragHandler);
			_monitor.addEventListener(Event.COMPLETE, dragHandler);
		}
		
		/**
		 * 处理选项卡拖拽
		 */
		private function dragHandler(e:Event):void 
		{
			if (!data) return;
			
			if (_monitor.dragging)
			{
				this.dispatchEvent(new NinjaEvent(NinjaEvent.START_DRAG_NINJA, [_dragData, this], true));
			}
			else
			{
				this.dispatchEvent(new NinjaEvent(NinjaEvent.STOP_DRAG_NINJA, [_dragData, this], true));
			}
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			_dragData = transformTeamFormationNinja(data as NinjaInfo);
			
			if((value as NinjaInfo).detail.life == 0)
			{
				this.mouseEnabled = false;
				this.mouseChildren = false;
			}
			else
			{
				this.mouseEnabled = true;
				this.mouseChildren = true;
			}
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		private function transformTeamFormationNinja(ninjaFormation:NinjaInfo):NinjaArrangeInfo
		{
			var teamFormationNinja:NinjaArrangeInfo;
			
			if(!ninjaFormation){return null;}
			
			teamFormationNinja = new NinjaArrangeInfo();
			teamFormationNinja.sequence = ninjaFormation.sequence;
			teamFormationNinja.ninjaId = ninjaFormation.id;
			teamFormationNinja.life = ninjaFormation.detail.life;
			teamFormationNinja.lifeMax = ninjaFormation.detail.lifeMax.value;
			
			return teamFormationNinja;
		}
		
		override protected function onMouseOver(evt:Event):void
		{
			(!this.data.selected) && (view.frame.gotoAndStop("blue"));
		}
		
		override public function destroy():void
		{
			super.destroy();
			_monitor.removeEventListener(Event.INIT, dragHandler);
			_monitor.removeEventListener(Event.COMPLETE, dragHandler);
			_monitor.dispose();
		}
		
	}

}