package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.LoginRewardCounterButton;
   import codo.component.PlayerAccountInfo;
   import codo.component.PrecisionOperationsButton;
   import codo.component.SupplyDropCounterButton;
   import codo.component.career.XPProgressTooltip;
   import codo.component.object.NavigationObj;
   import codo.component.playercard.PlayerCardShared;
   import codo.component.tutorial.UITourToolTip;
   import codo.component.tutorial.UITourToolTipIcon;
   import codo.component.tutorial.UITourToolTipSelector;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.constants.QuickMatchType;
   import codo.constants.UITutorialFlags;
   import codo.constants.WebImgData;
   import codo.constants.table.UINotifications;
   import codo.cpp.UiCppMatchSelectView;
   import codo.cpp.UiCppNewItems;
   import codo.cpp.UiCppOnboarding;
   import codo.debugger.ScaleformDebugger;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.CodoPageObj;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.services.CharacterLoadoutService;
   import codo.services.TutorialService;
   import codo.theme.BaseTheme;
   import codo.utils.CursorUtil;
   import codo.utils.InventoryUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import codo.views.persistentView_parts.GameOptionsPanel;
   import codo.views.persistentView_parts.MktMaintainStrip;
   import codo.views.persistentView_parts.PrimaryNavigationMenu;
   import codo.views.socialclan_sub.DLCDownloadingBar;
   import components.fsgpersistent_part.QtCrateButton;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   
   public class PersistentView extends BaseView
   {
      
      public static const BUTTON_HOME_INDEX:uint = 0;
      
      public static const BUTTON_PLAY_INDEX:uint = 1;
      
      public static const BUTTON_CAREER_INDEX:uint = 2;
      
      public static const BUTTON_MARKET_INDEX:uint = 3;
      
      public static const BUTTON_INVENTORY_INDEX:uint = 4;
      
      public static const BUTTON_SUPPLY_DROPS:uint = 5;
      
      public static const BUTTON_ESPORTS_INDEX:uint = 6;
      
      private static const LOGO_WIDTH:uint = 172;
      
      public var myPlayerCard:PlayerCardShared;
      
      public var myPlayerAccountInfo:PlayerAccountInfo;
      
      public var opener:Boolean;
      
      public var myGameOptions:GameOptionsPanel;
      
      public var myCODOLogo:MovieClip;
      
      public var myDLCBar:DLCDownloadingBar;
      
      public var myPrimaryNavMenu:PrimaryNavigationMenu;
      
      public var myQTCrateBtn1:QtCrateButton;
      
      public var myQTCrateBtn2:QtCrateButton;
      
      public var myQTCrateBtn3:QtCrateButton;
      
      public var mySupplyDropCounter:SupplyDropCounterButton;
      
      public var myLoginRewardCounter:LoginRewardCounterButton;
      
      public var myPrecisionOperationsButton:PrecisionOperationsButton;
      
      public var myMktMaintainStrip:MktMaintainStrip;
      
      public var myUITourHelpBtn:UITourToolTipIcon;
      
      public var myUITourToolTip:UITourToolTip;
      
      public var myUITourList:UITourToolTipSelector;
      
      public var myXPProgress:Sprite;
      
      public var myXPProgressBG:Sprite;
      
      public var myXPToolTip:XPProgressTooltip;
      
      private var mHelpTips:Vector.<UITourToolTipObj>;
      
      private var mDeferTipUpdate:Boolean;
      
      private var mCurPageID:String;
      
      private var mDebugGrid:Sprite;
      
      private var mDebugMenu:ScaleformDebugger;
      
      private var mPick10TutorialVisible:Boolean;
      
      public function PersistentView()
      {
         super();
         this.opener = true;
         this.myGameOptions.resultBtnVisible = false;
         this.initPrimaryNav();
         this.myCODOLogo.addEventListener(MouseEvent.CLICK,this.onLogoClick);
         this.myCODOLogo.addEventListener(MouseEvent.MOUSE_OVER,this.onLogoMouseOver);
         this.myCODOLogo.addEventListener(MouseEvent.MOUSE_OUT,this.onLogoMouseOut);
         this.myQTCrateBtn2.visible = false;
         this.myQTCrateBtn1.visible = CFunctionCommonContainer.IsUrlValid(WebImgData.BATTLE_PASS.id,0) == true;
         this.myQTCrateBtn1.label = LocalizeUtil.localize(Dict.MAIN_MENU_LABEL_BATTLE_PASS_BTN).toUpperCase();
         this.myQTCrateBtn3.label = LocalizeUtil.localize(Dict.MAIN_MENU_LABEL_STORE_ITEM_CRATE_BTN).toUpperCase();
         this.myQTCrateBtn1.crateButtonCallback = this.onQTCrateClick;
         this.myQTCrateBtn2.crateButtonCallback = this.onQTCrateClick;
         this.myQTCrateBtn3.crateButtonCallback = this.onQTCrateClick;
         if(!this.myQTCrateBtn1.visible)
         {
            this.myQTCrateBtn3.y = this.myQTCrateBtn2.y;
            this.myQTCrateBtn2.y = this.myQTCrateBtn1.y;
         }
         this.mySupplyDropCounter.registerClickEvent(this.onGotoSupplyDrop);
         this.myLoginRewardCounter.registerClickEvent(this.onOpenCheckinRewards);
         this.myPrecisionOperationsButton.registerClickEvent(this.onOpenPrecisionOperations);
         if(Boolean(getDP(DataID.IS_DEV_BUILD)) && Boolean(CFunctionCommonContainer.Dvar_GetBool("ui_enable_debug_tools")))
         {
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyEvent);
         }
         if(Boolean(getDP(DataID.IS_DEV_BUILD)) && Boolean(CFunctionCommonContainer.Dvar_GetBool("ui_enable_debug_tools")))
         {
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyEvent);
         }
         this.myPlayerCard.clickCallback = this.onGotoPlayerCardConfiguration;
         this.myPlayerCard.registerFocusCallback(this.onPlayerCardFocused);
         this.myPlayerCard.registerUnfocusCallback(this.onPlayerCardUnfocused);
         listen(BCEvent.EVT_MAIN_PAGE_CHANGED,this.onMainPageChange);
         listen(BCEvent.EVT_PAGE_CHANGED,this.onAnyPageChange);
         listen(BCEvent.EVT_TUTORIAL_STATE,this.checkSetAvailableUITour);
         listen(BCEvent.EVT_REFRESH_HELP_TIP,this.checkSetAvailableUITour);
         this.myUITourHelpBtn.clickCallback = this.onHelpClick;
         this.myUITourToolTip.clickCallback = this.onToolTipClick;
         this.myUITourHelpBtn.y = this.myQTCrateBtn3.y + this.myQTCrateBtn3.height + this.myUITourHelpBtn.height - 5;
         this.myUITourHelpBtn.isActive = false;
         this.myUITourList.addEventListener(UITourToolTipSelector.EVT_CHANGE,this.onHelpListClick);
         this.myUITourList.y = this.myUITourHelpBtn.y - 23;
         this.mPick10TutorialVisible = false;
      }
      
      override protected function setupThemeVector() : void
      {
         super.setupThemeVector();
         mThemeSetNew.push({
            "clip":this.myPrimaryNavMenu,
            "piece":BaseTheme.THEME_PIECE_PRIMARY_NAVIGATION
         });
         mThemeSetNew.push({
            "clip":this.myCODOLogo,
            "piece":BaseTheme.THEME_PIECE_CODO_LOGO
         });
      }
      
      override protected function initTheme() : void
      {
         super.initTheme();
         this.myPrimaryNavMenu.initTheme(this.myGameOptions);
      }
      
      private function initPrimaryNav() : void
      {
         var primaryNavButtons:Vector.<NavigationObj> = null;
         if(ScaleformUtil.isScaleform)
         {
            primaryNavButtons = new <NavigationObj>[new NavigationObj(BUTTON_HOME_INDEX,Dict.MAIN_MENU_LABEL_HOME,true,this.onGotoHome),new NavigationObj(BUTTON_PLAY_INDEX,Dict.MAIN_MENU_LABEL_PLAY,true,this.onGotoPlay),new NavigationObj(BUTTON_CAREER_INDEX,Dict.MAIN_MENU_LABEL_CAREER,true,this.onGotoCareer),new NavigationObj(BUTTON_MARKET_INDEX,Dict.MAIN_MENU_LABEL_MARKET,true,this.onGotoMarket,null,true),new NavigationObj(BUTTON_INVENTORY_INDEX,Dict.MAIN_MENU_LABEL_INVENTORY,true,this.onGotoLoadout,null,true),new NavigationObj(BUTTON_SUPPLY_DROPS,Dict.MAIN_MENU_LABEL_SUPPLY_DROPS,true,this.onGotoSupplyDrop,null,true),new NavigationObj(BUTTON_ESPORTS_INDEX,Dict.MAIN_MENU_LABEL_ESPORTS,true,this.onGotoESports,null,true)];
         }
         else
         {
            primaryNavButtons = new <NavigationObj>[new NavigationObj(BUTTON_HOME_INDEX,"HOME",true,this.onGotoHome),new NavigationObj(BUTTON_PLAY_INDEX,"PLAY",true,this.onGotoPlay),new NavigationObj(BUTTON_CAREER_INDEX,"CAREER",true,this.onGotoCareer),new NavigationObj(BUTTON_MARKET_INDEX,"MARKET",true,this.onGotoMarket),new NavigationObj(BUTTON_INVENTORY_INDEX,"INVENTORY",true,this.onGotoLoadout),new NavigationObj(BUTTON_SUPPLY_DROPS,"SUPPLY DROPS",true,this.onGotoSupplyDrop),new NavigationObj(BUTTON_ESPORTS_INDEX,"ESPORTS",true,this.onGotoESports)];
         }
         primaryNavButtons[BUTTON_INVENTORY_INDEX].breadcrumb = UiCppNewItems.CRUMB_INVENTORY;
         primaryNavButtons[BUTTON_MARKET_INDEX].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_INVENTORY_MARKET);
         primaryNavButtons[BUTTON_INVENTORY_INDEX].lockLevel = primaryNavButtons[BUTTON_MARKET_INDEX].lockLevel;
         primaryNavButtons[BUTTON_SUPPLY_DROPS].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_SUPPLY_DROPS);
         this.myPrimaryNavMenu.x = this.myCODOLogo.x + LOGO_WIDTH;
         this.myPrimaryNavMenu.setData(primaryNavButtons);
         if(ScaleformUtil.isScaleform)
         {
            this.mySupplyDropCounter.supplyDropsEnabled = this.myPrimaryNavMenu.getNavButtonByIndex(BUTTON_SUPPLY_DROPS).visible = CFunctionCommonContainer.SupplyDropsEnabled();
            this.myPrecisionOperationsButton.precisionOperationsEnabled = CFunctionCommonContainer.IsUrlValid(WebImgData.PRECISION_OPERATIONS.id,0);
            this.myPrimaryNavMenu.getNavButtonByIndex(BUTTON_ESPORTS_INDEX).visible = !getDP(DataID.IS_ESPORTS_BTN_LOCKED);
         }
      }
      
      override protected function showView() : void
      {
         super.showView();
         var pos:uint = this.myGameOptions.x + this.myGameOptions.width * 0.5;
         this.myPlayerAccountInfo.startXPos = pos;
         this.myDLCBar.active();
         if(this.opener == true)
         {
            this.myPlayerCard.active();
            this.opener = false;
         }
         this.myPlayerAccountInfo.active();
         this.myPlayerAccountInfo.positionAssets();
         this.updateMarketState();
         if(!ScaleformUtil.isScaleform)
         {
            this.myPlayerCard.visible = this.myPlayerAccountInfo.accountDataReady = true;
            this.myPlayerAccountInfo.active();
            this.myPlayerAccountInfo.myReplenishButton.visible = true;
            this.myPlayerAccountInfo.myGP.setData("23232");
            this.myPlayerAccountInfo.myCP.setData("232");
            this.myPlayerAccountInfo.positionAssets();
         }
         this.updateXPProgressBar();
         bind(DataID.IS_PICK_10_TUTORIAL_VISIBILITY,this.onPick10TutorialVisibilityChanged);
         listen(BCEvent.EVT_CHECK_SET_AVAILABLE_UI_TOUR,this.onCheckSetAvailableUITour);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myDLCBar.deactive();
         this.opener = true;
         this.myPlayerCard.deactive();
         this.myPlayerAccountInfo.deactive();
         unbind(DataID.IS_PICK_10_TUTORIAL_VISIBILITY,this.onPick10TutorialVisibilityChanged);
         unlisten(BCEvent.EVT_CHECK_SET_AVAILABLE_UI_TOUR,this.onCheckSetAvailableUITour);
      }
      
      private function onCheckSetAvailableUITour(evt:ParaEvent) : void
      {
         this.checkSetAvailableUITour();
      }
      
      private function onPick10TutorialVisibilityChanged(res:Object) : void
      {
         if(res.data == null)
         {
            this.mPick10TutorialVisible = false;
            return;
         }
         this.mPick10TutorialVisible = res.data as Boolean;
      }
      
      private function checkSetAvailableUITour() : void
      {
         var autoShowTip:UITourToolTipObj = null;
         var tutServ:TutorialService = null;
         var i:int = 0;
         var newTip:UITourToolTipObj = null;
         if(this.mDeferTipUpdate)
         {
            return;
         }
         this.mHelpTips = new Vector.<UITourToolTipObj>(0);
         if(!UITutorialBaseView.isTutorialShowing())
         {
            if(Boolean(getDP(DataID.IS_DATA_AVAILABLE)))
            {
               tutServ = TutorialService.getInstance();
               if(this.mCurPageID == PageID.FSG_LOADOUT && this.mPick10TutorialVisible)
               {
                  tutServ.getUITourContentByPageID(this.mCurPageID,this.mHelpTips);
               }
               if(this.mainNavIsVisible())
               {
                  tutServ.enableToolTip(UINotifications.ONBOARD_HELP_LOGIN_REWARDS,this.myLoginRewardCounter.visible);
                  tutServ.enableToolTip(UINotifications.ONBOARD_HELP_SUPPLY_DROPS,this.mySupplyDropCounter.visible);
                  tutServ.getUITourContentByPageID(PageID.PERSISTENT,this.mHelpTips);
               }
            }
         }
         this.myUITourHelpBtn.isActive = this.myUITourHelpBtn.pulsing = this.mHelpTips.length > 0;
         var shownTip:UITourToolTipObj = this.myUITourToolTip.getShownData();
         var onboardType:uint = CFunctionCommonContainer.GetPlayerOnboardType();
         if(onboardType != UiCppOnboarding.TYPE_PRE_MR5)
         {
            for(i = 0; i < this.mHelpTips.length; i++)
            {
               newTip = this.mHelpTips[i];
               if(newTip != null && newTip.onboardNotif != null && !CFunctionCommonContainer.AS_IsNotified(newTip.onboardNotif) && !newTip.tourSkipsIntro())
               {
                  if(newTip != shownTip)
                  {
                     autoShowTip = newTip;
                  }
                  break;
               }
            }
         }
         if(shownTip != null && (this.mHelpTips.indexOf(shownTip) == -1 || autoShowTip != null))
         {
            if(shownTip.tipStyle == UITourToolTip.STYLE_0_BTN)
            {
               this.onHelpAction(shownTip);
            }
            this.myUITourToolTip.deactive();
         }
         if(autoShowTip != null)
         {
            this.showHelpTip(autoShowTip);
         }
      }
      
      private function onHelpClick() : void
      {
         var shownTip:UITourToolTipObj = this.myUITourToolTip.getShownData();
         if(shownTip != null)
         {
            return;
         }
         if(this.myUITourList.showing)
         {
            this.myUITourList.hide();
         }
         else
         {
            this.myUITourList.setTours(this.mHelpTips);
            this.myUITourList.myScrollList.resetIndex();
            this.myUITourList.show();
         }
      }
      
      private function onHelpListClick() : void
      {
         var tip:UITourToolTipObj = this.mHelpTips[this.myUITourList.myScrollList.selectedIndex];
         this.showHelpTip(tip);
      }
      
      private function showHelpTip(tip:UITourToolTipObj) : void
      {
         tip.tourOpened = false;
         if(tip.tourSkipsIntro())
         {
            this.onToolTipClick(true,tip);
         }
         else
         {
            this.myUITourToolTip.showHelpTip(tip);
         }
      }
      
      private function pageIsActive(tip:UITourToolTipObj, id:String) : Boolean
      {
         var matchType:QuickMatchType = null;
         var page:CodoPageObj = CodoPageObj.getObjByID(id);
         if(page.owner.currentPageObj == page)
         {
            if(tip.onboardNotif == UINotifications.ONBOARD_HELP_WARGOD)
            {
               matchType = getDP(DataID.CURRENT_MATCH_TYPE);
               return matchType.isWarGod;
            }
            return true;
         }
         return false;
      }
      
      private function checkOpenTutorial(tip:UITourToolTipObj) : Boolean
      {
         var page:String = tip.pageID;
         if(tip.destination != null)
         {
            page = tip.destination;
         }
         if(this.pageIsActive(tip,page) && !tip.tourOpened)
         {
            tip.tourOpened = true;
            if(tip.flagID != UITutorialFlags.NULL)
            {
               broadcast(BCEvent.EVT_OPEN_UI_TOUR_FROM_TOOLTIP,{
                  "tourPage":page,
                  "tourFlag":tip.flagID
               });
            }
            return true;
         }
         return false;
      }
      
      private function goToTutorialPage(tip:UITourToolTipObj) : void
      {
         var destination:String = tip.destination;
         if(destination == PageID.FSG_LOADOUT)
         {
            broadcast(BCEvent.EVT_GOTO_LOADOUT_TAB,tip.destinationTab);
            return;
         }
         if(destination == this.mCurPageID)
         {
            if(tip.onboardNotif == UINotifications.ONBOARD_HELP_WARGOD)
            {
               broadcast(BCEvent.SET_MATCH_SELECT_TAB,UiCppMatchSelectView.ROOT_IDX_WARGOD);
            }
            return;
         }
         if(destination == PageID.MATCH_SELECT)
         {
            if(tip.onboardNotif == UINotifications.ONBOARD_HELP_WARGOD)
            {
               broadcast(BCEvent.EVT_GOTO_MAIN_WARGOD);
            }
            else
            {
               broadcast(BCEvent.EVT_GOTO_GAMEMODE_SELECTION);
            }
         }
         else if(destination == PageID.MARKET)
         {
            broadcast(BCEvent.EVT_GOTO_MARKET);
         }
         else if(Boolean(PageID.getSocialPopups()[destination]))
         {
            broadcast(BCEvent.EVT_SELECT_SOCIAL_BUTTON,destination);
         }
         else
         {
            broadcast(BCEvent.EVT_ROUTE_TO_PAGE,{"page":destination});
         }
      }
      
      private function onHelpAction(tip:UITourToolTipObj) : void
      {
         this.myUITourToolTip.deactive();
         if(tip.onboardNotif != null)
         {
            CFunctionCommonContainer.AS_SetNotified(tip.onboardNotif);
         }
         if(tip.onboardOnly)
         {
            TutorialService.getInstance().discardToolTip(tip);
         }
         else
         {
            tip.acknowledged = true;
         }
      }
      
      private function onToolTipClick(doOpenTour:Boolean, overrideTip:UITourToolTipObj = null) : void
      {
         this.mDeferTipUpdate = true;
         var shownTip:UITourToolTipObj = overrideTip != null ? overrideTip : this.myUITourToolTip.getShownData();
         this.onHelpAction(shownTip);
         if(doOpenTour)
         {
            if(shownTip.destination != null)
            {
               this.goToTutorialPage(shownTip);
            }
            this.checkOpenTutorial(shownTip);
         }
         TLogUtil.TLog_Onboarding_Guide(shownTip,doOpenTour);
         this.mDeferTipUpdate = false;
         this.checkSetAvailableUITour();
      }
      
      private function onShowEvt(cEvt:ParaEvent) : void
      {
         visible = true;
      }
      
      private function onHideEvt(cEvt:ParaEvent) : void
      {
         visible = false;
      }
      
      private function setMainNavVis(show:Boolean) : void
      {
         if(this.myCODOLogo.visible == show)
         {
            return;
         }
         this.myPlayerAccountInfo.forceHide = this.mySupplyDropCounter.forceHide = this.myLoginRewardCounter.forceHide = this.myPrecisionOperationsButton.forceHide = !show;
         this.myPrimaryNavMenu.visible = this.myCODOLogo.visible = this.myPlayerCard.visible = this.myGameOptions.visible = this.myXPProgress.visible = this.myXPProgressBG.visible = show;
         this.myMktMaintainStrip.alpha = show ? 1 : 0;
      }
      
      private function mainNavIsVisible() : Boolean
      {
         return visible && this.myCODOLogo.visible;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         bind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         bind(DataID.MARKETPLACE_MAINTAIN_STATE,this.bindMarketplaceMaintainState);
         bind(DataID.MARKETPLACE_UPDATE_STATE,this.bindMarketplaceUpdateState);
         bind(DataID.SUPPLY_DROP_COUNT,this.bindSupplyDropUpdateCount);
         bind(DataID.CHECKIN_REWARDS,this.bindCheckinRewards);
         listen(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
         listen(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         this.updateXPProgressBar();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unbind(DataID.MARKETPLACE_UPDATE_STATE,this.bindMarketplaceUpdateState);
         unbind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         unbind(DataID.MARKETPLACE_MAINTAIN_STATE,this.bindMarketplaceMaintainState);
         unbind(DataID.SUPPLY_DROP_COUNT,this.bindSupplyDropUpdateCount);
         unbind(DataID.CHECKIN_REWARDS,this.bindCheckinRewards);
         unlisten(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
         unlisten(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
      }
      
      private function onQTCrateClick(btn:QtCrateButton) : void
      {
         switch(btn)
         {
            case this.myQTCrateBtn1:
               broadcast(BCEvent.EVT_CLICK_PERSISTENT_VIEW_BATTLE_PASS_BTN);
               break;
            case this.myQTCrateBtn2:
               broadcast(BCEvent.EVT_CLICK_PERSISTENT_VIEW_RAREITEMS_BTN);
               break;
            case this.myQTCrateBtn3:
               broadcast(BCEvent.EVT_SHOW_CRAFTING);
         }
      }
      
      private function onLogoClick(evt:MouseEvent) : void
      {
         this.onGotoHome(true);
      }
      
      private function onLogoMouseOver(e:MouseEvent) : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onLogoMouseOut(e:MouseEvent) : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         if(cRes.result == 1 && (cRes.data == Common.MARKET_RECEIVED || cRes.data == Common.PLAYERDATA_RECEIVED))
         {
            this.updateMarketState();
            broadcast(BCEvent.EVT_SUPPLY_DROP_REFRESH);
         }
      }
      
      private function bindMarketplaceUpdateState(cRes:Object) : void
      {
      }
      
      private function bindSupplyDropUpdateCount(cRes:Object) : void
      {
         this.mySupplyDropCounter.update(cRes.data.total);
      }
      
      private function bindMarketplaceMaintainState(res:Object) : void
      {
         this.updateMarketState();
      }
      
      private function bindCheckinRewards(cRes:Object) : void
      {
         var ready:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         var rewards:Vector.<MOTDCheckinRewardObj> = cRes.data;
         this.updateCheckinRewardButton(rewards,ready);
      }
      
      private function updateMarketState() : void
      {
         var ready:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         this.myPrimaryNavMenu.marketReadyMode = ready;
         this.myPlayerCard.enable = ready;
         this.mySupplyDropCounter.enabled = ready;
         var rewards:Vector.<MOTDCheckinRewardObj> = getDP(DataID.CHECKIN_REWARDS);
         this.updateCheckinRewardButton(rewards,ready);
         var isMarketplaceInMaintain:Boolean = getDP(DataID.IS_REAL_MARKETPLACE_IN_MAINTAIN);
         var isWhitelistTester:Boolean = getDP(DataID.IS_WHITELIST_TESTER);
         if(!isMarketplaceInMaintain)
         {
            this.myMktMaintainStrip.visible = false;
            return;
         }
         this.myMktMaintainStrip.visible = true;
         if(!isWhitelistTester)
         {
            this.myMktMaintainStrip.text = Dict.DW_MARKETPLACE_MAINTAIN;
         }
         else
         {
            this.myMktMaintainStrip.text = Dict.DW_MARKETPLACE_WHITELIST_MAINTAIN;
         }
      }
      
      private function updateCheckinRewardButton(data:Vector.<MOTDCheckinRewardObj>, marketReady:Boolean) : void
      {
         var rewards:Vector.<MOTDCheckinRewardObj> = null;
         var len:int = 0;
         var i:int = 0;
         if(marketReady)
         {
            rewards = data;
            len = int(rewards.length);
            for(i = 0; i < len; i++)
            {
               if(!rewards[i].isEarned)
               {
                  this.myLoginRewardCounter.update(rewards[i],i - 1,len);
                  break;
               }
               if(i == len - 1)
               {
                  this.myLoginRewardCounter.update(rewards[i],i,len);
                  break;
               }
            }
            this.myLoginRewardCounter.readyToShow = len > 0;
         }
         else
         {
            this.myLoginRewardCounter.readyToShow = false;
         }
         this.checkSetAvailableUITour();
      }
      
      private function updateXPProgressBar() : void
      {
         var ratio:Number = this.myXPToolTip.updateProgress();
         this.myXPProgress.width = this.myXPProgressBG.width * ratio;
      }
      
      private function onGotoPlay() : void
      {
         if(getDP(DataID.CURRENT_MAIN_PAGE_ID) == PageID.MATCH_SELECT)
         {
            return;
         }
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_PLAY);
         broadcast(BCEvent.EVT_GOTO_GAMEMODE_SELECTION);
      }
      
      private function onGotoHome(fromLogo:Boolean = false) : void
      {
         var curPage:String = getDP(DataID.CURRENT_MAIN_PAGE_ID);
         if(curPage == PageID.HOME)
         {
            return;
         }
         TLogUtil.TLog_UserInput(fromLogo ? int(ButtonTLog.BUTTON_CODO_LOGO) : int(ButtonTLog.BUTTON_NAV_HOME));
         broadcast(BCEvent.EVT_GOTO_PLAY_MODE_SELECTION);
      }
      
      private function checkNavigatedToTutorial() : void
      {
         if(this.mDeferTipUpdate)
         {
            return;
         }
         var shownTip:UITourToolTipObj = this.myUITourToolTip.getShownData();
         if(shownTip != null && this.checkOpenTutorial(shownTip))
         {
            this.onHelpAction(shownTip);
            TLogUtil.TLog_Onboarding_Guide(shownTip,true);
         }
      }
      
      protected function onMainPageChange(cEvt:ParaEvent) : void
      {
         this.mCurPageID = cEvt.myPara.id;
         var showNav:Boolean = this.mCurPageID != PageID.MOTD_CHECKIN_REWARDS && this.mCurPageID != PageID.SUPPLY_DROP;
         this.setMainNavVis(showNav);
         var oldShownTip:UITourToolTipObj = this.myUITourToolTip.getShownData();
         this.checkNavigatedToTutorial();
         this.checkSetAvailableUITour();
         var newShownTip:UITourToolTipObj = this.myUITourToolTip.getShownData();
         if(oldShownTip != null && newShownTip != oldShownTip && !oldShownTip.acknowledged)
         {
            TLogUtil.TLog_Onboarding_Guide(oldShownTip,false);
         }
         if(this.mCurPageID == PageID.MATCH_SELECT)
         {
            this.myPrimaryNavMenu.selectedIndex = BUTTON_PLAY_INDEX;
         }
         else if(this.mCurPageID == PageID.CAREER_BATTLE_EXPERIENCE || this.mCurPageID == PageID.CAREER_CHALLENGES)
         {
            this.myPrimaryNavMenu.selectedIndex = BUTTON_CAREER_INDEX;
         }
         else if(this.mCurPageID == PageID.HOME)
         {
            this.myPrimaryNavMenu.selectedIndex = BUTTON_HOME_INDEX;
         }
         else if(this.mCurPageID == PageID.MARKET)
         {
            this.myPrimaryNavMenu.selectedIndex = BUTTON_MARKET_INDEX;
         }
         else if(this.mCurPageID == PageID.FSG_LOADOUT)
         {
            this.myPrimaryNavMenu.selectedIndex = BUTTON_INVENTORY_INDEX;
         }
      }
      
      private function onAnyPageChange(evt:ParaEvent) : void
      {
         var pageObj:CodoPageObj = evt.myPara.pageObj;
         if(Boolean(PageID.getSocialPopups()[pageObj.id]))
         {
            this.checkNavigatedToTutorial();
         }
      }
      
      private function onGotoPlayerCardConfiguration() : void
      {
         var lock:String = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_PLAYERCARD);
         if(lock != null)
         {
            return;
         }
         if(getDP(DataID.CURRENT_MAIN_PAGE_ID) == PageID.FSG_LOADOUT)
         {
            if(InventoryUtil.getCurrentTab() == InventoryUtil.PLAYERCARD_TAB)
            {
               return;
            }
         }
         broadcast(BCEvent.EVT_GOTO_LOADOUT_TAB,InventoryUtil.PLAYERCARD_TAB);
      }
      
      private function onGotoCareer() : void
      {
         if(getDP(DataID.CURRENT_MAIN_PAGE_ID) == PageID.CAREER_BATTLE_EXPERIENCE)
         {
            return;
         }
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_CAREER);
         this.broadcast(BCEvent.EVT_GOTO_CAREER);
         CFunctionCommonContainer.AS_SetNotified("un_career");
      }
      
      private function onGotoMarket() : void
      {
         if(getDP(DataID.CURRENT_MAIN_PAGE_ID) == PageID.MARKET)
         {
            return;
         }
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_MARKET);
         this.broadcast(BCEvent.EVT_GOTO_MARKET);
         CFunctionCommonContainer.AS_SetNotified("un_marketplace");
      }
      
      private function onGotoLoadout() : void
      {
         if(getDP(DataID.CURRENT_MAIN_PAGE_ID) == PageID.FSG_LOADOUT)
         {
            return;
         }
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_INVENTORY);
         CharacterLoadoutService.getInstance().showAvatarLoadout = false;
         this.broadcast(BCEvent.EVT_GOTO_FSG_LOADOUT);
      }
      
      private function onGotoSupplyDrop() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_SUPPLY_DROPS);
         this.broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP);
         CFunctionCommonContainer.AS_SetNotified("un_supplydrops");
      }
      
      private function onGotoESports() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_ESPORTS);
         this.broadcast(BCEvent.EVT_GOTO_ESPORTS);
      }
      
      private function onOpenCheckinRewards() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_DAILY_REWARD);
         this.broadcast(BCEvent.EVT_OPEN_MOTD_CHECKIN_REWARDS);
      }
      
      private function onOpenPrecisionOperations() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_NAV_PRECISION_OPERATIONS);
         this.broadcast(BCEvent.EVT_GOTO_PRECISIONOPERATIONS);
      }
      
      private function onPlayerCardFocused() : void
      {
         this.myXPToolTip.showBox();
      }
      
      private function onPlayerCardUnfocused() : void
      {
         this.myXPToolTip.hideBox();
      }
      
      private function handleKeyEvent(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.F10 && Boolean(CFunctionCommonContainer.IsDevelopmentBuild()))
         {
            if(null == this.mDebugGrid)
            {
               this.mDebugGrid = ScaleformDebugger.drawGrid();
               root.stage.addChild(this.mDebugGrid);
            }
            else
            {
               root.stage.removeChild(this.mDebugGrid);
               this.mDebugGrid = null;
            }
         }
         if(evt.keyCode == Keyboard.F9)
         {
            if(null == this.mDebugMenu)
            {
               this.drawDebugMenu();
            }
            else
            {
               this.mDebugMenu.dispose();
               root.stage.removeChild(this.mDebugMenu);
               this.mDebugMenu = null;
            }
         }
         if(evt.keyCode == Keyboard.ESCAPE && null != this.mDebugMenu && true == this.mDebugMenu.canClose())
         {
            this.mDebugMenu.dispose();
            root.stage.removeChild(this.mDebugMenu);
            this.mDebugMenu = null;
         }
      }
      
      private function drawDebugMenu() : void
      {
         var debugClass:Class = getDefinitionByName("scaleformDebugger") as Class;
         this.mDebugMenu = new debugClass() as ScaleformDebugger;
         root.stage.addChild(this.mDebugMenu);
      }
   }
}

