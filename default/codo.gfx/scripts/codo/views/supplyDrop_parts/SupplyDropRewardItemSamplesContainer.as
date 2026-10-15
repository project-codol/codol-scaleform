package codo.views.supplyDrop_parts
{
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.ProductObj;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SupplyDropRewardItemSamplesContainer extends UIInteractiveComponent
   {
      
      private static const TIMER_DURATION:int = 5000;
      
      private static const FADE_DURATION:Number = 0.25;
      
      private static const ITEM_SCALE_AMOUNT:Number = 0.3;
      
      public var myContainer:SupplyDropRewardItemImageContainer;
      
      private var mItems:Vector.<ProductObj>;
      
      private var mCurrentItemIndex:int;
      
      private var mTimer:Timer;
      
      public function SupplyDropRewardItemSamplesContainer()
      {
         super();
         this.myContainer.registerNewImageLoadedCallback(this.onNewImageLoaded);
      }
      
      override public function getData() : *
      {
         return this.mItems;
      }
      
      override public function setData(data:*) : void
      {
         this.mItems = data as Vector.<ProductObj>;
         this.mCurrentItemIndex = 0;
         this.myContainer.resetData();
         if(this.mItems.length > 0)
         {
            this.myContainer.setData(this.mItems[this.mCurrentItemIndex]);
         }
         this.restartTimer();
      }
      
      public function resetTimer() : void
      {
         if(this.mTimer == null)
         {
            return;
         }
         this.mTimer.reset();
         this.mTimer.removeEventListener(TimerEvent.TIMER,this.updateImage);
         this.mTimer = null;
      }
      
      public function restartTimer() : void
      {
         this.resetTimer();
         if(this.mItems.length > 1)
         {
            this.mTimer = new Timer(TIMER_DURATION);
            this.mTimer.addEventListener(TimerEvent.TIMER,this.updateImage);
            this.mTimer.start();
         }
      }
      
      private function updateImage(e:TimerEvent) : void
      {
         this.mCurrentItemIndex = (this.mCurrentItemIndex + 1) % this.mItems.length;
         var itemScale:Number = this.myContainer.itemScale;
         this.mTimer.stop();
         TweenLite.to(this.myContainer,FADE_DURATION,{
            "alpha":0,
            "scaleX":itemScale + ITEM_SCALE_AMOUNT,
            "scaleY":itemScale + ITEM_SCALE_AMOUNT,
            "colorTransform":{"exposure":2},
            "ease":Cubic.easeIn,
            "onComplete":this.crossFadeImage
         });
      }
      
      private function crossFadeImage() : void
      {
         this.myContainer.setData(this.mItems[this.mCurrentItemIndex]);
      }
      
      private function onNewImageLoaded() : void
      {
         var itemScale:Number = this.myContainer.itemScale;
         TweenLite.to(this.myContainer,FADE_DURATION,{
            "alpha":1,
            "scaleX":itemScale,
            "scaleY":itemScale,
            "colorTransform":{"exposure":1},
            "ease":Cubic.easeOut,
            "onComplete":this.onAnimComplete
         });
      }
      
      private function onAnimComplete() : void
      {
         this.restartTimer();
      }
      
      public function killAllTweens() : void
      {
         TweenLite.killTweensOf(this.myContainer);
      }
   }
}

