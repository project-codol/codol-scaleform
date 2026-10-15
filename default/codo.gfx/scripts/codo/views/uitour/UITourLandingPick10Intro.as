package codo.views.uitour
{
   import codo.constants.GameInfo;
   import codo.localization.Dict;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   
   public class UITourLandingPick10Intro extends UITutorialTourBase
   {
      
      public function UITourLandingPick10Intro()
      {
         super();
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_WITH_DESCRIPTION_WIDTH;
         title = DictUITutorial.UI_TOUR_LANDING_PICK10_INTRO_TITLE;
         description = LocalizeUtil.localize(DictUITutorial.UI_TOUR_LANDING_PICK10_INTRO_DESCRIPTION);
         myCallToActionButton.label = Dict.CONTINUE;
         this.positionAssets();
      }
      
      override protected function initAnimation() : void
      {
         revealText();
      }
      
      override protected function onDescriptionRevealed() : void
      {
         myTopicArrow.active();
         myTopicArrow.animationStartCallback = animateOverlayGlowIn;
      }
      
      private function positionAssets() : void
      {
         var centerpoint:int = (GameInfo.DEFAULT_WIDTH - TEXT_BOX_WITH_DESCRIPTION_WIDTH) * 0.5;
         myDescriptionTF.x = myTitleTF.x = centerpoint;
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         myCallToActionButton.y = myDescriptionTF.y + myDescriptionTF.textHeight + CONTENT_PADDING * 5;
         myTopicArrow.y = myCallToActionButton.y + myCallToActionButton.height + CONTENT_PADDING;
         myCallToActionButton.x = myTitleTF.x + (TEXT_BOX_WITH_DESCRIPTION_WIDTH - myCallToActionButton.width) * 0.5;
         myTopicArrow.x = myCallToActionButton.x + myTopicArrow.width - myCallToActionButton.width + 22;
      }
   }
}

