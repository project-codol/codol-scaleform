package codo.views.hud.popups.hudTdLoadoutView_parts
{
   import flash.text.TextField;
   
   public class HudTdEquipmentSlot extends HudTdLoadoutViewTiedSlotBase
   {
      
      public var myKey:TextField;
      
      public var myEmptyHint:TextField;
      
      public var myStack:TextField;
      
      public function HudTdEquipmentSlot()
      {
         super();
      }
      
      override public function set lootItemIndex(lootItemIndex:int) : void
      {
         super.lootItemIndex = lootItemIndex;
         this.myEmptyHint.visible = lootItemIndex == 0;
      }
      
      public function set emptyHint(text:String) : void
      {
         this.myEmptyHint.text = text;
      }
      
      public function set key(key:String) : void
      {
         this.myKey.text = key;
      }
      
      public function set stack(stack:int) : void
      {
         this.myStack.text = stack.toString();
      }
   }
}

