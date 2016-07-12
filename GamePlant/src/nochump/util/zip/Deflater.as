//Created by Action Script Viewer - http://www.buraks.com/asv
package nochump.util.zip {
    import flash.utils.*;

    public class Deflater {

        private var buf:ByteArray;
        private var compressed:Boolean;
        private var totalIn:uint;
        private var totalOut:uint;

        public function Deflater(){
            super();
            this.reset();
        }
        public function reset():void{
            this.buf = new ByteArray();
            this.compressed = false;
            this.totalOut = (this.totalIn = 0);
        }
        public function setInput(input:ByteArray):void{
            this.buf.writeBytes(input);
            this.totalIn = this.buf.length;
        }
        public function deflate(output:ByteArray):uint{
            if (!(this.compressed)){
                this.buf.compress();
                this.compressed = true;
            };
            output.writeBytes(this.buf, 2, (this.buf.length - 6));
            this.totalOut = output.length;
            return (0);
        }
        public function getBytesRead():uint{
            return (this.totalIn);
        }
        public function getBytesWritten():uint{
            return (this.totalOut);
        }

    }
}//package nochump.util.zip 
