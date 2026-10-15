package codo.component.factory
{
   import codo.component.ItemFooterButton;
   import codo.component.MarketplacePriceSelectorRow;
   import codo.component.SupplyDropRewardItem;
   import codo.component.SupplyDropRewardItem2;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.loadout.SDPlusPerkRow;
   import codo.component.loadout.SDPlusWeaponCard;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.component.marketplaceitem.parts.MarketplaceItemTools;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.views.marketplace_parts.MarketplaceFeaturedAd;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class MarketFactory
   {
      
      public static const MARKETPLACE_ITEM_LINKAGE:String = "codo.shared.marketplace.MarketplaceItem";
      
      public static const MARKETPLACE_ITEM_TOOLS:String = "codo.shared.marketplace.MarketplaceItemTools";
      
      public static const MARKETPLACE_ADD_TO_CART_ICON:String = "codo.shared.IconShoppingCart";
      
      public static const MARKETPLACE_REMOVE_ICON:String = "codo.shared.IconRemove";
      
      public static const MARKETPLACE_CHECKMARK_ICON:String = "codo.shared.iconCheckmark";
      
      public static const MARKETPLACE_FEATURED_AD:String = "codo.views.marketplace.MarketplaceFeaturedAd";
      
      public static const MARKETPLACE_PRICE_SELECTOR_ROW:String = "codo.shared.MarketplacePriceSelectorRow";
      
      public static const MARKETPLACE_PRICE_SELECTOR_WITHOUT_DURATION_ROW:String = "codo.shared.marketplacePriceSelectorWithoutDurationRow";
      
      public static const SDPLUS_WEAPON_CARD:String = "codo.shared.loadout.SDPlusWeaponCard";
      
      public static const SDPLUS_PERK_ROW:String = "codo.shared.loadout.SDPlusPerkRow";
      
      public static const MARKETPLACE_ICON_WEAPON:String = "codo.shared.icons.ItemIcon_Weapon";
      
      public static const MARKETPLACE_ICON_AVATAR:String = "codo.shared.icons.ItemIcon_Avatar";
      
      public static const MARKETPLACE_ICON_HEADWEAR:String = "codo.shared.icons.ItemIcon_Headwear";
      
      public static const MARKETPLACE_ICON_EYEWEAR:String = "codo.shared.icons.ItemIcon_Eyewear";
      
      public static const MARKETPLACE_ICON_JACKET:String = "codo.shared.icons.ItemIcon_Jacket";
      
      public static const MARKETPLACE_ICON_VEST:String = "codo.shared.icons.ItemIcon_Vest";
      
      public static const MARKETPLACE_ICON_TATTOOS:String = "codo.shared.icons.ItemIcon_Tattoos";
      
      public static const MARKETPLACE_ICON_GLOVES:String = "codo.shared.icons.ItemIcon_Gloves";
      
      public static const MARKETPLACE_ICON_PANTS:String = "codo.shared.icons.ItemIcon_Pants";
      
      public static const MARKETPLACE_ICON_OUTFIT:String = "codo.shared.icons.ItemIcon_Outfit";
      
      public static const MARKETPLACE_ICON_EMOTE:String = "codo.shared.icons.ItemIcon_Emotes";
      
      public static const SUPPLY_DROP_ITEM_CARD:String = "codo.shared.SupplyDropRewardItemClass";
      
      public static const SUPPLY_DROP_ITEM_CARD2:String = "codo.shared.supplyDropRewardItem2";
      
      public static const SUPPLY_DROP_ITEM_CARD2_EFFECT1:String = "codo.shared.supplyDropRewardItem2Effect1";
      
      public static const SUPPLY_DROP_ITEM_CARD2_EFFECT2:String = "codo.shared.supplyDropRewardItem2Effect2";
      
      public static const SUPPLY_DROP_ITEM_CARD2_EFFECT3:String = "codo.shared.supplyDropRewardItem2Effect3";
      
      private static var ITEM_CATEGORY_ICON_MAPPING:Object = {
         "wea":MARKETPLACE_ICON_WEAPON,
         "cha":MARKETPLACE_ICON_AVATAR,
         "heg":MARKETPLACE_ICON_HEADWEAR,
         "eye":MARKETPLACE_ICON_EYEWEAR,
         "fja":MARKETPLACE_ICON_JACKET,
         "ves":MARKETPLACE_ICON_VEST,
         "elp":MARKETPLACE_ICON_TATTOOS,
         "han":MARKETPLACE_ICON_GLOVES,
         "fpa":MARKETPLACE_ICON_PANTS,
         "oft":MARKETPLACE_ICON_OUTFIT,
         "wbd":MARKETPLACE_ICON_WEAPON,
         "emo":MARKETPLACE_ICON_EMOTE
      };
      
      public function MarketFactory()
      {
         super();
      }
      
      public static function GET_BUILD_MARKET_ITEM_CARD_FUNC(cardFrame:uint, withTools:Boolean = false, withCallToArms:Boolean = true, withDiscountTag:Boolean = true) : Function
      {
         return function():UIInteractiveComponent
         {
            var cls:* = getDefinitionByName(MARKETPLACE_ITEM_LINKAGE) as Class;
            var itm:* = new cls() as MarketplaceItem;
            itm.setCardStyle(cardFrame,withTools,withCallToArms);
            itm.withDiscountTag = withDiscountTag;
            return itm;
         };
      }
      
      public static function BUILD_MARKET_ITEM_TINY_CARD(withTools:Boolean = false, withPreview:Boolean = true) : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName(MARKETPLACE_ITEM_LINKAGE) as Class;
         var itm:MarketplaceItem = new cls() as MarketplaceItem;
         itm.setCardStyle(MarketItemUtil.ITEM_CARD_TINY_FRAME,false,false);
         itm.hasPreviewPopup = withPreview;
         return itm;
      }
      
      public static function BUILD_MARKET_ITEM_SMALL_CARD(withTools:Boolean = false, withPreview:Boolean = true) : UIInteractiveComponent
      {
         var frame_small:uint = 1;
         var cls:Class = getDefinitionByName(MARKETPLACE_ITEM_LINKAGE) as Class;
         var itm:MarketplaceItem = new cls() as MarketplaceItem;
         itm.setCardStyle(frame_small,withTools);
         itm.hasPreviewPopup = withPreview;
         return itm;
      }
      
      public static function BUILD_REWARD_ITEM_SMALL_CARD(withPreview:Boolean = true) : UIInteractiveComponent
      {
         var frame_small:uint = 4;
         var cls:Class = getDefinitionByName(MARKETPLACE_ITEM_LINKAGE) as Class;
         var itm:MarketplaceItem = new cls() as MarketplaceItem;
         itm.setCardStyle(frame_small,false,false);
         itm.withDiscountTag = false;
         itm.hasPreviewPopup = withPreview;
         return itm;
      }
      
      public static function BUILD_MARKET_ITEM_SMALL_CARD_NO_CALL_TO_ARMS(withTools:Boolean = false, withPreview:Boolean = true) : UIInteractiveComponent
      {
         var frame_small:uint = 1;
         var cls:Class = getDefinitionByName(MARKETPLACE_ITEM_LINKAGE) as Class;
         var itm:MarketplaceItem = new cls() as MarketplaceItem;
         itm.setCardStyle(frame_small,withTools,false);
         itm.hasPreviewPopup = withPreview;
         return itm;
      }
      
      public static function BUILD_MARKET_PRICE_SELECTOR_ROW(showDuration:Boolean) : MarketplacePriceSelectorRow
      {
         var cls:Class = getDefinitionByName(showDuration ? MARKETPLACE_PRICE_SELECTOR_ROW : MARKETPLACE_PRICE_SELECTOR_WITHOUT_DURATION_ROW) as Class;
         return new cls() as MarketplacePriceSelectorRow;
      }
      
      public static function BUILD_MARKET_ITEM_SMALL_CARD_WITH_MARKET_TOOLS() : UIInteractiveComponent
      {
         return BUILD_MARKET_ITEM_SMALL_CARD(true,true);
      }
      
      public static function BUILD_SDPLUS_WEAPON_CARD() : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName(SDPLUS_WEAPON_CARD) as Class;
         return new cls() as SDPlusWeaponCard;
      }
      
      public static function BUILD_SDPLUS_PERK_ROW() : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName(SDPLUS_PERK_ROW) as Class;
         return new cls() as SDPlusPerkRow;
      }
      
      public static function BUILD_MARKET_ITEM_MEDIUM_CARD(withTools:Boolean = false, withPreview:Boolean = true) : UIInteractiveComponent
      {
         var frame_medium:uint = 2;
         var cls:Class = getDefinitionByName(MARKETPLACE_ITEM_LINKAGE) as Class;
         var itm:MarketplaceItem = new cls() as MarketplaceItem;
         itm.setCardStyle(frame_medium,withTools);
         itm.hasPreviewPopup = withPreview;
         return itm;
      }
      
      public static function BUILD_MARKET_ITEM_MEDIUM_CARD_WITH_MARKET_TOOLS() : UIInteractiveComponent
      {
         return BUILD_MARKET_ITEM_MEDIUM_CARD(true);
      }
      
      public static function BUILD_MARKET_ITEM_LARGE_CARD(withTools:Boolean = false) : UIInteractiveComponent
      {
         var frame_large:uint = 3;
         var cls:Class = getDefinitionByName(MARKETPLACE_ITEM_LINKAGE) as Class;
         var itm:MarketplaceItem = new cls() as MarketplaceItem;
         itm.setCardStyle(frame_large,withTools);
         return itm;
      }
      
      public static function BUILD_MARKET_TOOLS(itemSize:uint) : MarketplaceItemTools
      {
         var btnWidth:uint = Math.floor(itemSize / 3);
         var toolCls:Class = getDefinitionByName(MARKETPLACE_ITEM_TOOLS) as Class;
         var tools:MarketplaceItemTools = new toolCls() as MarketplaceItemTools;
         tools.addFooterButton(BUILD_MARKET_ITEM_TOOL_BUTTON(MarketplaceItemTools.MARKET_TOOL_COMPARE,LocalizeUtil.localize(DictMarket.COMPARE_ITEM),btnWidth,true));
         tools.addFooterButton(BUILD_MARKET_ITEM_TOOL_BUTTON(MarketplaceItemTools.MARKET_TOOL_PREVIEW,LocalizeUtil.localize(Dict.PREVIEW_ITEM),btnWidth,true));
         tools.addFooterButton(BUILD_MARKET_ITEM_TOOL_BUTTON(MarketplaceItemTools.MARKET_TOOL_DETAILS,LocalizeUtil.localize(Dict.SHOW_DETAIL),btnWidth));
         tools.addFooterButton(BUILD_MARKET_ITEM_TOOL_BUTTON(MarketplaceItemTools.MARKET_TOOL_PURCHASE,LocalizeUtil.localize(DictMarket.BUY),btnWidth,false,true));
         tools.addFooterButton(BUILD_MARKET_ITEM_TOOL_BUTTON(MarketplaceItemTools.MARKET_TOOL_EQUIP,LocalizeUtil.localize(Dict.EQUIP_ITEM),btnWidth));
         tools.addFooterButton(BUILD_MARKET_ITEM_TOOL_BUTTON(MarketplaceItemTools.MARKET_TOOL_DISABLE_REASON,"",btnWidth));
         tools.addFooterButton(BUILD_MARKET_ITEM_TOOL_BUTTON(MarketplaceItemTools.MARKET_TOOL_NOTFORSALE_ACTION,"",btnWidth,false,true));
         return tools;
      }
      
      public static function BUILD_MARKET_ITEM_TOOL_BUTTON(index:uint, label:String, btnWidth:uint, bIsToggleButton:Boolean = false, setIsBuyMode:Boolean = false) : ItemFooterButton
      {
         var btn:ItemFooterButton = null;
         if(index == MarketplaceItemTools.MARKET_TOOL_DISABLE_REASON)
         {
            btn = ButtonFactory.BUILD_ITEM_FOOTER_INDICATOR();
         }
         else
         {
            btn = ButtonFactory.BUILD_ITEM_FOOTER_BUTTON(bIsToggleButton);
         }
         btn.index = index;
         btn.myLabel.textStyle = MarketGuide.styleMarketButton;
         btn.width = btnWidth;
         btn.label = label;
         btn.enabled = false;
         btn.gotoAndStop(setIsBuyMode ? 2 : 1);
         return btn;
      }
      
      public static function BUILD_SUPPLY_DROP_ITEM_CARD() : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName(SUPPLY_DROP_ITEM_CARD) as Class;
         return new cls() as SupplyDropRewardItem;
      }
      
      public static function BUILD_SUPPLY_DROP_ITEM_CARD2() : SupplyDropRewardItem2
      {
         var cls:Class = getDefinitionByName(SUPPLY_DROP_ITEM_CARD2) as Class;
         return new cls() as SupplyDropRewardItem2;
      }
      
      public static function BUILD_SUPPLY_DROP_ITEM_OPEN_EFFECT(isFeatured:Boolean, isShowOff:Boolean) : MovieClip
      {
         var cls:Class = null;
         if(isShowOff)
         {
            cls = getDefinitionByName(SUPPLY_DROP_ITEM_CARD2_EFFECT3) as Class;
         }
         else if(isFeatured)
         {
            cls = getDefinitionByName(SUPPLY_DROP_ITEM_CARD2_EFFECT2) as Class;
         }
         else
         {
            cls = getDefinitionByName(SUPPLY_DROP_ITEM_CARD2_EFFECT1) as Class;
         }
         return new cls() as MovieClip;
      }
      
      public static function BUILD_CHECKMARK_ICON(w:int = -1) : Sprite
      {
         var iconCls:Class = getDefinitionByName(MARKETPLACE_CHECKMARK_ICON) as Class;
         var icon:Sprite = new iconCls() as Sprite;
         if(w > 0)
         {
            icon.width = w;
         }
         icon.scaleY = icon.scaleX;
         return icon;
      }
      
      public static function BUILD_REMOVE_ICON(w:int = -1) : Sprite
      {
         var iconCls:Class = getDefinitionByName(MARKETPLACE_REMOVE_ICON) as Class;
         var icon:Sprite = new iconCls() as Sprite;
         if(w > 0)
         {
            icon.width = w;
         }
         icon.scaleY = icon.scaleX;
         return icon;
      }
      
      public static function BUILD_SHOPPING_CART_ICON(w:int = -1) : Sprite
      {
         var iconCls:Class = getDefinitionByName(MARKETPLACE_ADD_TO_CART_ICON) as Class;
         var icon:Sprite = new iconCls() as Sprite;
         if(w > 0)
         {
            icon.width = w;
         }
         icon.scaleY = icon.scaleX;
         return icon;
      }
      
      public static function BUILD_MARKETPLACE_FEATURED_AD() : MarketplaceFeaturedAd
      {
         var featureAdCls:Class = getDefinitionByName(MARKETPLACE_FEATURED_AD) as Class;
         return new featureAdCls() as MarketplaceFeaturedAd;
      }
      
      public static function GET_ITEM_CATEGORY_ICON_BY_TYPE(type:String) : Bitmap
      {
         var iconName:String = ITEM_CATEGORY_ICON_MAPPING[type];
         if(iconName == null)
         {
            iconName = ITEM_CATEGORY_ICON_MAPPING.cha;
         }
         var imageClass:Class = getDefinitionByName(iconName) as Class;
         if(imageClass == null)
         {
            return null;
         }
         var bitmapData:BitmapData = new imageClass();
         return new Bitmap(bitmapData);
      }
      
      public static function GET_MARKETPLACE_ICON_BY_LINKAGE(linkage:String) : Bitmap
      {
         var imageClass:Class = getDefinitionByName(linkage) as Class;
         var bitmapData:BitmapData = new imageClass();
         return new Bitmap(bitmapData);
      }
   }
}

