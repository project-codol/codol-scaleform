package codo.common
{
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.BattleCityLeagueInfoObj;
   import codo.objects.BattleCityLeagueMatchResultObj;
   import codo.objects.BattleCityLeaguePlayerObj;
   import codo.objects.CareerStatsObj;
   import codo.objects.ChatMessageObj;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.ClanSearchRequestObj;
   import codo.objects.FeaturedItemsObj;
   import codo.objects.ItemBanCategoryObj;
   import codo.objects.ItemBanObj;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.objects.MailObj;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.PlaylistCategoryObj;
   import codo.objects.RewardObjComplete;
   import codo.objects.RoomMemberObj;
   import codo.objects.SpyMatchResultObj;
   import codo.objects.SupplyDropDustInfoObj;
   import codo.objects.WarGodPendingPhasePlayerObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.objects.WeaponLoadoutObj;
   import codo.utils.ScaleformUtil;
   
   public dynamic class CFunctionContainer
   {
      
      public static var CL_UnequipItem:Function;
      
      public static var WL_EquipWeapon:Function;
      
      public static var WL_EquipWeaponInSlot:Function;
      
      public static var WL_UnequipWeaponSlot:Function;
      
      public static var WL_ConfirmSwapKillstreaks:Function;
      
      public static function IsPlayerStatsReady():Boolean
      {
         return ScaleformUtil.isScaleform ? false : true;
      }
      public static function SavePlayerStats():void
      {
      }
      public static function CL_EquipItem(id:int, isPreview:Boolean):void
      {
      }
      public static function CL_PreviewItemRemove(id:int):void
      {
      }
      public static function CL_EquipItemList(idList:Array, isPreview:Boolean):void
      {
      }
      public static function CL_EquipEmote(index:int, id:int):void
      {
      }
      public static function CL_PreviewItemListRemove(idList:Array):void
      {
      }
      public static function CL_PreviewItemRemoveAll():void
      {
      }
      public static function CL_PreviewEmote(itemName:String):void
      {
      }
      public static function CL_PlayAnimation(animType:uint, animScheduleFlags:uint):void
      {
      }
      public static function CL_CanItemBeEquippedByUIViewerCharacter(isBundle:Boolean, id:uint):Boolean
      {
         return true;
      }
      public static function CL_GetActiveCharacterLoadout():Object
      {
         return null;
      }
      public static function CL_SetDefaultCharacter(id:int):void
      {
      }
      public static function CL_SetCurrentCharacterID(id:int):void
      {
      }
      public static function CL_GetCurrentCharacterID():int
      {
         return 0;
      }
      public static function CL_GetCharacters(bInInventorySlot:Boolean):Array
      {
         return null;
      }
      public static function AS_CheckAvatarRefreshInTeam(faction:uint):void
      {
      }
      public static function CL_RefreshCurrentCharacter():void
      {
      }
      public static function CL_GetActiveCharacterDependency():Array
      {
         return null;
      }
      public static function CL_SetSlotCharacter(characterID:int, loadoutIndex:int):void
      {
      }
      public static function Callsign_HandleTryonItems():void
      {
      }
      public static function Callsign_TryonTitle(id:int):void
      {
      }
      public static function Callsign_GetActiveCallsignTitle():Object
      {
         return null;
      }
      public static function Callsign_TryonBackground(id:int):void
      {
      }
      public static function Callsign_GetActiveCallsignBackground():Object
      {
         return null;
      }
      public static function Callsign_TryonEmblem(id:int):void
      {
      }
      public static function Callsign_GetActiveCallsignEmblem():Object
      {
         return null;
      }
      public static function Callsign_TryonBadge(id:int, slot:int):void
      {
      }
      public static function Callsign_GetActiveCallsignBadge():Object
      {
         return null;
      }
      public static function Callsign_UnequipItem(id:int):void
      {
      }
      public static function Callsign_TryonNameplate(id:int):void
      {
      }
      public static function Callsign_TryonFrame(id:int):void
      {
      }
      public static function Callsign_TryonAdvancedConsumable(id:int):void
      {
      }
      public static function Callsign_UnequipAdvancedConsumable(id:int):void
      {
      }
      public static function Callsign_GetActiveAdvancedConsumable():int
      {
         return 0;
      }
      public static function UIViewer_SetFaction(faction:uint):void
      {
      }
      public static function AS_UIViewerSet3DSceneVisibility(visibility:Boolean):void
      {
      }
      public static function UIViewer_SetModelOffset(offset:int):void
      {
      }
      public static function WL_PreviewWeaponResetLoadoutSlot(index:int, slotName:String):void
      {
      }
      public static function WL_PreviewCombatKnife():void
      {
      }
      public static function WL_UnequipWeapon(slotIdx:int):void
      {
      }
      public static function WL_PreviewWeaponRemove(id:int):void
      {
      }
      public static function WL_PreviewAttachmentRemove(id:int):void
      {
      }
      public static function WL_EquipWeaponAttachment(itemID:int, isPreview:Boolean, isLoadoutView:Boolean):void
      {
      }
      public static function WL_PreviewWeaponRemoveAll():void
      {
      }
      public static function WL_ResetWeaponRotation():void
      {
      }
      public static function WL_GetUnlockedMPLoadoutNum():int
      {
         return 0;
      }
      public static function WL_CopyLoadoutFrom(copyFromCharacterIdx:int, copyFromLoadoutIdx:int):void
      {
      }
      public static function WL_GetLoadoutName(loadoutIndex:int, localIndex:int):String
      {
         return "";
      }
      public static function WL_SetLoadoutName(loadoutIndex:int, loadoutName:String):void
      {
      }
      public static function WL_GetCurrentSlot():String
      {
         return "";
      }
      public static function WL_SetCurrentSlot(nameid:String, bDeprecatedBool:Boolean):void
      {
      }
      public static function WL_SetCurrentType(nameid:String):void
      {
      }
      public static function WL_SwitchWeaponCategory(slot:String):void
      {
      }
      public static function WL_EquipLoadoutBundleInSlot(id:int):void
      {
      }
      public static function WL_GetWeaponType(weaponID:int):int
      {
         return -1;
      }
      public static function WL_GetWeaponInSlot(slotIdx:int):int
      {
         return -1;
      }
      public static function WL_GetCurrentWeaponID():int
      {
         return 0;
      }
      public static function WL_SetCurrentWeaponID(id:int):void
      {
      }
      public static function WL_GetWeaponCareerInfo(id:int):Array
      {
         return [];
      }
      public static function WL_GetModifiedWeaponStats(weaponID:int):Object
      {
         return null;
      }
      public static function WL_GetPreviewedWeaponStats(weaponID:int, attachmentID:int):Object
      {
         return null;
      }
      public static function WL_GetWeaponAttachSlotIsLocked(weaponID:int, weaponSlot:int, attachmentSlot:int):Boolean
      {
         return false;
      }
      public static function AS_SavePlayerProfile():void
      {
      }
      public static function AS_GetItemList(categoryid:String, filter:uint, inMarketDetails:Boolean, inMarketStorage:Boolean):Array
      {
         return [];
      }
      public static function AS_GetCloseToExpireItemList():Array
      {
         return null;
      }
      public static function AS_GetCharactersAbleToWearClothing(itemid:int, clothingFilter:uint, characterFilter:uint):Array
      {
         return null;
      }
      public static function AS_CanCharacterWearBundle(bundleID:int, charID:int):Boolean
      {
         return false;
      }
      public static function AS_GetBundleProductIDByCharacterAndPiece(charID:int, pieceItemID:int):int
      {
         return -1;
      }
      public static function AS_GetTimeInMillisecondsUntilNextBatchOfItemsExpire():int
      {
         return -1;
      }
      public static function AS_ScanForPromptingExpiration():void
      {
      }
      public static function AS_SetExpiryPopUpLastCheckedTimestamp(timestamp:uint):void
      {
      }
      public static function AS_IsExpiredInventoryProduct(productid:int):Boolean
      {
         return false;
      }
      public static function AS_UnequipItemByIDFromAllCharacterLoadouts(itemid:int):void
      {
      }
      public static function AS_UnequipAllExpiredUnpurchasableItem():void
      {
      }
      public static function AS_GetItemListByTag(filter:uint):Array
      {
         return [];
      }
      public static function WL_TryAbility(abilityid:int, inExtraSlot:Boolean, inTacticianSlot:Boolean):void
      {
      }
      public static function WL_EquipWildcard(itemID:int, slotIdx:int):void
      {
      }
      public static function WL_SetDoubleAmmo(itemGroup:String, enable:Boolean):void
      {
      }
      public static function WL_GetPick10LoadoutCount():int
      {
         return 0;
      }
      public static function WL_ResetClearedLoadoutFlag():Boolean
      {
         return false;
      }
      public static function MKT_BuyItem(skuid:int, num:int):void
      {
      }
      public static function MKT_BuyRecentExpiredItems(itemsSKUID:Array):void
      {
      }
      public static function MKT_AddToCart(skuid:int):Boolean
      {
         return false;
      }
      public static function MKT_RemoveFromCart(skuid:int, replaceid:int = 0):void
      {
      }
      public static function MKT_BuyCart(excludes:Array):void
      {
      }
      public static function MKT_GetCartItemList():Array
      {
         return null;
      }
      public static function MKT_ClearShoppingCart():void
      {
      }
      public static function MKT_UpdateInventory():void
      {
      }
      public static function MKT_PurchaseGift(skuID:int, targetUser:String, bNeedCheckID:Boolean):void
      {
      }
      public static function MKT_ClaimCoupon(couponID:String):void
      {
      }
      public static function MKT_ClaimCouponArray(couponIDArray:Array):void
      {
      }
      public static function MKT_TransferCoupon(couponID:String, targetUser:String, bNeedCheckID:Boolean):void
      {
      }
      public static function MKT_RedeemCoupon(couponID:String):void
      {
      }
      public static function MKT_RedeemCouponArray(couponIDArray:Array):void
      {
      }
      public static function MKT_RefreshPendingCoupon():Array
      {
         return null;
      }
      public static function MKT_RefreshCoupon():Array
      {
         return null;
      }
      public static function MKT_UpdateOnboardingPendingCoupon():Object
      {
         return null;
      }
      public static function MKT_GetRenewAllObject():void
      {
      }
      public static function MKT_GetFavoriteItems():Array
      {
         return [];
      }
      public static function MKT_SetFavoriteItems(items:Array):void
      {
      }
      public static function MKT_GetFeaturedItems(maxItemsPerCategory:uint):FeaturedItemsObj
      {
         return null;
      }
      public static function MKT_InvalidatePreviewList():void
      {
      }
      public static function AS_GetProductIDFromSKU(i:int):int
      {
         return -1;
      }
      public static function AS_GetDurationFromSKU(i:int):int
      {
         return -1;
      }
      public static function AS_GetItemIDsFromProduct(i:int):Array
      {
         return [];
      }
      public static function GetItemBanList(filter:uint, bannedOnly:Boolean):Vector.<ItemBanCategoryObj>
      {
         return null;
      }
      public static function GetItemBanEquippedList():Vector.<ItemBanObj>
      {
         return null;
      }
      public static function SetItemIsBanned(id:int, banned:Boolean):void
      {
      }
      public static function SetItemBansTemp():void
      {
      }
      public static function ResetItemBansToTemp():void
      {
      }
      public static function IsBundleProduct(id:int):Boolean
      {
         return false;
      }
      public static function IsPermanentOwnedProduct(id:int):Boolean
      {
         return false;
      }
      public static function GetItemQuantityByProductAndItemIndex(id:int, index:int):int
      {
         return 0;
      }
      public static function IsItemConsumable(id:int):Boolean
      {
         return false;
      }
      public static function AS_BuildWeaponBrandsFilterData():Array
      {
         return null;
      }
      public static function AS_GetWeaponBrandData(brandCategory:String):Object
      {
         return null;
      }
      public static function AS_GetWeaponBrandDataByWeaponID(weaponID:int):Object
      {
         return null;
      }
      public static function GetCheckinRewards():Vector.<MOTDCheckinRewardObj>
      {
         return null;
      }
      public static function GetCheckinRewardLastClaimed():int
      {
         return -1;
      }
      public static function SetCheckinRewardLastClaimed(index:int):void
      {
      }
      public static function AS_CreateUserName(userName:String):void
      {
      }
      public static function AS_IsFirstLogin():Boolean
      {
         return false;
      }
      public static function AS_AddCharacter(charID:int):void
      {
      }
      public static function HasCharacter():Boolean
      {
         return true;
      }
      public static function HaveZombieCharacter():Boolean
      {
         return true;
      }
      public static function AS_NeedQuestionnaire():Boolean
      {
         return false;
      }
      public static function AS_GetQuestionnaire():Array
      {
         return [];
      }
      public static function AS_ParseQuestionnaire():void
      {
      }
      public static function AS_ReplyQuestionnaire(reply:Array):void
      {
      }
      public static function AS_CloseQuestionnaire():void
      {
      }
      public static function AS_QuestionnaireClosed():Boolean
      {
         return false;
      }
      public static function AS_LoginSummaryViewed():Boolean
      {
         return false;
      }
      public static function AS_ShowLoginSummary():void
      {
      }
      public static function ListClan():void
      {
      }
      public static function CreateClan(name:String):void
      {
      }
      public static function InitClanProfile():void
      {
      }
      public static function RefreshClan():void
      {
      }
      public static function ForceRefreshClanInfo():void
      {
      }
      public static function RenameClan(newName:String):void
      {
      }
      public static function EditClanDescriptionAndRecruit(newMotto:String, state:int, level:int):void
      {
      }
      public static function EditClanAnnouncement(newMsg:String):void
      {
      }
      public static function EditClanTags(tags:Array):void
      {
      }
      public static function LeaveClan(newOwner:String):void
      {
      }
      public static function PromoteClanMember(userID:String, type:uint):void
      {
      }
      public static function DemoteClanMember(userID:String):void
      {
      }
      public static function KickClanMember(userID:String):void
      {
      }
      public static function ProposeClanMembership(inviteeID:String):void
      {
      }
      public static function IsClanMembershipProposed(inviteeID:String):Boolean
      {
         return false;
      }
      public static function AcceptClanMembership(teamID:String):void
      {
      }
      public static function RejectClanMembership(teamID:String):void
      {
      }
      public static function FetchClanInfo():void
      {
      }
      public static function FetchClanEntitlement():void
      {
      }
      public static function ApplyToJoinClan(clanID:String):void
      {
      }
      public static function IsInClan():Boolean
      {
         return false;
      }
      public static function ApplyForClan(obj:Object):void
      {
      }
      public static function HaveClanInfo():Boolean
      {
         return false;
      }
      public static function CreateClanCoolDownComplete():Boolean
      {
         return true;
      }
      public static function ExistInApplicationList(userId:String):Boolean
      {
         return false;
      }
      public static function ExistInInvitationList(teamId:String):Boolean
      {
         return false;
      }
      public static function ClanStateChanged():void
      {
      }
      public static function CreateParty(partyObj:Object):void
      {
      }
      public static function LeaveParty():void
      {
      }
      public static function KickPartyMember(userID:String):void
      {
      }
      public static function PromotePartyMember(userID:String):void
      {
      }
      public static function SetPartyInfo(partyObj:Object):void
      {
      }
      public static function ProposePartyMembership(userID:String):void
      {
      }
      public static function AcceptPartyMembership(inviterID:String, ticketID:String):void
      {
      }
      public static function RejectPartyMembership(inviterID:String, ticketID:String):void
      {
      }
      public static function IsPartyHost():Boolean
      {
         return false;
      }
      public static function IsInParty():Boolean
      {
         return false;
      }
      public static function RefreshParty():void
      {
      }
      public static function NotifyMyPartyInvitation(invitees:Array):void
      {
      }
      public static function IsPartyMemberInRoom(userID:String):void
      {
      }
      public static function TencentClaimRewards():Array
      {
         return [];
      }
      public static function GetMarketMaintainInfo():Object
      {
         return null;
      }
      public static function TencentGetAASRecord():Object
      {
         return null;
      }
      public static function UILog(tag:int, arg:Array):void
      {
      }
      public static function JoinChannel(channelIndex:uint):void
      {
      }
      public static function JoinGlobalChannel():void
      {
      }
      public static function JoinBigSpeakerChannel():void
      {
      }
      public static function IsInGlobalChannel():Boolean
      {
         return false;
      }
      public static function IsInBigSpeakerChannel():Boolean
      {
         return false;
      }
      public static function ListRoom():void
      {
      }
      public static function IsRoomListTaskWorking():Boolean
      {
         return true;
      }
      public static function CreateRoom(roomObj:Object):void
      {
      }
      public static function JoinRoom(roomObj:Object, bTicket:Boolean, teamSpecified:int):void
      {
      }
      public static function StartMatch(obj:Object):void
      {
      }
      public static function StartMatchCountDown():void
      {
      }
      public static function SetReadyState(bReady:Boolean):void
      {
      }
      public static function GetReadyState():Boolean
      {
         return false;
      }
      public static function CheckTeamAvatar(team:int):void
      {
      }
      public static function ChangeTeam(team:uint):void
      {
      }
      public static function GetTeamType():uint
      {
         return 0;
      }
      public static function ChangeRoomInfo(changedInfo:Object, type:String):void
      {
      }
      public static function ChangeRoomOptions(changedInfo:Object):void
      {
      }
      public static function GetRoomInfo():Object
      {
         return {
            "playListID":0,
            "mapID":"mp_afghan",
            "modeID":""
         };
      }
      public static function GetFakeClientObjs(team:int, startIdx:uint):Vector.<RoomMemberObj>
      {
         return null;
      }
      public static function CancelList():Boolean
      {
         return false;
      }
      public static function RejectRoomMembership(inviterID:String):void
      {
      }
      public static function QuickMatch(matchFilter:Object = null):void
      {
      }
      public static function JumpGame(roomInfo:Object = null):void
      {
      }
      public static function GetServerTime():Object
      {
         return {"hour":0};
      }
      public static function SendGlobalChatBrokenTLog():void
      {
      }
      public static function SetStatsForRoom(careerStats:CareerStatsObj):void
      {
      }
      public static function QueryRoomTeammateStats(teammateID:String):void
      {
      }
      public static function SelectTeamMemberItemInPanel(id:String):void
      {
      }
      public static function MouseClicked3DAreaInLobby():void
      {
      }
      public static function GetMaxRoomNameLength():int
      {
         return 0;
      }
      public static function IsEverBeKickedByRoom(roomID:String):Boolean
      {
         return false;
      }
      public static function GetGroupCounts():void
      {
      }
      public static function IsPilot():Boolean
      {
         return true;
      }
      public static function SetPilot(isPilot:Boolean):void
      {
      }
      public static function VoteMap(voteType:int):void
      {
      }
      public static function SetFinalVoting(playlistEntry:int):void
      {
      }
      public static function IsLogOnLobby():Boolean
      {
         return true;
      }
      public static function IsRoomHost():Boolean
      {
         return true;
      }
      public static function EnableVoiceTalk(bEnable:Boolean):void
      {
      }
      public static function ListDedicatedServer():void
      {
      }
      public static function RefreshInRoom():void
      {
      }
      public static function MarketDataReceivedInRoom():void
      {
      }
      public static function IsRankedMatch():Boolean
      {
         return true;
      }
      public static function IsRoomFull():Boolean
      {
         return false;
      }
      public static function GetRankedMatchState():int
      {
         return 0;
      }
      public static function GetRoomDLCLevel():uint
      {
         return 0;
      }
      public static function ReserveChatChannel(channelID:int, targetName:String, targetID:String):void
      {
      }
      public static function RemoveReservedChatChannel(channelID:int, targetName:String, targetID:String):void
      {
      }
      public static function FetchReservedChatChannel():Array
      {
         return [];
      }
      public static function FetchReservedChatMessage(id:int):void
      {
      }
      public static function FetchReservedChatMessageAll():void
      {
      }
      public static function RequireRecentmetData():void
      {
      }
      public static function SendChatMessage(msgObj:ChatMessageObj):void
      {
      }
      public static function SendLoudSpeaker(type:int, message:String):void
      {
      }
      public static function ReserveChatMessage(msgObj:ChatMessageObj):void
      {
      }
      public static function GetSubscribedChatGroup():int
      {
         return -1;
      }
      public static function SendTeamInstantMessage(msgObj:Object):void
      {
      }
      public static function SendGlobalInstantMessage(msgObj:Object):void
      {
      }
      public static function AS_MessageSetRead(id:uint):void
      {
      }
      public static function AS_MessageSetReadBatch(id:Array):void
      {
      }
      public static function AS_MessageSetAlerted(id:uint):void
      {
      }
      public static function AS_MessageDelete(id:uint):void
      {
      }
      public static function AS_MessageAccept(id:uint):void
      {
      }
      public static function AS_MessageReject(id:uint):void
      {
      }
      public static function AS_MessageActiveFetch():void
      {
      }
      public static function SendMail(mail:MailObj):void
      {
      }
      public static function FetchMailHeaders(startIndex:uint):void
      {
      }
      public static function FetchMailBodies(mailIDs:Array):void
      {
      }
      public static function DeleteMails(mails:Array):void
      {
      }
      public static function ReadMail(mailID:String):void
      {
      }
      public static function FetchClanMailHeaders(startIndex:uint):void
      {
      }
      public static function DeleteClanMails(mails:Array):void
      {
      }
      public static function GetAndClearMailPendingFlag(flag:Boolean):Boolean
      {
         return true;
      }
      public static function EnableRoomListEvent(enable:Boolean):void
      {
      }
      public static function EnableInRoomEvent(enable:Boolean):void
      {
      }
      public static function ListContact(type:uint):void
      {
      }
      public static function ListFriendProposal(type:uint):void
      {
      }
      public static function AddFriendByName(name:String):void
      {
      }
      public static function AddFriendByID(id:String):void
      {
      }
      public static function RemoveFriend(id:String):void
      {
      }
      public static function RemoveRecentmet(id:String):void
      {
      }
      public static function AcceptFriendProposal(id:String):void
      {
      }
      public static function RejectFriendProposal(id:String):void
      {
      }
      public static function WithdrawFriendshipProposal(id:String):void
      {
      }
      public static function GetMutInfo():Object
      {
         return false;
      }
      public static function ListBlackList():Array
      {
         return [];
      }
      public static function AddToBlackList(name:String, id:String):uint
      {
         return 0;
      }
      public static function RemoveFromBlackList(id:String):void
      {
      }
      public static function IsInBlackList(name:String):Boolean
      {
         return false;
      }
      public static function IsInBlackListByName(name:String):Boolean
      {
         return false;
      }
      public static function AS_GetPlayListCategoryByID(category:int):PlaylistCategoryObj
      {
         return null;
      }
      public static function GetPlayList():Array
      {
         return [];
      }
      public static function AS_PlayListUpdated():Boolean
      {
         return false;
      }
      public static function AS_PlayListValid(playlistID:int):Boolean
      {
         return false;
      }
      public static function AS_PlayListGetType(playlistID:int):int
      {
         return 0;
      }
      public static function AS_CanJoinStreakBreakLobby(playlistID:int):Boolean
      {
         return false;
      }
      public static function AS_GetStreakBreakHostPlaylistId(streakBreakId:int):int
      {
         return 0;
      }
      public static function AS_GetWarGodWarmRoundHostPlaylistId(wargodWarmRoundId:int):int
      {
         return 0;
      }
      public static function AS_EnablePublisherFilesUpdate(fileType:uint, bEnable:Boolean):void
      {
      }
      public static function AS_PublisherFileMarkAsOutOfDate(fileType:uint):void
      {
      }
      public static function AS_GetPlayListIdForNum(playlistNum:int):int
      {
         return 0;
      }
      public static function AS_GetPlayListNumForId(playlistId:int):int
      {
         return 0;
      }
      public static function AS_IsDMZGametype(gametype:String):Boolean
      {
         return false;
      }
      public static const PLAYLIST_GROUP_PVE:uint = 0;
      
      public static const PLAYLIST_GROUP_PVP:uint = 1;
      
      public static function GetPlayListCategories(group:uint):Array
      {
         return [];
      }
      public static function ListLeaderboard(data:Object):void
      {
      }
      public static function GetLeaderboardDefs():Array
      {
         return [];
      }
      public static function AS_GetRecentMatchStats():Array
      {
         return [];
      }
      public static function AS_GetScoreBoard_Main():Object
      {
         return null;
      }
      public static function AS_GetScoreBoard_MapType_Main():Object
      {
         return null;
      }
      public static function AS_GetObjectives_Main():Array
      {
         return null;
      }
      public static function AS_GetWeaponLevelup():Array
      {
         return null;
      }
      public static function AS_GetXPGPInfo():Array
      {
         return null;
      }
      public static function AS_GetXPGPScalerForPlaylist(playlistID:int):Array
      {
         return null;
      }
      public static function AS_GetRoundAward():Array
      {
         return null;
      }
      public static function AS_GetRandomRewards():Array
      {
         return null;
      }
      public static function AS_GetRewardsForModeAndMap(mode:String, mapName:String, getUniqueOnly:Boolean):Array
      {
         return [];
      }
      public static function AS_GetLevelRewards(prestige:int, level:int):Array
      {
         return null;
      }
      public static function AS_GetMatchChallengeRewards():Array
      {
         return null;
      }
      public static function AS_GetBattleCityBuddyInfo():Object
      {
         return null;
      }
      public static function AS_GetNextScoreForTier(tier:int, mode:String, map:String):String
      {
         return "";
      }
      public static function AS_GetScoresForMode(mode:Array):Array
      {
         return [];
      }
      public static function AS_GetScoresForCurrentMode():Array
      {
         return [];
      }
      public static function AS_GetChallengeStats(category:String):Array
      {
         return [];
      }
      public static function AS_GetVetAwardChallenges(numAwards:int):Array
      {
         return [];
      }
      public static function AS_GetDailyChallengeProgress():Number
      {
         return 0;
      }
      public static function AS_GetDailyChallengeSecondsLeft():uint
      {
         return 0;
      }
      public static function AS_GetQQPlayer(category:int, startIndex:int, numResult:int):void
      {
      }
      public static function AS_InviteQQFriend(qqIds:Array):void
      {
      }
      public static function FetchIsPlayerLeveledUp():Boolean
      {
         return false;
      }
      public static function DismissChallenge(challengeID:uint):void
      {
      }
      public static function FetchRecentChallenge(isCyborg:Boolean):void
      {
      }
      public static function GetNewUnlockedCoopStoryMaps(ufName:String):Array
      {
         return [];
      }
      public static function IsMapUnlockFlagNew(ufName:String):Boolean
      {
         return false;
      }
      public static function SetRecommendedSetting():void
      {
      }
      public static function SetTierSetting():void
      {
      }
      public static function SetVideoSetting():void
      {
      }
      public static function SetVoiceMicMute(enabled:Boolean):void
      {
      }
      public static function IsSubtitleToggled():Boolean
      {
         return false;
      }
      public static function ToggleSubtitle(enabled:Boolean):void
      {
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
      public static function ConvertPosUIToScreen(x:Number, y:Number):Object
      {
         return {
            "x":1,
            "y":1
         };
      }
      public static function GetRenderResolutions():Array
      {
         return [];
      }
      public static function GetDisplayResolution():Array
      {
         return null;
      }
      public static function CanRestartVideo():Boolean
      {
         return true;
      }
      public static function IsDoneLoading():Boolean
      {
         return true;
      }
      public static function ResetQLiveToolTipTime():void
      {
      }
      public static function GetExitPopupSelect():int
      {
         return 0;
      }
      public static function SetExitPopupSelect(select:int):void
      {
      }
      public static function AS_GetClientConnectionTime():Number
      {
         return 0;
      }
      public static function IsMapUnlocked(unlockFlag:String):Boolean
      {
         return false;
      }
      public static function IsFlagUnlocked(unlockFlag:String, rank:int):Boolean
      {
         return true;
      }
      public static function RemoveInvitation(id:uint):void
      {
      }
      public static function FetchPartyInvitation():void
      {
      }
      public static function IsTCLSLogOn():Boolean
      {
         return false;
      }
      public static function GetLockedMapsFromPublisher():Array
      {
         return [];
      }
      public static function MainMenuWillReload():void
      {
      }
      public static function GetCurrentDLCLevel():uint
      {
         return 0;
      }
      public static function GetHighResProgress():int
      {
         return 0;
      }
      public static function GetMaxDLCLevel():uint
      {
         return 1;
      }
      public static function IsFullClient():Boolean
      {
         return false;
      }
      public static function IsRealFullClient():Boolean
      {
         return false;
      }
      public static function GetMapDLCLevel(mapName:String):int
      {
         return 0;
      }
      public static function GetDLCDownloadProgress():Number
      {
         return 0.1;
      }
      public static function GetDLCDownloadRemainTime():Number
      {
         return 0.1;
      }
      public static function AS_InitialGameModeTLog(notification:String):void
      {
      }
      public static function AS_GetAARRandomRewardTier():int
      {
         return 0;
      }
      public static function AS_GetAARRandomRewardScore():int
      {
         return 0;
      }
      public static function AS_AARShouldShowRandomReward():Boolean
      {
         return false;
      }
      public static function AS_RedeemChangeName(newName:String):void
      {
      }
      public static function AS_NameChangeRestartLater():void
      {
      }
      public static function AS_RedeemStatReset():void
      {
      }
      public static function WL_FillInInventoryProductItems(weaponLoadoutObj:WeaponLoadoutObj):void
      {
      }
      public static function AS_IsItemEquipped(itemId:int, itemType:String):Boolean
      {
         return false;
      }
      public static function AS_GetExclusiveEquippedItem(id:int):Object
      {
         return null;
      }
      public static function AS_IsDependencyOwnedForItem(id:int):Boolean
      {
         return true;
      }
      public static function AS_IsDependencyOwnedForBundle(id:int):Boolean
      {
         return true;
      }
      public static function AS_IsDependencyRelation(id:int, parentId:int):Boolean
      {
         return true;
      }
      public static function AS_GetCharacterAttachmentDependencyInfo(id:int, isBundle:Boolean):Object
      {
         return null;
      }
      public static function SearchClan(request:ClanSearchRequestObj):void
      {
      }
      public static function IsClanApplicationEverSent(id:String):Boolean
      {
         return false;
      }
      public static function GetClanXpBoostPercentByType(type:int):Number
      {
         return 0;
      }
      public static function AS_GetPlayerInfoById(params:Array):void
      {
      }
      public static function CanShowClanTutorial():Boolean
      {
         return false;
      }
      public static function ClaimClanJoinReward():void
      {
      }
      public static function AS_GetSelfDetailInfo():Object
      {
         return null;
      }
      public static function GetClanGlobalConfigs():ClanGlobalConfig
      {
         return null;
      }
      public static function RedeemClanNameChangeToken(newName:String):void
      {
      }
      public static function GetRemainTimeClaimClanReward():int
      {
         return 0;
      }
      public static function ClaimClanDailyReward():void
      {
      }
      public static function GetCCPGatherStateForToday():Array
      {
         return null;
      }
      public static function AS_GetSupplyDropRewardProgress():Number
      {
         return 0;
      }
      public static function AS_GetSupplyDropRewardsEarned():int
      {
         return 0;
      }
      public static function AS_ConsumeSupplyDrop(supplyDropID:int, quantity:int):void
      {
      }
      public static function AS_GetSupplyDropSampleItems(supplyDropID:int):Array
      {
         return [];
      }
      public static function AS_GetSupplyDropFeaturedItems(supplyDropID:int):Array
      {
         return [];
      }
      public static function AS_SupplyDropFeaturedItemEnabled(supplyDropID:int):Boolean
      {
         return false;
      }
      public static function AS_GetSupplyDropFeaturedItemProgress(supplyDropID:int):Number
      {
         return 0;
      }
      public static function AS_IsSupplyDropForSale(supplyDropID:int):Boolean
      {
         return false;
      }
      public static function AS_GetSupplyDropDustExchangeRatio(supplyDropID:int):int
      {
         return 0;
      }
      public static function AS_IsSupplyDropMultipleConsumable(supplyDropID:int):Boolean
      {
         return false;
      }
      public static function AS_GetSupplyDropDustSku(supplyDropID:int):int
      {
         return 0;
      }
      public static function AS_GetSupplyDropDustInfo():SupplyDropDustInfoObj
      {
         return null;
      }
      public static function AS_ChangeASDPoints(delta:int):void
      {
      }
      public static function AS_ChangeBSDPoints(delta:int):void
      {
      }
      public static function AS_ChangeLSDPoints(delta:int):void
      {
      }
      public static function AS_RerollDailyChallenge(sequence:int, isPVP:Boolean, challengeID:int, rerollCount:int):void
      {
      }
      public static function AS_QueryPlayerBasicInfo(userIDsArray:Array):void
      {
      }
      public static function AS_UpdatePartialBasicInfo(data:Object):void
      {
      }
      public static function AS_GetHeadSeason():WarGodSeasonObj
      {
         return null;
      }
      public static function AS_GetWarGodPlayerData():WarGodPlayerObj
      {
         return null;
      }
      public static function AS_GetPlayerObjForMatchResult():Object
      {
         return null;
      }
      public static function AS_SendHeroicTierNotification():void
      {
      }
      public static function AS_SendWarGodMatchEndTLog():void
      {
      }
      public static function AS_GetSeasonBySeasonId(seasonId:int):WarGodSeasonObj
      {
         return null;
      }
      public static function AS_GetSeasonIDForLeaderBoardDisplay():int
      {
         return 0;
      }
      public static function AS_GetCreditRatingInfo():String
      {
         return "";
      }
      public static function AS_PickHowToStartNewSeason(option:int):void
      {
      }
      public static function AS_GetPendingPhasePlayerObj():WarGodPendingPhasePlayerObj
      {
         return null;
      }
      public static function AS_GetJuniorWarGodPlayList(isPlacementPlaylist:Boolean):Array
      {
         return null;
      }
      public static function AS_SetJuniorWarGodPlaylistSelection(data:Array):void
      {
      }
      public static function AS_SendTSSBlockTLog(userID:String, isParty:Boolean):void
      {
      }
      public static function AS_IsWarGodRoom():Boolean
      {
         return false;
      }
      public static function AS_GetPromotionScoreDetails():Array
      {
         return [];
      }
      public static function AS_GetPlayerScoreByRank(rank:PlayerWarGodRank):int
      {
         return 0;
      }
      public static function AS_GetWarGodZoneTopWebURL():String
      {
         return "";
      }
      public static function AS_IsPartyMemberWargodTierOffsetValid():Boolean
      {
         return true;
      }
      public static function AS_GetPlayerRankByScoreAndSeason(score:int, season:int):PlayerWarGodRank
      {
         return null;
      }
      public static function AS_IsLevelSatisfiedToWarGod():Boolean
      {
         return true;
      }
      public static function AS_IsWeaponSatisfiedToWarGod():Boolean
      {
         return true;
      }
      public static function AS_TryToUpdatePrimaryWeaponCountToPartyMember():void
      {
      }
      public static function AS_GetWarGodHistroySeason():void
      {
      }
      public static function AS_GetWarGod100thPlayerScore():int
      {
         return 0;
      }
      public static function AS_FetchWarGodCreditRatingScore():void
      {
      }
      public static function AS_BookThisIsWarGodMatch(playlistID:int):void
      {
      }
      public static function AS_ResetBookedWarGodRoom():void
      {
      }
      public static function AS_GetSpyModeMatchResult():SpyMatchResultObj
      {
         return null;
      }
      public static function AS_GetZhuntModeMatchResult():Array
      {
         return null;
      }
      public static function AS_GetTDModeMatchResult():Array
      {
         return null;
      }
      public static function AS_GetMOTDMessages():Array
      {
         return [];
      }
      public static function AS_GetMOTDCategoryMessages(category:int):Array
      {
         return [];
      }
      public static function AS_SetMOTDMessageViewed(messageId:int):void
      {
      }
      public static function AS_HaveUnviewedMOTDMessages():Boolean
      {
         return false;
      }
      public static function AS_RequestDownloadImage(name:String):void
      {
      }
      public static function AS_GetMOTDWelfarePageIndexByURL(url:String):int
      {
         return -1;
      }
      public static function AS_GetPlayerBattleCityStateByPlaylistID(playlistID:int):Object
      {
         return null;
      }
      public static function AS_GetGuaranteedBCUProgress():Array
      {
         return null;
      }
      public static function AS_GetBattleCityADProductsID(isLeague:Boolean):Array
      {
         return null;
      }
      public static function AS_GetDMZLeagueGlobalInfo():BattleCityLeagueGlobalObj
      {
         return null;
      }
      public static function AS_GetDMZLeaguePlayerInfo():BattleCityLeaguePlayerObj
      {
         return null;
      }
      public static function AS_GetDMZCurrentLeagueInfo():BattleCityLeagueInfoObj
      {
         return null;
      }
      public static function AS_TryBookDMZLeagueMatch(playlistID:int):void
      {
      }
      public static function AS_ResetBookedDMZLeagueMatch():void
      {
      }
      public static function AS_IsDMZLeagueMatch():Boolean
      {
         return false;
      }
      public static function AS_ResetBattleCityMatchTicketStatus():void
      {
      }
      public static function AS_GetDMZLeagueReward():RewardObjComplete
      {
         return null;
      }
      public static function AS_GetDMZLeagueMatchResult():BattleCityLeagueMatchResultObj
      {
         return null;
      }
      public static function AS_GetDMZLeagueTicketsBeforeMatch():Object
      {
         return null;
      }
      public static function AS_HasSuffcientDMZLeagueTicket():Boolean
      {
         return false;
      }
      public static function AS_IsHiddenRoomMatch():Boolean
      {
         return false;
      }
      public static function AS_GetPlayerStatePlaylistConfig():Array
      {
         return null;
      }
      public static function WL_EquipRecommendLoadout(items:Array):void
      {
      }
      public static function AS_HasHotRecommendedLoadout():Boolean
      {
         return false;
      }
      public static function AS_DatamoreReportPopup(taskId:int):void
      {
      }
      public static function AS_DatamoreClaimReward(taskId:int):void
      {
      }
      public static function AS_DatamoreInitPendingPopups():Array
      {
         return null;
      }
      public function CFunctionContainer()
      {
         super();
      }
      
      public static function isDLCLevelAvailable(level:int) : Boolean
      {
         if(!CFunctionContainer.IsFullClient() && level > 0)
         {
            return false;
         }
         return true;
      }
   }
}

