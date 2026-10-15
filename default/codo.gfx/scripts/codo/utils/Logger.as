package codo.utils
{
   import codo.objects.CustomObject;
   
   public class Logger
   {
      
      public static var CFUNCTION_COMMON:*;
      
      public static const INFO:int = 0;
      
      public static const WARNING:int = 1;
      
      public static const ERROR:int = 2;
      
      private static const TAG_FLASH:String = "[Flash log]";
      
      private static const TAG_JSON:String = "[json]";
      
      private static const TAG_UI_NAME:String = "[uiname]";
      
      private static const TAG_UI_PATH:String = "[uipath]";
      
      private static const TAG_UI_SOUND:String = "[playsound]";
      
      private static const TYPE_NONE:int = 0;
      
      private static const TYPE_ALL:int = 1;
      
      private static const TYPE_SF:int = 2;
      
      private static const TYPE_CPP:int = 3;
      
      private static const TYPE_AS:int = 4;
      
      private static const TYPE_AS_NORMAL:int = 5;
      
      private static const TYPE_JSON:int = 6;
      
      private static const TYPE_NAME:int = 7;
      
      private static const TYPE_PATH:int = 8;
      
      private static const TYPE_SOUND:int = 9;
      
      public static var LogType:int = TYPE_ALL;
      
      public static var IsShipBuild:Boolean = false;
      
      public static var PrintLog:Function = null;
      
      public function Logger()
      {
         super();
      }
      
      public static function init(type:int, shipBuild:Boolean, print:Function) : void
      {
         LogType = ScaleformUtil.getDebugType();
         IsShipBuild = shipBuild;
         PrintLog = print;
      }
      
      public static function print(... messages) : void
      {
         if(IsShipBuild)
         {
            return;
         }
         if(LogType == TYPE_NONE)
         {
            return;
         }
         var msg:String = "";
         for(var i:uint = 0; i < messages.length; i++)
         {
            msg += messages[i] + ", ";
         }
         msg = msg.substr(0,msg.length - 2) + "\n";
         if(PrintLog != null)
         {
            if(LogType != TYPE_ALL && LogType != TYPE_AS && LogType != TYPE_AS_NORMAL)
            {
               return;
            }
            if(msg.indexOf(TAG_JSON) != 0 && msg.indexOf(TAG_UI_NAME) != 0 && msg.indexOf(TAG_UI_PATH) != 0 && msg.indexOf(TAG_UI_SOUND) != 0)
            {
               msg = TAG_FLASH + msg;
            }
            PrintLog(msg,1,INFO);
         }
         else
         {
            trace(msg);
         }
      }
      
      public static function fatalErrorPrint(message:String) : void
      {
         if(ScaleformUtil.isScaleform)
         {
            CFUNCTION_COMMON.FatalErrorPrintLog("\n" + message + "\n");
         }
      }
      
      private static function objToString(cObj:Object, tabs:String = "") : String
      {
         var i:* = undefined;
         var type:String = null;
         if(cObj == null)
         {
            return "";
         }
         var objData:String = "";
         if(cObj is CustomObject)
         {
            objData = cObj.toString();
         }
         else
         {
            for(i in cObj)
            {
               type = typeof cObj[i];
               switch(type)
               {
                  case "object":
                     objData += tabs + i + ":\n";
                     objData += objToString(cObj[i],tabs + "\t");
                     break;
                  default:
                     objData += tabs + i + ": " + cObj[i] + "\n";
               }
            }
         }
         return objData;
      }
      
      public static function printObj(cObj:Object, prefix:String = "") : void
      {
         if(cObj == null)
         {
            return;
         }
         if(LogType == TYPE_ALL || LogType == TYPE_AS || LogType == TYPE_JSON)
         {
            Logger.print(prefix + objToString(cObj,""));
         }
      }
      
      public static function getObjUri(tObj:*) : String
      {
         var parent:Object = null;
         var target:Object = tObj;
         var objUri:String = tObj.name;
         while(target != null)
         {
            parent = target.parent;
            if(parent != null && parent != "null")
            {
               objUri = parent.name + "." + objUri;
            }
            target = parent;
         }
         return objUri;
      }
      
      public static function exportSoundFullName(cName:String) : void
      {
         if(cName != null && cName.length > 0)
         {
            if(LogType == TYPE_ALL || LogType == TYPE_AS || LogType == TYPE_SOUND)
            {
               Logger.print(TAG_UI_SOUND + cName);
            }
         }
      }
      
      public static function exportUIName(cName:String) : void
      {
         if(cName != null && cName.length > 0)
         {
            if(LogType == TYPE_ALL || LogType == TYPE_AS || LogType == TYPE_NAME)
            {
               Logger.print(TAG_UI_NAME + cName);
            }
         }
      }
      
      public static function exportFullPath(cPath:String) : void
      {
         if(cPath != null && cPath.length > 0)
         {
            if(LogType == TYPE_ALL || LogType == TYPE_AS || LogType == TYPE_PATH)
            {
               Logger.print(TAG_UI_PATH + cPath);
            }
         }
      }
   }
}

