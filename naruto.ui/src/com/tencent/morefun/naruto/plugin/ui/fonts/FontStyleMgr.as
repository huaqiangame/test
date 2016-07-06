package com.tencent.morefun.naruto.plugin.ui.fonts 
{
	import flash.text.Font;
	import flash.utils.getDefinitionByName;

	public class FontStyleMgr 
	{
		/**
		 * 汉仪雪君体字体
		 * 26个大小写英文字符、数字、标点符号
		 */
		public static const HYXueJunJ:String = "CXingKaiHK-Bold";
		
		/**
		 * 宋体
		 */
		public static const SongTi:String = "SimSun";
		
		/**
		 * 构造函数
		 * create a [FontStyleMgr] object
		 */
		public function FontStyleMgr()
		{
			
		}
		
		/**
		 * 初始化全局字体
		 */
		public function setup():void
		{
			var cls:Class = getDefinitionByName("ui.fonts.HanYiXueJunJian") as Class;
			Font.registerFont(cls);
		}
		}

}