package com.tencent.morefun.naruto.plugin.ui.util
{
	import com.tencent.morefun.naruto.plugin.ui.util.event.ObjectPoolEvent;
	import flash.utils.Dictionary;
	

	public class ObjectPool
	{
		private var m_autoIndex:Number;
		private var m_creatObjFunc:Function;
		private var m_objPool:Dictionary = new Dictionary(true);
		
		public function ObjectPool(creatObjFunc:Function)
		{
			m_creatObjFunc = creatObjFunc;
		}
		
		public function getObject(id:String = null):ObjectPoolItem
		{
			var obj:ObjectPoolItem;
			
			if(id != null)
			{
				obj = m_objPool[id];
				if(obj != null)
				{
					delete m_objPool[id];
					return obj;
				}
			}
			for(var i:* in m_objPool)
			{
				obj = m_objPool[i];
				if(obj.reuse)
				{
					delete m_objPool[i];
					return obj;
				}
			}
			
			return createObject(id);
		}
		
		public function getPoolMap():Dictionary
		{
			return m_objPool;
		}
		
		public function destroy():void
		{
			var obj:ObjectPoolItem;
			
			for(var key:* in m_objPool)
			{
				m_objPool[key].removeEventListener(ObjectPoolEvent.RELEASE, onRelease);
			}
			
			m_objPool = null;
		}
		
		private function onRelease(evt:ObjectPoolEvent):void
		{
			var item:ObjectPoolItem;
			
			item = evt.target as ObjectPoolItem;
			m_objPool[item.id] = item;
		}
		
		private function createObject(id:String):ObjectPoolItem
		{
			var item:ObjectPoolItem;
			var reuse:Boolean;
			
			if(id == null)
			{
				reuse = true;
				id = "ObjectPool" + (m_autoIndex ++);
			}
			
			item = new ObjectPoolItem(m_creatObjFunc(), id, reuse);
			item.addEventListener(ObjectPoolEvent.RELEASE, onRelease, false, 0, true);
			return item;
		}
		}
}