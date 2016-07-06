package naruto.component.core.event
{
	import flash.events.Event;
	
	public class PageSwitcherEvent extends Event
	{
		public static const PAGE_SWITCHER_VALUE_CHANGED:String = "pageSwitcherValueChanged";
		
		public var newValue:int;
		
		public function PageSwitcherEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type);
		}
	}
}