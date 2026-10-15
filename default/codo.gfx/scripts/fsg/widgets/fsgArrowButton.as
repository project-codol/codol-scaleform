package fsg.widgets
{
   import fsg.shared.ButtonGeneric;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol141")]
   public dynamic class fsgArrowButton extends ButtonGeneric
   {
      
      public function fsgArrowButton()
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

