package codo.views.hud.popups.hudTDInventoryView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CallToActionButton;
   import codo.localization.DictTD;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdInventoryViewPackagePanel extends MovieClip
   {
      
      private const PACKAGE_SLOT_COUNT:int = 28;
      
      public var myTitle:TextField;
      
      public var mySectionTitle:TextField;
      
      public var myStoreMaterialsBtn:CallToActionButton;
      
      public var myStoreAllBtn:CallToActionButton;
      
      public var myLockSlotsCover:MovieClip;
      
      private var mPackageSlots:Vector.<HudTdInventorySlot>;
      
      public function HudTdInventoryViewPackagePanel()
      {
         super();
         this.myTitle.text = DictTD.PACKAGE;
         this.mySectionTitle.text = DictTD.PACKAGE;
         this.myStoreMaterialsBtn.label = DictTD.STORE_MATERIALS;
         this.myStoreAllBtn.label = DictTD.STORE_ALL;
         this.mPackageSlots = new Vector.<HudTdInventorySlot>(0);
         for(var i:int = 0; i < this.PACKAGE_SLOT_COUNT; i++)
         {
            this.mPackageSlots[i] = getChildByName("myPackageSlot" + (i + 1).toString()) as HudTdInventorySlot;
            this.mPackageSlots[i].setClickCallback(this.onStoreSlot,i);
         }
         this.myStoreMaterialsBtn.setClickCallback(this.onStoreMaterials);
         this.myStoreAllBtn.setClickCallback(this.onStoreAll);
      }
      
      private function onStoreMaterials() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_inventory","store|materials");
      }
      
      private function onStoreAll() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_inventory","store|all");
      }
      
      public function onStoreSlot(arg:Object) : void
      {
         var slot:int = arg as int;
         CFunctionCommonContainer.ScriptMenuResponse("td_inventory","store|slot|" + slot);
      }
      
      public function set usableSlotNum(num:int) : void
      {
         this.myLockSlotsCover.visible = num != this.PACKAGE_SLOT_COUNT;
         for(var i:int = 0; i < this.PACKAGE_SLOT_COUNT; i++)
         {
            this.mPackageSlots[i].visible = i < num;
         }
      }
   }
}

