package codo.supplyDropReward
{
   import codo.views.supplyDrop_parts.SupplyDropRewardItemCoverPieceBottom;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2562")]
   public dynamic class SupplyDropRewardItemCoverBottom extends SupplyDropRewardItemCoverPieceBottom
   {
      
      public function SupplyDropRewardItemCoverBottom()
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

