package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.constants.MsgBtnCount;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppNewItems;
   import codo.localization.Dict;
   import codo.localization.DictInGame;
   import codo.localization.DictMarket;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.objects.SystemMsgObj;
   import codo.services.WeaponLoadoutService;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   
   public class LoadoutPanel extends LoadoutViewPanelBase
   {
      
      protected static const MAX_LOADOUT_SLOTS:int = 10;
      
      private const PRIMARY_LOADOUT_TAB_INDEX:int = 1;
      
      private const MELEE_LOADOUT_TAB_INDEX:int = 2;
      
      public var myPrimaryLoadoutTab:LoadoutSwitchTabButton;
      
      public var myMeleeLoadoutTab:LoadoutSwitchTabButton;
      
      public var myLoadout:LoadoutDisplay;
      
      public var myLoadoutMelee:LoadoutMeleeDisplay;
      
      public function LoadoutPanel()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         this.myPrimaryLoadoutTab.selected = true;
         this.myPrimaryLoadoutTab.label = DictMarket.ITEM_MENU_PRIMARY;
         this.myPrimaryLoadoutTab.index = this.PRIMARY_LOADOUT_TAB_INDEX;
         this.myPrimaryLoadoutTab.tabSelectedCallback = this.setSelectedTab;
         this.myPrimaryLoadoutTab.setBreadcrumb(UiCppNewItems.CRUMB_NONE_MELEES);
         this.myMeleeLoadoutTab.selected = false;
         this.myMeleeLoadoutTab.label = DictMarket.ITEM_MENU_MELEE;
         this.myMeleeLoadoutTab.index = this.MELEE_LOADOUT_TAB_INDEX;
         this.myMeleeLoadoutTab.tabSelectedCallback = this.setSelectedTab;
         this.myMeleeLoadoutTab.setBreadcrumb(UiCppNewItems.CRUMB_MELEES);
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_PICK_10_TUTORIAL_VISIBILITY,true);
         this.myLoadout.visible = true;
         this.myLoadoutMelee.visible = false;
         this.myLoadout.registerSelectPrimaryEvent(this.onPrimaryWeaponClicked,this.onPrimaryWeaponSlotCleared);
         this.myLoadout.registerEditPrimaryAttachmentEvent(this.onPrimaryAttachmentClicked,this.onPrimaryLoadoutButtonCleared);
         this.myLoadout.registerEditPrimaryReticleEvent(this.onEditPrimaryReticleClicked,this.onPrimaryLoadoutButtonCleared);
         this.myLoadout.registerEditPrimaryCamoEvent(this.onEditPrimaryCamoClicked,this.onPrimaryLoadoutButtonCleared);
         this.myLoadout.registerEditPrimaryDecalEvent(this.onEditPrimaryDecalClicked,this.onPrimaryLoadoutButtonCleared);
         this.myLoadout.registerSelectSecondaryEvent(this.onSecondaryWeaponClicked,this.onSecondaryWeaponSlotCleared);
         this.myLoadout.registerEditSecondaryAttachmentEvent(this.onSecondaryAttachmentClicked,this.onSecondaryLoadoutButtonCleared);
         this.myLoadout.registerEditSecondaryReticleEvent(this.onEditSecondaryReticleClicked,this.onSecondaryLoadoutButtonCleared);
         this.myLoadout.registerEditSecondaryCamoEvent(this.onEditSecondaryCamoClicked,this.onSecondaryLoadoutButtonCleared);
         this.myLoadout.registerEditSecondaryDecalEvent(this.onEditSecondaryDecalClicked,this.onSecondaryLoadoutButtonCleared);
         this.myLoadout.registerEditPerkEvent(this.onPerkClicked,this.onPerkCleared);
         this.myLoadout.registerEditLethalEvent(this.onLethalClicked,this.onLethalCleared);
         this.myLoadout.registerEditTacticalEvent(this.onTacticalClicked,this.onTacticalCleared);
         this.myLoadout.registerEditWildCardEvent(this.onWildCardClicked,this.onWildcardCleared);
         this.myLoadoutMelee.registerSelectPrimaryEvent(this.onPrimaryMeleeWeaponClicked,this.onPrimaryMeleeWeaponSlotCleared);
         this.myLoadoutMelee.registerSelectSecondaryEvent(this.onSecondaryMeleeWeaponClicked,this.onSecondaryMeleeWeaponSlotCleared);
      }
      
      override protected function onActivated() : void
      {
         super.onActivated();
         if(this.myPrimaryLoadoutTab.selected)
         {
            DataManager.getInstance().setBindData(DataID.IS_PICK_10_TUTORIAL_VISIBILITY,true);
         }
         else
         {
            DataManager.getInstance().setBindData(DataID.IS_PICK_10_TUTORIAL_VISIBILITY,false);
         }
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         if(this.myPrimaryLoadoutTab != null)
         {
            this.myPrimaryLoadoutTab.selected = true;
         }
         this.setSelectedTab(this.PRIMARY_LOADOUT_TAB_INDEX);
      }
      
      protected function setSelectedTab(index:int) : void
      {
         var meleeKey:String = null;
         if(index == this.PRIMARY_LOADOUT_TAB_INDEX)
         {
            CFunctionContainer.WL_SwitchWeaponCategory("primary");
            this.myLoadout.visible = true;
            this.myLoadoutMelee.visible = false;
            this.myMeleeLoadoutTab.selected = false;
            if(myInstructions != null)
            {
               if(this.myLoadout.visible)
               {
                  myInstructions.text = LocalizeUtil.localize(Dict.LOADOUT_INSTRUCTIONS);
               }
               else
               {
                  meleeKey = LocalizeUtil.localizeFirstKeyBindingForCommand("+melee").toUpperCase();
                  LocalizeUtil.paramColorized(myInstructions.myTextClip,Dict.STORAGE_MELEE_USAGE_DESCRIPTION,[meleeKey,meleeKey],[GlobalGuide.WHITE,GlobalGuide.WHITE]);
               }
            }
            DataManager.getInstance().setBindData(DataID.IS_PICK_10_TUTORIAL_VISIBILITY,true);
         }
         else
         {
            CFunctionContainer.WL_SwitchWeaponCategory("sword");
            this.myLoadout.visible = false;
            this.myLoadoutMelee.visible = true;
            this.myPrimaryLoadoutTab.selected = false;
            if(myInstructions != null)
            {
               meleeKey = LocalizeUtil.localizeFirstKeyBindingForCommand("+melee").toUpperCase();
               LocalizeUtil.paramColorized(myInstructions.myTextClip,Dict.STORAGE_MELEE_USAGE_DESCRIPTION,[meleeKey,meleeKey],[GlobalGuide.WHITE,GlobalGuide.WHITE]);
            }
            DataManager.getInstance().setBindData(DataID.IS_PICK_10_TUTORIAL_VISIBILITY,false);
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_CHECK_SET_AVAILABLE_UI_TOUR);
      }
      
      protected function editSlotAction(categories:Array, item:ProductObj = null, slot:String = "", isPrimary:Boolean = true) : void
      {
      }
      
      protected function onPrimaryWeaponClicked(slot:LoadoutWeaponSlot) : void
      {
         if(this.myLoadout.equippedItems >= MAX_LOADOUT_SLOTS && slot.getData().id == 0)
         {
            this.gotoSlotsFullPopup(LocalizeUtil.localize(DictMarket.ITEM_MENU_WEAPON));
            return;
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPON_SLOT_SELECT,{
            "isPrimary":true,
            "isMelee":false
         });
         this.editSlotAction([MarketMenuData.MARKET_CATEGORY_LABELS_PRIMARY],this.myLoadout.primaryWeaponData,MarketMenuData.SLOT_PRIMARY,true);
      }
      
      protected function onSecondaryWeaponClicked(slot:LoadoutWeaponSlot) : void
      {
         if(this.myLoadout.equippedItems >= MAX_LOADOUT_SLOTS && slot.getData().id == 0)
         {
            this.gotoSlotsFullPopup(LocalizeUtil.localize(DictMarket.ITEM_MENU_WEAPON));
            return;
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPON_SLOT_SELECT,{
            "isPrimary":false,
            "isMelee":false
         });
         var categories:Array = WeaponLoadoutService.getInstance().isOverkillEquipped() ? [MarketMenuData.MARKET_CATEGORY_LABELS_PRIMARY_OVERKILL] : [MarketMenuData.MARKET_CATEGORY_LABELS_SECONDARY];
         this.editSlotAction(categories,this.myLoadout.secondaryWeaponData,MarketMenuData.SLOT_SECONDARY,false);
      }
      
      protected function onPrimaryMeleeWeaponClicked(slot:LoadoutWeaponSlot) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPON_SLOT_SELECT,{
            "isPrimary":true,
            "isMelee":true
         });
         this.editSlotAction([MarketMenuData.MARKET_CATEGORY_LABLES_SWORD],this.myLoadoutMelee.swordWeaponData,MarketMenuData.SLOT_MELEE,true);
      }
      
      protected function onSecondaryMeleeWeaponClicked(slot:LoadoutWeaponSlot) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPON_SLOT_SELECT,{
            "isPrimary":false,
            "isMelee":true
         });
         this.editSlotAction([MarketMenuData.MARKET_CATEGORY_LABLES_KNIFE],this.myLoadoutMelee.knifeWeaponData,MarketMenuData.SLOT_MELEE,false);
      }
      
      protected function onEditPrimaryReticleClicked() : void
      {
         if(this.myLoadout.myPrimaryWeaponSlot.myReticleSlot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(this.myLoadout.myPrimaryWeaponSlot.myReticleSlot);
            return;
         }
         if(!this.myLoadout.myPrimaryWeaponSlot.myReticleSlot.locked)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,{"nameid":MarketMenuData.SLOT_COSMETIC + "_primary"});
            this.editSlotAction([{
               "id":MarketMenuData.SLOT_COSMETIC,
               "label":Dict.WEAPONLOADOUT_RETICULE,
               "categoryFunc":UiCppItemListView.FUNC_USE_WPN_PRI
            }],this.myLoadout.primaryWeaponData,MarketMenuData.SLOT_COSMETIC,true);
         }
      }
      
      protected function onEditPrimaryCamoClicked() : void
      {
         if(this.myLoadout.myPrimaryWeaponSlot.myCamoSlot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(this.myLoadout.myPrimaryWeaponSlot.myCamoSlot);
            return;
         }
         if(!this.myLoadout.myPrimaryWeaponSlot.myCamoSlot.locked)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,{"nameid":MarketMenuData.SLOT_CAMO + "_primary"});
            this.editSlotAction([{
               "id":MarketMenuData.SLOT_CAMO,
               "label":Dict.WEAPONLOADOUT_CAMO,
               "categoryFunc":UiCppItemListView.FUNC_USE_WPN_PRI
            }],this.myLoadout.primaryWeaponData,MarketMenuData.SLOT_CAMO,true);
         }
      }
      
      protected function onEditPrimaryDecalClicked() : void
      {
         if(this.myLoadout.myPrimaryWeaponSlot.myDecalSlot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(this.myLoadout.myPrimaryWeaponSlot.myDecalSlot);
            return;
         }
         if(!this.myLoadout.myPrimaryWeaponSlot.myDecalSlot.locked)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,{"nameid":MarketMenuData.SLOT_COSMETIC2 + "_primary"});
            this.editSlotAction([{
               "id":MarketMenuData.SLOT_COSMETIC2,
               "label":Dict.WEAPONLOADOUT_DECAL,
               "categoryFunc":UiCppItemListView.FUNC_USE_WPN_PRI
            }],this.myLoadout.primaryWeaponData,MarketMenuData.SLOT_COSMETIC2,true);
         }
      }
      
      protected function onEditSecondaryReticleClicked() : void
      {
         if(this.myLoadout.mySecondaryWeaponSlot.myReticleSlot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(this.myLoadout.mySecondaryWeaponSlot.myReticleSlot);
            return;
         }
         if(!this.myLoadout.mySecondaryWeaponSlot.myReticleSlot.locked)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,{"nameid":MarketMenuData.SLOT_COSMETIC + "_secondary"});
            this.editSlotAction([{
               "id":MarketMenuData.SLOT_COSMETIC,
               "label":Dict.WEAPONLOADOUT_RETICULE,
               "categoryFunc":UiCppItemListView.FUNC_USE_WPN_SEC
            }],this.myLoadout.secondaryWeaponData,MarketMenuData.SLOT_COSMETIC,false);
         }
      }
      
      protected function onEditSecondaryCamoClicked() : void
      {
         if(this.myLoadout.mySecondaryWeaponSlot.myCamoSlot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(this.myLoadout.mySecondaryWeaponSlot.myCamoSlot);
            return;
         }
         if(!this.myLoadout.mySecondaryWeaponSlot.myCamoSlot.locked)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,{"nameid":MarketMenuData.SLOT_CAMO + "_secondary"});
            this.editSlotAction([{
               "id":MarketMenuData.SLOT_CAMO,
               "label":Dict.WEAPONLOADOUT_CAMO,
               "categoryFunc":UiCppItemListView.FUNC_USE_WPN_SEC
            }],this.myLoadout.secondaryWeaponData,MarketMenuData.SLOT_CAMO,false);
         }
      }
      
      protected function onEditSecondaryDecalClicked() : void
      {
         if(this.myLoadout.mySecondaryWeaponSlot.myDecalSlot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(this.myLoadout.mySecondaryWeaponSlot.myDecalSlot);
            return;
         }
         if(!this.myLoadout.mySecondaryWeaponSlot.myDecalSlot.locked)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,{"nameid":MarketMenuData.SLOT_COSMETIC2 + "_secondary"});
            this.editSlotAction([{
               "id":MarketMenuData.SLOT_COSMETIC2,
               "label":Dict.WEAPONLOADOUT_DECAL,
               "categoryFunc":UiCppItemListView.FUNC_USE_WPN_SEC
            }],this.myLoadout.secondaryWeaponData,MarketMenuData.SLOT_COSMETIC2,false);
         }
      }
      
      protected function onPrimaryAttachmentClicked(id:int) : void
      {
         var requiredWildcard:int = 0;
         var slot:LoadoutButton = this.myLoadout["myPrimaryAttachment" + id];
         if(slot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(slot);
            return;
         }
         if(!slot.locked)
         {
            if(this.myLoadout.equippedItems >= MAX_LOADOUT_SLOTS && slot.getData().item_id == 0)
            {
               this.gotoSlotsFullPopup(LocalizeUtil.localize(DictInGame.WEAPON_ATTACHMENT));
               return;
            }
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,{"nameid":MarketMenuData.SLOT_ATTACH[id] + "_primary"});
            this.editSlotAction([{
               "id":MarketMenuData.SLOT_ATTACH[id],
               "label":DictMarket.MARKETPLACE_DETAILS_ATTACHMENTS,
               "categoryFunc":UiCppItemListView.FUNC_USE_WPN_PRI,
               "child":MarketMenuData.ATTACHMENT_FILTERS
            }],this.myLoadout.primaryWeaponData,MarketMenuData.SLOT_ATTACH[id],true);
         }
         else if(id == 2 && Boolean(slot.getData().isEnable))
         {
            requiredWildcard = CFunctionCommonContainer.GetItemIDByName("wild_primary_gunfighter");
            this.gotoSlotLockedPopup(LocalizeUtil.localize(DictInGame.WEAPON_ATTACHMENT),requiredWildcard);
         }
      }
      
      protected function onSecondaryAttachmentClicked(id:int) : void
      {
         var requiredWildcard:int = 0;
         var slot:LoadoutButton = this.myLoadout["mySecondaryAttachment" + id];
         if(slot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(slot);
            return;
         }
         if(!slot.locked)
         {
            if(this.myLoadout.equippedItems >= MAX_LOADOUT_SLOTS && slot.getData().item_id == 0)
            {
               this.gotoSlotsFullPopup(LocalizeUtil.localize(DictInGame.WEAPON_ATTACHMENT));
               return;
            }
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_SLOT_CLICK,{"nameid":MarketMenuData.SLOT_ATTACH[id] + "_secondary"});
            this.editSlotAction([{
               "id":MarketMenuData.SLOT_ATTACH[id],
               "label":DictMarket.MARKETPLACE_DETAILS_ATTACHMENTS,
               "categoryFunc":UiCppItemListView.FUNC_USE_WPN_SEC,
               "child":MarketMenuData.ATTACHMENT_FILTERS
            }],this.myLoadout.secondaryWeaponData,MarketMenuData.SLOT_ATTACH[id],false);
         }
         else if(id == 1 && Boolean(slot.getData().isEnable))
         {
            requiredWildcard = CFunctionCommonContainer.GetItemIDByName("wild_secondary_gunfighter");
            this.gotoSlotLockedPopup(LocalizeUtil.localize(DictInGame.WEAPON_ATTACHMENT),requiredWildcard);
         }
      }
      
      protected function onPerkClicked(data:Object) : void
      {
         var subcateg:Object = null;
         var requiredWildcard:int = 0;
         var slot:LoadoutButton = this.myLoadout["myPerk" + data.perk + "Slot" + data.slot];
         var isExtraSlot:Boolean = data.slot == 1;
         if(slot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(slot);
            return;
         }
         if(!slot.locked)
         {
            if(this.myLoadout.equippedItems >= MAX_LOADOUT_SLOTS && slot.getData().item_id == 0)
            {
               this.gotoSlotsFullPopup(LocalizeUtil.localize(DictMarket.ITEM_MENU_PERK));
               return;
            }
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_EDITING_EXTRA_SLOT,isExtraSlot);
            switch(data.perk)
            {
               case 0:
                  subcateg = {
                     "id":MarketMenuData.GRP_PERK1,
                     "label":DictMarket.CATEGORY_PERK1
                  };
                  break;
               case 1:
                  subcateg = {
                     "id":MarketMenuData.GRP_PERK2,
                     "label":DictMarket.CATEGORY_PERK2
                  };
                  break;
               case 2:
                  subcateg = {
                     "id":MarketMenuData.GRP_PERK3,
                     "label":DictMarket.CATEGORY_PERK3
                  };
            }
            this.editSlotAction([{
               "id":"perk",
               "label":DictMarket.ITEM_MENU_PERK,
               "child":[subcateg]
            }]);
         }
         else if(isExtraSlot)
         {
            requiredWildcard = 0;
            if(data.perk == 0)
            {
               requiredWildcard = CFunctionCommonContainer.GetItemIDByName("wild_perk1_greed");
            }
            else if(data.perk == 1)
            {
               requiredWildcard = CFunctionCommonContainer.GetItemIDByName("wild_perk2_greed");
            }
            else if(data.perk == 2)
            {
               requiredWildcard = CFunctionCommonContainer.GetItemIDByName("wild_perk3_greed");
            }
            if(requiredWildcard > 0)
            {
               this.gotoSlotLockedPopup(LocalizeUtil.localize(DictMarket.ITEM_MENU_PERK),requiredWildcard);
            }
         }
      }
      
      protected function onLethalClicked(id:int) : void
      {
         var isTacticianEquipped:Boolean = false;
         var categories:Array = null;
         var requiredWildcard:int = 0;
         var slot:LoadoutButton = this.myLoadout["myLethal" + id];
         var isExtraSlot:Boolean = id == 1;
         if(slot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(slot);
            return;
         }
         if(!slot.locked)
         {
            if(this.myLoadout.equippedItems >= MAX_LOADOUT_SLOTS && slot.getData().item_id == 0)
            {
               this.gotoSlotsFullPopup(LocalizeUtil.localize(Dict.LOADOUT_SLOT_LETHAL));
               return;
            }
            if(isExtraSlot)
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_SET_DOUBLE_AMMO,{
                  "group":MarketMenuData.GRP_LETHAL,
                  "enable":true
               });
               return;
            }
            isTacticianEquipped = WeaponLoadoutService.getInstance().isTacticianEquipped();
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_EDITING_TACTICIAN_SLOT,isTacticianEquipped);
            categories = [];
            if(!isTacticianEquipped)
            {
               categories = [{
                  "id":"equipment",
                  "label":DictMarket.ITEM_MENU_EQUIPMENT,
                  "child":[{
                     "id":MarketMenuData.GRP_LETHAL,
                     "label":DictMarket.CATEGORY_LETHAL
                  }]
               }];
            }
            else
            {
               categories = [{
                  "id":"equipment",
                  "label":DictMarket.ITEM_MENU_EQUIPMENT,
                  "child":[{
                     "id":MarketMenuData.GRP_TACTICAL,
                     "label":DictMarket.CATEGORY_TACTICAL
                  }]
               }];
            }
            this.editSlotAction(categories);
         }
         else if(isExtraSlot)
         {
            requiredWildcard = CFunctionCommonContainer.GetItemIDByName("wild_danger_close");
            this.gotoSlotLockedPopup(LocalizeUtil.localize(Dict.LOADOUT_SLOT_LETHAL),requiredWildcard);
         }
      }
      
      protected function onTacticalClicked(id:int) : void
      {
         var isExtraSlot:Boolean = false;
         var slot:LoadoutButton = this.myLoadout["myTactical" + id];
         if(slot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(slot);
            return;
         }
         if(!slot.locked)
         {
            if(this.myLoadout.equippedItems >= MAX_LOADOUT_SLOTS && slot.getData().item_id == 0)
            {
               this.gotoSlotsFullPopup(LocalizeUtil.localize(Dict.LOADOUT_SLOT_TACTICAL));
               return;
            }
            isExtraSlot = id == 1;
            if(isExtraSlot)
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_SET_DOUBLE_AMMO,{
                  "group":MarketMenuData.GRP_TACTICAL,
                  "enable":true
               });
               return;
            }
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_EDITING_TACTICIAN_SLOT,false);
            this.editSlotAction([{
               "id":"equipment",
               "label":DictMarket.ITEM_MENU_EQUIPMENT,
               "child":[{
                  "id":MarketMenuData.GRP_TACTICAL,
                  "label":DictMarket.CATEGORY_TACTICAL
               }]
            }]);
         }
      }
      
      protected function onWildCardClicked(id:int) : void
      {
         var slot:LoadoutButton = this.myLoadout["myWildCard" + id];
         if(slot.fixed)
         {
            this.showWeaponFixedLoadoutItemDetail(slot);
            return;
         }
         if(!slot.locked)
         {
            if(this.myLoadout.equippedItems >= MAX_LOADOUT_SLOTS && slot.getData().item_id == 0)
            {
               this.gotoSlotsFullPopup(LocalizeUtil.localize(DictMarket.ITEM_MENU_WILDCARD));
               return;
            }
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_WILDCARD_SLOT_IDX,id);
            this.editSlotAction([{
               "id":MarketMenuData.GRP_WILDCARD,
               "label":DictMarket.ITEM_MENU_WILDCARD
            }]);
         }
      }
      
      protected function onPrimaryWeaponSlotCleared(item:ProductObj) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_WEAPON,0);
      }
      
      protected function onSecondaryWeaponSlotCleared(item:ProductObj) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_WEAPON,1);
      }
      
      protected function onPrimaryMeleeWeaponSlotCleared(item:ProductObj) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_WEAPON,2);
      }
      
      protected function onSecondaryMeleeWeaponSlotCleared(item:ProductObj) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":item});
      }
      
      protected function onPrimaryLoadoutButtonCleared(item:LoadoutButton) : void
      {
         CFunctionContainer.WL_SwitchWeaponCategory("primary");
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":item.getData()});
      }
      
      protected function onSecondaryLoadoutButtonCleared(item:LoadoutButton) : void
      {
         CFunctionContainer.WL_SwitchWeaponCategory("secondary");
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":item.getData()});
      }
      
      protected function onPerkCleared(item:LoadoutButton) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_EDITING_EXTRA_SLOT,item.isExtraSlot);
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":item.getData()});
      }
      
      protected function onLethalCleared(item:LoadoutButton) : void
      {
         if(!item.isExtraSlot)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":item.getData()});
         }
         else
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_DOUBLE_AMMO,{
               "group":MarketMenuData.GRP_LETHAL,
               "enable":false
            });
         }
      }
      
      protected function onTacticalCleared(item:LoadoutButton) : void
      {
         if(!item.isExtraSlot)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":item.getData()});
         }
         else
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_DOUBLE_AMMO,{
               "group":MarketMenuData.GRP_TACTICAL,
               "enable":false
            });
         }
      }
      
      protected function onWildcardCleared(item:LoadoutButton) : void
      {
         if(item.getData().item_id == CFunctionCommonContainer.GetItemIDByName("wild_overkill"))
         {
            CFunctionContainer.WL_SwitchWeaponCategory("primary");
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":item.getData()});
      }
      
      protected function gotoSlotLockedPopup(itemType:String, requiredWildcard:int) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTERLOADOUT_SLOT_LOCKED,{
            "itemType":itemType,
            "numItems":this.myLoadout.equippedItems,
            "requiredWildcard":requiredWildcard
         });
      }
      
      protected function gotoSlotsFullPopup(itemType:String) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTERLOADOUT_FULL,{"itemType":itemType});
      }
      
      protected function showWeaponFixedLoadoutItemDetail(slot:LoadoutButton) : void
      {
         var isPerk:Boolean = false;
         if(slot.fixed)
         {
            if(slot.getData().imageURL != null && slot.getData().imageURL != "")
            {
               isPerk = slot.getData().name != null && slot.getData().name.indexOf("pk") != -1;
               EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,SystemMsgObj.getObj(LocalizeUtil.localize(isPerk ? Dict.PERK_OCCUPY_TWO_SLOT_DESC : Dict.WEAPON_FIXED_BINDING_ITEM_DESC),MsgBtnCount.ONE,0,null,"",null,"",null,"",0,0,LocalizeUtil.localize(isPerk ? Dict.PERK_OCCUPY_TWO_SLOT_TITLE : Dict.WEAPON_FIXED_BINDING_ITEM_TTILE)));
            }
            return;
         }
      }
   }
}

