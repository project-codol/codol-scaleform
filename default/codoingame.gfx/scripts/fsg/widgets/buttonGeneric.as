package fsg.widgets
{
   import fsg.shared.ButtonGeneric;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1423")]
   public dynamic class buttonGeneric extends ButtonGeneric
   {
      
      public function buttonGeneric()
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

