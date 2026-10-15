package codo.views.party_parts
{
   import codo.component.CheckBox;
   import codo.component.PlayerName;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.playerAccount.PlayerAccountInfoPrivileges;
   import codo.component.social.OnlineStatusWidget;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.objects.PlayerNameSettings;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class FriendItemForParty extends UIInteractiveComponent
   {
      
      public var myOnlineState:OnlineStatusWidget;
      
      public var myPlayerName:PlayerName;
      
      public var myBackground:MovieClip;
      
      public var myPlayerPrivileges:PlayerAccountInfoPrivileges;
      
      public var myCheckBox:CheckBox;
      
      protected var mHandler:Function;
      
      public function FriendItemForParty()
      {
         super();
         var nameSetting:PlayerNameSettings = new PlayerNameSettings();
         nameSetting.mode = PlayerNameSettings.MODE_DIRECT;
         nameSetting.fontSize = 18;
         nameSetting.textColor = GlobalGuide.WHITE;
         nameSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT;
         nameSetting.textWidth = 300;
         nameSetting.textHeight = 25;
         this.myPlayerName.settings = nameSetting;
         this.myCheckBox.label = "";
      }
      
      override public function setData(data:*) : void
      {
         if(null == data)
         {
            return;
         }
         super.setData(data);
         this.myPlayerName.setData(data.name,data.id);
         this.myOnlineState.onlineStatus = data.friendStatus;
         this.myPlayerPrivileges.showPlayerPrivileges(data.qqMembershipBits,data.netCafePrivileges);
         this.myCheckBox.removeCheckedCallback(this.onCheckBoxChecked);
         this.myCheckBox.removeUncheckedCallback(this.onCheckBoxUnchecked);
         if(Boolean(DataManager.getInstance().getDP(DataID.IS_SELECTED_PARTY_PLAYER,[data])))
         {
            this.selectCheckBox(true);
         }
         else
         {
            this.selectCheckBox(false);
         }
         this.myCheckBox.addCheckedCallback(this.onCheckBoxChecked);
         this.myCheckBox.addUncheckedCallback(this.onCheckBoxUnchecked);
      }
      
      private function onCheckBoxChecked() : void
      {
         if(null != this.mHandler)
         {
            this.mHandler(mData,true);
         }
      }
      
      private function onCheckBoxUnchecked() : void
      {
         if(null != this.mHandler)
         {
            this.mHandler(mData,false);
         }
      }
      
      public function set friendSelectionChanged(handler:Function) : void
      {
         this.mHandler = handler;
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      public function enableCheckBox(isEnabled:Boolean) : void
      {
         if(this.myCheckBox.checked && !isEnabled)
         {
            isEnabled = true;
         }
         this.myCheckBox.enabled = isEnabled;
         this.myCheckBox.alpha = isEnabled ? 1 : 0.5;
      }
      
      public function selectCheckBox(isSelected:Boolean) : void
      {
         this.myCheckBox.checked = isSelected;
         if(isSelected)
         {
            this.enableCheckBox(true);
         }
      }
   }
}

