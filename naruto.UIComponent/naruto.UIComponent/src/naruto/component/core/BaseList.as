package naruto.component.core
{
	import flash.events.Event;
	
	[Event(name="select", type="flash.events.Event")]
	
	/**
	 * 基类：列表。
	 * @author yboyjiang
	 */	
	public class BaseList extends UIComponent implements IScrollable
	{
		/**
		 * 此类必须是 BaseListItemRenderer 的子类。
		 */		
		protected var listItemRendererClass:Class;
		
		protected var _data:Array;
		protected var _dataKey:String;
		protected var _selectedIndex:int = -1;
		protected var _scrollPercent:Number = 0;
		
		public function BaseList(listItemRendererClass:Class)
		{
			super();
			this.listItemRendererClass = listItemRendererClass;
		}
		
		/**
		 * 数据源。
		 * @param data
		 */		
		public function get data():Array
		{
			return _data;
		}
		
		public function set data(value:Array):void
		{
			_data = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * 数据源key。
		 * @param data
		 */	
		public function get dataKey():String 
		{
			return _dataKey;
		}
		
		public function set dataKey(value:String):void 
		{
			_dataKey = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * 选中的索引。
		 */		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			this.invalidate(InvalidationType.STATE);
			this.dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get scrollPercent():Number
		{
			return _scrollPercent;
		}
		
		public function set scrollPercent(value:Number):void
		{
			value = Math.max(0, Math.min(value, 1));
			if (value != _scrollPercent)
			{
				_scrollPercent = value;
				this.invalidate(InvalidationType.SCROLL);
			}
		}
		
		public function get viewAreaPercent():Number
		{
			return 0;
		}
		
		public function set viewAreaPercent(value:Number):void
		{
			throw new Error("此值在此类里不可写。");
		}
		
		public function get rowCount():int
		{
			throw new Error("需要子类重写。");
			return 0;
		}
		
		public function set rowCount(value:int):void
		{
			throw new Error("需要子类重写。");
		}
		
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.listItemRendererClass = null;
			this._data = null;
			this._dataKey = null;
			
			super.dispose();
		}
		
	}
}