package codo.views
{
   import codo.base.BaseView;
   import codo.component.career.ChallengeChecklist;
   import codo.component.home.HomeAdSlideShow;
   import codo.component.home.HomePlayModeButton;
   import codo.component.home.WarGodPlayModeButton;
   import codo.component.home.WarGodShortCut;
   import codo.component.onboarding.OnboardingChallengeChecklist;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.QuickMatchType;
   import codo.constants.WebImgData;
   import codo.event.ParaEvent;
   import codo.localization.DictGameModeSummaryPopup;
   import codo.localization.DictSetting;
   import codo.localization.DictSystem;
   import codo.objects.FeaturedAdObj;
   import codo.objects.PlayListObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.objects.WebAdObj;
   import codo.services.ChallengeService;
   import codo.theme.ITheme;
   import codo.utils.LocalizeUtil;
   import codo.utils.TLogUtil;
   
   public class HomeView extends BaseView
   {
      
      private static const MAX_FEATURED_GAMEMODES:uint = 2;
      
      public var myFeaturedSlideShow:HomeAdSlideShow;
      
      public var myAdSlideShow0:HomeAdSlideShow;
      
      public var myAdSlideShow1:HomeAdSlideShow;
      
      public var myAdSlideShow2:HomeAdSlideShow;
      
      public var myAdSlideShow3:HomeAdSlideShow;
      
      public var myChallengeChecklist:ChallengeChecklist;
      
      public var myBattleCityButton:HomePlayModeButton;
      
      public var myPVPButton:HomePlayModeButton;
      
      public var myPVEButton:HomePlayModeButton;
      
      public var myWarGodButton:WarGodPlayModeButton;
      
      public var myChecklistPanel:OnboardingChallengeChecklist;
      
      public var myWarGodShortCut:WarGodShortCut;
      
      private var mInitialized:Boolean = false;
      
      public function HomeView()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myBattleCityButton.label = LocalizeUtil.localize(DictGameModeSummaryPopup.GAMEMODE_SUMMARY_POPUP_BATTLECITY_TITLE);
         this.myPVEButton.label = LocalizeUtil.localize(DictGameModeSummaryPopup.GAMEMODE_SUMMARY_POPUP_PVE_TITLE);
         this.myPVPButton.label = LocalizeUtil.localize(DictGameModeSummaryPopup.GAMEMODE_SUMMARY_POPUP_PVP_TITLE);
         this.myWarGodButton.label = LocalizeUtil.localize(DictGameModeSummaryPopup.GAMEMODE_SUMMARY_POPUP_WARGOD_TITLE);
         this.myBattleCityButton.registerClickEvent(this.onBattleCityClicked);
         this.myPVEButton.registerClickEvent(this.onPveClicked);
         this.myPVPButton.registerClickEvent(this.onPvpClicked);
         this.myWarGodButton.registerClickEvent(this.onWarGodClicked);
         this.myWarGodShortCut.registerClickEvent(this.onWarGodClicked);
         this.myChecklistPanel.useSmallRenderer = true;
      }
      
      override protected function initTheme() : void
      {
         super.initTheme();
         var themeSuite:ITheme = getDP(DataID.GET_THEME_SUITE);
         this.myFeaturedSlideShow.setStrokeColor(themeSuite.getThemeColor());
         this.myAdSlideShow0.setStrokeColor(themeSuite.getThemeColor());
         this.myAdSlideShow1.setStrokeColor(themeSuite.getThemeColor());
         this.myAdSlideShow2.setStrokeColor(themeSuite.getThemeColor());
         this.myAdSlideShow3.setStrokeColor(themeSuite.getThemeColor());
      }
      
      override protected function showView() : void
      {
         if(!this.mInitialized)
         {
            this.mInitialized = true;
            if(getDP(DataID.IS_WEBIMG_OPEN) == true)
            {
               listen(BCEvent.EVT_TRY_CLOSE_WEBIMG,this.onCloseWebImg);
               return;
            }
         }
         super.showView();
         listen(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
         this.refreshChallenges();
         if(!getDP(DataID.VITAL_COMMANDS_BOUNDED,[false]))
         {
            showMsg(DictSetting.NOTE_KEYS_UNBOUNDED,MsgBtnCount.ONE,0,this.onKeysUnbound,DictSystem.CONFIRM);
         }
         bind(DataID.WEB_IMG_STATUS,this.bind_webImgStatus);
         this.onGetPlayerWarGodData(getDP(DataID.PLAYER_WARGOD_DATA));
         this.myFeaturedSlideShow.startTimer();
         this.myAdSlideShow0.startTimer();
         this.myAdSlideShow1.startTimer();
         this.myAdSlideShow2.startTimer();
         this.myAdSlideShow3.startTimer();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myFeaturedSlideShow.stopTimer();
         this.myAdSlideShow0.stopTimer();
         this.myAdSlideShow1.stopTimer();
         this.myAdSlideShow2.stopTimer();
         this.myAdSlideShow3.stopTimer();
         unlisten(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
      }
      
      public function getFeaturedGamemodes() : Vector.<FeaturedAdObj>
      {
         var item:FeaturedAdObj = null;
         var playlists:Array = DataManager.getDP(DataID.LIST_PLAY_LIST_HOMEPAGE_AD);
         var playlistData:Vector.<FeaturedAdObj> = new Vector.<FeaturedAdObj>();
         for(var i:int = 0; i < playlists.length; i++)
         {
            item = new FeaturedAdObj("codo.shared.home.homeGameModeAd",playlists[i]);
            playlistData.push(item);
            if(i + 1 == MAX_FEATURED_GAMEMODES)
            {
               break;
            }
         }
         return playlistData;
      }
      
      private function bind_webImgStatus(cResult:Object) : void
      {
         var isAllImgReady:Boolean = false;
         var j:uint = 0;
         var images:Array = null;
         var imageVec:Vector.<FeaturedAdObj> = null;
         var featuredModes:Vector.<FeaturedAdObj> = null;
         var playlist:PlayListObj = null;
         var iAd:uint = 0;
         var imgCheckerData:Array = cResult.data;
         for(var i:uint = 0; i < imgCheckerData.length; i++)
         {
            if(imgCheckerData[i] == null)
            {
               continue;
            }
            isAllImgReady = true;
            for(j = 0; j < imgCheckerData[i].length; j++)
            {
               if(imgCheckerData[i][j].isReady == false)
               {
                  isAllImgReady = false;
                  break;
               }
            }
            if(!(isAllImgReady == true && imgCheckerData[i].length > 0))
            {
               continue;
            }
            switch(imgCheckerData[i][0].imgData.id)
            {
               case WebImgData.LANDING_AD1.id:
                  images = WebImgData.getWebImgURLs(WebImgData.LANDING_AD1.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oFeaturedAdClicked,"codo.shared.home.homeWebAdSlide");
                  featuredModes = this.getFeaturedGamemodes();
                  for(iAd = 0; iAd < featuredModes.length; iAd++)
                  {
                     playlist = featuredModes[iAd].itemData as PlayListObj;
                     if(playlist.homepageAdSlot > imageVec.length)
                     {
                        imageVec.push(featuredModes[iAd]);
                     }
                     else
                     {
                        imageVec.splice(playlist.homepageAdSlot - 1,0,featuredModes[iAd]);
                     }
                  }
                  this.myFeaturedSlideShow.setData(imageVec);
                  break;
               case WebImgData.LANDING_AD2.id:
                  images = WebImgData.getWebImgURLs(WebImgData.LANDING_AD2.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oAd0Clicked,"codo.shared.home.homeWebAdSlideSmall");
                  this.myAdSlideShow0.setData(imageVec);
                  break;
               case WebImgData.LANDING_AD3.id:
                  images = WebImgData.getWebImgURLs(WebImgData.LANDING_AD3.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oAd1Clicked,"codo.shared.home.homeWebAdSlideSmall");
                  this.myAdSlideShow1.setData(imageVec);
                  break;
               case WebImgData.LANDING_AD4.id:
                  images = WebImgData.getWebImgURLs(WebImgData.LANDING_AD4.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oAd2Clicked,"codo.shared.home.homeWebAdSlideSmall");
                  this.myAdSlideShow2.setData(imageVec);
                  break;
               case WebImgData.LANDING_AD5.id:
                  images = WebImgData.getWebImgURLs(WebImgData.LANDING_AD5.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oAd3Clicked,"codo.shared.home.homeWebAdSlideSmall");
                  this.myAdSlideShow3.setData(imageVec);
            }
         }
      }
      
      private function getFeaturedAdListFromWebImgs(data:Array, callback:Function, linkage:String) : Vector.<FeaturedAdObj>
      {
         var featuredItem:FeaturedAdObj = null;
         var webAd:WebAdObj = null;
         var vec:Vector.<FeaturedAdObj> = new Vector.<FeaturedAdObj>();
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            webAd = new WebAdObj(data[i],callback);
            featuredItem = new FeaturedAdObj(linkage,webAd);
            featuredItem.webSlot = i;
            vec.push(featuredItem);
         }
         return vec;
      }
      
      private function DoTLogByMatchType() : void
      {
         var tlogBtn:int = 0;
         var curMatchType:QuickMatchType = this.getDP(DataID.CURRENT_MATCH_TYPE);
         if(curMatchType.isSurvival())
         {
            tlogBtn = int(ButtonTLog.BUTTON_GAMEMODE_SURVIVAL);
         }
         else if(curMatchType.isCyborgs())
         {
            tlogBtn = int(ButtonTLog.BUTTON_GAMEMODE_CYBORG);
         }
         else
         {
            if(!curMatchType.isPvp())
            {
               return;
            }
            tlogBtn = int(ButtonTLog.BUTTON_GAMEMODE_MP);
         }
         TLogUtil.TLog_UserInput(tlogBtn);
      }
      
      private function onKeysUnbound() : void
      {
         broadcast(BCEvent.EVT_GOTO_OPTION);
      }
      
      private function refreshChallenges() : void
      {
         if(!ChallengeService.getInstance().showOnboardingChecklist)
         {
            this.myChallengeChecklist.setData(ChallengeService.getInstance().GetChallengeChecklist(),true);
            this.myChallengeChecklist.visible = true;
            this.myChecklistPanel.visible = false;
         }
         else
         {
            this.myChecklistPanel.setData(ChallengeService.getInstance().GetOnboardingChecklist(),true);
            this.myChallengeChecklist.visible = false;
            this.myChecklistPanel.visible = true;
         }
      }
      
      private function onCloseWebImg(e:ParaEvent) : void
      {
         unlisten(BCEvent.EVT_TRY_CLOSE_WEBIMG,this.onCloseWebImg);
         this.showView();
      }
      
      private function onBattleCityClicked() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_BATTLECITY);
         broadcast(BCEvent.EVT_GOTO_MAIN_BATTLECITY);
      }
      
      private function onPveClicked() : void
      {
         broadcast(BCEvent.EVT_GOTO_MAIN_PVE);
         this.DoTLogByMatchType();
      }
      
      private function onPvpClicked() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_MP);
         broadcast(BCEvent.EVT_GOTO_MAIN_PVP);
      }
      
      private function onWarGodClicked() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_WARGOD);
         broadcast(BCEvent.EVT_GOTO_MAIN_WARGOD);
      }
      
      private function oFeaturedAdClicked() : void
      {
         broadcast(BCEvent.EVT_LANDING_AD1,{"index":this.myFeaturedSlideShow.getData()[this.myFeaturedSlideShow.currentPage].webSlot});
      }
      
      private function oAd0Clicked() : void
      {
         broadcast(BCEvent.EVT_LANDING_AD2,{"index":this.myAdSlideShow0.currentPage});
      }
      
      private function oAd1Clicked() : void
      {
         broadcast(BCEvent.EVT_LANDING_AD3,{"index":this.myAdSlideShow1.currentPage});
      }
      
      private function oAd2Clicked() : void
      {
         broadcast(BCEvent.EVT_LANDING_AD4,{"index":this.myAdSlideShow2.currentPage});
      }
      
      private function oAd3Clicked() : void
      {
         broadcast(BCEvent.EVT_LANDING_AD5,{"index":this.myAdSlideShow3.currentPage});
      }
      
      private function onGetPlayerWarGodData(playerWarGodData:WarGodPlayerObj) : void
      {
         var seasonData:WarGodSeasonObj = getDP(DataID.CURRENT_WARGOD_INFO);
         var wargodSetting:WarGodGlobalSettingObj = getDP(DataID.WARGOD_GLOBAL_SETTING);
         var currentTimeStamp:int = getDP(DataID.GET_SERVER_TIME_STAMP);
         var isSeasonOpen:Boolean = currentTimeStamp >= seasonData.startTimeStamp && currentTimeStamp <= seasonData.endTimeStamp;
         isSeasonOpen &&= !getDP(DataID.WARGOD_IS_LOCKED);
         this.myWarGodButton.switchWarGodActive(isSeasonOpen);
         this.myWarGodButton.setWarGodData(wargodSetting,seasonData,playerWarGodData);
         this.myWarGodShortCut.setPlayerWarGodData(playerWarGodData);
      }
   }
}

