package components.fsgmatchresult_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.localization.Dict;
   import codo.localization.DictChallenge;
   import codo.localization.DictRoom;
   import codo.objects.ChallengeRewardObj;
   import codo.objects.DailyChallengeRewardObj;
   import codo.objects.LevelRewardObj;
   import codo.objects.ProductObj;
   import codo.objects.TDRewardObj;
   import codo.objects.ZHuntKillZombieRewardObj;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class FsgMatchResultProgressReward extends UIInteractiveComponent
   {
      
      private static const HEADER_FRAME_LIGHT_BLUE:int = 1;
      
      private static const HEADER_FRAME_DEEP_BLUE:int = 2;
      
      public var myHeader:MovieClip;
      
      public var myType:TextField;
      
      public var myTag:TextField;
      
      public var myBG:MovieClip;
      
      public function FsgMatchResultProgressReward()
      {
         super();
         this.myBG.visible = false;
      }
      
      override public function setData(data:*) : void
      {
         var reward:ChallengeRewardObj = null;
         var dailyReward:DailyChallengeRewardObj = null;
         var levelReward:LevelRewardObj = null;
         var zhuntKillZombieReward:ZHuntKillZombieRewardObj = null;
         var difficulty:int = 0;
         var tdRewardObj:TDRewardObj = null;
         var lvlText:String = null;
         var productId:int = 0;
         var itemIDs:Array = null;
         var itemID:int = 0;
         var item:UIInteractiveComponent = null;
         var itemCard:MarketplaceItemCard = null;
         var myRewardGPDisplay:Sprite = null;
         var myRewardGPTF:TextField = null;
         super.setData(data);
         var product:ProductObj = null;
         var useSmallCard:Boolean = true;
         if(data is ChallengeRewardObj)
         {
            reward = data as ChallengeRewardObj;
            if(reward is DailyChallengeRewardObj)
            {
               dailyReward = data as DailyChallengeRewardObj;
               this.myHeader.visible = true;
               this.myHeader.gotoAndStop(HEADER_FRAME_LIGHT_BLUE);
               this.myType.visible = true;
               this.myTag.visible = true;
               this.myType.text = LocalizeUtil.localize(Dict.DAILY_CHALLENGES);
               this.myTag.text = dailyReward.score + LocalizeUtil.localize(DictChallenge.DAILY_CHALLENGE_POINT);
            }
            else if(reward is LevelRewardObj)
            {
               levelReward = data as LevelRewardObj;
               this.myHeader.visible = true;
               this.myType.visible = true;
               this.myTag.visible = false;
               if(levelReward.category == LevelRewardObj.CATEGORY_REWARD)
               {
                  this.myType.text = LocalizeUtil.localize(Dict.CAREER_REWARD);
                  this.myHeader.gotoAndStop(HEADER_FRAME_LIGHT_BLUE);
               }
               else
               {
                  this.myType.text = LocalizeUtil.localize(Dict.CAREER_UNLOCK);
                  this.myHeader.gotoAndStop(HEADER_FRAME_DEEP_BLUE);
               }
            }
            else if(reward is ZHuntKillZombieRewardObj)
            {
               zhuntKillZombieReward = data as ZHuntKillZombieRewardObj;
               difficulty = CFunctionCommonContainer.Dvar_GetInt("ui_playlist_difficulty");
               this.myHeader.visible = true;
               this.myType.visible = true;
               this.myTag.visible = false;
               this.myHeader.gotoAndStop(HEADER_FRAME_LIGHT_BLUE);
               this.myType.text = LocalizeUtil.localize("@" + zhuntKillZombieReward.nameString) + "[" + LocalizeUtil.localize(DictRoom.ROOM_LEVELS[difficulty]) + "]";
               if(difficulty < 2)
               {
                  this.myType.text = LocalizeUtil.localize("@" + zhuntKillZombieReward.nameString);
               }
            }
            else if(reward is TDRewardObj)
            {
               tdRewardObj = data as TDRewardObj;
               this.myHeader.visible = true;
               this.myType.visible = true;
               this.myTag.visible = false;
               this.myHeader.gotoAndStop(HEADER_FRAME_LIGHT_BLUE);
               this.myType.text = tdRewardObj.rewardName;
            }
            else
            {
               this.myHeader.visible = true;
               this.myType.visible = true;
               this.myTag.visible = false;
               this.myType.text = LocalizeUtil.localize(DictChallenge.WEEKLY_CHALLENGES);
               this.myHeader.gotoAndStop(HEADER_FRAME_LIGHT_BLUE);
            }
            if(reward.type == ChallengeRewardObj.REWARD_TYPE_GP)
            {
               product = new ProductObj();
               product.levelRewardGP = reward.entityInfo;
               product.SKUs = null;
               lvlText = String(product.levelRewardGP) + " " + LocalizeUtil.localize(Dict.MATCH_RESULT_GP);
               product.name = lvlText;
               useSmallCard = false;
            }
            else if(reward.type == ChallengeRewardObj.REWARD_TYPE_PRODUCT)
            {
               product = ItemUtil.getProductObjByProductId(reward.entityId);
               product.remainSecond = reward.entityDuration * 86400;
               product.isBought = true;
            }
            else if(reward.type == ChallengeRewardObj.REWARD_TYPE_ITEM)
            {
               product = CFunctionCommonContainer.GetItemInfo(reward.entityId);
               if(reward.entityDuration > 0)
               {
                  product.remainSecond = reward.entityDuration * 86400;
                  product.isBought = true;
               }
            }
            else if(reward.type == ChallengeRewardObj.REWARD_TYPE_SKU)
            {
               productId = CFunctionContainer.AS_GetProductIDFromSKU(reward.entityId);
               if(Boolean(CFunctionContainer.IsBundleProduct(productId)))
               {
                  product = CFunctionCommonContainer.GetBundleInfo(productId) as ProductObj;
               }
               else
               {
                  itemIDs = CFunctionContainer.AS_GetItemIDsFromProduct(productId);
                  if(itemIDs != null && itemIDs.length > 0)
                  {
                     itemID = int(itemIDs[0]);
                     product = CFunctionCommonContainer.GetItemInfo(itemID);
                  }
               }
               if(product != null)
               {
                  product.remainSecond = CFunctionContainer.AS_GetDurationFromSKU(reward.entityId) * 86400;
                  product.isBought = true;
               }
            }
         }
         if(product != null)
         {
            item = null;
            if(!useSmallCard)
            {
               item = MarketFactory.BUILD_REWARD_ITEM_SMALL_CARD();
               itemCard = item.getChildByName("myMarketplaceItemCard") as MarketplaceItemCard;
               myRewardGPDisplay = itemCard.getChildByName("myRewardGPDisplay") as Sprite;
               myRewardGPDisplay.visible = product.levelRewardGP > 0;
               if(myRewardGPDisplay.visible)
               {
                  myRewardGPTF = myRewardGPDisplay.getChildByName("myRewardGPTF") as TextField;
                  itemCard.myItemImageHolder.visible = itemCard.myItemIconHolder.visible = false;
                  myRewardGPTF.text = product.levelRewardGP.toString();
               }
            }
            else
            {
               item = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD();
               (item as MarketplaceItem).withDiscountTag = false;
            }
            product.SKUs = null;
            product.equippable = false;
            item.setData(product);
            item.x = 0;
            item.y = this.myHeader.y + this.myHeader.height;
            this.addChildAt(item,0);
         }
      }
      
      override public function get width() : Number
      {
         return this.myBG.width;
      }
      
      override public function get height() : Number
      {
         return this.myBG.height;
      }
   }
}

