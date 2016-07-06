package com.tencent.morefun.naruto.plugin.ui.util
{
	import com.tencent.morefun.naruto.util.StrReplacer;

    import com.tencent.morefun.naruto.i18n.I18n;
	public class MomeyStringUtil
	{
		public function MomeyStringUtil()
		{
		}
		
		public static function getMomeyStr(value:int):String
		{
			var result:String;
			
			if (value < 100000)
			{
				result = value.toString();
			}
			else
			{
				var value:int = int(value / 10000);
				result = StrReplacer.replace(I18n.lang("as_ui_1451031579_6192"), value);
			}
			
			return result;
		}
	}
}