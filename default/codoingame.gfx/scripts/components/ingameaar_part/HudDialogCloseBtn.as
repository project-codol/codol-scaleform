package components.ingameaar_part
{
   import codo.localization.Dict;
   import components.BaseButton;
   import flash.text.TextField;
   
   public class HudDialogCloseBtn extends BaseButton
   {
      
      public var myLabelTF:TextField;
      
      public function HudDialogCloseBtn()
      {
         super();
         this.myLabelTF.text = Dict.BACK;
         this.myLabelTF.appendText(" (ESC)");
      }
   }
}

