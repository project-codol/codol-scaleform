package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.table.UINotifications;
   import codo.event.ParaEvent;
   import codo.localization.DictSystem;
   import codo.localization.DictWarGod;
   import codo.objects.PartyMemberObj;
   import codo.objects.PlayerObj;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodChallengeRewardObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodPlaylistObj;
   import codo.objects.WarGodRewardObj;
   import codo.objects.WarGodSeasonEndRewardObj;
   import codo.objects.WarGodSeasonObj;
   import codo.utils.WarGodUtility;
   
   public class WarGodController extends BaseController
   {
      
      private static const ACCEPT_INHERIT:int = 0;
      
      private static const ACCEPT_PLACEMENT:int = 1;
      
      private static const FRIENDS_LEADERBOARD_SOURCE_TYPE:int = 1;
      
      private static const GLOBAL_LEADERBOARD_SOURCE_TYPE:int = 2;
      
      private static const TOP_PLAYER_LEADERBOARD_OPEN_TYPE:int = 2;
      
      private static const FRIENDS_LEADERBOARD_OPEN_TYPE:int = 0;
      
      private static const ONBOARD_SELECT_WARGOD_AS_DEFAULT_PERSTIGE:int = 0;
      
      private static const ONBAORD_SELECT_WARGOD_AS_DEFAULT_LEVEL:int = 30;
      
      private static const ONBOARD_SELECT_WARGOD_AS_DEFAULT_TIER:int = 2;
      
      private var wargodResult:WarGodMatchResultObj;
      
      private var wargodResultEverSet:Boolean = false;
      
      private var weaponNumIsSatisfied:Boolean = false;
      
      private var wargodGlobalSetting:WarGodGlobalSettingObj;
      
      public function WarGodController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.WARGOD_GLOBAL_SETTING,this.getWarGodGlobalSetting);
         addDP(DataID.CURRENT_WARGOD_INFO,this.getCurrentWarGodInfo);
         addDP(DataID.WARGOD_IS_LOCKED,this.getWarGodIsLocked);
         addDP(DataID.WARGOD_OPENING_STATE,this.getWarGodOpeningState);
         addDP(DataID.PLAYER_WARGOD_DATA,this.getPlayerWarGodData);
         addDP(DataID.LOBBY_SUMMARY_WARGOD,this.getWarGodMatchResult);
         addDP(DataID.GET_SEASON_BY_ID,this.getSeasonById);
         addDP(DataID.Get_WARGOD_LEADERBOARD_FOR_DISPLAY,this.getWarGodLeaderBoardForDisplay);
         addDP(DataID.IF_SELECT_WARGOD_AS_DEFAULT,this.getIfNeedSelectWarGodAsDefaultMode);
         addDP(DataID.GET_JUNIOR_WARGOD_MATCHMAKING_PLAYLIST,this.getJuniorWarGodMatchMakingPlaylist);
         addDP(DataID.WARGOD_BLOCK_DURATION,this.getPlayerWargodBanDuration);
         listen(BCEvent.EVT_SEND_HEROIC_TIER_NOTIFICATION,this.onSendHeroicTierNotification);
         listen(BCEvent.EVT_FETCH_WARGOD_LEADERBOARD_TOP_100_DATA,this.onFetchWargodLeaderboardTop100Data);
         listen(BCEvent.EVT_FETCH_WARGOD_LEADERBOARD_FRIENDS_DATA,this.onFetchWargodLeaderboardFriendsData);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChanged);
         listen(BCEvent.EVT_FETCH_WARGOD_HISTROY_SEASON,this.onFetchWarGodHistroySeason);
         listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandler);
         listen(BCEvent.EVT_NEW_SEASON_SELECT_INHERIT_SCORE,this.onPickNewSeasonSelectInheritScore);
         listen(BCEvent.EVT_NEW_SEASON_SELECT_PLACEMENT,this.onPickNewSeasonSelectPlacement);
         listen(BCEvent.EVT_JUNIOR_WARGOD_PLAYLIST_OPTION_CHANGED,this.onJuniorWarGodPlaylistOptionChanged);
      }
      
      public function cppOnSeasonOpeningStateChanged() : void
      {
         broadcast(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED);
         broadcast(BCEvent.EVT_FETCH_WARGOD_LEADERBOARD_TOP_100_DATA);
      }
      
      public function cppOnWarGodPlayerObjChanged() : void
      {
         broadcast(BCEvent.EVT_WARGOD_PLAYER_OBJ_CHANGED);
      }
      
      public function cppOnCreditRatingChanged() : void
      {
         broadcast(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED);
         broadcast(BCEvent.EVT_WARGOD_TSS_STATE_CHANGED);
      }
      
      private function getWarGodGlobalSetting() : WarGodGlobalSettingObj
      {
         if(this.wargodGlobalSetting == null)
         {
            this.wargodGlobalSetting = CFunctionCommonContainer.AS_GetWarGodGlobalSetting();
         }
         return this.wargodGlobalSetting;
      }
      
      private function getCurrentWarGodInfo() : WarGodSeasonObj
      {
         return CFunctionContainer.AS_GetHeadSeason();
      }
      
      private function getSeasonById(seasonId:int) : WarGodSeasonObj
      {
         return CFunctionContainer.AS_GetSeasonBySeasonId(seasonId);
      }
      
      private function onFetchWargodLeaderboardTop100Data(cEvt:ParaEvent) : void
      {
         var seasonInfo:WarGodSeasonObj = this.getWarGodLeaderBoardForDisplay();
         if(seasonInfo == null)
         {
            return;
         }
         var param:Object = {
            "name":seasonInfo.lbName,
            "page":0,
            "size":100,
            "openMode":TOP_PLAYER_LEADERBOARD_OPEN_TYPE,
            "sourceType":GLOBAL_LEADERBOARD_SOURCE_TYPE,
            "mustHave":true
         };
         broadcast(BCEvent.EVT_REQUEST_LEADERBOARD,param);
         param = {
            "name":seasonInfo.lbName,
            "page":0,
            "size":100,
            "openMode":FRIENDS_LEADERBOARD_OPEN_TYPE,
            "sourceType":FRIENDS_LEADERBOARD_SOURCE_TYPE,
            "mustHave":true
         };
         broadcast(BCEvent.EVT_REQUEST_LEADERBOARD,param);
         var wargodGlobalSetting:WarGodGlobalSettingObj = this.getWarGodGlobalSetting();
         if(!wargodGlobalSetting.lockLocalLeaderboard && !wargodGlobalSetting.perZoneLBFromTencent)
         {
            param = {
               "name":seasonInfo.lbLocalName,
               "page":0,
               "size":100,
               "openMode":TOP_PLAYER_LEADERBOARD_OPEN_TYPE,
               "sourceType":GLOBAL_LEADERBOARD_SOURCE_TYPE,
               "mustHave":true
            };
            broadcast(BCEvent.EVT_REQUEST_LEADERBOARD,param);
         }
      }
      
      private function onFetchWargodLeaderboardFriendsData(cEvt:ParaEvent) : void
      {
         var seasonInfo:WarGodSeasonObj = this.getWarGodLeaderBoardForDisplay();
         if(seasonInfo == null)
         {
            return;
         }
         var param:Object = {
            "name":seasonInfo.lbName,
            "page":0,
            "size":100,
            "openMode":FRIENDS_LEADERBOARD_OPEN_TYPE,
            "sourceType":FRIENDS_LEADERBOARD_SOURCE_TYPE,
            "mustHave":true
         };
         broadcast(BCEvent.EVT_REQUEST_LEADERBOARD,param);
      }
      
      private function onInventoryChanged(cEvt:ParaEvent) : void
      {
         CFunctionContainer.AS_TryToUpdatePrimaryWeaponCountToPartyMember();
         var isSatisfiedBefore:Boolean = this.weaponNumIsSatisfied;
         if(isSatisfiedBefore != this.getWarGodPrimaryWeaponSatisfied())
         {
            broadcast(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED);
         }
      }
      
      private function onPlayerStatsReadyHandler(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.EVT_FETCH_WARGOD_LEADERBOARD_TOP_100_DATA);
         CFunctionContainer.AS_FetchWarGodCreditRatingScore();
      }
      
      private function onFetchWarGodHistroySeason(cEvt:ParaEvent) : void
      {
         CFunctionContainer.AS_GetWarGodHistroySeason();
      }
      
      private function getWarGodLeaderBoardForDisplay() : WarGodSeasonObj
      {
         var seasonId:int = CFunctionContainer.AS_GetSeasonIDForLeaderBoardDisplay();
         return CFunctionContainer.AS_GetSeasonBySeasonId(seasonId);
      }
      
      private function getIfNeedSelectWarGodAsDefaultMode() : Boolean
      {
         var onboardPvpNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_PVP]);
         var onboardPveNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_PVE]);
         var onboardWarGodNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_WARGOD]);
         if(!onboardPvpNotified || !onboardPveNotified || !onboardWarGodNotified)
         {
            return false;
         }
         if(int(PlayerObj.getObj().careerData.prestige) <= ONBOARD_SELECT_WARGOD_AS_DEFAULT_PERSTIGE && int(PlayerObj.getObj().careerData.currentLevel) < ONBAORD_SELECT_WARGOD_AS_DEFAULT_LEVEL && this.getPlayerWarGodData().warGodRank.tier < ONBOARD_SELECT_WARGOD_AS_DEFAULT_TIER)
         {
            return true;
         }
         return false;
      }
      
      private function getJuniorWarGodMatchMakingPlaylist() : WarGodPlaylistObj
      {
         var i:int = 0;
         var partyInfo:Object = null;
         var partyMember:PartyMemberObj = null;
         var playlistWrapper:WarGodPlaylistObj = new WarGodPlaylistObj();
         var playerObj:WarGodPlayerObj = this.getPlayerWarGodData();
         var isPlacementPlaylist:Boolean = false;
         var specifiedScore:int = WarGodPlaylistObj.NO_SPECIFIY_SCORE_WHEN_GET_PLAYLIST;
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            partyInfo = getDP(DataID.PARTY_INFO);
            if(Boolean(partyInfo))
            {
               for(i = 0; i < partyInfo.members.length; i++)
               {
                  partyMember = partyInfo.members[i];
                  if(partyMember.wargodPhase == WarGodPlayerObj.PHASE_PLACEMENT)
                  {
                     isPlacementPlaylist = true;
                     playlistWrapper.warnType = WarGodPlaylistObj.WARN_TYPE_PARTY_MEMBER_PLACEMENT;
                     playlistWrapper.othersPlaylist = true;
                     break;
                  }
               }
            }
         }
         else if(playerObj.phase == WarGodPlayerObj.PHASE_PLACEMENT)
         {
            isPlacementPlaylist = true;
            playlistWrapper.warnType = WarGodPlaylistObj.WARN_TYPE_PLAYER_PLACEMENT;
         }
         playlistWrapper.playlist = CFunctionContainer.AS_GetJuniorWarGodPlayList(isPlacementPlaylist);
         if(isPlacementPlaylist)
         {
            for(i = 0; i < playlistWrapper.playlist.length; i++)
            {
               playlistWrapper.playlist[i].enabled = false;
            }
         }
         return playlistWrapper;
      }
      
      private function onSendHeroicTierNotification(cEvt:ParaEvent) : void
      {
         CFunctionContainer.AS_SendHeroicTierNotification();
      }
      
      private function getWarGodIsLocked() : Boolean
      {
         return getDvarBool("lock_tournament");
      }
      
      private function getWarGodLevelIsSatisfied() : Boolean
      {
         return CFunctionContainer.AS_IsLevelSatisfiedToWarGod() as Boolean;
      }
      
      private function getWarGodPrimaryWeaponSatisfied() : Boolean
      {
         return CFunctionContainer.AS_IsWeaponSatisfiedToWarGod() as Boolean;
      }
      
      private function onPickNewSeasonSelectInheritScore(evt:ParaEvent) : void
      {
         showMsg(DictWarGod.CONFIRM_INHERIT_SCORE,MsgBtnCount.TWO,0,this.realSelectInheritScore,DictSystem.YES,null,DictSystem.CANCEL);
      }
      
      private function realSelectInheritScore() : void
      {
         CFunctionContainer.AS_PickHowToStartNewSeason(ACCEPT_INHERIT);
      }
      
      private function onPickNewSeasonSelectPlacement(evt:ParaEvent) : void
      {
         CFunctionContainer.AS_PickHowToStartNewSeason(ACCEPT_PLACEMENT);
      }
      
      private function onJuniorWarGodPlaylistOptionChanged(evt:ParaEvent) : void
      {
         var playlist:Array = evt.myPara;
         CFunctionContainer.AS_SetJuniorWarGodPlaylistSelection(playlist);
      }
      
      private function getWarGodOpeningState() : int
      {
         var seasonIsLocked:Boolean = this.getWarGodIsLocked();
         var seasonObj:WarGodSeasonObj = this.getCurrentWarGodInfo();
         var playerData:WarGodPlayerObj = this.getPlayerWarGodData();
         if(seasonIsLocked || !seasonObj)
         {
            return WarGodSeasonObj.STATE_CLOSE_LOCK;
         }
         var isLevelSatisfied:Boolean = this.getWarGodLevelIsSatisfied();
         var isPrimarySatisfied:Boolean = this.getWarGodPrimaryWeaponSatisfied();
         if(!isLevelSatisfied)
         {
            return WarGodSeasonObj.STATE_CLOSE_LEVEL;
         }
         if(!isPrimarySatisfied)
         {
            return WarGodSeasonObj.STATE_CLOSE_PRIMARY_WEAPON;
         }
         var currentTimeStamp:int = getDP(DataID.GET_SERVER_TIME_STAMP);
         if(currentTimeStamp < seasonObj.startTimeStamp)
         {
            return WarGodSeasonObj.STATE_CLOSE_SEASON_NOT_START;
         }
         if(currentTimeStamp > seasonObj.endTimeStamp)
         {
            return WarGodSeasonObj.STATE_CLOSE_SEASON_NOT_START;
         }
         var globalSetting:WarGodGlobalSettingObj = this.getWarGodGlobalSetting();
         var isTimeValid:Boolean = CFunctionContainer.AS_PlayListValid(globalSetting.playlistId) as Boolean;
         if(!isTimeValid && !WarGodUtility.isJuniorWarGod(playerData))
         {
            return WarGodSeasonObj.STATE_PAUSE;
         }
         if(playerData.isBlocked(currentTimeStamp))
         {
            return WarGodSeasonObj.STATE_BLOCKED;
         }
         return WarGodSeasonObj.STATE_OPEN;
      }
      
      private function getPlayerWarGodData() : WarGodPlayerObj
      {
         return CFunctionContainer.AS_GetWarGodPlayerData();
      }
      
      private function getWarGodMatchResult() : WarGodMatchResultObj
      {
         var beforeMatchLastLog:WarGodMatchObj = null;
         var afterMatchLastLog:WarGodMatchObj = null;
         var challengeReward:WarGodChallengeRewardObj = null;
         var j:int = 0;
         var aReward:WarGodRewardObj = null;
         var reward:WarGodRewardObj = null;
         var rewardObj:Object = null;
         if(!WarGodUtility.needWarGodResult())
         {
            return null;
         }
         if(this.wargodResultEverSet)
         {
            return this.wargodResult;
         }
         this.wargodResultEverSet = true;
         var result:Object = CFunctionContainer.AS_GetPlayerObjForMatchResult();
         var beforeMatch:WarGodPlayerObj = result.beforeMatch as WarGodPlayerObj;
         var afterMatch:WarGodPlayerObj = result.afterMatch as WarGodPlayerObj;
         if(afterMatch.numMatchHistroy <= 0)
         {
            return null;
         }
         this.wargodResult = new WarGodMatchResultObj();
         this.wargodResult.beforePhase = beforeMatch.phase;
         this.wargodResult.afterPhase = afterMatch.phase;
         this.wargodResult.beforeScore = beforeMatch.score;
         this.wargodResult.afterScore = afterMatch.score;
         this.wargodResult.beforeRank = beforeMatch.warGodRank;
         this.wargodResult.afterRank = afterMatch.warGodRank;
         this.wargodResult.beforeHV = beforeMatch.heroicValue;
         this.wargodResult.afterHV = afterMatch.heroicValue;
         this.wargodResult.beforePromotionScore = beforeMatch.promotionScore;
         this.wargodResult.afterPromotionScore = afterMatch.promotionScore;
         afterMatchLastLog = afterMatch.matchHistroy[afterMatch.numMatchHistroy - 1];
         this.wargodResult.HVGainLose = afterMatchLastLog.heroicValueGain;
         this.wargodResult.result = WarGodUtility.getMatchResultByFactors(afterMatchLastLog.isWinner,afterMatchLastLog.isDraw,afterMatchLastLog.isDisconnected);
         this.wargodResult.numPlacementComplete = afterMatch.numPlacementMatchCompleted;
         this.wargodResult.numPromotionComplete = beforeMatch.numPromotionMatchCompleted;
         this.wargodResult.hasPunishment = Boolean(afterMatchLastLog.isPunishment);
         var oneStarForPromotionPhase:Boolean = this.wargodResult.beforePhase != WarGodPlayerObj.PHASE_PROMOTION && this.wargodResult.afterPhase == WarGodPlayerObj.PHASE_PROMOTION;
         if(afterMatchLastLog.heroicValueGain > 0 && beforeMatch.heroicValue > afterMatch.heroicValue && !oneStarForPromotionPhase)
         {
            this.wargodResult.numStarChangeDueToHV = 1;
         }
         else
         {
            this.wargodResult.numStarChangeDueToHV = 0;
         }
         if(this.wargodResult.beforePhase == WarGodPlayerObj.PHASE_PLACEMENT)
         {
            this.wargodResult.numStarChangeDueToResult = 0;
         }
         else
         {
            this.wargodResult.numStarChangeDueToResult = WarGodUtility.calculateStarOffset(this.wargodResult.beforeScore,this.wargodResult.afterScore);
            this.wargodResult.numStarChangeDueToResult -= this.wargodResult.numStarChangeDueToHV;
         }
         if(oneStarForPromotionPhase && afterMatchLastLog.heroicValueGain == 0)
         {
            this.wargodResult.numStarChangeDueToPromotion = 1;
         }
         else
         {
            this.wargodResult.numStarChangeDueToPromotion = 0;
         }
         this.wargodResult.matchHistroy = afterMatch.matchHistroy;
         this.wargodResult.numMatchHistroy = afterMatch.numMatchHistroy;
         this.wargodResult.rewards = new Array();
         var beforeMatchMaxScore:int = beforeMatch.seasonMaxScore;
         var afterMatchMaxScore:int = afterMatch.seasonMaxScore;
         var setting:WarGodGlobalSettingObj = this.getWarGodGlobalSetting();
         for(var i:int = 0; i < setting.challengeReward.length; i++)
         {
            challengeReward = setting.challengeReward[i];
            if(beforeMatchMaxScore < challengeReward.threshold && afterMatchMaxScore >= challengeReward.threshold)
            {
               for(j = 0; j < challengeReward.rewards.length; j++)
               {
                  aReward = challengeReward.rewards[j] as WarGodRewardObj;
                  if(aReward.valid)
                  {
                     this.wargodResult.rewards.push(aReward);
                  }
               }
               break;
            }
         }
         var eligibleHPBonusReward:Array = [];
         for(i = 0; i < setting.hpBonusReward.length; i++)
         {
            reward = setting.hpBonusReward[i];
            if(beforeMatchMaxScore < reward.threshold && afterMatchMaxScore >= reward.threshold)
            {
               rewardObj = new Object();
               rewardObj.type = WarGodSeasonEndRewardObj.CHALLENGE_REWARD;
               rewardObj.msg = "";
               rewardObj.item = new Object();
               rewardObj.item.id = 0;
               rewardObj.item.type = WarGodRewardObj.TYPE_CURRENCY;
               rewardObj.item.currencyID = reward.currencyID;
               rewardObj.item.parameter = reward.parameter;
               rewardObj.item.seasonId = 0;
               eligibleHPBonusReward.push(rewardObj);
            }
         }
         if(eligibleHPBonusReward.length > 0)
         {
            broadcast(BCEvent.EVT_WANT_SHOW_WARGOD_CHALLENGE_REWARD,eligibleHPBonusReward);
         }
         this.wargodResult.firstTimeGetHeroicTier = beforeMatchMaxScore < PlayerWarGodRank.HEROIC_TIER_SCORE && afterMatchMaxScore >= PlayerWarGodRank.HEROIC_TIER_SCORE;
         this.wargodResult.matchResultFromDvar = CFunctionContainer.AS_GetPromotionScoreDetails();
         CFunctionContainer.AS_SendWarGodMatchEndTLog();
         return this.wargodResult;
      }
      
      private function getPlayerWargodBanDuration() : int
      {
         var playerData:WarGodPlayerObj = this.getPlayerWarGodData();
         return playerData.getBlockDuration();
      }
   }
}

