package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.NotificationState;
   import codo.constants.PageID;
   import codo.constants.table.UINotifications;
   import codo.event.ParaEvent;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.TableUtil;
   import flash.utils.Dictionary;
   
   public class UIUnlockController extends BaseController
   {
      
      private static var SF_UI:String = "@SF_UI_";
      
      private static var uiComponentUnlockDictionary:Dictionary = new Dictionary();
      
      private static var uiComponentUnlockTip:Dictionary = new Dictionary();
      
      private var _notifications:Array = [];
      
      private var _isNotificationInitialized:Boolean = false;
      
      public function UIUnlockController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.UI_COMPONENT_UNLOCKED,this.getComponentUnlocked);
         this.addDP(DataID.UI_COMPONENT_TIP,this.getComponentTip);
         this.addDP(DataID.IS_NOTIFIED,this.isNotified);
         this.addDP(DataID.IS_NOTIFICATION_UNLOCKED,this.isNotificationUnlocked);
         this.addDP(DataID.NOTIFICATION_STATE,this.getNotificationState);
         this.addDP(DataID.IS_TRAIN_BTN_LOCKED,this.isTrainLocked);
         this.addDP(DataID.IS_COOP_BTN_LOCKED,this.isCoopLocked);
         this.addDP(DataID.IS_CREATE_ROOM_LOCKED,this.isCreateRoomLocked);
         this.addDP(DataID.IS_ROBOT_PURCHASE_LOCKED,this.isRobotPurchaseLocked);
         this.addDP(DataID.IS_QUESTIONNAIRE_BTN_LOCKED,this.isQuestionnaireLocked);
         this.addDP(DataID.IS_CLAN_CREATE_UNLOCKED,this.isClanCreateUnLocked);
         this.addDP(DataID.IS_CLAN_CREATE_COOL_DOWN_COMPLETE,this.isClanCreateCoolDownComplete);
         this.addDP(DataID.OWN_CLAN_UNLOCKED_LEVEL,this.getOwnClanUnLockedLevel);
         this.addDP(DataID.IS_ESPORTS_BTN_LOCKED,this.isESportsLocked);
         this.listen(BCEvent.EVT_MAIN_PAGE_CHANGED,this.onMainPageChangeHandle);
         this.listen(BCEvent.EVT_UI_NOTIFICATION,this.onUINotification);
         this.listen(BCEvent.ADD_NEW_UNLOCK,this.onAddNewUnlock);
         this.listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandle);
      }
      
      public function cppLockCyborg(lock:Boolean) : void
      {
         Logger.print("UIUnlockController:::cppLockCyborg lock: " + lock);
         this.broadcast(BCEvent.UI_LOCK_CYBORG,lock);
      }
      
      private function onUINotification(cEvt:ParaEvent) : void
      {
         this.setNotified(cEvt.myPara.notification);
      }
      
      private function getNotificationState(notificationRef:String) : uint
      {
         if(!CFunctionCommonContainer.AS_IsNotificationUnlocked(notificationRef))
         {
            return NotificationState.LOCKED;
         }
         return Boolean(CFunctionCommonContainer.AS_IsNotified(notificationRef)) ? NotificationState.UNLOCKED : NotificationState.NEED_NOTIFICATION;
      }
      
      private function isNotified(notificationRef:String) : Boolean
      {
         var notified:Boolean = true;
         if(Boolean(notificationRef) && notificationRef.length > 0)
         {
            notified = CFunctionCommonContainer.AS_IsNotified(notificationRef) as Boolean;
         }
         return notified;
      }
      
      private function isNotificationUnlocked(notificationRef:String) : Boolean
      {
         var unlocked:Boolean = this.getNotificationState(notificationRef) == NotificationState.NEED_NOTIFICATION;
         if(!ScaleformUtil.isScaleform)
         {
            unlocked = true;
         }
         return unlocked;
      }
      
      private function setNotified(notificationRef:String) : void
      {
         Logger.print("UIUnlockController:::setNotified notificationRef: " + notificationRef);
         if(Boolean(notificationRef) && notificationRef.length > 0)
         {
            CFunctionCommonContainer.AS_SetNotified(notificationRef);
         }
      }
      
      private function onAddNewUnlock(e:ParaEvent) : void
      {
         this._notifications.push(e.myPara);
      }
      
      private function getComponentUnlocked(componentID:String) : Boolean
      {
         return uiComponentUnlockDictionary[componentID] != NotificationState.LOCKED;
      }
      
      private function getComponentTip(componentID:String) : String
      {
         return uiComponentUnlockTip[componentID];
      }
      
      private function onMainPageChangeHandle(cEvt:ParaEvent) : void
      {
         var currentPage:String = this.getDP(DataID.CURRENT_MAIN_PAGE_ID);
         if(currentPage != PageID.INROOM && currentPage != PageID.HOME)
         {
            this.initNotifications();
         }
      }
      
      private function onPlayerStatsReadyHandle(cEvt:ParaEvent) : void
      {
         this.initNotifications();
      }
      
      private function initNotifications() : void
      {
         var ruleName:String = null;
         var mode:String = null;
         var notificationState:uint = 0;
         var componentString:String = null;
         var componentsIDs:Array = null;
         var j:int = 0;
         if(this._isNotificationInitialized || !CFunctionContainer.IsPlayerStatsReady())
         {
            return;
         }
         var rowCount:int = TableUtil.getRowCount(UINotifications.PATH);
         if(rowCount <= 0)
         {
            return;
         }
         this._isNotificationInitialized = true;
         for(var i:int = 0; i < rowCount; i++)
         {
            ruleName = TableUtil.getValue(UINotifications.PATH,i,UINotifications.NOTIFICATION);
            mode = TableUtil.getValue(UINotifications.PATH,i,UINotifications.MODE);
            notificationState = this.getNotificationState(ruleName);
            if(notificationState == NotificationState.NEED_NOTIFICATION && mode.length > 0)
            {
               this._notifications.push(ruleName);
            }
            componentString = TableUtil.getValue(UINotifications.PATH,i,UINotifications.UI_COMPONENT);
            if(Boolean(componentString) && componentString.length > 0)
            {
               componentsIDs = componentString.split("|");
               for(j = 0; j < componentsIDs.length; j++)
               {
                  uiComponentUnlockDictionary[componentsIDs[j]] = notificationState;
                  uiComponentUnlockTip[componentsIDs[j]] = SF_UI + TableUtil.getValue(UINotifications.PATH,i,UINotifications.TIP);
               }
            }
         }
      }
      
      private function isQuestionnaireLocked() : Boolean
      {
         return ScaleformUtil.isScaleform ? this.getDvarBool("ui_lockQuestionnaire") : false;
      }
      
      private function isClanCreateUnLocked() : Boolean
      {
         return CFunctionCommonContainer.AS_IsNotificationUnlocked("un_clan") as Boolean;
      }
      
      private function isTrainLocked() : Boolean
      {
         return ScaleformUtil.isScaleform ? this.getDvarBool("ui_lockTrain") : false;
      }
      
      private function isCoopLocked() : Boolean
      {
         return ScaleformUtil.isScaleform ? this.getDvarBool("ui_lockCoop") : false;
      }
      
      private function isCreateRoomLocked() : Boolean
      {
         return ScaleformUtil.isScaleform ? this.getDvarBool("ui_lockCreateRoom") : false;
      }
      
      private function isRobotPurchaseLocked() : Boolean
      {
         return ScaleformUtil.isScaleform ? this.getDvarBool("ui_lock_purchaseRobot") : false;
      }
      
      private function getOwnClanUnLockedLevel() : int
      {
         return CFunctionCommonContainer.AS_GetNotificationUnlockLevel("un_clan");
      }
      
      private function isClanCreateCoolDownComplete() : Boolean
      {
         return CFunctionContainer.CreateClanCoolDownComplete() as Boolean;
      }
      
      private function isESportsLocked() : Boolean
      {
         return ScaleformUtil.isScaleform ? this.getDvarBool("ui_lockESports") : false;
      }
   }
}

