package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.Common;
   import codo.constants.ItemType;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ItemSlotObj;
   import codo.objects.ProductObj;
   import codo.objects.SKUObj;
   import codo.services.CharacterLoadoutService;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import fsg.shared.CurrencyButton;
   import fsg.util.FsgImageHolder;
   
   public class ItemUtil
   {
      
      public static var HIDDEN_ITEM_COLOR:uint = 16711935;
      
      public static var ignoreFutureSku:Boolean = false;
      
      public static var isChineseLanguage:Boolean = true;
      
      public static var isUsingNewDiscountSystem:Boolean = false;
      
      public function ItemUtil()
      {
         super();
      }
      
      public static function setupCurrencyButtons(bGPButton:CurrencyButton, bCPButton:CurrencyButton, product:ProductObj, GPBuyButtonOriginalX:Number) : void
      {
         var minSKUs:Object = null;
         minSKUs = CFunctionCommonContainer.AS_SetupAndReturnMinSkus(product);
         bCPButton.visible = minSKUs.minCPSku != null;
         if(Boolean(minSKUs.minCPSku))
         {
            bCPButton.setData(product,minSKUs.minCPSku);
         }
         bGPButton.visible = minSKUs.minGPSku != null;
         bGPButton.x = bCPButton.visible ? GPBuyButtonOriginalX : bCPButton.x;
         if(Boolean(minSKUs.minGPSku))
         {
            bGPButton.setData(product,minSKUs.minGPSku);
         }
      }
      
      public static function processSkuIndices(product:ProductObj) : void
      {
         var sku:* = undefined;
         var minGPSku:Object = null;
         var minCPSku:Object = null;
         var minHPSku:Object = null;
         var minEHPSku:Object = null;
         var skuArr:Array = product.SKUs;
         for(var i:int = 0; i < skuArr.length; i++)
         {
            sku = skuArr[i];
            if(Boolean(sku))
            {
               if(sku.currency == Dict.CP)
               {
                  if(!minCPSku || minCPSku.price > sku.price)
                  {
                     minCPSku = sku;
                     product.CPSKUIndex = i;
                  }
               }
               else if(sku.currency == Dict.GP)
               {
                  if(!minGPSku || minGPSku.price > sku.price)
                  {
                     minGPSku = sku;
                     product.GPSKUIndex = i;
                  }
               }
               else if(sku.currency == Dict.HP)
               {
                  if(!minHPSku || minHPSku.price > sku.price)
                  {
                     minHPSku = sku;
                     product.HPSKUIndex = i;
                  }
               }
               else if(sku.currency == Dict.EHP)
               {
                  if(!minEHPSku || minEHPSku.price > sku.price)
                  {
                     minEHPSku = sku;
                     product.EHPSKUIndex = i;
                  }
               }
            }
         }
      }
      
      public static function hasValidSku(product:ProductObj) : Boolean
      {
         var sku:* = undefined;
         var skuArr:* = product.SKUs;
         var hasOneValidSku:Boolean = false;
         var hasSku:Boolean = false;
         for each(sku in skuArr)
         {
            if(Boolean(sku))
            {
               hasSku = true;
               if(!sku.isInFuture)
               {
                  hasOneValidSku = true;
                  break;
               }
            }
         }
         if(ignoreFutureSku && hasSku)
         {
            return hasOneValidSku;
         }
         return true;
      }
      
      public static function isIgnoreFutureSku() : Boolean
      {
         return ignoreFutureSku;
      }
      
      public static function getParsedProductDetails(cType:String, cName:String, cImgURL:String = "") : Object
      {
         var faction:uint = 0;
         if(cType == ItemType.CAT || cType == ItemType.BUNDLE)
         {
            faction = CharacterLoadoutService.getInstance().currentLoadoutType;
            if(faction == Common.LOADOUT_TYPE_SC && cName.substring(cName.length - 7) != "SC_NAME")
            {
               cName = cName.substring(0,cName.lastIndexOf("_NAME")) + "_SC_NAME";
               cImgURL += "_sc";
            }
         }
         return {
            "name":cName,
            "imageURL":cImgURL
         };
      }
      
      public static function setItemData(cType:String, cName:String, cTitleTF:TextField = null, cImgURL:String = "", cImgHolder:Sprite = null, cBgHolder:Sprite = null) : void
      {
         var newBackground:DisplayObject = null;
         var newEmblem:DisplayObject = null;
         var itemData:Object = getParsedProductDetails(cType,cName,cImgURL);
         if(cBgHolder != null)
         {
            while(cBgHolder.numChildren > 0)
            {
               cBgHolder.removeChildAt(0);
            }
         }
         if(cTitleTF != null)
         {
            cTitleTF.visible = false;
         }
         if(cBgHolder != null)
         {
            cBgHolder.visible = false;
         }
         if(cImgHolder != null)
         {
            cImgHolder.visible = false;
         }
         if(cType == ItemType.PCT && cTitleTF != null)
         {
            cTitleTF.visible = true;
            cTitleTF.text = itemData.name;
            TextUtil.resizeTextToFitWidth(cTitleTF);
         }
         else if(cType == ItemType.PCB && cBgHolder != null)
         {
            cBgHolder.visible = true;
            if(isAnimatedItem("pcab_",itemData.imageURL))
            {
               cBgHolder["clearImage"]();
               newBackground = attachAnimatedClip(cBgHolder,itemData.imageURL);
               if(newBackground != null)
               {
                  newBackground.scaleX = newBackground.scaleY = 0.75;
                  newBackground.x = 0;
                  newBackground.y = 14;
               }
            }
            else
            {
               cBgHolder["setImage"](itemData.imageURL);
            }
         }
         else if(cType == ItemType.PCI && cImgHolder != null)
         {
            cImgHolder.visible = true;
            if(isAnimatedItem("pcai_",itemData.imageURL))
            {
               cImgHolder["clearImage"]();
               newEmblem = attachAnimatedClip(cImgHolder,itemData.imageURL);
               if(newEmblem != null)
               {
                  newEmblem.x = 108;
                  newEmblem.y = 0;
               }
            }
            else
            {
               cImgHolder["setImage"](itemData.imageURL);
            }
         }
         else if(cImgHolder != null)
         {
            cImgHolder.visible = true;
            cImgHolder["setImage"](itemData.imageURL);
         }
      }
      
      public static function setItemImage(imageClip:FsgImageHolder, item:ProductObj) : void
      {
         var clip:DisplayObject = null;
         var clipSize:MovieClip = null;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var scale:Number = NaN;
         imageClip.clearImage();
         if(item.isAnimatedBackground() || item.isAnimatedEmblem())
         {
            clip = attachAnimatedClip(imageClip,item.imageURL);
            if(clip != null)
            {
               clipSize = clip["mySize"];
               if(clipSize != null)
               {
                  contentWidth = clipSize.width;
                  contentHeight = clipSize.height;
                  if(item.isAnimatedBackground())
                  {
                     scale = getProperScaleSize(clipSize.width,clipSize.height,imageClip.startingWidth,imageClip.startingWidth);
                     clip.scaleX = clip.scaleY = scale;
                     contentWidth = clipSize.width * scale;
                     contentHeight = clipSize.height * scale;
                  }
                  clip.x = imageClip.startingWidth / 2 - contentWidth / 2;
                  clip.y = imageClip.startingHeight / 2 - contentHeight / 2;
               }
               else
               {
                  clip.x = imageClip.startingWidth / 2 - clip.width / 2;
                  clip.y = imageClip.startingHeight / 2 - clip.height / 2;
               }
            }
            imageClip.forceDispatchLoadComplete();
         }
         else
         {
            imageClip.setImage(item.imageURL);
         }
      }
      
      private static function getProperScaleSize(animatedWidth:Number, animatedHeight:Number, holderWidth:Number, holderHeight:Number) : Number
      {
         var widthScale:Number = holderWidth / animatedWidth;
         var heightScale:Number = holderHeight / animatedHeight;
         return Math.min(widthScale,heightScale);
      }
      
      private static function attachAnimatedClip(cBgHolder:Sprite, name:String) : DisplayObject
      {
         var itemClass:Class = null;
         try
         {
            itemClass = getDefinitionByName(name.toUpperCase()) as Class;
         }
         catch(e:ReferenceError)
         {
            trace(e);
         }
         if(itemClass != null)
         {
            return cBgHolder.addChild(new itemClass());
         }
         return null;
      }
      
      private static function isAnimatedItem(tag:String, background:String) : Boolean
      {
         var compareStr:String = background.substr(0,5).toLowerCase();
         return compareStr == tag;
      }
      
      public static function tryShowSaleTag(product:ProductObj, saleTag:MovieClip) : void
      {
         var skus:Array = product.SKUs;
         tryShowSaleTagBySku(skus,saleTag);
      }
      
      public static function getSkuSaleValue(sku:SKUObj) : String
      {
         var skus:Array = new Array();
         skus.push(sku);
         return getItemSaleValueBySku(skus);
      }
      
      public static function getItemSaleValueBySku(skus:Array) : String
      {
         var sku:Object = null;
         var toFix:int = 0;
         if(skus == null || skus.length == 0)
         {
            return null;
         }
         var skuCount:int = int(skus.length);
         var discountRate:int = -1;
         for(var i:int = 0; i < skuCount; i++)
         {
            sku = skus[i];
            if(!sku.isInFuture)
            {
               if(sku.hasOwnProperty("originalPrice") && sku.hasOwnProperty("discountRate"))
               {
                  if(discountRate == -1 || sku.discountRate < discountRate)
                  {
                     discountRate = int(sku.discountRate);
                  }
               }
            }
         }
         if(discountRate != -1)
         {
            if(isChineseLanguage)
            {
               toFix = discountRate % 10 == 0 ? 0 : 1;
               return Number(discountRate / 10).toFixed(toFix);
            }
            return String(100 - discountRate);
         }
         return null;
      }
      
      public static function tryShowSaleTagBySku(skus:Array, saleTag:MovieClip) : void
      {
         var sku:Object = null;
         var toFix:int = 0;
         var skuCount:int = int(skus.length);
         var discountRate:int = -1;
         for(var i:int = 0; i < skuCount; i++)
         {
            sku = skus[i];
            if(!sku.isInFuture)
            {
               if(sku.hasOwnProperty("originalPrice") && sku.hasOwnProperty("discountRate"))
               {
                  if(discountRate == -1 || sku.discountRate < discountRate)
                  {
                     discountRate = int(sku.discountRate);
                  }
               }
            }
         }
         if(discountRate != -1)
         {
            saleTag.visible = true;
            if(discountRate == 50)
            {
               TextUtil.replaceEnFont(saleTag.myTextTF,DictMarket.HALF_DISCOUNT);
            }
            else if(isChineseLanguage)
            {
               toFix = discountRate % 10 == 0 ? 0 : 1;
               TextUtil.replaceEnFont(saleTag.myTextTF,LocalizeUtil.param(DictMarket.DISCOUNT,[String(Number(discountRate / 10).toFixed(toFix))]));
            }
            else
            {
               TextUtil.replaceEnFont(saleTag.myTextTF,LocalizeUtil.param(DictMarket.DISCOUNT,[String(100 - discountRate)]));
            }
         }
         else
         {
            saleTag.visible = false;
         }
      }
      
      public static function tryShowXPBoost(product:ProductObj, xpBoostClip:MovieClip) : void
      {
         var name:String = null;
         var value:String = null;
         if(Boolean(xpBoostClip))
         {
            if(Boolean(product.specialPara) && product.specialPara.length > 0)
            {
               name = product.specialPara[0].name.toUpperCase();
               value = product.specialPara[0].value;
               if(value == "0")
               {
                  xpBoostClip.visible = false;
               }
               else
               {
                  if(value.indexOf("%") == -1)
                  {
                     value += "%";
                  }
                  xpBoostClip.visible = true;
                  if(product.type == ItemType.CAT || product.type == ItemType.BUNDLE)
                  {
                     xpBoostClip.myKeyText.text = name;
                  }
                  else
                  {
                     xpBoostClip.myKeyText.text = LocalizeUtil.param(Dict.SPECIAL_TAG_WEAPON_XP,[name]);
                  }
                  xpBoostClip.myValueText.text = "+" + value;
               }
            }
            else
            {
               xpBoostClip.visible = false;
            }
         }
      }
      
      public static function getDuratingString(duration:int) : String
      {
         var timeAmount:String = duration == 0 ? "" : String(duration);
         var timeUnit:String = duration == 0 ? LocalizeUtil.localize(Dict.FOREVER) : " " + LocalizeUtil.localize(Dict.DAY);
         return timeAmount + timeUnit;
      }
      
      public static function getDurationStringFromSKU(sku:int) : String
      {
         var duration:int = CFunctionContainer.AS_GetDurationFromSKU(sku);
         if(duration == -1)
         {
            return "";
         }
         return getDuratingString(duration);
      }
      
      private static function streakCompare(a:Object, b:Object) : int
      {
         var prodA:ProductObj = a.item;
         var prodB:ProductObj = b.item;
         if(prodA.killsReq != prodB.killsReq)
         {
            return prodA.killsReq < prodB.killsReq ? -1 : 1;
         }
         return 0;
      }
      
      public static function sortStreaks(slotObjs:Array) : Array
      {
         var i:int = 0;
         var slot:ItemSlotObj = null;
         var curData:Object = null;
         var sortData:Array = [];
         for(i = 0; i < slotObjs.length; i++)
         {
            slot = new ItemSlotObj(slotObjs[i]);
            curData = {
               "slot":slot,
               "item":CFunctionCommonContainer.GetItemInfo(slot.item_id)
            };
            sortData.push(curData);
         }
         sortData.sort(streakCompare);
         return sortData;
      }
      
      public static function getProductObjByProductId(prodID:int) : ProductObj
      {
         var prod:ProductObj = null;
         if(prodID == 0)
         {
            return null;
         }
         var itemIDs:Array = CFunctionContainer.AS_GetItemIDsFromProduct(prodID);
         if(itemIDs.length <= 0)
         {
            return null;
         }
         if(Boolean(CFunctionContainer.IsBundleProduct(prodID)))
         {
            prod = new ProductObj(CFunctionCommonContainer.GetBundleInfo(prodID));
         }
         else
         {
            prod = new ProductObj(CFunctionCommonContainer.GetItemInfo(itemIDs[0]));
         }
         return prod;
      }
   }
}

