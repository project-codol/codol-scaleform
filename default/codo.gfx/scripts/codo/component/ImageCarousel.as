package codo.component
{
   import codo.objects.CustomObject;
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgImageHolder;
   
   public class ImageCarousel extends MovieClip
   {
      
      private static const SLIDE_DURATION:Number = 0.25;
      
      public var myHitArea:Sprite;
      
      public var myMask:Sprite;
      
      public var myImage0:FsgImageHolder;
      
      public var myImage1:FsgImageHolder;
      
      private var mClickable:BehaviourClickable;
      
      private var mClickCallback:Function;
      
      private var mCurrentIndex:int = 0;
      
      private var mCurrentImageHolder:FsgImageHolder;
      
      private var mEmptyImageHolder:FsgImageHolder;
      
      private var mImages:Array;
      
      public function ImageCarousel()
      {
         super();
         this.mCurrentImageHolder = this.myImage0;
         this.mEmptyImageHolder = this.myImage1;
         this.mClickable = new BehaviourClickable(this.myHitArea);
         this.mClickable.addClickCallback(this.onClick);
      }
      
      public function setData(data:CustomObject) : void
      {
         this.mCurrentIndex = 0;
         this.mImages = data.images;
         this.mCurrentImageHolder.setImage(this.mImages[0]);
         this.mCurrentImageHolder.x = 0;
         this.mEmptyImageHolder.x = -this.mEmptyImageHolder.width;
         if(null != data.clickCallback)
         {
            this.mClickCallback = data.clickCallback;
         }
      }
      
      public function setSize(w:Number, h:Number) : void
      {
         this.myHitArea.width = this.myMask.width = w;
         this.myHitArea.height = this.myMask.height = h;
      }
      
      public function get currentIndex() : int
      {
         return this.mCurrentIndex;
      }
      
      public function set currentIndex(index:int) : void
      {
         if(index > this.mCurrentIndex)
         {
            this.mCurrentIndex = index - 1;
            this.nextImage();
         }
         else if(index < this.mCurrentIndex)
         {
            this.mCurrentIndex = index + 1;
            this.previousImage();
         }
      }
      
      public function nextImage() : void
      {
         ++this.mCurrentIndex;
         if(this.mCurrentIndex > this.mImages.length - 1)
         {
            this.mCurrentIndex = 0;
         }
         this.mEmptyImageHolder.x = this.myHitArea.width + GlobalGuide.COMPONENT_PADDING;
         this.mEmptyImageHolder.setImage(this.mImages[this.mCurrentIndex]);
         TweenLite.to(this.mCurrentImageHolder,SLIDE_DURATION,{"x":-this.mCurrentImageHolder.width - GlobalGuide.COMPONENT_PADDING});
         TweenLite.to(this.mEmptyImageHolder,SLIDE_DURATION,{
            "x":0,
            "onComplete":this.onSlideComplete
         });
      }
      
      public function previousImage() : void
      {
         --this.mCurrentIndex;
         if(this.mCurrentIndex < 0)
         {
            this.mCurrentIndex = this.mImages.length - 1;
         }
         this.mEmptyImageHolder.x = -this.mEmptyImageHolder.width - GlobalGuide.COMPONENT_PADDING;
         this.mEmptyImageHolder.setImage(this.mImages[this.mCurrentIndex]);
         TweenLite.to(this.mCurrentImageHolder,SLIDE_DURATION,{"x":this.myHitArea.width + GlobalGuide.COMPONENT_PADDING});
         TweenLite.to(this.mEmptyImageHolder,SLIDE_DURATION,{
            "x":0,
            "onComplete":this.onSlideComplete
         });
      }
      
      private function onSlideComplete() : void
      {
         var temp:FsgImageHolder = this.mEmptyImageHolder;
         this.mEmptyImageHolder = this.mCurrentImageHolder;
         this.mCurrentImageHolder = temp;
      }
      
      override public function get width() : Number
      {
         return this.myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return this.myHitArea.height;
      }
      
      private function onClick() : void
      {
         if(null != this.mClickCallback)
         {
            this.mClickCallback(this.mCurrentIndex);
         }
      }
   }
}

