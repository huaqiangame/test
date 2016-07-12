//Created by Action Script Viewer - http://www.buraks.com/asv
package thirdparty.sound {
    import __AS3__.vec.*;
    import flash.media.*;
    import com.greensock.*;
    import flash.events.*;

    public class GameSound extends EventDispatcher {

        private var sound:Sound;
        private var name:String;
        private var volume:Number;
        private var loops:int;
        private var enabled:Boolean;
        private var offset:Number;
        private var pan:Number;
        private var pausedOffset:Number;
        private var soundChannel:SoundChannel;
        private var muteSoundTransform:SoundTransform;
        private var _parallelSounds:Vector.<GameSound>;
        private var _state:int;// = 0
        private var _prevState:int;// = 0
        private var _mutePrevState:int;

        public static const STOPPED:int = 0;
        public static const PLAYING:int = 1;
        public static const PAUSED:int = 2;

        public function GameSound(name:String, sound:Sound, volume:Number, loops:int, enabled:Boolean, pan:Number=0, offset:Number=0){
            super();
            this.name = name;
            this.sound = sound;
            this.volume = volume;
            this.loops = ((loops)<0) ? int.MAX_VALUE : loops;
            this.enabled = enabled;
            this.offset = offset;
            this.pan = pan;
            this._parallelSounds = new Vector.<GameSound>();
            this.muteSoundTransform = new SoundTransform();
            this.previousState = STOPPED;
            this.currentState = STOPPED;
        }
        public function playInParallel(sound:GameSound, fadeIn:Boolean=false):void{
            this._parallelSounds.push(sound);
            sound.Play(fadeIn);
        }
        public function Play(fadeIn:Boolean):void{
            var transform:SoundTransform;
            if (this.enabled){
                if (this.currentState == STOPPED){
                    this.soundChannel = this.CurrentSound.play(this.Offset, this.Loops);
                    transform = this.soundChannel.soundTransform;
                    if (fadeIn){
                        this.doFadeIn(this.soundChannel, this.volume, transform, this.pan);
                    } else {
                        transform.volume = this.volume;
                        transform.pan = this.pan;
                        this.soundChannel.soundTransform = transform;
                    };
                    this.checkForLoop(this.Loops);
                    this.previousState = STOPPED;
                    this.currentState = PLAYING;
                } else {
                    if (this.currentState == PAUSED){
                        this.Resume();
                    };
                };
            };
        }
        public function mute(fadeOut:Boolean=false):void{
            this._mutePrevState = this.currentState;
            this.Pause(fadeOut);
            this.enabled = false;
        }
        public function unMute(fadeIn:Boolean=false):void{
            this.enabled = true;
            if (this._mutePrevState == PLAYING){
                this.Play(fadeIn);
            };
        }
        public function changeVolume(volume:Number, fade:Boolean=false, fadeOutSeconds:int=10):void{
            var auxVolume:Number;
            var transform:SoundTransform;
            if (this.volume < volume){
                auxVolume = (volume - this.volume);
                this.volume = (this.volume + auxVolume);
            } else {
                auxVolume = (this.volume - volume);
                this.volume = (this.volume - auxVolume);
            };
            if (this.volume > 1){
                this.volume = 1;
            };
            if (this.volume < 0){
                this.volume = 0;
            };
            if (this.soundChannel != null){
                if (!(fade)){
                    transform = this.soundChannel.soundTransform;
                    transform.volume = this.volume;
                    this.soundChannel.soundTransform = transform;
                } else {
                    TweenLite.to(this.soundChannel, fadeOutSeconds, {volume:this.volume});
                };
            };
        }
        public function Pause(fadeOut:Boolean):void{
            if (this.currentState == PLAYING){
                if (this.soundChannel != null){
                    this.pausedOffset = this.soundChannel.position;
                    this.Stop(fadeOut);
                    this.previousState = PLAYING;
                    this.currentState = PAUSED;
                };
            };
        }
        public function Resume():void{
            var transform:SoundTransform;
            if (this.currentState == PAUSED){
                if (this.sound != null){
                    this.soundChannel = this.CurrentSound.play(this.pausedOffset, this.Loops);
                    transform = this.soundChannel.soundTransform;
                    transform.volume = this.volume;
                    this.soundChannel.soundTransform = transform;
                    this.checkForLoop(this.Loops);
                    this.previousState = PAUSED;
                    this.currentState = PLAYING;
                };
            };
        }
        public function Stop(fadeOut:Boolean, fadeOutSeconds:int=10):void{
            this.stopParallelSounds(fadeOut);
            if (this.soundChannel != null){
                if (fadeOut){
                    this.doFadeOut(this.soundChannel, fadeOutSeconds);
                } else {
                    this.reallyStopSound();
                };
                this.previousState = PLAYING;
                this.currentState = STOPPED;
            };
        }
        public function get Name():String{
            return (this.name);
        }
        public function get CurrentSound():Sound{
            return (this.sound);
        }
        public function get Volume():Number{
            return (this.volume);
        }
        public function get Loops():int{
            return (this.loops);
        }
        public function get Enabled():Boolean{
            return (this.enabled);
        }
        public function get Offset():Number{
            return (this.offset);
        }
        public function set Offset(value:Number):void{
            this.offset = value;
        }
        public function get Playing():Boolean{
            return ((this.currentState == PLAYING));
        }
        public function get currentState():int{
            return (this._state);
        }
        public function set currentState(value:int):void{
            this._state = value;
        }
        public function get previousState():int{
            return (this._prevState);
        }
        public function set previousState(value:int):void{
            this._prevState = value;
        }
        private function doFadeIn(soundChannel:SoundChannel, volume:Number, transform:SoundTransform, pan:Number):void{
            transform.volume = 0;
            transform.pan = pan;
            soundChannel.soundTransform = transform;
            TweenLite.to(soundChannel, 2, {volume:volume});
        }
        private function doFadeOut(soundChannel:SoundChannel, fadeOutSeconds:int=10):void{
            TweenLite.to(soundChannel, fadeOutSeconds, {volume:0, onComplete:this.reallyStopSound});
        }
        private function reallyStopSound():void{
            if (this.soundChannel){
                this.soundChannel.stop();
                this.removeListeners();
                this.soundChannel = null;
            };
        }
        private function stopParallelSounds(fadeOut:Boolean=false):void{
            var tempS:GameSound;
            if (this._parallelSounds.length > 0){
                tempS = this._parallelSounds.pop();
                tempS.Stop(fadeOut);
                this.stopParallelSounds(fadeOut);
            };
        }
        private function removeListeners():void{
            if (((!((this.soundChannel == null))) && (this.soundChannel.hasEventListener(Event.SOUND_COMPLETE)))){
                this.soundChannel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundTrackComplete);
            };
        }
        private function checkForLoop(loops:int):void{
            if (this.soundChannel != null){
                this.soundChannel.addEventListener(Event.SOUND_COMPLETE, this.onSoundTrackComplete);
            };
        }
        private function onSoundTrackComplete(e:Event):void{
            dispatchEvent(new Event(Event.SOUND_COMPLETE));
            if (this.currentState == PLAYING){
                this.Stop(false);
                if (this.loops < 0){
                    this.Play(false);
                };
            };
        }

    }
}//package thirdparty.sound 
