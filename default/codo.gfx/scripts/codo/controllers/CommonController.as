package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataID;
   import codo.objects.TimeObj;
   import codo.services.CommonService;
   
   public class CommonController extends BaseController
   {
      
      public function CommonController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.IS_DEV_BUILD,this.isDevBuild);
         this.addDP(DataID.IS_SHIP_BUILD,this.isShipBuild);
         this.addDP(DataID.IS_CP_COUNT_ENABLED,this.isCpCountEnabled);
         this.addDP(DataID.IS_CP_RECHARGE_ENABLED,this.isCpRechargeEnabled);
         this.addDP(DataID.IS_WHITELIST_TESTER,this.isWhitelistTester);
         this.addDP(DataID.IS_ESPORT_SPECTATOR,this.isESportSpectator);
         this.addDP(DataID.GET_FORMAT_TIME_BY_TIMESTAMP,this.getFormatTimeByTimeStamp);
         this.addDP(DataID.GET_SERVER_TIME_STAMP,this.getServerTimeStamp);
      }
      
      private function isDevBuild() : Boolean
      {
         return CommonService.getInstance().isDevBuild();
      }
      
      private function isShipBuild() : Boolean
      {
         return CommonService.getInstance().isShipBuild();
      }
      
      private function isCpCountEnabled() : Boolean
      {
         var cpCounterLock:Boolean = this.getDvarBool("ui_lockCPCounter");
         return !cpCounterLock;
      }
      
      private function isCpRechargeEnabled() : Boolean
      {
         var cpRechargeLock:Boolean = this.getDvarBool("ui_lockCPCharger");
         return !cpRechargeLock;
      }
      
      private function isWhitelistTester() : Boolean
      {
         return CFunctionCommonContainer.AS_IsWhitelistTester() as Boolean;
      }
      
      private function isESportSpectator() : Boolean
      {
         return CFunctionCommonContainer.AS_IsESportSpectator() as Boolean;
      }
      
      private function getFormatTimeByTimeStamp(timeStamp:int) : TimeObj
      {
         return CFunctionCommonContainer.GetFormatTimeByTimeStamp(timeStamp);
      }
      
      private function getServerTimeStamp() : int
      {
         return CFunctionCommonContainer.GetServerTimeStamp();
      }
   }
}

