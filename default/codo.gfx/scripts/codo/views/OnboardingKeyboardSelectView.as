package codo.views
{
   import codo.base.BaseView;
   import codo.component.CallToActionButton;
   import codo.component.OnboardingKeyboardOption;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.cpp.UiCppOnboarding;
   import codo.localization.Dict;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.TLogUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   
   public class OnboardingKeyboardSelectView extends BaseView
   {
      
      public var myOptionStandard:OnboardingKeyboardOption;
      
      public var myOptionTraditional:OnboardingKeyboardOption;
      
      public var myContinueButton:CallToActionButton;
      
      public var myHeader:TextField;
      
      private var m_currentSelectedOption:OnboardingKeyboardOption;
      
      public function OnboardingKeyboardSelectView()
      {
         super();
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_HUGE;
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.width = 800;
         this.myHeader.height = 56;
         this.myHeader.text = LocalizeUtil.localize("@SF_KEYBOARD_SELECT_KEYBOARD_LAYOUT");
         this.myContinueButton.label = LocalizeUtil.localize(Dict.CONFIRM);
         this.myContinueButton.registerClickEvent(this.onConfirm);
         this.myOptionStandard.setData(Common.KEYBOARD_CODO);
         this.myOptionTraditional.setData(Common.KEYBOARD_CROSSFIRE);
         this.myOptionStandard.registerClickEvent(this.onKeyboardSelected,this.myOptionStandard);
         this.myOptionTraditional.registerClickEvent(this.onKeyboardSelected,this.myOptionTraditional);
         this.m_currentSelectedOption = this.myOptionStandard;
         this.m_currentSelectedOption.selected = true;
         this.myHeader.alpha = 0;
         this.myContinueButton.alpha = 0;
         this.myOptionStandard.alpha = 0;
         this.myOptionTraditional.alpha = 0;
      }
      
      override protected function showView() : void
      {
         var distance:Number = NaN;
         var duration:Number = NaN;
         var endY:Number = NaN;
         super.showView();
         distance = 24;
         duration = 0.2;
         endY = this.myHeader.y;
         this.myHeader.y -= distance;
         TweenLite.to(this.myHeader,duration,{
            "alpha":1,
            "y":endY,
            "ease":Cubic.easeOut
         });
         endY = this.myOptionStandard.y;
         this.myOptionStandard.y -= distance;
         TweenLite.to(this.myOptionStandard,duration,{
            "alpha":1,
            "y":endY,
            "delay":duration,
            "ease":Cubic.easeOut
         });
         endY = this.myOptionTraditional.y;
         this.myOptionTraditional.y -= distance;
         TweenLite.to(this.myOptionTraditional,duration,{
            "alpha":1,
            "y":endY,
            "delay":duration * 2,
            "ease":Cubic.easeOut
         });
         endY = this.myContinueButton.y;
         this.myContinueButton.y -= distance;
         TweenLite.to(this.myContinueButton,duration,{
            "alpha":1,
            "y":endY,
            "delay":duration * 3,
            "ease":Cubic.easeOut
         });
      }
      
      private function onKeyboardSelected(e:OnboardingKeyboardOption) : void
      {
         var selectedKeyboard:OnboardingKeyboardOption = e;
         if(selectedKeyboard == this.m_currentSelectedOption)
         {
            return;
         }
         this.m_currentSelectedOption.selected = false;
         this.m_currentSelectedOption = selectedKeyboard;
         selectedKeyboard.selected = true;
      }
      
      private function onConfirm() : void
      {
         broadcast(BCEvent.CHOOSE_KEYBOARD,{"keyboard":this.m_currentSelectedOption.keyboardID});
         TLogUtil.TLog_keyboard(this.m_currentSelectedOption.keyboardID);
         UiCppOnboarding.instance.FinishControlsStep();
      }
   }
}

