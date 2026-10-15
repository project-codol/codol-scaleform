package components.chatting_part
{
   public class HudChatModule extends ChatModule
   {
      
      public static const PLAY_MODE:int = 0;
      
      public static const SHOW_MODE:int = 1;
      
      public static const INPUT_MODE:int = 2;
      
      private var _mode:int = 0;
      
      private var _str:String = "";
      
      public function HudChatModule()
      {
         super();
      }
      
      public function setMode(mode:int) : void
      {
         this._mode = mode;
         if(mode == PLAY_MODE)
         {
            this.visible = false;
            this.focusOut();
         }
         else if(mode == SHOW_MODE)
         {
            this.visible = true;
            this.myInput.visible = false;
            this._str = this.myInput.text;
            this.mySendBtn.visible = false;
            this.myTextArea.myScrollBar.alpha = 0;
            this.focusOut();
         }
         else if(mode == INPUT_MODE)
         {
            this.visible = true;
            this.myInput.visible = true;
            this.mySendBtn.visible = true;
            this.myTextArea.myScrollBar.alpha = 1;
            this.focusIn(true);
            this.myInput.text = this._str;
         }
      }
      
      public function getMode() : int
      {
         return this._mode;
      }
   }
}

