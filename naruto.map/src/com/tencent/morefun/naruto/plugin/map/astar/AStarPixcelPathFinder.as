package com.tencent.morefun.naruto.plugin.map.astar
{
	import com.tencent.morefun.naruto.util.MathUtil;
	
	import flash.geom.Point;
	
	import base.MapGridUtil;
	
	import map.data.MapData;
	import map.def.ShortenPathType;

	public class AStarPixcelPathFinder extends AStarPathFinder
	{
		public function AStarPixcelPathFinder()
		{
			super();
		}
		
//		override public function find(beginPixcelPoint:Point, endPixcelPoint:Point):Array
//		{
//			var beginTilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, beginPixcelPoint.x, beginPixcelPoint.y);
//			var endTilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, endPixcelPoint.x, endPixcelPoint.y);
//			
////			var beginTilePoint:Point = pixcel2tile(beginPixcelPoint);
////			var endTilePoint:Point = pixcel2tile(endPixcelPoint);
//			
//			var rs:Array = super.find(beginTilePoint, endTilePoint);
//			if(rs)
//			{
//				var rs2:Array = [];
//				var len:int = rs.length;
//				//从1开始，第0个是启始坐标
//				for(var i:int=1;i<len;i++)
//				{
//					var tp:Point = rs[i];
//					var pp:Point = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tp.x, tp.y);
//					rs2.push(pp);
//				}
//				return rs2;
//			}
//			return null;
//		}
		
		public function findByPixcel(beginPoint:Point, endPoint:Point, shorten:int=0, shortenType:int = 0):Array
		{
			MapGridUtil.resetPoint();
			MapData.resetPoint();
			var beginTilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, beginPoint.x, beginPoint.y);
			var endTilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, endPoint.x, endPoint.y);
			
			//			var beginTilePoint:Point = pixcel2tile(beginPixcelPoint);
			//			var endTilePoint:Point = pixcel2tile(endPixcelPoint);
			
			if(!mapData.getWalkable(beginTilePoint.x, beginTilePoint.y))
			{
				return null;
			}
			
			if(endTilePoint.x < 0)
			{
				endTilePoint.x = 0;
			}else if(endTilePoint.x > mapData.mapTileWidth - 1)
			{
				endTilePoint.x = mapData.mapTileWidth - 1;
			}
			if(endTilePoint.y < 0)
			{
				endTilePoint.y = 0;
			}else if(endTilePoint.y > mapData.mapTileHeight - 1)
			{
				endTilePoint.y = mapData.mapTileHeight - 1;
			}
			
			if(!mapData.getWalkable(endTilePoint.x, endTilePoint.y))
			{
				endTilePoint = getNearestEndPoint(beginTilePoint, endTilePoint);
			}
			
			if(endTilePoint == null)
			{
				return null;
			}
			
			var rs:Array = super.find(beginTilePoint, endTilePoint);
			if(shorten>0 && rs && rs.length>0)
			{
				rs = shortenPath(rs,shorten, shortenType);
			}
			
//			for each(var tmp:Point in rs)
//			{
//				if(mapData.getWalkable(tmp.x,tmp.y)==false)
//				{
//					trace("xxxxxxxxxx")
//				}
//			}
			
			if(rs)
			{
				var len:int = rs.length;
				var rs2:Array = new Array();
				for(var i:int=0;i<len;i++)
				{
					var a:Point = rs[i];
					rs2.push(a);
					for(var j:int=len-1;j>=i+2;j--)
					{
						var b:Point = rs[j];
						
						if(canGoStraight(a,b))
						{
							i=j-1;
							break;
						}
					}
				}
				
				var rs3:Array = new Array();
				len = rs2.length;
				
				for(i=0;i<len;i++)
				{
					var tp:Point = rs2[i];
					var pp:Point = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tp.x, tp.y);
					if(i==0)
					{
						rs3.push(pp);
						continue;
					}
					//从1开始，第0个是启始坐标
					
					
					
					var lastTp:Point = rs2[i-1];
					if (!canGoStraight(lastTp,tp))
					{
						subtleAdjustPoint(lastTp, tp, pp);
						rs3.push(pp);
						if(i==len-1)
						{
							rs3.push(MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tp.x, tp.y));
						}
					}else
					{
						rs3.push(pp);
					}
					
//					rs3.push(pp);
//					
//					if(i == len-1) 
//					{
//						rs3.push(MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tp.x, tp.y));
//					}
				}
				return rs3;
			}
			return null;
		}
		
		private function canGoStraight(startTile:Point, endTile:Point):Boolean
		{
			var tilePointArr:Array = mapData.passedTile2(startTile, endTile);
			for each (var tilePoint:Point in tilePointArr)
			{
				if (tilePoint.equals(startTile))
				{
					continue;
				}
				if (mapData.getWalkable(tilePoint.x, tilePoint.y) == false)
				{
					return false;
				}
			}
			return true;
		}
		
		private function subtleAdjustPoint(currentTile:Point, nextTile:Point, nextTilePixel:Point):void
		{
			if (nextTile.x > currentTile.x && nextTile.y > currentTile.y)
			{
				nextTilePixel.y -= mapData.tilePixelHeight/2;
			}
			else if (nextTile.x > currentTile.x && nextTile.y < currentTile.y)
			{
				nextTilePixel.x -= mapData.tilePixelWidth/2;
			}
			else if (nextTile.x < currentTile.x && nextTile.y < currentTile.y)
			{
				nextTilePixel.y += mapData.tilePixelHeight/2;
			}
			else if (nextTile.x < currentTile.x && nextTile.y > currentTile.y)
			{
				nextTilePixel.x += mapData.tilePixelWidth/2;
			}
		}
		
		private function getNearestEndPoint(beginTilePoint:Point, endTilePoint:Point):Point
		{
			var passedTile:Array = mapData.passedTile2(beginTilePoint, endTilePoint);
			for (var i:int = passedTile.length-1; i>=0; i--)
			{
				if (mapData.getWalkable(passedTile[i].x, passedTile[i].y) == true)
				{
					return passedTile[i];
				}
			}
			
			return null;
		}
		
		public function shortenPathByPixcels(pixcelPointArr:Array, length:int, shortenType:int = 0):Array
		{
			var resultArr:Array;
			var tempTilePointArr:Array;
			var tempPixelPoint:Point;
			var outRangePixelPoint:Point;
			var inRangePixelPoint:Point;
			var tempTilePoint:Point;
			var targetPixelPoint:Point;
			var selectablePoints:Array;
			var firstOutRangePoint:Point;
			var firstInRangePoint:Point;
			var finalEndPoint:Point;
			var nearestDistance:Number;
			
			
			if (length <= 0 || pixcelPointArr.length < 2)  //只有一个点
			{
				return pixcelPointArr;
			}
			
			targetPixelPoint = pixcelPointArr[pixcelPointArr.length-1] as Point;
			
			//取一个路径中超出要截断距离的点
			for (var i:int = pixcelPointArr.length-1; i >= 0; i--)
			{
				tempPixelPoint = pixcelPointArr[i] as Point;
				if (Point.distance(tempPixelPoint, targetPixelPoint) > length)
				{
					outRangePixelPoint = tempPixelPoint;
					break;
				}
			}
			
			resultArr = new Array();
			if (!outRangePixelPoint)  //如果所有点都没有超出要截断的距离，就截断到只剩下第一个点
			{
				resultArr.push(pixcelPointArr[0]);
				return resultArr;
			}
			else  //否则，先把超出距离的点全部放入截断结果中
			{
				for (i = 0; i <= pixcelPointArr.indexOf(outRangePixelPoint); i++)
				{
					resultArr.push(pixcelPointArr[i]);
				}
			}
			
			//其实这样取的话inRangePixelPoint有可能到targetPixelPoint的距离就等于length，不一定在范围里面，而是在边上
			inRangePixelPoint = pixcelPointArr[pixcelPointArr.indexOf(outRangePixelPoint)+1];
			resultArr.push(MathUtil.crossPointOfCircleAndLine(targetPixelPoint, length, outRangePixelPoint, inRangePixelPoint));
			
			
			return resultArr;
		}
		
		public function shortenPath(tilePointArr:Array, length:int, shortenType:int = 0):Array
		{
			var resultArr:Array;
			var tempTilePointArr:Array;
			var tempPixelPoint:Point;
			var outRangePoint:Point;
			var inRangePoint:Point;
			var tempTilePoint:Point;
			var targetPixelPoint:Point;
			var selectablePoints:Array;
			var firstOutRangePoint:Point;
			var firstInRangePoint:Point;
			var finalEndPoint:Point;
			var nearestDistance:Number;
			
			
			if (length <= 0 || tilePointArr.length < 2)  //只有一个点
			{
				return tilePointArr;
			}

			tempTilePoint = tilePointArr[tilePointArr.length-1] as Point;
			targetPixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tempTilePoint.x, tempTilePoint.y);
			
			//取一个路径中超出要截断距离的点
			for (var i:int = tilePointArr.length-1; i >= 0; i--)
			{
				tempTilePoint = tilePointArr[i] as Point;
				tempPixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tempTilePoint.x, tempTilePoint.y);
				if (Point.distance(tempPixelPoint, targetPixelPoint) > length)
				{
					outRangePoint = tempTilePoint;
					break;
				}
			}
			
			resultArr = new Array();
			if (!outRangePoint)  //如果所有点都没有超出要截断的距离，就截断到只剩下第一个点
			{
				resultArr.push(tilePointArr[0]);
				return resultArr;
			}
			else  //否则，先把超出距离的点全部放入截断结果中
			{
				for (i = 0; i <= tilePointArr.indexOf(outRangePoint); i++)
				{
					resultArr.push(tilePointArr[i]);
				}
			}
				
			selectablePoints = new Array();
			selectablePoints.push(outRangePoint);   //先把超出距离的点放入待选择点的数组
			for (i = tilePointArr.indexOf(outRangePoint) + 1; i < tilePointArr.length; i++)
			{
				tempTilePoint = tilePointArr[i] as Point;
				tempPixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tempTilePoint.x, tempTilePoint.y);
				
				tempTilePointArr = mapData.passedTile2(tilePointArr[i-1] as Point, tempTilePoint);
				tempTilePointArr.splice(0,1);  //把第一个点去掉，因为连接起来会有重复
				selectablePoints = selectablePoints.concat(tempTilePointArr);
				
				if (Point.distance(tempPixelPoint, targetPixelPoint) < length)
				{
					inRangePoint = tempTilePoint;
					break;
				}
			}
			
			//剔除细化点中的不可行走点
			for (i = selectablePoints.length-1; i >= 0; i--)
			{
				tempTilePoint = selectablePoints[i] as Point;
				if (!mapData.getWalkable(tempTilePoint.x, tempTilePoint.y))
				{
					selectablePoints.splice(i, 1);
				}
			}
			
			//取细化了的点中第一个在截取范围以内的点
			for (i = 0; i < selectablePoints.length; i++)
			{
				tempTilePoint = selectablePoints[i] as Point;
				tempPixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tempTilePoint.x, tempTilePoint.y);
				
				if (Point.distance(tempPixelPoint, targetPixelPoint) < length)
				{
					firstInRangePoint = tempTilePoint;
					break;
				}
			}
			
			//取细化了的点中在截取范围以外，并且离终点距离最短的点
			for (i = selectablePoints.length - 1; i >= 0; i--)
			{
				tempTilePoint = selectablePoints[i] as Point;
				tempPixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tempTilePoint.x, tempTilePoint.y);
				
				if (Point.distance(tempPixelPoint, targetPixelPoint) > length)
				{
//					var tempValue:Number = Point.distance(tempPixelPoint, targetPixelPoint);
					firstOutRangePoint = tempTilePoint;
					break;
				}
			}
			
			//确定最终停止的细化点
			if (shortenType == ShortenPathType.CEIL)
			{
				finalEndPoint = firstOutRangePoint;
			}
			else if (shortenType == ShortenPathType.FLOOR)
			{
				finalEndPoint = firstInRangePoint;
			}
			else  
			{
				finalEndPoint = firstOutRangePoint;
				tempPixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, firstOutRangePoint.x, firstOutRangePoint.y);
				nearestDistance = Point.distance(tempPixelPoint, targetPixelPoint);
				
				for (i = selectablePoints.indexOf(firstOutRangePoint)+1; i <= selectablePoints.indexOf(firstInRangePoint); i++)
				{
					tempTilePoint = selectablePoints[i] as Point;
					tempPixelPoint = MapGridUtil.getPixelPoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, tempTilePoint.x, tempTilePoint.y);
					if (Point.distance(tempPixelPoint, targetPixelPoint) < nearestDistance)
					{
						finalEndPoint = tempTilePoint;
						nearestDistance = Point.distance(tempPixelPoint, targetPixelPoint);
					}
				}
			}
			
			//把最终停止的点放入结果数组
			if (!finalEndPoint.equals(outRangePoint))
			{
				resultArr.push(finalEndPoint);
			}
			
			return resultArr;
		}
		
		
		
//		public function pixcel2tile(pixcel:Point):Point
//		{
//			var tw:int = mapData.mapTileWidth;
//			var th:int = mapData.mapTileHeight;
//			var pw:int = mapData.mapPixelWidth;
//			var ph:int = mapData.mapPixelHeight;
//			
//			
//			var tileEdge:Number = Math.sqrt(pw*pw + ph*ph) / 2;
//			var tan:Number = ph / pw;
//			var sin:Number = (th / 2) / tileEdge;
//			var cos:Number = (tw / 2) / tileEdge;
//			
//			var tempA:Number = (pixcel.y + tan * pw / 2) / sin;
//			var tempB:Number = (pw / 2 - pixcel.x) / cos;
//			
//			var ly:Number = (tempA + tempB) / 2;
//			var lx:Number = (tempA - tempB) / 2;
//			
//			var tx:int = lx / tileEdge; 
//			var ty:int = ly / tileEdge; 
//			
//			return new Point(tx,ty);
//		}
//		
//		public function tile2pixcel(tile:Point):Point
//		{
//			var tw:int = mapData.mapTileWidth;
//			var th:int = mapData.mapTileHeight;
//			var pw:int = mapData.mapPixelWidth;
//			var ph:int = mapData.mapPixelHeight;
//			
//			
//			var tileEdge:Number = Math.sqrt(tw*tw + th*th) / 2;
//			var tan:Number = th / tw;
//			var sin:Number = (th / 2) / tileEdge;
//			var cos:Number = (tw / 2) / tileEdge;
//
//			
//			var x:int = pw / 2 - (tile.y-tile.x)*tileEdge * cos;
//			var y:int = -tan * pw / 2 + (tile.y+tile.x+1)*tileEdge * sin;
//			
//			return new Point(x, y);
//		}
		
		public function getRandomPixcel(oriPoint:Point, offsetRange:int):Point
		{
			var oriTilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, oriPoint.x, oriPoint.y);
			
			var ra:Number = Math.random()*Math.PI*2;
			var rx:int = oriPoint.x + Math.random() * offsetRange * Math.cos(ra);
			var ry:int = oriPoint.y + Math.random() * offsetRange * Math.sin(ra);
			if(rx<0)
			{
				rx = 0;
			}else if(rx>mapData.mapPixelWidth)
			{
				rx = mapData.mapPixelWidth;
			}
			if(ry<0)
			{
				ry = 0;
			}else if(ry>mapData.mapPixelHeight)
			{
				ry = mapData.mapPixelHeight;
			}
			
			var newPoint:Point = new Point(rx,ry);
			var newTilePoint:Point = MapGridUtil.getTilePoint(mapData.tilePixelWidth, mapData.tilePixelHeight, mapData.mapPixelWidth, rx, ry);
			if(mapData.getWalkable(newTilePoint.x,newTilePoint.y))
			{
				return newPoint;
			}
			
			return null;
		}
	}
}