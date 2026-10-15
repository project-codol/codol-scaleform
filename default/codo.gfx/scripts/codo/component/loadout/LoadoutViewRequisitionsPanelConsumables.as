package codo.component.loadout
{
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   
   public class LoadoutViewRequisitionsPanelConsumables extends LoadoutViewRequisitionsPanelConsumablesBase
   {
      
      public function LoadoutViewRequisitionsPanelConsumables()
      {
         super();
         headerTitle = DictMarket.MARKET_ITEM_CONSUMABLE;
         instructions = Dict.REQUISITIONS_CONSUMABLES_INSTRUCTIONS;
      }
      
      override protected function getCategoryArr() : Array
      {
         return [{"id":MarketMenuData.TYPE_GAMEMODE_TOKEN}];
      }
   }
}

