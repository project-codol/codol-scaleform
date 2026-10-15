package codo.views.friend_parts
{
   import codo.component.PlayerName;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.playerAccount.PlayerAccountInfoPrivileges;
   import codo.component.social.OnlineStatusWidget;
   import codo.component.social.SocialHamburgerButton;
   import codo.objects.PlayerNameSettings;
   import codo.style.GlobalGuide;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   
   public class FriendSelector extends UIInteractiveComponent
   {
      
      private static var mOptionButtonClickHandler:Function;
      
      private static const ITEM_WIDTH:int = 643;
      
      public var myName:PlayerName;
      
      public var myOnlineState:OnlineStatusWidget;
      
      public var myBackground:MovieClip;
      
      public var myOptionBtn:SocialHamburgerButton;
      
      public var myWargodTier:MovieClip;
      
      public var myPlayerPrivileges:PlayerAccountInfoPrivileges;
      
      public function FriendSelector()
      {
         super();
         isInteractiveEnabled = true;
         var nameSetting:PlayerNameSettings = new PlayerNameSettings();
         nameSetting.mode = PlayerNameSettings.MODE_DIRECT;
         nameSetting.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         nameSetting.textWidth = 250;
         nameSetting.textHeight = 25;
         nameSetting.textColor = GlobalGuide.WHITE;
         nameSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_EXTEND;
         this.myName.settings = nameSetting;
      }
      
      public static function setOptionButtonClickHandler(callback:Function) : void
      {
         mOptionButtonClickHandler = callback;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      override public function get width() : Number
      {
         return ITEM_WIDTH;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(data != null)
         {
            this.myName.setData(data.name,data.id);
            this.myOnlineState.onlineStatus = data.friendStatus;
            this.myOptionBtn.setData(data);
            this.myOptionBtn.setShowHamburgerButtonClickedHandler(mOptionButtonClickHandler);
            this.myPlayerPrivileges.showPlayerPrivileges(data.qqMembershipBits,data.netCafePrivileges);
            WarGodUtility.setWargodTierIcon(this,data);
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myBackground.gotoAndStop(2);
         this.myOnlineState.switchFocusState(true);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myBackground.gotoAndStop(1);
         this.myOnlineState.switchFocusState(false);
      }
   }
}

