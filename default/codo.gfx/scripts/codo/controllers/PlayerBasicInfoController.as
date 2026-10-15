package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.utils.PlayerBasicInfoQueryUtil;
   
   public class PlayerBasicInfoController extends BaseController
   {
      
      private var _receivers:Vector.<PlayerBasicInfoQueryUtil>;
      
      public function PlayerBasicInfoController()
      {
         super();
         this._receivers = new Vector.<PlayerBasicInfoQueryUtil>();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCEvent.EVT_QUERY_PLAYER_BASIC_INFO,this.onQueryPlayerBasicInfo);
         this.listen(BCEvent.REGISTER_PLAYER_BASIC_INFO_CALLBACK,this.onRegisterPlayerBasicInfoCallback);
         this.listen(BCEvent.UNREGISTER_PLAYER_BASIC_INFO_CALLBACK,this.onUnregisterPlayerBasicInfoCallback);
         this.listen(BCEvent.UPDATE_PARTIAL_BASIC_INFO,this.onUpdatePartialBasicInfo);
      }
      
      private function onQueryPlayerBasicInfo(cEvt:ParaEvent) : void
      {
         CFunctionContainer.AS_QueryPlayerBasicInfo(cEvt.myPara);
      }
      
      public function registerPlayerBasicInfoReceiver(receiver:PlayerBasicInfoQueryUtil) : void
      {
         for(var i:uint = 0; i < this._receivers.length; i++)
         {
            if(this._receivers[i] == receiver)
            {
               return;
            }
         }
         this._receivers.push(receiver);
      }
      
      public function unregisterPlayerBasicInfoReceiver(receiver:PlayerBasicInfoQueryUtil) : void
      {
         for(var i:uint = 0; i < this._receivers.length; i++)
         {
            if(this._receivers[i] == receiver)
            {
               this._receivers.splice(i,1);
               return;
            }
         }
      }
      
      private function onRegisterPlayerBasicInfoCallback(e:ParaEvent) : void
      {
         this.registerPlayerBasicInfoReceiver(e.myPara);
      }
      
      private function onUnregisterPlayerBasicInfoCallback(e:ParaEvent) : void
      {
         this.unregisterPlayerBasicInfoReceiver(e.myPara);
      }
      
      private function onUpdatePartialBasicInfo(e:ParaEvent) : void
      {
         CFunctionContainer.AS_UpdatePartialBasicInfo(e.myPara);
      }
      
      public function cppOnIncomingPlayerBasicInfoArray(playerBasicInfoArray:Array) : void
      {
         var receiver:PlayerBasicInfoQueryUtil = null;
         for(var i:uint = 0; i < this._receivers.length; i++)
         {
            receiver = this._receivers[i];
            receiver.onIncomingPlayerBasicInfoArray(playerBasicInfoArray);
         }
      }
      
      public function cppOnBatchQueryEnd() : void
      {
         var receiver:PlayerBasicInfoQueryUtil = null;
         var tempReceiver:Vector.<PlayerBasicInfoQueryUtil> = this._receivers.concat();
         for(var i:uint = 0; i < tempReceiver.length; i++)
         {
            receiver = tempReceiver[i];
            receiver.onBatchQueryEnd();
         }
      }
   }
}

