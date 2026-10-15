package codo.component.lobby
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionContainer;
   import codo.component.ScrollList;
   import codo.component.playercard.PlayerCard_Lobby;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.localization.Dict;
   import codo.objects.RoomMemberObj;
   import codo.objects.ScrollListSettings;
   import codo.utils.DataUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class LobbyTeamPanel extends BaseSubElement
   {
      
      private static const BG_FRIENDLY_FRAME:int = 1;
      
      private static const BG_ENEMY_FRAME:int = 2;
      
      private static const BG_SPECTATOR_FRAME:int = 3;
      
      private static const SCROLL_LIST_X:int = 4;
      
      private static const SCROLL_LIST_X_NO_SCROLL:int = 7;
      
      public static const TITLE_LIST_GAP:int = 16;
      
      public static const MEMBER_LIST_TYPE_TEAM:int = 0;
      
      public static const MEMBER_LIST_TYPE_SPECTATOR:int = 1;
      
      public static const MEMBER_LIST_TYPE_FULL:int = 2;
      
      public static const MEMBER_LIST_HEIGHT_TEAM:int = 245;
      
      public static const MEMBER_LIST_HEIGHT_SPECTATOR:int = 245;
      
      public static const MEMBER_LIST_HEIGHT_FULL:int = 700;
      
      private static const TWEEN_DURATION:Number = 0.5;
      
      private static const MEMBER_LIST_CLASS_NAME:String = "codo.component.lobby.lobbyTeamMember";
      
      private static const MEMBER_LIST_ENTRY_OFFSET:int = 3;
      
      private static const MEMBER_LIST_ENTRY_WIDTH:int = 330;
      
      private static const PLAYER_CARD_MOUSE_Y_OFFSET:Number = 150;
      
      private static const TEAM_EXPAND_HEIGHT:int = 250;
      
      private static const FULL_EXPAND_HEIGHT:int = 700;
      
      private static const SPEC_EXPAND_HEIGHT:int = 150;
      
      public var myScrollList:ScrollList;
      
      public var myMask:MovieClip;
      
      public var myBlackBg:MovieClip;
      
      public var myTitle:LobbyTeamPanelTitle;
      
      public var myTeamPanelPlayerCard:PlayerCard_Lobby;
      
      public const m_CollapsedHeight:int = 50;
      
      public var m_isExpanded:Boolean = true;
      
      public var m_ExpandedHeight:int = 250;
      
      private var m_enableViewMember:Boolean = true;
      
      private var m_enableViewName:Boolean = true;
      
      private var m_showPartyMemberTag:Boolean = false;
      
      private var m_team:int;
      
      private var m_isFriendly:Boolean;
      
      public function LobbyTeamPanel()
      {
         super();
         var scrollListSettings:ScrollListSettings = new ScrollListSettings();
         scrollListSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         scrollListSettings.useNavArrows = false;
         scrollListSettings.autoSize = false;
         scrollListSettings.autoSizeItems = false;
         scrollListSettings.itemPadding = MEMBER_LIST_ENTRY_OFFSET;
         this.myScrollList.settings = scrollListSettings;
         this.myScrollList.listItemClickCallback = this.onMemberClicked;
         this.myScrollList.listItemFocusCallback = this.onMemberFocused;
         this.myScrollList.listItemUnfocusCallback = this.onMemberUnfocused;
         this.myScrollList.width = MEMBER_LIST_ENTRY_WIDTH + 8;
         this.myScrollList.resetList();
         this.myTeamPanelPlayerCard.visible = false;
         this.setFriendly(true);
      }
      
      public function setTeamId(teamId:int) : void
      {
         this.m_team = teamId;
         this.myTitle.setTeamId(teamId);
         if(teamId == LobbyConstants.TEAM_TF141)
         {
            this.setPanelHeight(MEMBER_LIST_TYPE_TEAM);
         }
         else if(teamId == LobbyConstants.TEAM_SCAR)
         {
            this.setPanelHeight(MEMBER_LIST_TYPE_TEAM);
         }
         else if(teamId == LobbyConstants.TEAM_SPECTATOR)
         {
            this.setPanelHeight(MEMBER_LIST_TYPE_SPECTATOR);
         }
      }
      
      public function set unnamedTitle(unnamed:Boolean) : void
      {
         this.myTitle.setIsUnnamedTeam(unnamed);
      }
      
      public function switchShowPartyMemberTag(value:Boolean) : void
      {
         this.m_showPartyMemberTag = value;
      }
      
      public function setPanelHeight(type:int) : void
      {
         var panelHeight:Number = MEMBER_LIST_HEIGHT_TEAM;
         var scrollListX:Number = SCROLL_LIST_X;
         switch(type)
         {
            case MEMBER_LIST_TYPE_TEAM:
               panelHeight = MEMBER_LIST_HEIGHT_TEAM;
               scrollListX = SCROLL_LIST_X;
               this.m_ExpandedHeight = TEAM_EXPAND_HEIGHT;
               break;
            case MEMBER_LIST_TYPE_SPECTATOR:
               panelHeight = MEMBER_LIST_HEIGHT_SPECTATOR;
               scrollListX = SCROLL_LIST_X;
               this.m_ExpandedHeight = SPEC_EXPAND_HEIGHT;
               break;
            case MEMBER_LIST_TYPE_FULL:
               panelHeight = MEMBER_LIST_HEIGHT_FULL;
               scrollListX = SCROLL_LIST_X_NO_SCROLL;
               this.m_ExpandedHeight = FULL_EXPAND_HEIGHT;
         }
         this.myMask.height = panelHeight;
         this.myBlackBg.height = panelHeight;
         this.myScrollList.x = scrollListX;
         this.myScrollList.height = panelHeight - this.myScrollList.y - TITLE_LIST_GAP;
         this.myScrollList.resetList();
      }
      
      public function setFriendly(isFriendly:Boolean) : void
      {
         var memberItem:LobbyTeamMember = null;
         this.m_isFriendly = isFriendly;
         this.myTitle.setFriendly(this.m_isFriendly);
         if(this.m_team != LobbyConstants.TEAM_SPECTATOR)
         {
            if(this.m_isFriendly)
            {
               this.myBlackBg.gotoAndStop(BG_FRIENDLY_FRAME);
            }
            else
            {
               this.myBlackBg.gotoAndStop(BG_ENEMY_FRAME);
            }
         }
         else
         {
            this.myBlackBg.gotoAndStop(BG_SPECTATOR_FRAME);
         }
         var memberItemNum:int = this.myScrollList.numberOfItems;
         for(var i:int = 0; i < memberItemNum; i++)
         {
            memberItem = this.myScrollList.getItem(i) as LobbyTeamMember;
            memberItem.setFriendly(this.m_isFriendly);
         }
      }
      
      public function updateMembers(teamData:Array) : void
      {
         var roomMemberObj:RoomMemberObj = null;
         var addedItem:LobbyTeamMember = null;
         this.myScrollList.resetList();
         var members:Array = [];
         var fakeClients:Vector.<RoomMemberObj> = CFunctionContainer.GetFakeClientObjs(this.m_team,teamData.length);
         DataUtil.copyElems(members,teamData,fakeClients);
         var maxDlcLevel:int = getDP(DataID.DLC_GET_MAXDLCLEVEL);
         this.addTeamMateTagForDMZMode(members);
         for each(roomMemberObj in members)
         {
            addedItem = this.myScrollList.addItem(roomMemberObj,MEMBER_LIST_CLASS_NAME) as LobbyTeamMember;
            addedItem.setNameViewable(this.m_enableViewName);
            addedItem.setFriendly(this.m_isFriendly);
            addedItem.showMiniClientTag(roomMemberObj.dlcLevel < maxDlcLevel);
         }
         this.myScrollList.refreshVisuals();
      }
      
      private function addTeamMateTagForDMZMode(members:Array) : void
      {
         var roomMemberObj:RoomMemberObj = null;
         if(!this.m_showPartyMemberTag)
         {
            return;
         }
         for each(roomMemberObj in members)
         {
            if(roomMemberObj.isInMyParty && !roomMemberObj.isMe)
            {
               roomMemberObj.isPartyMember = true;
            }
            else
            {
               roomMemberObj.isPartyMember = false;
            }
         }
      }
      
      public function setJoinButtonState(isEnabled:Boolean, isVisible:Boolean) : void
      {
         this.myTitle.setJoinButtonState(isEnabled,isVisible);
      }
      
      public function setExpanded(expanded:Boolean, shouldAnimate:Boolean) : void
      {
         var targetAlpha:Number = NaN;
         var sourceY:int = 0;
         var targetY:int = 0;
         var bgTargetY:int = 0;
         var duration:Number = NaN;
         if(expanded)
         {
            targetAlpha = 1;
            sourceY = -140;
            targetY = 35;
            bgTargetY = 0;
         }
         else
         {
            targetAlpha = 0;
            sourceY = 35;
            targetY = -140;
            bgTargetY = -175;
            this.onMemberUnfocused();
         }
         if(shouldAnimate)
         {
            duration = (targetY - this.myScrollList.y) / (targetY - sourceY) * TWEEN_DURATION;
            TweenLite.to(this.myScrollList,duration,{
               "y":targetY,
               "alpha":targetAlpha
            });
            TweenLite.to(this.myBlackBg,duration,{
               "y":bgTargetY,
               "alpha":targetAlpha
            });
         }
         else
         {
            this.myScrollList.y = targetY;
            this.myBlackBg.y = bgTargetY;
            this.myScrollList.alpha = targetAlpha;
            this.myBlackBg.alpha = targetAlpha;
         }
         this.myTitle.setExpanded(expanded);
         this.m_isExpanded = expanded;
      }
      
      public function updateSelectedState(selectedTeamMemberID:String) : void
      {
         var teamMember:LobbyTeamMember = null;
         var isSelected:Boolean = false;
         var isSpectator:Boolean = false;
         for(var i:int = 0; i < this.myScrollList.numberOfItems; i++)
         {
            teamMember = this.myScrollList.getItem(i) as LobbyTeamMember;
            isSelected = teamMember.getData().id == selectedTeamMemberID;
            isSpectator = teamMember.getData().team == LobbyConstants.TEAM_SPECTATOR;
            teamMember.setSelected(!isSpectator && isSelected);
         }
      }
      
      public function switchEnableViewMember(value:Boolean) : void
      {
         this.m_enableViewMember = value;
      }
      
      public function switchEnableViewPlayerName(value:Boolean) : void
      {
         this.m_enableViewName = value;
      }
      
      private function onMemberClicked(callbackData:*) : void
      {
         var teamMember:LobbyTeamMember = callbackData as LobbyTeamMember;
         var roomMemberData:RoomMemberObj = teamMember.getData();
         if(this.m_enableViewMember)
         {
            this.broadcast(BCEvent.EVT_LOBBY_TRY_SELECT_MEMBER,roomMemberData.id);
         }
         else
         {
            showMsg(Dict.PROHIBIT_VIEW_MEMBER_BEFORE_MATCH,MsgBtnCount.ONE);
         }
      }
      
      private function onMemberFocused(member:RoomMemberObj) : void
      {
         if(!this.m_enableViewMember)
         {
            return;
         }
         this.myTeamPanelPlayerCard.selectMember(member);
         this.onStageMouseMoveHandle();
         if(!stage.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         }
         this.myTeamPanelPlayerCard.visible = true;
      }
      
      private function onMemberUnfocused() : void
      {
         if(stage.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         }
         this.myTeamPanelPlayerCard.visible = false;
      }
      
      private function onStageMouseMoveHandle() : void
      {
         this.myTeamPanelPlayerCard.y = stage.mouseY - this.y - PLAYER_CARD_MOUSE_Y_OFFSET;
      }
   }
}

