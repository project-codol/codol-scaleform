package codo.views.friend_parts
{
   import codo.component.Button;
   import codo.component.PlayerName;
   import codo.component.social.PageListBaseRender;
   import codo.component.social.PlayerActionButton;
   import codo.localization.Dict;
   import codo.localization.DictClan;
   import codo.objects.PlayerNameSettings;
   import codo.objects.QQUser;
   import codo.style.GlobalGuide;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   
   public class QQMemberSelector extends PageListBaseRender
   {
      
      private static const LOCATION_TYPE_NULL:int = 0;
      
      private static const LOCATION_TYPE_NETCAFE:int = 1;
      
      private static const LOCATION_TYPE_SAME_CITY:int = 2;
      
      public var myWargodTier:MovieClip;
      
      public var myName:PlayerName;
      
      public var myLocation:MovieClip;
      
      public var myActionButton:Button;
      
      public var myPlayerActionButton:PlayerActionButton;
      
      private var mQQUser:QQUser;
      
      public function QQMemberSelector()
      {
         super();
         isInteractiveEnabled = true;
         myBg.alpha = 1;
         this.myWargodTier.x = 5;
         var nameSetting:PlayerNameSettings = new PlayerNameSettings();
         nameSetting.mode = PlayerNameSettings.MODE_DIRECT;
         nameSetting.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         nameSetting.textWidth = 250;
         nameSetting.textHeight = 25;
         nameSetting.textColor = GlobalGuide.WHITE;
         nameSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_EXTEND;
         this.myName.settings = nameSetting;
         this.myName.x = this.myWargodTier.x + this.myWargodTier.width + 5;
         this.myActionButton.label = Dict.RECOMMEND_CODOL;
         this.myActionButton.width = 90;
         this.myActionButton.height = 31;
         this.myActionButton.x = myBg.width - this.myActionButton.width - 2;
         this.myActionButton.y = (myBg.height - this.myActionButton.height) / 2;
      }
      
      override public function setData(data:*) : void
      {
         var isQQFriend:Boolean = false;
         var nameForDisplay:String = null;
         super.setData(data);
         this.mQQUser = data as QQUser;
         if(this.mQQUser != null)
         {
            isQQFriend = this.mQQUser.userID == "0";
            nameForDisplay = this.mQQUser.qqName;
            if(isQQFriend)
            {
               nameForDisplay = this.mQQUser.qqName + " (QQ: " + this.mQQUser.qqNumber + ")";
               this.myName.setData(nameForDisplay,this.mQQUser.userID);
               this.myWargodTier.visible = false;
               this.myActionButton.label = Dict.RECOMMEND_CODOL;
               this.myActionButton.visible = true;
               this.myPlayerActionButton.visible = false;
               this.myLocation.x = this.myActionButton.x - this.myLocation.width - 20;
            }
            else
            {
               this.myName.setData(this.mQQUser.userName,this.mQQUser.userID);
               WarGodUtility.setWargodTierIcon(this,this.mQQUser);
               this.myActionButton.label = DictClan.BUTTON_DETAIL_LABEL;
               this.myPlayerActionButton.setNameAndID(this.mQQUser.userName,this.mQQUser.userID);
               this.myActionButton.visible = false;
               this.myPlayerActionButton.visible = true;
               this.myLocation.x = this.myPlayerActionButton.x - this.myLocation.width - 20;
            }
            this.setLocation(this.mQQUser.location);
            this.myActionButton.registerClickEvent(this.onActionButtonClicked);
         }
      }
      
      private function setLocation(location:int) : void
      {
         this.myLocation.visible = location != LOCATION_TYPE_NULL;
         this.myLocation.gotoAndStop(location == LOCATION_TYPE_NETCAFE ? 2 : 1);
      }
      
      override public function get width() : Number
      {
         return myBg.width;
      }
      
      override public function get height() : Number
      {
         return myBg.height;
      }
      
      override protected function onMouseOver() : void
      {
         myBg.gotoAndStop(2);
      }
      
      override protected function onMouseOut() : void
      {
         myBg.gotoAndStop(1);
      }
      
      private function onActionButtonClicked() : void
      {
         if(null != mHandler)
         {
            mHandler(this.mQQUser,0);
         }
      }
   }
}

