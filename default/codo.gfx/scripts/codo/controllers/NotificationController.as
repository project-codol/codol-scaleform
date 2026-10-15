package codo.controllers
{
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.SystemMsgPriority;
   
   public class NotificationController extends NotificationBaseController
   {
      
      public function NotificationController()
      {
         super();
      }
      
      override protected function show(cSysMsgObj:Object) : void
      {
         if(Boolean(cSysMsgObj) && Boolean(cSysMsgObj.message) && cSysMsgObj.message != "")
         {
            super.show(cSysMsgObj);
            if(cSysMsgObj.activityData != null)
            {
               this.gotoPage(CodoPageViewDB.PAGE_ACTIVITY_MSG_FSG);
            }
            else if(cSysMsgObj.wargodSeasonRewardObj != null)
            {
               this.gotoPage(CodoPageViewDB.PAGE_WARGOD_SEASON_REWARD);
            }
            else if(cSysMsgObj.rewardPopupData != null)
            {
               this.gotoPage(CodoPageViewDB.PAGE_POPUP_REWARD);
            }
            else if(cSysMsgObj.recommendationData != null)
            {
               this.gotoPage(CodoPageViewDB.PAGE_RECOMMENDATION_MSG_FSG);
            }
            else
            {
               this.gotoPage(CodoPageViewDB.PAGE_SYS_MSG_FSG);
            }
            if(cSysMsgObj.priority == SystemMsgPriority.FATAL)
            {
               this.broadcast(BCEvent.EVT_HIDE_SYSTEM_CONNECT);
            }
         }
      }
   }
}

