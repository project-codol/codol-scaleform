package components.fsgonboardpopups_part.character
{
   import codo.constants.OnboardingSound;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import flash.display.Sprite;
   import fsg.shared.popups.PopupButtonShared;
   
   public class FsgCharacterSelectViewItemButtonPanel extends Sprite
   {
      
      public var myConfirmBtn:PopupButtonShared;
      
      public var myCancelBtn:PopupButtonShared;
      
      public function FsgCharacterSelectViewItemButtonPanel()
      {
         super();
      }
      
      public function config(confirm:Function, cancel:Function) : void
      {
         this.myConfirmBtn.setText(DictSystem.CONFIRM);
         this.myCancelBtn.setText(Dict.CANCEL);
         this.myConfirmBtn.clickCallback = confirm;
         this.myCancelBtn.clickCallback = cancel;
         this.myConfirmBtn.behaviorAudio.overrideClickAudio(OnboardingSound.CHARACTER_SELECT_CONFIRM);
         this.myCancelBtn.behaviorAudio.overrideClickAudio(OnboardingSound.CHARACTER_SELECT_CANCEL);
         this.autosizeButtonToText();
      }
      
      private function autosizeButtonToText() : void
      {
         var maxWidth:uint = 0;
         var MAX:Function = Math.max;
         var PADDING:uint = 20;
         maxWidth = MAX(maxWidth,MAX(this.myConfirmBtn.txtField.textWidth,this.myCancelBtn.txtField.textWidth));
         this.myConfirmBtn.setButtonToTextWidth(maxWidth + PADDING);
         this.myCancelBtn.setButtonToTextWidth(maxWidth + PADDING);
         this.flowButtonXPos();
      }
      
      private function flowButtonXPos() : void
      {
         var BUTTON_PADDING_HORIZ:uint = 5;
         this.myConfirmBtn.x = this.myCancelBtn.x + this.myCancelBtn.width + BUTTON_PADDING_HORIZ;
      }
   }
}

