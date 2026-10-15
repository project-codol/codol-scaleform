package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import com.greensock.TweenLite;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class StringUtil
   {
      
      private static const IGNORE_STRING:String = "...";
      
      private static const KEY_LENGTH:int = 32;
      
      private static var KEY:Vector.<int> = new Vector.<int>(KEY_LENGTH);
      
      private static var IsKeyInited:Boolean = false;
      
      public static const INPUT_FIELD_VALID_REGULAR:RegExp = /^[_0-9a-zA-Z一-龥]+$/;
      
      public static const INPUT_FIELD_NAME_RESTRICTION:String = "_0-9a-zA-Z一-龥";
      
      public function StringUtil()
      {
         super();
      }
      
      public static function trim(str:String, char:String = " ") : String
      {
         return trimBack(trimFront(str,char),char);
      }
      
      public static function trimFront(str:String, char:String = " ") : String
      {
         char = stringToCharacter(char);
         if(str.charAt(0) == char)
         {
            str = trimFront(str.substring(1),char);
         }
         return str;
      }
      
      public static function trimBack(str:String, char:String = " ") : String
      {
         char = stringToCharacter(char);
         if(str.charAt(str.length - 1) == char)
         {
            str = trimBack(str.substring(0,str.length - 1),char);
         }
         return str;
      }
      
      public static function stringToCharacter(str:String) : String
      {
         if(str.length == 1)
         {
            return str;
         }
         return str.slice(0,1);
      }
      
      public static function addZero(cDat:*, cLen:uint = 2) : String
      {
         cDat = String(cDat);
         for(var i:uint = cDat.length + 1; i <= cLen; i++)
         {
            cDat = "0" + cDat;
         }
         return cDat;
      }
      
      public static function addTag(cTag:String, cName:String) : String
      {
         if(cName == null)
         {
            return "";
         }
         if(cTag == null)
         {
            return cName;
         }
         return cTag.length > 0 ? "[" + cTag + "] " + cName : cName;
      }
      
      public static function getRealLength(cStr:String) : uint
      {
         var len:uint = 0;
         for(var i:uint = 0; i < cStr.length; i++)
         {
            if(cStr.charCodeAt(i) > 255)
            {
               len += 2;
            }
            else
            {
               len++;
            }
         }
         return len;
      }
      
      public static function limitStringToRealLength(cStr:String, cLimitLen:uint) : String
      {
         var len:uint = 0;
         var returnStr:String = cStr;
         for(var i:uint = 0; i < cStr.length; i++)
         {
            if(cStr.charCodeAt(i) > 255)
            {
               len += 2;
            }
            else
            {
               len++;
            }
            if(len > cLimitLen)
            {
               returnStr = cStr.substr(0,i);
               break;
            }
         }
         return returnStr;
      }
      
      public static function limitStringToCharacterLength(cStr:String, cLimitLen:uint) : String
      {
         if(cStr.length > cLimitLen)
         {
            return cStr.substr(0,cLimitLen);
         }
         return cStr;
      }
      
      public static function limitStringToRealLengthUTF(cStr:String, cLimitLen:uint) : String
      {
         var byteStr:ByteArray = new ByteArray();
         byteStr.writeUTFBytes(cStr);
         while(byteStr.length > cLimitLen)
         {
            cStr = cStr.substr(0,cStr.length - 1);
            byteStr.clear();
            byteStr.writeUTFBytes(cStr);
         }
         return cStr;
      }
      
      public static function fitTextField(tf:TextField) : void
      {
         var originalStr:String = null;
         var testStr:String = null;
         var selectedIndex:int = 0;
         var i:int = 0;
         if(tf.textWidth > tf.width)
         {
            originalStr = tf.text;
            testStr = "";
            selectedIndex = 0;
            for(i = 0; i < originalStr.length; i++)
            {
               testStr += originalStr.charAt(i);
               tf.text = testStr + "...";
               if(tf.textWidth >= tf.width)
               {
                  break;
               }
               selectedIndex = i;
            }
            tf.text = originalStr.slice(0,selectedIndex);
            tf.appendText("...");
         }
      }
      
      public static function fitTextFieldByLength(tf:TextField, width:int) : void
      {
         var originalStr:String = null;
         var testStr:String = null;
         var selectedIndex:int = 0;
         var i:int = 0;
         if(tf.textWidth > width)
         {
            originalStr = tf.text;
            testStr = "";
            selectedIndex = 0;
            for(i = 0; i < originalStr.length; i++)
            {
               testStr += originalStr.charAt(i);
               tf.text = testStr + "..";
               if(tf.textWidth >= width)
               {
                  break;
               }
               selectedIndex = i;
            }
            tf.text = originalStr.slice(0,selectedIndex);
            tf.appendText("..");
         }
      }
      
      public static function cutOffString(srcTF:TextField, maxLines:int) : void
      {
         var originalLines:int = 0;
         var originalText:String = null;
         var firstCurLineIndex:int = 0;
         var cutTextCount:int = 0;
         var i:int = 0;
         if(srcTF.numLines > maxLines)
         {
            originalLines = srcTF.numLines;
            originalText = srcTF.text;
            firstCurLineIndex = maxLines;
            cutTextCount = 0;
            for(i = firstCurLineIndex; i < originalLines; i++)
            {
               cutTextCount += srcTF.getLineLength(i);
            }
            cutTextCount += IGNORE_STRING.length;
            srcTF.text = originalText.slice(0,originalText.length - cutTextCount);
            srcTF.appendText(IGNORE_STRING);
         }
      }
      
      public static function receiversToString(cReceivers:Array) : String
      {
         var name:String = "";
         for(var i:int = 0; i < cReceivers.length; i++)
         {
            name += cReceivers[i];
            name += "; ";
         }
         return name;
      }
      
      public static function stringToReceivers(cText:String) : Array
      {
         return cText.split(";");
      }
      
      public static function tweenText(target:TextField, targetNumber:Number, duration:Number, onStartHandle:Function = null, onUpdateHandle:Function = null, onCompleteHandle:Function = null) : TweenLite
      {
         var initNumber:Number = NaN;
         var tween:TweenLite = null;
         var fixed:int = 0;
         var onTextStart:Function = null;
         var onTextUpdate:Function = null;
         var onTextComplete:Function = null;
         onTextStart = function():void
         {
            initNumber = Number(target.text);
            if(isNaN(initNumber))
            {
               tween.kill();
               target.text = String(targetNumber);
            }
            if(onStartHandle != null)
            {
               onStartHandle.apply();
            }
         };
         onTextUpdate = function():void
         {
            var percent:Number = tween.currentTime / tween.totalDuration;
            var currentNumber:Number = initNumber + (targetNumber - initNumber) * percent;
            target.text = currentNumber.toFixed(fixed);
            if(onUpdateHandle != null)
            {
               onUpdateHandle.apply();
            }
         };
         onTextComplete = function():void
         {
            target.text = String(targetNumber);
            if(onCompleteHandle != null)
            {
               onCompleteHandle.apply();
            }
         };
         fixed = digitCount(targetNumber);
         tween = TweenLite.to(target,duration,{
            "onStart":onTextStart,
            "onUpdate":onTextUpdate,
            "onComplete":onTextComplete
         });
         return tween;
      }
      
      public static function digitCount(value:Number) : int
      {
         var tempStr:String = String(value);
         var dotIndex:int = tempStr.indexOf(".");
         return dotIndex == -1 ? 0 : int(tempStr.length - dotIndex - 1);
      }
      
      public static function isEmpty(txt:String) : Boolean
      {
         return txt == "" || txt == " ";
      }
      
      private static function initRandomKeyOnce() : void
      {
         var i:Number = NaN;
         var r:int = 0;
         if(!IsKeyInited)
         {
            for(i = 0; i < KEY_LENGTH; i++)
            {
               r = 0;
               do
               {
                  r = Math.floor(Math.random() * 255);
               }
               while(r == 0);
               KEY[i] = r;
            }
            IsKeyInited = true;
         }
      }
      
      public static function obfuscateStringToVector(cStr:String) : Vector.<int>
      {
         initRandomKeyOnce();
         var result:Vector.<int> = new Vector.<int>(cStr.length);
         for(var i:Number = 0; i < cStr.length; i++)
         {
            result[i] = cStr.charCodeAt(i) ^ KEY[i % KEY_LENGTH];
         }
         return result;
      }
      
      public static function unobfuscateVectorToString(vec:Vector.<int>) : String
      {
         initRandomKeyOnce();
         var result:String = new String();
         for(var i:Number = 0; i < vec.length; i++)
         {
            result += String.fromCharCode(vec[i] ^ KEY[i % KEY_LENGTH]);
         }
         return result;
      }
      
      public static function zeroPad(number:int, width:int) : String
      {
         var ret:String = "" + number;
         while(ret.length < width)
         {
            ret = "0" + ret;
         }
         return ret;
      }
      
      public static function getMinEnglishNameCharacterCount() : int
      {
         return CFunctionCommonContainer.AS_GetMinEnglishNameCharacterCount();
      }
      
      public static function getMaxEnglishNameCharacterCount() : int
      {
         var hackedNameLenLimit:int = 0;
         if(Boolean(CFunctionCommonContainer.IsDevelopmentBuild()))
         {
            hackedNameLenLimit = CFunctionCommonContainer.Dvar_GetInt("dw_hackNameLenLimit");
            if(-1 != hackedNameLenLimit)
            {
               return hackedNameLenLimit;
            }
         }
         return CFunctionCommonContainer.AS_GetMaxEnglishNameCharacterCount();
      }
      
      public static function formatSeconds(seconds:int) : String
      {
         var minutes:int = seconds / 60;
         seconds %= 60;
         return StringUtil.addZero(minutes) + ":" + StringUtil.addZero(seconds);
      }
      
      public static function formatSecondsHHMMSS(seconds:int) : String
      {
         var hours:int = seconds / 3600;
         var minutes:int = seconds % 3600 / 60;
         seconds %= 60;
         return StringUtil.addZero(hours) + ":" + StringUtil.addZero(minutes) + ":" + StringUtil.addZero(seconds);
      }
   }
}

