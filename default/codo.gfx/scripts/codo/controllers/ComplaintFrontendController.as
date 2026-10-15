package codo.controllers
{
   import codo.constants.CodoPageViewDB;
   import codo.constants.DataID;
   import codo.constants.PageID;
   
   public class ComplaintFrontendController extends ComplaintController
   {
      
      public function ComplaintFrontendController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         addDP(DataID.IS_MAINMENU_COMPLAINT_CONTROLLER,this.isMainMenuComplaintController);
      }
      
      override protected function showComplaintWindow(data:Object) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_COMPLAINT_WINDOW,data);
      }
      
      override protected function hideComplaintWindow() : void
      {
         closePopupPage(PageID.FSG_COMPLAINTWINDOW);
      }
      
      private function isMainMenuComplaintController() : Boolean
      {
         return true;
      }
   }
}

