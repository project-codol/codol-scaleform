package fsg.widgets
{
   import fsg.shared.ComboBox;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1710")]
   public dynamic class comboBoxOption extends ComboBox
   {
      
      public function comboBoxOption()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

