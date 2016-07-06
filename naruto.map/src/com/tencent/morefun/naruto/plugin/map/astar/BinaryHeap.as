package com.tencent.morefun.naruto.plugin.map.astar
{
	/**
	 * 二叉堆算法
	 * 
	 * 能够在不断追加数据的同时，随时取出数列中的最小值
	 * 
	 */
	public class BinaryHeap
	{
		private var data:Vector.<Node> ;//需要注意的是，二叉堆数据的下标是从1开始排列的
				
		public function BinaryHeap()
		{
			data = new Vector.<Node>();
			data[0] = null;
		}
		
		/**
		 * 数据长度
		 *  
		 * @return 
		 * 
		 */
		public function get length():int
		{
			return data.length - 1;
		}
		
		/**
		 * 添加节点
		 * @param o
		 * 
		 */
		public function push(o:Node):void
		{
			o.indexInOpen = data.push(o) - 1;//s 当前节点
			modifyIndex(o.indexInOpen);
		}
		
		/**
		 * 修改节点后重排顺序 
		 * @param o
		 * 
		 */
		public function modify(o : Node):void
		{
			if (o.indexInOpen > 0)
				modifyIndex(o.indexInOpen);
		}
		
		private function modifyIndex(index:int):void
		{
			var s:int = index;//s 当前节点
			while (s > 1)
			{
				var p:int = int(s / 2);//p 父节点
				if (data[s].f < data[p].f)
				{
					var t:Node = data[s];
					data[s] = data[p];
					data[p] = t;	
					var x:int = data[s].indexInOpen;
					data[s].indexInOpen = data[p].indexInOpen;
					data[p].indexInOpen = x;
				}
				else
					break;
					
				s = p;
			} 
		}
		
		/**
		 * 从数组中取出首节点（最小值）
		 * @param index
		 * 
		 */		
		public function shift():Node
		{
			if (data.length == 1)//数组为空
				return null;
			
			if (data.length == 2)//数组只有一个节点
				return data.pop();
			
			var v:Node = data[1];
			var s:int = 1;//s 当前节点
			
			data[1] = data.pop();//将末节点移动到队首
			data[1].indexInOpen = 1;
			
			while (true)
			{
				var os:int = s;//os s的旧值
				var p:int = s * 2;//p 子节点
				if (p < data.length)
				{
					if (data[p].f < data[s].f)
						s = p;
					
					//如果另一个子节点更小
					if (p + 1 < data.length && (data[p + 1].f < data[s].f))
						s = p + 1;
				}
				
				if (s != os)
				{
					var t:Node = data[s];
					data[s] = data[os];
					data[os] = t;
					
					var x:int = data[s].indexInOpen;
					data[s].indexInOpen = data[os].indexInOpen;
					data[os].indexInOpen = x;
				}	
				else
					break;
			}
			v.indexInOpen = -1;
			return v as Node;
		}
		
		/**
		 * 清空 
		 * 
		 */
		public function clear():void
		{
			data.length = 0;
			data[0] = null;
		}
		
		/**
		 * 默认排序函数
		 *  
		 * @param obj1
		 * @param obj2
		 * @return 
		 * 
		 */
//		private function sortMethod(obj1:Node,obj2:Node):Boolean
//		{
//			return obj1.f < obj2.f; 
//		}
		
//		private function swap(i:int, j:int):void
//		{			
//			var t:Node = data[i];
//			data[i] = data[j];
//			data[j] = t;
//			
//			var x:int = data[i].indexInOpen;
//			data[i].indexInOpen = data[j].indexInOpen;
//			data[j].indexInOpen = x;
//		}
		
	}
}