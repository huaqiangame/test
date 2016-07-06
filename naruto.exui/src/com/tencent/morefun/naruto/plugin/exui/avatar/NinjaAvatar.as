package com.tencent.morefun.naruto.plugin.exui.avatar
{
    import def.NinjaAssetDef;

    public class NinjaAvatar extends Avatar
    {
        public function NinjaAvatar(width:int=0, height:int=0)
        {
            super(width, height);
        }

        public function loadLarge(id:uint):void
        {
            loadByType(id, NinjaAssetDef.HEAD_BIG);
        }

        public function loadSmall(id:uint):void
        {
            loadByType(id, NinjaAssetDef.HEAD_SMALL);
        }

        public function loadByType(id:uint, type:String):void
        {
			if(NinjaAssetDef.isMajor(id))
			{
				id = int(id/100)*100 + 1; 
			}
            var url:String = NinjaAssetDef.getAsset(type, id);

            load(url);
        }
   	}
}