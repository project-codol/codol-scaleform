package codo.component.social
{
   import codo.component.Button;
   import codo.component.PlayerName;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.Common;
   import codo.localization.DictClan;
   import codo.objects.PlayerNameSettings;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class ClanFriendItem extends UIInteractiveComponent
   {
      
      public static const DETAIL_BTN_INDEX:int = 0;
      
      public static const INVITE_BTN_INDEX:int = 1;
      
      private static const HEIGHT:Number = 30;
      
      public var myName:PlayerName;
      
      public var myState:MovieClip;
      
      public var myBg:MovieClip;
      
      public var myDetailBtn:Button;
      
      public var myInviteBtn:Button;
      
      protected var mHandler:Function;
      
      public function ClanFriendItem()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myDetailBtn.width = ClanGuide.ITEM_BTN_WIDTH;
         this.myDetailBtn.height = ClanGuide.ITEM_BTN_HEIGHT;
         this.myInviteBtn.width = ClanGuide.ITEM_BTN_WIDTH;
         this.myInviteBtn.height = ClanGuide.ITEM_BTN_HEIGHT;
         this.myDetailBtn.label = DictClan.BUTTON_DETAIL_LABEL;
         this.myInviteBtn.label = DictClan.BUTTON_INVITE_LABEL;
         this.myState.myStateLabel.textStyle = ClanGuide.styleItemRenderBoldText;
         this.myState.myStateLabel.width = 85;
         var nameSetting:PlayerNameSettings = new PlayerNameSettings();
         nameSetting.mode = PlayerNameSettings.MODE_DIRECT;
         nameSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         nameSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_EXTEND;
         nameSetting.textColor = GlobalGuide.GRAY_80;
         nameSetting.textHeight = 22;
         nameSetting.textWidth = 270;
         this.myName.settings = nameSetting;
         this.myInviteBtn.x = this.myBg.width - 20 - this.myInviteBtn.width;
         this.myInviteBtn.y = ClanGuide.ITEM_BTN_Y_PADDING;
         this.myDetailBtn.x = this.myInviteBtn.x - GlobalGuide.COMPONENT_PADDING - this.myDetailBtn.width;
         this.myDetailBtn.y = ClanGuide.ITEM_BTN_Y_PADDING;
         this.myDetailBtn.registerClickEvent(this.onOptionBtnClicked,this.myDetailBtn);
         this.myInviteBtn.registerClickEvent(this.onOptionBtnClicked,this.myInviteBtn);
         this.myName.myTextField.fontColor = GlobalGuide.GRAY_80;
      }
      
      private function onOptionBtnClicked(btn:Button) : void
      {
         var btnIndex:int = 0;
         if(btn == this.myDetailBtn)
         {
            btnIndex = DETAIL_BTN_INDEX;
         }
         else if(btn == this.myInviteBtn)
         {
            btnIndex = INVITE_BTN_INDEX;
         }
         if(null != this.mHandler)
         {
            this.mHandler(mData,btnIndex);
         }
      }
      
      override public function get height() : Number
      {
         return HEIGHT;
      }
      
      override public function setData(value:*) : void
      {
         super.setData(value);
         if(null == value)
         {
            visible = false;
            return;
         }
         this.myName.setData(value.name,value.id);
         this.setStateFlag(value.friendStatus);
         visible = true;
      }
      
      public function setStateFlag(onlineState:int) : void
      {
         var frame:int = 1;
         switch(onlineState)
         {
            case Common.CODO_BASIC_PRESENCE_GAME:
               frame = 2;
               this.myState.myStateLabel.text = "@SF_UI_USER_STATUS_INGAME";
               this.myState.myStateLabel.fontColor = ClanGuide.INGAME_COLOR;
               break;
            case Common.CODO_BASIC_PRESENCE_OFFLINE:
               frame = 3;
               this.myState.myStateLabel.text = "@SF_UI_USER_OFFLINE";
               this.myState.myStateLabel.fontColor = ClanGuide.OFFLINE_COLOR;
               break;
            case Common.CODO_BASIC_PRESENCE_MENU:
            default:
               frame = 1;
               this.myState.myStateLabel.text = "@SF_UI_USER_ONLINE";
               this.myState.myStateLabel.fontColor = ClanGuide.ONLINE_COLOR;
         }
         this.myState.myStateFlag.gotoAndStop(frame);
      }
      
      public function set buttonClickHandler(handler:Function) : void
      {
         this.mHandler = handler;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myName.myTextField.fontColor = GlobalGuide.WHITE;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myName.myTextField.fontColor = GlobalGuide.GRAY_80;
      }
   }
}

