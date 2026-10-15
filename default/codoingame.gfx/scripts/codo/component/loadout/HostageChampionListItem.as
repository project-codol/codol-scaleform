package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.constants.BCInGameEvent;
   import codo.constants.Common;
   import codo.manager.EventManager;
   import codo.objects.HostageChampionObj;
   import codo.objects.ProductObj;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HostageChampionListItem extends Button
   {
      
      private static const NORMAL_FRAME:int = 1;
      
      private static const HIGHLIGHT_FRAME:int = 2;
      
      private static const ICON_START_Y:int = 72;
      
      private static const DEFAULT_ICON_HEIGHT:int = 50;
      
      public static const WEAPON_INDEX:int = 0;
      
      public static const WEAPON_ATT0_INDEX:int = 1;
      
      public static const WEAPON_ATT1_INDEX:int = 2;
      
      public var myCustomizeButton:Button;
      
      public var myName:TextField;
      
      public var myDescription:TextField;
      
      public var myCharacterImage:FsgImageHolder;
      
      public var myPrimaryWeaponImage:FsgImageHolder;
      
      public var myPrimaryAttImage0:FsgImageHolder;
      
      public var myPrimaryAttImage1:FsgImageHolder;
      
      public var mySecondaryWeaponImage:FsgImageHolder;
      
      public var mySecondaryAttImage0:FsgImageHolder;
      
      public var mySecondaryAttImage1:FsgImageHolder;
      
      public var myLethal:FsgImageHolder;
      
      public var myTactical:FsgImageHolder;
      
      public var myKillstreak:FsgImageHolder;
      
      public var myPerk:HostageChampionListItemPerkComponent;
      
      public var myFrame:MovieClip;
      
      public var mySelection:MovieClip;
      
      private var mSelection:Object;
      
      public function HostageChampionListItem()
      {
         super();
         this.myCustomizeButton.labelUnfocusColor = 2236962;
         this.myCustomizeButton.width = 120;
         this.myCustomizeButton.height = 32;
         this.myCustomizeButton.forceEndHighlight();
         this.myCustomizeButton.label = "@UI_HUD_HOSTAGE_CUSTOMIZE";
         this.myCustomizeButton.registerClickEvent(this.onCustomize);
         this.myCustomizeButton.visible = CFunctionCommonContainer.Dvar_GetBool("ui_enable_hostage_customize") as Boolean;
      }
      
      override public function setData(data:*) : void
      {
         var primaryWeapon:ProductObj = null;
         var primaryAtt0:ProductObj = null;
         var primaryAtt1:ProductObj = null;
         var secondaryWeapon:ProductObj = null;
         var secondaryAtt0:ProductObj = null;
         var secondaryAtt1:ProductObj = null;
         super.setData(data);
         var champion:HostageChampionObj = new HostageChampionObj(data);
         if(champion == null)
         {
            return;
         }
         this.updateCustomizeButtonVisibility(champion);
         this.myName.text = champion.name;
         this.myDescription.text = champion.desc;
         this.myCharacterImage.setImage(champion.image);
         if(Boolean(champion.primary) && champion.primary.length >= 1)
         {
            primaryWeapon = champion.primary[WEAPON_INDEX];
         }
         if(Boolean(champion.primary) && champion.primary.length >= 2)
         {
            primaryAtt0 = champion.primary[WEAPON_ATT0_INDEX];
         }
         if(Boolean(champion.primary) && champion.primary.length >= 3)
         {
            primaryAtt1 = champion.primary[WEAPON_ATT1_INDEX];
         }
         if(Boolean(champion.secondary) && champion.secondary.length >= 1)
         {
            secondaryWeapon = champion.secondary[WEAPON_INDEX];
         }
         if(Boolean(champion.secondary) && champion.secondary.length >= 2)
         {
            secondaryAtt0 = champion.secondary[WEAPON_ATT0_INDEX];
         }
         if(Boolean(champion.secondary) && champion.secondary.length >= 3)
         {
            secondaryAtt1 = champion.secondary[WEAPON_ATT1_INDEX];
         }
         if(Boolean(primaryWeapon))
         {
            this.myPrimaryWeaponImage.setImage(primaryWeapon.imageURL);
         }
         else
         {
            this.myPrimaryWeaponImage.clearImage();
         }
         if(Boolean(secondaryWeapon))
         {
            this.mySecondaryWeaponImage.setImage(secondaryWeapon.imageURL);
         }
         else
         {
            this.mySecondaryWeaponImage.clearImage();
         }
         if(Boolean(primaryAtt0))
         {
            this.myPrimaryAttImage0.setImage(primaryAtt0.imageURL);
         }
         else
         {
            this.myPrimaryAttImage0.clearImage();
         }
         if(Boolean(primaryAtt1))
         {
            this.myPrimaryAttImage1.setImage(primaryAtt1.imageURL);
         }
         else
         {
            this.myPrimaryAttImage1.clearImage();
         }
         if(Boolean(secondaryAtt0))
         {
            this.mySecondaryAttImage0.setImage(secondaryAtt0.imageURL);
         }
         else
         {
            this.mySecondaryAttImage0.clearImage();
         }
         if(Boolean(secondaryAtt1))
         {
            this.mySecondaryAttImage1.setImage(secondaryAtt1.imageURL);
         }
         else
         {
            this.mySecondaryAttImage1.clearImage();
         }
         if(Boolean(champion.perks) && champion.perks.length > 0)
         {
            this.myPerk.setData(champion.perks);
            this.myPerk.visible = true;
         }
         else
         {
            this.myPerk.visible = false;
         }
         if(Boolean(champion.lethal) && champion.lethal.imageURL != "")
         {
            this.myLethal.setImage(champion.lethal.imageURL);
            this.myLethal.visible = true;
         }
         else
         {
            this.myLethal.clearImage();
            this.myLethal.visible = false;
         }
         if(Boolean(champion.tactical) && champion.tactical.imageURL != "")
         {
            this.myTactical.setImage(champion.tactical.imageURL);
            this.myTactical.visible = true;
         }
         else
         {
            this.myTactical.clearImage();
            this.myTactical.visible = false;
         }
         if(Boolean(champion.killstreak) && champion.killstreak.imageURL != "")
         {
            this.myKillstreak.setImage(champion.killstreak.imageURL);
            this.myKillstreak.visible = true;
         }
         else
         {
            this.myKillstreak.clearImage();
            this.myKillstreak.visible = false;
         }
         var comps:Array = [this.myLethal,this.myTactical,this.myKillstreak];
         var startY:int = ICON_START_Y;
         for(var i:int = 0; i < comps.length; i++)
         {
            if((comps[i] as MovieClip).visible)
            {
               comps[i].y = startY;
               startY += DEFAULT_ICON_HEIGHT;
            }
         }
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(mToggled)
         {
            this.myFrame.gotoAndStop(HIGHLIGHT_FRAME);
         }
         else
         {
            this.myFrame.gotoAndStop(NORMAL_FRAME);
         }
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      public function setSelection(selection:Object) : void
      {
         this.mSelection = selection;
         if(Boolean(selection))
         {
            this.mySelection.myValue.text = String(selection.count);
         }
         else
         {
            this.mySelection.myValue.text = "0";
         }
      }
      
      public function getSelection() : Object
      {
         return this.mSelection;
      }
      
      private function onCustomize() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HOSTAGE_CUSTOMIZE_CHAMPION,new HostageChampionObj(mData));
      }
      
      private function updateCustomizeButtonVisibility(champion:HostageChampionObj) : void
      {
         var baseWeapon:int = 0;
         var variants:Array = null;
         if(Boolean(champion.primary))
         {
            baseWeapon = champion.primary[WEAPON_INDEX].baseID > 0 ? champion.primary[WEAPON_INDEX].baseID : champion.primary[WEAPON_INDEX].id;
            variants = CFunctionCommonContainer.AS_GetWeaponVariantList(baseWeapon,Common.LIST_TYPE_All,ProductObj.TIER_EPIC);
            this.myCustomizeButton.visible = variants.length > 1;
         }
         else
         {
            this.myCustomizeButton.visible = false;
         }
      }
   }
}

