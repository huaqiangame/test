package com.tencent.morefun.naruto.plugin.prewar.data
{
	import ninja.model.data.NinjaInfo;

	/**
	 * 背包忍者信息
	 * @author larryhou
	 * @createTime 2013/9/27 16:11
	 */
	public class PackageNinjaInfo
	{
		/**
		 * 解锁等级
		 */
		public var levelUnlock:uint;
		
		/**
		 * 是否被锁定
		 */
		public var locked:Boolean;
		
		/**
		 * 忍者信息
		 */
		public var ninja:NinjaInfo;
		
		/**
		 *是否正在拖动 
		 */		
		public var dragging:Boolean;
		
		/**
		 *是否选中 
		 */		
		public var selected:Boolean;
		
		/**
		 * 构造函数
		 * create a [PackageNinjaInfo] object
		 */
		public function PackageNinjaInfo(locked:Boolean = false, levelUnlock:uint = 0, ninja:NinjaInfo = null) 
		{
			this.locked = locked; this.levelUnlock =  levelUnlock; this.ninja = ninja;
		}
	}

}