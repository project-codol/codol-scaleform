package codo.views.uitour
{
   import codo.constants.UITourVOSoundAliases;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   
   public class UITourLandingNewUser extends UITutorialTourBase
   {
      
      public function UITourLandingNewUser()
      {
         super();
         myTitleTF.textStyle = TutorialGuide.styleTextTitle;
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_DEFAULT_WIDTH;
      }
      
      public function showNewUserEquipPrimary() : void
      {
         playSound(UITourVOSoundAliases.LANDING_GO_TO_LOADOUT_EQUIP_WEAPON);
         title = DictUITutorial.ONBOARDING_UI_TOUR_LANDING_EQUIP_ITEM_TITLE;
         description = DictUITutorial.ONBOARDING_UI_TOUR_LANDING_EQUIP_ITEM_DESCRIPTION;
         this.positionContent();
         myDescriptionTF.x = myTitleTF.x;
      }
      
      private function positionContent() : void
      {
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         show();
      }
   }
}

