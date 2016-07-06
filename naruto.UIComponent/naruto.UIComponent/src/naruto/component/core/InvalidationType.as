package naruto.component.core
{
	/**
	 * 组件的无效类型。组件开发人员使用这些常量来指定组件变为无效以后要重绘的组件部分。
	 * @author yboyjiang
	 */	
	public class InvalidationType
	{
		/**
		 * 全部无效。
		 */		
		public static const ALL:String = "all";
		
		/**
		 * 状态无效。例如改变了组件的 enabled 属性；改变按钮的鼠标状态；
		 */		
		public static const STATE:String = "state";
		
		/**
		 * 尺寸无效。改变了组件的宽高都会导致尺寸无效。
		 */		
		public static const SIZE:String = "size";
		
		/**
		 * 选中无效，改变组件选中状态会导致尺寸无效
		 */		
		public static const SELECTED:String = "selected";
		
		/**
		 * 数据无效，改变组件的数据时会导致数据无效
		 */
		public static const DATA:String = "data";
		
		/**
		 * 被滚动过后。
		 */		
		public static const SCROLL:String = "scroll";

		
		public function InvalidationType()
		{
		}
	}
}