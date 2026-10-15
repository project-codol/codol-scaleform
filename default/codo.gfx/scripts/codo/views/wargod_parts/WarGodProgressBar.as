package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.localization.DictWarGod;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.WarGodGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   
   public class WarGodProgressBar extends MovieClip implements IWarGodUIElement
   {
      
      private static const GAP_S:int = 4;
      
      private static const GAP_M:int = 8;
      
      private static const GAP_L:int = 12;
      
      private static const BM_WIDTH:int = 95;
      
      private static const SM_WIDTH:int = 63;
      
      public var myTextIndicator0:TextField;
      
      public var myTextIndicator1:TextField;
      
      public var myTextIndicator2:TextField;
      
      public var mySM0:MovieClip;
      
      public var mySM1:MovieClip;
      
      public var mySM2:MovieClip;
      
      public var mySM3:MovieClip;
      
      public var mySM4:MovieClip;
      
      public var mySM5:MovieClip;
      
      public var mySM6:MovieClip;
      
      public var mySM7:MovieClip;
      
      public var mySM8:MovieClip;
      
      public var mySM9:MovieClip;
      
      public var myBM0:MovieClip;
      
      public var myBM1:MovieClip;
      
      public var myBM2:MovieClip;
      
      public var myBM3:MovieClip;
      
      public var myBM4:MovieClip;
      
      private var myBigIndicatorGroup:Array;
      
      private var mySmallIndicatorGroup1:Array;
      
      private var mySmallIndicatorGroup2:Array;
      
      public function WarGodProgressBar()
      {
         super();
         this.myTextIndicator0.textStyle = WarGodGuide.styleWarGodProgressTextIndicator;
         this.myTextIndicator1.textStyle = WarGodGuide.styleWarGodProgressTextIndicator;
         this.myTextIndicator2.textStyle = WarGodGuide.styleWarGodProgressTextIndicator;
         this.myTextIndicator0.width = 327;
         this.myTextIndicator0.height = 25;
         this.myTextIndicator0.x = 0;
         this.myTextIndicator0.y = -45;
         this.myTextIndicator1.width = 502;
         this.myTextIndicator1.height = 25;
         this.myTextIndicator1.x = 346;
         this.myTextIndicator1.y = -45;
         this.myTextIndicator2.width = 327;
         this.myTextIndicator2.height = 25;
         this.myTextIndicator2.x = 860;
         this.myTextIndicator2.y = -45;
         this.myBigIndicatorGroup = [this.myBM0,this.myBM1,this.myBM2,this.myBM3,this.myBM4];
         this.mySmallIndicatorGroup1 = [this.mySM0,this.mySM1,this.mySM2,this.mySM3,this.mySM4];
         this.mySmallIndicatorGroup2 = [this.mySM5,this.mySM6,this.mySM7,this.mySM8,this.mySM9];
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         if(playerObj.phase == WarGodPlayerObj.PHASE_PROMOTION)
         {
            this.arrangePromotion(playerObj);
         }
         else
         {
            this.arrangeLayout(playerObj.warGodRank);
         }
      }
      
      private function arrangePromotion(playerObj:WarGodPlayerObj) : void
      {
         var currIndicatorName:String = null;
         var nextRank:PlayerWarGodRank = null;
         var nextIndicatorName:String = null;
         var playerRank:PlayerWarGodRank = playerObj.warGodRank;
         var startPos:Number = 0;
         startPos = 0;
         this.placeMatchIndicators(this.mySmallIndicatorGroup1,startPos,SM_WIDTH,GAP_S);
         this.setMatchIndicatorsFrame(this.mySmallIndicatorGroup1,WarGodGuide.MATCH_INDICATOR_MATCHED_FRAME);
         startPos = startPos + (SM_WIDTH + GAP_S) * (this.mySmallIndicatorGroup1.length - 1) + SM_WIDTH + GAP_L;
         this.placeMatchIndicators(this.myBigIndicatorGroup,startPos,BM_WIDTH,GAP_M);
         this.setMatchIndicatorsByStar(this.myBigIndicatorGroup,playerObj.numPromotionMatchCompleted);
         startPos = startPos + (BM_WIDTH + GAP_M) * (this.myBigIndicatorGroup.length - 1) + BM_WIDTH + GAP_L;
         this.placeMatchIndicators(this.mySmallIndicatorGroup2,startPos,SM_WIDTH,GAP_S);
         this.setMatchIndicatorsFrame(this.mySmallIndicatorGroup2,WarGodGuide.MATCH_INDICATOR_UNMATCH_FRAME);
         currIndicatorName = LocalizeUtil.localize(WarGodUtility.getTierName(playerRank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(playerRank.division));
         this.myTextIndicator0.text = currIndicatorName;
         this.myTextIndicator1.text = DictWarGod.WARGOD_PROMOTION_MATCH;
         nextRank = WarGodUtility.jumpToNextDivision(playerRank);
         nextIndicatorName = LocalizeUtil.localize(WarGodUtility.getTierName(nextRank.tier));
         if(nextRank.tier != PlayerWarGodRank.TIER_HEROIC)
         {
            nextIndicatorName = nextIndicatorName + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(nextRank.division));
         }
         this.myTextIndicator2.text = nextIndicatorName;
      }
      
      private function arrangeLayout(rank:PlayerWarGodRank) : void
      {
         var prevIndicatorName:String = null;
         var currIndicatorName:String = null;
         var nextIndicatorName:String = null;
         var nextNextIndicatorName:String = null;
         var prevRank:PlayerWarGodRank = null;
         var nextRank:PlayerWarGodRank = null;
         var nextNextRank:PlayerWarGodRank = null;
         var startPos:Number = NaN;
         var needPromotionMatch:Boolean = false;
         if(rank.tier == PlayerWarGodRank.TIER_BRONZE && rank.division == PlayerWarGodRank.DIVISION_THREE)
         {
            currIndicatorName = LocalizeUtil.localize(WarGodUtility.getTierName(rank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(rank.division));
            this.myTextIndicator0.text = currIndicatorName;
            nextRank = WarGodUtility.jumpToNextDivision(rank);
            nextIndicatorName = LocalizeUtil.localize(WarGodUtility.getTierName(nextRank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(nextRank.division));
            this.myTextIndicator1.text = nextIndicatorName;
            nextNextRank = WarGodUtility.jumpToNextDivision(nextRank);
            nextNextIndicatorName = LocalizeUtil.localize(WarGodUtility.getTierName(nextNextRank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(nextNextRank.division));
            this.myTextIndicator2.text = nextNextIndicatorName;
            startPos = 0;
            this.placeMatchIndicators(this.myBigIndicatorGroup,startPos,BM_WIDTH,GAP_M);
            this.setMatchIndicatorsByStar(this.myBigIndicatorGroup,rank.star);
            startPos = startPos + (BM_WIDTH + GAP_M) * (this.myBigIndicatorGroup.length - 1) + BM_WIDTH + GAP_L;
            this.placeMatchIndicators(this.mySmallIndicatorGroup1,startPos,SM_WIDTH,GAP_S);
            this.setMatchIndicatorsFrame(this.mySmallIndicatorGroup1,WarGodGuide.MATCH_INDICATOR_UNMATCH_FRAME);
            startPos = startPos + (SM_WIDTH + GAP_S) * (this.mySmallIndicatorGroup1.length - 1) + SM_WIDTH + GAP_L;
            this.placeMatchIndicators(this.mySmallIndicatorGroup2,startPos,SM_WIDTH,GAP_S);
            this.setMatchIndicatorsFrame(this.mySmallIndicatorGroup2,WarGodGuide.MATCH_INDICATOR_UNMATCH_FRAME);
            if(rank.star < PlayerWarGodRank.MAX_STAR_NUM)
            {
               this.setPendingIndicator(this.myBigIndicatorGroup,rank.star);
            }
            else
            {
               this.setPendingIndicator(this.mySmallIndicatorGroup1,0);
            }
         }
         else
         {
            prevRank = WarGodUtility.jumpToPrevDivision(rank);
            prevIndicatorName = LocalizeUtil.localize(WarGodUtility.getTierName(prevRank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(prevRank.division));
            this.myTextIndicator0.text = prevIndicatorName;
            currIndicatorName = LocalizeUtil.localize(WarGodUtility.getTierName(rank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(rank.division));
            this.myTextIndicator1.text = currIndicatorName;
            needPromotionMatch = WarGodUtility.nextDivisionNeedPromotionMatch(rank);
            if(!needPromotionMatch)
            {
               nextRank = WarGodUtility.jumpToNextDivision(rank);
               nextIndicatorName = LocalizeUtil.localize(WarGodUtility.getTierName(nextRank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(nextRank.division));
            }
            else
            {
               nextIndicatorName = DictWarGod.WARGOD_PROMOTION_MATCH;
            }
            this.myTextIndicator2.text = nextIndicatorName;
            startPos = 0;
            this.placeMatchIndicators(this.mySmallIndicatorGroup1,startPos,SM_WIDTH,GAP_S);
            this.setMatchIndicatorsFrame(this.mySmallIndicatorGroup1,WarGodGuide.MATCH_INDICATOR_MATCHED_FRAME);
            startPos = startPos + (SM_WIDTH + GAP_S) * (this.mySmallIndicatorGroup1.length - 1) + SM_WIDTH + GAP_L;
            this.placeMatchIndicators(this.myBigIndicatorGroup,startPos,BM_WIDTH,GAP_M);
            this.setMatchIndicatorsByStar(this.myBigIndicatorGroup,rank.star);
            startPos = startPos + (BM_WIDTH + GAP_M) * (this.myBigIndicatorGroup.length - 1) + BM_WIDTH + GAP_L;
            this.placeMatchIndicators(this.mySmallIndicatorGroup2,startPos,SM_WIDTH,GAP_S);
            this.setMatchIndicatorsFrame(this.mySmallIndicatorGroup2,WarGodGuide.MATCH_INDICATOR_UNMATCH_FRAME);
            if(rank.star < PlayerWarGodRank.MAX_STAR_NUM)
            {
               this.setPendingIndicator(this.myBigIndicatorGroup,rank.star);
            }
            else
            {
               this.setPendingIndicator(this.mySmallIndicatorGroup2,0);
            }
         }
      }
      
      private function placeMatchIndicators(indicators:Array, indicatorStartX:Number, indicatorWidth:Number, indicatorGap:Number) : void
      {
         for(var i:int = 0; i < indicators.length; i++)
         {
            indicators[i].x = indicatorStartX + (indicatorWidth + indicatorGap) * i;
         }
      }
      
      private function setMatchIndicatorsFrame(indicators:Array, frame:int) : void
      {
         for(var i:int = 0; i < indicators.length; i++)
         {
            indicators[i].gotoAndStop(frame);
         }
      }
      
      private function setMatchIndicatorsByStar(indicators:Array, star:int) : void
      {
         var i:int = 0;
         for(i = 0; i < star; i++)
         {
            indicators[i].gotoAndStop(WarGodGuide.MATCH_INDICATOR_MATCHED_FRAME);
         }
         while(i < indicators.length)
         {
            indicators[i].gotoAndStop(WarGodGuide.MATCH_INDICATOR_UNMATCH_FRAME);
            i++;
         }
      }
      
      private function setPendingIndicator(indicators:Array, index:int) : void
      {
         if(index < indicators.length)
         {
            indicators[index].gotoAndStop(WarGodGuide.MATCH_INDICATOR_PENDING_FRAME);
         }
      }
   }
}

