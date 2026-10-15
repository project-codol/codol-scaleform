package codo.component.lobby
{
   import codo.component.PlayerName;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.Dict;
   import codo.localization.DictWarGod;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.PlayerNameSettings;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class LobbyTeamMember extends UIInteractiveComponent
   {
      
      private static const BG_NORMAL_FRAME:int = 1;
      
      private static const BG_MOUSE_OVER_FRAME:int = 2;
      
      private static const BG_MOUSE_DOWN_FRAME:int = 3;
      
      private static const BG_SELECTED_FRAME:int = 4;
      
      private static const HOST_HIGH_LIGHT_FRAME:int = 2;
      
      private static const HOST_FRIENDLY_FRAME:int = 3;
      
      private static const HOST_ENEMY_FRAME:int = 4;
      
      private static const HOST_SPECTATOR_FRAME:int = 5;
      
      public var myName:PlayerName;
      
      public var myMiniTag:TextField;
      
      public var myHosting:MovieClip;
      
      public var myBackground:MovieClip;
      
      public var myBorder:MovieClip;
      
      private var m_teamIndex:int;
      
      private var m_isHost:Boolean;
      
      private var m_isLocalPlayer:Boolean;
      
      private var m_isReady:Boolean;
      
      private var m_playerName:String;
      
      private var m_playerID:String;
      
      private var m_selected:Boolean;
      
      private var m_mouseOver:Boolean;
      
      private var m_mouseDown:Boolean;
      
      private var m_enableViewName:Boolean;
      
      private var m_basicInfo:PlayerBasicInfoObj;
      
      private var m_isFriendly:Boolean;
      
      public function LobbyTeamMember()
      {
         super();
         isInteractiveEnabled = true;
         this.m_mouseOver = false;
         this.m_mouseDown = false;
         var nameSetting:PlayerNameSettings = new PlayerNameSettings();
         nameSetting.mode = PlayerNameSettings.MODE_DIRECT;
         nameSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT;
         nameSetting.textWidth = 280;
         nameSetting.textHeight = 24;
         nameSetting.fontSize = 16;
         nameSetting.textColor = GlobalGuide.WHITE;
         nameSetting.customHighlight = true;
         this.myName.settings = nameSetting;
         this.myMiniTag.font = GlobalGuide.FONT_FACE_BOLD;
         this.myMiniTag.fontSize = 16;
         this.myMiniTag.fontColor = GlobalGuide.WHITE;
         this.myMiniTag.text = Dict.MINI_CLIENT;
         this.m_basicInfo = new PlayerBasicInfoObj();
      }
      
      override public function setData(data:*) : void
      {
         mData = data;
         this.m_teamIndex = mData.team;
         this.m_isHost = mData.isHost;
         this.m_isLocalPlayer = mData.isMe;
         this.m_isReady = mData.isReady;
         this.m_playerName = mData.name;
         if(Boolean(mData.isPartyMember))
         {
            this.m_playerName = LocalizeUtil.localize(Dict.ROOM_MEMBER_SAME_PARTY) + mData.name;
         }
         this.m_playerID = mData.id;
         enabled = true;
         this.updateAppearance();
      }
      
      public function setSelected(isSelected:Boolean) : void
      {
         this.m_selected = isSelected;
         this.updateAppearance();
      }
      
      public function setNameViewable(viewable:Boolean) : void
      {
         this.m_enableViewName = viewable;
         this.updateName();
      }
      
      public function showMiniClientTag(isShow:Boolean) : void
      {
         this.myMiniTag.visible = isShow;
      }
      
      public function setFriendly(isFrendly:Boolean) : void
      {
         this.m_isFriendly = isFrendly;
         this.updateHosting();
      }
      
      public function reset() : void
      {
         mData = null;
         this.m_teamIndex = LobbyConstants.TEAM_TF141;
         this.m_isHost = false;
         this.m_isReady = false;
         this.m_isLocalPlayer = false;
         this.m_playerName = "";
         this.m_selected = false;
         this.updateAppearance();
      }
      
      private function updateAppearance() : void
      {
         this.updateName();
         this.updateBackground();
         this.updateHosting();
      }
      
      private function updateName() : void
      {
         if(this.m_enableViewName)
         {
            this.assembleBasicInfo();
            this.myName.setData(this.m_playerName,this.m_playerID,this.m_basicInfo);
         }
         else
         {
            this.myName.setData(DictWarGod.WARGOD_HIDDEN_NAME,"");
         }
         if(this.m_isLocalPlayer)
         {
            this.myName.myTextField.fontColor = GlobalGuide.CODO_YELLOW;
            this.myName.alpha = 1;
         }
         else if(this.m_selected || this.m_mouseOver)
         {
            this.myName.myTextField.fontColor = GlobalGuide.WHITE;
            this.myName.alpha = 1;
         }
         else if(!this.m_isReady)
         {
            this.myName.myTextField.fontColor = GlobalGuide.WHITE;
            this.myName.alpha = 0.6;
         }
         else if(this.m_teamIndex == LobbyConstants.TEAM_TF141)
         {
            this.myName.myTextField.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
            this.myName.alpha = 1;
         }
         else if(this.m_teamIndex == LobbyConstants.TEAM_SCAR)
         {
            this.myName.myTextField.fontColor = GlobalGuide.CODO_RED;
            this.myName.alpha = 1;
         }
         else if(this.m_teamIndex == LobbyConstants.TEAM_SPECTATOR)
         {
            this.myName.myTextField.fontColor = GlobalGuide.CODO_YELLOW;
            this.myName.alpha = 0.5;
         }
         this.myMiniTag.x = this.myName.x + this.myName.width;
      }
      
      private function updateBackground() : void
      {
         if(this.m_mouseDown)
         {
            this.myBackground.gotoAndStop(BG_MOUSE_DOWN_FRAME);
         }
         else if(this.m_mouseOver)
         {
            this.myBackground.gotoAndStop(BG_MOUSE_OVER_FRAME);
         }
         else if(this.m_selected)
         {
            this.myBackground.gotoAndStop(BG_SELECTED_FRAME);
         }
         else
         {
            this.myBackground.gotoAndStop(BG_NORMAL_FRAME);
         }
      }
      
      private function assembleBasicInfo() : void
      {
         this.m_basicInfo.available = true;
         this.m_basicInfo.entityID = mData.id;
         this.m_basicInfo.entityName = mData.name;
         this.m_basicInfo.level = mData.level;
         this.m_basicInfo.prestige = mData.prestige;
         this.m_basicInfo.clanName = mData.clanName;
         this.m_basicInfo.wargodScore = mData.wargodScore;
         this.m_basicInfo.wargodSeason = mData.wargodSeason;
         this.m_basicInfo.playerCardBackground = mData.callSignObj.cardBackgroundItemID;
         this.m_basicInfo.playerCardTitle = mData.callSignObj.cardTitleItemID;
         this.m_basicInfo.playerCardBadge = mData.callSignObj.cardIconItemID;
         this.m_basicInfo.playerCardNameplate = mData.callSignObj.cardNameplateItemID;
         this.m_basicInfo.playerCardFrame = mData.callSignObj.cardFrameItemID;
      }
      
      private function updateHosting() : void
      {
         this.myHosting.visible = this.m_isHost;
         if(!this.m_isHost)
         {
            return;
         }
         if(this.m_selected)
         {
            this.myHosting.gotoAndStop(HOST_HIGH_LIGHT_FRAME);
         }
         else if(this.m_teamIndex == LobbyConstants.TEAM_SPECTATOR)
         {
            this.myHosting.gotoAndStop(HOST_SPECTATOR_FRAME);
         }
         else if(this.m_isFriendly)
         {
            this.myHosting.gotoAndStop(HOST_FRIENDLY_FRAME);
         }
         else
         {
            this.myHosting.gotoAndStop(HOST_ENEMY_FRAME);
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.m_mouseOver = true;
         this.updateName();
         this.updateBackground();
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.m_mouseOver = false;
         this.updateName();
         this.updateBackground();
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         this.m_mouseDown = true;
         this.updateBackground();
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         this.m_mouseDown = false;
         this.updateBackground();
      }
   }
}

