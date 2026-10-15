package codo.views.battlecity_parts
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.utils.MarketItemUtil;
   import flash.display.MovieClip;
   
   public class BattleCityLeagueRewardCard extends UIInteractiveComponent
   {
      
      public var myMarketItemCard:MarketplaceItemCard;
      
      public var myGottenMask:MovieClip;
      
      public function BattleCityLeagueRewardCard()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myMarketItemCard.setCardStyle(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false);
         this.myMarketItemCard.withOwnStateHint = false;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(data == null)
         {
            return;
         }
         this.myMarketItemCard.setData(data);
         this.myGottenMask.visible = false;
         if(Boolean(data.owned))
         {
            this.myGottenMask.visible = true;
         }
      }
      
      override public function get height() : Number
      {
         return this.myMarketItemCard.height;
      }
      
      override public function get width() : Number
      {
         return this.myMarketItemCard.width;
      }
      
      public function get realWidth() : Number
      {
         return super.width;
      }
      
      public function get realHeight() : Number
      {
         return super.height;
      }
      
      public function set realWidth(value:Number) : void
      {
         super.width = value;
      }
      
      public function set realHeight(value:Number) : void
      {
         super.height = value;
      }
   }
}

