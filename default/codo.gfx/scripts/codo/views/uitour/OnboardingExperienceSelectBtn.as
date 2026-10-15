package codo.views.uitour
{
   import codo.component.Button;
   import codo.component.tutorial.UITourToolTip;
   import codo.localization.DictUITutorial;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.text.TextFieldAutoSize;
   
   public class OnboardingExperienceSelectBtn extends Button
   {
      
      public var myToolTip:UITourToolTip;
      
      private var mToolTipObj:UITourToolTipObj;
      
      public function OnboardingExperienceSelectBtn()
      {
         super();
         var textStyle:TextStyle = new TextStyle();
         this.myToolTip.deactive();
         textStyle.alignment = TextStyle.HALIGN_CENTER;
         textStyle.font = GlobalGuide.FONT_FACE_BOLD;
         textStyle.fontSize = 36;
         textStyle.autoSize = TextFieldAutoSize.NONE;
         myLabel.width = 266;
         myLabel.height = 55;
         myLabel.textStyle = textStyle;
         myLabel.x = myHitArea.x;
         myLabel.alpha = 0.7;
         this.myToolTip.byPassArrowAnimation = true;
         this.myToolTip.myShadow.visible = false;
         this.myToolTip.myGeneralTitleTF.text = ScaleformUtil.isScaleform ? DictUITutorial.ONBOARDING_CHOOSE_EXPERIENCE_LEVEL : "EXPERIENCE LEVEL";
      }
      
      public function set toolTip(tipObj:UITourToolTipObj) : void
      {
         this.mToolTipObj = tipObj;
      }
      
      override protected function showHighlight() : void
      {
         gotoAndPlay(2);
         TweenLite.to(myLabel,0.2,{
            "alpha":1,
            "y":-5,
            "ease":Cubic.easeOut
         });
         this.myToolTip.showHelpTip(this.mToolTipObj);
      }
      
      override protected function endHighlight() : void
      {
         gotoAndPlay(9);
         TweenLite.to(myLabel,0.2,{
            "alpha":0.7,
            "y":0,
            "ease":Cubic.easeOut
         });
         this.myToolTip.deactive();
      }
   }
}

