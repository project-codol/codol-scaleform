package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.marketplaceitem.parts.IconLock;
   import codo.cpp.UiCppOnboarding;
   import codo.localization.Dict;
   import codo.style.GlobalGuide;
   import codo.utils.StringUtil;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class SupplyDropCounterButton extends Button
   {
      
      private static const ANIMATION_SPEED:Number = 0.2;
      
      public var myBarMask:Sprite;
      
      public var myMouseOver:Sprite;
      
      public var myQuantityBkg:MovieClip;
      
      public var myQuantityTF:flash.text.TextField;
      
      public var myTitle:flash.text.TextField;
      
      public var myBkg:MovieClip;
      
      public var myLock:IconLock;
      
      private var mSupplyDropsEnabled:Boolean;
      
      private var mForceHide:Boolean;
      
      private var mPulsing:Boolean = false;
      
      private var mCount:int = -1;
      
      public function SupplyDropCounterButton()
      {
         super();
         this.myBarMask.scaleX = 0;
         this.myMouseOver.alpha = 0;
         this.myBkg.gotoAndStop(2);
         this.myQuantityBkg.gotoAndStop(2);
         this.myQuantityTF.textColor = GlobalGuide.CODO_BLACK;
         this.myQuantityBkg.visible = this.myQuantityTF.visible = false;
         this.myTitle.text = Dict.MAIN_MENU_LABEL_SUPPLY_DROPS;
         this.myBarMask.scaleX = CFunctionContainer.AS_GetSupplyDropRewardProgress();
         if(this.myLock != null)
         {
            this.myLock.visible = false;
         }
      }
      
      public function update(count:int) : void
      {
         var oldCount:uint = 0;
         if(this.mCount != count)
         {
            oldCount = uint(this.mCount);
            this.mCount = count;
            if(count > 99)
            {
               this.myQuantityTF.text = "99+";
               this.myQuantityBkg.width = 30;
            }
            else
            {
               this.myQuantityTF.text = StringUtil.addZero(count);
               this.myQuantityBkg.width = 23;
            }
            if(count > 0)
            {
               this.myQuantityBkg.visible = this.myQuantityTF.visible = true;
               if(this.mCount > oldCount && oldCount != -1 && (!this.myLock || !this.myLock.visible))
               {
                  TweenLite.to(this,ANIMATION_SPEED,{
                     "scaleX":1.1,
                     "scaleY":1.1,
                     "ease":Back.easeOut,
                     "overwrite":1,
                     "onStart":this.updatePulseStart,
                     "onComplete":this.updatePulse,
                     "delay":0.2
                  });
               }
            }
            else
            {
               this.myQuantityBkg.visible = this.myQuantityTF.visible = false;
            }
         }
      }
      
      public function setLockLevel(level:String) : void
      {
         if(this.myLock != null)
         {
            this.myLock.visible = true;
            this.myLock.setLockLevel(level);
         }
         gotoAndStop(3);
         this.myQuantityBkg.gotoAndStop(1);
         mClickable.setEnabled(false);
         myHitArea.visible = false;
         this.myTitle.text = Dict.MAIN_MENU_LABEL_SUPPLY_DROPS;
      }
      
      private function updatePulseStart() : void
      {
         this.mPulsing = true;
         gotoAndStop(2);
         this.setIsPulseIn();
         TweenMax.to(this.myMouseOver,ANIMATION_SPEED,{
            "alpha":1,
            "colorMatrixFilter":{
               "colorize":GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,
               "amount":1,
               "brightness":2
            },
            "ease":Cubic.easeOut
         });
      }
      
      private function updatePulse() : void
      {
         TweenLite.to(this,ANIMATION_SPEED,{
            "scaleX":1,
            "scaleY":1,
            "ease":Back.easeIn,
            "overwrite":1,
            "onComplete":this.updatePulseComplete,
            "delay":0.2
         });
      }
      
      private function updatePulseComplete() : void
      {
         gotoAndStop(1);
         TweenMax.to(this.myMouseOver,ANIMATION_SPEED,{
            "alpha":0,
            "colorMatrixFilter":{
               "colorize":GlobalGuide.WHITE,
               "amount":0
            },
            "ease":Cubic.easeOut
         });
         this.setIsPulseIn(false);
         this.mPulsing = false;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.setIsPulseIn();
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
         var targetAlpha:Number = pulseIn ? 0.7 : 0;
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
      
      public function set supplyDropsEnabled(value:Boolean) : void
      {
         this.mSupplyDropsEnabled = value;
         this.refreshVisible();
         var level:String = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_SUPPLY_DROPS);
         if(level != null)
         {
            this.setLockLevel(level);
         }
      }
      
      public function set forceHide(value:Boolean) : void
      {
         this.mForceHide = value;
         this.refreshVisible();
      }
      
      private function refreshVisible() : void
      {
         visible = this.mSupplyDropsEnabled && !this.mForceHide;
      }
   }
}

