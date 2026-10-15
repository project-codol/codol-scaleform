package codo.shared
{
   import codo.component.LoadingSpinner;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2468")]
   public dynamic class Loading extends LoadingSpinner
   {
      
      public function Loading()
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

