package codo.views.hud.popups.hudTDInventoryView_parts
{
   import codo.common.CFunctionInGameContainer;
   import codo.views.hud.popups.hudTdLoadoutView_parts.HudTdLoadoutViewTiedSlotBase;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdInventorySlot extends HudTdLoadoutViewTiedSlotBase
   {
      
      public var myStack:TextField;
      
      public var myEquipTag:MovieClip;
      
      private var mClickCallback:Function;
      
      private var mArg:Object;
      
      public function HudTdInventorySlot()
      {
         super();
      }
      
      override public function set lootItemIndex(lootItemIndex:int) : void
      {
         var itemInfo:Object = null;
         super.lootItemIndex = lootItemIndex;
         if(lootItemIndex == 0)
         {
            this.myEquipTag.visible = false;
            this.stack = 0;
         }
         else
         {
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
      
      public function setClickCallback(clickCallback:Function, args:Object) : void
      {
         this.mClickCallback = clickCallback;
         this.mArg = args;
      }
      
      override protected function onClick() : void
      {
         if(this.mClickCallback != null)
         {
            this.mClickCallback(this.mArg);
         }
      }
   }
}

