package codo.component.loadout
{
   import codo.component.CallToActionButton;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.DictMarket;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgUtil;
   
   public class SDPlusPerkRow extends UIInteractiveComponent
   {
      
      private static const NUM_COLS:int = 3;
      
      private static const SLOT_SIZE:int = 128;
      
      public var mySlotMount:MovieClip;
      
      public var myPurchaseButton:CallToActionButton;
      
      public var myLabel:TextField;
      
      public var myCost:TextField;
      
      public function SDPlusPerkRow()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myLabel.width = 400;
         this.myLabel.height = 50;
         this.myCost.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myCost.width = 400;
         this.myPurchaseButton.width = 392;
         this.myPurchaseButton.height = 31;
         this.myPurchaseButton.label = LocalizeUtil.localize(DictMarket.BUY);
         this.myPurchaseButton.registerClickEvent(this.onPurchaseClicked);
      }
      
      override public function setData(data:*) : void
      {
         var slot:SDPlusPerkSlot = null;
         super.setData(data);
         if(data == null)
         {
            visible = false;
            return;
         }
         this.myLabel.text = data.label;
         this.myCost.text = "$" + FsgUtil.commaFormatNumber(data.cost);
         this.myCost.x = this.myLabel.x + this.myLabel.textWidth + 10;
         this.mySlotMount.y = this.myLabel.y + this.myLabel.textHeight + 5;
         this.clearSlots();
         var col:int = 0;
         var curX:int = 0;
         var curY:int = 0;
         var slotClass:Class = getDefinitionByName("codo.shared.loadout.SDPlusPerkSlot") as Class;
         var itemVector:Vector.<Object> = data.slots as Vector.<Object>;
         for(var i:int = 0; i < itemVector.length; i++)
         {
            slot = new slotClass() as SDPlusPerkSlot;
            this.mySlotMount.addChild(slot);
            slot.setData(itemVector[i]);
            slot.width = slot.height = SLOT_SIZE;
            slot.x = curX;
            slot.y = curY;
            curX += SLOT_SIZE + 4;
            col++;
            if(col == NUM_COLS)
            {
               col = 0;
               curX = 0;
               curY += SLOT_SIZE + 4;
            }
         }
         this.myPurchaseButton.y = this.mySlotMount.y + this.mySlotMount.height;
      }
      
      private function clearSlots() : void
      {
         while(this.mySlotMount.numChildren > 0)
         {
            this.mySlotMount.removeChildAt(0);
         }
      }
      
      override public function get width() : Number
      {
         return this.myPurchaseButton.width;
      }
      
      override public function get height() : Number
      {
         return 324;
      }
      
      private function onPurchaseClicked() : void
      {
      }
   }
}

