package codo.supplyDropReward
{
   import codo.views.supplyDrop_parts.SupplyDropRewardItemCoverPiece;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol977")]
   public dynamic class SupplyDropRewardItemCoverTop extends SupplyDropRewardItemCoverPiece
   {
      
      public function SupplyDropRewardItemCoverTop()
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

