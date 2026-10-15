package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.manager.PageManagerMain;
   import codo.objects.CodoPageLayerObj;
   import codo.objects.CodoPageObj;
   import codo.views.UITutorialBaseView;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class StageKeyController extends BaseController
   {
      
      private var _toggleGlobalKeyCatch:Boolean = true;
      
      public function StageKeyController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCEvent.EVT_TOGGLE_GLOBAL_KEY_CATCH,this.onToggleGlobalKeyCatchHandle);
      }
      
      public function processKeyDown(cEvt:KeyboardEvent) : void
      {
         var isSystemMsgShowing:Boolean = false;
         var shouldBroadcast:Boolean = false;
         var currAdvPopup:CodoPageObj = null;
         var bPurchConfirm:Boolean = false;
         var bPlayerDetail:Boolean = false;
         var tutorialView:UITutorialBaseView = null;
         var highestPageLayerObj:CodoPageLayerObj = null;
         if(this._toggleGlobalKeyCatch)
         {
            switch(cEvt.keyCode)
            {
               case Keyboard.ESCAPE:
                  if(Boolean(CFunctionCommonContainer.Dvar_GetBool("ui_tutorial_escape")))
                  {
                     if(CodoPageViewDB.PAGE_LAYER_MAIN.currentPageObj != null && CodoPageViewDB.PAGE_LAYER_MAIN.currentPageObj.tutorialView != null)
                     {
                        tutorialView = CodoPageViewDB.PAGE_LAYER_MAIN.currentPageObj.tutorialView.instance as UITutorialBaseView;
                        if(tutorialView != null && !tutorialView.videoTourOpened)
                        {
                           tutorialView.hideAllTours();
                        }
                     }
                  }
                  isSystemMsgShowing = this.getDP(DataID.IS_SYSTEM_MSG_SHOWING);
                  shouldBroadcast = true;
                  currAdvPopup = CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj;
                  bPurchConfirm = currAdvPopup == CodoPageViewDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART;
                  bPlayerDetail = currAdvPopup == CodoPageViewDB.PAGE_PLAYER_DETAIL_INFO;
                  if(!isSystemMsgShowing && !bPlayerDetail)
                  {
                     if(bPurchConfirm)
                     {
                        shouldBroadcast = false;
                     }
                     highestPageLayerObj = PageManagerMain.getInstance().getHighestActivePageLayer();
                     if(Boolean(highestPageLayerObj.currentPageObj) && highestPageLayerObj.currentPageObj.enableCloseByESC)
                     {
                        prevPage();
                     }
                  }
                  if(shouldBroadcast)
                  {
                     this.broadcast(BCEvent.EVT_PRESS_ESC_CLOSE_WINDOW);
                  }
            }
         }
      }
      
      private function onToggleGlobalKeyCatchHandle(cEvt:ParaEvent) : void
      {
         this._toggleGlobalKeyCatch = cEvt.myPara;
      }
   }
}

