package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.base.def.DirectionDef;
	import com.tencent.morefun.naruto.plugin.ui.base.event.GridEvent;
	import com.tencent.morefun.naruto.plugin.ui.util.ExDictionary;
	import com.tencent.morefun.naruto.plugin.ui.util.ObjectPool;
	import com.tencent.morefun.naruto.plugin.ui.util.ObjectPoolItem;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	

	public class DirectionGrid extends PageContent
	{
		private var m_cellWidth:int;
		private var m_cellHeight:int;
		private var m_row:int;
		private var m_col:int;
		private var m_maxRow:int;
		private var m_maxCol:int;
		private var m_vergap:int;
		private var m_horgap:int;
		
		private var m_isPageMode:Boolean;
		
		private var m_scrollRectChanged:Boolean;
		
		private var m_itemSkinCls:Class;
		private var m_stageVerIndex:int;
		private var m_stageHorIndex:int;
		
		private var m_srouce:Array = [];
		private var m_status:Array = [];
		
		private var m_selectedIndex:int = -1;
		private var m_selectable:Boolean = false;
		
		private var m_statusMgr:DirectGridStatusMgr;
		
		private var m_refItemMap:Dictionary = new Dictionary();
		private var m_itemMap:ExDictionary = new ExDictionary();
		private var m_itemRendererCls:Class;
		
		private var m_rendererPool:ObjectPool = new ObjectPool(createRenderer);
		
		/**
		 * 
		 * @param row 显示的行数
		 * @param col 显示的列数
		 * @param itemRendererCls 渲染单元CLASS，继承自ItemRenderer
		 * @param itemSkinCls 渲染单元的皮肤CLASS
		 * @param background 网格背景
		 * @param direction 网格增长方向
		 * @param enableWheel 是否感应滑轮事件
		 * 
		 */		
		public function DirectionGrid(row:int,
									  col:int,
									  itemRendererCls:Class,
									  itemSkinCls:Class,
									  background:DisplayObject = null,
									  direction:String = "vertical",
									  enableWheel:Boolean = true)
		{	
			var defaultRenderer:ItemRenderer;
			
			m_itemSkinCls = itemSkinCls;
			m_itemRendererCls = itemRendererCls;
			
			defaultRenderer = createRenderer();
			m_cellWidth = defaultRenderer.width;
			m_cellHeight = defaultRenderer.height;
			defaultRenderer.destroy();
			
			super(0, background, col * m_cellWidth, row * m_cellHeight, enableWheel, direction);
			
			m_row = row;
			m_col = col;
			
			
			
			calculationPageScrollValue();
			updateScrollRect();
			waitUpdate();
		}
		
		/**
		 *在确定了方向、单元尺寸、行、列、间距后可以计算出每页的滚动值 
		 * 
		 */		
		private function calculationPageScrollValue():void
		{
			if(m_direction == DirectionDef.VERTICAL)
			{
				m_defaultPageScrollValue = (cellHeight * row) + (row * vergap);
			}
			else
			{
				m_defaultPageScrollValue = (cellWidth * col) + (col * horgap);
			}
		}
		
		/**
		 *更新显示区域 
		 * 
		 */		
		private function updateScrollRect():void
		{
			super.width = col *  (cellWidth + horgap);
			super.height = row * (cellHeight + vergap);
			scrollRect = new Rectangle(0, 0, col *  (cellWidth + horgap) , row * (cellHeight + vergap));
			calculationPageScrollValue();
		}
		
		/**
		 *用完记得调用 
		 * 
		 */		
		override public function destroy():void
		{
			super.destroy();
			
			releaseObjPool();
			removeItemRenderer();
			destroyItemRenderer();
			
			m_itemMap = new ExDictionary();
			m_refItemMap = new Dictionary();
			
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		public function set isPageMode(value:Boolean):void
		{
			m_isPageMode = value;
		}
		
		public function get isPageMode():Boolean
		{
			return m_isPageMode;
		}
		
		/**
		 *显示的行数 
		 * @return 
		 * 
		 */		
		public function get row():int
		{
			return m_row;
		}
		
		public function set row(value:int):void
		{
			m_row = value;
			
			updateMaxInfo();
			m_scrollRectChanged = true;
			waitUpdate();
		}
		
		/**
		 *显示的列数 
		 * @return 
		 * 
		 */		
		public function get col():int
		{
			return m_col;
		}
		
		public function set col(value:int):void
		{
			m_col = value;
			
			updateMaxInfo();
			m_scrollRectChanged = true;
			waitUpdate();
		}
		
		public function set vergap(value:int):void
		{
			if(value == m_vergap)
			{
				return ;
			}
			
			m_vergap = value;
			m_scrollRectChanged = true;
			waitUpdate();
		}
		
		/**
		 *行间间隔 
		 * @return 
		 * 
		 */		
		public function get vergap():int
		{
			return m_vergap;
		}
		
		public function set horgap(value:int):void
		{
			if(value == m_horgap)
			{
				return ;
			}
			
			m_horgap = value;
			m_scrollRectChanged = true;
			waitUpdate();
		}
		
		/**
		 *列间间隔 
		 * @return 
		 * 
		 */		
		public function get horgap():int
		{
			return m_horgap;
		}
		
		public function set cellWidth(value:int):void
		{
			if(m_cellWidth == value)
			{
				return ;
			}
			
			m_cellWidth = value;
			m_scrollRectChanged = true;
			waitUpdate();
		}
		
		/**
		 *单元格宽度 
		 * @return 
		 * 
		 */		
		public function get cellWidth():int
		{
			return m_cellWidth;
		}
		
		public function set cellHeight(value:int):void
		{
			if(m_cellHeight == value)
			{
				return ;
			}
			
			m_cellHeight = value;
			m_scrollRectChanged = true;
			waitUpdate();
		}
		
		/**
		 *单元格高度 
		 * @return 
		 * 
		 */		
		public function get cellHeight():int
		{
			return m_cellHeight;
		}
		
		/**
		 *设置ItemRenderer的状态列表 
		 * @param value
		 * 
		 */		
		public function set status(value:Array):void
		{
			m_status = value;
			
			if(m_statusMgr != null)
			{
				m_statusMgr.status = value;
			}
			
			this.waitUpdate();
		}
		
		public function get status():Array
		{
			return m_status;
		}
		
		/**
		 *状态管理类 
		 * @param value
		 * 
		 */		
		public function set statusMgr(value:DirectGridStatusMgr):void
		{
			m_statusMgr = value;
		}
		
		public function get statusMgr():DirectGridStatusMgr
		{
			return m_statusMgr;
		}
		
		public function set selectedIndex(value:int):void
		{
			this.m_selectedIndex = value;
			this.m_selectable = true;
			
			waitUpdate();
		}
		
		public function get selectedIndex():int
		{
			return m_selectedIndex;
		}
		
		public function set selectable(value:Boolean):void
		{
			this.m_selectable = value;
		}
		
		public function get selectable():Boolean
		{
			return m_selectable;
		}
		
		/**
		 *设置数据源 
		 * @param value
		 * 
		 */		
		public function set source(value:Array):void
		{
			m_srouce = value;
			
			if(m_srouce == null)
			{
				return ;
			}
			
			updateMaxInfo();
			
			this.waitUpdate();
		}
		
		/**
		 *根据数据源计算出最大滚动值、行、列3个信息 
		 * 
		 */		
		private function updateMaxInfo():void
		{
			var cellPageScrollValue:int;
			
			if(m_isPageMode == true)
			{
				if(m_direction == DirectionDef.VERTICAL)
				{
					maxVerScrollValue = Math.max(0, Math.ceil(m_srouce.length / (row * col)) * m_defaultPageScrollValue - m_defaultPageScrollValue);
					m_maxRow = Math.ceil(m_srouce.length / col);
					m_maxCol = col;
				}
				else
				{
					maxHorScrollValue = Math.max(0, Math.ceil(m_srouce.length / (row * col)) * m_defaultPageScrollValue - m_defaultPageScrollValue);
					m_maxCol = Math.ceil(m_srouce.length / row);
					m_maxRow = row;
				}
			}
			else
			{
				if(m_direction == DirectionDef.VERTICAL)
				{
					cellPageScrollValue = cellHeight + vergap;
					m_maxRow = Math.ceil(m_srouce.length / col);
					m_maxCol = col;
					
					maxVerScrollValue = Math.max(0, (m_maxRow - row) * cellPageScrollValue);
				}
				else
				{
					cellPageScrollValue = cellWidth + horgap;
					m_maxCol = Math.ceil(m_srouce.length / row);
					m_maxRow = row;
					
					maxHorScrollValue = Math.max(0, (m_maxCol - col) * cellPageScrollValue);
				}
			}
		}
		
		public function get source():Array
		{
			return m_srouce;	
		}
		
		/**
		 *更新显示 
		 * @param evt
		 * 
		 */		
		override protected function update(evt:Event):void
		{
			var dataStartIndex:int;
			var dataIndex:int;
			var rowDataOffset:int;
			var colDataOffset:int;
			var rowOffset:int;
			var colOffset:int;
			var tcol:int;
			var trow:int;
			var baseRow:int;
			var baseCol:int;
			var itemRenderer:ItemRenderer;
			var objectPoolItem:ObjectPoolItem;
			var refItemMap:Dictionary = new Dictionary();
			var rowgap:int;
			var colgap:int;
			var rowDisp:DisplayObject;
			var colDisp:DisplayObject;
			var selected:Boolean;
			
			super.update(evt);
			
			if(m_scrollRectChanged)
			{
				updateScrollRect();
				m_scrollRectChanged = false;
			}
			
			rowDataOffset = m_maxCol;
			colDataOffset = 1;
			if(m_direction == DirectionDef.VERTICAL)
			{
				dataStartIndex = Math.floor(verticalScrollValue / (m_cellHeight + m_vergap)) * m_maxCol;
				rowOffset = verticalScrollValue % (m_cellHeight + m_vergap);
				baseCol = 0;
				baseRow = dataStartIndex / m_maxCol;
				tcol = col;
				trow = row;
				if(rowOffset)
				{
					trow ++;
				}
			}
			else
			{
				dataStartIndex = Math.floor(horizontalScrollValue / (m_cellWidth + m_horgap)) * m_maxRow;
				colOffset = horizontalScrollValue % (m_cellWidth + m_horgap);
				baseCol = dataStartIndex / m_maxRow;
				baseRow = 0;
				tcol = col;
				trow = row;
				if(colOffset)
				{
					tcol ++;
				}
			}
			
			releaseObjPool();
			
			if(m_srouce == null){
				return;
			}
			
			
			var rendererIndex:int = 0;
			for(var i:int = 0;i < trow;i ++)
			{
				for(var j:int = 0;j < tcol;j ++)
				{

					dataIndex = dataStartIndex + j * colDataOffset + i * rowDataOffset;
					if(dataIndex >= m_srouce.length || baseCol + j >= m_maxCol || baseRow + i >= m_maxRow)
					{
						continue;
					}
					rendererIndex += 1;
					objectPoolItem = m_rendererPool.getObject(rendererIndex.toString());
					itemRenderer = objectPoolItem.data as ItemRenderer;
					m_itemMap.set(rendererIndex.toString(), objectPoolItem);
					refItemMap[rendererIndex] = 1;
					delete m_refItemMap[rendererIndex];
					itemRenderer.data = m_srouce[dataIndex];
					itemRenderer.status = m_status[dataIndex];
					itemRenderer.x = j * (m_cellWidth + m_horgap) - colOffset;
					itemRenderer.y = i * (m_cellHeight + m_vergap) - rowOffset;
					itemRenderer.row = baseRow + i;
					itemRenderer.col = baseCol + j;
					itemRenderer.index = dataIndex;
					itemRenderer.addEventListener(MouseEvent.CLICK, onItemClick);
					itemRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onItemMouseDown);
					itemRenderer.addEventListener(MouseEvent.MOUSE_UP, onItemMouseUp);
					
					selected = (m_selectable)?dataIndex == m_selectedIndex:false;
					if(itemRenderer.selected != selected)
					{
						itemRenderer.selected = selected;
					}
					
					if(!contains(itemRenderer))
					{
						addChild(itemRenderer);
					}
				}
			}
			
			removeItemRenderer();
			m_refItemMap = refItemMap;
			
		}
		
		/**
		 *渲染单元点击事件 
		 * @param evt
		 * 
		 */		
		private function onItemClick(evt:MouseEvent):void
		{
			var event:GridEvent;	
			var itemRenderer:ItemRenderer;
			var renderer:ItemRenderer;
			
			itemRenderer = evt.currentTarget as ItemRenderer;
			if(m_statusMgr != null)
			{
				m_statusMgr.itemClick(itemRenderer, m_itemMap);
			}
			
			if(m_selectable)
			{
				waitUpdate();
				m_selectedIndex = itemRenderer.index;
			}
			
			event = new GridEvent(GridEvent.ITEM_CLICK);
			event.itemRenderer = itemRenderer;
			this.dispatchEvent(event);
		}
		
		private function onItemMouseDown(evt:MouseEvent):void
		{
			var event:GridEvent;	
			var itemRenderer:ItemRenderer;
			
			itemRenderer = evt.currentTarget as ItemRenderer;
			event = new GridEvent(GridEvent.ITEM_MOUSE_DOWN);
			event.itemRenderer = itemRenderer;
			this.dispatchEvent(event);
		}
		
		private function onItemMouseUp(evt:MouseEvent):void
		{
			var event:GridEvent;	
			var itemRenderer:ItemRenderer;
			
			itemRenderer = evt.currentTarget as ItemRenderer;
			event = new GridEvent(GridEvent.ITEM_MOUSE_UP);
			event.itemRenderer = itemRenderer;
			this.dispatchEvent(event);
		}
		
		/**
		 *释放引用 
		 * 
		 */		
		private function releaseObjPool():void
		{
			var objectPoolItem:ObjectPoolItem;
			for(var i:* in m_refItemMap)
			{
				objectPoolItem = m_itemMap.getValue(i) as ObjectPoolItem;
				objectPoolItem.release();
			}
		}
		
		public function get showingRenderList():Array
		{
			var list:Array = [];
			
			for each(var rendererData:* in m_itemMap.map)
			{
				list.push(rendererData.data);
			}
			
			return list;
		}
		
		/**
		 *从舞台移除渲染单元 
		 * 
		 */		
		private function removeItemRenderer():void
		{
			var id:String;
			
			var itemRenderer:ItemRenderer;
			var objectPoolItem:ObjectPoolItem;
			
			for(var i:* in m_refItemMap)
			{
				objectPoolItem = m_itemMap.getValue(i) as ObjectPoolItem;
				itemRenderer = objectPoolItem.data as ItemRenderer;
				itemRenderer.removeEventListener(MouseEvent.CLICK, onItemClick);
				itemRenderer.removeEventListener(MouseEvent.MOUSE_DOWN, onItemMouseDown);
				itemRenderer.removeEventListener(MouseEvent.MOUSE_UP, onItemMouseUp);
				removeChild(itemRenderer);
				m_itemMap.remove(i);
			}
		}
		
		/**
		 * 销毁没有使用到的渲染单元
		 * 
		 */		
		private function destroyItemRenderer():void
		{
			var poolMap:Dictionary;
			var itemRenderer:ItemRenderer;
			var objectPoolItem:ObjectPoolItem;
			
			poolMap = m_rendererPool.getPoolMap();
			for(var i:* in poolMap)
			{
				objectPoolItem = poolMap[i];
				itemRenderer = objectPoolItem.data as ItemRenderer;
				itemRenderer.destroy();
				delete poolMap[i];
			}
		}
		
		/**
		 *创建渲染单元 
		 * @return 
		 * 
		 */		
		private function createRenderer():ItemRenderer
		{
			var itemRenderer:ItemRenderer;
			
			if(m_itemSkinCls)
			{
				itemRenderer = new m_itemRendererCls(new m_itemSkinCls());
			}
			else
			{
				try{
					itemRenderer = new m_itemRendererCls(null);
				}catch(error:ArgumentError)
				{
					itemRenderer = new m_itemRendererCls();
				}
			}
			
			return itemRenderer;
		}
		
		}
}