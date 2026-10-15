package codo.views.supplyDrop_parts
{
   import codo.component.core.ItemCardBase;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.localization.DictRoom;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.TimeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Cubic;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFieldEx;
   
   public class SupplyDropRewardItemCard extends ItemCardBase
   {
      
      private static const ANIMATE_DUR_SCALE:Number = 0.5;
      
      private static const FADE_DURATION:Number = 0.4 * ANIMATE_DUR_SCALE;
      
      private static const DUPLICATE_ANIM_DELAY:Number = 1 * ANIMATE_DUR_SCALE;
      
      private static const IMAGE_HOLDER_WIDTH:int = 300;
      
      private static const IMAGE_HOLDER_HEIGHT:int = 210;
      
      public var myItemCategoryBkg:Sprite;
      
      public var myItemTitleBkg:Sprite;
      
      public var myTop:MovieClip;
      
      public var myBottom:MovieClip;
      
      public var myBotShape:Sprite;
      
      public var myTopShape:Sprite;
      
      public var myMask:Sprite;
      
      public var myTierMultiply:Sprite;
      
      public var myItemDurationTF:TextField;
      
      public var myDependencyMultiply:Sprite;
      
      public var myDuplicateGPCard:MovieClip;
      
      public var myDuplicateCover:Sprite;
      
      public var myDuplicateMsg:Sprite;
      
      public var myPartialCrushMsg:TextField;
      
      public var myPartialCrushBg:MovieClip;
      
      public var myPartialDuplicateGPCard:MovieClip;
      
      private var mDuplicateCurrencyID:int = 0;
      
      private var mDuplicateValue:int = 0;
      
      private var mIsPartialDuplicated:Boolean = false;
      
      private var mDuplicateAnimComplete:Function;
      
      private var mAnimateDuplicate:TimelineLite;
      
      private var mMissingDependency:Boolean = false;
      
      private var mItemCrushed:Boolean = false;
      
      public function SupplyDropRewardItemCard()
      {
         var duplicateTxt:String = null;
         super();
         duplicateTxt = LocalizeUtil.localize(Dict.ITEM_ALREADY_OWNED);
         visible = false;
         this.myItemTitleBkg.width = this.myItemCategoryBkg.width = 0;
         this.hideAllItems();
         myItemNameTF.alpha = myItemCategoryTF.alpha = this.myItemDurationTF.alpha = this.myDuplicateMsg.alpha = this.myDependencyMultiply.alpha = 0;
         this.myDuplicateMsg.scaleX = this.myDuplicateMsg.scaleY = 0;
         TextFieldEx.setVerticalAlign(myItemNameTF,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(myItemCategoryTF,TextFieldEx.VALIGN_CENTER);
         this.myDuplicateCover.x = this.myDuplicateCover.width;
         this.myItemDurationTF.autoSize = TextFieldAutoSize.RIGHT;
         this.myItemDurationTF.y = 225;
         myItemCategoryTF.autoSize = myItemNameTF.autoSize = TextFieldAutoSize.LEFT;
         myItemCategoryTF.y = this.myItemCategoryBkg.y = 201;
         myItemNameTF.y = this.myItemTitleBkg.y = 228;
         this.myPartialCrushMsg.text = Dict.SUPPLY_DROP_PARTIAL_CRUSHED;
         TextField(this.myDuplicateMsg.getChildByName("myDuplicateMsgTF")).text = duplicateTxt;
      }
      
      public function set missingDependency(bMissingDependency:Boolean) : void
      {
         this.mMissingDependency = bMissingDependency;
      }
      
      private function hideAllItems() : void
      {
         myItemCategoryTF.visible = this.myItemCategoryBkg.visible = this.myItemDurationTF.visible = false;
         this.myDuplicateGPCard.visible = this.myDuplicateCover.visible = this.myDuplicateMsg.visible = this.myDependencyMultiply.visible = false;
      }
      
      public function setDuplicateValue(currencyID:int, val:uint, isPartialDuplicated:Boolean, onDuplicateAnimComplete:Function = null) : void
      {
         this.mDuplicateCurrencyID = currencyID;
         this.mDuplicateValue = val;
         this.mIsPartialDuplicated = isPartialDuplicated;
         this.mDuplicateAnimComplete = onDuplicateAnimComplete;
      }
      
      override protected function onIconImageLoaded(e:Event) : void
      {
         myItemIconHolder.removeEventListener(Event.COMPLETE,this.onIconImageLoaded);
         var bmpImage:DisplayObject = myItemIconHolder.loadedAsset;
         if(this.isStaticPlayerCard())
         {
            bmpImage.width = IMAGE_HOLDER_WIDTH;
            bmpImage.scaleY = bmpImage.scaleX;
         }
         else
         {
            bmpImage.scaleX = bmpImage.scaleY = 1.2;
            bmpImage.height = Math.min(IMAGE_HOLDER_HEIGHT,bmpImage.height);
            bmpImage.scaleX = bmpImage.scaleY;
         }
         bmpImage.x = (IMAGE_HOLDER_WIDTH - bmpImage.width) * 0.5;
         bmpImage.y = (IMAGE_HOLDER_HEIGHT - bmpImage.height) * 0.5;
      }
      
      override protected function checkUseIconHolderForImage() : Boolean
      {
         var useIconHolder:Boolean = super.checkUseIconHolderForImage();
         return useIconHolder || this.isCamo() || this.isStaticPlayerCard() || this.isReticle() || this.isEquippableToken();
      }
      
      protected function onMainImageLoaded(e:Event) : void
      {
         myItemImageHolder.removeEventListener(Event.COMPLETE,this.onIconImageLoaded);
         var bmpImage:DisplayObject = myItemImageHolder.loadedAsset;
         var m_scale:Number = 0.75;
         if(this.isDecal())
         {
            bmpImage.width = IMAGE_HOLDER_WIDTH;
            m_scale = bmpImage.scaleX;
         }
         else if(!this.isWildCard())
         {
            bmpImage.width = IMAGE_HOLDER_WIDTH;
            bmpImage.height = IMAGE_HOLDER_HEIGHT;
            m_scale = Math.max(bmpImage.scaleX,bmpImage.scaleY);
         }
         bmpImage.scaleY = bmpImage.scaleX = m_scale;
         bmpImage.x = (IMAGE_HOLDER_WIDTH - bmpImage.width) * 0.5;
         bmpImage.y = (IMAGE_HOLDER_HEIGHT - bmpImage.height) * 0.5;
      }
      
      private function isCamo() : Boolean
      {
         return mData.group == MarketMenuData.SLOT_CAMO;
      }
      
      private function isStaticPlayerCard() : Boolean
      {
         var prodObj:ProductObj = mData as ProductObj;
         return prodObj.type == MarketMenuData.TYPE_CALLSIGN_BKG && !prodObj.isAnimatedBackground();
      }
      
      private function isDecal() : Boolean
      {
         var prodObj:ProductObj = mData as ProductObj;
         return prodObj.group == MarketMenuData.SLOT_DECAL;
      }
      
      private function isWildCard() : Boolean
      {
         var prodObj:ProductObj = mData as ProductObj;
         return prodObj.group == MarketMenuData.GRP_WILDCARD;
      }
      
      private function isEquippableToken() : Boolean
      {
         return ProductObj(mData).group == MarketMenuData.GRP_EQUIPPABLE_TOKEN;
      }
      
      private function isReticle() : Boolean
      {
         return ProductObj(mData).group == MarketMenuData.GRP_RETICLE || ProductObj(mData).group == MarketMenuData.GRP_IRONSIGHT;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var productData:ProductObj = mData as ProductObj;
         var tierFrame:uint = productData.tier + 1;
         myItemNameTF.visible = this.myItemTitleBkg.visible = productData.type != MarketMenuData.TYPE_CALLSIGN_TITLE;
         this.myItemCategoryBkg.visible = myItemCategoryTF.visible;
         this.myDependencyMultiply.visible = false;
         this.myTierMultiply.visible = false;
         this.mItemCrushed = false;
         this.myPartialCrushMsg.alpha = 0;
         this.myPartialCrushBg.alpha = 0;
         this.myPartialDuplicateGPCard.alpha = 0;
         myItemImageHolder.addEventListener(Event.COMPLETE,this.onMainImageLoaded);
         this.myTop.gotoAndStop(tierFrame);
         this.myBottom.gotoAndStop(tierFrame);
         myBuffs.x = this.myMask.width - (myBuffs.width + 10);
      }
      
      public function animateOpened() : void
      {
         TweenLite.to(this.myMask,FADE_DURATION,{
            "scaleY":1,
            "ease":Cubic.easeOut,
            "onComplete":this.onMaskAnimComplete,
            "delay":0.1 * ANIMATE_DUR_SCALE
         });
         visible = true;
      }
      
      private function onMaskAnimComplete() : void
      {
         var productData:ProductObj = null;
         var supplyDropRentalDurationSeconds:int = 0;
         var durationTxt:String = null;
         var rentalTxt:String = null;
         var durationFilter:GlowFilter = null;
         var durationTextFormat:TextFormat = null;
         var endWidthCategory:uint = 0;
         var dependencyDelay:Number = 0.35 * ANIMATE_DUR_SCALE;
         if(mData != null)
         {
            productData = mData as ProductObj;
         }
         var shapeEndPos:uint = this.myTopShape.width;
         var PADDING:uint = 10;
         TweenLite.to(this.myTop,0.3 * ANIMATE_DUR_SCALE,{
            "y":-106,
            "ease":Cubic.easeIn
         });
         TweenLite.to(this.myBottom,0.3 * ANIMATE_DUR_SCALE,{
            "y":209,
            "ease":Cubic.easeIn
         });
         TweenLite.to(this.myTopShape,FADE_DURATION,{
            "x":0,
            "ease":Cubic.easeIn,
            "delay":0.2 * ANIMATE_DUR_SCALE
         });
         TweenLite.to(this.myBotShape,FADE_DURATION,{
            "x":shapeEndPos,
            "ease":Cubic.easeIn,
            "delay":0.25 * ANIMATE_DUR_SCALE
         });
         var endWidthTitle:uint = myItemNameTF.textWidth + myItemNameTF.x + PADDING;
         if(this.mIsPartialDuplicated)
         {
            if(this.mItemCrushed)
            {
               this.myPartialCrushMsg.alpha = 1;
               this.myPartialCrushBg.alpha = 1;
               this.myPartialDuplicateGPCard.alpha = 1;
            }
         }
         this.myItemDurationTF.visible = myBuffs.visible = !this.mItemCrushed;
         this.myItemCategoryBkg.visible = myItemCategoryTF.visible = myItemCategoryTF.visible && !this.mItemCrushed;
         if(productData != null && !this.mItemCrushed)
         {
            supplyDropRentalDurationSeconds = int(productData.supplyDropRentalDurationSeconds);
            rentalTxt = LocalizeUtil.localize("@SF_UI_DAY_RENTAL");
            durationFilter = null;
            durationTextFormat = this.myItemDurationTF.getTextFormat();
            durationTextFormat.size = 18;
            durationTextFormat.font = GlobalGuide.FONT_FACE_MEDIUM;
            if(supplyDropRentalDurationSeconds > 0)
            {
               durationTxt = LocalizeUtil.replaceConversionString(rentalTxt,[TimeUtil.secondsToDays(supplyDropRentalDurationSeconds)]);
               durationFilter = new GlowFilter(2764594,1,8,8,0.9,1);
            }
            else if(productData.isOwnedPermanent())
            {
               durationTxt = DictMarket.MARKET_OWNED_ITEM_PERMANENT;
               durationFilter = new GlowFilter(3774158,1,8,8,0.9,1);
               durationTextFormat.size = 20;
               durationTextFormat.font = GlobalGuide.FONT_FACE_BOLD;
            }
            else
            {
               durationTxt = LocalizeUtil.replaceConversionString(rentalTxt,[TimeUtil.secondsToDays(productData.remainSecond)]);
               durationFilter = new GlowFilter(2764594,1,8,8,0.9,1);
            }
            this.myItemDurationTF.text = durationTxt;
            this.myItemDurationTF.filters = [durationFilter];
            this.myItemDurationTF.setTextFormat(durationTextFormat);
            TweenLite.to(this.myItemDurationTF,FADE_DURATION,{
               "alpha":1,
               "ease":Cubic.easeOut,
               "delay":0.26 * ANIMATE_DUR_SCALE
            });
         }
         TweenLite.to(this.myItemTitleBkg,FADE_DURATION,{
            "alpha":1,
            "width":endWidthTitle,
            "ease":Cubic.easeOut,
            "delay":0.3 * ANIMATE_DUR_SCALE
         });
         TweenLite.to(myItemNameTF,FADE_DURATION,{
            "alpha":1,
            "ease":Cubic.easeOut,
            "delay":0.32 * ANIMATE_DUR_SCALE
         });
         if(myItemCategoryTF.visible)
         {
            endWidthCategory = myItemCategoryTF.textWidth + myItemCategoryTF.x + PADDING;
            TweenLite.to(this.myItemCategoryBkg,FADE_DURATION,{
               "width":endWidthCategory,
               "ease":Cubic.easeOut,
               "delay":0.35 * ANIMATE_DUR_SCALE
            });
            TweenLite.to(myItemCategoryTF,FADE_DURATION,{
               "alpha":0.8,
               "ease":Cubic.easeOut,
               "delay":0.37 * ANIMATE_DUR_SCALE
            });
            dependencyDelay = 0.38;
         }
         if(this.mMissingDependency)
         {
            this.myDependencyMultiply.visible = true;
            TweenLite.to(this.myDependencyMultiply,FADE_DURATION,{
               "alpha":1,
               "ease":Cubic.easeOut,
               "delay":dependencyDelay
            });
         }
      }
      
      public function initDuplicateAnim() : void
      {
         var gpValTF:TextField = null;
         if(this.mDuplicateValue <= 0)
         {
            return;
         }
         if(!this.mIsPartialDuplicated)
         {
            myItemNameTF.alpha = this.myItemTitleBkg.alpha = 0;
            this.mAnimateDuplicate = new TimelineLite();
            gpValTF = this.myDuplicateGPCard.getChildByName("myValueTF") as TextField;
            gpValTF.text = this.mDuplicateValue.toString();
            if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_BSD_POINTS)
            {
               this.myDuplicateGPCard.gotoAndStop(2);
            }
            else if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_ASD_POINTS)
            {
               this.myDuplicateGPCard.gotoAndStop(3);
            }
            else if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_LSD_POINTS)
            {
               this.myDuplicateGPCard.gotoAndStop(4);
            }
            else
            {
               this.myDuplicateGPCard.gotoAndStop(1);
            }
            this.myDuplicateCover.visible = this.myDuplicateMsg.visible = true;
            this.mItemCrushed = true;
            this.mAnimateDuplicate.append(new TweenLite(this.myDuplicateCover,0.2 * ANIMATE_DUR_SCALE,{
               "x":0,
               "ease":Cubic.easeOut,
               "delay":DUPLICATE_ANIM_DELAY
            }));
            this.mAnimateDuplicate.append(new TweenLite(this.myDuplicateMsg,0.2 * ANIMATE_DUR_SCALE,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1,
               "ease":Back.easeOut
            }));
            this.mAnimateDuplicate.append(new TweenLite(this.myMask,0.2 * ANIMATE_DUR_SCALE,{
               "scaleY":0,
               "ease":Cubic.easeOut,
               "delay":DUPLICATE_ANIM_DELAY,
               "onComplete":this.onDuplicateAnimComplete
            }));
         }
         else
         {
            this.mAnimateDuplicate = new TimelineLite();
            gpValTF = this.myPartialDuplicateGPCard.getChildByName("myValueTF") as TextField;
            gpValTF.text = this.mDuplicateValue.toString();
            if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_BSD_POINTS)
            {
               this.myPartialDuplicateGPCard.gotoAndStop(2);
            }
            else if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_ASD_POINTS)
            {
               this.myPartialDuplicateGPCard.gotoAndStop(3);
            }
            else if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_LSD_POINTS)
            {
               this.myPartialDuplicateGPCard.gotoAndStop(4);
            }
            else
            {
               this.myPartialDuplicateGPCard.gotoAndStop(1);
            }
            this.mItemCrushed = true;
            this.mAnimateDuplicate.append(new TweenLite(this.myDuplicateCover,0.2 * ANIMATE_DUR_SCALE,{"delay":DUPLICATE_ANIM_DELAY}));
            this.mAnimateDuplicate.append(new TweenLite(this.myDuplicateMsg,0.2 * ANIMATE_DUR_SCALE,{}));
            this.mAnimateDuplicate.append(new TweenLite(this.myMask,0.2 * ANIMATE_DUR_SCALE,{
               "scaleY":0,
               "ease":Cubic.easeOut,
               "delay":DUPLICATE_ANIM_DELAY,
               "onComplete":this.onDuplicateAnimComplete
            }));
         }
      }
      
      private function onDuplicateAnimComplete() : void
      {
         myItemNameTF.y = this.myItemTitleBkg.y = 228;
         this.mDuplicateAnimComplete();
      }
      
      override protected function positionAnimatedEmblem(emblemClip:MovieClip) : void
      {
         super.positionAnimatedEmblem(emblemClip);
         myAnimatedEmblemMount.x = IMAGE_HOLDER_WIDTH / 2 - emblemClip.mySize.width / 2 * myAnimatedEmblemMount.scaleX;
      }
      
      public function revealGPCard() : void
      {
         if(!this.mIsPartialDuplicated)
         {
            this.hideAllItems();
            if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_BSD_POINTS)
            {
               myItemNameTF.text = DictRoom.GAIN_BSDP_BONUS;
            }
            else if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_ASD_POINTS)
            {
               myItemNameTF.text = DictRoom.GAIN_ASDP_BONUS;
            }
            else if(this.mDuplicateCurrencyID == MarketMenuData.CURRENCY_LSD_POINTS)
            {
               myItemNameTF.text = DictRoom.GAIN_LSDP_BONUS;
            }
            else
            {
               myItemNameTF.text = DictRoom.GAIN_GP_BONUS;
            }
            this.myDuplicateGPCard.alpha = 0;
            this.myDuplicateGPCard.visible = true;
            myItemIconHolder.visible = myItemImageHolder.visible = false;
            while(myAnimatedBackgroundMount.numChildren > 0)
            {
               myAnimatedBackgroundMount.removeChildAt(0);
            }
            while(myAnimatedEmblemMount.numChildren > 0)
            {
               myAnimatedEmblemMount.removeChildAt(0);
            }
            TweenLite.to(this.myDuplicateGPCard,FADE_DURATION,{
               "alpha":1,
               "ease":Cubic.easeOut,
               "delay":1 * ANIMATE_DUR_SCALE
            });
         }
         this.mDuplicateCurrencyID = 0;
         this.mDuplicateValue = 0;
      }
   }
}

