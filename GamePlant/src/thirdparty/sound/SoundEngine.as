//Created by Action Script Viewer - http://www.buraks.com/asv
package thirdparty.sound {
    import flash.media.*;
    import __AS3__.vec.*;
    import flash.events.*;

    public class SoundEngine {

        private var _sounds:Array;
        private var soundChannels:Array;
        private var soundMute:Boolean;// = false
        private var tempSoundTransform:SoundTransform;
        private var muteSoundTransform:SoundTransform;
        private var tempSound:Sound;
        private var _queuedSound:Vector.<GameSound>;

        public function SoundEngine(){
            this.tempSoundTransform = new SoundTransform();
            this.muteSoundTransform = new SoundTransform();
            super();
            this._sounds = new Array();
            this._queuedSound = new Vector.<GameSound>();
            this.soundChannels = new Array();
        }
        public function addSound(sound:GameSound):void{
            this._sounds[sound.Name] = sound;
        }
        public function soundCurrentState(soundName:String):int{
            var aGameSound:GameSound = this._sounds[soundName];
            if (aGameSound){
                return (aGameSound.currentState);
            };
            return (GameSound.STOPPED);
        }
        public function soundPreviousState(soundName:String):int{
            var aGameSound:GameSound = this._sounds[soundName];
            if (aGameSound){
                return (aGameSound.previousState);
            };
            return (GameSound.STOPPED);
        }
        public function addSoundCompleteListener(soundName:String, callback:Function):void{
            var aGameSound:GameSound = this._sounds[soundName];
            if (aGameSound){
                aGameSound.addEventListener(Event.SOUND_COMPLETE, callback, false, 0, true);
            };
        }
        public function playSound(soundName:String, playInParallel:Boolean=false, queued:Boolean=false, fadeIn:Boolean=false):void{
            var aGameSound:GameSound;
            var auxGameSound:GameSound;
            var soundName = soundName;
            var playInParallel = playInParallel;
            var queued = queued;
            var fadeIn = fadeIn;
            aGameSound = (this._sounds[soundName] as GameSound);
            if (aGameSound != null){
                if (playInParallel){
                    auxGameSound = new GameSound(aGameSound.Name, aGameSound.CurrentSound, aGameSound.Volume, aGameSound.Loops, aGameSound.Enabled);
                    aGameSound.playInParallel(auxGameSound, fadeIn);
                } else {
                    if (queued){
                        aGameSound.addEventListener(Event.SOUND_COMPLETE, this.onQueuedSoundComplete);
                        if (this._queuedSound.length == 0){
                            this._queuedSound.push(aGameSound);
                            aGameSound.Play(fadeIn);
                        } else {
                            this._queuedSound.push(aGameSound);
                        };
                    } else {
                        aGameSound.Play(fadeIn);
                    };
                };
            };
            //unresolved jump
            var _slot1 = ex;
            trace(_slot1.message);
        }
        public function changeVolume(volume:Number, soundName:String, fade:Boolean=false):void{
            (this._sounds[soundName] as GameSound).changeVolume(volume, fade);
        }
        public function pauseSound(soundName:String, fadeOut:Boolean=false):void{
            var aGameSound:GameSound = (this._sounds[soundName] as GameSound);
            if (aGameSound != null){
                aGameSound.Pause(fadeOut);
            };
        }
        public function stopSound(soundName:String, fadeOut:Boolean=false, fadeOutSeconds:Number=10):void{
            var aGameSound:GameSound = (this._sounds[soundName] as GameSound);
            if (aGameSound != null){
                aGameSound.Stop(fadeOut, fadeOutSeconds);
            };
        }
        public function stopAllSounds(fadeOut:Boolean=false, fadeOutSeconds:int=10):void{
            var s:GameSound;
            for each (s in this._sounds) {
                s.Stop(fadeOut, fadeOutSeconds);
            };
        }
        public function muteSound(soundName:String):void{
            (this._sounds[soundName] as GameSound).mute();
        }
        public function unMuteSound(soundName:String):void{
            (this._sounds[soundName] as GameSound).unMute();
        }
        public function mute(on:Boolean):void{
            var name:String;
            for (name in this._sounds) {
                if (on){
                    (this._sounds[name] as GameSound).mute();
                } else {
                    (this._sounds[name] as GameSound).unMute();
                };
            };
        }
        private function onQueuedSoundComplete(e:Event):void{
            var auxGameS:GameSound;
            var aGameSound:GameSound = (e.target as GameSound);
            if (aGameSound){
                aGameSound.removeEventListener(Event.SOUND_COMPLETE, this.onQueuedSoundComplete);
            };
            do  {
                auxGameS = this._queuedSound.shift();
            } while (auxGameS == aGameSound);
            aGameSound = auxGameS;
            if (aGameSound){
                aGameSound.addEventListener(Event.SOUND_COMPLETE, this.onQueuedSoundComplete, false, 0, true);
                aGameSound.Play(false);
            };
        }

    }
}//package thirdparty.sound 
