package components.chatting_part
{
   import codo.event.ParaEvent;
   import codo.objects.ChatMessageObj;
   import components.Input;
   import components.TextArea;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shaui.component.core.InteractiveComponent;
   
   public class ChatModule extends InteractiveComponent
   {
      
      public static const INPUT_CHANGED:String = "inputchanged";
      
      public static const SEND_MESSGAE:String = "sendmessage";
      
      public static const UNREAD_MESSAGE:String = "unreadmessage";
      
      public static const READ_MESSAGE:String = "readmessage";
      
      private static const STRING_LEN_MAX:uint = 64;
      
      public var myInput:Input;
      
      public var myTextArea:TextArea;
      
      public var mySendBtn:MovieClip;
      
      private var _isShow:Boolean = false;
      
      public function ChatModule()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myTextArea.text = "";
         this.myInput.text = "";
         this.myInput.lengthLimit = STRING_LEN_MAX;
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         this.myTextArea.addEventListener(Event.SCROLL,this.onChatScroll);
         this.myInput.addEventListener(Input.EVT_CHANGE,this.onInputTFChangedHandle);
         this.myInput.addEventListener(Input.EVT_PRESS_ENTER,this.onEnterHandle);
         this.mySendBtn.addEventListener(MouseEvent.CLICK,this.onSendBtnClicked);
      }
      
      public function set isShow(value:Boolean) : void
      {
         if(this._isShow != value)
         {
            this._isShow = value;
            if(this._isShow && this.myTextArea.isAtBottom())
            {
               this.dispatchEvent(new ParaEvent(READ_MESSAGE));
            }
         }
      }
      
      private function onSendBtnClicked(cEvt:Event) : void
      {
         this.sendMsg();
      }
      
      private function onInputTFChangedHandle(cEvt:Event) : void
      {
         this.dispatchEvent(new ParaEvent(INPUT_CHANGED,this.myInput.text));
      }
      
      private function onChatScroll(cEvt:Event) : void
      {
         if(this._isShow && this.myTextArea.isAtBottom())
         {
            this.dispatchEvent(new ParaEvent(READ_MESSAGE));
         }
      }
      
      private function onEnterHandle(cEvt:ParaEvent) : void
      {
         this.sendMsg();
      }
      
      private function sendMsg() : void
      {
         this.dispatchEvent(new ParaEvent(SEND_MESSGAE,this.myInput.text));
         this.myTextArea.gotoBottom();
         this.myInput.text = "";
      }
      
      public function newMsg(msgObj:ChatMessageObj) : void
      {
         this.myTextArea.appendMode = this.myTextArea.isAtBottom() ? TextArea.ALWAYS_BOTTOM : TextArea.ALWAYS_CURRENT_LINE;
         this.myTextArea.appendHtmlText(msgObj.message);
         if(!this.myTextArea.isAtBottom() || this._isShow == false)
         {
            if(msgObj.isNew)
            {
               this.dispatchEvent(new ParaEvent(UNREAD_MESSAGE,{"msgObj":msgObj}));
            }
         }
      }
      
      public function setHtmlText(str:String) : void
      {
         this.myTextArea.htmlText = str;
         this.myTextArea.gotoBottom();
      }
      
      public function focusIn(value:Boolean) : void
      {
         this.myInput.focusIn(value);
      }
      
      public function focusOut() : void
      {
         this.myInput.focusOut();
      }
      
      public function setInputBox(str:String) : void
      {
         this.myInput.text = str;
      }
   }
}

