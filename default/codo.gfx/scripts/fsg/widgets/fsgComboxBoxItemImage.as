package fsg.widgets
{
   import fsg.shared.ComboBoxImageItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2069")]
   public dynamic class fsgComboxBoxItemImage extends ComboBoxImageItem
   {
      
      public function fsgComboxBoxItemImage()
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

