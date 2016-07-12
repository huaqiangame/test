package naruto.component.core
{
	/**
	 * 可滚动的东西。例如：List 。
	 * @author yboyjiang
	 */	
	public interface IScrollable
	{
		/**
		 * 滚动百分比。0表示最顶端，1表示最底端。
		 */		
		function get scrollPercent():Number;
		function set scrollPercent(value:Number):void;
		
		/**
		 * 可视区域占全部内容的比例。0表示可视区域无，1表示全部内容完全可见。
		 */		
		function get viewAreaPercent():Number;
		function set viewAreaPercent(value:Number):void;
	}
}