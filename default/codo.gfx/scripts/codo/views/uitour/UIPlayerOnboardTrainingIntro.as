package codo.views.uitour
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.cpp.UiCppOnboarding;
   import codo.localization.Dict;
   import codo.localization.DictOnBoard;
   import codo.localization.DictRoom;
   import codo.localization.DictUITutorial;
   import codo.manager.EventManager;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.style.GlobalGuide;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class UIPlayerOnboardTrainingIntro extends UITutorialTourBase
   {
      
      public var mySkipOnboardingButton:Button;
      
      public var _tempIsExperienceSelect:Boolean;
      
      public var myBtnVet:OnboardingExperienceSelectBtn;
      
      public var myBtnNovice:OnboardingExperienceSelectBtn;
      
      public var mySep:Sprite;
      
      public function UIPlayerOnboardTrainingIntro()
      {
         super();
         var glow:GlowFilter = new GlowFilter(806783,0.5,15,15);
         myTitleTF.filters = [glow];
         myDescriptionTF.filters = [glow];
         myTitleTF.fontSize = GlobalGuide.FONT_SIZE_HUGE;
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescription;
         myDescriptionTF.width = myTitleTF.width = 600;
         this.mySkipOnboardingButton.visible = false;
         this.myBtnNovice.label = LocalizeUtil.localize("@UI_TUTORIAL_ONBOARDING_INTRO_NOVICE");
         this.myBtnVet.label = LocalizeUtil.localize("@UI_TUTORIAL_ONBOARDING_INTRO_EXPERT");
         this.myBtnVet.alpha = this.myBtnNovice.alpha = 0;
         this.mySep.width = 0;
      }
      
      public function tempInitExperienceSelect(isExperienceSelect:Boolean) : void
      {
         var strVETTitle:String = null;
         var strVETDescription:String = null;
         var strNOOBTitle:String = null;
         var strNOOBDescription:String = null;
         var vetToolTipObj:UITourToolTipObj = null;
         var noviceToolTipObj:UITourToolTipObj = null;
         var userName:String = null;
         this._tempIsExperienceSelect = isExperienceSelect;
         var ISDEBUG:Boolean = !ScaleformUtil.isScaleform;
         if(isExperienceSelect)
         {
            strVETTitle = ISDEBUG ? "VETERAN" : DictUITutorial.ONBOARDING_INTRO_EXPERT;
            strVETDescription = ISDEBUG ? "Have you played a Call of Duty series competitive match before and would like to skip the training?" : DictUITutorial.ONBOARDING_INTRO_VET_DESCRIPTION;
            strNOOBTitle = ISDEBUG ? "NOVICE" : DictUITutorial.ONBOARDING_INTRO_NOVICE;
            strNOOBDescription = ISDEBUG ? "Select this option if you have never played a Call of Duty series game before and would like to learn the game\'s controls and unique combat features." : DictUITutorial.ONBOARDING_INTRO_NOVICE_DESCRIPTION;
            vetToolTipObj = new UITourToolTipObj("",0,strVETTitle,strVETDescription,new Point(-538,0),true,null,null,null,UITourToolTip.STYLE_0_BTN_NO_ARROW);
            noviceToolTipObj = new UITourToolTipObj("",0,strNOOBTitle,strNOOBDescription,new Point(52,0),true,null,null,null,UITourToolTip.STYLE_0_BTN_NO_ARROW);
            myTitleTF.text = LocalizeUtil.localize("@UI_TUTORIAL_ONBOARDING_INTRO_TITLE");
            myDescriptionTF.text = LocalizeUtil.localize("@UI_TUTORIAL_ONBOARDING_INTRO_DESC");
            myCallToActionButton.visible = this.mySkipOnboardingButton.visible = false;
            this.myBtnVet.toolTip = vetToolTipObj;
            this.myBtnNovice.toolTip = noviceToolTipObj;
            this.myBtnVet.y = this.myBtnNovice.y = this.mySkipOnboardingButton.y + 80;
            this.myBtnVet.registerClickEvent(this.onSkipOnboarding);
         }
         else
         {
            userName = CFunctionCommonContainer.GetPlayerName().name;
            myCallToActionButton.visible = this.mySkipOnboardingButton.visible = true;
            this.myBtnVet.visible = this.myBtnNovice.visible = false;
            LocalizeUtil.paramFont(myTitleTF.myTextClip,DictOnBoard.ONBOARD_GAMER_TAG_CREATE_SUCCESS_TITLE,[userName],[GameInfo.GAME_FONT_L]);
            myDescriptionTF.text = LocalizeUtil.localize(DictOnBoard.ONBOARD_GAMER_TAG_CREATE_SUCCESS_BEGIN_TRAINING);
            myCallToActionButton.label = Dict.CONTINUE;
            this.mySkipOnboardingButton.label = DictRoom.TUTORIAL_SKIP;
            this.mySkipOnboardingButton.registerClickEvent(this.onSkipOnboarding);
         }
         this.positionContent();
      }
      
      override protected function get shouldAnimateCallToAction() : Boolean
      {
         return !this._tempIsExperienceSelect;
      }
      
      override public function registerCallToActionEvent(callback:Function, data:* = null) : void
      {
         if(!this._tempIsExperienceSelect)
         {
            myCallToActionButton.setClickCallback(callback,data,true);
         }
         else
         {
            this.myBtnNovice.registerClickEvent(callback,data);
         }
      }
      
      override protected function appendAddionalAnimations() : void
      {
         var endY:int = 0;
         var animDuration:Number = NaN;
         var exp:uint = 0;
         endY = this.mySkipOnboardingButton.y;
         animDuration = 0.2;
         if(!this._tempIsExperienceSelect)
         {
            exp = CFunctionCommonContainer.GetPlayerOnboardType();
            if(exp == UiCppOnboarding.TYPE_MR5_NOVICE)
            {
               this.mySkipOnboardingButton.visible = false;
               return;
            }
            this.mySkipOnboardingButton.alpha = 0;
            this.mySkipOnboardingButton.visible = true;
            this.mySkipOnboardingButton.y -= CONTENT_PADDING * 2;
            mTransitionTimeline.append(new TweenLite(this.mySkipOnboardingButton,animDuration,{
               "alpha":callToActionInitialAlpha,
               "y":endY,
               "ease":Cubic.easeOut
            }));
            mTransitionTimeline.append(new TweenLite(this.mySkipOnboardingButton,animDuration,{
               "alpha":callToActionInitialAlpha,
               "y":endY,
               "ease":Cubic.easeOut
            }));
         }
         else
         {
            endY = this.myBtnVet.y - 30;
            this.myBtnVet.y = this.myBtnNovice.y = this.myBtnVet.y - 20;
            this.mySep.y = this.myBtnVet.y - 24;
            mTransitionTimeline.append(new TweenLite(this.mySep,animDuration,{
               "width":600,
               "ease":Cubic.easeOut
            }));
            mTransitionTimeline.append(new TweenLite(this.myBtnVet,animDuration,{
               "alpha":callToActionInitialAlpha,
               "y":endY,
               "ease":Cubic.easeOut
            }));
            mTransitionTimeline.append(new TweenLite(this.myBtnNovice,animDuration,{
               "alpha":callToActionInitialAlpha,
               "y":endY,
               "ease":Cubic.easeOut
            }));
         }
      }
      
      private function onSkipOnboarding() : void
      {
         if(this._tempIsExperienceSelect)
         {
            UiCppOnboarding.instance.FinishExperienceStep(true);
            return;
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_CLEAR_SHOW_MATCH_RESULT_DVAR);
         UiCppOnboarding.instance.FinishTutorialIntroStep(true);
      }
      
      private function positionContent() : void
      {
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING * 2;
         myCallToActionButton.y = this.mySkipOnboardingButton.y = myDescriptionTF.y + myDescriptionTF.textHeight + CONTENT_PADDING * 2;
      }
      
      override protected function initAnimation() : void
      {
         revealText();
      }
   }
}

