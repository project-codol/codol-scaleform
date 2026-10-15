package codo.views.hudSpy
{
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class VoiceSpeaker extends MovieClip
   {
      
      private static const NAME_TEXT_FIELD_WIDTH:int = 100;
      
      public var myName:TextField;
      
      public var myNickname:PlayerNickname;
      
      public var mySignal:MovieClip;
      
      private var myPlayerName:String;
      
      private var myPlayerNickname:String;
      
      public function VoiceSpeaker()
      {
         super();
         this.playerName = "";
         this.playerNickname = "A";
         this.mySignal.stop();
      }
      
      public function set playerName(name:String) : void
      {
         this.myName.text = name;
         StringUtil.fitTextFieldByLength(this.myName,NAME_TEXT_FIELD_WIDTH);
         this.myPlayerName = this.myName.text;
      }
      
      public function get playerName() : String
      {
         return this.myPlayerName;
      }
      
      public function set playerNickname(name:String) : void
      {
         this.myPlayerNickname = name;
         this.myNickname.nickname = this.myPlayerNickname;
      }
      
      public function startAnimation(frame:int = 1) : void
      {
         this.mySignal.gotoAndPlay(frame);
      }
      
      public function stopAnimation() : void
      {
         this.mySignal.stop();
      }
   }
}

