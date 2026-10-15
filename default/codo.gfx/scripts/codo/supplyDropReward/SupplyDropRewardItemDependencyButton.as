package codo.supplyDropReward
{
   import codo.component.SupplyDropRewardItemErrorButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol782")]
   public dynamic class SupplyDropRewardItemDependencyButton extends SupplyDropRewardItemErrorButton
   {
      
      public function SupplyDropRewardItemDependencyButton()
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

