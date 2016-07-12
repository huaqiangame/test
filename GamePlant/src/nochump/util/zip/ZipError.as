//Created by Action Script Viewer - http://www.buraks.com/asv
package nochump.util.zip {
    import flash.errors.*;

    public class ZipError extends IOError {

        public function ZipError(message:String="", id:int=0){
            super(message, id);
        }
    }
}//package nochump.util.zip 
