package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.SanitizedType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.SystemMsgObj;
   import codo.services.WeaponLoadoutService;
   import codo.utils.InventoryUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   
   public class WeaponLoadOutController extends BaseController
   {
      
      private static const LOADOUT_PRIMARY_SLOT:int = 0;
      
      private static const LOADOUT_SECONDARY_SLOT:int = 1;
      
      private static const LOADOUT_MELEE_SLOT:int = 2;
      
      private static const WAT_SLOT_FUNC1:int = 0;
      
      private static const WAT_SLOT_FUNC2:int = 1;
      
      private static const WAT_SLOT_FUNC3:int = 2;
      
      private static const WAT_SLOT_CAM:int = 3;
      
      private static const WAT_SLOT_COSM1:int = 4;
      
      private static const WAT_SLOT_COSM2:int = 5;
      
      private var _currentWeaponLoadoutType:uint = 0;
      
      private var _currentWeaponLoadoutIndex:uint = 0;
      
      private var _unlockedMPLoadoutAmount:int = -1;
      
      private var _isSelectedSlotPrimary:Boolean = true;
      
      private var _isSelectedSlotMelee:Boolean = false;
      
      private var _currentChangedNameLoadoutIndex:uint;
      
      private var _selectedWildcardSlotIdx:int = 0;
      
      private var _bEditingExtraSlot:Boolean = false;
      
      private var _bEditingTacticianSlot:Boolean = false;
      
      public function WeaponLoadOutController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         listen(BCEvent.WEAPON3D_ROTATION_CHANGE,this.onChangeWeapon3DRotationHandle);
         addDP(DataID.CURRENT_WEAPON_LOADOUT_INDEX,this.currentWeaponLoadoutIndex);
         addDP(DataID.WEAPON_LOADOUT_MP_UNLOCKED_AMOUNT,this.getWeaponMPLoadoutUnlockAmount);
         listen(BCEvent.EVT_WEAPONLOADOUT_CHANGED,this.onWeaponLoadoutChangeHandle);
         listen(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,this.onClickWeaponLoadoutSlot);
         listen(BCEvent.EVT_WEAPON_SLOT_SELECT,this.onWeaponLoadoutSlotSelected);
         listen(BCEvent.EVT_EQUIP,this.equipOrPreviewItem);
         listen(BCEvent.EVT_SET_DOUBLE_AMMO,this.setDoubleAmmo);
         listen(BCEvent.EVT_PREVIEW_REMOVE,this.removePreviewItem);
         listen(BCEvent.EVT_PREVIEW_REMOVE_ALL,this.removeAllPreviewItems);
         listen(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_SLOT,this.unequipSlot);
         listen(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,this.unequipItem);
         listen(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_WEAPON,this.unequipWeapon);
         listen(BCEvent.GOTO_FIRST_PAGE,this.onInitWeaponLoadout);
         listen(BCEvent.EVT_REFRESH_WEAPONLOADOUT_AND_LIST,this.onRefreshWeaponLoadoutSlotsAndList);
         listen(BCEvent.EVT_SHOW_KILLSTREAK_SWAP,this.onGoToKillstreakSwapPopup);
         listen(BCEvent.EVT_SHOW_KILLSTREAK_SELECT_SWAP,this.onGoToKillstreakSelectSwapPopup);
         listen(BCEvent.EVT_CONFIRM_KILLSTREAK_SWAP,this.onConfirmKillstreakSwapPopup);
         listen(BCEvent.EVT_CANCEL_KILLSTREAK_SWAP,this.onCancelKillstreakSwapPopup);
         this.listen(BCEvent.EVT_SET_LOADOUT_NAME,this.onSetLoadoutNameHandle);
         this.listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onSanitizedFeedbackHandle);
         listen(BCEvent.EVT_SET_WILDCARD_SLOT_IDX,this.onSetWildcardSlotIdxHandle);
         listen(BCEvent.EVT_SET_EDITING_EXTRA_SLOT,this.onSetEditingExtraSlot);
         listen(BCEvent.EVT_SET_EDITING_TACTICIAN_SLOT,this.onSetEditingTacticianSlot);
      }
      
      public function cppInvalidateWeaponLoadout() : void
      {
         WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
      }
      
      public function cppShowKillstreakSwapPopup(equippedStreakID:int, newStreakID:int) : void
      {
         broadcast(BCEvent.EVT_SHOW_KILLSTREAK_SWAP,{
            "equippedStreakID":equippedStreakID,
            "newStreakID":newStreakID
         });
      }
      
      public function cppShowKillstreakSelectSwapPopup(newStreakID:int) : void
      {
         broadcast(BCEvent.EVT_SHOW_KILLSTREAK_SELECT_SWAP,{"newStreakID":newStreakID});
      }
      
      public function cppShowKillstreakConflict() : void
      {
         if(!getDP(DataID.IS_IN_ROOM))
         {
            broadcast(BCEvent.EVT_GOTO_LOADOUT_TAB,InventoryUtil.SCORESTREAKS_TAB);
         }
         var killstreakConflictMsgObj:SystemMsgObj = SystemMsgObj.getObj(Dict.KILLSTREAK_CONFLICT_NOTIFICATION,MsgBtnCount.ONE);
         broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,killstreakConflictMsgObj);
      }
      
      private function currentWeaponLoadoutIndex() : uint
      {
         return this._currentWeaponLoadoutIndex;
      }
      
      private function onWeaponLoadoutChangeHandle(cEvt:ParaEvent) : void
      {
         Logger.print("WeaponLoadoutController::onWeaponLoadoutChangeHandle");
         if(cEvt.myPara.index != null)
         {
            this._currentWeaponLoadoutIndex = cEvt.myPara.index;
            request(DataID.WEAPONLOADOUT_CHANGE,{
               "id":this._currentWeaponLoadoutIndex,
               "type":this._currentWeaponLoadoutType
            });
         }
      }
      
      private function onSetLoadoutNameHandle(cEvt:ParaEvent) : void
      {
         this._currentChangedNameLoadoutIndex = cEvt.myPara.index;
         this.broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
            "type":SanitizedType.LOADOUT_NAME,
            "content":cEvt.myPara.name
         });
      }
      
      private function onSetWildcardSlotIdxHandle(cEvt:ParaEvent) : void
      {
         var slotIdx:int = cEvt.myPara;
         this._selectedWildcardSlotIdx = slotIdx >= 0 && slotIdx < 3 ? slotIdx : 0;
      }
      
      private function onSetEditingExtraSlot(cEvt:ParaEvent) : void
      {
         this._bEditingExtraSlot = cEvt.myPara;
      }
      
      private function onSetEditingTacticianSlot(cEvt:ParaEvent) : void
      {
         this._bEditingTacticianSlot = cEvt.myPara;
      }
      
      private function onInitWeaponLoadout(cEvt:ParaEvent) : void
      {
         WeaponLoadoutService.getInstance().invalidateCurrentWeaponLoadout();
      }
      
      private function getWeaponMPLoadoutUnlockAmount() : int
      {
         if(this._unlockedMPLoadoutAmount == -1)
         {
            if(ScaleformUtil.isScaleform)
            {
               this._unlockedMPLoadoutAmount = CFunctionContainer.WL_GetUnlockedMPLoadoutNum();
            }
            else
            {
               this._unlockedMPLoadoutAmount = 5;
            }
         }
         return this._unlockedMPLoadoutAmount;
      }
      
      private function onClickWeaponLoadoutSlot(cEvt:ParaEvent) : void
      {
         var currentWeaponSlot:String = null;
         var weaponType:String = null;
         if(cEvt.myPara.nameid == null)
         {
            return;
         }
         var slotSplits:Array = cEvt.myPara.nameid.split("_");
         if(slotSplits.length == 2)
         {
            currentWeaponSlot = slotSplits[0];
            weaponType = slotSplits[1];
            this.changeWeaponType(weaponType);
            this.changeWeaponSlot(currentWeaponSlot);
         }
         else
         {
            currentWeaponSlot = cEvt.myPara.nameid;
            if(currentWeaponSlot == "primary" || currentWeaponSlot == "secondary")
            {
               this.changeWeaponType(currentWeaponSlot);
            }
            this.changeWeaponSlot(currentWeaponSlot);
         }
      }
      
      private function changeWeaponSlot(currentWeaponSlot:String) : void
      {
         Logger.print("WeaponLoadoutController::changeWeaponSlot:" + currentWeaponSlot);
         CFunctionContainer.WL_SetCurrentSlot(currentWeaponSlot,false);
      }
      
      private function changeWeaponType(weaponType:String) : void
      {
         var isPrimary:Boolean = false;
         if(weaponType == "primary")
         {
            isPrimary = true;
            CFunctionContainer.WL_SwitchWeaponCategory("primary");
         }
         else if(weaponType == "secondary")
         {
            isPrimary = false;
            CFunctionContainer.WL_SwitchWeaponCategory("secondary");
         }
      }
      
      private function onWeaponLoadoutSlotSelected(cEvt:ParaEvent) : void
      {
         this._isSelectedSlotPrimary = cEvt.myPara.isPrimary;
         this._isSelectedSlotMelee = cEvt.myPara.isMelee;
      }
      
      private function equipOrPreviewItem(cEvt:ParaEvent) : void
      {
         var itemObject:Object = cEvt.myPara.item;
         var isPreviewing:Boolean = Boolean(cEvt.myPara.isPreviewing) ? true : false;
         var isLoadoutView:Boolean = Boolean(cEvt.myPara.isLoadoutView) ? true : false;
         if(!this.canEquip(itemObject))
         {
            return;
         }
         this._equipOrPreviewItem(itemObject,isPreviewing,isLoadoutView);
         this.validateLoadout();
         if(!isPreviewing)
         {
            broadcast(BCEvent.EVT_EQUIPPED,itemObject);
         }
      }
      
      private function canEquip(itemObject:Object) : Boolean
      {
         var sysMessageObj:SystemMsgObj = null;
         var primaryWeapon:int = 0;
         var secondaryWeapon:int = 0;
         var cItemId:int = int(itemObject.id);
         if(cItemId == CFunctionCommonContainer.GetItemIDByName("wild_primary_gunfighter"))
         {
            primaryWeapon = CFunctionContainer.WL_GetWeaponInSlot(LOADOUT_PRIMARY_SLOT);
            if(primaryWeapon == 0)
            {
               sysMessageObj = SystemMsgObj.getObj(Dict.NO_PRIMARY_WEAPON_EQUIPPED,MsgBtnCount.ONE);
               broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,sysMessageObj);
               return false;
            }
            if(primaryWeapon == 0 || !CFunctionContainer.WL_GetWeaponAttachSlotIsLocked(primaryWeapon,LOADOUT_PRIMARY_SLOT,WAT_SLOT_FUNC3))
            {
               sysMessageObj = SystemMsgObj.getObj(Dict.PRIMARY_WEAPON_ALREADY_HAVE_3_ATTACHMENT_SLOTS,MsgBtnCount.ONE);
               broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,sysMessageObj);
               return false;
            }
         }
         if(cItemId == CFunctionCommonContainer.GetItemIDByName("wild_secondary_gunfighter"))
         {
            secondaryWeapon = CFunctionContainer.WL_GetWeaponInSlot(LOADOUT_SECONDARY_SLOT);
            if(secondaryWeapon == 0)
            {
               sysMessageObj = SystemMsgObj.getObj(Dict.NO_SECONDARY_WEAPON_EQUIPPED,MsgBtnCount.ONE);
               broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,sysMessageObj);
               return false;
            }
            if(secondaryWeapon == 0 || !CFunctionContainer.WL_GetWeaponAttachSlotIsLocked(secondaryWeapon,LOADOUT_SECONDARY_SLOT,WAT_SLOT_FUNC2))
            {
               sysMessageObj = SystemMsgObj.getObj(Dict.SECONDARY_WEAPON_ALREADY_HAVE_2_ATTACHMENT_SLOTS,MsgBtnCount.ONE);
               broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,sysMessageObj);
               return false;
            }
         }
         return true;
      }
      
      private function _equipOrPreviewItem(itemObject:Object, isPreviewing:Boolean, isLoadoutView:Boolean) : void
      {
         var cItemId:int = 0;
         var weaponType:int = 0;
         var weaponSlot:int = 0;
         cItemId = int(itemObject.id);
         switch(itemObject.type)
         {
            case ItemType.WEAPON:
               weaponType = CFunctionContainer.WL_GetWeaponType(cItemId);
               if(WeaponLoadoutService.getInstance().isOverkillEquipped() && (weaponType == LOADOUT_PRIMARY_SLOT || this._isSelectedSlotMelee) && !isPreviewing)
               {
                  weaponSlot = this._isSelectedSlotPrimary ? LOADOUT_PRIMARY_SLOT : LOADOUT_SECONDARY_SLOT;
                  if(this._isSelectedSlotMelee)
                  {
                     weaponSlot = LOADOUT_MELEE_SLOT;
                  }
                  WeaponLoadoutService.getInstance().currentWeaponID = cItemId;
                  CFunctionContainer.WL_EquipWeaponInSlot(cItemId,weaponSlot,isPreviewing);
               }
               else
               {
                  WeaponLoadoutService.getInstance().currentWeaponID = cItemId;
                  if(!this._isSelectedSlotMelee)
                  {
                     CFunctionContainer.WL_EquipWeaponInSlot(cItemId,weaponType,isPreviewing);
                  }
                  else
                  {
                     CFunctionContainer.WL_EquipWeaponInSlot(cItemId,LOADOUT_MELEE_SLOT,isPreviewing);
                  }
               }
               WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
               break;
            case ItemType.WAT:
               if(Boolean(itemObject.equippable) || isPreviewing)
               {
                  CFunctionContainer.WL_EquipWeaponAttachment(cItemId,isPreviewing,isLoadoutView);
                  WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
               }
               break;
            case ItemType.KIS:
            case ItemType.PER:
            case ItemType.EQU:
            case ItemType.DES:
               if(Boolean(itemObject.equippable))
               {
                  CFunctionContainer.WL_TryAbility(cItemId,this._bEditingExtraSlot,this._bEditingTacticianSlot);
                  WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
               }
               break;
            case ItemType.ITM:
               if(itemObject.group == MarketMenuData.GRP_WILDCARD)
               {
                  CFunctionContainer.WL_EquipWildcard(cItemId,this._selectedWildcardSlotIdx);
                  WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
               }
               break;
            case ItemType.BUNDLE:
               if(itemObject.group == MarketMenuData.GRP_LOADOUT_BUNDLE)
               {
                  CFunctionContainer.WL_EquipLoadoutBundleInSlot(cItemId);
                  WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
               }
         }
      }
      
      private function setDoubleAmmo(cEvt:ParaEvent) : void
      {
         var itemGroup:String = cEvt.myPara.group;
         var bEnable:Boolean = Boolean(cEvt.myPara.enable);
         CFunctionContainer.WL_SetDoubleAmmo(itemGroup,bEnable);
         WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
      }
      
      private function removePreviewItem(cEvt:ParaEvent) : void
      {
         var isPreviewing:Boolean = false;
         var itemObject:Object = cEvt.myPara.item;
         var cItemId:int = int(itemObject.id);
         switch(itemObject.type)
         {
            case ItemType.WEAPON:
               CFunctionContainer.WL_PreviewWeaponRemove(cItemId);
               WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
               break;
            case ItemType.WAT:
               isPreviewing = Boolean(cEvt.myPara.isPreviewing) ? true : false;
               CFunctionContainer.WL_PreviewAttachmentRemove(cItemId);
               WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
         }
         this.validateLoadout();
      }
      
      private function removeAllPreviewItems() : void
      {
         CFunctionContainer.WL_PreviewWeaponRemoveAll();
         WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
      }
      
      private function validateLoadout() : void
      {
         var secondaryWeapon:int = 0;
         var resultArray:Array = null;
         var hasValidItem:Boolean = false;
         var i:int = 0;
         var itemId:int = 0;
         if(!WeaponLoadoutService.getInstance().isOverkillEquipped())
         {
            secondaryWeapon = CFunctionContainer.WL_GetWeaponInSlot(LOADOUT_SECONDARY_SLOT);
            if(secondaryWeapon > 0)
            {
               if(CFunctionContainer.WL_GetWeaponType(secondaryWeapon) == LOADOUT_PRIMARY_SLOT)
               {
                  resultArray = CFunctionContainer.AS_GetItemList(MarketMenuData.SLOT_SECONDARY,Common.LIST_TYPE_INVENTORY,false,false);
                  hasValidItem = false;
                  if(resultArray != null && resultArray.length > 0)
                  {
                     for(i = 0; i < resultArray.length; i++)
                     {
                        if(!CFunctionCommonContainer.AS_IsExpiredInventoryItem(resultArray[i].id))
                        {
                           itemId = int(resultArray[i].id);
                           WeaponLoadoutService.getInstance().currentWeaponID = itemId;
                           CFunctionContainer.WL_EquipWeaponInSlot(itemId,LOADOUT_SECONDARY_SLOT,false);
                           WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
                           hasValidItem = true;
                           break;
                        }
                     }
                  }
                  if(hasValidItem == false)
                  {
                     Logger.print("Error: No valid secondary weapon to wear when call validateLoadout() in WeaponLoadOutController.as");
                  }
               }
            }
         }
      }
      
      public function onRefreshWeaponLoadoutSlotsAndList(cEvt:ParaEvent) : void
      {
         WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
      }
      
      private function onGoToKillstreakSwapPopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_KILLSTREAK_SWAP,cEvt.myPara);
      }
      
      private function onGoToKillstreakSelectSwapPopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_KILLSTREAK__SELECT_SWAP,cEvt.myPara);
      }
      
      private function onConfirmKillstreakSwapPopup(cEvt:ParaEvent) : void
      {
         CFunctionContainer.WL_ConfirmSwapKillstreaks();
         WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
         broadcast(BCEvent.LOBBY_REFRESH_INVENTORY);
         broadcast(BCEvent.EVT_EQUIPPED);
      }
      
      private function onCancelKillstreakSwapPopup(cEvt:ParaEvent) : void
      {
         closePopupPage(PageID.FSG_KILLSTREAKSWAP);
      }
      
      private function onChangeWeapon3DRotationHandle(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.RotateModel(int(cEvt.myPara.offsetX),int(cEvt.myPara.offsetY));
      }
      
      private function unequipSlot(cEvt:ParaEvent) : void
      {
         var isPreviewing:Boolean = false;
         var itemID:int = int(cEvt.myPara.slot.item_id);
         if(itemID > 0)
         {
            isPreviewing = Boolean(cEvt.myPara.isPreviewing) ? true : false;
            CFunctionContainer.WL_UnequipWeaponSlot(itemID,this._bEditingExtraSlot);
            WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
         }
      }
      
      private function unequipItem(cEvt:ParaEvent) : void
      {
         var itemID:int = 0;
         if(cEvt.myPara.data.id != null)
         {
            itemID = int(cEvt.myPara.data.id);
         }
         else
         {
            itemID = int(cEvt.myPara.data.item_id);
         }
         if(itemID > 0)
         {
            CFunctionContainer.WL_UnequipWeaponSlot(itemID,this._bEditingExtraSlot);
            WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
            broadcast(BCEvent.EVT_EQUIPPED,{});
         }
      }
      
      private function unequipWeapon(cEvt:ParaEvent) : void
      {
         var slotIdx:int = cEvt.myPara;
         if(slotIdx == LOADOUT_PRIMARY_SLOT || slotIdx == LOADOUT_SECONDARY_SLOT || slotIdx == LOADOUT_MELEE_SLOT)
         {
            CFunctionContainer.WL_UnequipWeapon(slotIdx);
            WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
            broadcast(BCEvent.EVT_EQUIPPED,{});
         }
      }
      
      private function onSanitizedFeedbackHandle(cEvt:ParaEvent) : void
      {
         var tempType:uint = uint(cEvt.myPara.type);
         var tempSanitized:Boolean = Boolean(cEvt.myPara.sanitized);
         var tempContent:String = cEvt.myPara.content;
         if(tempSanitized == false)
         {
            switch(tempType)
            {
               case SanitizedType.LOADOUT_NAME:
                  CFunctionContainer.WL_SetLoadoutName(this._currentChangedNameLoadoutIndex,tempContent);
                  this.broadcast(BCEvent.EVT_EXIT_RENAME_LOADOUT);
                  this.broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
            }
         }
      }
   }
}

