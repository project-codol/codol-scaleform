package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import codo.utils.ShoutcastUtil;
   import codo.views.hudPropHunt.PropHuntAlive;
   import codo.views.hudPropHunt.PropHuntControls;
   import codo.views.hudPropHunt.WhistleTimer;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class HudPropHunt extends BaseView
   {
      
      public var myWhistleTimer:WhistleTimer;
      
      public var myWhistlingText:TextField;
      
      public var myAliveNum:PropHuntAlive;
      
      public var myPropControls:PropHuntControls;
      
      public function HudPropHunt()
      {
         super();
         this.myWhistlingText.text = "@PH_WHISTLING";
      }
      
      override protected function onInit() : void
      {
         super.onInit();
      }
      
      override protected function showView() : void
      {
         super.showView();
         var stagePosition:Point = GameInfo.stagePosition;
         this.myAliveNum.x = this.myWhistlingText.x = this.myWhistleTimer.x = stagePosition.x;
         this.myPropControls.x = stagePosition.x + GameInfo.stageSize.x - this.myPropControls.width - 16;
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_PropHunt,this);
         ShoutcastUtil.getInstance().registerView(this);
      }
   }
}

