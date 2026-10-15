package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataID;
   import codo.cpp.UiCppNewItems;
   import codo.localization.Dict;
   import codo.objects.BindDataHelper;
   import codo.objects.ItemSlotObj;
   import codo.objects.ProductObj;
   import codo.objects.WeaponLoadoutObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class LoadoutMeleeDisplay extends MovieClip
   {
      
      public var myPrimaryWeaponSlot:LoadoutWeaponSlot;
      
      public var mySecondaryWeaponSlot:LoadoutWeaponSlot;
      
      public var myPrimaryWeaponLabel:LoadoutHeader;
      
      public var mySecondaryWeaponLabel:LoadoutHeader;
      
      public var myContainer:MovieClip;
      
      public var myOutlines:MovieClip;
      
      protected var mBindWeaponLoadoutSlotsData:BindDataHelper;
      
      private var mPrimaryWeaponData:ProductObj;
      
      private var mSecondaryWeaponData:ProductObj;
      
      protected var mWeaponLoadout:WeaponLoadoutObj;
      
      public function LoadoutMeleeDisplay()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         this.mBindWeaponLoadoutSlotsData = new BindDataHelper(DataID.WEAPONLOADOUT_SLOTSDATA,this.bindLoadoutData);
         if(true == ScaleformUtil.isScaleform)
         {
            this.myPrimaryWeaponLabel.label = LocalizeUtil.localize(Dict.PRIMARY_WEAPON).toUpperCase();
            this.mySecondaryWeaponLabel.label = LocalizeUtil.localize(Dict.SECONDARY_WEAPON).toUpperCase();
         }
         this.myPrimaryWeaponLabel.width = this.mySecondaryWeaponLabel.width = this.mySecondaryWeaponSlot.myBackground.width;
         UiCppNewItems.instance.InitBreadcrumb(this.myPrimaryWeaponSlot,UiCppNewItems.CRUMB_OTHER_SECONDARIES);
         UiCppNewItems.instance.InitBreadcrumb(this.mySecondaryWeaponSlot,UiCppNewItems.CRUMB_COMBAT_KNIFE);
      }
      
      public function enableData() : void
      {
         if(this.mBindWeaponLoadoutSlotsData != null)
         {
            this.mBindWeaponLoadoutSlotsData.bind();
         }
      }
      
      public function disableData() : void
      {
         if(this.mBindWeaponLoadoutSlotsData != null)
         {
            this.mBindWeaponLoadoutSlotsData.unbind();
         }
      }
      
      public function get swordWeaponData() : ProductObj
      {
         return this.mPrimaryWeaponData;
      }
      
      public function get knifeWeaponData() : ProductObj
      {
         return this.mSecondaryWeaponData;
      }
      
      public function registerFocusEvent(f:Function) : void
      {
         this.myPrimaryWeaponSlot.registerFocusEvent(f,this.myPrimaryWeaponSlot);
         this.mySecondaryWeaponSlot.registerFocusEvent(f,this.mySecondaryWeaponSlot);
      }
      
      public function registerUnfocusEvent(f:Function) : void
      {
         this.myPrimaryWeaponSlot.registerUnfocusEvent(f,this.myPrimaryWeaponSlot);
         this.mySecondaryWeaponSlot.registerUnfocusEvent(f,this.mySecondaryWeaponSlot);
      }
      
      public function registerSelectPrimaryEvent(f:Function, clearFunction:Function) : void
      {
         this.myPrimaryWeaponSlot.setClickCallback(f);
         this.myPrimaryWeaponSlot.clearItemCallback = clearFunction;
      }
      
      public function registerSelectSecondaryEvent(f:Function, clearFunction:Function) : void
      {
         this.mySecondaryWeaponSlot.setClickCallback(f);
         this.mySecondaryWeaponSlot.clearItemCallback = clearFunction;
      }
      
      protected function bindLoadoutData(cResult:Object) : void
      {
         this.updateLoadout(new WeaponLoadoutObj(cResult.data));
      }
      
      public function updateLoadout(weaponLoadoutObj:WeaponLoadoutObj) : void
      {
         this.mWeaponLoadout = weaponLoadoutObj;
         var swordItem:ItemSlotObj = this.mWeaponLoadout.swordWeapSlot;
         var meleeItem:ItemSlotObj = this.mWeaponLoadout.meleeWeapSlot;
         this.mPrimaryWeaponData = CFunctionCommonContainer.GetItemInfo(swordItem.item_id);
         this.mPrimaryWeaponData.hideExtendedButtons = true;
         this.myPrimaryWeaponSlot.setData(this.mPrimaryWeaponData);
         this.mSecondaryWeaponData = CFunctionCommonContainer.GetItemInfo(meleeItem.item_id);
         this.mSecondaryWeaponData.hideExtendedButtons = true;
         this.mySecondaryWeaponSlot.setData(this.mSecondaryWeaponData);
         this.myPrimaryWeaponSlot.myReticleSlot.visible = this.myPrimaryWeaponSlot.myReticleLabel.visible = false;
         this.myPrimaryWeaponSlot.myCamoSlot.visible = this.myPrimaryWeaponSlot.myCamoLabel.visible = false;
         this.myPrimaryWeaponSlot.myDecalSlot.visible = this.myPrimaryWeaponSlot.myDecalLabel.visible = false;
         this.mySecondaryWeaponSlot.myReticleSlot.visible = this.mySecondaryWeaponSlot.myReticleLabel.visible = false;
         this.mySecondaryWeaponSlot.myCamoSlot.visible = this.mySecondaryWeaponSlot.myCamoLabel.visible = false;
         this.mySecondaryWeaponSlot.myDecalSlot.visible = this.mySecondaryWeaponSlot.myDecalLabel.visible = false;
      }
   }
}

