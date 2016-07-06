package com.tencent.morefun.naruto.plugin.ui.util
{
	import com.tencent.morefun.naruto.plugin.ui.util.event.ObjectPoolEvent;
	import flash.events.EventDispatcher;

	public class ObjectPoolItem extends EventDispatcher
	{
		private var m_id:String;
		private var m_data:Object;
		private var m_reuse:Boolean;
		
		public function ObjectPoolItem(data:Object, id:String, reuse:Boolean)
		{
			super();
			
			m_id = id;
			m_data = data;
			m_reuse = reuse;
		}
		
		public function get data():Object
		{
			return m_data;
		}
		
		public function get id():String
		{
			return m_id;
		}
		
		public function get reuse():Boolean
		{
			return m_reuse;
		}
		
		public function release():void
		{
			this.dispatchEvent(new ObjectPoolEvent(ObjectPoolEvent.RELEASE));
		}
		}
}