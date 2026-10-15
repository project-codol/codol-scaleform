package codo.component.playerinfo_part
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class MostUsedWeaponSlot extends UIInteractiveComponent
   {
      
      private static const NAME_WIDTH:Number = 233;
      
      public var myImage:FsgImageHolder;
      
      public var myTierColorAccent:MovieClip;
      
      public var myCategory:TextField;
      
      public var myName:TextField;
      
      public var myCategoryBG:MovieClip;
      
      public var myTierColorBar:MovieClip;
      
      public var myTierColorBarCap:MovieClip;
      
      public function MostUsedWeaponSlot()
      {
         super();
         isInteractiveEnabled = false;
         this.myName.fontColor = GlobalGuide.CODO_BLACK;
         this.myName.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myCategory.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myName.width = NAME_WIDTH;
         this.myCategory.width = NAME_WIDTH;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var productData:ProductObj = data as ProductObj;
         if(productData.id < 0)
         {
            this.switchShowElement(false);
            return;
         }
         this.switchShowElement(true);
         this.myName.text = LocalizeUtil.localize(productData.name);
         this.myImage.setImage(productData.imageURL);
         this.myCategoryBG.visible = this.myCategory.visible = productData.group.length > 0;
         if(true == this.myCategory.visible)
         {
            this.myCategory.text = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(productData.group));
            this.myCategoryBG.width = this.myCategory.x + this.myCategory.textWidth + GlobalGuide.COMPONENT_PADDING;
         }
         this.myTierColorAccent.gotoAndStop(productData.tier + 1);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[productData.tier],new <DisplayObject>[this.myTierColorBar]);
         this.myTierColorBar.width = this.myName.x + this.myName.textWidth * this.myName.scaleX + this.myTierColorBarCap.width + GlobalGuide.COMPONENT_PADDING;
         this.myTierColorBarCap.x = this.myTierColorBar.x + this.myTierColorBar.width - this.myTierColorBarCap.width;
      }
      
      public function switchShowElement(show:Boolean) : void
      {
         this.myImage.visible = show;
         this.myName.visible = show;
         this.myCategory.visible = show;
         this.myCategoryBG.visible = show;
         this.myTierColorBar.visible = show;
         this.myTierColorBarCap.visible = show;
      }
      
      public function reset() : void
      {
         this.switchShowElement(false);
      }
   }
}

