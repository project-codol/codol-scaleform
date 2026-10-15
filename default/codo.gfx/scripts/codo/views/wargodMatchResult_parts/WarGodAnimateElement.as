package codo.views.wargodMatchResult_parts
{
   import flash.display.MovieClip;
   import fsg.util.FsgAudioUtil;
   
   public class WarGodAnimateElement extends MovieClip
   {
      
      private var mCompleteHandler:Function;
      
      private var mPauseHandler:Function;
      
      protected var mSoundEffect:String;
      
      public function WarGodAnimateElement()
      {
         super();
      }
      
      public function startAni() : void
      {
         visible = true;
         if(this.mSoundEffect != null && this.mSoundEffect.length > 0)
         {
            FsgAudioUtil.getInstance().playSound(this.mSoundEffect);
         }
      }
      
      public function stopAni() : void
      {
      }
      
      protected function complete() : void
      {
         if(this.mCompleteHandler != null)
         {
            this.mCompleteHandler(this);
         }
      }
      
      protected function pause() : void
      {
         if(this.mPauseHandler != null)
         {
            this.mPauseHandler(this);
         }
      }
      
      public function registerCompleteHandler(handler:Function) : void
      {
         this.mCompleteHandler = handler;
      }
      
      public function registerPauseHandler(handler:Function) : void
      {
         this.mPauseHandler = handler;
      }
      
      public function setSoundEffect(effect:String) : void
      {
         this.mSoundEffect = effect;
      }
   }
}

