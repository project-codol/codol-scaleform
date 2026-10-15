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
   
   public class PlayerDetailLoadoutDisplay extends MovieClip
   {
      
      public static const ATTACHMENT_WIDTH:Number = 57;
      
      public static const ATTACHMENT_HEIGHT:Number = 64;
      
      public static const PERK_WIDTH:Number = 63;
      
      public static const PERK_HEIGHT:Number = 66;
      
      public static const WILDCARD_WIDTH:Number = 63;
      
      public static const WILDCARD_HEIGHT:Number = 66;
      
      public static const WILDCARD_IMAGE_SCALE:Number = 0.74;
      
      private static const WEAPONSLOT_ATTACHMENT_IMAGE_SCALE:Number = 0.92;
      
      private static const WEAPONSLOT_ATTACHMENT_DECAL_SCALE:Number = 0.5;
      
      private static const ATTACHMENT_IMAGE_SCALE:Number = 0.55;
      
      public var myPrimaryWeaponSlot:LoadoutWeaponSlot;
      
      public var mySecondaryWeaponSlot:LoadoutWeaponSlot;
      
      public var myPrimaryAttachment0:LoadoutButton;
      
      public var myPrimaryAttachment1:LoadoutButton;
      
      public var myPrimaryAttachment2:LoadoutButton;
      
      public var mySecondaryAttachment0:LoadoutButton;
      
      public var mySecondaryAttachment1:LoadoutButton;
      
      public var myPrimaryWeaponLabel:LoadoutHeader;
      
      public var mySecondaryWeaponLabel:LoadoutHeader;
      
      public var myPerk0Slot0:LoadoutButton;
      
      public var myPerk1Slot0:LoadoutButton;
      
      public var myPerk2Slot0:LoadoutButton;
      
      public var myLethal0:LoadoutButton;
      
      public var myTactical0:LoadoutButton;
      
      public var myPerkLabel:LoadoutHeader;
      
      public var myTacticalLabel:LoadoutHeader;
      
      public var myLethalLabel:LoadoutHeader;
      
      public var myPrimaryAttachmentLabel:LoadoutHeader;
      
      public var myWildCardLabel:LoadoutHeader;
      
      public var myWildCard0:LoadoutButton;
      
      public var myWildCard1:LoadoutButton;
      
      public var myWildCard2:LoadoutButton;
      
      public var myPerk0Slot1:LoadoutButton;
      
      public var myPerk1Slot1:LoadoutButton;
      
      public var myPerk2Slot1:LoadoutButton;
      
      public var myLethal1:LoadoutButton;
      
      public var myTactical1:LoadoutButton;
      
      public var myInputBlocker:MovieClip;
      
      private var mPerkSlots:Vector.<LoadoutButton>;
      
      private var mWildCardSlots:Vector.<LoadoutButton>;
      
      public function PlayerDetailLoadoutDisplay()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         this.mPerkSlots = new <LoadoutButton>[this.myPerk0Slot0,this.myPerk1Slot0,this.myPerk2Slot0,this.myPerk0Slot1,this.myPerk1Slot1,this.myPerk2Slot1];
         this.mWildCardSlots = new <LoadoutButton>[this.myWildCard0,this.myWildCard1,this.myWildCard2];
         if(true == ScaleformUtil.isScaleform)
         {
            this.myPerkLabel.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_PERKS).toUpperCase();
            this.myTacticalLabel.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_TACTICAL).toUpperCase();
            this.myLethalLabel.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_LETHAL).toUpperCase();
            this.myWildCardLabel.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_WILD_CARD).toUpperCase();
            this.myPrimaryAttachmentLabel.label = LocalizeUtil.localize(Dict.WEAPONLOADOUT_ATTACHMENTS).toUpperCase();
            this.myPrimaryWeaponSlot.myReticleLabel.label = LocalizeUtil.localize(DictMarket.CATEGORY_RETICLE).toUpperCase();
            this.mySecondaryWeaponSlot.myReticleLabel.label = LocalizeUtil.localize(DictMarket.CATEGORY_RETICLE).toUpperCase();
            this.myPrimaryWeaponLabel.label = LocalizeUtil.localize(Dict.PRIMARY_WEAPON).toUpperCase();
            this.mySecondaryWeaponLabel.label = LocalizeUtil.localize(Dict.SECONDARY_WEAPON).toUpperCase();
         }
         this.myWildCardLabel.width = 171;
         this.myPerkLabel.width = 72;
         this.myPrimaryAttachmentLabel.width = 72;
         this.myPrimaryWeaponLabel.width = 281;
         this.mySecondaryWeaponLabel.width = 281;
         this.myWildCardLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myPerkLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myPrimaryAttachmentLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myPrimaryWeaponLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.mySecondaryWeaponLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myLethalLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myTacticalLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myPrimaryAttachment0.width = ATTACHMENT_WIDTH;
         this.myPrimaryAttachment0.height = ATTACHMENT_HEIGHT;
         this.myPrimaryAttachment1.width = ATTACHMENT_WIDTH;
         this.myPrimaryAttachment1.height = ATTACHMENT_HEIGHT;
         this.myPrimaryAttachment2.width = ATTACHMENT_WIDTH;
         this.myPrimaryAttachment2.height = ATTACHMENT_HEIGHT;
         this.mySecondaryAttachment0.width = ATTACHMENT_WIDTH;
         this.mySecondaryAttachment0.height = ATTACHMENT_HEIGHT;
         this.mySecondaryAttachment1.width = ATTACHMENT_WIDTH;
         this.mySecondaryAttachment1.height = ATTACHMENT_HEIGHT;
         this.myPrimaryAttachment0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryAttachment1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryAttachment2.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.mySecondaryAttachment0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.mySecondaryAttachment1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         var bannedText:TextField = this.myPrimaryWeaponSlot.myDisabledIcon["myBannedItem"];
         bannedText.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myPrimaryWeaponSlot.updateDisabledIconVisuals();
         this.myPrimaryWeaponSlot.myReticleLabel.width = 38;
         this.myPrimaryWeaponSlot.myReticleLabel.myLabel.x = 2;
         this.myPrimaryWeaponSlot.myReticleLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myPrimaryWeaponSlot.myCamoLabel.width = 38;
         this.myPrimaryWeaponSlot.myCamoLabel.myLabel.x = 2;
         this.myPrimaryWeaponSlot.myCamoLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myPrimaryWeaponSlot.myCamoSlot.scaleImage(WEAPONSLOT_ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryWeaponSlot.myItemLevelDisplay.hideLabel();
         bannedText = this.mySecondaryWeaponSlot.myDisabledIcon["myBannedItem"];
         bannedText.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.mySecondaryWeaponSlot.updateDisabledIconVisuals();
         this.mySecondaryWeaponSlot.myReticleLabel.width = 38;
         this.mySecondaryWeaponSlot.myReticleLabel.myLabel.x = 2;
         this.mySecondaryWeaponSlot.myReticleLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.mySecondaryWeaponSlot.myCamoLabel.width = 38;
         this.mySecondaryWeaponSlot.myCamoLabel.myLabel.x = 2;
         this.mySecondaryWeaponSlot.myCamoLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.mySecondaryWeaponSlot.myCamoSlot.scaleImage(WEAPONSLOT_ATTACHMENT_IMAGE_SCALE);
         this.mySecondaryWeaponSlot.myItemLevelDisplay.hideLabel();
         bannedText = this.myPrimaryWeaponSlot.myDisabledIcon["myBannedItem"];
         bannedText.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myPrimaryWeaponSlot.updateDisabledIconVisuals();
         bannedText = this.mySecondaryWeaponSlot.myDisabledIcon["myBannedItem"];
         bannedText.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.mySecondaryWeaponSlot.updateDisabledIconVisuals();
         this.myPrimaryWeaponSlot.myReticleSlot.scaleImage(WEAPONSLOT_ATTACHMENT_IMAGE_SCALE);
         this.mySecondaryWeaponSlot.myReticleSlot.scaleImage(WEAPONSLOT_ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryWeaponSlot.myDecalSlot.scaleImage(WEAPONSLOT_ATTACHMENT_DECAL_SCALE);
         this.myPrimaryWeaponSlot.myDecalLabel.width = 38;
         this.myPrimaryWeaponSlot.myDecalLabel.myLabel.x = 2;
         this.myPrimaryWeaponSlot.myDecalLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.mySecondaryWeaponSlot.myDecalSlot.scaleImage(WEAPONSLOT_ATTACHMENT_DECAL_SCALE);
         this.mySecondaryWeaponSlot.myDecalLabel.width = 38;
         this.mySecondaryWeaponSlot.myDecalLabel.myLabel.x = 2;
         this.mySecondaryWeaponSlot.myDecalLabel.myLabel.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myPerk0Slot0.width = PERK_WIDTH;
         this.myPerk0Slot0.height = PERK_HEIGHT;
         this.myPerk1Slot0.width = PERK_WIDTH;
         this.myPerk1Slot0.height = PERK_HEIGHT;
         this.myPerk2Slot0.width = PERK_WIDTH;
         this.myPerk2Slot0.height = PERK_HEIGHT;
         this.myPerk0Slot1.width = PERK_WIDTH;
         this.myPerk0Slot1.height = PERK_HEIGHT;
         this.myPerk1Slot1.width = PERK_WIDTH;
         this.myPerk1Slot1.height = PERK_HEIGHT;
         this.myPerk2Slot1.width = PERK_WIDTH;
         this.myPerk2Slot1.height = PERK_HEIGHT;
         this.myWildCard0.width = WILDCARD_WIDTH;
         this.myWildCard0.height = WILDCARD_HEIGHT;
         this.myWildCard1.width = WILDCARD_WIDTH;
         this.myWildCard1.height = WILDCARD_HEIGHT;
         this.myWildCard2.width = WILDCARD_WIDTH;
         this.myWildCard2.height = WILDCARD_HEIGHT;
         this.myWildCard0.scaleImage(WILDCARD_IMAGE_SCALE);
         this.myWildCard1.scaleImage(WILDCARD_IMAGE_SCALE);
         this.myWildCard2.scaleImage(WILDCARD_IMAGE_SCALE);
         this.myLethal0.width = PERK_WIDTH;
         this.myLethal0.height = PERK_HEIGHT;
         this.myLethal1.width = PERK_WIDTH;
         this.myLethal1.height = PERK_HEIGHT;
         this.myTactical0.width = PERK_WIDTH;
         this.myTactical0.height = PERK_HEIGHT;
         this.myTactical1.width = PERK_WIDTH;
         this.myTactical1.height = PERK_HEIGHT;
      }
      
      public function setLoadoutData(loadoutData:Object) : void
      {
         if(loadoutData == null || loadoutData.primary == null)
         {
            return;
         }
         this.myPrimaryWeaponSlot.setData(new ProductObj(loadoutData.primary));
         this.myPrimaryAttachment0.setData(loadoutData.primaryAttachments[0]);
         this.myPrimaryAttachment1.setData(loadoutData.primaryAttachments[1]);
         this.myPrimaryAttachment2.setData(loadoutData.primaryAttachments[2]);
         this.myPrimaryWeaponSlot.myCamoSlot.setData(loadoutData.primaryAttachments[3]);
         this.myPrimaryWeaponSlot.myReticleSlot.setData(loadoutData.primaryAttachments[4]);
         this.myPrimaryWeaponSlot.myDecalSlot.setData(loadoutData.primaryAttachments[5]);
         this.mySecondaryWeaponSlot.setData(new ProductObj(loadoutData.secondary));
         this.mySecondaryAttachment0.setData(loadoutData.secondaryAttachments[0]);
         this.mySecondaryAttachment1.setData(loadoutData.secondaryAttachments[1]);
         this.mySecondaryWeaponSlot.myCamoSlot.setData(loadoutData.secondaryAttachments[3]);
         this.mySecondaryWeaponSlot.myReticleSlot.setData(loadoutData.secondaryAttachments[4]);
         this.mySecondaryWeaponSlot.myDecalSlot.setData(loadoutData.secondaryAttachments[5]);
         this.myLethal0.setData(loadoutData.equipments[0]);
         this.myLethal1.setData(loadoutData.equipments[1]);
         this.myTactical0.setData(loadoutData.equipments[2]);
         this.myTactical1.setData(loadoutData.equipments[3]);
         var i:int = 0;
         for(i = 0; i < 3; i++)
         {
            this.mWildCardSlots[i].setData(loadoutData.wildcards[i]);
         }
         for(i = 0; i < 6; i++)
         {
            this.mPerkSlots[i].setData(loadoutData.perks[i]);
         }
      }
      
      public function registerFocusEvent(f:Function) : void
      {
         this.myPrimaryWeaponSlot.registerFocusEvent(f,this.myPrimaryWeaponSlot);
         this.myPrimaryWeaponSlot.myCamoSlot.registerFocusEvent(f,this.myPrimaryWeaponSlot.myCamoSlot);
         this.myPrimaryWeaponSlot.myReticleSlot.registerFocusEvent(f,this.myPrimaryWeaponSlot.myReticleSlot);
         this.myPrimaryWeaponSlot.myDecalSlot.registerFocusEvent(f,this.myPrimaryWeaponSlot.myDecalSlot);
         this.mySecondaryWeaponSlot.registerFocusEvent(f,this.mySecondaryWeaponSlot);
         this.mySecondaryWeaponSlot.myCamoSlot.registerFocusEvent(f,this.mySecondaryWeaponSlot.myCamoSlot);
         this.mySecondaryWeaponSlot.myReticleSlot.registerFocusEvent(f,this.mySecondaryWeaponSlot.myReticleSlot);
         this.mySecondaryWeaponSlot.myDecalSlot.registerFocusEvent(f,this.mySecondaryWeaponSlot.myDecalSlot);
         this.myLethal0.registerFocusEvent(f,this.myLethal0);
         this.myLethal1.registerFocusEvent(f,this.myLethal1);
         this.myTactical0.registerFocusEvent(f,this.myTactical0);
         this.myTactical1.registerFocusEvent(f,this.myTactical1);
         this.myPerk0Slot0.registerFocusEvent(f,this.myPerk0Slot0);
         this.myPerk1Slot0.registerFocusEvent(f,this.myPerk1Slot0);
         this.myPerk2Slot0.registerFocusEvent(f,this.myPerk2Slot0);
         this.myPerk0Slot1.registerFocusEvent(f,this.myPerk0Slot1);
         this.myPerk1Slot1.registerFocusEvent(f,this.myPerk1Slot1);
         this.myPerk2Slot1.registerFocusEvent(f,this.myPerk2Slot1);
         this.myPrimaryAttachment0.registerFocusEvent(f,this.myPrimaryAttachment0);
         this.myPrimaryAttachment1.registerFocusEvent(f,this.myPrimaryAttachment1);
         this.myPrimaryAttachment2.registerFocusEvent(f,this.myPrimaryAttachment2);
         this.mySecondaryAttachment0.registerFocusEvent(f,this.mySecondaryAttachment0);
         this.mySecondaryAttachment1.registerFocusEvent(f,this.mySecondaryAttachment1);
         this.myWildCard0.registerFocusEvent(f,this.myWildCard0);
         this.myWildCard1.registerFocusEvent(f,this.myWildCard1);
         this.myWildCard2.registerFocusEvent(f,this.myWildCard2);
         this.myInputBlocker.visible = false;
      }
      
      public function registerUnfocusEvent(f:Function) : void
      {
         this.myPrimaryWeaponSlot.registerUnfocusEvent(f,this.myPrimaryWeaponSlot);
         this.myPrimaryWeaponSlot.myCamoSlot.registerUnfocusEvent(f,this.myPrimaryWeaponSlot.myCamoSlot);
         this.myPrimaryWeaponSlot.myReticleSlot.registerUnfocusEvent(f,this.myPrimaryWeaponSlot.myReticleSlot);
         this.myPrimaryWeaponSlot.myDecalSlot.registerUnfocusEvent(f,this.myPrimaryWeaponSlot.myDecalSlot);
         this.mySecondaryWeaponSlot.registerUnfocusEvent(f,this.mySecondaryWeaponSlot);
         this.mySecondaryWeaponSlot.myCamoSlot.registerUnfocusEvent(f,this.mySecondaryWeaponSlot.myCamoSlot);
         this.mySecondaryWeaponSlot.myReticleSlot.registerUnfocusEvent(f,this.mySecondaryWeaponSlot.myReticleSlot);
         this.mySecondaryWeaponSlot.myDecalSlot.registerUnfocusEvent(f,this.mySecondaryWeaponSlot.myDecalSlot);
         this.myLethal0.registerUnfocusEvent(f,this.myLethal0);
         this.myLethal1.registerUnfocusEvent(f,this.myLethal1);
         this.myTactical0.registerUnfocusEvent(f,this.myTactical0);
         this.myTactical1.registerUnfocusEvent(f,this.myTactical1);
         this.myPerk0Slot0.registerUnfocusEvent(f,this.myPerk0Slot0);
         this.myPerk1Slot0.registerUnfocusEvent(f,this.myPerk1Slot0);
         this.myPerk2Slot0.registerUnfocusEvent(f,this.myPerk2Slot0);
         this.myPerk0Slot1.registerUnfocusEvent(f,this.myPerk0Slot1);
         this.myPerk1Slot1.registerUnfocusEvent(f,this.myPerk1Slot1);
         this.myPerk2Slot1.registerUnfocusEvent(f,this.myPerk2Slot1);
         this.myPrimaryAttachment0.registerUnfocusEvent(f,this.myPrimaryAttachment0);
         this.myPrimaryAttachment1.registerUnfocusEvent(f,this.myPrimaryAttachment1);
         this.myPrimaryAttachment2.registerUnfocusEvent(f,this.myPrimaryAttachment2);
         this.mySecondaryAttachment0.registerUnfocusEvent(f,this.mySecondaryAttachment0);
         this.mySecondaryAttachment1.registerUnfocusEvent(f,this.mySecondaryAttachment1);
         this.myWildCard0.registerUnfocusEvent(f,this.myWildCard0);
         this.myWildCard1.registerUnfocusEvent(f,this.myWildCard1);
         this.myWildCard2.registerUnfocusEvent(f,this.myWildCard2);
      }
      
      public function registerClickEvent(f:Function) : void
      {
         this.myPrimaryWeaponSlot.registerClickEvent(f,this.myPrimaryWeaponSlot);
         this.myPrimaryWeaponSlot.myCamoSlot.registerClickEvent(f,this.myPrimaryWeaponSlot.myCamoSlot);
         this.myPrimaryWeaponSlot.myReticleSlot.registerClickEvent(f,this.myPrimaryWeaponSlot.myReticleSlot);
         this.myPrimaryWeaponSlot.myDecalSlot.registerClickEvent(f,this.myPrimaryWeaponSlot.myDecalSlot);
         this.mySecondaryWeaponSlot.registerClickEvent(f,this.mySecondaryWeaponSlot);
         this.mySecondaryWeaponSlot.myCamoSlot.registerClickEvent(f,this.mySecondaryWeaponSlot.myCamoSlot);
         this.mySecondaryWeaponSlot.myReticleSlot.registerClickEvent(f,this.mySecondaryWeaponSlot.myReticleSlot);
         this.mySecondaryWeaponSlot.myDecalSlot.registerClickEvent(f,this.mySecondaryWeaponSlot.myDecalSlot);
         this.myLethal0.registerClickEvent(f,this.myLethal0);
         this.myLethal1.registerClickEvent(f,this.myLethal1);
         this.myTactical0.registerClickEvent(f,this.myTactical0);
         this.myTactical1.registerClickEvent(f,this.myTactical1);
         this.myPerk0Slot0.registerClickEvent(f,this.myPerk0Slot0);
         this.myPerk1Slot0.registerClickEvent(f,this.myPerk1Slot0);
         this.myPerk2Slot0.registerClickEvent(f,this.myPerk2Slot0);
         this.myPerk0Slot1.registerClickEvent(f,this.myPerk0Slot1);
         this.myPerk1Slot1.registerClickEvent(f,this.myPerk1Slot1);
         this.myPerk2Slot1.registerClickEvent(f,this.myPerk2Slot1);
         this.myPrimaryAttachment0.registerClickEvent(f,this.myPrimaryAttachment0);
         this.myPrimaryAttachment1.registerClickEvent(f,this.myPrimaryAttachment1);
         this.myPrimaryAttachment2.registerClickEvent(f,this.myPrimaryAttachment2);
         this.mySecondaryAttachment0.registerClickEvent(f,this.mySecondaryAttachment0);
         this.mySecondaryAttachment1.registerClickEvent(f,this.mySecondaryAttachment1);
         this.myWildCard0.registerClickEvent(f,this.myWildCard0);
         this.myWildCard1.registerClickEvent(f,this.myWildCard1);
         this.myWildCard2.registerClickEvent(f,this.myWildCard2);
         this.myInputBlocker.visible = false;
      }
   }
}

