package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.FrameSizeDef;
	
	import flash.display.Sprite;
	
	public class BaseSprite extends Sprite
	{
		private var frameDef:String;
		private var isShow:Boolean;
		
		private var backgroundList:Array = [];
		
		public function BaseSprite()
		{
			super();
		}
		
		public function bindingFrameSize(frameSizeDef:String):void
		{
			this.frameDef = frameSizeDef;
		}
		
		public function addBackground(backgroundDef:String, layerDef:String):void
		{
			backgroundList.push({backgroundDef:backgroundDef, layerDef:layerDef});
		}
		
		public function show():void
		{
			if(isShow){hide();}
			isShow = true;
			
			if(frameDef)
			{
				pushFrameSize();
			}
			
			for each(var backgroundInfo:Object in backgroundList)
			{
				BackGround.addBackground(name, backgroundInfo["backgroundDef"], backgroundInfo["layerDef"]);
			}
		}
		
		public function hide():void
		{
			if(!isShow){return ;}
			isShow = false;
			
			if(frameDef)
			{
				popFrameSize();
			}
			
			BackGround.disposeGroup(name);
		}
		
		public function destroy():void
		{
			hide();
		}
		
		private function pushFrameSize():void
		{
			switch(frameDef)
			{
				case FrameSizeDef.MIDDLE_FRAME_SIZE:
					LayoutManager.singleton.pushFrameSize(FrameSizeDef.FIGHT_MIN_WIDTH, FrameSizeDef.FIGHT_MAX_WIDHT, FrameSizeDef.FIGHT_MIN_HEIGHT, FrameSizeDef.FIGHT_MAX_HEIGHT);
					break;
				case FrameSizeDef.MAX_FRAME_SIZE:
					LayoutManager.singleton.pushFrameSize(FrameSizeDef.DEAFULT_MIN_WIDTH, FrameSizeDef.DEFAULT_MAX_WIDTH, FrameSizeDef.DEFAULT_MIN_HEIGHT, FrameSizeDef.DEFAULT_MAX_HEIGHT);
					break;
			}
		}
		
		private function popFrameSize():void
		{
			LayoutManager.singleton.popFrameSize();
		}
	}
}