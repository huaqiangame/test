package naruto.component.core
{
	import flash.events.Event;

	[Event(name="select", type="flash.events.Event")]
	
	/**
	 * ComboBox 基类。
	 * @author yboyjiang
	 */	
	public class BaseComboBox extends UIComponent
	{
		/**
		 * 此类必须是 BaseList 的子类。
		 */		
		protected var listClass:Class;
		
		protected var _data:Array;
		protected var _dataKey:String;
		protected var _selectedIndex:int = -1;
		protected var _rowCount:int = 0;
		
		public function BaseComboBox(listClass:Class)
		{
			super();
			this.listClass = listClass;
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
		 * 数据key
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
			if (_selectedIndex == value)
			{
				return;
			}
			_selectedIndex = value;
			this.invalidate(InvalidationType.STATE);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get rowCount():int
		{
			return _rowCount;
		}
		
		public function set rowCount(value:int):void
		{
			_rowCount = value;
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this.listClass = null;
			this._data = null;
			this._dataKey = null;
			
			super.dispose();
		}
		
	}
}