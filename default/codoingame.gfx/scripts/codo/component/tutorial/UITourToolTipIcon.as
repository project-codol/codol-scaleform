package codo.component.tutorial
{
   import codo.component.Button;
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class UITourToolTipIcon extends Sprite
   {
      
      private static const MOUSE_OVER_ANIM_DURATION:Number = 0.3;
      
      private static const MOUSE_OUT_ANIM_DURATION:Number = 0.2;
      
      private static const DISABLE_ALPHA:Number = 0.7;
      
      public var myIconButton:Button;
      
      public var myBkg:MovieClip;
      
      public var myIcon:Sprite;
      
      private var mGlower:GlowFilter;
      
      private var mPulseGlow:TweenMax;
      
      private var mIsPulsing:Boolean;
      
      private var mIsActive:Boolean;
      
      public function UITourToolTipIcon()
      {
         super();
         this.mGlower = new GlowFilter(GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,0.4,16,16);
         this.myIconButton.registerFocusEvent(this.onMouseOver);
         this.myIconButton.registerUnfocusEvent(this.onMouseOut);
         this.alpha = DISABLE_ALPHA;
         this.mIsActive = true;
      }
      
      public function set clickCallback(callback:Function) : void
      {
         this.myIconButton.registerClickEvent(callback);
      }
      
      public function set isActive(active:Boolean) : void
      {
         if(this.mIsActive == active)
         {
            return;
         }
         this.mIsActive = active;
         this.myIconButton.enabled = active;
         alpha = active ? 1 : DISABLE_ALPHA;
         this.myBkg.gotoAndStop(active ? 1 : 2);
         if(!active)
         {
            this.pulsing = false;
         }
      }
      
      override public function set mouseEnabled(isEnabled:Boolean) : void
      {
         super.mouseEnabled = isEnabled;
         this.myIconButton.enabled = isEnabled;
      }
      
      public function set pulsing(doPulse:Boolean) : void
      {
         if(this.mIsPulsing == doPulse)
         {
            return;
         }
         this.mIsPulsing = doPulse;
         if(doPulse)
         {
            this.alpha = 1;
            this.mPulseGlow = new TweenMax(this.myBkg,0.5,{
               "glowFilter":this.mGlower,
               "yoyo":true,
               "repeat":-1
            });
            this.mPulseGlow.play();
         }
         else
         {
            TweenMax.killTweensOf(this.myBkg);
            this.myBkg.filters = [];
         }
      }
      
      private function onMouseOver() : void
      {
         if(this.mIsPulsing)
         {
            this.mPulseGlow.pause();
         }
         var SCALE_ASPECT:Number = 1.1;
         this.myBkg.filters = [this.mGlower];
         TweenLite.to(this,MOUSE_OVER_ANIM_DURATION,{
            "scaleX":SCALE_ASPECT,
            "scaleY":SCALE_ASPECT,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this.myIcon,MOUSE_OUT_ANIM_DURATION,{
            "scaleX":1.2,
            "scaleY":1.2,
            "ease":Cubic.easeIn,
            "delay":0.1
         });
      }
      
      private function onMouseOut() : void
      {
         if(this.mIsPulsing)
         {
            this.mPulseGlow.play();
         }
         else
         {
            this.myBkg.filters = [];
         }
         TweenLite.to(this,MOUSE_OVER_ANIM_DURATION,{
            "scaleX":1,
            "scaleY":1,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this.myIcon,MOUSE_OVER_ANIM_DURATION,{
            "scaleX":1,
            "scaleY":1,
            "ease":Cubic.easeOut
         });
      }
   }
}

