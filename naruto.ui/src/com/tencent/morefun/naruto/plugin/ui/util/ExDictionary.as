package com.tencent.morefun.naruto.plugin.ui.util
{
	import flash.utils.Dictionary;
	

	public class ExDictionary
	{
		private var m_length:int;
		private var m_map:Dictionary = new Dictionary();
		
		public function ExDictionary()
		{
		}
		
		public function set(key:String, value:Object):void
		{
			if(m_map[key] == null)
			{
				m_length ++;
			}
			
			m_map[key] = value;
		}
		
		public function remove(key:String):void
		{
			if(m_map[key] != null)
			{
				m_length --;
				
				delete m_map[key];
			}
		}
		
		public function removeAll():void
		{
			for(var i:* in m_map)
			{
				delete m_map[i];
			}
			
			m_length = 0;
		}
		
		public function getValue(key:String):Object
		{
			return m_map[key];
		}
		
		public function get length():int
		{
			return m_length;
		}
		
		public function get map():Dictionary
		{
			return m_map;
		}
		}
}