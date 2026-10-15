package components.fsgquestionnaire_part
{
   import flash.display.MovieClip;
   
   public class FsgQuestionTextInput extends MovieClip
   {
      
      public static var STATE_INACTIVE:uint = 1;
      
      public static var STATE_ACTIVE:uint = 3;
      
      public static var STATE_TYPING:uint = 2;
      
      public var myTextInput:MovieClip;
      
      public var myBG:MovieClip;
      
      public function FsgQuestionTextInput()
      {
         super();
         this.myTextInput.myTextTF.text = "";
      }
      
      public function set available(bAvailable:Boolean) : void
      {
         this.gotoAndStop(bAvailable ? 1 : 3);
         this.myBG.gotoAndStop(bAvailable ? 1 : 3);
         this.myTextInput.visible = bAvailable;
      }
      
      public function set state(uState:uint) : void
      {
         this.gotoAndStop(uState);
         this.myBG.gotoAndStop(uState);
         this.myTextInput.visible = uState != STATE_INACTIVE;
      }
      
      public function get text() : String
      {
         return this.myTextInput.myTextTF.text;
      }
      
      public function set text(sText:String) : void
      {
         this.myTextInput.myTextTF.text = sText;
      }
   }
}

