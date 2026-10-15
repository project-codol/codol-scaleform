package codo.views.wargod_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.style.WarGodGuide;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   
   public class LeaderBoardRankMeter extends MovieClip
   {
      
      public var myTier:MovieClip;
      
      public var myTierName:TextField;
      
      public var myPromoScore:TextField;
      
      public function LeaderBoardRankMeter()
      {
         super();
         this.myTierName.textStyle = WarGodGuide.styleTierNameInRankMeter;
         this.myTierName.width = 84;
         this.myTierName.height = 27;
         this.myTierName.x = 44;
         this.myTierName.y = 15;
         this.myPromoScore.textStyle = WarGodGuide.stylePromoScoreInRankMeter;
         this.myPromoScore.width = 84;
         this.myPromoScore.height = 27;
         this.myPromoScore.x = 150;
         this.myPromoScore.y = 15;
      }
      
      public function setData(score:int) : void
      {
         var tier:int = 0;
         var division:int = 0;
         var promoScore:int = 0;
         var wargodScoreInfo:Object = CFunctionCommonContainer.AS_GetTierDivisionStarFromScore(score);
         tier = int(wargodScoreInfo.tier);
         division = int(wargodScoreInfo.division);
         promoScore = int(wargodScoreInfo.promotionScore);
         this.myTier.visible = true;
         this.myTier.gotoAndStop(tier + 1);
         this.myTierName.text = WarGodUtility.getTierAndDivisionName(tier,division);
         this.myPromoScore.text = promoScore.toString();
      }
   }
}

