package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.constants.ServiceID;
   import codo.objects.ProductObj;
   import codo.objects.ResultObj;
   import codo.objects.WeaponLoadoutObj;
   import codo.utils.FakeXMLData;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   
   public class WeaponLoadoutService extends ServiceBase
   {
      
      private static var instance:WeaponLoadoutService;
      
      private var _currentWeaponLoadout:WeaponLoadoutObj;
      
      public function WeaponLoadoutService()
      {
         super(ServiceID.WEAPON);
      }
      
      public static function getInstance() : WeaponLoadoutService
      {
         if(WeaponLoadoutService.instance == null)
         {
            WeaponLoadoutService.instance = new WeaponLoadoutService();
         }
         return WeaponLoadoutService.instance;
      }
      
      public function get currentWeaponLoadoutIndex() : int
      {
         return CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
      }
      
      public function set currentWeaponLoadoutIndex(value:int) : void
      {
         CFunctionCommonContainer.WL_SetCurrentWeaponLoadoutIndex(value);
      }
      
      public function changeLoadout(idx:int) : void
      {
         CFunctionCommonContainer.WL_SetCurrentWeaponLoadoutIndex(idx);
         CFunctionContainer.WL_PreviewWeaponResetLoadoutSlot(idx,"primary");
         CFunctionContainer.WL_PreviewWeaponResetLoadoutSlot(idx,"secondary");
         CFunctionContainer.WL_PreviewWeaponResetLoadoutSlot(idx,"sword");
         var loadout:WeaponLoadoutObj = CFunctionCommonContainer.AS_RequestWeaponLoadout(idx) as WeaponLoadoutObj;
         setData(ResultObj.getObj(DataID.WEAPONLOADOUT_SLOTSDATA,loadout));
      }
      
      public function getCurrentWeaponLoadout() : WeaponLoadoutObj
      {
         var tempError:Error = null;
         var stackTrace:String = null;
         var weaponLoadout:WeaponLoadoutObj = null;
         if(Boolean(CFunctionCommonContainer.IsMarketplaceReady()))
         {
            weaponLoadout = new WeaponLoadoutObj(CFunctionCommonContainer.AS_RequestWeaponLoadout(this.currentWeaponLoadoutIndex));
            if(weaponLoadout != null)
            {
               this.writeSlotArray(weaponLoadout);
               this.autoFillWeaponLoadoutObj(weaponLoadout);
            }
         }
         else
         {
            tempError = new Error("Calling AS_RequestWeaponLoadout() before market data ready is unsafe.");
            stackTrace = tempError.getStackTrace();
            Logger.print(stackTrace);
         }
         return weaponLoadout;
      }
      
      public function fillWeaponLoadout(weaponLoadout:WeaponLoadoutObj) : void
      {
         if(weaponLoadout != null)
         {
            this.writeSlotArray(weaponLoadout);
            this.autoFillWeaponLoadoutObj(weaponLoadout);
         }
      }
      
      override public function init() : void
      {
         register(DataID.WEAPONLOADOUT_CHANGE,this.changeCurrentWeaponLoadout);
         this.currentWeaponLoadoutIndex = uint(0);
      }
      
      public function set currentWeaponID(value:int) : void
      {
         if(CFunctionContainer.WL_GetCurrentWeaponID() != value)
         {
            CFunctionContainer.WL_SetCurrentWeaponID(value);
         }
      }
      
      public function invalidateWeaponLoadOutSlotsData() : void
      {
         this.refreshCurrentWeaponLoadout();
         setData(ResultObj.getObj(DataID.WEAPONLOADOUT_SLOTSDATA,this._currentWeaponLoadout));
      }
      
      public function getPreviewCompareItem(item:ProductObj, slot:String) : ProductObj
      {
         var curItem:Object = null;
         var id:int = 0;
         if(item.type == MarketMenuData.TYPE_WEAPON)
         {
            curItem = this.getCurrentWeaponSlotItem(slot);
            if(curItem != null)
            {
               id = curItem.id as int;
               return CFunctionCommonContainer.GetItemInfo(id);
            }
         }
         return null;
      }
      
      public function getCurrentWeaponSlotItem(slot:String) : Object
      {
         if(this._currentWeaponLoadout == null)
         {
            this._currentWeaponLoadout = this.getCurrentWeaponLoadout();
         }
         if(slot == "primary")
         {
            return this._currentWeaponLoadout.primaryWeapSlotItem;
         }
         if(slot == "secondary")
         {
            return this._currentWeaponLoadout.secondaryWeapSlotItem;
         }
         if(slot == "sword")
         {
            return this._currentWeaponLoadout.swordWeapSlotItem;
         }
         return this._currentWeaponLoadout.primaryWeapSlotItem;
      }
      
      public function changeCurrentWeaponLoadout(cParams:Object) : void
      {
         Logger.print("WeaponLoadoutService::changeCurrentWeaponLoadout");
         this.currentWeaponLoadoutIndex = cParams.id;
         CFunctionContainer.WL_PreviewWeaponResetLoadoutSlot(this.currentWeaponLoadoutIndex,"secondary");
         CFunctionContainer.WL_SwitchWeaponCategory("primary");
         this.requestWeaponLoadout();
      }
      
      public function invalidateCurrentWeaponLoadout() : void
      {
         this._currentWeaponLoadout = null;
      }
      
      public function requestWeaponLoadout() : void
      {
         if(ScaleformUtil.isScaleform)
         {
            this._currentWeaponLoadout = this.getCurrentWeaponLoadout();
            setData(ResultObj.getObj(DataID.WEAPONLOADOUT_SLOTSDATA,this._currentWeaponLoadout));
         }
         else
         {
            setData(ResultObj.getObj(DataID.WEAPONLOADOUT_SLOTSDATA,new WeaponLoadoutObj(FakeXMLData.weaponLoadoutObject)));
         }
      }
      
      private function writeSlotArray(loadoutObj:Object) : void
      {
         var i:int = 0;
         var slotName:String = null;
         if(loadoutObj == null || loadoutObj.primaryWeapSlot == null || loadoutObj.secondaryWeapSlot == null)
         {
            return;
         }
         if(Boolean(loadoutObj.primaryWeapSlot.isEnable) && Boolean(loadoutObj.secondaryWeapSlot.isEnable))
         {
            for(i = 0; i < 6; i++)
            {
               slotName = "primaryWeapAttachment_" + i.toString();
               loadoutObj.primarySlotArray[i].nameid += "_primary";
               loadoutObj[slotName] = loadoutObj.primarySlotArray[i];
               slotName = "secondWeapAttachment_" + i.toString();
               loadoutObj.secondarySlotArray[i].nameid += "_secondary";
               loadoutObj[slotName] = loadoutObj.secondarySlotArray[i];
            }
         }
      }
      
      public function refreshCurrentWeaponLoadout() : void
      {
         if(ScaleformUtil.isScaleform && Boolean(CFunctionCommonContainer.IsMarketplaceReady()))
         {
            this._currentWeaponLoadout = this.getCurrentWeaponLoadout();
         }
      }
      
      public function autoFillWeaponLoadoutObj(weaponLoadoutObject:WeaponLoadoutObj) : void
      {
         if(!ScaleformUtil.isScaleform)
         {
            return;
         }
         if(weaponLoadoutObject.primaryWeapSlot == null)
         {
            return;
         }
         if(weaponLoadoutObject.primaryWeapSlot.isEmpty == false)
         {
            weaponLoadoutObject.primaryWeapSlotItem = weaponLoadoutObject.primaryWeapSlot.itemDat;
            weaponLoadoutObject.primaryWeapSlotItem = MarketService.getInstance().getItemInfoObj(weaponLoadoutObject.primaryWeapSlot.item_id);
         }
         if(weaponLoadoutObject.secondaryWeapSlot.isEmpty == false)
         {
            weaponLoadoutObject.secondaryWeapSlotItem = MarketService.getInstance().getItemInfoObj(weaponLoadoutObject.secondaryWeapSlot.item_id);
         }
         if(weaponLoadoutObject.swordWeapSlot.isEmpty == false)
         {
            weaponLoadoutObject.swordWeapSlotItem = MarketService.getInstance().getItemInfoObj(weaponLoadoutObject.swordWeapSlot.item_id);
         }
         if(weaponLoadoutObject.meleeWeapSlot.isEmpty == false)
         {
            weaponLoadoutObject.knifeWeapSlotItem = MarketService.getInstance().getItemInfoObj(weaponLoadoutObject.meleeWeapSlot.item_id);
         }
         CFunctionContainer.WL_FillInInventoryProductItems(weaponLoadoutObject);
      }
      
      public function isOverkillEquipped() : Boolean
      {
         var requiredWildcard:int = CFunctionCommonContainer.GetItemIDByName("wild_overkill");
         return CFunctionContainer.AS_IsItemEquipped(requiredWildcard,"wld") as Boolean;
      }
      
      public function isTacticianEquipped() : Boolean
      {
         var requiredWildcard:int = CFunctionCommonContainer.GetItemIDByName("wild_tactician");
         return CFunctionContainer.AS_IsItemEquipped(requiredWildcard,"wld") as Boolean;
      }
   }
}

