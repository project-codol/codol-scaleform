package codo.component.marketplaceitem.parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.ItemCardBase;
   import codo.component.marketplaceitem.MarketplaceBonusTag;
   import codo.component.marketplaceitem.MarketplaceDiscountItemPromoTag;
   import codo.component.marketplaceitem.MarketplaceItemPromoTag;
   import codo.component.marketplaceitem.MarketplaceNewTag;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.localization.DictMarket;
   import codo.objects.NotForSaleObj;
   import codo.objects.ProductObj;
   import codo.services.MarketService;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TextUtil;
   import codo.utils.TimeUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class MarketplaceItemCard extends ItemCardBase
   {
      
      public var myItemRentalStatus:MarketplaceItemRentalStatus;
      
      public var myBonusTag:MarketplaceBonusTag;
      
      public var myDiscountTag:MarketplaceDiscountItemPromoTag;
      
      public var myTierCornerFill:Sprite;
      
      public var myOuterOutline:Sprite;
      
      public var myInnerOutline:Sprite;
      
      public var myCallToAction:MarketplaceItemCardCallToAction;
      
      public var myItemLevel:MarketplaceItemLevel;
      
      public var myTimeRemainingTF:TextField;
      
      public var myNoSaleEventNameTF:TextField;
      
      public var myFill:Sprite;
      
      public var myEquippedStateBkg:Sprite;
      
      public var myEquippedCheckMark:MovieClip;
      
      public var myPromoTag:MarketplaceItemPromoTag;
      
      public var myNewTag:MarketplaceNewTag;
      
      public var myDisabledIcon:MovieClip;
      
      public var myItemNameRewardBkg:Sprite;
      
      public var myHighlightNameBg:MovieClip;
      
      public var myBkg:MovieClip;
      
      public var myInteriorShapes:MovieClip;
      
      private var mWithDiscountTag:Boolean = true;
      
      private var mWithOwnStateHint:Boolean = true;
      
      public function MarketplaceItemCard()
      {
         super();
         this.resetAllVisibility();
         if(ScaleformUtil.isScaleform)
         {
            addBreadcrumb();
         }
      }
      
      public function setCardStyle(frame:uint, withTools:Boolean) : void
      {
         var innerOuterDiff:int = 0;
         currentDisplayFrame = frame;
         this.resetAllVisibility();
         if(frame != MarketItemUtil.ITEM_CARD_SMALL_FRAME && frame != MarketItemUtil.ITEM_CARD_SMALL_REWARD_FRAME && frame != MarketItemUtil.ITEM_CARD_TINY_FRAME)
         {
            this.upscaleItemCard(frame);
         }
         this.myItemNameRewardBkg.visible = frame == MarketItemUtil.ITEM_CARD_SMALL_REWARD_FRAME;
         var icon:Sprite = this.myDisabledIcon["myIcon"];
         var bg:Sprite = this.myDisabledIcon["myBackground"];
         var txt:TextField = this.myDisabledIcon["myBannedItem"];
         txt.text = LocalizeUtil.localize("@SF_UI_ITEM_BANNED");
         switch(frame)
         {
            case MarketItemUtil.ITEM_CARD_LARGE_FRAME:
               bg.width = this.width - 144;
               break;
            case MarketItemUtil.ITEM_CARD_TINY_FRAME:
               bg.width = this.width;
               this.myInnerOutline.visible = true;
               this.myOuterOutline.visible = true;
               this.myTierCornerFill.visible = true;
               this.myTimeRemainingTF.visible = false;
               this.myNoSaleEventNameTF.visible = false;
               break;
            default:
               bg.width = this.width - 2;
         }
         var totalWidth:Number = txt.textWidth + icon.width + GlobalGuide.COMPONENT_PADDING;
         icon.x = bg.x + bg.width * 0.5 - totalWidth * 0.5;
         txt.x = icon.x + icon.width + GlobalGuide.COMPONENT_PADDING;
         this.myCallToAction.width = this.width - this.myCallToAction.x;
         if(withTools)
         {
            this.myFill.visible = true;
            this.myCallToAction.height = this.myOuterOutline.height - (this.myFill.height + this.myOuterOutline.y);
         }
         else if(frame != MarketItemUtil.ITEM_CARD_TINY_FRAME)
         {
            this.myFill.visible = false;
            innerOuterDiff = this.myOuterOutline.height - this.myInnerOutline.height;
            this.myInnerOutline.height = this.myEquippedStateBkg.height + 3;
            this.myOuterOutline.height = this.myInnerOutline.height + innerOuterDiff;
            this.myCallToAction.height = this.myOuterOutline.height;
         }
         if(frame != MarketItemUtil.ITEM_CARD_TINY_FRAME)
         {
            this.myEquippedCheckMark.x = this.width - this.myEquippedCheckMark.width;
         }
         myItemNameTF.height = this.height - myItemNameTF.y;
         if(Boolean(myBuffs))
         {
            mBufferInitX = myBuffs.x;
            mBufferInitY = myBuffs.y;
         }
      }
      
      private function upscaleItemCard(size:uint) : void
      {
         if(size == MarketItemUtil.ITEM_CARD_MEDIUM_FRAME)
         {
            myItemImageHolder.width = MarketItemUtil.ITEM_CARD_MEDIUM_WIDTH;
         }
         else
         {
            myItemImageHolder.width = MarketItemUtil.ITEM_CARD_LARGE_WIDTH;
         }
         myItemImageHolder.scaleY = myItemImageHolder.scaleX;
      }
      
      public function set withDiscountTag(withDiscount:Boolean) : void
      {
         this.mWithDiscountTag = withDiscount;
         if(this.mWithDiscountTag == false)
         {
            this.myDiscountTag.visible = false;
         }
      }
      
      public function set withOwnStateHint(withHint:Boolean) : void
      {
         this.mWithOwnStateHint = withHint;
         if(this.mWithOwnStateHint == false)
         {
            this.myEquippedCheckMark.visible = this.myEquippedStateBkg.visible = this.myItemRentalStatus.visible = this.myNewTag.visible = getBreadcrumb().visible = false;
         }
      }
      
      public function get toolPosX() : Number
      {
         return this.myFill.x;
      }
      
      public function get toolPosY() : Number
      {
         return this.myFill.y + 3;
      }
      
      public function get hasTools() : Boolean
      {
         return this.myFill.visible;
      }
      
      override protected function onIconImageLoaded(e:Event) : void
      {
         myItemIconHolder.removeEventListener(Event.COMPLETE,this.onIconImageLoaded);
         var bmpImage:DisplayObject = myItemIconHolder.loadedAsset;
         var offsetForTools:uint = this.hasTools ? uint(this.myFill.height * 0.5) : 0;
         var MAX_HEIGHT:uint = 115;
         if(currentFrame == MarketItemUtil.ITEM_CARD_LARGE_FRAME)
         {
            bmpImage.scaleX = bmpImage.scaleY = 1.3;
         }
         else
         {
            bmpImage.height = Math.min(MAX_HEIGHT,bmpImage.height);
            bmpImage.scaleX = bmpImage.scaleY;
         }
         bmpImage.x = this.myInnerOutline.x + (this.myInnerOutline.width - bmpImage.width) * 0.5;
         bmpImage.y = this.myInnerOutline.y + (this.myInnerOutline.height - bmpImage.height) * 0.5 - offsetForTools;
      }
      
      override public function setData(data:*) : void
      {
         var TXT_PADDING:int = 0;
         super.setData(data);
         var productData:ProductObj = mData as ProductObj;
         if(this.myHighlightNameBg != null)
         {
            this.myHighlightNameBg.visible = false;
         }
         if(productData == null)
         {
            return;
         }
         if(this.myInteriorShapes != null)
         {
            this.myInteriorShapes.visible = true;
         }
         if(this.myBkg != null)
         {
            this.myBkg.gotoAndStop(1);
         }
         if(productData.group == MarketMenuData.GRP_LOADOUT_BUNDLE)
         {
            if(this.myHighlightNameBg != null)
            {
               this.myHighlightNameBg.visible = true;
            }
            if(this.myInteriorShapes != null)
            {
               this.myInteriorShapes.visible = false;
            }
            if(this.myBkg != null)
            {
               this.myBkg.gotoAndStop(2);
            }
         }
         this.myBonusTag.setBonusInfo(productData);
         this.myCallToAction.setItemData(productData);
         if(productData.type == ItemType.WEAPON && productData.level > 0)
         {
            this.myItemLevel.visible = true;
            this.myItemLevel.setItemLevelAndTier(productData.level,productData.tier);
         }
         else
         {
            this.myItemLevel.visible = false;
         }
         this.myPromoTag.visible = false;
         var discountTxt:String = ItemUtil.getItemSaleValueBySku(productData.SKUs);
         if(!productData.ignoreDiscount && this.mWithDiscountTag && (discountTxt != null && !productData.isOwnedPermanent()))
         {
            this.myDiscountTag.visible = true;
            this.myDiscountTag.discount = discountTxt;
         }
         else
         {
            this.myDiscountTag.visible = false;
         }
         if(!this.myItemNameRewardBkg.visible && currentFrame != MarketItemUtil.ITEM_CARD_TINY_FRAME)
         {
            myItemNameTF.y = this.myFill.y - (myItemNameTF.textHeight + 10);
         }
         myItemCategoryTF.y = myItemNameTF.y - myItemCategoryTF.textHeight;
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[productData.tier],new <DisplayObject>[this.myInnerOutline,this.myTierCornerFill,this.myEquippedStateBkg]);
         if(productData.tier == MarketItemUtil.TIER_BASIC)
         {
            this.myEquippedStateBkg.transform.colorTransform = new ColorTransform();
         }
         this.myEquippedCheckMark.visible = this.myEquippedStateBkg.visible = this.mWithOwnStateHint && productData.isEquipped();
         this.setIsNew(MarketService.getInstance().isNewItem(productData.id),this.myEquippedCheckMark.visible);
         if(ScaleformUtil.isScaleform)
         {
            getBreadcrumb().visible = this.mWithOwnStateHint && productData.showBreadcrumb;
            if(getBreadcrumb().visible)
            {
               getBreadcrumb().text = DictMarket.MARKETPLACE_NEW_ITEM;
            }
         }
         if(this.mWithOwnStateHint)
         {
            if(productData.isOwnedRental())
            {
               this.myTimeRemainingTF.visible = true;
               this.myTimeRemainingTF.htmlText = TimeUtil.convertTimeRemainingToHHMMSS(productData.remainSecond);
               this.myItemRentalStatus.visible = false;
            }
            else if(productData.purchaseUiEnabled(false))
            {
               this.myItemRentalStatus.visible = true;
               this.myItemRentalStatus.setItemPurchaseable(CFunctionCommonContainer.AS_SetupAndReturnMinSkus(productData));
               this.myTimeRemainingTF.visible = false;
            }
            else
            {
               this.myItemRentalStatus.visible = false;
               this.myTimeRemainingTF.visible = false;
            }
         }
         else if(productData.stackable)
         {
            if(productData.displayQuantity > 0)
            {
               this.myTimeRemainingTF.visible = true;
               this.myTimeRemainingTF.text = LocalizeUtil.param(DictMarket.MARKET_ITEM_DISPLAY_QUANTITY,[productData.displayQuantity]);
            }
            else
            {
               this.myTimeRemainingTF.visible = false;
            }
         }
         else
         {
            this.myTimeRemainingTF.visible = true;
            if(productData.remainSecond > 0)
            {
               this.myTimeRemainingTF.htmlText = TimeUtil.convertTimeRemainingToHHMMSS(productData.remainSecond);
            }
            else
            {
               this.myTimeRemainingTF.htmlText = TimeUtil.forever();
            }
         }
         this.fillNotForSaleInfo(productData.notForSaleObj);
         this.myDisabledIcon.visible = productData.isBanned;
         if(this.myItemNameRewardBkg.visible)
         {
            TXT_PADDING = 18;
            this.myItemNameRewardBkg.width = Math.min(myItemNameTF.textWidth + TXT_PADDING,208);
            myItemNameTF.width = this.myItemNameRewardBkg.width - TXT_PADDING;
         }
         if(null != data.clickCallback)
         {
            setClickCallback(data.clickCallback);
         }
         if(productData.group == MarketMenuData.GRP_LOADOUT_BUNDLE)
         {
            this.myTimeRemainingTF.visible = false;
         }
      }
      
      private function fillNotForSaleInfo(notForSaleObj:NotForSaleObj) : void
      {
         if(Boolean(notForSaleObj))
         {
            this.myNoSaleEventNameTF.visible = true;
            this.myTimeRemainingTF.visible = false;
            this.myItemRentalStatus.visible = false;
            TextUtil.setFontSize(this.myNoSaleEventNameTF,GlobalGuide.FONT_SIZE_EXTRA_SMALL);
            this.myNoSaleEventNameTF.text = notForSaleObj.label;
            TextUtil.resizeTextToFitHeight(this.myNoSaleEventNameTF);
         }
         else
         {
            this.myNoSaleEventNameTF.visible = false;
         }
      }
      
      private function setIsNew(isNew:Boolean, isItemEquipped:Boolean) : void
      {
         this.myNewTag.visible = this.mWithOwnStateHint && isNew && !isItemEquipped;
         if(this.myNewTag.visible)
         {
            this.myNewTag.updateLabelSize(currentFrame == MarketItemUtil.ITEM_CARD_SMALL_FRAME);
         }
      }
      
      private function resetAllVisibility() : void
      {
         this.myCallToAction.visible = this.myPromoTag.visible = this.myTimeRemainingTF.visible = this.myNoSaleEventNameTF.visible = this.myItemLevel.visible = this.myEquippedStateBkg.visible = this.myEquippedCheckMark.visible = this.myNewTag.visible = this.myDiscountTag.visible = this.myBonusTag.visible = this.myDisabledIcon.visible = this.myItemNameRewardBkg.visible = false;
         this.withDiscountTag = this.mWithDiscountTag;
         this.withOwnStateHint = this.mWithOwnStateHint;
      }
      
      override public function get height() : Number
      {
         return this.myOuterOutline.y + this.myOuterOutline.height;
      }
      
      override public function get width() : Number
      {
         return this.myOuterOutline.x + this.myOuterOutline.width;
      }
   }
}

