package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.utils.ScaleformUtil;
   import flash.net.SharedObject;
   
   public class SharedObjectController extends BaseController
   {
      
      private static const CODO_SO_NAME:String = "codo_so";
      
      private var _bInit:Boolean = false;
      
      private var _codoSO:SharedObject;
      
      private var _currentAsyncID:uint = 0;
      
      public function SharedObjectController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCEvent.EVT_PLAYER_STATS_READY,this.onTestSO);
      }
      
      public function initSO(cConfigName:String) : void
      {
         if(this._bInit == false)
         {
            this._bInit = true;
            if(ScaleformUtil.isScaleform == true)
            {
               this._codoSO = SharedObject.getLocal(CODO_SO_NAME + cConfigName,"");
            }
            else
            {
               this._codoSO = SharedObject.getLocal(CODO_SO_NAME + cConfigName);
            }
         }
      }
      
      private function get soInstance() : SharedObject
      {
         if(this._codoSO == null)
         {
            if(ScaleformUtil.isScaleform == true)
            {
               this.initSO(CFunctionCommonContainer.Dvar_GetString("dw_username"));
            }
            else
            {
               this.initSO("local_flash_test");
            }
         }
         return this._codoSO;
      }
      
      public function saveToSO(cDataID:String, cValue:Object) : void
      {
      }
      
      public function loadFromSO(cDataID:String) : *
      {
         return null;
      }
      
      private function onTestSO(cEvt:ParaEvent) : void
      {
         if(ScaleformUtil.isTempContentEnabled() == true)
         {
         }
      }
      
      public function dumpBindingData(asyncID:uint) : void
      {
         this._currentAsyncID = asyncID;
         this.bind(asyncID,this.bindData_Dump);
         this._currentAsyncID = 0;
         this.unbind(asyncID,this.bindData_Dump);
      }
      
      private function bindData_Dump(cResult:Object) : void
      {
      }
   }
}

