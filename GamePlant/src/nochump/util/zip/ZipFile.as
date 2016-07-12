//Created by Action Script Viewer - http://www.buraks.com/asv
package nochump.util.zip {
    import flash.utils.*;

    public class ZipFile {

        private var buf:ByteArray;
        private var entryList:Array;
        private var entryTable:Dictionary;
        private var locOffsetTable:Dictionary;

        public function ZipFile(data:IDataInput){
            super();
            this.buf = new ByteArray();
            this.buf.endian = Endian.LITTLE_ENDIAN;
            data.readBytes(this.buf);
            this.readEntries();
        }
        public function get entries():Array{
            return (this.entryList);
        }
        public function get size():uint{
            return (this.entryList.length);
        }
        public function getEntry(name:String):ZipEntry{
            return (this.entryTable[name]);
        }
        public function getInput(entry:ZipEntry):ByteArray{
            var _local4:ByteArray;
            var _local5:Inflater;
            this.buf.position = ((this.locOffsetTable[entry.name] + ZipConstants.LOCHDR) - 2);
            var len:uint = this.buf.readShort();
            this.buf.position = (this.buf.position + (entry.name.length + len));
            var b1:ByteArray = new ByteArray();
            if (entry.compressedSize > 0){
                this.buf.readBytes(b1, 0, entry.compressedSize);
            };
            switch (entry.method){
                case ZipConstants.STORED:
                    return (b1);
                case ZipConstants.DEFLATED:
                    _local4 = new ByteArray();
                    _local5 = new Inflater();
                    _local5.setInput(b1);
                    _local5.inflate(_local4);
                    return (_local4);
                default:
                    throw (new ZipError("invalid compression method"));
            };
        }
        private function readEntries():void{
            var tmpbuf:ByteArray;
            var len:uint;
            var e:ZipEntry;
            this.readEND();
            this.entryTable = new Dictionary();
            this.locOffsetTable = new Dictionary();
            var i:uint;
            while (i < this.entryList.length) {
                tmpbuf = new ByteArray();
                tmpbuf.endian = Endian.LITTLE_ENDIAN;
                this.buf.readBytes(tmpbuf, 0, ZipConstants.CENHDR);
                if (tmpbuf.readUnsignedInt() != ZipConstants.CENSIG){
                    throw (new ZipError("invalid CEN header (bad signature)"));
                };
                tmpbuf.position = ZipConstants.CENNAM;
                len = tmpbuf.readUnsignedShort();
                if (len == 0){
                    throw (new ZipError("missing entry name"));
                };
                e = new ZipEntry(this.buf.readUTFBytes(len));
                len = tmpbuf.readUnsignedShort();
                e.extra = new ByteArray();
                if (len > 0){
                    this.buf.readBytes(e.extra, 0, len);
                };
                this.buf.position = (this.buf.position + tmpbuf.readUnsignedShort());
                tmpbuf.position = ZipConstants.CENVER;
                e.version = tmpbuf.readUnsignedShort();
                e.flag = tmpbuf.readUnsignedShort();
                if ((e.flag & 1) == 1){
                    throw (new ZipError("encrypted ZIP entry not supported"));
                };
                e.method = tmpbuf.readUnsignedShort();
                e.dostime = tmpbuf.readUnsignedInt();
                e.crc = tmpbuf.readUnsignedInt();
                e.compressedSize = tmpbuf.readUnsignedInt();
                e.size = tmpbuf.readUnsignedInt();
                this.entryList[i] = e;
                this.entryTable[e.name] = e;
                tmpbuf.position = ZipConstants.CENOFF;
                this.locOffsetTable[e.name] = tmpbuf.readUnsignedInt();
                i++;
            };
        }
        private function readEND():void{
            var b:ByteArray = new ByteArray();
            b.endian = Endian.LITTLE_ENDIAN;
            this.buf.position = this.findEND();
            this.buf.readBytes(b, 0, ZipConstants.ENDHDR);
            b.position = ZipConstants.ENDTOT;
            this.entryList = new Array(b.readUnsignedShort());
            b.position = ZipConstants.ENDOFF;
            this.buf.position = b.readUnsignedInt();
        }
        private function findEND():uint{
            var i:uint = (this.buf.length - ZipConstants.ENDHDR);
            var n:uint = Math.max(0, (i - 0xFFFF));
            while (i >= n) {
                if (this.buf[i] != 80){
                } else {
                    this.buf.position = i;
                    if (this.buf.readUnsignedInt() == ZipConstants.ENDSIG){
                        return (i);
                    };
                };
                i--;
            };
            throw (new ZipError("invalid zip"));
        }

    }
}//package nochump.util.zip 
