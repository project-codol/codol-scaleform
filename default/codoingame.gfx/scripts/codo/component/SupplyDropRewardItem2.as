package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.CurrencyObj;
   import codo.objects.ProductObj;
   import codo.objects.SupplyDropRewardItemObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.SoundUtil;
   import codo.utils.TimeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import fl.motion.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgImageHolder;
   import fsg.util.ImageHolderSimple;
   
   public class SupplyDropRewardItem2 extends MovieClip
   {
      
      private static var sTierColors:Array = [[0.47,0.47,0.47,7829367],[0.5255,0.8588,0.2392,8837949],[0.2078,0.7882,0.9882,3525116],[0.7255,0.3608,1,12147967],[1,0.5451,0,16747264]];
      
      public var mySpecialHint:flash.text.TextField;
      
      public var myAltText:flash.text.TextField;
      
      public var myAltTextShadow:flash.text.TextField;
      
      public var myAnimatedEmblemMount:MovieClip;
      
      public var myAnimatedBackgroundMount:MovieClip;
      
      public var myItemIconHolder:ImageHolderSimple;
      
      public var myItemImageHolder:FsgImageHolder;
      
      public var myDependencyNeededHint:MovieClip;
      
      public var myPartlyCrushHint:flash.text.TextField;
      
      public var myPartlyCrushIcon:MovieClip;
      
      public var myCrushIcon:MovieClip;
      
      public var myName:flash.text.TextField;
      
      public var myType:flash.text.TextField;
      
      public var myPermanentDurationEffect:MovieClip;
      
      public var myDuration:flash.text.TextField;
      
      public var myItemBg:MovieClip;
      
      public var myBg:MovieClip;
      
      private var mRewardItem:SupplyDropRewardItemObj;
      
      private var mItemLaunchedCallback:Function;
      
      private var mItemCrushAnimationPlayedCallback:Function;
      
      private var mCrushAnimationPlayed:Boolean;
      
      private var mZoom:Number;
      
      private var mDependencyNeededHintClickableBehavior:BehaviourClickable;
      
      private var mDependencyItem:ProductObj;
      
      public function SupplyDropRewardItem2()
      {
         super();
         this.myPermanentDurationEffect.visible = false;
         this.myPartlyCrushHint.text = Dict.SUPPLY_DROP_PARTIAL_CRUSHED;
         this.myDependencyNeededHint.myText.text = Dict.SUPPLY_DROP_DEPENDENCY_ITEM_NEEDED;
         this.mDependencyNeededHintClickableBehavior = new BehaviourClickable(this.myDependencyNeededHint);
         this.mDependencyNeededHintClickableBehavior.setEnabled(true);
         this.mDependencyNeededHintClickableBehavior.addClickCallback(this.onDependencyNeededHintClicked);
      }
      
      public function setData(data:SupplyDropRewardItemObj) : void
      {
         var textFormat:TextFormat = null;
         var productObj:ProductObj = null;
         var i:int = 0;
         var itemData:ProductObj = null;
         this.mRewardItem = data;
         productObj = this.mRewardItem.product;
         var color:Array = sTierColors[productObj.tier];
         var colorTransform:ColorTransform = new ColorTransform();
         colorTransform.redMultiplier = color[0];
         colorTransform.greenMultiplier = color[1];
         colorTransform.blueMultiplier = color[2];
         this.myItemBg.gotoAndStop(productObj.tier + 1);
         this.myBg["myPart1"].transform.colorTransform = colorTransform;
         this.myBg["myPart2"].transform.colorTransform = colorTransform;
         this.myBg["myPart3"].transform.colorTransform = colorTransform;
         this.myBg["myPart4"].transform.colorTransform = colorTransform;
         var dependencyItemOwned:Boolean = false;
         this.mDependencyItem = null;
         if(this.mRewardItem.itemDependencies != null && this.mRewardItem.itemDependencies.length > 0)
         {
            for(i = 0; i < this.mRewardItem.itemDependencies.length; i++)
            {
               itemData = CFunctionCommonContainer.GetItemInfo(this.mRewardItem.itemDependencies[i]);
               if(itemData.isOwned())
               {
                  dependencyItemOwned = true;
                  break;
               }
               this.mDependencyItem = itemData;
            }
         }
         else
         {
            dependencyItemOwned = true;
         }
         this.myDependencyNeededHint.visible = !dependencyItemOwned;
         var categoryStr:String = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(productObj.group));
         if(!categoryStr)
         {
            categoryStr = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(productObj.type));
         }
         this.myType.text = categoryStr;
         this.myName.text = productObj.name;
         this.myBg["myCategoryBg"].visible = true;
         if(!categoryStr)
         {
            this.myBg["myCategoryBg"].visible = false;
         }
         if(productObj.tier > 1)
         {
            if(this.mRewardItem.isFeatured || this.mRewardItem.shouldShowOff)
            {
               this.filters = [new GlowFilter(color[3],0.5,30,30)];
               this.startBreathOutGlow();
            }
            else
            {
               this.filters = [new GlowFilter(color[3],0.3,25,25)];
            }
         }
         this.myCrushIcon.visible = false;
         this.myPartlyCrushIcon.visible = false;
         this.myPartlyCrushHint.visible = false;
         this.myItemBg.scaleY = 1;
         this.mySpecialHint.text = "";
         if(this.mRewardItem.isFeatured)
         {
            this.mySpecialHint.text = DictMarket.SUPPLY_DROPS_GUARANTEED_TITLE;
         }
         this.myPermanentDurationEffect.visible = false;
         this.setIcon(productObj);
         this.myDuration.filters = [];
         textFormat = this.myDuration.getTextFormat();
         textFormat.font = GlobalGuide.FONT_FACE_MEDIUM;
         textFormat.size = 12;
         this.myDuration.setTextFormat(textFormat);
         if(productObj.stackable)
         {
            if(productObj.stackNumber > 0)
            {
               this.myDuration.text = LocalizeUtil.param(DictMarket.MARKET_QUANTITY,[productObj.stackNumber]);
            }
         }
         else if(productObj.supplyDropRentalDurationSeconds > 0)
         {
            this.myDuration.text = TimeUtil.secondsToDays(productObj.supplyDropRentalDurationSeconds).toString() + LocalizeUtil.localize(Dict.DAY);
         }
         else
         {
            this.myDuration.visible = false;
            textFormat = this.myDuration.getTextFormat();
            textFormat.font = GlobalGuide.FONT_FACE_BOLD;
            this.myDuration.setTextFormat(textFormat);
            this.myDuration.text = Dict.FOREVER;
            textFormat.size = 16;
            this.myDuration.filters = [new GlowFilter(16777215,0.5,1,1)];
            this.myPermanentDurationEffect.visible = true;
            this.myPermanentDurationEffect.gotoAndPlay(1);
         }
      }
      
      public function startBreathOutGlow() : void
      {
         TweenLite.to(this,1,{
            "glowFilter":{
               "blurX":50,
               "blurY":50
            },
            "ease":Linear.easeIn,
            "onComplete":this.startBreathIntGlow
         });
      }
      
      public function startBreathIntGlow() : void
      {
         TweenLite.to(this,1,{
            "glowFilter":{
               "blurX":30,
               "blurY":30
            },
            "ease":Linear.easeOut,
            "onComplete":this.startBreathOutGlow
         });
      }
      
      public function setIcon(productObj:ProductObj) : void
      {
         var ANIMATED_FRAME_WIDTH:int = 0;
         var ANIMATED_FRAME_HEIGHT:int = 0;
         var size:Point = null;
         var animatedBackgroundLoadData:Object = null;
         var animatedIconLoadData:Object = null;
         var useIconHolderForImage:Boolean = productObj.useIconHolderForImage();
         var isAnimatedBackground:Boolean = productObj.isAnimatedBackground();
         var isAnimatedEmblem:Boolean = productObj.isAnimatedEmblem();
         var isAnimatedFrame:Boolean = productObj.isAnimatedFrame();
         this.myItemImageHolder.visible = false;
         this.myAltText.visible = false;
         this.myItemIconHolder.visible = false;
         this.myAltTextShadow.visible = false;
         this.myAnimatedBackgroundMount.visible = false;
         this.myAnimatedEmblemMount.visible = false;
         if(productObj.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            this.myAltText.text = productObj.name;
            this.myAltTextShadow.text = productObj.name;
            this.myItemImageHolder.visible = false;
            this.myAltTextShadow.y = this.myAltText.y = this.myItemImageHolder.y + this.myItemImageHolder.height * 0.5 - this.myAltText.textHeight * 0.5;
            this.myAltText.visible = true;
            this.myAltTextShadow.visible = this.myAltText.visible;
         }
         else if(useIconHolderForImage)
         {
            this.myItemIconHolder.visible = true;
            this.myItemIconHolder.addEventListener(Event.COMPLETE,this.onIconImageLoaded);
            this.myItemIconHolder.setImage(productObj.imageURL);
         }
         else if(isAnimatedBackground || isAnimatedFrame)
         {
            ANIMATED_FRAME_WIDTH = 382;
            ANIMATED_FRAME_HEIGHT = 29;
            if(isAnimatedFrame)
            {
               size = new Point(ANIMATED_FRAME_WIDTH,ANIMATED_FRAME_HEIGHT);
            }
            animatedBackgroundLoadData = {
               "name":productObj.imageURL,
               "holder":this.myAnimatedBackgroundMount,
               "size":size
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedBackgroundLoadData);
            this.myAnimatedBackgroundMount.visible = true;
         }
         else if(isAnimatedEmblem)
         {
            animatedIconLoadData = {
               "name":productObj.imageURL,
               "holder":this.myAnimatedEmblemMount
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedIconLoadData);
            this.myAnimatedEmblemMount.visible = true;
         }
         else
         {
            this.myItemImageHolder.visible = true;
            this.myItemImageHolder.setImage(productObj.imageURL);
         }
      }
      
      protected function onIconImageLoaded(e:Event) : void
      {
         this.myItemIconHolder.removeEventListener(Event.COMPLETE,this.onIconImageLoaded);
         var bmpImage:DisplayObject = this.myItemIconHolder.loadedAsset;
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
         bmpImage.x = (this.myItemImageHolder.width - bmpImage.width) * 0.5;
         bmpImage.y = (this.myItemImageHolder.height - bmpImage.height) * 0.5;
      }
      
      public function getData() : SupplyDropRewardItemObj
      {
         return this.mRewardItem;
      }
      
      public function launch(delay:Number) : void
      {
         SoundUtil.getInstance().playSound("ui_supplydrop_reward_click_01");
         visible = false;
         var timeline:TimelineLite = new TimelineLite({
            "onComplete":this.onItemLaunched,
            "onCompleteParams":[this]
         });
         this.width = 71.2;
         this.height = 102.1;
         timeline.append(TweenLite.to(this,delay,{}));
         timeline.append(TweenLite.to(this,0.292,{
            "visible":true,
            "width":184.1 * this.mZoom,
            "height":264.2 * this.mZoom,
            "ease":Linear.easeIn
         }));
         if(this.mRewardItem.shouldShowOff || this.mRewardItem.isFeatured)
         {
            timeline.append(TweenLite.to(this,0.083,{
               "width":257.9 * this.mZoom * 1.2,
               "height":370 * this.mZoom * 1.2
            }));
         }
         else
         {
            timeline.append(TweenLite.to(this,0.083,{
               "width":257.9 * this.mZoom,
               "height":370 * this.mZoom
            }));
         }
         timeline.append(TweenLite.to(this,0.21,{
            "width":230 * this.mZoom,
            "height":330 * this.mZoom,
            "ease":Linear.easeOut
         }));
         if(!this.mRewardItem.product.stackable && this.mRewardItem.product.supplyDropRentalDurationSeconds == 0)
         {
            timeline.append(TweenLite.to(this.myPermanentDurationEffect,0.5,{"onStart":this.playPermanentDurationEffect}));
         }
      }
      
      public function playPermanentDurationEffect() : void
      {
         this.myDuration.alpha = 0;
         this.myDuration.visible = true;
         TweenLite.to(this.myDuration,0.5,{"alpha":1});
         this.myPermanentDurationEffect.visible = true;
         this.myPermanentDurationEffect.gotoAndPlay(1);
      }
      
      private function onItemLaunched(item:SupplyDropRewardItem2) : void
      {
         if(this.mItemLaunchedCallback != null)
         {
            this.mItemLaunchedCallback(item);
         }
      }
      
      public function set itemLaunchedCallback(itemLaunchedCallback:Function) : void
      {
         this.mItemLaunchedCallback = itemLaunchedCallback;
      }
      
      private function onItemCrushAnimationPlayed(item:SupplyDropRewardItem2) : void
      {
         this.mCrushAnimationPlayed = true;
         if(this.mItemCrushAnimationPlayedCallback != null)
         {
            this.mItemCrushAnimationPlayedCallback(item);
         }
      }
      
      public function set itemCrushAnimationPlayedCallback(itemCrushAnimationPlayedCallback:Function) : void
      {
         this.mItemCrushAnimationPlayedCallback = itemCrushAnimationPlayedCallback;
      }
      
      public function shouldCrush() : Boolean
      {
         return this.mRewardItem.isReplacedItem && this.mRewardItem.alternativeAmount > 0;
      }
      
      public function get crushAmount() : int
      {
         return this.mRewardItem.alternativeAmount;
      }
      
      public function get crushAnimationPlayed() : Boolean
      {
         return this.mCrushAnimationPlayed;
      }
      
      public function set zoom(zoom:Number) : void
      {
         this.mZoom = zoom;
      }
      
      public function playCrushAnimation() : void
      {
         if(!this.shouldCrush())
         {
            this.onItemCrushAnimationPlayed(this);
            return;
         }
         SoundUtil.getInstance().playSound("UI_Duplicate_Bought");
         var timeline:TimelineLite = new TimelineLite();
         timeline.append(TweenLite.to(this.myItemBg,0.2,{}));
         timeline.append(TweenLite.to(this.myItemBg,0.1,{
            "scaleY":0,
            "ease":Linear.easeOut,
            "onStart":this.onHideIcon
         }));
         timeline.append(TweenLite.to(this.myItemBg,0.1,{
            "scaleY":1,
            "ease":Linear.easeIn,
            "onComplete":this.onShowCrushIcon
         }));
         timeline.append(TweenLite.to(this.myItemBg,0.2,{
            "onComplete":this.onItemCrushAnimationPlayed,
            "onCompleteParams":[this]
         }));
      }
      
      private function onHideIcon() : void
      {
         this.hideIcon();
      }
      
      private function hideIcon() : void
      {
         TweenLite.to(this.myItemImageHolder,0.1,{"alpha":0});
         TweenLite.to(this.myAltText,0.1,{"alpha":0});
         TweenLite.to(this.myItemIconHolder,0.1,{"alpha":0});
         TweenLite.to(this.myAltTextShadow,0.1,{"alpha":0});
         TweenLite.to(this.myAnimatedBackgroundMount,0.1,{"alpha":0});
         TweenLite.to(this.myAnimatedEmblemMount,0.1,{"alpha":0});
      }
      
      private function showIcon() : void
      {
         TweenLite.to(this.myItemImageHolder,0.1,{"alpha":1});
         TweenLite.to(this.myAltText,0.1,{"alpha":1});
         TweenLite.to(this.myItemIconHolder,0.1,{"alpha":1});
         TweenLite.to(this.myAltTextShadow,0.1,{"alpha":1});
         TweenLite.to(this.myAnimatedBackgroundMount,0.1,{"alpha":1});
         TweenLite.to(this.myAnimatedEmblemMount,0.1,{"alpha":1});
      }
      
      private function onShowCrushIcon() : void
      {
         if(this.mRewardItem.isPartialCrushed)
         {
            this.myPartlyCrushIcon.gotoAndStop(1);
            if(this.mRewardItem.crushedCurrencyID == CurrencyObj.CURRENCY_BSDPOINT)
            {
               this.myPartlyCrushIcon.gotoAndStop(2);
            }
            else if(this.mRewardItem.crushedCurrencyID == CurrencyObj.CURRENCY_ASDPOINT)
            {
               this.myPartlyCrushIcon.gotoAndStop(3);
            }
            else if(this.mRewardItem.crushedCurrencyID == CurrencyObj.CURRENCY_LSDPOINT)
            {
               this.myPartlyCrushIcon.gotoAndStop(4);
            }
            this.showIcon();
            this.myPartlyCrushIcon.visible = true;
            this.myPartlyCrushIcon.alpha = 0;
            TweenLite.to(this.myPartlyCrushIcon,0.1,{"alpha":1});
            this.myPartlyCrushHint.visible = true;
            this.myPartlyCrushHint.alpha = 0;
            TweenLite.to(this.myPartlyCrushHint,0.1,{"alpha":1});
         }
         else
         {
            this.myCrushIcon.gotoAndStop(1);
            if(this.mRewardItem.crushedCurrencyID == CurrencyObj.CURRENCY_BSDPOINT)
            {
               this.myCrushIcon.gotoAndStop(2);
            }
            else if(this.mRewardItem.crushedCurrencyID == CurrencyObj.CURRENCY_ASDPOINT)
            {
               this.myCrushIcon.gotoAndStop(3);
            }
            else if(this.mRewardItem.crushedCurrencyID == CurrencyObj.CURRENCY_LSDPOINT)
            {
               this.myCrushIcon.gotoAndStop(4);
            }
            this.myCrushIcon.myValueTF.text = this.mRewardItem.alternativeAmount.toString();
            this.myCrushIcon.visible = true;
            this.myCrushIcon.alpha = 0;
            TweenLite.to(this.myCrushIcon,0.1,{"alpha":1});
         }
      }
      
      private function onDependencyNeededHintClicked() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP_DEPENDENCY_POPUP,{
            "rewardItem":this.mRewardItem.product,
            "dependency":this.mDependencyItem
         });
      }
   }
}

