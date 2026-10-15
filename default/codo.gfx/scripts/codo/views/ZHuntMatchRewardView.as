package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.CallToActionButton;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.utils.ScaleformUtil;
   import codo.views.zhuntMatchResult_parts.ZHuntMatchResultPanel;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ZHuntMatchRewardView extends BaseView
   {
      
      public var myMask:MovieClip;
      
      public var myFrame:MovieClip;
      
      public var myPanel:ZHuntMatchResultPanel;
      
      public var myConfirmBtn:CallToActionButton;
      
      public function ZHuntMatchRewardView()
      {
         super();
         this.myConfirmBtn.label = Dict.ACCEPT_REWARDS;
         this.myConfirmBtn.width = 200;
         this.myConfirmBtn.setClickCallback(this.onConfirmBtnClicked);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.visible = false;
         this.myPanel.killAllTweens();
         this.myPanel.visible = false;
         listen(BCEvent.EVT_SHOW_ZHUNT_MATCH_REWARD_VIEW,this.onRealShow);
      }
      
      override public function set visible(visible:Boolean) : void
      {
         super.visible = visible;
         if(visible)
         {
            CFunctionCommonContainer.setdvar("r_blur","1");
         }
         else
         {
            CFunctionCommonContainer.setdvar("r_blur","0");
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         CFunctionCommonContainer.setdvar("r_blur","0");
      }
      
      private function onConfirmBtnClicked() : void
      {
         this.myPanel.killAllTweens();
         this.myConfirmBtn.enabled = false;
         TweenLite.to(this.myConfirmBtn,0.2,{"alpha":0});
         TweenLite.to(this.myPanel,0.5,{
            "delay":0.2,
            "alpha":0,
            "onComplete":this.onHidePanelComplete
         });
      }
      
      private function onHidePanelComplete() : void
      {
         var endY:Number = this.myFrame.y + this.myFrame.height / 2;
         TweenLite.to(this.myFrame,0.3,{
            "y":endY,
            "height":0,
            "onComplete":this.onCloseViewAnimCompleted
         });
      }
      
      private function onCloseViewAnimCompleted() : void
      {
         this.myMask.visible = false;
         this.myPanel.killAllTweens();
         this.myPanel.visible = false;
         this.visible = false;
         broadcast(BCEvent.EVT_REFRESH_MATCH_RESULT_VIEW);
      }
      
      public function topMost() : void
      {
         parent.setChildIndex(this,parent.numChildren - 1);
      }
      
      private function onRealShow(cEvt:ParaEvent) : void
      {
         var stagePosition:Point = null;
         var frameDestHeight:Number = NaN;
         var frameDestY:Number = NaN;
         TweenLite.killTweensOf(this.myFrame);
         TweenLite.killTweensOf(this.myPanel);
         TweenLite.killTweensOf(this.myConfirmBtn);
         this.myPanel.killAllTweens();
         this.topMost();
         this.visible = true;
         this.myPanel.alpha = 0;
         this.myPanel.visible = true;
         var rewards:Array = cEvt.myPara as Array;
         this.myPanel.setData(rewards);
         this.myConfirmBtn.alpha = 0;
         this.myConfirmBtn.enabled = true;
         var stageSize:Point = new Point(1280,960);
         stagePosition = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         this.myMask.x = stagePosition.x;
         this.myMask.y = stagePosition.y;
         this.myMask.width = stageSize.x;
         this.myMask.height = stageSize.y;
         this.myFrame.width = stageSize.x;
         this.myFrame.height = 0;
         this.myFrame.x = 0;
         this.myFrame.y = stagePosition.y + stageSize.y / 2;
         frameDestHeight = this.myPanel.myArea.height;
         frameDestY = stagePosition.y + (stageSize.y - frameDestHeight) / 2;
         this.myPanel.y = frameDestY;
         this.myPanel.x = stagePosition.x + (stageSize.x - this.myPanel.myArea.width) / 2 - 5;
         this.myConfirmBtn.y = this.myPanel.y + this.myPanel.myArea.height + 15;
         TweenLite.to(this.myFrame,0.5,{
            "delay":1.5,
            "alpha":1,
            "y":frameDestY,
            "height":frameDestHeight,
            "onComplete":this.onFrameExpanded
         });
      }
      
      private function onFrameExpanded() : void
      {
         TweenLite.to(this.myPanel,0.5,{
            "delay":0.1,
            "alpha":1,
            "onComplete":this.onRewardPanelShown
         });
      }
      
      private function onRewardPanelShown() : void
      {
         TweenLite.to(this.myConfirmBtn,0.5,{"alpha":1});
         this.myPanel.playOpenCratesAnimations();
      }
   }
}

