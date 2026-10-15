package codo.component.matchselect
{
   import codo.component.ComboBox;
   import codo.component.InputTextField;
   import codo.component.TextField;
   import codo.localization.DictRoom;
   import codo.style.GlobalGuide;
   import codo.style.MatchSelectGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class MatchSelectCreateMatchOptions extends MovieClip
   {
      
      public static const LIMIT_PASSWORD:uint = 16;
      
      public static const DEFAULT_MAP_PLAYER_LIMIT:uint = 12;
      
      public static const TEXT_WIDTH:Number = 349;
      
      private static const WARNING_HEIGHT:Number = 50;
      
      private static const COMBOBOX_WIDTH:Number = 279;
      
      public var myRoomName:InputTextField;
      
      public var myRoomPassword:InputTextField;
      
      public var myRoomNameLabel:TextField;
      
      public var myRoomPasswordLabel:TextField;
      
      public var myPlayerLimit:ComboBox;
      
      public var mySecondaryCB:ComboBox;
      
      public var myPlayersLabel:TextField;
      
      public var myMaxPlayerWarning:TextField;
      
      public var myRoomSettingLabel:TextField;
      
      public function MatchSelectCreateMatchOptions()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myRoomSettingLabel.textStyle = MatchSelectGuide.styleRoomSettingLabel;
         this.myRoomSettingLabel.width = 279;
         this.myRoomSettingLabel.height = 25;
         this.myRoomSettingLabel.x = 18;
         this.myRoomSettingLabel.y = 0;
         this.myRoomSettingLabel.text = DictRoom.CREATE_ROOM_SETTINGS_LABEL;
         this.myRoomNameLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myRoomNameLabel.fontColor = GlobalGuide.WHITE;
         this.myRoomNameLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myPlayersLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myPlayersLabel.fontColor = GlobalGuide.WHITE;
         this.myPlayersLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myRoomPasswordLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myRoomPasswordLabel.fontColor = GlobalGuide.WHITE;
         this.myRoomPasswordLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myPlayersLabel.width = this.myRoomPasswordLabel.width = this.myRoomNameLabel.width = COMBOBOX_WIDTH;
         this.myPlayersLabel.text = LocalizeUtil.localize(DictRoom.CREATE_ROOM_PLAYERS_LABEL).toUpperCase();
         this.myRoomNameLabel.text = LocalizeUtil.localize(DictRoom.CREATE_ROOM_NAME).toUpperCase();
         this.myRoomPasswordLabel.text = LocalizeUtil.localize(DictRoom.CREATE_ROOM_PASSWORD).toUpperCase();
         this.myMaxPlayerWarning.htmlText = LocalizeUtil.localize(DictRoom.CREATE_ROOM_MAX_PLAYER_MAP_SUPPORT_WARNING);
         this.myMaxPlayerWarning.width = TEXT_WIDTH;
         this.myMaxPlayerWarning.height = WARNING_HEIGHT;
         this.myMaxPlayerWarning.fontSize = 15;
         this.myPlayerLimit.listWidth = 128;
         this.myPlayerLimit.width = COMBOBOX_WIDTH;
         this.myPlayerLimit.singleOptionMode = true;
         this.myPlayerLimit.allowScrolling = true;
         this.myPlayerLimit.scrollListHeight = 200;
         this.myRoomName.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myRoomPassword.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myRoomPassword.passwordMode = true;
         this.showHideMaxPlayerWarning(false);
      }
      
      public function getPlayerLimit() : int
      {
         return this.myPlayerLimit.selectedData.id;
      }
      
      public function getRoomName() : String
      {
         return this.myRoomName.text;
      }
      
      public function getRoomPassword() : String
      {
         return this.myRoomPassword.text;
      }
      
      public function getSecondaryCBIndex() : int
      {
         return this.mySecondaryCB.selectedData.id;
      }
      
      public function showHideMaxPlayerWarning(isShow:Boolean) : void
      {
         this.myMaxPlayerWarning.visible = isShow;
      }
   }
}

