package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import components.gvoice.GVoiceChatBar;
   
   public class GVoiceChatBarView extends BaseView
   {
      
      public var myBar:GVoiceChatBar;
      
      public function GVoiceChatBarView()
      {
         super();
      }
      
      override protected function showView() : void
      {
         listen(BCCommonEvent.EVT_GVOICE_SHOW_CHAT_BAR,this.onShowChatBar);
         listen(BCCommonEvent.EVT_GVOICE_HIDE_CHAT_BAR,this.onHideChatBar);
         listen(BCCommonEvent.EVT_GVOICE_UPDATE_BATTERY,this.onUpdateBattery);
         listen(BCCommonEvent.EVT_GVOICE_PLAYER_TALK,this.onPlayerTalk);
         this.myBar.visible = false;
      }
      
      override protected function hideView() : void
      {
         unlisten(BCCommonEvent.EVT_GVOICE_SHOW_CHAT_BAR,this.onShowChatBar);
         unlisten(BCCommonEvent.EVT_GVOICE_HIDE_CHAT_BAR,this.onHideChatBar);
         unlisten(BCCommonEvent.EVT_GVOICE_UPDATE_BATTERY,this.onUpdateBattery);
         unlisten(BCCommonEvent.EVT_GVOICE_PLAYER_TALK,this.onPlayerTalk);
         this.myBar.visible = false;
      }
      
      private function onShowChatBar(e:ParaEvent) : void
      {
         var param:Object = null;
         param = e.myPara as Object;
         if(Boolean(param.absolute))
         {
            this.myBar.x = param.x;
            this.myBar.y = param.y;
         }
         else
         {
            if(param.x >= 0)
            {
               this.myBar.x = GameInfo.stagePosition.x + param.x;
            }
            else
            {
               this.myBar.x = GameInfo.stagePosition.x + GameInfo.stageSize.x + param.x;
            }
            if(param.y >= 0)
            {
               this.myBar.y = GameInfo.stagePosition.y + param.y;
            }
            else
            {
               this.myBar.y = GameInfo.stagePosition.y + GameInfo.stageSize.y + param.y;
            }
         }
         this.myBar.setBattery(CFunctionCommonContainer.AS_GVoice_GetBatteryValue());
         this.myBar.show();
      }
      
      private function onHideChatBar(e:ParaEvent) : void
      {
         this.myBar.hide();
      }
      
      private function onUpdateBattery(e:ParaEvent) : void
      {
         this.myBar.setBattery(CFunctionCommonContainer.AS_GVoice_GetBatteryValue());
      }
      
      private function onPlayerTalk(e:ParaEvent) : void
      {
         var memberID:int = e.myPara as int;
         this.myBar.currentTalkingMember = memberID;
      }
   }
}

