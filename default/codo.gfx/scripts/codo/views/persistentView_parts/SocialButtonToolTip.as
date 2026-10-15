package codo.views.persistentView_parts
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class SocialButtonToolTip extends MovieClip
   {
      
      private static const ANIMATION_DURATION:Number = 0.2;
      
      private static const ANIMATION_HIDE_X:Number = 13;
      
      private static const ANIMATION_SHOW_X:Number = 65;
      
      private static const ANIMATION_SHOW_ALPHA:Number = 1;
      
      private static const ANIMATION_HIDE_ALPHA:Number = 0;
      
      private static const TEXT_PADDING:int = 7;
      
      public var myText:TextField;
      
      public var myBg:MovieClip;
      
      private var mPendingAnimation:CallWrapper;
      
      private var mAnimation:TweenLite;
      
      public function SocialButtonToolTip()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mPendingAnimation = new CallWrapper();
         this.myText.autoSize = TextFieldAutoSize.LEFT;
         x = ANIMATION_HIDE_X;
         visible = false;
      }
      
      public function showSocialToolTip(text:String, targetY:Number) : void
      {
         if(!this.checkDoable())
         {
            this.bookAnimation(CallWrapper.SHOW,text,targetY);
            return;
         }
         this.doShowAnimation(text,targetY);
      }
      
      public function hideSocialToolTip() : void
      {
         if(!this.checkDoable())
         {
            this.bookAnimation(CallWrapper.HIDE);
            return;
         }
         this.doHideAnimation();
      }
      
      private function checkDoable() : Boolean
      {
         return this.mAnimation == null;
      }
      
      private function bookAnimation(type:int, text:String = "", targetY:Number = 0) : void
      {
         this.mPendingAnimation.valid = true;
         this.mPendingAnimation.type = type;
         this.mPendingAnimation.text = text;
         this.mPendingAnimation.y = targetY;
      }
      
      private function doShowAnimation(text:String, targetY:Number) : void
      {
         this.myText.text = text;
         var targetWidth:Number = this.myText.x + this.myText.textWidth + TEXT_PADDING;
         TweenLite.to(this.myBg,ANIMATION_DURATION,{"width":targetWidth});
         if(!visible)
         {
            visible = true;
            y = targetY;
            alpha = ANIMATION_HIDE_ALPHA;
            x = ANIMATION_HIDE_X;
            this.mAnimation = TweenLite.to(this,ANIMATION_DURATION,{
               "alpha":ANIMATION_SHOW_ALPHA,
               "x":ANIMATION_SHOW_X,
               "onComplete":this.onShowAnimationComplete
            });
         }
         else if(y != targetY)
         {
            this.mAnimation = TweenLite.to(this,ANIMATION_DURATION,{
               "y":targetY,
               "onComplete":this.onShowAnimationComplete
            });
         }
      }
      
      private function onShowAnimationComplete() : void
      {
         this.onAnimationComplete();
      }
      
      private function onAnimationComplete() : void
      {
         this.mAnimation = null;
         if(this.mPendingAnimation.valid)
         {
            if(this.mPendingAnimation.type == CallWrapper.SHOW)
            {
               this.doShowAnimation(this.mPendingAnimation.text,this.mPendingAnimation.y);
            }
            else
            {
               this.doHideAnimation();
            }
            this.mPendingAnimation.valid = false;
         }
      }
      
      private function doHideAnimation() : void
      {
         this.mAnimation = TweenLite.to(this,ANIMATION_DURATION,{
            "alpha":ANIMATION_HIDE_ALPHA,
            "x":ANIMATION_HIDE_X,
            "onComplete":this.onHideAnimationComplete
         });
      }
      
      private function onHideAnimationComplete() : void
      {
         visible = false;
         this.onAnimationComplete();
      }
   }
}

class CallWrapper
{
   
   public static const SHOW:int = 0;
   
   public static const HIDE:int = 1;
   
   public var type:int;
   
   public var text:String;
   
   public var y:Number;
   
   public var valid:Boolean = false;
   
   public function CallWrapper()
   {
      super();
   }
}
