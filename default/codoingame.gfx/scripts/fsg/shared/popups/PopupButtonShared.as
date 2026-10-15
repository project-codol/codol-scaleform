package fsg.shared.popups
{
   import codo.utils.CursorUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import scaleform.gfx.TextFieldEx;
   
   public class PopupButtonShared extends Sprite
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DISABLED_STATE_FRAME:int = 2;
      
      private static const BKG_DISABLED_STATE_FRAME:int = 3;
      
      private static const INACTIVE_STATE_ALPHA:Number = 0.5;
      
      public var myFrame:MovieClip;
      
      public var myBackground:MovieClip;
      
      public var myLines:Sprite;
      
      public var myBackgroundBlinking:Sprite;
      
      public var myReflection:Sprite;
      
      public var myButtonTF:TextField;
      
      private var mClickCallback:Function;
      
      private var mTxtFormatColor:int;
      
      private var m_Clickable:BehaviourClickable;
      
      private var m_Audio:BehaviourAudio;
      
      private var MOUSE_HIGHLIGHT_OFF:int = 0;
      
      private var MOUSE_HIGHLIGHT_ON:int = 1;
      
      private var m_highlightState:int = this.MOUSE_HIGHLIGHT_OFF;
      
      public function PopupButtonShared()
      {
         super();
         mouseChildren = false;
         this.m_Clickable = new BehaviourClickable(this);
         this.m_Clickable.addClickCallback(this.onMouseClick);
         this.m_Clickable.addMouseOutCallback(this.onMouseOut);
         this.m_Clickable.addMouseOverCallback(this.onMouseOver);
         this.m_Clickable.setEnableMouseHighlight(false);
         this.m_Audio = new BehaviourAudio(this.m_Clickable);
         this.myButtonTF.autoSize = TextFieldAutoSize.LEFT;
         this.mTxtFormatColor = this.myButtonTF.getTextFormat().color as int;
         this.m_highlightState = this.MOUSE_HIGHLIGHT_OFF;
      }
      
      public function get behaviorAudio() : BehaviourAudio
      {
         return this.m_Audio;
      }
      
      private function onMouseOver() : void
      {
         this.myButtonTF.textColor = 0;
         this.myBackground.gotoAndStop(OVER_STATE_FRAME);
         if(this.m_highlightState == this.MOUSE_HIGHLIGHT_OFF)
         {
            CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
            this.m_highlightState = this.MOUSE_HIGHLIGHT_ON;
         }
      }
      
      private function onMouseOut() : void
      {
         this.myBackground.gotoAndStop(UP_STATE_FRAME);
         this.myButtonTF.textColor = this.mTxtFormatColor;
         if(this.m_highlightState == this.MOUSE_HIGHLIGHT_ON)
         {
            CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
            this.m_highlightState = this.MOUSE_HIGHLIGHT_OFF;
         }
      }
      
      private function onMouseClick() : void
      {
         this.myButtonTF.textColor = 0;
         this.myFrame.gotoAndStop(UP_STATE_FRAME);
         if(this.m_highlightState == this.MOUSE_HIGHLIGHT_ON)
         {
            CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
            this.m_highlightState = this.MOUSE_HIGHLIGHT_OFF;
         }
      }
      
      public function setEnabled(cEnable:Boolean) : void
      {
         this.alpha = 1;
         this.m_Clickable.setEnabled(cEnable);
         this.myFrame.gotoAndStop(cEnable ? UP_STATE_FRAME : DISABLED_STATE_FRAME);
         this.myButtonTF.alpha = cEnable ? 1 : INACTIVE_STATE_ALPHA;
         this.myButtonTF.textColor = cEnable ? uint(this.mTxtFormatColor) : 16777215;
         if(this.myBackgroundBlinking != null)
         {
            this.myBackgroundBlinking.visible = cEnable;
         }
         this.myBackground.gotoAndStop(cEnable ? UP_STATE_FRAME : BKG_DISABLED_STATE_FRAME);
      }
      
      public function getEnabled() : Boolean
      {
         return this.m_Clickable.isEnabled();
      }
      
      public function setViewStateIsClickable(isClickable:Boolean) : void
      {
      }
      
      public function set clickCallback(callback:Function) : void
      {
         if(this.mClickCallback != null)
         {
            this.clearClickEvent();
         }
         this.mClickCallback = callback;
         this.m_Clickable.addClickCallback(this.mClickCallback);
      }
      
      public function clearClickEvent() : void
      {
         this.m_Clickable.removeClickCallback(this.mClickCallback);
         this.mClickCallback = null;
      }
      
      public function setText(str:String) : void
      {
         str = LocalizeUtil.localize(str).toUpperCase();
         TextFieldEx.setVerticalAlign(this.myButtonTF,TextFieldEx.VALIGN_CENTER);
         this.myButtonTF.htmlText = str;
         this.myButtonTF.y = (this.myBackground.height - this.myButtonTF.textHeight) * 0.5;
         this.setTextXPos();
      }
      
      public function setButtonToTextWidth(w:uint) : void
      {
         this.myFrame.width = w + 1;
         this.myReflection.width = this.myBackground.width = w;
         this.myLines.width = w - 1;
         if(this.myBackgroundBlinking != null)
         {
            this.myBackgroundBlinking.width = w + 3;
         }
         this.setTextXPos();
      }
      
      private function setTextXPos() : void
      {
         this.myButtonTF.x = (this.myBackground.width - this.myButtonTF.textWidth) * 0.5;
      }
      
      public function get txtField() : TextField
      {
         return this.myButtonTF;
      }
   }
}

