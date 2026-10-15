package codo.common
{
   import codo.objects.BadgeObj;
   import codo.objects.CallSignObj;
   
   public class CFunctionContainerCommon
   {
      
      public static function PrintLog(msg:String, channel:int, level:int):void
      {
      }
      public static function setdvar(name:String, value:String):void
      {
      }
      public static function ForceCollectGarbage():void
      {
      }
      public static function Dvar_GetBool(varName:String):Boolean
      {
         return false;
      }
      public static function Dvar_GetInt(varName:String):int
      {
         return 0;
      }
      public static function Dvar_GetFloat(varName:String):Number
      {
         return 0;
      }
      public static function Dvar_GetString(varName:String):String
      {
         return "";
      }
      public static function Dvar_GetEnumLength(varName:String):Number
      {
         return -1;
      }
      public static function Dvar_GetEnumValue(varName:String, valueIndex:Number):String
      {
         return null;
      }
      public static function execnow(cmd:String):void
      {
      }
      public static function SetUIBlur(num:Number):void
      {
      }
      public static function ScriptMenuResponse(menu:String, response:String):void
      {
      }
      public static function ScriptMenuResponseReady():Boolean
      {
         return true;
      }
      public static function playsound(soundName:String):void
      {
      }
      public static function stopsound():void
      {
      }
      public static function playmusic(musicName:String, ambName:String):void
      {
      }
      public static function stopmusic():void
      {
      }
      public static function PlaySoundByFullName(prioritizedNameList:Array, soundFlag:int):Boolean
      {
         return false;
      }
      public static function StringTableLookup(fileName:String, comparisonColumn:int, searchValue:String, targetColumn:int):String
      {
         return "";
      }
      public static function StringTableLookupByRow(fileName:String, searchRow:int, returnValueColumn:int):String
      {
         return "";
      }
      public static function StringTableRowCount(fileName:String):int
      {
         return 0;
      }
      public static function StringTableColumnCount(fileName:String):int
      {
         return 0;
      }
      public static function StringTableLookupRowNumForValue(fileName:String, comparisonColumn:int, searchValue:String):int
      {
         return 0;
      }
      public static function SEH_StringEd_GetString(stringName:String):String
      {
         return stringName;
      }
      public static function IsShipBuild():Boolean
      {
         return false;
      }
      public static function IsDevelopmentBuild():Boolean
      {
         return true;
      }
      public static function GetTeamType():uint
      {
         return 0;
      }
      public static function IsInRoom():Boolean
      {
         return true;
      }
      public static function LeaveRoom(withParty:Boolean):void
      {
      }
      public static function IsInClan():Boolean
      {
         return true;
      }
      public static function GetPlayerName():Object
      {
         return {"name":""};
      }
      public static function GetPlayerID():String
      {
         return "0";
      }
      public static function GetPlayerXP():int
      {
         return 0;
      }
      public static function GetPlayerRank():uint
      {
         return 0;
      }
      public static function GetPlayerMaxRank():uint
      {
         return 70;
      }
      public static function GetPlayerCurrentLeague():uint
      {
         return 0;
      }
      public static function GetPlayerCallSignInfo():Object
      {
         return new CallSignObj();
      }
      public static function GetPlayerBadgeInfo():Object
      {
         return new BadgeObj();
      }
      public static function GetXpForRank(rank:uint):int
      {
         return 0;
      }
      public static function GetPlayerData(arr:Array, bSecureProfile:Boolean):*
      {
         return "";
      }
      public static function GetPlayerStatus():int
      {
         return 0;
      }
      public static function RotateModel(dx:int, dy:int):void
      {
      }
      public static function FetchServerMessage():void
      {
      }
      public static function Base64Encode(original:String):String
      {
         return "";
      }
      public static function Base64Decode(encoded:String):String
      {
         return "";
      }
      public static function SetCursorType(cursorType:int):void
      {
      }
      public static function FetchGameSummary():Object
      {
         return null;
      }
      public static function FetchLobbySummary():Object
      {
         return null;
      }
      public static function AS_NeedUpdateGameSummary():void
      {
      }
      public static function ListAllUnlockObj():Array
      {
         return [];
      }
      public static function AS_RequestWeaponLoadout(index:int):Object
      {
         return null;
      }
      public static function WL_GetUnlockedLoadoutNum():int
      {
         return 0;
      }
      public static function WL_GetWeaponCareerInfoAtLevel(id:int, level:int):Array
      {
         return [];
      }
      public static function AS_GetItemInfo(id:int):Object
      {
         return null;
      }
      public static function AS_GetBasicItemInfo(itemID:int):Object
      {
         return null;
      }
      public static function playvideo(name:String, loop:Boolean):void
      {
      }
      public static function pausevideo():void
      {
      }
      public static function resumevideo():void
      {
      }
      public static function stopvideo():void
      {
      }
      public static function isvideoplaying():Boolean
      {
         return false;
      }
      public static function isvideopaused():Boolean
      {
         return false;
      }
      public static function getvideosize():Object
      {
         return null;
      }
      public static function isvideoready(name:String):Boolean
      {
         return false;
      }
      public static function AS_UIViewerSetMode(mode:uint, status:uint, gametype:uint):void
      {
      }
      public static function AS_IsItemLockInMode(itemName:String, gameType:String):Boolean
      {
         return false;
      }
      public static function AS_IsNotified(notification:String):Boolean
      {
         return false;
      }
      public static function AS_SetNotified(notification:String):void
      {
      }
      public static function AS_IsNotificationUnlocked(notification:String):Boolean
      {
         return false;
      }
      public static function AS_GetNotificationUnlockLevel(notification:String):int
      {
         return 0;
      }
      public static function AS_IsEventWeapon(weaponID:int):Boolean
      {
         return false;
      }
      public static function MapKey(keyNum:int):uint
      {
         return 0;
      }
      public static function GetKeyBindingValuesFromCommand(command:String):Array
      {
         return [];
      }
      public static function GetKeyBindingNamesFromCommand(command:String):Array
      {
         return [];
      }
      public static function GetKeyBindingCountFromCommand(command:String):uint
      {
         return 1;
      }
      public static function SetKeyBindingForCommand(keyNum:uint, command:String):void
      {
      }
      public static function ClearKeyBindingForCommand(command:String):void
      {
      }
      public function CFunctionContainerCommon()
      {
         super();
      }
   }
}

