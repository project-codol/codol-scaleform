package codo.views.marketplace_parts
{
   import codo.component.home.HomeAdSlideShow;
   import codo.component.marketplaceitem.MarketplaceItemPromoTag;
   import codo.component.marketplaceitem.MarketplaceNewTag;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   
   public class MarketplaceFeaturedAdsContainer extends HomeAdSlideShow
   {
      
      private static const TAG_ALPHA_IN_SPEED:Number = 0.3;
      
      public var myPromoTag:MarketplaceItemPromoTag;
      
      public var myNewTag:MarketplaceNewTag;
      
      public function MarketplaceFeaturedAdsContainer()
      {
         super();
         this.myPromoTag.visible = this.myNewTag.visible = false;
      }
      
      private function set promoType(typeID:int) : void
      {
         var targetTag:DisplayObject = null;
         this.myPromoTag.alpha = this.myNewTag.alpha = 0;
         if(typeID == -1)
         {
            this.myNewTag.visible = this.myPromoTag.visible = false;
            return;
         }
         this.myPromoTag.promoType = typeID;
         this.myNewTag.visible = typeID == MarketplaceItemPromoTag.TEMPLATE_NEW;
         if(this.myPromoTag.visible)
         {
            targetTag = this.myPromoTag;
         }
         if(this.myNewTag.visible)
         {
            targetTag = this.myNewTag;
         }
         TweenLite.to(targetTag,TAG_ALPHA_IN_SPEED,{
            "alpha":1,
            "ease":Linear.easeIn
         });
      }
      
      private function resetList() : void
      {
         this.promoType = -1;
      }
      
      private function updateContent(isAutoForward:Boolean = true) : void
      {
      }
   }
}

