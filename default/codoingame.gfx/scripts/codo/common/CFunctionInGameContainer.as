package codo.common
{
   import codo.objects.ChatMessageObj;
   import codo.objects.SpyModeKillMapItemObj;
   import codo.objects.SpyModeSkillObj;
   import codo.objects.SpyQuickChatObj;
   import codo.objects.ZombieChampionAttrObj;
   import flash.display.MovieClip;
   
   public dynamic class CFunctionInGameContainer
   {
      
      public static function SendChatMessage(cMsgObj:ChatMessageObj):void
      {
      }
      public static function ReserveChatMessage(msgObj:ChatMessageObj):void
      {
      }
      public static function FetchReservedChatChannel():Array
      {
         return [];
      }
      public static function FetchReservedChatMessageAll():void
      {
      }
      public static function IsUIKeyCatcherBound():Boolean
      {
         return false;
      }
      public static function BindUIKeyCatcher(bind:Boolean):void
      {
      }
      public static function BindHudChatIME(bind:Boolean):void
      {
      }
      public static function AssignUIKeyCatcherToDotMenu():void
      {
      }
      public static function Dvar_GetBool(varName:String):Boolean
      {
         return false;
      }
      public static function GetMatchStatus():Object
      {
         return null;
      }
      public static function ShouldDrawHUD():Boolean
      {
         return true;
      }
      public static function GetGammaRange():Object
      {
         return {
            "min":0.5,
            "max":3,
            "val":0.9
         };
      }
      public static function GetSensitivityRange():Object
      {
         return {
            "min":0.01,
            "max":30,
            "val":5
         };
      }
      public static function GetFOVRange():Object
      {
         return {
            "min":65,
            "max":90,
            "val":80
         };
      }
      public static function AS_ShowShoutcastAndUpdateBypassMouseInput():Boolean
      {
         return false;
      }
      public static function GetDisplayResolution():Array
      {
         return null;
      }
      public static function GetTop3Players():Array
      {
         return null;
      }
      public static function GetSpyTop3Players():Array
      {
         return null;
      }
      public static function AS_IsFriendOnline(id:String):Boolean
      {
         return true;
      }
      public static function RequestRaisePauseMenu():void
      {
      }
      public static const HVT_Asym:uint = 0;
      
      public static const HVT_Clash:uint = 1;
      
      public static const HVT_Score:uint = 2;
      
      public static const HVT_SAR:uint = 3;
      
      public static const HVT_SAD:uint = 4;
      
      public static const HVT_ZArena:uint = 5;
      
      public static const HVT_PlayerCard:uint = 6;
      
      public static const HVT_Survival:uint = 7;
      
      public static const HVT_Spy:uint = 8;
      
      public static const HVT_PropHunt:uint = 9;
      
      public static const HVT_DMZ:uint = 10;
      
      public static const HVT_ZHunt:uint = 11;
      
      public static function AS_RegisterHUDView(type:uint, clip:MovieClip):void
      {
      }
      public static function AS_RegisterHUDPopupView(type:int, clip:MovieClip):int
      {
         return 0;
      }
      public static function AS_UnregisterHUDPopupView(index:int):void
      {
      }
      public static function AS_RegisterHUDComponent(type:int, clip:MovieClip):int
      {
         return 0;
      }
      public static function AS_UnregisterHUDComponent(type:int):void
      {
      }
      public static function AS_ZombieArenaHandleSelection(selection:int):void
      {
      }
      public static function AS_ZombieArenaGetMySkillInfo():Object
      {
         return null;
      }
      public static function AS_ZombieArenaGamblerRollComplete():void
      {
      }
      public static function AS_ZChampCloseAttributes(points:String):void
      {
      }
      public static function AS_ZChampGetAttributeInfo():Vector.<ZombieChampionAttrObj>
      {
         return new Vector.<ZombieChampionAttrObj>(0);
      }
      public static function AS_ZChampGetAttributeAllocations():Array
      {
         return [];
      }
      public static function AS_ZChampGetUpgrades():Array
      {
         return [];
      }
      public static function AS_ZChampGetBeacons():Array
      {
         return [];
      }
      public static function ToggleRecordVideo():void
      {
      }
      public static function IsZombieMPGametype(gametype:String):Boolean
      {
         return false;
      }
      public static function IsSpectator():Boolean
      {
         return false;
      }
      public static function AS_SpyMode_GetSelfRole():int
      {
         return 0;
      }
      public static function AS_SpyMode_GetSkillsByRole(role:int):Vector.<SpyModeSkillObj>
      {
         return new Vector.<SpyModeSkillObj>(0);
      }
      public static function AS_SpyMode_GetRoleInfo(role:int):Object
      {
         return null;
      }
      public static function AS_SpyCloseRoundStartup():void
      {
      }
      public static function AS_SpyCloseAutopsyReport():void
      {
      }
      public static function AS_SpyGetPlayerNameByClientNum(clientNum:int):String
      {
         return null;
      }
      public static function AS_SpyGetKillMap():Vector.<SpyModeKillMapItemObj>
      {
         return new Vector.<SpyModeKillMapItemObj>(0);
      }
      public static function AS_SpyCloseKarmaPunishHint():void
      {
      }
      public static function AS_SpyGetQuickChatInfo(role:int, cmd:int):SpyQuickChatObj
      {
         return null;
      }
      public static function AS_SpyHideQuickChatWheel():void
      {
      }
      public static function AS_SpyCheckQuickChatCoolDown(isGlobal:Boolean):Boolean
      {
         return false;
      }
      public static function AS_SpyGetMyRoundState():Object
      {
         return null;
      }
      public static function AS_SpyMode_GetPauseMenuTips():Array
      {
         return null;
      }
      public static function AS_SpyGetRoundsLeft():int
      {
         return 0;
      }
      public static function AS_Say2Team(message:String, teamType:int):void
      {
      }
      public static function AS_Say(message:String):void
      {
      }
      public static function AS_HostageGetChampionList(attacking:Boolean):Array
      {
         return [];
      }
      public static function AS_HostageGetRoundLimit():int
      {
         return 0;
      }
      public static function AS_GetWeaponIconByWeaponIndexAndKillMod(weaponIndex:int):String
      {
         return null;
      }
      public static function AS_SpyMode_GetRoundType():int
      {
         return 0;
      }
      public static function AS_SpyGetAirdropSkills():Array
      {
         return null;
      }
      public static function AS_SpyMode_HideSelectSkillPanel():void
      {
      }
      public static function AS_IsPropHuntMode():Boolean
      {
         return false;
      }
      public static function AS_IsPlayerDead():Boolean
      {
         return false;
      }
      public static function AS_DMZ_RefreshLoadout():void
      {
      }
      public static function AS_DMZ_GetItemByLootIndex(lootIndex:int):String
      {
         return null;
      }
      public static function AS_DMZ_GetTierByLootIndex(lootIndex:int):int
      {
         return 0;
      }
      public static function AS_DMZ_GetAttachmentInfo(attach:String):Object
      {
         return null;
      }
      public static function AS_DMZ_GetHealthPackInfo(healthPackIndex:int):Object
      {
         return null;
      }
      public static function AS_DMZ_CloseLoadoutView():void
      {
      }
      public static function AS_DMZ_IsAutoPickupEnabled():Boolean
      {
         return false;
      }
      public static function AS_DMZ_EnableAutoPickup(bEnable:Boolean):void
      {
      }
      public static function AS_DMZ_IsBuddyMode():Boolean
      {
         return false;
      }
      public static function AS_GetQuickChatInfo(channel:int):Object
      {
         return null;
      }
      public static function AS_HideQuickChatView():void
      {
      }
      public static function AS_ActionSlotDown(slot:int):void
      {
      }
      public static function AS_HUDComponentNotify(compIndex:int, msg:int, params:Object):Object
      {
         return null;
      }
      public static function AS_HUDPopupViewNotify(compIndex:int, msg:int, params:Object):Object
      {
         return null;
      }
      public static function AS_IsExecutingServerCommands():Boolean
      {
         return false;
      }
      public static function AS_GetZHuntHelpMenuInfo():Object
      {
         return null;
      }
      public static function AS_GetZHuntPauseMenuInfo():Object
      {
         return null;
      }
      public static function AS_GetZhuntLoadoutIndex():int
      {
         return 0;
      }
      public static function AS_RequestLeaveInGame():void
      {
      }
      public static function AS_GetTop3SelfCurrentWeaponHudIcon():String
      {
         return null;
      }
      public static function AS_GetTop3PlayerCurrentWeaponHudIcon(index:int):String
      {
         return null;
      }
      public static function AS_GetVIPSelectCharacterInfo(index:int):Object
      {
         return null;
      }
      public static function AS_VIPGetCurrentPlayerVIPSelectionIndex():int
      {
         return 0;
      }
      public static function AS_GetVoteReasonByVoteTypeAndReasonID(reason:int, voteType:int):String
      {
         return null;
      }
      public static function AS_GetVoteReasonListByVoteType(voteType:int):Array
      {
         return null;
      }
      public static function AS_GetVoteTypeInfo(voteType:int):Object
      {
         return null;
      }
      public static function AS_SendVoteRequestToDS(targetUserId:String, reason:int, message:String):void
      {
      }
      public static function AS_CurrentPlayerCanVote():Boolean
      {
         return false;
      }
      public static function AS_TD_GetLootItemInfo(lootItemIndex:int):Object
      {
         return null;
      }
      public static function AS_TD_GetItemPackageCount(lootItemIndex:int):int
      {
         return 0;
      }
      public static function AS_TD_GetItemInventoryCount(lootItemIndex:int):int
      {
         return 0;
      }
      public static function AS_TD_GetTurretList():Array
      {
         return null;
      }
      public static function AS_ToggleLoadoutMenu():void
      {
      }
      public function CFunctionInGameContainer()
      {
         super();
      }
   }
}

