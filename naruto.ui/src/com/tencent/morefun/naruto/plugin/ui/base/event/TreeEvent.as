package com.tencent.morefun.naruto.plugin.ui.base.event
{
	import flash.events.Event;

	public class TreeEvent extends Event
	{
		public static const NODE_OPEN:String = "nodeOpen";
		public static const NODE_CLOSE:String = "nodeClose";
		public static const NODE_CLICK:String = "nodeClick";
		public static const NODE_CREATE:String = "nodeCreate";
		public static const NODE_REMOVE:String = "nodeRemove";
		public static const TREE_UPDATE:String = "treeUpdate";
		
		public var nodeId:String;
		public var nodedata:Object;
		public function TreeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		}
}