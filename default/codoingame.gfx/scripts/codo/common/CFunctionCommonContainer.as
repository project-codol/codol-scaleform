package codo.common
{
   import codo.cpp.UiCpp;
   import codo.cpp.UiCppOnboarding;
   import codo.objects.CallSignObj;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.OnboardingChecklistObj;
   import codo.objects.ProductObj;
   import codo.objects.TimeObj;
   import codo.objects.WarGodGlobalSettingObj;
   import flash.display.MovieClip;
   
   public class CFunctionCommonContainer
   {
      
      public static function PrintLog(msg:String, channel:int, level:int):void
      {
      }
      public static function FatalErrorPrintLog(msg:String):void
      {
      }
      public static function TencentSanitizeString(sanitizeObj:Object):void
      {
      }
      public static function TencentReportPlayer(playerId:String, checkedOptions:uint, msg:String):void
      {
      }
      public static function TencentReportBadLanguage(playerId:String, playerUserName:String, msg:String, history:Array):void
      {
      }
      public static function GetMemberInfoList():Array
      {
         return [];
      }
      public static function setdvar(name:String, value:String):void
      {
      }
      public static function As_markSettingChanged():void
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
      public static function StopSoundByFullName(soundName:String):void
      {
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
      public static function BuildWeaponBuffsTable():Object
      {
         return {};
      }
      public static function BuildCharBuffsTable():Object
      {
         return {};
      }
      public static function IsShipBuild():Boolean
      {
         return false;
      }
      public static function IsDevelopmentBuild():Boolean
      {
         return true;
      }
      public static function IsInRoom():Boolean
      {
         return true;
      }
      public static function IsLeavingRoom():Boolean
      {
         return true;
      }
      public static function LeaveRoom(withParty:Boolean, isUserInput:Boolean):void
      {
      }
      public static function IsInClan():Boolean
      {
         return true;
      }
      public static function GetClanInfo():Object
      {
         return null;
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
      public static function GetPlayerPrestige():int
      {
         return 0;
      }
      public static function GetPlayerLevel():uint
      {
         return 0;
      }
      public static function GetPlayerNextLevel():uint
      {
         return 0;
      }
      public static function GetPlayerMaxLevel():uint
      {
         return 70;
      }
      public static function GetPlayerMaxPrestige():int
      {
         return 1;
      }
      public static function GetPlayerCurrentLeague():uint
      {
         return 0;
      }
      public static function GetPlayerCallSignInfo():Object
      {
         return new CallSignObj();
      }
      public static function GetPlayerBadgeInfo():Array
      {
         return [];
      }
      public static function GetXpForRank(rank:uint, prestige:uint):int
      {
         return 0;
      }
      public static function GetTargetXpForRank(rank:uint, prestige:uint):int
      {
         return 0;
      }
      public static function GetXpForNextLevel():int
      {
         return 0;
      }
      public static function GetDisplayLevel(level:int):String
      {
         return "1";
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
      public static function FetchLobbySummary():Array
      {
         return [];
      }
      public static function FetchDailyChallenge():Object
      {
         return null;
      }
      public static function FetchWeeklyChallenge():Object
      {
         return null;
      }
      public static function GetWeeklyChallengeChecklist():OnboardingChecklistObj
      {
         return null;
      }
      public static function GetWeeklyChallengeBonus():Object
      {
         return {
            "xp":100,
            "gp":200
         };
      }
      public static function GetPinnedChallenge(idx:uint):ChallengeBaseObj
      {
         return null;
      }
      public static function PinChallenge(idx:uint, challenge:ChallengeBaseObj):void
      {
      }
      public static function GetOnboardingChecklist():Vector.<OnboardingChecklistObj>
      {
         return null;
      }
      public static function GetDailyChallengeChecklist():OnboardingChecklistObj
      {
         return null;
      }
      public static function GetShowOnboardingChecklist():Boolean
      {
         return false;
      }
      public static function ClaimOnboardingChecklistReward(index:int):void
      {
      }
      public static function AS_NeedUpdateGameSummary():void
      {
      }
      public static function CL_GetCurrentCharacterLoadoutIndex():int
      {
         return 0;
      }
      public static function CL_SetCurrentCharacterLoadoutIndex(index:int, faction:int):void
      {
      }
      public static function WL_GetCurrentWeaponLoadoutIndex():int
      {
         return 0;
      }
      public static function WL_SetCurrentWeaponLoadoutIndex(idx:int):void
      {
      }
      public static function WL_GetCharacterWeaponLoadouts(characterIdx:int, sync:Boolean = false, replaced:Boolean = false):Array
      {
         return [];
      }
      public static function WL_GetAsymWeaponUpgrades(characterIdx:int, loadoutIdx:int):Array
      {
         return [];
      }
      public static function WL_GetWeaponRank(weaponID:int):int
      {
         return 0;
      }
      public static function WL_GetMaxNumLoadouts():int
      {
         return 0;
      }
      public static function WL_GetIsLoadoutSlotUnlocked(loadoutindex:int):Boolean
      {
         return false;
      }
      public static function WL_GetMarketItemIdForLoadoutIndex(loadoutindex:int):int
      {
         return 0;
      }
      public static function WL_GetIsBadgeSlotUnlocked(badgeindex:int):Boolean
      {
         return false;
      }
      public static function WL_GetMarketItemIdForBadgeIndex(badgeindex:int):int
      {
         return 0;
      }
      public static function AS_SelectChampionByClassID(championClassID:uint):void
      {
      }
      public static function AS_GetZombieChampionForClassID(championClassID:uint):Object
      {
         return null;
      }
      public static function AS_GetSelectedChampionClassID():uint
      {
         return 0;
      }
      public static function ListForRealAllUnlockObj():Array
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
      public static function GetCyborgTokenCount():int
      {
         return 0;
      }
      public static function GetInventoryCount(item:String):int
      {
         return 0;
      }
      public static function GetItemInfo(id:int):ProductObj
      {
         return null;
      }
      public static function GetItemInfoBySku(id:int):ProductObj
      {
         return null;
      }
      public static function AS_SetupAndReturnMinSkus(product:ProductObj):Object
      {
         return null;
      }
      public static function GetItemBasicInfo(itemID:int):Object
      {
         return {
            "name":"na",
            "description":"desc",
            "imageURL":"url",
            "id":itemID
         };
      }
      public static function GetItemGroup(itemId:int):String
      {
         return "itemGroup";
      }
      public static function GetItemIDByName(itemName:String):int
      {
         return 0;
      }
      public static function GetBundleInfo(id:int):Object
      {
         return null;
      }
      public static function IsItemInInventory(id:int):Boolean
      {
         return false;
      }
      public static function AS_GetWeaponVariantList(baseWeapon:int, filter:uint, tierLimit:int):Array
      {
         return [];
      }
      public static function playvideo(name:String, loop:Boolean, forceFrameNum:int = -1):void
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
      public static function getvideostatus():int
      {
         return 0;
      }
      public static function AS_UIViewerSetMode(mode:uint, status:uint, gametype:uint):void
      {
      }
      public static function AS_UIViewerEnableTurntable(enable:Boolean):void
      {
      }
      public static function AS_UIViewerSetItemDetailsID(itemID:int):void
      {
      }
      public static function AS_IsNotified(notification:String):Boolean
      {
         return false;
      }
      public static function AS_SetNotified(notification:String):void
      {
      }
      public static function AS_GetStencilFlag(id:int):Boolean
      {
         return false;
      }
      public static function AS_SetStencilFlag(id:int):void
      {
      }
      public static function AS_ClearStencilFlag(id:uint):void
      {
      }
      public static function AS_IsNotificationUnlocked(notification:String):Boolean
      {
         return true;
      }
      public static function AS_GetNotificationUnlockLevel(notification:String):int
      {
         return 0;
      }
      public static function OnboardIntroDone():Boolean
      {
         return true;
      }
      public static function GetPlayerOnboardType():uint
      {
         return 0;
      }
      public static function GetOnboardUnlockLevel(sku:String):String
      {
         return null;
      }
      public static function GetDisabledOnboardHelp():Object
      {
         return {};
      }
      public static function GetBuildNumber():int
      {
         return 0;
      }
      public static function GetDWConnectionID():String
      {
         return "";
      }
      public static function GetDWConnectionTime():int
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
      public static function GetCurrentTime():Object
      {
         return {
            "hour":1,
            "min":1,
            "sec":1,
            "formatedTime":"2014-06-14 15:25:07"
         };
      }
      public static function IsQtEnabled():Boolean
      {
         return false;
      }
      public static function IsLogInQueueEnabled():Boolean
      {
         return false;
      }
      public static function GetLogInQueueInfo():Object
      {
         return null;
      }
      public static function GetPlayerPrivileges():Object
      {
         return null;
      }
      public static function GetPlayerPrivilegesByID(userName:String):Object
      {
         return null;
      }
      public static function SwitchFocusingTextField(value:Boolean):void
      {
      }
      public static function OpenWebPage(slotID:int, imageIndex:int, x:int, y:int, w:int, h:int):Object
      {
         return null;
      }
      public static function OpenWebPageCustom(url:String, x:int, y:int, w:int, h:int):Object
      {
         return null;
      }
      public static function CloseCurrentWebPage():void
      {
      }
      public static function IsWelcomePageShowed():Boolean
      {
         return true;
      }
      public static function IsUrlValid(slotID:int, imageIndex:int):Boolean
      {
         return false;
      }
      public static function GetAdInfoReady():Boolean
      {
         return false;
      }
      public static function IsNFSDataReady():Boolean
      {
         return false;
      }
      public static function GetAdObjectCount(slotID:int):int
      {
         return 1;
      }
      public static function SetWebPageInputString(text:String):void
      {
      }
      public static function SetWebPageCompositionString(text:String):void
      {
      }
      public static function IsInInputField():Boolean
      {
         return false;
      }
      public static function IsAdImageDataReady(slotId:int, imageId:int):Boolean
      {
         return false;
      }
      public static function PreviousWebPage():void
      {
      }
      public static function NextWebPage():void
      {
      }
      public static function ReloadWebPage():void
      {
      }
      public static function DropDownMenuItemSelected(selectedIndex:int):void
      {
      }
      public static function WebPageMsgBoxClosed(buttonIndex:int):void
      {
      }
      public static function IsMarketplaceReady():Boolean
      {
         return false;
      }
      public static function IsMarketplaceInMaintain():Boolean
      {
         return false;
      }
      public static function AS_IsWhitelistTester():Boolean
      {
         return false;
      }
      public static function AS_IsESportSpectator():Boolean
      {
         return false;
      }
      public static function IsPlayerdataReady():Boolean
      {
         return false;
      }
      public static function IsRewardDataReady():Boolean
      {
         return false;
      }
      public static function IsInitialDataFetchPerformed():Boolean
      {
         return false;
      }
      public static function IsWeaponDataReady():Boolean
      {
         return false;
      }
      public static function IsChineseLanguage(clip:MovieClip = null):Boolean
      {
         return true;
      }
      public static function AS_GetMPGameType():String
      {
         return "";
      }
      public static function AS_GetGameTypeDisplayName(gameType:String = ""):String
      {
         return "";
      }
      public static function AS_IsGameTypeDisabled(id:String):Boolean
      {
         return false;
      }
      public static function AS_IsFFALobbyGameType(id:String):Boolean
      {
         return false;
      }
      public static function AS_GetDisabledMatchSelectOptions():String
      {
         return "";
      }
      public static function AS_GetCustomMapAvailableModes():String
      {
         return "";
      }
      public static function AS_CacheComScoreScreenBuffer(buffer:String):void
      {
      }
      public static function AS_RetreiveComScoreScreenBuffer():String
      {
         return "";
      }
      public static function AS_RegisterShoutcastUtil(clip:Object):void
      {
      }
      public static function Assert(b:Boolean, err:Error):void
      {
      }
      public static function IsInGame():Boolean
      {
         return false;
      }
      public static function MKT_RequestAccountInfo():void
      {
      }
      public static function GetMktUpdateState():int
      {
         return 0;
      }
      public static function IsMarketplaceItemOwned(itemID:uint):Boolean
      {
         return true;
      }
      public static function IsMarketplaceItemPurchasable(itemID:uint):Boolean
      {
         return true;
      }
      public static function AS_IsExpiredInventoryItem(itemid:int):Boolean
      {
         return false;
      }
      public static function GametypeUsesAsymRobots(gametype:String):Boolean
      {
         return false;
      }
      public static function AS_ClaimPunishTips():Array
      {
         return [];
      }
      public static function AS_RemovePunishTips(timeStamp:uint, rawReason:String, rawInfo:String):void
      {
      }
      public static function InitUiCpp(uiCpp:UiCpp, uiCppType:int):void
      {
      }
      public static function GetRecentStatistics():Object
      {
         return null;
      }
      public static function GetWeaponCategoryStatistics():Object
      {
         return null;
      }
      public static function GameMomentsPreInit():void
      {
      }
      public static function GameMomentsEditRecordedVideo(quit:Boolean):void
      {
      }
      public static function GameMomentsIsLastMatchRecorded():Boolean
      {
         return false;
      }
      public static function GameMomentsClearRecordedVideo():void
      {
      }
      public static function GetGameMomentsStatus():int
      {
         return 0;
      }
      public static function GetFormatTimeByTimeStamp(timeStamp:int):TimeObj
      {
         return null;
      }
      public static function GetServerTimeStamp():uint
      {
         return 0;
      }
      public static function AS_GetWarGodGlobalSetting():WarGodGlobalSettingObj
      {
         return null;
      }
      public static function IsWargodMatch():Boolean
      {
         return false;
      }
      public static function AS_GetJoinableZones():int
      {
         return 0;
      }
      public static function AS_IsInCrossZone():Boolean
      {
         return false;
      }
      public static function AS_GetClashSubMode():uint
      {
         return 0;
      }
      public static function AS_GetMinEnglishNameCharacterCount():uint
      {
         return 2;
      }
      public static function AS_GetMaxEnglishNameCharacterCount():uint
      {
         return 15;
      }
      public static function AS_IsEnoughSpyKarma():Boolean
      {
         return false;
      }
      public static function AS_SetQtEngineConfigVolume(volume:Number, microPhoneVolume:Number):void
      {
      }
      public static function AS_GetIsPrimaryWeapon(id:int):Boolean
      {
         return false;
      }
      public static function AS_GetItemDurationFromBundle(itemID:int, productID:int):int
      {
         return 0;
      }
      public static function AS_GetItemQuantityFromBundle(itemID:int, productID:int):int
      {
         return 0;
      }
      public static function AS_GetEquippedEmote(index:int):int
      {
         return 0;
      }
      public static function AS_GetPveSetInfo(id:int, group:String):Object
      {
         return null;
      }
      public static function AS_GetTierDivisionStarFromScore(score:int):Object
      {
         return null;
      }
      public static function AS_GVoice_GetRoomMembers():Array
      {
         return null;
      }
      public static function AS_GVoice_GetSpeakerVolume():int
      {
         return 0;
      }
      public static function AS_GVoice_SetSpeakerVolume(volume:int):void
      {
      }
      public static function AS_GVoice_GetMicrophoneVolume():int
      {
         return 0;
      }
      public static function AS_GVoice_SetMicrophoneVolume(volume:int):void
      {
      }
      public static function AS_GVoice_ForbidMemberVoice(memberId:int, forbidden:Boolean):void
      {
      }
      public static function AS_GVoice_GetBatteryValue():int
      {
         return 0;
      }
      public static function AS_GVoice_ShouldShowChatPanel():Boolean
      {
         return false;
      }
      public function CFunctionCommonContainer()
      {
         super();
      }
      
      public static function SupplyDropsEnabled() : Boolean
      {
         return Dvar_GetBool("ui_enable_supply_drops") as Boolean;
      }
      
      public static function SupplyDropHideFeatureItemProgress() : Boolean
      {
         return Dvar_GetBool("ui_hide_supply_drop_progress") as Boolean;
      }
      
      public static function CraftingEnabled() : Boolean
      {
         return Dvar_GetBool("ui_enable_crafting") as Boolean;
      }
      
      public static function TheaterEnabled() : Boolean
      {
         return Dvar_GetBool("cl_demo_enabled") as Boolean;
      }
      
      public static function GetPlayerDataInt(prop:String, bSecureProfile:Boolean) : int
      {
         return parseInt(CFunctionCommonContainer.GetPlayerData([prop],bSecureProfile).toString());
      }
      
      public static function GetPlayerDataFloat(prop:String, bSecureProfile:Boolean) : Number
      {
         return parseFloat(CFunctionCommonContainer.GetPlayerData([prop],bSecureProfile).toString());
      }
      
      public static function isLoadoutUsable(idx:int) : Boolean
      {
         var locked2:String = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_LOADOUT_2);
         if(locked2 != null)
         {
            return idx < 1;
         }
         var locked3:String = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_LOADOUT_3);
         if(locked3 != null)
         {
            return idx < 2;
         }
         return CFunctionCommonContainer.WL_GetIsLoadoutSlotUnlocked(idx) as Boolean;
      }
      
      public static function GetReviveTokenID() : int
      {
         return GetItemIDByName("token");
      }
      
      public static function GetRampageTokenID() : int
      {
         return GetItemIDByName("rampage_token");
      }
   }
}

