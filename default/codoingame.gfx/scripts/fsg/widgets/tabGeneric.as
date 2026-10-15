package fsg.widgets
{
   import fsg.shared.Tab;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2500")]
   public dynamic class tabGeneric extends Tab
   {
      
      public function tabGeneric()
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

