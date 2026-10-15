package codo.views.hudDMZ
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class AnimatedHealthBar extends MovieClip
   {
      
      private static const ANIM_DURATION:Number = 0.5;
      
      private static const REGEN_TARGET_OUTLINE_LENGTH:int = 444;
      
      public var myMask:MovieClip;
      
      public var myFill:MovieClip;
      
      public var myRegenTarget:MovieClip;
      
      private var mHealth:Number;
      
      private var mHealthTween:TweenLite;
      
      public function AnimatedHealthBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.setHealth(1,false);
         this.myRegenTarget.visible = false;
      }
      
      private function onAnimationComplete() : void
      {
         this.myFill.gotoAndStop(1);
      }
      
      public function setHealth(health:Number, animate:Boolean) : void
      {
         if(health == this.mHealth)
         {
            return;
         }
         if(this.mHealthTween != null && this.mHealthTween.active)
         {
            this.mHealthTween.complete();
         }
         if(!animate)
         {
            this.setProgress(health);
         }
         else
         {
            if(this.mHealth < health)
            {
               this.myFill.gotoAndStop(3);
            }
            else
            {
               this.myFill.gotoAndStop(2);
            }
            this.mHealthTween = new TweenLite(this.myMask,ANIM_DURATION,{
               "width":health * this.myFill.width,
               "onComplete":this.onAnimationComplete
            });
         }
         this.mHealth = health;
      }
      
      private function setProgress(progress:Number) : void
      {
         this.myMask.width = progress * this.myFill.width;
      }
      
      public function setRegenTarget(target:Number) : void
      {
         if(target == 0)
         {
            this.myRegenTarget.visible = false;
         }
         else
         {
            target = target > 1 ? 1 : target;
            this.myRegenTarget.width = target * REGEN_TARGET_OUTLINE_LENGTH;
            this.myRegenTarget.visible = true;
         }
      }
   }
}

