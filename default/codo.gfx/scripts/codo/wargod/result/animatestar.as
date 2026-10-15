package codo.wargod.result
{
   import codo.views.wargodMatchResult_parts.AnimateStar;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3459")]
   public dynamic class animatestar extends AnimateStar
   {
      
      public function animatestar()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,41,this.frame42,52,this.frame53,63,this.frame64);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame42() : *
      {
         stop();
      }
      
      internal function frame53() : *
      {
         stop();
      }
      
      internal function frame64() : *
      {
         stop();
      }
   }
}

