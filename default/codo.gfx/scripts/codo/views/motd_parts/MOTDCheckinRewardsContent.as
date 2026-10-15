package codo.views.motd_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionContainer;
   import codo.component.CallToActionButton;
   import codo.component.ContentContainer;
   import codo.component.TextField;
   import codo.component.factory.GlobalFactory;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.constants.SE_ID;
   import codo.localization.Dict;
   import codo.localization.DictMOTD;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.SupplyDropGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.utils.getDefinitionByName;
   
   public class MOTDCheckinRewardsContent extends BaseSubElement
   {
      
      private static const FADE_DURATION:Number = 0.3;
      
      public var myMessageTF:TextField;
      
      public var myRewardContainer:Sprite;
      
      public var myDurationDisplay:MOTDCheckinRewardsDuration;
      
      public var myCurrentReward:MovieClip;
      
      public var myFX:MovieClip;
      
      public var myTestCard:MarketplaceItemCard;
      
      public var myBkg:ContentContainer;
      
      public var myFeaturedBkg:ContentContainer;
      
      public var myBackButton:CallToActionButton;
      
      public var myTitleTF:TextField;
      
      private var mRewardItems:Vector.<MarketplaceItem>;
      
      private var mEarnedIndex:int = -1;
      
      private var mTimelineAnim:TimelineMax;
      
      private var mContainerX:Number;
      
      public var mReceivedDaily:Boolean = false;
      
      public function MOTDCheckinRewardsContent()
      {
         super();
         this.myBkg.width = 1010;
         this.myBkg.height = 841;
         this.myBkg.myContainer.gotoAndStop(6);
         this.mContainerX = this.myBkg.x + 20;
         this.myFeaturedBkg.width = 227;
         this.myFeaturedBkg.height = 841;
         this.myFeaturedBkg.myContainer.gotoAndStop(6);
         this.myBackButton.label = LocalizeUtil.localize(Dict.BACK_WITH_ESCAPE);
         this.myTestCard.visible = false;
         this.myTitleTF.font = GlobalGuide.FONT_FACE_BOLD;
         this.myTitleTF.fontSize = 60;
         this.myTitleTF.width = 800;
         this.myTitleTF.height = 60;
         this.myTitleTF.filters = [new GlowFilter(3317998,1,5,5),new DropShadowFilter(5,113,1319472,0.5,15,15)];
         this.myTitleTF.text = ScaleformUtil.isScaleform ? DictMOTD.CHECKIN_REWARDS_TITLE : "登录奖励";
         this.myMessageTF.filters = [new GlowFilter(3317998,1,5,5),new DropShadowFilter(5,113,1319472,0.5,15,15)];
         this.myMessageTF.textStyle = SupplyDropGuide.styleSupplyDropHeader;
         this.myCurrentReward.mouseEnabled = false;
         this.myCurrentReward.mouseChildren = false;
         this.myCurrentReward.buttonMode = false;
      }
      
      public function set title(txt:String) : void
      {
         this.myMessageTF.text = txt;
      }
      
      override public function active() : void
      {
         super.active();
      }
      
      override public function deactive() : void
      {
         super.deactive();
         while(this.myRewardContainer.numChildren > 0)
         {
            this.myRewardContainer.removeChildAt(0);
         }
         this.mRewardItems.length = 0;
         this.myDurationDisplay.dispose();
         if(null != this.mTimelineAnim)
         {
            this.mTimelineAnim.kill();
         }
         this.resetForAnimation();
      }
      
      public function showNextItemIcon() : void
      {
         var nextItem:MarketplaceItem = null;
         var nextIcon:Sprite = null;
         if(this.mEarnedIndex + 1 >= this.mRewardItems.length)
         {
            return;
         }
         nextItem = this.mRewardItems[this.mEarnedIndex + 1];
         var nextIconCls:Class = getDefinitionByName("codo.shared.market.MarketcardNextAwardIcon") as Class;
         nextIcon = new nextIconCls() as Sprite;
         nextIcon.x = nextItem.width - (nextIcon.width * 0.5 - 5);
         nextIcon.y = nextIcon.height * 0.5 - 2;
         nextItem.addChild(nextIcon);
      }
      
      public function setData(itemIds:Vector.<MOTDCheckinRewardObj>) : Boolean
      {
         var itemData:MOTDCheckinRewardObj = null;
         var item:MarketplaceItem = null;
         var cardData:ProductObj = null;
         var txt:TextField = null;
         var COLS:int = 6;
         var PADDING:int = 10;
         var lastClaimedIndex:int = CFunctionContainer.GetCheckinRewardLastClaimed();
         this.mEarnedIndex = -1;
         var len:int = int(itemIds.length);
         var itemCardClass:Class = getDefinitionByName(MarketFactory.MARKETPLACE_ITEM_LINKAGE) as Class;
         var column:int = 0;
         var row:int = 0;
         var allEarned:Boolean = true;
         this.mReceivedDaily = false;
         this.mRewardItems = new Vector.<MarketplaceItem>(0);
         this.myCurrentReward.visible = false;
         this.mTimelineAnim = new TimelineMax();
         this.resetForAnimation();
         TweenLite.to(this.myTitleTF,FADE_DURATION,{
            "alpha":1,
            "x":705
         });
         TweenLite.to(this.myMessageTF,FADE_DURATION,{
            "alpha":1,
            "x":708,
            "delay":0.15
         });
         TweenLite.to(this.myFX,FADE_DURATION,{"alpha":1});
         TweenLite.to(this.myBkg,FADE_DURATION,{"alpha":1});
         this.mTimelineAnim.append(new TweenLite(this.myRewardContainer,FADE_DURATION,{
            "alpha":1,
            "x":this.mContainerX
         }));
         this.mTimelineAnim.append(new TweenLite(this.myDurationDisplay,FADE_DURATION,{"alpha":1}));
         for(var i:int = 0; i < len; i++)
         {
            itemData = itemIds[i];
            column = i % COLS;
            row = int(i / COLS);
            item = new itemCardClass() as MarketplaceItem;
            item.setCardStyle(MarketItemUtil.ITEM_CARD_TINY_FRAME,false,false);
            item.withDiscountTag = false;
            item.x = (item.width + PADDING) * column;
            if(itemData.featured)
            {
               item.x += 40;
            }
            item.y = (item.height + PADDING) * row;
            cardData = ProductObj.makeItemOrGp(itemData.itemID,itemData.gp);
            item.setData(cardData);
            item.myMarketplaceItemCard.myFill.visible = false;
            StringUtil.fitTextField(item.myMarketplaceItemCard.myItemNameTF);
            if(!cardData.isGP)
            {
               item.myMarketplaceItemCard.myTimeRemainingTF.visible = true;
               item.myMarketplaceItemCard.myItemRentalStatus.visible = false;
               item.myMarketplaceItemCard.myTimeRemainingTF.htmlText = itemData.getDurationText(cardData);
            }
            this.setItemEarned(item,itemData,i <= lastClaimedIndex);
            if(itemData.isEarned)
            {
               this.mEarnedIndex = i;
            }
            else
            {
               txt = GlobalFactory.BUILD_TEXTFIELD();
               item.myMarketplaceItemCard.addChild(txt);
               txt.alignment = TextStyle.HALIGN_CENTER;
               txt.font = GlobalGuide.FONT_FACE_NUMBERS;
               txt.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
               txt.text = String(i + 1);
               txt.x = 123;
               txt.y = 0;
            }
            allEarned &&= itemData.isEarned;
            item.audioRef.overrideClickAudio(SE_ID.MUTE);
            this.myRewardContainer.addChild(item);
            this.mRewardItems[i] = item;
         }
         if(null != this.mTimelineAnim)
         {
            this.mTimelineAnim.play();
         }
         if(lastClaimedIndex != this.mEarnedIndex)
         {
            CFunctionContainer.SetCheckinRewardLastClaimed(this.mEarnedIndex);
            if(this.mEarnedIndex > -1)
            {
               this.mReceivedDaily = true;
            }
         }
         this.myDurationDisplay.modeShowMonthCountdown = allEarned;
         this.myDurationDisplay.init();
         return allEarned;
      }
      
      private function resetForAnimation() : void
      {
         this.myTitleTF.alpha = 0;
         this.myTitleTF.x = 300;
         this.myMessageTF.alpha = 0;
         this.myMessageTF.x = 494;
         this.myFX.alpha = 0;
         this.myBkg.alpha = 0;
         this.myDurationDisplay.alpha = 0;
         this.myRewardContainer.alpha = 0;
         this.myRewardContainer.x = this.myBkg.x - 100;
      }
      
      private function setItemEarned(item:MarketplaceItem, itemData:MOTDCheckinRewardObj, claimed:Boolean) : void
      {
         item.myMarketplaceItemCard.myEquippedCheckMark.visible = true;
         this.setCheckMark(item,itemData,itemData.isEarned && claimed);
         if(itemData.isEarned)
         {
            if(claimed)
            {
               this.setItemClaimed(item,itemData,false);
            }
            else
            {
               this.mTimelineAnim.append(new TweenLite(item,0.5,{
                  "alpha":1,
                  "ease":Cubic.easeIn,
                  "onComplete":this.setItemClaimed,
                  "onCompleteParams":[item,itemData]
               }));
            }
         }
      }
      
      private function setItemClaimed(item:MarketplaceItem, itemData:MOTDCheckinRewardObj, isClaimAnim:Boolean = true) : void
      {
         this.myCurrentReward.visible = true;
         this.myCurrentReward.myAnimation.gotoAndStop(1);
         this.myCurrentReward.myStatic.gotoAndStop(1);
         this.myCurrentReward.x = this.mContainerX + item.x - 167;
         this.myCurrentReward.y = this.myRewardContainer.y + item.y - 56;
         if(isClaimAnim)
         {
            playSound("ui_results_complete");
            this.setCheckMark(item,itemData,true);
         }
      }
      
      private function setCheckMark(item:MarketplaceItem, itemData:MOTDCheckinRewardObj, claimed:Boolean) : void
      {
         var featuredFrame:int = 0;
         var regularFrame:int = 0;
         if(claimed)
         {
            featuredFrame = 5;
            regularFrame = 2;
         }
         else
         {
            featuredFrame = 4;
            regularFrame = 3;
         }
         item.myMarketplaceItemCard.myEquippedCheckMark.gotoAndStop(itemData.featured ? featuredFrame : regularFrame);
      }
   }
}

