package codo.utils
{
   import codo.constants.GameInfo;
   import codo.interfaces.ISoundUtil;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import scaleform.gfx.TextFieldEx;
   
   public class TextUtil
   {
      
      public static var SOUND_UTIL:ISoundUtil;
      
      private static var _TYPE_TIMERS:Dictionary = new Dictionary();
      
      private static var _shuffleChars:String = "^-.*#$%!&543210";
      
      private static var _SHUFFLE_TIME:uint = 6;
      
      private static var _SHUFFLE_TYPE_TIMERS:Dictionary = new Dictionary();
      
      public static var TEXTFIELD_TIP_DATA:Dictionary = new Dictionary();
      
      public static var TEXTFIELD_TIP_TF_ALPHA:Number = 0.35;
      
      public function TextUtil()
      {
         super();
      }
      
      public static function addTypeEffect(cTF:TextField, cStr:String, cSpd:uint = 30, cOnComplete:Function = null) : void
      {
         removeTypeEffect(cTF);
         _TYPE_TIMERS[cTF] = {
            "tf":cTF,
            "txt":cStr,
            "spd":cSpd,
            "onComplete":cOnComplete,
            "currentIndex":0
         };
         var tempTimer:Timer = new Timer(cSpd,0);
         _TYPE_TIMERS[cTF].timer = tempTimer;
         tempTimer.addEventListener(TimerEvent.TIMER,typeEffectTimerHandle);
         cTF.text = "";
         tempTimer.start();
      }
      
      public static function removeTypeEffect(cTF:TextField) : void
      {
         if(_TYPE_TIMERS[cTF] != null)
         {
            _TYPE_TIMERS[cTF].timer.stop();
            _TYPE_TIMERS[cTF].timer.removeEventListener(TimerEvent.TIMER,typeEffectTimerHandle);
            delete _TYPE_TIMERS[cTF];
         }
      }
      
      private static function typeEffectTimerHandle(cEvt:TimerEvent) : void
      {
         var typeEffectObj:Object = getTypeEffectObjByTimer(cEvt.target as Timer);
         if(typeEffectObj.currentIndex > typeEffectObj.txt.length)
         {
            removeTypeEffect(typeEffectObj.tf);
         }
         typeEffectObj.tf.appendText(typeEffectObj.txt.charAt(typeEffectObj.currentIndex));
         ++typeEffectObj.currentIndex;
      }
      
      private static function getTypeEffectObjByTimer(cTimer:Timer) : Object
      {
         var tempObj:Object = null;
         var i:* = undefined;
         for(i in _TYPE_TIMERS)
         {
            if(_TYPE_TIMERS[i].timer == cTimer)
            {
               tempObj = _TYPE_TIMERS[i];
               break;
            }
         }
         return tempObj;
      }
      
      public static function addShuffleTypeEffect(cTF:TextField, cStr:String, cSpd:uint = 20, cOnComplete:Function = null) : void
      {
         removeShuffleTypeEffect(cTF);
         if(cStr == "" || cStr == null)
         {
            cTF.text = "";
            return;
         }
         _SHUFFLE_TYPE_TIMERS[cTF] = {
            "tf":cTF,
            "txt":cStr,
            "spd":cSpd,
            "onComplete":cOnComplete,
            "currentIndex":0,
            "shuffleIndex":[]
         };
         var tempTimer:Timer = new Timer(cSpd,0);
         _SHUFFLE_TYPE_TIMERS[cTF].timer = tempTimer;
         tempTimer.addEventListener(TimerEvent.TIMER,shuffleAddTimerHandle);
         var tempShuffleTimer:Timer = new Timer(33,0);
         _SHUFFLE_TYPE_TIMERS[cTF].shuffleTimer = tempShuffleTimer;
         tempShuffleTimer.addEventListener(TimerEvent.TIMER,shuffleCharacterTimerHandle);
         cTF.text = "";
         tempTimer.start();
         tempShuffleTimer.start();
      }
      
      public static function removeShuffleTypeEffect(cTF:TextField) : void
      {
         if(_SHUFFLE_TYPE_TIMERS[cTF] != null)
         {
            _SHUFFLE_TYPE_TIMERS[cTF].timer.stop();
            _SHUFFLE_TYPE_TIMERS[cTF].timer.removeEventListener(TimerEvent.TIMER,shuffleAddTimerHandle);
            _SHUFFLE_TYPE_TIMERS[cTF].shuffleTimer.stop();
            _SHUFFLE_TYPE_TIMERS[cTF].shuffleTimer.removeEventListener(TimerEvent.TIMER,shuffleCharacterTimerHandle);
            delete _SHUFFLE_TYPE_TIMERS[cTF];
         }
      }
      
      private static function shuffleAddTimerHandle(cEvt:TimerEvent) : void
      {
         var typeEffectObj:Object = getShuffleTypeEffectObjByTimer(cEvt.target as Timer);
         if(typeEffectObj.currentIndex > typeEffectObj.txt.length)
         {
            _SHUFFLE_TYPE_TIMERS[typeEffectObj.tf].timer.stop();
            _SHUFFLE_TYPE_TIMERS[typeEffectObj.tf].timer.removeEventListener(TimerEvent.TIMER,shuffleAddTimerHandle);
         }
         typeEffectObj.shuffleIndex[typeEffectObj.currentIndex] = 0;
         ++typeEffectObj.currentIndex;
      }
      
      private static function shuffleCharacterTimerHandle(cEvt:TimerEvent) : void
      {
         var typeEffectObj:Object = getShuffleTypeEffectObjByTimer(cEvt.target as Timer);
         var tempTxt:String = "";
         for(var i:uint = 0; i < typeEffectObj.shuffleIndex.length; i++)
         {
            if(typeEffectObj.shuffleIndex[i] > _SHUFFLE_TIME)
            {
               tempTxt += typeEffectObj.txt.charAt(i);
            }
            else
            {
               tempTxt += _shuffleChars.charAt(Math.round(Math.random() * _shuffleChars.length));
               ++typeEffectObj.shuffleIndex[i];
            }
         }
         if(typeEffectObj.tf.text != tempTxt)
         {
            typeEffectObj.tf.text = tempTxt;
         }
         if(tempTxt == typeEffectObj.txt)
         {
            removeShuffleTypeEffect(typeEffectObj.tf);
         }
      }
      
      private static function getShuffleTypeEffectObjByTimer(cTimer:Timer) : Object
      {
         var tempObj:Object = null;
         var i:* = undefined;
         for(i in _SHUFFLE_TYPE_TIMERS)
         {
            if(_SHUFFLE_TYPE_TIMERS[i].timer == cTimer || _SHUFFLE_TYPE_TIMERS[i].shuffleTimer == cTimer)
            {
               tempObj = _SHUFFLE_TYPE_TIMERS[i];
               break;
            }
         }
         return tempObj;
      }
      
      public static function setIconText(cTextField:TextField, cStr:String, cIconSrc:String, cColor:String = "FFFFFF", cOffsetY:uint = 0, cNeedLocalize:Boolean = true) : void
      {
         if(cNeedLocalize == true)
         {
            cStr = LocalizeUtil.localize(cStr);
         }
         if(ScaleformUtil.isScaleform == true)
         {
            cTextField.htmlText = "<img src=\'" + cIconSrc + "\' vspace=\'" + cOffsetY + "\' /><font color=\'#" + cColor + "\'>" + cStr + "</>";
         }
         else
         {
            cTextField.htmlText = "<font color=\'#" + cColor + "\'>" + cStr + "</>";
         }
      }
      
      public static function appendHTML(tf:TextField, msg:String = "") : void
      {
         if(ScaleformUtil.isScaleform)
         {
            TextFieldEx.appendHtml(tf,msg);
         }
         else
         {
            tf.htmlText += msg;
         }
      }
      
      public static function resizeTextToFitWidth(tf:TextField, textFieldMaxWidth:Number = -1, minSize:Number = 10) : void
      {
         var tFormat:TextFormat = tf.getTextFormat();
         var tMaxWidth:Number = tf.width;
         if(textFieldMaxWidth != -1)
         {
            tMaxWidth = textFieldMaxWidth;
         }
         while(tf.textWidth > tMaxWidth)
         {
            if(tFormat.size == minSize)
            {
               break;
            }
            tFormat.size = int(tFormat.size) - 1;
            tf.setTextFormat(tFormat);
         }
      }
      
      public static function resizeTextToFitHeight(tf:TextField, textFieldMaxHeight:Number = -1, minSize:Number = 10) : void
      {
         var tFormat:TextFormat = tf.getTextFormat();
         var tMaxHeight:Number = tf.height;
         if(textFieldMaxHeight != -1)
         {
            tMaxHeight = textFieldMaxHeight;
         }
         while(tf.textHeight > tMaxHeight)
         {
            if(tFormat.size == minSize)
            {
               break;
            }
            tFormat.size = int(tFormat.size) - 1;
            tf.setTextFormat(tFormat);
         }
      }
      
      public static function replaceEnFont(cTargetTF:TextField, cStr:String, cEnFont:String = "Agency FB", cEnSize:uint = 0, cCnFont:String = "FZZongYi-M05S", cCnSize:uint = 0) : void
      {
         var tempTF:TextFormat = null;
         var tempPattern:RegExp = null;
         var result:Object = null;
         var tempTxt:String = null;
         var searchFirstIndex:int = 0;
         var firstIndex:int = 0;
         var oldStr:String = cTargetTF.text;
         cTargetTF.text = cStr;
         if(oldStr != cTargetTF.text)
         {
            tempTF = cTargetTF.getTextFormat();
            tempTF.font = cCnFont;
            tempTF.bold = false;
            if(cCnSize != 0)
            {
               tempTF.size = cCnSize;
            }
            cTargetTF.setTextFormat(tempTF);
            tempTF.font = cEnFont;
            if(cEnFont == GameInfo.GAME_FONT_AENCY_FB_BOLD)
            {
               tempTF.bold = true;
            }
            if(cEnSize != 0)
            {
               tempTF.size = cEnSize;
            }
            tempPattern = /([\x00-\x7F]+)/ig;
            result = tempPattern.exec(cTargetTF.text);
            tempTxt = cTargetTF.text;
            searchFirstIndex = 0;
            while(result != null)
            {
               firstIndex = tempTxt.indexOf(result[1],searchFirstIndex);
               if(firstIndex != -1)
               {
                  cTargetTF.setTextFormat(tempTF,firstIndex,firstIndex + result[1].length);
                  searchFirstIndex += result[1].length;
                  result = tempPattern.exec(cTargetTF.text);
               }
            }
         }
      }
      
      public static function truncatTextByLineNum(cTargetTF:TextField, lineNum:int) : void
      {
         if(cTargetTF.numLines <= lineNum)
         {
            return;
         }
         var truncatString:String = "";
         for(var i:int = 0; i < lineNum; i++)
         {
            truncatString += cTargetTF.getLineText(i);
         }
         cTargetTF.text = truncatString;
      }
      
      public static function replaceEnFontAndFitWidth(cTargetTF:TextField, cStr:String) : void
      {
         var tempPattern:RegExp = null;
         var result:Object = null;
         var tempTxt:String = null;
         var searchFirstIndex:int = 0;
         var firstIndex:int = 0;
         cTargetTF.text = cStr;
         var tempTF:TextFormat = cTargetTF.getTextFormat();
         var fontSize:int = int(tempTF.size);
         do
         {
            tempTF.font = GameInfo.GAME_FONT_S;
            tempTF.bold = false;
            tempTF.size = fontSize;
            cTargetTF.setTextFormat(tempTF);
            tempTF.font = GameInfo.GAME_FONT_AENCY_FB_BOLD;
            tempTF.bold = true;
            tempPattern = /([\x00-\x7F]+)/ig;
            result = tempPattern.exec(cTargetTF.text);
            tempTxt = cTargetTF.text;
            searchFirstIndex = 0;
            while(result != null)
            {
               firstIndex = tempTxt.indexOf(result[1],searchFirstIndex);
               if(firstIndex != -1)
               {
                  cTargetTF.setTextFormat(tempTF,firstIndex,firstIndex + result[1].length);
                  searchFirstIndex += result[1].length;
                  result = tempPattern.exec(cTargetTF.text);
               }
            }
            fontSize--;
         }
         while(cTargetTF.textWidth > cTargetTF.width && fontSize > 0);
      }
      
      public static function replaceStrWithFont(cTF:TextField, cStr:String, cFont:String = "FZLanTingHei-R-GBK") : void
      {
         var tempStartIndex:uint = uint(cTF.text.indexOf(cStr));
         var tempLength:uint = uint(cStr.length);
         var tempTF:TextFormat = cTF.getTextFormat();
         tempTF.font = cFont;
         cTF.setTextFormat(tempTF,tempStartIndex,tempStartIndex + tempLength);
      }
      
      public static function setFontSize(tf:TextField, fontSize:int) : void
      {
         var tfm:TextFormat = tf.getTextFormat();
         tfm.size = fontSize;
         tf.setTextFormat(tfm);
      }
      
      public static function setFont(tf:TextField, font:String) : void
      {
         var tfm:TextFormat = tf.getTextFormat();
         tfm.font = font;
         tf.setTextFormat(tfm);
      }
      
      public static function addTextFieldTip(cTF:TextField, cTip:String) : void
      {
         TEXTFIELD_TIP_DATA[cTF] = {
            "tf":cTF,
            "tip":cTip
         };
         cTF.addEventListener(FocusEvent.FOCUS_IN,onTextFieldTipFocusInHandle);
         cTF.addEventListener(FocusEvent.FOCUS_OUT,onTextFieldTipFocusOutHandle);
         cTF.addEventListener(Event.CHANGE,onTextFieldTipChangeHandle);
         if(cTF.text == "")
         {
            cTF.text = cTip;
            cTF.alpha = TEXTFIELD_TIP_TF_ALPHA;
         }
      }
      
      public static function removeTextFieldTip(cTF:TextField) : void
      {
         if(TEXTFIELD_TIP_DATA[cTF] != null)
         {
            cTF.removeEventListener(FocusEvent.FOCUS_IN,onTextFieldTipFocusInHandle);
            cTF.removeEventListener(FocusEvent.FOCUS_OUT,onTextFieldTipFocusOutHandle);
            cTF.removeEventListener(Event.CHANGE,onTextFieldTipChangeHandle);
            if(cTF.text == LocalizeUtil.localize(TEXTFIELD_TIP_DATA[cTF].tip))
            {
               cTF.text = "";
            }
            delete TEXTFIELD_TIP_DATA[cTF];
         }
      }
      
      private static function onTextFieldTipFocusInHandle(cEvt:FocusEvent) : void
      {
         var tempTF:TextField = cEvt.target as TextField;
         if(tempTF.text == "" || tempTF.text == LocalizeUtil.localize(TEXTFIELD_TIP_DATA[tempTF].tip))
         {
            tempTF.text = "";
            tempTF.alpha = 1;
         }
      }
      
      private static function onTextFieldTipFocusOutHandle(cEvt:FocusEvent) : void
      {
         var tempTF:TextField = cEvt.target as TextField;
         if(tempTF.text == "")
         {
            tempTF.text = TEXTFIELD_TIP_DATA[tempTF].tip;
            tempTF.alpha = TEXTFIELD_TIP_TF_ALPHA;
         }
      }
      
      private static function onTextFieldTipChangeHandle(cEvt:Event) : void
      {
         var tempTF:TextField = cEvt.target as TextField;
         if(tempTF.text == "" || tempTF.text == LocalizeUtil.localize(TEXTFIELD_TIP_DATA[tempTF].tip))
         {
            if(tempTF.stage != null && tempTF.stage.focus != tempTF)
            {
               tempTF.text = LocalizeUtil.localize(TEXTFIELD_TIP_DATA[tempTF].tip);
            }
            tempTF.alpha = TEXTFIELD_TIP_TF_ALPHA;
         }
         else
         {
            tempTF.alpha = 1;
         }
      }
   }
}

