package components.gvoice
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GVoiceChatBarSpeakerVolumeBar extends MovieClip
   {
      
      public var myFill:MovieClip;
      
      protected var mAnimating:Boolean;
      
      protected var mTimer:Timer;
      
      public function GVoiceChatBarSpeakerVolumeBar()
      {
         super();
         this.myFill.width = 0;
         this.mAnimating = false;
      }
      
      public function show() : void
      {
         if(Boolean(this.mTimer))
         {
            this.mTimer.stop();
            this.mTimer = null;
         }
         this.mTimer = new Timer(1);
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.mTimer.start();
      }
      
      public function hide() : void
      {
         if(Boolean(this.mTimer))
         {
            this.mTimer.stop();
            this.mTimer = null;
         }
      }
      
      public function startVoiceAnim() : void
      {
         this.mAnimating = true;
      }
      
      public function stopVoiceAnim() : void
      {
         this.mAnimating = false;
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         var fillWidth:Number = NaN;
         if(this.mAnimating)
         {
            TweenLite.killTweensOf(this.myFill);
            fillWidth = Math.random() * width;
            TweenLite.to(this.myFill,0.48,{"width":fillWidth});
            TweenLite.to(this.myFill,0.48,{
               "width":0,
               "delay":0.5
            });
         }
      }
   }
}

