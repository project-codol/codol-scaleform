package codo.views.uitour
{
   import codo.localization.DictUITutorial;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   
   public class UITourInventoryPick10WildcardIntro extends UITutorialTourBase
   {
      
      public function UITourInventoryPick10WildcardIntro()
      {
         super();
         var FRAME_WIDTH_OUTLINE_WIDTH:uint = 375;
         var style:TextStyle = TutorialGuide.styleTextTitleAlignCenter;
         myTitleTF.textStyle = style;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         myDescriptionTF.textStyle = style;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_WITH_DESCRIPTION_WIDTH;
         title = DictUITutorial.UI_TOUR_INVENTORY_PICK10_WILDCARD_INTRO_TITLE;
         description = LocalizeUtil.localize(DictUITutorial.UI_TOUR_INVENTORY_PICK10_WILDCARD_INTRO_DESCRIPTION);
         myTitleTF.x = myDescriptionTF.x = myFrame.x + (FRAME_WIDTH_OUTLINE_WIDTH - TEXT_BOX_WITH_DESCRIPTION_WIDTH) * 0.5;
         myDescriptionTF.y = myTopicArrow.y - ARROW_BASE_HEIGHT - myDescriptionTF.textHeight;
         myTitleTF.y = myDescriptionTF.y - (myTitleTF.textHeight + CONTENT_PADDING);
      }
      
      override protected function initAnimation() : void
      {
         revealText();
      }
      
      override protected function onDescriptionRevealed() : void
      {
         myTopicArrow.active();
         myTopicArrow.animationCompleteCallback = animateOverlayGlowIn;
      }
   }
}

