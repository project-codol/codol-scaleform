package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import flash.display.MovieClip;
   
   public class HudScore extends BaseView
   {
      
      public var myRightContainer:MovieClip;
      
      public var myLeftContainer:MovieClip;
      
      public function HudScore()
      {
         super();
      }
      
      override public function init() : void
      {
         trace("HudScore::init()");
         super.init();
      }
      
      override protected function showView() : void
      {
         var stagePosition:Object = null;
         trace("HudScore::showView()");
         super.showView();
         visible = true;
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_Score,this);
         var stageSize:Object = GameInfo.stageSize;
         stagePosition = GameInfo.stagePosition;
         this.myRightContainer.x = stagePosition.x + (stageSize.width - GameInfo.DEFAULT_WIDTH);
         this.myRightContainer.y = stagePosition.y + (stageSize.height - GameInfo.DEFAULT_HEIGHT);
      }
      
      override protected function hideView() : void
      {
         trace("HudScore::hideView()");
         super.hideView();
      }
      
      public function refreshVisuals() : void
      {
         trace("HudScore::refreshVisuals()");
      }
   }
}

