package fsg.shared.widgets
{
   import codo.constants.ComponentCSS;
   import codo.constants.SE_ID;
   import codo.interfaces.IDisposable;
   import components.Input;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgAudioUtil;
   import scaleform.gfx.TextFieldEx;
   
   public class FsgSharedInputField extends Input implements IDisposable
   {
      
      protected static const TEXT_COLOR_FOCUS_OUT:uint = 10066329;
      
      public var myLabelTF:TextField;
      
      public var myInputFieldOutline:Sprite;
      
      public var myInputFieldTextBkg:Sprite;
      
      public var myInputFieldBkg:Sprite;
      
      public function FsgSharedInputField()
      {
         super();
         this.myLabelTF.autoSize = TextFieldAutoSize.LEFT;
         TextFieldEx.setVerticalAlign(this.myLabelTF,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(myIptTF,TextFieldEx.VALIGN_CENTER);
      }
      
      public function set label(txt:String) : void
      {
         this.myLabelTF.text = txt;
      }
      
      public function get inputTextField() : TextField
      {
         return myIptTF;
      }
      
      public function get inputText() : String
      {
         return myIptTF.text;
      }
      
      public function set inputText(txt:String) : void
      {
         myIptTF.text = txt;
      }
      
      public function forceFocus() : void
      {
         this.onIptFocusInHandle();
      }
      
      override protected function onIptFocusInHandle(cEvt:FocusEvent = null) : void
      {
         myIptTF.textColor = ComponentCSS.FSG_COLOR_BLUE;
         if(cEvt != null)
         {
            FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ROLLOVER);
         }
      }
      
      override protected function onIptFocusOutHandle(cEvt:FocusEvent) : void
      {
         myIptTF.textColor = TEXT_COLOR_FOCUS_OUT;
      }
      
      public function setSize(w:int = -1, h:int = -1) : void
      {
         var FIELD_PADDING:uint = 0;
         var RIGHT_FIELD_MARGIN:uint = 0;
         if(w > -1)
         {
            FIELD_PADDING = 28;
            RIGHT_FIELD_MARGIN = 4;
            this.myInputFieldOutline.width = w;
            this.myInputFieldBkg.scaleX = this.myInputFieldOutline.scaleX;
            this.myInputFieldTextBkg.width = myIptTF.width = this.myInputFieldBkg.width - (this.myLabelTF.textWidth + FIELD_PADDING);
            this.myInputFieldTextBkg.x = myIptTF.x = this.myInputFieldBkg.x + this.myInputFieldBkg.width - (this.myInputFieldTextBkg.width + RIGHT_FIELD_MARGIN);
         }
      }
      
      public function dispose() : void
      {
         FsgAudioUtil.getInstance().removeAudio(myIptTF);
      }
   }
}

