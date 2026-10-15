package codo.base
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.manager.AsyncTaskManager;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ResultObj;
   import codo.objects.SystemMsgObj;
   import codo.utils.Logger;
   
   public class ServiceBase extends StateMachineBase
   {
      
      private var _serviceID:uint = 0;
      
      public function ServiceBase(id:uint)
      {
         super();
         this._serviceID = id;
         this.init();
      }
      
      public function init() : void
      {
      }
      
      public function postActivate() : void
      {
      }
      
      public function get id() : uint
      {
         return this._serviceID;
      }
      
      protected function createTask(taskID:uint, taskGroup:uint = 0, taskParams:* = null, fakeData:* = null) : Boolean
      {
         return AsyncTaskManager.getInstance().createTask(taskID,taskGroup,taskParams,fakeData);
      }
      
      protected function cancelTask(taskID:uint) : Boolean
      {
         return AsyncTaskManager.getInstance().cancelTask(taskID);
      }
      
      protected function getTask(taskID:uint) : AsyncTaskBase
      {
         return AsyncTaskManager.getInstance().getTask(taskID);
      }
      
      protected function isTaskInProgress(taskID:uint) : Boolean
      {
         return AsyncTaskManager.getInstance().isTaskInProgress(taskID);
      }
      
      public function showMsg(cMsg:String, cBtnCount:int = 0, cPriority:int = 0, cCallback0:Function = null, cLabel0:String = "", cCallback1:Function = null, cLabel1:String = "", cCallback2:Function = null, cLabel2:String = "", triggerType:int = 0, cDelay:Number = 0) : void
      {
         Logger.print("ServiceBase:::showMsg this/msg: " + this + "/" + cMsg);
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,SystemMsgObj.getObj(cMsg,cBtnCount,cPriority,cCallback0,cLabel0,cCallback1,cLabel1,cCallback2,cLabel2,triggerType,cDelay));
      }
      
      public function hideMsg(cTime:Number = 0, cCallback:Function = null, cTriggerType:int = 0, cPriority:int = 0) : void
      {
         Logger.print("ServiceBase:::hideMsg this: " + this);
         this.broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{
            "delayTime":cTime,
            "callback":cCallback,
            "triggerType":cTriggerType,
            "priority":cPriority
         });
      }
      
      protected function register(dataID:uint, callback:Function = null, cOnComplete:Function = null, cOnFail:Function = null) : void
      {
         DataManager.getInstance().register(dataID,callback);
      }
      
      protected function setData(data:ResultObj) : void
      {
         DataManager.getInstance().setData(data);
      }
      
      protected function broadcast(cType:String, cData:* = null) : void
      {
         EventManager.getInstance().broadcast(cType,cData);
      }
      
      protected function listen(cType:String, cCallback:Function) : void
      {
         EventManager.getInstance().listen(cType,cCallback);
      }
      
      protected function addDP(cDataID:*, cProvider:Function) : void
      {
         DataManager.getInstance().addDP(cDataID,cProvider);
      }
      
      protected function removeDP(cDataID:*, cProvider:Function) : void
      {
         DataManager.getInstance().removeDP(cDataID,cProvider);
      }
      
      protected function getDP(cDataID:*, cParams:Array = null) : *
      {
         return DataManager.getInstance().getDP(cDataID,cParams);
      }
      
      public function getDvarBool(dvar:String) : Boolean
      {
         return CFunctionCommonContainer.Dvar_GetBool(dvar) as Boolean;
      }
      
      public function getDvarInt(dvar:String) : int
      {
         return CFunctionCommonContainer.Dvar_GetInt(dvar);
      }
      
      public function getDvarFloat(dvar:String) : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat(dvar);
      }
      
      public function getDvarString(dvar:String) : String
      {
         return CFunctionCommonContainer.Dvar_GetString(dvar);
      }
      
      public function getDvarEnumLen(dvar:String) : Number
      {
         return CFunctionCommonContainer.Dvar_GetEnumLength(dvar);
      }
      
      public function getDvarEnumVal(dvar:String, index:Number) : String
      {
         return CFunctionCommonContainer.Dvar_GetEnumValue(dvar,index);
      }
   }
}

