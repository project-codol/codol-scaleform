package components.hud
{
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class ProgressBar extends MovieClip
   {
      
      protected static const ANIMATION_DURATION:Number = 0.5;
      
      public var myBG:MovieClip;
      
      public var myFill:MovieClip;
      
      public var myMask:MovieClip;
      
      protected var mTween:TweenLite;
      
      protected var mProgress:Number;
      
      protected var mAnimDuration:Number;
      
      public function ProgressBar()
      {
         super();
         this.init();
         if(!ScaleformUtil.isScaleform)
         {
            this.SetProgress(0,true);
         }
      }
      
      protected function init() : void
      {
         this.mAnimDuration = ANIMATION_DURATION;
         this.SetProgress(1,false);
      }
      
      public function SetProgress(progress:Number, animated:Boolean) : void
      {
         var oldProgress:Number = this.mProgress;
         if(progress > 1)
         {
            progress = 1;
         }
         if(progress < 0)
         {
            progress = 0;
         }
         if(progress == this.mProgress)
         {
            return;
         }
         this.mProgress = progress;
         if(this.mTween != null && this.mTween.active)
         {
            this.mTween.complete();
         }
         this.doSetProgress(progress,oldProgress,animated);
      }
      
      protected function doSetProgress(progress:Number, oldProgress:Number, animated:Boolean) : void
      {
         if(!animated)
         {
            this.myMask.scaleX = progress;
         }
         else
         {
            this.mTween = new TweenLite(this.myMask,this.mAnimDuration,{"scaleX":progress});
         }
      }
      
      public function get AnimationLength() : Number
      {
         return this.mAnimDuration;
      }
      
      public function set AnimationLength(len:Number) : void
      {
         if(len >= 0)
         {
            this.mAnimDuration = len;
         }
      }
   }
}

