package codo.views.hud.popups.hudTdLoadoutView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdPackageSlot extends HudTdLoadoutViewTiedSlotBase
   {
      
      public var myStack:TextField;
      
      public var myEquipTag:MovieClip;
      
      private var mSlot:int;
      
      public function HudTdPackageSlot()
      {
         super();
         this.stack = 0;
      }
      
      override public function set lootItemIndex(lootItemIndex:int) : void
      {
         var itemInfo:Object = null;
         super.lootItemIndex = lootItemIndex;
         if(lootItemIndex == 0)
         {
            myDropButton.visible = false;
            this.myEquipTag.visible = false;
         }
         else
         {
            myDropButton.visible = true;
            this.myEquipTag.visible = false;
            itemInfo = CFunctionInGameContainer.AS_TD_GetLootItemInfo(lootItemIndex);
            if(itemInfo != null)
            {
               if(itemInfo.type == "lethal" || itemInfo.type == "tactical" || itemInfo.type == "syringe" || itemInfo.type == "ammo")
               {
                  this.myEquipTag.visible = true;
               }
            }
         }
      }
      
      public function set stack(stack:int) : void
      {
         this.myStack.visible = false;
         if(stack > 0)
         {
            this.myStack.visible = true;
            this.myStack.text = stack.toString();
         }
      }
      
      public function set slot(slot:int) : void
      {
         this.mSlot = slot;
      }
      
      override protected function onDrop() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_drop_item","package|" + this.mSlot.toString());
      }
      
      override protected function onClick() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_package_item_selection",this.mSlot.toString());
      }
   }
}

