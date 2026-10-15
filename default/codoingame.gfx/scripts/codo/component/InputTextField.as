package codo.component
{
   import codo.constants.SE_ID;
   import codo.utils.CursorUtil;
   import codo.utils.StringUtil;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import fsg.util.FsgAudioUtil;
   
   public class InputTextField extends TextField
   {
      
      private var mOnInputChangeCallback:Function;
      
      private var mOnInputMouseOverCallback:Function;
      
      private var mOnInputMouseOutCallback:Function;
      
      private var mOnInputFocusInCallback:Function;
      
      private var mOnInputFocusOutCallback:Function;
      
      private var OnInputSubmitCallback:Function;
      
      private var OnInputSubmitFailCallback:Function;
      
      private var mRegExpression:RegExp;
      
      private var mCharacterMinLimit:uint = 0;
      
      private var mDefaultInputFieldMessage:String = "";
      
      private var mIsEnabled:Boolean = true;
      
      private var mObfuscateEnabled:Boolean = false;
      
      private var mCache:String = "";
      
      private var mObfuscatedCache:Vector.<int> = new Vector.<int>();
      
      public function InputTextField()
      {
         super();
         this.text = "";
         myTextClip.addEventListener(Event.CHANGE,this.onInputChanged);
         myTextClip.addEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
         myTextClip.addEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
         myTextClip.addEventListener(MouseEvent.MOUSE_OVER,this.onInputMouseOver);
         myTextClip.addEventListener(MouseEvent.MOUSE_OUT,this.onInputMouseOut);
      }
      
      public function set defaultInputFieldMessage(msg:String) : void
      {
         this.text = msg;
         this.mDefaultInputFieldMessage = msg;
      }
      
      override public function get text() : String
      {
         return this.getCache();
      }
      
      override public function set text(txt:String) : void
      {
         this.setCache(txt);
         myTextClip.text = txt;
      }
      
      public function set passwordMode(password:Boolean) : void
      {
         myTextClip.displayAsPassword = password;
      }
      
      public function set ObfuscateEnabled(enabled:Boolean) : void
      {
         this.mObfuscateEnabled = enabled;
      }
      
      public function registerOnInputChangeCallback(func:Function) : void
      {
         this.mOnInputChangeCallback = func;
      }
      
      public function registerOnInputMouseOverCallback(func:Function) : void
      {
         this.mOnInputMouseOverCallback = func;
      }
      
      public function registerOnInputMouseOutCallback(func:Function) : void
      {
         this.mOnInputMouseOutCallback = func;
      }
      
      public function registerOnInputFocusInCallback(func:Function) : void
      {
         this.mOnInputFocusInCallback = func;
      }
      
      public function registerOnInputFocusOutCallback(func:Function) : void
      {
         this.mOnInputFocusOutCallback = func;
      }
      
      public function registerOnInputSubmitCallback(func:Function) : void
      {
         this.OnInputSubmitCallback = func;
      }
      
      public function registerOnInputSubmitFailCallback(func:Function) : void
      {
         this.OnInputSubmitFailCallback = func;
      }
      
      private function onInputChanged(cEvt:Event) : void
      {
         var newInput:String = StringUtil.limitStringToRealLength(myTextClip.text,myTextClip.maxChars);
         this.text = newInput;
         if(null != this.mOnInputChangeCallback)
         {
            this.mOnInputChangeCallback();
         }
      }
      
      private function onInputMouseOver(e:MouseEvent) : void
      {
         if(!this.enabled)
         {
            return;
         }
         if(null != this.mOnInputMouseOverCallback)
         {
            this.mOnInputMouseOverCallback();
         }
         FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ROLLOVER);
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onInputMouseOut(e:MouseEvent) : void
      {
         if(!this.enabled)
         {
            return;
         }
         if(null != this.mOnInputMouseOutCallback)
         {
            this.mOnInputMouseOutCallback();
         }
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      protected function onInputFocusIn(cEvt:FocusEvent = null) : void
      {
         if(!this.enabled)
         {
            return;
         }
         if(null != this.mOnInputFocusInCallback)
         {
            this.mOnInputFocusInCallback();
         }
         FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_PROCEED);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
         this.resetTextOnFocus();
      }
      
      protected function onInputFocusOut(cEvt:FocusEvent = null) : void
      {
         if(!this.enabled)
         {
            return;
         }
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
         if(null != this.mOnInputFocusOutCallback)
         {
            this.mOnInputFocusOutCallback();
         }
         this.resetTextOnFocus(false);
      }
      
      private function onKeyDownHandle(cEvt:KeyboardEvent) : void
      {
         if(!this.enabled)
         {
            return;
         }
         if(cEvt.keyCode == Keyboard.ENTER)
         {
            FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_PROCEED);
            this.trySubmittingInput();
         }
      }
      
      override public function get enabled() : Boolean
      {
         return this.mIsEnabled;
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         this.mIsEnabled = enabled;
         alpha = enabled ? 1 : 0.5;
      }
      
      public function set regExpLimit(cRegExp:RegExp) : void
      {
         this.mRegExpression = cRegExp;
      }
      
      public function set restrict(fieldRestrictions:String) : void
      {
         myTextClip.restrict = fieldRestrictions;
      }
      
      public function set minLength(cLength:uint) : void
      {
         this.mCharacterMinLimit = cLength;
      }
      
      public function set maxLength(cLength:uint) : void
      {
         myTextClip.maxChars = cLength;
      }
      
      public function get inputIsValid() : Boolean
      {
         var passesRegExpressionTest:Boolean = true;
         var stringToEvaluate:String = this.text;
         if(this.mRegExpression != null)
         {
            passesRegExpressionTest = this.mRegExpression.test(stringToEvaluate);
         }
         var inputLen:uint = StringUtil.getRealLength(stringToEvaluate);
         return passesRegExpressionTest && inputLen >= this.mCharacterMinLimit && inputLen <= myTextClip.maxChars;
      }
      
      private function trySubmittingInput() : void
      {
         if(this.inputIsValid)
         {
            if(this.OnInputSubmitCallback != null)
            {
               this.OnInputSubmitCallback();
            }
         }
         else
         {
            FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_LOCKED);
            if(this.OnInputSubmitFailCallback != null)
            {
               this.OnInputSubmitFailCallback();
            }
         }
      }
      
      public function focusIn(cFocusAll:Boolean = false) : void
      {
         if(stage != null && stage.focus != myTextClip)
         {
            stage.focus = myTextClip;
            this.onInputFocusIn();
            if(cFocusAll == true)
            {
               myTextClip.setSelection(0,myTextClip.length);
            }
         }
      }
      
      public function focusOut() : void
      {
         stage.focus = null;
      }
      
      private function resetTextOnFocus(isFocusIn:Boolean = true) : void
      {
         if(isFocusIn)
         {
            if(this.text == this.mDefaultInputFieldMessage)
            {
               this.text = "";
            }
         }
         else if(this.mDefaultInputFieldMessage.length > 0 && this.text == "")
         {
            this.text = this.mDefaultInputFieldMessage;
         }
      }
      
      private function setCache(srcStr:String) : void
      {
         if(this.mObfuscateEnabled)
         {
            this.mObfuscatedCache = StringUtil.obfuscateStringToVector(srcStr);
         }
         else
         {
            this.mCache = srcStr;
         }
      }
      
      private function getCache() : String
      {
         if(this.mObfuscateEnabled)
         {
            return StringUtil.unobfuscateVectorToString(this.mObfuscatedCache);
         }
         return this.mCache;
      }
   }
}

