package codo.component.loadout
{
   import codo.component.TextField;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class PlayerDetailLoadoutMeleeDisplay extends MovieClip
   {
      
      public var myPrimaryMeleeWeaponSlot:LoadoutWeaponSlot;
      
      public var mySecondaryMeleeWeaponSlot:LoadoutWeaponSlot;
      
      public var myPrimaryMeleeWeaponLabel:LoadoutHeader;
      
      public var mySecondaryMeleeWeaponLabel:LoadoutHeader;
      
      public var myInputBlocker:MovieClip;
      
      public function PlayerDetailLoadoutMeleeDisplay()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         var bannedText:TextField = null;
         if(true == ScaleformUtil.isScaleform)
         {
            this.myPrimaryMeleeWeaponLabel.label = LocalizeUtil.localize(DictMarket.CATEGORY_OTHER).toUpperCase();
            this.mySecondaryMeleeWeaponLabel.label = LocalizeUtil.localize(Dict.CHARACTERLOADOUT_COMBATKNIFE).toUpperCase();
         }
         this.myPrimaryMeleeWeaponLabel.width = 283;
         this.mySecondaryMeleeWeaponLabel.width = 283;
         this.myPrimaryMeleeWeaponLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.mySecondaryMeleeWeaponLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         bannedText = this.myPrimaryMeleeWeaponSlot.myDisabledIcon["myBannedItem"];
         bannedText.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myPrimaryMeleeWeaponSlot.updateDisabledIconVisuals();
         bannedText = this.mySecondaryMeleeWeaponSlot.myDisabledIcon["myBannedItem"];
         bannedText.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.mySecondaryMeleeWeaponSlot.updateDisabledIconVisuals();
         this.myPrimaryMeleeWeaponSlot.myDecalLabel.visible = this.myPrimaryMeleeWeaponSlot.myCamoLabel.visible = this.myPrimaryMeleeWeaponSlot.myReticleLabel.visible = false;
         this.myPrimaryMeleeWeaponSlot.myDecalSlot.visible = this.myPrimaryMeleeWeaponSlot.myCamoSlot.visible = this.myPrimaryMeleeWeaponSlot.myReticleSlot.visible = false;
         this.mySecondaryMeleeWeaponSlot.myDecalLabel.visible = this.mySecondaryMeleeWeaponSlot.myCamoLabel.visible = this.mySecondaryMeleeWeaponSlot.myReticleLabel.visible = false;
         this.mySecondaryMeleeWeaponSlot.myDecalSlot.visible = this.mySecondaryMeleeWeaponSlot.myCamoSlot.visible = this.mySecondaryMeleeWeaponSlot.myReticleSlot.visible = false;
         this.myInputBlocker.visible = false;
      }
      
      public function setLoadoutData(loadoutData:Object) : void
      {
         if(loadoutData == null)
         {
            return;
         }
         this.myPrimaryMeleeWeaponSlot.setData(new ProductObj(loadoutData.primaryMelee));
         this.mySecondaryMeleeWeaponSlot.setData(new ProductObj(loadoutData.secondaryMelee));
         this.myPrimaryMeleeWeaponSlot.myDecalLabel.visible = this.myPrimaryMeleeWeaponSlot.myCamoLabel.visible = this.myPrimaryMeleeWeaponSlot.myReticleLabel.visible = false;
         this.myPrimaryMeleeWeaponSlot.myDecalSlot.visible = this.myPrimaryMeleeWeaponSlot.myCamoSlot.visible = this.myPrimaryMeleeWeaponSlot.myReticleSlot.visible = false;
         this.mySecondaryMeleeWeaponSlot.myDecalLabel.visible = this.mySecondaryMeleeWeaponSlot.myCamoLabel.visible = this.mySecondaryMeleeWeaponSlot.myReticleLabel.visible = false;
         this.mySecondaryMeleeWeaponSlot.myDecalSlot.visible = this.mySecondaryMeleeWeaponSlot.myCamoSlot.visible = this.mySecondaryMeleeWeaponSlot.myReticleSlot.visible = false;
      }
      
      public function registerFocusEvent(f:Function) : void
      {
         this.myPrimaryMeleeWeaponSlot.registerFocusEvent(f,this.myPrimaryMeleeWeaponSlot);
         this.mySecondaryMeleeWeaponSlot.registerFocusEvent(f,this.mySecondaryMeleeWeaponSlot);
      }
      
      public function registerUnfocusEvent(f:Function) : void
      {
         this.myPrimaryMeleeWeaponSlot.registerUnfocusEvent(f,this.myPrimaryMeleeWeaponSlot);
         this.mySecondaryMeleeWeaponSlot.registerUnfocusEvent(f,this.mySecondaryMeleeWeaponSlot);
      }
      
      public function registerClickEvent(f:Function) : void
      {
         this.myPrimaryMeleeWeaponSlot.registerClickEvent(f,this.myPrimaryMeleeWeaponSlot);
         this.mySecondaryMeleeWeaponSlot.registerClickEvent(f,this.mySecondaryMeleeWeaponSlot);
      }
   }
}

