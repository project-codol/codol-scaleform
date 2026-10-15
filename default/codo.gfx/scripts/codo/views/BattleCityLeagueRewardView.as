package codo.views
{
   import codo.base.PopupView;
   import codo.component.ScrollGrid;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.DictBattleCity;
   import codo.localization.DictSystem;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.BattleCityLeaguePlayerObj;
   import codo.objects.ProductObj;
   import codo.objects.RewardObjComplete;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.views.battlecity_parts.BattleCityLeagueRewardCard;
   import codo.views.battlecity_parts.BattleCityRewardProgress;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class BattleCityLeagueRewardView extends PopupView
   {
      
      private static const ITEM_CARD_LINKAGE:String = "codo.battlecity.leaguerewarditemcard";
      
      private static const FULL_SIZE_WIDTH:int = 1243;
      
      private static const HALF_SIZE_HEIGHT:int = 611;
      
      private static const FULL_SIZE_HEIGHT:int = 865;
      
      public var myTitleChestPool:TextField;
      
      public var myTitleSubPool:TextField;
      
      public var myChestPoolScrollGrid:ScrollGrid;
      
      public var mySubPoolScrollGrid:ScrollGrid;
      
      public var myProgress:BattleCityRewardProgress;
      
      public var myDivider:MovieClip;
      
      public function BattleCityLeagueRewardView()
      {
         super();
         this.initStage();
      }
      
      public function initStage() : void
      {
         headerTitle = DictBattleCity.BATTLECITY_LEAGUE_REWARD_TITLE;
         myPopup.width = FULL_SIZE_WIDTH;
         myPopup.height = FULL_SIZE_HEIGHT;
         myPopup.configCancelButton(DictSystem.CONFIRM,this.onConfirmButtonClick);
         this.myTitleChestPool.text = DictBattleCity.BATTLECITY_CHEST_REWARD_TITLE;
         this.myTitleSubPool.text = DictBattleCity.BATTLECITY_SUB_REWARD_TITLE;
         var chestGridSettings:ScrollGridSettings = new ScrollGridSettings();
         chestGridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         chestGridSettings.useNavArrows = false;
         chestGridSettings.buildGridItemRenderMethod = this.buildMarketplaceItem;
         this.myChestPoolScrollGrid.initGrid(chestGridSettings,2,false,5);
         this.myChestPoolScrollGrid.listItemFocusCallback = this.onListItemFocused;
         this.myChestPoolScrollGrid.listItemUnfocusCallback = this.onListItemUnfocused;
         var subGridSettings:ScrollGridSettings = new ScrollGridSettings();
         subGridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         subGridSettings.useNavArrows = false;
         subGridSettings.buildGridItemRenderMethod = this.buildMarketplaceItem;
         this.mySubPoolScrollGrid.initGrid(subGridSettings,1,false,5);
         this.mySubPoolScrollGrid.listItemFocusCallback = this.onListItemFocused;
         this.mySubPoolScrollGrid.listItemUnfocusCallback = this.onListItemUnfocused;
      }
      
      override protected function enableData() : void
      {
         var leagueGlobal:BattleCityLeagueGlobalObj = getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         var playerObj:BattleCityLeaguePlayerObj = getDP(DataID.BATTLE_CITY_LEAGUE_PLAYER_OBJ);
         this.setRewardData(leagueGlobal.chestRewards,leagueGlobal.subRewards,playerObj.champRewardStatus);
         this.checkRewardStage(leagueGlobal.chestRewards,playerObj.champRewardStatus);
         this.myProgress.setProgress(playerObj.rewardCurrentProgress,playerObj.rewardFullProgress);
      }
      
      private function FillRewardState(rewards:Array, status:Array) : void
      {
         var numRewards:int = int(rewards.length);
         for(var i:int = 0; i < numRewards; i++)
         {
            rewards[i].owned = status[i];
         }
      }
      
      private function setRewardData(chestReward:Array, subReward:Array, status:Array) : void
      {
         var reward:Object = null;
         var rewards:Vector.<Object> = new Vector.<Object>();
         var i:int = 0;
         for(i = 0; i < chestReward.length; i++)
         {
            reward = (chestReward[i] as RewardObjComplete).getWrappedObj();
            reward.owned = status[i];
            rewards.push(reward);
         }
         this.myChestPoolScrollGrid.addItemsByVector(rewards);
         rewards.splice(0,rewards.length);
         for(i = 0; i < subReward.length; i++)
         {
            rewards.push((subReward[i] as RewardObjComplete).getWrappedObj());
         }
         this.mySubPoolScrollGrid.addItemsByVector(rewards);
      }
      
      private function checkRewardStage(chestReward:Array, status:Array) : void
      {
         var allChestClaimed:Boolean = true;
         for(var i:int = 0; i < chestReward.length; i++)
         {
            if(status[i] == false)
            {
               allChestClaimed = false;
               break;
            }
         }
         this.myDivider.visible = allChestClaimed;
         this.mySubPoolScrollGrid.visible = allChestClaimed;
         this.myTitleSubPool.visible = allChestClaimed;
         myPopup.height = allChestClaimed ? FULL_SIZE_HEIGHT : HALF_SIZE_HEIGHT;
         this.myTitleChestPool.textColor = allChestClaimed ? GlobalGuide.GRAY_50 : GlobalGuide.WHITE;
      }
      
      private function buildMarketplaceItem() : BattleCityLeagueRewardCard
      {
         var linkageClass:Class = getDefinitionByName(ITEM_CARD_LINKAGE) as Class;
         var itemCard:BattleCityLeagueRewardCard = new linkageClass() as BattleCityLeagueRewardCard;
         itemCard.isInteractiveEnabled = true;
         return itemCard;
      }
      
      protected function onListItemFocused(item:Object) : void
      {
         var product:ProductObj = item as ProductObj;
         if(Boolean(product))
         {
            broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
               "product":product,
               "compare":false
            });
         }
      }
      
      protected function onListItemUnfocused(item:Object) : void
      {
         broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      private function onConfirmButtonClick() : void
      {
         closePopupView();
      }
   }
}

