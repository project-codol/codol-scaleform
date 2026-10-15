package codo.views.wargod_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.WebImgData;
   import codo.cpp.UiCppMatchSelectView;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictWarGod;
   import codo.objects.FeaturedAdObj;
   import codo.objects.PartyMemberObj;
   import codo.objects.PlayListObj;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodPlaylistObj;
   import codo.objects.WarGodSeasonObj;
   import codo.objects.WebAdObj;
   import codo.style.WarGodGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.StringUtil;
   import codo.utils.TLogUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WarGodProgressPanel extends BaseSubElement
   {
      
      public static const TYPE_NEW_SEASON_PICK:int = 0;
      
      public static const TYPE_PLACEMENT:int = 1;
      
      public static const TYPE_STAR:int = 2;
      
      public static const TYPE_PROMOTION:int = 3;
      
      public static const TYPE_HEROIC:int = 4;
      
      public static const TYPE_CLOSED:int = 5;
      
      public static const JUNIOR_REWARD1_INDEX:int = 0;
      
      public static const JUNIOR_REWARD2_INDEX:int = 1;
      
      public static const WARGOD_REWARD1_INDEX:int = 2;
      
      public static const WARGOD_REWARD2_INDEX:int = 3;
      
      public var mySeasonDescription:SeasonDescription;
      
      public var myLevelUpIndicator:LevelUpIndicator;
      
      public var myWarGodProgressBg:MovieClip;
      
      public var mySeasonRotationSelection:SeasonRotationSelection;
      
      public var myPlayInfoIcon:MovieClip;
      
      public var myPlayInfo:TextField;
      
      public var myJuniorWarGodStartButton:JuniorWarGodStartButton;
      
      public var myPlacementMatchStatus:WarGodPlacementMatchStatus;
      
      public var myPromotionMatchStatus:WarGodPromotionMatchStatus;
      
      public var myHeroicStarMeter:HeroicTierStarMeter;
      
      public var myHeroicTierProgressBar:HeroicTierProgressBar;
      
      public var mySeasonEndPanel:WarGodSeasonEndPanel;
      
      public var myADSlide1:WarGodAdSlideShow;
      
      public var myADSlide2:WarGodAdSlideShow;
      
      public var myLastMatchLabel:TextField;
      
      public var myPromotionMatchLabel:TextField;
      
      private var mType:int;
      
      private var mUIListByType:Array = [];
      
      private var mSeasonObj:WarGodSeasonObj;
      
      private var mGlobalSetting:WarGodGlobalSettingObj;
      
      private var mPlayerWarGod:WarGodPlayerObj;
      
      private var mUiCpp:UiCppMatchSelectView;
      
      private var mPartyMembers:Array;
      
      private var mEditedPlaylistOption:Array;
      
      private var mTSSWaiting:Timer;
      
      private var mIsWaitingPartyMemberTSS:Boolean = false;
      
      public function WarGodProgressPanel()
      {
         super();
         this.mUIListByType[TYPE_NEW_SEASON_PICK] = [this.mySeasonDescription,this.myWarGodProgressBg,this.mySeasonRotationSelection,this.myADSlide1,this.myADSlide2,this.myPlayInfo,this.myPlayInfoIcon];
         this.mUIListByType[TYPE_PLACEMENT] = [this.myWarGodProgressBg,this.mySeasonDescription,this.myPlacementMatchStatus,this.myADSlide1,this.myADSlide2,this.myPlayInfo,this.myPlayInfoIcon,this.myJuniorWarGodStartButton];
         this.mUIListByType[TYPE_STAR] = [this.myWarGodProgressBg,this.mySeasonDescription,this.myLevelUpIndicator,this.myADSlide1,this.myADSlide2,this.myPlayInfo,this.myPlayInfoIcon,this.myJuniorWarGodStartButton];
         this.mUIListByType[TYPE_PROMOTION] = [this.myWarGodProgressBg,this.mySeasonDescription,this.myPromotionMatchStatus,this.myADSlide1,this.myADSlide2,this.myPlayInfo,this.myPlayInfoIcon,this.myJuniorWarGodStartButton];
         this.mUIListByType[TYPE_HEROIC] = [this.myWarGodProgressBg,this.mySeasonDescription,this.myHeroicStarMeter,this.myADSlide1,this.myADSlide2,this.myPlayInfo,this.myPlayInfoIcon,this.myJuniorWarGodStartButton];
         this.mUIListByType[TYPE_CLOSED] = [this.mySeasonEndPanel];
         this.myPlayInfo.textStyle = WarGodGuide.styleMatchInfo;
         this.myPlayInfo.width = 915;
         this.myPlayInfo.height = 20;
         this.myLastMatchLabel.textStyle = WarGodGuide.styleWarGodCommonLabel;
         this.myLastMatchLabel.width = 320;
         this.myLastMatchLabel.height = 25;
         this.myLastMatchLabel.x = 18;
         this.myLastMatchLabel.y = 420;
         this.myLastMatchLabel.text = DictWarGod.WARGOD_LAST_MATCH_LABEL;
         this.myPromotionMatchLabel.textStyle = WarGodGuide.styleWarGodCommonLabel;
         this.myPromotionMatchLabel.width = 320;
         this.myPromotionMatchLabel.height = 25;
         this.myPromotionMatchLabel.x = 18;
         this.myPromotionMatchLabel.y = 420;
         this.myPromotionMatchLabel.text = DictWarGod.WARGOD_PROMOTION_MATCH_LABEL;
         this.myJuniorWarGodStartButton.myStartButton.registerClickEvent(this.onStartMatchClickHandler);
         this.myJuniorWarGodStartButton.registerOptionChangeEvent(this.onJuniorWarGodPlaylistOptionChanged);
         this.myJuniorWarGodStartButton.registerOptionOpenStateChange(this.onJuniorWarGodPlaylistConfigureChanged);
      }
      
      override public function active() : void
      {
         super.active();
         this.mSeasonObj = getDP(DataID.CURRENT_WARGOD_INFO);
         this.mGlobalSetting = getDP(DataID.WARGOD_GLOBAL_SETTING);
         this.mPlayerWarGod = getDP(DataID.PLAYER_WARGOD_DATA);
         this.initTSSTimer();
         this.checkPartyState();
         this.update();
         listen(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangeHandler);
         listen(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpeningStateChanged);
         listen(BCEvent.EVT_WARGOD_PLAYER_OBJ_CHANGED,this.onWarGodPlayerObjChanged);
         listen(BCEvent.EVT_WARGOD_TSS_STATE_CHANGED,this.onTSSStateChanged);
         addDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getPlaylist);
         bind(DataID.WARGOD_LEADERBOARD_TOP100,this.onGetSeasonTop10Player);
         bind(DataID.PARTY_INFO,this.onUpdatePartyInfo);
         bind(DataID.WEB_IMG_STATUS,this.bindWebImgStatus);
         this.myADSlide2.myAdMount.addEventListener(MouseEvent.CLICK,this.onAD2SlideClicked);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.killTSSTimer();
         unlisten(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangeHandler);
         unlisten(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpeningStateChanged);
         unlisten(BCEvent.EVT_WARGOD_PLAYER_OBJ_CHANGED,this.onWarGodPlayerObjChanged);
         unlisten(BCEvent.EVT_WARGOD_TSS_STATE_CHANGED,this.onTSSStateChanged);
         removeDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getPlaylist);
         unbind(DataID.WARGOD_LEADERBOARD_TOP100,this.onGetSeasonTop10Player);
         unbind(DataID.PARTY_INFO,this.onUpdatePartyInfo);
         unbind(DataID.WEB_IMG_STATUS,this.bindWebImgStatus);
         this.myADSlide1.stopTimer();
         this.myADSlide2.stopTimer();
         this.myJuniorWarGodStartButton.deactive();
         this.myADSlide2.myAdMount.removeEventListener(MouseEvent.CLICK,this.onAD2SlideClicked);
      }
      
      private function initTSSTimer() : void
      {
         this.mTSSWaiting = new Timer(this.mGlobalSetting.tssTimeout * 1000);
         this.mTSSWaiting.addEventListener(TimerEvent.TIMER,this.onTSSTimeout);
      }
      
      private function killTSSTimer() : void
      {
         if(this.mTSSWaiting != null)
         {
            this.mTSSWaiting.stop();
            this.mTSSWaiting.reset();
            this.mTSSWaiting.removeEventListener(TimerEvent.TIMER,this.onTSSTimeout);
            this.mTSSWaiting = null;
         }
      }
      
      private function onWarGodOpeningStateChanged(cEvt:ParaEvent) : void
      {
         if(Boolean(this.mPlayerWarGod))
         {
            this.mSeasonObj = getDP(DataID.CURRENT_WARGOD_INFO);
            this.mGlobalSetting = getDP(DataID.WARGOD_GLOBAL_SETTING);
            this.mPlayerWarGod = getDP(DataID.PLAYER_WARGOD_DATA);
            this.update();
         }
      }
      
      private function onTSSStateChanged(cEvt:ParaEvent) : void
      {
         Logger.print("[TSS] Player credit rating is ready");
         this.endWaitingTSS(false);
      }
      
      private function onTSSTimeout(evt:TimerEvent) : void
      {
         Logger.print("[TSS] Waiting timeout");
         this.endWaitingTSS(this.mIsWaitingPartyMemberTSS);
      }
      
      private function onWarGodPlayerObjChanged(evt:ParaEvent) : void
      {
         this.mPlayerWarGod = getDP(DataID.PLAYER_WARGOD_DATA);
         this.update();
      }
      
      private function update() : void
      {
         this.mySeasonEndPanel.setData(this.mSeasonObj,this.mPlayerWarGod,this.mGlobalSetting);
         if(this.mySeasonEndPanel.isSeasonClosed())
         {
            this.setType(TYPE_CLOSED);
            return;
         }
         if(this.mPlayerWarGod.phase == WarGodPlayerObj.PHASE_STAR && this.mPlayerWarGod.warGodRank.tier == PlayerWarGodRank.TIER_HEROIC)
         {
            this.setType(TYPE_HEROIC);
         }
         else
         {
            this.setType(this.getPanelTypeByPhase(this.mPlayerWarGod.phase));
         }
      }
      
      private function onStartMatchClickHandler() : void
      {
         var playerData:WarGodPlayerObj = getDP(DataID.PLAYER_WARGOD_DATA);
         if(!this.mPlayerWarGod.tssReady)
         {
            Logger.print("[TSS] Player credit rating is not ready.");
            this.startWaitingTSS(false);
            return;
         }
         if(!this.checkPartyMemberTSS())
         {
            Logger.print("[TSS] Party member credit rating is not ready.");
            this.startWaitingTSS(true);
            return;
         }
         this.realStartMatchMaking();
      }
      
      private function realStartMatchMaking() : void
      {
         var reason:String = null;
         if(!this.mPlayerWarGod.tssSatisfied)
         {
            reason = CFunctionContainer.AS_GetCreditRatingInfo();
            if(StringUtil.trim(reason) == "")
            {
               reason = DictWarGod.WARGOD_TSS_NOT_QUALIFIED;
            }
            showMsg(reason,MsgBtnCount.ONE);
            CFunctionContainer.AS_SendTSSBlockTLog(CFunctionCommonContainer.GetPlayerID(),false);
            return;
         }
         if(WarGodUtility.isJuniorWarGod(this.mPlayerWarGod))
         {
            this.saveJuniorWarGodPlaylistOptions();
            this.decideWhichPlaylist();
         }
         var state:int = getDP(DataID.WARGOD_OPENING_STATE);
         if(state == WarGodSeasonObj.STATE_PAUSE)
         {
            showMsg(this.mGlobalSetting.playlistOpenTimeLabel,MsgBtnCount.ONE);
            return;
         }
         if(!this.checkPartyEnabledCondition())
         {
            showMsg(DictWarGod.WARGOD_PARTY_NOT_ENABLED,MsgBtnCount.ONE);
            return;
         }
         if(!this.checkPartyMemberPendingPhase())
         {
            return;
         }
         if(!CFunctionContainer.AS_IsPartyMemberWargodTierOffsetValid())
         {
            showMsg(DictWarGod.WARGOD_PARTY_MEMBER_LEVEL_GAP_TOO_BIG,MsgBtnCount.ONE);
            return;
         }
         if(!this.checkPartyMemberJoinCondition())
         {
            return;
         }
         var pl:PlayListObj = this.getPlaylist();
         if(pl != null)
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_BATTLE_PREP,pl.id.toString());
            broadcast(BCEvent.EVT_BOTTOM_START_GAME);
         }
         else
         {
            showMsg(DictWarGod.CHECK_AT_LEAST_ONE_PLAYLIST,1);
            this.myJuniorWarGodStartButton.forceOpenPlaylistSelector();
         }
      }
      
      private function startWaitingTSS(isParty:Boolean) : void
      {
         if(!isParty)
         {
            this.mIsWaitingPartyMemberTSS = false;
            showMsg(DictWarGod.WARGOD_TSS_WAITING);
         }
         else
         {
            this.mIsWaitingPartyMemberTSS = true;
            showMsg(DictWarGod.WARGOD_TSS_PARTY_WAITING);
         }
         this.mTSSWaiting.start();
      }
      
      private function endWaitingTSS(isParty:Boolean) : void
      {
         if(this.mTSSWaiting.running)
         {
            hideMsg();
            this.mTSSWaiting.stop();
            this.mTSSWaiting.reset();
            if(isParty)
            {
               this.mIsWaitingPartyMemberTSS = false;
            }
            this.realStartMatchMaking();
         }
      }
      
      private function onJuniorWarGodPlaylistOptionChanged(data:Array) : void
      {
         this.mEditedPlaylistOption = data;
      }
      
      private function onJuniorWarGodPlaylistConfigureChanged(isOpen:Boolean) : void
      {
         if(!isOpen)
         {
            this.saveJuniorWarGodPlaylistOptions();
         }
      }
      
      private function saveJuniorWarGodPlaylistOptions() : void
      {
         if(null != this.mEditedPlaylistOption)
         {
            broadcast(BCEvent.EVT_JUNIOR_WARGOD_PLAYLIST_OPTION_CHANGED,this.mEditedPlaylistOption);
         }
      }
      
      private function decideWhichPlaylist() : void
      {
         var j:int = 0;
         var wargodPlaylistWrapper:WarGodPlaylistObj = getDP(DataID.GET_JUNIOR_WARGOD_MATCHMAKING_PLAYLIST);
         var juniorWarGodPlayList:Array = wargodPlaylistWrapper.playlist;
         var playLists:Array = getDP(DataID.LIST_PLAY_LIST_MP);
         var numJuniorWarGodPlaylist:int = int(juniorWarGodPlayList.length);
         var numPlayLists:int = int(playLists.length);
         var selectedList:Array = new Array();
         for(var i:int = 0; i < numPlayLists; i++)
         {
            for(j = 0; j < numJuniorWarGodPlaylist; j++)
            {
               if(playLists[i].index == juniorWarGodPlayList[j].id)
               {
                  if(Boolean(juniorWarGodPlayList[j].checked))
                  {
                     selectedList.push(playLists[i]);
                  }
                  break;
               }
            }
         }
         broadcast(BCEvent.EVT_DECIDE_JUNIOR_WARGOD_PLAYLIST,selectedList);
      }
      
      private function getPlaylist() : PlayListObj
      {
         var playlist:PlayListObj = this.mUiCpp.GetWarGodPlaylist();
         if(Boolean(playlist))
         {
            playlist.isWarGod = true;
         }
         return playlist;
      }
      
      public function setUiCpp(uiCpp:UiCppMatchSelectView) : void
      {
         this.mUiCpp = uiCpp;
      }
      
      private function onPartyStateChangeHandler(cEvt:ParaEvent) : void
      {
         this.checkPartyState();
      }
      
      private function checkPartyState() : void
      {
         this.myPlayInfoIcon.visible = this.myPlayInfo.visible = this.mGlobalSetting.partyEnabled;
         var isInParty:Boolean = getDP(DataID.IS_IN_PARTY);
         var info:String = isInParty ? DictWarGod.WARGOD_IN_PARTY_INFO : DictWarGod.WARGOD_NOT_IN_PARTY;
         this.myPlayInfo.text = info;
         if(!isInParty)
         {
            this.mPartyMembers = null;
         }
         this.saveJuniorWarGodPlaylistOptions();
         if(WarGodUtility.isJuniorWarGod(this.mPlayerWarGod))
         {
            this.myJuniorWarGodStartButton.updatePlaylist();
         }
         else
         {
            this.myJuniorWarGodStartButton.updateSeniorWarGodPlaylist();
         }
      }
      
      public function setType(type:int) : void
      {
         this.mType = type;
         this.changeAppearance();
      }
      
      private function changeAppearance() : void
      {
         this.clearEverything();
         var uiElements:Array = this.mUIListByType[this.mType];
         var numElements:int = int(uiElements.length);
         for(var i:int = 0; i < numElements; i++)
         {
            addChild(uiElements[i]);
            if(uiElements[i] is IWarGodUIElement)
            {
               (uiElements[i] as IWarGodUIElement).setData(this.mSeasonObj,this.mPlayerWarGod,this.mGlobalSetting);
            }
         }
      }
      
      private function clearEverything() : void
      {
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      private function getPanelTypeByPhase(phase:int) : int
      {
         if(phase == WarGodPlayerObj.PHASE_PENDING)
         {
            return TYPE_NEW_SEASON_PICK;
         }
         if(phase == WarGodPlayerObj.PHASE_PLACEMENT)
         {
            return TYPE_PLACEMENT;
         }
         if(phase == WarGodPlayerObj.PHASE_STAR)
         {
            return TYPE_STAR;
         }
         return TYPE_PROMOTION;
      }
      
      private function onGetSeasonTop10Player(cRes:Object) : void
      {
         var leaderboardData:Object = cRes.data;
         this.myHeroicTierProgressBar.setSelfLBState(leaderboardData.selfStats);
         this.mySeasonEndPanel.setTopPlayerState(leaderboardData.statsList);
      }
      
      private function onUpdatePartyInfo(cRes:Object) : void
      {
         this.mPartyMembers = cRes.data.members;
         if(this.mIsWaitingPartyMemberTSS && this.checkPartyMemberTSS())
         {
            Logger.print("[TSS] Party member credit rating are ready now");
            this.endWaitingTSS(true);
         }
      }
      
      private function bindWebImgStatus(cResult:Object) : void
      {
         var adObj:Array = null;
         var index:int = 0;
         var requestedAdObject:Array = [WebImgData.WARGODREWARD1.id,WebImgData.WARGODREWARD2.id,WebImgData.WARGODREWARD3.id,WebImgData.WARGODREWARD4.id];
         var rewardImgs:Array = [[],[],[],[]];
         var imgCheckerData:Array = cResult.data;
         for(var i:uint = 0; i < imgCheckerData.length; i++)
         {
            adObj = imgCheckerData[i];
            if(adObj.length > 0)
            {
               index = requestedAdObject.indexOf(adObj[0].imgData.id);
               if(-1 != index)
               {
                  rewardImgs[index] = WebImgData.getWebImgURLs(adObj[0].imgData.id,adObj.length);
               }
            }
         }
         this.setRewardImages(rewardImgs);
      }
      
      private function setRewardImages(imgs:Array) : void
      {
         var imgList1:Array = null;
         var imgList2:Array = null;
         var webAd:WebAdObj = null;
         var featureAd:FeaturedAdObj = null;
         if(WarGodUtility.isJuniorWarGod(this.mPlayerWarGod))
         {
            imgList1 = imgs[JUNIOR_REWARD1_INDEX];
            imgList2 = imgs[JUNIOR_REWARD2_INDEX];
         }
         else
         {
            imgList1 = imgs[WARGOD_REWARD1_INDEX];
            imgList2 = imgs[WARGOD_REWARD2_INDEX];
         }
         var i:int = 0;
         var reward1Data:Vector.<FeaturedAdObj> = new Vector.<FeaturedAdObj>();
         var reward2Data:Vector.<FeaturedAdObj> = new Vector.<FeaturedAdObj>();
         for(i = 0; i < imgList1.length; i++)
         {
            webAd = new WebAdObj(imgList1[i],null);
            featureAd = new FeaturedAdObj("codo.wargod.webAdSlide",webAd);
            reward1Data.push(featureAd);
         }
         for(i = 0; i < imgList2.length; i++)
         {
            webAd = new WebAdObj(imgList2[i],null);
            featureAd = new FeaturedAdObj("codo.wargod.webAdSlide",webAd);
            reward2Data.push(featureAd);
         }
         this.myADSlide1.setData(reward1Data);
         this.myADSlide2.setData(reward2Data);
      }
      
      private function checkPartyEnabledCondition() : Boolean
      {
         if(Boolean(getDP(DataID.IS_IN_PARTY)) && !this.mGlobalSetting.partyEnabled)
         {
            return false;
         }
         return true;
      }
      
      private function checkPartyMemberPendingPhase() : Boolean
      {
         var partyMember:PartyMemberObj = null;
         if(!this.mPartyMembers)
         {
            return true;
         }
         for(var i:int = 0; i < this.mPartyMembers.length; i++)
         {
            partyMember = this.mPartyMembers[i] as PartyMemberObj;
            if(partyMember.wargodPhase == WarGodPlayerObj.PHASE_PENDING)
            {
               showMsg(LocalizeUtil.param(DictWarGod.WARGOD_PARTY_MEMBER_PENDING_PHASE,[partyMember.name]),MsgBtnCount.ONE);
               return false;
            }
         }
         return true;
      }
      
      private function checkPartyMemberTSS() : Boolean
      {
         var partyMember:PartyMemberObj = null;
         if(!this.mPartyMembers)
         {
            return true;
         }
         if(this.mPartyMembers.length <= 1)
         {
            return true;
         }
         for(var i:int = 0; i < this.mPartyMembers.length; i++)
         {
            partyMember = this.mPartyMembers[i] as PartyMemberObj;
            if(!partyMember.creditRatingDataReady)
            {
               return false;
            }
         }
         return true;
      }
      
      private function checkPartyMemberJoinCondition() : Boolean
      {
         var partyMember:PartyMemberObj = null;
         var msg:String = null;
         var levelString:String = null;
         if(!this.mPartyMembers)
         {
            return true;
         }
         if(this.mPartyMembers.length <= 1)
         {
            return true;
         }
         if(this.mPartyMembers.length > this.mGlobalSetting.maxPartyMember)
         {
            showMsg(LocalizeUtil.param(DictWarGod.MAX_PARTY_MEMBER_LIMIT,[this.mGlobalSetting.maxPartyMember]),MsgBtnCount.ONE);
            return false;
         }
         var canAccess:Boolean = true;
         var messageEverShown:Boolean = false;
         for(var i:int = 0; i < this.mPartyMembers.length; i++)
         {
            partyMember = this.mPartyMembers[i] as PartyMemberObj;
            if(!partyMember.meetWarGodWeaponRequirement)
            {
               if(!messageEverShown)
               {
                  msg = LocalizeUtil.param(DictWarGod.WARGOD_PARTY_MEMBER_INSUFFICIENT_WEAPON,[partyMember.name,this.mGlobalSetting.primaryWeaponRequirement]);
                  showMsg(msg,MsgBtnCount.ONE);
                  messageEverShown = true;
               }
               canAccess = false;
            }
            if(!partyMember.meetWarGodCreditRatingRequirement)
            {
               if(!messageEverShown)
               {
                  msg = LocalizeUtil.param(DictWarGod.WARGOD_PARTY_MEMBER_INSUFFICIENT_CREDIT,[partyMember.name]);
                  showMsg(msg,MsgBtnCount.ONE);
                  messageEverShown = true;
               }
               canAccess = false;
               CFunctionContainer.AS_SendTSSBlockTLog(partyMember.id,true);
            }
            if(partyMember.level + 1 + partyMember.prestige * 100 < this.mGlobalSetting.levelRestriction)
            {
               if(!messageEverShown)
               {
                  levelString = LocalizeUtil.localizePlayerLevel(this.mGlobalSetting.levelRestriction);
                  msg = LocalizeUtil.param(DictWarGod.WARGOD_PARTY_MEMBER_INSUFFICIENT_LEVEL,[partyMember.name,levelString]);
                  showMsg(msg,MsgBtnCount.ONE);
                  messageEverShown = true;
               }
               canAccess = false;
            }
            if(partyMember.isBlocked)
            {
               if(!messageEverShown)
               {
                  msg = LocalizeUtil.param(DictWarGod.WARGOD_PARTY_MEMBER_BLOCKED,[partyMember.name]);
                  showMsg(msg,MsgBtnCount.ONE);
                  messageEverShown = true;
               }
               canAccess = false;
            }
         }
         return canAccess;
      }
      
      private function onAD2SlideClicked(e:MouseEvent) : void
      {
         if(Boolean(getDP(DataID.IS_MARKETPLACE_READY)) && !getDP(DataID.IS_MARKETPLACE_MAINTAIN))
         {
            broadcast(BCEvent.EVT_NAVIGATE_TO_WARGOD_MARKETPLACE);
         }
         else
         {
            showMsg(Dict.DW_MARKETPLACE_MAINTAIN,MsgBtnCount.ONE);
         }
      }
   }
}

