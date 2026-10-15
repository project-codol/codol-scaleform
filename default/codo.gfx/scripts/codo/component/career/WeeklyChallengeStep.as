package codo.component.career
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.localization.DictCareer;
   import codo.localization.DictChallenge;
   import codo.manager.EventManager;
   import codo.objects.WeeklyChallengeObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.views.CareerTabsView;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class WeeklyChallengeStep extends UIInteractiveComponent
   {
      
      public var myBackground:MovieClip;
      
      public var myStepNumber:TextField;
      
      public var myProgress:TextField;
      
      public var myReward:TextField;
      
      public var myInfoAvailable:TextField;
      
      public var myOpenDay:TextField;
      
      public var myDescription:TextField;
      
      public var myLabel:TextField;
      
      public var myCompleteLabel:TextField;
      
      public var myCompleteModule:MovieClip;
      
      public var myImage:FsgImageHolder;
      
      public var myFocusBackground:MovieClip;
      
      private var mDisabled:Boolean;
      
      private var mGotoChallengePage:Boolean = false;
      
      public function WeeklyChallengeStep()
      {
         super();
         this.myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myLabel.fontSize = 30;
         this.myLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myLabel.height = 64;
         this.myReward.font = GlobalGuide.FONT_FACE_BOLD;
         this.myReward.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myReward.alignment = TextStyle.HALIGN_CENTER;
         this.myDescription.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myDescription.alignment = TextStyle.HALIGN_CENTER;
         this.myDescription.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         this.myProgress.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myProgress.fontSize = 28;
         this.myProgress.alignment = TextStyle.HALIGN_CENTER;
         this.myStepNumber.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myStepNumber.fontSize = 60;
         this.myStepNumber.alignment = TextStyle.HALIGN_RIGHT;
         this.myInfoAvailable.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myInfoAvailable.alignment = TextStyle.HALIGN_CENTER;
         this.myOpenDay.font = GlobalGuide.FONT_FACE_BOLD;
         this.myOpenDay.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myOpenDay.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myOpenDay.alignment = TextStyle.HALIGN_CENTER;
         this.myCompleteLabel = this.myCompleteModule["myCompleteLabel"];
         this.myCompleteLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myCompleteLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myCompleteLabel.width = 200;
         this.myCompleteLabel.text = LocalizeUtil.localize(DictCareer.CAREER_COMPLETE);
         this.myInfoAvailable.width = this.myOpenDay.width = this.myDescription.width = this.myLabel.width = 165;
         this.myProgress.width = 120;
         this.myReward.width = 300;
         this.myDescription.height = 75;
         this.myStepNumber.height = 75;
         this.myImage.alpha = 0.1;
         this.myFocusBackground.visible = false;
         this.myInfoAvailable.text = LocalizeUtil.localize(DictChallenge.CHALLENGES_AVAILABLE_AT);
      }
      
      public function gotoChallengePage(page:Boolean) : void
      {
         this.mGotoChallengePage = page;
      }
      
      public function disableClick() : void
      {
         this.mDisabled = true;
      }
      
      private function set stepNumber(step:int) : void
      {
         this.myStepNumber.text = step.toString();
         gotoAndStop(step);
      }
      
      override public function setData(data:*) : void
      {
         var weeklyChallengeData:WeeklyChallengeObj = null;
         super.setData(data);
         weeklyChallengeData = data as WeeklyChallengeObj;
         this.stepNumber = weeklyChallengeData.step + 1;
         this.myImage.setImage(weeklyChallengeData.icon);
         this.myCompleteModule.visible = false;
         this.myInfoAvailable.visible = false;
         this.myOpenDay.visible = false;
         this.myDescription.visible = false;
         this.myProgress.visible = true;
         if(!this.mDisabled)
         {
            isInteractiveEnabled = true;
         }
         if(weeklyChallengeData.finished)
         {
            this.myBackground.gotoAndStop(3);
            this.myCompleteModule.visible = true;
            this.myProgress.visible = false;
         }
         else if(weeklyChallengeData.revealed)
         {
            this.myBackground.gotoAndStop(2);
            this.myDescription.text = weeklyChallengeData.description;
            this.myDescription.visible = true;
         }
         else
         {
            this.myBackground.gotoAndStop(1);
            this.myInfoAvailable.visible = true;
            this.myOpenDay.visible = true;
            if(weeklyChallengeData.step >= 2)
            {
               this.myOpenDay.text = LocalizeUtil.localize("@SF_UI_FRIDAY");
            }
            else
            {
               this.myOpenDay.text = LocalizeUtil.localize("@SF_UI_WEDNESDAY");
            }
            isInteractiveEnabled = false;
         }
         this.myLabel.text = weeklyChallengeData.name;
         this.myProgress.text = weeklyChallengeData.progress.toString() + "/" + weeklyChallengeData.target.toString();
         var rewardText:String = weeklyChallengeData.getRewardText();
         this.myReward.text = rewardText;
      }
      
      override protected function onMouseClick() : void
      {
         if(this.mGotoChallengePage)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_CAREER_CHALLENGES,{"tabIndex":CareerTabsView.TAB_CHALLENGES});
         }
         else
         {
            EventManager.getInstance().broadcast(BCEvent.OPEN_CHALLENGE_SUMMARY,{"challenge":mData});
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myFocusBackground.visible = true;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myFocusBackground.visible = false;
      }
   }
}

