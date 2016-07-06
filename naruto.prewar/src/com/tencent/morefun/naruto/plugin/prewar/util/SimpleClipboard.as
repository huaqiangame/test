package com.tencent.morefun.naruto.plugin.prewar.util
{
	import flash.utils.Dictionary;
	
	/**
	 * 剪切板
	 * @author larryhou
	 * @createTime 2013/9/12 15:44
	 */
	public class SimpleClipboard 
	{
		private static const _buffer:Dictionary = new Dictionary(false);
		
		/**
		 * 设置剪切板
		 * @param	name	数据名
		 * @param	data	需要放到剪切板的内容
		 */
		public static function set(name:String, data:Object):void
		{
			_buffer[name] = data;
		}
		
		/**
		 * 获取剪切板内容
		 * @param	name	数据名
		 */
		public static function get(name:String):Object
		{
			return _buffer[name];
		}
		
		/**
		 * 检测书剪切板数据是否存在
		 * @param	name	数据名
		 */
		public static function has(name:String):Boolean
		{
			return Boolean(_buffer[name]);
		}
		
		/**
		 * 清除剪切板内容
		 * @param	name	数据名
		 */
		public static function clear(name:String):void
		{
			delete _buffer[name];
		}
		
		/**
		 * 清空剪切板
		 */
		public static function clearAll():void
		{
			for (var name:String in _buffer) delete _buffer[name];
		}		
	}

}