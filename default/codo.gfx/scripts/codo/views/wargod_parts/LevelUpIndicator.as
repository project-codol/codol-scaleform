package codo.views.wargod_parts
{
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class LevelUpIndicator extends MovieClip implements IWarGodUIElement
   {
      
      public var myCurrentTier:TierMeter;
      
      public var myNextTier:TierMeter;
      
      public var myPromotionScoreMeter:PromotionScoreMeter;
      
      public var mySeniorPromotionScoreMeter:SeniorPromotionScoreMeter;
      
      public var myCurrentTierLabel:TextField;
      
      public var myNextTierLabel:TextField;
      
      public function LevelUpIndicator()
      {
         super();
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var warGodRank:PlayerWarGodRank = null;
         var threshold:int = 0;
         warGodRank = playerObj.warGodRank;
         this.myCurrentTier.setData(warGodRank.tier);
         var tierName:String = WarGodUtility.getTierAndDivisionName(warGodRank.tier,warGodRank.division);
         this.myCurrentTierLabel.text = tierName;
         if(WarGodUtility.isJuniorWarGod(playerObj))
         {
            this.mySeniorPromotionScoreMeter.visible = false;
            this.myPromotionScoreMeter.visible = true;
            threshold = WarGodUtility.getJuniorWarGodPromotionValueByTier(warGodRank.tier,warGodRank.division);
            this.myPromotionScoreMeter.setProgress(playerObj.promotionScore,threshold);
         }
         else
         {
            this.mySeniorPromotionScoreMeter.visible = true;
            this.myPromotionScoreMeter.visible = false;
            threshold = WarGodUtility.getSeniorWargodPromotionValueByTier(warGodRank.tier,warGodRank.division);
            this.mySeniorPromotionScoreMeter.setProgress(playerObj.promotionScore,threshold);
         }
         var nextWarGodRank:PlayerWarGodRank = WarGodUtility.jumpToNextDivision(warGodRank);
         if(Boolean(nextWarGodRank))
         {
            this.myNextTier.setData(nextWarGodRank.tier);
            tierName = WarGodUtility.getTierAndDivisionName(nextWarGodRank.tier,nextWarGodRank.division);
            this.myNextTierLabel.text = tierName;
         }
      }
   }
}

