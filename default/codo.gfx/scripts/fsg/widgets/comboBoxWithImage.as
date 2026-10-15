package fsg.widgets
{
   import fsg.shared.ComboBoxWithImage;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2070")]
   public dynamic class comboBoxWithImage extends ComboBoxWithImage
   {
      
      public function comboBoxWithImage()
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

