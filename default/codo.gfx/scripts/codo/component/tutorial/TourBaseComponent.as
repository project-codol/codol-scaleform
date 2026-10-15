package codo.component.tutorial
{
   import codo.base.BaseSubElement;
   import com.greensock.TimelineLite;
   
   public class TourBaseComponent extends BaseSubElement
   {
      
      protected var mTransitionTimeline:TimelineLite;
      
      private var mAnimationStartCallback:Function;
      
      private var mAnimationCompleteCallback:Function;
      
      public function TourBaseComponent()
      {
         super();
         mouseEnabled = mouseChildren = false;
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.mAnimationCompleteCallback = this.mAnimationStartCallback = null;
         this.mTransitionTimeline = null;
         this.reset();
      }
      
      public function set animationStartCallback(callback:Function) : void
      {
         this.mAnimationStartCallback = callback;
      }
      
      public function set animationCompleteCallback(callback:Function) : void
      {
         this.mAnimationCompleteCallback = callback;
      }
      
      protected function onAnimationStart() : void
      {
         if(this.mAnimationStartCallback != null)
         {
            this.mAnimationStartCallback();
         }
         this.mAnimationStartCallback = null;
      }
      
      protected function onAnimationComplete() : void
      {
         this.mTransitionTimeline = null;
         if(this.mAnimationCompleteCallback != null)
         {
            this.mAnimationCompleteCallback();
         }
         this.mAnimationCompleteCallback = null;
      }
      
      public function reset() : void
      {
      }
   }
}

