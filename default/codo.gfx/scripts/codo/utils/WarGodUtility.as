package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.DataID;
   import codo.localization.DictWarGod;
   import codo.manager.DataManager;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.PromotionScoreBarParameter;
   import codo.objects.TimeObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.objects.WarGodPendingPhasePlayerObj;
   import codo.objects.WarGodPlayerObj;
   import flash.display.MovieClip;
   
   public class WarGodUtility
   {
      
      public function WarGodUtility()
      {
         super();
      }
      
      public static function getPhaseName(phase:int) : String
      {
         if(phase == WarGodPlayerObj.PHASE_PENDING)
         {
            return DictWarGod.WARGOD_PENDING_MATCH;
         }
         if(phase == WarGodPlayerObj.PHASE_PLACEMENT)
         {
            return DictWarGod.WARGOD_PLACEMENT_MATCH;
         }
         if(phase == WarGodPlayerObj.PHASE_STAR)
         {
            return DictWarGod.WARGOD_NORMAL_MATCH;
         }
         if(phase == WarGodPlayerObj.PHASE_PROMOTION)
         {
            return DictWarGod.WARGOD_PROMOTION_MATCH;
         }
         return "";
      }
      
      public static function getTierAndDivisionName(tier:int, division:int, hasSpace:Boolean = true) : String
      {
         var divisionName:String = null;
         var tierDivisionName:String = null;
         var tierName:String = LocalizeUtil.localize(getTierName(tier));
         if(tier < PlayerWarGodRank.TIER_HEROIC)
         {
            divisionName = LocalizeUtil.localize(getDivisionName(division));
            tierDivisionName = "";
            tierDivisionName = tierName;
            if(hasSpace)
            {
               tierDivisionName += " ";
            }
            return tierDivisionName + divisionName;
         }
         return tierName;
      }
      
      public static function getTierName(tier:int) : String
      {
         var tierNames:Array = [DictWarGod.TIER_J1,DictWarGod.TIER_J2,DictWarGod.TIER_J3,DictWarGod.TIER_J4,DictWarGod.TIER_J5,DictWarGod.TIER_J6,DictWarGod.TIER_BRONZE,DictWarGod.TIER_SILVER,DictWarGod.TIER_GOLD,DictWarGod.TIER_PLATINUM,DictWarGod.TIER_DIAMOND,DictWarGod.TIER_HEROIC];
         return tierNames[tier];
      }
      
      public static function getDivisionName(division:int) : String
      {
         var tierNames:Array = [DictWarGod.DIVISION_THREE,DictWarGod.DIVISION_TWO,DictWarGod.DIVISION_ONE];
         return tierNames[division];
      }
      
      public static function nextDivisionNeedPromotionMatch(rank:PlayerWarGodRank) : Boolean
      {
         var tier:int = rank.tier;
         var division:int = rank.division;
         if(division >= PlayerWarGodRank.MAX_DIVISION_NUM - 1)
         {
            tier++;
            if(tier == PlayerWarGodRank.TIER_DIAMOND || tier == PlayerWarGodRank.TIER_HEROIC)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      public static function incrementStar(rank:PlayerWarGodRank) : PlayerWarGodRank
      {
         var tier:int = rank.tier;
         var division:int = rank.division;
         var star:int = rank.star;
         if(tier == PlayerWarGodRank.TIER_HEROIC)
         {
            star++;
         }
         else if(star == getNumStarForUpgrade(tier))
         {
            if(division == PlayerWarGodRank.DIVISION_ONE)
            {
               tier++;
               division = 0;
               star = 1;
            }
            else
            {
               division++;
               star = 1;
            }
         }
         else
         {
            star++;
         }
         var newRank:PlayerWarGodRank = new PlayerWarGodRank();
         newRank.tier = tier;
         newRank.division = division;
         newRank.star = star;
         newRank.score = CFunctionContainer.AS_GetPlayerScoreByRank(newRank);
         return newRank;
      }
      
      public static function decreamentStar(rank:PlayerWarGodRank) : PlayerWarGodRank
      {
         var tier:int = rank.tier;
         var division:int = rank.division;
         var star:int = rank.star;
         if(star == 0)
         {
            if(tier == PlayerWarGodRank.TIER_HEROIC)
            {
               tier = PlayerWarGodRank.TIER_DIAMOND;
               division = PlayerWarGodRank.DIVISION_ONE;
               star = getNumStarForUpgrade(PlayerWarGodRank.TIER_DIAMOND);
            }
            else if(division == PlayerWarGodRank.DIVISION_THREE)
            {
               tier--;
               division = PlayerWarGodRank.DIVISION_ONE;
               star = getNumStarForUpgrade(tier);
            }
            else
            {
               division--;
               star = getNumStarForUpgrade(tier);
            }
         }
         else
         {
            star--;
         }
         var newRank:PlayerWarGodRank = new PlayerWarGodRank();
         newRank.tier = tier;
         newRank.division = division;
         newRank.star = star;
         newRank.score = CFunctionContainer.AS_GetPlayerScoreByRank(newRank);
         return newRank;
      }
      
      public static function calculateJuniorWarGodDivisionOffset(rank1:PlayerWarGodRank, rank2:PlayerWarGodRank) : int
      {
         if(rank1.tier > PlayerWarGodRank.TIER_JWG6)
         {
            rank1.tier = PlayerWarGodRank.TIER_JWG6;
            rank1.division = PlayerWarGodRank.DIVISION_ONE;
         }
         if(rank2.tier > PlayerWarGodRank.TIER_JWG6)
         {
            rank2.tier = PlayerWarGodRank.TIER_JWG6;
            rank2.division = PlayerWarGodRank.DIVISION_ONE;
         }
         var isRank1Greater:Boolean = false;
         if(rank1.tier > rank2.tier)
         {
            isRank1Greater = true;
         }
         else if(rank1.tier == rank2.tier)
         {
            isRank1Greater = rank1.division > rank2.division;
         }
         var smallerRank:PlayerWarGodRank = isRank1Greater ? rank2 : rank1;
         var greaterRank:PlayerWarGodRank = isRank1Greater ? rank1 : rank2;
         var offset:int = 0;
         while(rank1.tier != rank2.tier || rank1.division != rank2.division)
         {
            smallerRank = increaseJuniorWarGodDivision(smallerRank);
            offset++;
         }
         return isRank1Greater ? int(-1 * offset) : offset;
      }
      
      public static function increaseJuniorWarGodDivision(rank:PlayerWarGodRank) : PlayerWarGodRank
      {
         var tier:int = rank.tier;
         var division:int = rank.division;
         if(division == PlayerWarGodRank.DIVISION_ONE)
         {
            tier++;
            division = 0;
         }
         else
         {
            division++;
         }
         var newRank:PlayerWarGodRank = new PlayerWarGodRank();
         newRank.tier = tier;
         newRank.division = division;
         return newRank;
      }
      
      public static function decreaseJuniorWarGodDivision(rank:PlayerWarGodRank) : PlayerWarGodRank
      {
         var tier:int = rank.tier;
         var division:int = rank.division;
         if(division == PlayerWarGodRank.DIVISION_THREE)
         {
            tier--;
            division = PlayerWarGodRank.DIVISION_ONE;
         }
         else
         {
            division--;
         }
         var newRank:PlayerWarGodRank = new PlayerWarGodRank();
         newRank.tier = tier;
         newRank.division = division;
         return newRank;
      }
      
      public static function increaseSeniorWarGodDivision(rank:PlayerWarGodRank) : PlayerWarGodRank
      {
         var newRank:PlayerWarGodRank = null;
         var tier:int = rank.tier;
         var division:int = rank.division;
         if(tier != PlayerWarGodRank.TIER_HEROIC)
         {
            if(division == PlayerWarGodRank.DIVISION_ONE)
            {
               tier++;
               division = PlayerWarGodRank.DIVISION_THREE;
            }
            else
            {
               division++;
            }
            newRank = new PlayerWarGodRank();
            newRank.tier = tier;
            newRank.division = division;
            return newRank;
         }
         return rank;
      }
      
      public static function decreaseSeniorWarGodDivision(rank:PlayerWarGodRank) : PlayerWarGodRank
      {
         var newRank:PlayerWarGodRank = null;
         var tier:int = rank.tier;
         var division:int = rank.division;
         if(tier != PlayerWarGodRank.TIER_BRONZE)
         {
            if(tier == PlayerWarGodRank.TIER_HEROIC)
            {
               tier--;
               division = PlayerWarGodRank.DIVISION_ONE;
            }
            else if(division == PlayerWarGodRank.DIVISION_THREE)
            {
               tier--;
               division = PlayerWarGodRank.DIVISION_ONE;
            }
            else
            {
               division--;
            }
            newRank = new PlayerWarGodRank();
            newRank.tier = tier;
            newRank.division = division;
            return newRank;
         }
         if(division != PlayerWarGodRank.DIVISION_THREE)
         {
            division--;
         }
         newRank = new PlayerWarGodRank();
         newRank.tier = tier;
         newRank.division = division;
         return newRank;
      }
      
      public static function jumpToNextDivision(rank:PlayerWarGodRank) : PlayerWarGodRank
      {
         var tier:int = rank.tier;
         var division:int = rank.division;
         if(tier == PlayerWarGodRank.TIER_HEROIC)
         {
            return null;
         }
         if(division >= PlayerWarGodRank.MAX_DIVISION_NUM - 1)
         {
            division = PlayerWarGodRank.DIVISION_THREE;
            tier++;
         }
         else
         {
            division++;
         }
         var result:PlayerWarGodRank = new PlayerWarGodRank();
         result.tier = tier;
         result.division = division;
         result.star = rank.star;
         return result;
      }
      
      public static function jumpToPrevDivision(rank:PlayerWarGodRank) : PlayerWarGodRank
      {
         var tier:int = rank.tier;
         var division:int = rank.division;
         if(tier == PlayerWarGodRank.TIER_BRONZE && division == PlayerWarGodRank.DIVISION_THREE)
         {
            return null;
         }
         if(division == PlayerWarGodRank.DIVISION_THREE)
         {
            division = PlayerWarGodRank.DIVISION_ONE;
            tier--;
         }
         else
         {
            division--;
         }
         var result:PlayerWarGodRank = new PlayerWarGodRank();
         result.tier = tier;
         result.division = division;
         result.star = rank.star;
         return result;
      }
      
      public static function getLocalizedMatchResult(result:int) : String
      {
         if(result == WarGodMatchObj.RESULT_LOSE)
         {
            return DictWarGod.MATCH_RESULT_LOSE;
         }
         if(result == WarGodMatchObj.RESULT_WIN)
         {
            return DictWarGod.MATCH_RESULT_WON;
         }
         if(result == WarGodMatchObj.RESULT_DRAW)
         {
            return DictWarGod.MATCH_RESULT_DRAW;
         }
         if(result == WarGodMatchObj.RESULT_LEAVE)
         {
            return DictWarGod.MATCH_RESULT_LEAVE;
         }
         return "";
      }
      
      public static function getPlayerWarGodRankByScore(score:int) : Object
      {
         if(score < 0)
         {
            return null;
         }
         return CFunctionCommonContainer.AS_GetTierDivisionStarFromScore(score) as Object;
      }
      
      public static function getWarGodRankForPlayer(score:int, season:int) : Object
      {
         return CFunctionContainer.AS_GetPlayerRankByScoreAndSeason(score,season);
      }
      
      public static function isMatchValid(map:int) : Boolean
      {
         return map != 0;
      }
      
      public static function getMatchResultByFactors(isWinner:int, isDraw:int, isDisconnect:int) : int
      {
         if(Boolean(isDisconnect))
         {
            return WarGodMatchObj.RESULT_LEAVE;
         }
         if(Boolean(isWinner))
         {
            return WarGodMatchObj.RESULT_WIN;
         }
         if(Boolean(isDraw))
         {
            return WarGodMatchObj.RESULT_DRAW;
         }
         return WarGodMatchObj.RESULT_LOSE;
      }
      
      public static function getMatchKDByFactors(kills:int, death:int) : String
      {
         if(death == 0)
         {
            death = 1;
         }
         return (kills / death).toFixed(2);
      }
      
      public static function getFormattedTime(timeStamp:int) : String
      {
         var time:TimeObj = CFunctionCommonContainer.GetFormatTimeByTimeStamp(timeStamp);
         var serverTimeStamp:int = CFunctionCommonContainer.GetServerTimeStamp();
         var serverTime:TimeObj = CFunctionCommonContainer.GetFormatTimeByTimeStamp(serverTimeStamp);
         if(time.year == serverTime.year && time.month == serverTime.month && time.day == serverTime.day)
         {
            return StringUtil.zeroPad(time.hour,2) + ":" + StringUtil.zeroPad(time.min,2);
         }
         return StringUtil.zeroPad(time.year,4) + "-" + StringUtil.zeroPad(time.month,2) + "-" + StringUtil.zeroPad(time.day,2);
      }
      
      public static function getFormattedDuration(timeStamp:int) : String
      {
         var resultStr:String = null;
         var second:int = timeStamp % 60;
         var minute:int = Math.floor(timeStamp / 60);
         resultStr = String(second) + LocalizeUtil.localize(DictWarGod.WARGOD_SECOND);
         if(minute > 0)
         {
            resultStr = String(minute) + LocalizeUtil.localize(DictWarGod.WARGOD_MINUTE) + resultStr;
         }
         return resultStr;
      }
      
      public static function setWargodTierIcon(owner:MovieClip, data:Object) : void
      {
         var info:Object = null;
         if(data.wargodScore == null || data.wargodSeason == null)
         {
            owner.myWargodTier.visible = false;
            if(owner.hasOwnProperty("myWargodTierName"))
            {
               owner.myWargodTierName.visible = false;
               owner.myWargodTierName.text = "";
            }
         }
         else
         {
            info = WarGodUtility.getWarGodRankForPlayer(data.wargodScore,data.wargodSeason);
            if(info == null)
            {
               owner.myWargodTier.visible = false;
               if(owner.hasOwnProperty("myWargodTierName"))
               {
                  owner.myWargodTierName.visible = false;
                  owner.myWargodTierName.text = "";
               }
            }
            else
            {
               owner.myWargodTier.visible = true;
               if(owner.hasOwnProperty("myWargodTierName"))
               {
                  owner.myWargodTierName.visible = true;
                  owner.myWargodTierName.text = LocalizeUtil.localize(WarGodUtility.getTierName(info.tier));
                  if(info.tier != PlayerWarGodRank.TIER_HEROIC)
                  {
                     owner.myWargodTierName.text += LocalizeUtil.localize(WarGodUtility.getDivisionName(info.division));
                  }
               }
               owner.myWargodTier.gotoAndStop(info.tier + 1);
            }
         }
      }
      
      public static function getWarGodTierIndex(data:Object) : int
      {
         var info:Object = null;
         if(data.wargodScore == null || data.wargodSeason == null)
         {
            return -1;
         }
         info = WarGodUtility.getWarGodRankForPlayer(data.wargodScore,data.wargodSeason);
         if(info == null)
         {
            return -1;
         }
         return info.tier;
      }
      
      public static function needWarGodResult() : Boolean
      {
         var wargodResult:String = CFunctionCommonContainer.Dvar_GetString("ui_wg_valid");
         if(wargodResult == "1")
         {
            return true;
         }
         var result:Object = CFunctionContainer.AS_GetPlayerObjForMatchResult();
         var beforeMatch:WarGodPlayerObj = result.beforeMatch as WarGodPlayerObj;
         var afterMatch:WarGodPlayerObj = result.afterMatch as WarGodPlayerObj;
         if(beforeMatch.numMatchHistroy != afterMatch.numMatchHistroy)
         {
            return true;
         }
         if(beforeMatch.numPromotionMatchCompleted != afterMatch.numPromotionMatchCompleted)
         {
            return true;
         }
         if(beforeMatch.score != afterMatch.score)
         {
            return true;
         }
         return false;
      }
      
      public static function calculateStarOffset(beforeScore:int, afterScore:int) : int
      {
         var hv:int = 0;
         hv = beforeScore % 1000;
         var beforeBaseScore:int = beforeScore - hv;
         hv = afterScore % 1000;
         var afterBaseScore:int = afterScore - hv;
         if(afterBaseScore == beforeBaseScore)
         {
            return 0;
         }
         var upForward:Boolean = afterBaseScore > beforeBaseScore;
         var beforeRank:Object = CFunctionCommonContainer.AS_GetTierDivisionStarFromScore(beforeBaseScore);
         var afterRank:Object = CFunctionCommonContainer.AS_GetTierDivisionStarFromScore(afterBaseScore);
         var beforePlayerRank:PlayerWarGodRank = new PlayerWarGodRank();
         beforePlayerRank.tier = beforeRank.tier;
         beforePlayerRank.division = beforeRank.division;
         beforePlayerRank.star = beforeRank.star;
         beforePlayerRank.score = CFunctionContainer.AS_GetPlayerScoreByRank(beforePlayerRank);
         var afterPlayerRank:PlayerWarGodRank = new PlayerWarGodRank();
         afterPlayerRank.tier = afterRank.tier;
         afterPlayerRank.division = afterRank.division;
         afterPlayerRank.star = afterRank.star;
         afterPlayerRank.score = CFunctionContainer.AS_GetPlayerScoreByRank(afterPlayerRank);
         var resultOffset:int = 0;
         var tempRank:PlayerWarGodRank = beforePlayerRank;
         while(!rankEqual(tempRank,afterPlayerRank))
         {
            if(upForward)
            {
               tempRank = incrementStar(tempRank);
               if(tempRank.score > afterPlayerRank.score)
               {
                  break;
               }
               resultOffset++;
            }
            else
            {
               tempRank = decreamentStar(tempRank);
               if(tempRank.score < afterPlayerRank.score)
               {
                  break;
               }
               resultOffset--;
            }
            if(Math.abs(resultOffset) > 2)
            {
               Logger.print("WARGOD_ERROR: WarGodUtility.as Impossible rank offset is spotted",beforeScore,afterScore);
               break;
            }
         }
         return resultOffset;
      }
      
      public static function rankEqual(rank1:PlayerWarGodRank, rank2:PlayerWarGodRank) : Boolean
      {
         if(rank1.tier == PlayerWarGodRank.TIER_HEROIC && rank2.tier == PlayerWarGodRank.TIER_HEROIC)
         {
            return true;
         }
         return rank1.tier == rank2.tier && rank1.division == rank2.division;
      }
      
      public static function compareRank(rank1:PlayerWarGodRank, rank2:PlayerWarGodRank) : int
      {
         if(rank1.tier < rank2.tier)
         {
            return -1;
         }
         if(rank1.tier == rank2.tier)
         {
            if(rank1.tier == PlayerWarGodRank.TIER_HEROIC)
            {
               return 0;
            }
            if(rank1.division < rank2.division)
            {
               return -1;
            }
            if(rank1.division == rank2.division)
            {
               return 0;
            }
            return 1;
         }
         return 1;
      }
      
      public static function getNumStarForUpgrade(tier:int) : int
      {
         var wargodGlobalSetting:WarGodGlobalSettingObj = null;
         if(ScaleformUtil.isScaleform)
         {
            wargodGlobalSetting = DataManager.getInstance().getDP(DataID.WARGOD_GLOBAL_SETTING);
            return wargodGlobalSetting.numStarForUpgrade[tier];
         }
         return 5;
      }
      
      public static function isJuniorWarGod(playerObj:WarGodPlayerObj) : Boolean
      {
         var pendingPlayerObj:WarGodPendingPhasePlayerObj = null;
         if(playerObj.phase == WarGodPlayerObj.PHASE_PENDING)
         {
            pendingPlayerObj = CFunctionContainer.AS_GetPendingPhasePlayerObj();
            return isJuniorWarGodByScore(pendingPlayerObj.inheritedScore);
         }
         return isJuniorWarGodByScore(playerObj.score);
      }
      
      public static function isJuniorWarGodByScore(score:int) : Boolean
      {
         return score < PlayerWarGodRank.MINIMUM_BRONZE_SCORE;
      }
      
      public static function getJuniorWarGodPromotionValueByTier(tierIndex:int, divisionIndex:int) : Number
      {
         var wargodGlobalSetting:WarGodGlobalSettingObj = null;
         if(ScaleformUtil.isScaleform)
         {
            wargodGlobalSetting = DataManager.getInstance().getDP(DataID.WARGOD_GLOBAL_SETTING);
            return wargodGlobalSetting.promotionScore[tierIndex * PlayerWarGodRank.MAX_DIVISION_NUM + divisionIndex];
         }
         return 100;
      }
      
      public static function getSeniorWargodPromotionValueByTier(tierIndex:int, divisionIndex:int) : Number
      {
         var wargodGlobalSetting:WarGodGlobalSettingObj = null;
         if(ScaleformUtil.isScaleform)
         {
            wargodGlobalSetting = DataManager.getInstance().getDP(DataID.WARGOD_GLOBAL_SETTING);
            return wargodGlobalSetting.seniorWargodPromotionScore[(tierIndex - PlayerWarGodRank.TIER_BRONZE) * PlayerWarGodRank.MAX_DIVISION_NUM + divisionIndex];
         }
         return 100;
      }
      
      public static function getJuniorWarGodPromotionScoreBarParameter(data:WarGodMatchResultObj, paramters:Array) : int
      {
         var psbp:PromotionScoreBarParameter = null;
         var sv:int = 0;
         var ev:int = 0;
         var tv:int = 0;
         var lastPsbp:PromotionScoreBarParameter = null;
         var scoreDifference:int = 0;
         var beforeRank:PlayerWarGodRank = data.beforeRank;
         var afterRank:PlayerWarGodRank = data.afterRank;
         var isUpgrade:Boolean = data.beforeScore < data.afterScore;
         var previousRank:PlayerWarGodRank = beforeRank;
         var currentRank:PlayerWarGodRank = beforeRank;
         var currentStartValue:int = data.beforePromotionScore;
         while(!WarGodUtility.rankEqual(currentRank,afterRank) && currentRank.tier < PlayerWarGodRank.TIER_BRONZE)
         {
            psbp = new PromotionScoreBarParameter();
            if(isUpgrade)
            {
               sv = currentStartValue;
               ev = WarGodUtility.getJuniorWarGodPromotionValueByTier(currentRank.tier,currentRank.division);
               tv = ev;
               previousRank = currentRank;
               currentRank = WarGodUtility.increaseJuniorWarGodDivision(currentRank);
               currentStartValue = 0;
            }
            else
            {
               sv = currentStartValue;
               ev = 0;
               tv = WarGodUtility.getJuniorWarGodPromotionValueByTier(currentRank.tier,currentRank.division);
               previousRank = currentRank;
               currentRank = WarGodUtility.decreaseJuniorWarGodDivision(currentRank);
               currentStartValue = WarGodUtility.getJuniorWarGodPromotionValueByTier(currentRank.tier,currentRank.division);
            }
            psbp.startValue = sv;
            psbp.endValue = ev;
            psbp.threshold = tv;
            psbp.rank = currentRank;
            psbp.prevRank = previousRank;
            paramters.push(psbp);
            scoreDifference += psbp.endValue - psbp.startValue;
         }
         if(currentRank.tier < PlayerWarGodRank.TIER_BRONZE)
         {
            lastPsbp = new PromotionScoreBarParameter();
            lastPsbp.startValue = currentStartValue;
            lastPsbp.endValue = data.afterPromotionScore;
            lastPsbp.threshold = WarGodUtility.getJuniorWarGodPromotionValueByTier(currentRank.tier,currentRank.division);
            lastPsbp.prevRank = currentRank;
            lastPsbp.rank = currentRank;
            paramters.push(lastPsbp);
            scoreDifference += lastPsbp.endValue - lastPsbp.startValue;
         }
         return scoreDifference;
      }
      
      public static function getSeniorWarGodPromotionScoreBarParamater(data:WarGodMatchResultObj, paramters:Array) : int
      {
         var i:int = 0;
         var psbp:PromotionScoreBarParameter = null;
         var sv:int = 0;
         var ev:int = 0;
         var tv:int = 0;
         var scoreDifference:int = 0;
         var beforeRank:PlayerWarGodRank = data.beforeRank;
         var afterRank:PlayerWarGodRank = data.afterRank;
         var isUpgrade:Boolean = data.beforeScore < data.afterScore;
         var previousRank:PlayerWarGodRank = beforeRank;
         var currentRank:PlayerWarGodRank = beforeRank;
         var currentStartValue:int = data.beforePromotionScore;
         for(i = 0; i < 30; i++)
         {
            if(WarGodUtility.rankEqual(currentRank,afterRank))
            {
               break;
            }
            psbp = new PromotionScoreBarParameter();
            if(isUpgrade)
            {
               sv = currentStartValue;
               ev = WarGodUtility.getSeniorWargodPromotionValueByTier(currentRank.tier,currentRank.division);
               tv = ev;
               previousRank = currentRank;
               currentRank = WarGodUtility.increaseSeniorWarGodDivision(currentRank);
               currentStartValue = 0;
            }
            else
            {
               sv = currentStartValue;
               ev = 0;
               tv = WarGodUtility.getSeniorWargodPromotionValueByTier(currentRank.tier,currentRank.division);
               previousRank = currentRank;
               currentRank = WarGodUtility.decreaseSeniorWarGodDivision(currentRank);
               currentStartValue = WarGodUtility.getSeniorWargodPromotionValueByTier(currentRank.tier,currentRank.division);
            }
            psbp.rank = currentRank;
            psbp.prevRank = previousRank;
            psbp.startValue = sv;
            psbp.endValue = ev;
            psbp.threshold = tv;
            paramters.push(psbp);
         }
         var lastPsbp:PromotionScoreBarParameter = new PromotionScoreBarParameter();
         lastPsbp.startValue = currentStartValue;
         lastPsbp.endValue = data.afterPromotionScore;
         lastPsbp.threshold = WarGodUtility.getSeniorWargodPromotionValueByTier(currentRank.tier,currentRank.division);
         lastPsbp.prevRank = currentRank;
         lastPsbp.rank = currentRank;
         paramters.push(lastPsbp);
         scoreDifference += data.matchResultFromDvar[WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_WINLOSE];
         scoreDifference += data.matchResultFromDvar[WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_PUNISH];
         for(i = WarGodMatchResultObj.SENIOR_WARGOD_PROPTION_SCORE_DETAIL_MIN; i <= WarGodMatchResultObj.SENIOR_WARGOD_PROPTION_SCORE_DETAIL_MAX; i++)
         {
            if(i >= data.matchResultFromDvar.length)
            {
               break;
            }
            scoreDifference += data.matchResultFromDvar[i];
         }
         return scoreDifference;
      }
   }
}

