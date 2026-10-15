package codo.views
{
   import codo.base.BaseView;
   import codo.component.CallToActionButton;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.localization.DictSystem;
   import codo.objects.BattleCityLeagueMatchResultObj;
   import codo.views.battlecityLeagueAward_parts.BattleCityLeagueAwardLoot;
   import codo.views.battlecityLeagueAward_parts.BattleCityLeagueAwardPresent;
   import codo.views.battlecityLeagueAward_parts.BattleCityLeagueAwardProgress;
   import flash.geom.Point;
   
   public class BattleCityLeagueAwardView extends BaseView
   {
      
      private static const ANIMATION_STATUS_PROGRESS:int = 0;
      
      private static const ANIMATION_STATUS_SPINNING:int = 1;
      
      private static const ANIMATION_STATUS_PRESENT:int = 2;
      
      public var myProgressBar:BattleCityLeagueAwardProgress;
      
      public var myLootPanel:BattleCityLeagueAwardLoot;
      
      public var myPresentPanel:BattleCityLeagueAwardPresent;
      
      public var myConfirmBtn:CallToActionButton;
      
      private var mAnimationStatus:int = 0;
      
      private var mData:BattleCityLeagueMatchResultObj;
      
      public function BattleCityLeagueAwardView()
      {
         super();
         this.myConfirmBtn.label = DictSystem.CONFIRM;
         this.myConfirmBtn.x = (GameInfo.DEFAULT_WIDTH - this.myConfirmBtn.width) / 2;
      }
      
      override protected function showView() : void
      {
         visible = false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.EVT_PLAY_BATTLECITY_LEAGUE_AWARD_ANIMATION,this.showBattleCityLeagueAward);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.EVT_PLAY_BATTLECITY_LEAGUE_AWARD_ANIMATION,this.showBattleCityLeagueAward);
      }
      
      private function showBattleCityLeagueAward(evt:ParaEvent) : void
      {
         this.mData = evt.myPara as BattleCityLeagueMatchResultObj;
         this.realShowView();
      }
      
      private function realShowView() : void
      {
         visible = true;
         this.arrangeDisplayOrder();
         this.myConfirmBtn.registerClickEvent(this.closePopupView);
         this.myConfirmBtn.visible = false;
         this.triggerAnimation();
      }
      
      private function realHideView() : void
      {
         visible = false;
         this.myConfirmBtn.unRegisterClickEvent(this.closePopupView);
         broadcast(BCEvent.EVT_HIDE_BATTLECITY_LEAGUE_AWARD);
         broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
      }
      
      private function arrangeDisplayOrder() : void
      {
         var numChildrenInTotal:int = parent.numChildren;
         parent.swapChildren(this,parent.getChildAt(numChildrenInTotal - 1));
      }
      
      private function closePopupView() : void
      {
         this.realHideView();
      }
      
      private function triggerAnimation() : void
      {
         if(this.mAnimationStatus == ANIMATION_STATUS_PROGRESS)
         {
            this.playProgressBarAnimation();
         }
         else if(this.mAnimationStatus == ANIMATION_STATUS_SPINNING)
         {
            this.playSpinningAnimation();
         }
         else if(this.mAnimationStatus == ANIMATION_STATUS_PRESENT)
         {
            this.playPresentAnimation();
         }
      }
      
      private function playProgressBarAnimation() : void
      {
         this.myProgressBar.visible = true;
         this.myLootPanel.visible = false;
         this.myPresentPanel.visible = false;
         this.myProgressBar.setData(this.mData,this.onProgressBarAnimationComplete);
         this.myProgressBar.playAnimation();
      }
      
      private function onProgressBarAnimationComplete(needAward:Boolean) : void
      {
         if(needAward)
         {
            this.mAnimationStatus = ANIMATION_STATUS_SPINNING;
            this.triggerAnimation();
         }
         else
         {
            this.onAnimationComplete();
         }
      }
      
      private function playSpinningAnimation() : void
      {
         this.myProgressBar.visible = false;
         this.myLootPanel.visible = true;
         this.myPresentPanel.visible = false;
         this.myLootPanel.setData(this.mData,this.playSpinningAnimationComplete);
         this.myLootPanel.playAnimation();
      }
      
      private function playSpinningAnimationComplete() : void
      {
         this.mAnimationStatus = ANIMATION_STATUS_PRESENT;
         this.triggerAnimation();
      }
      
      private function playPresentAnimation() : void
      {
         this.myProgressBar.visible = false;
         this.myPresentPanel.visible = true;
         this.myPresentPanel.setData(this.mData,this.playPresentAnimationComplete);
         var finalPosition:Point = this.myLootPanel.getFinalStationaryPoint();
         this.myPresentPanel.setSlotInitPosition(finalPosition.x,finalPosition.y);
         this.myPresentPanel.playAnimation();
      }
      
      private function playPresentAnimationComplete() : void
      {
         this.onAnimationComplete();
      }
      
      private function onAnimationComplete() : void
      {
         this.myConfirmBtn.visible = true;
      }
   }
}

