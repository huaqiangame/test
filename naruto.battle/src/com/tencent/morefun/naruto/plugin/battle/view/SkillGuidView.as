package com.tencent.morefun.naruto.plugin.battle.view
{	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class SkillGuidView extends Sprite
	{
		private var type:int;
		private var skillIconDisplay:SkillButtonView;
		private var guidAnimation1:GuidAnimation1;
		private var guidAnimation2:GuidAnimation2;
		private var guidAnimation3:GuidAnimation3;
		
		public function SkillGuidView()
		{
			super();
			
			initUI();
		}
		
		private function initUI():void
		{
			guidAnimation1 = new GuidAnimation1();
			guidAnimation2 = new GuidAnimation2();
			guidAnimation3 = new GuidAnimation3();
			
			guidAnimation1.mouseEnabled = guidAnimation1.mouseChildren = false;
			guidAnimation2.mouseEnabled = guidAnimation2.mouseChildren = false;
			guidAnimation3.mouseEnabled = guidAnimation3.mouseChildren = false;
		}
		
		public function hideAnimation():void
		{
			guidAnimation1.visible = false;
			guidAnimation2.visible = false;
			guidAnimation3.visible = false;
		}
		
		public function showAnimation():void
		{
			guidAnimation1.visible = true;
			guidAnimation2.visible = true;
			guidAnimation3.visible = true;
		}
		
		public function updateGuidState(type:int, display:SkillButtonView):void
		{
			reset();
			
			this.type = type;
			this.skillIconDisplay = display;
			
			switch(type)
			{
				case 1:
				case 4:
				case 6:
					addChild(guidAnimation1);
					break;
				case 2:
					addChild(guidAnimation2);
					break;
				case 5:
				case 7:
					case 8:
					addChild(guidAnimation3);
					break;
			}
			
			update();
		}
		
		public function update():void
		{
			switch(type)
			{
				case 1:
				case 4:
				case 6:
					updateGuid1();
					break;
				case 2:
					updateGuid2();
					break;
				case 5:
				case 7:
					updateGuid3();
					break;
				case 8:
					updateGuid4();
					break;
			}
		}
		
		public function destroy():void
		{
			removeChildren();
			graphics.clear();
			skillIconDisplay = null;
		}
		
		private function reset():void
		{
			type = 0;
			removeChildren();
			graphics.clear();
			skillIconDisplay = null;
		}
		
		private function updateGuid1():void
		{
			var stagePoint:Point;
			var width:int;
			var height:int;
			var guidPos:MovieClip;
			
			graphics.clear();
			
			if(!skillIconDisplay)
			{
				return ;
			}
			
			guidPos = skillIconDisplay.guidPos;
			
			width = guidPos.width;
			height = guidPos.height;
			stagePoint = guidPos.localToGlobal(new Point(0, 0));
			stagePoint = globalToLocal(stagePoint);
			
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.drawRect(stagePoint.x, stagePoint.y, guidPos.width, guidPos.height);
			graphics.endFill();
			
			guidAnimation1.x = stagePoint.x + guidPos.width / 2;
			guidAnimation1.y = stagePoint.y + guidPos.height / 2;
		}
		
		private function updateGuid3():void
		{
			var stagePoint:Point;
			var width:int;
			var height:int;
			var guidPos:MovieClip;
			
			graphics.clear();
			
			if(!skillIconDisplay)
			{
				return ;
			}
			
			guidPos = skillIconDisplay.guidPos;
			
			width = guidPos.width;
			height = guidPos.height;
			stagePoint = guidPos.localToGlobal(new Point(0, 0));
			stagePoint = globalToLocal(stagePoint);
			
			graphics.beginFill(0x000000, 0.2);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.drawRect(stagePoint.x, stagePoint.y, guidPos.width, guidPos.height);
			graphics.endFill();
			
			guidAnimation3.x = stagePoint.x + guidPos.width / 2;
			guidAnimation3.y = stagePoint.y + guidPos.height / 2;
		}
		
		private function updateGuid4():void
		{
			var stagePoint:Point;
			var guidPos:MovieClip;
			
			guidPos = skillIconDisplay.guidPos;
			stagePoint = guidPos.localToGlobal(new Point(0, 0));
			stagePoint = globalToLocal(stagePoint);
			guidAnimation3.x =  stagePoint.x + guidPos.width / 2;
			guidAnimation3.y =  stagePoint.y + guidPos.height / 2;
		}
		
		private function updateGuid2():void
		{
			var stagePoint:Point;
			var guidPos:MovieClip;
			
			guidPos = skillIconDisplay.guidPos;
			stagePoint = guidPos.localToGlobal(new Point(0, 0));
			stagePoint = globalToLocal(stagePoint);
			guidAnimation2.x =  stagePoint.x + guidPos.width / 2;
			guidAnimation2.y =  stagePoint.y + guidPos.height / 2;
		}
		
		
		public function autoSetNull():void
		{
			
			skillIconDisplay = null;
			guidAnimation1 = null;
			guidAnimation2 = null;
			guidAnimation3 = null;
		}
	}
}