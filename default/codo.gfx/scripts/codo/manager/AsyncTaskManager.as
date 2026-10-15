package codo.manager
{
   import codo.base.AsyncTaskBase;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.AsyncTaskState;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.objects.ResultObj;
   import codo.objects.SystemMsgObj;
   import codo.services.CommonService;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import flash.utils.Dictionary;
   
   public class AsyncTaskManager
   {
      
      private static var _instance:AsyncTaskManager;
      
      private var _asyncTasks:Dictionary = new Dictionary();
      
      public var GetTaskClass:Function;
      
      public function AsyncTaskManager()
      {
         super();
      }
      
      public static function getInstance() : AsyncTaskManager
      {
         if(AsyncTaskManager._instance == null)
         {
            AsyncTaskManager._instance = new AsyncTaskManager();
         }
         return AsyncTaskManager._instance;
      }
      
      public function canCreateTask(taskID:uint, taskGroup:uint) : Boolean
      {
         var tasks:Array = null;
         var task:AsyncTaskBase = null;
         if(this.canBeQueued(taskID,taskGroup))
         {
            return true;
         }
         if(!this.hasGroup(taskGroup))
         {
            return true;
         }
         tasks = this.getGroup(taskGroup);
         if(tasks.length <= 0)
         {
            return true;
         }
         for each(task in tasks)
         {
            if(this.isPending(task) || this.isInProgress(task))
            {
               return false;
            }
         }
         return true;
      }
      
      public function createTask(taskID:uint, taskGroup:uint, taskParams:* = null, fakeData:* = null) : Boolean
      {
         var error:String = null;
         var ids:String = null;
         var tasks:Array = null;
         var t:AsyncTaskBase = null;
         var task:AsyncTaskBase = null;
         if(this.GetTaskClass == null)
         {
            error = "AsyncTaskManager:::createTask[" + taskID + "] failed: GetTaskName is null!";
            Logger.print(error);
            this.showMsg(error,MsgBtnCount.ONE,true);
            return false;
         }
         var canBeQueued:Boolean = false;
         if(taskParams != null && Boolean(taskParams.hasOwnProperty("queue")))
         {
            canBeQueued = Boolean(taskParams.queue);
         }
         if(!canBeQueued && !this.canCreateTask(taskID,taskGroup))
         {
            tasks = this.getGroup(taskGroup);
            for each(t in tasks)
            {
               if(ids != null)
               {
                  ids += ",";
               }
               ids += t.id;
            }
            error = "AsyncTaskManager:::createTask[" + taskID + "] failed: task[" + ids + "] is running!";
            Logger.print(error);
            this.showMsg(error,MsgBtnCount.ONE,true);
            return false;
         }
         var taskClass:Class = this.GetTaskClass(taskID);
         if(taskClass != null)
         {
            task = new taskClass();
            if(task != null)
            {
               task.params = taskParams;
               if(taskParams != null)
               {
                  if(Boolean(taskParams.hasOwnProperty("auto")) && taskParams.auto != null)
                  {
                     task.auto = taskParams.auto;
                  }
                  if(Boolean(taskParams.hasOwnProperty("feedback")) && taskParams.feedback != null)
                  {
                     task.showFeedback = taskParams.feedback;
                  }
               }
               if(!ScaleformUtil.isScaleform)
               {
                  task.result.data = fakeData;
               }
               this.addTask(task);
               return true;
            }
            error = "AsyncTaskManager:::createTask[" + taskID + "] failed: invalid task[" + String(taskClass) + "]!";
            Logger.print(error);
            this.showMsg(error,MsgBtnCount.ONE,true);
            return false;
         }
         error = "AsyncTaskManager:::createTask[" + taskID + "] failed: invalid task class[" + String(taskClass) + "]!";
         Logger.print(error);
         this.showMsg(error,MsgBtnCount.ONE,true);
         return false;
      }
      
      public function cancelTask(taskID:uint) : Boolean
      {
         var task:AsyncTaskBase = this.getTask(taskID);
         if(task != null)
         {
            task.state = AsyncTaskState.CANCELLED;
            return true;
         }
         return false;
      }
      
      public function getTask(taskID:uint) : AsyncTaskBase
      {
         var group:* = undefined;
         var task:* = undefined;
         loop0:
         for(group in this._asyncTasks)
         {
            var _loc6_:int = 0;
            var _loc7_:* = this._asyncTasks[group];
            do
            {
               for each(task in _loc7_)
               {
               }
               continue loop0;
            }
            while(!(task is AsyncTaskBase && task.id == taskID));
            return task;
         }
         return null;
      }
      
      public function getTaskState(taskID:uint) : uint
      {
         var task:AsyncTaskBase = this.getTask(taskID);
         return task != null ? task.state : AsyncTaskState.NONE;
      }
      
      public function isTaskInProgress(taskID:uint) : Boolean
      {
         var task:AsyncTaskBase = this.getTask(taskID);
         return task != null ? this.isInProgress(task) : false;
      }
      
      private function canBeQueued(taskID:uint, taskGroup:uint) : Boolean
      {
         if(taskGroup == AsyncTaskGroup.CONTACT)
         {
            return true;
         }
         if(taskID == DataID.PROMOTE_CLAN_MEMBER || taskID == DataID.DEMOTE_CLAN_MEMBER || taskID == DataID.PROPOSE_CLAN_MEMBERSHIP || taskID == DataID.REJECT_CLAN_MEMBERSHIP || taskID == DataID.KICK_CLAN_MEMBER || taskID == DataID.PUBLISHER_FILES_UPDATE)
         {
            return true;
         }
         return false;
      }
      
      private function hasGroup(taskGroup:uint) : Boolean
      {
         return this._asyncTasks.hasOwnProperty(taskGroup.toString());
      }
      
      private function getGroup(taskGroup:uint) : Array
      {
         return this.hasGroup(taskGroup) ? this._asyncTasks[taskGroup] : null;
      }
      
      private function addTask(task:AsyncTaskBase) : void
      {
         Logger.print("AsyncTaskManager:::addTask task.id: " + task.id);
         if(task == null)
         {
            return;
         }
         if(!this.hasGroup(task.group))
         {
            this._asyncTasks[task.group] = [];
         }
         var tasks:Array = this.getGroup(task.group);
         var startTask:Boolean = true;
         for(var i:int = 0; i < tasks.length; i++)
         {
            if(this.isInProgress(tasks[i]))
            {
               startTask = false;
               break;
            }
         }
         this._asyncTasks[task.group].push(task);
         task.state = startTask ? AsyncTaskState.STARTED : AsyncTaskState.PENDING;
      }
      
      private function removeTask(task:AsyncTaskBase) : void
      {
         var msg:String = null;
         var startTask:Boolean = false;
         if(task == null || task.persistent)
         {
            return;
         }
         var tasks:Array = this.getGroup(task.group);
         if(tasks == null || tasks.length <= 0)
         {
            msg = "AsyncTaskManager:::removeTask current task queue is empty, can not remove task[" + task.id + "]!";
            this.showMsg(msg,MsgBtnCount.ONE,true);
            return;
         }
         for(var i:int = tasks.length - 1; i >= 0; i--)
         {
            if(tasks[i] == task)
            {
               tasks.splice(i,1);
               Logger.print("AsyncTaskManager:::removeTask task.id: " + task.id);
               break;
            }
         }
         if(tasks.length <= 0)
         {
            this._asyncTasks[task.group] = null;
            delete this._asyncTasks[task.group];
         }
         else
         {
            startTask = true;
            for each(task in tasks)
            {
               if(this.isInProgress(task))
               {
                  startTask = false;
                  break;
               }
            }
            if(startTask)
            {
               for each(task in tasks)
               {
                  if(this.isPending(task))
                  {
                     task.state = AsyncTaskState.STARTED;
                     break;
                  }
               }
            }
         }
      }
      
      private function isPending(task:AsyncTaskBase) : Boolean
      {
         return task.state == AsyncTaskState.PENDING;
      }
      
      private function isInProgress(task:AsyncTaskBase) : Boolean
      {
         return task.state == AsyncTaskState.STARTED || task.state == AsyncTaskState.WAITING;
      }
      
      private function isComplete(task:AsyncTaskBase) : Boolean
      {
         return task.state == AsyncTaskState.NONE || task.state == AsyncTaskState.SUCCEEDED || task.state == AsyncTaskState.FAILED || task.state == AsyncTaskState.CANCELLED || task.state == AsyncTaskState.COMPLETE;
      }
      
      private function isResultSuccess(task:AsyncTaskBase) : Boolean
      {
         return task.result != null && task.result.result == ResultObj.RESULT_SUCCESS;
      }
      
      private function isResultFail(task:AsyncTaskBase) : Boolean
      {
         return task.result != null && task.result.result == ResultObj.RESULT_FAIL;
      }
      
      private function setData(data:ResultObj) : void
      {
         DataManager.getInstance().setData(data);
      }
      
      private function showMsg(msg:String, btnCount:uint, debug:Boolean = false) : void
      {
         Logger.print("AsyncTaskManager:::showMsg msg: " + msg);
         var show:Boolean = true;
         if(debug)
         {
            show = CommonService.getInstance().isDevBuild();
         }
         if(show)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,SystemMsgObj.getObj(msg,btnCount,SystemMsgPriority.WARNING));
         }
      }
      
      private function hideMsg() : void
      {
         Logger.print("AsyncTaskManager:::hideMsg");
         EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{
            "delayTime":0,
            "callback":null,
            "triggerType":0,
            "priority":0
         });
      }
      
      public function onDWDisconnected() : void
      {
         var group:* = undefined;
         var task:AsyncTaskBase = null;
         Logger.print("AsyncTaskManager:::onDWDisconnected - LSG service disconnected, cancelling all async tasks.");
         this.update(0);
         for(group in this._asyncTasks)
         {
            for each(task in this._asyncTasks[group])
            {
               Logger.print("\tcancel task: " + task.id);
               this.cancelTask(task.id);
            }
         }
         Logger.print("AsyncTaskManager:::onDWDisconnected end.");
      }
      
      public function cppRefreshTask(cObj:Object) : void
      {
         var res:ResultObj = new ResultObj(cObj);
         if(res.id == DataID.NONE)
         {
            return;
         }
         var task:AsyncTaskBase = this.getTask(res.id);
         if(task != null)
         {
            task.result = null;
            task.result = res;
            task.result.params = task.params;
         }
         else
         {
            this.setData(res);
         }
      }
      
      public function update(deltaTime:Number) : void
      {
         var group:* = undefined;
         var task:AsyncTaskBase = null;
         var resS:* = undefined;
         var resF:* = undefined;
         for(group in this._asyncTasks)
         {
            for each(task in this._asyncTasks[group])
            {
               if(deltaTime > 0)
               {
                  task.update(deltaTime);
               }
               if(!ScaleformUtil.isScaleform)
               {
                  ++task.elapsedFrames;
                  if(task.result != null && task.result.result == ResultObj.RESULT_NONE && (task.elapsedFrames >= 1 || task.auto))
                  {
                     task.result.id = task.id;
                     task.result.result = ResultObj.RESULT_SUCCESS;
                  }
               }
               if(this.isResultSuccess(task))
               {
                  if(!task.auto)
                  {
                     this.hideMsg();
                  }
                  resS = task.result;
                  task.state = AsyncTaskState.SUCCEEDED;
                  this.setData(resS);
               }
               else if(this.isResultFail(task))
               {
                  if(!task.auto)
                  {
                     this.hideMsg();
                  }
                  if(task.showFeedback)
                  {
                     Logger.print("AsyncTaskManager:::update task: " + task);
                     this.showMsg(task.result.resultMsg,MsgBtnCount.ONE);
                  }
                  resF = task.result;
                  task.state = AsyncTaskState.FAILED;
                  this.setData(resF);
               }
               if(this.isComplete(task))
               {
                  this.removeTask(task);
               }
            }
         }
      }
   }
}

