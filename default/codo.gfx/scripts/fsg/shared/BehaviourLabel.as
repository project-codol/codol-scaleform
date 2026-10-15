package fsg.shared
{
   import flash.text.TextField;
   
   public class BehaviourLabel
   {
      
      protected var m_textField:TextField;
      
      public function BehaviourLabel(textField:TextField)
      {
         super();
         this.m_textField = textField;
      }
      
      public function setText(str:String) : void
      {
         if(this.m_textField != null)
         {
            this.m_textField.text = str;
         }
      }
      
      public function getText() : String
      {
         if(this.m_textField != null)
         {
            return this.m_textField.text;
         }
         return "";
      }
      
      public function setAutoSize(mode:String) : void
      {
         if(this.m_textField != null)
         {
            this.m_textField.autoSize = mode;
         }
      }
   }
}

