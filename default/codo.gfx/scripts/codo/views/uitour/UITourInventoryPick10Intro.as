package codo.views.uitour
{
   import codo.component.Button;
   import codo.constants.GameInfo;
   import codo.localization.Dict;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   
   public class UITourInventoryPick10Intro extends UITutorialTourBase
   {
      
      public var myCancelBtn:Button;
      
      public var myPlayTourVideoButton:Button;
      
      public function UITourInventoryPick10Intro()
      {
         super();
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_WITH_DESCRIPTION_WIDTH;
         this.myCancelBtn.label = DictUITutorial.UI_TOUR_PICK10_BUTTON_LABEL_CANCEL;
         this.myPlayTourVideoButton.label = Dict.TUTORIAL_VIDEO_LIST;
         this.myCancelBtn.alpha = this.myPlayTourVideoButton.alpha = 0;
      }
      
      public function setToStepIntro() : void
      {
         gotoAndStop(TUTORIAL_FRAME_FIRST);
         title = DictUITutorial.UI_TOUR_INVENTORY_PICK10_INTRO_TITLE;
         description = LocalizeUtil.localize(DictUITutorial.UI_TOUR_INVENTORY_PICK10_INTRO_DESCRIPTION);
         myCallToActionButton.label = DictUITutorial.UI_TOUR_PICK10_BUTTON_LABEL_TAKE_TOUR;
         this.positionAssetsAndShow();
      }
      
      private function positionAssetsAndShow() : void
      {
         var offset:int = 0;
         var centerpoint:int = (GameInfo.DEFAULT_WIDTH - TEXT_BOX_WITH_DESCRIPTION_WIDTH) * 0.5;
         offset = this.myPlayTourVideoButton.width + CONTENT_PADDING;
         myDescriptionTF.x = myTitleTF.x = centerpoint;
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         myCallToActionButton.y = this.myCancelBtn.y = this.myPlayTourVideoButton.y = myDescriptionTF.y + myDescriptionTF.textHeight + CONTENT_PADDING * 5;
         myTopicArrow.y = myCallToActionButton.y + myCallToActionButton.height + CONTENT_PADDING;
         this.myPlayTourVideoButton.x = myTitleTF.x + (TEXT_BOX_WITH_DESCRIPTION_WIDTH - myCallToActionButton.width) * 0.5;
         this.myCancelBtn.x = this.myPlayTourVideoButton.x - offset;
         myCallToActionButton.x = this.myPlayTourVideoButton.x + offset;
         myTopicArrow.x = myCallToActionButton.x + myTopicArrow.width - myCallToActionButton.width + 22;
         show();
      }
      
      override protected function initAnimation() : void
      {
         revealText();
      }
      
      override protected function appendAddionalAnimations() : void
      {
         var endY:int = this.myCancelBtn.y;
         this.myCancelBtn.y = this.myPlayTourVideoButton.y = endY - CONTENT_PADDING * 2;
         mTransitionTimeline.append(new TweenLite(this.myPlayTourVideoButton,0.2,{
            "alpha":1,
            "y":endY,
            "ease":Cubic.easeOut
         }));
         myTopicArrow.animationStartCallback = animateOverlayGlowIn;
         mTransitionTimeline.append(new TweenLite(this.myCancelBtn,0.2,{
            "alpha":1,
            "y":endY,
            "ease":Cubic.easeOut,
            "onComplete":myTopicArrow.active
         }));
      }
   }
}

