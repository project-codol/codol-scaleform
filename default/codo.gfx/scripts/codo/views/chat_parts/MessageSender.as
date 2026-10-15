package codo.views.chat_parts
{
   import codo.component.Button;
   import codo.component.social.InputBox;
   import codo.localization.DictChatting;
   import codo.objects.InputBoxSettings;
   import codo.style.GlobalGuide;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   
   public class MessageSender extends MovieClip
   {
      
      public static var sGlobalMessageLen:int;
      
      private static const INPUT_WIDTH:int = 695;
      
      private static const INPUT_HEIGHT:int = 30;
      
      private static const SEND_BTN_WIDTH:int = 159;
      
      private static const MESSAGE_GAP:int = 5;
      
      public var myInputBox:InputBox;
      
      public var mySendBtn:Button;
      
      private var mPostMessageHandler:Function;
      
      public function MessageSender()
      {
         var inputSetting:InputBoxSettings = null;
         super();
         inputSetting = new InputBoxSettings();
         inputSetting.width = INPUT_WIDTH - SEND_BTN_WIDTH;
         inputSetting.height = INPUT_HEIGHT;
         inputSetting.showSearchIcon = false;
         inputSetting.showClearButton = false;
         inputSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         inputSetting.highlightAsDefault = true;
         inputSetting.textValidator = this.textCounter;
         inputSetting.keyEnterHandler = this.onSendMessageFromKeyBoard;
         inputSetting.hasBg = false;
         this.myInputBox.settings = inputSetting;
         this.myInputBox.x = 2 + MESSAGE_GAP;
         this.myInputBox.y = -2;
         this.mySendBtn.x = 2 + this.myInputBox.x + this.myInputBox.width;
         this.mySendBtn.y = -3;
         this.mySendBtn.width = SEND_BTN_WIDTH;
         this.mySendBtn.height = INPUT_HEIGHT;
         this.mySendBtn.label = DictChatting.SEND_MESSAGE;
         this.mySendBtn.registerClickEvent(this.onSendMessageFromButton);
      }
      
      public function registerPostMessageHandler(handler:Function) : void
      {
         this.mPostMessageHandler = handler;
      }
      
      private function onSendMessageFromKeyBoard() : void
      {
         this.onSendMessage(false);
      }
      
      private function onSendMessageFromButton() : void
      {
         this.onSendMessage(true);
      }
      
      private function onSendMessage(fromButton:Boolean) : void
      {
         var text:String = this.myInputBox.text;
         text = StringUtil.trim(text);
         if(null != this.mPostMessageHandler)
         {
            this.mPostMessageHandler(text,fromButton);
         }
         this.myInputBox.text = "";
      }
      
      public function focusInput() : void
      {
         this.myInputBox.catchFocus();
      }
      
      public function unfocusInput() : void
      {
         this.myInputBox.releaseFocus();
      }
      
      private function textCounter(text:String) : Boolean
      {
         var textCount:int = text.length;
         var normalMessageLen:int = sGlobalMessageLen;
         return textCount <= normalMessageLen;
      }
   }
}

