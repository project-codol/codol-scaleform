package codo.base
{
   import codo.constants.BCEvent;
   import codo.interfaces.IDataManager;
   import codo.interfaces.IEventManager;
   import codo.objects.BindDataHelper;
   import codo.objects.SystemMsgObj;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.SoundUtil;
   import shaui.component.core.InteractiveComponent;
   
   public class BaseSubElement extends InteractiveComponent
   {
      
      public static var DataManager:IDataManager;
      
      public static var EventManager:IEventManager;
      
      public function BaseSubElement()
      {
         super();
      }
      
      public function active() : void
      {
         this.visible = true;
      }
      
      public function deactive() : void
      {
         this.visible = false;
      }
      
      protected function broadcast(cType:String, cData:* = null) : void
      {
         if(EventManager != null)
         {
            EventManager.broadcast(cType,cData);
         }
      }
      
      protected function playSound(vo_alias:String) : void
      {
         SoundUtil.getInstance().playSound(vo_alias);
      }
      
      protected function listen(cEvtType:String, cCallback:Function) : void
      {
         if(EventManager != null)
         {
            EventManager.listen(cEvtType,cCallback);
         }
      }
      
      protected function unlisten(cEvtType:String, cCallback:Function) : void
      {
         if(EventManager != null)
         {
            EventManager.unlisten(cEvtType,cCallback);
         }
      }
      
      protected function createBindHelper(cDataID:*, cCallback:Function, cParams:* = null, cImmediateCall:Boolean = true, initialDataVersion:uint = 0) : BindDataHelper
      {
         return new BindDataHelper(cDataID,cCallback,cParams,cImmediateCall,true,false,initialDataVersion);
      }
      
      protected function bind(cDataID:*, cCallback:Function, cParams:Object = null, cImmediateCall:Boolean = true) : void
      {
         if(DataManager != null)
         {
            DataManager.bind(cDataID,cCallback,cParams,cImmediateCall,true,false);
         }
      }
      
      protected function unbind(cDataID:*, cCallback:Function) : void
      {
         if(DataManager != null)
         {
            DataManager.unbind(cDataID,cCallback);
         }
      }
      
      protected function setBindData(cDataID:*, cValue:Object) : void
      {
         if(DataManager != null)
         {
            DataManager.setBindData(cDataID,cValue);
         }
      }
      
      protected function addDP(cDataID:*, cProvider:Function) : void
      {
         if(DataManager != null)
         {
            DataManager.addDP(cDataID,cProvider);
         }
      }
      
      protected function getDP(cDataID:*, cParams:Array = null) : *
      {
         if(DataManager != null)
         {
            return DataManager.getDP(cDataID,cParams);
         }
         return null;
      }
      
      protected function removeDP(cDataID:*, cProvider:Function) : void
      {
         if(DataManager != null)
         {
            DataManager.removeDP(cDataID,cProvider);
         }
      }
      
      protected function showRightClickMenu(cRightClickMenuType:String, cParams:Array = null, cPos:Object = null) : void
      {
         this.broadcast(BCEvent.EVT_SHOW_RIGHT_CLICK_MENU,{
            "type":cRightClickMenuType,
            "params":cParams,
            "pos":cPos
         });
      }
      
      protected function showMsg(cMsg:String, cBtnCount:int = 0, cPriority:int = 0, cCallback0:Function = null, cLabel0:String = "", cCallback1:Function = null, cLabel1:String = "", cCallback2:Function = null, cLabel2:String = "", cDelay:Number = 0) : void
      {
         Logger.print("BaseSubElement:::showMsg this/msg: " + this + "/" + cMsg);
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,SystemMsgObj.getObj(cMsg,cBtnCount,cPriority,cCallback0,cLabel0,cCallback1,cLabel1,cCallback2,cLabel2,0,cDelay));
      }
      
      protected function hideMsg(cTime:Number = 0, cCallback:Function = null) : void
      {
         Logger.print("BaseSubElement:::hideMsg this: " + this);
         this.broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{
            "delayTime":cTime,
            "callback":cCallback,
            "triggerType":0,
            "priority":0
         });
      }
      
      final protected function get isDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
   }
}

