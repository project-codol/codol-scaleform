package codo.views.supplyDrop_parts
{
   import codo.constants.MarketMenuData;
   import codo.objects.ProductObj;
   import codo.style.MarketGuide;
   import codo.utils.SoundUtil;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class SupplyDropRewardItemCover extends Sprite
   {
      
      private static const ANIMATE_DUR_SCALE:Number = 0.5;
      
      private static const FADE_DURATION:Number = 0.3 * ANIMATE_DUR_SCALE;
      
      public var myLock:SupplyDropRewardItemCoverLock;
      
      public var myTopBits:Sprite;
      
      public var myBotBits:Sprite;
      
      public var myCoverBottom:SupplyDropRewardItemCoverPieceBottom;
      
      public var myRewardItemCard:SupplyDropRewardItemCard;
      
      public var myCoverTop:SupplyDropRewardItemCoverPiece;
      
      public var mySlotBottom:MovieClip;
      
      public var mySlotTop:MovieClip;
      
      public var myHolder:Sprite;
      
      private var isOpening:Boolean = false;
      
      private var mSlotTopInitY:int;
      
      private var mSlotBotInitY:int;
      
      private var mPulseGlow:TweenMax;
      
      private var mCommonTierGlow:GlowFilter = new GlowFilter(0,0.5,25,25);
      
      private var mIsFeatured:Boolean = false;
      
      private var mIsOpenDuplicate:Boolean = false;
      
      private var mAfterOpenedCallback:Function;
      
      public function SupplyDropRewardItemCover()
      {
         super();
         mouseEnabled = mouseChildren = false;
         this.mySlotTop.alpha = this.mySlotBottom.alpha = 0;
         this.mSlotTopInitY = this.mySlotTop.y;
         this.mSlotBotInitY = this.mySlotBottom.y;
      }
      
      public function setRewardItemData(data:ProductObj, isFeatured:Boolean = false) : void
      {
         this.mSlotTopInitY = this.mySlotTop.y = -45.25;
         this.mSlotBotInitY = this.mySlotBottom.y = 5.5;
         this.myRewardItemCard.setData(data);
         this.mIsFeatured = isFeatured;
         this.mIsOpenDuplicate = false;
         if(data.tier > 0)
         {
            this.mCommonTierGlow.color = MarketGuide.COLOR_BY_TIER[data.tier];
            this.mPulseGlow = new TweenMax(this,0.5 * ANIMATE_DUR_SCALE,{
               "glowFilter":{
                  "color":this.mCommonTierGlow.color,
                  "alpha":0.75,
                  "blurX":this.mCommonTierGlow.blurX,
                  "blurY":this.mCommonTierGlow.blurY
               },
               "yoyo":true,
               "repeat":-1
            });
            this.mPulseGlow.play();
         }
         else
         {
            filters = [this.mCommonTierGlow];
         }
      }
      
      public function set afterOpenedCallback(callback:Function) : void
      {
         this.mAfterOpenedCallback = callback;
      }
      
      public function set supplyDropType(supplyDropID:int) : void
      {
         var cardFrame:int = 3;
         if(this.mIsFeatured)
         {
            cardFrame = 4;
         }
         else
         {
            switch(supplyDropID)
            {
               case MarketMenuData.SUPPLY_DROP_BASIC:
                  cardFrame = 1;
                  break;
               case MarketMenuData.SUPPLY_DROP_ADVANCED:
                  cardFrame = 2;
                  break;
               case MarketMenuData.SUPPLY_DROP_EVENT:
                  cardFrame = 3;
            }
         }
         this.mySlotTop.gotoAndStop(cardFrame);
         this.mySlotBottom.gotoAndStop(cardFrame);
         this.myCoverTop.cardTypeByID = this.myCoverBottom.cardTypeByID = this.myLock.cardTypeByID = cardFrame;
      }
      
      public function openReward() : void
      {
         if(this.mPulseGlow != null)
         {
            this.mPulseGlow.repeat = 0;
         }
         else
         {
            filters = [this.mCommonTierGlow];
         }
         this.isOpening = true;
         this.myLock.animateOpened(this.onLockOpen);
         swapChildren(this.myLock,getChildAt(numChildren - 1));
      }
      
      private function onLockOpen() : void
      {
         var Y_OFFSET:uint = 122;
         swapChildren(this.myLock,this.myHolder);
         this.myCoverBottom.animateOpen();
         this.myCoverTop.animateOpen();
         this.myRewardItemCard.animateOpened();
         TweenLite.to(this.mySlotTop,FADE_DURATION,{
            "alpha":1,
            "y":this.mSlotTopInitY - Y_OFFSET,
            "ease":Cubic.easeOut,
            "delay":0.1 * ANIMATE_DUR_SCALE
         });
         TweenLite.to(this.mySlotBottom,FADE_DURATION,{
            "alpha":1,
            "y":this.mSlotBotInitY + Y_OFFSET,
            "ease":Cubic.easeOut,
            "delay":0.1 * ANIMATE_DUR_SCALE
         });
         TweenLite.to(this.myTopBits,FADE_DURATION,{
            "alpha":0,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this.myBotBits,FADE_DURATION,{
            "alpha":0,
            "ease":Cubic.easeOut,
            "onComplete":this.onLockOpened
         });
      }
      
      private function onLockOpened() : void
      {
         if(this.mAfterOpenedCallback != null)
         {
            this.mAfterOpenedCallback();
         }
      }
      
      public function setItemInDependencyMode(dependencyIsOwned:Boolean) : void
      {
         this.myRewardItemCard.missingDependency = !dependencyIsOwned;
      }
      
      public function setDuplicatedMode(currencyID:int, value:int, isPartial:Boolean) : void
      {
         this.myRewardItemCard.setDuplicateValue(currencyID,value,isPartial,this.closeForDuplicateAnim);
         this.mIsOpenDuplicate = true;
      }
      
      private function closeForDuplicateAnim() : void
      {
         TweenLite.to(this.mySlotTop,FADE_DURATION,{
            "alpha":0,
            "y":this.mSlotTopInitY,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this.mySlotBottom,FADE_DURATION,{
            "alpha":0,
            "y":this.mSlotBotInitY,
            "ease":Cubic.easeOut,
            "onComplete":this.myRewardItemCard.revealGPCard
         });
         this.myLock.myLockCenter.animatePiecesOut(this.openReward);
         this.myCoverBottom.animateClose();
         this.myCoverTop.animateClose();
      }
      
      public function onMouseOver() : void
      {
         if(this.isOpening)
         {
            return;
         }
         this.myLock.animateFocusIn();
         this.myCoverBottom.animateFocusIn();
         this.myCoverTop.animateFocusIn();
         swapChildren(this.myLock,getChildAt(numChildren - 1));
         SoundUtil.getInstance().playSound("UI_Box_Hover");
      }
      
      public function onMouseOut() : void
      {
         if(this.isOpening)
         {
            return;
         }
         this.myLock.animateFocusOut();
         this.myCoverBottom.animateFocusOut();
         this.myCoverTop.animateFocusOut();
         swapChildren(getChildAt(numChildren - 1),this.myTopBits);
      }
   }
}

