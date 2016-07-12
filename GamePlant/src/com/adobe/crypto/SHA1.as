//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.crypto {
    import flash.utils.*;
    import com.adobe.utils.*;

    public class SHA1 {

        public static function hash(s:String):String{
            var blocks:Array = createBlocksFromString(s);
            var byteArray:ByteArray = hashBlocks(blocks);
            return (((((IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)));
        }
        public static function hashBytes(data:ByteArray):String{
            var blocks:Array = _slot1.createBlocksFromByteArray(data);
            var byteArray:ByteArray = hashBlocks(blocks);
            return (((((IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)));
        }
        public static function hashToBase64(s:String):String{
            var byte:uint;
            var blocks:Array = _slot1.createBlocksFromString(s);
            var byteArray:ByteArray = hashBlocks(blocks);
            var charsInByteArray:String = "";
            byteArray.position = 0;
            var j:int;
            while (j < byteArray.length) {
                byte = byteArray.readUnsignedByte();
                charsInByteArray = (charsInByteArray + String.fromCharCode(byte));
                j++;
            };
            var encoder:Base64Encoder = new Base64Encoder();
            encoder.encode(charsInByteArray);
            return (encoder.flush());
        }
        private static function hashBlocks(blocks:Array):ByteArray{
            var a:int;
            var b:int;
            var c:int;
            var d:int;
            var e:int;
            var t:int;
            var temp:int;
            var h0:int = 1732584193;
            var h1:int = 4023233417;
            var h2:int = 2562383102;
            var h3:int = 271733878;
            var h4:int = 3285377520;
            var len:int = blocks.length;
            var w:Array = new Array(80);
            var i:int;
            while (i < len) {
                a = h0;
                b = h1;
                c = h2;
                d = h3;
                e = h4;
                t = 0;
                while (t < 80) {
                    if (t < 16){
                        w[t] = blocks[(i + t)];
                    } else {
                        w[t] = IntUtil.rol((((w[(t - 3)] ^ w[(t - 8)]) ^ w[(t - 14)]) ^ w[(t - 16)]), 1);
                    };
                    temp = ((((IntUtil.rol(a, 5) + f(t, b, c, d)) + e) + int(w[t])) + k(t));
                    e = d;
                    d = c;
                    c = IntUtil.rol(b, 30);
                    b = a;
                    a = temp;
                    t++;
                };
                h0 = (h0 + a);
                h1 = (h1 + b);
                h2 = (h2 + c);
                h3 = (h3 + d);
                h4 = (h4 + e);
                i = (i + 16);
            };
            var byteArray:ByteArray = new ByteArray();
            byteArray.writeInt(h0);
            byteArray.writeInt(h1);
            byteArray.writeInt(h2);
            byteArray.writeInt(h3);
            byteArray.writeInt(h4);
            byteArray.position = 0;
            return (byteArray);
        }
        private static function f(t:int, b:int, c:int, d:int):int{
            if (t < 20){
                return (((b & c) | (~(b) & d)));
            };
            if (t < 40){
                return (((b ^ c) ^ d));
            };
            if (t < 60){
                return ((((b & c) | (b & d)) | (c & d)));
            };
            return (((b ^ c) ^ d));
        }
        private static function k(t:int):int{
            if (t < 20){
                return (1518500249);
            };
            if (t < 40){
                return (1859775393);
            };
            if (t < 60){
                return (2400959708);
            };
            return (3395469782);
        }
        private static function createBlocksFromByteArray(data:ByteArray):Array{
            var oldPosition:int = data.position;
            data.position = 0;
            var blocks:Array = new Array();
            var len:int = (data.length * 8);
            var mask:int = 0xFF;
            var i:int;
            while (i < len) {
                blocks[(i >> 5)] = (blocks[(i >> 5)] | ((data.readByte() & mask) << (24 - (i % 32))));
                i = (i + 8);
            };
            blocks[(len >> 5)] = (blocks[(len >> 5)] | (128 << (24 - (len % 32))));
            blocks[((((len + 64) >> 9) << 4) + 15)] = len;
            data.position = oldPosition;
            return (blocks);
        }
        private static function createBlocksFromString(s:String):Array{
            var blocks:Array = new Array();
            var len:int = (s.length * 8);
            var mask:int = 0xFF;
            var i:int;
            while (i < len) {
                blocks[(i >> 5)] = (blocks[(i >> 5)] | ((s.charCodeAt((i / 8)) & mask) << (24 - (i % 32))));
                i = (i + 8);
            };
            blocks[(len >> 5)] = (blocks[(len >> 5)] | (128 << (24 - (len % 32))));
            blocks[((((len + 64) >> 9) << 4) + 15)] = len;
            return (blocks);
        }

    }
}//package com.adobe.crypto 
