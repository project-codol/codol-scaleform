package codo.shared
{
   import codo.views.supplyDrop_parts.SupplyDropRewardItemCoverLockCenter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2067")]
   public dynamic class SupplyDropRewardItemCoverLockCenter extends codo.views.supplyDrop_parts.SupplyDropRewardItemCoverLockCenter
   {
      
      public function SupplyDropRewardItemCoverLockCenter()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame7() : *
      {
         stop();
      }
   }
}

