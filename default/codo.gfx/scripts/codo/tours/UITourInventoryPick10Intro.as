package codo.tours
{
   import codo.views.uitour.UITourInventoryPick10Intro;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4093")]
   public dynamic class UITourInventoryPick10Intro extends codo.views.uitour.UITourInventoryPick10Intro
   {
      
      public function UITourInventoryPick10Intro()
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

