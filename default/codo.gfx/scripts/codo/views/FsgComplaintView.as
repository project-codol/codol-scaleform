package codo.views
{
   import codo.constants.DataID;
   import codo.constants.DataInGameID;
   import codo.objects.UserObj;
   import components.fsgpopups_part.FsgComplaintViewContent;
   import fsg.shared.popups.PopupBaseView;
   
   public class FsgComplaintView extends PopupBaseView
   {
      
      private var mComplaintContent:FsgComplaintViewContent;
      
      public function FsgComplaintView()
      {
         super();
         this.mComplaintContent = myContent as FsgComplaintViewContent;
      }
      
      override public function set routeData(data:*) : void
      {
         var userList:Array;
         var mode:String;
         var preSelection:UserObj = null;
         try
         {
            preSelection = data.preSelection;
         }
         catch(e:TypeError)
         {
            preSelection = new UserObj(data.preSelection);
         }
         userList = data.userList;
         mode = data.mode;
         this.mComplaintContent.useSinglePlayerName = getDP(DataID.IS_MAINMENU_COMPLAINT_CONTROLLER);
         this.mComplaintContent.setData(preSelection,userList,mode);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.mComplaintContent.enableData();
      }
      
      override protected function disableData() : void
      {
         this.mComplaintContent.disableData();
         super.disableData();
      }
      
      override protected function showView() : void
      {
         super.showView();
         setBindData(DataInGameID.IS_COMPLAINT_WINDOW_OPEN,true);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.mComplaintContent.storeDataIfNeeded();
         setBindData(DataInGameID.IS_COMPLAINT_WINDOW_OPEN,false);
      }
   }
}

