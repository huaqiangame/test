package com.tencent.morefun.naruto.plugin.map
{
	
	import com.tencent.morefun.framework.apf.core.plugin.Plugin;
	import com.tencent.morefun.naruto.plugin.map.executer.MapViewExecuter;
	
	import flash.geom.Matrix;
	import flash.net.registerClassAlias;
	
	import def.PluginDef;
	
	import map.IMapPlugin;
	import map.data.MapBgImgInfo;
	import map.data.MapFgImgInfo;
	import map.data.MapMgImgInfo;
	
	public class MapPlugin extends Plugin implements IMapPlugin
	{
		public function MapPlugin()
		{
			super();
			
			registerClassAlias("Matrix_Class_Alias", Matrix);
			registerClassAlias("MapBgImgInfo_Class_Alias", MapBgImgInfo);
			registerClassAlias("MapMgImgInfo_Class_Alias", MapMgImgInfo);
			registerClassAlias("MapFgImgInfo_Class_Alias", MapFgImgInfo);
		}

		override public function getPluginName():String
		{
			return PluginDef.MAP;
		}
		
		override public function initialize(config:XML):void
		{
			registerExecuter(new MapViewExecuter());
		}
	}
}