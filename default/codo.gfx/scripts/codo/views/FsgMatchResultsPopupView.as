package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.navigation.SubNavTabBar;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMatchResults;
   import codo.localization.DictRoom;
   import codo.objects.AARProgressObj;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.PlayListObj;
   import codo.objects.ResultObj;
   import codo.objects.UnlockItemObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.objects.WarGodPlayerObj;
   import codo.services.ChallengeService;
   import codo.services.CharacterLoadoutService;
   import codo.services.MatchService;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.WarGodUtility;
   import com.greensock.TweenLite;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   import components.fsgmatchresult_part.HPEHPRewardBox;
   import components.fsgmatchresult_part.MatchResultsModeMapDisplay;
   import components.fsgmatchresult_part.panels.FsgMatchResultChallengesPopupPanel;
   import components.fsgmatchresult_part.panels.FsgMatchResultProgressPopupPanel;
   import components.fsgmatchresult_part.panels.FsgMatchResultScoreboardPopupPanel;
   import components.fsgmatchresult_part.panels.FsgMatchResultSpyScoreboardPopupPanel;
   import components.fsgmatchresult_part.panels.FsgMatchResultWarGodPopupPanel;
   import components.fsgmatchresult_part.panels.FsgMatchResultWarGodRewardPopupPanel;
   import components.fsgmatchresult_part.panels.FsgMatchResultWeaponPopupPanel;
   import components.fsgmatchresult_part.panels.MatchResultMissionAwardsPanel;
   import components.fsgpopups_part.FsgCharacterSwapViewContent;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class FsgMatchResultsPopupView extends BaseView
   {
      
      private static const SCRIM_FADE_DURATION:Number = 0.3;
      
      private static const LOCALIZE:Function = LocalizeUtil.localize;
      
      public var myScrim:MovieClip;
      
      public var myNextButton:Button;
      
      public var myPrevButton:Button;
      
      public var myPanelHolder:MovieClip;
      
      public var myHeaderTF:TextField;
      
      public var myMatchResultsTabBar:SubNavTabBar;
      
      public var myMatchResultsModeMapDisplay:MatchResultsModeMapDisplay;
      
      private var mMatchResultPanels:Vector.<FsgMatchResultPopupPanelBase>;
      
      private var mCurrentPanelIndex:int;
      
      private var mCurrentPanel:FsgMatchResultPopupPanelBase;
      
      private var mInitialized:Boolean = false;
      
      private var mFirstAnimation:Boolean = true;
      
      private var mIsCyborgMode:Boolean = false;
      
      private var mProgressPanelData:AARProgressObj;
      
      private var mWeaponPanelData:Array;
      
      private var mChallengePanelData:Vector.<ChallengeBaseObj>;
      
      private var mWarGodMathResultData:WarGodMatchResultObj;
      
      private var mProgressPanel:FsgMatchResultProgressPopupPanel;
      
      private var mWeaponPanel:FsgMatchResultWeaponPopupPanel;
      
      private var mChallengesPanel:FsgMatchResultChallengesPopupPanel;
      
      private var mWarGodResultPanel:FsgMatchResultWarGodPopupPanel;
      
      private var mWarGodRewardPanel:FsgMatchResultWarGodRewardPopupPanel;
      
      private var mScoreboardPanel:FsgMatchResultScoreboardPopupPanel;
      
      private var mSpyScoreboardPanle:FsgMatchResultSpyScoreboardPopupPanel;
      
      private var mMissionAwardsPanel:MatchResultMissionAwardsPanel;
      
      private var mTransitionTween:TweenLite;
      
      private var mWarGodTabIndex:int = -1;
      
      private var m_excludeHideList:Array = new Array();
      
      private var mIsOnboarding:Boolean;
      
      private var mChallengeTab:Button;
      
      private var mPrevButtonClickHandler:Function;
      
      private var mNextButtonClickHandler:Function;
      
      private var mWaitingOtherMatchResultViewClose:Boolean;
      
      private var mZHuntKillZombieRewards:Array;
      
      public function FsgMatchResultsPopupView()
      {
         super();
         this.myScrim.mouseChildren = false;
         this.myScrim.buttonMode = false;
         this.myScrim.mouseEnabled = false;
         this.myNextButton.visible = false;
         this.myPrevButton.visible = false;
         this.myNextButton.y += 50;
         this.myPrevButton.y += 50;
         var style:TextStyle = GlobalGuide.styleTextHeader;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 40;
         this.myHeaderTF.textStyle = style;
         this.myHeaderTF.text = this.inDebugMode ? "AFTER ACTION REPORT" : DictMatchResults.AFTER_ACTION_REPORT_HEADER;
         this.myPanelHolder.x = this.myHeaderTF.x;
         this.myPanelHolder.y = this.myMatchResultsTabBar.y + 60;
         if(this.inDebugMode)
         {
            this.enableData();
         }
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unbind(DataID.LOBBY_SUMMARY_ROUNDAWARD,this.bind_lobbysummaryRoundAward);
         unlisten(BCEvent.EVT_REFRESH_MATCH_RESULT_VIEW,this.onRefershView);
      }
      
      override protected function enableData() : void
      {
         var i:int = 0;
         super.enableData();
         listen(BCEvent.EVT_REFRESH_MATCH_RESULT_VIEW,this.onRefershView);
         if(this.inDebugMode)
         {
            this.myMatchResultsTabBar.addTab("test");
            this.myMatchResultsTabBar.addTab("test2");
            this.myMatchResultsTabBar.init(this.onTabClicked);
            this.myMatchResultsTabBar.setSelectedTab(0);
            return;
         }
         this.mWaitingOtherMatchResultViewClose = false;
         if(!this.mInitialized)
         {
            this.initialize();
            if(this.mZHuntKillZombieRewards.length > 0)
            {
               broadcast(BCEvent.EVT_SHOW_ZHUNT_MATCH_REWARD_VIEW,this.mZHuntKillZombieRewards);
               this.myMatchResultsTabBar.visible = false;
               for(i = 0; i < this.mMatchResultPanels.length; i++)
               {
                  this.mMatchResultPanels[i].visible = false;
               }
               this.myHeaderTF.visible = false;
               this.mWaitingOtherMatchResultViewClose = true;
            }
         }
      }
      
      private function initialize() : void
      {
         var progressClass:Class = null;
         var bShowChallenges:Boolean = false;
         var bShowChecklist:Boolean = false;
         var challengesClass:Class = null;
         var weaponClass:Class = null;
         var scoreboardClass:Class = null;
         var spyScoreboardClass:Class = null;
         var warGodClass:Class = null;
         if(this.mInitialized)
         {
            return;
         }
         var challengeIndex:int = -1;
         this.mCurrentPanelIndex = 0;
         this.mMatchResultPanels = new Vector.<FsgMatchResultPopupPanelBase>();
         this.mInitialized = true;
         this.mIsCyborgMode = getDP(DataID.IS_CYBORG);
         this.mIsOnboarding = UiCppOnboarding.instance.GetJustPlayedMission();
         this.mProgressPanelData = getDP(DataID.LOBBY_SUMMARY_EXPBOARD);
         var playListNum:int = CFunctionCommonContainer.Dvar_GetInt("ui_played_playlist");
         var playedGametype:String = CFunctionCommonContainer.Dvar_GetString("ui_played_gametype");
         this.mZHuntKillZombieRewards = [];
         if(playedGametype == "zhunt")
         {
            this.mZHuntKillZombieRewards = CFunctionContainer.AS_GetZhuntModeMatchResult();
         }
         var tdRewards:Array = [];
         if(playedGametype == "td")
         {
            tdRewards = CFunctionContainer.AS_GetTDModeMatchResult();
         }
         if(this.mZHuntKillZombieRewards.length > 0 || tdRewards.length > 0 || this.mProgressPanelData.gainedExpValue > 0 || this.mProgressPanelData.gainedGpValue > 0 || this.gainedWarGodCurrency() || Boolean(playListNum > 0) && Boolean(CFunctionContainer.AS_IsDMZGametype(playedGametype)))
         {
            progressClass = getDefinitionByName("fsg.matchresults.fsgMatchResultProgressPanel") as Class;
            this.mProgressPanel = this.myPanelHolder.addChild(new progressClass()) as FsgMatchResultProgressPopupPanel;
            this.mMatchResultPanels.push(this.mProgressPanel);
            this.mProgressPanel.setOnboardMission(this.mIsOnboarding);
            this.mProgressPanel.setProgressData(this.mProgressPanelData);
            this.mProgressPanel.setZHuntKillZombieRewards(this.mZHuntKillZombieRewards);
            this.mProgressPanel.setTDRewards(tdRewards);
            this.mProgressPanel.onClaimButtonClickedCallback = this.onRandomRewardClaimButtonClicked;
            this.myMatchResultsTabBar.addTab(LOCALIZE(DictRoom.SUMMARY_TAB_PROGRESS));
            bind(DataID.LOBBY_SUMMARY_ROUNDAWARD,this.bind_lobbysummaryRoundAward);
         }
         if(this.isChallengeEnable())
         {
            this.mChallengePanelData = getDP(DataID.LOBBY_SUMMARY_CHALLENGEBOARD);
            bShowChallenges = this.mChallengePanelData.length > 0 && !this.mIsOnboarding;
            bShowChecklist = ChallengeService.getInstance().showOnboardingChecklist;
            if(bShowChallenges || bShowChecklist)
            {
               challengesClass = getDefinitionByName("fsg.matchresults.fsgMatchResultChallengesPanel") as Class;
               this.mChallengesPanel = this.myPanelHolder.addChild(new challengesClass()) as FsgMatchResultChallengesPopupPanel;
               challengeIndex = this.myMatchResultsTabBar.addTab(LOCALIZE(DictMatchResults.CHALLENGES));
               this.mMatchResultPanels.push(this.mChallengesPanel);
               this.mChallengesPanel.setChallengesData(this.mChallengePanelData,bShowChallenges,bShowChecklist);
            }
         }
         this.mWeaponPanelData = getDP(DataID.LOBBY_SUMMARY_WEAPONBOARD);
         if(null != this.mWeaponPanelData && 0 < this.mWeaponPanelData.length && !this.mIsOnboarding)
         {
            weaponClass = getDefinitionByName("fsg.matchresults.fsgMatchResultWeaponPopupPanel") as Class;
            this.mWeaponPanel = this.myPanelHolder.addChild(new weaponClass()) as FsgMatchResultWeaponPopupPanel;
            this.myMatchResultsTabBar.addTab(LOCALIZE(DictMatchResults.WEAPON_UPGRADES_BUTTON));
            this.mMatchResultPanels.push(this.mWeaponPanel);
            this.mWeaponPanel.setData(this.mWeaponPanelData);
         }
         if(true == this.isScoreboardEnable() && !this.mIsOnboarding)
         {
            scoreboardClass = getDefinitionByName("fsg.matchresults.fsgMatchResultScoreboardPanel") as Class;
            this.mScoreboardPanel = this.myPanelHolder.addChild(new scoreboardClass()) as FsgMatchResultScoreboardPopupPanel;
            this.mScoreboardPanel.skipAnimation(true);
            this.myMatchResultsTabBar.addTab(LOCALIZE(DictMatchResults.SCOREBOARD_BUTTON));
            this.mMatchResultPanels.push(this.mScoreboardPanel);
         }
         if(true == this.isSpyScoreboardEnable())
         {
            spyScoreboardClass = getDefinitionByName("fsg.matchresults.fsgMatchResultSpyScoreboardPanel") as Class;
            this.mSpyScoreboardPanle = this.myPanelHolder.addChild(new spyScoreboardClass()) as FsgMatchResultSpyScoreboardPopupPanel;
            this.myMatchResultsTabBar.addTab(LOCALIZE(DictMatchResults.SCOREBOARD_BUTTON));
            this.mMatchResultPanels.push(this.mSpyScoreboardPanle);
         }
         this.mWarGodMathResultData = getDP(DataID.LOBBY_SUMMARY_WARGOD);
         if(null != this.mWarGodMathResultData)
         {
            warGodClass = getDefinitionByName("codo.wargod.fsgMatchResultWarGodPanel") as Class;
            this.mWarGodResultPanel = this.myPanelHolder.addChild(new warGodClass()) as FsgMatchResultWarGodPopupPanel;
            this.myMatchResultsTabBar.addTab(LOCALIZE(Dict.MATCH_SELECT_MENU_OPTION_WARGOD));
            this.mWarGodResultPanel.setData(this.mWarGodMathResultData);
            this.mWarGodResultPanel.registerFullScreenOpenStateCallback(this.onFullScreenOpenStateChange);
            this.mWarGodTabIndex = this.mMatchResultPanels.length;
            this.mMatchResultPanels.push(this.mWarGodResultPanel);
         }
         if(null != this.mMatchResultPanels && 0 < this.mMatchResultPanels.length)
         {
            this.mCurrentPanel = this.mMatchResultPanels[this.mCurrentPanelIndex];
            if(this.mIsOnboarding)
            {
               this.myNextButton.visible = false;
            }
            this.myMatchResultsTabBar.init(this.onTabClicked);
            this.myMatchResultsTabBar.visible = false;
            if(challengeIndex > -1)
            {
               this.mChallengeTab = this.myMatchResultsTabBar.getTabByIndex(challengeIndex);
               this.mChallengeTab.visible = !this.mIsOnboarding;
            }
         }
      }
      
      private function bind_lobbysummaryRoundAward(result:ResultObj) : void
      {
         var awardsClass:Class = null;
         var awards:Vector.<UnlockItemObj> = result.data;
         if(null != awards && awards.length > 0 && !this.mIsOnboarding)
         {
            awardsClass = getDefinitionByName("fsg.matchresults.fsgMatchResultAccoladesPanel") as Class;
            this.mMissionAwardsPanel = this.myPanelHolder.addChild(new awardsClass()) as MatchResultMissionAwardsPanel;
            this.mMatchResultPanels.push(this.mMissionAwardsPanel);
            this.mMissionAwardsPanel.setAwards(awards);
            this.myMatchResultsTabBar.addTab(LOCALIZE(DictRoom.SUMMARY_MEDAL_TITLE));
         }
      }
      
      private function onTabClicked(currentTabIndex:int) : void
      {
         if(Boolean(this.mCurrentPanel) && this.mCurrentPanel.canAdvance())
         {
            this.mCurrentPanelIndex = currentTabIndex;
            this.UpdateCurrentPanel(true);
         }
      }
      
      private function get inDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
      
      private function formatButton(btn:Button, label:String) : void
      {
         btn.label = LOCALIZE(label);
         btn.width = btn.myLabel.myTextClip.textWidth + 40;
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(null != this.mTransitionTween && this.mTransitionTween.currentTime < this.mTransitionTween.totalTime)
         {
            this.mTransitionTween.complete();
         }
         this.mTransitionTween = TweenLite.to(this,SCRIM_FADE_DURATION,{"alpha":1});
         if(this.mFirstAnimation && this.myScrim.visible)
         {
            this.mFirstAnimation = false;
            TweenLite.to(this.myScrim,0.1,{
               "delay":1.2,
               "alpha":0,
               "onComplete":this.onFadeInComplete
            });
         }
         broadcast(BCEvent.EVT_HIDE_PERSISTENT_VIEW,{"exclude":this.m_excludeHideList});
         broadcast(BCEvent.EVT_MATCH_RESULTS_OPEN);
      }
      
      public function onFadeInComplete() : void
      {
         if(this.mWaitingOtherMatchResultViewClose)
         {
            return;
         }
         this.onRefershView(null);
      }
      
      private function setPanelNavigation() : void
      {
         this.mIsOnboarding = false;
         this.updatePrevNextButton();
         if(this.mChallengeTab != null)
         {
            this.mChallengeTab.visible = true;
         }
      }
      
      private function onRandomRewardClaimButtonClicked() : void
      {
         this.myNextButton.visible = false;
         this.myPrevButton.visible = false;
      }
      
      override protected function hideView() : void
      {
         if(null != this.mTransitionTween && this.mTransitionTween.currentTime < this.mTransitionTween.totalTime)
         {
            this.mTransitionTween.complete();
         }
         this.mTransitionTween = TweenLite.to(this,SCRIM_FADE_DURATION,{
            "alpha":0,
            "onComplete":this.finishHideView
         });
         unlisten(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
      }
      
      private function refreshChallenges() : void
      {
         this.mChallengePanelData = getDP(DataID.LOBBY_SUMMARY_CHALLENGEBOARD);
         var bShowChallenges:Boolean = this.mChallengePanelData.length > 0;
         var bShowChecklist:Boolean = ChallengeService.getInstance().showOnboardingChecklist;
         if(bShowChallenges || bShowChecklist)
         {
            this.mChallengesPanel.setChallengesData(this.mChallengePanelData,bShowChallenges,bShowChecklist);
         }
         else
         {
            this.mChallengesPanel.displayNoChallengesAvailable();
         }
      }
      
      private function finishHideView() : void
      {
         super.hideView();
         broadcast(BCEvent.EVT_SET_UIVIEWER_MODE,{
            "mode":Common.UIVIEWER_MODE_TEAM,
            "status":Common.UIVIEWER_POS_NONE,
            "gametype":(this.mIsCyborgMode ? Common.UIVIEWER_GAME_ZM : Common.UIVIEWER_GAME_MP)
         });
         broadcast(BCEvent.EVT_CLOSE_MATCH_RESULTS);
         broadcast(BCEvent.EVT_SHOW_PERSISTENT_VIEW);
         Logger.print("Finish hide match result popup view");
         if(Boolean(CFunctionCommonContainer.IsInRoom()) && !CFunctionContainer.AS_IsHiddenRoomMatch())
         {
            Logger.print("Broadcast EVT MATCH RESULTS SHOW LOBBY");
            broadcast(BCEvent.EVT_MATCH_RESULTS_SHOW_LOBBY);
         }
         else
         {
            broadcast(BCEvent.EVT_GOTO_MATCH_SELECT);
         }
      }
      
      private function isScoreboardEnable() : Boolean
      {
         if(ScaleformUtil.isScaleform == true)
         {
            return getDP(DataID.EOG_IS_SCOREBOARD_ENABLE);
         }
         return true;
      }
      
      private function isChallengeEnable() : Boolean
      {
         return getDP(DataID.EOG_IS_CHALLENGE_ENABLE);
      }
      
      private function isSpyScoreboardEnable() : Boolean
      {
         if(ScaleformUtil.isScaleform == true)
         {
            return getDP(DataID.EOG_IS_SPY_SCOREBOARD_ENABLE);
         }
         return true;
      }
      
      private function UpdateCurrentPanel(isSetByTab:Boolean = false) : void
      {
         if(this.mCurrentPanelIndex <= 0)
         {
            this.mCurrentPanelIndex = 0;
         }
         this.updateButtonsVisibility();
         this.mCurrentPanel.deactive();
         this.mCurrentPanel = this.mMatchResultPanels[this.mCurrentPanelIndex];
         this.mCurrentPanel.active();
         if(this.mScoreboardPanel != null && this.mCurrentPanel == this.mScoreboardPanel)
         {
            this.myMatchResultsModeMapDisplay.deactive();
         }
         if(!isSetByTab)
         {
            this.myMatchResultsTabBar.setSelectedTab(this.mCurrentPanelIndex,true);
         }
      }
      
      private function updatePrevNextButton() : void
      {
         var prevBtnText:String = null;
         var nextBtnText:String = null;
         var prevBtnVisible:Boolean = false;
         var nextBtnVisible:Boolean = false;
         var prevBtnHandler:Function = null;
         var nextBtnHandler:Function = null;
         var rejoinDMZEnable:Boolean = false;
         var playListNum:int = CFunctionCommonContainer.Dvar_GetInt("ui_played_playlist");
         var playedGametype:String = CFunctionCommonContainer.Dvar_GetString("ui_played_gametype");
         var hasPrevPanel:Boolean = this.mCurrentPanelIndex >= 1;
         var isLastPanel:Boolean = this.mCurrentPanelIndex == this.mMatchResultPanels.length - 1;
         var isInRoom:Boolean = CFunctionCommonContainer.IsInRoom() as Boolean;
         var isLeavingRoom:Boolean = CFunctionCommonContainer.IsLeavingRoom() as Boolean;
         var isDMZ:Boolean = playListNum > 0 && Boolean(CFunctionContainer.AS_IsDMZGametype(playedGametype));
         var isInParty:Boolean = getDP(DataID.IS_IN_PARTY);
         var isDMZLeague:Boolean = getDP(DataID.IS_BATTLE_CITY_LEAGUE_MATCH);
         var hasDMZLeagueTicket:Boolean = getDP(DataID.BATTLE_CITY_LEAGUE_HAS_SUFFICIENT_TICKET);
         if(!isLastPanel)
         {
            prevBtnText = Dict.PREVIOUS_PAGE;
            prevBtnVisible = hasPrevPanel;
            prevBtnHandler = this.onPreviousPage;
            nextBtnText = Dict.NEXT_PAGE;
            nextBtnVisible = !this.mIsOnboarding;
            nextBtnHandler = this.onNextPage;
         }
         else
         {
            rejoinDMZEnable = isDMZ && !isInRoom && !isInParty;
            if(isDMZLeague && !hasDMZLeagueTicket)
            {
               rejoinDMZEnable = false;
            }
            if(rejoinDMZEnable)
            {
               prevBtnVisible = true;
               prevBtnText = DictRoom.RETURN_MAIN_MENU;
               prevBtnHandler = this.closePopupView;
               nextBtnVisible = true;
               nextBtnText = DictRoom.JOIN;
               nextBtnHandler = this.rematchDMZ;
            }
            else
            {
               prevBtnText = Dict.PREVIOUS_PAGE;
               prevBtnVisible = hasPrevPanel;
               prevBtnHandler = this.onPreviousPage;
               nextBtnText = isInRoom && !isLeavingRoom ? DictRoom.BACK_TO_ROOM : DictRoom.RETURN_MAIN_MENU;
               nextBtnVisible = true;
               nextBtnHandler = this.closePopupView;
            }
         }
         this.myPrevButton.visible = prevBtnVisible;
         this.formatButton(this.myPrevButton,prevBtnText);
         this.mPrevButtonClickHandler = this.updateButtonClickHandler(this.myPrevButton,this.mPrevButtonClickHandler,prevBtnHandler);
         this.myNextButton.visible = nextBtnVisible;
         this.formatButton(this.myNextButton,nextBtnText);
         this.mNextButtonClickHandler = this.updateButtonClickHandler(this.myNextButton,this.mNextButtonClickHandler,nextBtnHandler);
         this.myPrevButton.x = this.myNextButton.x - (this.myPrevButton.width + 10);
      }
      
      private function updateButtonClickHandler(button:Button, oldHandler:Function, newHandler:Function) : Function
      {
         if(oldHandler != null)
         {
            button.unRegisterClickEvent(oldHandler);
         }
         if(newHandler != null)
         {
            button.registerClickEvent(newHandler);
         }
         return newHandler;
      }
      
      private function rematchDMZ() : void
      {
         var playListNum:int = CFunctionCommonContainer.Dvar_GetInt("ui_played_playlist");
         var playListObj:PlayListObj = MatchService.getInstance().getPlayListObj(playListNum);
         broadcast(BCEvent.EVT_START_QUICK_MATCH_MP,{"data":playListObj});
      }
      
      private function onNextPage() : void
      {
         var playListNum:int = 0;
         var playedGametype:String = null;
         var isInParty:Boolean = false;
         var leftPlaylistDMZGame:Boolean = false;
         var playListObj:PlayListObj = null;
         if(this.mCurrentPanel.canAdvance())
         {
            if(this.mCurrentPanelIndex + 1 >= this.mMatchResultPanels.length && true == this.canClosePopup())
            {
               playListNum = CFunctionCommonContainer.Dvar_GetInt("ui_played_playlist");
               playedGametype = CFunctionCommonContainer.Dvar_GetString("ui_played_gametype");
               isInParty = getDP(DataID.IS_IN_PARTY);
               leftPlaylistDMZGame = !CFunctionCommonContainer.IsInRoom() && !isInParty && playListNum > 0 && Boolean(CFunctionContainer.AS_IsDMZGametype(playedGametype));
               if(leftPlaylistDMZGame)
               {
                  playListObj = MatchService.getInstance().getPlayListObj(playListNum);
                  broadcast(BCEvent.EVT_START_QUICK_MATCH_MP,{"data":playListObj});
               }
               else
               {
                  this.closePopupView();
               }
            }
            else if(this.mCurrentPanelIndex + 1 < this.mMatchResultPanels.length)
            {
               ++this.mCurrentPanelIndex;
               this.UpdateCurrentPanel();
            }
         }
      }
      
      private function onPreviousPage() : void
      {
         if(this.mCurrentPanel.canAdvance())
         {
            --this.mCurrentPanelIndex;
            this.UpdateCurrentPanel();
         }
      }
      
      private function canClosePopup() : Boolean
      {
         for(var i:int = 0; i < this.mMatchResultPanels.length; i++)
         {
            if(false == this.mMatchResultPanels[i].canAdvance())
            {
               return false;
            }
         }
         return true;
      }
      
      private function closePopupView() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
         if(this.checkIsFirstTimeGetHeroicTier())
         {
            broadcast(BCEvent.EVT_SEND_HEROIC_TIER_NOTIFICATION);
         }
         if(CharacterLoadoutService.getInstance().showExceededCharacterLimit())
         {
            CharacterLoadoutService.getInstance().resetShowExceededCharacterLimit();
            broadcast(BCEvent.EVT_SHOW_CHARACTER_SWAP,FsgCharacterSwapViewContent.POPUP_STATE_MAX_CHARACTERS_WARNING);
         }
      }
      
      private function checkIsFirstTimeGetHeroicTier() : Boolean
      {
         if(!this.mWarGodMathResultData)
         {
            return false;
         }
         return this.mWarGodMathResultData.firstTimeGetHeroicTier;
      }
      
      private function onFullScreenOpenStateChange(isOpen:Boolean) : void
      {
         this.updateButtonsVisibility();
      }
      
      private function gainedWarGodCurrency() : Boolean
      {
         var wargodDetails:Array = CFunctionContainer.AS_GetPromotionScoreDetails();
         var playerObj:WarGodPlayerObj = getDP(DataID.PLAYER_WARGOD_DATA);
         if(WarGodUtility.isJuniorWarGod(playerObj))
         {
            if(wargodDetails[HPEHPRewardBox.ARRAY_INDEX_JUNIOR_WARGOD_CURRENCY_GAINED] > 0)
            {
               return true;
            }
         }
         else if(wargodDetails[HPEHPRewardBox.ARRAY_INDEX_SENIOR_WARGOD_CURRENCY_GAINED] > 0)
         {
            return true;
         }
         return false;
      }
      
      private function updateButtonsVisibility() : void
      {
         var matchResultWarGodPanel:FsgMatchResultWarGodPopupPanel = null;
         this.myMatchResultsTabBar.visible = true;
         if(this.mCurrentPanelIndex == this.mWarGodTabIndex && this.mWarGodTabIndex < this.mMatchResultPanels.length)
         {
            matchResultWarGodPanel = this.mMatchResultPanels[this.mCurrentPanelIndex] as FsgMatchResultWarGodPopupPanel;
            if(Boolean(matchResultWarGodPanel) && matchResultWarGodPanel.playingPromotionAnimation())
            {
               this.myHeaderTF.visible = this.myMatchResultsTabBar.visible = this.myPrevButton.visible = this.myNextButton.visible = false;
               return;
            }
         }
         this.myHeaderTF.visible = this.myMatchResultsTabBar.visible = true;
         this.updatePrevNextButton();
      }
      
      private function onRefershView(cEvt:ParaEvent) : void
      {
         this.myHeaderTF.visible = true;
         if(null != this.mCurrentPanel)
         {
            this.mCurrentPanel.active();
            this.myMatchResultsTabBar.visible = true;
         }
         this.updatePrevNextButton();
         if(this.mMatchResultPanels == null || this.mMatchResultPanels.length == 0)
         {
            this.myNextButton.visible = false;
            this.myPrevButton.visible = false;
            this.closePopupView();
            if(Boolean(CFunctionCommonContainer.GameMomentsIsLastMatchRecorded()))
            {
               broadcast(BCCommonEvent.EVT_GAMEMOMENTS_EDIT);
            }
            return;
         }
         if(this.mProgressPanel != null)
         {
            if(!this.mIsOnboarding)
            {
               this.setPanelNavigation();
            }
            this.mProgressPanel.presentationCompleteCallback = this.setPanelNavigation;
         }
         broadcast(BCEvent.EVT_ENABLE_PREV_MATCH_SUMMARY,{"isCyborg":this.mIsCyborgMode});
         broadcast(BCEvent.EVT_SHOW_BATTLECITY_LEAGUE_AWARD);
         broadcast(BCEvent.EVT_SHOW_BATTLECITY_TICKET_REWARD);
         if(Boolean(CFunctionCommonContainer.GameMomentsIsLastMatchRecorded()))
         {
            broadcast(BCCommonEvent.EVT_GAMEMOMENTS_EDIT);
         }
         listen(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
         this.myMatchResultsTabBar.visible = true;
         this.myMatchResultsTabBar.setSelectedTab(0);
      }
   }
}

