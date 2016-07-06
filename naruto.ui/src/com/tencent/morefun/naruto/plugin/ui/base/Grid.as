package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.event.GridEvent;
	import com.tencent.morefun.naruto.plugin.ui.util.ExDictionary;
	import com.tencent.morefun.naruto.plugin.ui.util.ObjectPool;
	import com.tencent.morefun.naruto.plugin.ui.util.ObjectPoolItem;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	

	public class Grid extends ScrollContent
	{
		protected var m_cellWidth:int;
		protected var m_cellHeight:int;
		protected var m_vergap:int;
		protected var m_horgap:int;
		protected var m_maxRow:int;
		protected var m_maxCol:int;
		protected var m_colDataMap:ExDictionary = new ExDictionary();
		protected var m_rowDataMap:ExDictionary = new ExDictionary();
		protected var m_itemRefIndex:Dictionary = new Dictionary();
		protected var m_itemMap:ExDictionary = new ExDictionary();
		protected var m_itemSkinCls:Class;
		protected var m_itemRendererCls:Class;
		protected var m_objPool:ObjectPool = new ObjectPool(createRenderer);
		protected var m_row:int;
		protected var m_col:int;
		protected var m_scrollRectChanged:Boolean = false;
		protected var m_pageWidth:int;
		protected var m_pageHeight:int;
		protected var m_position:Point = new Point();
		
		/**
		 * 
		 * @param row 显示行数
		 * @param col 显示列数
		 * @param itemRendererCls 渲染单元逻辑类
		 * @param itemSkinCls 渲染单元皮肤类
		 * @param skin 网格背景
		 * @param enableWheel 是否感应鼠标滑轮事件
		 * 
		 */		
		public function Grid(col:int, row:int, itemRendererCls:Class, itemSkinCls:Class, skin:DisplayObject = null, enableWheel:Boolean = true)
		{
			var defaultRenderer:ItemRenderer;
			
			m_itemSkinCls = itemSkinCls;
			m_itemRendererCls = itemRendererCls;
			
			defaultRenderer = createRenderer();
			m_cellWidth = defaultRenderer.width;
			m_cellHeight = defaultRenderer.height;
			defaultRenderer.destroy();
			
			super(skin, col *  (cellWidth + horgap), row * (cellHeight + vergap), enableWheel);
			m_row = row;
			m_col = col;
		}
		
		/**
		 *销毁函数 用完记得调用 
		 * 
		 */		
		override public function destroy():void
		{
			var itemRenderer:ItemRenderer;
			var objectPoolItem:ObjectPoolItem;
			
			super.destroy();
			
			m_maxCol = 0;
			m_maxRow = 0;
			
			m_colDataMap.removeAll();
			m_rowDataMap.removeAll();
			
			destroyItemRenderer();
//			removeItemRenderer();
			m_objPool.destroy();
			
			removeChildren();
		}
		
		/**
		 *添加一个单元内容 
		 * @param row 行
		 * @param col 列
		 * @param data 数据
		 * 
		 */		
		public function addItem(row:int, col:int, data:Object):void
		{
			var dataMap:ExDictionary;
			
			if(row > m_maxRow)
			{
				m_maxRow = row;
				//当前高度 减去 一页高度
				this.maxVerScrollValue = (m_maxRow + 1 - m_row) * (m_cellHeight + m_vergap);
				this.maxVerScrollValue = Math.max(0, maxVerScrollValue);
			}
			
			if(col > m_maxCol)
			{
				m_maxCol = col;
				//当前宽度 减去 一页宽度
				this.maxHorScrollValue = (m_maxCol + 1 - m_col) * (m_cellWidth + m_horgap);
				this.maxHorScrollValue = Math.max(0, maxHorScrollValue);
			}
			
			dataMap = m_colDataMap.getValue(col.toString()) as ExDictionary;
			if(dataMap == null)
			{
				dataMap = new ExDictionary();
				m_colDataMap.set(col.toString(), dataMap);
			}
			
			dataMap.set(row.toString(), data);
			
			dataMap = m_rowDataMap.getValue(row.toString()) as ExDictionary;
			if(dataMap == null)
			{
				dataMap = new ExDictionary();
				m_rowDataMap.set(row.toString(), dataMap);
			}
			
			dataMap.set(col.toString(), data);
			
			waitUpdate();
		}
		
		/**
		 * 删除一个单元
		 * @param row 行
		 * @param col 列
		 * 
		 */		
		public function removeItem(row:int, col:int):void
		{
			var i:*;
			var map:Dictionary;
			var dataMap:ExDictionary;
			
			dataMap = m_colDataMap.getValue(col.toString()) as ExDictionary;
			dataMap.remove(row.toString());
			if(dataMap.length == 0 && col == m_maxCol)
			{
				dataMap.remove(col.toString());
				m_maxCol = 0;
				map = dataMap.map;
				for(i in map)
				{
					if(i > m_maxCol)
					{
						m_maxCol = i;
					}
				}
			}
			
			this.maxHorScrollValue = m_maxCol * (m_cellWidth + m_horgap);
			
			dataMap = m_rowDataMap.getValue(row.toString()) as ExDictionary;
			dataMap.remove(col.toString());
			if(dataMap.length == 0 && col == m_maxCol)
			{
				dataMap.remove(row.toString());
				m_maxRow = 0;
				map = dataMap.map;
				for(i in map)
				{
					if(i > m_maxRow)
					{
						m_maxRow = i;
					}
				}
			}
			
			this.maxVerScrollValue = m_maxRow * (m_cellHeight + m_vergap);
			
			waitUpdate();
		}
		
		/**
		 *删除所有单元 
		 * 
		 */		
		public function removeAll():void
		{
			m_maxCol = 0;
			m_maxRow = 0;
			
			maxVerScrollValue = 0;
			maxHorScrollValue = 0;
			
			m_colDataMap.removeAll();
			m_rowDataMap.removeAll();
			
			releaseObjPool();
			removeItemRenderer();
			updateNow();
		}
		
		/**
		 *根据位置获取单元数据 
		 * @param row 行
		 * @param col 列
		 * @return 单元数据
		 * 
		 */		
		public function getItemDataByPosition(row:int, col:int):Object
		{
			var dataMap:ExDictionary;
			
			dataMap = m_rowDataMap.getValue(row.toString()) as ExDictionary;
			if(dataMap == null)
			{
				return null;
			}
			
			return dataMap.getValue(col.toString());
		}
		
		public function getTotalItemDatas():Array
		{
			var itemDatas:Array = [];
			
			for each(var colMap:ExDictionary in m_rowDataMap.map)
			{
				for each(var data:Object in colMap.map)
				{
					itemDatas.push(data);
				}
			}
			
			return itemDatas;
		}
		
		public function getRenderList():Array
		{
			var renderList:Array = [];
			
			for each(var objectPoolItem:ObjectPoolItem in m_itemMap.map)
			{
				renderList.push(objectPoolItem.data);
			}
			return renderList;
		}
		
		public function getRenderByPosition(row:int, col:int):ItemRenderer
		{
			var renderList:Array = [];
			var itemRender:ItemRenderer;
			
			for each(var objectPoolItem:ObjectPoolItem in m_itemMap.map)
			{
				itemRender = objectPoolItem.data as ItemRenderer;
				if(itemRender.row == row && itemRender.col == col)
				{
					return itemRender;
				}
			}
			
			return null;
		}
		
		/**
		 *根据数据获得对应位置(不建议使用 2次遍历查找） 
		 * @param data
		 * @return 
		 * 
		 */		
		public function getItemPositionByData(data:Object):Point
		{
			var dataMap:ExDictionary;
			var colDataMap:ExDictionary;
			var tData:Object;
			
			dataMap = m_rowDataMap;
			for(var i:* in dataMap.map)
			{
				colDataMap = dataMap.map[i];
				for(var j:* in colDataMap.map)
				{
					tData = colDataMap.map[j];
					if(tData == data)
					{
						this.m_position.x = j;
						this.m_position.y = i;
						return m_position;
					}
				}
			}
			
			return null;	
		}
		
		/**
		 *单元渲染宽度 
		 * @param value
		 * 
		 */		
		public function set cellWidth(value:int):void
		{
			m_scrollRectChanged = true;
			m_cellWidth = value;
			waitUpdate();
		}
		
		public function get cellWidth():int
		{
			return m_cellWidth;
		}
		
		/**
		 *单元渲染高度 
		 * @param value
		 * 
		 */		
		public function set cellHeight(value:int):void
		{
			m_scrollRectChanged = true;
			m_cellHeight = value;
			waitUpdate();
		}
		
		public function get cellHeight():int
		{
			return m_cellHeight;
		}
		
		/**
		 *设置水垂直单元间隔 
		 * @param value
		 * 
		 */		
		public function set vergap(value:int):void
		{
			m_scrollRectChanged = true;
			m_vergap = value;
			waitUpdate();
		}
		
		public function get vergap():int
		{
			return m_vergap;
		}
		
		/**
		 *设置水平单元间隔 
		 * @param value
		 * 
		 */		
		public function set horgap(value:int):void
		{
			m_scrollRectChanged = true;
			m_horgap = value;
			waitUpdate()
		}
		
		public function get horgap():int
		{
			return 	m_horgap;
		}
		
		/**
		 *设置显示行数 
		 * @param value
		 * 
		 */		
		public function set row(value:int):void
		{
			m_scrollRectChanged = true;
			m_row = value;
			waitUpdate()
		}
		
		public function get row():int
		{
			return m_row;
		}
		
		/**
		 *设置显示列数 
		 * @param value
		 * 
		 */		
		public function set col(value:int):void
		{
			m_scrollRectChanged = true;
			m_col = value;
			waitUpdate()
		}
		
		public function get col():int
		{
			return m_col;
		}
		
		/**
		 *更新显示内容 
		 * @param evt
		 * 
		 */		
		override protected function update(evt:Event):void
		{
			
			var data:Object;
			var startRow:int;
			var startCol:int;
			var rowOffset:int;
			var colOffset:int;
			var colNum:int;
			var rowNum:int;
			var rendererIndex:int;
			var itemRenderer:ItemRenderer;
			var objectPoolItem:ObjectPoolItem;
			var itemRefIndex:Dictionary = new Dictionary();
			
			super.update(evt);
			
			rowOffset = verticalScrollValue % (m_cellHeight + m_vergap);
			colOffset = horizontalScrollValue % (m_cellWidth + m_horgap);
			
			rowNum = m_row;
			colNum = m_col;
			
			if(rowOffset)
			{
				rowNum ++;
			}
			
			if(colOffset)
			{
				colNum ++;
			}
			
			releaseObjPool();
			
			startRow =  Math.floor(verticalScrollValue / (m_cellHeight + m_vergap));
			startCol = Math.floor(horizontalScrollValue / (m_cellWidth + m_horgap));
			rendererIndex = 0;
			for(var i:int = 0;i < rowNum;i ++)
			{
				for(var j:int = 0;j < colNum;j ++)
				{
					rendererIndex ++;
					data = getItemDataByPosition(startRow + i, startCol + j);
					if(data == null)
					{
						continue;
					}
					objectPoolItem = m_objPool.getObject(rendererIndex.toString()) as ObjectPoolItem;
					itemRenderer = objectPoolItem.data as ItemRenderer;
					m_itemMap.set(rendererIndex.toString(), objectPoolItem);
					itemRefIndex[rendererIndex] = 1;
					delete m_itemRefIndex[rendererIndex];
					itemRenderer.row = startRow + i;
					itemRenderer.col = startCol + j;
					itemRenderer.x = j * (m_cellWidth + m_horgap) - colOffset;
					itemRenderer.y = i * (m_cellHeight + m_vergap) - rowOffset;
					itemRenderer.data = data;
					itemRenderer.addEventListener(MouseEvent.CLICK, onItemClick);
					addChild(itemRenderer);
				}
			}
			
			if(m_scrollRectChanged)
			{
				updateScrollRect();
				m_scrollRectChanged = false;
			}
			
			
			removeItemRenderer();
			m_itemRefIndex = itemRefIndex;
			
			//防止data更新后滚动值过大导致内容不可见
			verticalScrollValue = verticalScrollValue;
			horizontalScrollValue = verticalScrollValue;
		}
		
		/**
		 *渲染条目点击事件 
		 * @param evt
		 * 
		 */		
		protected function onItemClick(evt:MouseEvent):void
		{
			var event:GridEvent;	
			var itemRenderer:ItemRenderer;
			
			itemRenderer = evt.currentTarget as ItemRenderer;
			event = new GridEvent(GridEvent.ITEM_CLICK);
			event.itemRenderer = itemRenderer;
			this.dispatchEvent(event);
		}
		
		/**
		 *释放渲染条目引用 
		 * 
		 */		
		protected function releaseObjPool():void
		{
			var objectPoolItem:ObjectPoolItem;
			for(var i:* in m_itemRefIndex)
			{
				objectPoolItem = m_itemMap.getValue(i) as ObjectPoolItem;
				objectPoolItem.release();
			}
		}
		
		/**
		 *从舞台移除渲染条目 
		 * 
		 */		
		protected function removeItemRenderer():void
		{
			var id:String;
			var itemRenderer:ItemRenderer;
			var objectPoolItem:ObjectPoolItem;
			
			for(var i:* in m_itemRefIndex)
			{
				objectPoolItem = m_itemMap.getValue(i) as ObjectPoolItem;
				itemRenderer = objectPoolItem.data as ItemRenderer;
				itemRenderer.removeEventListener(MouseEvent.CLICK, onItemClick);
				m_itemMap.remove(i);
				removeChild(itemRenderer);
			}
			
			m_itemRefIndex = new Dictionary();
		}
		
		/**
		 *销毁渲染条目 
		 * 
		 */		
		protected function destroyItemRenderer():void
		{
			var i:*;
			var id:String;
			var poolMap:Dictionary;
			var itemRenderer:ItemRenderer;
			var objectPoolItem:ObjectPoolItem;
			
			poolMap = m_objPool.getPoolMap();
			for(i in poolMap)
			{
				objectPoolItem = poolMap[i];
				itemRenderer = objectPoolItem.data as ItemRenderer;
				itemRenderer.destroy();
				delete poolMap[i];
			}
			
			for(i in m_itemRefIndex)
			{
				objectPoolItem = m_itemMap.getValue(i) as ObjectPoolItem;
				objectPoolItem.release();
				itemRenderer = objectPoolItem.data as ItemRenderer;
				itemRenderer.removeEventListener(MouseEvent.CLICK, onItemClick);
				itemRenderer.destroy();
				m_itemMap.remove(i);
				if(contains(itemRenderer)){removeChild(itemRenderer)};
			}
			
			m_itemRefIndex = new Dictionary();
		}
		
		/**
		 *创建渲染条目 
		 * @return 
		 * 
		 */		
		protected function createRenderer():ItemRenderer
		{
			var itemRenderer:ItemRenderer;
			
			if(m_itemSkinCls)
			{
				itemRenderer = new m_itemRendererCls(new m_itemSkinCls());
			}
			else
			{
				itemRenderer = new m_itemRendererCls(null);
			}
			
			return itemRenderer;
		}
		
		/**
		 *更新显示区域 
		 * 
		 */		
		protected function updateScrollRect():void
		{
			super.width = m_col *  (cellWidth + horgap);
			super.height = m_row * (cellHeight + vergap);
		}
		}
}