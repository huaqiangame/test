package com.tencent.morefun.naruto.plugin.ui.base
{

	import com.tencent.morefun.framework.log.logger;
	import com.tencent.morefun.naruto.plugin.ui.base.def.BackGroundDef;
	import com.tencent.morefun.naruto.plugin.ui.core.BattleMaskAnimationUI;
	import com.tencent.morefun.naruto.plugin.ui.core.BottomBg;
	import com.tencent.morefun.naruto.plugin.ui.core.DangerBackgroundAnimation;
	import com.tencent.morefun.naruto.plugin.ui.core.DangerBg;
	import com.tencent.morefun.naruto.plugin.ui.core.FrameUI;
	import com.tencent.morefun.naruto.plugin.ui.core.PicBg1;
	import com.tencent.morefun.naruto.plugin.ui.core.TopBg;
	import com.tencent.morefun.naruto.plugin.ui.core.battleBg;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayoutManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class BackGround extends Sprite
	{
		private static var m_stage:Stage;
		private static var m_curDef:int;
		private static var m_curBackgroundInfo:BackgroundInfo;
		private static var m_lastPuashBackgroundInfo:BackgroundInfo;
		private static var m_curLayer:String = LayerDef.BACKG_GROUND;
		
		private static var m_dangerScrrenFrame:Sprite;
		private static var m_battleScreenFrame:Sprite;
		
		private static var m_backgroundGroupMap:Dictionary = new Dictionary();
		
		private static var m_dangerContainer:DangerBackgroundAnimation;
		private static var m_battleBackGroundContianer:BattleMaskAnimationUI;
		
		private static var m_backgroundIndex:int;
		
		//static
		{
			(function():void {
				if(m_stage==null)
				{
					initialize(LayerManager.singleton.stage);
				}
			}());
		}
		
		public function BackGround()
		{
			super();
		}
		
		public static function initialize(stage:Stage):void
		{
			m_stage = stage;
			
			m_dangerScrrenFrame = new Sprite();
			m_battleScreenFrame = new Sprite();
			
			m_dangerContainer = new DangerBackgroundAnimation();
			m_dangerContainer.mouseEnabled = false;
			m_dangerContainer.mouseChildren = false;
			
			m_battleBackGroundContianer = new BattleMaskAnimationUI();
			m_battleBackGroundContianer.mouseEnabled = false;
			m_battleBackGroundContianer.mouseChildren = false;
			
			LayerManager.singleton.addItemToLayer(m_dangerContainer, m_curLayer);
			LayerManager.singleton.addItemToLayer(m_battleBackGroundContianer, m_curLayer);
			LayerManager.singleton.stage.addEventListener(Event.RESIZE, onStageResize);
			
			m_dangerContainer["container"].addChild(m_dangerScrrenFrame);
			m_battleBackGroundContianer["container"].addChild(m_battleScreenFrame);
			m_dangerContainer.addEventListener(Event.COMPLETE, onDangerAnimationComplete);
			m_battleBackGroundContianer.addEventListener(Event.COMPLETE, onBattleAnimationComplete);
		}
		
		private static function onDangerAnimationComplete(evt:Event):void
		{
			clearDangerAnimation();
		}
		
		private static function onBattleAnimationComplete(evt:Event):void
		{
			clearBattleAnimation();
		}
		
		private static function clearBattleAnimation():void
		{
			var backgroundInfoList:Array;
			var cloneBackgroundInfoList:Array;
			
			for(var key:* in m_backgroundGroupMap)
			{
				backgroundInfoList = m_backgroundGroupMap[key];
				cloneBackgroundInfoList = backgroundInfoList.concat();
				for each(var backgroundInfo:BackgroundInfo in cloneBackgroundInfoList)
				{
					if(backgroundInfo.def == BackGroundDef.BATTLE_MASK_ANIMATION)
					{
						hideBackground(backgroundInfo);
						backgroundInfoList.splice(backgroundInfoList.indexOf(backgroundInfo), 1);
					}
				}
			}
		}
		
		private static function clearDangerAnimation():void
		{
			var backgroundInfoList:Array;
			var cloneBackgroundInfoList:Array;
			
			for(var key:* in m_backgroundGroupMap)
			{
				backgroundInfoList = m_backgroundGroupMap[key];
				cloneBackgroundInfoList = backgroundInfoList.concat();
				for each(var backgroundInfo:BackgroundInfo in backgroundInfoList)
				{
					if(backgroundInfo.def == BackGroundDef.DANGER_ANIMATION)
					{
						hideBackground(backgroundInfo);
						
						backgroundInfoList.splice(backgroundInfoList.indexOf(backgroundInfo), 1);
					}
				}
			}
		}
		
		public static function createGroup(grupName:String):void
		{
			if(!m_backgroundGroupMap[grupName])
			{
				m_backgroundGroupMap[grupName] = new Array();
			}
		}
		
		public static function destroyGroup(grupName:String):void
		{
			disposeGroup(grupName);
			delete m_backgroundGroupMap[grupName];
		}
		
		public static function disposeGroup(grupName:String):void
		{
			var backgroundInfoList:Array;
			var cloneBackgroundInfoList:Array;
			
			logger.output("disposeGroup", grupName);
			
			backgroundInfoList = m_backgroundGroupMap[grupName];
			cloneBackgroundInfoList = backgroundInfoList.concat();
			for each(var backgroundInfo:BackgroundInfo in cloneBackgroundInfoList)
			{
				if(removeBackgroundByInfo(backgroundInfo))
				{
					backgroundInfoList.splice(backgroundInfoList.indexOf(backgroundInfo), 1);
				}
			}
		}
		
		public static function addBackground(group:String, def:int = 0, layer:String = null):int
		{
			var backgroundIndex:int;
			var containerLayer:String;
			var backgroundContainer:Sprite;
			var backgroundInfo:BackgroundInfo;
			var backgroundInfoList:Array;
			
			backgroundInfoList = m_backgroundGroupMap[group];
			
			if(backgroundInfoList == null)
			{
				backgroundInfoList = [];
				m_backgroundGroupMap[group] = backgroundInfoList;
			}
			
			containerLayer = layer || m_curLayer;
			backgroundContainer = new Sprite();
			
			if(def == BackGroundDef.DANGER_ANIMATION)
			{
				clearDangerAnimation();
				m_dangerScrrenFrame.addChild(backgroundContainer);
			}
			else if(def == BackGroundDef.BATTLE_MASK_ANIMATION)
			{
				clearBattleAnimation();
				m_battleScreenFrame.addChild(backgroundContainer);
			}
			else
			{
				LayerManager.singleton.addItemToLayer(backgroundContainer, containerLayer);
			}
			
			backgroundIndex = getBackgroundIndex();
			backgroundInfo = new BackgroundInfo(def, containerLayer, backgroundIndex, backgroundContainer);
			backgroundInfoList.push(backgroundInfo);
			showBackground(backgroundInfo);
			
			return backgroundIndex;
		}
		
		public static function removeBackground(group:String, index:int):void
		{
			var index:int;
			var backgroundInfoList:Array;
			
			backgroundInfoList = m_backgroundGroupMap[group];
			for each(var backgroundInfo:BackgroundInfo in backgroundInfoList)
			{
				if(backgroundInfo.index == index)
				{
					removeBackgroundByInfo(backgroundInfo);
					index = backgroundInfoList.indexOf(backgroundInfo);
					backgroundInfoList[index] = null;
					backgroundInfoList.splice(index, 1);
					break;
				}
			}
		}
		
		private static function removeBackgroundByInfo(backgroundInfo:BackgroundInfo):Boolean
		{
			var backgroundInfo:BackgroundInfo;
			
			if(backgroundInfo.def == BackGroundDef.DANGER_ANIMATION || backgroundInfo.isPushBackground == false)
			{
				return false;
			}
			
			hideBackground(backgroundInfo);
			
			return true;
		}
		
		public static function hasBackground(group:String, def:int):Boolean
		{
			var backgroundInfoList:Array;
			
			backgroundInfoList = m_backgroundGroupMap[group];
			
			if(backgroundInfoList == null)
			{
				return false;
			}
			
			for each(var backgroundInfo:BackgroundInfo in backgroundInfoList)
			{
				if(backgroundInfo.def == def)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function createFrame(group:String, def:int = 0):Sprite
		{
			var backgroundIndex:int;
			var containerLayer:String;
			var backgroundInfo:BackgroundInfo;
			var backgroundContainer:Sprite = new Sprite();
			var backgroundInfoList:Array;
			
			backgroundInfoList = m_backgroundGroupMap[group];
			
			if(backgroundInfoList == null)
			{
				throw new Error(I18n.lang("as_ui_1451031579_6135"));
			}
			
			backgroundIndex = getBackgroundIndex();
			backgroundInfo = new BackgroundInfo(def, containerLayer, backgroundIndex, backgroundContainer);
			backgroundInfo.isPushBackground = false;
			backgroundInfoList.push(backgroundInfo);
			showBackground(backgroundInfo);
			
			return backgroundContainer;
		}
		
		public static function redrawFrame(group:String, container:Sprite):void
		{
			var backgroundInfoList:Array;
			
			backgroundInfoList = m_backgroundGroupMap[group];
			
			if(backgroundInfoList == null)
			{
				return ;
			}
			
			for each(var backgroundInfo:BackgroundInfo in backgroundInfoList)
			{
				if(backgroundInfo.contianer == container)
				{
					redraw(backgroundInfo);
				}
			}
		}
		
		public static function destroyFrame(group:String, container:Sprite):void
		{
			var index:int;
			var backgroundInfoList:Array;
			
			backgroundInfoList = m_backgroundGroupMap[group];
			
			if(backgroundInfoList == null)
			{
				return ;
			}
			
			for each(var backgroundInfo:BackgroundInfo in backgroundInfoList)
			{
				if(backgroundInfo.contianer == container)
				{
					index = backgroundInfoList.indexOf(backgroundInfo);
					backgroundInfoList[index] = null;
					backgroundInfoList.splice(index, 1);
					hideBackground(backgroundInfo);
					break;
				}
			}
		}
		
		private static function showBackground(backgroundInfo:BackgroundInfo):void
		{
			var topImgData:BitmapData;
			var bottomImgData:BitmapData;
			var backgroundImgData:BitmapData;
			
			switch(backgroundInfo.def)
			{
				case BackGroundDef.PLOT_FRAME:
					topImgData = new TopBg();
					bottomImgData = new BottomBg();
					backgroundInfo.topBitmapData = topImgData;
					backgroundInfo.bottomBitmapData = bottomImgData;
					drawAroundFrame(backgroundInfo.contianer, backgroundInfo.topBitmapData, backgroundInfo.bottomBitmapData);
					break;
				
				case BackGroundDef.PLOT_BACKGROUND:
					backgroundImgData = new PicBg1();
					backgroundInfo.backgroundBitmapData = backgroundImgData;
					drawRepeatBackround(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				
				case BackGroundDef.OLD_PLOT_FRAME:
					backgroundImgData = new FrameUI();
					backgroundInfo.backgroundBitmapData = backgroundImgData;
					drawFrame(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				
				case BackGroundDef.OLD_PLOT_SPEAK_TOP_FRAME:
					backgroundImgData = new FrameUI();
					backgroundInfo.backgroundBitmapData = backgroundImgData;
					drawTopFrame(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				
				case BackGroundDef.OLD_PLOT_SPEAK_BOTTOM_FRAME:
					backgroundImgData = new FrameUI();
					backgroundInfo.backgroundBitmapData = backgroundImgData;
					drawBottomFrame(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				
				case BackGroundDef.DANGER_ANIMATION:
					backgroundImgData = new DangerBg();
					backgroundInfo.backgroundBitmapData = backgroundImgData;
					drawBackground(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					m_dangerContainer.gotoAndPlay("animation");
					break;
				
				case BackGroundDef.BATTLE_MASK_ANIMATION:
					backgroundImgData = new battleBg();
					backgroundInfo.backgroundBitmapData = backgroundImgData;
					drawBackground(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					m_battleBackGroundContianer.gotoAndPlay("show");
					break;
				case BackGroundDef.ESCORT_FRAME:
					backgroundInfo.alpha = 1;
					backgroundInfo.color = 0x000000;
					drawColorBackground(backgroundInfo.contianer, backgroundInfo.color, backgroundInfo.alpha);
					break;
				case BackGroundDef.ROLE_PROMOTE:
					backgroundInfo.alpha = 1;
					backgroundInfo.color = 0x000000;
					drawColorFrame(backgroundInfo.contianer, backgroundInfo.color, backgroundInfo.alpha);
					break;
			}
		}
		
		private static function hideBackground(backgroundInfo:BackgroundInfo):void
		{
			backgroundInfo.contianer.graphics.clear();
			switch(backgroundInfo.def)
			{
				case BackGroundDef.PLOT_FRAME:
					backgroundInfo.topBitmapData.dispose();
					backgroundInfo.bottomBitmapData.dispose();
					LayerManager.singleton.removeItemToLayer(backgroundInfo.contianer);
					break;
				case BackGroundDef.PLOT_BACKGROUND:
					backgroundInfo.backgroundBitmapData.dispose();
					LayerManager.singleton.removeItemToLayer(backgroundInfo.contianer);
					break;
				case BackGroundDef.OLD_PLOT_FRAME:
					backgroundInfo.backgroundBitmapData.dispose();
					LayerManager.singleton.removeItemToLayer(backgroundInfo.contianer);
					break;
				case BackGroundDef.DANGER_ANIMATION:
					backgroundInfo.backgroundBitmapData.dispose();
					m_dangerScrrenFrame.removeChild(backgroundInfo.contianer);
					break;
				case BackGroundDef.BATTLE_MASK_ANIMATION:
					backgroundInfo.backgroundBitmapData.dispose();
					backgroundInfo.contianer.parent.removeChild(backgroundInfo.contianer);
					backgroundInfo.contianer.graphics.clear();
					m_battleBackGroundContianer.gotoAndPlay("hide");
					break;
				
				case BackGroundDef.OLD_PLOT_SPEAK_TOP_FRAME:
					backgroundInfo.backgroundBitmapData.dispose();
					LayerManager.singleton.removeItemToLayer(backgroundInfo.contianer);
					break;
				
				case BackGroundDef.OLD_PLOT_SPEAK_BOTTOM_FRAME:
					backgroundInfo.backgroundBitmapData.dispose();
					LayerManager.singleton.removeItemToLayer(backgroundInfo.contianer);
					break;
				
				case BackGroundDef.ESCORT_FRAME:
					backgroundInfo.contianer.graphics.clear();
					LayerManager.singleton.removeItemToLayer(backgroundInfo.contianer);
					break;
				case BackGroundDef.ROLE_PROMOTE:
					backgroundInfo.contianer.graphics.clear();
					LayerManager.singleton.removeItemToLayer(backgroundInfo.contianer);
					break;
			}
		}
		
		private static function onStageResize(evt:Event):void
		{
			var backgroundInfoList:Array;
			
			for(var key:* in m_backgroundGroupMap)
			{
				backgroundInfoList = m_backgroundGroupMap[key];
				for each(var backgroundInfo:BackgroundInfo in backgroundInfoList)
				{
					redraw(backgroundInfo);
				}
			}
		}
		
		private static function redraw(backgroundInfo:BackgroundInfo):void
		{
			switch(backgroundInfo.def)
			{
				case BackGroundDef.PLOT_FRAME:
					drawAroundFrame(backgroundInfo.contianer, backgroundInfo.topBitmapData, backgroundInfo.bottomBitmapData);
					break;
				
				case BackGroundDef.PLOT_BACKGROUND:
					drawRepeatBackround(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				
				case BackGroundDef.OLD_PLOT_FRAME:
					drawFrame(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				
				case BackGroundDef.OLD_PLOT_SPEAK_TOP_FRAME:
					drawTopFrame(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				
				case BackGroundDef.OLD_PLOT_SPEAK_BOTTOM_FRAME:
					drawBottomFrame(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData)
					break;
				
				case BackGroundDef.DANGER_ANIMATION:
					drawBackground(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				
				case BackGroundDef.BATTLE_MASK_ANIMATION:
					drawBackground(backgroundInfo.contianer, backgroundInfo.backgroundBitmapData);
					break;
				case BackGroundDef.ESCORT_FRAME:
					drawColorBackground(backgroundInfo.contianer, backgroundInfo.color, backgroundInfo.alpha);
					break;
				case BackGroundDef.ROLE_PROMOTE:
					drawColorFrame(backgroundInfo.contianer, backgroundInfo.color, backgroundInfo.alpha);
					break;
			}
		}
		
		private static function drawFrame(container:Sprite, frameBitmapData:BitmapData):void
		{
			container.graphics.clear();
			container.graphics.beginBitmapFill(frameBitmapData as BitmapData, new Matrix(1, 0, 0, 1, 0, 0));
			container.graphics.drawRect(0, 0, LayoutManager.stageWidth, 150);
			container.graphics.beginBitmapFill(frameBitmapData as BitmapData, new Matrix(1, 0, 0, -1, 0, LayoutManager.stageHeight));
			container.graphics.drawRect(0, LayoutManager.stageHeight - 150, LayoutManager.stageWidth, 150);
			container.graphics.endFill();
		}
		
		private static function drawBottomFrame(container:Sprite, frameBitmapData:BitmapData):void
		{
			container.graphics.clear();
			
			container.graphics.beginBitmapFill(frameBitmapData as BitmapData, new Matrix(1, 0, 0, -1, 0, LayoutManager.stageHeight + LayoutManager.stageOffsetY * 2 - frameBitmapData.height));
			container.graphics.drawRect(0, LayoutManager.stageHeight + LayoutManager.stageOffsetY * 2 - frameBitmapData.height, LayoutManager.stageWidth + LayoutManager.stageOffsetX * 2, frameBitmapData.height);
			container.graphics.endFill();
		}
		
		private static function drawTopFrame(container:Sprite, frameBitmapData:BitmapData):void
		{
			container.graphics.clear();
			
			container.graphics.beginBitmapFill(frameBitmapData as BitmapData, new Matrix(1, 0, 0, 1, 0, 0));
			container.graphics.drawRect(0, 0, LayoutManager.stageWidth + LayoutManager.stageOffsetX * 2, frameBitmapData.height);
			container.graphics.endFill();
		}
		
		private static function drawAroundFrame(container:Sprite, topBitmapData:BitmapData, bottomBitmapData:BitmapData):void
		{
			container.graphics.clear();
			
			container.graphics.beginBitmapFill(topBitmapData, new Matrix(1, 0, 0, 1, 0, int(topBitmapData.height / 2) - 1), true, true);
			container.graphics.drawRect(0, 0, LayoutManager.stageWidth, int(topBitmapData.height / 2) - 1);
			
			container.graphics.beginBitmapFill(bottomBitmapData, new Matrix(1, 0, 0, 1, 0, LayoutManager.stageHeight - topBitmapData.height + int(topBitmapData.height / 2) + 1), true, true);
			container.graphics.drawRect(0, LayoutManager.stageHeight - topBitmapData.height + int(topBitmapData.height / 2) + 1, LayoutManager.stageWidth, topBitmapData.height / 2);
			container.graphics.endFill();
		}
		
		private static function drawBackground(container:Sprite, backgroundBitmapData:BitmapData):void
		{
			container.graphics.clear();
			
			container.graphics.beginBitmapFill(backgroundBitmapData, new Matrix(LayoutManager.stageWidth / backgroundBitmapData.width, 0, 0, LayoutManager.stageHeight / backgroundBitmapData.height), true, true);
			container.graphics.drawRect(0, 0, LayoutManager.stageWidth, LayoutManager.stageHeight);
			container.graphics.endFill();
		}
		
		private static function drawRepeatBackround(container:Sprite, backgroundBitmapData:BitmapData):void
		{
			container.graphics.clear();
			
			container.graphics.beginBitmapFill(backgroundBitmapData, new Matrix(1, 0, 0, 1), true, true);
			container.graphics.drawRect(0, 0, LayoutManager.stageWidth + LayoutManager.stageOffsetX * 2, LayoutManager.stageHeight + LayoutManager.stageOffsetY * 2);
			container.graphics.endFill();
		}
		
		private static function drawPicture(container:Sprite, backgroundBitmapData:BitmapData):void
		{
			container.graphics.clear();
			
			container.graphics.beginBitmapFill(backgroundBitmapData, new Matrix(1, 0, 0, 1), true, true);
			container.graphics.drawRect(0, 0, backgroundBitmapData.width, backgroundBitmapData.height);
			container.graphics.endFill();
		}
		
		private static function drawColorBackground(container:Sprite, color:uint = 0, alpha:Number = 0):void
		{
			container.graphics.clear();
			
			container.graphics.beginFill(color, alpha);
			container.graphics.drawRect(0, 0, LayerManager.singleton.stage.stageWidth, LayerManager.singleton.stage.stageHeight);
			container.graphics.endFill();
		}
		
		private static function drawColorFrame(container:Sprite, color:uint = 0, alpha:Number = 0):void
		{
			container.graphics.clear();
			
			container.graphics.beginFill(color, alpha);
			container.graphics.drawRect(0, 0, LayerManager.singleton.stage.stageWidth, LayerManager.singleton.stage.stageHeight);
			container.graphics.drawRect(LayoutManager.stageOffsetX, LayoutManager.stageOffsetY, LayoutManager.stageWidth, LayoutManager.stageHeight);
			container.graphics.endFill();
		}
		
		private static function getBackgroundIndex():int
		{
			if(m_backgroundIndex == int.MAX_VALUE)
			{
				m_backgroundIndex = 0;
			}
			
			return m_backgroundIndex ++;
		}
		}
}

import flash.display.BitmapData;
import flash.display.Sprite;

class BackgroundInfo
{
	public var def:int;
	public var layer:String;
	public var index:int;
	public var contianer:Sprite;
	public var topBitmapData:BitmapData;
	public var bottomBitmapData:BitmapData;
	public var backgroundBitmapData:BitmapData;
	public var isPushBackground:Boolean = true;
	
	public var color:uint;
	public var alpha:Number;
	
	public function BackgroundInfo(def:int, layer:String, index:int, contianer:Sprite)
	{
		this.def = def;
		this.layer = layer;
		this.contianer = contianer;
		this.index = index;
	}
}