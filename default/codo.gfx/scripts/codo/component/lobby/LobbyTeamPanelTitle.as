package codo.component.lobby
{
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.SE_ID;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class LobbyTeamPanelTitle extends UIInteractiveComponent
   {
      
      private static const BG_FRIENDLY_FRAME:int = 1;
      
      private static const BG_ENEMY_FRAME:int = 2;
      
      private static const BG_SPECTATOR_FRAME:int = 3;
      
      public var myLogoImg:MovieClip;
      
      public var myJoinBtn:LobbyTeamJoinButton;
      
      public var myTitleTF:MovieClip;
      
      public var myTeamPanelTitleBackground:MovieClip;
      
      private var m_team:int;
      
      private var m_isUnnamedTeam:Boolean;
      
      private var m_isFriendly:Boolean;
      
      public function LobbyTeamPanelTitle()
      {
         super();
         isInteractiveEnabled = true;
         this.myLogoImg.mouseEnabled = false;
         this.myLogoImg.mouseChildren = false;
         this.m_isUnnamedTeam = false;
         setClickCallback(this.onMouseClickTopBar);
         audioRef.overrideClickAudio(SE_ID.PRIMARYSELECT_PROCEED);
      }
      
      public function setTeamId(teamId:int) : void
      {
         this.m_team = teamId;
         if(this.m_isUnnamedTeam)
         {
            return;
         }
         if(teamId == LobbyConstants.TEAM_TF141)
         {
            this.myLogoImg.gotoAndStop(1);
            this.myTitleTF.myTextTF.text = Dict.FORCE_TF;
         }
         else if(teamId == LobbyConstants.TEAM_SCAR)
         {
            this.myLogoImg.gotoAndStop(2);
            this.myTitleTF.myTextTF.text = Dict.FORCE_SC;
         }
         else if(teamId == LobbyConstants.TEAM_SPECTATOR)
         {
            this.myLogoImg.gotoAndStop(3);
            this.myTitleTF.myTextTF.text = LocalizeUtil.localize(Dict.FORCE_SPECTATOR);
         }
      }
      
      public function setFriendly(isFriendly:Boolean) : void
      {
         this.m_isFriendly = isFriendly;
         if(this.m_isUnnamedTeam)
         {
            return;
         }
         if(this.m_team != LobbyConstants.TEAM_SPECTATOR)
         {
            if(this.m_isFriendly)
            {
               this.myTeamPanelTitleBackground.gotoAndStop(BG_FRIENDLY_FRAME);
               this.myJoinBtn.setStyle(LobbyConstants.STYLE_FRIENDLY);
            }
            else
            {
               this.myTeamPanelTitleBackground.gotoAndStop(BG_ENEMY_FRAME);
               this.myJoinBtn.setStyle(LobbyConstants.STYLE_ENEMY);
            }
         }
         else
         {
            this.myTeamPanelTitleBackground.gotoAndStop(BG_SPECTATOR_FRAME);
            this.myJoinBtn.setStyle(LobbyConstants.STYLE_SPECTATOR);
         }
      }
      
      public function setIsUnnamedTeam(unnamed:Boolean) : void
      {
         if(this.m_isUnnamedTeam != unnamed)
         {
            this.m_isUnnamedTeam = unnamed;
            if(this.m_isUnnamedTeam)
            {
               this.setupUnnamedStyle();
            }
            else
            {
               this.setTeamId(this.m_team);
               this.setFriendly(this.m_isFriendly);
            }
         }
      }
      
      public function setJoinButtonState(isEnabled:Boolean, isVisible:Boolean) : void
      {
         this.myJoinBtn.enabled = isEnabled;
         this.myJoinBtn.visible = isVisible;
      }
      
      public function setExpanded(expanded:Boolean) : void
      {
         enabled = !expanded;
      }
      
      private function onMouseClickTopBar() : void
      {
         dispatchEvent(new Event(LobbyConstants.EVENT_TEAM_PANEL_TITLE_CLICK,true));
      }
      
      private function setupUnnamedStyle() : void
      {
         this.myLogoImg.gotoAndStop(3);
         this.myTitleTF.myTextTF.text = LocalizeUtil.localize(Dict.FORCE_TEAM_MEMBERS);
         this.myTeamPanelTitleBackground.gotoAndStop(BG_FRIENDLY_FRAME);
         this.myJoinBtn.setStyle(LobbyConstants.STYLE_FRIENDLY);
      }
   }
}

