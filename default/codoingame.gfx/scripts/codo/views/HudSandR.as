package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import codo.utils.ShoutcastUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class HudSandR extends BaseView
   {
      
      public var myLeftContainer:MovieClip;
      
      public function HudSandR()
      {
         super();
      }
      
      override public function init() : void
      {
         trace("HudSandR::init()");
         super.init();
      }
      
      override protected function showView() : void
      {
         trace("HudSandR::showView()");
         super.showView();
         var stagePosition:Point = GameInfo.stagePosition;
         this.myLeftContainer.x = stagePosition.x;
         this.myLeftContainer.y = stagePosition.y;
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_SAR,this);
         ShoutcastUtil.getInstance().registerView(this);
      }
      
      override protected function hideView() : void
      {
         trace("HudSandR::hideView()");
         super.hideView();
      }
   }
}

