package codo.controllers
{
   import awesomium.MessageBoxObj;
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.CombatType;
   import codo.constants.DataID;
   import codo.constants.GlobalBottomBtnStatus;
   import codo.constants.MarketMenuData;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.PlayListType;
   import codo.constants.QuickMatchType;
   import codo.constants.RankedMatchStatus;
   import codo.constants.RoomMatchType;
   import codo.constants.SE_ID;
   import codo.constants.WebImgData;
   import codo.constants.table.UINotifications;
   import codo.cpp.UiCppMatchSelectView;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictParty;
   import codo.localization.DictRoom;
   import codo.localization.DictSystem;
   import codo.manager.PageManagerMain;
   import codo.objects.CodoPageObj;
   import codo.objects.PlayListObj;
   import codo.objects.PlaylistCategoryObj;
   import codo.objects.QuickMatchFilterObj;
   import codo.objects.WarGodSeasonEndRewardObj;
   import codo.services.MatchService;
   import codo.utils.InventoryUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.views.FsgGameModesMapRewardView;
   import codo.views.MatchSelectView;
   import com.society.comscore.DAXDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import fsg.util.FsgAudioUtil;
   
   public class MainMenuController extends BaseController
   {
      
      private static const CODO_URL_SIMPLE_PATTERN:String = "^codo://.*$";
      
      private static const CODO_URL_PATTERN:String = "^codo://(?P<action>[\\w_]*)(\\?(?P<param1>\\w*)=(?P<val1>\\w*)(&(?P<param2>\\w*)=(?P<val2>\\w*))?)?$";
      
      private static const START_PLAY_CONFIG:Array = [BCEvent.EVT_GOTO_MAIN_PVP,BCEvent.EVT_GOTO_MAIN_PVE,BCEvent.EVT_GOTO_MAIN_WARGOD,BCEvent.EVT_GOTO_MAIN_BATTLECITY];
      
      private var _currentPageID:String;
      
      private var _currentRankedMatchStatus:String;
      
      private var _currentBottomBtnStatus:uint;
      
      private var _dlcDownloadTimer:Timer;
      
      private var _isFullClient:Boolean;
      
      private var _isRealFullClient:Boolean;
      
      private var _checkWebImgAbleTimer:Timer;
      
      private var _checkAbleWebImgSlots:Array = [];
      
      private var _imgChecker:Array = [];
      
      private var _isMailNotificationReady:Boolean = false;
      
      public function MainMenuController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.DLC_IS_FULLCLIENT,this.isFullClient);
         addDP(DataID.DLC_GET_MAXDLCLEVEL,this.getMaxDLCLevel);
         addDP(DataID.DLC_GET_LEVEL,this.getDLCLevel);
         addDP(DataID.JOINABLE_ZONES,this.getJoinableZones);
         addDP(DataID.IS_IN_CROSSZONE,this.isInCrossZone);
         addDP(DataID.AD_OBJECT_COUNT,this.getAdObjectCount);
         addDP(DataID.IS_WEBIMG_LOCKED,this.getIsWebimgLocked);
         addDP(DataID.IS_RECRUITMENTBTN_LOCKED,this.getIsRecruitmentBtnLocked);
         addDP(DataID.IS_WEBIMG_READY,this.getIsWebImgReady);
         addDP(DataID.IS_MAIL_NOTIFICATION_READY,this.getIsMailNotificationReady);
         listen(BCEvent.EVT_GOTO_PLAY_MODE_SELECTION,this.onGotoPlayModeSelectionHandle);
         listen(BCEvent.EVT_GOTO_GAMEMODE_SELECTION,this.onGotoGameModeSelectionHandle);
         listen(BCEvent.EVT_GOTO_FSG_LOADOUT,this.onGotoLoadoutHandle);
         listen(BCEvent.EVT_GOTO_LOADOUT_WEAPON,this.onGotoLoadoutWeaponHandle);
         listen(BCEvent.EVT_GOTO_QUIT,this.onGotoQuitHandle);
         listen(BCEvent.EVT_GOTO_MARKET,this.onGotoMarketHandle);
         listen(BCEvent.EVT_GOTO_MARKET_COMPARE,this.onGotoMarketCompareHandle);
         listen(BCEvent.EVT_GOTO_SHOW_CLAIMREWARDS,this.onShowClaimRewards);
         listen(BCEvent.EVT_GOTO_SHOW_REWARD_POPUP,this.onShowRewardPopup);
         listen(BCEvent.EVT_SHOW_MKT_MAINTAIN_MSG,this.onShowMktMaintainMsg);
         listen(BCEvent.EVT_GOTO_CAREER,this.onGotoCareerHandle);
         listen(BCEvent.EVT_GOTO_CAREER_CHALLENGES,this.onGotoCareerAwardsHandle);
         listen(BCEvent.EVT_GOTO_LOADOUT_TAB,this.onGotoLoadoutTab);
         listen(BCEvent.EVT_GOTO_SUPPLY_DROP,this.onGotoSupplyDropSelection);
         listen(BCEvent.EVT_OPEN_MOTD_CHECKIN_REWARDS,this.onOpenCheckinRewards);
         listen(BCEvent.EVT_GOTO_SUPPLY_DROP_ITEMS_TO_WIN_POPUP,this.onOpenSupplyDropItemsToWinPopup);
         listen(BCEvent.EVT_GOTO_SUPPLY_DROP_REWARD_SELECTION,this.onGotoSupplyDropRewardSelection);
         listen(BCEvent.EVT_GOTO_SUPPLY_DROP_DEPENDENCY_POPUP,this.onGotoSupplyDropDependencyPopup);
         listen(BCEvent.EVT_GOTO_VIDEO_PLAYER_VIEW,this.onGotoVideoPlayerView);
         listen(BCEvent.EVT_CLOSE_FRIEND,this.onCloseFriend);
         listen(BCEvent.EVT_OPEN_SOCIAL_POPUP,this.onOpenSocialPopup);
         listen(BCEvent.EVT_CLOSE_MAIL,this.onCloseMail);
         listen(BCEvent.EVT_ON_MAIL_NOTIFICATION_READY,this.onMailNotificationReady);
         listen(BCEvent.EVT_ON_MAIL_NOTIFICATION_UNREADY,this.onMailNotificationUnready);
         listen(BCEvent.EVT_GOTO_ESPORTS,this.onGotoESports);
         listen(BCEvent.EVT_BOOK_WARGOD_HIDDEN_ROOM,this.onBookWarGodHiddenRoom);
         listen(BCEvent.EVT_RESET_WARGOD_HIDDEN_ROOM,this.onResetWarGodHiddenRoom);
         listen(BCEvent.EVT_BOOK_BCL_HIDDEN_ROOM,this.onBookBattleCityLeagueHiddenRoom);
         listen(BCEvent.EVT_RESET_BCL_HIDDEN_ROOM,this.onResetBattleCityLeagueHiddenRoom);
         listen(BCEvent.EVT_GOTO_ZHCRAFTING,this.onGotoZombieHunterCrafting);
         listen(BCEvent.EVT_GOTO_PRECISIONOPERATIONS,this.onGotoPrecisionOperations);
         listen(BCEvent.EVT_OPEN_MOTD_DASHBOARD,this.onOpenMOTDDashboard);
         listen(BCEvent.EVT_LOBBY_SUMMARY,this.onGotoLobbySummaryHandle);
         listen(BCEvent.EVT_GOTO_MAIN_BATTLECITY,this.onGotoMainHandle);
         listen(BCEvent.EVT_GOTO_MAIN_PVP,this.onGotoMainHandle);
         listen(BCEvent.EVT_GOTO_MAIN_PVE,this.onGotoMainHandle);
         listen(BCEvent.EVT_GOTO_MAIN_WARGOD,this.onGotoMainHandle);
         listen(BCEvent.EVT_GOTO_MATCH_SELECT,this.onGotoMatchSelect);
         listen(BCEvent.EVT_BOTTOM_START_GAME,this.onBottomStartBtnClickHandle);
         listen(BCEvent.EVT_SET_BOTTOM_START_STATUS,this.onSetBottomStartStatus);
         listen(BCEvent.EVT_MAIN_PAGE_ID_CHANGED,this.onPageIDChangedHandle);
         listen(BCEvent.RANKED_MATCH_STATUS_CHANGED,this.onRankedMatchStatusChangedHandle);
         listen(BCEvent.ON_ROOM_LEFT,this.onRoomLeftHandle);
         listen(BCEvent.TRY_OPEN_MAIL,this.onTryOpenMailHandle);
         listen(BCEvent.TRY_OPEN_FRIENDLIST,this.onTryOpenFriendListHandle);
         listen(BCEvent.EVT_CLOSE_FSG_SOCIAL,this.onCloseFsgSocial);
         listen(BCEvent.SOCIAL_EXPAND_CHANGE,this.onSocialExpandChangeHandle);
         listen(BCEvent.QT_VIDEO_STATE_CHANGE,this.onQTVideoStateChanged);
         listen(BCEvent.EVT_SHOW_MAP_REWARDS,this.onGoToMapRewardsHandle);
         listen(BCEvent.EVT_SHOW_CHARACTER_SWAP,this.onGoToCharacterSwapPopup);
         listen(BCEvent.SHOW_CHALLENGE_AWARD_POPUP,this.onGoToChallengeAwardPopup);
         this.listen(BCEvent.EVT_CLICK_PERSISTENT_VIEW_BATTLE_PASS_BTN,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_CLICK_PERSISTENT_VIEW_RAREITEMS_BTN,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_CLICK_PERSISTENT_VIEW_POINTSSTORE_BTN,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_SHOW_WARGODLADDER_INSTRUCTION,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_SHOW_BATTLECITY_INSTRUCTION,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_SHOW_BATTLECITY_LEADERBOARD,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_SHOW_JUNIOR_WARGODLADDER_INSTRUCTION,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_SHOW_WARGODLADDER_CREDIT,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_SHOW_RECHARGE,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_SHOW_CRAFTING,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_LANDING_AD1,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_LANDING_AD2,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_LANDING_AD3,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_LANDING_AD4,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_LANDING_AD5,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_MARKET_AD1,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_MARKET_AD2,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_MARKET_AD3,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_MARKET_AD4,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_MARKET_AD5,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_CLICK_SUPPLY_DROP_ITEMS_WEBPAGE,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_TRY_CLOSE_WEBIMG,this.onTryCloseWebImgHandle);
         this.listen(BCEvent.EVT_WEBPAGE_OPEN_ESPORTS,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_WEBPAGE_OPEN_ZHCRAFTING,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_WEBPAGE_OPEN_TDCRAFTING,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_WEBPAGE_OPEN_PRECISIONOPERATIONS,this.onShowWebImgHandle);
         this.listen(BCEvent.EVT_WEBPAGE_OPEN_TEAMMATE_RECRUITMENT,this.onShowWebImgHandle);
         this.addDP(DataID.IS_WEBIMG_VALID,this.getIsWebimgValid);
         addDP(DataID.IS_WEBIMG_OPEN,this.isWebImageOpen);
         this.dax_initializeData();
         this._isFullClient = CFunctionContainer.IsFullClient() as Boolean;
         this._isRealFullClient = CFunctionContainer.IsRealFullClient() as Boolean;
         this._dlcDownloadTimer = new Timer(1000);
         this._dlcDownloadTimer.addEventListener(TimerEvent.TIMER,this.dlcDownloadProgressTimer);
         this._dlcDownloadTimer.start();
         this._checkAbleWebImgSlots.push(WebImgData.LANDING_AD1,WebImgData.LANDING_AD2,WebImgData.LANDING_AD3,WebImgData.LANDING_AD4,WebImgData.LANDING_AD5,WebImgData.MARKET_AD1,WebImgData.MARKET_AD2,WebImgData.MARKET_AD3,WebImgData.MARKET_AD4,WebImgData.MARKET_AD5,WebImgData.WARGODREWARD1,WebImgData.WARGODREWARD2,WebImgData.WARGODREWARD3,WebImgData.WARGODREWARD4,WebImgData.ESPORTS,WebImgData.BATTLECITY_LEAGUE_AD,WebImgData.ZHCRAFTING_AD,WebImgData.TDCRAFTING_AD);
         for(var i:uint = 0; i < this._checkAbleWebImgSlots.length; i++)
         {
            this._imgChecker[i] = [];
         }
         this._checkWebImgAbleTimer = new Timer(1000);
         this._checkWebImgAbleTimer.addEventListener(TimerEvent.TIMER,this.onCheckWebImgTimerHandle);
         this._checkWebImgAbleTimer.start();
      }
      
      private function onCheckWebImgTimerHandle(cEvt:TimerEvent) : void
      {
         var tempCount:uint = 0;
         var j:uint = 0;
         var tempIdx:uint = 0;
         var tempIsImgReady:Boolean = false;
         var isAllImgReady:Boolean = CFunctionCommonContainer.GetAdInfoReady() as Boolean;
         var isDataChanged:Boolean = false;
         for(var i:uint = 0; i < this._imgChecker.length; i++)
         {
            tempCount = CFunctionCommonContainer.GetAdObjectCount(this._checkAbleWebImgSlots[i].id);
            if(this._imgChecker[i].length != tempCount)
            {
               this._imgChecker[i] = [];
               for(tempIdx = 0; tempIdx < tempCount; tempIdx++)
               {
                  this._imgChecker[i].push({
                     "imgData":this._checkAbleWebImgSlots[i],
                     "isReady":false
                  });
               }
            }
            for(j = 0; j < this._imgChecker[i].length; j++)
            {
               if(this._imgChecker[i][j].isReady == false)
               {
                  tempIsImgReady = CFunctionCommonContainer.IsAdImageDataReady(this._imgChecker[i][j].imgData.id,j) as Boolean;
                  if(tempIsImgReady == true)
                  {
                     this._imgChecker[i][j].isReady = tempIsImgReady;
                     isDataChanged = true;
                  }
                  else
                  {
                     isAllImgReady = false;
                  }
               }
            }
         }
         if(isAllImgReady == true)
         {
            this._checkWebImgAbleTimer.stop();
         }
         if(isDataChanged == true)
         {
            this.setBindData(DataID.WEB_IMG_STATUS,this._imgChecker);
         }
      }
      
      private function getIsWebImgReady(id:int) : Boolean
      {
         var j:int = 0;
         loop0:
         for(var i:uint = 0; i < this._imgChecker.length; )
         {
            j = 0;
            while(true)
            {
               if(j >= this._imgChecker[i].length)
               {
                  i++;
                  continue loop0;
               }
               if(this._imgChecker[i][j].imgData.id == id && Boolean(this._imgChecker[i][j].isReady))
               {
                  break;
               }
               j++;
            }
            return true;
         }
         return false;
      }
      
      private function getIsMailNotificationReady() : Boolean
      {
         return this._isMailNotificationReady;
      }
      
      private function dax_initializeData() : void
      {
         var sampleRateDvar:int = getDvarInt("dax_sample_rate");
         DAXDispatcher.daxInitialise(sampleRateDvar,true);
      }
      
      private function onSetBottomStartStatus(cEvt:ParaEvent) : void
      {
         this._currentBottomBtnStatus = cEvt.myPara;
         setBindData(DataID.CURRRENT_BOTTOM_BTN_STATUS,{
            "status":this._currentBottomBtnStatus,
            "isCyborg":false
         });
      }
      
      private function onPageIDChangedHandle(cEvt:ParaEvent) : void
      {
         this._currentPageID = cEvt.myPara.id;
         this.refreshBottomButtonStatus();
      }
      
      private function onRoomLeftHandle(cEvt:ParaEvent) : void
      {
         this.refreshBottomButtonStatus();
      }
      
      private function onRankedMatchStatusChangedHandle(cEvt:ParaEvent) : void
      {
         this._currentRankedMatchStatus = cEvt.myPara.status;
         this.refreshBottomButtonStatus();
      }
      
      private function refreshBottomButtonStatus() : void
      {
         var tempIsInRoom:Boolean = getDP(DataID.IS_IN_ROOM);
         var tempIsRankedMatch:Boolean = getDP(DataID.IS_IN_RANKED_MATCH);
         if(!CFunctionContainer.AS_IsHiddenRoomMatch() && (tempIsInRoom || tempIsRankedMatch))
         {
            switch(this._currentPageID)
            {
               case PageID.INROOM:
                  if(tempIsRankedMatch)
                  {
                     if(this._currentRankedMatchStatus == RankedMatchStatus.BACK_FROM_GAME)
                     {
                        this._currentBottomBtnStatus = GlobalBottomBtnStatus.STATUS_NOTIDLE_RANKED_INROOM;
                     }
                     else
                     {
                        this._currentBottomBtnStatus = GlobalBottomBtnStatus.STATUS_NOTIDLE_RANKED_INROOM_CANT_LEAVE;
                     }
                  }
                  break;
               default:
                  if(Boolean(getDP(DataID.IS_RANKED_MATCH_IN_PROGRESS)))
                  {
                     this._currentBottomBtnStatus = GlobalBottomBtnStatus.STATUS_NOTIDLE_RANKED_INPROGRESS;
                  }
                  else if(Boolean(getDP(DataID.IS_RANKED_MATCH_READY)))
                  {
                     this._currentBottomBtnStatus = GlobalBottomBtnStatus.STATUS_NOTIDLE_NOT_INROOM_CANT_LEAVE;
                  }
                  else
                  {
                     this._currentBottomBtnStatus = GlobalBottomBtnStatus.STATUS_NOTIDLE_NOT_INROOM;
                  }
            }
         }
         else
         {
            switch(this._currentPageID)
            {
               case PageID.HOME:
                  this._currentBottomBtnStatus = GlobalBottomBtnStatus.STATUS_IDLE_MP_LANDING;
                  break;
               case PageID.MATCH_SELECT:
                  return;
               case PageID.FSG_LOADOUT:
                  this._currentBottomBtnStatus = GlobalBottomBtnStatus.STATUS_DISABLED;
                  break;
               default:
                  this._currentBottomBtnStatus = GlobalBottomBtnStatus.STATUS_IDLE_DEFAULT;
            }
         }
         setBindData(DataID.CURRRENT_BOTTOM_BTN_STATUS,{
            "status":this._currentBottomBtnStatus,
            "isCyborg":false
         });
      }
      
      private function onGotoPlayModeSelectionHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_HOME);
      }
      
      private function onGotoGameModeSelectionHandle(cEvt:ParaEvent) : void
      {
         var onboardPvpNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_PVP]);
         if(!onboardPvpNotified)
         {
            broadcast(BCEvent.EVT_GOTO_MAIN_PVP);
            return;
         }
         var onboardPveNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_PVE]);
         if(!onboardPveNotified)
         {
            broadcast(BCEvent.EVT_GOTO_MAIN_PVE);
            return;
         }
         var onboardWarGodNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_WARGOD]);
         if(!onboardWarGodNotified)
         {
            broadcast(BCEvent.EVT_GOTO_MAIN_WARGOD);
            return;
         }
         broadcast(BCEvent.EVT_SET_MATCH_TYPE,MatchSelectView.GetDefaultMatchType());
         gotoPage(CodoPageViewDB.PAGE_MATCH_SELECT);
      }
      
      private function onGotoLoadoutHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_FSG_LOADOUT);
      }
      
      private function onGotoLoadoutWeaponHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_LOADOUT_SELECTION,cEvt.myPara);
      }
      
      private function onGotoLobbySummaryHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_ADV_FSG_MATCH_RESULT);
      }
      
      private function onGotoQuitHandle(cEvt:ParaEvent) : void
      {
         if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != CodoPageViewDB.PAGE_POPUP_FSG_SUMMARY)
         {
            gotoPage(CodoPageViewDB.PAGE_POPUP_FSG_SUMMARY);
         }
      }
      
      private function onGotoMarketHandle(cEvt:ParaEvent) : void
      {
         var params:Object = {
            "categories":null,
            "tabIndex":(cEvt.myPara != null ? cEvt.myPara.tabIndex : null),
            "subtabIndex":(cEvt.myPara != null ? cEvt.myPara.subtabIndex : null)
         };
         gotoPage(CodoPageViewDB.PAGE_MAIN_MARKET,params);
      }
      
      private function onGotoMarketCompareHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_MAIN_MARKET_COMPARE,cEvt.myPara);
      }
      
      private function onGotoCareerHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_CAREER_BATTLE_EXPERIENCE,cEvt);
      }
      
      private function onGotoCareerAwardsHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_CAREER_CHALLENGES,cEvt);
      }
      
      private function onGotoLoadoutTab(cEvt:ParaEvent) : void
      {
         var tab:int = cEvt.myPara;
         InventoryUtil.setCurrentTab(tab);
         if(getDP(DataID.CURRENT_MAIN_PAGE_ID) != PageID.FSG_LOADOUT)
         {
            gotoPage(CodoPageViewDB.PAGE_FSG_LOADOUT);
         }
      }
      
      private function onGotoESports(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.EVT_WEBPAGE_OPEN_ESPORTS);
      }
      
      private function onGotoZombieHunterCrafting(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.EVT_WEBPAGE_OPEN_ZHCRAFTING);
      }
      
      private function onGotoPrecisionOperations(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.EVT_WEBPAGE_OPEN_PRECISIONOPERATIONS);
      }
      
      private function onGotoSupplyDropSelection(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_SUPPLY_DROP);
      }
      
      private function onOpenSupplyDropItemsToWinPopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_SUPPLY_DROP_ITEMS_TO_WIN_POPUP,cEvt.myPara);
      }
      
      private function onOpenCheckinRewards(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_MOTD_CHECKIN_REWARDS);
      }
      
      private function onGotoSupplyDropRewardSelection(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_SUPPLY_DROP_REWARD_SELECTION,cEvt.myPara);
      }
      
      private function onGotoSupplyDropDependencyPopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_SUPPLY_DROP_DEPENDENCY_POPUP,cEvt.myPara);
      }
      
      private function onGotoVideoPlayerView(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_VIDEO_PLAYER,cEvt.myPara);
      }
      
      private function onOpenMOTDDashboard(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_MOTD_NOTIFICATIONS_POPUP,cEvt.myPara);
      }
      
      private function onCloseFriend(cEvt:ParaEvent) : void
      {
         prevPage();
      }
      
      private function onOpenSocialPopup(cEvt:ParaEvent) : void
      {
         var pageObj:CodoPageObj = null;
         var key:String = null;
         var id:String = cEvt.myPara;
         var popups:Object = PageID.getSocialPopups();
         for(key in popups)
         {
            pageObj = CodoPageObj.getObjByID(key);
            if(pageObj.owner.currentPageObj == pageObj && pageObj.id != id)
            {
               closePopupPage(pageObj.id);
               break;
            }
         }
         if(id != null)
         {
            pageObj = CodoPageObj.getObjByID(id);
            if(pageObj.owner.currentPageObj == pageObj)
            {
               return;
            }
            if(id == PageID.CLAN)
            {
               broadcast(BCEvent.EVT_ON_OPEN_CLAN);
            }
            gotoPage(pageObj);
         }
      }
      
      private function onCloseMail(cEvt:ParaEvent) : void
      {
         prevPage();
      }
      
      private function onMailNotificationReady(cEvt:ParaEvent) : void
      {
         this._isMailNotificationReady = true;
      }
      
      private function onMailNotificationUnready(cEvt:ParaEvent) : void
      {
         this._isMailNotificationReady = false;
      }
      
      private function onShowClaimRewards(event:ParaEvent) : void
      {
         var i:int = 0;
         var processed:Boolean = false;
         var rewards:Array = event.myPara;
         for(i = 0; i < rewards.length; i++)
         {
            if(Boolean(rewards[i].updateInventory))
            {
               broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
               break;
            }
         }
         for(i = 0; i < rewards.length; i++)
         {
            processed = false;
            if(Boolean(rewards[i].type))
            {
               if(rewards[i].type == 4)
               {
                  showRewardMsg(rewards[i]);
                  processed = true;
               }
               else if(rewards[i].type == WarGodSeasonEndRewardObj.CHALLENGE_REWARD || rewards[i].type == WarGodSeasonEndRewardObj.SEASON_END_REWARD)
               {
                  showWarGodSeasonEndRewardMsg(rewards[i]);
                  processed = true;
               }
            }
            if(!processed)
            {
               showActivityMsg(rewards[i]);
            }
         }
      }
      
      private function onShowRewardPopup(event:ParaEvent) : void
      {
         var para:Object = event.myPara;
         showRewardPopupMsg(para);
      }
      
      private function onShowMktMaintainMsg(event:ParaEvent) : void
      {
         var msg:String = null;
         var NOTIFY_NORMAL:int = 1;
         var NOTIFY_POSTPONE:int = 2;
         var NOTIFY_ADVANCE:int = 3;
         var info:Object = event.myPara;
         switch(info.notifyStatus)
         {
            case NOTIFY_NORMAL:
               msg = LocalizeUtil.param(Dict.MKT_MAINTAIN_MSG,[info.month,info.day,info.startTime,info.endTime]);
               break;
            case NOTIFY_POSTPONE:
               msg = LocalizeUtil.param(Dict.MKT_MAINTAIN_MSG_POSTPONE,[info.endTime]);
               break;
            case NOTIFY_ADVANCE:
               msg = LocalizeUtil.param(Dict.MKT_MAINTAIN_MSG_ADVANCE,[info.endTime]);
         }
         showMsg(msg,MsgBtnCount.ONE);
      }
      
      private function onGotoMainHandle(cEvt:ParaEvent) : void
      {
         switch(cEvt.type)
         {
            case BCEvent.EVT_GOTO_MAIN_PVP:
               broadcast(BCEvent.EVT_SET_MATCH_TYPE,QuickMatchType.makePvp());
               break;
            case BCEvent.EVT_GOTO_MAIN_PVE:
               broadcast(BCEvent.EVT_SET_MATCH_TYPE,MatchSelectView.GetDefaultPveType());
               break;
            case BCEvent.EVT_GOTO_MAIN_WARGOD:
               broadcast(BCEvent.EVT_SET_MATCH_TYPE,QuickMatchType.makeWarGod());
               break;
            case BCEvent.EVT_GOTO_MAIN_BATTLECITY:
               broadcast(BCEvent.EVT_SET_MATCH_TYPE,QuickMatchType.makeBattleCity());
               break;
            default:
               return;
         }
         this.onGotoMatchSelect(cEvt);
      }
      
      private function onGotoMatchSelect(cEvt:ParaEvent) : void
      {
         var matchType:QuickMatchType = getDP(DataID.CURRENT_MATCH_TYPE);
         var pageObj:CodoPageObj = CodoPageViewDB.PAGE_HOME;
         if(matchType.isPve() || matchType.isPvp() || matchType.isHeroOps() || matchType.isTheatre)
         {
            pageObj = CodoPageViewDB.PAGE_MATCH_SELECT;
         }
         var playlist:PlayListObj = cEvt.myPara != null ? cEvt.myPara.playlist : null;
         gotoPage(pageObj,playlist);
      }
      
      private function leaveParty() : void
      {
         this.broadcast(BCEvent.PARTY_LEAVE);
      }
      
      private function onBottomStartBtnClickHandle(cEvt:ParaEvent) : void
      {
         var joinRoom:Function;
         var msg:String = null;
         var playListObj:PlayListObj = null;
         var isValid:Boolean = false;
         var teamIndex:int = 0;
         var tempRoomListSelectedRoom:Object = null;
         var roomParams:Object = null;
         var mapObj:Object = null;
         var filter:QuickMatchFilterObj = null;
         var partyInfo:Object = null;
         var invalidPlayerName:String = null;
         var invalidPlayerNameCount:int = 0;
         var i:int = 0;
         var curMemberLevel:int = 0;
         var openLevelLeftInterval:int = 0;
         var openLevelRightInterval:int = 0;
         var currentMatchType:QuickMatchType = getDP(DataID.CURRENT_MATCH_TYPE);
         Logger.print("MainMenuController:::onBottomStartBtnClickHandle currentMatchType: " + currentMatchType);
         Logger.print("MainMenuController:::onBottomStartBtnClickHandle _currentBottomBtnStatus: " + this._currentBottomBtnStatus);
         if(MatchService.getInstance().isInRoom)
         {
            showMsg(DictRoom.NOTE_ALREADY_IN_RANKED_MATCH,MsgBtnCount.ONE);
            return;
         }
         broadcast(BCEvent.EVT_RESET_WARGOD_HIDDEN_ROOM);
         broadcast(BCEvent.EVT_RESET_BCL_HIDDEN_ROOM);
         switch(this._currentBottomBtnStatus)
         {
            case GlobalBottomBtnStatus.STATUS_IDLE_COOP_STAGE_CHOOSE:
               if(Boolean(this.getDP(DataID.IS_IN_PARTY)))
               {
                  msg = LocalizeUtil.localize(DictRoom.NOTE_PARTY_CANT_PLAY_COOP);
                  showMsg(msg,MsgBtnCount.TWO,0,null,DictSystem.ACCEPT,this.leaveParty,DictParty.LEAVE_PARTY);
               }
               else
               {
                  DAXDispatcher.OnMatchStart();
                  broadcast(BCEvent.EVT_QUICK_MATCH_COOP,getDP(DataID.QUICK_MATCH_COOP_DATA));
               }
               break;
            case GlobalBottomBtnStatus.STATUS_IDLE_MP_PLAYLIST_CHOOSE:
               playListObj = getDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA) as PlayListObj;
               isValid = CFunctionContainer.AS_PlayListValid(playListObj.index) as Boolean;
               if(!isValid)
               {
                  msg = LocalizeUtil.localize(DictRoom.LIST_TIMED_CLOSE_LOCKED);
                  showMsg(msg,MsgBtnCount.ONE);
                  return;
               }
               if(playListObj != null)
               {
                  Logger.print("MainMenuController:::onBottomStartBtnClickHandle:" + playListObj.unlocked);
                  if(playListObj.dlcLocked)
                  {
                     FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ERROR);
                     msg = LocalizeUtil.localize(DictSystem.DLC_LOCKED);
                     showMsg(msg,MsgBtnCount.ONE);
                     return;
                  }
                  if(!playListObj.unlocked && !playListObj.isWarGod)
                  {
                     showMsg(playListObj.unlockHint,MsgBtnCount.ONE);
                     return;
                  }
                  if(Boolean(getDP(DataID.IS_IN_PARTY)))
                  {
                     partyInfo = getDP(DataID.PARTY_INFO);
                     if(playListObj.levelRestricted && !playListObj.isWarGod)
                     {
                        invalidPlayerName = "";
                        invalidPlayerNameCount = 0;
                        for(i = 0; i < partyInfo.members.length; i++)
                        {
                           curMemberLevel = partyInfo.members[i].level + 1;
                           curMemberLevel += partyInfo.members[i].prestige * 100;
                           openLevelLeftInterval = playListObj.unlockLevelStart;
                           openLevelRightInterval = playListObj.unlockLevelEnd;
                           if(openLevelRightInterval == 70)
                           {
                              openLevelRightInterval = 2147483647;
                           }
                           if(curMemberLevel < openLevelLeftInterval || curMemberLevel > openLevelRightInterval)
                           {
                              invalidPlayerNameCount++;
                              if(invalidPlayerNameCount == 1)
                              {
                                 invalidPlayerName += partyInfo.members[i].name;
                              }
                              else if(invalidPlayerNameCount == 2)
                              {
                                 invalidPlayerName += ", " + partyInfo.members[i].name;
                              }
                              else if(invalidPlayerNameCount == 3)
                              {
                                 invalidPlayerName += "...";
                              }
                           }
                        }
                        if(invalidPlayerNameCount > 0)
                        {
                           msg = LocalizeUtil.param(DictParty.PARTY_MEMBER_UNSATISFIED_PLAYLIST_LEVEL,[invalidPlayerName]);
                           showMsg(msg,MsgBtnCount.ONE);
                           return;
                        }
                     }
                     if(playListObj.dlcLevel > 0 && partyInfo.partyDLCLevel < CFunctionContainer.GetMaxDLCLevel())
                     {
                        FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ERROR);
                        msg = LocalizeUtil.localize(DictSystem.PARTY_DLC_LOCKED);
                        showMsg(msg,MsgBtnCount.ONE);
                        return;
                     }
                  }
                  if(playListObj.index == PlayListType.SPY_PLAYLIST_ID && !CFunctionCommonContainer.AS_IsEnoughSpyKarma())
                  {
                     if(Boolean(getDP(DataID.IS_IN_PARTY)))
                     {
                        showMsg(DictSystem.PARTY_SPY_KARMA_NOT_ENOUGH,MsgBtnCount.ONE);
                     }
                     else
                     {
                        showMsg(DictSystem.SPY_KARMA_NOT_ENOUGH,MsgBtnCount.ONE);
                     }
                     return;
                  }
                  if(playListObj.isFiringRangeTraining())
                  {
                     if(Boolean(getDP(DataID.IS_IN_PARTY)))
                     {
                        broadcast(BCEvent.PARTY_LEAVE,DictParty.LEAVE_PARTY_DUE_TO_TRAINING);
                     }
                     else
                     {
                        UiCppMatchSelectView.ON_TRAINING(UiCppMatchSelectView.ENTRANCE_FROM_PLAYLIST,playListObj);
                     }
                     return;
                  }
                  if(playListObj.type == PlayListType.COMBAT && playListObj.combatTrainingType <= CombatType.CT)
                  {
                     filter = new QuickMatchFilterObj();
                     filter.type = RoomMatchType.MP;
                     filter.mode = QuickMatchFilterObj.MODE_COMBAT_TRAINING;
                     filter.league = playListObj.leagueID;
                     filter.playListID = playListObj.id;
                     filter.minPlayer = playListObj.minRoomSize;
                     filter.maxPlayer = playListObj.maxRoomSize;
                     this.tryBookIfThisIsWarGodMatch(playListObj);
                     this.tryBookIfThisIsBattleCityLeagueMatch(playListObj);
                     broadcast(BCEvent.EVT_QUICK_MATCH,{"filter":filter});
                  }
                  else if(PlayListType.isPveType(playListObj.type))
                  {
                     filter = new QuickMatchFilterObj();
                     filter.type = RoomMatchType.MP;
                     filter.mode = QuickMatchFilterObj.MODE_PLAYLIST;
                     filter.league = playListObj.leagueID;
                     filter.playListID = playListObj.id;
                     filter.minPlayer = playListObj.minRoomSize;
                     filter.maxPlayer = playListObj.maxRoomSize;
                     filter.skipLobby = playListObj.maxRoomSize == 1;
                     broadcast(BCEvent.EVT_QUICK_MATCH,{"filter":filter});
                  }
                  else
                  {
                     this.tryBookIfThisIsWarGodMatch(playListObj);
                     this.tryBookIfThisIsBattleCityLeagueMatch(playListObj);
                     broadcast(BCEvent.EVT_START_QUICK_MATCH_MP,{"data":playListObj});
                  }
               }
               break;
            case GlobalBottomBtnStatus.STATUS_IDLE_MP_TRAINING:
               playListObj = getDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA) as PlayListObj;
               if(playListObj != null)
               {
                  DAXDispatcher.OnMatchStart();
                  broadcast(BCEvent.EVT_QUICK_MATCH_TRAINING,{
                     "mode":playListObj.modes[0],
                     "league":getDP(DataID.LIST_LEAGUE)[0],
                     "map":playListObj.maps[0]
                  });
               }
               break;
            case GlobalBottomBtnStatus.STATUS_IDLE_MP_ROOM_JOIN:
            case GlobalBottomBtnStatus.STATUS_IDLE_COOP_ROOM_JOIN:
            case GlobalBottomBtnStatus.STATUS_IDLE_CYBORG_ROOM_JOIN:
               teamIndex = cEvt.myPara as int;
               tempRoomListSelectedRoom = getDP(DataID.MATCH_ROOMLIST_SELECTED_ROOM);
               if(tempRoomListSelectedRoom != null && tempRoomListSelectedRoom.selectedDataIndex != -1)
               {
                  joinRoom = function():void
                  {
                     DAXDispatcher.OnMatchStart();
                     broadcast(BCEvent.TRY_JOIN_ROOM,{
                        "room":tempRoomListSelectedRoom,
                        "ticket":false,
                        "teamSpecified":teamIndex
                     });
                  };
                  if(getDP(DataID.DLC_GET_LEVEL) > tempRoomListSelectedRoom.roomDLCLevel)
                  {
                     showMsg(DictRoom.ONENTER_LOWERDLC_ROOM,MsgBtnCount.TWO,0,joinRoom);
                  }
                  else if(tempRoomListSelectedRoom.currentMatchMode.id == "spy" && !CFunctionCommonContainer.AS_IsEnoughSpyKarma())
                  {
                     showMsg(DictSystem.SPY_KARMA_NOT_ENOUGH,MsgBtnCount.ONE);
                  }
                  else
                  {
                     joinRoom();
                  }
               }
               break;
            case GlobalBottomBtnStatus.STATUS_IDLE_MP_ROOM_CREATOR:
               roomParams = getDP(DataID.MATCH_MPCT_ROOMCREATOR_PARAMS);
               mapObj = getDP(DataID.MAP_OBJ,[roomParams.room.map]);
               if(Boolean(getDP(DataID.IS_UNAVAILABLE_MINICLIENT_MODE,[roomParams.room.mode])) && !this.isFullClient())
               {
                  showMsg(DictRoom.CREATE_ROOM_NODLC_ERROR,MsgBtnCount.ONE);
               }
               else if(mapObj == null || !mapObj.unlocked)
               {
                  Logger.print("Unhandled exception when create room with mode " + roomParams.room.mode);
               }
               else if(roomParams.room.mode == "spy" && !CFunctionCommonContainer.AS_IsEnoughSpyKarma())
               {
                  if(Boolean(getDP(DataID.IS_IN_PARTY)))
                  {
                     showMsg(DictSystem.PARTY_SPY_KARMA_NOT_ENOUGH,MsgBtnCount.ONE);
                  }
                  else
                  {
                     showMsg(DictSystem.SPY_KARMA_NOT_ENOUGH,MsgBtnCount.ONE);
                  }
               }
               else
               {
                  broadcast(BCEvent.EVT_SET_MATCH_TYPE,roomParams.type);
                  switch(roomParams.room.mode)
                  {
                     case "combat":
                        broadcast(BCEvent.EVT_QUICK_MATCH,{"filter":roomParams.room});
                        break;
                     default:
                        broadcast(BCEvent.EVT_CREATE_ROOM,roomParams.room);
                  }
               }
               break;
            case GlobalBottomBtnStatus.STATUS_NOTIDLE_RANKED_INPROGRESS:
               broadcast(BCEvent.LEAVE_ROOM);
               break;
            case GlobalBottomBtnStatus.STATUS_NOTIDLE_NOT_INROOM:
            case GlobalBottomBtnStatus.STATUS_NOTIDLE_NOT_INROOM_CANT_LEAVE:
               this.backToRoom();
               break;
            default:
               Logger.print("onBottomStartBtnClickHandle reached with invalid _currentBottomBtnStatus, bad!");
         }
      }
      
      private function tryBookIfThisIsWarGodMatch(pl:PlayListObj) : void
      {
         if(Boolean(pl.isWarGod))
         {
            broadcast(BCEvent.EVT_BOOK_WARGOD_HIDDEN_ROOM,pl.index);
            pl.isWarGod = false;
         }
      }
      
      private function tryBookIfThisIsBattleCityLeagueMatch(pl:PlayListObj) : void
      {
         broadcast(BCEvent.EVT_BOOK_BCL_HIDDEN_ROOM,pl.index);
      }
      
      private function backToRoom() : void
      {
         broadcast(BCEvent.EVT_BACK_TO_ROOM);
      }
      
      private function onTryOpenMailHandle(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.SHOW_MAIL);
         if(this.getDvarBool("ui_fsg_mail") == true)
         {
         }
      }
      
      private function onTryOpenFriendListHandle(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.SHOW_FRIENDLIST);
         if(ScaleformUtil.isFsgFriendslistEnabled() == true)
         {
         }
      }
      
      private function onSocialExpandChangeHandle(cEvt:ParaEvent) : void
      {
         if(CodoPageViewDB.PAGE_LAYER_SYS_MSG.currentPageObj != null)
         {
            PageManagerMain.getInstance().showMask(false);
         }
         else
         {
            PageManagerMain.getInstance().showMask(true);
         }
      }
      
      private function onQTVideoStateChanged(cEvt:ParaEvent) : void
      {
         var qtVideoOpened:Boolean = cEvt.myPara;
         if(qtVideoOpened)
         {
            gotoPage(CodoPageViewDB.PAGE_POPUP_FSG_QVIDEO);
         }
         else
         {
            prevPage();
         }
      }
      
      private function onCloseFsgSocial(cEvt:ParaEvent) : void
      {
         prevPage();
      }
      
      private function onGoToMapRewardsHandle(cEvt:ParaEvent) : void
      {
         FsgGameModesMapRewardView.InitialTab = cEvt != null && cEvt.myPara != null ? int(cEvt.myPara.index) : 0;
         gotoPage(CodoPageViewDB.PAGE_POPUP_MAP_SPECIFIC_REWARDS);
      }
      
      private function onGoToCharacterSwapPopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_CHARACTER_SWAP,cEvt.myPara as int);
      }
      
      private function onGoToChallengeAwardPopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_CHALLENGE_AWARD,cEvt.myPara as Object);
      }
      
      private function isFullClient() : Boolean
      {
         return CFunctionContainer.IsFullClient() as Boolean;
      }
      
      private function getMaxDLCLevel() : uint
      {
         return CFunctionContainer.GetMaxDLCLevel() as uint;
      }
      
      private function getDLCLevel() : uint
      {
         return CFunctionContainer.GetCurrentDLCLevel() as uint;
      }
      
      private function getJoinableZones() : int
      {
         return CFunctionCommonContainer.AS_GetJoinableZones() as int;
      }
      
      private function isInCrossZone() : Boolean
      {
         return CFunctionCommonContainer.AS_IsInCrossZone() as Boolean;
      }
      
      private function dlcDownloadProgressTimer(e:TimerEvent) : void
      {
         var title:String = null;
         if(!this._isFullClient && Boolean(CFunctionContainer.IsFullClient()))
         {
            this._isFullClient = true;
            showMsg(Dict.DLC_MAP_DOWNLOADED_FINISHED,MsgBtnCount.ONE);
            broadcast(BCEvent.EVT_FULLCLIENT_DOWNLOADED);
         }
         if(!this._isRealFullClient && Boolean(CFunctionContainer.IsRealFullClient()))
         {
            this._isRealFullClient = true;
            showMsg(Dict.DLC_DOWNLOAD_FINISHED,MsgBtnCount.ONE);
            broadcast(BCEvent.EVT_FULLCLIENT_DOWNLOADED);
         }
         if(CFunctionContainer.GetHighResProgress() != 1)
         {
            title = LocalizeUtil.localize(Dict.DLC_CONTENT_HIGHRES);
         }
         else
         {
            title = LocalizeUtil.localize(Dict.DLC_CONTENT_MAP);
         }
         var percent:Number = CFunctionContainer.GetDLCDownloadProgress();
         var remainTime:Number = CFunctionContainer.GetDLCDownloadRemainTime();
         var visible:Boolean = !this._isRealFullClient;
         var miniclient:Boolean = !this.isFullClient();
         this.setBindData(DataID.DLC_INFO,{
            "percent":percent,
            "remainTime":remainTime,
            "visible":visible,
            "title":title,
            "miniclient":miniclient
         });
      }
      
      private function onShowWebImgHandle(cEvt:ParaEvent) : void
      {
         var tempWebImgDat:Object = null;
         var tempImgIndex:uint = 0;
         var ret:Object = null;
         if(this.getIsWebimgLocked() == false)
         {
            tempImgIndex = 0;
            switch(cEvt.type)
            {
               case BCEvent.EVT_CLICK_PERSISTENT_VIEW_BATTLE_PASS_BTN:
                  tempWebImgDat = WebImgData.BATTLE_PASS;
                  break;
               case BCEvent.EVT_CLICK_PERSISTENT_VIEW_RAREITEMS_BTN:
                  tempWebImgDat = WebImgData.RAREITEMS;
                  break;
               case BCEvent.EVT_CLICK_PERSISTENT_VIEW_POINTSSTORE_BTN:
                  tempWebImgDat = WebImgData.POINTSSTORE;
                  break;
               case BCEvent.EVT_SHOW_JUNIOR_WARGODLADDER_INSTRUCTION:
                  tempWebImgDat = WebImgData.WARGODLADDER1;
                  break;
               case BCEvent.EVT_SHOW_WARGODLADDER_INSTRUCTION:
                  tempWebImgDat = WebImgData.WARGODLADDER2;
                  break;
               case BCEvent.EVT_SHOW_WARGODLADDER_CREDIT:
                  tempWebImgDat = WebImgData.WARGODCREDIT;
                  break;
               case BCEvent.EVT_SHOW_BATTLECITY_INSTRUCTION:
                  tempWebImgDat = WebImgData.BATTLECITY;
                  break;
               case BCEvent.EVT_SHOW_BATTLECITY_LEADERBOARD:
                  tempWebImgDat = WebImgData.BATTLECITY_LEADER_BOARD;
                  break;
               case BCEvent.EVT_SHOW_RECHARGE:
                  tempWebImgDat = WebImgData.RECHARGE;
                  this.comScoreLogging("action_type","add_currency");
                  break;
               case BCEvent.EVT_SHOW_CRAFTING:
                  tempWebImgDat = WebImgData.CRAFTING;
                  break;
               case BCEvent.EVT_LANDING_AD1:
                  tempWebImgDat = WebImgData.LANDING_AD1;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_LANDING_AD2:
                  tempWebImgDat = WebImgData.LANDING_AD2;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_LANDING_AD3:
                  tempWebImgDat = WebImgData.LANDING_AD3;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_LANDING_AD4:
                  tempWebImgDat = WebImgData.LANDING_AD4;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_LANDING_AD5:
                  tempWebImgDat = WebImgData.LANDING_AD5;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_MARKET_AD1:
                  tempWebImgDat = WebImgData.MARKET_AD1;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_MARKET_AD2:
                  tempWebImgDat = WebImgData.MARKET_AD2;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_MARKET_AD3:
                  tempWebImgDat = WebImgData.MARKET_AD3;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_MARKET_AD4:
                  tempWebImgDat = WebImgData.MARKET_AD4;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_MARKET_AD5:
                  tempWebImgDat = WebImgData.MARKET_AD5;
                  this.comScoreLogging("action_type","ad_click");
                  break;
               case BCEvent.EVT_CLICK_SUPPLY_DROP_ITEMS_WEBPAGE:
                  tempWebImgDat = WebImgData.SUPPLY_DROP_ITEMS;
                  break;
               case BCEvent.EVT_WEBPAGE_OPEN_ESPORTS:
                  tempWebImgDat = WebImgData.ESPORTS;
                  break;
               case BCEvent.EVT_WEBPAGE_OPEN_PRECISIONOPERATIONS:
                  tempWebImgDat = WebImgData.PRECISION_OPERATIONS;
                  break;
               case BCEvent.EVT_WEBPAGE_OPEN_ZHCRAFTING:
                  tempWebImgDat = WebImgData.ZHCRAFTING_AD;
                  break;
               case BCEvent.EVT_WEBPAGE_OPEN_TEAMMATE_RECRUITMENT:
                  tempWebImgDat = WebImgData.TEAMMATE_RECRUITMENT;
                  break;
               case BCEvent.EVT_WEBPAGE_OPEN_TDCRAFTING:
                  tempWebImgDat = WebImgData.TDCRAFTING_AD;
            }
            if(tempWebImgDat != null)
            {
               if(cEvt.myPara != null && cEvt.myPara.index != null)
               {
                  tempImgIndex = uint(cEvt.myPara.index);
               }
               if(CFunctionCommonContainer.IsUrlValid(tempWebImgDat.id,tempImgIndex) == true)
               {
                  if(tempWebImgDat.id != WebImgData.WELCOME.id || !CFunctionCommonContainer.IsWelcomePageShowed())
                  {
                     ret = CFunctionCommonContainer.OpenWebPage(tempWebImgDat.id,tempImgIndex,tempWebImgDat.x,tempWebImgDat.y,tempWebImgDat.width,tempWebImgDat.height);
                     if(ret.succeed == true)
                     {
                        this.broadcast(BCEvent.EVT_SHOW_WEBIMG_CONTAINER,{
                           "data":tempWebImgDat,
                           "hideTitle":ret.hideTitle
                        });
                     }
                  }
               }
            }
         }
      }
      
      private function comScoreLogging(action:String, value:String) : void
      {
         try
         {
            DAXDispatcher.queue(action,value);
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("** DAXDispatcher: " + e.message);
         }
      }
      
      private function onTryCloseWebImgHandle(cEvt:ParaEvent) : void
      {
         if(!this.isWebImageOpen())
         {
            return;
         }
         CFunctionCommonContainer.CloseCurrentWebPage();
         this.broadcast(BCEvent.EVT_HIDE_WEBIMG_CONTAINER);
      }
      
      private function getIsWebimgLocked() : Boolean
      {
         return this.getDvarBool("ui_lockWeb") as Boolean;
      }
      
      private function getIsRecruitmentBtnLocked() : Boolean
      {
         return this.getDvarBool("ui_lockRecruitmentBtn") as Boolean;
      }
      
      private function getIsWebimgValid(cWebimgDat:Object, cIndex:uint) : Boolean
      {
         return CFunctionCommonContainer.IsUrlValid(cWebimgDat.id,cIndex) as Boolean;
      }
      
      private function isWebImageOpen() : Boolean
      {
         var page:CodoPageObj = CodoPageViewDB.PAGE_LAYER_WEBIMG.currentPageObj;
         return page == null ? false : Boolean(page.views[0].instance.visible);
      }
      
      public function cppQuitGameConfimation() : void
      {
         this.broadcast(BCEvent.EVT_TRY_CLOSE_WEBIMG);
         this.broadcast(BCEvent.TRYOPEN_QUESTIONNAIRE);
      }
      
      public function cppWebPageInputStart() : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_INPUT_START);
      }
      
      public function cppWebPageInputUpdatePosition(x:int, y:int) : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_INPUT_POSCHANGE,{
            "x":x,
            "y":y
         });
      }
      
      public function cppWebPageInputEnd() : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_INPUT_END);
      }
      
      public function cppWebPageInputComposite() : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_INPUT_COMPOSITE);
      }
      
      public function cppWebPageInputFocusChanged(focused:Boolean) : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_INPUT_FOCUSCHANGE,{"focused":focused});
      }
      
      public function cppWebPageTitleChanged(title:String) : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_TITLE_CHANGE,{"title":title});
      }
      
      public function cppWebPageAddressChanged(url:String) : void
      {
         if(this.isCODOInGameUrl(url))
         {
            if(!this.processInGameUrlRequest(url))
            {
               Logger.print("MainMenuController::cppWebPageAddressChanged Failed process InGame url:" + url);
            }
            this.broadcast(BCEvent.EVT_WEBPAGE_OPEN_INGAME_URL,{"url":url});
         }
         else
         {
            this.broadcast(BCEvent.EVT_WEBPAGE_URL_CHANGE,{"url":url});
         }
      }
      
      public function cppWebPageLoadingStatus(loading:Boolean) : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_LOADING,{"loading":loading});
      }
      
      private function getAdObjectCount(cSlotID:int) : uint
      {
         return CFunctionCommonContainer.GetAdObjectCount(cSlotID);
      }
      
      public function cppOpenWebPageContextMenu(posX:int, posY:int, data:Array, selected:int, itemHeight:int, itemWidth:int, fontSize:Number) : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_OPEN_DROP_DOWN_MENU,{
            "posX":posX,
            "posY":posY,
            "height":itemHeight,
            "width":itemWidth,
            "fontSize":fontSize,
            "data":data,
            "selected":selected
         });
      }
      
      public function cppCloseWebPageContextMenu() : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_CLOSE_DROP_DOWN_MENU);
      }
      
      public function cppOpenWebPageMessageBox(obj:MessageBoxObj) : void
      {
         this.broadcast(BCEvent.EVT_WEBPAGE_OPEN_MESSAGE_BOX,obj);
      }
      
      public function cppOnRemoteImageDownloadComplete(url:String, isSuccess:Boolean) : void
      {
         this.broadcast(BCEvent.EVT_DOWNLOAD_MOTD_IMAGE_COMPLETE,{
            "url":url,
            "success":isSuccess
         });
      }
      
      public function cppOnCrossMatchMakingNetworkBecomeWorse(isParty:Boolean, ticket:String) : void
      {
         var doLeave:Function = null;
         doLeave = function():void
         {
            if(isParty)
            {
               request(DataID.LEAVE_PARTY);
            }
            else
            {
               broadcast(BCEvent.LEAVE_ROOM);
            }
         };
         if(getDP(DataID.ACCEPTED_HIGH_LATENCY_TICKET) == ticket)
         {
            return;
         }
         if(isParty)
         {
            showMsg(DictParty.PARTY_JOINED_CROSS_ZONE_WARNING,MsgBtnCount.TWO,0,doLeave,DictParty.LEAVE_PARTY,null,DictSystem.STAY);
         }
         else
         {
            showMsg(DictParty.ROOM_JOINED_CROSS_ZONE_WARNING,MsgBtnCount.TWO,0,doLeave,DictRoom.LEAVE_ROOM,null,DictSystem.STAY);
         }
      }
      
      private function isCODOInGameUrl(url:String) : Boolean
      {
         var simpleInGameUrlPattern:RegExp = new RegExp(CODO_URL_SIMPLE_PATTERN,"gi");
         return simpleInGameUrlPattern.test(url.toLowerCase());
      }
      
      private function parseCODOInGameUrl(url:String) : Object
      {
         var CODOUrlRE:RegExp = new RegExp(CODO_URL_PATTERN,"gi");
         var result:Array = CODOUrlRE.exec(url);
         if(result != null)
         {
            if(result.param1 != null)
            {
               result[result.param1] = result.val1;
            }
            if(result.param2 != null)
            {
               result[result.param2] = result.val2;
            }
         }
         return result;
      }
      
      private function processInGameUrlRequest(url:String) : Boolean
      {
         var processed:Boolean = false;
         var request:Object = this.parseCODOInGameUrl(url);
         if(request != null)
         {
            switch(request.action)
            {
               case "goto_page":
                  processed = this.processCODOUrlGotoPageRequest(request);
                  break;
               case "goto_playlist":
                  processed = this.processCODOUrlGotoPlaylistRequest(request);
            }
         }
         return processed;
      }
      
      private function processCODOUrlGotoPageRequest(request:Object) : Boolean
      {
         var processed:Boolean = false;
         if(request.page != null)
         {
            switch(request.page)
            {
               case "supplydrop":
                  gotoPage(CodoPageViewDB.PAGE_SUPPLY_DROP);
                  processed = true;
                  break;
               case "marketplace":
                  if(request.subpage == "wargod")
                  {
                     gotoPage(CodoPageViewDB.PAGE_MAIN_MARKET,{
                        "categories":null,
                        "tabIndex":MarketMenuData.TAB_WARGOD
                     });
                  }
                  else
                  {
                     gotoPage(CodoPageViewDB.PAGE_MAIN_MARKET,{
                        "categories":null,
                        "tabIndex":MarketMenuData.TAB_FEATURED
                     });
                  }
                  processed = true;
                  break;
               case "wargod":
                  broadcast(BCEvent.EVT_GOTO_MAIN_WARGOD);
                  processed = true;
            }
         }
         return processed;
      }
      
      private function processCODOUrlGotoPlaylistRequest(request:Object) : Boolean
      {
         var playlistNum:int = 0;
         var categoryObj:PlaylistCategoryObj = null;
         var playlistObj:PlayListObj = null;
         if(request.id != null)
         {
            playlistNum = CFunctionContainer.AS_GetPlayListNumForId(int(request.id));
            playlistObj = MatchService.getInstance().getPlayListObj(playlistNum);
         }
         else if(request.category != null)
         {
            categoryObj = CFunctionContainer.AS_GetPlayListCategoryByID(int(request.category));
            if(categoryObj != null && categoryObj.entries.length > 0)
            {
               playlistNum = CFunctionContainer.AS_GetPlayListNumForId(categoryObj.cycleTodayIndex >= 0 ? categoryObj.entries[categoryObj.cycleTodayIndex] : categoryObj.entries[0]);
               playlistObj = MatchService.getInstance().getPlayListObj(playlistNum);
            }
         }
         if(playlistObj != null)
         {
            broadcast(playlistObj.getGotoMatchMainPageEvent(),{"playlist":playlistObj});
            return true;
         }
         return false;
      }
      
      private function onBookWarGodHiddenRoom(evt:ParaEvent) : void
      {
         if(!getDP(DataID.IS_IN_PARTY) || Boolean(getDP(DataID.IS_PARTY_HOST)))
         {
            CFunctionContainer.AS_BookThisIsWarGodMatch(evt.myPara);
         }
      }
      
      private function onResetWarGodHiddenRoom(e:ParaEvent) : void
      {
         if(!getDP(DataID.IS_IN_PARTY) || Boolean(getDP(DataID.IS_PARTY_HOST)))
         {
            CFunctionContainer.AS_ResetBookedWarGodRoom();
         }
      }
      
      private function onBookBattleCityLeagueHiddenRoom(evt:ParaEvent) : void
      {
         if(!getDP(DataID.IS_IN_PARTY) || Boolean(getDP(DataID.IS_PARTY_HOST)))
         {
            CFunctionContainer.AS_TryBookDMZLeagueMatch(evt.myPara);
         }
      }
      
      private function onResetBattleCityLeagueHiddenRoom(e:ParaEvent) : void
      {
         if(!getDP(DataID.IS_IN_PARTY) || Boolean(getDP(DataID.IS_PARTY_HOST)))
         {
            CFunctionContainer.AS_ResetBookedDMZLeagueMatch();
         }
      }
   }
}

