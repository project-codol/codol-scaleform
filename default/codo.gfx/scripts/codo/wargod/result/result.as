package codo.wargod.result
{
   import codo.views.wargodMatchResult_parts.Result;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3291")]
   public dynamic class result extends Result
   {
      
      public function result()
      {
         super();
         addFrameScript(0,this.frame1,25,this.frame26);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame26() : *
      {
         stop();
         complete();
      }
   }
}

