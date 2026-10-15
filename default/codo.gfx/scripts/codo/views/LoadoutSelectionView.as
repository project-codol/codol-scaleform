package codo.views
{
   import codo.component.BackButton;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.constants.table.UINotifications;
   import codo.cpp.UiCppItemListView;
   import codo.event.ParaEvent;
   import codo.services.TutorialService;
   
   public class LoadoutSelectionView extends MarketplaceBaseView
   {
      
      public var myBackButton:BackButton;
      
      private var mDoOnboardTourClickCardStep:Boolean = false;
      
      public function LoadoutSelectionView()
      {
         super();
      }
      
      override public function setShowingTutorial(showing:Boolean) : void
      {
         super.setShowingTutorial(showing);
         if(mInOnboardTourMode)
         {
            if(!this.mDoOnboardTourClickCardStep)
            {
               myFilter.addOnSubCategoryUncheckedCallback(this.onOnboardFilterClicked);
               this.mDoOnboardTourClickCardStep = true;
            }
         }
      }
      
      private function onOnboardFilterClicked() : void
      {
         broadcast(BCEvent.EVT_NEXT_TUTORIAL_STEP,_pageID);
         myFilter.clearOnSubCategoryUncheckedCallback();
      }
      
      private function hasPrimaryWpns(categories:Array) : Boolean
      {
         if(categories != null && categories.length > 0)
         {
            return categories[0].id == MarketMenuData.SLOT_PRIMARY;
         }
         return false;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.myBackButton.registerClickEvent(this.onBackButtonClicked);
         this.myBackButton.visible = true;
         this.initMarketContent(data.categories);
         var enableWpnTip:Boolean = this.hasPrimaryWpns(data.categories);
         TutorialService.getInstance().enableToolTip(UINotifications.ONBOARD_HELP_SELECT_WEAPON,enableWpnTip);
      }
      
      override protected function showView() : void
      {
         super.showView();
         listen(BCEvent.EVT_EQUIPPED,this.onLoadoutEquip);
         this.myBackButton.show();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unlisten(BCEvent.EVT_EQUIPPED,this.onLoadoutEquip);
         this.myBackButton.hide();
      }
      
      protected function onLoadoutEquip(evt:ParaEvent) : void
      {
         this.onBackButtonClicked();
      }
      
      private function onBackButtonClicked() : void
      {
         broadcast(BCEvent.GOTO_PREV_PAGE);
      }
      
      protected function initMarketContent(filterData:Array) : void
      {
         myFrame.visible = myMarketplaceControls.visible = myItemCount.visible = myFilter.visible = myScrollGrid.visible = true;
         myStatGraph.visible = mShowModel;
         EventManager.broadcast(BCEvent.EVT_MARKET_SET_COMPARE_ITEM,null);
         UiCppItemListView(_uiCpp).SetInitData(filterData,true);
      }
   }
}

