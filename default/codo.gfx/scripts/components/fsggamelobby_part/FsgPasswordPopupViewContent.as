package components.fsggamelobby_part
{
   import codo.constants.BCEvent;
   import codo.localization.DictRoom;
   import codo.localization.DictSystem;
   import codo.utils.CursorUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import fsg.shared.popups.PopupContentBase;
   import fsg.shared.widgets.FsgSharedInputField;
   import scaleform.gfx.TextFieldEx;
   
   public class FsgPasswordPopupViewContent extends PopupContentBase
   {
      
      private static const LIMIT_PASSWORD:uint = 16;
      
      public var myNotifyTF:TextField;
      
      public var myInputBox:FsgSharedInputField;
      
      private var mInputTF:TextField;
      
      private var mBaseMsg:String;
      
      private var mKeysDown:Object = new Object();
      
      public function FsgPasswordPopupViewContent()
      {
         super();
      }
      
      public function resetFocus() : void
      {
         this.myInputBox.focusIn();
         this.myInputBox.forceFocus();
      }
      
      override protected function configPopUpBase() : void
      {
         super.configPopUpBase();
         this.mBaseMsg = LocalizeUtil.replace(LocalizeUtil.localize(DictRoom.CREATE_ROOM_PASSWORD_LIMIT_DESC),[LIMIT_PASSWORD]);
         this.mInputTF = this.myInputBox.inputTextField;
         this.setBaseNotifyMsg();
         this.myNotifyTF.width = contentInnerWidth - CONTENT_PADDING;
         this.myInputBox.label = DictRoom.CREATE_ROOM_PASSWORD;
         this.myInputBox.y = this.myNotifyTF.y + this.myNotifyTF.textHeight + CONTENT_PADDING;
         this.mInputTF.displayAsPassword = true;
         TextFieldEx.setIMEEnabled(this.myInputBox.inputTextField,false);
         myPopupBase.headerText = DictRoom.CREATE_ROOM_PASSWORD;
         myPopupBase.subheaderText = LocalizeUtil.localize(DictRoom.INPUT_ROOM_PASSWORD).toUpperCase();
         myPopupBase.animateFrame = true;
         this.mInputTF.addEventListener(Event.CHANGE,this.onInputChangedHandle);
         this.mInputTF.addEventListener(FocusEvent.FOCUS_IN,this.onInputFocusInHandle);
         this.mInputTF.addEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOutHandle);
         this.mInputTF.addEventListener(MouseEvent.MOUSE_OVER,this.onInputMouseOver);
         this.mInputTF.addEventListener(MouseEvent.MOUSE_OUT,this.onInputMouseOut);
         myPopupBase.configCancelButton(DictSystem.CANCEL,this.onCancelClickHandle);
         myPopupBase.configConfirmButton(DictSystem.CONFIRM,this.onConfirmClickHandle);
         myPopupBase.animateFrame = true;
         this.resetFocus();
      }
      
      private function trySend() : void
      {
         if(this.mInputTF.text.length > 0)
         {
            this.broadcast(BCEvent.EVT_CONFIRM_ENTER_JOIN_ROOM_PASSWORD,this.mInputTF.text);
            this.mInputTF.text = "";
         }
         else
         {
            this.resetFocus();
            this.myNotifyTF.htmlText = LOCALIZE(DictRoom.NOTE_EMPTY_ROOM_PASSWORD);
            this.myNotifyTF.textColor = 16711680;
         }
      }
      
      private function onConfirmClickHandle() : void
      {
         this.trySend();
      }
      
      private function onCancelClickHandle() : void
      {
         this.broadcast(BCEvent.EVT_CANCEL_ENTER_JOIN_ROOM_PASSWORD);
      }
      
      private function setBaseNotifyMsg() : void
      {
         this.myNotifyTF.htmlText = this.mBaseMsg;
         this.myNotifyTF.textColor = 16777215;
      }
      
      private function onInputChangedHandle(cEvt:Event) : void
      {
         this.setBaseNotifyMsg();
         if(this.mInputTF.text.length > 0)
         {
            this.mInputTF.text = StringUtil.limitStringToRealLength(this.mInputTF.text,LIMIT_PASSWORD);
         }
      }
      
      public function onInputMouseOver(evt:MouseEvent) : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      public function onInputMouseOut(evt:MouseEvent) : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onInputFocusInHandle(cEvt:FocusEvent) : void
      {
         this.mInputTF.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
         this.mInputTF.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
      }
      
      private function onInputFocusOutHandle(cEvt:FocusEvent) : void
      {
         this.mInputTF.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
         this.mInputTF.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
      }
      
      private function onKeyDownHandle(cEvt:KeyboardEvent) : void
      {
         if(this.isDown(cEvt.keyCode) == false)
         {
            switch(cEvt.keyCode)
            {
               case Keyboard.ENTER:
               case Keyboard.NUMPAD_ENTER:
                  if(this.stage != null && this.stage.focus == this.mInputTF)
                  {
                     this.stage.focus = null;
                     this.trySend();
                  }
            }
         }
         this.mKeysDown[cEvt.keyCode] = true;
      }
      
      private function onKeyUpHandle(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode in this.mKeysDown)
         {
            delete this.mKeysDown[cEvt.keyCode];
         }
      }
      
      private function isDown(keyCode:uint) : Boolean
      {
         return Boolean(keyCode in this.mKeysDown);
      }
      
      override protected function get viewWidth() : uint
      {
         return 580;
      }
      
      override protected function get viewHeight() : uint
      {
         return 220;
      }
   }
}

