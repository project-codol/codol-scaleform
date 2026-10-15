package codo.base
{
   import codo.constants.AsyncTaskState;
   import codo.objects.ResultObj;
   
   public class AsyncTaskBase extends StateMachineBase
   {
      
      public static var LIFE_TIME:Number = 30;
      
      private var _group:uint = 0;
      
      private var _id:uint = 0;
      
      private var _persistent:Boolean = false;
      
      private var _result:ResultObj = new ResultObj();
      
      private var _isAuto:Boolean = false;
      
      private var _params:* = null;
      
      private var _showFeedback:Boolean = true;
      
      private var _life:Number = 0;
      
      public var elapsedFrames:int = 0;
      
      public function AsyncTaskBase(id:uint, group:uint = 0)
      {
         super();
         this._id = id;
         this._group = group;
         this.onInit();
      }
      
      public function onInit() : void
      {
         this.addState(AsyncTaskState.NONE,null);
         this.addState(AsyncTaskState.PENDING,null);
         this.addState(AsyncTaskState.STARTED,this.onStart);
         this.addState(AsyncTaskState.WAITING,null);
         this.addState(AsyncTaskState.SUCCEEDED,this.onSuccess);
         this.addState(AsyncTaskState.FAILED,this.onFail);
         this.addState(AsyncTaskState.CANCELLED,this.onCancel);
         this.addState(AsyncTaskState.COMPLETE,this.onComplete);
      }
      
      override public function update(deltaTime:Number) : void
      {
         this._life += deltaTime;
      }
      
      public function onStart() : void
      {
         this.state = AsyncTaskState.WAITING;
      }
      
      public function onSuccess() : void
      {
         this.state = AsyncTaskState.COMPLETE;
      }
      
      public function onFail() : void
      {
         this.state = AsyncTaskState.COMPLETE;
      }
      
      public function onCancel() : void
      {
         this.state = AsyncTaskState.COMPLETE;
      }
      
      public function onComplete() : void
      {
         this.state = AsyncTaskState.NONE;
         this._result = null;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(id:uint) : void
      {
         this._id = id;
      }
      
      public function get persistent() : Boolean
      {
         return this._persistent;
      }
      
      public function set persistent(persistent:Boolean) : void
      {
         this._persistent = persistent;
      }
      
      public function get result() : ResultObj
      {
         return this._result;
      }
      
      public function set result(result:ResultObj) : void
      {
         this._result = result;
      }
      
      public function get auto() : Boolean
      {
         return this._isAuto;
      }
      
      public function set auto(bAuto:Boolean) : void
      {
         this._isAuto = bAuto;
      }
      
      public function get group() : uint
      {
         return this._group;
      }
      
      public function set group(group:uint) : void
      {
         this._group = group;
      }
      
      public function get params() : *
      {
         return this._params;
      }
      
      public function set params(value:*) : void
      {
         this._params = value;
      }
      
      public function get showFeedback() : Boolean
      {
         return this._showFeedback;
      }
      
      public function set showFeedback(value:Boolean) : void
      {
         this._showFeedback = value;
      }
   }
}

