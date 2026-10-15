package codo.views.zhuntMatchResult_parts
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.objects.ProductObj;
   import codo.objects.RewardObjComplete;
   import codo.style.MarketGuide;
   import codo.utils.MarketItemUtil;
   import codo.views.zhuntMatchResult_parts.ZHuntMatchResultItem_parts.ZHuntMatchRewardItemCover;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class ZHuntMatchRewardItem extends UIInteractiveComponent
   {
      
      private const COVER_REOPEN_START_FRAME:int = 8;
      
      public var myCover:ZHuntMatchRewardItemCover;
      
      public var myShowOffEffect:MovieClip;
      
      public var myItemCard:MarketplaceItemCard;
      
      public var myShadow:MovieClip;
      
      public var myLightLine:MovieClip;
      
      private var mShouldShowOff:Boolean = false;
      
      public function ZHuntMatchRewardItem()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         var rewardObjComplete:RewardObjComplete = null;
         super.setData(data);
         this.myCover.gotoAndStop(1);
         this.myCover.icon = data.icon;
         rewardObjComplete = new RewardObjComplete(data.rewardType,data.rewardEntity,data.rewardParam);
         this.myItemCard.setCardStyle(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false);
         this.myItemCard.withOwnStateHint = false;
         this.myItemCard.setData(rewardObjComplete.getWrappedObj());
         this.myItemCard.visible = false;
         var productObj:ProductObj = rewardObjComplete.getProductObj();
         var tier:int = 0;
         if(productObj != null)
         {
            tier = productObj.tier;
         }
         var colorTransform:ColorTransform = new ColorTransform();
         colorTransform.color = MarketGuide.COLOR_BY_TIER[tier];
         this.myShowOffEffect.transform.colorTransform = colorTransform;
         this.myShowOffEffect.gotoAndStop(1);
         this.myShadow.transform.colorTransform = colorTransform;
         this.myShadow.gotoAndStop(1);
         this.myLightLine.transform.colorTransform = colorTransform;
         this.myLightLine.gotoAndStop(1);
         this.myLightLine.filters = [new GlowFilter(MarketGuide.COLOR_BY_TIER[tier],20,20,5)];
         this.myCover.width = this.myItemCard.width;
         this.myCover.height = this.myItemCard.height;
      }
      
      public function set shouldShowOff(val:Boolean) : void
      {
         this.mShouldShowOff = val;
      }
      
      public function get shouldShowOff() : Boolean
      {
         return this.mShouldShowOff;
      }
      
      public function open() : void
      {
         var gp:int = 0;
         this.myItemCard.visible = true;
         this.myCover.gotoAndPlay(1);
         this.myShadow.gotoAndPlay(1);
         this.myLightLine.gotoAndPlay(1);
         TweenLite.killTweensOf(this.myShowOffEffect);
         if(this.mShouldShowOff)
         {
            TweenLite.to(this.myShowOffEffect,0.83,{"onComplete":this.onPlayShowOffEffect});
         }
         gp = int(getData().convertedGP);
         if(gp > 0)
         {
            TweenLite.killTweensOf(this.myCover);
            TweenLite.to(this.myCover,0.35,{
               "delay":1.2,
               "frame":this.COVER_REOPEN_START_FRAME,
               "onStart":function():void
               {
                  myCover.icon = "";
               },
               "onComplete":function():void
               {
                  myItemCard.setData(ProductObj.makeGpObj(new ProductObj(),gp));
                  myCover.gotoAndPlay(COVER_REOPEN_START_FRAME);
               }
            });
         }
      }
      
      private function onPlayShowOffEffect() : void
      {
         this.myShowOffEffect.gotoAndPlay(1);
      }
   }
}

