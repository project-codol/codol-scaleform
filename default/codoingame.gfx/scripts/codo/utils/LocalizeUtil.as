package codo.utils
{
   import codo.localization.Dict;
   import codo.localization.DictCareer;
   import codo.objects.RequirementObj;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class LocalizeUtil
   {
      
      public static var CFUNCTION_COMMON:*;
      
      private static var _LOCAL_TRANS_TF:TextField;
      
      public function LocalizeUtil()
      {
         super();
      }
      
      public static function localize(cStrID:String) : String
      {
         if(cStrID == null)
         {
            return "";
         }
         if(_LOCAL_TRANS_TF == null)
         {
            _LOCAL_TRANS_TF = new TextField();
         }
         _LOCAL_TRANS_TF.text = cStrID;
         return _LOCAL_TRANS_TF.text;
      }
      
      public static function replace(cOrgStr:String, cParams:Array) : String
      {
         return LocalizeUtil.replaceConversionString(cOrgStr,cParams);
      }
      
      public static function getLocalizationWithToken(source:String, ... params) : String
      {
         var replacement:String = null;
         var pattern:RegExp = /{\d}/g;
         var ar:Array = localize(source).match(pattern);
         var i:uint = 0;
         var len:uint = ar.length;
         for(source = localize(source); i < len; )
         {
            replacement = localize(params[i]);
            source = source.split(ar[i]).join(replacement);
            i++;
         }
         return source;
      }
      
      public static function getLocalizationWithKeyBinding(cStrID:String) : String
      {
         var len:uint = 0;
         var bindingKeyNames:Array = null;
         var bindingKeyNameStr:String = null;
         var i:uint = 0;
         var tempRegExp:RegExp = /\[\{(\+\w[\w ]+)\}\]/i;
         var tempStr:String = localize(cStrID);
         var tempResult:Array = tempRegExp.exec(tempStr);
         while(tempResult != null)
         {
            bindingKeyNames = CFUNCTION_COMMON.GetKeyBindingNamesFromCommand(tempResult[1]);
            bindingKeyNameStr = "";
            for(i = 0; i < bindingKeyNames.length; i++)
            {
               if(bindingKeyNames[i] == "KEY_MOUSE1_ICON")
               {
                  bindingKeyNames[i] = "KEY_MOUSE1";
               }
               if(bindingKeyNames[i] == "KEY_MOUSE2_ICON")
               {
                  bindingKeyNames[i] = "KEY_MOUSE2";
               }
               if(i > 0)
               {
                  bindingKeyNameStr += " " + LocalizeUtil.localize("@KEY_OR") + " ";
               }
               bindingKeyNameStr += LocalizeUtil.localize("@" + bindingKeyNames[i]);
            }
            tempStr = tempStr.split(tempResult[0]).join(bindingKeyNameStr);
            tempResult = tempRegExp.exec(tempStr);
         }
         return tempStr;
      }
      
      public static function localizeFirstKeyBindingForCommand(cmd:String) : String
      {
         var bindings:Array = CFUNCTION_COMMON.GetKeyBindingNamesFromCommand(cmd);
         var bind:String = bindings[0];
         if(bind == "KEY_MOUSE1_ICON")
         {
            bindings[0] = "KEY_MOUSE1";
         }
         if(bind == "KEY_MOUSE2_ICON")
         {
            bindings[0] = "KEY_MOUSE2";
         }
         if(bind.indexOf("KEY_") >= 0)
         {
            bind = LocalizeUtil.localize("@" + bindings[0]);
         }
         return bind;
      }
      
      public static function param(cStrID:String, params:Array) : String
      {
         return LocalizeUtil.replaceConversionString(LocalizeUtil.localize(cStrID),params);
      }
      
      private static function getParamFactors(tf:TextField, strID:String, params:Array) : Vector.<Point>
      {
         var key:String = null;
         var startIndex:int = 0;
         var localizedKey:String = null;
         var endIndex:int = 0;
         var index:Point = null;
         var paramLen:int = int(params.length);
         var paramIndices:Vector.<Point> = new Vector.<Point>();
         var localizedRaw:String = LocalizeUtil.localize(strID);
         for(var i:int = 0; i < paramLen; i++)
         {
            key = "&&" + String(i + 1);
            startIndex = localizedRaw.indexOf(key);
            localizedKey = LocalizeUtil.localize(params[i]);
            endIndex = startIndex + localizedKey.length;
            index = new Point(startIndex,endIndex);
            paramIndices.push(index);
            localizedRaw = localizedRaw.replace(key,localizedKey);
         }
         tf.text = localizedRaw;
         return paramIndices;
      }
      
      public static function paramCustomizeFormat(tf:TextField, strID:String, params:Array, customizedFormatter:Function) : void
      {
         var textFormat:TextFormat = null;
         var paramIndices:Vector.<Point> = getParamFactors(tf,strID,params);
         if(null == paramIndices)
         {
            return;
         }
         for(var i:int = 0; i < paramIndices.length; i++)
         {
            textFormat = tf.getTextFormat();
            customizedFormatter(textFormat,i);
            tf.setTextFormat(textFormat,paramIndices[i].x,paramIndices[i].y);
         }
      }
      
      public static function paramColorized(tf:TextField, strID:String, params:Array, colors:Array) : void
      {
         var textFormat:TextFormat = null;
         var paramIndices:Vector.<Point> = getParamFactors(tf,strID,params);
         if(null == paramIndices)
         {
            return;
         }
         for(var i:int = 0; i < paramIndices.length; i++)
         {
            textFormat = tf.getTextFormat();
            textFormat.color = colors[i];
            tf.setTextFormat(textFormat,paramIndices[i].x,paramIndices[i].y);
         }
      }
      
      public static function combineColorizedStrings(tf:TextField, strIDs:Array, colors:Array) : void
      {
         var onSetFontColor:Function = null;
         onSetFontColor = function(textFormat:TextFormat, index:int):void
         {
            textFormat.color = colors[index];
         };
         combineCustomizeFormatStrings(tf,strIDs,onSetFontColor);
      }
      
      public static function combineCustomizeFormatStrings(tf:TextField, strIDs:Array, customizedFormatter:Function) : void
      {
         var i:int = 0;
         var localized:String = null;
         var textFormat:TextFormat = null;
         var lengths:Array = [];
         var s:String = "";
         for(i = 0; i < strIDs.length; i++)
         {
            localized = localize(strIDs[i]);
            s += localized;
            lengths.push(localized.length);
         }
         tf.text = s;
         var start:int = 0;
         for(i = 0; i < lengths.length; i++)
         {
            textFormat = tf.getTextFormat();
            customizedFormatter(textFormat,i);
            tf.setTextFormat(textFormat,start,start + lengths[i]);
            start += lengths[i];
         }
      }
      
      public static function paramFont(tf:TextField, strID:String, params:Array, fonts:Array) : void
      {
         var textFormat:TextFormat = null;
         var paramIndices:Vector.<Point> = getParamFactors(tf,strID,params);
         if(null == paramIndices)
         {
            return;
         }
         for(var i:int = 0; i < paramIndices.length; i++)
         {
            textFormat = tf.getTextFormat();
            textFormat.font = fonts[i];
            tf.setTextFormat(textFormat,paramIndices[i].x,paramIndices[i].y);
         }
      }
      
      public static function paramTextFieldInput(tf:TextField, strID:String, params:Array, colors:Array = null, fonts:Array = null, sizes:Array = null) : Vector.<Point>
      {
         var textFormat:TextFormat = null;
         var paramIndices:Vector.<Point> = getParamFactors(tf,strID,params);
         if(null == paramIndices)
         {
            return null;
         }
         for(var i:int = 0; i < paramIndices.length; i++)
         {
            textFormat = tf.getTextFormat();
            if(colors != null)
            {
               textFormat.color = colors[i];
            }
            if(fonts != null)
            {
               textFormat.font = fonts[i];
            }
            if(sizes != null)
            {
               textFormat.size = sizes[i];
            }
            tf.setTextFormat(textFormat,paramIndices[i].x,paramIndices[i].y);
         }
         return paramIndices;
      }
      
      public static function replaceConversionString(cOrgStr:String, cParams:Array) : String
      {
         var findStr:String = null;
         for(var i:uint = 0; i < cParams.length; i++)
         {
            findStr = "&&" + (i + 1);
            if(cOrgStr != null && cOrgStr.length > 0)
            {
               if(ScaleformUtil.isScaleform)
               {
                  cOrgStr = cOrgStr.split(findStr).join(cParams[i]);
               }
               else
               {
                  cOrgStr = cParams[i] + " " + cOrgStr;
               }
            }
         }
         return cOrgStr;
      }
      
      public static function getLocalizedRequirement(cObj:Object) : String
      {
         var resultStringArray:Array = null;
         var resultString:String = null;
         var i:uint = 0;
         var cRequirement:RequirementObj = new RequirementObj(cObj);
         if(cRequirement != null)
         {
            if(cRequirement.isChallenge == false)
            {
               if(cRequirement.valueArray.length > 0)
               {
                  return replaceConversionString(localize(cRequirement.statement),cRequirement.valueArray);
               }
               return localize(cRequirement.statement);
            }
            resultStringArray = new Array();
            resultString = "";
            for(i = 0; i < cRequirement.challengeNum; i++)
            {
               resultString += localize(cRequirement.challengeNames[i]) + "(" + cRequirement.challengeLevels[i] + localize(Dict.CHALLENGE_UNIT) + ")";
            }
            resultStringArray.push(resultString);
            return replaceConversionString(localize(cRequirement.statement),resultStringArray);
         }
         return "";
      }
      
      public static function removeColorTags(cStrID:String) : String
      {
         if(cStrID.length == 0)
         {
            return cStrID;
         }
         var removeColorTags:RegExp = /[\^]([0-9])/g;
         return cStrID.replace(removeColorTags,"");
      }
      
      public static function getColorCodeByColorString(colorStr:String) : uint
      {
         switch(colorStr)
         {
            case "^0":
               return 0;
            case "^1":
               return 16745001;
            case "^2":
               return 2729727;
            case "^3":
               return 2214279;
            case "^4":
               return 255;
            case "^5":
               return 65535;
            case "^6":
               return 16735487;
            case "^7":
               return 16777215;
            default:
               return 16777215;
         }
      }
      
      public static function setTextFieldColorWithLocalizedString(tf:TextField, source:String) : void
      {
         var lengths:Array = [];
         if(source.length == 0)
         {
            tf.text = source;
            return;
         }
         var colorArray:Array = source.match(/\^\d/g);
         if(colorArray.length == 0)
         {
            tf.text = source;
            return;
         }
         var strArray:Array = source.split(/\^\d/g);
         for(var i:int = 0; i < strArray.length; i++)
         {
            lengths.push(strArray[i].toString().length);
         }
         tf.text = strArray.join("");
         var start:int = 0;
         var textFormat:TextFormat = tf.getTextFormat();
         for(i = 0; i < lengths.length; i++)
         {
            if(i != 0 || source.indexOf(colorArray[0]) != 0)
            {
               textFormat.color = getColorCodeByColorString(colorArray[i - 1]);
               tf.setTextFormat(textFormat,start,start + lengths[i]);
            }
            start += lengths[i];
         }
      }
      
      public static function localizeTextField(tf:TextField, strID:String) : void
      {
         setTextFieldColorWithLocalizedString(tf,getLocalizationWithKeyBinding(strID));
      }
      
      public static function localizePlayerLevel(rawLevel:int) : String
      {
         var level:int = rawLevel % 100;
         var prestige:int = (rawLevel - level) / 100;
         if(prestige == 0)
         {
            return LocalizeUtil.param(DictCareer.CAREER_X_LEVEL,[String(level)]);
         }
         return LocalizeUtil.param(DictCareer.CAREER_X_PRESTIGE,[String(prestige),String(level)]);
      }
   }
}

