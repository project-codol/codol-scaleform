package codo.views.supplydrop
{
   import codo.views.supplyDrop_parts.SupplyDropRewardItemPanel;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5852")]
   public dynamic class supplydroprewarditempanel extends SupplyDropRewardItemPanel
   {
      
      public function supplydroprewarditempanel()
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

