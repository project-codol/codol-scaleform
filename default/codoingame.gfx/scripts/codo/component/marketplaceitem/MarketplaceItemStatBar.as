package codo.component.marketplaceitem
{
   import codo.component.TextField;
   import codo.objects.WeaponBasicStatObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   
   public class MarketplaceItemStatBar extends Sprite
   {
      
      private static const MAX_VALUE:Number = 100;
      
      private static const POSITIVE_FRAME:int = 1;
      
      private static const NEGATIVE_FRAME:int = 2;
      
      public var myGainArrow:MarketplaceStatGainArrow;
      
      public var myIcon:Sprite;
      
      public var myFill:Sprite;
      
      public var myFillCap:Sprite;
      
      public var myBuffFill:MovieClip;
      
      public var myFillBG:Sprite;
      
      public var myLabel:TextField;
      
      public var myValue:TextField;
      
      public function MarketplaceItemStatBar()
      {
         super();
         this.myBuffFill.visible = false;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.fontColor = GlobalGuide.WHITE;
         this.myValue.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myValue.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myValue.fontColor = GlobalGuide.WHITE;
         this.myValue.autoSize = TextFieldAutoSize.LEFT;
         this.myValue.alignment = TextStyle.HALIGN_RIGHT;
      }
      
      public function setData(data:WeaponBasicStatObj, compareData:WeaponBasicStatObj = null, bCompareBase:Boolean = false, bSimpleGraph:Boolean = false) : void
      {
         var compareDiff:int = 0;
         var statValue:int = 0;
         if(bCompareBase)
         {
            statValue = data.base;
            compareDiff = Boolean(compareData) ? int(statValue - compareData.base) : 0;
         }
         else
         {
            statValue = data.value;
            compareDiff = Boolean(compareData) ? int(statValue - compareData.value) : 0;
         }
         this.myLabel.text = LocalizeUtil.localize(data.name).toUpperCase();
         this.myValue.text = statValue.toString();
         this.myValue.fontColor = GlobalGuide.WHITE;
         this.myBuffFill.visible = !bSimpleGraph && compareDiff != 0;
         if(this.myBuffFill.visible)
         {
            this.myFill.width = this.myFillBG.width * (statValue - compareDiff) / MAX_VALUE;
            if(compareDiff > 0)
            {
               this.myBuffFill.width = this.myFillBG.width * compareDiff / MAX_VALUE;
               this.myBuffFill.x = this.myFill.x + this.myFill.width;
               this.myBuffFill.gotoAndStop(POSITIVE_FRAME);
               this.myValue.fontColor = GlobalGuide.GREEN;
            }
            else
            {
               this.myBuffFill.width = this.myFillBG.width * Math.abs(compareDiff) / MAX_VALUE;
               this.myBuffFill.x = this.myFill.x + this.myFill.width - this.myBuffFill.width;
               this.myBuffFill.gotoAndStop(NEGATIVE_FRAME);
               this.myValue.fontColor = GlobalGuide.CODO_RED;
            }
         }
         else
         {
            this.myFill.width = this.myFillBG.width * statValue / MAX_VALUE;
         }
         this.myFillCap.x = this.myFill.x + this.myFill.width - this.myFillCap.width;
         this.myGainArrow.setData(statValue - compareDiff,compareDiff);
         while(this.myIcon.numChildren > 0)
         {
            this.myIcon.removeChildAt(0);
         }
         var imageClass:Class = getDefinitionByName(data.image) as Class;
         var bitmapData:BitmapData = new imageClass(width,height);
         var bitmap:Bitmap = new Bitmap(bitmapData);
         this.myIcon.addChild(bitmap);
      }
   }
}

