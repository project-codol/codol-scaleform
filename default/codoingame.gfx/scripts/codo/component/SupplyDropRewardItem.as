package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.objects.SupplyDropRewardItemObj;
   import codo.utils.SoundUtil;
   import codo.views.supplyDrop_parts.SupplyDropRewardItemCover;
   import com.greensock.TweenLite;
   
   public class SupplyDropRewardItem extends UIInteractiveComponent
   {
      
      private static const ANIMATE_DUR_SCALE:Number = 0.5;
      
      private static const FADE_DURATION:Number = 0.2 * ANIMATE_DUR_SCALE;
      
      public var myCover:SupplyDropRewardItemCover;
      
      public var myDependencyButton:SupplyDropRewardItemErrorButton;
      
      private var mOpen:Boolean = false;
      
      private var mItemDependency:int;
      
      private var mIsDuplicateItem:Boolean;
      
      private var mAfterOpenedCallback:Function;
      
      private var mOpenedTimes:uint;
      
      private var mShouldShowOff:Boolean;
      
      public function SupplyDropRewardItem()
      {
         super();
         this.myDependencyButton.visible = false;
         this.myDependencyButton.alpha = 0;
         this.mOpenedTimes = 0;
         isInteractiveEnabled = true;
         registerFocusEvent(this.myCover.onMouseOver);
         registerUnfocusEvent(this.myCover.onMouseOut);
         this.myCover.afterOpenedCallback = this.onAfterOpened;
         this.mShouldShowOff = false;
      }
      
      public function set afterOpenedCallback(callback:Function) : void
      {
         this.mAfterOpenedCallback = callback;
      }
      
      private function onAfterOpened() : void
      {
         ++this.mOpenedTimes;
         if(this.mAfterOpenedCallback != null)
         {
            this.mAfterOpenedCallback(this,this.mOpenedTimes);
         }
      }
      
      public function get shouldShowOff() : Boolean
      {
         return this.mShouldShowOff;
      }
      
      override public function setData(data:*) : void
      {
         var prodObj:ProductObj = null;
         var rewardItemObj:SupplyDropRewardItemObj = null;
         var itemDependencies:Array = null;
         var dependencyData:ProductObj = null;
         var isDependencyOwned:Boolean = false;
         var i:uint = 0;
         super.setData(data);
         TweenLite.killTweensOf(this);
         TweenLite.killTweensOf(this.myCover);
         this.mOpenedTimes = 0;
         var isFeatured:Boolean = false;
         var supplyDropTypeID:int = MarketMenuData.SUPPLY_DROP_BASIC;
         this.mShouldShowOff = false;
         if(data is SupplyDropRewardItemObj)
         {
            rewardItemObj = data as SupplyDropRewardItemObj;
            isFeatured = rewardItemObj.isFeatured;
            prodObj = rewardItemObj.product;
            this.mShouldShowOff = rewardItemObj.shouldShowOff;
         }
         else
         {
            prodObj = data as ProductObj;
         }
         this.mOpen = false;
         this.mIsDuplicateItem = false;
         if(rewardItemObj != null)
         {
            itemDependencies = rewardItemObj.itemDependencies;
            supplyDropTypeID = rewardItemObj.supplyDropID;
            if(itemDependencies != null && itemDependencies.length > 0 && itemDependencies.length <= 5)
            {
               isDependencyOwned = true;
               for(i = 0; i < itemDependencies.length; i++)
               {
                  this.mItemDependency = itemDependencies[i];
                  dependencyData = CFunctionCommonContainer.GetItemInfo(this.mItemDependency);
                  isDependencyOwned = dependencyData.isOwned();
                  if(isDependencyOwned)
                  {
                     break;
                  }
               }
               this.myDependencyButton.visible = true;
               this.myDependencyButton.resetCallback();
               this.myDependencyButton.registerClickEvent(this.onDependencyClicked);
               this.myDependencyButton.dependencyItemImage = dependencyData.imageURL;
               if(!isDependencyOwned)
               {
                  this.myDependencyButton.inError = true;
                  EventManager.getInstance().listen(BCEvent.EVT_MARKET_PURCHASE_TASK_SUCCESS,this.onPurchaseSuccess);
               }
               else
               {
                  this.myDependencyButton.inError = false;
               }
               this.myCover.setItemInDependencyMode(isDependencyOwned);
            }
            if(rewardItemObj != null && rewardItemObj.isReplacedItem)
            {
               this.myCover.setDuplicatedMode(rewardItemObj.crushedCurrencyID,rewardItemObj.alternativeAmount,rewardItemObj.isPartialCrushed);
               this.mIsDuplicateItem = true;
            }
         }
         this.myCover.setRewardItemData(prodObj,isFeatured);
         this.myCover.supplyDropType = supplyDropTypeID;
      }
      
      public function get isOpen() : Boolean
      {
         return this.mOpen;
      }
      
      public function open() : void
      {
         enabled = false;
         this.mOpen = true;
         this.myCover.openReward();
         if(this.myDependencyButton.visible)
         {
            this.myDependencyButton.y = this.myCover.myCoverTop.animationTargetY + 44;
            TweenLite.to(this.myDependencyButton,FADE_DURATION,{
               "alpha":1,
               "delay":1.3 * ANIMATE_DUR_SCALE
            });
         }
         if(this.mIsDuplicateItem)
         {
            SoundUtil.getInstance().playSound("UI_Duplicate_Bought");
         }
         else
         {
            SoundUtil.getInstance().playSound("ui_supplydrop_reward_click_01");
         }
      }
      
      public function initDuplicateAnim() : void
      {
         this.myCover.myRewardItemCard.initDuplicateAnim();
      }
      
      private function onDependencyClicked() : void
      {
         var dependencyData:ProductObj = CFunctionCommonContainer.GetItemInfo(this.mItemDependency);
         if(dependencyData.isOwned())
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{
               "itemData":dependencyData,
               "bDisablePurchase":true
            });
         }
         else
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP_DEPENDENCY_POPUP,{
               "rewardItem":SupplyDropRewardItemObj(mData).product,
               "dependency":dependencyData
            });
         }
      }
      
      private function onPurchaseSuccess(evt:ParaEvent) : void
      {
         var purchasedItem:int = evt.myPara as int;
         var itemIDs:Array = CFunctionContainer.AS_GetItemIDsFromProduct(purchasedItem);
         if(itemIDs.indexOf(this.mItemDependency) >= 0)
         {
            this.myDependencyButton.inError = false;
            this.myCover.myRewardItemCard.myDependencyMultiply.visible = false;
         }
      }
      
      public function clear() : void
      {
         EventManager.getInstance().unlisten(BCEvent.EVT_MARKET_PURCHASE_TASK_SUCCESS,this.onPurchaseSuccess);
      }
   }
}

