package
{
   import fsg.shared.CheckBox;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2101")]
   public dynamic class fsgCheckBox extends CheckBox
   {
      
      public function fsgCheckBox()
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

