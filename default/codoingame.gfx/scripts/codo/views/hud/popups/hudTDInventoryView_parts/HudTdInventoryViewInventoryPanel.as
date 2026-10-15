package codo.views.hud.popups.hudTDInventoryView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CallToActionButton;
   import codo.localization.DictTD;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdInventoryViewInventoryPanel extends MovieClip
   {
      
      private const INVENTORY_MATERIAL_SLOTS:int = 12;
      
      private const INVENTORY_GOODS_SLOTS:int = 16;
      
      public var myTitle:TextField;
      
      public var myMaterialSectionTitle:TextField;
      
      public var myGoodsSectionTitle:TextField;
      
      public var myFetchSupplyBtn:CallToActionButton;
      
      private var mMaterialSlots:Vector.<HudTdInventorySlot>;
      
      private var mGoodsSlots:Vector.<HudTdInventorySlot>;
      
      public function HudTdInventoryViewInventoryPanel()
      {
         var i:int = 0;
         super();
         this.myTitle.text = DictTD.INVENTORY;
         this.myMaterialSectionTitle.text = DictTD.MATERIALS;
         this.myGoodsSectionTitle.text = DictTD.GOODS;
         this.myFetchSupplyBtn.label = DictTD.FETCH_SUPPLIES;
         this.mMaterialSlots = new Vector.<HudTdInventorySlot>(0);
         this.mGoodsSlots = new Vector.<HudTdInventorySlot>(0);
         for(i = 0; i < this.INVENTORY_MATERIAL_SLOTS; i++)
         {
            this.mMaterialSlots[i] = getChildByName("myMaterialSlot" + i.toString()) as HudTdInventorySlot;
            this.mMaterialSlots[i].setClickCallback(this.onFetchSlot,{
               "inventoryType":"material",
               "slot":i
            });
         }
         for(i = 0; i < this.INVENTORY_GOODS_SLOTS; i++)
         {
            this.mGoodsSlots[i] = getChildByName("myGoodsSlot" + i.toString()) as HudTdInventorySlot;
            this.mGoodsSlots[i].setClickCallback(this.onFetchSlot,{
               "inventoryType":"goods",
               "slot":i
            });
         }
         this.myFetchSupplyBtn.setClickCallback(this.onFetchSupply);
      }
      
      private function onFetchSupply() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_inventory","fetch|supply");
      }
      
      private function onFetchSlot(arg:Object) : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_inventory","fetch|" + arg.inventoryType + "|" + arg.slot.toString());
      }
   }
}

