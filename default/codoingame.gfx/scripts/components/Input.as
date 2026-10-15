package components
{
   import codo.constants.BCCommonEvent;
   import codo.constants.SE_ID;
   import codo.constants.TweenParam;
   import codo.event.ParaEvent;
   import codo.manager.EventManager;
   import codo.utils.CursorUtil;
   import codo.utils.StringUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import fsg.util.FsgAudioUtil;
   import scaleform.gfx.TextFieldEx;
   import shaui.component.core.InteractiveComponent;
   
   public class Input extends InteractiveComponent
   {
      
      public static var FOCUS_CHANGE_CB:Function;
      
      private static const TEXT_COLOR:Array = [16777215,15129031];
      
      public static const EVT_PRESS_ENTER:String = "evt_press_enter";
      
      public static const EVT_PRESS_CTRL_ENTER:String = "evt_press_ctrl_enter";
      
      public static const EVT_FOCUS_CHANGE:String = "evt_focus_change";
      
      public static const EVT_CHANGE:String = "evt_change";
      
      public static const EVT_REGEXP_RESULT:String = "evt_regexp_result";
      
      public static const EVT_KEY_DOWN:String = "evt_key_down";
      
      public static const EVT_KEY_UP:String = "evt_key_up";
      
      public var myBgNormal:MovieClip;
      
      public var myBgFocus:MovieClip;
      
      public var myIptTF:TextField;
      
      public var myTipTF:TextField;
      
      public var myCleanBtn:MovieClip;
      
      private var _iptLengthLimit:uint = 0;
      
      private var _lengthLimitIsCharacterCount:Boolean = false;
      
      private var _regexp:RegExp;
      
      private var _maxLines:uint = 999;
      
      private var _tipStr:String = "";
      
      public function Input()
      {
         super();
         this.onStyleChangeForMatchType();
         this.myIptTF.text = "";
         if(this.myTipTF != null)
         {
            this.myTipTF.text = "";
            this.myTipTF.type = TextFieldType.DYNAMIC;
            this.myTipTF.visible = false;
         }
         if(this.myBgFocus != null)
         {
            this.myBgFocus.visible = false;
            this.myBgFocus.alpha = 0;
         }
         if(this.myCleanBtn != null)
         {
            this.myCleanBtn.gotoAndStop(1);
            this.myCleanBtn.visible = false;
            this.myCleanBtn.addEventListener(MouseEvent.ROLL_OVER,this.onCleanBtnOverHandle);
            this.myCleanBtn.addEventListener(MouseEvent.ROLL_OUT,this.onCleanBtnOutHandle);
            this.myCleanBtn.addEventListener(MouseEvent.CLICK,this.onCleanBtnClickHandle);
         }
      }
      
      override protected function onInit() : void
      {
         TextFieldEx.setIMEEnabled(this.myIptTF,true);
      }
      
      override protected function onInitListener() : void
      {
         this.myIptTF.addEventListener(FocusEvent.FOCUS_IN,this.onIptFocusInHandle);
         this.myIptTF.addEventListener(FocusEvent.FOCUS_OUT,this.onIptFocusOutHandle);
         this.myIptTF.addEventListener(Event.CHANGE,this.onInputTFChangedHandle);
         this.myIptTF.addEventListener(MouseEvent.MOUSE_OVER,this.onInputMouseOver);
         this.myIptTF.addEventListener(MouseEvent.MOUSE_OUT,this.onInputMouseOut);
      }
      
      public function set multiLineEnable(cSwi:Boolean) : void
      {
         this.myIptTF.multiline = cSwi;
      }
      
      public function set maxLines(cLines:uint) : void
      {
         this._maxLines = cLines;
      }
      
      public function focusIn(cFocusAll:Boolean = false) : void
      {
         if(stage != null && stage.focus != this.myIptTF)
         {
            stage.focus = this.myIptTF;
            if(cFocusAll == true)
            {
               this.myIptTF.setSelection(0,this.myIptTF.length);
            }
         }
      }
      
      public function focusOut() : void
      {
         stage.focus = null;
      }
      
      public function get isFocusIn() : Boolean
      {
         var tempIsFocusIn:Boolean = false;
         if(stage != null)
         {
            tempIsFocusIn = stage.focus == this.myIptTF;
         }
         return tempIsFocusIn;
      }
      
      public function set lengthLimit(cLength:uint) : void
      {
         this._iptLengthLimit = cLength;
      }
      
      public function set lengthLimitIsCharacterCount(value:Boolean) : void
      {
         this._lengthLimitIsCharacterCount = value;
      }
      
      override public function set enable(cSwi:Boolean) : void
      {
         super.enable = cSwi;
         if(cSwi == true)
         {
            this.myIptTF.type = TextFieldType.INPUT;
            this.myIptTF.selectable = true;
         }
         else
         {
            this.myIptTF.type = TextFieldType.DYNAMIC;
            this.myIptTF.selectable = false;
         }
         this.refresh();
      }
      
      public function setBgVisible(cSwi:Boolean) : void
      {
         if(this.myBgNormal != null)
         {
            TweenLite.killTweensOf(this.myBgNormal,true);
            this.myBgNormal.visible = cSwi;
         }
         if(this.myBgFocus != null)
         {
            TweenLite.killTweensOf(this.myBgFocus,true);
            this.myBgFocus.visible = false;
         }
      }
      
      public function set text(cTxt:String) : void
      {
         this.myIptTF.text = cTxt;
         this.refresh();
      }
      
      public function get text() : String
      {
         return this.myIptTF.text;
      }
      
      public function set tip(cTxt:String) : void
      {
         this._tipStr = cTxt;
         if(this.myTipTF != null)
         {
            this.myTipTF.text = this._tipStr;
            this.refresh();
         }
      }
      
      public function get tip() : String
      {
         return this._tipStr;
      }
      
      public function set htmlText(cTxt:String) : void
      {
         this.myIptTF.htmlText = cTxt;
      }
      
      public function set textColor(cColor:uint) : void
      {
         this.myIptTF.textColor = cColor;
      }
      
      public function set maxChars(cLen:int) : void
      {
         this.myIptTF.maxChars = cLen;
      }
      
      public function set regExpLimit(cRegExp:RegExp) : void
      {
         this._regexp = cRegExp;
      }
      
      public function set restrict(cLimit:String) : void
      {
         this.myIptTF.restrict = cLimit;
      }
      
      public function get caretIndex() : int
      {
         return this.myIptTF.caretIndex;
      }
      
      public function set caretIndex(index:int) : void
      {
         this.myIptTF.setSelection(index,index);
      }
      
      private function onInputMouseOver(e:MouseEvent) : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onInputMouseOut(e:MouseEvent) : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      protected function onIptFocusInHandle(cEvt:FocusEvent = null) : void
      {
         this.myIptTF.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
         if(this.myBgFocus != null)
         {
            TweenLite.killTweensOf(this.myBgFocus);
            TweenLite.to(this.myBgFocus,TweenParam.SPD_FADE,{"autoAlpha":1});
         }
         if(this.myBgNormal != null)
         {
            TweenLite.killTweensOf(this.myBgNormal);
            TweenLite.to(this.myBgNormal,TweenParam.SPD_FADE,{"autoAlpha":0});
         }
         this.refresh();
         this.dispatchEvent(new ParaEvent(EVT_FOCUS_CHANGE,{"focusin":true}));
         EventManager.getInstance().broadcast(BCCommonEvent.EVT_INPUT_FOCUS_CHANGED,{"focus":true});
         if(FOCUS_CHANGE_CB != null)
         {
            FOCUS_CHANGE_CB(true);
         }
      }
      
      protected function onIptFocusOutHandle(cEvt:FocusEvent) : void
      {
         this.myIptTF.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
         if(this.myBgFocus != null)
         {
            TweenLite.killTweensOf(this.myBgFocus);
            TweenLite.to(this.myBgFocus,TweenParam.SPD_FADE,{"autoAlpha":0});
         }
         if(this.myBgNormal != null)
         {
            TweenLite.killTweensOf(this.myBgNormal);
            TweenLite.to(this.myBgNormal,TweenParam.SPD_FADE,{"autoAlpha":1});
         }
         this.refresh();
         this.dispatchEvent(new ParaEvent(EVT_FOCUS_CHANGE,{"focusin":false}));
         EventManager.getInstance().broadcast(BCCommonEvent.EVT_INPUT_FOCUS_CHANGED,{"focus":false});
         if(FOCUS_CHANGE_CB != null)
         {
            FOCUS_CHANGE_CB(false);
         }
      }
      
      private function onKeyDownHandle(cEvt:KeyboardEvent) : void
      {
         switch(cEvt.keyCode)
         {
            case Keyboard.NUMPAD_ENTER:
               if(this.stage.focus == this.myIptTF)
               {
                  this.dispatchEvent(new ParaEvent(EVT_PRESS_ENTER));
               }
               break;
            case Keyboard.ENTER:
               if(this.stage.focus == this.myIptTF)
               {
                  if(cEvt.ctrlKey == true)
                  {
                     this.dispatchEvent(new ParaEvent(EVT_PRESS_CTRL_ENTER));
                  }
                  else
                  {
                     this.dispatchEvent(new ParaEvent(EVT_PRESS_ENTER));
                  }
               }
         }
         this.dispatchEvent(new ParaEvent(EVT_KEY_DOWN,{"keyCode":cEvt.keyCode}));
      }
      
      private function onInputTFChangedHandle(cEvt:Event) : void
      {
         var tempRegexpResult:Boolean = false;
         if(this._iptLengthLimit > 0 && this.myIptTF.text.length > 0)
         {
            if(this._lengthLimitIsCharacterCount)
            {
               this.myIptTF.text = StringUtil.limitStringToCharacterLength(this.myIptTF.text,this._iptLengthLimit);
            }
            else
            {
               this.myIptTF.text = StringUtil.limitStringToRealLength(this.myIptTF.text,this._iptLengthLimit);
            }
         }
         if(this._regexp != null)
         {
            tempRegexpResult = this._regexp.test(this.myIptTF.text);
            this.dispatchEvent(new ParaEvent(EVT_REGEXP_RESULT,{"result":tempRegexpResult}));
         }
         while(this.myIptTF.numLines > this._maxLines)
         {
            this.myIptTF.text = this.myIptTF.text.substr(0,this.myIptTF.length - 1);
            if(this.myIptTF.length <= 0)
            {
               break;
            }
         }
         this.refresh();
         this.dispatchEvent(new ParaEvent(EVT_CHANGE));
      }
      
      override public function onStyleChangeForMatchType() : void
      {
         if(this.myBgNormal != null && this.myBgNormal.totalFrames > 1)
         {
            this.myIptTF.textColor = TEXT_COLOR[this.currentMatchType];
            this.myBgNormal.gotoAndStop(this.currentMatchType + 1);
            this.myBgFocus.gotoAndStop(this.currentMatchType + 1);
         }
      }
      
      private function refresh() : void
      {
         var tempFocusIn:Boolean = false;
         if(this._tipStr != "" && this.myTipTF != null)
         {
            tempFocusIn = false;
            if(this.stage != null)
            {
               tempFocusIn = this.stage.focus == this.myIptTF;
            }
            if(this.myIptTF.text == "" && tempFocusIn == false && this.enable == true)
            {
               this.myTipTF.visible = true;
            }
            else
            {
               this.myTipTF.visible = false;
            }
         }
         if(this.myCleanBtn != null)
         {
            if(this.text == "")
            {
               this.myCleanBtn.gotoAndStop(1);
               this.myCleanBtn.visible = false;
            }
            else
            {
               this.myCleanBtn.visible = true;
            }
         }
      }
      
      private function onCleanBtnOverHandle(cEvt:MouseEvent) : void
      {
         this.myCleanBtn.gotoAndStop(2);
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ROLLOVER);
      }
      
      private function onCleanBtnOutHandle(cEvt:MouseEvent) : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         this.myCleanBtn.gotoAndStop(1);
      }
      
      private function onCleanBtnClickHandle(cEvt:MouseEvent) : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         this.text = "";
         this.refresh();
         FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_BACK);
         this.dispatchEvent(new ParaEvent(EVT_CHANGE));
      }
   }
}

