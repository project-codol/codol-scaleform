package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataCommonID;
   import codo.constants.ServiceID;
   import codo.constants.UIStencils;
   import codo.event.ParaEvent;
   import codo.objects.UIStencilPageStencilStatusObj;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class UIStencilService extends ServiceBase
   {
      
      private static var _instance:UIStencilService;
      
      private var mAllStencilsViewedByPageID:Dictionary;
      
      public function UIStencilService()
      {
         super(ServiceID.UISTENCILS);
         this.mAllStencilsViewedByPageID = new Dictionary();
      }
      
      public static function getInstance() : UIStencilService
      {
         if(UIStencilService._instance == null)
         {
            UIStencilService._instance = new UIStencilService();
         }
         return UIStencilService._instance;
      }
      
      public function checkIsNotified(id:int) : Boolean
      {
         return CFunctionCommonContainer.AS_GetStencilFlag(id) as Boolean;
      }
      
      public function get resolution() : Point
      {
         var res:Array = this.getDP(DataCommonID.CURRENT_RESOLUTION);
         return new Point(res[0],res[1]);
      }
      
      public function isUserOptedOutOfUIStencils() : Boolean
      {
         return UIStencilService.getInstance().checkIsNotified(UIStencils.UI_STENCIL_USER_OPT_OUT);
      }
      
      public function setStencilViewed(e:ParaEvent) : void
      {
         var stencilNotification:int = e.myPara as int;
         CFunctionCommonContainer.AS_SetStencilFlag(stencilNotification);
      }
      
      public function setAllPageStencilsViewed(statusData:UIStencilPageStencilStatusObj) : void
      {
         this.mAllStencilsViewedByPageID[statusData.pageID] = statusData.allViewed;
      }
      
      public function pageHasNonViewedStencils(pageID:String, stencilNotifications:Vector.<int>) : Boolean
      {
         var notification:int = 0;
         var id:String = null;
         for each(notification in stencilNotifications)
         {
            if(!this.checkIsNotified(notification))
            {
               return true;
            }
         }
         for(id in this.mAllStencilsViewedByPageID)
         {
            if(this.mAllStencilsViewedByPageID[id] == pageID && this.mAllStencilsViewedByPageID[id] == true)
            {
               return true;
            }
         }
         return false;
      }
   }
}

