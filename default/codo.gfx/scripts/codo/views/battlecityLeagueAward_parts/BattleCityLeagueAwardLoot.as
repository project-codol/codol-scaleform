package codo.views.battlecityLeagueAward_parts
{
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.localization.DictBattleCity;
   import codo.manager.DataManager;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.BattleCityLeagueMatchResultObj;
   import codo.utils.SoundUtil;
   import codo.views.battlecity_parts.BattleCityLeagueRewardCard;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class BattleCityLeagueAwardLoot extends MovieClip
   {
      
      private static const ITEM_CARD_LINKAGE:String = "codo.battlecity.leaguerewarditemcard";
      
      private static const REWARDS_PER_ROW:int = 6;
      
      private static const REWARDS_X_GAP:int = 5;
      
      private static const REWARDS_Y_GAP:int = 5;
      
      private static const REWARD_CARD_WIDTH:int = 222;
      
      private static const REWARD_CARD_HEIGHT:int = 160;
      
      private static const BASE_LOOT_COUNT:int = 35;
      
      private static const INIT_DURATION_TIME:Number = 0.05;
      
      private static const DURATION_OFFSET_TIME:Number = 0.005;
      
      private static const LAST_ONE_REWARD_TWEEN_DURATION:Number = 2;
      
      private static const TWEEN_DISAPPEAR_ANIMATION:Number = 1.5;
      
      private var mRewardPool:Array;
      
      private var mRewardIndex:int;
      
      private var mCompleteHandler:Function;
      
      private var mRenderPools:Array;
      
      private var mLootablePools:Array;
      
      private var mLootOrders:Array;
      
      private var mLootDuration:Array;
      
      private var mRewardStartX:Number = 0;
      
      private var mRewardStartY:Number = 0;
      
      private var mTotalDuration:Number = 0;
      
      private var mTween:TweenLite;
      
      private var mCurrentHighlightIndex:int = -1;
      
      public var mySelectedFrame:MovieClip;
      
      public var myTitle:TextField;
      
      public function BattleCityLeagueAwardLoot()
      {
         super();
         this.mySelectedFrame.visible = false;
         this.myTitle.text = DictBattleCity.LOOT_DESCRIPTION;
      }
      
      public function setData(data:BattleCityLeagueMatchResultObj, completeHandler:Function = null) : void
      {
         var targetPool:Array = null;
         var dmzlGlobalObj:BattleCityLeagueGlobalObj = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         var rewardStatus:Array = data.beforeMatchRewardStatus;
         this.mRewardPool = [];
         this.mLootablePools = [];
         var i:int = 0;
         if(data.rewardPoolType == BattleCityLeagueMatchResultObj.REWARD_TYPE_MAIN)
         {
            targetPool = dmzlGlobalObj.chestRewards;
            for(i = 0; i < targetPool.length; i++)
            {
               this.mRewardPool.push(targetPool[i].getWrappedObj());
               this.mRewardPool[i].owned = rewardStatus[i];
               if(!rewardStatus[i])
               {
                  this.mLootablePools.push(i);
               }
            }
         }
         else if(data.rewardPoolType == BattleCityLeagueMatchResultObj.REWARD_TYPE_SUB)
         {
            targetPool = dmzlGlobalObj.subRewards;
            for(i = 0; i < targetPool.length; i++)
            {
               this.mRewardPool.push(targetPool[i].getWrappedObj());
               this.mLootablePools.push(i);
            }
         }
         this.mRewardIndex = data.rewardIndex;
         this.mCompleteHandler = completeHandler;
      }
      
      public function playAnimation() : void
      {
         this.arrangeLayout();
         this.arrangeLootOrder();
         this.startLoot();
      }
      
      public function getFinalStationaryPoint() : Point
      {
         return localToGlobal(new Point(this.mySelectedFrame.x,this.mySelectedFrame.y));
      }
      
      private function calculateStartPosition() : void
      {
         var totalRow:int = 0;
         var totalColumn:int = 0;
         var totalWidth:Number = 0;
         var totalHeight:Number = 0;
         var numRewards:int = int(this.mRewardPool.length);
         if(numRewards <= REWARDS_PER_ROW)
         {
            totalWidth = REWARD_CARD_WIDTH * numRewards + REWARDS_X_GAP * (numRewards - 1);
            totalHeight = REWARD_CARD_HEIGHT;
         }
         else
         {
            totalColumn = REWARDS_PER_ROW;
            totalRow = Math.ceil(numRewards / REWARDS_PER_ROW);
            totalWidth = totalColumn * REWARD_CARD_WIDTH + (totalColumn - 1) * REWARDS_X_GAP;
            totalHeight = totalRow * REWARD_CARD_HEIGHT + (totalRow - 1) * REWARDS_Y_GAP;
         }
         this.mRewardStartX = (GameInfo.DEFAULT_WIDTH - totalWidth) / 2;
         this.mRewardStartY = (GameInfo.DEFAULT_HEIGHT - totalHeight) / 2;
      }
      
      private function arrangeLayout() : void
      {
         var item:BattleCityLeagueRewardCard = null;
         this.calculateStartPosition();
         this.myTitle.x = this.mRewardStartX;
         this.myTitle.y = this.mRewardStartY - this.myTitle.textHeight - 10;
         this.mRenderPools = new Array();
         for(var i:int = 0; i < this.mRewardPool.length; i++)
         {
            item = this.buildMarketplaceItem();
            addChild(item);
            item.setData(this.mRewardPool[i]);
            this.mRenderPools.push(item);
            item.x = this.mRewardStartX + i % REWARDS_PER_ROW * (item.width + REWARDS_X_GAP);
            item.y = this.mRewardStartY + Math.floor(i / REWARDS_PER_ROW) * (item.height + REWARDS_Y_GAP);
         }
      }
      
      private function buildMarketplaceItem() : BattleCityLeagueRewardCard
      {
         var linkageClass:Class = getDefinitionByName(ITEM_CARD_LINKAGE) as Class;
         return new linkageClass() as BattleCityLeagueRewardCard;
      }
      
      private function arrangeLootOrder() : void
      {
         var oneDuration:Number = NaN;
         var numLootableItems:int = int(this.mLootablePools.length);
         var curLootableIndex:int = 0;
         this.mLootOrders = new Array();
         this.mLootDuration = new Array();
         var i:int = 0;
         for(i = 0; i < BASE_LOOT_COUNT; i++)
         {
            curLootableIndex = i % numLootableItems;
            this.mLootOrders.push(this.mLootablePools[curLootableIndex]);
         }
         if(-1 == this.mLootablePools.indexOf(this.mRewardIndex))
         {
            return;
         }
         while(this.mLootablePools[curLootableIndex] != this.mRewardIndex)
         {
            curLootableIndex = (curLootableIndex + 1) % numLootableItems;
            this.mLootOrders.push(this.mLootablePools[curLootableIndex]);
         }
         this.mTotalDuration = 0;
         for(i = 0; i < this.mLootOrders.length; i++)
         {
            oneDuration = INIT_DURATION_TIME + i * DURATION_OFFSET_TIME;
            this.mTotalDuration += oneDuration;
            this.mLootDuration.push(this.mTotalDuration);
         }
      }
      
      private function startLoot() : void
      {
         swapChildren(this.mySelectedFrame,getChildAt(numChildren - 1));
         if(this.mLootablePools.length <= 1)
         {
            this.highlightItem(this.mRewardIndex);
            this.mTween = TweenLite.to(this,LAST_ONE_REWARD_TWEEN_DURATION,{"onComplete":this.onLootAnimationComplete});
         }
         else
         {
            this.mTween = TweenLite.to(this,this.mTotalDuration,{
               "delay":0.3,
               "onUpdate":this.onLootAnimationUpdate,
               "onComplete":this.onLootAnimationComplete
            });
         }
      }
      
      private function onLootAnimationUpdate() : void
      {
         if(!this.mTween)
         {
            return;
         }
         var highlightIndex:int = 0;
         for(var i:int = this.mLootDuration.length - 1; i >= 0; i--)
         {
            if(this.mTween.currentTime >= this.mLootDuration[i])
            {
               highlightIndex = i;
               break;
            }
         }
         var selectedIndex:int = int(this.mLootOrders[highlightIndex]);
         this.highlightItem(selectedIndex);
      }
      
      private function onLootAnimationComplete() : void
      {
         if(null != this.mCompleteHandler)
         {
            this.mCompleteHandler();
         }
         TweenLite.to(this,TWEEN_DISAPPEAR_ANIMATION,{"alpha":0});
      }
      
      private function highlightItem(index:int) : void
      {
         if(this.mCurrentHighlightIndex != index)
         {
            this.mCurrentHighlightIndex = index;
            SoundUtil.getInstance().playSound("UI_Loot_Tick");
         }
         this.mySelectedFrame.visible = true;
         this.mySelectedFrame.width = REWARD_CARD_WIDTH;
         this.mySelectedFrame.height = REWARD_CARD_HEIGHT;
         this.mySelectedFrame.x = this.mRenderPools[index].x;
         this.mySelectedFrame.y = this.mRenderPools[index].y;
      }
   }
}

