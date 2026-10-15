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
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.CharacterObj;
   import codo.objects.RoomMemberObj;
   import codo.services.CharacterLoadoutService;
   import codo.services.WeaponLoadoutService;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import components.fsgpopups_part.FsgCharacterSwapViewContent;
   
   public class CharacterLoadOutController extends BaseController
   {
      
      private static const CHAR_DATA_STATE_NOT_INITIALIZED:int = 0;
      
      private static const CHAR_DATA_STATE_WAITING:int = 1;
      
      private static const CHAR_DATA_STATE_READY:int = 2;
      
      private static const MAX_EMOTE_SLOTS:int = 4;
      
      private var _currentCharacterItemID:int = 0;
      
      private var _deferCharLimitPopup:Boolean;
      
      private var _charLimitPopupDeferred:Boolean;
      
      private var _currentMainPageID:String;
      
      private var mCharacterDataState:int = 0;
      
      public function CharacterLoadOutController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,this.getCurrentCharacterID);
         listen(BCEvent.CHARACTER3D_ROTATION_CHANGE,this.onChangeCharacter3DRotationHandle);
         listen(BCEvent.EVT_CHARACTERLOADOUT_CHANGED,this.onCharacterLoadoutChangeHandle);
         listen(BCEvent.EVT_CHARACTERLOADOUT_UNEQUIP_ITEM_IN_SLOT,this.onUnequipSlotItem);
         listen(BCEvent.EVT_CHARACTERLOADOUT_UNEQUIP_ITEM_BY_ITEM,this.onUnequipItemByItem);
         listen(BCEvent.EVT_CHARACTERLOADOUT_FULL,this.onLoadoutFullHandle);
         listen(BCEvent.EVT_RECOMMENDED_LOADOUT_POPUP,this.onRecommendedLoadoutPopupHandle);
         listen(BCEvent.EVT_CHARACTERLOADOUT_SLOT_LOCKED,this.onLoadoutSlotLockedHandle);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChangeHandle);
         listen(BCEvent.EVT_DEFER_CHAR_LIMIT_POPUP,this.onDeferCharLimitPopup);
         listen(BCEvent.EVT_EQUIP,this.equipOrPreviewItem);
         listen(BCEvent.EVT_PREVIEW_REMOVE,this.removePreviewItem);
         listen(BCEvent.EVT_PREVIEW_REMOVE_ALL,this.removeAllPreviewItems);
         listen(BCEvent.EVT_SET_DEFAULT_CHARACTER,this.setDefaultCharacter);
         listen(BCEvent.EVT_RENAME_LOADOUT,this.onRenameLoadout);
         listen(BCEvent.EVT_EXIT_RENAME_LOADOUT,this.onExitRenameLoadout);
         listen(BCEvent.GOTO_FIRST_PAGE,this.initCharactersData);
         listen(BCEvent.EVT_GOTO_MANAGE_CHARACTER_ROSTER,this.onGotoManageRoster);
         bind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         bind(DataID.PUBLISHER_FILES_UPDATE,this.bind_dataReceived);
         this.mCharacterDataState = CHAR_DATA_STATE_NOT_INITIALIZED;
      }
      
      public function cppUnlockAllItems(unlock:Boolean) : void
      {
         CharacterLoadoutService.getInstance().unlockAllItems(unlock);
      }
      
      public function cppInvalidateCharacters() : void
      {
         CharacterLoadoutService.getInstance().updateCharacters();
      }
      
      private function onCharacterLoadoutChangeHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara != null)
         {
            this.selectCharacter(cEvt.myPara);
            this.setWeaponLoadoutWithCharacter(cEvt.myPara);
         }
      }
      
      protected function getCurrentCharacterID() : int
      {
         return this._currentCharacterItemID;
      }
      
      private function onLoadoutFullHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_ADV_POPUP_LOADOUT_FULL,cEvt.myPara);
      }
      
      private function onRecommendedLoadoutPopupHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_ADV_POPUP_RECOMMENDED_LOADOUT,cEvt.myPara);
      }
      
      private function onLoadoutSlotLockedHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_ADV_POPUP_SLOT_LOCKED,cEvt.myPara);
      }
      
      private function onGotoManageRoster(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_CHARACTER_ROSTER,cEvt.myPara);
      }
      
      private function onUnequipSlotItem(cEvt:ParaEvent) : void
      {
         this.unequipSlot(cEvt.myPara.slotObj);
         broadcast(BCEvent.EVT_EQUIPPED,{});
      }
      
      private function onUnequipItemByItem(cEvt:ParaEvent) : void
      {
         var i:int = 0;
         var _itemObject:Object = cEvt.myPara.data;
         if(_itemObject.type == ItemType.CAT || _itemObject.type == ItemType.CHA)
         {
            CFunctionContainer.CL_UnequipItem(int(_itemObject.id));
         }
         else if(_itemObject.group == MarketMenuData.GRP_OUTFIT)
         {
            for(i = 0; i < _itemObject.itemsList.length; i++)
            {
               CFunctionContainer.CL_UnequipItem(int(_itemObject.itemsList[i].id));
            }
         }
         else if(_itemObject.type == ItemType.ITM && _itemObject.group == MarketMenuData.GRP_EMOTE)
         {
            for(i = 0; i < MAX_EMOTE_SLOTS; i++)
            {
               if(CFunctionCommonContainer.AS_GetEquippedEmote(i) == _itemObject.id)
               {
                  CFunctionContainer.CL_EquipEmote(i,0);
                  break;
               }
            }
            broadcast(BCCommonEvent.EVT_REFRESH_EMOTE_SETTING_PANEL);
         }
         this.refreshCharacterLoadoutAndList();
         broadcast(BCEvent.EVT_EQUIPPED,{});
      }
      
      private function onInventoryChangeHandle(cEvt:ParaEvent) : void
      {
         if(this._currentMainPageID == PageID.INROOM)
         {
            this.UpdateCyborgTokenCount();
         }
         CharacterLoadoutService.getInstance().updateCharacters();
         this.safeRefreshCharacterLoadoutAndList(null);
         if(CharacterLoadoutService.getInstance().showExceededCharacterLimit())
         {
            if(this._deferCharLimitPopup)
            {
               this._charLimitPopupDeferred = true;
            }
            else
            {
               this.showCharLimitPopup();
            }
         }
      }
      
      private function onDeferCharLimitPopup(evt:ParaEvent) : void
      {
         this._deferCharLimitPopup = evt.myPara;
         if(!this._deferCharLimitPopup && this._charLimitPopupDeferred)
         {
            this._charLimitPopupDeferred = false;
            this.showCharLimitPopup();
         }
      }
      
      private function showCharLimitPopup() : void
      {
         CharacterLoadoutService.getInstance().resetShowExceededCharacterLimit();
         broadcast(BCEvent.EVT_SHOW_CHARACTER_SWAP,FsgCharacterSwapViewContent.POPUP_STATE_MAX_CHARACTERS_WARNING);
      }
      
      private function safeRefreshCharacterLoadoutAndList(cEvt:ParaEvent) : void
      {
         CharacterLoadoutService.getInstance().requestCharacterLoadout();
      }
      
      private function equipOrPreviewItem(cEvt:ParaEvent) : void
      {
         var itemIdList:Array = null;
         var itemID:* = undefined;
         var index:int = 0;
         var _itemObject:Object = cEvt.myPara.item;
         var isPreviewing:Boolean = Boolean(cEvt.myPara.isPreviewing) ? true : false;
         if(_itemObject.type == ItemType.CAT || _itemObject.type == ItemType.CHA)
         {
            if(_itemObject.type == ItemType.CHA && !isPreviewing && CharacterLoadoutService.getInstance().getTotalCharsOwned() > 12)
            {
               showMsg(Dict.CHARACTER_MAX_EQUIP_WARNING,MsgBtnCount.ONE);
               return;
            }
            CFunctionContainer.CL_EquipItem(int(_itemObject.id),isPreviewing);
            this.refreshCharacterLoadoutAndList();
         }
         else if(_itemObject.group == MarketMenuData.GRP_OUTFIT)
         {
            itemIdList = [];
            for each(itemID in _itemObject.itemsList)
            {
               itemIdList.push(int(itemID.id));
            }
            CFunctionContainer.CL_EquipItemList(itemIdList,isPreviewing);
            this.refreshCharacterLoadoutAndList();
         }
         else if(_itemObject.type == ItemType.ITM && _itemObject.group == "emo")
         {
            if(!isPreviewing)
            {
               index = 0;
               if(Boolean(cEvt.myPara.hasOwnProperty("index")))
               {
                  index = int(cEvt.myPara.index);
               }
               CFunctionContainer.CL_EquipEmote(index,int(_itemObject.id));
               broadcast(BCCommonEvent.EVT_REFRESH_EMOTE_SETTING_PANEL);
            }
            CFunctionContainer.CL_PreviewEmote(_itemObject.nameid);
         }
      }
      
      private function removePreviewItem(cEvt:ParaEvent) : void
      {
         var itemIdList:Array = null;
         var itemID:* = undefined;
         var _itemObject:Object = cEvt.myPara.item;
         if(_itemObject.type == ItemType.CAT)
         {
            CFunctionContainer.CL_PreviewItemRemove(int(_itemObject.id));
            this.refreshCharacterLoadoutAndList();
         }
         else if(_itemObject.type == ItemType.CHA)
         {
            this.removeAllPreviewItems();
         }
         else if(_itemObject.group == MarketMenuData.GRP_OUTFIT)
         {
            itemIdList = [];
            for each(itemID in _itemObject.itemsList)
            {
               itemIdList.push(int(itemID.id));
            }
            CFunctionContainer.CL_PreviewItemListRemove(itemIdList);
            this.refreshCharacterLoadoutAndList();
         }
      }
      
      private function removeAllPreviewItems() : void
      {
         CFunctionContainer.CL_PreviewItemRemoveAll();
         this.refreshCharacterLoadoutAndList();
      }
      
      private function setDefaultCharacter(cEvt:ParaEvent) : void
      {
         var prevID:int = 0;
         var character:CharacterObj = cEvt.myPara.character;
         Logger.printObj(character,"CharacterLoadOutController::setDefaultCharacter cEvt.myPara.character:\n");
         if(character != null)
         {
            prevID = this._currentCharacterItemID;
            this._currentCharacterItemID = character.id;
            CharacterLoadoutService.getInstance().setDefaultCharacterID(this._currentCharacterItemID);
            broadcast(BCEvent.EVT_EQUIP,{"item":character});
            if(prevID != this._currentCharacterItemID)
            {
               setBindData(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,this._currentCharacterItemID);
            }
         }
      }
      
      public function unequipSlot(cSlotObj:Object) : void
      {
         CFunctionContainer.CL_UnequipItem(int(cSlotObj.item_id));
         this.refreshCharacterLoadoutAndList();
      }
      
      private function refreshCharacterLoadoutAndList() : void
      {
         CharacterLoadoutService.getInstance().requestCharacterLoadout();
         CharacterLoadoutService.getInstance().updateCharacters();
      }
      
      private function onChangeCharacter3DRotationHandle(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.RotateModel(int(cEvt.myPara.offsetX),int(cEvt.myPara.offsetY));
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         if(Boolean(this.mCharacterDataState == CHAR_DATA_STATE_WAITING) && Boolean(CFunctionCommonContainer.IsMarketplaceReady()) && Boolean(CFunctionCommonContainer.IsPlayerdataReady()) && Boolean(CFunctionCommonContainer.IsRewardDataReady()))
         {
            this.initCharactersData(null);
            request(DataID.CHARACTERLOADOUT_CHARACTERS);
         }
      }
      
      private function initCharactersData(unused:ParaEvent) : void
      {
         var ready:Boolean = Boolean(CFunctionCommonContainer.IsPlayerdataReady()) && Boolean(CFunctionCommonContainer.IsMarketplaceReady()) && Boolean(CFunctionCommonContainer.IsRewardDataReady());
         if(ready)
         {
            this.mCharacterDataState = CHAR_DATA_STATE_READY;
            this.listOwnedCharacters();
            this.setCharacterLoadout(null);
            this.UpdateCyborgTokenCount();
         }
         else
         {
            Logger.print("CharacterLoadOutController:::initCharacterData delayed, player or market data not yet ready.");
            this.mCharacterDataState = CHAR_DATA_STATE_WAITING;
         }
      }
      
      private function listOwnedCharacters() : void
      {
         var tfCharacters:Vector.<CharacterObj> = CharacterLoadoutService.getInstance().getCharactersByType(Common.LOADOUT_TYPE_TF);
         var scCharacters:Vector.<CharacterObj> = CharacterLoadoutService.getInstance().getCharactersByType(Common.LOADOUT_TYPE_SC);
         var cyborgsCharacters:Vector.<CharacterObj> = CharacterLoadoutService.getInstance().getCharactersByType(Common.LOADOUT_TYPE_ZM);
         if(tfCharacters.length > 0)
         {
            setBindData(DataID.CHARACTERLOADOUT_CHARACTERS_TF,tfCharacters);
         }
         if(scCharacters.length > 0)
         {
            setBindData(DataID.CHARACTERLOADOUT_CHARACTERS_SC,scCharacters);
         }
         if(cyborgsCharacters.length > 0)
         {
            setBindData(DataID.CHARACTERLOADOUT_CHARACTERS_CYBORGS,cyborgsCharacters);
         }
      }
      
      private function setCharacterLoadout(unUsed:ParaEvent) : void
      {
         var roomMemberObj:RoomMemberObj = null;
         var faction:uint = Common.LOADOUT_TYPE_TF;
         if(Boolean(getDP(DataID.IS_CYBORG)))
         {
            faction = Common.LOADOUT_TYPE_ZM;
         }
         else
         {
            roomMemberObj = getDP(DataID.ROOM_MEMBER_OBJ,[getDP(DataID.PLAYER_USER_NAME)]);
            if(roomMemberObj != null)
            {
               faction = roomMemberObj.team;
            }
         }
         Logger.print("CharacterLoadOutController:::setCharacterLoadout faction: " + faction);
         var defaultCharacterObj:Object = CharacterLoadoutService.getInstance().getDefaultCharacter(faction);
         if(defaultCharacterObj != null)
         {
            this.selectCharacter(defaultCharacterObj);
            this.setWeaponLoadoutWithCharacter(defaultCharacterObj);
         }
      }
      
      private function setWeaponLoadoutWithCharacter(character:Object) : void
      {
         Logger.print("CharacterLoadoutController::setWeaponLoadoutWithCharacter");
         var loadoutIdx:int = int(character["loadoutIdx"]);
         broadcast(BCEvent.EVT_WEAPONLOADOUT_CHANGED,{"index":WeaponLoadoutService.getInstance().currentWeaponLoadoutIndex});
      }
      
      private function selectCharacter(characterObj:Object) : void
      {
         Logger.print("CharacterLoadoutController::selectCharacter");
         var prevID:int = this._currentCharacterItemID;
         this._currentCharacterItemID = characterObj.id;
         this.showSelectedCharacter();
         CharacterLoadoutService.getInstance().requestCharacterLoadout();
         if(prevID != this._currentCharacterItemID)
         {
            setBindData(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,this._currentCharacterItemID);
         }
      }
      
      public function showSelectedCharacter() : void
      {
         var faction:int = 0;
         if(ScaleformUtil.isScaleform)
         {
            CFunctionContainer.CL_EquipItem(this._currentCharacterItemID,false);
            faction = int(CharacterLoadoutService.getInstance().currentLoadoutType);
            CharacterLoadoutService.getInstance().changeFactionIdx(Math.max(0,faction));
         }
      }
      
      private function onRenameLoadout(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_ADV_RENAME_LOADOUT);
      }
      
      private function onExitRenameLoadout(cEvt:ParaEvent) : void
      {
         prevPage();
      }
      
      private function UpdateCyborgTokenCount() : void
      {
         setBindData(DataID.CYBORG_TOKEN,CFunctionCommonContainer.GetCyborgTokenCount());
      }
   }
}

