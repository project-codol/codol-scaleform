package codo.views.hud.pveWeaponEnergyBar
{
   import com.greensock.TweenLite;
   import components.hud.CircleProgressBar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class WeaponGUEnergyProgressBar extends CircleProgressBar
   {
      
      private static const ICON_FRAME_DISABLED:int = 1;
      
      private static const ICON_FRAME_NORMAL:int = 2;
      
      private static const ICON_FRAME_ACTIVATE:int = 3;
      
      private static const PROGRESS_PER_LIGHT:Number = 1 / 6;
      
      private static const LIGHT_PROGRESS_ADJUST:Number = 0.05 * PROGRESS_PER_LIGHT;
      
      public var myIcon:MovieClip;
      
      public var myActivatedFill:MovieClip;
      
      private var myActivatedMask:MovieClip;
      
      private var mActivatedMaskFill:Number;
      
      private var myLights:Array;
      
      private var mLightOnNum:int;
      
      private var mIsActivated:Boolean;
      
      public function WeaponGUEnergyProgressBar()
      {
         var light:DisplayObject = null;
         super();
         this.myLights = new Array();
         for(var i:int = 0; true; i++)
         {
            light = getChildByName("myLight".concat(i));
            if(light == null)
            {
               break;
            }
            this.myLights.push(light);
         }
         this.setActivated(false);
         this.mActivatedMaskFill = -1;
         this.activatedMaskFill = 0;
      }
      
      override protected function doSetProgress(progress:Number, oldProgress:Number, animated:Boolean) : void
      {
         this.refreshLightsAndIconAppearance(progress);
         if(this.mIsActivated)
         {
            this.myActivatedFill.visible = true;
            if(animated)
            {
               mTween = TweenLite.to(this,AnimationLength,{
                  "activatedMaskFill":progress,
                  "onComplete":this.onAnimateComplete
               });
            }
            else
            {
               this.activatedMaskFill = progress;
            }
            maskFill = (this.mLightOnNum - 1) * PROGRESS_PER_LIGHT;
         }
         else if(animated)
         {
            mTween = TweenLite.to(this,AnimationLength,{
               "maskFill":progress,
               "activatedMaskFill":progress,
               "onComplete":this.onAnimateComplete
            });
         }
         else
         {
            maskFill = progress;
            this.activatedMaskFill = progress;
         }
      }
      
      public function set activatedMaskFill(progress:Number) : void
      {
         this.myActivatedFill.alpha = progress <= 0 ? 0 : 1;
         if(progress == this.activatedMaskFill)
         {
            return;
         }
         this.myActivatedMask = setFillProgressMask(this.myActivatedFill,this.myActivatedMask,progress);
         this.mActivatedMaskFill = progress;
      }
      
      public function get activatedMaskFill() : Number
      {
         return this.mActivatedMaskFill;
      }
      
      public function setActivated(active:Boolean) : void
      {
         this.mIsActivated = active;
         myFill.visible = !this.mIsActivated;
         this.refreshLightsAndIconAppearance(this.activatedMaskFill);
      }
      
      private function refreshLightsAndIconAppearance(progress:Number) : void
      {
         var lightOnFrame:int = 0;
         var i:int = 0;
         var light:MovieClip = null;
         if(this.myLights != null)
         {
            lightOnFrame = this.mIsActivated ? ICON_FRAME_ACTIVATE : ICON_FRAME_NORMAL;
            this.mLightOnNum = progress == 0 ? 0 : int(Math.ceil(progress / PROGRESS_PER_LIGHT + LIGHT_PROGRESS_ADJUST));
            for(i = 0; i < this.myLights.length; i++)
            {
               light = this.myLights[i] as MovieClip;
               light.gotoAndStop(i < this.mLightOnNum ? lightOnFrame : ICON_FRAME_DISABLED);
            }
         }
         if(this.myIcon != null)
         {
            if(this.mIsActivated)
            {
               this.myIcon.gotoAndPlay(ICON_FRAME_ACTIVATE);
            }
            else if(this.mLightOnNum > 1)
            {
               this.myIcon.gotoAndStop(ICON_FRAME_NORMAL);
            }
            else
            {
               this.myIcon.gotoAndStop(ICON_FRAME_DISABLED);
            }
         }
      }
      
      override public function onAnimateComplete() : void
      {
         super.onAnimateComplete();
         this.myActivatedFill.visible = this.mIsActivated;
         this.refreshLightsAndIconAppearance(this.activatedMaskFill);
      }
   }
}

