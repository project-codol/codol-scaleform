package codo.views.supplyDrop_parts
{
   import codo.localization.DictMarket;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFieldEx;
   
   public class SupplyDropItemQuantity extends MovieClip
   {
      
      public var myQuantityTF:TextField;
      
      public var myQuantityLabelTF:TextField;
      
      private var mQuantity:int;
      
      public function SupplyDropItemQuantity()
      {
         super();
         var qtyLabel:String = ScaleformUtil.isScaleform ? DictMarket.SUPPLY_DROPS_UNOPENED : "未开封";
         this.myQuantityLabelTF.text = qtyLabel;
         TextFieldEx.setVerticalAlign(this.myQuantityTF,TextFieldEx.VALIGN_CENTER);
         this.quantity = 0;
      }
      
      public function set quantity(number:int) : void
      {
         this.mQuantity = number;
         if(number > 999)
         {
            this.myQuantityTF.text = "999";
         }
         else
         {
            this.myQuantityTF.text = StringUtil.addZero(number);
         }
         var textFormat:TextFormat = this.myQuantityTF.getTextFormat();
         textFormat.size = 48;
         this.myQuantityTF.setTextFormat(textFormat);
         TextUtil.resizeTextToFitWidth(this.myQuantityTF);
      }
      
      public function get quantity() : int
      {
         return this.mQuantity;
      }
   }
}

