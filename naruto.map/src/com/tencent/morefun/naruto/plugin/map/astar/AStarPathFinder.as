package com.tencent.morefun.naruto.plugin.map.astar
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import map.data.MapData;
	
	public class AStarPathFinder
	{
		//====================================
		//	Constants 评分标准 COST_HORIZONTAL 20 COST_VERTICAL 5 COST_DIAGONAL 12
		//====================================
		
		//横向移动一格的路径评分
		private const COST_HORIZONTAL : int = 10;
		//竖向移动一格的路径评分
		private const COST_VERTICAL : int = 10;
		//斜向移动一格的路径评分
		private const COST_DIAGONAL : int = 14;
		//拐弯的路径评分
		private const COST_TURN : int = 10;
		
		
		private var xMapStart:int;		//地图起始网格坐标
		private var yMapStart:int;		//地图起始网格坐标
		private var wMap:int;			//地图列数（每行格点数）
		private var hMap:int;			//地图行数（每列格点数）
		private var map:Dictionary;			//与地图行列相同的数组，存放节点

		private var openList:BinaryHeap;		//开放列表
		
		private var isFinded:Boolean = false;		//能否找到路径，true-已找到
		
		public var runTimeInMs:int = 0; 	//寻路时间
		
		protected var mapData:MapData;
		
		public function AStarPathFinder()
		{
			//全图寻路
			this.xMapStart = 0;
			this.yMapStart = 0;
//			this.hMap = useMap.mapTileHeight;
//			this.wMap = useMap.mapTileWidth;
			
			//显示范围内寻路
//			this.xMapStart = useMap.getXMapStart();
//			this.yMapStart = useMap.getYMapStart();
//			this.hMap = useMap.getMapDisHeight();
//			this.wMap = useMap.getMapDisWidth();
		}
		
		public function setMapData(mapData:MapData):void
		{
			this.mapData = mapData;
			
			this.hMap = mapData.mapTileHeight;
			this.wMap = mapData.mapTileWidth;
		}
		
		public function dispose():void
		{
			this.mapData = null;
		}
		
		public function find(startPoint:Point, endPoint:Point):Array
		{
			///// 运行时间 ////////////
			var startTime:int = getTimer();
			var expandNum:int = 0;
			//////////////////////////
			var currentNode:Node;
			var endNode:Node;
			var currentSignNode:Node;
			var endSignNode:Node;
			
			if (!mapData.getWalkable(startPoint.x, startPoint.y))
			{
				return [];
			}	
			
			initList();
			
			currentNode = getNode(startPoint.x, startPoint.y);
			endNode = getNode(endPoint.x, endPoint.y);
			endSignNode = getSignNode(endNode.x, endNode.y);
			
			this.isFinded = false;
			openList.push(currentNode);
			
			while(openList.length>0){
				//取出并删除开放列表第一个元素
				do{
					currentNode = openList.shift();
					currentSignNode = getSignNode(currentNode.x, currentNode.y);
				}
				while (currentSignNode.isInClose && openList.length>0);
				
				if (currentSignNode.isInClose) break;
				
				//加入到关闭列表
				currentNode.isInClose = true;
				currentSignNode.isInClose = true;
				
				//当前节点==目标节点
				if(currentSignNode.x==endSignNode.x && currentSignNode.y==endSignNode.y){
					this.isFinded = true;	//能达到终点，找到路径
					break;
				}
				
				//取相邻八个方向的节点，去除不可通过和以在关闭列表中的节点
				var aroundNodes:Array = this.getAroundsNode(currentNode.x, currentNode.y);
				expandNum++;
				
				for each (var node:Node in aroundNodes) //检测相邻的八个方向的节点
				{					
					//计算 G， H 值   
					var g:int = this.getGValue(currentNode, node);
					var h:int = this.getHValue(currentNode, node, endNode);
					
					if (node.indexInOpen != -1)	//如果节点已在播放列表中
					{
						//如果该节点新的G值比原来的G值小,修改F,G值，设置该节点的父节点为当前节点
						if (g+h < node.f)
						{
							node.g = g;
							node.h = h;
							node.f = g + h;
							node.parentNode = currentNode;
							
							openList.modify(node);
						}
					} 
					else //如果节点不在开放列表中
					{
						//插入开放列表中，并按照估价值排序
						node.g = g;
						node.h = h;
						node.f = g + h;
						node.parentNode = currentNode;
						openList.push(node);
					}
				}
			}
			
			var path:Array = (isFinded)? this.createPath(startPoint.x, startPoint.y, currentNode, endPoint) : null;
//			path = cutPathPoint(path);  //把多余的中间结点去掉，多余的意思是它前后两个结点直线可达
			
			///// 运行时间 ////////////
			this.runTimeInMs = getTimer() - startTime;
			//////////////////////////
			destroyLists();
			return path;
		}
		
		/**
		 * 生成路径数组
		 */
		private function createPath(xStart:int, yStart:int, endNode:Node, endPoint:Point):Array
		{
			var path:Array = new Array();			
			var node:Node = endNode;
			
			while (node.x != xStart || node.y != yStart)
			{
				path.unshift(new Point(node.x, node.y));
				node = node.parentNode;
			}
			path.unshift(new Point(node.x, node.y));
			
			if (!endPoint.equals(path[path.length-1]))
			{
				path.push(endPoint);
			}
			return path;
		}
				
		/**
		 * 计算G值
		 */
		private function getGValue(currentNode:Node, node:Node):int
		{
			var g:int = 0; 			
			var dx:int;
			var dy:int;
			dx = (currentNode.x - node.x) * this.COST_HORIZONTAL;
			dy = (currentNode.y - node.y) * this.COST_VERTICAL;			
			g = currentNode.g + Math.sqrt(dx*dx + dy*dy);
			
//			if (turned(currentNode.parentNode, currentNode, node))
//			{
//				g += COST_TURN;
//			}
			return g;
		}
		
		/**
		 * 计算H值
		 */
		private function getHValue(currentNode:Node, node:Node, endNode:Node):int
		{
			var value:int;
			var dx:int;
			var dy:int;
			dx = (endNode.x - node.x) * this.COST_HORIZONTAL;
			dy = (endNode.y - node.y) * this.COST_VERTICAL;
						
			value = Math.sqrt(dx*dx + dy*dy);
			
			return value;
		}
		
		/**
		 * 得到周围八方向节点
		 */
		private function getAroundsNode(x:int, y:int):Array
		{
			var aroundNodes:Array = new Array();
			
			var node:Node;
			var expandSignNode:Node;
			var signX:int;
			var signY:int;
			var w:int;
			var h:int;
			var pt:Point;
			
			if (mapData.getIsSign(x,y))
			{
				signX = x;
				signY = y;
			}
			else
			{
				pt = mapData.getSign(x,y);
				signX = pt.x;
				signY = pt.y;
			}
			
			pt = mapData.getSign(signX,signY);
			w = pt.x;
			h = pt.y;
			
			for (var checkX:int = signX-1; checkX <= signX + w; checkX += (w+1))
			{
				for (var checkY:int = signY-1; checkY <= signY+h; checkY++)
				{
					if (isWalkable(checkX, checkY))
					{

						node = getNode(checkX, checkY);
						expandSignNode = getSignNode(checkX, checkY);
						if (!(expandSignNode.isInClose))
						{
							aroundNodes.push(node);
						}
					}
				}
			}
			
			for (checkY = signY-1; checkY <= signY+h; checkY += (h+1))
			{
				for (checkX = signX; checkX < signX+w; checkX++)
				{
					if (isWalkable(checkX, checkY))
					{
						node = getNode(checkX, checkY); 
						expandSignNode = getSignNode(checkX, checkY);
						if (!(expandSignNode.isInClose))
						{
							aroundNodes.push(node);
						}
					}
				}
			}
			return aroundNodes;
		}
		
		/**
		 * 检查点在地图上是否可通过
		 */
		private function isWalkable(x:int, y:int):Boolean
		{
			// 1. 是否是有效的地图上点（数组边界检查）
			if (x < this.xMapStart || x >= this.wMap) 
			{
				return false;
			}
			if (y < this.yMapStart || y >= this.hMap)
			{
				return false;
			}
			// 2. 是否是walkable
			return mapData.getWalkable(x, y);
		}
		
		
		/**
		 * 使用节点初始化一个行列与地图格点相同的数组
		 */
		private function initList()	:void
		{
			openList ||= new BinaryHeap();		
			map ||= new Dictionary();
		}
		
		/**
		 * 销毁数组
		 */
		private function destroyLists():void
		{
			openList.clear();
			for(var k1:String in map)
			{
				for(var k2:String in map[k1])
				{
					delete map[k1][k2];
				}
				delete map[k1];
			}
		}
		
		private function getNode(x:int, y:int):Node
		{
			if (map[y] == undefined)
			{
				map[y] = new Dictionary();
			}
			if (map[y][x] == undefined)
			{
				map[y][x] = new Node(x,y);
			}
			return map[y][x] as Node;
		}
		
		private function turned(lastNode:Node, currentNode:Node, nextNode:Node):Boolean
		{
			if (lastNode == null) 
			{
				return false;
			}
						
			var dy1:int = currentNode.y - lastNode.y;
			var dx1:int = currentNode.x - lastNode.x;
			var dy2:int = nextNode.y - currentNode.y;
			var dx2:int = nextNode.x - currentNode.x;
			
			if ( Math.round(Math.atan2(dy1, dx1) * 2 / Math.PI) == Math.round(Math.atan2(dy2, dx2) * 2 / Math.PI) )
			{
				return false;
			}		
			return true;
		}
		
		private function getStraightPoint(lastNode:Node, currentNode:Node, nextNode:Point):int
		{			
			nextNode.setTo(currentNode.x + (currentNode.x - lastNode.x), currentNode.y + (currentNode.y - lastNode.y));
			if (lastNode.x == currentNode.x || lastNode.y == currentNode.y)
			{
				return this.COST_HORIZONTAL;
			}
			return this.COST_VERTICAL;
		}
		
		private function getSignNode(tileX:int, tileY:int):Node
		{
			var signX:int;
			var signY:int;
			var pt:Point;
			if (mapData.getIsSign(tileX, tileY))
			{
				signX = tileX;
				signY = tileY;
			}
			else
			{
				pt = mapData.getSign(tileX, tileY);
				signX = pt.x;
				signY = pt.y;
			}
			return getNode(signX, signY);
		}
		
//		private function cutPathPoint(path:Array):Array
//		{
//			var result:Array = new Array();
//			var currentPoint:Point;
//			if (path.length == 0)
//			{
//				return result;
//			}
//			
//			result[0] = path[0];
//			while(result[result.length-1] != path[path.length-1])
//			{
//				currentPoint = result[result.length-1];
//				for (var i:int = path.length-1; i >= 0; i--)
//				{
//					if (canGoStraight(currentPoint, path[i]) || currentPoint == path[i-1])
//					{
//						result.push(path[i]);
//						break;
//					}
//				}
//			}
//			return result;
//		}
//		
//		private function canGoStraight(startTile:Point, endTile:Point):Boolean
//		{
//			var tilePointArr:Array = mapInfo.passedTile2(startTile, endTile);
//			for each (var tilePoint:Point in tilePointArr)
//			{
//				if (mapInfo.getWalkable(tilePoint.x, tilePoint.y) == false)
//				{
//					return false;
//				}
//			}
//			return true;
//		}
		
		
		
	}//end class
	
}//end package


