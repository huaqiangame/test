//Created by Action Script Viewer - http://www.buraks.com/asv
package nochump.util.zip {
    import flash.utils.*;

    public class CRC32 {

        private var crc:uint;

        private static var crcTable:Array = makeCrcTable();

        public function getValue():uint{
            return ((this.crc & 4294967295));
        }
        public function reset():void{
            this.crc = 0;
        }
        public function update(buf:ByteArray):void{
            var off:uint;
            var len:uint = buf.length;
            var c:uint = ~(this.crc);
            while (--len >= 0) {
                var _temp1 = off;
                off = (off + 1);
                c = (crcTable[((c ^ buf[_temp1]) & 0xFF)] ^ (c >>> 8));
            };
            this.crc = ~(c);
        }

        private static function makeCrcTable():Array{
            var c:uint;
            var k:int;
            var crcTable:Array = new Array(0x0100);
            var n:int;
            while (n < 0x0100) {
                c = n;
                k = 8;
                while (--k >= 0) {
                    if ((c & 1) != 0){
                        c = (3988292384 ^ (c >>> 1));
                    } else {
                        c = (c >>> 1);
                    };
                };
                crcTable[n] = c;
                n++;
            };
            return (crcTable);
        }

    }
}//package nochump.util.zip 
