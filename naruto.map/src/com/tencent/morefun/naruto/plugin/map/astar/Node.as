package com.tencent.morefun.naruto.plugin.map.astar
{
	public class Node
	{
		public var x:int;
		public var y:int;
		public var indexInOpen:int;
		public var isInClose:Boolean;
		public var g:int;
		public var h:int;
		public var f:int;
		public var parentNode:Node;
		
		public function Node(x:int, y:int)
		{
			this.x = x;
			this.y = y;
			this.indexInOpen = -1;
			this.isInClose = false;
			this.g = 0;
			this.h = 0;
			this.f = 0;
			this.parentNode = null;
		}
		
		public function reset():void
		{
			this.indexInOpen = -1;
			this.isInClose = false;
			this.g = 0;
			this.h = 0;
			this.f = 0;
			this.parentNode = null;
		}
	}

}