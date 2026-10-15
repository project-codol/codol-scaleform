package codo.views.supplyDrop_parts
{
   import codo.component.core.UIInteractiveComponent;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class SupplyDropRewardProgressBar extends UIInteractiveComponent
   {
      
      private static const TWEEN_DURATION:int = 1;
      
      public var myProgress:MovieClip;
      
      public var myBackground:MovieClip;
      
      private var mProgress:Number;
      
      private var mTweenLite:TweenLite;
      
      public function SupplyDropRewardProgressBar()
      {
         super();
         this.mProgress = 0;
      }
      
      public function get progress() : Number
      {
         return this.mProgress;
      }
      
      public function set progress(value:Number) : void
      {
         this.mProgress = value;
         this.myProgress.width = 0;
      }
      
      public function playAnimation() : void
      {
         if(this.myBackground == null)
         {
            return;
         }
         TweenLite.killTweensOf(this);
         var width:Number = (this.myBackground.width - 2) * this.mProgress;
         this.mTweenLite = TweenLite.to(this.myProgress,TWEEN_DURATION,{"width":width});
      }
   }
}

