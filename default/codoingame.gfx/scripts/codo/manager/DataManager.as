package codo.manager
{
   import codo.interfaces.IDataManager;
   import codo.objects.BindCallbackObj;
   import codo.objects.ResultObj;
   import flash.utils.Dictionary;
   
   public class DataManager implements IDataManager
   {
      
      private static var _instance:DataManager;
      
      private var _database:Dictionary = new Dictionary();
      
      private var _serviceCallbacks:Dictionary = new Dictionary();
      
      private var _requestCallbacks:Dictionary = new Dictionary();
      
      private var _bindCallbacks:Dictionary = new Dictionary();
      
      private var _dataProviderCallbacks:Dictionary = new Dictionary();
      
      private var _currentDataID:* = null;
      
      public function DataManager()
      {
         super();
      }
      
      public static function getInstance() : DataManager
      {
         if(DataManager._instance == null)
         {
            DataManager._instance = new DataManager();
         }
         return DataManager._instance;
      }
      
      public function bind(dataID:*, callback:Function, params:* = null, immediate:Boolean = true, fromViewDeprecated:Boolean = false, fromController:Boolean = false, initialDataVersion:uint = 0) : void
      {
         var callbackObj:BindCallbackObj = null;
         var dataObj:ResultObj = null;
         if(!this.isBound(dataID,callback))
         {
            callbackObj = new BindCallbackObj();
            callbackObj.callback = callback;
            callbackObj.fromController = fromController;
            callbackObj.dataVersion = initialDataVersion;
            callbackObj.params = params;
            if(!this._bindCallbacks.hasOwnProperty(dataID))
            {
               this._bindCallbacks[dataID] = [];
            }
            this._bindCallbacks[dataID].push(callbackObj);
         }
         callbackObj = callbackObj == null ? this.getCallbackObj(dataID,callback,this._bindCallbacks) : callbackObj;
         if(callbackObj != null)
         {
            if(immediate)
            {
               dataObj = this._database[dataID];
               if(dataObj != null)
               {
                  this.dispatch(dataID,callbackObj);
               }
            }
         }
      }
      
      public function unbind(dataID:*, callback:Function) : uint
      {
         var index:int;
         var dataVersion:int;
         var everyFunc:Function;
         var callbacks:Array = this._bindCallbacks[dataID];
         if(!callbacks || callbacks.length < 1)
         {
            return 0;
         }
         index = -1;
         dataVersion = 0;
         everyFunc = function(callbackObj:BindCallbackObj, i:uint, arr:Array):Boolean
         {
            if(callbackObj != null && callbackObj.callback == callback)
            {
               index = i;
               dataVersion = callbackObj.dataVersion;
               return false;
            }
            return true;
         };
         callbacks.every(everyFunc);
         if(index > -1 && index < callbacks.length)
         {
            callbacks.splice(index,1);
         }
         return dataVersion;
      }
      
      public function unload() : void
      {
      }
      
      public function request(dataID:*, params:* = null, callback:Function = null) : void
      {
         var callbackObj:BindCallbackObj = null;
         if(callback != null)
         {
            if(this.isRequested(dataID,callback))
            {
               callbackObj = this.getCallbackObj(dataID,callback,this._requestCallbacks);
               callbackObj.params = params;
            }
            else
            {
               if(!this._requestCallbacks.hasOwnProperty(dataID))
               {
                  this._requestCallbacks[dataID] = [];
               }
               callbackObj = new BindCallbackObj();
               callbackObj.callback = callback;
               callbackObj.fromController = true;
               callbackObj.params = params;
               this._requestCallbacks[dataID].push(callbackObj);
            }
         }
         if(this._serviceCallbacks[dataID] != null)
         {
            if(params != null)
            {
               this._serviceCallbacks[dataID](params);
            }
            else
            {
               this._serviceCallbacks[dataID]();
            }
         }
      }
      
      public function register(dataID:*, callback:Function) : void
      {
         if(!this._serviceCallbacks.hasOwnProperty(dataID) && callback != null)
         {
            this._serviceCallbacks[dataID] = callback;
         }
      }
      
      public function addDP(dataID:*, callback:Function) : void
      {
         if(!this._dataProviderCallbacks.hasOwnProperty(dataID) && callback != null)
         {
            this._dataProviderCallbacks[dataID] = callback;
         }
      }
      
      public function removeDP(dataID:*, callback:Function) : void
      {
         if(this._dataProviderCallbacks[dataID] == callback)
         {
            this._dataProviderCallbacks[dataID] = null;
            delete this._dataProviderCallbacks[dataID];
         }
      }
      
      public function getDP(dataID:*, params:Array = null) : *
      {
         var len:uint = 0;
         var callback:Function = this._dataProviderCallbacks[dataID];
         if(callback == null)
         {
            return null;
         }
         len = params != null ? params.length : 0;
         switch(len)
         {
            case 0:
               return callback();
            case 1:
               return callback(params[0]);
            case 2:
               return callback(params[0],params[1]);
            case 3:
               return callback(params[0],params[1],params[2]);
            case 4:
               return callback(params[0],params[1],params[2],params[3]);
            case 5:
               return callback(params[0],params[1],params[2],params[3],params[4]);
            default:
               throw new Error("DataManager:::getDP Too many parameters with dataID: " + dataID,", params:" + params);
         }
      }
      
      public function setBindData(dataID:*, data:Object) : void
      {
         if(!this._database.hasOwnProperty(dataID))
         {
            this._database[dataID] = new ResultObj();
         }
         ++this._database[dataID].dataVersion;
         this._database[dataID].data = data;
         this._database[dataID].result = ResultObj.RESULT_SUCCESS;
         if(this._currentDataID != dataID)
         {
            this.dispatchToBoundCallbacks(dataID,false);
         }
      }
      
      public function setData(resObj:ResultObj) : void
      {
         var dataID:* = resObj.id;
         this._currentDataID = dataID;
         if(!this._database.hasOwnProperty(dataID))
         {
            this._database[dataID] = new ResultObj();
         }
         ++this._database[dataID].dataVersion;
         this._database[dataID].data = resObj.data;
         this._database[dataID].resultMsg = resObj.resultMsg;
         this._database[dataID].result = resObj.result;
         this._database[dataID].params = resObj.params;
         this.dispatchToRequestedCallbacks(dataID);
         this.dispatchToBoundCallbacks(dataID,true);
         this._currentDataID = null;
      }
      
      private function isBound(dataID:*, callback:Function) : Boolean
      {
         return this.getCallbackObj(dataID,callback,this._bindCallbacks) != null;
      }
      
      private function isRequested(dataID:*, callback:Function) : Boolean
      {
         return this.getCallbackObj(dataID,callback,this._requestCallbacks) != null;
      }
      
      private function getCallbackObj(dataID:*, callback:Function, callbacksDict:Dictionary) : BindCallbackObj
      {
         var callbackObj:BindCallbackObj = null;
         var callbacks:Array = callbacksDict[dataID];
         if(!callbacks || callbacks.length < 1)
         {
            return null;
         }
         for each(callbackObj in callbacks)
         {
            if(callbackObj != null && callbackObj.callback == callback)
            {
               return callbackObj;
            }
         }
         return null;
      }
      
      private function dispatch(dataID:*, callbackObj:BindCallbackObj) : void
      {
         var dataObj:ResultObj = null;
         if(!this._database.hasOwnProperty(dataID) || this._database[dataID] == null || callbackObj == null)
         {
            return;
         }
         if(callbackObj.callback != null)
         {
            dataObj = this._database[dataID];
            if(dataObj.dataVersion > callbackObj.dataVersion)
            {
               if(callbackObj.params != null)
               {
                  dataObj.params = callbackObj.params;
               }
               callbackObj.dataVersion = dataObj.dataVersion;
               callbackObj.callback(dataObj);
            }
         }
      }
      
      private function dispatchToRequestedCallbacks(dataID:*) : void
      {
         if(!this._database.hasOwnProperty(dataID) || this._database[dataID] == null)
         {
            return;
         }
         if(!this._requestCallbacks.hasOwnProperty(dataID) || this._requestCallbacks[dataID].length <= 0)
         {
            return;
         }
         var callbacks:Array = this._requestCallbacks[dataID].concat();
         this._requestCallbacks[dataID] = null;
         delete this._requestCallbacks[dataID];
         for(var i:int = 0; i < callbacks.length; i++)
         {
            callbacks[i].callback(this._database[dataID]);
         }
      }
      
      private function dispatchToBoundCallbacks(dataID:*, toController:Boolean) : void
      {
         var i:int = 0;
         if(this._bindCallbacks.hasOwnProperty(dataID) && this._bindCallbacks[dataID].length > 0)
         {
            this._bindCallbacks[dataID].sortOn("fromController",Array.DESCENDING);
            for(i = 0; i < this._bindCallbacks[dataID].length; i++)
            {
               if(!(Boolean(this._bindCallbacks[dataID][i].fromController) && !toController))
               {
                  this.dispatch(dataID,this._bindCallbacks[dataID][i]);
               }
            }
         }
      }
   }
}

