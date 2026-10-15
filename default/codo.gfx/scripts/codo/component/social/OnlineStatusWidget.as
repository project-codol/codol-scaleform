package codo.component.social
{
   import codo.component.TextField;
   import codo.constants.Common;
   import codo.localization.Dict;
   import codo.style.FriendGuide;
   import flash.display.MovieClip;
   
   public class OnlineStatusWidget extends MovieClip
   {
      
      private static const FRAME_ONLINE:int = 1;
      
      private static const FRAME_INGAME:int = 2;
      
      private static const FRAME_OFFLINE:int = 3;
      
      public var myOnlineDot:MovieClip;
      
      public var myLabel:TextField;
      
      public var myBg:MovieClip;
      
      public function OnlineStatusWidget()
      {
         super();
         this.myLabel.textStyle = FriendGuide.styleStatusLabel;
      }
      
      public function set onlineStatus(status:int) : void
      {
         if(status == Common.CODO_BASIC_PRESENCE_MENU || status == Common.CODO_BASIC_PRESENCE_ROOM || status == Common.CODO_BASIC_PRESENCE_PARTY)
         {
            this.myLabel.text = Dict.USER_ONLINE;
            this.myOnlineDot.gotoAndStop(FRAME_ONLINE);
         }
         else if(status == Common.CODO_BASIC_PRESENCE_GAME)
         {
            this.myLabel.text = Dict.USER_STATUS_INGAME;
            this.myOnlineDot.gotoAndStop(FRAME_INGAME);
         }
         else
         {
            this.myLabel.text = Dict.USER_OFFLINE;
            this.myOnlineDot.gotoAndStop(FRAME_OFFLINE);
         }
      }
      
      public function switchFocusState(isFocus:Boolean) : void
      {
         this.myBg.gotoAndStop(isFocus ? 2 : 1);
      }
   }
}

