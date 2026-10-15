package codo.component.marketplaceitem
{
   import codo.localization.DictMarket;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class MarketplaceNewTag extends MovieClip
   {
      
      public static const FRAME_ORANGE:uint = 1;
      
      public static const FRAME_GREEN:uint = 2;
      
      public var myLabelTF:TextField;
      
      public var myBG:MovieClip;
      
      private var mTF:TextFormat;
      
      public function MarketplaceNewTag()
      {
         super();
         this.mTF = this.myLabelTF.getTextFormat();
         this.myLabelTF.text = DictMarket.MARKETPLACE_NEW_ITEM;
      }
      
      public function updateLabelSize(doResizeSmall:Boolean = false) : void
      {
         var bkgFillItemWidth:uint = 55;
         if(doResizeSmall)
         {
            gotoAndStop(2);
            bkgFillItemWidth = 43;
         }
         this.mTF.size = doResizeSmall ? 14 : 18;
         this.myLabelTF.setTextFormat(this.mTF);
         x = parent.width - width;
         this.myLabelTF.width = bkgFillItemWidth;
      }
      
      public function setColor(frame:uint) : void
      {
         this.myBG.gotoAndStop(frame);
      }
   }
}

