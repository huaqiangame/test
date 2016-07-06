package com.tencent.morefun.naruto.plugin.map.executer
{
	import com.tencent.morefun.framework.base.Command;
	import com.tencent.morefun.naruto.model.event.ModelEvent;
	import com.tencent.morefun.naruto.plugin.map.astar.AStarPixcelPathFinder;
	import com.tencent.morefun.naruto.plugin.map.views.MapView;
	import com.tencent.morefun.naruto.plugin.ui.layer.LayerManager;
	import com.tencent.morefun.naruto.plugin.ui.layer.def.LayerDef;
	
	import flash.geom.Point;
	
	import base.MapGridUtil;
	import base.NarutoExecuter;
	
	import battle.data.BattleInfo;
	import battle.def.BattleKeyDef;
	
	import def.ExecuterDef;
	import def.ModelDef;
	import def.PluginDef;
	
	import map.command.HideMoveTargetUiCommand;
	import map.command.ImitateSceneClickCommand;
	import map.command.ShowMoveTargetUiCommand;
	import map.commands.AddMapElementCommand;
	import map.commands.BindCameraMapElementCommand;
	import map.commands.CleanMapCommand;
	import map.commands.ConvertMapPointCommand;
	import map.commands.FindPathMapCommand;
	import map.commands.GetMapDataCommand;
	import map.commands.GetPassTilePixelArrCommand;
	import map.commands.GetPixelBlockCommand;
	import map.commands.GetPixelWalkableCommand;
	import map.commands.GetRandomPixcelCommand;
	import map.commands.LadeMapCommand;
	import map.commands.SetCameraPositionCommand;
	import map.commands.ShortenPathMapCommand;
	import map.data.MapData;
	
	import player.commands.SelfMoveToPixcelCommand;
	
	public class MapViewExecuter extends NarutoExecuter
	{
		private var mapView:MapView;
		private var mapData:MapData;
		private var pathFinder:AStarPixcelPathFinder;
		
		public function MapViewExecuter()
		{
			super(PluginDef.MAP, ExecuterDef.MAP_VIEW);
			
			mapView = new MapView();
			LayerManager.singleton.addItemToLayer(mapView, LayerDef.MAP_DEF);
			mapData = new MapData();
			pathFinder = new AStarPixcelPathFinder();
			
			(plugin.retrieveModel(ModelDef.BATTLE) as BattleInfo).addEventListener(ModelEvent.UPDATE, onBattleInfo);
		}
		
		protected function onBattleInfo(event:ModelEvent):void
		{
			switch(event.key)
			{
				case BattleKeyDef.START:
					mapView.mapControl.stop();
					break;
				case BattleKeyDef.FAIL:
				case BattleKeyDef.END:
					mapView.mapControl.play();
					break;
			}
		}
		
		override public function doCommand(cmd:Command):void
		{
			switch(true)
			{
				case cmd is LadeMapCommand:
					doLadeMapCommand(cmd as LadeMapCommand);
					break;
				case cmd is CleanMapCommand:
					doCleanMapCommand(cmd as CleanMapCommand);
					break;
				case cmd is ShowMoveTargetUiCommand:
					doShowMoveTargetUICommand(cmd as ShowMoveTargetUiCommand);
					break;
				case cmd is HideMoveTargetUiCommand:
					doHideMoveTargetUICommand(cmd as HideMoveTargetUiCommand);
					break;
				
				case cmd is BindCameraMapElementCommand:
					doBindCameraMapElementCommand(cmd as BindCameraMapElementCommand);
					break;
				case cmd is SetCameraPositionCommand:
					doSetCameraPositionCommand(cmd as SetCameraPositionCommand);
					break;
				case cmd is AddMapElementCommand:
					doAddMapElementCommand(cmd as AddMapElementCommand);
					break;
				case cmd is FindPathMapCommand:
					doFindPathCommand(cmd as FindPathMapCommand);
					break;
				case cmd is ShortenPathMapCommand:
					doShaortenPathCommand(cmd as ShortenPathMapCommand);
					break;
				
				case cmd is ImitateSceneClickCommand:
					doImitateSceneClickCommand();
					break;
				
				case cmd is GetPixelBlockCommand:
					doGetPixelBlockCommand(cmd as GetPixelBlockCommand);
					break;
				
				case cmd is GetPixelWalkableCommand:
					doGetPixelWalkableCommand(cmd as GetPixelWalkableCommand);
					break;
				case cmd is GetRandomPixcelCommand:
					doGetRandomPixcelCommand(cmd as GetRandomPixcelCommand);
					break;
				
				case cmd is GetPassTilePixelArrCommand:
					doGetPassTilePixelArrCommand(cmd as GetPassTilePixelArrCommand);
					break;
				
				case cmd is ConvertMapPointCommand:
					doConvertMapPointCommand(cmd as ConvertMapPointCommand);
					break;
				
				case cmd is GetMapDataCommand:
					doGetMapDataCommand(cmd as GetMapDataCommand);
					break;
			}
		}
		
		private function doGetRandomPixcelCommand(cmd:GetRandomPixcelCommand):void
		{
			var newPoint:Point = pathFinder.getRandomPixcel(cmd.oriPoint,cmd.offsetRange);
			cmd.newPoint = newPoint;
			cmd.finish();
		}
		
		private function doImitateSceneClickCommand():void
		{
			if(mapView.mouseX<0 || mapView.mouseY<0 || mapView.mouseX > mapView.width || mapView.mouseY > mapView.height)
			{
				return;
			}
			new SelfMoveToPixcelCommand(new Point(mapView.mouseX,mapView.mouseY)).call();
		}
		
		private function doLadeMapCommand(cmd:LadeMapCommand):void
		{
//			LayerManager.singleton.setAllLayerVisible(false);
//			LayerManager.singleton.setLayerVisible(LayerDef.MAP_DEF,true);
//			LayerManager.singleton.setLayerVisible(LayerDef.LOADING,true);
//			LayerManager.singleton.stage.addChild(mapView);
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.stage.addChild(new Sprite());
//			LayerManager.singleton.setLayerVisible(LayerDef.MAIN_UI,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.CHAT,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.FIGHT,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.FIGHT_UI,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.BATTLE_MASK_DEF,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.TEST,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.LOGIN,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.DEBUG,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.SETUP,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.UI_GAME,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.MODAL,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.BOX,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.DRAG_ICON,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.TIPS,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.VIDEO,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.GAME_TIP,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.BACKG_FRAME,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.MAIN_UI_NOTIFY,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.PLOT,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.STAGE_MASK,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.LOADING,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.FULL_LOADING,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.TEXT_BOX,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.MENU,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.WORLD_SNAPSHOT,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.PREWAR,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.PREWAR_UI,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.PREWAR_FORE_GROUND,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.BATTLE_FRAME,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.USER_INFO_CHANGE,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.GUIDE_UI,false);
//			LayerManager.singleton.setLayerVisible(LayerDef.GUIDE_UI_MASK,false);
			
			this.mapData.setData(cmd.mapData);
			this.pathFinder.setMapData(mapData);
			
			this.mapView.mapControl.setData(cmd.mapBgImgInfos, cmd.mapMgImgInfos, cmd.mapFgImgInfos, mapData, cmd.shrinkBitmap, cmd.alphaBitmap.bitmapData);
			this.mapView.eleControl.setTimeType(cmd.sceneInfo.time);
			this.mapView.cameraControl.setCenterPos(cmd.pos.x, cmd.pos.y);
			this.mapView.cameraControl.setData(LayerManager.singleton.stage);
			this.mapView.startup();
			
			cmd.finish();
			
//			selfInfo.state.addFlagChangedListenerByName(UserStateDef.BASE_NEWPLOT,onNewplot);
		}
		
		private function doCleanMapCommand(cmd:CleanMapCommand):void
		{
//			selfInfo.state.removeFlagChangedListenerByName(UserStateDef.BASE_NEWPLOT,onNewplot);
			mapView.dispose();
			pathFinder.dispose();
			cmd.finish();
		}
		
//		private function onNewplot():void
//		{
//			if(selfInfo.state.getFlagByName(UserStateDef.BASE_NEWPLOT) == false)
//			{
//				mapView.mapControl.update(mapView.scrollRect);
//			}
//		}
		
		
		private function doShowMoveTargetUICommand(cmd:ShowMoveTargetUiCommand):void
		{
			mapView.showMoveTargetUI(cmd.x,cmd.y);
			cmd.finish();
		}
		
		private function doHideMoveTargetUICommand(cmd:HideMoveTargetUiCommand):void
		{
			mapView.hideMoveTargetUI();
			cmd.finish();
		}
		
		private function doBindCameraMapElementCommand(cmd:BindCameraMapElementCommand):void
		{
			mapView.cameraControl.bindElement(cmd.element);
			cmd.finish();
		}
		
		private function doSetCameraPositionCommand(cmd:SetCameraPositionCommand):void
		{
			mapView.cameraControl.setCenterPos(cmd.x,cmd.y);
			cmd.finish();
		}
		
		private function doAddMapElementCommand(cmd:AddMapElementCommand):void
		{
			mapView.eleControl.addElement(cmd.element,cmd.layer);
			cmd.finish();
		}
		
		private function doFindPathCommand(cmd:FindPathMapCommand):void
		{
//			var rs:Array = pathFinder.find(cmd.beginPixcel,cmd.endPixcel);
			var rs:Array = pathFinder.findByPixcel(cmd.beginPixcel,cmd.endPixcel,cmd.shorten, cmd.shortenType);
			if(rs)
			{
//				drawPath(cmd.beginPixcel,rs);
				cmd.resultPixcels = rs;
				cmd.finish();
			}else
			{
				cmd.faild(1);
			}
		}
		
		
		private function doShaortenPathCommand(cmd:ShortenPathMapCommand):void
		{
			var rs:Array = pathFinder.shortenPathByPixcels(cmd.sourcePixcels,cmd.shortenLength,cmd.shortenType);
			cmd.resultPixcels = rs;
			cmd.finish();
		}
		
		
//		private var pathShape:Shape;
//		private function drawPath(beginPixcel:Point, ps:Array):void
//		{
//			if(pathShape==null)
//			{
//				pathShape = new Shape();
//			}
//			mapView.addChild(pathShape);
//			pathShape.graphics.clear();
//			pathShape.graphics.lineStyle(2,0xFF0000);
//			pathShape.graphics.beginFill(0xFF0000,0.5);
//			
////			pathShape.graphics.lineTo(1000,1000);
////			return;
//			if(ps)
//			{
//				pathShape.graphics.moveTo(beginPixcel.x,beginPixcel.y);
//				
//				var len:int = ps.length;
//				for(var i:int=0;i<len;i++)
//				{
//					pathShape.graphics.lineTo(ps[i].x,ps[i].y);
//					pathShape.graphics.drawCircle(ps[i].x,ps[i].y,5);
//					pathShape.graphics.moveTo(ps[i].x,ps[i].y);
//				}
//			}
//			
//		}
		
		private function doGetPixelBlockCommand(cmd:GetPixelBlockCommand):void
		{
			var tilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, cmd.pixelPoint.x, cmd.pixelPoint.y);
			cmd.block = mapData.getBlock(tilePoint.x, tilePoint.y);
			cmd.finish();
		}
		
		private function doGetPixelWalkableCommand(cmd:GetPixelWalkableCommand):void
		{
			var tilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, cmd.pixelPoint.x, cmd.pixelPoint.y);
			cmd.walkable = mapData.getWalkable(tilePoint.x,tilePoint.y);
			cmd.finish();
		}
		
		private function doGetPassTilePixelArrCommand(cmd:GetPassTilePixelArrCommand):void
		{
			var startTilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, cmd.startPixelPoint.x, cmd.startPixelPoint.y);
			var endTilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, cmd.endPixelPoint.x, cmd.endPixelPoint.y);
			var tileArr:Array = mapData.passedTile2(startTilePoint, endTilePoint);
			var pixelArr:Array = new Array();
			var pixelPoint:Point;
			
			for each (var pt:Point in tileArr)
			{
				pixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, pt.x, pt.y);
				pixelArr.push(pixelPoint);
			}
			cmd.passPixels = pixelArr;
			cmd.finish();
		}
		
		private function doConvertMapPointCommand(cmd:ConvertMapPointCommand):void
		{
			if (cmd.tilePoint)
			{
				cmd.pixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, cmd.tilePoint.x, cmd.tilePoint.y);
			}
			else if (cmd.pixelPoint)
			{
				cmd.tilePoint = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, cmd.pixelPoint.x, cmd.pixelPoint.y);
			}
			cmd.finish();
		}
		
		private function doGetMapDataCommand(cmd:GetMapDataCommand):void
		{
			cmd.mapData = this.mapData;
			cmd.finish();
		}
		
	}
}