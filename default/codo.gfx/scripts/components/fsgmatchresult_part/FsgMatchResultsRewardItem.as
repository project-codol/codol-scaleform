package components.fsgmatchresult_part
{
   import components.fsgpopups_part.FsgPopupBaseFrameAnimated;
   
   public class FsgMatchResultsRewardItem extends FsgMatchResultsUnlockListItem
   {
      
      private static const FRAME_1_SIZE:Number = 248;
      
      private static const FRAME_2_SIZE:Number = 258;
      
      public var myFrame1:FsgPopupBaseFrameAnimated;
      
      public var myFrame2:FsgPopupBaseFrameAnimated;
      
      public function FsgMatchResultsRewardItem()
      {
         super();
         this.myFrame1 = myContainer["myFrame1"];
         this.myFrame2 = myContainer["myFrame2"];
         this.myFrame1.setSize(FRAME_1_SIZE,FRAME_1_SIZE);
         this.myFrame2.setSize(FRAME_2_SIZE,FRAME_2_SIZE);
      }
   }
}

