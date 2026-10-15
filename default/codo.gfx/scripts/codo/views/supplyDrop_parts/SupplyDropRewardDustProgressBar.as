package codo.views.supplyDrop_parts
{
   import codo.component.TextField;
   import codo.style.SupplyDropGuide;
   import codo.utils.SoundUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SupplyDropRewardDustProgressBar extends MovieClip
   {
      
      public var myProgressTF:TextField;
      
      public var myTotalProgressTF:TextField;
      
      public var myGlowProgressTF:TextField;
      
      public var myProgress:MovieClip;
      
      public var myBackground:Sprite;
      
      private var mDusts:int;
      
      private var mDisplayDusts:int;
      
      private var mExchangeRatio:int;
      
      private var mTweenLite:TweenLite;
      
      private var mGlowTimes:int;
      
      public function SupplyDropRewardDustProgressBar()
      {
         super();
         this.mDusts = 0;
         this.mDisplayDusts = 0;
         this.mExchangeRatio = 0;
         this.mGlowTimes = 0;
         this.myProgressTF.textStyle = SupplyDropGuide.styleSupplyDropDustProgress;
         this.myTotalProgressTF.textStyle = SupplyDropGuide.styleSupplyDropDustTotalProgress;
         this.myGlowProgressTF.textStyle = SupplyDropGuide.styleSupplyDropDustGlowProgress;
      }
      
      public function set exchangeRatio(val:int) : void
      {
         this.mExchangeRatio = val;
      }
      
      public function set dusts(val:Number) : void
      {
         this.mDusts = val;
      }
      
      public function setDisplayDusts(val:Number) : void
      {
         var offset:Number = NaN;
         this.mDisplayDusts = val;
         if(val != 0)
         {
            offset = this.mDisplayDusts - this.mExchangeRatio;
            if(offset > 0)
            {
               offset = 0;
            }
            this.myProgress.x = this.myBackground.x + this.myBackground.width * offset / this.mExchangeRatio;
         }
         else
         {
            this.myProgress.x = -1200;
         }
         this.myTotalProgressTF.text = "/" + this.mExchangeRatio;
         if(val >= 100)
         {
            this.myProgressTF.visible = false;
            this.myGlowProgressTF.visible = true;
            this.myGlowProgressTF.text = this.mDisplayDusts.toString();
         }
         else
         {
            this.myProgressTF.visible = true;
            this.myGlowProgressTF.visible = false;
            this.myProgressTF.text = this.mDisplayDusts.toString();
         }
      }
      
      public function stopAnimation() : void
      {
         TweenLite.killTweensOf(this.myProgress);
      }
      
      public function get dusts() : Number
      {
         return this.mDusts;
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      public function animateToDusts(val:Number, duration:Number, delay:Number, onComplete:Function) : void
      {
         this.mDisplayDusts = this.mDusts;
         this.mDusts = val;
         this.mGlowTimes = 0;
         if(onComplete == null)
         {
            this.mTweenLite = TweenLite.to(this.myProgress,duration,{
               "delay":delay,
               "onUpdate":this.onAnimationUpdate,
               "onUpdateParams":[this.mDisplayDusts]
            });
         }
         else
         {
            this.mTweenLite = TweenLite.to(this.myProgress,duration,{
               "delay":delay,
               "onUpdate":this.onAnimationUpdate,
               "onUpdateParams":[this.mDisplayDusts],
               "onComplete":onComplete
            });
         }
      }
      
      private function onAnimationUpdate(oldDisplayValue:int) : void
      {
         if(this.mTweenLite == null)
         {
            return;
         }
         var newDisplayValue:int = oldDisplayValue * (this.mTweenLite.totalDuration - this.mTweenLite.currentTime) / this.mTweenLite.totalDuration + this.mDusts * this.mTweenLite.currentTime / this.mTweenLite.totalDuration;
         if(newDisplayValue != this.mDisplayDusts)
         {
            SoundUtil.getInstance().playSound("UI_Supply_counter");
         }
         this.setDisplayDusts(newDisplayValue);
      }
      
      public function killAllTweens() : void
      {
         TweenLite.killTweensOf(this.myProgress);
      }
   }
}

