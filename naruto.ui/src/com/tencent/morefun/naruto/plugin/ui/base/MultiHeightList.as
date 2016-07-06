package com.tencent.morefun.naruto.plugin.ui.base
{
	import com.tencent.morefun.naruto.plugin.ui.EasyLayoutScrollBar_2_Skin;
	import com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class MultiHeightList extends Sprite
	{
		private var _renderClass:Class;
		private var _listWidth:int;
		private var _listHeight:int;
		private var _vgap:int;
		private var _dataSource:Array;
		private var _dataItemHeight:Array;
		private var _freeRenders:Array;
		private var _showingRenders:Array;
		private var _scrollValue:int;
		private var _dataSumHeight:int;
		private var _renderContainer:Sprite;
		private var _scrollBar:com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar;
		private var _scrollRect:Rectangle;
		
		public function MultiHeightList(renderClass:Class, listWidth:int, listHeight:int, vgap:int = 0, scrollBarUI:MovieClip = null)
		{
			super();
			
			drawMouseArea();
			
			this._renderClass = renderClass;
			this._listWidth = listWidth;
			this._listHeight = listHeight;
			this._vgap = vgap;
			
			this._dataSource = new Array();
			this._dataItemHeight = new Array();
			this._freeRenders = new Array();
			this._showingRenders = new Array();
			
			this._renderContainer = new Sprite();
			this.addChild(_renderContainer);
			this._scrollRect = new Rectangle(0, 0, listWidth, listHeight);
			_renderContainer.scrollRect = _scrollRect;
			
			this._scrollValue = 0;
			this._dataSumHeight = 0;
			
			this._scrollBar = new com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar((scrollBarUI)? scrollBarUI : new EasyLayoutScrollBar_2_Skin(), listHeight);
			this._scrollBar.bar.minHeight = 10;
			this._scrollBar.addEventListener(Event.CHANGE, onScrollBarValueChange);
			this._scrollBar.wheelArea = this;
			this.addChild(_scrollBar.view);
			scrollerUpdate();
		}

		public function push(data:Object):void
		{
			var renderHeight:int = getRenderHeight(data);
			
			_dataSource.push(data);
			_dataItemHeight.push(renderHeight);
			(_dataSumHeight < listHeight) && (updateView());  //如果满足这个条件，push进去的数据在当前显示范围内，所以应该更新视图
			_dataSumHeight += renderHeight;
			scrollerUpdate();
		}
		
		public function pop():void
		{
			var renderHeight:int;
			
			_dataSource.pop();
			renderHeight = _dataItemHeight.pop();
			_dataSumHeight -= renderHeight;
			if (_dataSumHeight < _scrollValue+listHeight)  //如果满足这个条件，删除的数据在当前显示范围内，所以应该更新视图
			{
				_scrollValue = _dataSumHeight - listHeight;
				updateView();
			}
			scrollerUpdate();
		}
		
		public function shift():void
		{
			var renderHeight:int;
			
			_dataSource.shift();
			renderHeight = _dataItemHeight.shift();
			_dataSumHeight -= renderHeight;
			if (_scrollValue < renderHeight)  //如果满足这个条件，删除的数据在当前显示范围内，所以应该更新视图
			{
				_scrollValue = 0;
				updateView();
			}
			else
			{
				_scrollValue -= renderHeight;
			}
			scrollerUpdate();
		}
		
		public function splice(...paras):void
		{
			var heightParams:Array;
			var addDataSumHeight:int;
			var delDataSumHeight:int;
			var deletedItemHeightArr:Array;
			
			heightParams = new Array();
			addDataSumHeight = 0;
			for (var i:int = 0; i < paras.length; i++)
			{
				if (i < 2)  //前两个参数是起始索引和要删除的数量,后面的是若干个data
				{
					heightParams[i] = paras[i];
				}
				else
				{
					heightParams[i] = getRenderHeight(paras[i]);
					addDataSumHeight += heightParams[i];
				}			
			}
			
			_dataSource.splice.apply(_dataSource, paras);
			deletedItemHeightArr = _dataItemHeight.splice.apply(_dataItemHeight, heightParams);
			if (deletedItemHeightArr && deletedItemHeightArr.length > 0)
			{
				for each (var deletedItemHeight:int in deletedItemHeightArr)
				{
					_dataSumHeight -= deletedItemHeight;
				}
			}
			_dataSumHeight += addDataSumHeight;
			(_scrollValue > maxScrollValue) && (_scrollValue = maxScrollValue);
			updateView();
			scrollerUpdate();
		}
		
		/**
		 *  设置列表的滚动值
		 */
		private function set scrollValue(value:int):void
		{
			_scrollValue = value;
			updateView();
		}
		
		/**
		 *  获取列表的当前滚动值
		 */
		private function get scrollValue():int
		{
			return _scrollValue;
		}
		
		private function updateView():void
		{
			var sumHeight:int = 0;
			var showingSumHeight:int = 0;
			var render:ItemRenderer;
			
			recyleAllRenders();
			for (var i:int = 0; i < _dataSource.length; i++)
			{
				if ((sumHeight > (scrollValue-_dataItemHeight[i]) && sumHeight < (scrollValue+listHeight)) || (sumHeight <= scrollValue && (sumHeight+_dataItemHeight[i]) >= (scrollValue+listHeight)))
				{
					if (_showingRenders.length == 0)
					{
						this._scrollRect.y = scrollValue - sumHeight;
						_renderContainer.scrollRect = _scrollRect;
					}
					render = getFilledRender(_dataSource[i]);
					render.y = showingSumHeight;
					showingSumHeight += (_dataItemHeight[i]);
					_renderContainer.addChild(render);
					_showingRenders.push(render);
				}
				else
				{
					if (_showingRenders.length > 0)
					{
						break;
					}
				}
				sumHeight += _dataItemHeight[i];
			}
		}
		
		public function get scrollBar():com.tencent.morefun.naruto.plugin.ui.components.scrollers.ScrollBar
		{
			return _scrollBar;
		}
		
		/**
		 * 回收所有在显示的render
		 */
		private function recyleAllRenders():void
		{
			_renderContainer.removeChildren();
			while (_showingRenders.length > 0)
			{ 
				_freeRenders.push(_showingRenders.pop());
			}
		}
		
		/**
		 * 得到一个已经赋值为data的渲染器
		 */
		private function getFilledRender(data:Object):ItemRenderer
		{
			var render:ItemRenderer;
			for (var i:int = 0; i < _freeRenders.length; i++)
			{
				render = _freeRenders[i] as ItemRenderer;
				if (render.data == data) 
				{
					_freeRenders.splice(i,1);
					break;
				}
				if (i == _freeRenders.length-1)
				{
					_freeRenders.pop();
					render.data = data;
					break;
				}
			}
			
			if (!render)
			{
				render = new _renderClass();
				render.data = data;
			}
			
			return render;
		}
		
		private function getRenderHeight(data:Object):int
		{
			var render:ItemRenderer = new _renderClass() as ItemRenderer;
			var result:int;
			render.data = data;
			result = render.height + _vgap;
			render.destroy();
			render = null;
			
			return result;
		}
		
		private function scrollerUpdate():void
		{
			_scrollBar.height = this._listHeight;
			_scrollBar.pageCount = this._listHeight;
			_scrollBar.lineCount = this._dataSumHeight;
			_scrollBar.value = percentScrollValue;
		}
		
		private function onScrollBarValueChange(evt:Event):void
		{
			this.scrollValue = maxScrollValue * _scrollBar.value / 100;
//			trace("scrollValueeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee:" + _scrollBar.value);
		}
		
		private function get maxScrollValue():int
		{
			return (_dataSumHeight - listHeight > 0)? (_dataSumHeight - listHeight) : 0;
		}
		
		private function get percentScrollValue():Number
		{
			return Number(_scrollValue) / maxScrollValue * 100;
		}
		
		public function get listWidth():int
		{
			return _listWidth;
		}

		public function set listWidth(value:int):void
		{
			_listWidth = value;
			drawMouseArea();
		}

		public function get listHeight():int
		{
			return _listHeight;
		}

		public function set listHeight(value:int):void
		{
			_listHeight = value;
			_scrollRect.height = value;
			_renderContainer.scrollRect = _scrollRect;
			_scrollValue = (_scrollValue > maxScrollValue)? maxScrollValue : _scrollValue;
			updateView();
			scrollerUpdate();
			drawMouseArea();
		}
		
		public function get length():int
		{
			return _dataSource.length;
		}
		
		public function clear():void
		{
			while (_dataSource.length > 0)
			{
				_dataSource.pop();
			}
			
			while (_dataItemHeight.length > 0)
			{
				_dataItemHeight.pop();
			}
			
			this._scrollValue = 0;
			this._dataSumHeight = 0;
			updateView();
			scrollerUpdate();
		}
		
		public function set dataProvider(value:Array):void
		{
			var renderHeight:int;
			clear();
			for each (var obj:Object in value)
			{
				renderHeight = getRenderHeight(obj);
				_dataSource.push(obj);
				_dataItemHeight.push(renderHeight);
				_dataSumHeight += renderHeight;
			}
			
			_scrollValue = 0;
			updateView();
			scrollerUpdate();
		}
		
		public function get dataProvider():Array
		{
			return _dataSource;
		}
		
		private function drawMouseArea():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff, 0);
			this.graphics.drawRect(0, 0, _listWidth, _listHeight);
			this.graphics.endFill();
		}


		}
}