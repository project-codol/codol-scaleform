package components.fsgquestionnaire_part
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import flash.display.MovieClip;
   
   public class FsgQuestionOption extends UIInteractiveComponent
   {
      
      public var myCheckBox:MovieClip;
      
      public var myLabel:TextField;
      
      private var mChecked:Boolean = false;
      
      public function FsgQuestionOption()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.width = 1000;
         this.myLabel.wordWrap = false;
         this.myLabel.multiline = false;
      }
      
      public function set label(l:String) : void
      {
         this.myLabel.text = l;
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      public function get checked() : Boolean
      {
         return this.mChecked;
      }
      
      public function set checked(check:Boolean) : void
      {
         this.mChecked = check;
         this.myCheckBox.gotoAndStop(check ? 2 : 1);
      }
   }
}

