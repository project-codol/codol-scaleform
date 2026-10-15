package codo.component.marketplaceitem.parts
{
   import codo.common.CFunctionCommonContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class MarketplaceItemLevel extends Sprite
   {
      
      public var myBkg:MovieClip;
      
      public var myLabelTF:TextField;
      
      public function MarketplaceItemLevel()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myLabelTF,TextFieldEx.VALIGN_CENTER);
      }
      
      public function setItemLevelAndTier(level:uint, tier:uint) : void
      {
         this.myLabelTF.text = CFunctionCommonContainer.GetDisplayLevel(level);
         this.myBkg.gotoAndStop(tier + 1);
      }
   }
}

