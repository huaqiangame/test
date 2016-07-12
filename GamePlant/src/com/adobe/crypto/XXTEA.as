//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.crypto {
    import flash.utils.*;

    public class XXTEA {

        private static const delta:uint = uint(2654435769);

        private static function LongArrayToByteArray(data:Array, includeLength:Boolean):ByteArray{
            var m:uint;
            var length:uint = data.length;
            var n:uint = ((length - 1) << 2);
            if (includeLength){
                m = data[(length - 1)];
                if ((((m < (n - 3))) || ((m > n)))){
                    return (null);
                };
                n = m;
            };
            var result:ByteArray = new ByteArray();
            result.endian = Endian.LITTLE_ENDIAN;
            var i:uint;
            while (i < length) {
                result.writeUnsignedInt(data[i]);
                i++;
            };
            if (includeLength){
                result.length = n;
                return (result);
            };
            return (result);
        }
        private static function ByteArrayToLongArray(data:ByteArray, includeLength:Boolean):Array{
            var length:uint = data.length;
            var n:uint = (length >> 2);
            if ((length % 4) > 0){
                n++;
                data.length = (data.length + (4 - (length % 4)));
            };
            data.endian = Endian.LITTLE_ENDIAN;
            data.position = 0;
            var result:Array = [];
            var i:uint;
            while (i < n) {
                result[i] = data.readUnsignedInt();
                i++;
            };
            if (includeLength){
                result[n] = length;
            };
            data.length = length;
            return (result);
        }
        public static function encrypt(data:ByteArray, key:ByteArray):ByteArray{
            var mx:uint;
            var e:uint;
            var p:uint;
            if (data.length == 0){
                return (new ByteArray());
            };
            var v:Array = ByteArrayToLongArray(data, true);
            var k:Array = ByteArrayToLongArray(key, false);
            if (k.length < 4){
                k.length = 4;
            };
            var n:uint = (v.length - 1);
            var z:uint = v[n];
            var y:uint = v[0];
            var q:uint = uint((6 + (52 / (n + 1))));
            var sum:uint;
            while (0 < q--) {
                sum = (sum + delta);
                e = ((sum >>> 2) & 3);
                p = 0;
                while (p < n) {
                    y = v[(p + 1)];
                    mx = ((((z >>> 5) ^ (y << 2)) + ((y >>> 3) ^ (z << 4))) ^ ((sum ^ y) + (k[((p & 3) ^ e)] ^ z)));
                    z = (v[p] = (v[p] + mx));
                    p++;
                };
                y = v[0];
                mx = ((((z >>> 5) ^ (y << 2)) + ((y >>> 3) ^ (z << 4))) ^ ((sum ^ y) + (k[((p & 3) ^ e)] ^ z)));
                z = (v[n] = (v[n] + mx));
            };
            return (LongArrayToByteArray(v, false));
        }
        public static function decrypt(data:ByteArray, key:ByteArray):ByteArray{
            var mx:uint;
            var e:uint;
            var p:uint;
            if (data.length == 0){
                return (new ByteArray());
            };
            var v:Array = ByteArrayToLongArray(data, false);
            var k:Array = ByteArrayToLongArray(key, false);
            if (k.length < 4){
                k.length = 4;
            };
            var n:uint = (v.length - 1);
            var z:uint = v[(n - 1)];
            var y:uint = v[0];
            var q:uint = uint((6 + (52 / (n + 1))));
            var sum:uint = (q * delta);
            while (sum != 0) {
                e = ((sum >>> 2) & 3);
                p = n;
                while (p > 0) {
                    z = v[(p - 1)];
                    mx = ((((z >>> 5) ^ (y << 2)) + ((y >>> 3) ^ (z << 4))) ^ ((sum ^ y) + (k[((p & 3) ^ e)] ^ z)));
                    y = (v[p] = (v[p] - mx));
                    p--;
                };
                z = v[n];
                mx = ((((z >>> 5) ^ (y << 2)) + ((y >>> 3) ^ (z << 4))) ^ ((sum ^ y) + (k[((p & 3) ^ e)] ^ z)));
                y = (v[0] = (v[0] - mx));
                sum = (sum - delta);
            };
            return (LongArrayToByteArray(v, true));
        }

    }
}//package com.adobe.crypto 
