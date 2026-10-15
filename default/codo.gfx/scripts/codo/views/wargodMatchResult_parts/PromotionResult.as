package codo.views.wargodMatchResult_parts
{
   import codo.localization.DictWarGod;
   import codo.objects.PlayerWarGodRank;
   import flash.display.MovieClip;
   
   public class PromotionResult extends PlacementResult
   {
      
      public var mySuccessText:MovieClip;
      
      public var myFailText:MovieClip;
      
      public function PromotionResult()
      {
         super();
         this.mySuccessText.myTF.text = DictWarGod.WARGOD_PROMOTION_RESULT_SUCCESS;
         this.myFailText.myTF.text = DictWarGod.WARGOD_PROMOTION_RESULT_FAIL;
      }
      
      public function setData(rank:PlayerWarGodRank, isSuccess:Boolean) : void
      {
         myTier.setData(rank.tier);
         if(rank.tier != PlayerWarGodRank.TIER_HEROIC)
         {
            myDivision.setData(true,rank.division);
         }
         else
         {
            myDivision.setData(false,0);
         }
         this.mySuccessText.visible = isSuccess;
         this.myFailText.visible = !isSuccess;
      }
   }
}

