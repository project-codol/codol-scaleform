package codo.views.uitour
{
   import codo.constants.UITourVOSoundAliases;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   
   public class UITourInventoryNewUserEquipPrimarySecondary extends UITutorialTourBase
   {
      
      public function UITourInventoryNewUserEquipPrimarySecondary()
      {
         super();
         myTitleTF.width = myDescriptionTF.width = 450;
         myDescriptionTF.height = 96;
      }
      
      public function setToEquipPrimary() : void
      {
         myDescriptionTF.visible = true;
         playSound(UITourVOSoundAliases.INVENTORY_CLICK_PRIMARY_SLOT);
         gotoAndStop(TUTORIAL_FRAME_FIRST);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_FIRST);
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         title = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_EQUIP_PRIMARY_TITLE;
         description = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_EQUIP_PRIMARY_DESCRIPTION;
         this.positionContentAndShow();
      }
      
      public function setToEquipSecondary(useAlt:Boolean = false) : void
      {
         if(!useAlt)
         {
            playSound(UITourVOSoundAliases.MARKET_DETAILS_ADD_FURTHER_ATTACHMENTS);
         }
         else
         {
            playSound(UITourVOSoundAliases.INVENTORY_CLICK_SECONDARY_SLOT);
         }
         gotoAndStop(TUTORIAL_FRAME_SECOND);
         myOverlay.gotoAndStop(TUTORIAL_FRAME_SECOND);
         myTitleTF.y = 700;
         title = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_EQUIP_SECONDARY_TITLE;
         description = DictUITutorial.ONBOARDING_UI_TOUR_LOADOUT_SELECT_EQUIP_SECONDARY_DESCRIPTION;
         this.positionContentAndShow();
      }
      
      private function positionContentAndShow() : void
      {
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         show();
      }
   }
}

