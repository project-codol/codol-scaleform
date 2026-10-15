package fsg.widgets
{
   import fsg.shared.ComboBox;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1846")]
   public dynamic class comboBox extends ComboBox
   {
      
      public function comboBox()
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

