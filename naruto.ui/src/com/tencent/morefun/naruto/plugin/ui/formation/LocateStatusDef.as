package com.tencent.morefun.naruto.plugin.ui.formation 
{

	public class LocateStatusDef 
	{
		/**
		 * 有网格被其他阵法忍者占用
		 */
		public static const LOCATE_FAIL_OCCUPIED:uint = 1 << 1;
		
		/**
		 * 占用网格超出边界
		 */
		public static const LOCATE_FAIL_NULL:uint = 1 << 2;
		
		/**
		 * 有覆盖空白网格
		 */
		public static const LOCATE_PASS:uint = 1 << 3;
		}

}