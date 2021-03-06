package com.tencent.morefun.naruto.plugin.ui.util.ext {


    import com.tencent.morefun.naruto.i18n.I18n;
    public class BitmapBytes {
        import flash.display.BitmapData;
        import flash.geom.Rectangle;
        import flash.utils.ByteArray;
        
        
        public function BitmapBytes() {
            throw new Error(I18n.lang("as_ui_1451031579_6182"));
        }
        
        public static function encodeByteArray(data:BitmapData):ByteArray {
            if(data == null) {
                //throw new Error("data参数不能为空!");
				return null;
            }
            var bytes:ByteArray = data.getPixels(data.rect);
            bytes.writeShort(data.width);
            bytes.writeShort(data.height);
            bytes.writeBoolean(data.transparent);
            bytes.compress();
            bytes.position = 0;
            return bytes;
        }
        
        public static function encodeBase64(data:BitmapData):String {
            return Base64.encodeByteArray(encodeByteArray(data));
        }
        
        public static function decodeByteArray(bytes:ByteArray):BitmapData {
            if(bytes == null) {
                //throw new Error("bytes参数不能为空!");
				return null;
            }
            bytes.uncompress();
            
            if(bytes.length < 6) {
                throw new Error(I18n.lang("as_ui_1451031579_6183"));
            }
            bytes.position = bytes.length - 1;
            var transparent:Boolean = bytes.readBoolean();
            bytes.position = bytes.length - 3;
            var height:int = bytes.readShort();
            bytes.position = bytes.length - 5;
            var width:int = bytes.readShort();
            bytes.position = 0;
            var datas:ByteArray = new ByteArray();
            bytes.readBytes(datas, 0, bytes.length - 5);
            var bmp:BitmapData = new BitmapData(width, height, transparent, 0);
            bmp.setPixels(new Rectangle(0, 0, width, height), datas);
			
            return bmp;
        }
        
        public static function decodeBase64(data:String):BitmapData {
            return decodeByteArray(Base64.decodeToByteArray(data));
        }
    
    	}
}
