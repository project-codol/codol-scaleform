package codo.views.uitour
{
   import codo.constants.UITourVOSoundAliases;
   import codo.localization.Dict;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   
   public class UITourAARLevelXPRewards extends UITutorialTourBase
   {
      
      private var mInitAnimationShow:Boolean = true;
      
      public function UITourAARLevelXPRewards()
      {
         super();
         myTitleTF.width = myDescriptionTF.width = 650;
         myCallToActionButton.label = Dict.QUESTION_NEXT;
         myTitleTF.textStyle = TutorialGuide.styleTextTitle;
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
      }
      
      public function showGPReward(callToAction:Function, step:uint) : void
      {
         playSound(UITourVOSoundAliases.AAR_EARN_EXPERIENCE_AND_GP);
         alpha = 0;
         gotoAndStop(TUTORIAL_FRAME_FIRST);
         title = DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH_EARNED_GP_TITLE;
         description = DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH_EARNED_GP_DESCRIPTION;
         registerCallToActionEvent(callToAction,step);
         this.positionContent(174);
         TweenLite.to(this,0.3,{
            "alpha":1,
            "ease":Linear.easeInOut,
            "onComplete":show
         });
      }
      
      public function showXPReward(callToAction:Function, step:uint) : void
      {
         playSound(UITourVOSoundAliases.AAR_MORE_EXPERIENCE_XP_RANK_UP);
         gotoAndStop(TUTORIAL_FRAME_SECOND);
         title = DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH_EARNED_XP_TITLE;
         description = DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH_EARNED_XP_DESCRIPTION;
         this.positionContent(254);
         registerCallToActionEvent(callToAction,step);
         show();
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
      
      public function set assetsAreVisible(doShow:Boolean) : void
      {
         myTopicArrow.visible = myTitleTF.visible = myDescriptionTF.visible = myCallToActionButton.visible = doShow;
      }
      
      public function showSupplyDropReward(callToAction:Function, step:uint) : void
      {
         myTitleTF.textStyle = TutorialGuide.styleTextTitle;
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         gotoAndStop(TUTORIAL_FRAME_THIRD);
         title = DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH_SUPPLY_DROP_TITLE;
         description = LocalizeUtil.localize(DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH_SUPPLY_DROP_DESCRIPTION);
         myTitleTF.y = 794;
         myTitleTF.x = myDescriptionTF.x = myCallToActionButton.x = 943;
         myTitleTF.width = myDescriptionTF.width = 600;
         myTopicArrow.x = myTitleTF.x - 110;
         myDescriptionTF.y = myTitleTF.y + (myTitleTF.textHeight + CONTENT_PADDING);
         myCallToActionButton.y = myDescriptionTF.y + (myDescriptionTF.textHeight + CONTENT_PADDING);
         registerCallToActionEvent(callToAction,step);
         show();
      }
      
      public function showLevelUpReward(callToAction:Function, step:uint) : void
      {
         this.assetsAreVisible = true;
         playSound(UITourVOSoundAliases.AAR_UNLOCK_WEAPONS);
         myTitleTF.width = myDescriptionTF.width = 650;
         gotoAndStop(TUTORIAL_FRAME_FOURTH);
         title = DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH_LEVEL_REWARD_TITLE;
         description = LocalizeUtil.localize(DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH_LEVEL_REWARD_DESCRIPTION);
         myTitleTF.x = myDescriptionTF.x = myCallToActionButton.x = 712;
         myTitleTF.y = 524;
         myTopicArrow.x = 580;
         myDescriptionTF.y = myTitleTF.y + (myTitleTF.textHeight + CONTENT_PADDING);
         myCallToActionButton.y = myDescriptionTF.y + (myDescriptionTF.textHeight + CONTENT_PADDING);
         registerCallToActionEvent(callToAction,step);
         show();
      }
      
      private function positionContent(titleY:uint) : void
      {
         var yPos:uint = titleY + myTitleTF.textHeight + CONTENT_PADDING;
         myTitleTF.x = myTopicArrow.x + ARROW_BASE_HEIGHT;
         myTitleTF.y = titleY;
         if(myDescriptionTF != null)
         {
            myDescriptionTF.y = yPos;
            if(myDescriptionTF.visible)
            {
               yPos = myDescriptionTF.y + myDescriptionTF.textHeight + CONTENT_PADDING;
            }
            myDescriptionTF.x = myCallToActionButton.x = myTitleTF.x;
         }
         if(myCallToActionButton != null)
         {
            myCallToActionButton.y = yPos;
         }
      }
   }
}

