package codo.component.lobby
{
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class LobbyTeamJoinButton extends UIInteractiveComponent
   {
      
      private static const MOUSE_OUT_FRAME:int = 1;
      
      private static const MOUSE_OVER_FRAME:int = 2;
      
      private static const MOUSE_CLICK_FRAME:int = 3;
      
      public var myTextField:TextField;
      
      public var myFriendlyBg:MovieClip;
      
      public var myEnemyBg:MovieClip;
      
      public var mySpectatorBg:MovieClip;
      
      public var myDisableMask:MovieClip;
      
      private var m_currentBg:MovieClip;
      
      public function LobbyTeamJoinButton()
      {
         super();
         this.myDisableMask.visible = false;
         this.myTextField.text = LocalizeUtil.localize(Dict.JOIN_FORCE);
         isInteractiveEnabled = true;
         setClickCallback(this.onClickedHandler);
      }
      
      public function setStyle(style:int) : void
      {
         if(style == LobbyConstants.STYLE_FRIENDLY)
         {
            this.myFriendlyBg.visible = true;
            this.myEnemyBg.visible = false;
            this.mySpectatorBg.visible = false;
            this.m_currentBg = this.myFriendlyBg;
         }
         else if(style == LobbyConstants.STYLE_ENEMY)
         {
            this.myFriendlyBg.visible = false;
            this.myEnemyBg.visible = true;
            this.mySpectatorBg.visible = false;
            this.m_currentBg = this.myEnemyBg;
         }
         else if(style == LobbyConstants.STYLE_SPECTATOR)
         {
            this.myFriendlyBg.visible = false;
            this.myEnemyBg.visible = false;
            this.mySpectatorBg.visible = true;
            this.m_currentBg = this.mySpectatorBg;
         }
      }
      
      override public function set enabled(isEnabled:Boolean) : void
      {
         super.enabled = isEnabled;
         this.myDisableMask.visible = !isEnabled;
         this.alpha = isEnabled ? 1 : 0.5;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.m_currentBg.gotoAndStop(MOUSE_OVER_FRAME);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.m_currentBg.gotoAndStop(MOUSE_OUT_FRAME);
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         this.m_currentBg.gotoAndStop(MOUSE_CLICK_FRAME);
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         this.m_currentBg.gotoAndStop(MOUSE_OUT_FRAME);
      }
      
      private function onClickedHandler() : void
      {
         dispatchEvent(new Event(LobbyConstants.EVENT_TEAM_JOIN_BUTTON_CLICKED,true));
      }
   }
}

