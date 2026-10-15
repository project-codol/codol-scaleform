package codo.controllers
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictCareer;
   import codo.objects.CareerStatsObj;
   import codo.objects.CyborgsCareerObj;
   import codo.objects.OnboardingChecklistChallengeObj;
   import codo.objects.PlayerObj;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TimeUtil;
   
   public class CareerController extends CareerBaseController
   {
      
      private static const FIXED_RECENT_LENGTH:int = 15;
      
      private var _currentXP:int = -1;
      
      private var _recentMatchStats:Array = null;
      
      private var _careerStats:CareerStatsObj = null;
      
      private var _currentBadgeSlot:int = 0;
      
      public function CareerController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         addDP(DataID.IS_ME,this.isMe);
         addDP(DataID.IS_IN_NEWBIE_CHANNEL,this.isInNewbieChannel);
         addDP(DataID.CAREER_STATS,this.getCareerStats);
         addDP(DataID.CAREER_INFO_CYBORGS,this.getCyborgsCareerInfo);
         addDP(DataID.CAREER_CURRENT_XP,this.getCurrentXP);
         addDP(DataID.LEVEL_NAME,this.getLevelName);
         listen(BCEvent.EVT_CLOSE_LEVELUP_INFO,this.onCloseLevelupInfo);
         listen(BCEvent.EVT_EQUIP,this.equipItem);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChangeHandle);
         listen(BCEvent.EVT_CHARACTERLOADOUT_UNEQUIP_ITEM_BY_ITEM,this.onUnequipItemByItem);
         listen(BCEvent.EVT_CALLSIGN_VIEW_ONSHOW,this.onCallsignViewOnShow);
         listen(BCEvent.EVT_BADGE_SLOT_SELECTED,this.onBadgeSlotSelected);
      }
      
      public function cppUIChallengeComplete(data:OnboardingChecklistChallengeObj) : void
      {
      }
      
      private function getCareerStats() : CareerStatsObj
      {
         var playerObj:PlayerObj = null;
         if(this._careerStats == null)
         {
            playerObj = PlayerObj.getObj();
            this._careerStats = new CareerStatsObj();
            this._careerStats.recentScores = this.getRecentScores();
            this._careerStats.averageScore = this.getRecentAverageScore();
            this._careerStats.matchResult = this.getMatchResults();
            this._careerStats.currentLevelInfo = getLevelInfo();
            this._careerStats.customStats = this.getCustomStats();
            this._careerStats.customStatsValues = this.getCustomStatsValues();
            this._careerStats.isBootCamp = getDP(DataID.IS_BOOT_CAMP);
            this._careerStats.bootCampEXP = playerObj.careerData.totalEarnedXP;
            this._careerStats.bootCampScore = playerObj.careerData.score;
         }
         return this._careerStats;
      }
      
      private function getCurrentXP() : int
      {
         if(this._currentXP == -1)
         {
            this._currentXP = CFunctionCommonContainer.GetPlayerXP();
         }
         return this._currentXP;
      }
      
      private function isInNewbieChannel() : Boolean
      {
         return CFunctionCommonContainer.GetPlayerPrestige() == 0 && CFunctionCommonContainer.GetPlayerLevel() < Common.NEWBIE_THRESHOLD;
      }
      
      protected function isMe(cUser:Object) : Boolean
      {
         var client:PlayerObj = PlayerObj.getObj();
         if(cUser == null)
         {
            return false;
         }
         return client.id == cUser.id;
      }
      
      private function get recentMatchStats() : Array
      {
         var fullRecentMatchStats:Array = null;
         var i:uint = 0;
         if(this._recentMatchStats == null)
         {
            this._recentMatchStats = [];
            fullRecentMatchStats = CFunctionContainer.AS_GetRecentMatchStats();
            for(i = fullRecentMatchStats.length - FIXED_RECENT_LENGTH; i < fullRecentMatchStats.length; i++)
            {
               this._recentMatchStats.push(fullRecentMatchStats[i]);
            }
         }
         return this._recentMatchStats;
      }
      
      private function getRecentScores(cGameType:int = 0) : Array
      {
         var matchStats:Object = null;
         var pos:Number = NaN;
         var recentMatchStats:Array = this.recentMatchStats;
         var positions:Array = ScaleformUtil.isScaleform ? [] : [0.2,0.4,0.6,0.3,0.5,0.9,1,0,0.5,0.3,0.15,0.2,0.4,0.6,0.3,0.5,0.9,1,0,0.5,0.3,0.15];
         for(var i:uint = 0; i < recentMatchStats.length; i++)
         {
            matchStats = recentMatchStats[i];
            if(!matchStats.empty)
            {
               if(matchStats.averageScore == 0)
               {
                  pos = Boolean(matchStats.topScore) ? matchStats.score / matchStats.topScore : 0;
               }
               else
               {
                  pos = matchStats.score / matchStats.averageScore;
                  pos = pos > 2 ? 1 : pos / 2;
               }
               positions.push(pos);
            }
         }
         return positions;
      }
      
      private function getRecentAverageScore() : uint
      {
         var matchStats:Object = null;
         var recentMatchStats:Array = this.recentMatchStats;
         var sum:int = 0;
         var count:int = 0;
         for(var i:uint = 0; i < recentMatchStats.length; i++)
         {
            matchStats = recentMatchStats[i];
            if(matchStats.empty == false)
            {
               sum += matchStats.score;
               count++;
            }
         }
         return uint(count == 0 ? 0 : sum / count);
      }
      
      private function getMatchResults() : Object
      {
         var playerObj:PlayerObj = PlayerObj.getObj();
         return {
            "win":playerObj.careerData.wins,
            "lose":playerObj.careerData.losses,
            "draw":playerObj.careerData.ties,
            "flee":playerObj.careerData.escapes
         };
      }
      
      private function getCustomStats() : Array
      {
         var scorePerMinute:Number = NaN;
         var playerObj:PlayerObj = PlayerObj.getObj();
         var timeInHours:String = TimeUtil.timeInHours(playerObj.careerData.timePlayed) + " <font face=\"$font_2\">" + LocalizeUtil.localize(Dict.HOUR) + "</font>";
         var timeInMinutes:int = TimeUtil.timeInMinutes(playerObj.careerData.timePlayed);
         if(timeInMinutes == 0)
         {
            scorePerMinute = 0;
         }
         else
         {
            scorePerMinute = playerObj.careerData.scoreEarned / timeInMinutes;
         }
         var winRatio:String = "<font face=\"$font_2\">%</font>";
         if(playerObj.careerData.winRatio == 100)
         {
            winRatio = playerObj.careerData.winRatio.toFixed(0) + winRatio;
         }
         else
         {
            winRatio = playerObj.careerData.winRatio.toFixed(2) + winRatio;
         }
         return [{
            "label":DictCareer.CAREER_KDRATIO,
            "value":playerObj.careerData.kdRatio.toFixed(2)
         },{
            "label":DictCareer.CAREER_KILLS,
            "value":playerObj.careerData.kills.toString()
         },{
            "label":DictCareer.CAREER_DEATH,
            "value":playerObj.careerData.deaths.toString()
         },{
            "label":DictCareer.CAREER_WINRATIO,
            "value":winRatio
         },{
            "label":DictCareer.CAREER_WINS,
            "value":playerObj.careerData.wins.toString()
         },{
            "label":DictCareer.CAREER_LOSSES,
            "value":(playerObj.careerData.losses + playerObj.careerData.ties).toString()
         },{
            "label":DictCareer.CAREER_SCORE,
            "value":playerObj.careerData.scoreEarned.toString()
         },{
            "label":DictCareer.CAREER_SCORE_PER_MINUTE,
            "value":scorePerMinute.toFixed(2)
         },{
            "label":DictCareer.CAREER_HEADSHOTS,
            "value":playerObj.careerData.headshots.toString()
         },{
            "label":DictCareer.CAREER_WINSTREAK,
            "value":playerObj.careerData.winStreak.toString()
         },{
            "label":DictCareer.CAREER_CURRENT_WINSTREAK,
            "value":playerObj.careerData.currentWinStreak.toString()
         },{
            "label":DictCareer.CAREER_TIES,
            "value":playerObj.careerData.ties
         },{
            "label":DictCareer.CAREER_TIMEPLAYED,
            "value":timeInHours
         },{
            "label":DictCareer.CAREER_HITRATE,
            "value":playerObj.careerData.accuracy.toFixed(2) + "%"
         },{
            "label":DictCareer.CAREER_OBJECTIVES,
            "value":playerObj.careerData.objectives.toString()
         }];
      }
      
      private function getCustomStatsValues() : Array
      {
         var playerObj:PlayerObj = PlayerObj.getObj();
         return [playerObj.careerData.timePlayed,playerObj.careerData.scoreEarned,playerObj.careerData.accuracy,playerObj.careerData.winStreak,playerObj.careerData.killStreak,playerObj.careerData.kdRatio,playerObj.careerData.currentLevel];
      }
      
      private function refreshAdvancedConsumable() : void
      {
      }
      
      private function onUnequipItemByItem(cEvt:ParaEvent) : void
      {
         var itemData:ProductObj = cEvt.myPara.data as ProductObj;
         if(itemData.type == ItemType.BDG)
         {
            CFunctionContainer.Callsign_UnequipItem(itemData.id);
            PlayerObj.updateBadgeInfo();
            broadcast(BCEvent.EVT_EQUIPPED,{});
         }
         else if(itemData.group == MarketMenuData.GRP_EQUIPPABLE_TOKEN)
         {
            CFunctionContainer.Callsign_UnequipAdvancedConsumable(itemData.id);
            this.refreshAdvancedConsumable();
            broadcast(BCEvent.EVT_EQUIPPED,{});
         }
         else if(itemData.type == ItemType.PCN || itemData.type == ItemType.PCF)
         {
            CFunctionContainer.Callsign_UnequipItem(itemData.id);
            PlayerObj.updateCallsignInfo();
            broadcast(BCEvent.EVT_EQUIPPED,{});
         }
      }
      
      private function equipItem(cEvt:ParaEvent) : void
      {
         var item:Object = cEvt.myPara.item;
         if(item.type == ItemType.PCT)
         {
            CFunctionContainer.Callsign_TryonTitle(int(item.id));
            PlayerObj.updateCallsignInfo();
         }
         else if(item.type == ItemType.PCB)
         {
            CFunctionContainer.Callsign_TryonBackground(int(item.id));
            PlayerObj.updateCallsignInfo();
         }
         else if(item.type == ItemType.PCI)
         {
            CFunctionContainer.Callsign_TryonEmblem(int(item.id));
            PlayerObj.updateCallsignInfo();
         }
         else if(item.type == ItemType.PCN)
         {
            CFunctionContainer.Callsign_TryonNameplate(int(item.id));
            PlayerObj.updateCallsignInfo();
         }
         else if(item.type == ItemType.PCF)
         {
            CFunctionContainer.Callsign_TryonFrame(int(item.id));
            PlayerObj.updateCallsignInfo();
         }
         else if(item.type == ItemType.BDG)
         {
            CFunctionContainer.Callsign_TryonBadge(int(item.id),this._currentBadgeSlot);
            PlayerObj.updateBadgeInfo();
         }
         else if(item.type == ItemType.ITM && item.group == MarketMenuData.GRP_EQUIPPABLE_TOKEN)
         {
            CFunctionContainer.Callsign_TryonAdvancedConsumable(int(item.id));
            this.refreshAdvancedConsumable();
         }
      }
      
      private function onCloseLevelupInfo(cEvt:ParaEvent) : void
      {
         prevPage();
      }
      
      private function onCallsignViewOnShow(cEvt:ParaEvent) : void
      {
         PlayerObj.updateCallsignInfo();
         PlayerObj.updateBadgeInfo();
      }
      
      private function onInventoryChangeHandle(cEvt:ParaEvent) : void
      {
         PlayerObj.updateCallsignInfo();
         PlayerObj.updateBadgeInfo();
      }
      
      protected function getCyborgsCareerInfo() : CyborgsCareerObj
      {
         return new CyborgsCareerObj();
      }
      
      private function getLevelName(level:uint) : String
      {
         return level >= 0 ? PlayerObj.getRankName(level) : "";
      }
      
      private function onBadgeSlotSelected(cEvt:ParaEvent) : void
      {
         this._currentBadgeSlot = cEvt.myPara as int;
      }
   }
}

