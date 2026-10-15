package codo.views
{
   import codo.base.BaseSubElement;
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.CallToActionButton;
   import codo.component.FilterToggleButton;
   import codo.component.ViewPanelBase;
   import codo.component.factory.ButtonFactory;
   import codo.component.matchselect.ModeSelectScrollList;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.GlobalBottomBtnStatus;
   import codo.constants.MsgBtnCount;
   import codo.constants.QuickMatchType;
   import codo.cpp.UiCppView;
   import codo.cpp.UiCppViewPanel;
   import codo.localization.Dict;
   import codo.localization.DictBattleCity;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.AccountObj;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.PartyMemberObj;
   import codo.objects.PlayListObj;
   import codo.objects.ScrollListSettings;
   import codo.objects.SystemMsgObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import codo.views.battlecity_parts.BattleCityBaseSubPanel;
   import com.society.comscore.DAXDispatcher;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class BattleCityPanel extends ViewPanelBase
   {
      
      private static const BUTTON_INIT_X:int = 1513;
      
      private static const BUTTON_GAP_X:int = 10;
      
      private static const BUTTON_WIDTH:int = 280;
      
      private static const BUTTON_HEIGHT:int = 59;
      
      private static const SUB_PANEL_INIT_X:int = 521;
      
      private static const SUB_PANEL_INIT_Y:int = 258;
      
      private static const TOGGLE_BTN_INIT_X:int = 524;
      
      private static const TOGGLE_BTN_INIT_Y:int = 200;
      
      public var myLogo:MovieClip;
      
      public var myFrame:MovieClip;
      
      public var myLeftList:ModeSelectScrollList;
      
      public var myToggleBtn:FilterToggleButton;
      
      public var mySoloConfirmBtn:CallToActionButton;
      
      public var myBuddyConfirmBtn:CallToActionButton;
      
      private var mCurrentPageIndex:int = -1;
      
      private var mPanelsInUse:Vector.<BattleCityBaseSubPanel>;
      
      private var mToggleBtns:Vector.<FilterToggleButton>;
      
      private var mLabels:Array;
      
      private var mPartyMembers:Array;
      
      private var mAccountObj:AccountObj;
      
      private var mLeaderBoardPanelIndex:int = -1;
      
      private var mRulePanelIndex:int = -1;
      
      private var mRewardPanelIndex:int = -1;
      
      private var mIsBuddyPlaylist:Boolean = false;
      
      public function BattleCityPanel()
      {
         super();
         this.initStage();
         if(!ScaleformUtil.isScaleform)
         {
            visible = true;
            alpha = 1;
         }
      }
      
      private function initStage() : void
      {
         this.myLogo.myName.text = DictBattleCity.BATTLECITY_LOGO_NAME;
         this.myFrame.gotoAndStop(4);
         this.myBuddyConfirmBtn.label = DictBattleCity.BATTLECITY_START_BUDDY_BATTLE;
         this.myBuddyConfirmBtn.width = BUTTON_WIDTH;
         this.myBuddyConfirmBtn.height = BUTTON_HEIGHT;
         this.myBuddyConfirmBtn.myLabel.fontSize = 28;
         this.mySoloConfirmBtn.label = DictBattleCity.BATTLECITY_START_SOLO_BATTLE;
         this.mySoloConfirmBtn.width = BUTTON_WIDTH;
         this.mySoloConfirmBtn.height = BUTTON_HEIGHT;
         this.mySoloConfirmBtn.myLabel.fontSize = 28;
         this.mySoloConfirmBtn.x = this.myBuddyConfirmBtn.x - 6 - this.myBuddyConfirmBtn.width;
         var leftListSettings:ScrollListSettings = new ScrollListSettings();
         leftListSettings.autoSize = false;
         leftListSettings.autoSizeItems = true;
         leftListSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         leftListSettings.useNavArrows = false;
         leftListSettings.itemPadding = 6;
         leftListSettings.hideScrollBar = true;
         leftListSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_MATCH_SELECT_MODE_OPTION;
         this.myLeftList.settings = leftListSettings;
         this.myLeftList.myDownIndicator.y = 300;
         this.myLeftList.x = 126;
         this.myLeftList.y = 528;
         this.myLeftList.height = 300;
         this.myLeftList.width = 350;
         this.initToggleAndPanel();
      }
      
      private function initToggleAndPanel() : void
      {
         var panel:BattleCityBaseSubPanel = null;
         var defineClass:Class = null;
         this.mToggleBtns = new Vector.<FilterToggleButton>();
         this.mToggleBtns.push(this.myToggleBtn);
         this.mLabels = new Array();
         this.mLabels.push(DictBattleCity.BATTLECITY_GENERAL_INFO);
         var subPanelLinkage:Vector.<String> = new Vector.<String>();
         subPanelLinkage.push("codo.battlecity.battleCityGeneralInfoPanel");
         if(!CFunctionCommonContainer.Dvar_GetBool("ui_lock_dmz_leaderboard"))
         {
            this.mLeaderBoardPanelIndex = this.mLabels.length;
            this.mLabels.push(DictBattleCity.BATTLECITY_LEADER_BOARD);
            subPanelLinkage.push(null);
         }
         this.mLabels.push(DictBattleCity.BATTLECITY_PLAYER_STATE);
         subPanelLinkage.push("codo.battlecity.battleCityPlayerInfoPanel");
         this.mRewardPanelIndex = this.mLabels.length;
         this.mLabels.push(DictBattleCity.BATTLECITY_REWARDS);
         subPanelLinkage.push(null);
         var leagueGlobal:BattleCityLeagueGlobalObj = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         if(leagueGlobal.leaderboardEnabled)
         {
            this.mLabels.push(DictBattleCity.BATTLECITY_LEAGUE_LEADER_BOARD);
            subPanelLinkage.push("codo.battlecity.battleCityLeagueLeaderboard");
         }
         if(!CFunctionCommonContainer.Dvar_GetBool("ui_lock_dmz_rule"))
         {
            this.mRulePanelIndex = this.mLabels.length;
            this.mLabels.push(DictBattleCity.BATTLECITY_RULES);
            subPanelLinkage.push(null);
         }
         this.mPanelsInUse = new Vector.<BattleCityBaseSubPanel>();
         for(var i:int = 0; i < subPanelLinkage.length; i++)
         {
            panel = null;
            if(subPanelLinkage[i] == null)
            {
               this.mPanelsInUse.push(null);
            }
            else
            {
               defineClass = getDefinitionByName(subPanelLinkage[i]) as Class;
               if(Boolean(defineClass))
               {
                  panel = new defineClass() as BattleCityBaseSubPanel;
                  if(Boolean(panel))
                  {
                     addChild(panel);
                     panel.visible = false;
                     panel.x = SUB_PANEL_INIT_X;
                     panel.y = SUB_PANEL_INIT_Y;
                  }
                  this.mPanelsInUse.push(panel);
               }
            }
         }
         this.allocateToggleBtns(getQualifiedClassName(this.myToggleBtn));
         for(i = 0; i < this.mToggleBtns.length; i++)
         {
            if(i >= this.mLabels.length)
            {
               this.mToggleBtns[i].visible = false;
            }
            else
            {
               this.mToggleBtns[i].visible = true;
               this.mToggleBtns[i].label = this.mLabels[i];
               this.mToggleBtns[i].registerClickEvent(this.onSetTab,i);
               if(i > 0)
               {
                  this.mToggleBtns[i].x = this.mToggleBtns[i - 1].x + this.mToggleBtns[i - 1].myBackground.width + BUTTON_GAP_X;
               }
            }
         }
      }
      
      private function allocateToggleBtns(className:String) : void
      {
         var toggleInstance:FilterToggleButton = null;
         var offset:int = this.mLabels.length - this.mToggleBtns.length;
         var definitionClass:Class = getDefinitionByName(className) as Class;
         if(!definitionClass)
         {
            return;
         }
         for(var i:int = 0; i < offset; i++)
         {
            toggleInstance = new definitionClass() as FilterToggleButton;
            toggleInstance.x = TOGGLE_BTN_INIT_X;
            toggleInstance.y = TOGGLE_BTN_INIT_Y;
            addChild(toggleInstance);
            this.mToggleBtns.push(toggleInstance);
         }
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         DAXDispatcher.setGameVariant("mp");
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_MATCH_TYPE,QuickMatchType.makeBattleCity());
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_BOTTOM_START_STATUS,GlobalBottomBtnStatus.STATUS_IDLE_MP_PLAYLIST_CHOOSE);
         DataManager.getInstance().addDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getPlaylist);
         DataManager.getInstance().bind(DataID.PARTY_INFO,this.onUpdatePartyInfo);
         DataManager.getInstance().bind(DataID.MY_ACCOUNT,this.bindAccountInfo);
         this.mySoloConfirmBtn.registerClickEvent(this.onSoloConfirmClicked);
         this.myBuddyConfirmBtn.registerClickEvent(this.onBuddyConfirmClicked);
         if(this.mCurrentPageIndex == -1)
         {
            this.onSetTab(0);
         }
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         DataManager.getInstance().removeDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getPlaylist);
         DataManager.getInstance().unbind(DataID.PARTY_INFO,this.onUpdatePartyInfo);
         DataManager.getInstance().unbind(DataID.MY_ACCOUNT,this.bindAccountInfo);
         this.mySoloConfirmBtn.unRegisterClickEvent(this.onSoloConfirmClicked);
         this.myBuddyConfirmBtn.unRegisterClickEvent(this.onBuddyConfirmClicked);
      }
      
      private function onSoloConfirmClicked() : void
      {
         this.mIsBuddyPlaylist = false;
         var playlistObj:PlayListObj = this.getPlaylist();
         this.onStartMatch(playlistObj);
      }
      
      private function onBuddyConfirmClicked() : void
      {
         this.mIsBuddyPlaylist = true;
         var playlistObj:PlayListObj = this.getPlaylist();
         this.onStartMatch(playlistObj);
      }
      
      private function onStartMatch(playlist:PlayListObj) : void
      {
         if(playlist.isBattleCityLeague())
         {
            if(!this.checkBattleCityOpenState())
            {
               return;
            }
            if(!this.checkBattleCityLeagueTicket())
            {
               return;
            }
         }
         if(Boolean(playlist))
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_BATTLE_PREP,playlist.id.toString());
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_BOTTOM_START_GAME);
      }
      
      public function getPlaylist() : PlayListObj
      {
         var buddyPlaylistNum:int = 0;
         var buddyPlaylistObj:PlayListObj = null;
         var playlistObj:PlayListObj = this.myLeftList.selectedData as PlayListObj;
         if(this.mIsBuddyPlaylist && playlistObj.buddyPlaylist != 0)
         {
            buddyPlaylistNum = CFunctionContainer.AS_GetPlayListNumForId(playlistObj.buddyPlaylist);
            buddyPlaylistObj = DataManager.getInstance().getDP(DataID.PLAY_LIST_OBJ,[buddyPlaylistNum]);
            if(Boolean(buddyPlaylistObj))
            {
               playlistObj = buddyPlaylistObj;
            }
         }
         return playlistObj;
      }
      
      private function onUpdatePartyInfo(cRes:Object) : void
      {
         this.mPartyMembers = cRes.data.members;
      }
      
      public function onPlaylistSelect(playlistSelection:int) : void
      {
         var playlistObj:PlayListObj = null;
         var i:int = 0;
         var panel:BattleCityBaseSubPanel = null;
         if(playlistSelection < this.myLeftList.listData.length)
         {
            playlistObj = this.myLeftList.listData[playlistSelection] as PlayListObj;
            if(Boolean(playlistObj))
            {
               PlayListObj.setSelectedPlaylist(playlistObj);
               for(i = 0; i < this.mPanelsInUse.length; i++)
               {
                  panel = this.mPanelsInUse[i];
                  if(null != panel)
                  {
                     panel.onPlaylistSelect(playlistObj);
                  }
               }
               this.updateStartButtons(playlistObj);
            }
         }
      }
      
      private function onSetTab(index:int) : void
      {
         var i:int = 0;
         var lastPageIndex:int = this.mCurrentPageIndex;
         if(this.mCurrentPageIndex != index)
         {
            for(i = 0; i < this.mToggleBtns.length; i++)
            {
               this.mToggleBtns[i].setBar(index == i);
            }
            this.switchSubPanel(index);
            this.mCurrentPageIndex = index;
         }
         if(index == this.mRulePanelIndex || index == this.mRewardPanelIndex || index == this.mLeaderBoardPanelIndex)
         {
            this.onSetTab(lastPageIndex);
         }
      }
      
      private function switchSubPanel(nextPanelIndex:int) : void
      {
         var prevPanel:BaseSubElement = null;
         var nextPanel:BaseSubElement = null;
         if(this.mCurrentPageIndex >= 0 && this.mCurrentPageIndex < this.mPanelsInUse.length)
         {
            prevPanel = this.mPanelsInUse[this.mCurrentPageIndex];
            if(Boolean(prevPanel))
            {
               prevPanel.deactive();
            }
         }
         if(nextPanelIndex == this.mRulePanelIndex)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_BATTLECITY_INSTRUCTION);
         }
         else if(nextPanelIndex == this.mLeaderBoardPanelIndex)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_BATTLECITY_LEADERBOARD);
         }
         else if(nextPanelIndex == this.mRewardPanelIndex)
         {
            if(Boolean(DataManager.getInstance().getDP(DataID.IS_MARKETPLACE_READY)) && !DataManager.getInstance().getDP(DataID.IS_MARKETPLACE_MAINTAIN))
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_MAP_REWARDS);
            }
            else
            {
               BaseView.staticShowMsg(Dict.DW_MARKETPLACE_MAINTAIN,MsgBtnCount.ONE);
            }
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
      
      private function updateStartButtons(playlistObj:PlayListObj) : void
      {
         var leagueGlobal:BattleCityLeagueGlobalObj = null;
         if(playlistObj.buddyPlaylist != 0)
         {
            this.mySoloConfirmBtn.label = DictBattleCity.BATTLECITY_START_SOLO_BATTLE;
            this.myBuddyConfirmBtn.visible = true;
            this.myBuddyConfirmBtn.x = BUTTON_INIT_X;
            this.mySoloConfirmBtn.x = this.myBuddyConfirmBtn.x - 6 - this.myBuddyConfirmBtn.width;
         }
         else
         {
            this.mySoloConfirmBtn.label = DictBattleCity.BATTLECITY_START_BATTLE;
            this.myBuddyConfirmBtn.visible = false;
            this.mySoloConfirmBtn.x = BUTTON_INIT_X;
         }
         this.switchEnableActionButton(this.mySoloConfirmBtn,true);
         this.switchEnableActionButton(this.myBuddyConfirmBtn,true);
         if(playlistObj.isBattleCityLeague())
         {
            leagueGlobal = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
            if(!leagueGlobal.enabled)
            {
               this.switchEnableActionButton(this.mySoloConfirmBtn,false);
               this.switchEnableActionButton(this.myBuddyConfirmBtn,false);
            }
         }
      }
      
      private function switchEnableActionButton(button:CallToActionButton, enabled:Boolean) : void
      {
         button.enabled = enabled;
         button.alpha = enabled ? 1 : 0.5;
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppViewPanel(this);
      }
      
      private function bindAccountInfo(cResult:Object) : void
      {
         this.mAccountObj = new AccountObj(cResult.data);
      }
      
      private function checkBattleCityOpenState() : Boolean
      {
         var leagueDisableMsgObj:SystemMsgObj = null;
         var leagueGlobal:BattleCityLeagueGlobalObj = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         if(!leagueGlobal.enabled)
         {
            leagueDisableMsgObj = SystemMsgObj.getObj("@" + leagueGlobal.disableReason,MsgBtnCount.ONE);
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,leagueDisableMsgObj);
            return false;
         }
         return true;
      }
      
      private function checkBattleCityLeagueTicket() : Boolean
      {
         var noTicketMsgObj:SystemMsgObj = null;
         var i:int = 0;
         var partyMember:PartyMemberObj = null;
         var partyMemberMsg:String = null;
         var partyMemberMsgObj:SystemMsgObj = null;
         if(this.mAccountObj.dmzlBattleTicket <= 0 && this.mAccountObj.dmzlFreeTicket <= 0)
         {
            noTicketMsgObj = SystemMsgObj.getObj(DictBattleCity.BATTLECITY_LEAGUE_NO_TICKET,MsgBtnCount.ONE);
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,noTicketMsgObj);
            return false;
         }
         var isInParty:Boolean = DataManager.getInstance().getDP(DataID.IS_IN_PARTY);
         if(isInParty)
         {
            for(i = 0; i < this.mPartyMembers.length; i++)
            {
               partyMember = this.mPartyMembers[i] as PartyMemberObj;
               if(!partyMember.meetDMZLeagueTicketRequirement)
               {
                  partyMemberMsg = LocalizeUtil.param(LocalizeUtil.localize(DictBattleCity.BATTLECITY_LEAGUE_PARTY_MEMBER_NO_TICKET),[partyMember.name]);
                  partyMemberMsgObj = SystemMsgObj.getObj(partyMemberMsg,MsgBtnCount.ONE);
                  EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,partyMemberMsgObj);
                  return false;
               }
            }
         }
         return true;
      }
   }
}

