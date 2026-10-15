package codo.views.battlecityLeagueAward_parts
{
   import codo.constants.DataID;
   import codo.localization.DictBattleCity;
   import codo.manager.DataManager;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.BattleCityLeagueMatchResultObj;
   import codo.objects.ProductObj;
   import codo.objects.RewardObjComplete;
   import codo.utils.SoundUtil;
   import codo.views.battlecity_parts.BattleCityLeagueRewardCard;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class BattleCityLeagueAwardPresent extends MovieClip
   {
      
      private static const ITEM_CARD_LINKAGE:String = "codo.battlecity.leaguerewarditemcard";
      
      private static const REWARD_CARD_MIDDLE_WIDTH:int = 355;
      
      private static const REWARD_CARD_MIDDLE_HEIGHT:int = 186;
      
      private static const REWARD_CARD_FINAL_WIDTH:int = 714;
      
      private static const REWARD_CARD_FINAL_HEIGHT:int = 374;
      
      private static const REWARD_CARD_FINAL_X:int = 739;
      
      private static const REWARD_CARD_FINAL_Y:int = 384;
      
      private static const TWEEN_DURATION:int = 1;
      
      private static const TWEEN_DELAY:int = 2;
      
      private static const GLOW_ANIMATION:int = 2;
      
      private var mRewardObj:RewardObjComplete;
      
      private var mItem:BattleCityLeagueRewardCard;
      
      private var mCompleteHandler:Function;
      
      public var myTitle:TextField;
      
      public var myGlow:MovieClip;
      
      public function BattleCityLeagueAwardPresent()
      {
         super();
         this.myTitle.text = DictBattleCity.BATTLECITY_LEAGUE_REWARD_INFO;
      }
      
      public function setData(data:BattleCityLeagueMatchResultObj, completeHandler:Function = null) : void
      {
         var targetPool:Array = null;
         var dmzlGlobalObj:BattleCityLeagueGlobalObj = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         if(data.rewardPoolType == BattleCityLeagueMatchResultObj.REWARD_TYPE_MAIN)
         {
            targetPool = dmzlGlobalObj.chestRewards;
         }
         else
         {
            targetPool = dmzlGlobalObj.subRewards;
         }
         this.mRewardObj = targetPool[data.rewardIndex];
         this.mCompleteHandler = completeHandler;
      }
      
      public function setSlotInitPosition(slotX:Number, slotY:Number) : void
      {
         var localPoint:Point = globalToLocal(new Point(slotX,slotY));
         this.mItem = this.buildMarketplaceItem();
         this.mItem.x = localPoint.x;
         this.mItem.y = localPoint.y;
         var wrappedObj:Object = this.mRewardObj.getWrappedObj();
         this.mItem.setData(wrappedObj);
         addChild(this.mItem);
         if(wrappedObj is ProductObj)
         {
            this.myGlow.gotoAndStop(wrappedObj.tier + 1);
         }
         else
         {
            this.myGlow.gotoAndStop(1);
         }
      }
      
      private function buildMarketplaceItem() : BattleCityLeagueRewardCard
      {
         var linkageClass:Class = getDefinitionByName(ITEM_CARD_LINKAGE) as Class;
         return new linkageClass() as BattleCityLeagueRewardCard;
      }
      
      public function playAnimation() : void
      {
         this.myTitle.visible = false;
         this.myGlow.visible = false;
         this.mItem.realWidth = REWARD_CARD_MIDDLE_WIDTH;
         this.mItem.realHeight = REWARD_CARD_MIDDLE_HEIGHT;
         TweenLite.to(this.mItem,TWEEN_DURATION,{
            "delay":TWEEN_DELAY,
            "realWidth":REWARD_CARD_FINAL_WIDTH,
            "realHeight":REWARD_CARD_FINAL_HEIGHT,
            "x":REWARD_CARD_FINAL_X,
            "y":REWARD_CARD_FINAL_Y,
            "onStart":this.onPresentAnimationStart,
            "onComplete":this.onPresentAnimationComplete
         });
      }
      
      private function onPresentAnimationStart() : void
      {
         SoundUtil.getInstance().playSound("UI_Reward_Appear");
      }
      
      private function onPresentAnimationComplete() : void
      {
         this.showGlowAniamtion();
         if(this.mCompleteHandler != null)
         {
            this.mCompleteHandler();
         }
      }
      
      private function showGlowAniamtion() : void
      {
         this.myTitle.visible = true;
         this.myGlow.visible = true;
         this.myGlow.alpha = 0;
         TweenMax.to(this.myGlow,GLOW_ANIMATION,{
            "alpha":0.5,
            "yoyo":true,
            "repeat":-1
         });
      }
   }
}

