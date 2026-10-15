package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.WebImgData;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.objects.RecommendationObject;
   import codo.views.MOTDNotificationsPopup;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DatamoreController extends BaseController
   {
      
      private const INTERVAL_CHECK_DELAY:int = 100;
      
      private var m_bIsFirstPageReady:Boolean;
      
      private var m_intervalCheckTimer:Timer;
      
      private var m_currentPopupID:int;
      
      private var m_bIsMarketDataReady:Boolean;
      
      private var m_pendingPopups:Array;
      
      public function DatamoreController()
      {
         super();
         this.m_intervalCheckTimer = new Timer(this.INTERVAL_CHECK_DELAY);
         this.m_intervalCheckTimer.addEventListener(TimerEvent.TIMER,this.intervalCheckTicked);
         this.m_currentPopupID = -1;
         this.m_bIsMarketDataReady = false;
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         listen(BCEvent.GOTO_FIRST_PAGE,this.onEnterFirstPage);
         listen(BCEvent.EVT_DATAMORE_REPORT_POPUP,this.onPopupReport);
         listen(BCEvent.EVT_DATAMORE_OPEN_WEB_PAGE,this.onOpenWebPage);
         listen(BCEvent.GOTO_FIRST_PAGE,this.onEnterFirstPage);
         bind(DataID.DATA_RECEIVE,this.checkIfMarketReady);
         bind(DataID.MARKETPLACE_MAINTAIN_STATE,this.checkIfMarketReady);
         this.m_pendingPopups = CFunctionContainer.AS_DatamoreInitPendingPopups();
      }
      
      public function cppShowRecommendationPopup(obj:Object) : void
      {
         if(this.isReadyToPop() && this.messageCanPop(obj))
         {
            this.internalShowPopup(obj);
         }
         else
         {
            this.m_pendingPopups.push(obj);
         }
      }
      
      public function cppRefreshMOTDWelfarePage() : void
      {
         broadcast(BCEvent.EVT_MOTD_REFRESH_CATEGORY_DATA,1 << codo.views.MOTDNotificationsPopup.CATEGORY_INDEX_WELFARE);
      }
      
      private function onEnterFirstPage(cEvt:ParaEvent = null) : void
      {
         this.m_bIsFirstPageReady = true;
         this.m_intervalCheckTimer.start();
      }
      
      private function onPopupReport(cEvt:ParaEvent = null) : void
      {
         var taskID:int = cEvt.myPara;
         CFunctionContainer.AS_DatamoreReportPopup(taskID);
         if(taskID == this.m_currentPopupID)
         {
            this.m_currentPopupID = -1;
            this.m_intervalCheckTimer.start();
         }
      }
      
      private function onOpenWebPage(cEvt:ParaEvent = null) : void
      {
         var url:String = cEvt.myPara;
         var ret:Object = CFunctionCommonContainer.OpenWebPageCustom(url,WebImgData.POPUP_AD.x,WebImgData.POPUP_AD.y,WebImgData.POPUP_AD.width,WebImgData.POPUP_AD.height) as Object;
         if(Boolean(ret.succeed))
         {
            this.broadcast(BCEvent.EVT_SHOW_WEBIMG_CONTAINER,{
               "data":WebImgData.POPUP_AD,
               "hideTitle":ret.hideTitle
            });
         }
      }
      
      private function intervalCheckTicked(cEvt:TimerEvent) : void
      {
         var i:int = 0;
         if(this.m_pendingPopups.length > 0 && this.isReadyToPop())
         {
            for(i = 0; i < this.m_pendingPopups.length; i++)
            {
               if(this.messageCanPop(this.m_pendingPopups[i]))
               {
                  this.internalShowPopup(this.m_pendingPopups[i]);
                  this.m_pendingPopups.splice(i,1);
                  break;
               }
            }
         }
      }
      
      private function isReadyToPop() : Boolean
      {
         return this.m_currentPopupID < 0 && this.m_bIsFirstPageReady && !this.getDP(DataID.HAS_POPUP) && !CFunctionCommonContainer.IsInRoom() && !this.getDP(DataID.IS_WEBIMG_OPEN);
      }
      
      private function messageCanPop(obj:Object) : Boolean
      {
         switch(obj.type)
         {
            case RecommendationObject.MARKET:
               return this.m_bIsMarketDataReady && CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_INVENTORY_MARKET) == null;
            case RecommendationObject.SUPPLY_DROP:
               return this.m_bIsMarketDataReady && CFunctionCommonContainer.SupplyDropsEnabled() && CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_SUPPLY_DROPS) == null;
            case RecommendationObject.WELFARE:
            case RecommendationObject.REWARD:
            case RecommendationObject.GAMEMODE:
            case RecommendationObject.RAW_WEB:
         }
         return true;
      }
      
      private function internalShowPopup(obj:Object) : void
      {
         if(obj.type == RecommendationObject.RAW_WEB)
         {
            broadcast(BCEvent.EVT_DATAMORE_OPEN_WEB_PAGE,obj.buttondata);
            broadcast(BCEvent.EVT_DATAMORE_REPORT_POPUP,obj.taskid);
         }
         else
         {
            this.m_currentPopupID = obj.taskid;
            showRecommendationPopupMsg(obj);
            this.m_intervalCheckTimer.stop();
         }
      }
      
      private function checkIfMarketReady(cRes:Object = null) : void
      {
         this.m_bIsMarketDataReady = getDP(DataID.IS_DATA_AVAILABLE);
      }
   }
}

