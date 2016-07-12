package com.tencent.morefun.naruto.plugin.ui.base
{

	import com.tencent.morefun.naruto.plugin.ui.base.event.TreeEvent;
	import com.tencent.morefun.naruto.plugin.ui.util.ExDictionary;
	import com.tencent.morefun.naruto.plugin.ui.util.ObjectPool;
	import com.tencent.morefun.naruto.plugin.ui.util.ObjectPoolItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	

	public class Tree extends Sprite
	{
		private var m_cellWidth:int;
		private var m_cellHeight:int;
		private var m_levelOffsetWidth:int;
		
		private var m_showRoot:Boolean;
		private var m_cellRendererCls:Class;
		private var m_itemSkinCls:Class;
		
		private var m_itemList:Array = [];
		private var m_itemMap:ExDictionary = new ExDictionary();
		private var m_mapNodeInfoById:Dictionary = new Dictionary();
		private var m_mapNodeInfoByLevel:Dictionary = new Dictionary();
		private var m_mapChildNodes:Dictionary = new Dictionary();
		private var m_mapRefRenderer:Dictionary = new Dictionary();
		private var m_rootNodeInfo:Object;
		private var m_nodeChanged:Boolean;
		private var m_objectPool:ObjectPool = new ObjectPool(getTreeRenderer);
		
		private var m_autoClickExpand:Boolean = true;
		private var m_multiSelectedEnable:Boolean = false;
		private var m_lastSelectedId:String;
		private var m_selectedList:Array = [];
		
		
		/**
		 * 
		 * @param levelOffsetWidth 每级渲染单元的缩进
		 * @param cellRendererCls 渲染单元逻辑类
		 * @param itemSkinCls 渲染单元皮肤类
		 * @param showRoot 是否显示根节点
		 * 
		 */		
		public function Tree(levelOffsetWidth:int, cellRendererCls:Class, itemSkinCls:Class, showRoot:Boolean)
		{
			var defaultCellRenderer:ItemRenderer;
			
			super();
			
			m_itemSkinCls = itemSkinCls;
			m_cellRendererCls = cellRendererCls;
			defaultCellRenderer = getTreeRenderer();
			m_cellWidth = defaultCellRenderer.width;
			m_cellHeight = defaultCellRenderer.height;
			m_levelOffsetWidth = levelOffsetWidth;
			m_showRoot = showRoot;

		}
		
		public function set levelOffsetWidth(value:Number):void
		{
			m_levelOffsetWidth = value;
			waitUpdate();
		}
		
		public function get levelOffsetWidth():Number
		{
			return m_levelOffsetWidth;
		}
		
		public function set cellWidth(value:int):void
		{
			m_cellWidth = value;
			waitUpdate();
		}
		
		public function get cellWidth():int
		{
			return m_cellWidth;	
		}
		
		public function set cellHeight(value:int):void
		{
			m_cellHeight = value;
			waitUpdate();
		}
		
		public function get cellHeight():int
		{
			return m_cellHeight;
		}
		
		public function set multiSelectedEnable(value:Boolean):void
		{
			m_multiSelectedEnable = value;
		}
		
		public function get multiSelectedEnable():Boolean
		{
			return m_multiSelectedEnable;	
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		public function destroy():void
		{
			m_rootNodeInfo = null;
			releaseObjPool();
			removeItemRenderer();
			destroyItemRenderer();
			resetSelected();
		}
		
		/**
		 *展开某一节点 
		 * @param id
		 * 
		 */		
		public function expandNode(id:String):void
		{
			var nodeInfo:Object;
			
			nodeInfo = m_mapNodeInfoById[id];
			if(nodeInfo != null && nodeInfo.open == false)
			{
				nodeInfo.open = true;
				
				if(m_mapChildNodes[nodeInfo.id] != null)
				{
					waitUpdate();
				}
			}
		}
		
		/**
		 *关闭某一节点 
		 * @param id
		 * 
		 */		
		public function closeNode(id:String):void
		{
			var nodeInfo:Object;
			
			nodeInfo = m_mapNodeInfoById[id];
			
			if(nodeInfo != null && nodeInfo.open == true)
			{
				nodeInfo.open = false;
				
				if(m_mapChildNodes[nodeInfo.id] != null)
				{
					waitUpdate();
				}
			}
		}
		
		/**
		 *某一节点是否展开 
		 * @param id
		 * @return 
		 * 
		 */		
		public function isExpandNode(id:String):Boolean
		{
			var nodeInfo:Object;
			
			nodeInfo = m_mapNodeInfoById[id];
			if(nodeInfo != null)
			{
				return nodeInfo.open;
			}
			
			return false;
		}
		
		public function set autoClickExpand(value:Boolean):void
		{
			m_autoClickExpand = value;
		}
		
		public function get autoClickExpand():Boolean
		{
			return m_autoClickExpand;
		}
		
		/**
		 *创建节点 
		 * @param id 节点ID
		 * @param data 节点数据
		 * @param parentId 父级节点ID
		 * @param index 该节点的显示顺序
		 * @param open 是否展开
		 * 
		 */		
		public function createNode(id:String, data:Object, parentId:String, index:int = 0, open:Boolean = true):void
		{	
			var event:TreeEvent;
			
			m_nodeChanged = true;
			
			if(parentId == null && m_rootNodeInfo == null)
			{
				m_rootNodeInfo = {id:id, data:data, parentId:parentId, index:index, open:open, selected:false};
				m_mapNodeInfoById[id] = m_rootNodeInfo;
			}
			else if(parentId == null && m_rootNodeInfo != null)
			{
				return ;
			}
			else
			{
				m_mapNodeInfoById[id] = {id:id, data:data, parentId:parentId, index:index, open:open, selected:false};
			}
			
			event = new TreeEvent(TreeEvent.NODE_CREATE);
			event.nodeId = id;
			event.nodedata = data;
			this.dispatchEvent(event);
			
			waitUpdate();
		}
		
		/**
		 *移除所有节点 
		 * 
		 */		
		public function removeAll():void
		{
			m_nodeChanged = true;
			
			m_rootNodeInfo = null;
			
			releaseObjPool();
			removeItemRenderer();
			
			m_mapNodeInfoById = new Dictionary();
			m_mapRefRenderer = new Dictionary();
			m_itemList = [];
			
			waitUpdate();
		}
		
		/**
		 *移除某一节点 
		 * @param id
		 * 
		 */		
		public function removeNode(id:String):void
		{
			var event:TreeEvent;
			var nodeInfo:Object;
			var childList:Array;
			var treeRenderer:TreeRenderer;
			
			m_nodeChanged = true;
			
			if(id == m_rootNodeInfo.id)
			{
				m_rootNodeInfo = null;
			}
			
			nodeInfo = m_mapNodeInfoById[id];
			delete m_mapNodeInfoById[id];
			
			event = new TreeEvent(TreeEvent.NODE_REMOVE);
			event.nodeId = id;
			event.nodedata = nodeInfo.data;
			this.dispatchEvent(event);
			
			waitUpdate();
		}
		
		/**
		 *延迟更新 
		 * 
		 */		
		public function waitUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 *立即更新 
		 * 
		 */		
		public function updateNow():void
		{
			update(new Event(Event.ENTER_FRAME));
		}
		
		public function getLastSelectedId():String
		{
			return this.m_lastSelectedId;
		}
		
		public function getSelectedIdList():Array
		{
			return m_selectedList;
		}
		
		public function setSelected(id:String):void
		{
			var nodeInfo:Object;
			var render:TreeRenderer;
			
//			if(m_selectedList.indexOf(id) != -1)
//			{
//				m_selectedList.splice(m_selectedList.indexOf(id), 1);
//			}
			
			if(m_multiSelectedEnable == false && m_lastSelectedId != null)
			{
				render = getRenderById(m_lastSelectedId);
				if(render != null)
				{
					render.selected = false;
				}
				
				nodeInfo = m_mapNodeInfoById[m_lastSelectedId];
				nodeInfo.selected = false;
			}
			
			nodeInfo = m_mapNodeInfoById[id];
			if(nodeInfo != null)
			{
				nodeInfo.selected = true;
				m_selectedList.push(nodeInfo.id);
			}
			
			render = getRenderById(id);
			if(render != null)
			{
				render.selected = true;
			}
			
			m_lastSelectedId = id;
		}
		
		public function clearSelectd(id:String):void
		{
			var render:TreeRenderer;
			var nodeInfo:Object;
			
			nodeInfo = m_mapNodeInfoById[id];
			if(nodeInfo != null)
			{
				nodeInfo.selected = false;
				m_selectedList.splice(m_selectedList.indexOf(id), 1);
			}
			
			render = getRenderById(id);
			if(render != null)
			{
				render.selected = false;
			}
		}
		
		public function resetSelected():void
		{
			var selectedList:Array;
			
			selectedList = m_selectedList.concat();
			for each(var id:String in selectedList)
			{
				this.clearSelectd(id);
			}
			
			m_selectedList = [];
			m_lastSelectedId = null;
		}
		
		public function getRenderById(id:String):TreeRenderer
		{
			for each(var render:TreeRenderer in m_itemList)
			{
				if(render.id == id)
				{
					return render;
				}
			}
			
			return null;
		}
		
		public function getRenderVerPixel(id:String):int
		{
			for each(var render:TreeRenderer in m_itemList)
			{
				if(render.id == id)
				{
					return render.y;
				}
			}
			
			return - 1;
		}
		
		public function getRenderList():Array
		{
			return m_itemList;
		}
		
		/**
		 *更新显示内容 
		 * @param evt
		 * 
		 */		
		private function update(evt:Event):void
		{
			var event:TreeEvent;
			var nodeInfo:Object;
			var iterateInfo:Object;
			var iterateArr:Array = []
			var childNodeInfos:Array = []
			var subChildNodeInfos:Array = [];
			var treeRenderer:TreeRenderer;
			
			var baseX:int;
			var bseeY:int;
			var offsetY:int;
			var offsetX:int;
			var rendererIndex:String;
			var objectPoolItem:ObjectPoolItem;
			var mapRefItem:Dictionary = new Dictionary();
			var parentIndex:String = "";
			
			this.removeEventListener(Event.ENTER_FRAME, update);
			
			m_itemList.splice(0, m_itemList.length);
			if(m_nodeChanged)
			{
				fixNodeData();
				m_nodeChanged = false;
			}
			
			if(m_rootNodeInfo == null)
			{
				return ;
			}
			
			
			releaseObjPool();
			
			if(m_showRoot && m_rootNodeInfo)
			{
				offsetY = m_cellHeight;
				offsetX = m_levelOffsetWidth;
				
				objectPoolItem = m_objectPool.getObject("0") as ObjectPoolItem;
				mapRefItem["00"] = 1;
				delete m_mapRefRenderer["00"];
				m_itemMap.set("00", objectPoolItem);
				treeRenderer = objectPoolItem.data as TreeRenderer;
				treeRenderer.data = m_rootNodeInfo.data;
				treeRenderer.open = m_rootNodeInfo.open;
				treeRenderer.id = m_rootNodeInfo.id;
				treeRenderer.row = 0;
				treeRenderer.col = 0;
				treeRenderer.selected = m_rootNodeInfo.selected;
				treeRenderer.addEventListener(MouseEvent.CLICK, onItemClick);
				treeRenderer.addEventListener(TreeEvent.NODE_CLOSE, onNodeClose);
				treeRenderer.addEventListener(TreeEvent.NODE_OPEN, onNodeOpen);
				addChild(treeRenderer);
				
				m_itemList.push(treeRenderer);
			}
			
			childNodeInfos = m_mapChildNodes[m_rootNodeInfo.id];
			if(childNodeInfos == null){return ;}
			for(var i:int = 0;i < childNodeInfos.length && m_rootNodeInfo.open;i ++)
			{
				nodeInfo = childNodeInfos[i];
				rendererIndex = parentIndex + "," + nodeInfo.level + "," + i;
				nodeInfo.rendererIndex = rendererIndex;
				objectPoolItem = m_objectPool.getObject(rendererIndex) as ObjectPoolItem;
				m_itemMap.set(rendererIndex, objectPoolItem);
				mapRefItem[rendererIndex] = 1;
				delete m_mapRefRenderer[rendererIndex];
				treeRenderer = objectPoolItem.data as TreeRenderer;
				addChild(treeRenderer);
				treeRenderer.data = nodeInfo.data;
				treeRenderer.open = nodeInfo.open;
				treeRenderer.id = nodeInfo.id;
				treeRenderer.row = i;
				treeRenderer.col = nodeInfo.level;
				treeRenderer.addEventListener(MouseEvent.CLICK, onItemClick);
				treeRenderer.addEventListener(TreeEvent.NODE_CLOSE, onNodeClose);
				treeRenderer.addEventListener(TreeEvent.NODE_OPEN, onNodeOpen);
				treeRenderer.x = baseX + offsetX;
				treeRenderer.y = bseeY + offsetY;
				treeRenderer.selected = nodeInfo.selected;
				
				
				bseeY += m_cellHeight;
				m_itemList.push(treeRenderer);
				
				if(m_mapChildNodes[nodeInfo.id] != null && nodeInfo.open)
				{
					parentIndex += ":" + i;
					iterateArr.push({arr:childNodeInfos, index:i, baseX:baseX});
					baseX += m_levelOffsetWidth;
					i = -1;
					childNodeInfos = m_mapChildNodes[nodeInfo.id];
					continue;
				}
				
				while(i == childNodeInfos.length - 1 && iterateArr.length != 0)
				{
					parentIndex.substring(parentIndex.lastIndexOf(":"), parentIndex.length);
					iterateInfo = iterateArr.pop();
					baseX = iterateInfo.baseX;
					i = iterateInfo.index;
					childNodeInfos = iterateInfo.arr;
				}
			}
			
			removeItemRenderer();
			m_mapRefRenderer = mapRefItem;
			
			event = new TreeEvent(TreeEvent.TREE_UPDATE);
			this.dispatchEvent(event);
		}
		
		/**
		 *释放引用 
		 * 
		 */		
		private function releaseObjPool():void
		{
			var objPoolItem:ObjectPoolItem;
			
			for(var i:* in m_mapRefRenderer)	
			{
				objPoolItem = m_itemMap.getValue(i) as ObjectPoolItem;
				objPoolItem.release();
			}
		}
		
		/**
		 *从舞台上移除渲染单元 
		 * 
		 */		
		private function removeItemRenderer():void
		{
			var treeRenderer:TreeRenderer;
			var objectPoolItem:ObjectPoolItem;
			
			for(var i:* in m_mapRefRenderer)
			{
				objectPoolItem = m_itemMap.getValue(i) as ObjectPoolItem;
				treeRenderer = objectPoolItem.data as TreeRenderer;
				treeRenderer.removeEventListener(MouseEvent.CLICK, onItemClick);
				treeRenderer.removeEventListener(TreeEvent.NODE_CLOSE, onNodeClose);
				treeRenderer.removeEventListener(TreeEvent.NODE_OPEN, onNodeOpen);
				treeRenderer.selected = false;
				m_itemMap.remove(i);
				removeChild(treeRenderer);
			}
		}
		
		/**
		 *销毁渲染单元 
		 * 
		 */		
		private function destroyItemRenderer():void
		{
			var poolMap:Dictionary;
			var itemRenderer:ItemRenderer;
			var objectPoolItem:ObjectPoolItem;
			
			poolMap = m_objectPool.getPoolMap();
			for(var i:* in poolMap)
			{
				objectPoolItem = poolMap[i];
				itemRenderer = objectPoolItem.data as ItemRenderer;
				itemRenderer.destroy();
				delete poolMap[i];
			}
		}
		
		/**
		 *渲染单元点击响应 
		 * @param evt
		 * 
		 */		
		private function onItemClick(evt:MouseEvent):void
		{
			var event:TreeEvent;
			var treeRenderer:TreeRenderer;
			var info:Object;
			
			treeRenderer = evt.currentTarget as TreeRenderer;
			
			
			event = new TreeEvent(TreeEvent.NODE_CLICK);
			event.nodedata = treeRenderer.data;
			event.nodeId = treeRenderer.id;
			this.dispatchEvent(event);
			
			if(m_autoClickExpand)
			{
				info = m_mapNodeInfoById[treeRenderer.id];
				
				if(info == null)
				{
					return ;
				}
				
				if(info.open)
				{
					this.closeNode(info.id);
				}
				else
				{
					this.expandNode(info.id);
				}
			}
		}
		
		/**
		 *节点关闭响应 
		 * @param evt
		 * 
		 */		
		private function onNodeClose(evt:TreeEvent):void
		{
			var treeRenderer:TreeRenderer;
			
			treeRenderer = evt.currentTarget as TreeRenderer;
			closeNode(treeRenderer.id);
		}
		
		/**
		 *节点展开响应 
		 * @param evt
		 * 
		 */		
		private function onNodeOpen(evt:TreeEvent):void
		{
			var treeRenderer:TreeRenderer;
			
			treeRenderer = evt.currentTarget as TreeRenderer;
			expandNode(treeRenderer.id);
		}
		
		/**
		 * 父-子级节点关系绑定
		 * 
		 */		
		private function fixNodeData():void
		{
			var iterateArr:Array = [];
			var childNodeInfos:Array = []
			var levelNodeInfos:Array = [];
			var subChildNodeInfos:Array;
			var nodeInfo:Object;
			var iterateInfo:Object;
			var level:int = 1;
			
			m_mapChildNodes = new Dictionary();
			m_mapNodeInfoByLevel = new Dictionary();
			
			if(m_rootNodeInfo == null)
			{
				return ;
			}
			
			for(var i:* in m_mapNodeInfoById)
			{
				nodeInfo = m_mapNodeInfoById[i];
				childNodeInfos = m_mapChildNodes[nodeInfo.parentId];
				if(childNodeInfos == null)
				{
					childNodeInfos = new Array();
					m_mapChildNodes[nodeInfo.parentId] = childNodeInfos;
				}
				
				childNodeInfos.push(nodeInfo);
				childNodeInfos.sortOn("index", Array.NUMERIC);
			}
			
			childNodeInfos = m_mapChildNodes[m_rootNodeInfo.id];
			
			if(childNodeInfos == null){return ;}
			for(var j:int = 0;j < childNodeInfos.length;j ++)
			{
				nodeInfo = childNodeInfos[j];
				nodeInfo.level = level;
				
				levelNodeInfos = m_mapNodeInfoByLevel[level];
				if(levelNodeInfos == null)
				{
					levelNodeInfos = new Array();
					m_mapNodeInfoByLevel[level] = levelNodeInfos;
				}
				levelNodeInfos.push(nodeInfo);
				
				subChildNodeInfos = m_mapChildNodes[nodeInfo.id];
				if(subChildNodeInfos != null)
				{
					iterateArr.push({index:j, arr:childNodeInfos, level:level});
					childNodeInfos = subChildNodeInfos;
					level ++;
					j = -1;
					continue;
				}
				
				while(j == childNodeInfos.length - 1 && iterateArr.length != 0)
				{
					iterateInfo = iterateArr.pop();
					j = iterateInfo.index;
					level = iterateInfo.level;
					childNodeInfos = iterateInfo.arr;
				}
			}
		}
		
		/**
		 *创建渲染单元 
		 * @return 
		 * 
		 */		
		private function getTreeRenderer():TreeRenderer
		{
			var itemRenderer:TreeRenderer;
			
			if(m_itemSkinCls)
			{
				itemRenderer = new m_cellRendererCls(new m_itemSkinCls());
			}
			else
			{
				itemRenderer = new m_cellRendererCls(null);
			}
			
			return itemRenderer;
		}
		}
}