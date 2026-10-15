package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.CharacterSwitchModule;
   import codo.component.PlayerAccountInfo;
   import codo.component.SupplyDropCounterButton;
   import codo.component.TextField;
   import codo.component.career.ChallengeChecklist;
   import codo.component.factory.ButtonFactory;
   import codo.component.loadout.LoadoutViewGearPanel;
   import codo.component.lobby.LobbyCountdownTimer;
   import codo.component.lobby.LobbyGearSubPanel;
   import codo.component.lobby.LobbyMainPanel;
   import codo.component.lobby.LobbyMatchOptionsPanel;
   import codo.component.lobby.LobbyScenePlayerNames;
   import codo.component.lobby.LobbyStartButton;
   import codo.component.lobby.LobbyTeams;
   import codo.component.lobby.ZombieChampionDetailLobby;
   import codo.component.lobby.ZombieChampionList;
   import codo.component.lobby.ZombieChampionSwitcher;
   import codo.component.navigation.NavigationMenu;
   import codo.component.navigation.SubNavTabBar;
   import codo.component.navigation.parts.NavigationButton;
   import codo.component.object.NavigationObj;
   import codo.component.onboarding.OnboardingChallengeChecklist;
   import codo.component.playercard.PlayerCardShared;
   import codo.component.playercard.PlayerCard_Lobby;
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.constants.PageID;
   import codo.constants.QuickMatchType;
   import codo.constants.SE_ID;
   import codo.constants.ViewState;
   import codo.cpp.UiCppNewItems;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.objects.BindDataHelper;
   import codo.objects.ItemBanObj;
   import codo.objects.PlayListObj;
   import codo.objects.RankedMatchLobbyUpdateObj;
   import codo.objects.RoomMemberObj;
   import codo.objects.RoomObj;
   import codo.objects.ZombieChampionObj;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.services.ChallengeService;
   import codo.services.MatchService;
   import codo.services.TutorialService;
   import codo.services.WeaponLoadoutService;
   import codo.style.GlobalGuide;
   import codo.theme.BaseTheme;
   import codo.theme.ITheme;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.SoundUtil;
   import codo.utils.TLogUtil;
   import codo.views.persistentView_parts.GameOptionsPanel;
   import codo.views.persistentView_parts.PrimaryNavigationMenu;
   import components.Clock;
   import components.fsggamelobby_part.LobbyDevPanel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   
   public class GameLobbyView extends BaseView
   {
      
      public static const BUTTON_LOBBY_INDEX:int = 0;
      
      public static const BUTTON_INVENTORY_INDEX:int = 1;
      
      public static const ROOM_NAME_TEXT_WIDTH:int = 300;
      
      public static const LOBBY_SCROLL_LIST_HEIGHT:Number = 300;
      
      public static const BROADCAST_SELECTION:Boolean = true;
      
      public static const DO_NOT_BROADCAST_SELECTION:Boolean = false;
      
      public static const LOADOUT_VIEW_GEAR_PANEL_CUSTOM_HEIGHT:Number = 710;
      
      public static const LOADOUT_VIEW_GEAR_PANEL_CUSTOM_GRID_HEIGHT:Number = 575;
      
      public static const BACK_BUTTON_LOADOUT_X:Number = 781;
      
      public static const BACK_BUTTON_LOADOUT_Y:Number = 949;
      
      public static const BACK_BUTTON_GEAR_X:Number = 1013;
      
      public static const BACK_BUTTON_GEAR_Y:Number = 896;
      
      private static const TAB_IDX_MAPINFO:int = 0;
      
      private static const TAB_IDX_CHECKLIST:int = 1;
      
      private static const TIME_ALMOST_EXPIRED_TIME:Number = 10;
      
      public var myPrimaryNavMenu:PrimaryNavigationMenu;
      
      public var mySecondaryNavMenu:NavigationMenu;
      
      public var myPlayerCard:PlayerCardShared;
      
      public var myPlayerAccountInfo:PlayerAccountInfo;
      
      public var myReadyBtn:LobbyStartButton;
      
      public var myReturnBtn:Button;
      
      public var myDevPanel:LobbyDevPanel;
      
      public var myGameOptions:GameOptionsPanel;
      
      public var myMainPanel:LobbyMainPanel;
      
      public var myTeamSelectionPanel:LobbyTeams;
      
      public var myCountdownTimer:LobbyCountdownTimer;
      
      public var myRoomName:TextField;
      
      public var myGearSubPanel:LobbyGearSubPanel;
      
      public var myLoadoutViewGearPanel:LoadoutViewGearPanel;
      
      public var myMapInfoPanel:LobbyMatchOptionsPanel;
      
      public var mySubNav:SubNavTabBar;
      
      public var myOnboardingChecklist:OnboardingChallengeChecklist;
      
      public var myChallengeChecklist:ChallengeChecklist;
      
      public var my3DClickArea:Sprite;
      
      public var myCharacterModule:CharacterSwitchModule;
      
      public var myTeamViewPlayerCard:PlayerCard_Lobby;
      
      public var mySupplyDropCounter:SupplyDropCounterButton;
      
      public var myBackButton:Button;
      
      public var myCODOLogo:MovieClip;
      
      public var myCODOLogoGlow:MovieClip;
      
      public var myLobbyClock:Clock;
      
      public var myLobbyScenePlayerNames:LobbyScenePlayerNames;
      
      public var myZombieChampionList:ZombieChampionList;
      
      public var myZombieChampionDetailPanel:ZombieChampionDetailLobby;
      
      public var myZombieChampionSwitcher:ZombieChampionSwitcher;
      
      private var mRoomInfoBindData:BindDataHelper;
      
      private var m_bindLoadout:BindDataHelper;
      
      private var m_bindDataReceive:BindDataHelper;
      
      private var m_bindMktMaintainState:BindDataHelper;
      
      private var _roomObj:RoomObj = null;
      
      private var mCanStartMatchAlone:Boolean = false;
      
      private var mIsInitialized:Boolean = false;
      
      private var mSelectedMember:RoomMemberObj;
      
      private var mIsHost:Boolean;
      
      private var mShowBanPopup:Boolean;
      
      private var mInitForMode:Boolean;
      
      private var mCurToolTip:UITourToolTipObj;
      
      private var mHelpTipDisplay:UITourToolTip;
      
      private var _inventoryTab:NavigationButton;
      
      private var _loadoutTab:NavigationButton;
      
      private var _killstreakTab:NavigationButton;
      
      private var _loadoutSecNav:NavigationObj;
      
      private var _requisitionSecNav:NavigationObj;
      
      private var _killstreakSecNav:NavigationObj;
      
      private var _gearSecNav:NavigationObj;
      
      private var _secondNavButtons:Vector.<NavigationObj>;
      
      public function GameLobbyView()
      {
         super();
         this.mySubNav.addTab(LocalizeUtil.localize(DictRoom.ROOM_INFO));
         this.mySubNav.addTab(LocalizeUtil.localize(Dict.ONBOARDING_CHECKLIST));
         this.mySubNav.init(this.onSubNavTabClicked);
         this.mySubNav.setSelectedTab(0);
         this.myOnboardingChecklist.useSmallRenderer = true;
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
         var theme:ITheme = getDP(DataID.GET_THEME_SUITE);
         this.myCODOLogoGlow.visible = theme.hasCODOLogoGlow();
      }
      
      override protected function onInit() : void
      {
         var primaryNavButtons:Vector.<NavigationObj> = null;
         super.onInit();
         this.mIsHost = false;
         this.mShowBanPopup = true;
         this.mInitForMode = true;
         this.myDevPanel.visible = false;
         this.mRoomInfoBindData = createBindHelper(DataID.ROOM_INFO,this.bind_onRoomInfoUpdated);
         this.m_bindLoadout = createBindHelper(DataID.WEAPONLOADOUT_SLOTSDATA,this.bindData_loadout);
         this.m_bindDataReceive = createBindHelper(DataID.DATA_RECEIVE,this.bind_dataReceived);
         this.m_bindMktMaintainState = createBindHelper(DataID.MARKETPLACE_MAINTAIN_STATE,this.bind_MktMaintainState);
         this.myGameOptions.resultBtnVisible = false;
         primaryNavButtons = new <NavigationObj>[new NavigationObj(BUTTON_LOBBY_INDEX,Dict.MAIN_MENU_LABEL_LOBBY,true,this.onGotoLobby),new NavigationObj(BUTTON_INVENTORY_INDEX,Dict.MAIN_MENU_LABEL_INVENTORY,true,this.onGotoInventory)];
         primaryNavButtons[BUTTON_INVENTORY_INDEX].breadcrumb = UiCppNewItems.CRUMB_LOBBY_INVENTORY;
         primaryNavButtons[BUTTON_INVENTORY_INDEX].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_INVENTORY_MARKET);
         this._loadoutSecNav = new NavigationObj(-1,Dict.LOBBY_LOADOUTS_LABEL);
         this._requisitionSecNav = new NavigationObj(-1,Dict.LOADOUT_CATEGORY_REQUISITIONS);
         this._killstreakSecNav = new NavigationObj(-1,Dict.LOADOUT_CATEGORY_SCORESTREAKS);
         this._gearSecNav = new NavigationObj(-1,Dict.LOADOUT_CATEGORY_GEAR);
         this._loadoutSecNav.breadcrumb = UiCppNewItems.CRUMB_LOBBY_LOADOUT;
         this._requisitionSecNav.breadcrumb = UiCppNewItems.CRUMB_REQUISITIONS;
         this._killstreakSecNav.breadcrumb = UiCppNewItems.CRUMB_STREAKS;
         this._gearSecNav.breadcrumb = UiCppNewItems.CRUMB_GEAR;
         this._requisitionSecNav.lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_REQUISITIONS);
         this._killstreakSecNav.lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_STREAKS);
         this._gearSecNav.lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_GEAR);
         this.myReadyBtn.registerClickEvent(this.onReadyButtonClicked);
         this.myReadyBtn.audioRef.overrideClickAudio(SE_ID.PRIMARYSELECT_PROCEED);
         this.myReturnBtn.height = 51;
         this.myReturnBtn.label = DictRoom.RETURN_MAIN_MENU;
         this.myReturnBtn.registerClickEvent(this.onReturnButtonClicked);
         this.myReturnBtn.audioRef.overrideClickAudio(SE_ID.GENERAL_BACK);
         this.myZombieChampionSwitcher.visible = false;
         this.mySecondaryNavMenu.listItemClickCallback = this.onInventoryTabClicked;
         this.mySecondaryNavMenu.navButtonRenderMethod = ButtonFactory.BUILD_SECONDARY_MENU_BUTTON;
         this.mySecondaryNavMenu.visible = false;
         this.myPrimaryNavMenu.x = this.myCODOLogo.x + 232;
         this.myPrimaryNavMenu.setData(primaryNavButtons);
         this._inventoryTab = this.myPrimaryNavMenu.getNavButtonByIndex(BUTTON_INVENTORY_INDEX);
         this.myDevPanel.visible = false;
         this.myDevPanel.initListener();
         this.myCountdownTimer.visible = false;
         this.myCountdownTimer.setTime(0,false);
         this.myRoomName.width = ROOM_NAME_TEXT_WIDTH;
         this.myLobbyClock.enableHour = false;
         this.myLobbyClock.enableMin = true;
         this.myLobbyClock.visible = false;
         this.myZombieChampionList.visible = false;
         this.myZombieChampionDetailPanel.hide();
         this.myCharacterModule.showCharacterOnly(true);
         this.myCharacterModule.registerCharacterChangeCallback(this.onCharacterChanged);
         this.myCharacterModule.registerGotoNextLoadoutCallback(this.onNextLoadout);
         this.myCharacterModule.registerGotoPrevLoadoutCallback(this.onPrevLoadout);
         this.myCharacterModule.setListMaxHeight(160);
         this.myCharacterModule.show();
         this.hideSelectedMemberModule();
         this.myGearSubPanel.registerBackCallback(this.onGotoLobby);
         this.myGearSubPanel.registerGearSlotSelectedCallback(this.onGotoGearStore);
         this.myLoadoutViewGearPanel.myFrame.height = LOADOUT_VIEW_GEAR_PANEL_CUSTOM_HEIGHT;
         this.myLoadoutViewGearPanel.gridHeightDelta = -100;
         this.myLoadoutViewGearPanel.myInstructions.fontColor = GlobalGuide.WHITE;
         this.myMainPanel.registerOnItemSelectVisibilityChanged(this.onItemSelectVisibilityChanged);
         this.myMainPanel.registerOnPanelClosedCallback(this.onGotoLobby);
         this.myBackButton.label = Dict.BACK;
         this.myBackButton.registerClickEvent(this.onBackButtonPressed);
         this.myBackButton.visible = false;
         this.my3DClickArea.addEventListener(MouseEvent.CLICK,this.on3DClickAreaClick);
         this.mySupplyDropCounter.registerClickEvent(this.onGotoSupplyDrops);
         this.mySupplyDropCounter.supplyDropsEnabled = CFunctionCommonContainer.SupplyDropsEnabled();
         this.myMapInfoPanel.myAdvancedOptions.myAdvancedBtn.x += 15;
         listen(BCEvent.RANKED_MATCH_GO_ROOM_TIMER,this.onSetMatchTimer);
         listen(BCEvent.RANKED_MATCH_GO_GAME_TIMER,this.onSetMatchTimer);
         listen(BCEvent.UNRANKED_MATCH_GO_GAME_TIMER,this.onSetMatchTimer);
         listen(BCEvent.ALL_READY,this.onMatchStarted);
         listen(BCEvent.EVT_REENABLE_BACKTOLOBBY_BUTTON,this.onReenableBackToLobbyButton);
         listen(BCEvent.RANKED_MATCH_ENABLE_LEAVE_ROOM,this.onRankedMatchEnableLeaveRoomHandle);
         listen(BCEvent.RANKED_MATCH_LOBBY_UPDATE,this.onRankedMatchLobbyUpdate);
         listen(BCEvent.EVT_SELECTED_CHARACTER,this.onSelectedCharacter);
         listen(BCEvent.EVT_SELECTED_CHARACTER_CLEARED,this.onSelectedCharacterCleared);
         listen(BCEvent.EVT_MATCH_RESULTS_SHOW_LOBBY,this.showView);
         listen(BCEvent.EVT_MATCH_RESULTS_OPEN,this.hideView);
         listen(BCEvent.ON_ROOM_LEFT,this.onRoomLeft);
         listen(BCEvent.READY_STATE_CHANGE_COMPLETE,this.onReadyStateChangeComplete);
      }
      
      override protected function showView() : void
      {
         super.showView();
         Logger.print("Show GameLobbyView");
         this.myPlayerCard.active();
         this.myPlayerAccountInfo.active();
         this.myPlayerAccountInfo.positionAssets();
         this.myMapInfoPanel.showPanel();
         this.myReturnBtn.visible = true;
         this.myLobbyScenePlayerNames.active();
         this.refreshBottomButton();
         listen(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
         this.refreshChallenges();
         this.refreshToolTip();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         Logger.print("Hide GameLobbyView");
         this.myPlayerCard.deactive();
         this.myBackButton.visible = false;
         this.myLobbyClock.visible = false;
         this.myZombieChampionList.visible = false;
         this.myZombieChampionDetailPanel.hide();
         this.myPrimaryNavMenu.selectedIndex = BUTTON_LOBBY_INDEX;
         this.myMainPanel.hidePanel();
         this.myGearSubPanel.hidePanel();
         this.mySecondaryNavMenu.hideMenu();
         this.myLoadoutViewGearPanel.hidePanel();
         this.myMapInfoPanel.hidePanel();
         this.hideSelectedMemberModule();
         unlisten(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
      }
      
      override protected function enableData() : void
      {
         ScaleformUtil.setInLobbyLoadout(true);
         listen(BCEvent.EVT_ENABLE_PREV_MATCH_SUMMARY,this.onEnablePrevMatchSummary);
         listen(BCEvent.JOIN_ROOM,this.onJoinRoom);
         listen(BCEvent.EVT_EQUIPPED,this.onEquip);
         listen(BCEvent.EVT_ITEM_REMOVED_FROM_INVENTORY,this.onItemRemovedFromInventory);
         this.mRoomInfoBindData.bind();
         this.m_bindLoadout.bind();
         this.m_bindDataReceive.bind();
         this.m_bindMktMaintainState.bind();
         bind(DataID.SUPPLY_DROP_COUNT,this.bindSupplyDropUpdateCount);
         this.initLobby();
         this.myMapInfoPanel.mCurrentVote = -1;
         this.myMapInfoPanel.setUpOptions();
      }
      
      override protected function disableData() : void
      {
         ScaleformUtil.setInLobbyLoadout(false);
         this.mRoomInfoBindData.unbind();
         this.m_bindLoadout.unbind();
         this.m_bindDataReceive.unbind();
         this.m_bindMktMaintainState.unbind();
         unbind(DataID.SUPPLY_DROP_COUNT,this.bindSupplyDropUpdateCount);
         unlisten(BCEvent.EVT_ENABLE_PREV_MATCH_SUMMARY,this.onEnablePrevMatchSummary);
         unlisten(BCEvent.JOIN_ROOM,this.onJoinRoom);
         unlisten(BCEvent.EVT_EQUIPPED,this.onEquip);
         unlisten(BCEvent.EVT_ITEM_REMOVED_FROM_INVENTORY,this.onItemRemovedFromInventory);
         var curPopup:String = getDP(DataID.CURRENT_PAGE_ID_AT_HIGHEST_DEPTH);
         if(curPopup == PageID.ITEM_RESTRICTION_WARNING_POPUP || curPopup == PageID.ITEM_RESTRICTION_PREVIEW_POPUP || curPopup == PageID.FSG_CREATEROOMOPTIONS)
         {
            broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":curPopup});
         }
         this.myMapInfoPanel.myAdvancedOptions.disableData();
      }
      
      private function refreshChallenges() : void
      {
         this.mySubNav.visible = true;
         this.myMapInfoPanel.visible = false;
         this.myOnboardingChecklist.visible = false;
         this.myChallengeChecklist.visible = false;
         if(ChallengeService.getInstance().showOnboardingChecklist)
         {
            this.myOnboardingChecklist.setData(ChallengeService.getInstance().GetOnboardingChecklist(),true);
            this.myOnboardingChecklist.visible = true;
            this.mySubNav.getTabByIndex(TAB_IDX_CHECKLIST).label = LocalizeUtil.localize(Dict.ONBOARDING_CHECKLIST);
            this.mySubNav.setSelectedTab(TAB_IDX_CHECKLIST,true);
            this.onSubNavTabClicked(TAB_IDX_CHECKLIST);
         }
         else
         {
            this.myChallengeChecklist.setData(ChallengeService.getInstance().GetChallengeChecklist(),true,true,true);
            this.myChallengeChecklist.visible = true;
            this.mySubNav.getTabByIndex(TAB_IDX_CHECKLIST).label = LocalizeUtil.localize(Dict.CHALLENGES_CHECKLIST);
            this.mySubNav.setSelectedTab(TAB_IDX_MAPINFO,true);
            this.onSubNavTabClicked(TAB_IDX_MAPINFO);
         }
      }
      
      private function onSubNavTabClicked(index:int) : void
      {
         switch(index)
         {
            case TAB_IDX_CHECKLIST:
               if(ChallengeService.getInstance().showOnboardingChecklist)
               {
                  this.myOnboardingChecklist.visible = true;
               }
               else
               {
                  this.myChallengeChecklist.visible = true;
               }
               this.myMapInfoPanel.hidePanel();
               break;
            case TAB_IDX_MAPINFO:
               this.myOnboardingChecklist.visible = false;
               this.myChallengeChecklist.visible = false;
               this.myMapInfoPanel.showPanel();
         }
      }
      
      private function onEnablePrevMatchSummary(cEvt:ParaEvent) : void
      {
         if(!cEvt.myPara.isCyborg)
         {
            this.myGameOptions.resultBtnVisible = true;
         }
      }
      
      private function bind_onRoomInfoUpdated(cRes:Object) : void
      {
         var listData:Vector.<Object> = null;
         var i:uint = 0;
         var tutorialModes:Vector.<String> = null;
         var numTutorialModes:uint = 0;
         var iMode:uint = 0;
         var mode:String = null;
         var flag:String = null;
         var playlist:PlayListObj = null;
         if(cRes.data == null)
         {
            return;
         }
         this._roomObj = cRes.data;
         this.buildNavButtons(this._roomObj);
         this.buildCharacterModule(this._roomObj);
         if(this.mIsHost != this._roomObj.forces.isHost)
         {
            this.mIsHost = this._roomObj.forces.isHost;
            if(this.mIsHost)
            {
               this.myMapInfoPanel.reupdateMapList();
            }
         }
         this.myDevPanel.visible = this.mIsHost && Boolean(getDP(DataID.IS_DEV_BUILD));
         this.mCanStartMatchAlone = this.mIsHost && Boolean(getDP(DataID.IS_WHITELIST_TESTER));
         this.myRoomName.text = this._roomObj.name;
         this.myReadyBtn.switchTester(this.mCanStartMatchAlone);
         this.myReadyBtn.switchReady(getDP(DataID.IS_IN_ROOM_READY));
         var isMarketAvailable:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         this.mySupplyDropCounter.enabled = this.myReadyBtn.enabled && isMarketAvailable;
         if(state == ViewState.ACTIVATED && this._roomObj != null)
         {
            this.myMapInfoPanel.roomInfo = this._roomObj;
         }
         if(this.myMainPanel.myLoadoutPanel.isShown() || this.myMainPanel.myScorestreaksPanel.isShown())
         {
            WeaponLoadoutService.getInstance().requestWeaponLoadout();
         }
         var equippedBans:Vector.<ItemBanObj> = this.refreshEquippedBans();
         var numEquippedBans:uint = equippedBans.length;
         if(numEquippedBans > 0 && (this._roomObj.isPlayList || !this.mIsHost || this._roomObj.IsPveMode()) && getDP(DataID.CURRENT_BACKGROUND_POPUP_PAGE_ID) != PageID.FSG_MATCHRESULT && this.mShowBanPopup)
         {
            listData = new Vector.<Object>();
            for(i = 0; i < numEquippedBans; i++)
            {
               listData.push(equippedBans[i]);
            }
            broadcast(BCEvent.SHOW_MATCH_ITEM_RESTRICTIONS_WARNING,listData);
            this.mShowBanPopup = false;
         }
         if(this.mInitForMode)
         {
            if(this._roomObj.currentMatchMode.id == QuickMatchType.ID_ZCHAMP)
            {
               this.myZombieChampionList.addEventListener(ZombieChampionList.EVENT_CHAMPION_SELECTED,this.onZombieChampionSelected);
               this.myZombieChampionList.init();
               this._inventoryTab.visible = false;
               this.myZombieChampionSwitcher.visible = true;
               this.myZombieChampionList.show();
            }
            else
            {
               this.myZombieChampionList.removeEventListener(ZombieChampionList.EVENT_CHAMPION_SELECTED,this.onZombieChampionSelected);
               this._inventoryTab.visible = true;
               this.myZombieChampionSwitcher.visible = false;
            }
            tutorialModes = TutorialService.getInstance().getTutorialPopupModes();
            numTutorialModes = tutorialModes.length;
            for(iMode = 0; iMode < numTutorialModes; iMode++)
            {
               mode = tutorialModes[iMode];
               if(this._roomObj.currentMatchMode.id == mode)
               {
                  if(mode == "dmz")
                  {
                     playlist = getDP(DataID.PLAY_LIST_OBJ,[this._roomObj.playListID]);
                     if(MatchService.getInstance().getPlayListHasRule(playlist,"dmz_circle_reversed 1"))
                     {
                        mode = "rdmz";
                     }
                  }
                  else if(mode == "zhunt")
                  {
                     if(this._roomObj.currentMap.id == "mp_deathmarch_chap1_c" || this._roomObj.currentMap.id == "mp_deathmarch_chap1_d")
                     {
                        mode = "zhunt_1";
                     }
                     if(this._roomObj.currentMap.id == "mp_deathmarch_chap3_a" || this._roomObj.currentMap.id == "mp_deathmarch_chap3_b")
                     {
                        mode = "zhunt_2";
                     }
                     if(this._roomObj.currentMap.id == "mp_deathmarch_chap4_a" || this._roomObj.currentMap.id == "mp_deathmarch_chap4_b")
                     {
                        mode = "zhunt_3";
                     }
                  }
                  flag = "onboard_" + mode + "_popup";
                  if(!CFunctionCommonContainer.AS_IsNotified(flag))
                  {
                     broadcast(BCEvent.EVT_OPEN_GAME_MODE_TUTORIAL,mode);
                     CFunctionCommonContainer.AS_SetNotified(flag);
                  }
               }
            }
            this.mInitForMode = false;
         }
      }
      
      private function bindData_loadout() : void
      {
         this.refreshEquippedBans();
      }
      
      private function bindSupplyDropUpdateCount(cRes:Object) : void
      {
         this.mySupplyDropCounter.update(cRes.data.total);
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         this.checkMktData();
      }
      
      private function bind_MktMaintainState(cRes:Object) : void
      {
         this.checkMktData();
      }
      
      private function checkMktData() : void
      {
         var lobbyBtn:NavigationButton = null;
         var isAvailable:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         this.mySupplyDropCounter.enabled = isAvailable && this.myReadyBtn.enabled;
         this.myPrimaryNavMenu.getNavButtonByIndex(BUTTON_INVENTORY_INDEX).routingDisabled = !isAvailable;
         if(!isAvailable)
         {
            lobbyBtn = this.myPrimaryNavMenu.getNavButtonByIndex(BUTTON_LOBBY_INDEX);
            this.myPrimaryNavMenu.onMenuItemSelected(lobbyBtn);
         }
         this.refreshToolTip();
      }
      
      private function refreshToolTip() : void
      {
         var newTip:UITourToolTipObj = null;
         var tips:Vector.<UITourToolTipObj> = null;
         var cls:Class = null;
         if(Boolean(getDP(DataID.IS_DATA_AVAILABLE)))
         {
            tips = new Vector.<UITourToolTipObj>(0);
            TutorialService.getInstance().getUITourContentByPageID(TutorialService.LOBBY_TIP_ID,tips);
            if(tips.length > 0)
            {
               newTip = tips[0];
               if(newTip != null && Boolean(CFunctionCommonContainer.AS_IsNotified(newTip.onboardNotif)))
               {
                  newTip = null;
               }
            }
         }
         if(newTip != this.mCurToolTip)
         {
            this.mCurToolTip = newTip;
            if(this.mHelpTipDisplay != null)
            {
               this.mHelpTipDisplay.deactive();
            }
            if(newTip != null)
            {
               if(this.mHelpTipDisplay == null)
               {
                  cls = getDefinitionByName("codo.shared.UITourToolTip") as Class;
                  this.mHelpTipDisplay = new cls() as UITourToolTip;
                  addChild(this.mHelpTipDisplay);
                  this.mHelpTipDisplay.clickCallback = this.onHelpClick;
               }
               this.mHelpTipDisplay.showHelpTip(this.mCurToolTip);
            }
         }
      }
      
      private function onHelpClick(doOpenTour:Boolean) : void
      {
         TutorialService.getInstance().discardToolTip(this.mCurToolTip);
         TLogUtil.TLog_Onboarding_Guide(this.mCurToolTip,doOpenTour);
         if(doOpenTour)
         {
            if(this.mCurToolTip.onboardNotif != null)
            {
               CFunctionCommonContainer.AS_SetNotified(this.mCurToolTip.onboardNotif);
            }
            if(this.mCurToolTip.linkedTip != null)
            {
               TutorialService.getInstance().discardToolTip(this.mCurToolTip.linkedTip);
            }
            TutorialService.getInstance().setPendingInventoryTutorial(this.mCurToolTip);
            this.onReturnButtonClicked();
         }
         this.refreshToolTip();
      }
      
      private function onCharacterChanged() : void
      {
         this.broadcast(BCEvent.LOBBY_REFRESH_AVATAR);
      }
      
      protected function onEquip(evt:ParaEvent) : void
      {
         broadcast(BCEvent.LOBBY_REFRESH_AVATAR);
      }
      
      private function onItemRemovedFromInventory(evt:ParaEvent) : void
      {
         var bWasEquipped:Boolean = Boolean(evt.myPara.bWasEquipped);
         if(bWasEquipped)
         {
            broadcast(BCEvent.LOBBY_REFRESH_AVATAR);
         }
      }
      
      private function refreshEquippedBans() : Vector.<ItemBanObj>
      {
         var i:uint = 0;
         var equippedBans:Vector.<ItemBanObj> = new Vector.<ItemBanObj>();
         if(this._loadoutTab == null || this._killstreakTab == null)
         {
            return equippedBans;
         }
         this._loadoutTab.myWarningIcon.visible = false;
         this._killstreakTab.myWarningIcon.visible = false;
         var numEquippedBans:uint = 0;
         if(Boolean(this._roomObj) && this._roomObj.numItemBans > 0)
         {
            equippedBans = CFunctionContainer.GetItemBanEquippedList();
            numEquippedBans = equippedBans.length;
            for(i = 0; i < numEquippedBans; i++)
            {
               if(equippedBans[i].type == MarketMenuData.TYPE_KILLSTREAK)
               {
                  this._killstreakTab.myWarningIcon.visible = true;
               }
               else
               {
                  this._loadoutTab.myWarningIcon.visible = true;
               }
            }
         }
         this._inventoryTab.myWarningIcon.visible = numEquippedBans > 0;
         return equippedBans;
      }
      
      private function onNextLoadout() : void
      {
         this.selectLoadout(1);
      }
      
      private function onPrevLoadout() : void
      {
         this.selectLoadout(-1);
      }
      
      private function selectLoadout(dir:int) : void
      {
         var maxLoadouts:int = CFunctionCommonContainer.WL_GetMaxNumLoadouts();
         var curLoadout:int = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
         var tryNext:Boolean = true;
         while(tryNext)
         {
            curLoadout += dir;
            if(curLoadout < 0)
            {
               curLoadout = maxLoadouts - 1;
            }
            else if(curLoadout >= maxLoadouts)
            {
               curLoadout = 0;
            }
            tryNext = !CFunctionCommonContainer.isLoadoutUsable(curLoadout);
         }
         WeaponLoadoutService.getInstance().changeLoadout(curLoadout);
      }
      
      private function onChampionSwitchPressed() : void
      {
         this.myZombieChampionList.show();
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
      }
      
      private function onZombieChampionSelected(evt:ParaEvent) : void
      {
         var champion:ZombieChampionObj = evt.myPara;
         CFunctionCommonContainer.AS_SelectChampionByClassID(champion.id);
         this.myZombieChampionList.visible = false;
         this.myZombieChampionSwitcher.setData(champion,this.onChampionSwitchPressed,this.onChampionDetailPressed);
      }
      
      private function onChampionDetailPressed(champion:ZombieChampionObj) : void
      {
         this.myZombieChampionDetailPanel.show(champion);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
      }
      
      protected function shouldUpdateTimer() : Boolean
      {
         return state == ViewState.ACTIVATED || state == ViewState.BACKGROUND;
      }
      
      private function onSetMatchTimer(parameterEvent:ParaEvent) : void
      {
         if(this.shouldUpdateTimer())
         {
            this.setMatchTimer(parameterEvent.myPara,true);
         }
      }
      
      private function onReadyButtonClicked() : void
      {
         if(this.mCanStartMatchAlone)
         {
            broadcast(BCEvent.START_MATCH,{
               "useDS":true,
               "index":-1,
               "isForceStart":true
            });
            return;
         }
         broadcast(BCEvent.CHANGE_READY_STATE);
      }
      
      private function onReadyStateChangeComplete(evt:ParaEvent) : void
      {
         var isReady:Boolean = evt.myPara as Boolean;
         this.myReadyBtn.switchReady(isReady);
      }
      
      private function onReturnButtonClicked() : void
      {
         this.myGameOptions.resultBtnVisible = false;
         broadcast(BCEvent.LEAVE_ROOM,{"isUserInput":true});
      }
      
      private function onPrimaryNavButtonClicked(btn:NavigationObj) : void
      {
         if(btn.clickEvent != null)
         {
            btn.clickEvent();
         }
      }
      
      private function onInventoryTabClicked(tab:NavigationObj) : void
      {
         switch(tab.index)
         {
            case this._loadoutSecNav.index:
               this.onGotoLoadout();
               break;
            case this._requisitionSecNav.index:
               this.onGotoRequisitions();
               break;
            case this._killstreakSecNav.index:
               this.onGotoKillstreaks();
               break;
            case this._gearSecNav.index:
               this.onGotoGear();
         }
      }
      
      private function hideLoadoutViewGearPanel() : void
      {
         this.myLoadoutViewGearPanel.hidePanel();
      }
      
      private function onGotoLobby() : void
      {
         this.setSelectedMember(null,BROADCAST_SELECTION);
         this.navigateToLobby();
      }
      
      private function navigateToLobby() : void
      {
         this.myMainPanel.hidePanel();
         this.myGearSubPanel.hidePanel();
         this.hideLoadoutViewGearPanel();
         this.mySecondaryNavMenu.hideMenu();
         this.myMapInfoPanel.showPanel();
         this.myRoomName.visible = true;
         this.myBackButton.visible = false;
         this.myLobbyClock.visible = this.myLobbyClock.time > 0;
         this.refreshChallenges();
      }
      
      private function onGotoInventory() : void
      {
         this.setSelectedSelf();
         this.navigateToDefaultPanel();
      }
      
      private function navigateToDefaultPanel() : void
      {
         this.myMapInfoPanel.hidePanel();
         this.mySubNav.visible = false;
         this.myOnboardingChecklist.visible = false;
         this.myChallengeChecklist.visible = false;
         this.myMainPanel.showPanel();
         this.mySecondaryNavMenu.clearSelectedIndex();
         if(this._loadoutSecNav.index != -1)
         {
            this.onGotoLoadout();
            this.mySecondaryNavMenu.selectedIndex = this._loadoutSecNav.index;
         }
         else
         {
            this.onGotoGear();
            this.mySecondaryNavMenu.selectedIndex = this._gearSecNav.index;
         }
         this.mySecondaryNavMenu.visible = true;
         this.mySecondaryNavMenu.showMenu();
         this.myRoomName.visible = false;
         this.myLobbyClock.visible = false;
      }
      
      private function onGotoMarket() : void
      {
         this.setSelectedSelf();
         this.navigateToMarket();
      }
      
      private function navigateToMarket() : void
      {
         this.myMainPanel.showPanel();
         this.mySecondaryNavMenu.hideMenu();
         this.myGearSubPanel.hidePanel();
         this.hideLoadoutViewGearPanel();
         this.myMapInfoPanel.hidePanel();
         this.mySubNav.visible = false;
         this.myOnboardingChecklist.visible = false;
         this.myChallengeChecklist.visible = false;
         this.myMainPanel.onGotoMarket();
         this.myRoomName.visible = false;
         this.myBackButton.visible = false;
         this.myLobbyClock.visible = false;
      }
      
      private function onGotoSupplyDrops() : void
      {
         this.myMainPanel.onGotoSupplyDrop();
      }
      
      private function onGotoLoadout() : void
      {
         this.myMainPanel.showPanel();
         this.myGearSubPanel.hidePanel();
         this.hideLoadoutViewGearPanel();
         this.myMapInfoPanel.hidePanel();
         this.mySubNav.visible = false;
         this.myOnboardingChecklist.visible = false;
         this.myChallengeChecklist.visible = false;
         this.myMainPanel.onGotoLoadout();
         this.myBackButton.visible = false;
      }
      
      private function onGotoRequisitions() : void
      {
         this.myMainPanel.showPanel();
         this.myGearSubPanel.hidePanel();
         this.hideLoadoutViewGearPanel();
         this.myMapInfoPanel.hidePanel();
         this.mySubNav.visible = false;
         this.myOnboardingChecklist.visible = false;
         this.myChallengeChecklist.visible = false;
         this.myMainPanel.onGotoRequisitions();
         this.myBackButton.visible = false;
      }
      
      private function onGotoKillstreaks() : void
      {
         this.myMainPanel.showPanel();
         this.myGearSubPanel.hidePanel();
         this.myMainPanel.onGotoKillstreaks();
         this.hideLoadoutViewGearPanel();
         this.myMapInfoPanel.hidePanel();
         this.mySubNav.visible = false;
         this.myOnboardingChecklist.visible = false;
         this.myChallengeChecklist.visible = false;
         this.myBackButton.visible = false;
      }
      
      private function onGotoGear() : void
      {
         this.myMainPanel.hidePanel();
         this.myGearSubPanel.showPanel();
         this.hideLoadoutViewGearPanel();
         this.myMapInfoPanel.hidePanel();
         this.mySubNav.visible = false;
         this.myOnboardingChecklist.visible = false;
         this.myChallengeChecklist.visible = false;
         this.myBackButton.visible = false;
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
      }
      
      private function onGotoGearStore(categoryIndex:int) : void
      {
         this.myMainPanel.hidePanel();
         this.myGearSubPanel.hidePanel();
         this.myMapInfoPanel.hidePanel();
         this.mySubNav.visible = false;
         this.myOnboardingChecklist.visible = false;
         this.myChallengeChecklist.visible = false;
         this.myLoadoutViewGearPanel.showPanel();
         this.myLoadoutViewGearPanel.myLoadoutFilter.setCategorySelection(categoryIndex);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
         this.myBackButton.x = BACK_BUTTON_GEAR_X;
         this.myBackButton.y = BACK_BUTTON_GEAR_Y;
         this.myBackButton.visible = true;
      }
      
      private function onStageKeyHandle(e:KeyboardEvent) : void
      {
         if(e.type == KeyboardEvent.KEY_UP)
         {
            switch(e.keyCode)
            {
               case Keyboard.ESCAPE:
                  this.onBackButtonPressed();
                  stage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
            }
         }
      }
      
      private function onJoinRoom(cEvent:ParaEvent) : void
      {
         this.initLobby();
      }
      
      private function onRoomLeft(cEvent:ParaEvent) : void
      {
         this._roomObj = null;
         this._secondNavButtons = null;
         this.mIsInitialized = false;
         this.mShowBanPopup = true;
         this.mInitForMode = true;
         this.mRoomInfoBindData.unbind();
         this.mRoomInfoBindData.reset();
         this.m_bindDataReceive.unbind();
         this.myPlayerCard.deactive();
         this.myTeamSelectionPanel.deactive();
         this.myMapInfoPanel.reupdateMapList();
         this.myCountdownTimer.visible = false;
      }
      
      private function onMatchStarted(cEvt:ParaEvent) : void
      {
         this.myReadyBtn.enabled = false;
         this.myReturnBtn.enabled = false;
         this.mySupplyDropCounter.enabled = false;
         broadcast(BCEvent.EVT_ON_BACKTOLOBBY_BUTTON_DISABLED);
      }
      
      private function onReenableBackToLobbyButton(cEvent:ParaEvent) : void
      {
         this.myReturnBtn.enabled = true;
      }
      
      private function onRankedMatchEnableLeaveRoomHandle(cEvent:ParaEvent) : void
      {
         this.myReturnBtn.enabled = cEvent.myPara;
      }
      
      private function onSelectedCharacter(evt:ParaEvent) : void
      {
         var member:RoomMemberObj = evt.myPara as RoomMemberObj;
         var self:RoomMemberObj = this.getDP(DataID.MY_AVATAR_MEMBER_OBJ);
         if(!member || !self)
         {
            return;
         }
         if(member.team != self.team)
         {
            this.refreshSelectedMemberModule(member);
            return;
         }
         this.setSelectedMember(member,DO_NOT_BROADCAST_SELECTION);
         if(this.myPrimaryNavMenu.selectedIndex != BUTTON_INVENTORY_INDEX)
         {
            if(this.myPrimaryNavMenu.getNavButtonByIndex(BUTTON_INVENTORY_INDEX).enabled)
            {
               this.myPrimaryNavMenu.selectedIndex = BUTTON_INVENTORY_INDEX;
               this.navigateToDefaultPanel();
            }
         }
      }
      
      private function onSelectedCharacterCleared(evt:ParaEvent) : void
      {
         this.setSelectedMember(null,DO_NOT_BROADCAST_SELECTION);
         this.myPrimaryNavMenu.selectedIndex = BUTTON_LOBBY_INDEX;
         this.navigateToLobby();
      }
      
      private function setSelectedSelf() : void
      {
         var self:RoomMemberObj = this.getDP(DataID.MY_AVATAR_MEMBER_OBJ);
         this.setSelectedMember(self,BROADCAST_SELECTION);
      }
      
      private function setSelectedMember(member:RoomMemberObj, broadcastSelection:Boolean) : void
      {
         this.mSelectedMember = member;
         this.refreshSelectedMemberModule(member);
         if(broadcastSelection == BROADCAST_SELECTION)
         {
            if(this.mSelectedMember != null)
            {
               this.broadcast(BCEvent.EVT_LOBBY_TRY_SELECT_MEMBER,this.mSelectedMember.id);
            }
            else
            {
               this.broadcast(BCEvent.EVT_LOBBY_TRY_SELECT_MEMBER,"");
            }
         }
      }
      
      private function refreshSelectedMemberModule(member:RoomMemberObj) : void
      {
         if(member != null)
         {
            if(member.isMe)
            {
               this.myCharacterModule.visible = true;
               this.myTeamViewPlayerCard.visible = false;
            }
            else
            {
               this.myCharacterModule.visible = false;
               this.myTeamViewPlayerCard.visible = true;
               this.myTeamViewPlayerCard.selectMember(member);
            }
         }
         else
         {
            this.hideSelectedMemberModule();
         }
      }
      
      private function hideSelectedMemberModule() : void
      {
         this.myCharacterModule.visible = false;
         this.myTeamViewPlayerCard.visible = false;
      }
      
      private function setMatchTimer(cTimer:Number, startingMatch:Boolean) : void
      {
         var bCountingDown:Boolean = cTimer != 0 && this.myCountdownTimer.getTime() > cTimer;
         if(startingMatch && bCountingDown)
         {
            SoundUtil.getInstance().playSound(SE_ID.GENERAL_COUNTDOWN);
         }
         var almostExpired:Boolean = bCountingDown && cTimer <= TIME_ALMOST_EXPIRED_TIME;
         this.myMapInfoPanel.mapSelectionEnabled = !almostExpired;
         this.myCountdownTimer.visible = cTimer > 1;
         this.myCountdownTimer.setTime(cTimer,almostExpired);
      }
      
      private function setLobbyWaitTimer(cTimer:Number) : void
      {
         this.myLobbyClock.time = cTimer;
         this.myLobbyClock.visible = cTimer > 0 && this.myRoomName.visible;
      }
      
      private function initLobby() : void
      {
         if(this.mIsInitialized)
         {
            return;
         }
         this.mIsInitialized = true;
         this.myTeamSelectionPanel.active();
         this.myCountdownTimer.visible = false;
      }
      
      private function refreshBottomButton() : void
      {
         this.myReadyBtn.switchReady(getDP(DataID.IS_IN_ROOM_READY));
         this.myReadyBtn.enabled = true;
         this.myReturnBtn.enabled = true;
      }
      
      private function onRankedMatchLobbyUpdate(parameterEvent:ParaEvent) : void
      {
         var updateObj:RankedMatchLobbyUpdateObj = null;
         var isInIntermission:Boolean = false;
         if(this.shouldUpdateTimer())
         {
            updateObj = parameterEvent.myPara as RankedMatchLobbyUpdateObj;
            isInIntermission = updateObj.intermissionElapsedTime > 0 && updateObj.intermissionElapsedTime < updateObj.intermissionTotalTime;
            if(updateObj.isFinalUpdate)
            {
               this.setLobbyWaitTimer(0);
            }
            else if(isInIntermission)
            {
               this.setLobbyWaitTimer(Math.max(0,updateObj.intermissionTotalTime - updateObj.intermissionElapsedTime));
            }
            else
            {
               this.setLobbyWaitTimer(updateObj.elapsedTime);
            }
         }
         else
         {
            this.setLobbyWaitTimer(0);
         }
      }
      
      private function on3DClickAreaClick(cEvt:MouseEvent) : void
      {
         CFunctionContainer.MouseClicked3DAreaInLobby();
      }
      
      private function onItemSelectVisibilityChanged(visible:Boolean) : void
      {
         if(visible)
         {
            this.myBackButton.x = BACK_BUTTON_LOADOUT_X;
            this.myBackButton.y = BACK_BUTTON_LOADOUT_Y;
            this.myBackButton.visible = true;
         }
         else
         {
            this.myBackButton.visible = false;
         }
      }
      
      private function onBackButtonPressed() : void
      {
         if(this.myZombieChampionList.visible)
         {
            this.myZombieChampionList.visible = false;
         }
         else if(this.myZombieChampionDetailPanel.visible)
         {
            this.myZombieChampionDetailPanel.hide();
         }
         else if(this.myLoadoutViewGearPanel.visible == true)
         {
            this.onGotoGear();
         }
         else if(this.myMainPanel.myLoadoutItemSelectPanel.visible == true)
         {
            this.onGotoLoadout();
         }
      }
      
      private function buildNavButtons(roomObj:RoomObj) : void
      {
         if(this._secondNavButtons != null)
         {
            return;
         }
         this._secondNavButtons = new Vector.<NavigationObj>();
         this._loadoutSecNav.index = this._requisitionSecNav.index = this._killstreakSecNav.index = this._gearSecNav.index = -1;
         if(roomObj.currentMatchMode.isDMZ)
         {
            this._secondNavButtons.splice(0,0,this._gearSecNav,this._requisitionSecNav);
         }
         else
         {
            this._secondNavButtons.splice(0,0,this._loadoutSecNav,this._gearSecNav,this._killstreakSecNav,this._requisitionSecNav);
         }
         for(var i:int = 0; i < this._secondNavButtons.length; i++)
         {
            this._secondNavButtons[i].index = i;
         }
         this.mySecondaryNavMenu.setData(this._secondNavButtons);
         this.mySecondaryNavMenu.visible = false;
         this._loadoutTab = null;
         if(this._loadoutSecNav.index != -1)
         {
            this._loadoutTab = this.mySecondaryNavMenu.getNavButtonByIndex(this._loadoutSecNav.index);
         }
         this._killstreakTab = null;
         if(this._killstreakSecNav.index != -1)
         {
            this._killstreakTab = this.mySecondaryNavMenu.getNavButtonByIndex(this._killstreakSecNav.index);
         }
      }
      
      private function buildCharacterModule(roomObj:RoomObj) : void
      {
         if(roomObj.currentMatchMode.isDMZ)
         {
            this.myCharacterModule.setWeaponLoadoutVisible(false);
         }
         else
         {
            this.myCharacterModule.setWeaponLoadoutVisible(true);
         }
      }
   }
}

