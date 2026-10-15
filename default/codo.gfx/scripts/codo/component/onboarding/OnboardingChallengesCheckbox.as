package codo.component.onboarding
{
   import codo.component.career.ChallengeScoreLabel;
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.OnboardingCheckboxObj;
   import codo.style.GlobalGuide;
   import codo.utils.SoundUtil;
   import codo.utils.StringUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class OnboardingChallengesCheckbox extends UIInteractiveComponent
   {
      
      private static const MAX_WIDTH:int = 285;
      
      public var myLabel:TextField;
      
      public var myValue:TextField;
      
      public var myCheck:Sprite;
      
      public var myOutline:Sprite;
      
      public var myMask:Sprite;
      
      public var myTag:ChallengeScoreLabel;
      
      private var mAnimateProgress:Boolean;
      
      public function OnboardingChallengesCheckbox()
      {
         super();
         isInteractiveEnabled = true;
         this.myValue.autoSize = TextFieldAutoSize.LEFT;
         this.myValue.text = "";
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var checkboxData:OnboardingCheckboxObj = data as OnboardingCheckboxObj;
         this.myCheck.visible = this.myValue.visible = false;
         this.myMask.width = 0;
         this.myLabel.text = checkboxData.name;
         this.myCheck.visible = checkboxData.finished;
         this.myValue.textColor = this.myLabel.textColor = checkboxData.finished ? GlobalGuide.CODO_BLUE_LIGHT : 16777215;
         if(checkboxData.progress != null)
         {
            this.myValue.visible = true;
            this.myValue.text = checkboxData.progress.toUpperCase();
            this.myLabel.x = this.myValue.x + this.myValue.textWidth + 6;
         }
         else
         {
            this.myLabel.x = 40;
         }
         this.myLabel.width = MAX_WIDTH - this.myLabel.x;
         StringUtil.fitTextFieldByLength(this.myLabel,this.myLabel.width);
         if(checkboxData.tag != null)
         {
            this.myTag.setText(checkboxData.tag);
            this.myTag.setCompleted(checkboxData.finished);
            this.myTag.visible = true;
            this.myOutline.visible = false;
            this.myCheck.visible = false;
         }
         else
         {
            this.myTag.visible = false;
         }
         myHitArea.width = this.myLabel.x + this.myLabel.textWidth + 6;
         this.mAnimateProgress = checkboxData.animateIn;
      }
      
      public function animateIn(delay:Number = 0, doAnim:Boolean = false) : void
      {
         if(doAnim)
         {
            TweenLite.to(this.myMask,0.2,{
               "width":this.width + 6,
               "ease":Cubic.easeOut,
               "delay":delay,
               "onComplete":this.onAnimComplete,
               "onCompleteParams":[this.mAnimateProgress]
            });
         }
         else
         {
            this.myMask.width = this.width + 6;
            this.onAnimComplete(false);
         }
      }
      
      private function onAnimComplete(animProgress:Boolean) : void
      {
         if(this.myCheck.visible)
         {
            if(animProgress)
            {
               gotoAndPlay(2);
               SoundUtil.getInstance().playSound("ui_actionreport_checkboxcheck_01");
            }
            else
            {
               gotoAndStop("end");
            }
         }
      }
   }
}

