package fsg.widgets
{
   import fsg.shared.ComboBoxItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol752")]
   public dynamic class comboBoxItem extends ComboBoxItem
   {
      
      public function comboBoxItem()
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

