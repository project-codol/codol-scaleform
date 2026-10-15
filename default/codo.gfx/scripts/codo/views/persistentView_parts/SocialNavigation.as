package codo.views.persistentView_parts
{
   import codo.base.BaseView;
   import codo.common.CFunctionContainer;
   import codo.component.NotificationSocialButton;
   import codo.component.SocialButton;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictParty;
   import codo.theme.BaseTheme;
   import codo.theme.ITheme;
   import codo.utils.TLogUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SocialNavigation extends BaseView
   {
      
      private static const PARTY_BTN_INDEX:int = 5;
      
      public var myNotificationsBtn:NotificationSocialButton;
      
      public var myMailBtn:SocialButton;
      
      public var myLeaderBoardBtn:SocialButton;
      
      public var myFriendBtn:SocialButton;
      
      public var myClanBtn:SocialButton;
      
      public var myPartyBtn:SocialButton;
      
      public var myLiveBtn:SocialButton;
      
      public var myTeammateRecruitmentBtn:SocialButton;
      
      public var mySocialToolTip:SocialButtonToolTip;
      
      public var myPartyInvitationToolTip:SocialButtonToolTip;
      
      public var myBg:Sprite;
      
      private var mPartyNotificationTimer:Timer;
      
      private var mButtons:Vector.<SocialButton>;
      
      private var mButtonToolTip:Vector.<String>;
      
      private var mButtonToolTipY:Vector.<Number>;
      
      private var mPartyNotificationShowing:Boolean = false;
      
      public function SocialNavigation()
      {
         super();
         this.mButtons = new <SocialButton>[this.myNotificationsBtn,this.myMailBtn,this.myLeaderBoardBtn,this.myFriendBtn,this.myClanBtn,this.myPartyBtn];
         this.mButtonToolTip = new <String>[Dict.MAIN_MENU_LABEL_NOTIFICATION_SHORT_NAME,Dict.MAIN_MENU_LABEL_MAIL_SHORT_NAME,Dict.MAIN_MENU_LABEL_LEADERBOARD,Dict.MAIN_MENU_LABEL_CONTACT_SHORT_NAME,Dict.MAIN_MENU_LABEL_CLAN_SHORT_NAME,Dict.MAIN_MENU_LABEL_PARTY_SHORT_NAME,Dict.MAIN_MENU_LABEL_QVIDEO_SHORT_NAME,Dict.MAIN_MENU_LABEL_TEAMMATE_RECRUITMENT];
         this.mButtonToolTipY = new <Number>[92,146,200,257,313,367,422,479];
         this.myNotificationsBtn.type = SocialButton.TYPE_NOTIFICATIONS;
         this.myMailBtn.type = SocialButton.TYPE_MAIL;
         this.myLeaderBoardBtn.type = SocialButton.TYPE_LEADERBOARD;
         this.myFriendBtn.type = SocialButton.TYPE_FRIEND;
         this.myClanBtn.type = SocialButton.TYPE_CLAN;
         this.myPartyBtn.type = SocialButton.TYPE_PARTY;
         this.myLiveBtn.type = SocialButton.TYPE_LIVE;
         this.myTeammateRecruitmentBtn.type = SocialButton.TYPE_TEAMMATE_RECRUITMENT;
         this.myNotificationsBtn.registerFocusEvent(this.onSocialButtonFocused,0);
         this.myMailBtn.registerFocusEvent(this.onSocialButtonFocused,1);
         this.myLeaderBoardBtn.registerFocusEvent(this.onSocialButtonFocused,2);
         this.myFriendBtn.registerFocusEvent(this.onSocialButtonFocused,3);
         this.myClanBtn.registerFocusEvent(this.onSocialButtonFocused,4);
         this.myPartyBtn.registerFocusEvent(this.onSocialButtonFocused,5);
         this.myLiveBtn.registerFocusEvent(this.onSocialButtonFocused,6);
         this.myTeammateRecruitmentBtn.registerFocusEvent(this.onSocialButtonFocused,7);
         this.myNotificationsBtn.registerUnfocusEvent(this.onSocialButtonUnfocused,0);
         this.myMailBtn.registerUnfocusEvent(this.onSocialButtonUnfocused,1);
         this.myLeaderBoardBtn.registerUnfocusEvent(this.onSocialButtonUnfocused,2);
         this.myFriendBtn.registerUnfocusEvent(this.onSocialButtonUnfocused,3);
         this.myClanBtn.registerUnfocusEvent(this.onSocialButtonUnfocused,4);
         this.myPartyBtn.registerUnfocusEvent(this.onSocialButtonUnfocused,5);
         this.myLiveBtn.registerUnfocusEvent(this.onSocialButtonUnfocused,6);
         this.myTeammateRecruitmentBtn.registerUnfocusEvent(this.onSocialButtonUnfocused,7);
         this.myNotificationsBtn.registerClickEvent(this.onSocialButtonClicked,this.myNotificationsBtn);
         this.myMailBtn.registerClickEvent(this.onSocialButtonClicked,this.myMailBtn);
         this.myLeaderBoardBtn.registerClickEvent(this.onSocialButtonClicked,this.myLeaderBoardBtn);
         this.myFriendBtn.registerClickEvent(this.onSocialButtonClicked,this.myFriendBtn);
         this.myClanBtn.registerClickEvent(this.onSocialButtonClicked,this.myClanBtn);
         this.myPartyBtn.registerClickEvent(this.onSocialButtonClicked,this.myPartyBtn);
         this.myLiveBtn.registerClickEvent(this.onSocialButtonClicked,this.myLiveBtn);
         this.myTeammateRecruitmentBtn.registerClickEvent(this.onSocialButtonClicked,this.myTeammateRecruitmentBtn);
         this.myClanBtn.setOnboardLock(UiCppOnboarding.FEATURE_CLANS);
         this.myLeaderBoardBtn.setOnboardLock(UiCppOnboarding.FEATURE_LEADERBOARDS);
         if(Boolean(getDP(DataID.IS_RECRUITMENTBTN_LOCKED)))
         {
            this.myTeammateRecruitmentBtn.setIconLock();
         }
         this.mPartyNotificationTimer = new Timer(3000);
      }
      
      override protected function setupThemeVector() : void
      {
         super.setupThemeVector();
         mThemeSetNew.push({
            "clip":this.myBg,
            "piece":BaseTheme.THEME_PIECE_SOCIAL_BUTTON_BACKGROUND
         });
      }
      
      override protected function initTheme() : void
      {
         super.initTheme();
         var theme:ITheme = getDP(DataID.GET_THEME_SUITE);
         var themeColor:int = int(theme.getSocialButtonColor());
         this.myNotificationsBtn.buttonColor = themeColor;
         this.myMailBtn.buttonColor = themeColor;
         this.myLeaderBoardBtn.buttonColor = themeColor;
         this.myFriendBtn.buttonColor = themeColor;
         this.myClanBtn.buttonColor = themeColor;
         this.myPartyBtn.buttonColor = themeColor;
         this.myLiveBtn.buttonColor = themeColor;
         this.myTeammateRecruitmentBtn.buttonColor = themeColor;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myNotificationsBtn.addBreadcrumb();
         listen(BCEvent.EVT_MOTD_CLOSED,this.refreshNotifsCrumb);
         this.refreshNotifsCrumb();
      }
      
      private function refreshNotifsCrumb() : void
      {
         var show:Boolean = CFunctionContainer.AS_HaveUnviewedMOTDMessages() as Boolean;
         this.myNotificationsBtn.getBreadcrumb().visible = show;
         this.myNotificationsBtn.setPulse(show);
      }
      
      override protected function showView() : void
      {
         super.showView();
         x = 0;
         y = 430;
         this.mPartyNotificationTimer.addEventListener(TimerEvent.TIMER,this.onShowNotificationComplete);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         broadcast(BCEvent.EVT_ON_MAIL_NOTIFICATION_UNREADY);
         this.mPartyNotificationTimer.removeEventListener(TimerEvent.TIMER,this.onShowNotificationComplete);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         listen(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
         listen(BCEvent.EVT_PLAY_MAIL_ARCHIVE_ANIMATION,this.onPlayMailArchiveAnimation);
         listen(BCEvent.EVT_SELECT_SOCIAL_BUTTON,this.onSocialButtonEvent);
         listen(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangeHandler);
         listen(BCEvent.PARTY_INVITATION_SENT,this.onPartyInvitationSentHandler);
         bind(DataID.TOTAL_UNREAD_MAIL_COUNT,this.onBindTotalMailCount);
         bind(DataID.MESSAGE_CLAN_APPLICATION,this.onBindClanApplication);
         bind(DataID.PARTY_INFO,this.bindPartyInfo);
         bind(DataID.PARTY_PENDING_MEMBER,this.bindPartyPendingMember);
         this.myClanBtn.isInteractiveEnabled = !getDP(DataID.LOCK_CLAN);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         unlisten(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
         unlisten(BCEvent.EVT_SELECT_SOCIAL_BUTTON,this.onSocialButtonEvent);
         unlisten(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangeHandler);
         unlisten(BCEvent.PARTY_INVITATION_SENT,this.onPartyInvitationSentHandler);
         unbind(DataID.TOTAL_UNREAD_MAIL_COUNT,this.onBindTotalMailCount);
         unbind(DataID.PARTY_INFO,this.bindPartyInfo);
         unbind(DataID.PARTY_PENDING_MEMBER,this.bindPartyPendingMember);
      }
      
      private function onShowEvt(myPara:ParaEvent) : void
      {
         this.visible = true;
      }
      
      private function onHideEvt(myPara:ParaEvent) : void
      {
         this.visible = false;
      }
      
      private function onSocialButtonEvent(evt:ParaEvent) : void
      {
         var id:String = evt.myPara;
         switch(id)
         {
            case PageID.CLAN:
               this.onSocialButtonClicked(this.myClanBtn);
               break;
            case PageID.LEADERBOARD:
               this.onSocialButtonClicked(this.myLeaderBoardBtn);
               break;
            case PageID.FRIEND:
               this.onSocialButtonClicked(this.myFriendBtn);
               break;
            case PageID.PARTY:
               this.onSocialButtonClicked(this.myPartyBtn);
         }
      }
      
      private function onSocialButtonFocused(index:int) : void
      {
         if(index == PARTY_BTN_INDEX && this.mPartyNotificationShowing)
         {
            this.hidePartyNotification();
         }
         this.mySocialToolTip.showSocialToolTip(this.mButtonToolTip[index],this.mButtonToolTipY[index]);
      }
      
      private function onSocialButtonUnfocused(index:int) : void
      {
         this.mySocialToolTip.hideSocialToolTip();
      }
      
      private function onSocialButtonClicked(button:SocialButton) : void
      {
         var highlight:Boolean = true;
         if(button.lockedForLevel)
         {
            return;
         }
         broadcast(BCEvent.EVT_CLOSE_MOTD_DASHBOARD);
         switch(button)
         {
            case this.myNotificationsBtn:
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SOCIAL_NOTIFICATIONS);
               broadcast(BCEvent.EVT_OPEN_MOTD_DASHBOARD,{
                  "category":0,
                  "index":0
               });
               broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP);
               break;
            case this.myMailBtn:
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SOCIAL_MAIL);
               broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP,PageID.MAIL);
               break;
            case this.myLeaderBoardBtn:
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SOCIAL_LEADERBOARD);
               broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP,PageID.LEADERBOARD);
               break;
            case this.myFriendBtn:
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SOCIAL_FRIENDS);
               broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP,PageID.FRIEND);
               break;
            case this.myClanBtn:
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SOCIAL_CLAN);
               broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP,PageID.CLAN);
               break;
            case this.myPartyBtn:
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SOCIAL_PARTY);
               broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP,PageID.PARTY);
               break;
            case this.myLiveBtn:
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SOCIAL_QT_LIVE);
               broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP);
               broadcast(BCCommonEvent.OPEN_QLIVE);
               highlight = false;
               break;
            case this.myTeammateRecruitmentBtn:
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SOCIAL_TEAMMATE_RECRUITMENT);
               broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP);
               broadcast(BCEvent.EVT_WEBPAGE_OPEN_TEAMMATE_RECRUITMENT);
               highlight = false;
         }
         this.resetButtons();
         if(highlight)
         {
            button.setToggled(true);
            listen(BCCommonEvent.MASK_STATE_CHANGED,this.onMaskChange);
         }
      }
      
      private function resetButtons() : void
      {
         var len:int = int(this.mButtons.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.mButtons[i].isInteractiveEnabled)
            {
               this.mButtons[i].setToggled(false);
            }
         }
      }
      
      private function onMaskChange(evt:ParaEvent) : void
      {
         var masked:Boolean = evt.myPara;
         if(!masked && !getDP(DataID.HAS_POPUP))
         {
            this.resetButtons();
            unlisten(BCCommonEvent.MASK_STATE_CHANGED,this.onMaskChange);
         }
      }
      
      private function onPlayMailArchiveAnimation(cEvt:ParaEvent) : void
      {
         var timeLine:TimelineLite = new TimelineLite();
         timeLine.append(TweenLite.to(this.myMailBtn,0.15,{
            "scaleX":1.2,
            "scaleY":1.2
         }));
         timeLine.append(TweenLite.to(this.myMailBtn,0.15,{
            "scaleX":1,
            "scaleY":1
         }));
      }
      
      private function onBindTotalMailCount(cRes:Object) : void
      {
         this.myMailBtn.number = cRes.data;
      }
      
      private function onBindClanApplication(cRes:Object) : void
      {
         var clanApplication:Array = cRes.data.dp as Array;
         this.myClanBtn.switchShowRedDot(clanApplication.length > 0);
      }
      
      private function bindPartyInfo(cRes:Object) : void
      {
         var numPartyMember:int = int(cRes.data.members.length);
         if(numPartyMember > 0)
         {
            this.myPartyBtn.cornerNumber = String(numPartyMember);
         }
      }
      
      private function bindPartyPendingMember(cRes:Object) : void
      {
         var pendingMember:Array = cRes.data as Array;
         this.myPartyBtn.switchShowAnimation(pendingMember.length > 0);
      }
      
      private function onPartyStateChangeHandler() : void
      {
         var isInParty:Boolean = getDP(DataID.IS_IN_PARTY);
         if(isInParty)
         {
            this.myPartyBtn.type = SocialButton.TYPE_IN_PARTY;
         }
         else
         {
            this.myPartyBtn.type = SocialButton.TYPE_PARTY;
            this.myPartyBtn.cornerNumber = "";
            this.myPartyBtn.switchShowAnimation(false);
         }
      }
      
      private function onPartyInvitationSentHandler() : void
      {
         this.mPartyNotificationShowing = true;
         this.mPartyNotificationTimer.reset();
         this.mPartyNotificationTimer.start();
         this.myPartyInvitationToolTip.showSocialToolTip(DictParty.PROPOSE_PARTY_SUCCESS,this.mButtonToolTipY[PARTY_BTN_INDEX]);
      }
      
      private function hidePartyNotification() : void
      {
         this.mPartyNotificationShowing = false;
         this.mPartyNotificationTimer.stop();
         this.myPartyInvitationToolTip.hideSocialToolTip();
      }
      
      private function onShowNotificationComplete(evt:TimerEvent) : void
      {
         this.hidePartyNotification();
      }
   }
}

