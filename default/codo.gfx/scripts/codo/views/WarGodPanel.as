package codo.views
{
   import codo.base.BaseSubElement;
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.FilterToggleButton;
   import codo.component.PlayerAccountInfo;
   import codo.component.ViewPanelBase;
   import codo.component.factory.GlobalFactory;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.GlobalBottomBtnStatus;
   import codo.constants.QuickMatchType;
   import codo.constants.table.UINotifications;
   import codo.cpp.UiCppMatchSelectView;
   import codo.cpp.UiCppView;
   import codo.cpp.UiCppViewPanel;
   import codo.event.ParaEvent;
   import codo.localization.DictWarGod;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.WarGodUtility;
   import codo.views.wargod_parts.WarGodBriefInfoPanel;
   import codo.views.wargod_parts.WarGodProgressPanel;
   import com.society.comscore.DAXDispatcher;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class WarGodPanel extends ViewPanelBase
   {
      
      public static const PANEL_PROGRESS:int = 0;
      
      public static const PANEL_MATCH_LOG:int = 1;
      
      public static const PANEL_LEADER_BOARD:int = 2;
      
      public static const PANEL_SEASON_HISTORY:int = 3;
      
      public static const PANEL_RULE:int = 4;
      
      public static const PANEL_CREDIT:int = 5;
      
      public var myBriefPanel:WarGodBriefInfoPanel;
      
      public var myToggleBtn0:FilterToggleButton;
      
      public var myToggleBtn1:FilterToggleButton;
      
      public var myToggleBtn2:FilterToggleButton;
      
      public var myToggleBtn3:FilterToggleButton;
      
      public var myToggleBtn4:FilterToggleButton;
      
      public var myToggleBtn5:FilterToggleButton;
      
      public var myBg:MovieClip;
      
      private var mCurrentPageIndex:int = -1;
      
      private var mRulePageIndex:int = -1;
      
      private var mCreditPageIndex:int = -1;
      
      private var mPanels:Vector.<BaseSubElement>;
      
      private var mPanelsInUse:Vector.<BaseSubElement>;
      
      private var mLabels:Vector.<String>;
      
      private var mToggleBtns:Vector.<FilterToggleButton>;
      
      private var mRuleBreadCrumb:MovieClip;
      
      private var mWarGodPlayerObj:WarGodPlayerObj;
      
      public function WarGodPanel()
      {
         var subPanelLinkages:Vector.<String> = null;
         var i:int = 0;
         var panel:BaseSubElement = null;
         var defineClass:Class = null;
         super();
         if(!ScaleformUtil.isScaleform)
         {
            visible = true;
            alpha = 1;
         }
         this.mPanels = new Vector.<BaseSubElement>();
         this.mPanelsInUse = new Vector.<BaseSubElement>();
         subPanelLinkages = new Vector.<String>();
         subPanelLinkages.push("codo.wargod.wargodProgressPanel");
         subPanelLinkages.push("codo.wargod.wargodMatchHistoryPanel");
         subPanelLinkages.push("codo.wargod.wargodLeaderboardPanel");
         subPanelLinkages.push("codo.wargod.wargodSeasonHistoryPanel");
         subPanelLinkages.push(null);
         subPanelLinkages.push(null);
         for(i = 0; i < subPanelLinkages.length; i++)
         {
            panel = null;
            if(subPanelLinkages[i] == null)
            {
               this.mPanels.push(null);
            }
            else
            {
               try
               {
                  defineClass = getDefinitionByName(subPanelLinkages[i]) as Class;
                  if(Boolean(defineClass))
                  {
                     panel = new defineClass() as BaseSubElement;
                     if(Boolean(panel))
                     {
                        addChild(panel);
                        panel.visible = false;
                        panel.x = this.myBg.x;
                        panel.y = this.myBg.y;
                     }
                  }
               }
               catch(e:Error)
               {
                  Logger.print("Error: WarGodPanel wrong sub panel linkage:",subPanelLinkages[i],e.message);
               }
               finally
               {
                  this.mPanels.push(panel);
               }
            }
         }
         this.mLabels = new Vector.<String>();
         this.mLabels.splice(0,0,DictWarGod.WARGOD_PROGRESS,DictWarGod.WARGOD_LAST_TEN,DictWarGod.WARGOD_LEADERBOARD,DictWarGod.WARGOD_SEASON_HISTORY,DictWarGod.WARGOD_RULES,DictWarGod.WARGOD_CREDITS);
         this.mToggleBtns = new Vector.<FilterToggleButton>();
         this.mToggleBtns.splice(0,0,this.myToggleBtn0,this.myToggleBtn1,this.myToggleBtn2,this.myToggleBtn3,this.myToggleBtn4,this.myToggleBtn5);
         for(i = 0; i < this.mToggleBtns.length; i++)
         {
            this.mToggleBtns[i].registerClickEvent(this.onSetTab,i);
         }
         addChild(this.myBriefPanel);
         EventManager.getInstance().listen(BCEvent.EVT_DECIDE_JUNIOR_WARGOD_PLAYLIST,this.onDecideJuniorWarGodPlaylist);
      }
      
      override protected function enableData() : void
      {
         var i:int = 0;
         var subPanel:BaseSubElement = null;
         super.enableData();
         EventManager.getInstance().broadcast(BCEvent.EVT_SWITCH_HP_EHP_CURRENCY_MODE,PlayerAccountInfo.HPEHPMode);
         i = 0;
         for(var panelIndex:int = 0; panelIndex < this.mPanels.length; panelIndex++)
         {
            this.mToggleBtns[panelIndex].visible = false;
         }
         this.mPanelsInUse.length = 0;
         var needPanel:Array = new Array();
         needPanel.push(PANEL_PROGRESS);
         this.mWarGodPlayerObj = DataManager.getInstance().getDP(DataID.PLAYER_WARGOD_DATA);
         var isJuniorWarGod:Boolean = WarGodUtility.isJuniorWarGod(this.mWarGodPlayerObj);
         var state:int = DataManager.getInstance().getDP(DataID.WARGOD_OPENING_STATE);
         var globalSetting:WarGodGlobalSettingObj = DataManager.getInstance().getDP(DataID.WARGOD_GLOBAL_SETTING);
         var leaderBoardIsLocked:Boolean = globalSetting.lockLeaderboard;
         var histroyIsLocked:Boolean = globalSetting.lockHistroy;
         switch(state)
         {
            case WarGodSeasonObj.STATE_CLOSE_LOCK:
               break;
            case WarGodSeasonObj.STATE_CLOSE_LEVEL:
            case WarGodSeasonObj.STATE_CLOSE_PRIMARY_WEAPON:
               if(!leaderBoardIsLocked && !isJuniorWarGod)
               {
                  needPanel.push(PANEL_LEADER_BOARD);
               }
               if(!histroyIsLocked)
               {
                  needPanel.push(PANEL_SEASON_HISTORY);
               }
               needPanel.push(PANEL_RULE);
               needPanel.push(PANEL_CREDIT);
               break;
            default:
               needPanel.push(PANEL_MATCH_LOG);
               if(!leaderBoardIsLocked && !isJuniorWarGod)
               {
                  needPanel.push(PANEL_LEADER_BOARD);
               }
               if(!histroyIsLocked)
               {
                  needPanel.push(PANEL_SEASON_HISTORY);
               }
               needPanel.push(PANEL_RULE);
               needPanel.push(PANEL_CREDIT);
         }
         for(i = 0; i < needPanel.length; i++)
         {
            if(needPanel[i] == PANEL_RULE)
            {
               this.mRulePageIndex = i;
            }
            if(needPanel[i] == PANEL_CREDIT)
            {
               this.mCreditPageIndex = i;
            }
         }
         var BUTTON_GAP_X:Number = 10;
         for(i = 0; i < needPanel.length; i++)
         {
            subPanel = this.getProperPanelByIndex(needPanel[i]);
            this.mPanelsInUse.push(subPanel);
            this.mToggleBtns[i].label = this.getProperLabelByIndex(needPanel[i]);
            this.mToggleBtns[i].visible = true;
            if(i > 0)
            {
               this.mToggleBtns[i].x = this.mToggleBtns[i - 1].x + this.mToggleBtns[i - 1].myBackground.width + BUTTON_GAP_X;
            }
         }
         if(this.mCurrentPageIndex == -1)
         {
            this.onSetTab(0);
         }
         this.myBriefPanel.active();
         DAXDispatcher.setGameVariant("mp");
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_MATCH_TYPE,QuickMatchType.makeWarGod());
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_BOTTOM_START_STATUS,GlobalBottomBtnStatus.STATUS_IDLE_MP_PLAYLIST_CHOOSE);
         var isWarGodEntered:Boolean = DataManager.getInstance().getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_WARGOD]);
         if(!isWarGodEntered && this.mRulePageIndex >= 0 && this.mRulePageIndex < this.mToggleBtns.length)
         {
            this.mRuleBreadCrumb = GlobalFactory.BUILD_BREADCRUMB();
            this.mToggleBtns[this.mRulePageIndex].addChild(this.mRuleBreadCrumb);
         }
      }
      
      private function getProperPanelByIndex(index:int) : BaseSubElement
      {
         if(index < this.mPanels.length)
         {
            return this.mPanels[index];
         }
         return null;
      }
      
      private function getProperLabelByIndex(index:int) : String
      {
         if(index < this.mLabels.length)
         {
            return this.mLabels[index];
         }
         return null;
      }
      
      override protected function disableData() : void
      {
         var subPanel:BaseSubElement = null;
         super.disableData();
         EventManager.getInstance().broadcast(BCEvent.EVT_SWITCH_HP_EHP_CURRENCY_MODE,PlayerAccountInfo.CPGPMode);
         this.myBriefPanel.deactive();
         if(this.mCurrentPageIndex != -1)
         {
            subPanel = this.mPanelsInUse[this.mCurrentPageIndex];
            if(Boolean(subPanel))
            {
               this.mPanelsInUse[this.mCurrentPageIndex].deactive();
            }
            this.mCurrentPageIndex = -1;
         }
      }
      
      override public function setView(view:BaseView) : void
      {
         var panel:BaseSubElement = null;
         super.setView(view);
         var uiCpp:UiCppMatchSelectView = view.getUiCpp() as UiCppMatchSelectView;
         for each(panel in this.mPanels)
         {
            if(panel is WarGodProgressPanel)
            {
               (panel as WarGodProgressPanel).setUiCpp(uiCpp);
               break;
            }
         }
      }
      
      private function onSetTab(index:int) : void
      {
         var lastPageIndex:int = this.mCurrentPageIndex;
         if(this.mCurrentPageIndex != index)
         {
            this.myToggleBtn0.setBar(index == 0);
            this.myToggleBtn1.setBar(index == 1);
            this.myToggleBtn2.setBar(index == 2);
            this.myToggleBtn3.setBar(index == 3);
            this.myToggleBtn4.setBar(index == 4);
            this.myToggleBtn5.setBar(index == 5);
            this.switchSubPanel(index);
            this.mCurrentPageIndex = index;
         }
         if(index == this.mRulePageIndex)
         {
            this.onSetTab(lastPageIndex);
            if(Boolean(this.mRuleBreadCrumb))
            {
               CFunctionCommonContainer.AS_SetNotified(UINotifications.ONBOARD_WARGOD);
               if(Boolean(this.mRuleBreadCrumb.parent))
               {
                  this.mRuleBreadCrumb.parent.removeChild(this.mRuleBreadCrumb);
               }
               this.mRuleBreadCrumb = null;
            }
         }
         if(index == this.mCreditPageIndex)
         {
            this.onSetTab(lastPageIndex);
         }
      }
      
      private function switchSubPanel(nextPanelIndex:int) : void
      {
         var prevPanel:BaseSubElement = null;
         var isJuniorWarGod:Boolean = false;
         var nextPanel:BaseSubElement = null;
         if(this.mCurrentPageIndex >= 0 && this.mCurrentPageIndex < this.mPanelsInUse.length)
         {
            prevPanel = this.mPanelsInUse[this.mCurrentPageIndex];
            if(Boolean(prevPanel))
            {
               prevPanel.deactive();
            }
         }
         if(nextPanelIndex == this.mRulePageIndex)
         {
            isJuniorWarGod = WarGodUtility.isJuniorWarGod(this.mWarGodPlayerObj);
            if(!isJuniorWarGod)
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_WARGODLADDER_INSTRUCTION);
            }
            else
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_JUNIOR_WARGODLADDER_INSTRUCTION);
            }
         }
         else if(nextPanelIndex == this.mCreditPageIndex)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_WARGODLADDER_CREDIT);
         }
         else if(nextPanelIndex >= 0 && nextPanelIndex < this.mPanelsInUse.length)
         {
            nextPanel = this.mPanelsInUse[nextPanelIndex];
            if(Boolean(nextPanel))
            {
               nextPanel.active();
            }
         }
      }
      
      private function onDecideJuniorWarGodPlaylist(evt:ParaEvent) : void
      {
         (_view.getUiCpp() as UiCppMatchSelectView).decideJuniorWarGodPlaylist(evt.myPara);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppViewPanel(this);
      }
   }
}

