package codo.tours
{
   import codo.views.uitour.UITourAARCrateRewards;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3769")]
   public dynamic class UITourAARCrateRewards extends codo.views.uitour.UITourAARCrateRewards
   {
      
      public function UITourAARCrateRewards()
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

