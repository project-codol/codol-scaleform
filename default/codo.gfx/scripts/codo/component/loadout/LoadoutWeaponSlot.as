package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Breadcrumb;
   import codo.component.CloseButton;
   import codo.component.ItemLevelDisplay;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ItemBuffListObj;
   import codo.objects.ItemBuffObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.TextUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class LoadoutWeaponSlot extends UIInteractiveComponent
   {
      
      private static const UNFOCUS_FRAME:int = 1;
      
      private static const FOCUS_FRAME:int = 2;
      
      private static const SLOT_WIDTH:Number = 59;
      
      private static const SLOT_HEIGHT:Number = 61;
      
      private static const NAME_WIDTH:Number = 210;
      
      private static const BUFF_ICON_SIZE:int = 64;
      
      public var myClearButton:CloseButton;
      
      public var myReticleSlot:LoadoutButton;
      
      public var myCamoSlot:LoadoutButton;
      
      public var myDecalSlot:LoadoutButton;
      
      public var myImage:FsgImageHolder;
      
      public var myName:TextField;
      
      public var myCategory:TextField;
      
      public var myTierColorAccent:MovieClip;
      
      public var myItemLevelDisplay:ItemLevelDisplay;
      
      public var myReticleLabel:LoadoutHeader;
      
      public var myCamoLabel:LoadoutHeader;
      
      public var myDecalLabel:LoadoutHeader;
      
      public var myTierColorBar:MovieClip;
      
      public var myTierColorBarCap:MovieClip;
      
      public var myCategoryBG:MovieClip;
      
      public var myBackground:MovieClip;
      
      public var myHighlightOutline:Sprite;
      
      public var myBuffs:Sprite;
      
      public var myDisabledIcon:MovieClip;
      
      public var myEquippedIcon:MovieClip;
      
      private var mClearCallback:Function;
      
      private var mCustomizeReticleCallback:Function;
      
      private var mCustomizeCamoCallback:Function;
      
      private var mCustomizeDecalCallback:Function;
      
      private var mIsSuggestedLoadout:Boolean;
      
      private var mIgnoreMouse:Boolean;
      
      public function LoadoutWeaponSlot()
      {
         var text:TextField = null;
         super();
         isInteractiveEnabled = true;
         this.myName.textStyle = MarketGuide.styleLoadoutWeaponName;
         this.myCategory.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myName.width = NAME_WIDTH;
         this.myCategory.width = NAME_WIDTH;
         this.myReticleSlot.width = SLOT_WIDTH;
         this.myReticleSlot.height = SLOT_HEIGHT;
         this.myReticleSlot.registerClickEvent(this.onReticleSlotClicked);
         this.myCamoSlot.width = SLOT_WIDTH;
         this.myCamoSlot.height = SLOT_HEIGHT;
         this.myCamoSlot.registerClickEvent(this.onCamoSlotClicked);
         this.myDecalSlot.width = SLOT_WIDTH;
         this.myDecalSlot.height = SLOT_HEIGHT;
         this.myDecalSlot.registerClickEvent(this.onDecalSlotClicked);
         this.myReticleLabel.width = SLOT_WIDTH;
         this.myCamoLabel.width = SLOT_WIDTH;
         this.myDecalLabel.width = SLOT_WIDTH;
         this.myReticleLabel.label = LocalizeUtil.localize(DictMarket.CATEGORY_RETICLE);
         this.myCamoLabel.label = LocalizeUtil.localize(Dict.WEAPONLOADOUT_CAMO);
         this.myDecalLabel.label = LocalizeUtil.localize(Dict.WEAPONLOADOUT_DECAL);
         this.myReticleLabel.myLabel.fontColor = GlobalGuide.WHITE;
         this.myCamoLabel.myLabel.fontColor = GlobalGuide.WHITE;
         this.myDecalLabel.myLabel.fontColor = GlobalGuide.WHITE;
         this.myClearButton.visible = false;
         gotoAndStop(UNFOCUS_FRAME);
         if(this.myHighlightOutline != null)
         {
            this.myHighlightOutline.visible = false;
         }
         if(this.myDisabledIcon != null)
         {
            this.myDisabledIcon.visible = false;
            text = this.myDisabledIcon["myBannedItem"];
            text.fontColor = 16460860;
            text.fontSize = 30;
            text.width = 420;
            text.text = LocalizeUtil.localize("@SF_UI_ITEM_BANNED");
            this.updateDisabledIconVisuals();
         }
         this.myCategoryBG.visible = this.myCategory.visible = false;
      }
      
      public function setIsSuggestedLoadout() : void
      {
         if(this.mIsSuggestedLoadout)
         {
            return;
         }
         this.mIsSuggestedLoadout = true;
         var cls:Class = getDefinitionByName("codo.shared.marketplace.MarketplaceItemCardEquippedCheckmark") as Class;
         this.myEquippedIcon = new cls() as MovieClip;
         addChild(this.myEquippedIcon);
         this.myEquippedIcon.scaleX = this.myEquippedIcon.scaleY = 0.75;
         this.myEquippedIcon.y = this.myClearButton.y;
         this.myEquippedIcon.x = this.myClearButton.x + this.myClearButton.width - this.myEquippedIcon.width;
      }
      
      public function getIsSuggestedLoadout() : Boolean
      {
         return this.mIsSuggestedLoadout;
      }
      
      public function updateDisabledIconVisuals() : void
      {
         var text:TextField = this.myDisabledIcon["myBannedItem"];
         var icon:Sprite = this.myDisabledIcon["myIcon"];
         var bg:Sprite = this.myDisabledIcon["myBackground"];
         var totalWidth:Number = icon.width + GlobalGuide.COMPONENT_PADDING + text.textWidth;
         icon.x = bg.width * 0.5 - totalWidth * 0.5;
         text.x = icon.x + icon.width + GlobalGuide.COMPONENT_PADDING;
      }
      
      override public function setData(data:*) : void
      {
         var buffs:Vector.<ItemBuffObj> = null;
         var imgClass:Class = null;
         var imgHolder:FsgImageHolder = null;
         var idx:int = 0;
         var buff:ItemBuffObj = null;
         super.setData(data);
         var productData:ProductObj = data as ProductObj;
         var isFilled:Boolean = productData.id > 0;
         var isDefaultKnife:Boolean = productData.id == CFunctionCommonContainer.GetItemIDByName("defaultknife_mp");
         this.setFillState(isFilled,isDefaultKnife);
         if(!isFilled)
         {
            return;
         }
         this.myName.text = LocalizeUtil.localize(productData.name);
         TextUtil.resizeTextToFitWidth(this.myName.myTextClip);
         this.myImage.setImage(productData.imageURL);
         this.myItemLevelDisplay.level = productData.level;
         this.myItemLevelDisplay.tier = productData.tier;
         this.myCategoryBG.visible = this.myCategory.visible = productData.group.length > 0;
         if(true == this.myCategory.visible)
         {
            this.myCategory.text = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(productData.group));
            this.myCategoryBG.width = this.myCategory.x + this.myCategory.textWidth + GlobalGuide.COMPONENT_PADDING;
         }
         this.myTierColorAccent.gotoAndStop(productData.tier + 1);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[productData.tier],new <DisplayObject>[this.myTierColorBar]);
         this.myTierColorBar.width = this.myName.x + this.myName.textWidth + this.myTierColorBarCap.width + 5;
         this.myTierColorBarCap.x = this.myTierColorBar.x + this.myTierColorBar.width - this.myTierColorBarCap.width;
         if(Boolean(this.myBuffs))
         {
            buffs = ItemBuffListObj.getBuffs(productData);
            imgClass = getDefinitionByName("codo.shared.Size32ImageHolder") as Class;
            while(this.myBuffs.numChildren < buffs.length)
            {
               imgHolder = new imgClass() as FsgImageHolder;
               imgHolder.width = imgHolder.height = BUFF_ICON_SIZE;
               imgHolder.x = -(this.myBuffs.numChildren * (imgHolder.width - 8));
               this.myBuffs.addChild(imgHolder);
            }
            for(idx = 0; idx < this.myBuffs.numChildren; idx++)
            {
               imgHolder = this.myBuffs.getChildAt(idx) as FsgImageHolder;
               if(idx < buffs.length)
               {
                  imgHolder.visible = true;
                  buff = buffs[idx];
                  imgHolder.setImage(buff.icon);
               }
               else
               {
                  imgHolder.visible = false;
               }
            }
         }
         if(this.myDisabledIcon != null)
         {
            this.myDisabledIcon.visible = productData.isBanned;
         }
         if(this.mIsSuggestedLoadout)
         {
            this.myHighlightOutline.visible = !productData.isOwned();
            this.mIgnoreMouse = !this.myHighlightOutline.visible || !productData.purchaseUiEnabled();
            this.myEquippedIcon.visible = productData.isEquipped();
         }
      }
      
      public function set clearItemCallback(callback:Function) : void
      {
         if(callback == null)
         {
            this.myClearButton.unRegisterClickEvent(this.onClearClicked);
            this.mClearCallback = null;
            this.myClearButton.visible = false;
         }
         else
         {
            this.myClearButton.registerClickEvent(this.onClearClicked);
            this.mClearCallback = callback;
            this.myClearButton.visible = true;
         }
      }
      
      public function set customizeReticleCallback(callback:Function) : void
      {
         this.mCustomizeReticleCallback = callback;
      }
      
      public function set customizeCamoCallback(callback:Function) : void
      {
         this.mCustomizeCamoCallback = callback;
      }
      
      public function set customizeDecalCallback(callback:Function) : void
      {
         this.mCustomizeDecalCallback = callback;
      }
      
      private function onClearClicked() : void
      {
         if(null != this.mClearCallback)
         {
            this.mClearCallback(mData as ProductObj);
         }
      }
      
      private function onReticleSlotClicked() : void
      {
         if(null != this.mCustomizeReticleCallback)
         {
            this.mCustomizeReticleCallback();
         }
      }
      
      private function onCamoSlotClicked() : void
      {
         if(null != this.mCustomizeCamoCallback)
         {
            this.mCustomizeCamoCallback();
         }
      }
      
      private function onDecalSlotClicked() : void
      {
         if(null != this.mCustomizeDecalCallback)
         {
            this.mCustomizeDecalCallback();
         }
      }
      
      public function ignoringMouse() : Boolean
      {
         return this.mIgnoreMouse;
      }
      
      override protected function onMouseOver() : void
      {
         if(this.ignoringMouse())
         {
            return;
         }
         gotoAndStop(FOCUS_FRAME);
      }
      
      override protected function onMouseOut() : void
      {
         if(this.ignoringMouse())
         {
            return;
         }
         gotoAndStop(UNFOCUS_FRAME);
      }
      
      protected function setFillState(isFilled:Boolean, isDefaultKnife:Boolean) : void
      {
         var child:DisplayObject = null;
         var crumb:Breadcrumb = getBreadcrumb();
         var crumbVis:Boolean = crumb != null ? crumb.visible : false;
         for(var i:int = numChildren - 1; i >= 0; i--)
         {
            child = getChildAt(i);
            if(child != this.myHighlightOutline)
            {
               child.visible = isFilled;
            }
         }
         if(crumb != null)
         {
            crumb.visible = crumbVis;
         }
         this.myClearButton.visible = isFilled && !isDefaultKnife && this.mClearCallback != null;
         this.myBackground.visible = !isFilled;
         myHitArea.visible = true;
      }
   }
}

