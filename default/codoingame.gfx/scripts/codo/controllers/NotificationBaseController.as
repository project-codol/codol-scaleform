package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.constants.WebImgData;
   import codo.event.ParaEvent;
   import codo.localization.DictSystem;
   import codo.objects.SystemMsgObj;
   import codo.utils.CommonUtil;
   import codo.utils.Logger;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class NotificationBaseController extends BaseController
   {
      
      private var _messagesToBeShown:Array = [];
      
      private var _delayToHideCallback:Function = null;
      
      private var _delayToHideTimer:Timer = new Timer(1000,1);
      
      protected var _currentNotificationID:int = 0;
      
      protected var _currentNotification:SystemMsgObj = null;
      
      private var _isShowing:Boolean = false;
      
      public function NotificationBaseController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.addDP(DataID.IS_SYSTEM_MSG_SHOWING,this.isShowing);
         this.addDP(DataID.CAN_SYS_MSG_FORCE_BE_CLOSED,this.canBeForciblyClosed);
         this.listen(BCEvent.EVT_SHOW_SYSTEM_MSG,this.onShowSystemMsgHandle);
         this.listen(BCEvent.EVT_HIDE_SYSTEM_MSG,this.onHideSystemMsgHandle);
         this.listen(BCEvent.EVT_CHANGE_SYSTEM_MSG,this.onChangeSystemMsgHandle);
         this._delayToHideTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayToHideTimerCompleteHandle);
      }
      
      override public function update(deltaTime:Number) : void
      {
         this.checkMessagesToBeShown();
      }
      
      public function cppIsShowingNotification() : Boolean
      {
         return this.isShowing();
      }
      
      public function cppShowNotification(msg:String, priority:int = 0, type:int = 0) : void
      {
         Logger.print("NotificationBaseController:::cppShowNotification msg/priority/type: " + msg + "/" + priority + "/" + type);
         if(msg == null || msg.length <= 0)
         {
            return;
         }
         var sysMsgObj:SystemMsgObj = SystemMsgObj.getObj(msg,MsgBtnCount.ONE,priority,null,"",null,"",null,"",SystemMsgObj.TRIGGER_TYPE_CPP);
         switch(type)
         {
            case SystemMsgPriority.NORMAL:
            case SystemMsgPriority.WARNING:
            case SystemMsgPriority.ERROR:
               break;
            case SystemMsgPriority.FATAL:
               sysMsgObj.btn0Handle = CommonUtil.quit;
               sysMsgObj.btn0Label = DictSystem.QUIT;
         }
         if(sysMsgObj != null)
         {
            this.show(sysMsgObj);
         }
      }
      
      public function cppShowHopeNotification(title:String, message:String, isModel:Boolean) : void
      {
         var sysMsgObj:SystemMsgObj = SystemMsgObj.getObj(message,MsgBtnCount.ONE,0,null,"",null,"",null,"",SystemMsgObj.TRIGGER_TYPE_CPP);
         sysMsgObj.title = title;
         if(isModel)
         {
            sysMsgObj.btn0Handle = CommonUtil.quit;
            sysMsgObj.btn0Label = DictSystem.QUIT;
         }
         if(sysMsgObj != null)
         {
            this.show(sysMsgObj);
         }
      }
      
      public function cppShowHopeWebPageNotification(url:String, quitGameWhenClose:Boolean) : void
      {
         var ret:Object = CFunctionCommonContainer.OpenWebPageCustom(url,WebImgData.HOPE_WEB_NOTIFICATION.x,WebImgData.HOPE_WEB_NOTIFICATION.y,WebImgData.HOPE_WEB_NOTIFICATION.width,WebImgData.HOPE_WEB_NOTIFICATION.height) as Object;
         if(Boolean(ret.succeed))
         {
            this.broadcast(BCEvent.EVT_SHOW_WEBIMG_CONTAINER,{
               "data":WebImgData.HOPE_WEB_NOTIFICATION,
               "hideTitle":ret.hideTitle,
               "quitGameWhenClose":quitGameWhenClose
            });
            return;
         }
      }
      
      public function cppHideNotification() : void
      {
         this.hide();
      }
      
      private function addCloseCb(callback:Function, hideCallback:Function, shouldAdd:Boolean) : Function
      {
         if(!shouldAdd)
         {
            return null;
         }
         return function():void
         {
            if(hideCallback != null)
            {
               hideCallback();
            }
            if(callback != null)
            {
               callback();
            }
         };
      }
      
      protected function show(cSysMsgObj:Object) : void
      {
         this._isShowing = true;
         this._currentNotification = cSysMsgObj as SystemMsgObj;
         this._currentNotification.id = this._currentNotificationID++;
         this._currentNotification.btn0Handle = this.addCloseCb(this._currentNotification.btn0Handle,this.closeSystemMessage,this._currentNotification.btn0Handle != null || this._currentNotification.btnCount >= MsgBtnCount.ONE);
         this._currentNotification.btn1Handle = this.addCloseCb(this._currentNotification.btn1Handle,this.closeSystemMessage,this._currentNotification.btn1Handle != null || this._currentNotification.btnCount >= MsgBtnCount.TWO);
         this._currentNotification.btn2Handle = this.addCloseCb(this._currentNotification.btn2Handle,this.closeSystemMessage,this._currentNotification.btn2Handle != null || this._currentNotification.btnCount >= MsgBtnCount.THREE);
         if(this._currentNotification.activityData != null)
         {
            this.broadcast(BCEvent.EVT_SET_ACTIVITY_VIEW_MSG,this._currentNotification);
         }
         else if(this._currentNotification.wargodSeasonRewardObj != null)
         {
            this.broadcast(BCEvent.EVT_SET_SEASON_END_REWARD_MSG,this._currentNotification);
         }
         else if(this._currentNotification.rewardPopupData != null)
         {
            this.broadcast(BCEvent.EVT_SET_REWARD_POPUP_MSG,this._currentNotification);
         }
         else if(this._currentNotification.recommendationData != null)
         {
            this.broadcast(BCEvent.EVT_RECOMMENDATION_POPUP_MSG,this._currentNotification);
         }
         else
         {
            this.broadcast(BCEvent.EVT_SET_SYS_VIEW_MSG,this._currentNotification);
         }
      }
      
      protected function change(cSysMsgObj:Object) : void
      {
         this.broadcast(BCEvent.EVT_CHANGE_SYS_VIEW_MSG,cSysMsgObj);
      }
      
      protected function hide(cDelaySecond:Number = 0, cCallback:Function = null) : void
      {
         if(cCallback != null)
         {
            this._delayToHideCallback = cCallback;
         }
         if(cDelaySecond > 0)
         {
            this._delayToHideTimer.reset();
            this._delayToHideTimer.delay = cDelaySecond * 1000;
            this._delayToHideTimer.start();
         }
         else
         {
            this.closeSystemMessage();
         }
      }
      
      private function canBeForciblyClosed() : Boolean
      {
         return this._currentNotification == null || this._currentNotification.btnCount == MsgBtnCount.NONE;
      }
      
      protected function addMessagesToBeShown(cMsgObj:Object) : void
      {
         if(cMsgObj.btnCount == MsgBtnCount.NONE)
         {
            return;
         }
         this._messagesToBeShown.push(cMsgObj);
         this._messagesToBeShown.sortOn("priority",Array.DESCENDING);
      }
      
      private function isEqual(cMsgObj1:SystemMsgObj, cMsgObj2:SystemMsgObj) : Boolean
      {
         if(cMsgObj1 == null || cMsgObj2 == null)
         {
            return false;
         }
         return cMsgObj1.message == cMsgObj2.message && cMsgObj1.priority == cMsgObj2.priority && cMsgObj1.btnCount == cMsgObj2.btnCount;
      }
      
      protected function onShowSystemMsgHandle(cEvt:ParaEvent) : void
      {
         this.broadcast(BCEvent.SYS_POPUP_APPEAR);
         var msgObj:SystemMsgObj = cEvt.myPara;
         Logger.print("NotificationBaseController:::onShowSystemMsgHandle msgObj.message: " + msgObj.message,msgObj);
         if(msgObj.message.length <= 0)
         {
            return;
         }
         msgObj.triggerType = SystemMsgObj.TRIGGER_TYPE_AS;
         switch(msgObj.priority)
         {
            case SystemMsgPriority.NORMAL:
            case SystemMsgPriority.WARNING:
            case SystemMsgPriority.ERROR:
               if(msgObj.btnCount > 0)
               {
                  msgObj.btn0Label = msgObj.btn0Label == "" ? DictSystem.CONFIRM : msgObj.btn0Label;
               }
               break;
            case SystemMsgPriority.FATAL:
               if(msgObj.btnCount > 0)
               {
                  msgObj.btn0Label = msgObj.btn0Label == "" ? DictSystem.QUIT : msgObj.btn0Label;
                  msgObj.btn0Handle = msgObj.btn0Handle == null ? CommonUtil.quit : msgObj.btn0Handle;
               }
         }
         var canShow:Boolean = true;
         if(this._isShowing && this._currentNotification != null && this._currentNotification.btnDelay <= 0)
         {
            if(SystemMsgObj.equal(this._currentNotification,msgObj))
            {
               return;
            }
            if(msgObj.priority > this._currentNotification.priority || msgObj.btnCount > 0 && this._currentNotification.btnCount == 0)
            {
               this.addMessagesToBeShown(this._currentNotification);
            }
            else
            {
               canShow = false;
               this.addMessagesToBeShown(msgObj);
            }
         }
         if(canShow)
         {
            this.show(msgObj);
         }
      }
      
      protected function onHideSystemMsgHandle(cEvt:ParaEvent) : void
      {
         var messageIndex:int = 0;
         if(cEvt.myPara.systemMsg != null)
         {
            Logger.print("NotificationBaseController:::onHideSystemMsgHandle removing specific system message: " + cEvt.myPara.systemMsg);
            for(messageIndex = 0; messageIndex < this._messagesToBeShown.length; messageIndex++)
            {
               if(SystemMsgObj.equal(this._messagesToBeShown[messageIndex],cEvt.myPara.systemMsg))
               {
                  this._messagesToBeShown.splice(messageIndex,1);
                  messageIndex--;
               }
            }
            if(SystemMsgObj.equal(this._currentNotification,cEvt.myPara.systemMsg))
            {
               this.hide(cEvt.myPara.delayTime,cEvt.myPara.callback);
            }
         }
         else
         {
            Logger.print("NotificationBaseController:::onHideSystemMsgHandle isShowing: " + this._isShowing);
            if(!this._isShowing)
            {
               return;
            }
            if(cEvt.myPara.priority != null && cEvt.myPara.priority < this._currentNotification.priority)
            {
               Logger.print("NotificationBaseController:::onHideSystemMsgHandle Current system message box should not be closed by lower priority!");
               return;
            }
            if(this._currentNotification.priority > SystemMsgPriority.ERROR && this._currentNotification.triggerType != SystemMsgObj.TRIGGER_TYPE_CPP)
            {
               return;
            }
            if(this._currentNotification.triggerType == SystemMsgObj.TRIGGER_TYPE_CPP && this._currentNotification.triggerType != cEvt.myPara.triggerType)
            {
               return;
            }
            if(cEvt.myPara.triggerType == SystemMsgObj.TRIGGER_TYPE_AS && this._currentNotification.btnCount > 0)
            {
               return;
            }
            this.hide(cEvt.myPara.delayTime,cEvt.myPara.callback);
         }
      }
      
      protected function onChangeSystemMsgHandle(cEvt:ParaEvent) : void
      {
         this.change(cEvt.myPara);
      }
      
      protected function onDelayToHideTimerCompleteHandle(cEvt:TimerEvent) : void
      {
         Logger.print("NotificationBaseController:::onDelayToHideTimerCompleteHandle");
         this.closeSystemMessage();
      }
      
      protected function checkMessagesToBeShown(deltaTime:Number = 0) : void
      {
         if(this._messagesToBeShown.length <= 0 || this._isShowing)
         {
            return;
         }
         this.show(this._messagesToBeShown[0]);
         this._messagesToBeShown.shift();
      }
      
      protected function isShowing() : Boolean
      {
         return this._isShowing;
      }
      
      protected function closeSystemMessage() : void
      {
         Logger.print("NotificationBaseController:::closeSystemMessage this._isShowing: " + this._isShowing);
         if(this._isShowing)
         {
            this._isShowing = false;
            this._currentNotification = null;
            if(this._delayToHideCallback != null)
            {
               this._delayToHideCallback();
            }
            this.closeAllPopUp();
         }
      }
   }
}

