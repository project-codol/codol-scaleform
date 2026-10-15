package codo.component
{
   import codo.localization.Dict;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class PrecisionOperationsButton extends Button
   {
      
      private static const ANIMATION_SPEED:Number = 0.2;
      
      public var myMouseOver:Sprite;
      
      public var myTitle:flash.text.TextField;
      
      private var mPrecisionOperationsEnabled:Boolean;
      
      private var mForceHide:Boolean;
      
      private var mPulsing:Boolean = false;
      
      public function PrecisionOperationsButton()
      {
         super();
         this.myTitle.text = Dict.MAIN_MENU_LABEL_PRECISION_OPERATIONS;
         this.myMouseOver.alpha = 0;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.setIsPulseIn(true);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.setIsPulseIn(false);
      }
      
      private function setIsPulseIn(pulseIn:Boolean = true) : void
      {
         if(this.mPulsing)
         {
            return;
         }
         var targetAlpha:Number = pulseIn ? 0.4 : 0;
         var targetScale:Number = pulseIn ? 1.1 : 1;
         TweenLite.to(this.myMouseOver,ANIMATION_SPEED,{
            "alpha":targetAlpha,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this,ANIMATION_SPEED,{
            "scaleX":targetScale,
            "scaleY":targetScale,
            "ease":Cubic.easeOut
         });
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         alpha = enabled ? 1 : 0.5;
      }
      
      public function set precisionOperationsEnabled(value:Boolean) : void
      {
         this.mPrecisionOperationsEnabled = value;
         this.refreshVisible();
      }
      
      public function set forceHide(value:Boolean) : void
      {
         this.mForceHide = value;
         this.refreshVisible();
      }
      
      private function refreshVisible() : void
      {
         visible = this.mPrecisionOperationsEnabled && !this.mForceHide;
      }
   }
}

