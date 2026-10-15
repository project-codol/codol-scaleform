package codo.component.loadout
{
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   
   public class LoadoutViewRequisitionsPanelConsumablesShards extends LoadoutViewRequisitionsPanelConsumablesBase
   {
      
      public function LoadoutViewRequisitionsPanelConsumablesShards()
      {
         super();
         headerTitle = DictMarket.MARKET_ITEM_SHARD;
         instructions = Dict.REQUISITIONS_SHARDS_INSTRUCTIONS;
      }
      
      override protected function getCategoryArr() : Array
      {
         return [{"id":MarketMenuData.TYPE_GAMEMODE_SHARD}];
      }
   }
}

