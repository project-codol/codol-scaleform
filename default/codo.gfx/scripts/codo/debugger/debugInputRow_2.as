package codo.debugger
{
   [Embed(source="/_assets/assets.swf", symbol="symbol1301")]
   public dynamic class debugInputRow extends DebugInputRow
   {
      
      public function debugInputRow()
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

