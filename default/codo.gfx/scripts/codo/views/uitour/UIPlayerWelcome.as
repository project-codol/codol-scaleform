package codo.views.uitour
{
   import codo.component.InputTextField;
   import codo.component.TextField;
   import codo.component.factory.GlobalFactory;
   import codo.constants.UITourVOSoundAliases;
   import codo.localization.Dict;
   import codo.localization.DictOnBoard;
   import codo.style.OnboardingGuide;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class UIPlayerWelcome extends UITutorialTourBase
   {
      
      private static const MESSAGE_WIDTH:Number = 580;
      
      private static const DISABLE_STATE_ALPHA:Number = 0.5;
      
      private static const LOCALIZE:Function = LocalizeUtil.localize;
      
      private static const PADDING:uint = 10;
      
      private static const FIELD_FRAME_MOUSEOUT:uint = 1;
      
      private static const FIELD_FRAME_MOUSEOVER:uint = 2;
      
      private static const FIELD_FRAME_FOCUSED:uint = 3;
      
      private var mWarningIcon:Sprite;
      
      private var mBaseWarningMsg:String;
      
      public var mGamerTagInputTF:InputTextField;
      
      public var myInputErrorMsgTxt:TextField;
      
      public var myLogo:Sprite;
      
      public var myFocusLine:MovieClip;
      
      public var myFieldBackground:MovieClip;
      
      public var myGhostImage:Sprite;
      
      public function UIPlayerWelcome()
      {
         super();
         var glow:GlowFilter = new GlowFilter(806783,0.5,15,15);
         myTitleTF.filters = [glow];
         myDescriptionTF.filters = [glow];
         var LOCALIZE:Function = LocalizeUtil.localize;
         this.myInputErrorMsgTxt.textStyle = OnboardingGuide.styleCreateGameTagWarningText;
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescription;
         myDescriptionTF.width = myTitleTF.width = 325;
         this.mWarningIcon = addChild(GlobalFactory.BUILD_ICON_DISABLED(40)) as Sprite;
         this.mGamerTagInputTF = addChild(GlobalFactory.BUILD_INPUT_TEXT_FIELD(OnboardingGuide.styleCreateGamerTagTextField)) as InputTextField;
         title = DictOnBoard.FIRST_WELCOME_TITLE;
         description = LOCALIZE(DictOnBoard.FIRST_WELCOME_MESSAGE);
         this.mBaseWarningMsg = LOCALIZE(DictOnBoard.FIRST_WELCOME_NAME_TEXT_LIMIT);
         myTitleTF.width = myDescriptionTF.width = MESSAGE_WIDTH;
         this.showOrHideErrorMsg(null);
         this.configContent();
         this.myGhostImage.mouseEnabled = false;
         this.mGamerTagInputTF.alpha = this.myLogo.alpha = this.myLogo.scaleX = this.myLogo.scaleY = this.myFieldBackground.alpha = this.myFocusLine.alpha = 0;
      }
      
      private function onSubmitFail() : void
      {
         this.showOrHideErrorMsg(this.mBaseWarningMsg);
      }
      
      public function get requestedGamerTag() : String
      {
         return this.mGamerTagInputTF.text;
      }
      
      private function configContent() : void
      {
         myCallToActionButton.enabled = false;
         myCallToActionButton.alpha = DISABLE_STATE_ALPHA;
         this.myInputErrorMsgTxt.height = this.mWarningIcon.height;
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         myCallToActionButton.label = Dict.CONTINUE;
         this.mGamerTagInputTF.width = this.myInputErrorMsgTxt.width = this.myFieldBackground.width - PADDING * 2;
         this.mGamerTagInputTF.height = this.myFocusLine.height;
         this.mGamerTagInputTF.x = this.mWarningIcon.x = this.myFieldBackground.x + PADDING;
         this.mGamerTagInputTF.y = this.myFieldBackground.y = myDescriptionTF.y + myDescriptionTF.textHeight + CONTENT_PADDING * 2;
         this.mGamerTagInputTF.ObfuscateEnabled = true;
         this.myFocusLine.y = this.mGamerTagInputTF.y - 1;
         this.mWarningIcon.y = this.myInputErrorMsgTxt.y = this.mGamerTagInputTF.y + myCallToActionButton.height + PADDING * 2;
         this.myInputErrorMsgTxt.x = this.mWarningIcon.x + this.mWarningIcon.width + PADDING;
         myCallToActionButton.height = this.myFocusLine.height - 4;
         myCallToActionButton.y = this.myFieldBackground.y;
         myCallToActionButton.x = this.myFieldBackground.x + this.myFieldBackground.width + CONTENT_PADDING;
      }
      
      public function configureGamerTagInput(submitCallback:Function) : void
      {
         this.mGamerTagInputTF.minLength = StringUtil.getMinEnglishNameCharacterCount();
         this.mGamerTagInputTF.maxLength = StringUtil.getMaxEnglishNameCharacterCount();
         this.mGamerTagInputTF.defaultInputFieldMessage = LOCALIZE(DictOnBoard.FIRST_WELCOME_INPUT);
         this.mGamerTagInputTF.restrict = StringUtil.INPUT_FIELD_NAME_RESTRICTION;
         this.mGamerTagInputTF.registerOnInputChangeCallback(this.onInputChangeHandle);
         this.mGamerTagInputTF.registerOnInputSubmitCallback(submitCallback);
         this.mGamerTagInputTF.registerOnInputSubmitFailCallback(this.onSubmitFail);
         registerCallToActionEvent(submitCallback);
         this.mGamerTagInputTF.registerOnInputMouseOverCallback(this.onFieldMouseOver);
         this.mGamerTagInputTF.registerOnInputMouseOutCallback(this.onFieldMouseOut);
         this.mGamerTagInputTF.registerOnInputFocusInCallback(this.onFieldFocus);
         this.mGamerTagInputTF.registerOnInputFocusInCallback(this.onFieldFocus);
         this.mGamerTagInputTF.registerOnInputFocusOutCallback(this.onFieldFocus);
      }
      
      override protected function initAnimation() : void
      {
         TweenLite.to(this.myLogo,0.4,{
            "alpha":1,
            "scaleY":1,
            "scaleX":1,
            "ease":Cubic.easeOut,
            "onComplete":this.revealText
         });
      }
      
      override protected function get callToActionInitialAlpha() : Number
      {
         return DISABLE_STATE_ALPHA;
      }
      
      override protected function revealText() : void
      {
         var endY:int = myTitleTF.y;
         myTitleTF.y = endY - CONTENT_PADDING * 2;
         mTransitionTimeline.append(new TweenLite(myTitleTF,0.2,{
            "alpha":1,
            "y":endY,
            "ease":Cubic.easeOut,
            "onComplete":onTitleRevealed
         }));
         endY = myDescriptionTF.y;
         myDescriptionTF.y = endY - CONTENT_PADDING * 2;
         mTransitionTimeline.append(new TweenLite(myDescriptionTF,0.4,{
            "alpha":1,
            "y":endY,
            "ease":Cubic.easeOut,
            "onComplete":this.onDescriptionRevealed
         }));
      }
      
      override protected function onDescriptionRevealed() : void
      {
         var endY:int = 0;
         endY = this.myFieldBackground.y;
         this.myFieldBackground.y = endY - CONTENT_PADDING * 2;
         endY = myCallToActionButton.y;
         myCallToActionButton.y = endY - CONTENT_PADDING * 2;
         mTransitionTimeline.append(new TweenLite(this.myFieldBackground,0.4,{
            "alpha":1,
            "y":endY,
            "ease":Cubic.easeOut
         }));
         mTransitionTimeline.append(new TweenLite(this.myFocusLine,0.2,{
            "alpha":1,
            "ease":Cubic.easeOut
         }));
         mTransitionTimeline.append(new TweenLite(myCallToActionButton,0.3,{
            "alpha":this.callToActionInitialAlpha,
            "y":endY,
            "ease":Cubic.easeOut,
            "onComplete":this.onCalltoActionRevealed
         }));
         mTransitionTimeline.append(new TweenLite(this.mGamerTagInputTF,0.4,{
            "alpha":1,
            "ease":Cubic.easeOut
         }));
      }
      
      override protected function onCalltoActionRevealed() : void
      {
         animateOverlayGlowIn();
      }
      
      private function onFieldMouseOver() : void
      {
         this.myFieldBackground.gotoAndStop(FIELD_FRAME_MOUSEOVER);
      }
      
      private function onFieldMouseOut() : void
      {
         this.myFieldBackground.gotoAndStop(FIELD_FRAME_MOUSEOUT);
      }
      
      private function onFieldFocus() : void
      {
         if(this.myFocusLine.currentFrame == 1)
         {
            this.myFocusLine.gotoAndStop(2);
         }
         else
         {
            this.myFocusLine.gotoAndStop(1);
         }
         this.myFieldBackground.gotoAndStop(FIELD_FRAME_FOCUSED);
      }
      
      private function onInputChangeHandle() : void
      {
         myCallToActionButton.enabled = this.mGamerTagInputTF.inputIsValid;
         myCallToActionButton.alpha = myCallToActionButton.enabled ? 1 : 0.5;
         if(myCallToActionButton.enabled)
         {
            this.showOrHideErrorMsg(null);
         }
      }
      
      public function showOrHideErrorMsg(err:String, errCode:int = -1) : void
      {
         var sound:String = null;
         this.myInputErrorMsgTxt.visible = this.mWarningIcon.visible = err != null;
         if(err != null)
         {
            this.myInputErrorMsgTxt.text = err;
            sound = UITourVOSoundAliases.CALLSIGN_TRY_AGAIN;
            if(errCode == 709)
            {
               sound = UITourVOSoundAliases.CALLSIGN_PROHIBITED;
            }
            playSound(sound);
         }
      }
   }
}

