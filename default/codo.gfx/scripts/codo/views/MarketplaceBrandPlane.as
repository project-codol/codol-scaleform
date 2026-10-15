package codo.views
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class MarketplaceBrandPlane extends MovieClip
   {
      
      private static const DESC_MIN_HEIGHT:Number = 74;
      
      private static const BG_HEIGHT_OFFSET:Number = 12;
      
      private static const DESC_RIGHT_MARGIN:Number = 16;
      
      public var myLabel:TextField;
      
      public var myDescription:TextField;
      
      public var myBrandIcon:FsgImageHolder;
      
      public var myLine:MovieClip;
      
      private var myCallbackOnHeightChanged:Function;
      
      public function MarketplaceBrandPlane()
      {
         super();
         this.myBrandIcon.keepWHRatio = true;
         this.myBrandIcon.addEventListener(Event.COMPLETE,this.onBrandIconLoadComplete);
      }
      
      public function setData(brandObj:Object) : void
      {
         if(brandObj != null)
         {
            this.myLabel.text = brandObj.outline;
            this.myDescription.text = brandObj.desc;
            this.myBrandIcon.setImage(brandObj.icon);
         }
         this.addjustLinePosition();
      }
      
      public function setOnHeightChangedCallback(cb:Function) : void
      {
         this.myCallbackOnHeightChanged = cb;
      }
      
      private function onBrandIconLoadComplete(event:Event) : void
      {
         var brandMargin:Number = NaN;
         brandMargin = (this.myBrandIcon.startingWidth - this.myBrandIcon.width) * 0.5;
         this.myBrandIcon.x = this.myLine.width - brandMargin - this.myBrandIcon.width;
         this.myDescription.width = this.myBrandIcon.x - this.myDescription.x + brandMargin - DESC_RIGHT_MARGIN;
         this.myDescription.height = this.myDescription.textHeight + BG_HEIGHT_OFFSET;
         this.addjustLinePosition();
      }
      
      public function addjustLinePosition() : void
      {
         var descHeight:Number = Math.max(this.myDescription.textHeight,DESC_MIN_HEIGHT);
         this.myLine.y = descHeight + this.myDescription.y + BG_HEIGHT_OFFSET;
         if(this.myCallbackOnHeightChanged != null)
         {
            this.myCallbackOnHeightChanged();
         }
      }
   }
}

