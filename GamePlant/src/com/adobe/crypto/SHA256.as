//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.crypto {
    import flash.utils.*;
    import com.adobe.utils.*;

    public class SHA256 {

        public static function hash(s:String):String{
            var blocks:Array = createBlocksFromString(s);
            var byteArray:ByteArray = hashBlocks(blocks);
            return ((((((((IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)));
        }
        public static function hashBytes(data:ByteArray):String{
            var blocks:Array = createBlocksFromByteArray(data);
            var byteArray:ByteArray = hashBlocks(blocks);
            return ((((((((IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)) + IntUtil.toHex(byteArray.readInt(), true)));
        }
        public static function hashToBase64(s:String):String{
            var byte:uint;
            var blocks:Array = createBlocksFromString(s);
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
            var f:int;
            var g:int;
            var h:int;
            var t:int;
            var s0:int;
            var maj:int;
            var t2:int;
            var s1:int;
            var ch:int;
            var t1:int;
            var ws0:int;
            var ws1:int;
            var h0:int = 1779033703;
            var h1:int = 3144134277;
            var h2:int = 1013904242;
            var h3:int = 2773480762;
            var h4:int = 1359893119;
            var h5:int = 2600822924;
            var h6:int = 528734635;
            var h7:int = 1541459225;
            var k:Array = new Array(1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298);
            var len:int = blocks.length;
            var w:Array = new Array(64);
            var i:int;
            while (i < len) {
                a = h0;
                b = h1;
                c = h2;
                d = h3;
                e = h4;
                f = h5;
                g = h6;
                h = h7;
                t = 0;
                while (t < 64) {
                    if (t < 16){
                        w[t] = blocks[(i + t)];
                        if (isNaN(w[t])){
                            w[t] = 0;
                        };
                    } else {
                        ws0 = ((IntUtil.ror(w[(t - 15)], 7) ^ IntUtil.ror(w[(t - 15)], 18)) ^ (w[(t - 15)] >>> 3));
                        ws1 = ((IntUtil.ror(w[(t - 2)], 17) ^ IntUtil.ror(w[(t - 2)], 19)) ^ (w[(t - 2)] >>> 10));
                        w[t] = (((w[(t - 16)] + ws0) + w[(t - 7)]) + ws1);
                    };
                    s0 = ((IntUtil.ror(a, 2) ^ IntUtil.ror(a, 13)) ^ IntUtil.ror(a, 22));
                    maj = (((a & b) ^ (a & c)) ^ (b & c));
                    t2 = (s0 + maj);
                    s1 = ((IntUtil.ror(e, 6) ^ IntUtil.ror(e, 11)) ^ IntUtil.ror(e, 25));
                    ch = ((e & f) ^ (~(e) & g));
                    t1 = ((((h + s1) + ch) + k[t]) + w[t]);
                    h = g;
                    g = f;
                    f = e;
                    e = (d + t1);
                    d = c;
                    c = b;
                    b = a;
                    a = (t1 + t2);
                    t++;
                };
                h0 = (h0 + a);
                h1 = (h1 + b);
                h2 = (h2 + c);
                h3 = (h3 + d);
                h4 = (h4 + e);
                h5 = (h5 + f);
                h6 = (h6 + g);
                h7 = (h7 + h);
                i = (i + 16);
            };
            var byteArray:ByteArray = new ByteArray();
            byteArray.writeInt(h0);
            byteArray.writeInt(h1);
            byteArray.writeInt(h2);
            byteArray.writeInt(h3);
            byteArray.writeInt(h4);
            byteArray.writeInt(h5);
            byteArray.writeInt(h6);
            byteArray.writeInt(h7);
            byteArray.position = 0;
            return (byteArray);
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
