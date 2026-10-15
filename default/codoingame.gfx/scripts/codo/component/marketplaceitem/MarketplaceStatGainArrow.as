package codo.component.marketplaceitem
{
   import flash.display.MovieClip;
   
   public class MarketplaceStatGainArrow extends MovieClip
   {
      
      private static const GREAT_GAIN_THRESHOLD:Number = 0.2;
      
      private static const POSITIVE_BASE_FRAME:Number = 1;
      
      private static const NEGATIVE_BASE_FRAME:Number = 3;
      
      public function MarketplaceStatGainArrow()
      {
         super();
      }
      
      public function setData(baseValue:Number, diffValue:Number) : void
      {
         var targetFrame:int = 0;
         visible = diffValue != 0;
         if(visible)
         {
            targetFrame = this.getArrowFrame(baseValue,diffValue);
            gotoAndStop(targetFrame);
         }
      }
      
      private function getArrowFrame(baseValue:Number, diffValue:Number) : Number
      {
         var frame:Number = diffValue > 0 ? POSITIVE_BASE_FRAME : NEGATIVE_BASE_FRAME;
         if(Math.abs(diffValue) > GREAT_GAIN_THRESHOLD * baseValue)
         {
            return frame + 1;
         }
         return frame;
      }
   }
}

