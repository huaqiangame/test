package com.tencent.morefun.naruto.plugin.map.controls
{
	import com.tencent.morefun.naruto.util.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import map.data.MapBgImgInfo;
	import map.data.MapData;
	import map.data.MapFgImgInfo;
	import map.data.MapMgImgInfo;
	import map.def.MapLayerDef;
	import map.images.MapMme;
	import map.images.MapTile;
	
	public class MapControl
	{
		private static var tempRect:Rectangle = new Rectangle(); // 计算缩略图用的
		
		public var mapData:MapData;
		public var baseBitmap:Bitmap; // 缩略图
		private var mapBgImgInfos:Dictionary;
		private var mapMgImgInfos:Dictionary;
		private var mapFgImgInfos:Dictionary;
		
		private var baseBitmapImgPixelWidth:Number; // 缩略图的单元宽度
		private var baseBitmapImgPixelHeight:Number; // 缩略图的单元高度
		
		private var alphaBitmapData:BitmapData;
		private var layers:Vector.<Sprite>;
		
		private var mapTiles:Dictionary;
		private var mapMmes:Dictionary;
		
		public function MapControl(layers:Vector.<Sprite>)
		{
			this.layers = layers;
			
			this.mapTiles = new Dictionary();
			this.mapMmes = new Dictionary();
		}
		
		public function play():void
		{
			for each(var mmes:Vector.<MapMme> in mapMmes)
			{
				for each(var mme:MapMme in mmes)
				{
					mme.isActive = true;
				}
			}
		}
		
		public function stop():void
		{
			for each(var mmes:Vector.<MapMme> in mapMmes)
			{
				for each(var mme:MapMme in mmes)
				{
					mme.isActive = false;
				}
			}
		}
		
		public function dispose():void
		{
			for each(var tile:MapTile in mapTiles)
			{
				tile.destroy();
			}
			this.mapTiles = new Dictionary();
			for each(var mmes:Vector.<MapMme> in mapMmes)
			{
				for each(var mme:MapMme in mmes)
				{
					mme.destroy();
				}
				mmes.fixed = false;
				mmes.length = 0;
			}
			this.mapMmes = new Dictionary();
			this.alphaBitmapData = null;
			this.baseBitmap = null;
			this.mapData = null;
			this.mapBgImgInfos = null;
			this.mapMgImgInfos = null;
			this.mapFgImgInfos = null;
		}
		
		public function destroy():void
		{
			dispose();
			this.mapTiles = null;
			this.mapMmes = null;
			this.layers = null;
		}
		
		public function setData(mapBgImgInfos:Dictionary, mapMgImgInfos:Dictionary, mapFgImgInfos:Dictionary, mapData:MapData, baseBitmap:Bitmap, alphaBitmapData:BitmapData):void
		{
			this.mapBgImgInfos = mapBgImgInfos;
			this.mapMgImgInfos = mapMgImgInfos;
			this.mapFgImgInfos = mapFgImgInfos;
			this.mapData = mapData;
			this.baseBitmap = baseBitmap;
			this.alphaBitmapData = alphaBitmapData;
			this.baseBitmapImgPixelWidth = this.baseBitmap.width/this.mapData.mapPixelWidth*this.mapData.imgPixelWidth;
			this.baseBitmapImgPixelHeight = this.baseBitmap.height/this.mapData.mapPixelHeight*this.mapData.imgPixelHeight;
		}
		
		public function update(viewpoint:Rectangle):void
		{
			var bx:int = (viewpoint.x-100)/mapData.imgPixelWidth;
			var by:int = (viewpoint.y-100)/mapData.imgPixelHeight;
			var ex:int = (viewpoint.right+100)/mapData.imgPixelWidth;
			var ey:int = (viewpoint.bottom+100)/mapData.imgPixelHeight;
			checkOutViewpoint(bx,by,ex,ey);
			checkInViewpoint(bx,by,ex,ey);
		}
		
		private var checkOutViewpoint_arr:Array = [];
		private function checkOutViewpoint(bx:int,by:int,ex:int,ey:int):void
		{
			for each(var layer:Sprite in layers)
			{
				for(var i:int=layer.numChildren-1; i >= 0; i--)
				{
					var dobj:DisplayObject = layer.getChildAt(i);
					if (dobj is MapTile)
					{
						var tile:MapTile = dobj as MapTile;
						if(tile.cfg.imgX < bx || tile.cfg.imgX > ex || tile.cfg.imgY < by || tile.cfg.imgY > ey)
						{
//							tile.outViewpoint();
							checkOutViewpoint_arr.push(tile);
						}
					}else if(dobj is MapMme)
					{
						var mme:MapMme = dobj as MapMme;
						if(mme.cfg.imgX < bx || mme.cfg.imgX > ex || mme.cfg.imgY < by || mme.cfg.imgY > ey)
						{
//							mme.outViewpoint();
							checkOutViewpoint_arr.push(mme);
						}
					}
				}
			}
			
			for each(var obj:Object in checkOutViewpoint_arr)
			{
				obj.outViewpoint();
			}
			checkOutViewpoint_arr.length = 0;
		}
		
		private function checkInViewpoint(bx:int,by:int,ex:int,ey:int):void
		{
			var ox:int = (bx + ex) >> 1;
			var oy:int = (by + ey) >> 1;
			var lenx:int = (ex - bx + 1) >> 1;
			var leny:int = (ey - by + 1) >> 1;
			var ix:int;
			var iy:int;
			
			for(;ix<=lenx || iy<= leny; ix++,iy++)
			{
				this.getBounds(ox,oy,ix,iy);
				var num:int = this.boundsX.length;
				for (var i:int = 0; i < num; i++)
				{
					var x:int = this.boundsX[i];
					var y:int = this.boundsY[i];
					if (bx <= x && x <= ex && by <= y && y <= ey)
					{
						checkInViewpointGridBg(x,y);
						checkInViewpointGridMg(x,y);
					}
					
					if(ix==0&&iy==0)
					{
						break;
					}
				}
			}
		}
		
		private var boundsX:Vector.<int> = new Vector.<int>();
		private var boundsY:Vector.<int> = new Vector.<int>();
		private function getBounds(x:int,y:int,offsetX:int,offsetY:int):void
		{
			this.boundsX.length = 0;
			this.boundsY.length = 0;
			if (offsetX == 0 && offsetY == 0)
			{
				this.boundsX.push(x);
				this.boundsY.push(y);
				return;
			}
			
			var dx:int = x - offsetX;
			var addX:int = x + offsetX;
			var dy:int = y - offsetY;
			var addY:int = y + offsetY;
			for (var i:int = dx; i <= addX; i++)
			{
				for (var j:int = dy; j <= addY; j++)
				{
					if (i == dx || i == addX || j == dy || j == addY)
					{
						this.boundsX.push(i);
						this.boundsY.push(j);
					}
				}
			}
		}
		
		private static const MME_EXT:String = ".swf";
		
		/**
		 * 检测进入屏幕的背景网格
		 * @param ix
		 * @param iy
		 */
		private function checkInViewpointGridBg(ix:int, iy:int):void
		{
			var info:MapBgImgInfo = mapBgImgInfos[ix*1000+iy];
			if(info == null)
			{
				return;
			}
			var tile:MapTile = mapTiles[ix*1000+iy];
			if(tile == null)
			{
				var frontInfo:MapFgImgInfo = mapFgImgInfos[ix*1000+iy];
				var toX:int = info.imgX * mapData.imgPixelWidth;
				var toY:int = info.imgY * mapData.imgPixelHeight;
				
				var thumbBmd:BitmapData = new BitmapData(this.baseBitmapImgPixelWidth, this.baseBitmapImgPixelHeight, true, 0);
				MapControl.tempRect.x = int(ix * this.baseBitmapImgPixelWidth);
				MapControl.tempRect.y = int(iy * this.baseBitmapImgPixelHeight);
				MapControl.tempRect.width = this.baseBitmapImgPixelWidth;
				MapControl.tempRect.height = this.baseBitmapImgPixelWidth;
				thumbBmd.copyPixels(this.baseBitmap.bitmapData, MapControl.tempRect, MathUtil.ZERO_POINT);
				var thumbBmp:Bitmap = new Bitmap();
				thumbBmp.bitmapData = thumbBmd;
				thumbBmp.width = this.mapData.imgPixelWidth;
				thumbBmp.height = this.mapData.imgPixelHeight;
				thumbBmp.x = toX;
				thumbBmp.y = toY;
				
				
				tile = new MapTile();
				tile.x = toX;
				tile.y = toY;
				(tile as MapTile).initialize(info, frontInfo, layers[MapLayerDef.BOTTOM_MAP], layers[MapLayerDef.FRONT_MAP], alphaBitmapData, thumbBmp);
				mapTiles[ix*1000+iy] = tile;
			}
			
			tile.inViewpoint();
		}
		
		
		/**
		 * 检测移出屏幕的背景网格
		 * @param ix
		 * @param iy
		 */
		private function checkOutViewpointGridBg(ix:int, iy:int):void
		{
			var info:MapBgImgInfo = mapBgImgInfos[ix*1000+iy];
			if(info == null)
			{
				return;
			}
			
			var tile:MapTile = mapTiles[ix*1000+iy];
			if(tile)
			{
				tile.outViewpoint();
			}
		}
		
		/**
		 * 检测进入屏幕的中景网格
		 * @param ix
		 * @param iy
		 */
		private function checkInViewpointGridMg(ix:int, iy:int):void
		{
			var infos:Array = mapMgImgInfos[ix*1000+iy];
			if(infos == null)
			{
				return;
			}
			
			var mapSwfVector:Vector.<MapMme> = mapMmes[ix*1000 + iy];
			if(mapSwfVector == null)
			{
				mapMmes[ix*1000 + iy] = mapSwfVector = new Vector.<MapMme>(infos.length,true);
			}
			
			for(var i:int=0;i<mapSwfVector.length;i++)
			{
				var info:MapMgImgInfo = infos[i];
				var mme:MapMme = mapSwfVector[i];
				if(mme == null)
				{
					mapSwfVector[i] = mme = new MapMme(info, layers[info.subLayerIndex+1]);
				}
				mme.transform.matrix = info.matrix;
				mme.x = info.imgX * mapData.imgPixelWidth + info.offsetX;
				mme.y = info.imgY * mapData.imgPixelHeight + info.offsetY;
				mme.inViewpoint();
			}
		}
		
		/**
		 * 检测移出屏幕的中景网格
		 * @param ix
		 * @param iy
		 */
		private function checkOutViewpointGridMg(ix:int, iy:int):void
		{
			var infos:Array = mapMgImgInfos[ix*1000+iy];
			if(infos == null)
			{
				return;
			}
			
			var mapSwfVector:Vector.<MapMme> = mapMmes[ix*1000 + iy];
			if(mapSwfVector == null)
			{
				return;
			}
			
			for(var i:int=0;i<mapSwfVector.length;i++)
			{
				var mme:MapMme = mapSwfVector[i];
				if(mme)
				{
					mme.outViewpoint();					
				}
			}
		}
		
	}
}