package fsg.myComplaintViewContent
{
   import fsg.shared.ComboBoxItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4009")]
   public dynamic class ComboBoxItem extends fsg.shared.ComboBoxItem
   {
      
      public function ComboBoxItem()
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

