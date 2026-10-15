package codo.views.hud.playerInfoBar
{
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import components.hud.ProgressBar;
   import flash.display.MovieClip;
   
   public class PlayerInfoHealthBar extends ProgressBar
   {
      
      public var myHealthIncreaseIndicator:MovieClip;
      
      public var myHealthDecreaseIndicator:MovieClip;
      
      public var myHealthIncreaseOverlay:MovieClip;
      
      public var myHealthDecreaseOverlay:MovieClip;
      
      private var mHealthIncreaseIndicatorMask:MovieClip;
      
      private var mHealthDecreaseIndicatorMask:MovieClip;
      
      private var mHealthDecreaseIndicatorStartX:Number;
      
      private var mHealthDecreaseIndicatorWidth:Number;
      
      public function PlayerInfoHealthBar()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         AnimationLength = 1;
         this.mHealthIncreaseIndicatorMask = new MovieClip();
         addChild(this.mHealthIncreaseIndicatorMask);
         this.myHealthIncreaseIndicator.mask = this.mHealthIncreaseIndicatorMask;
         this.mHealthIncreaseIndicatorMask.x = this.myHealthIncreaseIndicator.x;
         this.mHealthIncreaseIndicatorMask.y = this.myHealthIncreaseIndicator.y;
         this.myHealthIncreaseIndicator.visible = false;
         this.mHealthDecreaseIndicatorMask = new MovieClip();
         addChild(this.mHealthDecreaseIndicatorMask);
         this.myHealthDecreaseIndicator.mask = this.mHealthDecreaseIndicatorMask;
         this.mHealthDecreaseIndicatorMask.x = this.myHealthDecreaseIndicator.x;
         this.mHealthDecreaseIndicatorMask.y = this.myHealthDecreaseIndicator.y;
         this.myHealthDecreaseIndicator.visible = false;
         this.myHealthDecreaseOverlay.visible = false;
         this.myHealthIncreaseOverlay.visible = false;
      }
      
      public function onAnimationComplete() : void
      {
         this.myHealthIncreaseIndicator.visible = false;
         this.myHealthDecreaseIndicator.visible = false;
         this.myHealthDecreaseOverlay.visible = false;
         this.myHealthIncreaseOverlay.visible = false;
      }
      
      override protected function doSetProgress(progress:Number, oldProgress:Number, animated:Boolean) : void
      {
         if(!animated)
         {
            myMask.scaleX = progress;
         }
         else if(mProgress > oldProgress)
         {
            this.drawRectMask(this.mHealthIncreaseIndicatorMask,oldProgress * this.myHealthIncreaseIndicator.width,(progress - oldProgress) * this.myHealthIncreaseIndicator.width,this.myHealthIncreaseIndicator.height);
            this.myHealthIncreaseIndicator.visible = true;
            this.myHealthIncreaseOverlay.visible = true;
            this.myHealthIncreaseOverlay.play();
            mTween = new TweenLite(myMask,mAnimDuration,{
               "scaleX":progress,
               "onComplete":this.onAnimationComplete
            });
         }
         else
         {
            this.myHealthDecreaseIndicator.visible = true;
            this.myHealthDecreaseOverlay.visible = true;
            this.myHealthDecreaseOverlay.play();
            myMask.scaleX = progress;
            this.mHealthDecreaseIndicatorStartX = mProgress * this.myHealthDecreaseIndicator.width;
            this.healthDecreaseMaskWidth = (oldProgress - mProgress) * this.myHealthDecreaseIndicator.width;
            mTween = new TweenLite(this,mAnimDuration,{
               "healthDecreaseMaskWidth":progress,
               "onComplete":this.onAnimationComplete
            });
         }
      }
      
      private function drawRectMask(mask:MovieClip, x:Number, width:Number, height:Number) : void
      {
         mask.graphics.clear();
         if(width > 0)
         {
            mask.graphics.beginFill(GlobalGuide.CODO_RED,1);
            mask.graphics.drawRect(x,0,width,height);
            mask.graphics.endFill();
         }
      }
      
      public function get healthDecreaseMaskWidth() : Number
      {
         return this.mHealthDecreaseIndicatorWidth;
      }
      
      public function set healthDecreaseMaskWidth(width:Number) : void
      {
         this.drawRectMask(this.mHealthDecreaseIndicatorMask,this.mHealthDecreaseIndicatorStartX,width,this.myHealthDecreaseIndicator.height);
         this.mHealthDecreaseIndicatorWidth = width;
      }
   }
}

