package codo.views.clan_sub
{
   import codo.base.BaseSubElement;
   import codo.component.social.SocialMainTab;
   import codo.component.social.SocialTabButton;
   import codo.constants.BCEvent;
   import codo.constants.ClanMemberPosition;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictClan;
   import codo.objects.SocialTabSetting;
   import codo.views.clan_sub.management_sub.ClanApplicationPanel;
   import codo.views.clan_sub.management_sub.ClanInvitationPanel;
   import codo.views.clan_sub.management_sub.ClanMemberPanel;
   import codo.views.clan_sub.management_sub.ClanSettingPanel;
   import codo.views.clan_sub.search_sub.ClanBestPanel;
   import codo.views.clan_sub.search_sub.ClanNameSearchPanel2;
   import codo.views.clan_sub.search_sub.ClanNewPanel;
   
   public class ClanManagementPanel extends BaseSubElement
   {
      
      private static const SUB_PANEL_X:int = 1;
      
      private static const SUB_PANEL_Y:int = 302;
      
      private static const CLAN_INFO_EXPIRED_SECOND:uint = 60 * 10;
      
      public var myClanLogPanel:ClanRulePanel;
      
      public var myMainTab:SocialMainTab;
      
      public var myMemberPanel:ClanMemberPanel;
      
      public var mySummaryPanel:ClanSummaryPanel;
      
      public var mySettingPanel:ClanSettingPanel;
      
      public var myInvitationPanel:ClanInvitationPanel;
      
      public var myApplicationPanel:ClanApplicationPanel;
      
      private var myCurrentSubPanels:Array;
      
      private var mNavigateData:SocialTabSetting;
      
      private var myCurrentSubPanel:BaseSubElement;
      
      private var mLeaderTabs:Array;
      
      private var mAdministratorTabs:Array;
      
      private var mMemberTabs:Array;
      
      private var mCurrentRole:int = -1;
      
      private var mApplicationTabIndex:int = -1;
      
      private var mBestClanPanel:ClanBestPanel;
      
      private var mNewClanPanel:ClanNewPanel;
      
      private var mNameSearchClanPanel:ClanNameSearchPanel2;
      
      private var mBestClanDataRequested:Boolean = false;
      
      private var mNewClanDataRequested:Boolean = false;
      
      private var mLastTimeGetClanInfo:uint = 0;
      
      public function ClanManagementPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.mBestClanPanel = new clanBestPanel();
         this.mNewClanPanel = new clanNewPanel();
         this.mNameSearchClanPanel = new clanNameSearchPanel2();
         this.mBestClanPanel.switchShowJoinBtn(false);
         this.mNewClanPanel.switchShowJoinBtn(false);
         var subPanelIndex:int = getChildIndex(this.myApplicationPanel);
         addChildAt(this.mBestClanPanel,subPanelIndex);
         addChildAt(this.mNewClanPanel,subPanelIndex);
         addChildAt(this.mNameSearchClanPanel,subPanelIndex);
         this.mBestClanPanel.x = this.mNewClanPanel.x = this.mNameSearchClanPanel.x = SUB_PANEL_X;
         this.mBestClanPanel.y = this.mNewClanPanel.y = this.mNameSearchClanPanel.y = SUB_PANEL_Y;
         this.mLeaderTabs = [DictClan.MAIN_TAB_MEMBERS,DictClan.MAIN_TAB_INVITATIONS,DictClan.MAIN_TAB_APPLICATIONS,DictClan.MAIN_TAB_SETTINGS,DictClan.BEST_CLAN_LABEL,DictClan.NEW_CLAN_LABEL,DictClan.SEARCH_CLAN_LABEL2];
         this.mAdministratorTabs = [DictClan.MAIN_TAB_MEMBERS,DictClan.MAIN_TAB_INVITATIONS,DictClan.BEST_CLAN_LABEL,DictClan.NEW_CLAN_LABEL,DictClan.SEARCH_CLAN_LABEL2];
         this.mMemberTabs = [DictClan.MAIN_TAB_MEMBERS,DictClan.BEST_CLAN_LABEL,DictClan.NEW_CLAN_LABEL,DictClan.SEARCH_CLAN_LABEL2];
         this.mNavigateData = new SocialTabSetting();
         this.mNavigateData.tabSelectedCallback = this.onTabSelectedCallback;
         this.mBestClanPanel.deactive();
         this.mNewClanPanel.deactive();
         this.mNameSearchClanPanel.deactive();
         this.myMemberPanel.deactive();
         this.myInvitationPanel.deactive();
         this.myApplicationPanel.deactive();
         this.mySettingPanel.deactive();
         this.myCurrentSubPanel = null;
      }
      
      override public function active() : void
      {
         super.active();
         this.mySummaryPanel.active();
         bind(DataID.CLAN_INFO,this.bindClanInfo);
         bind(DataID.MESSAGE_CLAN_APPLICATION,this.bindApplication);
         listen(BCEvent.EVT_CLAN_TITLE_CHANGED,this.onSelfClanTitleChanged);
         this.checkExpiredClanInfo();
      }
      
      private function checkExpiredClanInfo() : void
      {
         var nowTimeStamp:uint = getDP(DataID.GET_SERVER_TIME_STAMP);
         if(this.mLastTimeGetClanInfo == 0)
         {
            this.mLastTimeGetClanInfo = nowTimeStamp;
            return;
         }
         if(nowTimeStamp - this.mLastTimeGetClanInfo > CLAN_INFO_EXPIRED_SECOND)
         {
            this.mLastTimeGetClanInfo = nowTimeStamp;
            broadcast(BCEvent.EVT_REQUEST_RETRIEVE_CLAN_INFO);
         }
      }
      
      override public function deactive() : void
      {
         unbind(DataID.CLAN_INFO,this.bindClanInfo);
         unbind(DataID.MESSAGE_CLAN_APPLICATION,this.bindApplication);
         unlisten(BCEvent.EVT_CLAN_TITLE_CHANGED,this.onSelfClanTitleChanged);
         this.mySummaryPanel.deactive();
         if(Boolean(this.myCurrentSubPanel))
         {
            this.myCurrentSubPanel.deactive();
            this.myCurrentSubPanel = null;
         }
         this.mCurrentRole = -1;
         this.myMainTab.clearSelectedTab();
         super.deactive();
      }
      
      private function bindApplication(cRes:Object) : void
      {
         var data:Array = cRes.data.dp as Array;
         if(this.mApplicationTabIndex != -1)
         {
            this.myMainTab.setTabRedDotCount(this.mApplicationTabIndex,data.length);
         }
      }
      
      private function onSelfClanTitleChanged(cEvt:ParaEvent) : void
      {
         this.updateRole();
      }
      
      private function updateRole() : void
      {
         var role:int = 0;
         if(Boolean(getDP(DataID.IS_CLAN_OWNER)))
         {
            role = int(ClanMemberPosition.OWNER);
         }
         else if(Boolean(getDP(DataID.IS_CLAN_ADMIN)))
         {
            role = int(ClanMemberPosition.ADMIN);
         }
         else
         {
            role = int(ClanMemberPosition.ORDINARY);
         }
         if(this.mCurrentRole == role)
         {
            return;
         }
         this.mCurrentRole = role;
         switch(role)
         {
            case ClanMemberPosition.OWNER:
               this.mNavigateData.labels = this.mLeaderTabs;
               this.myCurrentSubPanels = [this.myMemberPanel,this.myInvitationPanel,this.myApplicationPanel,this.mySettingPanel,this.mBestClanPanel,this.mNewClanPanel,this.mNameSearchClanPanel];
               break;
            case ClanMemberPosition.ADMIN:
               this.mNavigateData.labels = this.mAdministratorTabs;
               this.myCurrentSubPanels = [this.myMemberPanel,this.myInvitationPanel,this.mBestClanPanel,this.mNewClanPanel,this.mNameSearchClanPanel];
               break;
            case ClanMemberPosition.ORDINARY:
               this.mNavigateData.labels = this.mMemberTabs;
               this.myCurrentSubPanels = [this.myMemberPanel,this.mBestClanPanel,this.mNewClanPanel,this.mNameSearchClanPanel];
         }
         this.mNavigateData.fixedTabWidth = 115;
         this.mApplicationTabIndex = this.myCurrentSubPanels.indexOf(this.myApplicationPanel);
         this.myMainTab.setTabType(SocialTabButton.TYPE_BIG);
         this.myMainTab.setData(this.mNavigateData);
         this.myMainTab.selectTab(0);
      }
      
      private function bindClanInfo(cRes:Object) : void
      {
         this.updateRole();
      }
      
      private function onTabSelectedCallback(index:int) : void
      {
         if(Boolean(this.myCurrentSubPanel))
         {
            this.myCurrentSubPanel.deactive();
         }
         if(Boolean(this.myCurrentSubPanels[index]))
         {
            this.myCurrentSubPanel = this.myCurrentSubPanels[index] as BaseSubElement;
            this.myCurrentSubPanel.active();
            this.tryRequestData(this.myCurrentSubPanels[index]);
         }
      }
      
      public function resetBestAndNewSearchSession() : void
      {
         this.mBestClanDataRequested = false;
         this.mNewClanDataRequested = false;
      }
      
      private function tryRequestData(subPanel:BaseSubElement) : void
      {
         if(subPanel == this.mBestClanPanel && !this.mBestClanDataRequested)
         {
            this.mBestClanPanel.startNewSearch();
            this.mBestClanDataRequested = true;
         }
         else if(subPanel == this.mNewClanPanel && !this.mNewClanDataRequested)
         {
            this.mNewClanPanel.startNewSearch();
            this.mNewClanDataRequested = true;
         }
      }
   }
}

