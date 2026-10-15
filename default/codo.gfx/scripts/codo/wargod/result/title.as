package codo.wargod.result
{
   import codo.views.wargodMatchResult_parts.Title;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3308")]
   public dynamic class title extends Title
   {
      
      public function title()
      {
         super();
         addFrameScript(19,this.frame20);
      }
      
      internal function frame20() : *
      {
         stop();
         complete();
      }
   }
}

