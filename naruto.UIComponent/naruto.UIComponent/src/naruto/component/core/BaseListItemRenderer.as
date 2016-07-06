package naruto.component.core
{
	import flash.events.Event;

	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 基类：列表的 ItemRenderer 。
	 * @author yboyjiang
	 */	
	public class BaseListItemRenderer extends UIComponent
	{
		protected var _index:uint;
		protected var _data:Object;
		protected var _selected:Boolean;
		
		public function BaseListItemRenderer()
		{
			super();
		}
		
		/**
		 * 索引。
		 */		
		public function get index():uint
		{
			return _index;
		}
		
		public function set index(value:uint):void
		{
			_index = value;
		}
		
		/**
		 * 数据源。
		 */		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * 选中。
		 */		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (_selected != value)
			{
				_selected = value;
				this.invalidate(InvalidationType.STATE);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		override public function dispose():void
		{
			// 事件
			
			// 置空
			this._data = null;
			
			super.dispose();
		}
		
	}
}