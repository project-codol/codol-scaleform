package fsg.widgets
{
   import fsg.shared.ComboBoxItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2025")]
   public dynamic class comboBoxItemNEW extends ComboBoxItem
   {
      
      public function comboBoxItemNEW()
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

