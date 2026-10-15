package codo.views.uitour
{
   import codo.constants.UITourVOSoundAliases;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   
   public class UITourLoadoutSelectNewUserEquipNewPrimarySecondary extends UITutorialTourBase
   {
      
      public function UITourLoadoutSelectNewUserEquipNewPrimarySecondary()
      {
         super();
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_DEFAULT_WIDTH;
      }
      
      public function setToPrimary(isOnboardingMode:Boolean = true) : void
      {
         if(isOnboardingMode)
         {
            playSound(UITourVOSoundAliases.LOADOUT_SELECT_EQUIP_NEW_WEAPON);
            title = DictUITutorial.ONBOARDING_UI_TOUR_LOADOUT_SELECT_EQUIP_PRIMARY_TITLE;
            description = DictUITutorial.ONBOARDING_UI_TOUR_LOADOUT_SELECT_EQUIP_PRIMARY_DESCRIPTION;
         }
         else
         {
            title = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_PERK_1_TITLE;
            description = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_PERK_1_DESCRIPTION;
         }
         myTitleTF.y = 548;
         this.positionContent();
         show();
      }
      
      public function setWildCardSlot() : void
      {
         title = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_WILDCARD_TITLE;
         description = DictUITutorial.UI_TOUR_PICK10_LOADOUT_SELECT_CLICK_TO_EQUIP_WILDCARD_DESCRIPTION;
         myTitleTF.y = 548;
         this.positionContent();
         show();
      }
      
      public function setToSecondary(isPreEquip:Boolean = false) : void
      {
         if(isPreEquip)
         {
            playSound(UITourVOSoundAliases.MARKET_SELECT_STINGER);
            title = DictUITutorial.ONBOARDING_UI_TOUR_MARKETPLACE_SELECT_ITEM_TITLE;
            description = DictUITutorial.ONBOARDING_UI_TOUR_MARKETPLACE_SELECT_ITEM_DESCRIPTION;
            myDescriptionTF.visible = true;
            this.positionContent();
         }
         else
         {
            playSound(UITourVOSoundAliases.MARKET_PURCHASE_STINGER_SUCCESS);
            title = DictUITutorial.ONBOARDING_UI_TOUR_LOADOUT_SELECT_EQUIP_SECONDARY_TITLE;
            myDescriptionTF.visible = false;
         }
         show();
      }
      
      private function positionContent() : void
      {
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
      }
   }
}

