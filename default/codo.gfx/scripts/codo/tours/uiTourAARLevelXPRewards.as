package codo.tours
{
   import codo.views.uitour.UITourAARLevelXPRewards;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3768")]
   public dynamic class uiTourAARLevelXPRewards extends UITourAARLevelXPRewards
   {
      
      public function uiTourAARLevelXPRewards()
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

