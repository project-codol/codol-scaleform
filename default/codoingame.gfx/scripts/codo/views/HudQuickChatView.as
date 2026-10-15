package codo.views
{
   import codo.base.BaseView;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.utils.ScaleformUtil;
   import codo.views.hudShared.HudQuickChatWheel;
   import flash.geom.Point;
   
   public class HudQuickChatView extends BaseView
   {
      
      public var myWheel:HudQuickChatWheel;
      
      public function HudQuickChatView()
      {
         super();
         var stageSize:Point = new Point(1280,960);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         this.myWheel.x = stageSize.x / 2 + stagePosition.x;
         this.myWheel.y = stageSize.y / 2 + stagePosition.y;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
      }
      
      override protected function showView() : void
      {
         var channel:int = getDP(DataID.GET_QUICK_CHAT_CHANNEL);
         super.showView();
         this.myWheel.show(channel);
      }
      
      override protected function hideView() : void
      {
         this.myWheel.hide();
         super.hideView();
      }
   }
}

