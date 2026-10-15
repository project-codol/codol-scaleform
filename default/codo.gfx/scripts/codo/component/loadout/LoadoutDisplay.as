package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.ComboBox;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.cpp.UiCppNewItems;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.manager.EventManager;
   import codo.objects.AttachmentSlotObj;
   import codo.objects.BindDataHelper;
   import codo.objects.CustomObject;
   import codo.objects.ItemSlotObj;
   import codo.objects.LoadoutMeterSettings;
   import codo.objects.ProductObj;
   import codo.objects.WeaponLoadoutObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class LoadoutDisplay extends MovieClip
   {
      
      public static const ATTACHMENT_WIDTH:Number = 104;
      
      public static const ATTACHMENT_HEIGHT:Number = 104;
      
      public static const WILDCARD_WIDTH:Number = 104;
      
      public static const WILDCARD_HEIGHT:Number = 138;
      
      public static const WILDCARD_IMAGE_SCALE:Number = 1;
      
      public static const ATTACHMENT_IMAGE_SCALE:Number = 0.85;
      
      public static const CONTAINER_WIDTH:Number = 957;
      
      public static const CONTAINER_HEIGHT:Number = 791;
      
      public static const TICK_WIDTH:Number = 8;
      
      public static const TICK_PADDING:Number = 5;
      
      public static const PERK_WIDTH:uint = 104;
      
      public static const PERK_HEIGHT:uint = 104;
      
      public static const PERK_PADDING_X:uint = 10;
      
      public static const OPTIONS_BUTTON_OFFSET_X:Number = 220;
      
      private static const RENAME:Number = 0;
      
      private static const COPY:Number = 1;
      
      private static const PASTE:Number = 2;
      
      private static const WEAPONSLOT_ATTACHMENT_IMAGE_SCALE:Number = 1.31;
      
      private static const WEAPONSLOT_ATTACHMENT_DECAL_SCALE:Number = 0.8;
      
      public var myPrimaryWeaponSlot:LoadoutWeaponSlot;
      
      public var mySecondaryWeaponSlot:LoadoutWeaponSlot;
      
      public var myLoadoutMeter:LoadoutMeter;
      
      public var myPrimaryAttachment0:LoadoutButton;
      
      public var myPrimaryAttachment1:LoadoutButton;
      
      public var myPrimaryAttachment2:LoadoutButton;
      
      public var mySecondaryAttachment0:LoadoutButton;
      
      public var mySecondaryAttachment1:LoadoutButton;
      
      public var myPerk0Slot0:LoadoutButton;
      
      public var myPerk1Slot0:LoadoutButton;
      
      public var myPerk2Slot0:LoadoutButton;
      
      public var myLethal0:LoadoutButton;
      
      public var myTactical0:LoadoutButton;
      
      public var myPerkLabel:LoadoutHeader;
      
      public var myPerkLabel2:LoadoutHeader;
      
      public var myPerkLabel3:LoadoutHeader;
      
      public var myTacticalLabel:LoadoutHeader;
      
      public var myLethalLabel:LoadoutHeader;
      
      public var myPrimaryWeaponLabel:LoadoutHeader;
      
      public var mySecondaryWeaponLabel:LoadoutHeader;
      
      public var myPrimaryAttachmentLabel:LoadoutHeader;
      
      public var mySecondaryAttachmentLabel:LoadoutHeader;
      
      public var myContainer:MovieClip;
      
      public var myOptions:ComboBox;
      
      public var myOutlines:MovieClip;
      
      public var myWildCard0:LoadoutButton;
      
      public var myWildCard1:LoadoutButton;
      
      public var myWildCard2:LoadoutButton;
      
      public var myPerk0Slot1:LoadoutButton;
      
      public var myPerk1Slot1:LoadoutButton;
      
      public var myPerk2Slot1:LoadoutButton;
      
      public var myLethal1:LoadoutButton;
      
      public var myTactical1:LoadoutButton;
      
      public var myWildCardLabel:LoadoutHeader;
      
      public var myWildCardLabel2:LoadoutHeader;
      
      public var myWildCardLabel3:LoadoutHeader;
      
      protected var mBindWeaponLoadoutSlotsData:BindDataHelper;
      
      protected var mTickWidth:Number = 8;
      
      protected var mTickPadding:Number = 5;
      
      private var mPrimaryWeaponData:ProductObj;
      
      private var mSecondaryWeaponData:ProductObj;
      
      protected var mWeaponLoadout:WeaponLoadoutObj;
      
      private var mEquippedItems:int;
      
      private var mOnboardUnlockPerksLevel:String;
      
      private var copyFromCharacterIndex:int = -1;
      
      private var copyFromLoadoutIdx:int = -1;
      
      private var mLoadoutCopiedCb:Function;
      
      public var mPriAttaches:Vector.<LoadoutButton>;
      
      public var mSecAttaches:Vector.<LoadoutButton>;
      
      public var mPerks:Vector.<Vector.<LoadoutButton>>;
      
      public var mLethals:Vector.<LoadoutButton>;
      
      public var mTacticals:Vector.<LoadoutButton>;
      
      public function LoadoutDisplay()
      {
         super();
         this.mPriAttaches = new <LoadoutButton>[this.myPrimaryAttachment0,this.myPrimaryAttachment1,this.myPrimaryAttachment2];
         this.mSecAttaches = new <LoadoutButton>[this.mySecondaryAttachment0,this.mySecondaryAttachment1];
         this.mPerks = new <Vector.<LoadoutButton>>[new <LoadoutButton>[this.myPerk0Slot0,this.myPerk1Slot0,this.myPerk2Slot0],new <LoadoutButton>[this.myPerk0Slot1,this.myPerk1Slot1,this.myPerk2Slot1]];
         this.mLethals = new <LoadoutButton>[this.myLethal0,this.myLethal1];
         this.mTacticals = new <LoadoutButton>[this.myTactical0,this.myTactical1];
         this.initStage();
      }
      
      protected function initStage() : void
      {
         var options:Array = null;
         this.mBindWeaponLoadoutSlotsData = new BindDataHelper(DataID.WEAPONLOADOUT_SLOTSDATA,this.bindLoadoutData);
         if(true == ScaleformUtil.isScaleform)
         {
            this.myPerkLabel.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_PERKS).toUpperCase() + " 1";
            if(this.myPerkLabel2 != null)
            {
               this.myPerkLabel2.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_PERKS).toUpperCase() + " 2";
            }
            if(this.myPerkLabel3 != null)
            {
               this.myPerkLabel3.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_PERKS).toUpperCase() + " 3";
            }
            this.myTacticalLabel.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_TACTICAL).toUpperCase();
            this.myLethalLabel.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_LETHAL).toUpperCase();
            this.myWildCardLabel.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_WILD_CARD).toUpperCase() + " 1";
            if(this.myWildCardLabel2 != null)
            {
               this.myWildCardLabel2.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_WILD_CARD).toUpperCase() + " 2";
            }
            if(this.myWildCardLabel3 != null)
            {
               this.myWildCardLabel3.label = LocalizeUtil.localize(Dict.LOADOUT_SLOT_WILD_CARD).toUpperCase() + " 3";
            }
            this.myPrimaryAttachmentLabel.label = LocalizeUtil.localize(Dict.WEAPONLOADOUT_ATTACHMENTS).toUpperCase();
            this.mySecondaryAttachmentLabel.label = LocalizeUtil.localize(Dict.WEAPONLOADOUT_ATTACHMENTS).toUpperCase();
            this.myPrimaryWeaponLabel.label = LocalizeUtil.localize(Dict.PRIMARY_WEAPON).toUpperCase();
            this.mySecondaryWeaponLabel.label = LocalizeUtil.localize(Dict.SECONDARY_WEAPON).toUpperCase();
         }
         this.myPrimaryWeaponLabel.width = this.mySecondaryWeaponLabel.width = this.mySecondaryWeaponSlot.myBackground.width;
         this.myPrimaryAttachmentLabel.width = this.mySecondaryAttachmentLabel.width = PERK_WIDTH;
         this.myPerkLabel.width = this.myWildCardLabel.width = this.myTacticalLabel.width = this.myLethalLabel.width = PERK_WIDTH;
         if(this.myPerkLabel2 != null)
         {
            this.myPerkLabel2.width = this.myPerkLabel.width;
         }
         if(this.myPerkLabel3 != null)
         {
            this.myPerkLabel3.width = this.myPerkLabel.width;
         }
         if(this.myWildCardLabel2 != null)
         {
            this.myWildCardLabel2.width = this.myWildCardLabel.width;
         }
         if(this.myWildCardLabel3 != null)
         {
            this.myWildCardLabel3.width = this.myWildCardLabel.width;
         }
         this.myTacticalLabel.x = this.myLethalLabel.x + PERK_WIDTH + PERK_PADDING_X;
         if(null != this.myOptions)
         {
            options = [{
               "id":RENAME,
               "enabled":true,
               "label":LocalizeUtil.localize(Dict.LOADOUT_RENAME)
            },{
               "id":COPY,
               "enabled":true,
               "label":LocalizeUtil.localize(Dict.LOADOUT_COPY)
            },{
               "id":PASTE,
               "enabled":false,
               "label":LocalizeUtil.localize(Dict.LOADOUT_PASTE)
            }];
            this.myOptions.label = LocalizeUtil.localize(Dict.LOADOUT_OPTIONS);
            this.myOptions.singleOptionMode = true;
            this.myOptions.clearOnSelect = true;
            this.myOptions.dataProvider = options;
            this.myOptions.addEventListener(ComboBox.EVT_CHANGE,this.onOptionsChanged);
            this.myOptions.width = 112;
            this.myOptions.listWidth = 140;
            this.myOptions.x = this.myPerk0Slot0.x + OPTIONS_BUTTON_OFFSET_X;
         }
         this.myPerk0Slot0.width = PERK_WIDTH;
         this.myPerk0Slot0.height = PERK_HEIGHT;
         this.myPerk0Slot0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPerk1Slot0.width = PERK_WIDTH;
         this.myPerk1Slot0.height = PERK_HEIGHT;
         this.myPerk1Slot0.x = this.myPerk0Slot0.x + PERK_WIDTH + PERK_PADDING_X;
         this.myPerk1Slot0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPerk2Slot0.width = PERK_WIDTH;
         this.myPerk2Slot0.height = PERK_HEIGHT;
         this.myPerk2Slot0.x = this.myPerk1Slot0.x + PERK_WIDTH + PERK_PADDING_X;
         this.myPerk2Slot0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPerk0Slot1.width = PERK_WIDTH;
         this.myPerk0Slot1.height = PERK_HEIGHT;
         this.myPerk0Slot1.y = this.myPerk0Slot0.y + PERK_HEIGHT;
         this.myPerk0Slot1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPerk1Slot1.width = PERK_WIDTH;
         this.myPerk1Slot1.height = PERK_HEIGHT;
         this.myPerk1Slot1.x = this.myPerk0Slot1.x + PERK_WIDTH + PERK_PADDING_X;
         this.myPerk1Slot1.y = this.myPerk0Slot1.y;
         this.myPerk1Slot1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPerk2Slot1.width = PERK_WIDTH;
         this.myPerk2Slot1.height = PERK_HEIGHT;
         this.myPerk2Slot1.x = this.myPerk1Slot1.x + PERK_WIDTH + PERK_PADDING_X;
         this.myPerk2Slot1.y = this.myPerk0Slot1.y;
         this.myPerk2Slot1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myLethal0.width = PERK_WIDTH;
         this.myLethal0.height = PERK_HEIGHT;
         this.myLethal0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myTactical0.width = PERK_WIDTH;
         this.myTactical0.height = PERK_HEIGHT;
         this.myTactical0.x = this.myLethal0.x + PERK_WIDTH + PERK_PADDING_X;
         this.myTactical0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myLethal1.width = PERK_WIDTH;
         this.myLethal1.height = PERK_HEIGHT;
         this.myLethal1.y = this.myLethal0.y + PERK_HEIGHT;
         this.myLethal1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myTactical1.width = PERK_WIDTH;
         this.myTactical1.height = PERK_HEIGHT;
         this.myTactical1.x = this.myLethal1.x + PERK_WIDTH + PERK_PADDING_X;
         this.myTactical1.y = this.myLethal1.y;
         this.myTactical1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryAttachment0.width = ATTACHMENT_WIDTH;
         this.myPrimaryAttachment0.height = ATTACHMENT_HEIGHT;
         this.myPrimaryAttachment0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryAttachment1.width = ATTACHMENT_WIDTH;
         this.myPrimaryAttachment1.height = ATTACHMENT_HEIGHT;
         this.myPrimaryAttachment1.y = this.myPrimaryAttachment0.y + ATTACHMENT_HEIGHT;
         this.myPrimaryAttachment1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryAttachment2.width = ATTACHMENT_WIDTH;
         this.myPrimaryAttachment2.height = ATTACHMENT_HEIGHT;
         this.myPrimaryAttachment2.y = this.myPrimaryAttachment1.y + ATTACHMENT_HEIGHT;
         this.myPrimaryAttachment2.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.mySecondaryAttachment0.width = ATTACHMENT_WIDTH;
         this.mySecondaryAttachment0.height = ATTACHMENT_HEIGHT;
         this.mySecondaryAttachment0.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.mySecondaryAttachment1.width = ATTACHMENT_WIDTH;
         this.mySecondaryAttachment1.height = ATTACHMENT_HEIGHT;
         this.mySecondaryAttachment1.y = this.mySecondaryAttachment0.y + ATTACHMENT_HEIGHT;
         this.mySecondaryAttachment1.scaleImage(ATTACHMENT_IMAGE_SCALE);
         this.myWildCard0.width = WILDCARD_WIDTH;
         this.myWildCard0.height = WILDCARD_HEIGHT;
         this.myWildCard1.width = WILDCARD_WIDTH;
         this.myWildCard1.height = WILDCARD_HEIGHT;
         this.myWildCard1.x = this.myWildCard0.x + WILDCARD_WIDTH + PERK_PADDING_X;
         this.myWildCard2.width = WILDCARD_WIDTH;
         this.myWildCard2.height = WILDCARD_HEIGHT;
         this.myWildCard2.x = this.myWildCard1.x + WILDCARD_WIDTH + PERK_PADDING_X;
         this.myWildCard0.scaleImage(WILDCARD_IMAGE_SCALE);
         this.myWildCard1.scaleImage(WILDCARD_IMAGE_SCALE);
         this.myWildCard2.scaleImage(WILDCARD_IMAGE_SCALE);
         this.myPrimaryWeaponSlot.myCamoSlot.scaleImage(WEAPONSLOT_ATTACHMENT_IMAGE_SCALE);
         this.mySecondaryWeaponSlot.myCamoSlot.scaleImage(WEAPONSLOT_ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryWeaponSlot.myReticleSlot.scaleImage(WEAPONSLOT_ATTACHMENT_IMAGE_SCALE);
         this.mySecondaryWeaponSlot.myReticleSlot.scaleImage(WEAPONSLOT_ATTACHMENT_IMAGE_SCALE);
         this.myPrimaryWeaponSlot.myDecalSlot.scaleImage(WEAPONSLOT_ATTACHMENT_DECAL_SCALE);
         this.mySecondaryWeaponSlot.myDecalSlot.scaleImage(WEAPONSLOT_ATTACHMENT_DECAL_SCALE);
         this.myLoadoutMeter.x = this.myPerk0Slot0.x;
         this.myPerk0Slot0.setBreadcrumb(UiCppNewItems.CRUMB_PERKS_1);
         this.myPerk0Slot1.setBreadcrumb(UiCppNewItems.CRUMB_PERKS_1);
         this.myPerk1Slot0.setBreadcrumb(UiCppNewItems.CRUMB_PERKS_2);
         this.myPerk1Slot1.setBreadcrumb(UiCppNewItems.CRUMB_PERKS_2);
         this.myPerk2Slot0.setBreadcrumb(UiCppNewItems.CRUMB_PERKS_3);
         this.myPerk2Slot1.setBreadcrumb(UiCppNewItems.CRUMB_PERKS_3);
         this.myWildCard0.setBreadcrumb(UiCppNewItems.CRUMB_WILDCARDS);
         this.myWildCard1.setBreadcrumb(UiCppNewItems.CRUMB_WILDCARDS);
         this.myWildCard2.setBreadcrumb(UiCppNewItems.CRUMB_WILDCARDS);
         this.myLethal0.setBreadcrumb(UiCppNewItems.CRUMB_LETHALS);
         this.myTactical0.setBreadcrumb(UiCppNewItems.CRUMB_TACTICALS);
         UiCppNewItems.instance.InitBreadcrumb(this.myPrimaryWeaponSlot,UiCppNewItems.CRUMB_PRIMARIES);
         UiCppNewItems.instance.InitBreadcrumb(this.mySecondaryWeaponSlot,UiCppNewItems.CRUMB_SECONDARIES);
         this.mOnboardUnlockPerksLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_PERKS);
         if(this.mOnboardUnlockPerksLevel != null)
         {
            this.myPerk0Slot0.setOnboardUnlockLevel(this.mOnboardUnlockPerksLevel);
            this.myPerk0Slot1.setOnboardUnlockLevel(this.mOnboardUnlockPerksLevel);
            this.myPerk1Slot0.setOnboardUnlockLevel(this.mOnboardUnlockPerksLevel);
            this.myPerk1Slot1.setOnboardUnlockLevel(this.mOnboardUnlockPerksLevel);
            this.myPerk2Slot0.setOnboardUnlockLevel(this.mOnboardUnlockPerksLevel);
            this.myPerk2Slot1.setOnboardUnlockLevel(this.mOnboardUnlockPerksLevel);
         }
         var wildcardLevel:String = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_WILDCARDS);
         if(wildcardLevel != null)
         {
            this.myWildCard0.setOnboardUnlockLevel(wildcardLevel);
            this.myWildCard1.setOnboardUnlockLevel(wildcardLevel);
            this.myWildCard2.setOnboardUnlockLevel(wildcardLevel);
         }
      }
      
      public function enableData() : void
      {
         this.clearCopyCache();
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
      
      public function setIsSuggestedLoadout() : void
      {
         var priAtt:LoadoutButton = null;
         var secAtt:LoadoutButton = null;
         var perks:Vector.<LoadoutButton> = null;
         var lethal:LoadoutButton = null;
         var tac:LoadoutButton = null;
         var perk:LoadoutButton = null;
         if(this.mBindWeaponLoadoutSlotsData != null)
         {
            this.mBindWeaponLoadoutSlotsData.unbind();
            this.mBindWeaponLoadoutSlotsData = null;
         }
         this.myOptions.visible = false;
         this.myContainer.visible = false;
         this.myLoadoutMeter.visible = false;
         this.myWildCard0.visible = false;
         this.myWildCard1.visible = false;
         this.myWildCard2.visible = false;
         this.myWildCardLabel.visible = false;
         this.myWildCardLabel2.visible = false;
         this.myWildCardLabel3.visible = false;
         this.myPerk0Slot1.visible = false;
         this.myPerk1Slot1.visible = false;
         this.myPerk2Slot1.visible = false;
         this.myLethal1.visible = false;
         this.myTactical1.visible = false;
         this.myPrimaryWeaponSlot.setIsSuggestedLoadout();
         this.mySecondaryWeaponSlot.setIsSuggestedLoadout();
         for each(priAtt in this.mPriAttaches)
         {
            priAtt.setIsSuggestedLoadout();
         }
         for each(secAtt in this.mSecAttaches)
         {
            secAtt.setIsSuggestedLoadout();
         }
         for each(perks in this.mPerks)
         {
            for each(perk in perks)
            {
               perk.setIsSuggestedLoadout();
            }
         }
         for each(lethal in this.mLethals)
         {
            lethal.setIsSuggestedLoadout();
         }
         for each(tac in this.mTacticals)
         {
            tac.setIsSuggestedLoadout();
         }
      }
      
      public function get primaryWeaponData() : ProductObj
      {
         return this.mPrimaryWeaponData;
      }
      
      public function get secondaryWeaponData() : ProductObj
      {
         return this.mSecondaryWeaponData;
      }
      
      public function get equippedItems() : int
      {
         return this.mEquippedItems;
      }
      
      public function get weaponLoadout() : WeaponLoadoutObj
      {
         return this.mWeaponLoadout;
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
      
      public function registerEditPrimaryReticleEvent(f:Function, clearFunction:Function) : void
      {
         this.myPrimaryWeaponSlot.customizeReticleCallback = f;
         this.myPrimaryWeaponSlot.myReticleSlot.registerClearCallback(clearFunction);
      }
      
      public function registerEditPrimaryCamoEvent(f:Function, clearFunction:Function) : void
      {
         this.myPrimaryWeaponSlot.customizeCamoCallback = f;
         this.myPrimaryWeaponSlot.myCamoSlot.registerClearCallback(clearFunction);
      }
      
      public function registerEditPrimaryDecalEvent(f:Function, clearFunction:Function) : void
      {
         this.myPrimaryWeaponSlot.customizeDecalCallback = f;
         this.myPrimaryWeaponSlot.myDecalSlot.registerClearCallback(clearFunction);
      }
      
      public function registerEditSecondaryReticleEvent(f:Function, clearFunction:Function) : void
      {
         this.mySecondaryWeaponSlot.customizeReticleCallback = f;
         this.mySecondaryWeaponSlot.myReticleSlot.registerClearCallback(clearFunction);
      }
      
      public function registerEditSecondaryCamoEvent(f:Function, clearFunction:Function) : void
      {
         this.mySecondaryWeaponSlot.customizeCamoCallback = f;
         this.mySecondaryWeaponSlot.myCamoSlot.registerClearCallback(clearFunction);
      }
      
      public function registerEditSecondaryDecalEvent(f:Function, clearFunction:Function) : void
      {
         this.mySecondaryWeaponSlot.customizeDecalCallback = f;
         this.mySecondaryWeaponSlot.myDecalSlot.registerClearCallback(clearFunction);
      }
      
      public function registerEditPrimaryAttachmentEvent(f:Function, clearFunction:Function) : void
      {
         this.myPrimaryAttachment0.registerClickEvent(f,0);
         this.myPrimaryAttachment0.registerClearCallback(clearFunction);
         this.myPrimaryAttachment1.registerClickEvent(f,1);
         this.myPrimaryAttachment1.registerClearCallback(clearFunction);
         this.myPrimaryAttachment2.registerClickEvent(f,2);
         this.myPrimaryAttachment2.registerClearCallback(clearFunction);
      }
      
      public function registerEditSecondaryAttachmentEvent(f:Function, clearFunction:Function) : void
      {
         this.mySecondaryAttachment0.registerClickEvent(f,0);
         this.mySecondaryAttachment0.registerClearCallback(clearFunction);
         this.mySecondaryAttachment1.registerClickEvent(f,1);
         this.mySecondaryAttachment1.registerClearCallback(clearFunction);
      }
      
      public function registerEditPerkEvent(f:Function, clearFunction:Function) : void
      {
         this.myPerk0Slot0.registerClickEvent(f,{
            "perk":0,
            "slot":0
         });
         this.myPerk1Slot0.registerClickEvent(f,{
            "perk":1,
            "slot":0
         });
         this.myPerk2Slot0.registerClickEvent(f,{
            "perk":2,
            "slot":0
         });
         this.myPerk0Slot1.registerClickEvent(f,{
            "perk":0,
            "slot":1
         });
         this.myPerk1Slot1.registerClickEvent(f,{
            "perk":1,
            "slot":1
         });
         this.myPerk2Slot1.registerClickEvent(f,{
            "perk":2,
            "slot":1
         });
         this.registerPerkClears(clearFunction);
         this.myPerk0Slot1.isExtraSlot = true;
         this.myPerk1Slot1.isExtraSlot = true;
         this.myPerk2Slot1.isExtraSlot = true;
      }
      
      public function registerPerkClears(clearFunction:Function) : void
      {
         if(this.mOnboardUnlockPerksLevel != null)
         {
            return;
         }
         this.myPerk0Slot0.registerClearCallback(clearFunction);
         this.myPerk1Slot0.registerClearCallback(clearFunction);
         this.myPerk2Slot0.registerClearCallback(clearFunction);
         this.myPerk0Slot1.registerClearCallback(clearFunction);
         this.myPerk1Slot1.registerClearCallback(clearFunction);
         this.myPerk2Slot1.registerClearCallback(clearFunction);
      }
      
      public function registerEditLethalEvent(f:Function, clearFunction:Function) : void
      {
         this.myLethal0.registerClickEvent(f,0);
         this.myLethal0.registerClearCallback(clearFunction);
         this.myLethal1.registerClickEvent(f,1);
         this.myLethal1.registerClearCallback(clearFunction);
         this.myLethal1.isExtraSlot = true;
      }
      
      public function registerEditTacticalEvent(f:Function, clearFunction:Function) : void
      {
         var btnData:CustomObject = new CustomObject({
            "label":"TAC1",
            "clearCallback":clearFunction,
            "id":"tac"
         });
         this.myTactical0.setData(btnData);
         this.myTactical0.registerClickEvent(f,0);
         btnData = new CustomObject({
            "label":"TAC2",
            "clearCallback":clearFunction,
            "id":"tac"
         });
         this.myTactical1.setData(btnData);
         this.myTactical1.registerClickEvent(f,1);
         this.myTactical1.isExtraSlot = true;
      }
      
      public function registerEditWildCardEvent(f:Function, clearFunction:Function) : void
      {
         var btnData:CustomObject = new CustomObject({
            "label":"WLD1",
            "clearCallback":clearFunction,
            "id":"wild1"
         });
         this.myWildCard0.setData(btnData);
         this.myWildCard0.registerClickEvent(f,0);
         btnData = new CustomObject({
            "label":"WLD2",
            "clearCallback":clearFunction,
            "id":"wild2"
         });
         this.myWildCard1.setData(btnData);
         this.myWildCard1.registerClickEvent(f,1);
         btnData = new CustomObject({
            "label":"WLD3",
            "clearCallback":clearFunction,
            "id":"wild3"
         });
         this.myWildCard2.setData(btnData);
         this.myWildCard2.registerClickEvent(f,2);
      }
      
      protected function bindLoadoutData(cResult:Object) : void
      {
         this.updateLoadout(new WeaponLoadoutObj(cResult.data));
      }
      
      public function updateLoadout(weaponLoadoutObj:WeaponLoadoutObj) : void
      {
         var loadoutButton:LoadoutButton = null;
         var item:ItemSlotObj = null;
         var copyToCharacterIndex:int = 0;
         var copyToLoadoutIdx:int = 0;
         this.mEquippedItems = CFunctionContainer.WL_GetPick10LoadoutCount();
         this.mWeaponLoadout = weaponLoadoutObj;
         var primaryItem:ItemSlotObj = this.mWeaponLoadout.primaryWeapSlot;
         var secondaryItem:ItemSlotObj = this.mWeaponLoadout.secondaryWeapSlot;
         this.mPrimaryWeaponData = CFunctionCommonContainer.GetItemInfo(primaryItem.item_id);
         this.mPrimaryWeaponData.isBanned = primaryItem.isBanned;
         this.mPrimaryWeaponData.hideExtendedButtons = true;
         this.myPrimaryWeaponSlot.setData(this.mPrimaryWeaponData);
         this.mSecondaryWeaponData = CFunctionCommonContainer.GetItemInfo(secondaryItem.item_id);
         this.mSecondaryWeaponData.isBanned = secondaryItem.isBanned;
         this.mSecondaryWeaponData.hideExtendedButtons = true;
         this.mySecondaryWeaponSlot.setData(this.mSecondaryWeaponData);
         var len:int = int(this.mWeaponLoadout.primarySlotArray.length);
         for(var i:int = 0; i < len; i++)
         {
            loadoutButton = this["myPrimaryAttachment" + i];
            item = new AttachmentSlotObj(this.mWeaponLoadout.primarySlotArray[i]);
            if(null != loadoutButton)
            {
               loadoutButton.setData(item);
            }
            else if(i == 3)
            {
               this.myPrimaryWeaponSlot.myCamoSlot.setData(this.mWeaponLoadout.primarySlotArray[i]);
            }
            else if(i == 4)
            {
               this.myPrimaryWeaponSlot.myReticleSlot.setData(this.mWeaponLoadout.primarySlotArray[i]);
            }
            else if(i == 5)
            {
               this.myPrimaryWeaponSlot.myDecalSlot.setData(this.mWeaponLoadout.primarySlotArray[i]);
            }
         }
         len = int(this.mWeaponLoadout.secondarySlotArray.length);
         for(i = 0; i < len; i++)
         {
            item = new AttachmentSlotObj(this.mWeaponLoadout.secondarySlotArray[i]);
            loadoutButton = this["mySecondaryAttachment" + i];
            if(null != loadoutButton)
            {
               loadoutButton.setData(item);
            }
            else if(i == 3)
            {
               this.mySecondaryWeaponSlot.myCamoSlot.setData(this.mWeaponLoadout.secondarySlotArray[i]);
            }
            else if(i == 4)
            {
               this.mySecondaryWeaponSlot.myReticleSlot.setData(this.mWeaponLoadout.secondarySlotArray[i]);
            }
            else if(i == 5)
            {
               this.mySecondaryWeaponSlot.myDecalSlot.setData(this.mWeaponLoadout.secondarySlotArray[i]);
            }
         }
         len = 3;
         for(i = 0; i < len; i++)
         {
            item = new ItemSlotObj(this.mWeaponLoadout["perkSlot_" + i]);
            loadoutButton = this["myPerk" + i + "Slot0"];
            loadoutButton.setData(item);
            item = new ItemSlotObj(this.mWeaponLoadout["perkSlot_" + (i + len)]);
            loadoutButton = this["myPerk" + i + "Slot1"];
            loadoutButton.setData(item);
         }
         this.myLethal0.setData(this.mWeaponLoadout.grenadeSlot_0);
         this.myLethal1.setData(this.mWeaponLoadout.grenadeSlot_1);
         this.mWeaponLoadout.grenadeSlot_2.isLocked = false;
         this.mWeaponLoadout.grenadeSlot_3.isLocked = false;
         this.myTactical0.setData(this.mWeaponLoadout.grenadeSlot_2);
         this.myTactical1.setData(this.mWeaponLoadout.grenadeSlot_3);
         len = 3;
         for(i = 0; i < len; i++)
         {
            item = new ItemSlotObj(this.mWeaponLoadout["wildcardSlot_" + i]);
            loadoutButton = this["myWildCard" + i];
            loadoutButton.setData(item);
         }
         var meterSettings:LoadoutMeterSettings = new LoadoutMeterSettings(this.mEquippedItems,this.mTickWidth,this.mTickPadding);
         this.myLoadoutMeter.setData(meterSettings);
         var pasteEnabled:Boolean = false;
         if(this.copyFromCharacterIndex > -1 && this.copyFromLoadoutIdx > -1)
         {
            copyToCharacterIndex = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
            copyToLoadoutIdx = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
            if(this.copyFromLoadoutIdx != copyToLoadoutIdx || this.copyFromCharacterIndex != copyToCharacterIndex)
            {
               pasteEnabled = true;
            }
         }
         this.enablePasteOption(pasteEnabled);
         if(this.myPrimaryWeaponSlot.getIsSuggestedLoadout())
         {
            this.myPrimaryWeaponSlot.myReticleSlot.visible = this.myPrimaryWeaponSlot.myReticleLabel.visible = false;
            this.myPrimaryWeaponSlot.myCamoSlot.visible = this.myPrimaryWeaponSlot.myCamoLabel.visible = false;
            this.myPrimaryWeaponSlot.myDecalSlot.visible = this.myPrimaryWeaponSlot.myDecalLabel.visible = false;
            this.mySecondaryWeaponSlot.myReticleSlot.visible = this.mySecondaryWeaponSlot.myReticleLabel.visible = false;
            this.mySecondaryWeaponSlot.myCamoSlot.visible = this.mySecondaryWeaponSlot.myCamoLabel.visible = false;
            this.mySecondaryWeaponSlot.myDecalSlot.visible = this.mySecondaryWeaponSlot.myDecalLabel.visible = false;
         }
      }
      
      public function registerLoadoutCopiedCb(f:Function) : void
      {
         this.mLoadoutCopiedCb = f;
      }
      
      public function clearCopyCache() : void
      {
         this.copyFromCharacterIndex = -1;
         this.copyFromLoadoutIdx = -1;
         this.enablePasteOption(false);
      }
      
      private function enablePasteOption(isEnabled:Boolean) : void
      {
         if(this.myOptions == null)
         {
            return;
         }
         var option:UIInteractiveComponent = this.myOptions.getOptionById(PASTE);
         if(Boolean(option))
         {
            option.enabled = isEnabled;
         }
      }
      
      private function onOptionsChanged(e:ParaEvent) : void
      {
         var copyToCharacterIndex:int = 0;
         var copyToLoadoutIdx:int = 0;
         var option:int = int(this.myOptions.selectedData.id);
         if(option == RENAME)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_RENAME_LOADOUT);
         }
         else if(option == COPY)
         {
            this.copyFromCharacterIndex = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
            this.copyFromLoadoutIdx = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
            this.enablePasteOption(false);
         }
         else if(option == PASTE)
         {
            if(this.copyFromCharacterIndex > -1 && this.copyFromLoadoutIdx > -1)
            {
               copyToCharacterIndex = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
               copyToLoadoutIdx = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
               if(this.copyFromLoadoutIdx != copyToLoadoutIdx || this.copyFromCharacterIndex != copyToCharacterIndex)
               {
                  CFunctionContainer.WL_CopyLoadoutFrom(this.copyFromCharacterIndex,this.copyFromLoadoutIdx);
                  if(this.mLoadoutCopiedCb != null)
                  {
                     this.mLoadoutCopiedCb();
                  }
                  this.clearCopyCache();
               }
            }
         }
      }
   }
}

