package codo.views
{
   import codo.base.BaseSubElement;
   import codo.base.BaseView;
   import codo.component.CloseButton;
   import codo.component.ContentContainer;
   import codo.component.social.ClanCCPDetailPanel;
   import codo.component.social.ClanDetailInfoPanel;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.ProductObj;
   import codo.services.TutorialService;
   import codo.utils.ScaleformUtil;
   import codo.views.clan_sub.ClanManagementPanel;
   import codo.views.clan_sub.ClanRulePanel;
   import codo.views.clan_sub.ClanSearchPanel;
   import codo.views.clan_sub.ClanTagsEditPane;
   import components.fsgmatchresult_part.FsgRandomRewardPresentation;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public class ClanView extends BaseView
   {
      
      private static const DETAIL_PANEL_INFO_LINK:String = "codo.social.clanDetailInfoPanel";
      
      private static const DETAIL_CCP_PANEL_LINK:String = "codo.social.clanCCPDetailPanel";
      
      private static const CONTAINER_WIDTH:int = 1220;
      
      private static const CONTAINER_HEIGHT:int = 749;
      
      private static const CONTAINER_HEIGHT_INGAME:int = 810;
      
      public var myContentContainer:ContentContainer;
      
      public var myCloseBtn:CloseButton;
      
      public var myClanRulePanel:ClanRulePanel;
      
      public var mySearchPanel:ClanSearchPanel;
      
      public var myManagementPanel:ClanManagementPanel;
      
      public var myRewardContainer:FsgRandomRewardPresentation;
      
      public var myClanTagsEditPane:ClanTagsEditPane;
      
      private var mCurrentPanel:BaseSubElement;
      
      private var mIsInClanKeeper:Boolean = false;
      
      private var myDetailInfo:ClanDetailInfoPanel;
      
      private var myCCPDetailInfo:ClanCCPDetailPanel;
      
      public function ClanView()
      {
         super();
         this.myManagementPanel.visible = this.mySearchPanel.visible = false;
         this.myRewardContainer.visible = false;
         if(!ScaleformUtil.isScaleform)
         {
            this.myManagementPanel.visible = true;
         }
         var cls:Class = getDefinitionByName(DETAIL_PANEL_INFO_LINK) as Class;
         this.myDetailInfo = new cls() as ClanDetailInfoPanel;
         cls = getDefinitionByName(DETAIL_CCP_PANEL_LINK) as Class;
         this.myCCPDetailInfo = new cls() as ClanCCPDetailPanel;
         this.myContentContainer.showText = true;
         this.myContentContainer.showAccents = true;
         this.myContentContainer.width = CONTAINER_WIDTH;
         this.myContentContainer.height = CONTAINER_HEIGHT;
         this.myCloseBtn.registerClickEvent(this.onCloseBtnClicked);
         this.myClanRulePanel.deactive();
         this.myClanTagsEditPane.deactive();
      }
      
      override protected function showView() : void
      {
         super.showView();
         broadcast(BCEvent.EVT_CLAN_OPENED);
         listen(BCEvent.EVT_OPEN_CLAN_RULE_PANEL,this.openClanRulePanel);
         listen(BCEvent.EVT_OPEN_CLAN_TAGS_EDIT_PANEL,this.openClanTagsEditPane);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myRewardContainer.killPresentation();
         broadcast(BCEvent.EVT_CLAN_CLOSED);
         unlisten(BCEvent.EVT_OPEN_CLAN_RULE_PANEL,this.openClanRulePanel);
         unlisten(BCEvent.EVT_OPEN_CLAN_TAGS_EDIT_PANEL,this.openClanTagsEditPane);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         var isInClan:Boolean = getDP(DataID.IS_IN_CLAN);
         this.checkInClanState(isInClan);
         this.switchToPanel(isInClan);
         listen(BCEvent.EVT_ON_CLAN_JOINED,this.onClanStatusChanged);
         listen(BCEvent.EVT_ON_CLAN_LEFT,this.onClanStatusChanged);
         listen(BCEvent.SHOW_DETAIL_CLAN_INFO,this.showDetailClanInfo);
         listen(BCEvent.HIDE_DETAIL_CLAN_INFO,this.hideDetailClanInfo);
         listen(BCEvent.SHOW_MY_CCP_STATE,this.showMyCCPState);
         listen(BCEvent.HIDE_MY_CCP_STATE,this.hideMyCCPState);
      }
      
      override protected function disableData() : void
      {
         unlisten(BCEvent.SHOW_DETAIL_CLAN_INFO,this.showDetailClanInfo);
         unlisten(BCEvent.HIDE_DETAIL_CLAN_INFO,this.hideDetailClanInfo);
         unlisten(BCEvent.SHOW_MY_CCP_STATE,this.showMyCCPState);
         unlisten(BCEvent.HIDE_MY_CCP_STATE,this.hideMyCCPState);
         unlisten(BCEvent.EVT_ON_CLAN_JOINED,this.onClanStatusChanged);
         unlisten(BCEvent.EVT_ON_CLAN_LEFT,this.onClanStatusChanged);
         if(Boolean(this.mCurrentPanel))
         {
            this.mCurrentPanel.deactive();
            this.mCurrentPanel = null;
         }
         this.myManagementPanel.resetBestAndNewSearchSession();
         this.mySearchPanel.resetBestAndNewSearchSession();
         super.disableData();
      }
      
      private function onClanStatusChanged(cEvt:ParaEvent) : void
      {
         var isInClan:Boolean = getDP(DataID.IS_IN_CLAN);
         this.checkInClanState(isInClan);
         this.switchToPanel(isInClan);
      }
      
      private function switchToPanel(isInClan:Boolean) : void
      {
         var panel:BaseSubElement = isInClan ? this.myManagementPanel : this.mySearchPanel;
         if(this.mCurrentPanel != panel)
         {
            if(this.mCurrentPanel != null)
            {
               this.mCurrentPanel.deactive();
            }
            this.mCurrentPanel = panel;
            this.mCurrentPanel.active();
            this.myContentContainer.height = isInClan ? CONTAINER_HEIGHT_INGAME : CONTAINER_HEIGHT;
            this.myClanRulePanel.deactive();
         }
      }
      
      private function onCloseBtnClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_CLAN);
      }
      
      private function checkInClanState(isInClan:Boolean) : void
      {
         var timerHandler:uint = 0;
         var realCheckInClanState:Function = null;
         realCheckInClanState = function():void
         {
            var prodObj:ProductObj = null;
            clearTimeout(timerHandler);
            if(visible)
            {
               if(mIsInClanKeeper == isInClan)
               {
                  return;
               }
               mIsInClanKeeper = isInClan;
               if(mIsInClanKeeper && Boolean(getDP(DataID.SHOULD_HAVE_CLAN_REWARD)))
               {
                  broadcast(BCEvent.CLAIM_CLAN_JOIN_REWARD);
                  myRewardContainer.visible = true;
                  prodObj = TutorialService.getInstance().getClanOnboardingReward();
                  myRewardContainer.showRandomReward([prodObj]);
               }
            }
         };
         timerHandler = setTimeout(realCheckInClanState,0.1);
      }
      
      private function showDetailClanInfo(cEvt:ParaEvent) : void
      {
         var para:Object = null;
         para = cEvt.myPara;
         this.myDetailInfo.data = para;
         var gPt:Point = new Point(para.globalX,para.globalY);
         var lPt:Point = globalToLocal(gPt);
         addChild(this.myDetailInfo);
         this.myDetailInfo.x = lPt.x;
         if(Boolean(para.isUpperSection))
         {
            this.myDetailInfo.y = lPt.y;
         }
         else
         {
            this.myDetailInfo.y = lPt.y - this.myDetailInfo.height;
         }
      }
      
      private function hideDetailClanInfo(cEvt:ParaEvent) : void
      {
         if(Boolean(this.myDetailInfo) && Boolean(this.myDetailInfo.parent))
         {
            removeChild(this.myDetailInfo);
         }
      }
      
      private function showMyCCPState(cEvt:ParaEvent) : void
      {
         var para:Object = cEvt.myPara;
         var ccpState:Array = getDP(DataID.PLAYER_CCP_STATE);
         var globalSetting:ClanGlobalConfig = getDP(DataID.CLAN_GLOBAL_CONFIG);
         this.myCCPDetailInfo.setData(ccpState,globalSetting);
         var gPt:Point = new Point(para.globalX,para.globalY);
         var lPt:Point = globalToLocal(gPt);
         addChild(this.myCCPDetailInfo);
         this.myCCPDetailInfo.x = lPt.x;
         if(Boolean(para.isUpperSection))
         {
            this.myCCPDetailInfo.y = lPt.y;
         }
         else
         {
            this.myCCPDetailInfo.y = lPt.y - this.myCCPDetailInfo.height;
         }
      }
      
      private function hideMyCCPState(cEvt:ParaEvent) : void
      {
         if(Boolean(this.myCCPDetailInfo) && Boolean(this.myCCPDetailInfo.parent))
         {
            removeChild(this.myCCPDetailInfo);
         }
      }
      
      private function openClanRulePanel(cEvt:ParaEvent) : void
      {
         this.myClanRulePanel.active();
      }
      
      private function openClanTagsEditPane(cEvt:ParaEvent) : void
      {
         this.myClanTagsEditPane.setData(cEvt.myPara);
         this.myClanTagsEditPane.active();
      }
   }
}

