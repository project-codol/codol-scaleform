package codo.views.supplyDrop_parts
{
   import codo.component.core.ItemCardBase;
   import codo.component.marketplaceitem.MarketplaceNewTag;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class SupplyDropItemToWin extends ItemCardBase
   {
      
      public static const TAG_NONE:int = 0;
      
      public static const TAG_NEW:int = 1;
      
      public static const TAG_FEATURED:int = 2;
      
      private static const IMAGE_HOLDER_WIDTH:int = 177;
      
      private static const IMAGE_HOLDER_HEIGHT:int = 166;
      
      public var myItemCategoryBkg:Sprite;
      
      public var myItemTitleBkg:Sprite;
      
      public var myTierStripe:MovieClip;
      
      public var myTierOverlay:MovieClip;
      
      public var myTag:MarketplaceNewTag;
      
      private var mSupplyDropItemToWinData:Object;
      
      public function SupplyDropItemToWin()
      {
         super();
         myItemCategoryTF.visible = this.myItemCategoryBkg.visible = false;
         myItemNameTF.height = myItemCategoryTF.height = 18;
         myItemNameTF.width = myItemCategoryTF.width = IMAGE_HOLDER_WIDTH;
         myItemCategoryTF.alpha = 0.8;
         this.myTierStripe.visible = false;
         isInteractiveEnabled = true;
         mouseEnabled = mouseChildren = true;
         this.myTag.visible = false;
      }
      
      private function showNewTag() : void
      {
         this.myTag.myLabelTF.text = DictMarket.MARKETPLACE_NEW_ITEM;
         this.myTag.setColor(1);
         this.myTag.visible = true;
      }
      
      private function showFeaturedTag() : void
      {
         this.myTag.myLabelTF.text = DictMarket.MARKETPLACE_FEATURE_ITEMS;
         this.myTag.setColor(2);
         this.myTag.visible = true;
      }
      
      override public function setData(data:*) : void
      {
         var PADDING:uint = 0;
         var prodObject:ProductObj = null;
         if(data == null)
         {
            return;
         }
         super.setData(data.item);
         this.mSupplyDropItemToWinData = data;
         if(Boolean(data.isNew))
         {
            this.showNewTag();
         }
         else if(Boolean(data.isFeatured))
         {
            this.showFeaturedTag();
         }
         else
         {
            this.myTag.visible = false;
         }
         PADDING = 10;
         var MIN:Function = Math.min;
         prodObject = data.item;
         var tier:int = prodObject.tier;
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[tier],new <DisplayObject>[this.myTierStripe]);
         this.myTierStripe.visible = prodObject.tier > 1;
         this.myTierStripe.gotoAndStop(prodObject.tier > 2 ? 2 : 1);
         this.myTierOverlay.gotoAndStop(tier + 1);
         this.myItemTitleBkg.visible = myItemNameTF.text != "";
         this.myItemTitleBkg.width = MIN(myItemNameTF.textWidth + myItemNameTF.x + PADDING,myHitArea.width);
         this.myItemCategoryBkg.visible = myItemCategoryTF.visible;
         this.myItemCategoryBkg.width = MIN(myItemCategoryTF.textWidth + myItemCategoryTF.x + PADDING,myHitArea.width);
      }
      
      override public function getData() : *
      {
         return this.mSupplyDropItemToWinData;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override protected function onIconImageLoaded(e:Event) : void
      {
         myItemIconHolder.removeEventListener(Event.COMPLETE,this.onIconImageLoaded);
         var bmpImage:DisplayObject = myItemIconHolder.loadedAsset;
         bmpImage.scaleX = bmpImage.scaleY = 1.2;
         bmpImage.height = Math.min(IMAGE_HOLDER_HEIGHT,bmpImage.height);
         bmpImage.scaleX = bmpImage.scaleY;
         bmpImage.x = (IMAGE_HOLDER_WIDTH - bmpImage.width) * 0.5;
         bmpImage.y = (IMAGE_HOLDER_HEIGHT - bmpImage.height) * 0.5;
      }
      
      override protected function positionAnimatedEmblem(emblemClip:MovieClip) : void
      {
         myAnimatedEmblemMount.x = IMAGE_HOLDER_HEIGHT / 2 - emblemClip.mySize.width / 2;
      }
   }
}

