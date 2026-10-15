package codo.views.hudDMZ
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class AnimatedArmorBar extends MovieClip
   {
      
      private static const ANIM_DURATION:Number = 0.5;
      
      public var myMask:MovieClip;
      
      public var myFill:MovieClip;
      
      private var mArmor:Number;
      
      private var mTween:TweenLite;
      
      public function AnimatedArmorBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.setArmor(1,false);
      }
      
      private function onAnimationComplete() : void
      {
         this.myFill.gotoAndStop(1);
      }
      
      public function setArmor(armor:Number, animate:Boolean) : void
      {
         if(armor == this.mArmor)
         {
            return;
         }
         if(this.mTween != null && this.mTween.active)
         {
            this.mTween.complete();
         }
         if(!animate)
         {
            this.setProgress(armor);
         }
         else
         {
            if(this.mArmor > armor)
            {
               this.myFill.gotoAndStop(2);
            }
            this.mTween = new TweenLite(this.myMask,ANIM_DURATION,{
               "width":armor * this.myFill.width,
               "onComplete":this.onAnimationComplete
            });
         }
         this.mArmor = armor;
      }
      
      private function setProgress(progress:Number) : void
      {
         this.myMask.width = progress * this.myFill.width;
      }
   }
}

