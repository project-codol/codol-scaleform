package codo.debugger
{
   [Embed(source="/_assets/assets.swf", symbol="symbol472")]
   public dynamic class debugButton extends DebugButton
   {
      
      public function debugButton()
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

