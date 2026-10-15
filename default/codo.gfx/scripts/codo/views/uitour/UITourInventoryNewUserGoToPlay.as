package codo.views.uitour
{
   import codo.constants.UITourVOSoundAliases;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   
   public class UITourInventoryNewUserGoToPlay extends UITutorialTourBase
   {
      
      public function UITourInventoryNewUserGoToPlay()
      {
         super();
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = 650;
      }
      
      public function showPlaySecondMission() : void
      {
         playSound(UITourVOSoundAliases.INVENTORY_GOTO_SECOND_TRAINING);
         title = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_GO_TO_PLAY_TITLE;
         description = DictUITutorial.ONBOARDING_UI_TOUR_INVENTORY_GO_TO_PLAY_DESCRIPTION;
         this.positionContent();
      }
      
      private function positionContent() : void
      {
         myDescriptionTF.x = myTitleTF.x;
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         show();
      }
   }
}

