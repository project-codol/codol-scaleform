package codo.component.lobby
{
   import codo.component.TextField;
   import codo.localization.DictRoom;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class LobbyCountdownTimer extends MovieClip
   {
      
      private static const BG_NORMAL_FRAME:int = 1;
      
      private static const BG_TIME_ALMOST_EXPIRED_FRAME:int = 2;
      
      public var myTextField:TextField;
      
      public var myCountdownTimerText:TextField;
      
      private var m_Time:Number = 0;
      
      public function LobbyCountdownTimer()
      {
         super();
         this.myTextField.text = DictRoom.LOBBY_COUNTDOWN_TIME_HEADER;
         this.myTextField.alignment = TextFormatAlign.CENTER;
         this.myTextField.autoSize = TextFieldAutoSize.CENTER;
         this.myCountdownTimerText.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myCountdownTimerText.fontSize = 60;
         this.myCountdownTimerText.alignment = TextFormatAlign.CENTER;
         this.myCountdownTimerText.autoSize = TextFieldAutoSize.CENTER;
      }
      
      public function getTime() : Number
      {
         return this.m_Time;
      }
      
      public function setTime(time:Number, almostExpired:Boolean) : void
      {
         this.myCountdownTimerText.text = time.toString();
         if(almostExpired)
         {
            gotoAndStop(BG_TIME_ALMOST_EXPIRED_FRAME);
         }
         else
         {
            gotoAndStop(BG_NORMAL_FRAME);
         }
         this.m_Time = time;
      }
   }
}

