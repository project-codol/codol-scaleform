package components.hud
{
   import com.greensock.TweenLite;
   
   public class StageProgressBar extends ProgressBar
   {
      
      protected var mStageNum:int = 1;
      
      protected var mCurrentStage:int;
      
      protected var mOnStageChanged:Function;
      
      protected var mMaskFill:Number;
      
      public function StageProgressBar()
      {
         super();
      }
      
      override protected function doSetProgress(progress:Number, oldProgress:Number, animated:Boolean) : void
      {
         if(animated)
         {
            mTween = TweenLite.to(this,AnimationLength,{
               "maskFill":progress,
               "onComplete":this.onAnimateComplete
            });
         }
         else
         {
            this.maskFill = progress;
         }
      }
      
      public function set maskFill(progress:Number) : void
      {
         var nextStage:int = Math.min(Math.round(Math.floor(progress * this.mStageNum)),this.mStageNum - 1);
         if(nextStage != this.mCurrentStage)
         {
            if(this.mOnStageChanged != null)
            {
               this.mOnStageChanged(this.mCurrentStage,nextStage);
            }
            this.mCurrentStage = nextStage;
         }
         myMask.scaleX = progress * this.mStageNum - this.mCurrentStage;
         this.mMaskFill = progress;
      }
      
      public function get maskFill() : Number
      {
         return this.mMaskFill;
      }
      
      public function set OnStageChangedCallback(cb:Function) : void
      {
         this.mOnStageChanged = cb;
      }
      
      public function set StageNumber(num:int) : void
      {
         this.mStageNum = num;
         this.maskFill = mProgress;
      }
      
      public function get StageNumber() : int
      {
         return this.mStageNum;
      }
      
      protected function onAnimateComplete() : void
      {
         mTween = null;
      }
   }
}

