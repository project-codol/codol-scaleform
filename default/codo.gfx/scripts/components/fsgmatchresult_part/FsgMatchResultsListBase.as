package components.fsgmatchresult_part
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import fsg.util.FsgAudioUtil;
   
   public class FsgMatchResultsListBase extends MovieClip
   {
      
      private static const FADE_DURATION:Number = 0.2;
      
      protected var mOnCompleteCallback:Function;
      
      public function FsgMatchResultsListBase()
      {
         super();
      }
      
      public function skipAnimation() : void
      {
      }
      
      public function startAnimation() : void
      {
         FsgAudioUtil.getInstance().playSound("ui_accolades_bonus_open");
      }
      
      public function hideList() : void
      {
         TweenLite.to(this,FADE_DURATION,{
            "alpha":0,
            "onComplete":this.onHideComplete
         });
      }
      
      public function showList() : void
      {
         this.visible = true;
         TweenLite.to(this,FADE_DURATION,{"alpha":1});
      }
      
      public function setOnCompleteCallback(callback:Function) : void
      {
         this.mOnCompleteCallback = callback;
      }
      
      private function onHideComplete() : void
      {
         this.visible = false;
      }
   }
}

