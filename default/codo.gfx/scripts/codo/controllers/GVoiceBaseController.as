package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.DataCommonID;
   import codo.event.ParaEvent;
   
   public class GVoiceBaseController extends BaseController
   {
      
      public function GVoiceBaseController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataCommonID.GVOICE_MEMBER_INFO,this.getGVoiceMembers);
         listen(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING,this.onToggleVoiceSettings);
         listen(BCCommonEvent.TRY_FORCE_CLOSE_GVOICE_SETTING,this.onForceCloseGVoiceSettings);
      }
      
      protected function getGVoiceMembers() : Array
      {
         return CFunctionCommonContainer.AS_GVoice_GetRoomMembers();
      }
      
      protected function onToggleVoiceSettings(cEvt:ParaEvent) : void
      {
      }
      
      protected function onForceCloseGVoiceSettings(cEvt:ParaEvent) : void
      {
      }
      
      public function cppRefreshMembers() : void
      {
         broadcast(BCCommonEvent.EVT_GVOICE_REFRESH_MEMBERS);
      }
      
      public function cppShowGVoiceBar(absolute:Boolean, x:int, y:int) : void
      {
         var param:Object = new Object();
         param.absolute = absolute;
         param.x = x;
         param.y = y;
         broadcast(BCCommonEvent.EVT_GVOICE_SHOW_CHAT_BAR,param);
      }
      
      public function cppHideGVoiceBar() : void
      {
         broadcast(BCCommonEvent.EVT_GVOICE_HIDE_CHAT_BAR);
      }
      
      public function cppUpdateBattery() : void
      {
         broadcast(BCCommonEvent.EVT_GVOICE_UPDATE_BATTERY);
      }
      
      public function cppNotifyPlayerTalk(memberID:int) : void
      {
         broadcast(BCCommonEvent.EVT_GVOICE_PLAYER_TALK,memberID);
      }
   }
}

